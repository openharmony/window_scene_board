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
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { CheckEmptyUtils, LogDomain, LogHelper, ObjUtil } from '@ohos/basicutils';
import { commonBundleManager, DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  AppModel,
  CommonConstants,
  DockItemInfo,
  SnapshotInfo,
  EventConstants,
  DockContinuableInfo} from '@ohos/launchercommon';
import { SCBSceneInfo } from '@ohos/windowscene';
import { bundleManager } from '@kit.AbilityKit';
import { PcDockPopupMgr } from '../manager/PcDockPopupMgr';
import { bundleResourceManager } from '@kit.AbilityKit';
import PcSmartDockViewModel from '../viewmodel/SmartDockViewModel';

const TAG = 'PCDockUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

const SPLIT_STR = '_';
const DLP_INDEX_START = 1001;

export class PCDockUtils {
  private static readonly DEFAULT_ENABLE_ANIMATION: string = 'true';

  /**
   * 更新pc dock popup窗口是否显示状态位
   *   pc dock popup的显隐在应用侧的hover回调中实现了延时处理，对于多个元素的popups状态可能存在错乱的情况，此方法用来精确更新当前是否存在popup窗口
   * @param isPopupVisible 当前popup是否显示
   * @param isItemOnHover hover的是否为当前元素
   * @param isItemOnHoverEmpty 当前hover的元素
   */
  public static updateDockMissionsPopupShow(
    isPopupVisible: boolean, isItemOnHover: boolean, onHoverItem: DockItemInfo | null, screenId: number): void {
    log.showDebug(`isPopupVisible is ${isPopupVisible}, isItemOnHover is ${isItemOnHover} screenId:${screenId}`);
    if (isPopupVisible && isItemOnHover) {
      // 正常hover场景
      log.showDebug(`set isDockPopupShow true`);
      PcDockPopupMgr.getInstance().setIsDockPopupShow(screenId, true);
    } else if (!isPopupVisible) {
      // 正常hover移出的场景，onHoverItem为空则代表当前没有元素响应hover
      log.showDebug(`set isDockPopupShow false`);
      PcDockPopupMgr.getInstance().setIsDockPopupShow(screenId, false);
      PCDockUtils.callHideDock(screenId);
      // 在图标间移动的场景isItemOnHoverEmpty不为null，此时不做处理
    }
  }

  /**
   * 获取AppItem布局组件Column的id
   * @param item 图标
   * @returns id
   */
  public static getAppItemColumnId(item: DockItemInfo, isResident: boolean = true): string {
    const baseField: string = PcSmartDockViewModel.getInstance().getIdPrefix(isResident) ;
    const field = 'AppIcon'
    if (item?.abilityName === CommonConstants.APPCENTER_ABILITY) {
      return `${baseField}_${field}_com.ohos.sceneboard1`;
    }
    if (item?.abilityName === CommonConstants.RECENT_ABILITY) {
      return `${baseField}_${field}_com.ohos.sceneboard2`;
    }
    return PCDockUtils.buildStandardId(item, `${baseField}_${field}_`);
  }

  private static buildStandardId(item: DockItemInfo, field: string = 'ResidentLayoutForPC_AppItem_'): string {
    let res: string = field + item?.bundleName + SPLIT_STR + item?.appIndex + SPLIT_STR +
      item?.shortcutId ?? '';
    if (item?.appIndex !== undefined && item?.appIndex > 0) {
      res = res + SPLIT_STR + item?.appIndex;
    }
    if (item?.shortcutId !== undefined) {
      res = res + SPLIT_STR + item?.shortcutId;
    }
    if (item?.persistentId !== undefined) {
      res = res + SPLIT_STR + item?.persistentId;
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(item?.appInstanceKey)) {
      res = res + '_' + item?.appInstanceKey;
    }
    return res;
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
    if (!PCDockUtils.isEnableDesktopFeatureAnimation()) {
      return true;
    }
    return false;
  }

  public static isEnableDesktopFeatureAnimation(): boolean {
    try {
      return systemParameterEnhance.getSync('const.pcsceneboard.enable_desktop_feature_animation',
        PCDockUtils.DEFAULT_ENABLE_ANIMATION) === PCDockUtils.DEFAULT_ENABLE_ANIMATION;
    } catch (e) {
      log.showError('Get enable desktop feature animation state failed');
      return true;
    }
  }

