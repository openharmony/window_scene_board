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

import { CheckEmptyUtils, OutdoorConfig, LogDomain, LogHelper, singleManager } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import {
  DeviceHelper,
  IconResourceManager,
  localEventManager,
  RdbStoreConfig,
  ResourceManager,
  LightOutdoorConfig
} from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { BaseBundleInfo } from '../../bean/BaseBundleInfo';
import { GridLayoutDBMapReplaceCorrectorBuilder } from '../../db/gridlayoutcorrector/GridLayoutDBMapReplaceCorrector';
import {
  AppItemInfo,
  AppModel,
  AppStatus,
  BadgeManager,
  CommonConstants,
  CommonDockModel,
  DeliverUtil,
  DockItemInfo, DockUtils,
  EventConstants,
  FolderCommonUtil,
  FolderDataModelManager,
  GetHideAppsFromConfig,
  GridLayoutItemInfo,
  GridLayoutUtil,
  launcherAbilityManager,
  layoutConfigManager,
  NotHarmonyUtil,
  RdbStoreManager,
  ShortcutInfo,
  SmallFolderIconFileUtil,
  SmartDockLayoutConfig
} from '../../TsIndex';
import { PreInstallUtils } from '../../utils/PreInstallUtils';
import { BaseDockLayoutCacheMgr } from './BaseDockLayoutCacheMgr';

const TAG = 'ResidentLayoutCacheMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 *  resident缓存数据管理类
 */
export class ResidentLayoutCacheMgr extends BaseDockLayoutCacheMgr {

  protected static instance: ResidentLayoutCacheMgr;

  private readonly mSmartDockLayoutConfig: SmartDockLayoutConfig;

  // 简易模式切换，继承标准布局Dock栏元素
  private mHomeInheritDockItems: DockItemInfo[] = [];

  private constructor() {
    super();
    this.mSmartDockLayoutConfig = layoutConfigManager.getFunctionConfig(SmartDockLayoutConfig.SMART_DOCK_LAYOUT_INFO);
    if (this.mSmartDockLayoutConfig === null) {
      // 防止单例创建早于layoutConfigManager中填充信息，如果从layoutConfigManager中未获取到信息则自行创建单例
      this.mSmartDockLayoutConfig = singleManager.get<SmartDockLayoutConfig>(SmartDockLayoutConfig);

      // 添加时序异常的调用堆栈打印,用于问题时序排查,后续删除
      let stack: string = new Error('LayoutConfig_empty').stack;
      log.showError('LayoutConfig_empty: %{public}s', stack);
    }
  }

  public static getInstance(): ResidentLayoutCacheMgr {
    if (!ResidentLayoutCacheMgr.instance) {
      ResidentLayoutCacheMgr.instance = new ResidentLayoutCacheMgr();
      ResidentLayoutCacheMgr.instance.init(true);
    }
    return ResidentLayoutCacheMgr.instance;
  }

  /**
   * 获取所有resident区数据
   * @returns 返回当前resident区的缓存对象
   */
  getAllDockItems(): DockItemInfo[] {
    return this.dockCacheData ?? [];
  }

