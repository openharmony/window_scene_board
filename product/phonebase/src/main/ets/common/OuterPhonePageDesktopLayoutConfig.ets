/**
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

import { GlobalContext, IconResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import { AnimateToScheduleUtils, CheckEmptyUtils, FileUtils, LogDomain, LogHelper,
  SingleContext,
  singleManager} from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  AppItemInfo,
  AppModel,
  AppStatus,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DockItemInfo,
  EventConstants,
  FolderLayoutCacheManager,
  FormLayoutCacheManager,
  FormModel,
  CommonDockModel,
  GetLayoutInfoFromConfig,
  GridLayoutItemInfo,
  launcherAbilityManager,
  ContactCacheManager,
  LaunchLayoutCacheManager,
  layoutLockUtil,
  PageDesktopLayoutConfig,
  RdbStoreManager,
  LauncherLayoutCacheUtil,
  PageInfoManager,
  PreInstallUtils
} from '@ohos/launchercommon';
import { DesktopLayoutCacheData } from '@ohos/launchercommon/src/main/ets/cache/layout/DesktopLayoutCacheData';
import { BundleChangeCorrector } from '@ohos/launchercommon/src/main/ets/db/gridlayoutcorrector/BundleChangeCorrector';
import { gridLayoutCorrector } from '@ohos/launchercommon/src/main/ets/db/gridlayoutcorrector/GridLayoutCorrectorChain';
import lazy { PreviewLayoutCheckTool } from '@ohos/launchercommon/src/main/ets/tools/PreviewLayoutCheckTool';
import PhoneDesktopLayoutInfo from './configs/PhoneDesktopLayoutInfo';
import {
  GridLayoutDBMapReplaceCorrectorBuilder
} from '@ohos/launchercommon/src/main/ets/db/gridlayoutcorrector/GridLayoutDBMapReplaceCorrector';
import { CardNodeControllerManager } from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';

const TAG = 'OuterPhonePageDesktopLayoutConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const OUTER_PRELOAD_CHECK_NAME = 'outer';

export default class OuterPhonePageDesktopLayoutConfig extends PageDesktopLayoutConfig {
  public static singleName: string = 'OuterPhonePageDesktopLayoutConfig';
  public mGridLayoutInfo: DefaultDesktopLayoutInfo = PhoneDesktopLayoutInfo.PHONE_LAYOUT_INFO;

  private mOuterGridLayoutInfo: DefaultDesktopLayoutInfo = PhoneDesktopLayoutInfo.OUT_PHONE_LAYOUT_INFO;

  private layoutData?: DesktopLayoutCacheData;

  private static readonly DEFAULT_CARD_ID: string = '0';
  private static outerInstance: OuterPhonePageDesktopLayoutConfig;

  static self: OuterPhonePageDesktopLayoutConfig;
  public getLayoutInfoFromConfig: GetLayoutInfoFromConfig;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.getLayoutInfoFromConfig = singleManager.get<GetLayoutInfoFromConfig>(GetLayoutInfoFromConfig, ctx);
  }

  /**
   * PhoneLauncherLayoutStyleConfig of instance
   */
  public static getInstance(ctx?: SingleContext): OuterPhonePageDesktopLayoutConfig {
    return singleManager.get<OuterPhonePageDesktopLayoutConfig>(OuterPhonePageDesktopLayoutConfig, ctx);
  }

  public getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }

  public getPersistConfigJson(isOuter?: boolean): string {
    let showOuter = isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    if (!showOuter) {
      return JSON.stringify(this.mGridLayoutInfo);
    } else {
      return JSON.stringify(this.mOuterGridLayoutInfo);
    }
  }

  /**
   * load configuration.
   */
  private getPersistConfig(isOuter: boolean): DefaultDesktopLayoutInfo {
    let defaultConfig = this.getPersistConfigJson(isOuter);
    return JSON.parse(defaultConfig);
  }

  /**
   * Update workspace layout data.
   *
   * @params gridLayoutInfo
   */
  updateGridLayoutInfo(gridLayoutInfo: DefaultDesktopLayoutInfo): void {
    log.showInfo('updateGridLayoutInfo ' + gridLayoutInfo?.layoutInfo?.length);
    FileUtils.writeStringToFile(JSON.stringify(gridLayoutInfo), this.getConfigFileAbsPath());
    launcherStatusUtil.getShowOutLauncherStatus() ? this.mOuterGridLayoutInfo.layoutInfo = gridLayoutInfo.layoutInfo :
      this.mGridLayoutInfo.layoutInfo = gridLayoutInfo.layoutInfo;
  }

  /**
   * Update LayoutDescription
   * @param gridLayoutInfo
   */
  updateLayoutDescription(gridLayoutInfo: DefaultDesktopLayoutInfo): void {
    log.showInfo(`updateLayoutDescription, pageCount:${gridLayoutInfo.layoutDescription.pageCount}`);
    const temp = gridLayoutInfo;
    FileUtils.writeStringToFile(JSON.stringify(temp), this.getConfigFileAbsPath());
    if (!launcherStatusUtil.getShowOutLauncherStatus()) {
      this.mGridLayoutInfo.layoutDescription = gridLayoutInfo.layoutDescription;
      RdbStoreManager.getInstance().updateSettings(desktopUtil.getPageCount(), temp.layoutDescription.pageCount);
    } else {
      this.mOuterGridLayoutInfo.layoutDescription = gridLayoutInfo.layoutDescription;
      RdbStoreManager.getInstance().updateSettings(desktopUtil.getPageCount(), temp.layoutDescription.pageCount);
    }
  }

  /**
   * Get workspace layout data
   *
   * @return Workspace layout data
   */
  getGridLayoutInfo(): DefaultDesktopLayoutInfo {
    if (this.layoutData) {
      return this.layoutData.getGridLayoutInfo();
    }
    return launcherStatusUtil.getShowOutLauncherStatus() ? this.mOuterGridLayoutInfo : this.mGridLayoutInfo;
  }

  /**
   * load configuration
   */
  async loadPersistConfig(): Promise<void> {
    log.showInfo('loadPersistConfig start');
    await PreInstallUtils.initNeedInstallAppCache();
    AnimateToScheduleUtils.stopBootGCPriority();
    let defaultConfig = this.getPersistConfig(false);
    let outerDefaultConfig = this.getPersistConfig(true);

    const result = await Promise.all([
      RdbStoreManager.getInstance().querySettingsPageCount(false),
      RdbStoreManager.getInstance().queryGridLayoutInfo(false),
    ]);
    let pageCount = result[0];
    let configFromRdb = result[1];
    IconResourceManager.getInstance().checkSystemStateAndVersion();
    if (pageCount) {
      defaultConfig.layoutDescription.pageCount = pageCount;
      this.mGridLayoutInfo = defaultConfig;
    }
    const outerResult = await Promise.all([
      RdbStoreManager.getInstance().querySettingsPageCount(true),
      RdbStoreManager.getInstance().queryGridLayoutInfo(true),
    ]);
    let outerPageCount = outerResult[0];
    let outerConfigFromRdb = outerResult[1];
    let rdbStartVersion = RdbStoreManager.getInstance().getRdbStartVersion();
    let rdbLatestVersion = RdbStoreManager.getInstance().getRdbLatestVersion();
    log.showWarn(`loadPersistConfig -> RdbStoreManager.pageCount: ${pageCount}, configFromRdb.length: ${configFromRdb.length},
    RdbStoreManager.outerPageCount: ${outerPageCount}, outerconfigFromRdb.length: ${outerConfigFromRdb.length},
    rdbVersion:  ${rdbStartVersion} -> ${rdbLatestVersion}`);
    if ((configFromRdb && configFromRdb.length > 0) || (configFromRdb && this.isConfigExist() && rdbStartVersion > 0)) {
      let dockDataList: DockItemInfo[] = await CommonDockModel.getInstance().querySmartDock(false);
      let installedApps: AppItemInfo[] =
        await launcherAbilityManager.getLauncherAbilityList(launcherAbilityManager.getUserId());

      // 桌面脏数据矫正清理
      gridLayoutCorrector.initCorrectorChain();
      await GridLayoutDBMapReplaceCorrectorBuilder.getInstance()
        .outerPhonePageDesktopMapReplaceCorrector(configFromRdb, dockDataList, outerConfigFromRdb);
      gridLayoutCorrector.addGridLayoutCorrector(new BundleChangeCorrector(installedApps, dockDataList));
      gridLayoutCorrector.handleData(configFromRdb, false);

      configFromRdb = await this.filterDbListByInstalled(configFromRdb, installedApps, false);
      log.showWarn(`loadPersistConfig ->  filterDbListByInstalled configFromRdb.length: ${configFromRdb.length}`);
      defaultConfig.layoutInfo = configFromRdb;
      this.mGridLayoutInfo = defaultConfig;

      // outer query
      if (outerPageCount) {
        outerDefaultConfig.layoutDescription.pageCount = outerPageCount;
        this.mOuterGridLayoutInfo = outerDefaultConfig;
      }
      gridLayoutCorrector.handleData(outerConfigFromRdb, true);
      gridLayoutCorrector.clearCorrectorChain();
      outerConfigFromRdb = await this.filterDbListByInstalled(outerConfigFromRdb, installedApps, true);
      outerConfigFromRdb = await this.filterOuterDbList(configFromRdb, outerConfigFromRdb);
      outerDefaultConfig.layoutInfo = outerConfigFromRdb;
      this.mOuterGridLayoutInfo = outerDefaultConfig;

      this.initLayoutCache();
      ContactCacheManager.getInstance().checkToAddContactShortcut(dockDataList);
      localEventManager.sendLocalEvent(EventConstants.EVENT_LAYOUT_INIT_FINISHED, null);
      log.showInfo('loadPersistConfig end');

      // 重启加载桌面布局后，异步刷新桌面布局表中的图标名称信息
      AppModel.getInstance().updateInfoNameOfApp(false, true);
      AppModel.getInstance().updateInfoNameOfApp(false, false);
      layoutLockUtil.init();
    } else {
      this.addPreloadLayoutPromiseEvent();
      // 数据库没有创建，第一次加载数据从配置文件夹中进行
      this.getLayoutInfoFromConfig.registerGetLayoutInfoCallback(() => {
        this.loadDataFromConfiguration(pageCount);
      });
      log.showInfo(`rdbStore version:${RdbStoreHelper.getInstance().getRdbStore()?.version}`);
    }
  }

  protected addPreloadLayoutPromiseEvent(): void {
    super.addPreloadLayoutPromiseEvent();
    PreviewLayoutCheckTool.getInstance().addPromiseEvent(OUTER_PRELOAD_CHECK_NAME);
  }

  public async loadDataFromConfiguration(pageCount: number): Promise<void> {
    AppModel.getInstance().initIconNameCache();
    await this.loadLayoutInfoFromConfig(pageCount);
    await this.loadOuterLayoutInfoFromConfig(pageCount);
    this.initLayoutCache();
    ContactCacheManager.getInstance().checkToAddContactShortcut();
    localEventManager.sendLocalEvent(EventConstants.EVENT_LAYOUT_INIT_FINISHED, null);
    log.showInfo(`loadLayoutInfoFromConfig -> end this.mGridLayoutInfo.layoutInfo.length : ${JSON.stringify(this
      .mGridLayoutInfo.layoutInfo.length)}`);
  }

  private async filterOuterDbList(configFromRdb: GridLayoutItemInfo[], dbList: GridLayoutItemInfo[]):
    Promise<GridLayoutItemInfo[]> {
    let outerConfigFromRdb = dbList?.filter(item => {
      if (LauncherLayoutCacheUtil.isOuterFormOutOfLayoutBound(item, true)) {
        log.showWarn(`this is out of layout bound app, bundleName : ${item?.bundleName}, cardId : ${item?.cardId}`);
        RdbStoreManager.getInstance().deleteFormInfoById(item?.cardId, true);
        return false;
      }
      return true;
    });
    outerConfigFromRdb.forEach(outerLayout => {
      if (outerLayout.typeId === CommonConstants.TYPE_CARD &&
        !FormModel.getInstance().isCardIdInvalid(outerLayout.cardId) &&
      FormModel.getInstance().existCardId(outerLayout.cardId, configFromRdb)) {
        log.showWarn(`find same cardId: ${outerLayout.cardId} bundle: ${outerLayout.bundleName}`);
        outerLayout.cardId = OuterPhonePageDesktopLayoutConfig.DEFAULT_CARD_ID;
      } else if (outerLayout.typeId === CommonConstants.TYPE_FOLDER) {
        log.showWarn(`filterOuterDbList delete invalid folder infoId: ${outerLayout.infoId}`);
        RdbStoreManager.getInstance().deleteItemByInfoId(outerLayout.infoId, true);
      }
    });
    return outerConfigFromRdb;
  }

  private async loadOuterLayoutInfoFromConfig(pageCount: number): Promise<void> {
    // outer desktop
    let outerDefaultLayoutInfoFromFile: DefaultDesktopLayoutInfo | null = await this.getOuterAllLayoutConfigFile();
    if (outerDefaultLayoutInfoFromFile) {
      this.mOuterGridLayoutInfo.layoutInfo = outerDefaultLayoutInfoFromFile.layoutInfo;
      let outerCount = outerDefaultLayoutInfoFromFile?.layoutDescription?.pageCount;
      if (outerCount === undefined || outerCount === null) {
        outerCount = pageCount;
      }
      this.mOuterGridLayoutInfo.layoutDescription.pageCount = Math.max(outerCount, 0);
    }
    log.showInfo(`loadLayoutInfoFromConfig -> start this.mOuterGridLayoutInfo.layoutInfo.length : ${JSON.stringify(this
      .mOuterGridLayoutInfo.layoutInfo.length)}`);

    // 筛选出正确的数据
    if (this.mOuterGridLayoutInfo && this.mOuterGridLayoutInfo.layoutInfo) {
      // 过滤dock区图标
      this.mOuterGridLayoutInfo.layoutInfo = this.mOuterGridLayoutInfo.layoutInfo.filter(item => {
        return item.container !== CommonConstants.CONTAINER_SMARTDOCK;
      });

    }
    AppModel.getInstance().getAppList(() => {
      this.checkAppOuterList();
    });
  }

  protected initLayoutCache(): void {
    this.layoutData = new DesktopLayoutCacheData(this.mGridLayoutInfo);
    this.layoutData.setGridLayoutInfo(this.mOuterGridLayoutInfo, true);
    this.layoutData.setGridLayoutItemList(this.mOuterGridLayoutInfo.layoutInfo, true);
    if (this.layoutData) {
      LaunchLayoutCacheManager.getInstance().reInit(this.layoutData);
      FormLayoutCacheManager.getInstance().reInit(this.layoutData);
      FolderLayoutCacheManager.getInstance().reInit(this.layoutData);
    }
    super.persistConfig();
  }


  private checkAppOuterList(): void {
    // 获取系统所有图标集合
    const totalAppInfoList = AppModel.getInstance().getAppList();

    this.mOuterGridLayoutInfo.layoutInfo = this.mOuterGridLayoutInfo.layoutInfo.filter(item => {
      if (item.typeId !== CommonConstants.TYPE_APP) {
        return true;
      }
      item.keyName = AppItemInfo.getKeyName(item);
      for (const appInfo of totalAppInfoList) {
        if (item.keyName === appInfo.keyName) {
          item.appStatus = AppStatus.INSTALLED;
          return true;
        }
      }
      // 加载预制布局场景DFX相关能力:应用包名配置正确，类名配置错误，加载完成后，该图标仍正常出现在预期位置，且可以正常打开应用
      let existAppInfo = AppModel.getInstance().getAppInfoByKeyName(item.keyName);
      if (typeof existAppInfo !== 'undefined') {
        item.appStatus = AppStatus.INSTALLED;
        this.complementAppInfo(item, existAppInfo); // 根据系统图标数据补全配置文件中图标数据
        return true;
      }
      return false;
    });
    // 绑定文件夹和文件夹里图标的关系
    this.bindOuterAppAndFolder();
    // 首次加载预置布局后，异步刷新桌面布局表中的图标名称信息
    AppModel.getInstance().updateInfoNameOfApp(false, true);

  }

  private bindOuterAppAndFolder(): void {
    log.showInfo('bindOuterAppAndFolder -> start!');
    let layoutInfoItems: GridLayoutItemInfo[] = this.mOuterGridLayoutInfo?.layoutInfo;
    // 将id赋值给缓存，进行绑定文件夹和文件夹里面图标的关系
    layoutInfoItems.forEach((item) => {
      item.infoId = RdbStoreManager.getInstance().generateRandomUUID(true);
    });
    let promise = RdbStoreManager.getInstance().insertGridLayoutInfo(layoutInfoItems, true, true);
    promise.then((res) => {
      if (res) {
        PreviewLayoutCheckTool.getInstance().startCheck(OUTER_PRELOAD_CHECK_NAME);
        log.showInfo('bindOuterAppAndFolder -> insertGridLayoutResult ok!');
      } else {
        log.showInfo('bindOuterAppAndFolder -> insertGridLayoutResult fail!');
      }
    });
  }

  /**
   * 获取预制的外屏布局文件
   *
   * @returns 布局信息
   */
  protected async getOuterAllLayoutConfigFile(): Promise<DefaultDesktopLayoutInfo | null> {
    return this.getLayoutInfoFromConfig.getOuterAllLayoutConfigFile();
  }

  /**
   * refreshLayout After backup recover
   * @returns Promise<void>
   */
  public async refreshLayoutAfterRecover(): Promise<void> {
    // 克隆完成后，查询前先清除缓存
    log.showInfo(`refreshLayoutAfterRecover start`);
    GlobalContext.getInstance().setObject('backupStatus', true);
    const result = await Promise.all([
      RdbStoreManager.getInstance().querySettingsPageCount(false),
      RdbStoreManager.getInstance().queryGridLayoutInfo(false),
    ]);
    let pageCount = result[0];
    let configFromRdb = result[1];
    if (pageCount) {
      this.mGridLayoutInfo.layoutDescription.pageCount = pageCount;
      PageInfoManager.getInstance().updatePageCount(pageCount, 'refreshLayoutAfterRecover', false);
    }
    const outerResult = await Promise.all([
      RdbStoreManager.getInstance().querySettingsPageCount(true),
      RdbStoreManager.getInstance().queryGridLayoutInfo(true),
    ]);
    let outerPageCount = outerResult[0];
    let outerConfigFromRdb = outerResult[1];
    if (outerPageCount) {
      this.mOuterGridLayoutInfo.layoutDescription.pageCount = outerPageCount;
      PageInfoManager.getInstance().updatePageCount(outerPageCount, 'refreshLayoutAfterRecover', true);
    }
    if (configFromRdb && configFromRdb.length > 0) {
      this.mGridLayoutInfo.layoutInfo = [...configFromRdb];
      this.mGridLayoutInfo.layoutInfo.forEach(item => {
        if (!CheckEmptyUtils.isEmpty(item.layoutInfo)) {
          let date: string = String(new Date());
          item.formRefreshDate = date;
        }
      });
      this.mOuterGridLayoutInfo.layoutInfo = [...outerConfigFromRdb];
      this.mOuterGridLayoutInfo.layoutInfo.forEach(item => {
        if (!CheckEmptyUtils.isEmpty(item.layoutInfo)) {
          let date: string = String(new Date());
          item.formRefreshDate = date;
        }
      });
      this.initLayoutCache();
      let dockDataList: DockItemInfo[] = await RdbStoreManager.getInstance().querySmartDock(false);
      ContactCacheManager.getInstance().checkToAddContactShortcut(dockDataList);
      AppStorage.setOrCreate('isCloneStatus', true);
    }
  }
}