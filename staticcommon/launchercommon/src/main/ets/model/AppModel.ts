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

import {
  EventConstants as StaticEventConstants
} from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import type { ShortcutInfo } from '../bean/ReceiveEventInfo';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import type { CommonEventSubscribeInfo } from 'commonEvent/commonEventSubscribeInfo';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventData } from 'commonEvent/commonEventData';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  CommonUtils,
} from '@ohos/basicutils';
import {
  localEventManager,
  HiDfxEventUtil,
  LogCollectUtil,
  AccountEvent,
  DeviceHelper,
  EvtBus,
  ResourceManager,
  AccountMgr,
  HiSysEventUtil,
  IconResourceManager,
  PackageCommonEvent,
  onLineThemeUtil,
  SettingsUtil
} from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { EventConstants } from '../constants/EventConstants';
import { CommonConstants, DeleteItemType } from '../constants/CommonConstants';
import { FormModel } from './FormModel';
import { AppItemInfo } from '../bean/AppItemInfo';
import { DockItemInfo } from '../bean/DockItemInfo';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import { launcherAbilityManager } from '../abilitymanager/LauncherAbilityManager';
import { AtomicServiceAppModel } from './AtomicServiceAppModel';
import SystemApplication from '../configs/SystemApplication';
import { RdbStoreManager } from '../db/RdbStoreManager';

import taskpool from '@ohos.taskpool';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import HashSet from '@ohos.util.HashSet';
import commonEventManager from '@ohos.commonEventManager';
import {
  AppGalleryDownloadManager,
  AppStatus,
  lockedAppUninstallModel,
  GetHideAppsFromConfig,
  AdaptiveIconManager,
} from '../TsIndex';
import { BaseBundleInfo } from '../bean/BaseBundleInfo';
import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { LoadHideAppType } from '@ohos/commonconstants/src/main/ets/constants/Constants';
import AppUpdateUtils from '../utils/AppUpdateUtils';
import { SettingsConstants, SettingsKeyConstants, UpdateType } from '@ohos/commonconstants';
import { HashMap } from '@kit.ArkTS';
import { RefreshStrategyManager } from './layoutRefresh/RefreshStrategyManager';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'AppModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MULTI_ICON_NUMBER: number = 2;
const KEY_NAME = 'name';
const KEY_ICON = 'icon';
const ADAPTIVE_ICON = 'adaptiveicon';
const DELIVER_APP_CODE_PATH = '1';
const ohos_APPLICATION = '1';
const INVALID_ICON_ID: number = 0;
const MAX_SHORTCUT_LENGTH: number = 4;
const LANGUAGE_CHANGE_LABEL_ZERO: string = '0';
const LANGUAGE_CHANGE_LABEL_ONE: string = '1';
const DELETE_APP_BATCH_COUNT: number = 50;
const DELETE_APP_DELAY: number = 200;
const PERMISSION_GET_BUNDLE_RESOURCES: string = 'ohos.permission.GET_BUNDLE_RESOURCES';
type ListenerType = (event: string, bundleName: string, userId: number, appIndex?: number) => void;
export type StateChangeType = (appList: AppItemInfo[], event: string, bundleName: string, appIndex?: number) => void

/**
 * Desktop application information data model.
 */
export class AppModel {
  private static mInstance: AppModel;
  private mBundleInfoList: AppItemInfo[] = [];
  private readonly mSystemApplicationName: string[] = [];
  private readonly mAppStateChangeListener: StateChangeType[] = [];
  private readonly mShortcutInfoMap = new Map<string, ShortcutInfo[]>();
  private readonly mFormModel: FormModel;
  private readonly mInstallationListener: ListenerType;
  private readonly mAtomicServiceAppModel: AtomicServiceAppModel;
  private readonly mBundleInfoMap = new Map<string, AppItemInfo>();
  private readonly mCloneInfoMap: Map<string, Set<number>> = new Map<string, Set<number>>();
  private mOperationItemInfo: AppItemInfo | undefined;
  private mIsFirstTime: boolean = true;
  public mIsChangeTheme: boolean = false;
  private mIsLoadFinish: boolean = false;
  private callBack: Function[] = [];
  private mMultiIconAppMap = new Map<string, number>();
  private mIsMultiIconAppMapInit: boolean = false;
  private eventSubscribers: CommonEventSubscriber[] = [];
  private mIconChangeListener: IconChangeListener[] = [];
  private resourceChangeListeners: ResourceChangeListener[] = [];
  private deleteAppList: DeleteItemType[] = [];
  private deleteAppTimeId: number = 0;
  private readonly imageNames: string[] = [
    'ic_calendar_background',
    'ic_deskclock_background',
    'ic_deskclock_dial',
    'ic_deskclock_hour',
    'ic_deskclock_minute',
    'ic_deskclock_second'
  ];

