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

import {
  ResUtils,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSystemBarProperty,
  windowMgr
} from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import {
  DeviceHelper,
  ViewArea as ScreenRect,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { display } from '@kit.ArkUI';
import { StatusBarTint } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarTint';
import { SCBGeneralStatusBarController } from '../viewmodel/SCBGeneralStatusBarController';

const TAG: string = 'SCBVirtualStatusBar';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const CALL_MODULE = 'virtual_status_bar';
/**
 * 窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_STATUS_BAR;

@Component
export struct SCBGeneralStatusBar {
  @State viewController: SCBGeneralStatusBarController = new SCBGeneralStatusBarController();
  @Link screenProp: SCBScreenProperty;

  persistentId: number = 0;
  private screenId: number = 0;
  private isRegisterFoldStatusChange: boolean = false;
  private isRegisterBeforeScreenProperty: boolean = false;
  /**
   * 判断设备是否为折叠态（直板机状态为非折叠态）
   */
  @State isFolded: boolean = this.getFolded(display.getFoldStatus());

  aboutToAppear() {
    viewMgrPolicy.registerViewController(ViewType.VIRTUAL_STATUS_BAR, this.viewController);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();

    // 设置状态栏避让区高度
    this.refreshStatusBarRect(this.screenProp.width);

    // set Cast+ projection filter. The window will not show on virtual display.
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipEventAndShowOnVirtualScreen(true);
    }
    SCBSceneSessionManager.getInstance().
    registerSystemBarPropertyCallbacks(this.systemBarPropertyCallback, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.onScreenPropertyChangeCallback,
      this.screenProp.screenId, true, this.persistentId);


      // 折叠屏状态监听
      try {
        display.on('foldStatusChange', this.folderStatusChangeCallback);
        this.isRegisterFoldStatusChange = true;
      } catch (error) {
        log.showError(`register fold change listener failed: ${error?.code}`);
      }

    this.setAppOverrideStatusBarProperty();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    let systemSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    if (systemSceneSession) {
      systemSceneSession.setSkipEventAndShowOnVirtualScreen(false);
    }
    SCBSceneSessionManager.getInstance().
    unRegisterSystemBarPropertyCallbacks(this.systemBarPropertyCallback, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChangeCallback,
      this.screenProp.screenId, true, this.persistentId);
    if (this.isRegisterFoldStatusChange) {
      try {
        display.off('foldStatusChange', this.folderStatusChangeCallback);
        this.isRegisterFoldStatusChange = false;
      } catch (e) {
        log.showError(`unRegister fold change listener failed: ${e?.code}`);
      }
    }
    if (this.isRegisterBeforeScreenProperty) {
      SCBScreenSessionManager.getInstance().
      unRegisterBeforeScreenPropertyChangeCallbacks(this.beforeScreenPropertyChangeCallback, this.screenProp.screenId);
      this.isRegisterBeforeScreenProperty = false;
    }
  }

  private systemBarPropertyCallback = (property: SCBSystemBarProperty) => {
    log.showInfo(`systemBarPropertyCallback enable is ${property.enable}`);
    if (property.enable) {
      this.viewController.show();
    } else {
      this.viewController.hide();
    }
  }

  private onScreenPropertyChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screenId: ${screenProperty.screenId}`);
    try {
      this.getUIContext().runScopedTask(() => {
        this.refreshStatusBarRect(screenProperty.width, reason);
      });
    } catch (e) {
      log.error(`on screen property change error`, e);
    }
  }

  /**
   * 判断设备是否是折叠状态
   */
  private getFolded(foldStatus: display.FoldStatus): boolean {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      return true;
    }
    return false;
  }

  private folderStatusChangeCallback = (newFoldStatus: display.FoldStatus) => {
    this.isFolded = this.getFolded(newFoldStatus);
    this.setAppOverrideStatusBarProperty();
  };

  private beforeScreenPropertyChangeCallback: Callback<display.FoldStatus> = (foldStatus: display.FoldStatus): void => {
    this.folderStatusChangeCallbackForOuterHome(foldStatus);
  };

  private folderStatusChangeCallbackForOuterHome(foldStatus: display.FoldStatus): void {
    this.isFolded = foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED;
    this.setAppOverrideStatusBarProperty();
  };

  /**
   * 刷新状态栏高度相关数据
   * 否则 避障和显示高度分别计算
   */
  private refreshStatusBarRect(screenWidth: number, reason?: SCBPropertyChangeReason) {
    const tempAvoidHeight = this.getHeightByDevice(reason);
    log.showInfo(`refreshStatusBarRect Height: ${vp2px(tempAvoidHeight)} ${this.screenProp.screenId}`);
    sceneSessionManager.setStatusBarAvoidHeight(this.screenProp.screenId, vp2px(tempAvoidHeight));
    // 状态栏显示区域更新
    let area: ScreenRect = {
      left: 0,
      top: 0,
      width: px2vp(screenWidth),
      height: tempAvoidHeight,
    }
    this.viewController.updateArea(area);
    this.viewController.updateRect(area);
  }

  /**
   *
   */
  private setAppOverrideStatusBarProperty() {
    return;
    if (!this.isFolded) {
      SCBSceneSessionManager.getInstance().clearAppOverrideSystemBarProperty(this.screenProp.screenId, CALL_MODULE);
    } else {
      let defaultSystemBarProperty = new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
        false, StatusBarTint.CONTENT_COLOR_WHITE, StatusBarTint.CONTENT_COLOR_WHITE);
      SCBSceneSessionManager.getInstance().setAppOverrideSystemBarProperty(
        defaultSystemBarProperty, this.screenProp.screenId, CALL_MODULE);
    }
    SCBSceneSessionManager.getInstance().updateSystemBarProperty();
  }

  getHeightByDevice(source?: SCBPropertyChangeReason): number {
    // 应对折叠展开事件后于屏幕属性变化事件
    if (source === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      this.isFolded = false;
    } else if (source === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      this.isFolded = true;
    }
    return ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  }

  build() {
    Stack({ alignContent: Alignment.Top }) { // 状态栏高度会动态变化、下方内容会默认居中显示，会导致显示异常
    }
    .width(px2vp(this.screenProp.width))
    .height(this.getHeightByDevice())
    .opacity(0)
  }
}