  public static clearSnapshotList(): void {
    log.showInfo('clearSnapshotList');
    const snapshotListTmp: SnapshotInfo[] | undefined = AppStorage.get('snapshotList');
    snapshotListTmp?.forEach(item => {
      if (item && item.image) {
        item.image.release();
      }
    });
    AppStorage.setOrCreate('snapshotList', []);
  }

  public static callHideDock(screenId: number): void {
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK, screenId);
    log.showInfo('callHideDock');
  }

  public static getDockAppCount(residentList: DockItemInfo[]): number[] {
    let shortcutNumber: number = 0;
    let appNumber: number = 0;
    residentList?.forEach(item => {
      if (item && item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        shortcutNumber++;
        return;
      }
      appNumber++;
    });
    return [appNumber, shortcutNumber];
  }

  public static async getRecentAppInfo(sceneInfo: SCBSceneInfo | undefined,
    snapshotInfo: SnapshotInfo): Promise<SnapshotInfo> {
    if (CheckEmptyUtils.isEmpty(sceneInfo)) {
      log.showError('sceneInfo is empty.');
      return snapshotInfo;
    }
    sceneInfo = sceneInfo as SCBSceneInfo;
    let appInfoFromCache = AppModel.getInstance()
      .getAppInfoByBundleNameAndAbility(sceneInfo.bundleName, sceneInfo.abilityName);
    if (appInfoFromCache) {
      PCDockUtils.getAppInfoFromCache(appInfoFromCache, snapshotInfo);
      return snapshotInfo;
    }
    await commonBundleManager.getAbilityInfoByAbilityName(sceneInfo.bundleName,
      sceneInfo.abilityName).then((appInfoFromBms) => {
      if (!CheckEmptyUtils.isEmpty(appInfoFromBms)) {
        PCDockUtils.getAppInfoFromBms(appInfoFromBms as bundleManager.AbilityInfo, snapshotInfo);
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

  /**
   * dlpIndex范围：从1001开始
   *
   * @return true dlp
   */
  public static isDlpIndex(appIndex: number): boolean {
    return (appIndex >= DLP_INDEX_START);
  }

  public static isContinuableItemExists(deviceInfo: DockContinuableInfo): boolean {
    return ObjUtil.isValid(deviceInfo) && ObjUtil.isValid(deviceInfo.bundleName) &&
    ObjUtil.isValid(deviceInfo.sourceDeviceName);
  }

  public static isPcFileManager(bundleName: string): boolean {
    return ((!DeviceHelper.is2In1DevicePcType() && bundleName === CommonConstants.FILE_MANAGER_BUNDLE) ||
      (DeviceHelper.is2In1DevicePcType() && bundleName === CommonConstants.PHONE_FILE_MANAGER_BUNDLE));
  }

  public static isFileManager(bundleName: string): boolean {
    return (bundleName === CommonConstants.FILE_MANAGER_BUNDLE ||
      bundleName === CommonConstants.PHONE_FILE_MANAGER_BUNDLE);
  }

  /**
   * 校验两个包是否归属同一个dock图标
   * @param bundleName
   * @param otherBundleName
   * @returns
   */
  public static isSameBundle(bundleName: string | undefined, otherBundleName: string | undefined): boolean {
    if (bundleName === undefined || otherBundleName === undefined) {
      return false;
    }
    if (bundleName === otherBundleName) {
      return true;
    }
    // QXS上 壳应用和文管服务应用属于合并显示在一个图标上
    if (DeviceHelper.is2In1DevicePcType() && (bundleName === CommonConstants.FILE_MANAGER_BUNDLE ||
      bundleName === CommonConstants.PHONE_FILE_MANAGER_BUNDLE)) {
      return otherBundleName === CommonConstants.FILE_MANAGER_BUNDLE ||
        otherBundleName === CommonConstants.PHONE_FILE_MANAGER_BUNDLE;
    }
    return false;
  }

  /**
   * QXS校验文管的壳应用是否存在
   * @returns
   */
  public static isFilesBundleExist(): boolean {
    // 非qxs设备，少做一次包校验
    if (!DeviceHelper.is2In1DevicePcType()) {
      return false;
    }
    try {
      let bundleInfo: bundleResourceManager.BundleResourceInfo = bundleResourceManager
        .getBundleResourceInfo(CommonConstants.PHONE_FILE_MANAGER_BUNDLE);
      return bundleInfo?.appIndex >= 0;
    } catch (err) {
      log.showInfo(`com.ohos.files is uninstall, bundleService err: [${err?.code}]-[${err?.message}]`)
      return false;
    }
  }
}
