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

import { promptAction } from '@kit.ArkUI';
import {
  AppGalleryDownloadManager,
  AppGalleryEventInfo,
  AppItemInfo,
  AppModel,
  AppStatus,
  BaseViewModel,
  DownloadStatusInfo,
  GridLayoutItemInfo,
  MenuInfo,
  AppInstallUtils,
  RdbStoreManager,
  EnterpriseSpaceUtil,
  ShortcutInfo
} from '@ohos/launchercommon';
import { CommonConstants, LayoutViewModel, ShortcutViewModel } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { PinyinSort } from '@ohos/frameworkpinyin';
import { SCBConstants } from '@ohos/commonconstants';
import {
  HiSysEventUtil,
  ReportParams,
  localEventManager,
  InstallStatusChangeEvent,
  GlobalContext,
  sEventManager,
  ResourceManager,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { DisplayConstants, OOBE_CHANGE_EVENT, OTA_OOBE_CHANGE_EVENT } from '@ohos/windowscene';
import { AppCenterItemsCountParams } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { AppCenterViewModel } from '../viewmodel/AppCenterViewModel';
import { EventConstants } from '@ohos/launchercommon';
import { BadgeItemInfo } from '@ohos/launchercommon';
import { ReceiveEventInfo } from '@ohos/launchercommon';
import { AppLayoutInfo } from '../viewmodel/AppLayoutInfo';
import { Pinyin } from '@ohos/frameworkpinyin/src/main/ets/utils/Pinyin';
import AppGridLayoutCacheManager from '../cache/AppGridLayoutCacheManager';
import { AppCenterDragMgr } from '../../controller/AppCenterDragMgr';
import { AppGridItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppGridItemInfo';
import type ctx from '@ohos.app.ability.common';
import { BaseIconInfo } from '@ohos/launchercommon/src/main/ets/bean/BaseIconInfo';
import FeatureConstants from '../constants/FeatureConstants';
import { AppCenterGridStyleConfig } from '../AppCenterGridStyleConfig';
import {
  CONTACTS_BUNDLE_NAME,
  CONTACTS_ABILITY_NAME,
  DEFAULT_CONTACT_SHORTCUT_NAME
} from '../../../default/constants/LayoutConstants';
import { HashMap } from '@kit.ArkTS';
import { FoldAcGridLayoutConstants, FoldedDeviceAcViewModel } from '../../folded/FoldedDeviceAcViewModel';

const TAG = 'AppListPresenter';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CACHE_TYPE_NAME = 'name';

export class AppListPresenter extends BaseViewModel {
  private static instance: AppListPresenter;
  private mPinyinSort: PinyinSort;
  private mPinyin: Pinyin = new Pinyin();
  private patternChinese: RegExp = new RegExp('[\u4e00-\u9fa5]');
  private mAppGridLayoutCacheManager: AppGridLayoutCacheManager;
  private mInstallingInfoList: AppItemInfo[] = [];
  private mAppGridStyleConfig: AppCenterGridStyleConfig;
  protected mScreenIds: number[] = [];

  protected constructor() {
    super();
    this.mPinyinSort = new PinyinSort();
    this.mAppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();
    this.mAppGridStyleConfig = AppCenterViewModel.getInstance().getAppGridStyleConfig();
    log.showWarn('constructor');
  }


  private readonly mLocalDownloadListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: GridLayoutItemInfo[]) => {
      log.showInfo(`mAppCenterLocalDownloadListener receive event: ${event}, params: ${params.length}`);
      switch (event) {
        case EventConstants.EVENT_REQUEST_APPGALLERY_CREATED:
          this.insertNewUpdateApp(params);
          break;
        default:
          break;
      }
    }
  }

  public async insertNewUpdateApp(items: GridLayoutItemInfo[]): Promise<void> {
    if (!items) {
      return;
    }
    let result: AppItemInfo[] = this.mAppModel.getAppList();
    items.forEach(item => {
      log.showInfo('insertNewUpdateApp, bundleName is %{public}s status: %{public}d', item.bundleName, item.appStatus);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = item.bundleName;
      appItemInfo.typeId = item.typeId;
      appItemInfo.abilityName = item.abilityName;
      appItemInfo.moduleName = item.moduleName;
      appItemInfo.keyName = item.keyName;
      appItemInfo.badgeNumber = item.badgeNumber;
      appItemInfo.area = item.area;
      if (item.appName !== null && typeof item.appName === 'string') {
        appItemInfo.appName = item.appName;
      }
      appItemInfo.appIconId = item.appIconId;
      appItemInfo.appLabelId = item.appLabelId;
      appItemInfo.kindId = item.kindId;
      appItemInfo.bundleType = item.bundleType;
      appItemInfo.applicationName = item.applicationName;
      appItemInfo.appStatus = item.appStatus;
      if (!appItemInfo.appStatus) {
        appItemInfo.appStatus = CommonConstants.INVALID_VALUE;
      }
      appItemInfo.downloadProgress = item.downloadProgress;
      appItemInfo.iconResource = item.iconResource;
      appItemInfo.callerName = item.callerName;
      appItemInfo.appId = RdbStoreManager.getInstance().generateRandomUUID();
      item.container = CommonConstants.INVALID_VALUE;
      item.infoId = '-' + appItemInfo.appId;
      item.intent = appItemInfo.intent;
      result.push(appItemInfo);
      this.onPackageAdded(appItemInfo);
    });
    RdbStoreManager.getInstance().insertGridLayoutInfo(items);
  }

  private updateOneAppLayoutInfo(): void {
    log.showInfo(`updateOneAppLayoutInfo`);
    let appCenterLayoutInfo = AppStorage.get<AppLayoutInfo[]>('appCenterLayoutInfo') as AppLayoutInfo[];
    if (!appCenterLayoutInfo) {
      return;
    }
    let nowTime: number = Date.now();
    appCenterLayoutInfo.forEach((pageInfos) => {
      pageInfos.packageChangeTime = nowTime;
    });
    AppStorage.setOrCreate('appCenterLayoutInfo', appCenterLayoutInfo);
  }

  public static getInstance(): AppListPresenter {
    if (AppListPresenter.instance == null) {
      AppListPresenter.instance = new AppListPresenter();
    }
    return AppListPresenter.instance;
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: BadgeItemInfo | number) => {
      log.showInfo(`localEventListener receive event: ${event}`);
      switch (event) {
        case EventConstants.EVENT_BADGE_UPDATE:
          this.updateBadgeNum(params as BadgeItemInfo);
          break;
        case EventConstants.EVENT_REQUEST_APP_GRID_REFRESH_FINISHED:
          this.refreshAppGridLayout(FeatureConstants.AC_SCENE_DFT, params as number);
          break;
        default:
          break;
      }
    }
  }

  /**
   * Registering Listening Events.
   */
  public onAppListViewCreate(): void {
    log.showInfo('onAppListViewCreate');
    localEventManager.registerEventListener(this.mLocalEventListener, [
      EventConstants.EVENT_BADGE_UPDATE,
      EventConstants.EVENT_REQUEST_APP_GRID_REFRESH_FINISHED
    ]);
    localEventManager.registerEventListener(this.mLocalDownloadListener, [
      EventConstants.EVENT_REQUEST_APPGALLERY_CREATED
    ]);
  }

  /**
   * Unregistering Listening Events.
   */
  public onAppListViewDestroy(): void {
    log.showInfo('onAppListViewDestroy');
    localEventManager.unregisterEventListener(this.mLocalEventListener);
    localEventManager.unregisterEventListener(this.mLocalDownloadListener);
  }

  /**
   * 执行简易搜索并刷新结果集
   * @param input
   */
  public searchAndFilterApps(input: string, fullAppPageList: AppLayoutInfo[]): AppLayoutInfo[] {
    log.showInfo(`doSearchAndFilterApps: ${input}, full length: ${fullAppPageList?.length}`);

    let searchAppPageList: AppLayoutInfo[] = [];
    if (!input) {
      return searchAppPageList;
    }

    if (fullAppPageList !== undefined) {
      searchAppPageList = this.doSearchAndFilterApps(input, fullAppPageList);
    }

    log.showInfo(`doSearchAndFilterApps:end  ${input}, full length: ${searchAppPageList?.length}`);
    return searchAppPageList;
  }

  private doSearchAndFilterApps(input: string, fullAppPageList: AppLayoutInfo[]): AppLayoutInfo[] {
    let searchResultAppPageList: AppLayoutInfo[] = [];
    let searchResultItems: AppItemInfo[] = [];
    for (let appLayoutInfo of fullAppPageList) {
      for (let appItem of appLayoutInfo.pageInfo) {
        if (this.isAppShotInSearch(appItem.appName, input)) {
          searchResultItems.push(appItem);
        }
      }
    }

    searchResultAppPageList = AppCenterViewModel.getInstance()
      .doAppCenterDataPaging(searchResultItems, new Date().getTime());

    return searchResultAppPageList;
  }

  private isAppShotInSearch(appName: string, input: string): boolean {
    if (appName.startsWith(input)) {
      return true;
    }

    if (appName.includes(input)) {
      return true;
    }

    if (this.containChinese(input)) {
      return false;
    }

    return this.mPinyin.getFullChars(appName)?.toLowerCase()
      .startsWith(this.mPinyin.getFullChars(input)?.toLowerCase());
  }

  private containChinese(str: string): boolean {
    if (str.length === 0) {
      return false;
    }

    return this.patternChinese.test(str.charAt(0));
  }

  public refreshAppGridLayout(scene: number, reason?: number): void {
    log.showInfo('refreshAppGridLayout');
    const appLayoutInfo: AppLayoutInfo[] = this.mAppGridLayoutCacheManager.getAppGridLayoutItemList();
    if (appLayoutInfo) {
      log.showInfo(`refreshAppGridLayout validData.length: ${appLayoutInfo.length}`);
      AppStorage.setOrCreate('appCenterLayoutInfo', appLayoutInfo);
      AppStorage.setOrCreate('updateAppGridPageData', !AppStorage.get<boolean>('updateAppGridPageData'));
      GlobalContext.getContext()?.eventHub.emit(FeatureConstants.EVENT_UPDATE_CURRENT_PAGE);
      AppCenterDragMgr.getInstance().updateAppCenterLayoutInfo(scene, reason);
    } else {
      log.showInfo('refreshAppGridLayout cache not exist');
      this.getAppList();
    }
  }

  private async updateBadgeNum(badgeInfo: BadgeItemInfo) {
    log.showInfo(`updateBadgeNum`);

    // 此处更新badgeNum，要区分是否已有数据，无则不必再次刷新
    let appList = await this.mAppModel.getAppList();
    let appItem = appList.find(item => {
      return item.bundleName == badgeInfo.bundleName;
    });

    // CheckEmptyUtils.isEmpty(badgeInfo?.appInstanceKey) 应用多开实例消息不在桌面显示，判断非多开消息，应用中心进行更新
    if (appItem && !badgeInfo.checkAppInstanceKey(badgeInfo?.appInstanceKey)) {
      appItem.badgeNumber = badgeInfo.isShow ? badgeInfo.badgeNumber : 0;
      log.showInfo(`update app(${appItem.bundleName}) badge num: ${badgeInfo.badgeNumber}`);
    }
  }

  /**
   * 刷新并获取全局的应用列表
   * @returns
   */
  public async getAppList(): Promise<void> {
    log.showInfo('getAppList');
    this.mAppModel.getAppList(() => {
      let appList = this.mAppModel.getAppList();
      log.showInfo(`getAppList size:${appList?.length}`);
      this.regroupDataAppListChange(appList, EventConstants.EVENT_INIT_APPLIST_FINISH);
    });
  }

  private changeContactAppInfo(appList: AppItemInfo[]): void {
    if (!DeviceHelper.is2In1DevicePcType()) {
      log.showInfo(`changeToContactApp not support in the device type`);
      return;
    }
    let index = appList.findIndex((appItemInfo: AppItemInfo) => {
      return appItemInfo.bundleName === CONTACTS_BUNDLE_NAME;
    });
    if (index <= 0) {
      log.showInfo(`changeToContactApp contact app not found`);
      return;
    }
    let appItemInfo: AppItemInfo = appList[index];
    appItemInfo.abilityName = CONTACTS_ABILITY_NAME;
    let shortcuts: ShortcutInfo[] = ShortcutViewModel.getInstance().getShortcutByBundleName(CONTACTS_BUNDLE_NAME);
    if (!CheckEmptyUtils.isEmptyArr(shortcuts)) {
      appItemInfo.moduleName = shortcuts[0].moduleName;
      appItemInfo.appIconId = shortcuts[0].iconId ?? 0;
      appItemInfo.appLabelId = shortcuts[0].labelId;
    }
    appItemInfo.keyName = AppItemInfo.getKeyName(appItemInfo);
    ResourceManager.getInstance().getAppNameWithCache(appItemInfo.appLabelId, appItemInfo.bundleName,
      appItemInfo.moduleName, DEFAULT_CONTACT_SHORTCUT_NAME, (name: string) => {
        appItemInfo.appName = name;
      });
  }

  private filterApp(appList: AppItemInfo[]): AppItemInfo[] {
    return appList;
  }

  /**
   * 加载应用中心图标数据
   * @returns
   */
  public async loadAppCenterData(): Promise<void> {
    log.showInfo('loadAppCenterData');
    const isHwItOS = EnterpriseSpaceUtil.hwItOsCheck();

    if (isHwItOS) {
      this.oobeEventListen();
      this.vpnEventListen();
    }

    // 如果数据库里面没有数据，则是首次加载，直接使用BMS获取到的数据
    // 再从BMS查询一次，做对比
    this.mAppModel.getAppList(async () => {
      let appList = this.mAppModel.getAppList();
      log.showInfo(`getAppList userId is ${this.mAppModel.getUserId()}, size: ${appList?.length}`);
      if (!appList) {
        return;
      }
      // 从DB数据库获取查询
      let appCenterGridData: AppGridItemInfo[] = await RdbStoreManager.getInstance().queryAppCenter();
      let appCenterInstallingData: AppItemInfo[] = await RdbStoreManager.getInstance().queryAppCenterInstallApp();

      // it镜像、企业数字空间企业账号隐藏应用市场
      if (isHwItOS) {
        try {
          appList = this.enterpriseSpaceHideAppGallery(appList);
        } catch (err) {
          log.showInfo('enterpriseSpaceHideAppGallery fail');
        }
      }
      appList = this.filterApp(appList);
      this.changeContactAppInfo(appList);
      // 查询到数据之后，跟DB数据进行对比，差异项回刷
      if (CheckEmptyUtils.isEmptyArr(appCenterGridData)) {
        // 数据库查询为空，直接使用BMS拿到的数据，并分组
        // 执行应用中心应用列表排序
        appList.sort((a, b): number => {
          return this.mPinyinSort.sortByParameter(a.appName, b.appName);
        });
        // 这里异步可能会导致缓存没有及时刷新，导致写库失败
        await this.regroupDataAppListChange(appList, EventConstants.EVENT_INIT_APPLIST_FINISH);
        let cachedData: AppItemInfo[] = this.mAppGridLayoutCacheManager.getAppItemList();
        log.showInfo(`loadAppCenterData getCachedList: ${cachedData?.length}`);
        let dbDataArr: AppGridItemInfo[] = cachedData?.map((appItemInfo: AppItemInfo) => {
          let instance: AppGridItemInfo = AppGridItemInfo.newInstanceFromAppItemInfo(appItemInfo);
          return instance;
        });
        log.showInfo(`loadAppCenterData getCachedList transfer: ${dbDataArr?.length}`);
        RdbStoreManager.getInstance().insertAppCenter(dbDataArr);
      } else {
        log.showInfo(`loadAppCenterData getCachedList appCenterGridData: ${appCenterGridData?.length}`);

        // 重新排布应用的分页信息
        let installingAppList = this.filterInstallAppList(appCenterInstallingData, appList);
        this.reorganizeAppData(appCenterGridData, appList, installingAppList);
      }
      this.appCenterItemsCounts();
    });
  }

  private appCenterItemsCounts(): void {
    let getAppCenterItemsCount: AppCenterItemsCountParams = this.appItemsCount();
    log.showInfo('appItemsCountEvent report happen');
    HiSysEventUtil.reportAppCenterItemsCount(getAppCenterItemsCount);
  }

  private appItemsCount(): AppCenterItemsCountParams {
    let appLayoutInfoList: AppLayoutInfo[] = []
    let pagecnt: number = 0;
    let singlePageIconCnt: number[] = [];
    let index = 0;
    let sumIconCnt: number = 0;
    appLayoutInfoList = this.mAppGridLayoutCacheManager.getAppGridLayoutItemList();
    pagecnt = appLayoutInfoList?.length;
    appLayoutInfoList?.forEach((appLayoutInfo) => {
      singlePageIconCnt[index++] = appLayoutInfo?.pageInfo?.length;
      appLayoutInfo?.pageInfo?.forEach((appItemInfo) => {
        sumIconCnt++;
      })
    })
    let results: AppCenterItemsCountParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PAGECNT: pagecnt,
      SINGLEPAGEICONSCNT: singlePageIconCnt,
      SUMICONSCNT: sumIconCnt,
      DTYPE: DisplayConstants.DEFAULT_DISPLAY
    }
    return results;
  }

  private filterInstallAppList(desktopDbApps: AppItemInfo[], bmsApps: AppItemInfo[]): AppItemInfo[] {
    let installList: AppItemInfo[] = [];

    // 正在安装应用至BMS列表
    if (desktopDbApps) {
      desktopDbApps.forEach(item => {
        // 若不存在，或者状态不等则添加
        let appInDockIndex: number = bmsApps.findIndex(
          dockItem => dockItem.bundleName === item.bundleName
        );
        if (appInDockIndex === -1) {
          log.showWarn(`installing Data bundleName: ${item.bundleName}`);
          installList.push(item);
        } else {
          log.showWarn(`error Data bundleName: ${item.bundleName}`);
        }
      });
    }

    return installList;
  }

  private reorganizeAppData(appsInDb: AppGridItemInfo[], appsFromBms: AppItemInfo[],
    appsInstallingFromDB: AppItemInfo[]): void {
    // DB和BMS皆有的应用列表
    let apps4Both: AppItemInfo[] = [];

    // DB中存在但是BMS中不存在的App的清单
    let apps2DeleteFromDB: AppGridItemInfo[] = [];

    // BMS中相对于DB而言是新增的应用的清单，包括那些存在于DB但是moduleName为空的应用
    let newAppsFromBms: AppItemInfo[] = [];

    // 重组应用数据
    let appLayoutInfo: AppLayoutInfo[] =
      this.compareAndReposition(appsFromBms, appsInDb, apps4Both, apps2DeleteFromDB, appsInstallingFromDB,
        newAppsFromBms);

    // 更新缓存以及DB
    this.updateCacheAndDB(appLayoutInfo, apps2DeleteFromDB, newAppsFromBms, apps4Both, appsInstallingFromDB);

    // 更新UI
    this.refreshAppGridLayout(FeatureConstants.AC_SCENE_AC_APP_INIT_LIST_FINISH);
  }

  private updateCacheAndDB(appLayoutInfo: AppLayoutInfo[], apps2DeleteFromDB: AppGridItemInfo[],
    newAppsFromBms: AppItemInfo[], apps4Both: AppItemInfo[], appsInstalling: AppItemInfo[]): void {
    // 先刷新缓存
    this.mAppGridLayoutCacheManager.setAppGridLayoutItemList(appLayoutInfo);
    this.mAppGridLayoutCacheManager.afterSetAppGridLayoutItemList(appLayoutInfo);

    newAppsFromBms.forEach((item: AppItemInfo) => {
      RdbStoreManager.getInstance().queryAppCenter().then((appCenterGridData: AppGridItemInfo[]) => {
        if (!CheckEmptyUtils.isEmptyArr(appCenterGridData)) {
          RdbStoreManager.getInstance().insertAppCenter([AppGridItemInfo.newInstanceFromAppItemInfo(item)]);
        }
      });
    });

    // 新增数据库记录 - 建立在引用之上，如果没有原始DB数据则不增加，待初始化之后再考虑
    if (newAppsFromBms.length > 0) {
      RdbStoreManager.getInstance().queryAppCenter().then((appCenterGridData: AppGridItemInfo[]) => {
        if (CheckEmptyUtils.isEmptyArr(appCenterGridData)) {
          log.showWarn(`Ignore new apps from bms when DB is empty-${newAppsFromBms.length}`);
          return;
        }

        let newAppBmsData: AppGridItemInfo[] = newAppsFromBms?.map((appItemInfo: AppItemInfo) => {
          let bmsApp: AppGridItemInfo = AppGridItemInfo.newInstanceFromAppItemInfo(appItemInfo);
          return bmsApp;
        });

        log.showWarn(`Insert new apps from bms-${newAppsFromBms.length}-${newAppBmsData?.length}`);
        RdbStoreManager.getInstance().insertAppCenter(newAppBmsData);
      });
    }

    // 更新数据库 - 建立在引用之上
    if (apps4Both.length > 0) {
      let bothAppData: AppGridItemInfo[] = apps4Both?.map((appItemInfo: AppItemInfo) => {
        let bothApp: AppGridItemInfo = AppGridItemInfo.newInstanceFromAppItemInfo(appItemInfo);
        return bothApp;
      });

      log.showWarn(`Update both apps-${apps4Both.length}-${bothAppData?.length}`);
      RdbStoreManager.getInstance().updateAppCenterItemPositions(bothAppData);
    }

    // 更新数据库 - 建立在引用之上
    if (appsInstalling.length > 0) {
      let installingAppData: AppGridItemInfo[] = appsInstalling?.map((appItemInfo: AppItemInfo) => {
        let istApp: AppGridItemInfo = AppGridItemInfo.newInstanceFromAppItemInfo(appItemInfo);
        return istApp;
      });

      RdbStoreManager.getInstance().updateAppCenterItemPositions(installingAppData);
    }

    // 删除数据库记录 - 建立在引用之上
    apps2DeleteFromDB.forEach((item: AppGridItemInfo) => {
      let app: AppItemInfo = new AppItemInfo();
      app.bundleName = item.bundleName ?? '';
      app.abilityName = item.abilityName ?? '';
      app.moduleName = item.moduleName;
      RdbStoreManager.getInstance().deleteAppCenterItem(app).then(() => {
        log.showInfo(`Delete from db: ${this.getItemKey(item)}`);
      });
    });
  }

  private compareAndReposition(bmsApps: AppItemInfo[], dbApps: AppGridItemInfo[], apps4Both: AppItemInfo[],
    apps2DeleteFromDB: AppGridItemInfo[], appsInstallingFromDB: AppItemInfo[],
    newAppsFromBms: AppItemInfo[]): AppLayoutInfo[] {
    log.showInfo(`Data Length bms vs db: ${bmsApps.length}-${dbApps.length}`);

    // 先把db app的mapping建立好
    let dbAppsInMap: Map<string, AppGridItemInfo> = new Map();
    dbApps.forEach((item: AppGridItemInfo) => {
      log.showInfo(`print dbapp: ${item.bundleName}-${item.moduleName}, column: ${item.column}, row: ${item.row}, page: ${item.page}`);
      dbAppsInMap.set(this.getItemKey(item), item);
    });

    // 安装应用的列表需要把坐标补充到AppItemInfo中
    let installingAppsMap: Map<string, AppItemInfo> = new Map();
    appsInstallingFromDB.forEach((app: AppItemInfo) => {
      let key = this.getItemKey(app);
      if (dbAppsInMap.has(key)) {
        app.row = dbAppsInMap.get(key)?.row;
        app.column = dbAppsInMap.get(key)?.column;
        app.page = dbAppsInMap.get(key)?.page;
        installingAppsMap.set(key, app);
      } else {
        log.showWarn(`in desktop db but no in app center db : ${key}`);

        // 桌面标存在记录，应用中心标不存在记录，状态记录-1
        app.appStatus = -1;
      }
    });

    // 先找出BMS中相对于DB而言是新增的应用的清单
    bmsApps.forEach((appItem: AppItemInfo) => {
      let key = this.getItemKey(appItem);
      let existInDb = dbAppsInMap.has(key);
      log.showInfo(`App exist in Db: ${appItem.bundleName}-${appItem.moduleName}-${existInDb}`);
      if (!existInDb) {
        newAppsFromBms.push(appItem);
      } else {
        // 将数据库里的行列信息补充到BMS数据源
        appItem.row = dbAppsInMap.get(key)?.row;
        appItem.column = dbAppsInMap.get(key)?.column;
        appItem.page = dbAppsInMap.get(key)?.page;
        apps4Both.push(appItem);
      }
    });

    // 先把bms app的mapping建立好
    let bmsAppsInMap: Map<string, AppItemInfo> = new Map();
    bmsApps.forEach((item: AppItemInfo) => {
      log.showInfo(`print bmsapp: ${item.bundleName}-${item.moduleName}, column: ${item.column}, row: ${item.row}, page: ${item.page}`);
      bmsAppsInMap.set(this.getItemKey(item), item);
    });

    // 找出DB中存在但是BMS中不存在的App的清单
    dbApps.forEach((item: AppGridItemInfo) => {
      let key = this.getItemKey(item);
      let existInBms = bmsAppsInMap.has(key);
      let existInstalling = installingAppsMap.has(key);
      log.showInfo(`get app delete in db: ${key}-${existInstalling}-${existInBms}`);
      if (!existInBms && !existInstalling) {
        log.showInfo(`not in bms: ${item.bundleName}-${item.moduleName}, column: ${item.column}, row: ${item.row}, page: ${item.page}`);
        apps2DeleteFromDB.push(item);
      }
    });

    // 仅在DB中但是未完成安装的应用清单，需要继续保留在应用中心页面上
    log.showInfo(`Delta data: ${newAppsFromBms.length}-${apps2DeleteFromDB.length}-` +
      `${bmsApps.length}-${dbApps.length}-${apps4Both.length}-${appsInstallingFromDB.length}`);

    // 填充空位 - 对于新增的App需要重新排到队尾，对于已有的保持不变，对于DB特有的则要执行删除
    // Step.01 获取已有的页码数据
    let oldPagingAppsMap: HashMap<number, AppItemInfo[]> = new HashMap<number, AppItemInfo[]>();
    apps4Both.forEach((item: AppItemInfo) => {
      let appsInPage: AppItemInfo[] = oldPagingAppsMap.get(item.page);
      if (CheckEmptyUtils.isEmptyArr(appsInPage)) {
        appsInPage = [];
      }
      appsInPage.push(item);
      oldPagingAppsMap.set(item.page, appsInPage);
    });

    // 待安装应用需要一起放到旧数据里
    for (let item of appsInstallingFromDB) {
      // 在应用中心，无记录的数据，不处理，进行下一步
      if (CheckEmptyUtils.isEmpty(item?.page) && item.appStatus === -1) {
        continue;
      }
      let appsInPage: AppItemInfo[] = oldPagingAppsMap.get(item.page);
      if (CheckEmptyUtils.isEmptyArr(appsInPage)) {
        appsInPage = [];
      }
      appsInPage.push(item);
      oldPagingAppsMap.set(item.page, appsInPage);
    };

    // Step.02 排序已有的页码数组
    const pageNumbers: number[] = Array.from(oldPagingAppsMap.keys());
    pageNumbers.sort((a, b) => {
      return a - b;
    });
    log.showInfo(`Old page numbers: ${JSON.stringify(pageNumbers)}`);


    // Step.03 检查是否页内app数量超过满页的情况，如果有需要重新分页
    let fullPageAppCount = this.mAppGridStyleConfig.mRows * this.mAppGridStyleConfig.mColumns;
    let redundantApps: AppItemInfo[] = [];
    pageNumbers.forEach((page: number) => {
      let appsInPage: AppItemInfo[] = oldPagingAppsMap.get(page);
      if (appsInPage.length > fullPageAppCount) {
        log.showInfo(`Apps count exceed in page-${page}-${appsInPage.length}`);
        let curRedundant = appsInPage.splice(fullPageAppCount);
        redundantApps.push(...curRedundant);
        log.showInfo(`Apps count exceed in page-${page}-rdt-${redundantApps.length}-${appsInPage.length}`);
      }
    });

    if (redundantApps.length > 0) {
      let originAppCount = redundantApps.length;
      let newPagesCount = Math.floor(redundantApps.length / fullPageAppCount);
      let leftAppCount = redundantApps.length % fullPageAppCount;
      let tailPageIdx = pageNumbers[pageNumbers.length - 1];
      log.showInfo(`Apps count exceed so repaging-${newPagesCount}-${originAppCount}-${leftAppCount}-${tailPageIdx}`);

      // 如果有多页app数据需要重新分页则先整页分组
      let firstNewPageIdx = tailPageIdx + 1;
      let curNewPageIdx = firstNewPageIdx;
      for (let i = 0; i < newPagesCount; ++i) {
        curNewPageIdx = firstNewPageIdx + i;
        let curAppsInPage: AppItemInfo[] = redundantApps.splice(0, fullPageAppCount);
        curAppsInPage.forEach((item: AppItemInfo) => {
          item.page = curNewPageIdx;
        });
        pageNumbers.push(curNewPageIdx);
        oldPagingAppsMap.set(curNewPageIdx, curAppsInPage);
        log.showInfo(`Add a new page for ${curNewPageIdx}-${redundantApps.length}`);
      }

      // 若还有剩余app，则安排剩余app到最后一页
      if (redundantApps.length > 0) {
        let finalPageIdx = tailPageIdx + 1;
        if (originAppCount > redundantApps.length) {
          finalPageIdx = curNewPageIdx + 1;
        }
        redundantApps.forEach((item: AppItemInfo) => {
          item.page = finalPageIdx;
        });
        oldPagingAppsMap.set(finalPageIdx, redundantApps);
        pageNumbers.push(finalPageIdx);
        log.showInfo(`Add the final new page for ${tailPageIdx}-${finalPageIdx}`);
      }

      pageNumbers.sort((a, b) => {
        return a - b;
      });
      log.showInfo(`Page numbers after repaging: ${JSON.stringify(pageNumbers)}`);
    }

    // Step.04 排序那些新增的App列表
    log.showInfo(`new Apps length: ${newAppsFromBms.length}`);
    newAppsFromBms.sort((a, b): number => {
      return this.mPinyinSort.sortByParameter(a.appName, b.appName);
    });

    // Step.05 把新增的App安排到每一个页面上，尽可能填空
    let newAppsFromBms2 = [...newAppsFromBms];
    let cols = this.getFixedColumnCount();
    let appCenterLayoutInfo: AppLayoutInfo[] = [];
    pageNumbers.forEach((page: number) => {
      let appLayoutItem: AppLayoutInfo = new AppLayoutInfo();
      appLayoutItem.pageInfo = oldPagingAppsMap.get(page);
      log.showInfo(`Page App len: ${page}-${appLayoutItem.pageInfo.length}`);
      appLayoutItem.index = page;
      appLayoutItem.packageChangeTime = new Date().getTime();
      this.positionNewAppsInPage(appLayoutItem.pageInfo, newAppsFromBms2, page, fullPageAppCount, cols);
      this.sortAppsInPage(appLayoutItem.pageInfo);
      appCenterLayoutInfo.push(appLayoutItem);
    });

    // Step.06 如果新增的App还有剩下没安排完的，那说明需要进一步增加新页来承载了
    log.showInfo(`new Apps not arranged: ${newAppsFromBms2.length}`);
    if (newAppsFromBms2.length > 0) { // 假定剩余的不大于一页数据，不太可能出现这种情况
      let finalPage = pageNumbers[pageNumbers.length - 1] + 1;
      log.showInfo(`new page arranged: ${finalPage}`);
      let appLayoutItem: AppLayoutInfo = new AppLayoutInfo();
      appLayoutItem.index = finalPage;
      appLayoutItem.packageChangeTime = new Date().getTime();
      appLayoutItem.pageInfo = [];
      this.positionNewAppsInPage(appLayoutItem.pageInfo, newAppsFromBms2, finalPage, fullPageAppCount, cols);
      appCenterLayoutInfo.push(appLayoutItem);
    }

    // Step.07 矫正每一个页面的App数据的坐标信息，确保无空位，且是连续的
    appCenterLayoutInfo.forEach((app: AppLayoutInfo) => {
      let appCount = app.pageInfo.length;
      let sequencesInPage = new Set<number>();
      app.pageInfo.forEach((item: AppItemInfo) => {
        sequencesInPage.add(this.getSequenceInPage(item.row ?? 0, item.column ?? 0, cols));
      });

      log.showInfo(`Reorder row and column of app in page-${app.index}-${appCount}`);
      for (let i = 0; i < appCount; ++i) {
        let r = Math.floor(i / cols);
        let c = i % cols;
        let valid = app.pageInfo[i].row === r && app.pageInfo[i].column === c;
        if (!valid) {
          log.showInfo(`App repositioned: ${i}-${app.pageInfo[i].row}-` +
            `${app.pageInfo[i].column}-${app.index}-${app.pageInfo[i].bundleName}`);
          app.pageInfo[i].row = r;
          app.pageInfo[i].column = c;
        }
      }
    });

    // Step.08 矫正每一个页面的页码信息，确保无空位，且是连续的
    let needJustifyPageNumbers: boolean = false;
    if (pageNumbers.length > 0) {
      needJustifyPageNumbers = pageNumbers[pageNumbers.length - 1] !== pageNumbers.length - 1;
    }
    if (needJustifyPageNumbers) {
      log.showInfo(`Reorder page numbers start: ${JSON.stringify(pageNumbers)}`);
      appCenterLayoutInfo.sort((a, b) => {
        return a.index - b.index;
      });
      for (let i = 0; i < appCenterLayoutInfo.length; i++) {
        if (i === appCenterLayoutInfo[i].index) {
          continue;
        }
        log.showInfo(`Reorder page number ${appCenterLayoutInfo[i].index} to ${i}`);
        appCenterLayoutInfo[i].index = i;
        appCenterLayoutInfo[i].pageInfo.forEach((info) => {
          info.page = i;
        });
      }
    }

    return appCenterLayoutInfo;
  }

  private positionNewAppsInPage(curAppsOnPage: AppItemInfo[], apps2Arrange: AppItemInfo[], page: number,
    fullPageAppCount: number, cols: number): boolean {
    log.showInfo(`positionNewAppsInPage, cur len: ${cols}-${page}-${curAppsOnPage.length}-${apps2Arrange.length}`);

    // 页满则直接返回
    if (curAppsOnPage.length === fullPageAppCount || apps2Arrange.length === 0) {
      log.showInfo(`positionNewAppsInPage: page full or no apps 2 arrange ${page}-${apps2Arrange.length}`);
      return false;
    }

    let emptyPosCount = fullPageAppCount - curAppsOnPage.length;
    log.showInfo(`positionNewAppsInPage: emptyPosCount on page ${emptyPosCount}`);

    // 已有的业内App的一维索引编号的集合 - 假设行列信息没有重复的
    let oldSequencesInPage = new Set<number>();
    curAppsOnPage.forEach((item: AppItemInfo) => {
      let r = item.row ?? 0;
      let c = item.column ?? 0;
      oldSequencesInPage.add(this.getSequenceInPage(r, c, cols));
    });

    let putCount: number = 0;
    for (let i = 0; i < fullPageAppCount && putCount < emptyPosCount && apps2Arrange.length > 0; ++i) {
      if (!oldSequencesInPage.has(i)) {
        let item: AppItemInfo | undefined = apps2Arrange.shift();
        log.showInfo(`positionNewAppsInPage, left apps : ${apps2Arrange.length}`);
        if (item) {
          item.page = page;
          item.column = i % cols;
          item.row = Math.floor(i / cols);
          curAppsOnPage.push(item);
          ++putCount;
        }
      }
    }

    log.showInfo(`positionNewAppsInPage: left apps: ${apps2Arrange.length}-${curAppsOnPage.length}`);
    return true;
  }

  private getSequenceInPage(i: number, j: number, cols: number): number {
    return i * cols + j;
  }

  private sortAppsInPage(pageData: AppItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(pageData)) {
      log.showWarn(`sortAppsInPage input data undefined`);
      return;
    }

    pageData.sort((item1: AppItemInfo, item2: AppItemInfo) => {
      if (item1.row === item2.row) {
        return (item1.column === undefined || item2.column === undefined) ? 1 : item1.column - item2.column;
      } else {
        return (item1.row === undefined || item2.row === undefined) ? 1 : item1.row - item2.row;
      }
    });
  }

  private getFixedColumnCount(): number {
    if (FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      return FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS;
    } else {
      return this.mAppGridStyleConfig.mColumns;
    }
  }

  private getItemKey(item: AppItemInfo | AppGridItemInfo) {
    return item ? `${item.bundleName}-${item.appIndex}` : '';
  }

  private onPackageAdded(newAddItem: AppItemInfo | undefined): void {
    log.showInfo('onPackageAdded');
    if (!newAddItem) {
      return;
    }
    let cachedLayoutItemList = AppStorage.get<AppLayoutInfo[]>('appCenterLayoutInfo') as AppLayoutInfo[];
    if (!cachedLayoutItemList) {
      log.showWarn('cachedLayoutItemList empty');
      return;
    }
    let isExist = false;
    cachedLayoutItemList.forEach((gridItemInfo: AppLayoutInfo) => {
      gridItemInfo.pageInfo.forEach((item: AppItemInfo) => {
        if (item.bundleName === newAddItem.bundleName && item.appIndex === newAddItem.appIndex) {
          log.showInfo(`onPackageAdded finditem  : ${newAddItem.bundleName},iconId:${newAddItem.appIconId} lableId:${newAddItem.appLabelId}`);
          newAddItem.appStatus = AppStatus.INSTALLED;
          newAddItem.row = item.row;
          newAddItem.column = item.column;
          newAddItem.page = item.page;
          item.appStatus = AppStatus.INSTALLED;
          item.abilityName = newAddItem.abilityName;
          item.moduleName = newAddItem.moduleName;
          item.appName = newAddItem.appName;
          item.appIndex = newAddItem.appIndex;
          item.appLabelId = newAddItem.appLabelId;
          item.appIconId = newAddItem.appIconId;
          item.applicationLabelId = newAddItem.applicationLabelId;
          item.isUninstallAble = newAddItem.isUninstallAble;
          item.keyName =
            item.bundleName + item.abilityName + item.moduleName + item.appIndex;
          item.enableNewAppInstance = newAddItem.enableNewAppInstance;
          item.intent = newAddItem.intent;
          isExist = true;
        }
      });
    })
    log.showInfo('findPositionOnPage');
    // 数据存在则更新数据库，否则插入数据库
    let scene = FeatureConstants.AC_SCENE_DFT;
    if (isExist) {
      RdbStoreManager.getInstance()
        .updateAppCenterItemPositions([FoldedDeviceAcViewModel.getInstance()
          .transformToPortrait(AppGridItemInfo.newInstanceFromAppItemInfo(newAddItem))]);
      scene = FeatureConstants.AC_SCENE_APP_LIFE_PKG_ADD_INSTALLED;
    } else {
      AppCenterViewModel.getInstance().findPositionOnPage(cachedLayoutItemList, [newAddItem]);
      // 数据库如果不存在则不插入取BMS数据
      RdbStoreManager.getInstance().queryAppCenter().then((appCenterGridData: AppGridItemInfo[]) => {
        if (!CheckEmptyUtils.isEmptyArr(appCenterGridData)) {
          RdbStoreManager.getInstance().insertAppCenter([FoldedDeviceAcViewModel.getInstance()
            .transformToPortrait(AppGridItemInfo.newInstanceFromAppItemInfo(newAddItem))]);
        }
      });
      scene = FeatureConstants.AC_SCENE_APP_LIFE_PKG_ADD_INIT;
    }
    this.mAppGridLayoutCacheManager.updateAppPageList(cachedLayoutItemList, newAddItem);
    this.refreshAppGridLayout(scene);
  }

  private onPackageRemoved(bundleName: string | undefined, appIndex?: number): void {
    log.showInfo('onPackageRemoved');
    this.mAppGridLayoutCacheManager.deleteCachedLayoutItem(bundleName ?? '', true, appIndex);
    this.refreshAppGridLayout(FeatureConstants.AC_SCENE_APP_LIFE_PKG_REMOVED);
  }

  /**
   * 应用中心处理应用生命周期事件：安装、卸载、更新、系统初始化
   *
   * @param appItemList
   * @param event
   * @param bundleName
   */
  public async regroupDataAppListChange(appItemList: Array<AppItemInfo>, event: string, bundleName?: string,
    appIndex?: number) {
    log.showInfo(`regroupDataAppListChange：${event} app list len:${appItemList?.length} bundleName:${bundleName}`);
    let needHideApp = this.checkNeedHideApp(bundleName);
    if (needHideApp && bundleName !== undefined) {
      return;
    }

    if (event === EventConstants.EVENT_PACKAGE_ADDED) {
      let downloadStatusInfo: DownloadStatusInfo | undefined = AppGalleryDownloadManager.getInstance()
        .getDownDownloadTaskInfo(bundleName);
      if (downloadStatusInfo) {
        this.registerInstalledAniFinishCallback(bundleName as string);
      }
    }
    // 获取应用名称：需兼顾多语言切换的场景
    for (let item of appItemList) {
      if (!item) {
        continue;
      }
      let bundleName: string = item.bundleName === undefined ? '' : item.bundleName;
      let modName: string = item.moduleName === undefined ? '' : item.moduleName;
      let cacheKey: string = item.appLabelId + bundleName + modName;
      let appName = this.mResourceManager.getAppResourceCache(cacheKey, CACHE_TYPE_NAME);
      if (appName != null && typeof appName === 'string') {
        item.appName = appName;
      } else {
        let itemAppName: string = item.appName === undefined ? '' : item.appName;
        let loadAppName = await this.mResourceManager.getAppNameSync(item.appLabelId, bundleName, modName, itemAppName);
        item.appName = loadAppName;
      }
      if (bundleName === CONTACTS_BUNDLE_NAME) {
        item.appName = await this.mResourceManager.getAbilityAppName(
          item.bundleName, item.moduleName, item.abilityName);
      }
    }
    let packageChangeTime: number = 0;
    if (event === EventConstants.EVENT_PACKAGE_CHANGED || event === EventConstants.EVENT_PACKAGE_ADDED) {
      packageChangeTime = new Date().getTime();
    }
    // 安装
    if (event === EventConstants.EVENT_PACKAGE_ADDED) {
      let newAddItem: AppItemInfo | undefined = appItemList.find((item: AppItemInfo) => {
        return item.bundleName === bundleName && item.appIndex === appIndex;
      })
      if (newAddItem && appIndex) {
        newAddItem.appIndex = appIndex;
      }
      log.showInfo(`onPackageAdded：${newAddItem?.bundleName} moduleName ${newAddItem?.moduleName}  moduleName ${newAddItem?.abilityName}`);
      this.onPackageAdded(newAddItem);
      return;
    }
    // 修改
    if (event === EventConstants.EVENT_PACKAGE_CHANGED) {
      let changeAppItem: AppItemInfo | undefined = appItemList.find((item: AppItemInfo) => {
        return item.bundleName === bundleName && item.appIndex === appIndex;
      })
      log.showInfo(`onPackageChange：${changeAppItem?.bundleName} moduleName ${changeAppItem?.moduleName}  moduleName ${changeAppItem?.abilityName}`);
      this.onPackageChanged(changeAppItem);
      return;
    }
    // 卸载
    if (event === EventConstants.EVENT_PACKAGE_REMOVED) {
      this.onPackageRemoved(bundleName, appIndex);
      return;
    }

    // 执行应用中心应用列表排序
    appItemList.sort((a, b): number => {
      return this.mPinyinSort.sortByParameter(a.appName, b.appName);
    });

    // SCB启动初始化则直接返回
    if (event === EventConstants.EVENT_INIT_APPLIST_FINISH) {
      // 如果已经有了数据缓存，则不需要再次分页，否则会打乱数据
      const pagedAppData = AppCenterViewModel.getInstance().doAppCenterDataPaging(appItemList, packageChangeTime);
      this.mAppGridLayoutCacheManager.putAppItemToGrid(pagedAppData);
      this.mAppGridLayoutCacheManager.setAppGridLayoutItemList(pagedAppData);
      this.refreshAppGridLayout(FeatureConstants.AC_SCENE_APPS_REORDER);
      return;
    }

    // 应用图标重组排列的动效：安装、卸载、更新、分辨率、DPI变化
    animateTo({
      duration: 500,
      curve: Curve.Friction,
      playMode: PlayMode.Normal,
      iterations: 1,
      onFinish: () => {
      }
    }, () => {
      const pagedAppData = AppCenterViewModel.getInstance().doAppCenterDataPaging(appItemList, packageChangeTime);
      this.mAppGridLayoutCacheManager.putAppItemToGrid(pagedAppData);
      this.mAppGridLayoutCacheManager.setAppGridLayoutItemList(pagedAppData);
      this.refreshAppGridLayout(FeatureConstants.AC_SCENE_ENV_CHANGED);
    });
  }

  // 更新缓存数据
  private onPackageChanged(newAddItem: AppItemInfo | undefined): void {
    log.showInfo('onPackageChanged');
    if (!newAddItem) {
      return;
    }
    let cachedLayoutItemList = AppStorage.get<AppLayoutInfo[]>('appCenterLayoutInfo') as AppLayoutInfo[];
    if (!cachedLayoutItemList) {
      log.showInfo(`cachedLayoutItemList empty`);
      // 更新系统字段
      RdbStoreManager.getInstance().updateAppCenterSys([AppGridItemInfo.newInstanceFromAppItemInfo(newAddItem)]);
    } else {
      let isExist = false;
      cachedLayoutItemList?.forEach((gridItemInfo: AppLayoutInfo) => {
        gridItemInfo?.pageInfo?.forEach((item: AppItemInfo) => {
          if (item.bundleName === newAddItem.bundleName && item.appIndex === newAddItem.appIndex) {
            log.showInfo(`onPackageChanged finditem: ${newAddItem.bundleName},abilityName:${newAddItem.abilityName} moduleName:${newAddItem.moduleName} iconId:${newAddItem.appIconId} lableId:${newAddItem.appLabelId}`);
            newAddItem.appStatus = AppStatus.INSTALLED;
            newAddItem.row = item.row;
            newAddItem.column = item.column;
            newAddItem.page = item.page;
            item.appStatus = AppStatus.INSTALLED;
            item.abilityName = newAddItem.abilityName;
            item.moduleName = newAddItem.moduleName;
            item.appName = newAddItem.appName;
            item.appIndex = newAddItem.appIndex;
            item.appLabelId = newAddItem.appLabelId;
            item.appIconId = newAddItem.appIconId;
            item.applicationLabelId = newAddItem.applicationLabelId;
            item.isUninstallAble = newAddItem.isUninstallAble;
            item.enableNewAppInstance = newAddItem.enableNewAppInstance;
            item.intent = newAddItem.intent;
            isExist = true;
            item.keyName =
              item.bundleName + item.abilityName + item.moduleName + item.appIndex;
          }
        });
      })
      log.showInfo(`onPackageChanged finish. isExist:${isExist}, ${cachedLayoutItemList?.length}`);
      // 数据存在则更新数据库，否则插入数据库
      if (isExist) {
        RdbStoreManager.getInstance()
          .updateAppCenterItemPositions([FoldedDeviceAcViewModel.getInstance()
            .transformToPortrait(AppGridItemInfo.newInstanceFromAppItemInfo(newAddItem))]);
      }
      this.mAppGridLayoutCacheManager.setAndUpdateAppListForPkgChange(cachedLayoutItemList, newAddItem);
      this.refreshAppGridLayout(FeatureConstants.AC_SCENE_APP_LIFE_PKG_CHANGED);
    }
  }

  public informUninstallResult(resultCode: number) {
    if (resultCode === CommonConstants.UNINSTALL_FORBID) {
      log.showInfo('uninstall result: forbidden');
      try {
        promptAction.showToast({
          message: $r('app.string.disable_uninstall'),
          showMode: promptAction.ToastShowMode.TOP_MOST
        });
      } catch (error) {
        log.error('uninstall result: forbidden error', error);
      }
    } else if (resultCode === CommonConstants.UNINSTALL_SUCCESS) {
      log.showInfo('uninstall result: success');
      try {
        promptAction.showToast({
          message: $r('app.string.uninstall_success'),
          bottom: !FoldedDeviceAcViewModel.getInstance().isFoldedDevice() ?
            (LayoutViewModel.getInstance().getDockHeight() + 80) : undefined,
          showMode: promptAction.ToastShowMode.TOP_MOST
        });
      } catch (error) {
        log.error('uninstall result: success error', error);
      }
    } else {
      log.showInfo('uninstall result: failed');
      try {
        promptAction.showToast({
          message: $r('app.string.uninstall_failed'),
          showMode: promptAction.ToastShowMode.TOP_MOST
        });
      } catch (error) {
        log.error('uninstall result: failed error', error);
      }
    }
  }

  public intoSetting() {
    this.jumpToSetting();
  }

  private registerInstalledAniFinishCallback(bundleName: string): void {
    log.showInfo(`registerInstalledAniFinishCallback:${bundleName}`);
    if (!bundleName) {
      return;
    }
    const installAniFinishEvent: string = `appCenterInstallAniFinish${bundleName}${CommonConstants.MAIN_APP_INDEX}`;
    const eventHub: ctx.EventHub =
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.eventHub;
    if (installAniFinishEvent) {
      eventHub.off(installAniFinishEvent);
      eventHub.on(installAniFinishEvent, async (): Promise<void> => {
        eventHub.off(installAniFinishEvent);
      });
      let appGalleryEventInfo: AppGalleryEventInfo = {
        bundleName: bundleName,
        eventType: InstallStatusChangeEvent.INSTALL_STATUS_CHANGE,
        status: AppStatus.INSTALLED as number,
      };
      eventHub.emit(`appGalleryStatusChange${bundleName}${CommonConstants.MAIN_APP_INDEX}icon`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${CommonConstants.MAIN_APP_INDEX}appCenter`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${CommonConstants.MAIN_APP_INDEX}name`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${CommonConstants.MAIN_APP_INDEX}folder`, appGalleryEventInfo);
      eventHub.emit(`appGalleryStatusChange${bundleName}${CommonConstants.MAIN_APP_INDEX}smallFolder`, appGalleryEventInfo);
      let appItem: BaseIconInfo = {
        bundleName: bundleName as string,
        abilityName: ''
      };
      RdbStoreManager.getInstance().deleteGridLayoutByCondition(appItem, CommonConstants.INVALID_VALUE);
      this.updateNewInstalledGridInfo(appItem.bundleName, appItem.appIndex);
      AppGalleryDownloadManager.getInstance().deleteDownloadTaskInfo(bundleName);
      AppGalleryDownloadManager.getInstance().deleteDownloadProgressInfo(bundleName);
    }
  }

  private updateNewInstalledGridInfo(bundleName: string, appIndex?: number): void {
    // 更新新安装数据
    let newApp: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleInfo({
      bundleName: bundleName,
      appIndex: appIndex ?? 0
    });
    if (newApp) {
      let originItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      originItem.bundleName = newApp.bundleName;
      originItem.appName = newApp.appName;
      originItem.applicationName = newApp.applicationName;
      originItem.applicationLabelId = newApp.applicationLabelId;
      originItem.appIconId = newApp.appIconId;
      originItem.appLabelId = newApp.appLabelId;
      originItem.isUninstallAble = newApp?.isUninstallAble;
      originItem.isSystemApp = newApp?.isSystemApp;
      originItem.installTime = newApp.installTime;
      originItem.moduleName = newApp.moduleName;
      originItem.abilityName = newApp.abilityName;
      originItem.keyName = newApp.keyName;
      originItem.appStatus = AppStatus.INSTALLED;
      log.showInfo(`updateNewInstalledGridInfo originItem.moduleName = ${originItem.moduleName}, originItem.abilityName = ${originItem.abilityName}`);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_FINISH, [originItem]);
    }
  }

  public buildNotInstalledAppMenu(bundleName: string): Map<AppStatus, MenuInfo[]> {
    let notInstalledMenuMap: Map<AppStatus, MenuInfo[]> = new Map();
    let removeInfo: MenuInfo = new MenuInfo();
    removeInfo.menuType = CommonConstants.MENU_TYPE_FIXED;
    removeInfo.menuImgSrc = '/common/pics/ic_public_remove.svg';
    removeInfo.menuText = $r('app.string.delete_app');
    removeInfo.onMenuClick = (): void => {
      log.showInfo('remove this app');
      this.deleteAppCenterItem(bundleName);
      this.onPackageRemoved(bundleName);
      //  调用AG移除接口
      AppInstallUtils.getInstance().cancelTask(bundleName);
      AppStorage.setOrCreate('openFolderStatus', CommonConstants.OPEN_FOLDER_STATUS_CLOSE);
    };
    notInstalledMenuMap.set(AppStatus.PENDING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.PENDING, []);
    notInstalledMenuMap.set(AppStatus.WAITING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.DOWNLOADING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.UPDATING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.WIFI_WAITING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.PAUSING, [removeInfo]);
    notInstalledMenuMap.set(AppStatus.INSTALL_WAITING, []);
    notInstalledMenuMap.set(AppStatus.INSTALLING, []);
    return notInstalledMenuMap;
  }

  public deleteInstallFailApp(bundleName?: string): void {
    this.deleteAppCenterItem(bundleName);
    this.onPackageRemoved(bundleName);
  }

  deleteAppCenterItem(bundleName?: string): void {
    let appItem: BaseIconInfo = {
      bundleName: bundleName as string,
      abilityName: ''
    };
    RdbStoreManager.getInstance().deleteGridLayoutByCondition(appItem, CommonConstants.INVALID_VALUE);
    let index = this.mInstallingInfoList.findIndex((item) => {
      return bundleName === item.bundleName;
    });
    if (index !== CommonConstants.INVALID_VALUE) {
      this.mInstallingInfoList.splice(index, 1);
    }
    return;
  }

  /**
   * Open application function.
   *
   * @param {string} abilityName - ability name of the application to be jump to.
   * @param {string} bundleName - bundle name of the application to be jump to.
   */
  public openApplication(abilityName: string, bundleName: string,
    moduleName: string, params?: Map<string, Object>, screenId?: number) {
    log.showInfo(`open app abilityName: ${abilityName}, bundleName: ${bundleName}, moduleName: ${moduleName} params: ${params?.get(SCBConstants.START_APP_CLONE_INDEX)}`);
    this.jumpTo(abilityName, bundleName, moduleName, params, screenId);
  }

  /***
   * it镜像企业空间内隐藏应用市场
   * 条件：1. it镜像 2.企业空间 3.企业域账号
   */
  private enterpriseSpaceHideAppGallery(appList: AppItemInfo[]): AppItemInfo[] {
    log.showInfo('enterpriseSpaceHideAppGallery: appList length' + appList?.length);

    let envCheckPass = EnterpriseSpaceUtil.envCheck();
    if (envCheckPass) {
      appList = appList.filter((item: AppItemInfo) => !EnterpriseSpaceUtil.isAppNeedHidden(item.bundleName));
      log.showInfo('appList removed APP_GALLERY,length:' + appList?.length);
    }

    return appList;
  }

  /***
   * it镜像企业空间内隐藏应用市场检查
   * 条件：1. it镜像 4.包名是否在vpn配置中
   */
  private checkNeedHideApp(bundleName?:string): boolean {
    let envCheckPass = EnterpriseSpaceUtil.envCheck();
    return envCheckPass && EnterpriseSpaceUtil.isAppNeedHidden(bundleName);
  }

  /***
   * 监听oobe事件，it镜像企业空间中隐藏应用市场
   */
  private oobeEventListen(): void {
    log.showInfo('oobeEventListen start');

    const onOOBEChange = (enable: boolean) => {
      log.showInfo(`Oobe state change ${enable}`);

      if (!enable) {
        const isPass = EnterpriseSpaceUtil.envCheck();
        log.showInfo(`EnterpriseSpaceUtil envCheck exec`);

        if (isPass) {
          log.showInfo(`appcenter hide appgallery`);
          EnterpriseSpaceUtil.getNeedHiddenAppList().forEach((bundleName) => {
            this.onPackageRemoved(bundleName);
          });
        }
      }
    };

    log.showWarn('subscribe start');
    sEventManager.subscribe(OOBE_CHANGE_EVENT, onOOBEChange);
    sEventManager.subscribe(OTA_OOBE_CHANGE_EVENT, onOOBEChange);
  }

  private vpnEventListen(): void {
    EnterpriseSpaceUtil.onvpnConfigChange(() => {
      log.showInfo(`vpn event listen callback`);
      const pass: boolean = EnterpriseSpaceUtil.envCheck();
      log.showInfo(`vpn envCheck result: ${pass}`);
      if (!pass) {
        log.showWarn(`enterorise space check not pass`);
        return;
      }
      EnterpriseSpaceUtil.getNeedHiddenAppList().forEach((bundleName) => {
        log.showInfo(`applist removed app: ${bundleName}`);
        this.onPackageRemoved(bundleName);
      });
    });
  }
}