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

import type ctx from '@ohos.app.ability.common';
import systemparameter from '@ohos.systemparameter';
import {
  CheckEmptyUtils,
  CommonUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { GlobalContext, DownloadStatusChangeEvent, HiSysEventUtil } from '@ohos/frameworkwrapper';
import {
  AppItemInfo,
  AppReserveType,
  AppStatus,
  DeliverUtil,
  DockItemInfo,
  EventConstants,
  FolderAppItemInfo,
  FolderDataModelManager,
  FolderLayoutCacheManager,
  FolderManager,
  FolderModel,
  FolderViewModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  launcherAbilityManager,
  LaunchLayoutCacheManager,
  LayoutViewModel,
  LegacyInfo,
  RdbStoreManager,
  ResidentLayoutCacheMgr
} from '../TsIndex';
import { AppGalleryEventInfo, CommonConstants } from '../constants/CommonConstants';
import { LightIconInNotHarmonyFolderBean } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { preferences } from '@kit.ArkData';
import { NumberConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { AppFoundationServiceExtensionManager } from '../manager/AppFoundationServiceExtensionManager';

const DAY_IN_MILLIS = 1000 * 60 * 60 * 24;
const DEFAULT_USER_ID: number = 100;
const APP_NOT_IN_LIST = 1 << 5;
const TAG = 'NotHarmonyUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
export const NOT_HARMONY_FOLDERNAME = '${not_harmony_apps}';

export class NotHarmonyUtil {
  public static readonly NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT: string = 'NotHarmonyFolder';
  //判断未鸿蒙化图标的点亮状态字段，1：点亮 0：置灰
  public static readonly NOT_HARMONY_APP_MASK_STATE: string = 'maskState';
  public static readonly APP_TYPE: string = 'appType';
  public static readonly LIGHT_DATA: string = 'lightData';
  public static readonly INSTALL_SOURCE = 'installSource';
  public static readonly AUTO_MIGRATE_TYPE = 'autoMigrateType';
  public static mNotHarmonyFolderId: string = '';
  public static CANCEL_NOT_HARMONY_FOLDER: boolean =
    systemparameter.getSync('const.not_harmony.cancel_not_harmony_folder', 'true') === 'true';

  static isNotHarmonyFolderById(folderId?: string): boolean {
    log.showDebug(`folderId = ${folderId}, mNotHarmonyFolderId = ${NotHarmonyUtil.mNotHarmonyFolderId}`);
    return (folderId && folderId === NotHarmonyUtil.mNotHarmonyFolderId) as boolean;
  }

  static setNotHarmonyFolderId(folderId: string): void {
    log.showInfo(`setNotHarmonyFolderId folderId = ${folderId}`);
    NotHarmonyUtil.mNotHarmonyFolderId = folderId;
  }

  /**
   * 查询被拖拽元素是否在文件夹中
   *
   * @param dragGridItem 被拖拽元素
   * @return true 是 false 否
   */
  static isInNotHarmonyFolder(dragGridItem: GridLayoutItemInfo): boolean {
    const notHarmonyFolderData: GridLayoutItemInfo =
      FolderManager.getInstance().getFolder(this.mNotHarmonyFolderId)?.getGridInfo();
    log.showInfo(`not harmony folder container is ${notHarmonyFolderData.id}`);
    return FolderViewModel.isInFolder(notHarmonyFolderData, dragGridItem);
  }

  /**
   * 根据文件夹类型、文件夹内元素数量、元素状态判断文件夹是否解散（解散返回true）
   * @param appsLength 文件夹内元素被操作前长度
   * @param gridLayout 文件夹被操作后元素列表
   */
  static isNotHarmonyFolderShouldReleased(folderId: string | undefined, appsLength: number,
    gridLayout?: GridLayoutItemInfo[] | FolderAppItemInfo[]): boolean {
    //文件夹元素数量≤0、非定制文件夹内元素数量为1时返回True
    let shouldRelease: boolean =
      appsLength <= 0 || (appsLength === CommonConstants.FOLDER_APP_VALUE && !NotHarmonyUtil.isNotHarmonyFolderById(folderId));
    //未鸿蒙化文内且剩余元素为1，且为已安装状态时返回true
    if (NotHarmonyUtil.isNotHarmonyFolderById(folderId) && appsLength === 1) {
      shouldRelease = gridLayout?.[0]?.appStatus === AppStatus.INSTALLED;
    }
    log.showDebug('isNotHarmonyFolderShouldReleased folderId : %{public}s, shouldRelease : %{public}d', folderId,
      shouldRelease);
    return shouldRelease;
  }

  static isNotHarmonyFolderHasOneOrMoreApp(folderId: string | undefined, appsLength: number): boolean {
    return appsLength > CommonConstants.FOLDER_APP_VALUE ||
      (appsLength === CommonConstants.FOLDER_APP_VALUE && NotHarmonyUtil.isNotHarmonyFolderById(folderId));
  }

  static isNotHarmonyFolderByIntent(intent?: string): boolean {
    if (CheckEmptyUtils.isEmpty(intent)) {
      return false;
    }
    let map: Map<string, Object> = CommonUtils.jsonStrToMap(intent);
    return map.has(NotHarmonyUtil.NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT);
  }

  /**
   * 点亮&去除点亮桌面的图标
   *
   * @param relationMap 未鸿蒙化文件夹中应用列表map
   */
  static lightingNotHarmonyAppIcons(relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>): void {
    if ((!relationMap || relationMap.size === 0) && (!publicTestRelationMap || publicTestRelationMap.size === 0)) {
      return;
    }
    //desktop
    NotHarmonyUtil.lightAppInDesktop(relationMap, publicTestRelationMap);
    // dock
    NotHarmonyUtil.lightAppInSmartDock(relationMap, publicTestRelationMap);
  }

  private static lightAppInDesktop(relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>): void {
    let desktopAppInfos: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(TAG);
    for (let i = 0; i < desktopAppInfos.length; i++) {
      let desktopItemInfo: GridLayoutItemInfo = desktopAppInfos[i];
      if (desktopItemInfo.typeId === CommonConstants.TYPE_APP) {
        if (!NotHarmonyUtil.isNeedLightUpOrDown(relationMap, publicTestRelationMap, desktopItemInfo)) {
          continue;
        }
        NotHarmonyUtil.updateIntentAndSendEvent(desktopItemInfo, relationMap, publicTestRelationMap,
          desktopItemInfo.infoId ?? '');
      }
      if (desktopItemInfo.typeId === CommonConstants.TYPE_FOLDER) {
        let needRefreshFolder: boolean = NotHarmonyUtil.findAndLightAppInFolder(desktopItemInfo, relationMap, publicTestRelationMap);
        if (!needRefreshFolder) {
          continue;
        }
        FolderManager.getInstance().updateFolderLayout('lightAppInDesktop', desktopItemInfo.folderId,
          desktopItemInfo.layoutInfo?.flat(), []);
      }
    }
    LaunchLayoutCacheManager.getInstance().updateGridLayoutItems(desktopAppInfos, TAG, false);
  }

  private static lightAppInSmartDock(relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>): void {
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    for (let i = 0; i < residentList.length; i++) {
      let dockItemInfo: DockItemInfo = residentList[i];
      if (dockItemInfo.typeId === CommonConstants.TYPE_APP) {
        if (!NotHarmonyUtil.isNeedLightUpOrDown(relationMap, publicTestRelationMap, dockItemInfo)) {
          continue;
        }
        NotHarmonyUtil.updateIntentAndSendEvent(dockItemInfo, relationMap, publicTestRelationMap,
          dockItemInfo.appId ?? '');
      }
      if (dockItemInfo.typeId === CommonConstants.TYPE_FOLDER) {
        NotHarmonyUtil.findAndLightAppInFolder(dockItemInfo, relationMap, publicTestRelationMap);
      }
    }
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_light'), residentList);
  }

  private static findAndLightAppInFolder(desktopItemInfo: GridLayoutItemInfo | DockItemInfo,
    relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>): boolean {
    let needRefreshFolder: boolean = false;
    if (!desktopItemInfo.layoutInfo) {
      return needRefreshFolder;
    }
    for (let j = 0; j < desktopItemInfo.layoutInfo.length; j++) {
      for (let k = 0; k < desktopItemInfo.layoutInfo[j].length; k++) {
        if (!NotHarmonyUtil.isNeedLightUpOrDown(relationMap, publicTestRelationMap, desktopItemInfo.layoutInfo[j][k])) {
          continue;
        }
        NotHarmonyUtil.updateIntentAndSendEvent(desktopItemInfo.layoutInfo[j][k], relationMap, publicTestRelationMap,
          desktopItemInfo.layoutInfo[j][k].infoId ?? '');
        needRefreshFolder = true;
      }
    }
    return needRefreshFolder;
  }

  private static isNeedLightUpOrDown(relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>,
    item: GridLayoutItemInfo | DockItemInfo): boolean {
    if (!relationMap.has(item.bundleName) && !publicTestRelationMap.has(item.bundleName)) {
      return false;
    }
    if (item.appStatus !== AppStatus.WAIT_FOR_HARMONY) {
      return false;
    }
    // 桌面已经点亮，则不需要再次点亮,忽略掉点亮事件
    if (CommonUtils.jsonStrToMap(item.intent).get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) === 1) {
      // 再次点亮的普通应用
      if (relationMap.get(item.bundleName)) {
        relationMap.delete(item.bundleName);
        log.showWarn('light common app , AG send light event again, bundleName = %{public}s', item.bundleName);
        return false;
      }
      // 再次点亮的尝鲜应用
      if (publicTestRelationMap.get(item.bundleName)) {
        publicTestRelationMap.delete(item.bundleName);
        log.showWarn('light publicTest app , AG send light event again, bundleName = %{public}s', item.bundleName);
        return false;
      }
    }
    return true;
  }

  private static updateIntentAndSendEvent(desktopItemInfo: GridLayoutItemInfo | DockItemInfo,
    relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>, infoId: string): void {
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(desktopItemInfo.intent);
    // 修改点亮未点亮的关系
    let paras: LightIconInNotHarmonyFolderBean = new LightIconInNotHarmonyFolderBean();
    paras.bundleName = desktopItemInfo.bundleName;
    if (relationMap.get(desktopItemInfo.bundleName)) {
      intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
      intentMap.set(NotHarmonyUtil.APP_TYPE, AppReserveType.THIRD);
      intentMap.set(NotHarmonyUtil.LIGHT_DATA, new Date().getTime().toString());
      HiSysEventUtil.reportLightIconInNotHarmonyFolder(paras);
    } else if (publicTestRelationMap.get(desktopItemInfo.bundleName)) {
      intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 1);
      intentMap.set(NotHarmonyUtil.APP_TYPE, AppReserveType.TASTE_FRESH);
      intentMap.set(NotHarmonyUtil.LIGHT_DATA, new Date().getTime().toString());
      HiSysEventUtil.reportLightIconInNotHarmonyFolder(paras);
    } else {
      intentMap.set(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE, 0);
      if (intentMap.get(NotHarmonyUtil.APP_TYPE) === AppReserveType.TASTE_FRESH) {
        intentMap.set(NotHarmonyUtil.APP_TYPE, AppReserveType.THIRD);
      }
    }
    // 保存数据入库和缓存
    let intentStr: string = CommonUtils.mapToJonStr(intentMap);
    desktopItemInfo.intent = intentStr;
    RdbStoreManager.getInstance().updateFolderIntentByInfoId(infoId, intentStr);
    // 发送更新事件到桌面
    let data: AppGalleryEventInfo = {
      bundleName: desktopItemInfo.bundleName,
      status: desktopItemInfo.appStatus ?? 0,
      eventType: DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE,
      intent: intentMap,
    };
    log.showInfo('find not harmony app bundleName = %{public}s, appIndex = %{public}d, infoId = %{public}s, appType = %{public}d, maskState = %{public}d',
      desktopItemInfo.bundleName, desktopItemInfo.appIndex, infoId, intentMap.get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE),
      intentMap.get(NotHarmonyUtil.APP_TYPE));
    const eventHub: ctx.EventHub =
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.eventHub;
    eventHub.emit(`appGalleryStatusChange${desktopItemInfo.bundleName}${desktopItemInfo.appIndex}icon`, data);
  }

  /**
   * 点亮未鸿蒙化应用文件夹中的图标： 目前采用的方式是全量刷新
   *
   * @param relationMap 未鸿蒙化文件夹中应用列表map
   */
  static refreshNotHarmonyFolderPosition(relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>): void {
    if ((relationMap.size === 0 && publicTestRelationMap.size === 0) || !NotHarmonyUtil.mNotHarmonyFolderId) {
      return;
    }
    // 拿到文件夹ID
    let folder: GridLayoutItemInfo | undefined =
      FolderLayoutCacheManager.getInstance().selectGridLayoutItemByFolderId(NotHarmonyUtil.mNotHarmonyFolderId);
    // 查看是否在dock区
    if (!folder) {
      NotHarmonyUtil.refreshNotHarmonyFolderInDock(relationMap, publicTestRelationMap);
      return;
    }
    NotHarmonyUtil.refreshNotHarmonyFolderInDesktop(folder, relationMap, publicTestRelationMap);
  }

  /**
   * 判断拖拽的元素是不是都是定制文件夹应用
   *
   * @param dragItems 拖拽元素的数组
   */
  static isNotHarmonyApps(dragItems: GridLayoutItemInfo[]): boolean {
    for (const dragItem of dragItems) {
      if (dragItem.appStatus !== AppStatus.WAIT_FOR_HARMONY) {
        return false;
      }
    }
    return true;
  }

  /**
   * 点亮桌面（非dock)区文件夹中的图标
   *
   * @param relationMap 未鸿蒙化文件夹中应用列表map
   */
  private static refreshNotHarmonyFolderInDesktop(folderItem: GridLayoutItemInfo,
    relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>): void {
    let folderAppList: GridLayoutItemInfo[] = NotHarmonyUtil.refreshNotHarmonyFolderAppList(relationMap, publicTestRelationMap, folderItem);
    NotHarmonyUtil.updateFolderAppLocation(folderAppList);
    FolderLayoutCacheManager.getInstance().updateFolderItemLayoutInfoByFolderId(
      folderItem.folderId ?? '',
      DeliverUtil.translateFolderLayout(folderAppList),
      folderAppList,
      TAG,
      true
    );
    const openFolderId: string = FolderManager.getInstance().getOpenFolderId();
    if (openFolderId === this.mNotHarmonyFolderId) {
      FolderDataModelManager.getInstance().getSwiperController()?.changeIndex(0, false);
    }
  }

  /**
   * 点亮dock区文件夹中的图标
   *
   * @param relationMap 未鸿蒙化文件夹中应用列表map
   */
  private static refreshNotHarmonyFolderInDock(relationMap: Map<string, boolean>, publicTestRelationMap: Map<string, boolean>): void {
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let folderIndex: number = residentList.findIndex(item => {
      return item.appId === NotHarmonyUtil.mNotHarmonyFolderId;
    });
    if (folderIndex === -1) {
      log.showWarn('refreshNotHarmonyFolderInDock::Not harmony folder not exist.');
      return;
    }
    log.showInfo('refreshNotHarmonyFolderInDock::Find not harmony folder in dock success %{public}d.', folderIndex);
    let dockFolderItemInfo: DockItemInfo = residentList[folderIndex];
    let folderAppList: GridLayoutItemInfo[] = NotHarmonyUtil.refreshNotHarmonyFolderAppList(relationMap, publicTestRelationMap, dockFolderItemInfo);
    NotHarmonyUtil.updateFolderAppLocation(folderAppList);

    dockFolderItemInfo.layoutInfo = DeliverUtil.translateFolderLayout(folderAppList);
    const folderMgr: FolderManager = FolderManager.getInstance()
    const openFolderId: string = folderMgr.getOpenFolderId();
    if (openFolderId === this.mNotHarmonyFolderId) {
      folderMgr.getOpenedFolder().layoutInfo = dockFolderItemInfo.layoutInfo;
    }
    residentList.splice(folderIndex, 1, dockFolderItemInfo);
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_refresh'), residentList);
    const folderItem: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockFolderItemInfo);
    folderMgr.updateFolderItems('update dock NotHarmonyFolder', folderItem, []);
    RdbStoreManager.getInstance().addInfoToDockFolder(dockFolderItemInfo.bundleName, folderAppList);
    if (openFolderId === NotHarmonyUtil.mNotHarmonyFolderId) {
      FolderDataModelManager.getInstance().getSwiperController()?.changeIndex(0, false);
    }
  }

  /**
   * 更新文件夹应用位置
   *
   * @param layoutList 文件夹中应用列表
   */
  private static updateFolderAppLocation(layoutList: GridLayoutItemInfo[]): void {
    let folderOpenColumn: number = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let folderOpenRow: number = FolderModel.getInstance().getFolderOpenLayout()?.row;
    for (let i = 0; i < layoutList.length; i++) {
      layoutList[i].column = i % folderOpenColumn;
      layoutList[i].row = Math.floor(i / folderOpenColumn % folderOpenRow);
      layoutList[i].page = Math.floor(i / (folderOpenColumn * folderOpenRow));
    }
  }

  /**
   * 获取桌面文件夹的应用信息，将应用点亮、置灰
   *
   * @param relationMap 文件夹应用状态map
   * @param folderItem 桌面文件夹
   * @return { GridLayoutItemInfo[] } 桌面文件夹appInfos
   */
  private static refreshNotHarmonyFolderAppList(relationMap: Map<string, boolean>,
    publicTestRelationMap: Map<string, boolean>,
    folderItem: GridLayoutItemInfo | DockItemInfo): GridLayoutItemInfo[] {
    let isHarmonyArr: GridLayoutItemInfo[] = [];
    let notHarmonyArr: GridLayoutItemInfo[] = [];
    let folderAppArr: GridLayoutItemInfo[] = folderItem.layoutInfo?.flat() ?? [];
    for (let i = 0; i < folderAppArr.length; i++) {
      let folderItemInfo: GridLayoutItemInfo = folderAppArr[i];
      if (relationMap.get(folderItemInfo.bundleName) || publicTestRelationMap.get(folderItemInfo.bundleName)) {
        isHarmonyArr.push(folderItemInfo);
      } else {
        notHarmonyArr.push(folderItemInfo);
      }
    }
    isHarmonyArr = isHarmonyArr.concat(notHarmonyArr);
    return isHarmonyArr;
  }

  /**
   * 判断item是否满足点亮条件
   *
   * @param item 应用item
   * @returns true 是否满足点亮条件
   */
  public static checkItemLightingStatus(item: GridLayoutItemInfo | AppItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmpty(item.intent)) {
      return false;
    }
    let appType: number = CommonUtils.jsonStrToMap(item.intent).get(NotHarmonyUtil.APP_TYPE) as number;
    let maskState: number =
      CommonUtils.jsonStrToMap(item.intent).get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) as number;
    return appType === AppReserveType.ENTERPRISE || (appType === AppReserveType.TASTE_FRESH && maskState === 1);
  }

  /**
   * 判断未鸿蒙化的item是否满足点亮条件
   *
   * @param item 应用item
   * @returns true 是否满足点亮条件
   */
  public static checkNotHarmonyItemLightingStatus(item: GridLayoutItemInfo | AppItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmpty(item.intent)) {
      return false;
    }
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
    let installSource: string = intentMap.get(NotHarmonyUtil.INSTALL_SOURCE) as string;
    if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG || installSource === DeliverUtil.ABROAD_APP_PKG) {
      return true;
    }
    if (intentMap.get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) === 1) {
      return true;
    }
    return false;
  }

  /**
   * 判断未鸿蒙化的item是否满足加待下载角标条件
   *
   * @param item 应用item
   * @returns true 需要添加待下载角标条件
   */
  public static checkNotHarmonyItemAddBadgeStatus(item: GridLayoutItemInfo | AppItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(item) || CheckEmptyUtils.isEmpty(item.intent)) {
      return false;
    }
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
    let installSource: string = intentMap.get(NotHarmonyUtil.INSTALL_SOURCE) as string;
    if (installSource !== DeliverUtil.DELIVER_APPSTORE_PKG && installSource !== DeliverUtil.ABROAD_APP_PKG) {
      if (intentMap.get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) === 1) {
        return true;
      }
    }
    return false;
  }

  /**
   * 是否为64位应用
   * @param legacyInfo  应用扩展信息
   * @returns true 支持64位应用 false 不支持64位应用
   */
  public static isSupport64(legacyInfo: LegacyInfo): boolean {
    if (CheckEmptyUtils.isEmpty(legacyInfo)) {
      log.showWarn('judge isSupport64 but legacyInfo is empty');
      return true;
    }
    log.showInfo('primaryCpuAbi = %{public}s, secondaryCpuAbi = %{public}s', legacyInfo.primaryCpuAbi,
      legacyInfo.secondaryCpuAbi);
    let abi64: string = 'arm64-v8a';
    if (CheckEmptyUtils.isEmpty(legacyInfo.primaryCpuAbi) && CheckEmptyUtils.isEmpty(legacyInfo.secondaryCpuAbi)) {
      return true;
    }
    if (legacyInfo.primaryCpuAbi === abi64 || legacyInfo.secondaryCpuAbi === abi64) {
      return true;
    }
    return false;
  }

  /**
   * 查询并点亮未鸿蒙化可出应用
   *
   * @param gridLayoutItemInfoList 未安装应用信息info
   */
  public static async queryAndLightDeliverApp(gridLayoutItemInfoList: GridLayoutItemInfo[]): Promise<void> {
    try {
      if (launcherAbilityManager.getUserId() !== DEFAULT_USER_ID) {
        log.showWarn('only default user support deliver');
        return;
      }
      let date: Date = new Date();
      let preference = await preferences.getPreferences(
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext, 'DESKTOP_LAYOUT_INFO');
      let queryAndLightAddDeliverAppTime: number = preference.getSync('queryAndLightAddDeliverApp', 0) as number;
      if (queryAndLightAddDeliverAppTime !== 0 &&
        queryAndLightAddDeliverAppTime > NotHarmonyUtil.minusDays(date, NumberConstants.CONSTANT_NUMBER_ONE)) {
        log.showInfo('not need query, last query time %{public}d', queryAndLightAddDeliverAppTime);
        return;
      }
      let queryBeforePkgNames: string[] = (preference.getSync('lightDeliverBundleNames', '') as string).split(',');
      let queryResult: string[][] =
        NotHarmonyUtil.collectNeedQueryAndLightBeforeApp(gridLayoutItemInfoList, queryBeforePkgNames);
      let pkgNameArr: string[] = (queryResult && queryResult.length === 2) ? queryResult[0] : [];
      let lightBeforeBundleNames: string[] = (queryResult && queryResult.length === 2) ? queryResult[1] : [];
      if (CheckEmptyUtils.isEmptyArr(pkgNameArr)) {
        log.showInfo('queryAndLightAddDeliverAp pkgNameArr is empty');
        return;
      }
      let appFoundation: AppFoundationServiceExtensionManager = AppFoundationServiceExtensionManager.getInstance();
      await appFoundation.queryAppMappingInfo(pkgNameArr);
      let deliverBundleNamesMap: Map<string, number> = appFoundation.getDeliverBundleNamesMap();
      if (!appFoundation.queryMappingResult() && deliverBundleNamesMap.size === 0) {
        log.showError('queryAppMappingInfo failed, do not save time');
        return;
      }
      let deliverBundleNames: string[] = NotHarmonyUtil.removeNotInAppList32App(deliverBundleNamesMap, gridLayoutItemInfoList);
      preference.putSync('lightDeliverBundleNames', deliverBundleNames.join(','));
      if (appFoundation.queryMappingResult()) {
        log.showInfo('lightAddDeliverApp start');
        let publicTestRelationMap: Map<string, boolean> = new Map();
        let relationMap: Map<string, boolean> =
          NotHarmonyUtil.findLightUpOrDownAppByRelation(lightBeforeBundleNames, deliverBundleNames);
        NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap);
        NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap, publicTestRelationMap);
        log.showInfo('lightAddDeliverApp end');
      }
      preference.putSync('queryAndLightAddDeliverApp', date.getTime());
      await preference.flush().then(() => {
        log.showInfo('save queryAndLightAddDeliverApp to sp success');
      }).catch((reject: Error) => {
        log.showInfo('save queryAndLightAddDeliverApp to sp fail: %{public}s', reject?.message);
      });
      log.showInfo('queryAndLightAddDeliverApp time %{public}s', date.toString());
    } catch (err) {
      log.showError(`queryAndLightAddDeliverApp, Failed to get preferences error: ${err.code} : ${err.message}`);
    }
  }

  private static collectNeedQueryAndLightBeforeApp(gridLayoutItemInfoList: GridLayoutItemInfo[],
    queryBeforePkgNames: string[]): string[][] {
    let pkgNameArr: string[] = [];
    let lightBeforeBundleNames: string[] = [];
    let result: string[][] = [pkgNameArr, lightBeforeBundleNames];
    if (CheckEmptyUtils.isEmptyArr(gridLayoutItemInfoList)) {
      log.showInfo('collect gridLayoutItemInfoList is empty');
      return result;
    }
    gridLayoutItemInfoList.forEach(appItemInfo => {
      if (appItemInfo.appStatus !== AppStatus.WAIT_FOR_HARMONY) {
        log.showInfo('not wait for harmony app, bundleName = %{public}s', appItemInfo.bundleName);
        return;
      }
      let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(appItemInfo.intent);
      let installSource: string = intentMap.get(NotHarmonyUtil.INSTALL_SOURCE) as string;
      let maskState = intentMap.get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) as number;
      log.showInfo('wait for harmony app, bundleName = %{public}s , installSource = %{public}s maskState = %{public}d',
        appItemInfo.bundleName, installSource, maskState);
      if (installSource !== DeliverUtil.DELIVER_APPSTORE_PKG && installSource !== DeliverUtil.ABROAD_APP_PKG) {
        if (!maskState) {
          pkgNameArr.push(appItemInfo.bundleName);
        } else if (maskState === 1 && queryBeforePkgNames.includes(appItemInfo.bundleName)) {
          pkgNameArr.push(appItemInfo.bundleName);
          lightBeforeBundleNames.push(appItemInfo.bundleName);
        }
      }
    });
    return result;
  }

  private static findLightUpOrDownAppByRelation(queryBeforePkgNames: string[],
    deliverBundleNames: string[]): Map<string, boolean> {
    let relationMap: Map<string, boolean> = new Map();
    let queryBeforePkgSet: Set<string> = new Set<string>(queryBeforePkgNames);
    let deliverBundleNameSet: Set<string> = new Set<string>(deliverBundleNames);
    // 点亮 -->  新点亮集合 - 旧点亮集合  排除原来点亮集合里面的
    deliverBundleNameSet.forEach(item => {
      if (!queryBeforePkgSet.has(item)) {
        log.showInfo('queryAndLightAddDeliverApp hasohosApp: %{public}s', item);
        relationMap.set(item, true);
      }
    });
    // 熄灭 -->  旧点亮集合 - 新点亮集合  不在新点亮集合里面,需要熄灭
    queryBeforePkgSet.forEach(item => {
      if (!deliverBundleNameSet.has(item)) {
        log.showInfo('queryAndLightAddDeliverApp not hasohosApp: %{public}s', item);
        relationMap.set(item, false);
      }
    });
    return relationMap;
  }

  private static removeNotInAppList32App(deliverBundleNamesMap: Map<string, number>,
    gridLayoutItemInfoList: GridLayoutItemInfo[]): string[] {
    let deliverBundleNames: string[] = [];
    if (CheckEmptyUtils.isEmpty(deliverBundleNamesMap) || CheckEmptyUtils.isEmptyArr(gridLayoutItemInfoList)) {
      log.showWarn('removeNotInAppList32App params is empty');
      return deliverBundleNames;
    }
    deliverBundleNamesMap.forEach((type, item) => {
      if (type & APP_NOT_IN_LIST) {
        let gridLayoutInfo: GridLayoutItemInfo | undefined =
          gridLayoutItemInfoList.find(grid => grid.bundleName === item);
        if (gridLayoutInfo && NotHarmonyUtil.isSupport64(CommonUtils.jsonStrToMap(gridLayoutInfo.intent)
          .get('legacyInfo') as LegacyInfo)) {
          log.showInfo('queryAndLightAddDeliverApp hasohosApp is support deliver 64: %{public}s', item);
          deliverBundleNames.push(item);
        }
      } else {
        deliverBundleNames.push(item);
      }
    });
    return deliverBundleNames;
  }

  /**
   * 在date基础减去上days天数
   *
   * @param date 基础日期
   * @param days 减去天数
   * @return 减去后的毫秒值
   */
  private static minusDays(date: Date, days: number): number {
    let curTime: number = date.getTime();
    return curTime - (days * DAY_IN_MILLIS);
  }

  /**
   * 是否为待下载应用
   * @param item  当前应用信息
   * @returns true 是待下载应用
   */
  public static isWaitingDownloadApp(item: AppItemInfo | GridLayoutItemInfo): boolean {
    return (item.appStatus === AppStatus.WAIT_FOR_HARMONY &&
      NotHarmonyUtil.checkNotHarmonyItemAddBadgeStatus(item)) ||
      (item.appStatus === AppStatus.PENDING && NotHarmonyUtil.checkItemLightingStatus(item));
  }
}