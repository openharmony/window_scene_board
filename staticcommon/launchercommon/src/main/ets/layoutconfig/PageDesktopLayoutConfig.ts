/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  AnimateToScheduleUtils,
  CheckEmptyUtils,
  OutdoorConfig,
  FileUtils,
  LogDomain,
  LogHelper,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import {
  DeviceHelper,
  GlobalContext,
  IconResourceManager,
  localEventManager,
  HiDfxEventUtil
} from '@ohos/frameworkwrapper';
import { ILayoutConfig } from './ILayoutConfig';
import { AppStatus, CommonConstants, DesktopLayoutState } from '../constants/CommonConstants';
import { AppModel } from '../model/AppModel';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { AppItemInfo } from '../bean/AppItemInfo';
import { EventConstants } from '../constants/EventConstants';
import { GetLayoutInfoFromConfig } from './GetLayoutInfoFromConfig';
import { launcherAbilityManager } from '../abilitymanager/LauncherAbilityManager';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import { DesktopLayoutCacheData } from '../cache/layout/DesktopLayoutCacheData';
import {
  CommonDockModel,
  ContactCacheManager,
  DeliverUtil,
  DesktopDataLoader,
  DockItemInfo,
  FolderLayoutCacheManager,
  FormLayoutCacheManager,
  LauncherLayoutCacheConfig,
  LaunchLayoutCacheManager,
  layoutLockUtil,
  NoIconAppModel,
  PadLaunchLayoutCacheManager,
  PageInfoManager,
  GetHideAppsFromConfig,
  FolderManager,
  FolderCommonUtil,
  SceneMsgEnum
} from '../TsIndex';
import { PreInstallUtils } from '../utils/PreInstallUtils';
import { gridLayoutCorrector } from '../db/gridlayoutcorrector/GridLayoutCorrectorChain';
import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import { BundleChangeCorrector } from '../db/gridlayoutcorrector/BundleChangeCorrector';
import { DirtyFormCorrector } from '../db/gridlayoutcorrector/DirtyFormCorrector';
import { GridLayoutDBMapReplaceCorrectorBuilder } from '../db/gridlayoutcorrector/GridLayoutDBMapReplaceCorrector';
import { CleanContactsDirtyIconCorrector } from '../db/gridlayoutcorrector/CleanContactsDirtyIconCorrector';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { LayoutViewModel } from '../viewmodel/LayoutViewModel';
import lazy { PreviewLayoutCheckTool } from '../tools/PreviewLayoutCheckTool';
import { LauncherStartup, StartupStep } from '../tools/LauncherStartup';
import { PageDesktopModel } from '../pagedesktop/model/PageDesktopModel';
import { ChangeAppStatusToPauseCorrector } from '../db/gridlayoutcorrector/DuplicatePositionCorrector';

const TAG = 'PageDesktopLayoutConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const PRELOAD_CHECK_NAME = 'default';

/**
 * Desktop workspace function layout configuration.
 */
export class PageDesktopLayoutConfig extends ILayoutConfig {
  public static singleName: string = 'PageDesktopLayoutConfig';

  /**
   * Workspace Feature Layout Configuration Index.
   */
  static GRID_LAYOUT_INFO = CommonConstants.GRID_LAYOUT_INFO;

  mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();

  private mIsPresetLayoutPersist: boolean = false;

  private mPresetCardUpdateCallBack: Function[] = [];

  private isRetailEnable: boolean = false;

