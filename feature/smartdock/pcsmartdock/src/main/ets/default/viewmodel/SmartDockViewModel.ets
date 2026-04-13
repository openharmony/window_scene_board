/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  MenuInfo,
  DockItemInfo,
  CommonConstants,
  RecentBundleMissionInfo,
  GridLayoutItemInfo,
} from '@ohos/launchercommon';
import { PcSmartDockEventMgr } from '../manager/PcSmartDockEventMgr';
import { SmartDockStyleMgr } from '@ohos/smartdock/src/main/ets/default/manager/SmartDockStyleMgr';
import SmartDockViewModel from '@ohos/smartdock/src/main/ets/default/viewmodel/SmartDockViewModel';
import { PCDockUtils } from '../utils/PCDockUtils';
import { ArrowType } from '../common/constants/FixedDockConstants';
import { PcSmartDockModel } from '../model/PcSmartDockModel';
import { HiSysEventUtil, WindowEvent } from '@ohos/frameworkwrapper';

const TAG = 'PcSmartDockViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * PC SmartDock Viewmodel
 */
export default class PcSmartDockViewModel extends SmartDockViewModel {
  private static instance: PcSmartDockViewModel;
  private mSmartDockModel: PcSmartDockModel = PcSmartDockModel.getInstance();
  protected lastGettingSnapshotItem: DockItemInfo = new DockItemInfo();
  protected callBackSnapshotStatus: boolean = false;
  public extScreenWidth: number = 0;
  public extScreenHeight: number = 0;

  private constructor() {
    super();
    log.showInfo('registerDataChangeCallback');
  }

  public static getInstance(): PcSmartDockViewModel {
    if (!PcSmartDockViewModel.instance) {
      PcSmartDockViewModel.instance = new PcSmartDockViewModel();
    }
    return PcSmartDockViewModel.instance;
  }

  public initMgr(): void {
    this.mSmartDockModel = PcSmartDockModel.getInstance();
    this.mSmartDockStyleMgr = SmartDockStyleMgr.getInstance();
    this.mSmartDockEventMgr = PcSmartDockEventMgr.getInstance();
  }

  unregisterDataChangeCallback(): void {
    log.showInfo('unregisterDataChangeCallback');
  }

  /**
   * resident dock item onClick function
   * @param event
   * @param item
   * @param callback
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  public residentOnClick(event: ClickEvent, item: DockItemInfo, callback?: Function, startNewAbility: boolean = false,
    params?: Map<string, Object>): boolean {
    return this.mSmartDockEventMgr.residentOnClick(event, item, startNewAbility, callback, params);
  }

  public residentOnClickWithDisplay(screenId: number, event: ClickEvent | null, item: DockItemInfo,
    callback?: Function, startNewAbility: boolean = false, params?: Map<string, Object>): boolean {
    return this.mSmartDockEventMgr.residentOnClickWithDisplay(screenId, event, item, startNewAbility, callback, params);
  }

  /**
   * recent dock item onClick function
   * @param event
   * @param item
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  public recentOnClick(event: ClickEvent, item: DockItemInfo, callback?: Function,
    startNewAbility: boolean = false): boolean {
    return this.mSmartDockEventMgr.recentOnClick(event, item, startNewAbility, callback);
  }

  public getWpsUnreadMessageMenu(appInfo: DockItemInfo): MenuInfo {
    if (this.mSmartDockEventMgr instanceof PcSmartDockEventMgr) {
      return (this.mSmartDockEventMgr as PcSmartDockEventMgr).getWpsUnreadMessageMenu(appInfo);
    }
    return new MenuInfo();
  }

  public getWpsCloseMenu(appInfo: DockItemInfo, preExitCallback: Function): MenuInfo {
    if (this.mSmartDockEventMgr instanceof PcSmartDockEventMgr) {
      return (this.mSmartDockEventMgr as PcSmartDockEventMgr).getWpsCloseMenu(appInfo, preExitCallback);
    }
    return new MenuInfo();
  }

  /**
   * build menu for @Component CustomOverlay
   * @param appInfo
   * @param dockType
   * @param callback
   * @param screenId
   */
  buildMenuInfoList(appInfo: DockItemInfo, dockType: number, formDialog?: CustomDialogController | null,
    callback?: Function, screenId?: number): MenuInfo[] {
    return this.mSmartDockEventMgr.buildMenuInfoList(appInfo, dockType, formDialog, callback, screenId);
  }

  /**
   * what SmartDockContent.dockItemList onChange
   */
  onDockListChange(): void {
    this.mSmartDockStyleMgr.updateDockParams(CommonConstants.PC_DEVICE_TYPE).then(() => {
    }, () => {
    });
  }

  public getOpenNewWindowMenu(appInfo: DockItemInfo, screenId?: number): MenuInfo {
    if (this.mSmartDockEventMgr instanceof PcSmartDockEventMgr) {
      return (this.mSmartDockEventMgr as PcSmartDockEventMgr).getOpenNewWindowMenu(appInfo, screenId);
    }
    return new MenuInfo();
  }