  private constructor() {
    log.showInfo('constructor start');
    this.mSystemApplicationName = SystemApplication.systemApplicationName.split(',');
    this.mFormModel = FormModel.getInstance();
    this.mInstallationListener = this.installationSubscriberCallBack.bind(this);
    this.mAtomicServiceAppModel = AtomicServiceAppModel.getInstance();
    LogCollectUtil.getInstance().registerCollectLogCallback(TAG, (collectLogTag: string) => {
      const logCollect: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, collectLogTag);
      logCollect.showInfo(`current apps num = ${this.mBundleInfoList.length}`);
    });
    EvtBus.on(AccountEvent, (event) => {
      log.showInfo('user change need reload App list');
      if (AccountMgr.isInvalidAccount(event?.accountInfo?.localId)) {
        log.showInfo('setCurrentUserId user id err');
        return;
      }
      launcherAbilityManager.setCurrentUserId(event?.accountInfo?.localId);
      this.loadAppList(true);
    });
    EvtBus.on(PackageCommonEvent, (event) => this.handlePackageEvent(event));
    this.subscribeBundleResourceChangeEvent();
    this.subscribeShortcutChangeEvent();
    IconResourceManager.getInstance().setAppIconIdLoader(this);
  }

  /**
   * 获取应用的iconId
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @returns iconId
   */
  public getAppItemIconId(bundleName: string, moduleName: string, abilityName: string): number {
    let appItemInfos = this.mBundleInfoList.filter((appItemInfo) => {
        return appItemInfo.bundleName === bundleName &&
        appItemInfo.moduleName === moduleName &&
        appItemInfo.abilityName === abilityName;
    });
    if (CommonUtils.containerIsEmpty(appItemInfos)) {
      return INVALID_ICON_ID;
    } else {
      return appItemInfos[0].appIconId;
    }

  }

  onDownloadCanceled(event: string, bundleName: string, appIndex: number): void {
    this.installationSubscriberCallBack(event, bundleName, this.getUserId(), appIndex);
  }

  /**
   * Get the application data model object.
   *
   * @return {object} application data model singleton
   */
  static getInstance(): AppModel {
    if (AppModel.mInstance == null) {
      AppModel.mInstance = new AppModel();
    }
    return AppModel.mInstance;
  }

  private handlePackageEvent(event: PackageCommonEvent): void {
    if (!event || CommonUtils.isInvalid(event.event)) {
      log.showWarn('handlePackageEvent package event unknown');
      return;
    }
    if (event.userId && event.userId !== this.getUserId()) {
      log.showWarn('user is not current');
      return;
    }
    log.showInfo('handlePackageEvent event: %{public}s bundleName: %{public}s isEnableDynamicIcon: %{public}s',
      event.event, event.bundleName, event.isEnableDynamicIcon);
    if (event.event === EventConstants.EVENT_DYNAMIC_ICON_CHANGED) {
      // 收到广播，清空缓存通知图标更新
      IconResourceManager.getInstance().deleteIconResource(event.bundleName, UpdateType.UPDATE,
        event.appIndex).then(() => {
        AdaptiveIconManager.getInstance().deleteIconResource(event.bundleName);
        localEventManager.sendLocalEvent(`updateIconImage_${event.bundleName}`);
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE, event.bundleName);
        localEventManager.sendLocalEventSticky(StaticEventConstants.EVENT_REFRESH_SMALL_FOLDER_IMAGE, [event.bundleName]);
      });
    }
    if (event.event === EventConstants.EVENT_PACKAGE_CHANGED || event.event === EventConstants.EVENT_PACKAGE_ADDED ||
      event.event === EventConstants.EVENT_PACKAGE_REMOVED) {
      log.showInfo(`handlePackageEvent: update game engine valid status, event info: ${event.event}`);
      this.updateGameEngineValidStatus(event.bundleName ?? '');
      AdaptiveIconManager.getInstance().deleteIconResource(event.bundleName ?? '');
    }
  }

  public registerIconChangeListener(listener: IconChangeListener): void {
    if (this.mIconChangeListener.indexOf(listener) === CommonConstants.INVALID_VALUE) {
      this.mIconChangeListener.push(listener);
    }
  }

  public unregisterIconChangeListener(listener: IconChangeListener): void {
    let index: number = this.mIconChangeListener.indexOf(listener);
    if (index !== CommonConstants.INVALID_VALUE) {
      this.mIconChangeListener.splice(index, 1);
    }
  }

  public registerResourceChangeListener(listener: ResourceChangeListener): void {
    if (this.resourceChangeListeners.indexOf(listener) === CommonConstants.INVALID_VALUE) {
      this.resourceChangeListeners.push(listener);
      log.showInfo('register listener: %{public}s success', listener.id);
    }
  }

  public unregisterResourceChangeListener(listener: ResourceChangeListener): void {
    let index: number = this.resourceChangeListeners.indexOf(listener);
    if (index !== CommonConstants.INVALID_VALUE) {
      this.resourceChangeListeners.splice(index, 1);
      log.showInfo('unregister listener: %{public}s success', listener.id);
    }
  }

  private notifyClearCache(): void {
    this.resourceChangeListeners.forEach((listener: ResourceChangeListener) => {
      listener.clearCache();
      log.showInfo('notify listener: %{public}s clear cache success', listener.id);
    });
  }

  public getDesktopAppBundle(): Set<string> {
    let appBundleList: Set<string> = new Set(this.mBundleInfoMap.keys());
    log.showInfo(`appBundleList length: ${appBundleList.size}`);
    return appBundleList;
  }

  private deleteDynamicIconCache(): void {
    this.imageNames.forEach((name: string) => {
      ResourceManager.getInstance().deleteAppResourceCache(name, 'imageDescriptor');
    });
  }

  private async handleResourceChangeEvent(eventData: CommonEventData): Promise<void> {
    let bundleResourceChangeType: number = eventData?.parameters?.bundleResourceChangeType;
    let isLanguageChange: boolean =
      (bundleResourceChangeType & EventConstants.BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_LANGUAGE_CHANGE) !== 0;
    // PC多用户切换的时候 scb不会切进程，同一个进程有多个用户，所以切用户时，需要做一次语言切换
    let isUserIdChange: boolean = (bundleResourceChangeType &
      EventConstants.BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_USER_ID_CHANGE) !== 0 && DeviceHelper.isPC();
    // 语言切换，切换用户(针对PC多用户)场景刷新应用名称
    if (isLanguageChange || isUserIdChange) {
      this.updateInfoNameOfApp(isLanguageChange || isUserIdChange, false);
      this.mFormModel.updateFormsAppInfo();
    }
    let initAccountId = await AccountMgr.getInitAccountId();
    let uid: number = eventData?.parameters?.userId;
    log.showInfo(`BUNDLE_RESOURCES_CHANGED: initAccountId: ${initAccountId}, uid: ${uid}, changeType: ${bundleResourceChangeType}`);

    if (initAccountId !== uid) {
      return;
    }

    let isThemeChange: boolean =
      (bundleResourceChangeType & EventConstants.BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_THEME_CHANGE) !== 0;
    // 切换语言、隐私空间不清理图标缓存
    let isNeedClearCache: boolean = bundleResourceChangeType !== EventConstants.BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_LANGUAGE_CHANGE &&
      bundleResourceChangeType !== EventConstants.BUNDLE_RESOURCE_CHANGE_TYPE_SYSTEM_USER_ID_CHANGE;
    if (isNeedClearCache) {
      this.clearAppResourceCache();
    }
  }

  private async clearAppResourceCache(): Promise<void> {
    SettingsUtil.setValueEx(settings.domainName.USER_PROPERTY,
      SettingsKeyConstants.THEME_CHANGE_STATUS, SettingsConstants.THEME_CHANGE_STATUS_RUNNING);
    // 切换主题开始
    let startTime: number = new Date().getTime();
    this.mIsChangeTheme = true;
    this.notifyClearCache();
    // 清理动态图标缓存
    this.deleteDynamicIconCache();
    // 清除快捷图标缓存
    ResourceManager.getInstance().clearAppResourceCache();
    AdaptiveIconManager.getInstance().clearIconResources('bundle resource change');
    // 清除快捷图标背景图缓存
    let deliverAppIconInfosMap: Map<string, IconInfo> = new Map<string, IconInfo>();

    await IconResourceManager.getInstance().clearAppResourceCache(`${TAG} THEME_CHANGE`);
    await RefreshStrategyManager.getInstance().refreshLayout(this.mIconChangeListener, deliverAppIconInfosMap);
    this.mIsChangeTheme = false;
    // 切换主题结束
    let endTime: number = new Date().getTime()
    let costTime = endTime - startTime;
    // 切换主题耗时
    log.showWarn('Change thmeme cost: %{public}d', costTime);
    if (costTime > CommonConstants.FIVE_THOUSAND_MSECOND) {
      HiDfxEventUtil.reportChangeThemeTime(costTime);
    }
    let themeChangeStatus: string = SettingsUtil.getValueEx(settings.domainName.USER_PROPERTY,
      SettingsKeyConstants.THEME_CHANGE_STATUS, '');
    let status: string = themeChangeStatus === SettingsConstants.THEME_CHANGE_STATUS_STOP ?
      SettingsConstants.THEME_CHANGE_STATUS_STOP : SettingsConstants.THEME_CHANGE_STATUS_FINISH;
    SettingsUtil.setValueEx(settings.domainName.USER_PROPERTY,
      SettingsKeyConstants.THEME_CHANGE_STATUS, status);
  }

  async subscribeShortcutChangeEvent(): Promise<void> {
    this.subscribeEvent([EventConstants.EVENT_SHORTCUT_CHANGED], PERMISSION_GET_BUNDLE_RESOURCES,
      (eventData: PackageCommonEvent) => {
        this.updateShortcutInfo(eventData?.bundleName);
      });
  }

  async subscribeBundleResourceChangeEvent(): Promise<void> {
    this.subscribeEvent([EventConstants.EVENT_BUNDLE_RESOURCES_CHANGED], PERMISSION_GET_BUNDLE_RESOURCES,
      (eventData: CommonEventData) => {
        this.handleResourceChangeEvent(eventData);
      });
  }

  private subscribeEvent(events: string[], permission: string, handleCallBack: Function): void {
    const subscribeInfo: CommonEventSubscribeInfo = {
      events: events,
      publisherPermission: permission
    };
    try {
      commonEventManager.createSubscriber(subscribeInfo, (err, commonEventSubscriber) => {
        if (err) {
          log.showError(`Failed to create subscriber: ${events}`);
          return;
        }
        if (CheckEmptyUtils.isEmpty(commonEventSubscriber)) {
          log.showError('Failed to create subscriber: subscriber is empty.');
          return;
        }
        log.showInfo(`Success to create subscriber: ${events}`);
        this.eventSubscribers.push(commonEventSubscriber);
        commonEventManager.subscribe(commonEventSubscriber, async (err, eventData): Promise<void> => {
          if (err && err.code !== 0) {
            log.showError(`Can't handle common event, err: ${err.message}`);
            return;
          }
          log.showInfo(`Receive event: ${eventData?.event}`);
          await handleCallBack(eventData);
        });
      });
    } catch (err) {
      log.showError('Failed to create subscriber: ' + err);
    }
  }

  /**
   * 异步加载应用列表
   */
  async loadAppList(isFirstLoad?: boolean, loadHideConfigType?: number): Promise<void> {
    let result: AppItemInfo[] | undefined;
    try {
      result = await this.getLauncherAbilityList();
      log.showInfo('load all app from bms success');
      // 初始化隐藏app配置文件 1.开机时加载系统预装的隐藏配置;2.oobe修改完隐藏配置刷新桌面重新加载
      if (isFirstLoad || loadHideConfigType === LoadHideAppType.LOAD_BY_REFRESH) {
        await GetHideAppsFromConfig.getInstance().loadHideConfig(loadHideConfigType);
        result = GetHideAppsFromConfig.getInstance().filterHideApp(result);
      }
    } catch (exception) {
      log.showError(`loadAppList exception: ${exception?.message},code ${exception?.code}`);
    }
    this.mIsLoadFinish = false;
    if (result && result.length > 0) {
      this.setAppListAsync(result, loadHideConfigType).then(() => {
        if (isFirstLoad) {
          this.initIconResource();
        }
      });
    } else {
      this.mIsLoadFinish = true;
      log.showWarn('loadAppList result is null');
    }
  }

  /**
   * taskpool 异步获取应用列表
   * @returns
   */
  public async getLauncherAbilityList(): Promise<AppItemInfo[]> {
    let result: AppItemInfo[] = <AppItemInfo[]> await taskpool
      .execute(new taskpool.Task('getLauncherAbilityList', getLauncherAbilityListTask,
        launcherAbilityManager.getUserId()));
    return result;
  }

  private initIconResource(): void {
    this.initMultiIconList();
    this.mIsMultiIconAppMapInit = true;
    this.initIconNameCache().then(() => {
      this.initBundleInfoNameAndCache();
    });
  }

  private initBundleInfoNameAndCache(): void {
    try {
      log.showWarn('initBundleInfoNameAndCache start');
      this.mBundleInfoList.forEach((appItem: AppItemInfo) => {
        let appName: string = IconResourceManager.getInstance().getCachedIconNameSync(appItem.bundleName,
          appItem.moduleName, appItem.abilityName);
        if (appName) {
          IconResourceManager.getInstance().setAppNameCache(appItem.appLabelId,
            appItem.bundleName, appItem.moduleName, appItem.appName);
          appItem.appName = `${appName}${appItem.appIndex > 0 ? appItem.appIndex : ''}`;
        }
      });
      log.showWarn('initBundleInfoNameAndCache end');
    } catch (err) {
      log.showError('initBundleInfoNameAndCache error ' + err);
    }
  }

  /**
   * 初始化应用名称缓存
   * @returns
   */
  public async initIconNameCache(): Promise<void> {
    try {
      log.showInfo('initIconNameCache begin');
      let abilityInfoList =
        await taskpool.execute(getAllLauncherAbilityInfo) as bundleResourceManager.LauncherAbilityResourceInfo[];
      log.showInfo('initIconNameCache end');
      abilityInfoList.forEach((info: bundleResourceManager.LauncherAbilityResourceInfo) => {
        if (!CheckEmptyUtils.checkStrIsEmpty(info.label)) {
          IconResourceManager.getInstance().setNameResourceCache(info.bundleName,
            info.moduleName, info.abilityName, info.label, info.appIndex);
        }
      });
      log.showInfo(`initIconNameCache abilityInfoList size ${abilityInfoList.length}`);
    } catch (err) {
      log.showError('initIconNameCache error ' + err);
    }
  }

  /**
   * 初始化应用列表名称
   * @returns
   */
  private initResourceNameCache(): void {
    log.showInfo('initResourceNameCache');
    try {
      this.mBundleInfoList.forEach((appItem: AppItemInfo) => {
        let appName: string = IconResourceManager.getInstance().getAppNameByCache(appItem.appLabelId,
          appItem.bundleName, appItem.moduleName, appItem.appName, appItem.appIndex);
        if (appName) {
          appItem.appName = appName;
        }
      });
    } catch (err) {
      log.showError('initIconNameCache error ' + err);
    }
  }

  /**
   * 更新桌面布局数据库(gridlayout_info)中的名称字段信息以及应用图标名称缓存
   * 重启、切语言场景下触发
   */
  public async updateInfoNameOfApp(isLanguageChange: boolean, isOuter?: boolean): Promise<void> {
    try {
      taskpool.execute(getAllLauncherAbilityInfo)
        .then((taskAbilityInfoList: Object) => {
          let abilityInfoList = taskAbilityInfoList as bundleResourceManager.LauncherAbilityResourceInfo[];
          // 更新前从数据库中查询一次应用列表，避免无效数据库刷新
          RdbStoreManager.getInstance().queryGridLayoutByType(CommonConstants.TYPE_APP, isOuter)
            .then((dbAppList: GridLayoutItemInfo[]) => {
              let dbAppNameMap: HashMap<string, string> = new HashMap();
              let existAppNameSet: HashSet<string> = new HashSet();
              dbAppList.forEach((info: GridLayoutItemInfo) => {
                let key = `${info.bundleName}${info.moduleName}${info.abilityName}${info.appIndex ?? 0}`;
                let value = IconResourceManager.getInstance().getAppNameCacheKey(info.appLabelId, info.bundleName,
                  info.moduleName);
                dbAppNameMap.set(key, value);
                if (info.appName) {
                  existAppNameSet.add(key);
                }
              });
              for (let i = 0; i < abilityInfoList.length; i++) {
                let curInfo: bundleResourceManager.LauncherAbilityResourceInfo = abilityInfoList[i];
                let curKey = `${curInfo.bundleName}${curInfo.moduleName}${curInfo.abilityName}${curInfo.appIndex ?? 0}`;
                if (!CheckEmptyUtils.isEmpty(dbAppNameMap.get(curKey)) &&
                  (!existAppNameSet.has(curKey) || isLanguageChange)) {
                  log.showInfo(`updateAppName,curkey:${curKey},appIndex:${curInfo.appIndex}`);
                  RdbStoreManager.getInstance()
                    .updateAppNameByAbilityInfoAndType(curInfo.label, curInfo.bundleName,
                      curInfo.moduleName, curInfo.abilityName, CommonConstants.TYPE_APP, curInfo.appIndex, isOuter);
                }
                if ((isOuter === undefined || isOuter === launcherStatusUtil.getShowOutLauncherStatus()) &&
                  (curInfo.appIndex ?? 0 ) === 0 && !CheckEmptyUtils.isEmpty(dbAppNameMap.get(curKey))) {
                  log.showInfo(`setAppNameCacheByCacheKey key ${dbAppNameMap.get(curKey)}  label ${curInfo.label}`);
                  // 分批合入，待移除
                  IconResourceManager.getInstance().setNameResourceCache(curInfo.bundleName,
                    curInfo.moduleName, curInfo.abilityName, curInfo.label, curInfo.appIndex);
                  IconResourceManager.getInstance().setAppNameCacheByCacheKey(dbAppNameMap.get(curKey), curInfo.label);
                }
              }
              if (isLanguageChange) {
                let desktopLan: string = AppStorage.get('desktopAppNameChange') as string;
                desktopLan = (desktopLan === LANGUAGE_CHANGE_LABEL_ZERO) ? LANGUAGE_CHANGE_LABEL_ONE :
                  LANGUAGE_CHANGE_LABEL_ZERO;
                this.initResourceNameCache();
                AppStorage.setOrCreate('desktopAppNameChange', desktopLan);
              }
              log.showInfo('abilityInfoList %{public}d dbAppList %{public}d isLanguageChange %{public}s',
                abilityInfoList.length, dbAppList.length, isLanguageChange);
            });
        });
    } catch (err) {
      log.showError('updateInfoNameOfApp error ' + err);
    }
  }

  /**
   * Get the list of apps displayed on the desktop.
   * (public function, reduce the frequency of method call)
   *
   * @return {array} bundleInfoList 仅数据参考，不建议直接修改
   */
  getAppList(callBack?: Function): AppItemInfo[] {
    if (callBack) {
      if (this.mIsLoadFinish) {
        log.showInfo(`getAppList mBundleInfoList length: ${this.mBundleInfoList.length}`);
        callBack();
        if (!CheckEmptyUtils.isEmptyArr(this.mBundleInfoList) && !this.mIsMultiIconAppMapInit) {
          this.initMultiIconList();
          this.mIsMultiIconAppMapInit = true;
        }
        return this.mBundleInfoList;
      } else {
        log.showInfo('getAppList add call');
        this.callBack.push(callBack);
      }
    }
    log.showInfo(`currentBundleInfoList length: ${this.mBundleInfoList.length}`);
    return this.mBundleInfoList;
  }

  private initMultiIconList(): void {
    this.mBundleInfoList.forEach(item => {
      let iconNum: number = 1;
      if (this.mMultiIconAppMap.has(item.bundleName)) {
        iconNum += (this.mMultiIconAppMap.get(item.bundleName) ?? 0);
      }
      this.mMultiIconAppMap.set(item.bundleName, iconNum);
    });
  }

  /**
   * 判断是否为多图标
   *
   * @param bundleName 图标的bundleName
   * @returns true表示多图标
   */
  public checkIsMultiIcon(bundleName: string, appIndex: number): boolean {
    if (this.mMultiIconAppMap.has(bundleName)) {
      return (this.mMultiIconAppMap.get(bundleName) ?? 0) >= MULTI_ICON_NUMBER;
    }
    if (CheckEmptyUtils.isEmptyArr(this.mBundleInfoList)) {
      log.showWarn('checkIsMultiIcon false as the mBundleInfoList is empty');
      return false;
    }
    let iconNum: number = (this.mBundleInfoList.filter(appItem => appItem.bundleName === bundleName &&
      appItem.appIndex === appIndex).length);
    this.mMultiIconAppMap.set(bundleName, iconNum);
    return iconNum >= MULTI_ICON_NUMBER;
  }
  /**
   * 判斷this.mBundleInfoList是否已经存在此元素
   *
   * @param keyNameNew
   */
  isExistBundleInfoList(keyNameNew: string): AppItemInfo | undefined {
    let resultInfo: AppItemInfo | undefined;
    this.mBundleInfoList.forEach((mBundleInfo: AppItemInfo) => {
      let keyNameOld = AppItemInfo.getKeyName(mBundleInfo);
      if (keyNameNew === keyNameOld) {
        resultInfo = mBundleInfo;
      }
    });
    return resultInfo;
  }

  /**
   * 从包管理读数据的时候需要覆盖刷新，因此删除旧的元素，
   *
   * @param bundleInfo
   */
  deleteBundleItem(bundleInfo: AppItemInfo): void {
    this.mBundleInfoList = this.mBundleInfoList.filter(item => item !== bundleInfo);
  }

  /**
   * set the list of apps displayed on the desktop (private function).
   *
   * @return {array} bundleInfoList, excluding system applications
   */
  async setAppListAsync(appList: AppItemInfo[], loadHideConfigType?: number): Promise<AppItemInfo[]> {
    log.showInfo(`setAppListAsync allAbilityList length: ${appList.length}`);
    let launcherAbilityList: AppItemInfo[] = [];
    let appBundleList: string[] = [];
    // 由于刷新时可能会隐藏app所以追加只能清空后重新添加
    if (loadHideConfigType === LoadHideAppType.LOAD_BY_REFRESH) {
      this.mBundleInfoMap.clear();
      this.mBundleInfoList = [];
    }
    for (let ability of appList) {
      if (this.mSystemApplicationName.indexOf(ability.bundleName) === CommonConstants.INVALID_VALUE) {
        launcherAbilityList.push(ability);
        if (!ability.appIndex) {
          appBundleList.push(ability.bundleName);
          // mBundleInfoMap只缓存主应用，不涉及分身
          this.mBundleInfoMap.set(ability.bundleName, ability);
        }
        this.updateShortcutInfo(ability.bundleName);
      }
    }
    this.mFormModel.updateAppFormsInfo(launcherAbilityList);
    launcherAbilityList.forEach((launcherAbility: AppItemInfo) => {
      log.showInfo(`setAppListAsync--->load app for name: ${launcherAbility.bundleName}`);
      this.mBundleInfoList.push(launcherAbility);
      this.addCloneAppCache(launcherAbility.bundleName, launcherAbility.appIndex ?? 0);
    });
    if (DeviceHelper.DEVICE_TYPE === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.checkIconMissWhenPowerOn(launcherAbilityList);
    }
    this.mIsLoadFinish = true;
    this.callBack.forEach((call: Function) => {
      call();
    });
    this.callBack = [];
    log.showInfo(`setAppListAsync--->allAbilityList length after filtration: ${launcherAbilityList.length}`);
    return launcherAbilityList;
  }

  private checkIconMissWhenPowerOn(bundleInfoList: AppItemInfo[]): void {
    log.showInfo('checkIconMissWhenPowerOn start');
    if (this.mIsFirstTime) {
      RdbStoreManager.getInstance().queryAllGridLayoutInfo().then((gridLayoutList: GridLayoutItemInfo[]) => {
        log.showInfo('checkIconMissWhenPowerOn query database success');
        let gridLayoutAppNum = 0;
        gridLayoutList.forEach((layoutInfo) => {
          if (layoutInfo?.typeId === CommonConstants.TYPE_APP) {
            gridLayoutAppNum++;
          }
        });
        log.showInfo('checkIconMissWhenPowerOn bundleInfoListLength: %{public}d, gridLayoutAppNum: %{public}d', bundleInfoList.length, gridLayoutAppNum);
        if (bundleInfoList.length > gridLayoutAppNum && gridLayoutAppNum !== 0) {
          HiDfxEventUtil.reportIconMissError();
        }
      }).catch((err: Error) => {
        log.error('checkIconMissWhenPowerOn query database failed', err);
      });
      this.mIsFirstTime = false;
    }
  }

  /**
   * get AppInfo
   *
   * @param bundleName : bundlerName
   * @returns appInfo
   */
  public getAppInfoByBundleName(bundleName: string): AppItemInfo | undefined {
    return this.mBundleInfoMap.get(bundleName);
  }

  /**
   * 通过bundle信息获取AppInfo
   *
   * @param bundleInfo BaseBundleInfo包含bundleName和分身appIndex
   * @returns
   */
  public getAppInfoByBundleInfo(bundleInfo: BaseBundleInfo): AppItemInfo | undefined {
    return this.mBundleInfoList.find(item => {
      return item.bundleName === bundleInfo.bundleName && item.appIndex === bundleInfo.appIndex;
    });
  }

  /**
   * get AppInfo, 涉及分身应用可使用此接口
   *
   * @param bundleName : keyName
   * @returns appInfo
   */
  public getAppInfoByKeyName(keyName: string): AppItemInfo | undefined {
    return this.mBundleInfoList.find(item => {
      return item.keyName === keyName;
    });
  }

  /**
   * 根据bundleName与appIndex获取应用
   *
   * @param bundleName bundleName
   * @param appIndex 分身
   * @returns 应用信息
   */
  public getAppInfoByBundleNameAndAppIndex(bundleName: string, appIndex: number): AppItemInfo[] {
    return this.mBundleInfoList.filter(item => {
      return item.bundleName === bundleName && item.appIndex === appIndex;
    });
  }

  /**
   * get AppInfo
   *
   * @param bundleName : bundlerName
   * @param abilityName : abilityName
   * @returns appInfo
   */
  public getAppInfoByBundleNameAndAbility(bundleName: string, abilityName: string, appIndex: number = 0): AppItemInfo {
    return this.mBundleInfoList.find(item => {
      return item.bundleName === bundleName && item.abilityName === abilityName && item.appIndex === appIndex;
    });
  }

  public getAppIconImageId(itemInfo: GridLayoutItemInfo): string {
    if (!itemInfo) {
      return '';
    }
    if (itemInfo.typeId === CommonConstants.TYPE_APP) {
      const appInfo: AppItemInfo | undefined = this.getAppInfoByBundleNameAndAbility(itemInfo.bundleName,
        itemInfo.abilityName, itemInfo.appIndex);
      return `${CommonConstants.APP_ITEM_APP_BUBBLE_ICON_TAG}${itemInfo.bundleName}_${appInfo?.appIconId}_` +
        `${itemInfo.appIndex}`;
    } else {
      return `${CommonConstants.APP_ITEM_APP_BUBBLE_ICON_TAG}${itemInfo.bundleName}_${itemInfo.appIndex}_` +
        `${itemInfo.shortcutId}`;
    }
  }

  public getAppIconId(isOpenFolder: boolean, item: AppItemInfo): string {
    const tag = isOpenFolder ? CommonConstants.Folder_BUBBLE_APP_ICON_TAG : CommonConstants.APP_ITEM_APP_BUBBLE_ICON_TAG;
    if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return `${tag}${item.bundleName}_${item.appIndex}_${item.shortcutId}`;
    } else {
      return `${tag}${item.bundleName}_${item.appIconId}_${item.appIndex}`;
    }
  }

  public getAppIconContainerId(traceId: string, bundleName: string, abilityName: string,
    appIndex?: number, appInstanceKey?: string): string {
    if (CheckEmptyUtils.isEmpty(appIndex) && CheckEmptyUtils.isEmpty(appInstanceKey)) {
      return `${traceId}_Container_${bundleName}_${abilityName}`;
    }
    if (!CheckEmptyUtils.isEmpty(appIndex) && CheckEmptyUtils.isEmpty(appInstanceKey)) {
      return `${traceId}_Container_${bundleName}_${abilityName}_${appIndex}`;
    }
    if (CheckEmptyUtils.isEmpty(appIndex) && !CheckEmptyUtils.isEmpty(appInstanceKey)) {
      return `${traceId}_Container_${bundleName}_${abilityName}_${appInstanceKey}`;
    }
    return `${traceId}_Container_${bundleName}_${abilityName}_${appIndex}_${appInstanceKey}`;
  }

  /**
   * Unregister application list change event listener.
   *
   * @param listener
   */
  unregisterAppStateChangeListener(listener: StateChangeType): void {
    let index: number = this.mAppStateChangeListener.indexOf(listener);
    if (index !== CommonConstants.INVALID_VALUE) {
      this.mAppStateChangeListener.splice(index, 1);
    }
  }

  /**
   * Register application list change event listener.
   *
   * @param listener
   */
  registerStateChangeListener(listener: StateChangeType): void {
    if (this.mAppStateChangeListener.indexOf(listener) === CommonConstants.INVALID_VALUE) {
      this.mAppStateChangeListener.push(listener);
    }
  }

  /**
   * 获取userId.
   */
  getUserId(): number {
    return launcherAbilityManager.getUserId();
  }

  /**
   * Start listening to the system application status.
   */
  registerAppListEvent(): void {
    launcherAbilityManager.registerLauncherAbilityChangeListener(this.mInstallationListener);
  }

  /**
   * Stop listening for system application status.
   */
  unregisterAppListEvent(): void {
    launcherAbilityManager.unregisterLauncherAbilityChangeListener(this.mInstallationListener);
  }

  /**
   * 文件夹内加锁应用卸载成功后，先执行补位动效后再刷新布局
   * @param bundleName 应用bundleName
   * @param appIndex  应用分身索引
   */
  public onLockedAppUninstallAnimEnd(bundleName: string, appIndex: number): void {
    log.showInfo('onLockedAppUninstallAnimEnd %{public}s', bundleName);
    this.appItemRemove(bundleName, appIndex);
  }

  /**
   * 通过重新触发应用安装事件，重新加载应用
   *
   * @param bundleName 包名
   * @param appIndex appIndex
   */
  public async reloadLostAppItem(bundleName: string, appIndex: number = 0): Promise<void> {
    log.showWarn(`reloadLostAppItem bundleName: ${bundleName} appIndex: ${appIndex}`);
    this.installationSubscriberCallBack(EventConstants.EVENT_PACKAGE_ADDED, bundleName, appIndex);
  }

  /**
   * The callback function of the application installation event.
   *
   * @param {Object} event
   * @param {string} bundleName
   * @param {number} userId
   */
  private async installationSubscriberCallBack(event: string, bundleName: string, userId: number,
                                               appIndex: number = 0): Promise<void> {
    log.showWarn(`installationSubscriberCallBack event: ${event} bundleName: ${bundleName} appIndex: ${appIndex}`);
    this.updateShortcutInfo(bundleName, event);
    if (this.checkIfOriginalApp(appIndex)) {
      // 只有主应用涉及卡片
      this.mFormModel.deleteCardDescriptionCache(bundleName);
    }
    if (event === EventConstants.EVENT_PACKAGE_REMOVED && AppUpdateUtils.checkIsEnterPriseTypeAppUpdate(bundleName)) {
      log.showInfo('appItem is update no need to remove');
      if (this.mIsLoadFinish) {
        this.notifyAppStateChangeEvent(event, bundleName, appIndex);
      }
      return;
    } else if (event === EventConstants.EVENT_PACKAGE_REMOVED) {
      this.appItemRemove(bundleName, appIndex);
    } else {
      let appItemInfo = await this.appAddedOrUpdated(event, bundleName, appIndex);
      if (!appItemInfo) {
        return;
      }
    }
    if (this.mIsLoadFinish) {
      this.notifyAppStateChangeEvent(event, bundleName, appIndex);
    }
  }

  /**
   * 应用安装或者更新的回调
   * @param event 事件名
   * @param bundleName bundleName
   * @param appIndex appIndex
   * @returns
   */
  public async appAddedOrUpdated(event: string, bundleName: string, appIndex: number): Promise<AppItemInfo | undefined> {
    log.showInfo(`appInstall appAddedOrUpdated ${event}, bundleName:${bundleName} appIndex:${appIndex}`);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECOMMEND_FORM_DELETE, bundleName);
    let isPackAdd: boolean = (event === EventConstants.EVENT_PACKAGE_ADDED);
    let appItemInfo: AppItemInfo | undefined = await this.getAndReplaceLauncherAbility(bundleName, appIndex, isPackAdd);
    if (isPackAdd) {
      this.addCloneAppCache(bundleName, appIndex);
    }
    let isAtomicService: boolean = false;
    if (CheckEmptyUtils.isEmpty(appItemInfo)) {
      appItemInfo = await this.mAtomicServiceAppModel.getAndReplaceAtomicAbility(bundleName, appIndex);
      isAtomicService = true;
    }

    await this.mFormModel.updateAppItemFormInfo(bundleName);
    // 应用安装、升级时，更新card_info表中的应用卡片信息
    this.mFormModel.updateSingleAppItemFormInfo(bundleName);

    if (!appItemInfo) {
      log.showInfo(`installationSubscriberCallBack neither launcher nor atomic app, bundleName:${bundleName}`);
      AppGalleryDownloadManager.getInstance().deleteDownloadTaskInfo(bundleName);
      AppGalleryDownloadManager.getInstance().deleteDownloadProgressInfo(bundleName);
      // 无appItemInfo，查看是否之前有对应数据，若有，则删除之前的数据
      if (this.mBundleInfoMap.has(bundleName)) {
        this.installationSubscriberCallBack(EventConstants.EVENT_PACKAGE_REMOVED, bundleName, this.getUserId());
      }
      return undefined;
    }

    // 收到应用change广播replace appItemInfo后，需检查设置AppName缓存
    this.setAppNameCacheByAppItem(appItemInfo);

    if (this.mSystemApplicationName.indexOf(appItemInfo.bundleName) !== CommonConstants.INVALID_VALUE) {
      log.showWarn('the system application %{public}s is not show on desktop', appItemInfo.bundleName);
      return undefined;
    }

    if (event === EventConstants.EVENT_PACKAGE_CHANGED) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE, bundleName);
      AppStorage.setOrCreate('formRefreshBundleName', bundleName);
      localEventManager.sendLocalEvent('updateIconImage_' + bundleName);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_APP_PACKAGE_CHANGED, bundleName);
      this.checkAtomicRefresh(isAtomicService);
    } else {
      await IconResourceManager.getInstance()
        .getCombIcon(appItemInfo.bundleName, appItemInfo.moduleName, appItemInfo.abilityName, 0, 'CombIcon_AppModel',
          appItemInfo.codePath === ohos_APPLICATION);

      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD, bundleName);
    }
    this.mOperationItemInfo = this.getOperationItemInfo(bundleName);
    log.showWarn('appInstall appAddedOrUpdated end bundleType:%{public}s', appItemInfo.bundleType);
    return appItemInfo;
  }

  private setAppNameCacheByAppItem(appItemInfo: AppItemInfo): void {
    let appName = IconResourceManager.getInstance().getAppNameByCache(appItemInfo.appLabelId, appItemInfo.bundleName,
      appItemInfo.moduleName, '');
    if (CheckEmptyUtils.isEmpty(appName)) {
      // 不缓存应用分身名称
      if (!appItemInfo.appIndex) {
        IconResourceManager.getInstance().setAppNameCache(appItemInfo.appLabelId, appItemInfo.bundleName,
          appItemInfo.moduleName, appItemInfo.appName);
      }
      IconResourceManager.getInstance().setNameResourceCache(appItemInfo.bundleName, appItemInfo.moduleName,
        appItemInfo.abilityName, appItemInfo.appName, appItemInfo.appIndex);
      log.showInfo(`installationSubscriberCallBack, setNameResourceCache, appName: ${appItemInfo.appName}`);
    }
  }

  private checkAtomicRefresh(isAtomicService: boolean): void {
    if (isAtomicService) {
      // 元服务通知内外屏刷新
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH, null);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH, null);
    }
  }

  public appItemRemove(bundleName: string, appIndex: number = 0): void {
    if (lockedAppUninstallModel.doLockedAppUninstalledAnim(bundleName)) {
      log.showWarn('locked app in folder uninstall success');
      return;
    }
    let itemIntent = this.getAppInfoByBundleName(bundleName)?.intent;
    let deleteNodeControllerKey: string = bundleName;
    if (appIndex !== 0) {
      //分身应用使用keyname匹配去删除node缓存节点避免删除掉主应用的缓存节点
      let existAppInfo: AppItemInfo[] = this.getAppInfoByBundleNameAndAppIndex(bundleName, appIndex);
      if (!CheckEmptyUtils.isEmptyArr(existAppInfo)) {
        deleteNodeControllerKey = existAppInfo[0]?.keyName ?? bundleName;
      }
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_APP_PACKAGE_CHANGED, deleteNodeControllerKey);
    this.removeItem(bundleName, appIndex);
    this.removeItemCache(bundleName, appIndex, UpdateType.DELETE);
    this.removeCloneAppCache(bundleName, appIndex);
    this.mAtomicServiceAppModel.removeAtomicServiceItem(bundleName, appIndex);
    if (this.checkIfOriginalApp(appIndex)) {
      this.mFormModel.deleteFormByBundleName(bundleName, false);
      this.mFormModel.deleteAppItemFormInfoInDB(bundleName);
    }
    AppStorage.setOrCreate('removeAppBundleName', bundleName);
    // delete app form dock
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE, {
      bundleName: bundleName,
      keyName: undefined,
      isDeleteAppToUninstallFolder: true,
      appIndex: appIndex,
    });
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECENT_DOCK_ITEM_DELETE, {
      bundleName: bundleName,
      keyName: undefined,
      appIndex: appIndex,
    });

    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECENT_LOCK_ITEM_DELETE, {
      bundleName: bundleName,
      abilityName: '',
      moduleName: '',
      appIndex: appIndex
    });

    localEventManager.sendLocalEventSticky(EventConstants.EVENT_SUGGEST_MENU_REMOVED, {
      bundleName: bundleName,
      keyName: undefined,
      appIndex: appIndex,
    });

    this.deleteAppList.push({
      bundleName: bundleName,
      keyName: undefined,
      appIndex: appIndex,
      isUninstalled: true
    });
    this.batchDeleteApp();

    if (!appIndex) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RECOMMEND_FORM_DELETE, bundleName);
      // delete form from formstack
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_FORM_STACK_DELETE, bundleName);
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DELIVER_APP_ITEM_REMOVE, {
      bundleName: bundleName,
      intent: itemIntent
    });
    log.showInfo('appItem remove bundleName:%{public}s appIndex: %{public}d', bundleName, appIndex);
  }

  /**
   * 批量取消下载任务，收集到50个就发送通知，200ms内没有接收到任务也发送通知
   */
  private batchDeleteApp(): void {
    if (this.deleteAppList.length >= DELETE_APP_BATCH_COUNT) {
      // delete app from folder
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_PACKAGE_REMOVED_BATCH, this.deleteAppList);

      // delete app from pageDesktop
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE_BATCH,
        this.deleteAppList);

      clearTimeout(this.deleteAppTimeId);
      this.deleteAppList = [];
      this.deleteAppTimeId = 0;
      return;
    }
    if (this.deleteAppTimeId) {
      clearTimeout(this.deleteAppTimeId);
    }
    this.deleteAppTimeId = setTimeout(() => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_PACKAGE_REMOVED_BATCH, this.deleteAppList);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE_BATCH,
        this.deleteAppList);
      this.deleteAppList = [];
      this.deleteAppTimeId = 0;
    }, DELETE_APP_DELAY);
  }

  private updateGameEngineValidStatus(bundleName: string): void {
    HiSysEventUtil.updateGameEngineValidStatus(bundleName);
  }

  getOperationItemInfo(bundleName: string): AppItemInfo | undefined {
    let originItemIndex: number = this.getItemIndex(bundleName);
    if (originItemIndex === CommonConstants.INVALID_VALUE) {
      log.showError('publishEvent originItemIndex is error.');
      return undefined;
    }
    return this.mBundleInfoList[originItemIndex];
  }

  private async getAndReplaceLauncherAbility(bundleName: string, appIndex: number, isPackAdd?: boolean):
    Promise<AppItemInfo | undefined> {
    this.removeItemCache(bundleName, appIndex, UpdateType.UPDATE);
    const abilityInfos: AppItemInfo[] = await launcherAbilityManager.getLauncherAbilityInfo(bundleName, isPackAdd);
    if (CheckEmptyUtils.isEmptyArr(abilityInfos)) {
      log.showError('getAndReplaceLauncherAbility abilityInfos is error, %{public}s', bundleName);
      return undefined;
    }
    log.showInfo(`launcher abilityInfos: ${JSON.stringify(abilityInfos)}`);
    await this.replaceItem(bundleName, appIndex, abilityInfos);
    let findIndex = abilityInfos.findIndex(item => item.appIndex === appIndex);
    if (findIndex >= 0) {
      return abilityInfos[findIndex];
    }
    return undefined;
  }

  /**
   * Send event about application state change.
   */
  private notifyAppStateChangeEvent(event: string, bundleName: string, appIndex: number): void {
    for (let i = 0; i < this.mAppStateChangeListener.length; i++) {
      this.mAppStateChangeListener[i](this.mBundleInfoList, event, bundleName, appIndex);
    }
  }

  /**
   * Get the app index in bundleInfoList.
   *
   * @param {string} bundleName
   * @return {number} index
   */
  private getItemIndex(bundleName: string, appIndex: number = 0): number {
    for (const listItem of this.mBundleInfoList) {
      if (listItem.bundleName === bundleName && listItem.appIndex === appIndex) {
        return this.mBundleInfoList.indexOf(listItem);
      }
    }
    return CommonConstants.INVALID_VALUE;
  }

  /**
   * Append app items into the bundleInfoList.
   *
   * @param {array} abilityInfos
   */
  private async appendItem(abilityInfos: AppItemInfo[], appIndex: number): Promise<void> {
    for (let index = 0; index < abilityInfos.length; index++) {
      if (this.mSystemApplicationName.indexOf(abilityInfos[index].bundleName) !== CommonConstants.INVALID_VALUE) {
        log.showWarn('the system application %{public}s is not show on desktop', abilityInfos[index].bundleName);
        continue;
      }
      if (abilityInfos[index].appIndex === appIndex) {
        this.mBundleInfoList.push(abilityInfos[index]);
      }
      if (!abilityInfos[index].appIndex) {
        // mBundleInfoMap只缓存主应用，不涉及分身
        this.mBundleInfoMap.set(abilityInfos[index].bundleName, abilityInfos[index]);
        await this.mFormModel.updateAppItemFormInfo(abilityInfos[index].bundleName);
      }
    }
    if (!CheckEmptyUtils.isEmptyArr(abilityInfos)) {
      this.mMultiIconAppMap.set(abilityInfos[0].bundleName, abilityInfos.length);
    }
  }

  // 判断当前图标是否为应用分身，appIndex为0或undefined时，表示是主应用
  private checkIfOriginalApp(appIndex: number): boolean {
    return !appIndex;
  }

  private addCloneAppCache(bundleName: string, appIndex: number): void {
    if (this.mCloneInfoMap.has(bundleName)) {
      this.mCloneInfoMap.get(bundleName)?.add(appIndex);
    } else {
      let appIndexSet: Set<number> = new Set<number>();
      appIndexSet.add(appIndex);
      this.mCloneInfoMap.set(bundleName, appIndexSet);
    }
  }

  private removeCloneAppCache(bundleName: string, appIndex: number): void {
    if (!this.mCloneInfoMap.has(bundleName)) {
      return;
    }
    let appIndexSet: Set<number> | undefined = this.mCloneInfoMap.get(bundleName);
    appIndexSet?.delete(appIndex);
    if (appIndexSet && appIndexSet.size <= 0) {
      this.mCloneInfoMap.delete(bundleName);
    }
  }

  public getCloneAppNumber(bundleName: string): number {
    if (!this.mCloneInfoMap.has(bundleName)) {
      log.showInfo(`getCloneAppNumber： 0`);
      return 0;
    }
    log.showInfo(`getCloneAppNumber: ${this.mCloneInfoMap.get(bundleName)?.size}`);
    return this.mCloneInfoMap.get(bundleName)?.size ?? 0;
  }

  /**
   * Remove app item from the bundleInfoList.
   *
   * @param {string} bundleName
   */
  private removeItem(bundleName: string, appIndex: number): void {
    log.showDebug(`removeItem bundleName: ${bundleName}${appIndex}`);
    if (this.checkIfOriginalApp(appIndex)) {
      this.mFormModel.deleteAppItemFormInfo(bundleName);
    }
    let originItemIndex: number = this.getItemIndex(bundleName, appIndex);
    while (originItemIndex !== CommonConstants.INVALID_VALUE) {
      this.mOperationItemInfo = this.mBundleInfoList[originItemIndex];
      this.mBundleInfoList.splice(originItemIndex, 1);
      originItemIndex = this.getItemIndex(bundleName, appIndex);
    }
    if (this.checkIfOriginalApp(appIndex)) {
      this.mBundleInfoMap.delete(bundleName);
    }
    if (this.mIsMultiIconAppMapInit && this.mMultiIconAppMap.has(bundleName)) {
      this.mMultiIconAppMap.delete(bundleName);
    }
  }

  /**
   * Remove app item from the cache.
   *
   * @param {string} bundleName
   */
  private removeItemCache(bundleName: string, appIndex: number, type: UpdateType = UpdateType.NONE): void {
    log.showInfo(`removeItemCache bundleName: ${bundleName} appIndex: ${appIndex}`);
    IconResourceManager.getInstance().deleteIconResource(bundleName, type, appIndex);
    if (appIndex === 0) {
      // 主应用卸载才清ResourceManager缓存
      globalThis.ResourceManager.deleteAppResourceCacheByBundle(bundleName);
    }
  }

  /**
   * Replace app items in the bundleInfoList.
   *
   * @param {string} bundleName
   * @param {array} abilityInfos
   */
  private async replaceItem(bundleName: string, appIndex: number, abilityInfos: AppItemInfo[]): Promise<void> {
    log.showDebug(`replaceItem bundleName: ${bundleName}`);
    this.removeItem(bundleName, appIndex);
    await this.appendItem(abilityInfos, appIndex);
  }

  /**
   * 批量打印快捷方式信息日志
   */
  private batchPrintShortcutInfo(shortcutInfo: ShortcutInfo[] | undefined): void {
    if (shortcutInfo && !CheckEmptyUtils.isEmptyArr(shortcutInfo)) {
      for (let i = 0; i < shortcutInfo.length; i += MAX_SHORTCUT_LENGTH) {
        let shortcutInfoLog: string = '';
        for (let j = i; j < i + MAX_SHORTCUT_LENGTH && j < shortcutInfo.length; j++) {
          shortcutInfoLog = shortcutInfoLog +
            `id: ${shortcutInfo[j].id}, iconId: ${shortcutInfo[j].iconId}, labelId: ${shortcutInfo[j].labelId}, visible: ${shortcutInfo[j].visible}. `;
        }
        log.showInfo(`shortcutInfo: ${shortcutInfoLog}`);
      }
    }
  }

  /**
   * Put shortcut info into map.
   *
   * @param {string} bundleName
   * @param {array} shortcutInfo
   */
  setShortcutInfo(bundleName: string, shortcutInfo: ShortcutInfo[]): void {
    log.showInfo(`setShortcutInfo bundleName: ${bundleName}, shortcutInfo length: ${shortcutInfo?.length}`);
    this.batchPrintShortcutInfo(shortcutInfo);
    this.mShortcutInfoMap.set(bundleName, shortcutInfo);
  }

  /**
   * Get MAX_SHORTCUT_LENGTH shortcut info from map.
   *
   * @param {string} bundleName
   * @return {array | undefined} shortcutInfo
   */
  getShortcutInfo(bundleName: string): ShortcutInfo[] | undefined {
    let shortcutInfoList = this.mShortcutInfoMap.get(bundleName);
    log.showInfo(`getShortcutInfo bundleName: ${bundleName}, shortcutInfo length: ${shortcutInfoList?.length}`);
    if (shortcutInfoList && !CheckEmptyUtils.isEmptyArr(shortcutInfoList) &&
      shortcutInfoList.length > MAX_SHORTCUT_LENGTH) {
      shortcutInfoList = shortcutInfoList.slice(0, MAX_SHORTCUT_LENGTH);
    }
    this.batchPrintShortcutInfo(shortcutInfoList);
    return shortcutInfoList;
  }

  /**
   * Get all shortcut info from map.
   * 该接口获取应用的全部快捷方式，存在超大数量可能，谨慎使用
   * @param {string} bundleName
   * @return {array | undefined} shortcutInfo
   */
  public getAllShortcutInfo(bundleName: string): ShortcutInfo[] | undefined {
    let shortcutInfoList = this.mShortcutInfoMap.get(bundleName);
    log.showInfo(`getAllShortcutInfo bundleName: ${bundleName}, shortcutInfo length: ${shortcutInfoList?.length}`);
    this.batchPrintShortcutInfo(shortcutInfoList);
    return shortcutInfoList;
  }

  /**
   * Update shortcut info of map.
   *
   * @param {string} bundleName
   * @param {string | undefined} eventType
   */
  public updateShortcutInfo(bundleName: string, eventType?: string): void {
    log.showInfo(`updateShortcutInfo eventType: ${eventType}`);
    let currentShortcutInfoList: ShortcutInfo[] | undefined = this.getAllShortcutInfo(bundleName);
    if (currentShortcutInfoList) {
      currentShortcutInfoList.forEach((item: ShortcutInfo) => {
        let cacheKey: string = `${item.labelId}${item.bundleName}${item.moduleName}`;
        ResourceManager.getInstance().deleteAppResourceCache(cacheKey, KEY_NAME);
        cacheKey = `${item.iconId}${item.bundleName}${item.moduleName}`;
        ResourceManager.getInstance().deleteAppResourceCache(cacheKey, KEY_ICON);
        ResourceManager.getInstance().deleteAppResourceCache(cacheKey, ADAPTIVE_ICON);
      });
      this.mShortcutInfoMap.delete(bundleName);
    }

    if (eventType && eventType === EventConstants.EVENT_PACKAGE_REMOVED) {
      return;
    }
    launcherAbilityManager.getShortcutInfoSync(bundleName,
      (bundleName: string, shortcutInfo: ShortcutInfo[]) => this.setShortcutInfo(bundleName, shortcutInfo));
  }

  /**
   * 将GridLayoutItemInfo转换为DockItemInfo
   */
  public gridLayoutToDockItem(info: GridLayoutItemInfo): DockItemInfo {
    let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(info);
    let appItem: AppItemInfo = this.getAppInfoByKeyName(info.keyName ?? '') ?? new AppItemInfo();
    dockItem.installTime = appItem.installTime;
    dockItem.isSystemApp = appItem.isSystemApp;
    dockItem.isUninstallAble = appItem.isUninstallAble;
    dockItem.areaType = CommonConstants.TYPE_AREA_DOCK;
    return dockItem;
  }

  public getShortcutInfoFromManagerSync(bundleName: string): ShortcutInfo[] | undefined {
    launcherAbilityManager.getShortcutInfoSync(bundleName,
      (bundleName: string, shortcutInfo: ShortcutInfo[]) => this.setShortcutInfo(bundleName, shortcutInfo));
    return this.getShortcutInfo(bundleName);
  }

  async getShortcutInfoFromManager(bundleName: string): Promise<ShortcutInfo[] | undefined> {
    await launcherAbilityManager.getShortcutInfo(bundleName,
      (bundleName: string, shortcutInfo: ShortcutInfo[]) => this.setShortcutInfo(bundleName, shortcutInfo));
    return this.getShortcutInfo(bundleName);
  }
}

