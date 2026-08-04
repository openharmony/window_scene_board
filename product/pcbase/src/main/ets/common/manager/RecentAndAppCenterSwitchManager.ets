/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  GlobalContext,
  viewMgrPolicy,
  ViewType,
} from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBScreenSessionArray, SCBScreenSessionManager } from '@ohos/windowscene';
import { AcDragStatusMgr } from '@ohos/appcenter/src/main/ets/default/controller/AcDragStatusMgr';

const TAG = 'RecentAndAppCenterSwitchManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class RecentAndAppCenterSwitchManager {

  private isRecentToAppCenter: boolean = false;
  private isAppCenterViewHiding: boolean = false;
  private static instance: RecentAndAppCenterSwitchManager;
  private oneFrameVisibles: Map<number, boolean> = new Map();

  public static getInstance(): RecentAndAppCenterSwitchManager {
    log.showDebug('getInstance');
    if (RecentAndAppCenterSwitchManager.instance === null || RecentAndAppCenterSwitchManager.instance === undefined) {
      RecentAndAppCenterSwitchManager.instance = new RecentAndAppCenterSwitchManager();
    }
    return RecentAndAppCenterSwitchManager.instance;
  }

  public recentIsShowing(): boolean {
    return AppStorage.get('showRecent') === true;
  }

  private hideAppCenter(screenId?: number, openAfterClose?: boolean): void {
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation(screenId, openAfterClose);
    } else {
      viewMgrPolicy.hideView(ViewType.APP_CENTER);
      viewMgrPolicy.hideView(ViewType.APP_CENTER_EXT);
    }
  }

  public setAppCenterViewHiding(isAppCenterViewHiding: boolean): void {
    this.isAppCenterViewHiding = isAppCenterViewHiding;
  }

  public getAppCenterViewHiding(): boolean {
    return this.isAppCenterViewHiding;
  }

  public getRecentToAppCenter(): boolean {
    return this.isRecentToAppCenter;
  }

  public setRecentToAppCenter(isRecentToAppCenter: boolean): void {
    this.isRecentToAppCenter = isRecentToAppCenter;
  }

  public appcenterIsShowing(screenId: number = 0): boolean {
    if (screenId !== 0) {
      log.showInfo(`extAppcenterIsShowing: ${viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT)}, ${this.isAppCenterViewHiding}`);
      return (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT)) && !this.isAppCenterViewHiding;
    }
    log.showInfo(`appcenterIsShowing: ${viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)}, ${this.isAppCenterViewHiding}`);
    return (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) && !this.isAppCenterViewHiding;
  }

  public getOneFrameVisible(screenId: number): boolean {
    return this.oneFrameVisibles.get(screenId) ?? false;
  }

  public setOneFrameVisible(screenId: number, oneFrameVisible: boolean): void {
    this.oneFrameVisibles.set(screenId, oneFrameVisible);
  }

  private setAllOneFrameVisible(oneFrameVisible: boolean): void {
    for (const screenId of this.oneFrameVisibles.keys()) {
      this.oneFrameVisibles.set(screenId, oneFrameVisible);
    }
  }

  public enterAppCenter(screenId: number = 0): void {
    if (this.isAppCenterViewHiding) {
      log.showInfo(`enterAppCenter isAppCenterViewHiding`);
      return;
    }
    if ((viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT)) &&
      !AppStorage.get<boolean>('isAppCenterShow')) {
      AppStorage.setOrCreate('isAppCenterShow', true);
    }
    // 应用中心显示或应用中心进入动效中，退出到桌面.一帧关闭任务中心，再做隐藏应用中心动效
    if (this.appcenterIsShowing(screenId) || this.isRecentToAppCenter) {
      if (this.isRecentToAppCenter) {
        this.setOneFrameVisible(screenId, true);
        this.isRecentToAppCenter = false;
      }
      AppStorage.setOrCreate('showRecent', false);
      this.hideAppCenter(screenId);
      return;
    }
    if (this.recentIsShowing()) {
      this.isRecentToAppCenter = true;
    }
    if (this.isMainScreen(screenId)) {
      if (this.isExtAppCenterViewShowing()) {
        this.openAfterHiding(screenId);
        return;
      }
      if (!AcDragStatusMgr.getInstance().isDraggingNow()) {
      viewMgrPolicy.showView(ViewType.APP_CENTER);
      } else {
        log.showInfo(`can't open main when app center in dragging`);
      }
    } else {
      if (this.isMainAppCenterViewShowing()) {
        this.openAfterHiding(screenId);
        return;
      }
      if (!AcDragStatusMgr.getInstance().isDraggingNow()) {
        viewMgrPolicy.showView(ViewType.APP_CENTER_EXT);
      } else {
        log.showInfo(`can't open ext when app center in dragging`);
      }
    }
  }

  public openAfterHiding(screenId: number): void {
    let screenSessionList: SCBScreenSessionArray = SCBScreenSessionManager.getInstance().getScreenSessionList();
    log.showInfo(`openAfterHiding screenId: ${screenId}`);
    screenSessionList.forEach((screen) => {
      if (screen.scbScreenProperty.screenId !== screenId) {
        let open = true;
        if (AcDragStatusMgr.getInstance().isDraggingNow()) {
          open = false;
        }
        this.hideAppCenter(screen.session.screenId, open);
      }
    });
  }

  public isMainAppCenterViewShowing(): boolean {
    return (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER));
  }

  public isExtAppCenterViewShowing(): boolean {
    if (viewMgrPolicy.getViewController(ViewType.APP_CENTER_EXT)) {
      return (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT));
    }
    return false;
  }

  public enterRecent(): void {
    log.showInfo(`enter recent: ${this.isRecentToAppCenter}, ${this.recentIsShowing()}`);
    // 任务中心显示中，退出到桌面
    if (!this.isRecentToAppCenter && this.recentIsShowing()) {
      this.setAllOneFrameVisible(false);
      AppStorage.setOrCreate('showRecent', false);
      return;
    }

    // 应用中心显示，一帧显示任务中心，再做隐藏应用中心动效
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) ||
    viewMgrPolicy.isViewShowing(ViewType.APP_CENTER_EXT) || this.isRecentToAppCenter) {
      this.isRecentToAppCenter = false;
      this.setAllOneFrameVisible(true);
      this.hideAppCenter();
      AppStorage.setOrCreate('showRecent', true);
      return;
    }

    AppStorage.setOrCreate('showRecent', true);
  }

  /**
   * 是否是主显示器
   *
   * @param screenId
   * @returns
   */
  public isMainScreen(screenId: number): boolean {
    return SCBSceneSessionManager.getInstance().mainScreenId === screenId;
  }
}