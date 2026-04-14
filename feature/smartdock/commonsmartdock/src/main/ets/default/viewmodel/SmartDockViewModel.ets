/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { GlobalContext, localEventManager, InstallStatusChangeEvent, DeviceHelper } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { AppGalleryEventInfo,
  AppItemInfo,
  BadgeItemInfo,
  CardItemInfo,
  DeleteDockItem,
  EventConstants,
  FormLayoutCacheManager, GridLayoutItemInfo, LaunchLayoutCacheManager,
  ReceiveEventInfo,
  ResidentLayoutCacheMgr } from '@ohos/launchercommon';
import { SCBSceneSessionManager, SCBSceneContainerSession, SCBSceneSession, SCBScreenProperty } from '@ohos/windowscene';
import { AppGalleryDownloadManager, AppInstallEventData } from '@ohos/launchercommon';
import { MenuInfo } from '@ohos/launchercommon';
import { DockItemInfo } from '@ohos/launchercommon';
import Prompt from '@ohos.promptAction';
import { CommonConstants } from '@ohos/launchercommon';
import { BaseViewModel } from '@ohos/launchercommon';
import SmartDockModel from '../model/SmartDockModel';
import SmartDockDragHandler from '../common/SmartDockDragHandler';
import type { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import { LayoutViewModel } from '@ohos/launchercommon';
import type { RecentBundleMissionInfo } from '@ohos/launchercommon';
import type { SnapshotInfo } from '@ohos/launchercommon';
import type ctx from '@ohos.app.ability.common';
import { AppStatus, DownloadStatusInfo } from '@ohos/launchercommon';
import type { SmartDockStyleInterface } from '../common/interfaces/SmartDockStyleInterface';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';
import type { SmartDockEventInterface } from '../common/interfaces/SmartDockEventInterface';
import { SmartDockEventMgr } from '../manager/SmartDockEventMgr';
import lazy { PcModeDockUtils } from '../utils/PcModeDockUtils';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { PageDesktopViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';
import { FormModel } from '@ohos/launchercommon';
const TAG = 'SmartDockViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * SmartDock Viewmodel
 */
export default class SmartDockViewModel extends BaseViewModel {
  public static singleName: string = 'SmartDockViewModel';
  protected mSmartDockStyleMgr: SmartDockStyleInterface = SmartDockStyleMgr.getInstance();
  protected mSmartDockEventMgr: SmartDockEventInterface = SmartDockEventMgr.getInstance();
  private waitingForInstallAni: boolean = false;
  protected lastGettingSnapshotItem: DockItemInfo | undefined;
  protected callBackSnapshotStatus: boolean = false;

  private readonly localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: DockItemInfo | AppInstallEventData | BadgeItemInfo): void => {
      log.showInfo(`localEventListener receive event: ${event}, params: ${JSON.stringify(params)}`);
      switch (event) {
        case EventConstants.EVENT_BADGE_UPDATE:
          this.updateBadgeNumber(params as BadgeItemInfo);
          break;
        case EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH:
          this.refreshDockItem(params as DockItemInfo);
          break;
        case EventConstants.APP_INSTALL_BMS_CHANGE_EVENT:
          this.appInstallBmsChangeEvent(params as AppInstallEventData);
          break;
        default:
          break;
      }
    }
  };

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.initMgr();
    localEventManager.registerEventListener(this.localEventListener, [
      EventConstants.EVENT_BADGE_UPDATE,
      EventConstants.APP_INSTALL_BMS_CHANGE_EVENT,
      EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_REFRESH
    ]);
    if (DeviceHelper.isPad()) {
    }
    log.showInfo('Launcher SmartDockViewModel constructor!');
  }

  initMgr(): void {
    this.mSmartDockStyleMgr = SmartDockStyleMgr.getInstance();
    this.mSmartDockEventMgr = SmartDockEventMgr.getInstance(this.singleContext);
  }

  private dataChangeCallbackFunc = (collaborationDataList: Array<DockItemInfo>): void => {
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      PcModeDockUtils.closeCollaborationWindow(collaborationDataList);
    }
    AppStorage.setOrCreate('collaborationDataList', collaborationDataList);
  };

  static getInstance(ctx?: SingleContext): SmartDockViewModel {
    return singleManager.get<SmartDockViewModel>(SmartDockViewModel, ctx);
  }

  private updateBadgeNumber(badgeInfo: BadgeItemInfo) : void {
    log.showInfo(`updateBadgeNumber, badgeInfo is ${JSON.stringify(badgeInfo)}`);
    if (!!badgeInfo && !!badgeInfo.bundleName && (!!badgeInfo.badgeNumber || badgeInfo.badgeNumber === 0)) {
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      log.showInfo(`updateBadgeNumber, the residentList is ${JSON.stringify(residentList)}`);
      if (CheckEmptyUtils.isEmptyArr(residentList)) {
        return;
      }
      for (let index = 0; index < residentList.length; index++) {
        let dockItemInfo : DockItemInfo = residentList[index];
        if (dockItemInfo.itemType === CommonConstants.TYPE_FOLDER) {
          this.refreshFolderBadgeNum(dockItemInfo, badgeInfo, residentList);
        }
      }
    }
  }

  uninstallAppResult(bundleName: string, resultData: ResultData, appIndex?: number): void {
    return;
  }

  private refreshDockItem(dockItem: DockItemInfo): void {
    log.showInfo('refreshDockItem dockItem bundleName:%{public}s, keyName:%{public}s,  appIndex:%{public}d', dockItem.bundleName, dockItem.keyName, dockItem.appIndex);
    SmartDockDragHandler.getInstance(this.singleContext).refreshDockItem(dockItem as DockItemInfo);
  }

  private appInstallBmsChangeEvent(eventData: AppInstallEventData): void {
    this.regroupDataAppListChange([], eventData.eventName, eventData.bundleName, eventData.appIndex);
  }


  regroupDataAppListChange(callbackList: [], event: string, bundleName: string, appIndex?: number): void {
    log.showInfo(`regroupDataAppListChange, ${event}, ${bundleName}, ${appIndex}`);
    if (!SmartDockModel.getInstance(this.singleContext).isBundleNameAppExistInDock(bundleName, appIndex)) {
      log.showInfo(`regroupDataAppListChange current app ${bundleName} is not exist in dock`);
      return;
    }
    if (event === EventConstants.EVENT_PACKAGE_ADDED || event === EventConstants.EVENT_PACKAGE_CHANGED) {
      let downloadStatus: DownloadStatusInfo | undefined = AppGalleryDownloadManager.getInstance().getDownDownloadTaskInfo(bundleName);
      if (downloadStatus && !appIndex) {
        this.registerInstalledAniFinishCallback(bundleName, appIndex ?? 0);
        AppGalleryDownloadManager.getInstance().deleteDownloadTaskInfo(bundleName);
        AppGalleryDownloadManager.getInstance().deleteDownloadProgressInfo(bundleName);
      } else {
        SmartDockModel.getInstance(this.singleContext).updateResidentDockItem(bundleName, appIndex).then(() => {
          if (DeviceHelper.isPC()) {
            localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_ITEM_CHANGE, bundleName);
          }
        });
      }
    } else if (!this.waitingForInstallAni) {
      if (this.checkIsNeedRemoveItem(event, bundleName, appIndex)) {
        return;
      }
      SmartDockModel.getInstance(this.singleContext).refreshDockResidentList();
    }
  }

  private checkIsNeedRemoveItem(event: string, bundleName: string, appIndex?: number): boolean {
    let item: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    if (CheckEmptyUtils.isEmptyArr(item)) {
      return false;
    }
    let updateItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    for (let i = 0; i < item.length; i++) {
      if (item[i].appIndex === appIndex) {
        updateItem = item[i];
        break;
      }
    }
    if (updateItem.appStatus === AppStatus.UPDATING && event === EventConstants.EVENT_PACKAGE_REMOVED) {
      return true;
    } else {
      return false;
    }
  }

  private registerInstalledAniFinishCallback(bundleName: string, appIndex: number): void {
    this.waitingForInstallAni = true;
    const installAniFinishEvent: string = `smartDockInstallAniFinish${bundleName}`;
    const eventHub: ctx.EventHub = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.eventHub;
    if (installAniFinishEvent) {
      eventHub.off(installAniFinishEvent);
      eventHub.on(installAniFinishEvent, async(): Promise<void> => {
        this.waitingForInstallAni = false;
        eventHub.off(installAniFinishEvent);
        // if installed bundleName in dock,then refresh dock
        SmartDockModel.getInstance(this.singleContext).updateResidentDockItem(bundleName, appIndex);
      });
      let appGalleryEventInfo: AppGalleryEventInfo = {
        bundleName: bundleName,
        eventType: InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
        status: AppStatus.INSTALLED as number,
      };
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}icon`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}name`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}smallFolder`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${appIndex}folder`, appGalleryEventInfo);
      log.showInfo(`registerInstalledAniFinishCallback for ${installAniFinishEvent}`);
      this.waitingForInstallAni = false;
      SmartDockModel.getInstance(this.singleContext).updateResidentDockItem(bundleName, appIndex);
    }
  }

  private refreshFolderBadgeNum(dockItemInfo: DockItemInfo, badgeInfo: BadgeItemInfo, residentList: DockItemInfo[]) : void {
    let badgeSum : number = 0;
    if (!dockItemInfo.layoutInfo) {
      log.showInfo('layoutInfo is empty!');
      return;
    }
    for (const folderItemLayoutInfoList of dockItemInfo.layoutInfo) {
      for (const gridLayoutItemInfo of folderItemLayoutInfoList) {
        if (SmartDockModel.getInstance(this.singleContext).checkSameDockItem(dockItemInfo, badgeInfo)) {
          gridLayoutItemInfo.badgeNumber = badgeInfo.badgeNumber;
          log.showInfo(`gridLayoutItemInfo.badgeNumber is ${gridLayoutItemInfo.badgeNumber}`);
        }
        if (gridLayoutItemInfo.typeId === CommonConstants.TYPE_APP) {
          badgeSum = badgeSum + (gridLayoutItemInfo.badgeNumber ?? 0);
          log.showInfo(`badgeSum is ${badgeSum}`);
        }
      }
    }
    dockItemInfo.badgeNumber = badgeSum;
    log.showInfo(`the residentList is ${JSON.stringify(residentList)}`);
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_badgeNum'), residentList);
  }

  /**
   * get SmartDockStyleConfig
   */
  getStyleConfig(): SmartDockStyleConfig {
    return this.mSmartDockStyleMgr.getStyleConfig();
  }

  /**
   * resident dock item onClick function
   * @param event
   * @param item
   * @param callback
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  residentOnClick(event: ClickEvent | null, item: DockItemInfo, callback?: Function, startNewAbility: boolean = false,
    params?: Map<string, Object>): boolean {
    return this.mSmartDockEventMgr.residentOnClick(event, item, startNewAbility, callback, params);
  }

  /**
   * recent dock item onClick function
   * @param event
   * @param item
   * @param startNewAbility whether start new ability
   * @return whether to open the missions hover window, true is open
   */
  public recentOnClick(event: ClickEvent, item: DockItemInfo, callback?: Function, startNewAbility: boolean = false):
    boolean {
    return this.mSmartDockEventMgr.recentOnClick(event, item, startNewAbility, callback);
  }

  /**
   * what SmartDockContent.dockItemList onChange
   */
  onDockListChange(): void {
    this.mSmartDockStyleMgr.updateDockParams(AppStorage.get('device') ?? CommonConstants.DEFAULT_DEVICE_TYPE).
      then(() => {}, () => {});
  }

  /**
   * build menu for @Component CustomOverlay
   * @param appInfo
   * @param dockType
   * @param callback
   */
  buildMenuInfoList(appInfo: DockItemInfo, dockType: number, formDialog?: CustomDialogController | null,
    callback?: Function): MenuInfo[] {
    return this.mSmartDockEventMgr.buildMenuInfoList(appInfo, dockType, formDialog, callback);
  }

  /**
   * 构建非安装状态应用长按菜单Map
   * @param bundleName 应用bundleName
   * @returns Map<AppStatus, MenuInfo[]>
   */
  public buildNotInstalledAppMenu(item: DockItemInfo, dialog: CustomDialogController): Map<AppStatus, MenuInfo[]> {
    return this.mSmartDockEventMgr.buildNotInstalledAppMenu(item, dialog);
  }

  deleteDockItem(dockItem: DeleteDockItem, dockType: number): void {
    this.mSmartDockEventMgr.deleteDockItem(dockItem, dockType);
  }

  getSelectedItem(): DockItemInfo | undefined {
    return this.mSmartDockEventMgr.getSelectedItem();
  }

  getSelectedDockType(): number {
    return this.mSmartDockEventMgr.getSelectedDockType();
  }



  /**
   * 初始化dock栏元素中心点x坐标
   * @param dockCenter 当前dock栏中心点
   */
  public initDockItemCenterArray(dockCenter: number): void {
    this.mSmartDockStyleMgr.initDockItemCenterArray(dockCenter);
  }

  /**
   * 获取含指定元素个数的dock栏中索引对应元素x坐标
   * @param length dock栏元素个数 index元素索引
   */
  public getDockItemCenter(length: number, index: number): number {
    return this.mSmartDockStyleMgr.getDockItemCenter(length, index);
  }

  /**
   * The application uninstallation result is displayed.
   *
   * @param resultCode: Application uninstallation result
   */
  informUninstallResult(resultCode: number, bundleName?: string): void {
    log.info('informUninstallResult resultCode:' + resultCode);
    if (resultCode === CommonConstants.UNINSTALL_FORBID) {
      try {
        Prompt.showToast({
          message: $r('app.string.disable_uninstall')
        });
      } catch (err) {
        log.error('[UNINSTALL_FORBID showToast] failed, error -> ', err);
      }
    } else if (resultCode === CommonConstants.UNINSTALL_SUCCESS) {
      try {
        Prompt.showToast({
          message: $r('app.string.uninstall_success')
        });
      } catch (err) {
        log.error('[UNINSTALL_SUCCESS showToast] failed, error -> ', err);
      }
    } else {
      try {
        Prompt.showToast({
          message: $r('app.string.uninstall_failed')
        });
      } catch (err) {
        log.error('[UNINSTALL other showToast] failed, error -> ', err);
      }
    }
  }

  /**
   * 初始化数据列表
   *
   * @param containerSessionList 会话列表
   */
  initRecentDataList(containerSessionList: SCBSceneContainerSession[], tag?: string): void {
    return this.mSmartDockEventMgr.initRecentDataList(containerSessionList, tag);
  }
  /**
   * 更新数据列表
   *
   * @param containerSessionList 全屏会话列表
   * @param floatSceneSessionList 悬浮窗会话列表
   */
  updateRecentDataList(containerSessionList: Array<SCBSceneContainerSession>,
    floatSceneSessionList: Array<SCBSceneSession>, screenProperty: SCBScreenProperty): void {
    this.mSmartDockEventMgr.updateRecentDataList(containerSessionList, floatSceneSessionList, screenProperty);
  }

  /**
   * get snapshot
   *
   * @param missionIds missionid list
   * @return snapshot list
   */
  async getSnapshot(missionInfos: RecentBundleMissionInfo): Promise<SnapshotInfo[]> {
    return this.mSmartDockEventMgr.getSnapshot(missionInfos);
  }

  public getOpenMenu(appInfo: AppItemInfo): MenuInfo {
    if (this.mSmartDockEventMgr instanceof SmartDockEventMgr) {
      return (this.mSmartDockEventMgr as SmartDockEventMgr).getOpenMenu(appInfo);
    }
    return new MenuInfo();
  }

  public getOpenNewWindowMenu(appInfo: DockItemInfo): MenuInfo {
    if (this.mSmartDockEventMgr instanceof SmartDockEventMgr) {
      return (this.mSmartDockEventMgr as SmartDockEventMgr).getOpenNewWindowMenu(appInfo);
    }
    return new MenuInfo();
  }

  public getExitMenu(appInfo: AppItemInfo): MenuInfo {
    if (this.mSmartDockEventMgr instanceof SmartDockEventMgr) {
      return (this.mSmartDockEventMgr as SmartDockEventMgr).getExitMenu(appInfo);
    }
    return new MenuInfo();
  }

  public createDockItemFromGridLayout(itemInfo: GridLayoutItemInfo): DockItemInfo {
    const dockItemInfo = new DockItemInfo();
    dockItemInfo.itemType =
      typeof itemInfo.itemType === 'number' ? itemInfo.itemType : Number.parseInt(itemInfo.itemType ?? '0');
    dockItemInfo.typeId = itemInfo.typeId;
    dockItemInfo.bundleName = itemInfo.bundleName;
    dockItemInfo.moduleName = itemInfo.moduleName;
    dockItemInfo.abilityName = itemInfo.abilityName;
    dockItemInfo.appIconId = itemInfo.appIconId;
    dockItemInfo.appLabelId = itemInfo.appLabelId;
    dockItemInfo.applicationLabelId = itemInfo.applicationLabelId;
    dockItemInfo.appName = itemInfo.appName ?? '';
    dockItemInfo.areaType = itemInfo.areaType;
    dockItemInfo.keyName = itemInfo.keyName;
    dockItemInfo.layoutInfo = itemInfo.layoutInfo;
    dockItemInfo.row = itemInfo.row;
    dockItemInfo.column = itemInfo.column;
    dockItemInfo.badgeNumber = itemInfo.badgeNumber;
    dockItemInfo.isSystemApp = itemInfo.isSystemApp;
    dockItemInfo.applicationIconId = itemInfo.applicationIconId;
    return dockItemInfo;
  }

  public getArrowId(arrowType: ArrowType): string {
    return this.isLeftArrow(arrowType) ? 'leftArrowPath' : 'rightArrowPath';
  }

  public isLeftArrow(arrowType: ArrowType): boolean {
    return arrowType === ArrowType.RESIDENT_LEFT || arrowType === ArrowType.RECENT_LEFT;
  }

  public getIdPrefix(isResident: boolean): string {
    return isResident ? 'ResidentLayoutForPC' : 'RecentLayout';
  }

  public getDockArrowId(isResident: boolean, arrowType: ArrowType): string {
    const prefix: string = this.getIdPrefix(isResident);
    const arrowId: string = this.getArrowId(arrowType);
    return prefix + '_Image_' + arrowId;
  }

  recentOnClickWithPopup(item: DockItemInfo): void {
    this.onHoverEvent(item, false);
    log.showInfo(`recentOnClickWithPopup happen`);
    AppStorage.setOrCreate('isClickOpenPopup', true);
  }

  pcModeOnItemClick(event: ClickEvent | null, item: DockItemInfo): boolean {
    return this.residentOnClick(event, item, () => this.recentOnClickWithPopup(item));
  }

  /**
   * hover事件响应，更新应用的任务列表
   */
  async onHoverEvent(item: DockItemInfo, needRefreshList?: boolean): Promise<void> {
    // 桌面应用不做处理
    if (item.bundleName === CommonConstants.LAUNCHER_BUNDLE) {
      PcModeDockUtils.clearSnapshotList();
      return;
    }
    const gettingSnapshotStatus = AppStorage.get<boolean>('gettingSnapshotStatus');
    log.showInfo(`onHoverEvent lastGettingSnapshotBundleName: ${this.lastGettingSnapshotItem?.bundleName}, ` +
      `bundleName: ${item.bundleName}, gettingSnapshotStatus: ${gettingSnapshotStatus}`);
    if (SmartDockModel.getInstance(this.singleContext).isSameDockItem(item, this.lastGettingSnapshotItem) &&
      gettingSnapshotStatus === true) {
      this.callBackSnapshotStatus = true;
    } else {
      this.callBackSnapshotStatus = false;
    }
    if (!SmartDockModel.getInstance(this.singleContext).isSameDockItem(item, this.lastGettingSnapshotItem)) {
      this.lastGettingSnapshotItem = item;
    }
    // 更新应用的任务列表
    log.showInfo(`onHoverEvent callBackSnapshotStatus: ${this.callBackSnapshotStatus}`);
    if (this.callBackSnapshotStatus === false) {
      this.getRefreshSnapshot(item, needRefreshList);
    }
  }

  async getRefreshSnapshot(item: DockItemInfo, needRefreshList?: boolean): Promise<void> {
    try {
      const missionInfoList = AppStorage.get('missionInfoList') as Array<RecentBundleMissionInfo>;
      const list = missionInfoList.filter(it => {
        const itPersistentId = it?.persistentId || '';
        const itemPersistentId = item?.persistentId || '';
        return itPersistentId === itemPersistentId &&
          SmartDockModel.getInstance(this.singleContext).checkSameDockItem(it, item);
      });
      if (list.length <= 0) {
        log.showInfo(`missionInfoList null`);
        PcModeDockUtils.clearSnapshotList();
        return;
      }

      if (needRefreshList) {
        PcModeDockUtils.clearSnapshotList();
      }

      log.showInfo(`getRefreshSnapshot getSnapShot happen, callBackSnapshotStatus: ${this.callBackSnapshotStatus}`);
      await this.getSnapshot(list[0]);

      if (this.callBackSnapshotStatus === true) {
        this.onHoverEvent(item, needRefreshList);
      }
    } catch (reason) {
      log.showError(`missionInfoList error ${reason}`);
    }
  }

}

enum ArrowType {
  RESIDENT_LEFT = 0,
  RESIDENT_RIGHT = 1,
  RECENT_LEFT = 2,
  RECENT_RIGHT = 3
}

export class ResultData {
  code: number = -1;
  errorCode: number = -1;
}