  /**
   * 更新所有resident区数据，第三个入参isOperateDb决定是否入库
   * @param from 更新来源
   * @param dockItems 数据
   * @param isOperateDb 是否操作数据库，默认入库
   * @returns
   */
  updateAllDockItems(from: string, dockItems: DockItemInfo[], isOperateDb: boolean = true, tableName?: string): void {
    let paramLog = DockUtils.getPrintParam(dockItems);
    log.showInfo(`updateAllDockItems from: ${from}, param: ${paramLog}, isOperateDb: ${isOperateDb}`);
    dockItems.forEach((item) => {
      if (item.typeId === CommonConstants.TYPE_APP && CheckEmptyUtils.checkStrIsEmpty(item.appName)) {
        item.appName = AppModel.getInstance().getAppInfoByKeyName(item.keyName ?? '')?.appName ?? '';
      }
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON && CheckEmptyUtils.checkStrIsEmpty(item.appName)) {
        IconResourceManager.getInstance().getAppName(item.appLabelId,
          item.bundleName, item.moduleName, '', item.appIndex).then((value) => {
          item.appName = value;
        });
      }
      log.showWarn(`bundleName: ${item.bundleName}, abilityName: ${item.abilityName}, moduleName: ${item.moduleName},typeId: ${item.typeId}, name:${item.appName}`);
    })
    this.dockCacheData = dockItems;
    this.mSmartDockLayoutConfig.updateDockLayoutInfo(dockItems);
    // 同步数据
    AppStorage.setOrCreate('residentList', dockItems);
    if (isOperateDb) {
      this.updateRdbResidentLayoutInfo(dockItems, tableName);
    }
  }

  /**
   * 通过bundleName appIndex查找在dock区的app类型的应用(不包含快捷方式)
   * @param bottomAppList resident区应用list
   * @param bundleName 应用包名
   * @param appIndex 分身索引
   * @returns 返回app类型的应用是否在dock区  GridLayoutItemInfo 文件夹中 DockItemInfo在桌面
   */
  public getAppTypeItemByBundleName(bundleName: string, appIndex: number = 0):
    GridLayoutItemInfo | DockItemInfo | undefined {
    if (CheckEmptyUtils.isEmptyArr(this.dockCacheData)) {
      log.showInfo('getAppTypeItem residentList is empty');
      return undefined;
    }
    for (let i = 0; i < this.dockCacheData.length; i++) {
      if (this.dockCacheData[i].typeId === CommonConstants.TYPE_FOLDER) {
        let folderAppItem: GridLayoutItemInfo | undefined =
          this.dockCacheData[i].layoutInfo?.flat().find(appItem => appItem.bundleName === bundleName &&
            appItem.appIndex === appIndex && appItem.typeId === CommonConstants.TYPE_APP);
        if (folderAppItem !== undefined) {
          log.showInfo('getAppTypeItem::getDockItemByBundleName: in dock folder');
          return folderAppItem;
        }
      } else if (this.dockCacheData[i].typeId === CommonConstants.TYPE_APP) {
        if (this.dockCacheData[i].bundleName === bundleName && this.dockCacheData[i].appIndex === appIndex) {
          log.showInfo('getAppTypeItem::getDockItemByBundleName: in dock');
          return this.dockCacheData[i];
        }
      }
    }
    log.showInfo('getAppTypeItem::getDockItemByBundleName: not find in dock');
    return undefined;
  }

  /**
   * 持久化residentList 数据.
   * @params residentList
   * @returns
   */
  public updateRdbResidentLayoutInfo(residentList: DockItemInfo[], target?: string): void {
    RdbStoreManager.getInstance().insertIntoSmartdock(residentList, target).then((result) => {
      log.showInfo(`updateResidentLayoutInfo success, result is ${result}, param target is ${target}`);
    }).catch((err) => {
      log.showError(`updateResidentLayoutInfo error: ${err.toString()}`);
    });
  }

  /**
   * clear resident dock list
   */
  private clearResidentListCache(): void {
    this.dockCacheData = [];
    this.mSmartDockLayoutConfig.updateDockLayoutInfo([]);
  }

  /**
   * 清理缓存并重新初始化resident区的数据
   * @param from 来源
   * @returns
   */
  async clearCacheAndInit(from: string): Promise<void> {
    log.showInfo(`clearCacheAndInit from: ${from}`);
    // 临时缓存当前标准布局dock栏元素
    let tmpTableName: string = RdbStoreManager.getInstance().getLayoutInfoTableName(false);
    if (tmpTableName === RdbStoreConfig.simpleLayoutInfo.tableName) {
      this.mHomeInheritDockItems = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    }
    //清除原有的缓存
    this.clearResidentListCache();
    await this.init();
  }

  /**
   * 处理隐藏配置并增加BMS包名校验（【语音助手桌面映射方案】防止脏数据，增加BMS包名校验）
   * @param dockDataList 缓存数据源
   */
  private async dealHideConfigAndDBMap(dockDataList: DockItemInfo[]): Promise<void> {
    try {
      const isPC: boolean = DeviceHelper.isPC();
      await Promise.all([
        GetHideAppsFromConfig.getInstance().loadHideConfig(),
        // 【语音助手桌面映射方案】防止脏数据，增加BMS包名校验
        GridLayoutDBMapReplaceCorrectorBuilder.getInstance().dockMapReplaceCorrector(isPC, dockDataList)
      ]);
    } catch (e) {
      log.showError(`loadHideConfig or dockMapReplaceCorrector error.  ${e?.code}, ${e?.message}`);
    }
  }

  private shouldLoadDefaultLayout(tableName: string): boolean {
    if (DeviceHelper.isPC()) {
      return true;
    }
    if (tableName === RdbStoreConfig.gridLayoutInfo.tableName) {
      return !this.mSmartDockLayoutConfig.isConfigExist();
    }
    let result: boolean = false;
    if (tableName === RdbStoreConfig.simpleLayoutInfo.tableName) {
      result = !this.mSmartDockLayoutConfig.getSimpleConfigStatus();
      if (result) {
        this.mSmartDockLayoutConfig.putSimpleConfigStatus();
      }
    }
    log.showWarn(`shouldLoadDefaultLayout: ${result}`);
    return result;
  }

  private transDockFolderId(dockItemInfo: DockItemInfo[]): void {
    dockItemInfo.forEach((item) => {
      if (GridLayoutUtil.isFolderType(item.itemType)) {
        item.keyName = FolderCommonUtil.transFolderID(item.keyName, 'J');
        item.bundleName = item.keyName;
      }
    });
  }

  /**
   * 初始化resident区的缓存数据
   * @param isFirst
   * @returns
   */
  private async init(isFirst: boolean = false): Promise<void> {
    let tmpTableName: string = RdbStoreManager.getInstance().getLayoutInfoTableName(false);
    // query rdb data
    let dockDataList: DockItemInfo[] = await CommonDockModel.getInstance().querySmartDock(false, tmpTableName);
    if (isFirst) {
      await this.dealHideConfigAndDBMap(dockDataList);
    }

    let residentList: DockItemInfo[] = [];
    // 识别是否为首次加载dock信息
    let isInitDockInfo = false;
    let noDockInfo =
      CheckEmptyUtils.isEmptyArr(dockDataList) && this.shouldLoadDefaultLayout(tmpTableName);
    // 如果是户外模式模式，则只判断数据库中是否有数据。
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      noDockInfo = true;
      log.showInfo(`Outdoor mode, read dockInfo from config files`);
    }
    if (LightOutdoorConfig.getInstance().isOnLightOutdoorMode()) {
      noDockInfo = CheckEmptyUtils.isEmptyArr(dockDataList);
    }
    if (noDockInfo) {
      // init preset dock data
      if (tmpTableName !== RdbStoreConfig.simpleLayoutInfo.tableName) {
        dockDataList = await this.mSmartDockLayoutConfig.getDockLayoutInfo();
      } else {
        // 简易布局首次切换，继承标准布局Dock栏前3个元素
        dockDataList = this.mHomeInheritDockItems.slice(0, 3);
        this.transDockFolderId(dockDataList);
      }
      dockDataList.forEach((item) => {
        if (GridLayoutUtil.isIconType(item.itemType)) {
          item.appId = RdbStoreManager.getInstance().generateRandomUUID(false);
        }
      });
      let dockFolders: DockItemInfo[] = dockDataList.filter(item => item.itemType === CommonConstants.TYPE_FOLDER);
      if (dockFolders.length > 0) {
        // Dock区文件夹独立插入
        let insertFolders: GridLayoutItemInfo[] = dockFolders.map(item => GridLayoutUtil.dockItemToGridLayout(item));
        await RdbStoreManager.getInstance().insertGridLayoutInfo(insertFolders);
      }
      isInitDockInfo = true;

      let paramLog = DockUtils.getPrintParam(dockDataList);
      log.showWarn(`init from config length: ${dockDataList.length},${paramLog}`);
    } else {
      let paramLog = DockUtils.getPrintParam(dockDataList);
      log.showWarn(`init from rdb table name: ${tmpTableName} length: ${dockDataList.length},${paramLog}`);
    }
    this.mHomeInheritDockItems = [];
    let keyNameSet: Set<string> = new Set();
    if (!CheckEmptyUtils.isEmptyArr(dockDataList)) {
      dockDataList = GetHideAppsFromConfig.getInstance().filterHideApp(dockDataList);
    }
    for (let i = 0; i < dockDataList.length; i++) {
      if (this.isDataNeedIgnore(dockDataList[i]) || launcherAbilityManager.isIgnoreApp(dockDataList[i])) {
        continue;
      }
      if (GridLayoutUtil.isIconType(dockDataList[i].itemType)) {
        log.showDebug(`getResidentList dockDataList[i].bundleName: ${dockDataList[i].bundleName}`);
        let dockItemInfo = await this.createDockAppInfo(dockDataList[i], i, true);
        if (!dockItemInfo) {
          continue;
        }
        await this.dealDockIcon(dockItemInfo, keyNameSet, residentList);
      } else if (dockDataList[i].itemType === CommonConstants.TYPE_CARD) {
      } else if (dockDataList[i].itemType === CommonConstants.TYPE_FOLDER) {
        const dockItemInfo = new DockItemInfo();
        await this.createDockFolderInfo(dockItemInfo, dockDataList[i], i, tmpTableName);
        await this.dealDockFolder(dockItemInfo, residentList);
      } else {
        const dockItemInfo = new DockItemInfo();
        await this.createDockOtherInfo(dockItemInfo, dockDataList[i], i);
        residentList.push(dockItemInfo);
      }
    }
    if (SCBSceneSessionManager.getInstance().isPcMode() &&
      residentList[0]?.abilityName !== CommonConstants.RECENT_ABILITY) {
      const recentCenterItem: DockItemInfo = this.createDockRecentAppInfo();
      residentList.unshift(recentCenterItem);
    }
    keyNameSet.clear();
    // 更新新的缓存及数据
    this.updateAllDockItems(TAG.concat('_init'), residentList, true, tmpTableName);
    if (isFirst) {
      if (noDockInfo) {
        this.mSmartDockLayoutConfig.updateDockLayoutInfoAndPersist(residentList);
      }
      log.showInfo('getResidentList send EVENT_SMARTDOCK_INIT_FINISHED');
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_SMARTDOCK_INIT_FINISHED, residentList);
    }
    if (isInitDockInfo) {
      // 首次从预置布局中加载SmarkDock数据时，异步刷新应用名称信息至缓存和桌面布局表中
      AppModel.getInstance().updateInfoNameOfApp(false);
    }
  }

  /**
   * 数据是否需要过滤
   * @param dockItemInfo
   * @returns
   */
  private isDataNeedIgnore(dockItemInfo: DockItemInfo): boolean {
    if (DeviceHelper.isPC()) {
      return dockItemInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE && !this.isLauncherBundle(dockItemInfo);
    }
    return dockItemInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE &&
      dockItemInfo.itemType !== CommonConstants.TYPE_SHORTCUT_ICON;
  }

  private isLauncherBundle(dockItemInfo: DockItemInfo): boolean {
    return dockItemInfo.abilityName === CommonConstants.APPCENTER_ABILITY ||
      dockItemInfo.abilityName === CommonConstants.RECENT_ABILITY ||
      dockItemInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY;
  }

  /**
   * 创建dock区app元素
   *
   * @param appItemInfo 数据库或缓存中取出的元素
   * @param index 位置信息
   */
  public async createDockAppInfo(appItemInfo: DockItemInfo, index: number,
    isFromResident: boolean = false): Promise<DockItemInfo | null> {
    if (CheckEmptyUtils.isEmpty(appItemInfo)) {
      return null;
    }
    if (appItemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let dockItemInfo: DockItemInfo = appItemInfo;
      this.updateShortcut(dockItemInfo, index);
      return dockItemInfo;
    }
    let appDataFromSystem = await launcherAbilityManager.getAppInfoByBundleName(appItemInfo.bundleName, '', appItemInfo.appIndex);
    if (!appDataFromSystem) {
      log.showWarn(`appDataFromSystem is empty, bundleName: ${appItemInfo.bundleName}`);
      if (PreInstallUtils.checkIsNeedInstallApp(appItemInfo)) {
        return appItemInfo;
      }
      if (!GridLayoutUtil.isAppInstalled(appItemInfo)) {
        log.showWarn(`bundleName ${appItemInfo.bundleName} status is ${appItemInfo.appStatus}`);
        return appItemInfo;
      }
      // 重启后dh未启动，dock区中的应用从bms取不到信息，也要加载出来
      if (DeliverUtil.isContainerItem(appItemInfo.intent)) {
        appItemInfo.codePath = String(NumberConstants.CONSTANT_NUMBER_ONE);
        AppModel.getInstance().setAppListByDelivery(appItemInfo);
        return appItemInfo;
      }
      if (isFromResident) {
        // 未安装非占位应用从数据库中删除
        await RdbStoreManager.getInstance()
          .deleteInfoByBundle(appItemInfo.bundleName, appItemInfo.typeId, appItemInfo.appIndex, false);
      }
      return null;
    }
    return this.buildDockItemByAppInfo(appItemInfo, index, appDataFromSystem);
  }

  /**
   * 通过appItemInfo构建dockItemInfo
   * @param appItemInfo
   * @param appDataFromSystem
   * @returns
   */
  private buildDockItemByAppInfo(appItemInfo: DockItemInfo, index: number, appDataFromSystem: AppItemInfo): DockItemInfo {
    let dockItemInfo = new DockItemInfo();
    dockItemInfo.itemType = appItemInfo.itemType;
    dockItemInfo.typeId = appItemInfo.itemType;
    dockItemInfo.editable = appItemInfo.editable;
    dockItemInfo.appId = appItemInfo.appId;
    dockItemInfo.shortcutId = appItemInfo.shortcutId;
    dockItemInfo.intent = appItemInfo.intent;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.codePath = appItemInfo?.codePath;
    dockItemInfo.intent = appItemInfo?.intent;
    dockItemInfo.row = 0;
    dockItemInfo.column = index;
    dockItemInfo.area = [1, 1];
    this.fillDockItemByAppInfo(dockItemInfo, appDataFromSystem);
    return dockItemInfo;
  }

  /**
   * 填充基础数据
   * @param itemInfo
   * @param appDataFromSystem
   */
  public fillDockItemByAppInfo(itemInfo: DockItemInfo | GridLayoutItemInfo, appDataFromSystem: AppItemInfo): void {
    itemInfo.appName = appDataFromSystem.appName;
    itemInfo.bundleName = appDataFromSystem.bundleName;
    itemInfo.moduleName = appDataFromSystem.moduleName;
    itemInfo.abilityName = appDataFromSystem.abilityName;
    itemInfo.appIndex = appDataFromSystem.appIndex;
    itemInfo.appIconId = appDataFromSystem.appIconId;
    itemInfo.appLabelId = appDataFromSystem.appLabelId;
    itemInfo.applicationLabelId = appDataFromSystem.applicationLabelId;
    itemInfo.applicationName = appDataFromSystem.applicationName;
    itemInfo.installTime = appDataFromSystem.installTime;
    itemInfo.appStatus = appDataFromSystem.appStatus;
    itemInfo.isUninstallAble = appDataFromSystem.isUninstallAble;
    itemInfo.badgeNumber = appDataFromSystem.badgeNumber;
    itemInfo.enableNewAppInstance = appDataFromSystem.enableNewAppInstance;
    itemInfo.isSystemApp = appDataFromSystem.isSystemApp;
    itemInfo.keyName = DockItemInfo.getKeyName(itemInfo);
    log.showWarn(`dockItem info: keyName: ${itemInfo.keyName}, appStatus: ${itemInfo.appStatus}`);
  }

  /**
   * 处理dock icon
   * @param dockItemInfo
   * @param keyNameSet
   * @param residentList
   * @returns
   */
  private async dealDockIcon(dockItemInfo: DockItemInfo, keyNameSet: Set<string>,
    residentList: DockItemInfo[]): Promise<void> {
    if (keyNameSet.has(dockItemInfo.keyName ?? '')) {
      log.showWarn(`dockItemInfo already has ${dockItemInfo.keyName},bundleName: ${dockItemInfo.bundleName}`);
      await RdbStoreManager.getInstance().deleteInfoByBundle(dockItemInfo.bundleName, dockItemInfo.typeId, dockItemInfo.appIndex, false);
    } else {
      keyNameSet.add(dockItemInfo.keyName ?? '');
      residentList.push(dockItemInfo);
    }
  }

  /**
   * 创建dock区folder元素
   *
   * @param dockItemInfo 待赋值的dock区元素
   * @param appItemInfo 数据库或缓存中取出的元素
   * @param index 位置信息
   * @returns Promise
   */
  private async createDockFolderInfo(dockItemInfo: DockItemInfo, appItemInfo: DockItemInfo, index: number, tableName?: string): Promise<void> {
    dockItemInfo.typeId = appItemInfo.typeId;
    dockItemInfo.appId = appItemInfo.appId;
    dockItemInfo.itemType = appItemInfo.itemType;
    dockItemInfo.editable = appItemInfo.editable;
    dockItemInfo.moduleName = appItemInfo.moduleName;
    dockItemInfo.abilityName = appItemInfo.abilityName;
    dockItemInfo.appIconId = appItemInfo.appIconId;
    dockItemInfo.appLabelId = appItemInfo.appLabelId;
    dockItemInfo.applicationLabelId = appItemInfo.applicationLabelId;
    dockItemInfo.appName = appItemInfo.appName;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    //文件夹拖入dock内appid缺失，新建dockItem文件夹无法识别，dock文件夹统一使用keyname标识.
    dockItemInfo.bundleName = appItemInfo.keyName ?? appItemInfo.appId ?? '';
    dockItemInfo.keyName = appItemInfo.keyName ?? appItemInfo.appId;
    dockItemInfo.layoutInfo = appItemInfo.layoutInfo;
    await this.dealDockFolderAppInfo(dockItemInfo, tableName);
    dockItemInfo.area = [1, 1];
    dockItemInfo.row = 0;
    dockItemInfo.column = index;
    let badgeNumber: number = 0;
    if (dockItemInfo.layoutInfo) {
      for (const folderItemLayoutInfoList of dockItemInfo.layoutInfo) {
        for (const gridLayoutItemInfo of folderItemLayoutInfoList) {
          badgeNumber = badgeNumber + (gridLayoutItemInfo.badgeNumber ?? 0);
        }
      }
    }
    dockItemInfo.badgeNumber = badgeNumber;
    dockItemInfo.intent = appItemInfo.intent;
    dockItemInfo.id = appItemInfo.id;
  }

  /**
   * 处理文件夹内的应用信息
   *
   * @param dockItemInfo  dock区文件夹信息
   * @param tableName 表名
   * @returns Promise
   */
  private async dealDockFolderAppInfo(dockItemInfo: DockItemInfo, tableName?: string): Promise<void> {
    if (!dockItemInfo.layoutInfo) {
      return;
    }
    for (let i = 0; i < dockItemInfo.layoutInfo.length; i++) {
      dockItemInfo.layoutInfo[i] = GetHideAppsFromConfig.getInstance().filterHideApp(dockItemInfo.layoutInfo[i]);
      await this.dealDockFolderPageAppInfo(dockItemInfo.layoutInfo[i], tableName);
    }
  }

  private async dealDockFolderPageAppInfo(page: GridLayoutItemInfo[], tableName?: string): Promise<void> {
    for (let index = 0; index < page.length; index++) {
      let item = page[index];
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.updateShortcut(item);
        continue;
      }
      const appData = await launcherAbilityManager.getAppInfoByBundleName(item.bundleName, '', item.appIndex);
      if (CheckEmptyUtils.isEmpty(appData) && !PreInstallUtils.checkIsNeedInstallApp(item)) {
        // Deliver应用开机查不到先缓存
        if (DeliverUtil.isContainerItem(item.intent) && item.appStatus === AppStatus.INSTALLED) {
          let appItemInfo: AppItemInfo = item as AppItemInfo;
          appItemInfo.codePath = String(NumberConstants.CONSTANT_NUMBER_ONE);
          AppModel.getInstance().setAppListByDelivery(appItemInfo);
        }
        continue;
      }
      // 记录原始状态
      let oldStatus = item.appStatus;
      const isNeedInstallApp = CheckEmptyUtils.isEmpty(appData) && PreInstallUtils.checkIsNeedInstallApp(item);
      // 刷新dock区小文件夹图标id
      item.bundleName = typeof (appData) === 'undefined' ? item.bundleName : appData.bundleName;
      item.moduleName = typeof (appData) === 'undefined' ? item.moduleName : appData.moduleName;
      item.abilityName = typeof (appData) === 'undefined' ? item.abilityName : appData.abilityName;
      item.appIndex = typeof (appData) === 'undefined' ? item.appIndex : appData.appIndex;
      item.appName = typeof (appData) !== 'undefined' && item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON ? appData.appName : item.appName;
      item.appStatus = isNeedInstallApp ? AppStatus.PENDING : AppStatus.INSTALLED;
      item.iconResource = isNeedInstallApp ? item.iconResource : '';
      item.downloadProgress = 0;
      if (item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
        item.appIconId = typeof (appData) === 'undefined' ? item.appIconId : appData.appIconId;
        item.appLabelId = typeof (appData) === 'undefined' ? item.appLabelId : appData.appLabelId;
        item.isUninstallAble = typeof (appData) === 'undefined' ? item.isUninstallAble : appData.isUninstallAble;
        item.keyName = typeof (appData) === 'undefined' ? item.keyName : DockItemInfo.getKeyName(appData);
      }
      await BadgeManager.getInstance().getBadgeDisplayNumberByBundleSync(item as BaseBundleInfo).then(badgeNumber => {
        item.badgeNumber = badgeNumber;
      });
      // 如果原始状态不是已安装
      if (!this.isInstalledStatus(oldStatus)) {
        log.showInfo(`system keyName:${item.keyName}, appIconId:${item.appIconId}, appLabelId:${item.appLabelId}`);
        RdbStoreManager.getInstance().updateNewInstalledGridInfo(item, false, tableName);
      }
    }
  }

  private isInstalledStatus(status: number | undefined): boolean {
    if (CheckEmptyUtils.isEmpty(status)) {
      return true;
    }
    return status === AppStatus.INSTALLED;
  }

  /**
   * 处理dock文件夹
   * @param dockItemInfo
   * @param residentList
   * @returns
   */
  private async dealDockFolder(dockItemInfo: DockItemInfo, residentList: DockItemInfo[]): Promise<void> {
    if (dockItemInfo.layoutInfo && dockItemInfo.layoutInfo.length > 0 &&
      (DeliverUtil.checkFolderIsOneMoreApps(dockItemInfo.appId, dockItemInfo.layoutInfo[0].length) ||
      NotHarmonyUtil.isNotHarmonyFolderHasOneOrMoreApp(dockItemInfo.appId, dockItemInfo.layoutInfo[0].length))) {
      DockUtils.formatFolderInfo(dockItemInfo);
      residentList.push(dockItemInfo);
      log.showInfo(`the residentList is ${JSON.stringify(residentList)}`);
    } else {
      RdbStoreManager.getInstance().deleteItemByInfoId(dockItemInfo.appId ?? '', false);
      FolderDataModelManager.getInstance().deleteFolderInMap(dockItemInfo.appId ?? '');
      SmallFolderIconFileUtil.deleteFolderIcon(dockItemInfo.appId ?? '');
      if (dockItemInfo.layoutInfo?.length === 1 && dockItemInfo.layoutInfo[0]?.length === 1) {
        let dockItem: DockItemInfo | null = await this.createDockAppInfoByLayoutInfo(dockItemInfo);
        if (dockItem) {
          residentList.push(dockItem);
        }
      }
    }
  }

  /**
   * 创建dockappinfo
   * @param dockItemFolderInfo
   * @returns
   */
  async createDockAppInfoByLayoutInfo(dockItemFolderInfo: DockItemInfo): Promise<DockItemInfo | null> {
    if (!dockItemFolderInfo.layoutInfo ||
      (dockItemFolderInfo.layoutInfo.length !== 1 && dockItemFolderInfo.layoutInfo[0].length !== 1)) {
      log.showError('dockItemFolderInfo dose not have element');
      return null;
    }
    let dockGridLayoutItemInfo: GridLayoutItemInfo = dockItemFolderInfo.layoutInfo[0][0];
    let dockItemInfo: DockItemInfo = new DockItemInfo();
    dockItemInfo.itemType = dockGridLayoutItemInfo.typeId;
    dockItemInfo.typeId = dockGridLayoutItemInfo.typeId;
    dockItemInfo.appId = dockGridLayoutItemInfo.infoId;
    dockItemInfo.shortcutId = dockGridLayoutItemInfo.shortcutId;
    dockItemInfo.intent = dockGridLayoutItemInfo.intent;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.row = 0;
    dockItemInfo.area = [1, 1];
    dockItemInfo.column = dockItemFolderInfo.column;
    let appDataFromSystem: AppItemInfo | undefined = await launcherAbilityManager.getAppInfoByBundleName(
      dockGridLayoutItemInfo.bundleName, '', dockGridLayoutItemInfo.appIndex);
    if (!appDataFromSystem) {
      log.showWarn('createDockAppInfo appDataFromSystem is empty');
      // 重启后dh未启动，dock区中的应用从bms取不到信息，也要加载出来
      if (DeliverUtil.isContainerItem(dockItemInfo.intent) && dockItemInfo.appStatus === AppStatus.INSTALLED) {
        dockItemInfo.codePath = String(NumberConstants.CONSTANT_NUMBER_ONE);
        AppModel.getInstance().setAppListByDelivery(dockItemInfo);
        return dockItemInfo;
      }
      return null;
    }
    this.fillDockItemByAppInfo(dockItemInfo, appDataFromSystem);
    return dockItemInfo;
  }

  /**
   * 创建dock区其他元素
   *
   * @param dockItemInfo 待赋值的dock区元素
   * @param appItemInfo 数据库或缓存中取出的元素
   * @param index 位置信息
   * @returns Promise
   */
  private async createDockOtherInfo(dockItemInfo: DockItemInfo, appItemInfo: DockItemInfo, index: number): Promise<void> {
    dockItemInfo.itemType = appItemInfo.itemType;
    dockItemInfo.typeId = appItemInfo.typeId;
    dockItemInfo.editable = appItemInfo.editable;
    dockItemInfo.bundleName = appItemInfo.bundleName;
    dockItemInfo.moduleName = appItemInfo.moduleName;
    dockItemInfo.abilityName = appItemInfo.abilityName;
    dockItemInfo.appIndex = appItemInfo.appIndex;
    dockItemInfo.keyName = DockItemInfo.getKeyName(appItemInfo);
    dockItemInfo.appIconId = appItemInfo.appIconId;
    dockItemInfo.appLabelId = appItemInfo.appLabelId;
    dockItemInfo.applicationLabelId = appItemInfo.applicationLabelId;
    const loadAppName = await IconResourceManager.getInstance().getAppName(dockItemInfo.appLabelId,
      dockItemInfo.bundleName, dockItemInfo.moduleName, '');
    const loadApplicationName = await IconResourceManager.getInstance().getAppName(dockItemInfo.applicationLabelId,
      dockItemInfo.bundleName, dockItemInfo.moduleName, '');
    dockItemInfo.appName = loadAppName;
    dockItemInfo.applicationName = loadApplicationName;
    dockItemInfo.column = index;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
  }

  /**
   * 创建dockrecentappInfo
   * @returns
   */
  private createDockRecentAppInfo(): DockItemInfo {
    let dockItemInfo = new DockItemInfo();
    dockItemInfo.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    dockItemInfo.abilityName = CommonConstants.RECENT_ABILITY;
    dockItemInfo.typeId = 0;
    dockItemInfo.itemType = CommonConstants.TYPE_FUNCTION;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.appIndex = 0;
    dockItemInfo.keyName = CommonConstants.LAUNCHER_BUNDLE + CommonConstants.RECENT_ABILITY;
    return dockItemInfo;
  }

  /**
   * 与包管理快捷方式对比，更新快捷图标信息
   *
   * @param dockItemInfo 待赋值的dock区元素
   * @param index 位置信息
   */
  private updateShortcut(dockItemInfo: GridLayoutItemInfo | DockItemInfo, index?: number): void {
    let shortcutInfoList: ShortcutInfo[] | undefined =
      AppModel.getInstance().getAllShortcutInfo(dockItemInfo.bundleName);
    if (!shortcutInfoList) {
      shortcutInfoList = launcherAbilityManager.getShortcutInfoByBundleNameSync(dockItemInfo.bundleName);
      AppModel.getInstance().setShortcutInfo(dockItemInfo.bundleName, shortcutInfoList);
    }
    let shortcut: ShortcutInfo | undefined = shortcutInfoList.find(shortcut => shortcut.id === dockItemInfo.shortcutId);
    if (shortcut) {
      dockItemInfo.appIconId = shortcut.iconId ?? 0;
      dockItemInfo.appLabelId = shortcut.labelId;
      dockItemInfo.appName = '';
      dockItemInfo.badgeNumber = 0;
      dockItemInfo.keyName = DockItemInfo.getKeyName(dockItemInfo);
      // in Dock
      if (index !== undefined) {
        dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
        dockItemInfo.row = 0;
        dockItemInfo.column = index;
        dockItemInfo.area = [1, 1];
      } else {
        // in Dock Folder
        dockItemInfo.appStatus = AppStatus.INSTALLED;
        dockItemInfo.iconResource = '';
        dockItemInfo.downloadProgress = 0;
      }
    }
  }

  /**
   * 刷新resident list
   * @returns
   */
  async refreshDockResidentList(): Promise<void> {
    let residentList = new Array<DockItemInfo>();
    const dockDataList = this.getAllDockItems();
    let paramStart = DockUtils.getPrintParam(dockDataList);
    log.showInfo(`refresh before getResidentList: ${paramStart}`);
    for (let i = 0; i < dockDataList.length; i++) {
      if (SCBSceneSessionManager.getInstance().isPcMode() && dockDataList[i]?.abilityName === CommonConstants.RECENT_ABILITY) {
        residentList.unshift(dockDataList[i]);
      } else if (GridLayoutUtil.isIconType(dockDataList[i].itemType)) {
        let dockItemInfo = await this.createDockAppInfo(dockDataList[i], i, true);
        if (!dockItemInfo) {
          continue;
        }
        residentList.push(dockItemInfo);
      } else if (dockDataList[i].itemType === CommonConstants.TYPE_CARD) {
      } else if (dockDataList[i].itemType === CommonConstants.TYPE_FOLDER) {
        const dockItemInfo = new DockItemInfo();
        await this.createDockFolderInfo(dockItemInfo, dockDataList[i], i);
        let itemInfoParam = DockUtils.getPrintDockParam(dockItemInfo);
        log.showInfo(`the fold dockItemInfo is ${itemInfoParam}`);
        if (dockItemInfo.layoutInfo && dockItemInfo.layoutInfo.length > 0 &&
          (DeliverUtil.checkFolderIsOneMoreApps(dockItemInfo.appId, dockItemInfo.layoutInfo[0].length) ||
          NotHarmonyUtil.isNotHarmonyFolderHasOneOrMoreApp(dockItemInfo.appId, dockItemInfo.layoutInfo[0].length))) {
          residentList.push(dockItemInfo);
        } else {
          RdbStoreManager.getInstance().deleteItemByInfoId(dockItemInfo.appId ?? '', false);
          SmallFolderIconFileUtil.deleteFolderIcon(dockItemInfo.appId ?? '');
        }
      } else {
        const dockItemInfo = new DockItemInfo();
        await this.createDockOtherInfo(dockItemInfo, dockDataList[i], i);
        residentList.push(dockItemInfo);
      }
    }
    // update dock Items
    this.updateAllDockItems(TAG.concat('_refresh'), residentList);
  }
}