/**
 * 异步线程-更新桌面布局表中的info_name，且返回应用列表信息
 *
 * @returns LauncherAbilityResource列表
 */
async function getAllLauncherAbilityInfo(): Promise<bundleResourceManager.LauncherAbilityResourceInfo[]> {
  'use concurrent';
  let result: bundleResourceManager.LauncherAbilityResourceInfo[] = [];
  try {
    result =
      await bundleResourceManager.getAllLauncherAbilityResourceInfo(bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL);
  } catch (e) {
    LogHelper.getLogHelper(LogDomain.SCB, 'getAllLauncherAbilityInfo')
      .showError('get info err ' + e);
  }
  return result;
}

/**
 * 异步线程-获取应用列表
 *
 * @returns 已安装应用列表
 */
async function getLauncherAbilityListTask(userId: number): Promise<AppItemInfo[]> {
  'use concurrent';
  let result = await launcherAbilityManager.getLauncherAbilityList(userId);
  return result;
}

export interface IconChangeListener {
  bundleName?: string;
  moduleName?: string;
  abilityName?: string;
  onIconResourceChange: () => void;
}

/**
 * 资源切换监听器
 */
export interface ResourceChangeListener {
  /**
   * 监听器标识
   */
  id: string;

  /**
   * 清空缓存回调
   */
  clearCache: () => void;
}