  public getOpenMenu(appInfo: DockItemInfo, screenId?: number): MenuInfo {
    if (this.mSmartDockEventMgr instanceof PcSmartDockEventMgr) {
      return (this.mSmartDockEventMgr as PcSmartDockEventMgr).getOpenMenu(appInfo, screenId);
    }
    return new MenuInfo();
  }

  public getExitMenu(appInfo: DockItemInfo, screenId?: number): MenuInfo {
    if (this.mSmartDockEventMgr instanceof PcSmartDockEventMgr) {
      return (this.mSmartDockEventMgr as PcSmartDockEventMgr).getExitMenu(appInfo, screenId);
    }
    return new MenuInfo();
  }

  public getFormMenu(appInfo: DockItemInfo): MenuInfo {
    if (this.mSmartDockEventMgr instanceof PcSmartDockEventMgr) {
      return (this.mSmartDockEventMgr as PcSmartDockEventMgr).getFormMenu(appInfo);
    }
    return new MenuInfo();
  }

  /**
   * hover事件响应，更新应用的任务列表
   */
  async onHoverEvent(item: DockItemInfo, needRefreshList?: boolean): Promise<void> {
    // 桌面应用不做处理
    if (item.bundleName === CommonConstants.LAUNCHER_BUNDLE) {
      PCDockUtils.clearSnapshotList();
      return;
    }
    const gettingSnapshotStatus = AppStorage.get<boolean>('gettingSnapshotStatus');
    log.showInfo(`onHoverEvent lastGettingSnapshotBundleName:${this.lastGettingSnapshotItem?.bundleName},` +
      `bundleName:${item.bundleName}, gettingSnapshotStatus:${gettingSnapshotStatus}`);
    if (this.mSmartDockModel.isSameDockItem(item, this.lastGettingSnapshotItem) &&
      gettingSnapshotStatus === true) {
      this.callBackSnapshotStatus = true;
    } else {
      this.callBackSnapshotStatus = false;
    }
    if (!this.mSmartDockModel.isSameDockItem(item, this.lastGettingSnapshotItem)) {
      this.lastGettingSnapshotItem = item;
    }
    // 更新应用的任务列表
    log.showInfo(`onHoverEvent callBackSnapshotStatus:${this.callBackSnapshotStatus}`);
    if (this.callBackSnapshotStatus === false) {
      this.getRefreshSnapshot(item, needRefreshList);
    }
  }

  async getRefreshSnapshot(item: DockItemInfo, needRefreshList?: boolean): Promise<void> {
    try {
      const missionInfoList = AppStorage.get('missionInfoList') as Array<RecentBundleMissionInfo>;
      let list = missionInfoList.filter(it => this.mSmartDockModel.isSameDockItem(it, item));
      if (list.length <= 0) {
        PCDockUtils.clearSnapshotList();
        return;
      }

      if (needRefreshList) {
        PCDockUtils.clearSnapshotList();
      }

      log.showInfo(`getRefreshSnapshot getSnapShot happen,callBackSnapshotStatus ${this.callBackSnapshotStatus}`);
      await this.getSnapshot(list[0]);

      if (this.callBackSnapshotStatus === true) {
        this.onHoverEvent(item, needRefreshList);
      }
    } catch (reason) {
      log.showError(`missionInfoList error ${reason}`);
    }
  }

  recentOnClickWithPopup(item: DockItemInfo): void {
    this.onHoverEvent(item, true);
    log.showInfo(`recentOnClickWithPopup  happen`);
    AppStorage.setOrCreate('isClickOpenPopup', true);
  }

  onItemClick(event: ClickEvent, item: DockItemInfo): boolean {
    return this.residentOnClick(event, item, (): void => this.recentOnClickWithPopup(item));
  }

  onItemClickWithDisplay(event: ClickEvent | null, item: DockItemInfo, screenId: number): boolean {
    return this.residentOnClickWithDisplay(screenId, event, item, (): void => this.recentOnClickWithPopup(item));
  }

  public getIdPrefix(isResident: boolean): string {
    return isResident ? 'ResidentLayoutForPC' : 'RecentLayout';
  }

  public getArrowId(arrowType: ArrowType): string {
    return this.isLeftArrow(arrowType) ? 'leftArrowPath' : 'rightArrowPath';
  }

  public isLeftArrow(arrowType: ArrowType): boolean {
    return arrowType === ArrowType.RESIDENT_LEFT || arrowType === ArrowType.RECENT_LEFT;
  }

  public getDockArrowId(isResident: boolean, arrowType: ArrowType): string {
    const prefix: string = this.getIdPrefix(isResident);
    const arrowId: string = this.getArrowId(arrowType);
    return prefix + '_Image_' + arrowId;
  }
}