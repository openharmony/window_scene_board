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
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import BundleManager from '@ohos.bundle.bundleManager';
import {
  RecentBundleMissionInfo,
  DockItemInfo,
  EventConstants,
  SnapshotInfo,
  AppModel,
  AppItemInfo,
  ResidentLayoutCacheMgr,
  CommonConstants,
  GridLayoutItemInfo
} from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { commonBundleManager, DeviceHelper, HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper';
import { ItemUtils } from '@ohos/componenthelper';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import { bundleManager } from '@kit.AbilityKit';
import { SCBSceneContainerSession, SCBSceneInfo, SCBSceneSession, SCBSceneSessionManager } from '@ohos/windowscene';
import { CollaborationLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/dock/cache/CollaborationLayoutCacheMgr';

const TAG = 'PcModeDockUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PcModeDock-' + TAG);

export class PcModeDockUtils {
  private static readonly DEFAULT_ENABLE_ANIMATION: string = 'true';

  /**
   * 更新dock popup窗口是否显示状态位
   *   dock popup的显隐在应用侧的hover回调中实现了延时处理，对于多个元素的popups状态可能存在错乱的情况，此方法用来精确更新当前是否存在popup窗口
   * @param isPopupVisible 当前popup是否显示
   * @param isItemOnHover hover的是否为当前元素
   * @param isItemOnHoverEmpty 当前hover的元素
   */
  public static updateDockMissionsPopupShow(
    isPopupVisible: boolean, isItemOnHover: boolean, onHoverItem: DockItemInfo | null): void {
    log.showDebug(`isPopupVisible is ${isPopupVisible}, isItemOnHover is ${isItemOnHover}`);
    if (isPopupVisible && isItemOnHover) {
      // 正常hover场景
      log.showDebug(`set isDockMissionsPopupShow true`);
      AppStorage.setOrCreate('isDockMissionsPopupShow', true);
    } else if (!isPopupVisible) {
      let isItemOnHoverEmpty: boolean = CheckEmptyUtils.isEmpty(onHoverItem);
      // 正常hover移出的场景，onHoverItem为空则代表当前没有元素响应hover
      log.showDebug(`set isDockMissionsPopupShow false`);
      AppStorage.setOrCreate('isDockMissionsPopupShow', false);
      PcModeDockUtils.callHideDock();
      // 在图标间移动的场景isItemOnHoverEmpty不为null，此时不做处理
    }
  }

  public static clearSnapshotList(): void {
    const snapshotListTmp: SnapshotInfo[] | undefined = AppStorage.get('snapshotList');
    snapshotListTmp?.forEach(item => {
      if (!CheckEmptyUtils.isEmpty(item) && item.image) {
        item.image.release();
      }
    });
    AppStorage.setOrCreate('snapshotList', []);
  }

  public static callHideDock(): void {
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK);
    log.showInfo('callHideDock');
  }

  public static isEnableDesktopFeatureAnimation(): boolean {
    try {
      return systemParameterEnhance.getSync('const.pcsceneboard.enable_desktop_feature_animation',
        PcModeDockUtils.DEFAULT_ENABLE_ANIMATION) === PcModeDockUtils.DEFAULT_ENABLE_ANIMATION;
    } catch (e) {
      log.showError('Get enable desktop feature animation state failed');
      return true;
    }
  }

  /**
   * whether the device version is 2D version
   *
   * @return true 2D version
   */
  public static is2D(): boolean {
    if (DeviceHelper.isPC() && DeviceHelper.isEmulator()) {
      return true;
    }
    if (!PcModeDockUtils.isEnableDesktopFeatureAnimation()) {
      return true;
    }
    return false;
  }

  public static getPadDockAnimationWithArrowRect(appItem: AppItemInfo): RectInfo {
    let iconRect: RectInfo = ItemUtils.getRectById(AppModel.getInstance().getAppIconContainerId(
      'SmartDock_AppIcon', appItem.bundleName, appItem.abilityName, appItem.appIndex));
    const isResidentItem: boolean = PcModeDockUtils.checkIsResidentItem(appItem);
    if (isResidentItem) {
      return iconRect;
    }
    const collaborationItems = CollaborationLayoutCacheMgr.getInstance().getAllDockItems();
    if (collaborationItems?.some(item =>
    item?.bundleName === appItem.bundleName && item?.abilityName === appItem.abilityName)) {
      return iconRect;
    }
    let recentBgRect: RectInfo = ItemUtils.getRectById(SmartDockConstants.PC_MODE_DOCK_RECENT_BG_ID);
    log.showInfo(`getPadDockAnimationWithArrowRect iconRect left: ${iconRect.left}, right: ${iconRect.right} ` +
      `recentBgRect left: ${recentBgRect.left}, right: ${recentBgRect.right}`);
    // dock中图标太多被隐藏时，获取箭头的位置。图标从未显示时，大小为0，默认向右箭头收缩。
    if (PcModeDockUtils.checkRectEmpty(iconRect) || iconRect.right > recentBgRect.right) {
      return ItemUtils.getRectById('RecentLayout_Image_rightArrowPath');
    } else if (iconRect.left < recentBgRect.left) {
      return ItemUtils.getRectById('RecentLayout_Image_leftArrowPath');
    } else {
      return iconRect;
    }
  }

  public static checkIsResidentItem(appItem: AppItemInfo): boolean {
    let isResidentItem: boolean = false;
    let resistDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    resistDockItems.find((item: DockItemInfo) => {
      if (item?.bundleName === appItem.bundleName &&
        item?.abilityName === appItem.abilityName &&
        item?.appIndex === appItem.appIndex) {
        isResidentItem = true;
        return true;
      }
      return false;
    });
    let recentItems: DockItemInfo[] = AppStorage.get('recentList') as DockItemInfo[];
    recentItems.find((item: DockItemInfo) => {
      if (item?.bundleName === appItem.bundleName &&
        item?.abilityName === appItem.abilityName &&
        item?.appIndex === appItem.appIndex) {
        isResidentItem = false;
        return true;
      }
      return false;
    });
    log.showInfo(`checkIsResidentItem, isResidentItem: ${isResidentItem}`);
    return isResidentItem;
  }

  public static checkRectEmpty(itemRect: RectInfo): boolean {
    let result: boolean = false;
    if (CheckEmptyUtils.isEmpty(itemRect)) {
      result = true;
    }
    if (itemRect.left === 0 && itemRect.right === 0 && itemRect.top === 0 && itemRect.bottom === 0) {
      result = true;
    }
    log.showInfo(`checkRectEmpty, result: ${result}`);
    return result;
  }

  public static isInResidentFolder(residentList: DockItemInfo[], bundleName: string): boolean {
    for (const item of residentList) {
      const folderItemLength: number | undefined = item?.layoutInfo?.flat().length;
      let folderItemList: GridLayoutItemInfo[] = [];
      if (folderItemLength && folderItemLength > 0) {
        item?.layoutInfo?.flat().forEach((folderItem: GridLayoutItemInfo) => {
          folderItemList.push(folderItem);
        });
      }
      const index = folderItemList?.findIndex((folderItem) => {
        return folderItem.bundleName === bundleName && (folderItem.appIndex ?? 0) === 0;
      });
      if (index >= 0) {
        return true;
      }
    }
    return false;
  }

  public static isInDockList(appList: DockItemInfo[], bundleName: string): boolean {
    let index = -1;
    if (!CheckEmptyUtils.isEmptyArr(appList)) {
      index = appList.findIndex((item) => item.bundleName === bundleName && (item.appIndex ?? 0) === 0);
    }
    return index >= 0;
  }

  public static isInstanceWindowExist(bundleName: string, appIndex: number): boolean {
    const missionInfoList: RecentBundleMissionInfo[] | undefined = AppStorage.get('missionInfoList');
    const missionInfo = missionInfoList?.find((missionInfo: RecentBundleMissionInfo) => {
      return missionInfo.bundleName === bundleName && missionInfo.appIndex === appIndex;
    });
    return !CheckEmptyUtils.isEmpty(missionInfo) && (missionInfo?.missionInfoList.length ?? 0) >= 1;
  }

  public static async getRecentAppInfo(sceneInfo: SCBSceneInfo | undefined, snapshotInfo: SnapshotInfo):
    Promise<SnapshotInfo> {
    if (CheckEmptyUtils.isEmpty(sceneInfo)) {
      log.showError('sceneInfo is empty.');
      return snapshotInfo;
    }
    sceneInfo = sceneInfo as SCBSceneInfo;
    let appInfoFromCache = AppModel.getInstance()
      .getAppInfoByBundleNameAndAbility(sceneInfo.bundleName, sceneInfo.abilityName);
    if (appInfoFromCache) {
      PcModeDockUtils.getAppInfoFromCache(appInfoFromCache, snapshotInfo);
      return snapshotInfo;
    }
    await commonBundleManager.getAbilityInfoByAbilityName(sceneInfo.bundleName,
      sceneInfo.abilityName).then((appInfoFromBms) => {
      if (!CheckEmptyUtils.isEmpty(appInfoFromBms)) {
        PcModeDockUtils.getAppInfoFromBms(appInfoFromBms as bundleManager.AbilityInfo, snapshotInfo);
      }
      return snapshotInfo;
    });
    return snapshotInfo;
  }

  private static getAppInfoFromCache(appInfoFromCache: AppItemInfo, snapshotInfo: SnapshotInfo): void {
    snapshotInfo.name = appInfoFromCache.appName as string;
    let cacheAppLabelId = appInfoFromCache.appLabelId as number;
    if (cacheAppLabelId === 0) {
      cacheAppLabelId = appInfoFromCache.applicationLabelId as number;
    }
    snapshotInfo.appLabelId = cacheAppLabelId;
    log.showInfo(`(${snapshotInfo.name}) from cache LabelId = ${snapshotInfo.appLabelId}`);
    return;
  }

  private static getAppInfoFromBms(appInfoFromBms: bundleManager.AbilityInfo, snapshotInfo: SnapshotInfo): void {
    snapshotInfo.name = appInfoFromBms.name as string;
    let bmsAppLabelId = appInfoFromBms.labelId as number;
    if (bmsAppLabelId === 0) {
      bmsAppLabelId = appInfoFromBms.applicationInfo.labelId as number;
    }
    snapshotInfo.appLabelId = bmsAppLabelId;
    log.showInfo(`(${snapshotInfo.name}) from bms, LabelId = ${snapshotInfo.appLabelId}`);
  }

  public static isSupportOpenMultiWindow(launchType: BundleManager.LaunchType, appInfo: DockItemInfo): boolean {
    return launchType === BundleManager.LaunchType.MULTITON || appInfo.enableNewAppInstance ||
      appInfo.bundleName === CommonConstants.FILE_MANAGER_BUNDLE ||
      (!DeviceHelper.isUltraScreenProduct() && appInfo.bundleName === CommonConstants.BROWSER_BUNDLE) ||
      (DeviceHelper.isPad() && appInfo.bundleName === CommonConstants.PHONE_FILE_MANAGER_BUNDLE);
  }

  private static close(sceneSession: SCBSceneSession):void {
    if (!sceneSession) {
      return;
    }
    const missionId: number = sceneSession.session?.persistentId;
    SCBSceneSessionManager.getInstance().asyncPrepareTerminate(missionId, (err, isPrepareTerminate) => {
      if (isPrepareTerminate) {
        log.showInfo('deleteRecentSession isPrepareTerminate');
        return;
      }
      try {
        SCBSceneSessionManager.getInstance().close(sceneSession.sceneInfo?.screenId, missionId);
      } catch (error) {
        log.showError(`close error= ${error}`);
        return;
      }
    });
  }

  private static closeSceneSession(appInfo: DockItemInfo): void {
    const containerList: SCBSceneContainerSession[] = SCBSceneSessionManager.getInstance().getContainerSessionList();
    containerList?.forEach((item) => {
      if (appInfo.bundleName === item.primarySession?.sceneInfo.bundleName &&
        appInfo.appIndex === item.primarySession?.sceneInfo.appIndex) {
        PcModeDockUtils.close(item.primarySession);
      }
      if (appInfo.bundleName === item.secondarySession?.sceneInfo.bundleName &&
        appInfo.appIndex === item.secondarySession?.sceneInfo.appIndex) {
        PcModeDockUtils.close(item.secondarySession);
      }
    });
  }

  public static closeCollaborationWindow(collaborationDataList: DockItemInfo[]): void {
    let oldCollaborationDataList: DockItemInfo[] | undefined = AppStorage.get('collaborationDataList');
    if (!oldCollaborationDataList || CheckEmptyUtils.isEmptyArr(oldCollaborationDataList)) {
      return;
    }
    oldCollaborationDataList.forEach(item => {
      const index: number = collaborationDataList.findIndex((dockItem: RecentBundleMissionInfo) => {
        return (item?.bundleName === dockItem?.bundleName);
      });
      if (index < 0) {
        HiSysEventUtil.reportShowCollaborationIcon(item?.bundleName ?? '', 0);
        PcModeDockUtils.closeSceneSession(item);
      }
    });
  }
}