  public getLayoutInfoFromConfig: GetLayoutInfoFromConfig;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.getLayoutInfoFromConfig = singleManager.get<GetLayoutInfoFromConfig>(GetLayoutInfoFromConfig, ctx);
    try {
      this.isRetailEnable = systemParameterEnhance.getSync('const.dfx.enable_retail', 'false') === 'true';
    } catch (err) {
      log.showError('systemParameterEnhance error %{public}d: %{public}s', err.code, err.message);
    }
  }

  /**
   * Get an instance of the workspace function layout configuration
   */
  static getInstance(ctx?: SingleContext): PageDesktopLayoutConfig {
    return singleManager.get<PageDesktopLayoutConfig>(PageDesktopLayoutConfig, ctx);
  }

  initConfig(): void {
    this.loadPersistConfig();
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_FUNCTION;
  }

  getConfigName(): string {
    return PageDesktopLayoutConfig.GRID_LAYOUT_INFO;
  }


  public getPersistConfigJson(): string {
    return JSON.stringify(this.mGridLayoutInfo);
  }

  /**
   * Update workspace layout data.
   *
   * @params gridLayoutInfo
   */
  updateGridLayoutInfo(gridLayoutInfo: DefaultDesktopLayoutInfo): void {
    log.showInfo('updateGridLayoutInfo ' + gridLayoutInfo?.layoutInfo?.length);
    FileUtils.writeStringToFile(JSON.stringify(gridLayoutInfo), this.getConfigFileAbsPath());
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
    this.mGridLayoutInfo.layoutDescription = gridLayoutInfo.layoutDescription;
    RdbStoreManager.getInstance().updateDesktopPageCount(temp.layoutDescription.pageCount);
  }

  /**
   * Get workspace layout data
   *
   * @return Workspace layout data
   */
  getGridLayoutInfo(): DefaultDesktopLayoutInfo {
    return this.mGridLayoutInfo;
  }

  /**
   * 更新桌面数据加载器
   *
   * @param desktopDataLoader
   */
  updateDesktopDataLoader(desktopDataLoader: DesktopDataLoader): void {
    this.mDesktopDataLoader = desktopDataLoader;
  }

  /**
   * 注册预置文件写入数据库更新后更新回调
   *
   * @param callBack 数据库回调操作
   */
  public registerPresetFinishedCallback(callBack: () => void): void {
    if (this.mIsPresetLayoutPersist) {
      log.showInfo('registerPresetFinishedCallback success');
      this.mPresetCardUpdateCallBack.push(callBack);
    } else {
      log.showWarn('registerPresetFinishedCallback error');
    }
  }

  /**
   * load configuration
   */
  async loadPersistConfig(): Promise<void> {
    log.showInfo('loadPersistConfig start');
    let startTime: number = new Date().getTime();
    LauncherStartup.getInstance().passStep(StartupStep.PERSIST_CONFIG);
    // 初始化隐藏app配置文件 1.开机时加载系统预装的隐藏配置;2.oobe修改完隐藏配置刷新桌面重新加载
    await PreInstallUtils.initNeedInstallAppCache();
    await GetHideAppsFromConfig.getInstance().loadHideConfig();
    AnimateToScheduleUtils.stopBootGCPriority();
    let defaultConfig: DefaultDesktopLayoutInfo = super.loadPersistConfig() as DefaultDesktopLayoutInfo;
    if (CheckEmptyUtils.isEmpty(this.mDesktopDataLoader)) {
      this.initDesktopDataLoader();
    }
    let pageCount: number = await this.mDesktopDataLoader?.loadPageCount() ?? 1;
    const desktopMode: number = LayoutViewModel.getInstance().getDesktopModel();
    // 目前只在 HOME_LAUNCHER_MODE模式、加载卡片最大数量限制、其他模式暂不支持
    if (desktopMode === DesktopLayoutState.HOME_LAUNCHER_MODE) {
      let maxFormCount: number = await this.mDesktopDataLoader?.loadMaxFormCount() ??
        CommonConstants.MIN_FORM_LIMIT_COUNT;
      if (maxFormCount && maxFormCount >= CommonConstants.MIN_FORM_LIMIT_COUNT) {
        // 防止数据库记录数据错误、导致不能加卡、如果小于MIN_FORM_COUNT、则使用默认值
        defaultConfig.layoutDescription.maxForm = maxFormCount;
      }
    }
    PageInfoManager.getInstance().updatePageCount(pageCount, 'loadPersistConfig');
    LauncherStartup.getInstance().passStep(StartupStep.PERSIST_CONFIG_PAGE, `pages:${pageCount}`);
    let configFromRdb = await this.mDesktopDataLoader?.loadGridLayoutItemsFromRdb();
    let rdbStartVersion = RdbStoreManager.getInstance().getRdbStartVersion();
    let rdbLatestVersion = RdbStoreManager.getInstance().getRdbLatestVersion();
    log.showInfo('loadPersistConfig -> RdbStoreManager.pageCount: %{public}d, configFromRdb.length: %{public}d,rdbVersion: %{public}d -> %{public}d',
      pageCount, configFromRdb?.length, rdbStartVersion, rdbLatestVersion);
    log.showInfo(`loadPersistConfig -> RdbStoreManager.pageCount: ${pageCount}, configFromRdb.length: ${configFromRdb?.length}`);
    LauncherStartup.getInstance().passStep(StartupStep.PERSIST_CONFIG_DB);
    IconResourceManager.getInstance().checkSystemStateAndVersion();
    if (pageCount) {
      defaultConfig.layoutDescription.pageCount = pageCount;
      this.mGridLayoutInfo = defaultConfig;
    }
    let shouldReadFromDb = (configFromRdb && configFromRdb.length > 0) || (configFromRdb && this.isConfigExist() && rdbStartVersion > 0);
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      shouldReadFromDb = false;
    }
    if (shouldReadFromDb) {
      LauncherStartup.getInstance().passStep(StartupStep.LOAD_DB, `len:${configFromRdb?.length}`);
      configFromRdb = await GetHideAppsFromConfig.getInstance().autoAlignGridLayoutItem(
        configFromRdb as GridLayoutItemInfo[]);
      let installedApps: AppItemInfo[] =
        await launcherAbilityManager.getLauncherAbilityList(launcherAbilityManager.getUserId());
      LauncherStartup.getInstance().passStep(StartupStep.LOAD_BMS, `len:${installedApps?.length}`);
      let dockDataList: DockItemInfo[] = await this.mDesktopDataLoader?.loadSmartDockItemsFromRdb() ?? [];
      // 桌面出现多个克隆应用/应用文件夹兜底清除
      DeliverUtil.checkAndMergeDeliveryFolder(configFromRdb);
      DeliverUtil.checkAndMergeAbroadFolder(configFromRdb);
      await this.initGridLayoutCorrector(configFromRdb, installedApps, dockDataList);
      let pageDeletedSet: Set<number> = new Set();
      gridLayoutCorrector.addGridLayoutCorrector(new DirtyFormCorrector(pageDeletedSet));
      gridLayoutCorrector.handleData(configFromRdb);
      gridLayoutCorrector.clearCorrectorChain();
      LauncherStartup.getInstance().passStep(StartupStep.CORRECTOR, `len:${configFromRdb?.length}`);
      configFromRdb = await this.filterDbListByInstalled(configFromRdb, installedApps, false);
      LauncherStartup.getInstance().passStep(StartupStep.FILTER_BY_BMS, `len:${configFromRdb?.length}`);
      defaultConfig.layoutInfo = configFromRdb;
      this.mGridLayoutInfo = defaultConfig;
      this.initLayoutCache();
      LauncherStartup.getInstance().passStep(StartupStep.INIT_CACHE);
      pageDeletedSet.forEach((page: number) => {
        let pageDeleted: boolean = PageDesktopModel.getInstance().deleteBlankPageFromLayoutInfo(page);
        log.showError(`DirtyFormCorrector delete page: ${page}, pageDeleted: ${pageDeleted}`);
      });

      await this.dealLastBlankPage(pageCount);
      LauncherStartup.getInstance().passStep(StartupStep.INIT_CACHE);
      ContactCacheManager.getInstance().checkToAddContactShortcut(dockDataList);
      localEventManager.sendLocalEvent(EventConstants.EVENT_LAYOUT_INIT_FINISHED, null);
      // 重启加载桌面布局后，异步刷新桌面布局表中的图标名称信息
      AppModel.getInstance().updateInfoNameOfApp(false, false);
      layoutLockUtil.init();
      LauncherStartup.getInstance().passStep(StartupStep.INIT_LOCK);
    } else {
      this.addPreloadLayoutPromiseEvent();
      // 数据库没有创建，第一次加载数据从配置文件夹中进行
      this.getLayoutInfoFromConfig.registerGetLayoutInfoCallback(() => {
        this.loadDataFromConfiguration(pageCount, desktopMode);
      });
      log.showInfo(`rdbStore version:${RdbStoreHelper.getInstance().getRdbStore()?.version}`);
    }
    //删除隐藏后空白页
    GetHideAppsFromConfig.getInstance().deleteBlankPageFromLayoutInfo();
    let endTime: number = new Date().getTime()
    let costTime = endTime - startTime;
    log.showInfo('Loaded desktop cost: %{public}d ms', costTime);
    if (costTime > CommonConstants.FIVE_THOUSAND_MSECOND) {
      HiDfxEventUtil.reportLoadedDesktopTime(costTime);
    }
  }

  /**
   * 处理最后几页的空白页,具体实现逻辑由子类实现
   */
  protected async dealLastBlankPage(pageCount: number): Promise<void> {
  }

  /**
   * 添加布局修护器
   * @param gridLayoutCorrector
   * @returns
   */
  protected async initGridLayoutCorrector(configFromRdb: GridLayoutItemInfo[], installedApps: AppItemInfo[],
    dockDataList: DockItemInfo[]): Promise<void> {
    // 桌面脏数据矫正清理
    gridLayoutCorrector.initCorrectorChain();
    await GridLayoutDBMapReplaceCorrectorBuilder.getInstance()
      .pageDesktopMapReplaceCorrector(configFromRdb, dockDataList);
    gridLayoutCorrector.addGridLayoutCorrector(new BundleChangeCorrector(installedApps, dockDataList));
    if (!DeviceHelper.isSupportVoiceCapability()) {
      gridLayoutCorrector.addGridLayoutCorrector(new CleanContactsDirtyIconCorrector());
    }
    gridLayoutCorrector.addGridLayoutCorrector(new ChangeAppStatusToPauseCorrector(installedApps));
  }

  public async loadDataFromConfiguration(pageCount: number, desktopMode?: number): Promise<void> {
    LauncherStartup.getInstance().passStep(StartupStep.LOAD_CONFIG);
    AppModel.getInstance().initIconNameCache();
    await this.loadLayoutInfoFromConfig(pageCount, desktopMode);
    this.initLayoutCache();
    LauncherStartup.getInstance().passStep(StartupStep.INIT_CACHE);
    ContactCacheManager.getInstance().checkToAddContactShortcut();
    localEventManager.sendLocalEvent(EventConstants.EVENT_LAYOUT_INIT_FINISHED, 'loadDataFromConfiguration');
    log.showWarn(`loadLayoutInfoFromConfig -> end this.mGridLayoutInfo.layoutInfo.length : ${JSON.stringify(this
      .mGridLayoutInfo.layoutInfo.length)}`);
  }

  public getInfo(item: GridLayoutItemInfo): string {
    return `item typeId[${item.typeId}],iconId[${item.appIconId}],cardId[${item.cardId}],folderId[${item.folderId}],` +
      `formStackId[${item.formStackId}],rowColumn[${item.row},${item.column}], page[${item.page}],` +
      `area[${item.area?.[0]}, ${item.area?.[1]}],iconResource[${item.iconResource}],moduleName[${item.moduleName}],` +
      `abilityName[${item.abilityName}],appName[${item.appName}]`;
  }

  async filterDbListByInstalled(dbList: GridLayoutItemInfo[], installedApps: AppItemInfo[],
    isOuter: boolean): Promise<GridLayoutItemInfo[]> {
    let removedList: GridLayoutItemInfo[] = [];
    let result = dbList?.filter(item => {
      log.showInfo(`dbList item in ${isOuter} desktop is ${this.getInfo(item)}}`);
      if (item.typeId === CommonConstants.TYPE_APP) {
        return this.filterLayoutItem(item, installedApps, removedList, undefined, isOuter);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        DeliverUtil.copyDesktopOldDataToIntent(item);
        item.layoutInfo = item.layoutInfo?.map(folderPage =>
        folderPage.filter(itemInPage => {
          log.showInfo(`dbList item in ${isOuter} folderPage is ${this.getInfo(itemInPage)}`);
          DeliverUtil.setContainerAppNameCache(itemInPage, item.intent ?? '');
          return this.filterLayoutItem(itemInPage, installedApps, removedList, item, isOuter);
        })
        );
        if (DeliverUtil.isContainerItem(item.intent ?? '') && item.layoutInfo && item.layoutInfo.flat().length > 0) {
          DeliverUtil.setContainerFolderMapInDesktop(item);
          log.showWarn(`containerFolder in ${isOuter} desktop is ${JSON.stringify(item)}`);
        }
        return true;
      }
      // 卡片需检查对应包名是否已安装，无包名则过滤
      if (item.typeId === CommonConstants.TYPE_CARD) {
        let appExist = installedApps.some(app => app.bundleName === item.bundleName);
        if (!appExist) {
          removedList.push(item);
          log.showWarn('filterDbListByInstalled remove card: %{public}s', item.bundleName);
        }
        return appExist;
      }
      return true;
    });
    this.checkRemoveFromDb(removedList, isOuter);
    return result;
  }

  private filterLayoutItem(item: GridLayoutItemInfo, installedApps: AppItemInfo[],
    removedList: GridLayoutItemInfo[], folderItem?: GridLayoutItemInfo, isOuter?: boolean): boolean {
    if (folderItem && item.typeId === CommonConstants.TYPE_ADD) {
      return false;
    }
    // 该方法为应用修正，快捷方式有专属修正方法，不走该流程
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return true;
    }
    if (DeliverUtil.isRemovedDeliverApp(item.bundleName)) {
      log.showInfo('isRemovedDeliverApp bundleName = ' + item.bundleName);
      removedList.push(item);
      return false;
    }
    let installInfo: AppItemInfo | undefined = item as Object as AppItemInfo;
    if (item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
      installInfo = installedApps.find((appItem: AppItemInfo) => appItem.keyName === item.keyName);
    }
    if (this.isShowInDeliveryFolder(item) && !this.isRetailEnable) {
      let appItem = AppModel.getInstance().getAppInfoByBundleName(item.bundleName);
      if (!CheckEmptyUtils.isEmpty(appItem)) {
        appItem.intent = appItem.intent ? appItem.intent : item.intent;
        installInfo = appItem;
      } else {
        installInfo = item as AppItemInfo;
      }
      if (installInfo) {
        installInfo.codePath = String(NumberConstants.CONSTANT_NUMBER_ONE);
        AppModel.getInstance().setAppListByDelivery(installInfo);
      }
    }
    let isAppStatusInstalled = GridLayoutUtil.isAppInstalled(item);
    if (CheckEmptyUtils.isEmpty(installInfo)) {
      if (isAppStatusInstalled) {
        log.showWarn('filterLayoutItem: bundleName=%{public}s', item.bundleName);
        if (PreInstallUtils.checkIsNeedInstallApp(item)) {
          return true;
        }
        removedList.push(item);
      }
    } else {
      if (!isAppStatusInstalled && installInfo) {
        log.showWarn('data correct: bundleName:%{public}s, oldStatus:%{public}d', item.bundleName, item.appStatus);
        item.appStatus = AppStatus.INSTALLED as number;
        item.moduleName = installInfo.moduleName;
        item.abilityName = installInfo.abilityName;
        item.keyName = installInfo.keyName;
        item.appName = installInfo.appName;
        RdbStoreManager.getInstance().updateNewInstalledGridInfo(item, isOuter);
      }
    }
    return !CheckEmptyUtils.isEmpty(installInfo) || !isAppStatusInstalled;
  }

  private isShowInDeliveryFolder(item: GridLayoutItemInfo): boolean {
    return DeliverUtil.isContainerItem(item.intent ?? '') && item.appStatus === AppStatus.INSTALLED;
  }

  private checkRemoveFromDb(removedApps: GridLayoutItemInfo[], isOuter: boolean): void {
    removedApps.forEach(appInfo => {
      launcherAbilityManager.isAbilityInstalledAsync(appInfo.bundleName, (isInstalled: boolean) => {
        if (!isInstalled) {
          RdbStoreManager.getInstance()
            .deleteGridLayoutByCondition(appInfo, appInfo.container, isOuter, SceneMsgEnum.FILTER_DB_LIST_BY_INSTALLED);
          log.showInfo('checkRemoveFromDb: bundleName=%{public}s', appInfo.bundleName);
        }
      });
    });
  }

  protected async loadLayoutInfoFromConfig(pageCount: number, desktopMode?: number): Promise<void> {
    let defaultLayoutInfoFromFile: DefaultDesktopLayoutInfo | undefined =
      await this.mDesktopDataLoader?.loadFromJsonConfig();
    if (defaultLayoutInfoFromFile) {
      this.mGridLayoutInfo.layoutInfo =
        await GetHideAppsFromConfig.getInstance().autoAlignGridLayoutItem(defaultLayoutInfoFromFile.layoutInfo);
      this.mGridLayoutInfo.layoutDescription.pageCount = Math.max(pageCount, 0);
      // 卡片最大数量限制、只有HOME_LAUNCHER_MODE模式才入库
      if (defaultLayoutInfoFromFile.layoutDescription && defaultLayoutInfoFromFile.layoutDescription.maxForm) {
        this.mGridLayoutInfo.layoutDescription.maxForm = defaultLayoutInfoFromFile.layoutDescription.maxForm;
        if (desktopMode === DesktopLayoutState.HOME_LAUNCHER_MODE) {
          RdbStoreManager.getInstance()
            .updateSettings('max_form_count', defaultLayoutInfoFromFile.layoutDescription.maxForm);
        }
      }
      layoutLockUtil.init();
      LauncherStartup.getInstance().passStep(StartupStep.INIT_LOCK);
    }
    log.showInfo(`loadLayoutInfoFromConfig -> start this.mGridLayoutInfo.layoutInfo.length : ${JSON.stringify(this
      .mGridLayoutInfo.layoutInfo.length)}`);
    await this.updatePLPageCount(pageCount);
    // 筛选出正确的数据
    if (this.mGridLayoutInfo && this.mGridLayoutInfo.layoutInfo) {
      AppModel.getInstance().getAppList(() => {
        this.checkAppList(desktopMode);
        this.dealNotInCCMApp();
        // 绑定文件夹和文件夹里图标的关系
        this.bindAppAndFolder();
      });
    }
  }

  /**
   * 云端模式预置布局pageCount校验纠正
   *
   * @param currentPageCount
   * @returns
   */
  private async updatePLPageCount(currentPageCount: number): Promise<void> {
    try {
      if (!OutdoorConfig.getInstance().isInOutdoorMode()) {
        return;
      }
      let desktopLayoutInfo: DefaultDesktopLayoutInfo =
        await GetLayoutInfoFromConfig.getInstance().getOutdoorLayoutConfigFile()
      let pageCount: number = desktopLayoutInfo.layoutDescription.pageCount;
      if (pageCount === currentPageCount) {
        log.showInfo(`not need to updatePLPageCount and currentPageCount:${currentPageCount}`);
        return;
      }
      log.showError(`updatePLPageCount pageCount:${pageCount} and currentPageCount:${currentPageCount}`);
      this.mGridLayoutInfo.layoutDescription.pageCount = pageCount;
      PageInfoManager.getInstance().updatePageCount(pageCount, 'updatePLPageCount');
      RdbStoreManager.getInstance().updateDesktopPageCount(pageCount);
    } catch (error) {
      log.showError(`updatePLPageCount error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  /**
   * 处理BMS所有应用尚未在CCM配置的应用
   * 默认不做处理，如果需要处理，重写该方法
   */
  protected dealNotInCCMApp(): void {
  }

  protected initLayoutCache(): void {
    let layoutData: DesktopLayoutCacheData = new DesktopLayoutCacheData(this.mGridLayoutInfo);
    LaunchLayoutCacheManager.getInstance().reInit(layoutData);
    FormLayoutCacheManager.getInstance().reInit(layoutData);
    FolderLayoutCacheManager.getInstance().reInit(layoutData);
    if (DeviceHelper.isPad()) {
      layoutData.setIsPad(true);
      PadLaunchLayoutCacheManager.getInstance().reInit(layoutData);
    }
    super.persistConfig();
  }

  private filterInvalidStackCards(stackLayoutInfo: GridLayoutItemInfo, desktopFormList: GridLayoutItemInfo[]): void {
    if (!stackLayoutInfo.layoutInfo) {
      return;
    }
    stackLayoutInfo.layoutInfo[0] =
      stackLayoutInfo.layoutInfo[0].filter(info => {
        if (NoIconAppModel.getInstance().checkIfBundleIsNoIconApp(info.bundleName)) {
          return true;
        }
        const appInfo: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(info.bundleName);
        let appExist: boolean = !CheckEmptyUtils.isEmpty(appInfo);
        if (!appExist) {
          log.showWarn('delete stack card %{public}s, %{public}s, %{public}s, %{public}s, %{public}s, %{public}d',
            stackLayoutInfo.formStackId, info.bundleName, info.moduleName, info.abilityName, info.cardName,
            info.cardDimension);
        }
        return appExist;
      });
    // 堆叠中仅剩一张卡片时，将这张卡片移到桌面
    if (stackLayoutInfo.layoutInfo[0].length === 1) {
      let cardLayoutInfo: GridLayoutItemInfo = stackLayoutInfo.layoutInfo[0][0];
      cardLayoutInfo.page = stackLayoutInfo.page;
      cardLayoutInfo.row = stackLayoutInfo.row;
      cardLayoutInfo.column = stackLayoutInfo.column;
      cardLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
      desktopFormList.push(cardLayoutInfo);
    }
  }

  protected checkAppList(desktopMode?: number): void {
    // 过滤dock区图标
    this.mGridLayoutInfo.layoutInfo = this.mGridLayoutInfo.layoutInfo.filter(item => {
      return item.container !== CommonConstants.CONTAINER_SMARTDOCK;
    });
    // 获取系统所有图标集合
    const totalAppInfoList = AppModel.getInstance().getAppList();

    // The double-upgrade order process is not different from the default layout
    // 如果是简易模式，这里不被拦截
    let backupStatus = GlobalContext.getInstance().getObject('backupStatus');
    if (backupStatus !== undefined &&
      (desktopMode === undefined || desktopMode !== DesktopLayoutState.SIMPLE_LAUNCHER_MODEL)) {
      log.showWarn('checkAppList return! backupStatus:  %{public}s, desktopMode:  %{public}d',
        backupStatus, desktopMode);
      return;
    }
    let desktopFormList: GridLayoutItemInfo[] = [];
    this.mGridLayoutInfo.layoutInfo = this.mGridLayoutInfo.layoutInfo.filter(item => {
      if (item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
        item.layoutInfo = item.layoutInfo?.map(folderPage => {
          return folderPage.filter(info => this.updateAppInfoFromBMS(info, totalAppInfoList));
        });
        return (item.layoutInfo?.flat().length ?? 0) > 0;
      }
      if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
        if (!item.layoutInfo || CheckEmptyUtils.isEmptyArr(item.layoutInfo?.[0])) {
          return false;
        }
        this.filterInvalidStackCards(item, desktopFormList);
        // 堆叠中卡片数量需要至少2张
        return item.layoutInfo.flat().length >= 2;
      }
      if (item.typeId !== CommonConstants.TYPE_APP) {
        // 卡片需检查对应包名是否已安装，无包名则不预装卡片
        if (item.typeId === CommonConstants.TYPE_CARD) {
          return this.updateAppInfoFromBMS(item, totalAppInfoList);
        }
        return true;
      }
      return this.updateAppInfoFromBMS(item, totalAppInfoList);
    });

    this.mGridLayoutInfo.layoutInfo.push(...desktopFormList);
  }

  protected updateAppInfoFromBMS(info: GridLayoutItemInfo, totalAppInfoList: AppItemInfo[]): boolean {
    // 先用keyname匹配更新应用信息
    info.keyName = AppItemInfo.getKeyName(info);
    for (const appInfo of totalAppInfoList) {
      if (info.keyName === appInfo.keyName) { // 该图标在系统图标集合中
        info.appStatus = AppStatus.INSTALLED;
        this.complementAppInfo(info, appInfo); // 根据系统图标数据补全配置文件中图标数据
        return true;
      }
    }
    // 加载预制布局场景DFX相关能力:keyName匹配失败，bundleName+appIndex匹配，避免应用修改abilityName与moduleName
    let existAppInfo: AppItemInfo[] = AppModel.getInstance()
      .getAppInfoByBundleNameAndAppIndex(info.bundleName, info.appIndex ?? 0);
    if (CheckEmptyUtils.isEmptyArr(existAppInfo)) {
      log.showWarn('the %{public}s is not find in BMS', info.bundleName);
      return false;
    }
    if (existAppInfo.length > 1) {
      log.showInfo('the %{public}s can not match as multiIcon', info.bundleName);
      return false;
    }
    let findAppInfo: AppItemInfo = existAppInfo[0];
    info.keyName = findAppInfo.keyName;
    info.appStatus = AppStatus.INSTALLED;
    this.complementAppInfo(info, findAppInfo); // 根据系统图标数据补全配置文件中图标数据
    return true;
  }

  private bindAppAndFolder(): void {
    let layoutInfoItems: GridLayoutItemInfo[] = this.mGridLayoutInfo?.layoutInfo;
    log.showWarn('bindAppAndFolder -> start! layoutInfoItems length:%{public}d', layoutInfoItems.length);
    // 将id赋值给缓存，进行绑定文件夹和文件夹里面图标的关系
    this.dealLayoutInfoItems(layoutInfoItems);
    this.mIsPresetLayoutPersist = true;
    let promise = RdbStoreManager.getInstance().insertGridLayoutInfo(layoutInfoItems, true, false);
    promise.then((res) => {
      if (res) {
        LauncherStartup.getInstance().passStep(StartupStep.CONFIG_INTO_DB);
        log.showWarn('bindAppAndFolder -> insertGridLayoutResult ok! length:%{public}d', layoutInfoItems.length);
        // 首次加载预置布局后，刷新桌面布局表中的图标名称信息
        if (!OutdoorConfig.getInstance().isInOutdoorMode()) { //云端模式不更新
          AppModel.getInstance().updateInfoNameOfApp(false, false);
        }
        PreviewLayoutCheckTool.getInstance().startCheck(PRELOAD_CHECK_NAME);
      } else {
        log.showError('bindAppAndFolder -> insertGridLayoutResult fail!');
      }
      if (!CheckEmptyUtils.isEmptyArr(this.mPresetCardUpdateCallBack)) {
        log.showInfo('the presetFile update callback length %{public}d', this.mPresetCardUpdateCallBack.length);
        this.mPresetCardUpdateCallBack.forEach((callback) => {
          callback();
        });
      }
      layoutInfoItems.forEach(layoutItem => {
        if (layoutItem.typeId === CommonConstants.TYPE_FOLDER) {
          this.updateFolderAppContainer(layoutItem);
        }
      });
      this.mPresetCardUpdateCallBack = [];
      this.mIsPresetLayoutPersist = false;
    });
  }

  // 将id赋值给缓存，进行绑定文件夹和文件夹里面图标的关系
  private dealLayoutInfoItems(layoutInfoItems: GridLayoutItemInfo[]): void {
    layoutInfoItems.forEach((item) => {
      item.infoId = RdbStoreManager.getInstance().generateRandomUUID(false);
      if (item.typeId === CommonConstants.TYPE_FOLDER && item.layoutInfo && item.layoutInfo.length > 0) {
        if (item.folderId === CommonConstants.PRESET_OpenHarmony_FOLDER_ID) {
          ContactCacheManager.getInstance().addPresetContactToFolder(item);
        }
        const layoutItemsInFolder: GridLayoutItemInfo[] = item.layoutInfo?.flat() ?? [];
        // 对文件夹中应用按照page、行、列进行排序，与数据库查询返回的逻辑保持一致
        layoutItemsInFolder.sort((folderAppItem1, folderAppItem2): number => {
          if (folderAppItem1.page === folderAppItem2.page) {
            if (folderAppItem1.row === folderAppItem2.row) {
              return (folderAppItem1.column ?? 0) - (folderAppItem2.column ?? 0);
            }
            return (folderAppItem1.row ?? 0) - (folderAppItem2.row ?? 0);
          }
          return (folderAppItem1.page ?? 0) - (folderAppItem2.page ?? 0);
        });
        FolderCommonUtil.updateFolderAppLocation(layoutItemsInFolder);
        for (const itemInFolder of layoutItemsInFolder) {
          itemInFolder.infoId = RdbStoreManager.getInstance().generateRandomUUID(false);
          itemInFolder.areaType = CommonConstants.TYPE_AREA_DESKTOP;
        }
      }
    });
  }

  private updateFolderAppContainer(folderItem: GridLayoutItemInfo): void {
    RdbStoreManager.getInstance().queryRecordByInfoId(folderItem.folderId ?? '').then(
      (rdbItem: GridLayoutItemInfo | undefined) => {
      if (rdbItem && rdbItem.id) {
        folderItem.id = rdbItem.id;
        let items: GridLayoutItemInfo[] = folderItem.layoutInfo?.flat() ?? [];
        items.forEach(item => item.container = rdbItem.id);
        FolderManager.getInstance().updateFolderItems('update preset folder', folderItem, items);
      }
    });
  }

  /**
   * 添加需要校验的参数
   */
  protected addPreloadLayoutPromiseEvent(): void {
    PreviewLayoutCheckTool.getInstance().addPromiseEvent(PRELOAD_CHECK_NAME);
  }

  protected complementAppInfo(info: GridLayoutItemInfo, appInfo: AppItemInfo): void {
    info.abilityName = appInfo.abilityName;
    info.moduleName = appInfo.moduleName;
    info.keyName = appInfo.keyName;
    info.applicationName = appInfo.applicationName;
    info.appName = appInfo.appName;
    info.appIconId = appInfo.appIconId;
    info.appLabelId = appInfo.appLabelId;
    info.isSystemApp = appInfo.isSystemApp;
    info.kindId = appInfo.kindId;
    info.checked = appInfo.checked;
    info.isUninstallAble = appInfo.isUninstallAble;
    info.applicationIconId = appInfo.applicationIconId;
    info.bundleType = appInfo.bundleType;
    info.appIndex = appInfo.appIndex ?? 0;
  }

  /**
   * refreshLayout After backup recover
   * @returns Promise<void>
   */
  public async refreshLayoutAfterRecover(): Promise<void> {
    // 克隆完成后，查询前先清除缓存
    GlobalContext.getInstance().setObject('backupStatus', true);
    const allRst: Object[] = await Promise.all([
      globalThis.RdbStoreManagerInstance.querySettingsPageCount(),
      globalThis.RdbStoreManagerInstance.queryGridLayoutInfo(),
    ]);
    const pageCount = allRst[0] as number;
    const configFromRdb = allRst[1] as GridLayoutItemInfo[];
    log.showWarn('refreshLayoutAfterRecover configFromRdb length = %{public}d,pageCount = %{public}d',
      configFromRdb.length, pageCount);
    if (pageCount) {
      this.mGridLayoutInfo.layoutDescription.pageCount = pageCount;
      PageInfoManager.getInstance().updatePageCount(pageCount, 'refreshLayoutAfterRecover');
    }
    if (configFromRdb && configFromRdb.length > 0) {
      this.mGridLayoutInfo.layoutInfo = [...configFromRdb];
      this.mGridLayoutInfo.layoutInfo.forEach(item => {
        if (!CheckEmptyUtils.isEmpty(item.layoutInfo)) {
          let date: string = String(new Date());
          item.formRefreshDate = date;
        }
      });
      this.initLayoutCache();
      let dockDataList: DockItemInfo[] = await CommonDockModel.getInstance().querySmartDock(false);
      ContactCacheManager.getInstance().checkToAddContactShortcut(dockDataList);
    }
  }

  /**
   * 获取预制的布局文件
   *
   * @returns 布局信息
   */
  protected async getAllLayoutConfigFile(): Promise<DefaultDesktopLayoutInfo | null> {
    return this.getLayoutInfoFromConfig.getAllLayoutConfigFile();
  }

  protected initDesktopDataLoader(): void {
    let desktopLayout: number = Number(sSettingsUtil.getValue(CommonConstants.SIMPLE_MODE_KEY, '0'));
    this.mDesktopDataLoader = DesktopDataLoader.getInstance(desktopLayout, this.singleContext);
  }
}
