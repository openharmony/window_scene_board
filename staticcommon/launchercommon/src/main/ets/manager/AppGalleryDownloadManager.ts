/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import taskPool from '@ohos.taskpool';
import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { CommonEvent, DeviceHelper, IconResourceManager } from '@ohos/frameworkwrapper';
import { UpdateType } from '@ohos/commonconstants';
import {
  HiSysEventUtil,
  EvtBus,
  GlobalContext,
  localEventManager,
  PackageDataClearedEvent,
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  InstallStatusChangeEvent,
  ShutDownEvent,
} from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { AppItemInfo } from '../bean/AppItemInfo';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { EventConstants } from '../constants/EventConstants';
import {
  AppDownloadInfo,
  AppGalleryEventInfo,
  AppInstallStatusInfo,
  BusinessType,
  DownloadInfoItem,
  DownloadStatusInfo
} from '../constants/CommonConstants';
import { AppGalleryEventStatus, AppStatus, CommonConstants } from '../constants/CommonConstants';
import type ctx from '@ohos.app.ability.common';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
// import installInfoManager from '@ohos.core.appgalleryservice.installInfoManager';
import HashMap from '@ohos.util.HashMap';
import { AppModel } from '../model/AppModel';
import {
  AppReserveType,
  DisposedEventManager,
  DockItemInfo,
  FolderLayoutCacheManager,
  LaunchLayoutCacheManager,
  LayoutViewModel,
  NotHarmonyUtil,
  GetHideAppsFromConfig,
  ResidentLayoutCacheMgr
} from '../TsIndex';
import { BundleMappingChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { preferences } from '@kit.ArkData';
import { AppCategoryInfoManager } from './AppCategoryInfoManager';
import { HashSet } from '@kit.ArkTS';
import AppUpdateUtils from '../utils/AppUpdateUtils';
import { AppInstallUtils } from '../appinstall/AppInstallUtils';
import { ObjectCopyUtil } from '@ohos/componenthelper';

type AppGalleryEvent = AppInstallStatusInfo | DownloadStatusInfo | AppDownloadInfo;

const TAG = 'AppGalleryDownloadManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FILE_PRE = 'file://';
const APPGALLERY_BUNDLENAME = 'com.ohos.appgallery';
const TYPE_ENTERPRISE = 'enterprise';
const TYPE_INTERNALTESTING = 'internaltesting';
const WAIT_FOR_STRING = '__WAIT_FOR_';
const PRE_DOWNLOAD_MENU_LEAST_NUM = 1;
const SHORTCUT_LIMIT_KEY = 'shortcutLimit';
const THROTTLING_INTERVAL = 500; // 点击优先下载，节流时间间隔

export class AppGalleryDownloadManager {
  private static sInstance: AppGalleryDownloadManager;
  private downloadProgressList: AppDownloadInfo[] = [];
  private downloadTaskList: DownloadStatusInfo[] = [];

  /**
   * 取消下载bundleName集合
   */
  private cancelDownloadSet: HashSet<string> = new HashSet<string>();
  private installEventAppStatusMap: Map<AppGalleryEventStatus, AppStatus> = new Map<AppGalleryEventStatus, AppStatus>();
  private appDownloadMap: HashMap<String, number> = new HashMap<String, number>();

  private lastClickBundleName: string = ''; // 记录上次点击的图标包名

  private lastClickTime: number = 0; // 记录最后一次有效点击时间戳

  /**
   * 是否开启下一代下载功能，默认不开启
   */
  private enableNextDownload: boolean = false;

  /**
   * Get instance of AppGalleryDownloadManager
   * @returns instance of AppGalleryDownloadManager
   */
  public static getInstance(): AppGalleryDownloadManager {
    if (!AppGalleryDownloadManager.sInstance) {
      AppGalleryDownloadManager.sInstance = new AppGalleryDownloadManager();
    }
    return AppGalleryDownloadManager.sInstance;
  }

  constructor() {
  }

  /**
   * 初始化AppGalleryDownloadManager
   */
  public init(): void {
    log.showWarn('int app install event');
    this.initInstallEventAppStatusMap();
    this.initAppGalleryEvent();
  }

  /**
   * 获取开启下一代下载功能
   * @returns
   */
  public isEnableNextDownload(): boolean {
    return this.enableNextDownload;
  }

  /**
   * 设置是否开启下一代下载功能
   * @param isEnableNextDownload
   */
  public setEnableNextDownload(isEnableNextDownload: boolean): void {
    this.enableNextDownload = isEnableNextDownload;
  }

  private initInstallEventAppStatusMap(): void {
    this.installEventAppStatusMap.set(AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT_ID, AppStatus.WAITING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.DOWNLOAD_WAIT_EVENT_ID, AppStatus.WAITING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.DOWNLOAD_PAUSE_EVENT_ID, AppStatus.PAUSING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.DOWNLOAD_RESUME_EVENT_ID, AppStatus.DOWNLOADING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.DOWNLOAD_WLAN_EVENT_ID, AppStatus.PAUSING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.DOWNLOAD_SUCCEED_EVENT_ID, AppStatus.INSTALL_WAITING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.INSTALL_START_EVENT_ID, AppStatus.INSTALLING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.COMPANY_APP_RESET_EVENT_ID, AppStatus.PENDING);
    this.installEventAppStatusMap.set(AppGalleryEventStatus.INSTALL_FAILED_EVENT_ID, AppStatus.INSTALL_FAIL);
  }

  private notifyDownloadCanceled(bundleName: string, appIndex: number): void {
    AppModel.getInstance().onDownloadCanceled(EventConstants.EVENT_PACKAGE_REMOVED, bundleName, appIndex);
  }

  private initAppGalleryEvent(): void {
    EvtBus.on(DownloadStatusChangeEvent, (event: CommonEvent) => {
      this.handleAppGalleryEventChange(event);
    });
    EvtBus.on(DownloadingProgressChangeEvent, (event: CommonEvent) => {
      this.handleAppGalleryEventChange(event);
    });
    EvtBus.on(InstallStatusChangeEvent, (event: CommonEvent) => {
      this.handleAppGalleryEventChange(event);
    });
    EvtBus.on(ShutDownEvent, (event: CommonEvent) => {
      this.changeAllCacheAppToPause();
    });
    EvtBus.on(PackageDataClearedEvent, (commonEvent: CommonEvent) => {
      if (commonEvent.bundleName !== APPGALLERY_BUNDLENAME) {
        return;
      }
      this.removeAllNotInstalledApp();
    });
    EvtBus.on(BundleMappingChangeEvent, (event: CommonEvent) => {
      this.handleBundleMappingEventChange(event);
    });
  }

  private handleAppGalleryEventChange(event: CommonEvent): void {
    log.showInfo('handleAppGalleryEventChange: %{public}s bundleName: %{public}s', event?.event, event?.parameters?.bundleName);
    if (event?.parameters) {
      DisposedEventManager.getInstance().handleAppInstalled(event);
      let actionBundleName: string = event?.parameters.bundleName;
      // 无图标应用更新安装完成时，清理图标缓存，通知systemui重新获取图标
      this.dealNoImageIconCache(actionBundleName, event?.code);
      if ((this.isAppUpdating(actionBundleName) || this.isUpdateStatus(event)) && !this.isDistributeType(event)) {
        log.showWarn('handleAppGalleryEventChange %{public}s is updating', actionBundleName);
        return;
      }
      let eventData: AppGalleryEvent;
      switch (event?.event) {
        case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
          eventData = event?.parameters as DownloadStatusInfo;
          if (!event.code) {
            log.showWarn('event code is empty!!!!');
            return;
          }
          this.dealWithDownloadStatusChange(eventData as DownloadStatusInfo, event.code, actionBundleName);
          break;
        case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
          eventData = event?.parameters as AppDownloadInfo;
          this.dealWithDownloadProgressChange(eventData as AppDownloadInfo, actionBundleName);
          break;
        case InstallStatusChangeEvent.INSTALL_STATUS_CHANGE:
          eventData = event?.parameters as AppInstallStatusInfo;
          if (!event.code) {
            log.showWarn('event code is empty!!!!');
            return;
          }
          this.dealWithInstallStatusChange(eventData as AppInstallStatusInfo, event.code, actionBundleName);
          break;
      }
    }
  }

  /**
   * 无图标应用更新安装完成时，清理图标缓存，通知systemui重新获取图标
   *
   * @param bundleName 包名
   * @param code 事件id
   */
  private dealNoImageIconCache(bundleName: string, code?: number): void {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn(`bundleName is empty`);
      return;
    }
    if (code !== AppGalleryEventStatus.INSTALL_SUCCEED_EVENT_ID) {
      return;
    }
    let appItem: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(bundleName);
    if (CheckEmptyUtils.isEmpty(appItem)) {
      IconResourceManager.getInstance().deleteIconResource(bundleName, UpdateType.UPDATE);
    }
  }

  private handleBundleMappingEventChange(event: CommonEvent): void {
    log.showInfo('handleBundleMappingEventChange start');
    if (!event?.parameters) {
      log.showInfo('handleBundleMappingEventChange end, event parameters are null');
      return;
    }
    // 根据应用市场通知去点亮或熄灭占位的未鸿蒙化应用
    let hasohosApp: string[] = event.parameters['ag.params.HARMONY_PKGS_ADDED'] as string[];
    let notohosApp: string[] = event.parameters['ag.params.HARMONY_PKGS_REMOVED'] as string[];
    let publicTestohosApp: string[] = event.parameters['ag.params.PUBLIC_TEST_APP_PKGS_ADDED'] as string[];
    // 普通三方应用的点亮熄灭映射关系
    let relationMap: Map<string, boolean> = new Map();
    // 尝鲜应用的点亮熄灭映射关系
    let publicTestRelationMap: Map<string, boolean> = new Map();
    if (hasohosApp && hasohosApp.length > 0) {
      hasohosApp.forEach(item => {
        log.showInfo(`BundleMappingEventChange hasohosApp: ${item}`);
        relationMap.set(item, true);
      });
    }
    if (publicTestohosApp && publicTestohosApp.length > 0) {
      publicTestohosApp.forEach(item => {
        log.showInfo(`BundleMappingEventChange publicTestohosApp: ${item}`);
        publicTestRelationMap.set(item, true);
      });
    }
    this.dealNotohosApp(notohosApp, relationMap, publicTestRelationMap);
    // 兼容老版本未鸿蒙化应用平铺在桌面的场景
    NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap);
    // 刷新未鸿蒙化应用文件夹中的应用排序状态
    if (!CheckEmptyUtils.isEmptyArr(notohosApp)) {
      for (let i = 0; i < notohosApp.length; i++) {
        relationMap.delete(notohosApp[i]);
        publicTestRelationMap.delete(notohosApp[i]);
      }
    }
    NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap, publicTestRelationMap);
    log.showInfo('handleBundleMappingEventChange end');
  }

  private dealNotohosApp(notohosApp: string[], relationMap: Map<string, boolean>,
    publicTestRelationMap: Map<string, boolean>): void {
    if (CheckEmptyUtils.isEmptyArr(notohosApp)) {
      log.showInfo('BundleMappingEventChange dealNotohosApp is empty');
      return;
    }
    try {
      // delivery点亮的 忽略掉AG的熄灭事件
      let preference = preferences.getPreferencesSync(GlobalContext.getContext(), { name: 'DESKTOP_LAYOUT_INFO' });
      let lightDeliverBundleNames: string = preference.getSync('lightDeliverBundleNames', '') as string;
      let lightArr: string[] = lightDeliverBundleNames.split(',');
      notohosApp.forEach(item => {
        if (lightArr.indexOf(item) !== CommonConstants.INVALID_VALUE) {
          log.showWarn('BundleMappingEventChange notohosApp is delivery light app %{public}s', item);
          return;
        }
        log.showInfo(`BundleMappingEventChange notohosApp: ${item}`);
        relationMap.set(item, false);
        publicTestRelationMap.set(item, false);
      });
    } catch (error) {
      log.showInfo('set  notohosApp error: ${public}s', error?.message);
    }
  }

  private isUpdateStatus(event: CommonEvent): boolean {
    if (event.parameters?.updateStatus && event.parameters.updateStatus === 1) {
      return true;
    }
    return false;
  }

  private isAppUpdating(bundleName: string): boolean {
    let appItem: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(bundleName);
    return appItem !== undefined && appItem !== null && (appItem.appStatus === undefined || appItem.appStatus === 0);
  }

  private isDistributeType(event: CommonEvent): boolean {
    let IsAppDistribute: boolean = event?.parameters?.distributeType === TYPE_ENTERPRISE ||
      event?.parameters?.distributeType === TYPE_INTERNALTESTING;
    if (!IsAppDistribute) {
      IsAppDistribute = AppUpdateUtils.checkIsEnterPriseTypeAppUpdate(event?.parameters?.bundleName);
    }
    return IsAppDistribute;
  }

  private dealCancelOrFailedTask(bundleName: string, statusCode: number): void {
    log.showWarn('dealCancelOrFailedTask bundleName: %{public}s.', bundleName);
    // 主应用下载取消和失败时，同步移除所有分身应用
    this.removeMainAndTwinAppByBundleName(bundleName);
    this.dealUpdateAppItemAfterInstall(bundleName, statusCode);
  }

  private dealWithDownloadStatusChange(eventData: DownloadStatusInfo, statusCode: number, actionBundleName: string): void {
    log.showWarn(`dealWithDownloadStatusChange statusCode is ${statusCode} bundleName is ${actionBundleName},updateStatus is ${eventData?.updateStatus}`);
    let downloadInfo: DownloadStatusInfo | undefined = this.getDownDownloadTaskInfo(actionBundleName);
    if (downloadInfo && downloadInfo.status === AppStatus.INSTALLING) {
      log.showWarn(`app is installing return!`);
      return;
    }
    let data: DownloadStatusInfo = eventData;
    switch (statusCode) {
      case AppGalleryEventStatus.DOWNLOAD_CANCEL_EVENT_ID:
        log.showWarn('cancel task successful, bundleName: %{public}s.', actionBundleName);
        if (data.bundleName.startsWith(WAIT_FOR_STRING)) {
          this.deleteNotHarmonyItem(data);
          break;
        }
        if (this.cancelDownloadSet.has(actionBundleName)) {
          this.cancelDownloadSet.remove(actionBundleName);
        } else {
          this.dealCancelOrFailedTask(data.bundleName, statusCode);
        }
        break;
      case AppGalleryEventStatus.DOWNLOAD_FAILED_EVENT_ID: {
        if (data.bundleName.startsWith(WAIT_FOR_STRING)) {
          this.deleteNotHarmonyItem(data);
          break;
        }
        this.dealCancelOrFailedTask(data.bundleName, statusCode);
        break;
      }
      case AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT_ID: {
        this.dealAppGalleryCreatedEvent(data, actionBundleName, eventData);
        break;
      }
      case AppGalleryEventStatus.DOWNLOAD_SUCCEED_EVENT_ID: {
        if (this.appDownloadMap.hasKey(data.bundleName)) {
          HiSysEventUtil.reportAnimationDurationAppDownload(data.bundleName, Date.now() - this.appDownloadMap.get(data.bundleName));
        }
        break;
      }
      case AppGalleryEventStatus.COMPANY_APP_RESET_EVENT_ID: {
        this.deleteDownloadProgressInfo(data.bundleName);
        this.deleteDownloadTaskInfo(data.bundleName);
        let appList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(data.bundleName);
        let status: AppStatus = this.installEventAppStatusMap.get(statusCode) ?? AppStatus.PENDING;
        let icon: string | undefined = !CheckEmptyUtils.isEmptyArr(appList) ? appList[0].iconResource : '';
        this.refreshAppIconCache(data, status, icon ?? '', appList);
        this.dealWithDownloadStatusChangeEvent(statusCode, data, actionBundleName, eventData);
        break;
      }
      default: {
        this.dealWithDownloadStatusChangeEvent(statusCode, data, actionBundleName, eventData);
      }
    }
  }

  private refreshAppIconCache(data: DownloadStatusInfo, status: AppStatus, icon: string, appList: GridLayoutItemInfo[]): GridLayoutItemInfo {
    data.status = status;
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.bundleName = data.bundleName;
    if (data.legacyInfos && !CheckEmptyUtils.isEmptyArr(data.legacyInfos) &&
      !CheckEmptyUtils.checkStrIsEmpty(data.legacyInfos[0].pkgName)) {
      item.oldBundleNames = [data.legacyInfos[0].pkgName];
    }
    if (CheckEmptyUtils.checkStrIsEmpty(data.appName)) {
      item.appName = !CheckEmptyUtils.isEmptyArr(appList) ? appList[0].appName : '';
    } else {
      item.appName = data.appName;
    }
    item.appIndex = CommonConstants.MAIN_APP_INDEX;
    item.keyName = data.bundleName + CommonConstants.MAIN_APP_INDEX;
    item.typeId = CommonConstants.TYPE_APP;
    item.appStatus = status;

    // 桌面取消了网络权限，所以无法从应用市场接口获取到图标时，不再使用iconUrl
    item.iconResource = icon;
    item.area = [1, 1];
    item.container = CommonConstants.CONTAINER_DESKTOP;
    item.intent = !CheckEmptyUtils.isEmptyArr(appList) ? appList[0].intent : '';
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [item]);
    return item;
  }

  private dealWithDownloadStatusChangeEvent(statusCode: number, data: DownloadStatusInfo, actionBundleName: string,
    eventData: DownloadStatusInfo): void {
    let mapAppStatus: AppStatus | undefined = this.installEventAppStatusMap.get(statusCode);
    if (mapAppStatus) {
      data.status = mapAppStatus;
      let downloadInfo: DownloadInfoItem = {
        bundleName: actionBundleName,
        appStatus: mapAppStatus
      };
      RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
      if (mapAppStatus !== AppStatus.PENDING) {
        this.addDownloadTaskInfo(data);
      }
      let appGalleryEventInfo: AppGalleryEventInfo = eventData as AppGalleryEventInfo;
      appGalleryEventInfo.eventType = DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE;
      appGalleryEventInfo.status = mapAppStatus;
      this.emitAppGalleryStatusChangeEvent(appGalleryEventInfo);
    }
  }

  private dealWithInstallStatusChangeEvent(statusCode: number, data: DownloadStatusInfo, actionBundleName: string,
    eventData: DownloadStatusInfo): void {
    let mapAppStatus: AppStatus | undefined = this.installEventAppStatusMap.get(statusCode);
    if (mapAppStatus) {
      data.status = mapAppStatus;
      let downloadInfo: DownloadInfoItem = {
        bundleName: actionBundleName,
        appStatus: mapAppStatus
      };
      let appGalleryEventInfo: AppGalleryEventInfo = eventData as AppGalleryEventInfo;
      appGalleryEventInfo.eventType = InstallStatusChangeEvent.INSTALL_STATUS_CHANGE;
      appGalleryEventInfo.status = mapAppStatus;
      this.emitAppGalleryStatusChangeEvent(appGalleryEventInfo);
    }
  }

  private dealAppGalleryCreatedEvent(data: DownloadStatusInfo, actionBundleName: string,
    eventData: DownloadStatusInfo): void {
    // 根据与应用市场的联调情况，针对手机中例如云空间等默认有的基础功能在接收应用市场更新通知消息时能更新升级但不需要在桌面创建图标的情况
    // 应用市场在下载接口中增加一个新字段updateStatus,这个值可能返回0和1或者undefined,来区分是否是云空间等应用更新，仅当该字段有值且值等于1时
    // 则判断是云空间等仅更新功能无需建图标的应用，刚原地break不执行任何处理，如果除此之外的值，刚走原来正常下载创建桌面icon的逻辑
    if (!data) {
      log.showWarn(`dealAppGalleryCreatedEvent data is null or undefined`);
      return;
    }
    if (GetHideAppsFromConfig.getInstance().isHideApp(actionBundleName)) {
      return;
    }
    log.showInfo(`dealWithDownloadStatusChange ${data.bundleName} ${data.updateStatus}`);
    if (data.updateStatus === 1) {
      this.dealUpdateAppItem(eventData, data.bundleName);
    } else {
      // 加入任务列表(undefined 或 0)
      data.status = AppStatus.WAITING;
      this.addDownloadTaskInfo(data);
      let appList: GridLayoutItemInfo[] = [];
      // 如果是未鸿蒙化的应用，则需根据legacyInfos去缓存中查找是否存在分身应用
      if (!data.legacyInfos || CheckEmptyUtils.isEmptyArr(data.legacyInfos) ||
        CheckEmptyUtils.checkStrIsEmpty(data.legacyInfos[0].pkgName)) {
        appList = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(data.bundleName);
      } else {
        appList = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(data.legacyInfos[0].pkgName);
      }
      this.dealNotHarmonyTaskIfNeeded(data, appList);
      // 如果是多对一的场景，删除第一个之外的所有占位图标
      this.deleteOtherNotHarmonyTaskIfNeed(data);
      AppInstallUtils.getInstance().getIconFromAppGalleryPool([data.bundleName]).then((icon: string) => {
        this.onGetIconFromAppGallery(data, icon, actionBundleName, appList);
        if (AppCategoryInfoManager.getInstance().getAppCatEnable()) {
          AppCategoryInfoManager.getInstance().updateAppCatInfo([data.bundleName]);
        }
      }).catch((err: Error) => {
        log.showInfo('dealWithDownloadStatusChange error: %{public}s', err.message);
      });
    }
  }

  private dealNotHarmonyTaskIfNeeded(data: DownloadStatusInfo, appList: GridLayoutItemInfo[]): void {
    if (!data.legacyInfos || CheckEmptyUtils.isEmptyArr(data.legacyInfos) ||
      CheckEmptyUtils.isEmpty(data.legacyInfos[0].pkgName)) {
      return;
    }
    // 存在未鸿蒙化应用文件夹，需要删除掉应用和分身，否则需要更新包名，兼容之前用户的情况
    if (FolderLayoutCacheManager.getInstance().isAppExistNotDragOutFolder(data.legacyInfos[0].pkgName)) {
      for (let i = 0; i < appList?.length; i++) {
        this.notifyDownloadCanceled(appList[i].bundleName, appList[i].appIndex ?? 0);
        log.showInfo('wait for openHarmony app delete folder app  bundleName %{public}s, appIndex :%{public}d',
          appList[i].bundleName, appList[i].appIndex);
      }
      data.legacyInfos = [];
    } else {
      // 不存在未鸿蒙化文件夹，需要更新设备包名未设备包名，避免图标异常导致新增异常图标
      // 如未鸿蒙化应用在dock区，需单独先更新dock区缓存
      appList.forEach(item => {
        if (item.container === CommonConstants.CONTAINER_SMARTDOCK) {
          let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
          let appInDockIndex: number = residentList.findIndex(dockItem => dockItem.keyName === item.keyName);
          residentList[appInDockIndex].bundleName = data.bundleName;
          residentList[appInDockIndex].keyName = data.bundleName + residentList[appInDockIndex].appIndex;
          LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_deal'), residentList);
          log.showInfo(`wait for openHarmony app update bundleName in cache, oldBundleName ${data.legacyInfos?.[0].pkgName}, bundleName ${data.bundleName}`);
        }
      });
      let downloadInfo: DownloadInfoItem = {
        bundleName: data.bundleName,
        appStatus: AppStatus.WAITING,
        oldBundleName: data.legacyInfos[0].pkgName,
        updateTwinApp: true
      };
      log.showInfo(`wait for openHarmony app update bundleName in db, oldBundleName ${data.legacyInfos[0].pkgName}, bundleName ${data.bundleName}`);
      RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
    }
  }

  private deleteOtherNotHarmonyTaskIfNeed(data: DownloadStatusInfo): void {
    if (data.legacyInfos && !CheckEmptyUtils.isEmptyArr(data.legacyInfos) && data.legacyInfos?.length > 1) {
      for (let i = 1; i < data.legacyInfos.length; i++) {
        // 避免应用市场传递多个相同的设备包名导致异常问题
        if (data.legacyInfos[i].pkgName === data.legacyInfos[0].pkgName) {
          continue;
        }
        let appList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(data.legacyInfos[i].pkgName);
        appList.forEach(item => {
          this.notifyDownloadCanceled(item.bundleName, item.appIndex ?? 0);
          log.showInfo('many to one, delete other item, bundleName %{public}s, appIndex :%{public}d',
            item.bundleName, item.appIndex);
        });
      }
    }
  }

  private dealUpdateAppItemAfterInstall(bundleName: string, statusCode: number): void {
    if (AppUpdateUtils.checkIsEnterPriseTypeAppUpdate(bundleName) &&
      (statusCode === AppGalleryEventStatus.DOWNLOAD_CANCEL_EVENT_ID ||
        statusCode === AppGalleryEventStatus.DOWNLOAD_FAILED_EVENT_ID ||
        statusCode === AppGalleryEventStatus.INSTALL_SUCCEED_EVENT_ID)
    ) {
      AppUpdateUtils.deleteEnterPriseTypeAppUpdateList(bundleName);
      let item: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
      for (let i = 0; i < item.length; i++) {
        log.showInfo(`item bundleName: ${item[i].bundleName}, item keyName: ${item[i].keyName}`);
        item[i].appStatus = AppStatus.INSTALLED;
      }
      let downloadInfo: DownloadInfoItem = {
        bundleName: bundleName,
        appStatus: AppStatus.INSTALLED
      };
      RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, item);
    } else {
      log.showInfo(`no fresh updateAppBundleNameList`);
    }
  }

  private dealUpdateAppItem(eventData: DownloadStatusInfo, bundleName: string): void {
    log.showInfo(`enter dealUpdateAppItem`);
    let appGalleryEventInfo: AppGalleryEventInfo = eventData as AppGalleryEventInfo;
    if (appGalleryEventInfo.distributeType === TYPE_ENTERPRISE || appGalleryEventInfo.distributeType === TYPE_INTERNALTESTING) {
      let item: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
      for (let i = 0; i < item.length; i++) {
        log.showInfo(`item bundleName: ${item[i].bundleName}, item keyName: ${item[i].keyName}`);
        item[i].appStatus = AppStatus.UPDATING;
      }
      let downloadInfo: DownloadInfoItem = {
        bundleName: bundleName,
        appStatus: AppStatus.UPDATING
      };
      RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, item);
      let updateAppBundleNameList: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      if (!updateAppBundleNameList) {
        AppStorage.setOrCreate('updateAppBundleNameList', [bundleName]);
      } else {
        updateAppBundleNameList.push(bundleName);
        AppStorage.setOrCreate('updateAppBundleNameList', updateAppBundleNameList);
      }
    }
  }

  private deleteNotHarmonyItem(data: DownloadStatusInfo): void {
    let pkgName = data.bundleName;
    if (data.legacyInfos && !CheckEmptyUtils.isEmptyArr(data.legacyInfos)) {
      pkgName = data.legacyInfos[0].pkgName ?? data.bundleName;
      log.showInfo('pkgName : %{public}s bundleName : %{public}s', pkgName, data.bundleName);
    } else {
      pkgName = pkgName.split('__')[2];
      log.showInfo('pkgName : %{public}s bundleName : %{public}s', pkgName, data.bundleName);
    }
    if (!this.isAppUpdating(pkgName)) {
      this.removeMainAndTwinAppByBundleName(pkgName);
    }
  }

  private onGetIconFromAppGallery(data: DownloadStatusInfo, icon: string, actionBundleName: string,
    appList: GridLayoutItemInfo[]): void {
    log.showInfo('AppGalleryEventStatus CREATE_EVENT_ID icon is %{public}s', icon);
    let status: number = AppStatus.WAITING;
    let downloadInfo: DownloadStatusInfo | undefined = this.getDownDownloadTaskInfo(actionBundleName);
    if (downloadInfo) {
      status = downloadInfo.status;
    } else {
      // 任务列表中无任务，说明任务已被移除，不再创建桌面图标
      log.showInfo('onGetIconFromAppGallery return for canceled');
      return;
    }
    data.status = status;
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.bundleName = data.bundleName;
    if (data.legacyInfos && !CheckEmptyUtils.isEmptyArr(data.legacyInfos)) {
      item.oldBundleNames = [data.legacyInfos[0].pkgName];
    }
    item.appIndex = CommonConstants.MAIN_APP_INDEX;
    item.keyName = data.bundleName + CommonConstants.MAIN_APP_INDEX;
    item.typeId = CommonConstants.TYPE_APP;
    item.appStatus = status;
    item.appName = data?.appName;
    // 桌面取消了网络权限，所以无法从应用市场接口获取到图标时，不再使用iconUrl
    item.iconResource = (icon === undefined) ? undefined : FILE_PRE + icon;
    item.area = [1, 1];
    if (!CheckEmptyUtils.isEmptyArr(appList) &&
      CommonUtils.jsonStrToMap(appList[0].intent).get('appType') === AppReserveType.ENTERPRISE) {
      item.intent = appList[0].intent;
    }
    // 加桌上限设置 需保留
    const limitNum = !CheckEmptyUtils.isEmptyArr(appList) ? CommonUtils.jsonStrToMap(appList[0].intent)
      .get(SHORTCUT_LIMIT_KEY) : undefined;
    if (limitNum !== undefined) {
      let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
      intentMap.set(SHORTCUT_LIMIT_KEY, limitNum);
      item.intent = CommonUtils.mapToJonStr(intentMap);
    }
    item.container = CommonConstants.CONTAINER_DESKTOP;
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [item]);
    log.showInfo(`download main app, bundleName: ${item.bundleName}, appIndex: ${item.appIndex}, appStatus: ${item.appStatus}, iconResource: ${item.iconResource}`);
    this.refreshAppTwinIcon(item, appList);
    this.addDownloadTaskInfo(data);
    this.appDownloadMap.set(item.bundleName, Date.now());
  }

  private refreshAppTwinIcon(item: GridLayoutItemInfo, appList: GridLayoutItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      return;
    }
    appList.forEach(sameBundleNameItem => {
      if ((sameBundleNameItem.appIndex ?? 0) > 0) {
        item.appIndex = sameBundleNameItem.appIndex;
        item.keyName = item.bundleName + sameBundleNameItem.appIndex;
        item.appStatus = AppStatus.PENDING;
        item.installTime = new Date().getTime().toString();
        item.appName = CheckEmptyUtils.checkStrIsEmpty(item.appName) ? sameBundleNameItem.appName : item.appName;
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [item]);
        log.showInfo(`download twin app, bundleName: ${item.bundleName}, appIndex: ${item.appIndex}, appStatus: ${item.appStatus}, iconResource: ${item.iconResource}`);
      }
    });
  }

  public removeDownloadInfo(bundleName: string, appIndex: number = 0): void {
    this.notifyDownloadCanceled(bundleName, appIndex);
    if (appIndex === CommonConstants.MAIN_APP_INDEX) {
      this.deleteDownloadProgressInfo(bundleName);
      this.deleteDownloadTaskInfo(bundleName);
    }
  }

  private dealWithDownloadProgressChange(eventData: AppDownloadInfo, actionBundleName: string): void {
    let totalSize: number = eventData.totalSize;
    let downloadedSize: number = eventData.downloadedSize;
    let progress: number = downloadedSize / totalSize;
    let downloadInfo: DownloadInfoItem = {
      bundleName: actionBundleName,
      downloadProgress: progress
    };
    RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
    this.addDownloadProgressInfo(eventData);
    let data: DownloadStatusInfo = {
      bundleName: actionBundleName,
      status: AppStatus.DOWNLOADING
    };
    this.addDownloadTaskInfo(data);
    let appGalleryEventInfo: AppGalleryEventInfo = eventData as AppGalleryEventInfo;
    appGalleryEventInfo.eventType = DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE;
    this.emitAppGalleryStatusChangeEvent(appGalleryEventInfo);
  }

  private dealWithInstallStatusChange(eventData: AppInstallStatusInfo, statusCode: number, actionBundleName: string): void {
    log.showInfo('dealWithInstallStatusChange statusCode is %{public}d', statusCode);
    if (statusCode === AppGalleryEventStatus.INSTALL_START_EVENT_ID) {
      let statusChangeEventDate: DownloadStatusInfo = {
        bundleName: actionBundleName,
        status: AppStatus.INSTALLING
      };
      this.dealWithDownloadStatusChangeEvent(AppGalleryEventStatus.INSTALL_START_EVENT_ID, statusChangeEventDate, actionBundleName, statusChangeEventDate);
    }
    if (statusCode === AppGalleryEventStatus.INSTALL_FAILED_EVENT_ID) {
      this.installFailedNotify(actionBundleName);
      // 主应用安装失败时，同步移除所有分身应用
      this.removeMainAndTwinAppByBundleName(actionBundleName);
    }
    this.dealUpdateAppItemAfterInstall(actionBundleName, statusCode);
  }

  private installFailedNotify(actionBundleName: string): void {
    // 接收到安装失败事件后发送安装失败通知
    // PC通过AppGalleryStatusChangeEvent来监听安装失败回调
    if (DeviceHelper.isPC()) {
      let statusChangeEventDate: DownloadStatusInfo = {
        bundleName: actionBundleName,
        status: AppStatus.INSTALL_FAIL
      };
      this.dealWithInstallStatusChangeEvent(AppGalleryEventStatus.INSTALL_FAILED_EVENT_ID, statusChangeEventDate, actionBundleName, statusChangeEventDate);
    }
  }

  private removeMainAndTwinAppByBundleName(bundleName: string): void {
    this.deleteDownloadProgressInfo(bundleName);
    this.deleteDownloadTaskInfo(bundleName);
    let appList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    appList.forEach(item => {
      log.showWarn(`remove item, bundleName:${item.bundleName}, appIndex:${item.appIndex}, status:${item.appStatus}`);
      if (item.appStatus !== AppStatus.INSTALLED) {
        this.notifyDownloadCanceled(bundleName, item.appIndex ?? 0);
      }
    });
  }

  private emitAppGalleryStatusChangeEvent(data: AppGalleryEventInfo): void {
    const eventHub: ctx.EventHub = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.eventHub;
    eventHub.emit(`appGalleryStatusChange${data.bundleName}${CommonConstants.MAIN_APP_INDEX}item`, data);
    eventHub.emit(`appGalleryStatusChange${data.bundleName}${CommonConstants.MAIN_APP_INDEX}appCenter`, data);
    eventHub.emit(`appGalleryStatusChange${data.bundleName}${CommonConstants.MAIN_APP_INDEX}icon`, data);
    eventHub.emit(`appGalleryStatusChange${data.bundleName}${CommonConstants.MAIN_APP_INDEX}name`, data);
    eventHub.emit(`appGalleryStatusChange${data.bundleName}${CommonConstants.MAIN_APP_INDEX}folder`, data);
    eventHub.emit(`appGalleryStatusChange${data.bundleName}${CommonConstants.MAIN_APP_INDEX}smallFolder`, data);
  }

  private addDownloadProgressInfo(appDownloadInfo: AppDownloadInfo): void {
    let currentInfoIndex: number = this.downloadProgressList.findIndex(item => item.bundleName === appDownloadInfo.bundleName);
    if (currentInfoIndex !== -1) {
      this.downloadProgressList[currentInfoIndex] = appDownloadInfo;
    } else {
      this.downloadProgressList.push(appDownloadInfo);
    }
  }

  public deleteDownloadProgressInfo(actionBundleName: string): void {
    this.downloadProgressList = this.downloadProgressList.filter(item => item.bundleName !== actionBundleName);
  }

  private addDownloadTaskInfo(downloadStatusInfo: DownloadStatusInfo): void {
    let currentInfoIndex: number = this.downloadTaskList.findIndex(item => item.bundleName === downloadStatusInfo.bundleName);
    if (currentInfoIndex !== -1) {
      this.downloadTaskList[currentInfoIndex] = ObjectCopyUtil.simpleClone(downloadStatusInfo);
    } else {
      this.downloadTaskList.push(downloadStatusInfo);
    }
  }

  public deleteDownloadTaskInfo(actionBundleName: string): void {
    this.downloadTaskList = this.downloadTaskList.filter(item => item.bundleName !== actionBundleName);
  }

  /**
   * 读取应用的下载进度
   * @param actionBundleName 应用bundleName
   * @returns
   */
  public getDownloadProgressInfo(actionBundleName: string): AppDownloadInfo | undefined {
    return this.downloadProgressList.find(item => item.bundleName === actionBundleName);
  }

  /**
   * 读取应用的下载信息
   * @param actionBundleName 应用bundleName
   * @returns
   */
  public getDownDownloadTaskInfo(actionBundleName: string): DownloadStatusInfo | undefined {
    return this.downloadTaskList.find(item => item.bundleName === actionBundleName);
  }

  private changeAllCacheAppToPause(): void {
    let downloadingList: DownloadStatusInfo[] = [];
    this.downloadTaskList.forEach((item) => {
      if (item.status === AppStatus.WAITING || item.status === AppStatus.DOWNLOADING ||
        item.status === AppStatus.INSTALL_WAITING || item.status === AppStatus.INSTALLING) {
        downloadingList.push(item);
      }
    });
    downloadingList.forEach((item) => {
      let downloadInfo: DownloadInfoItem = {
        bundleName: item.bundleName,
        appStatus: AppStatus.PAUSING
      };
      RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
    });
  }

  private async removeAllNotInstalledApp(): Promise<void> {
    let notInstalledApplicationList: string[] = await RdbStoreManager.getInstance().queryNotInstalledApplication();
    notInstalledApplicationList.forEach(bundleName => {
      log.showInfo('delete not installed app: %{public}s', bundleName);
      this.removeDownloadInfo(bundleName);
    });
  }
}

export interface AppGalleryDownloadListener {
  onDownloadCanceled(event: string, bundleName: string, appIndex: number): void;
}

export interface CheckTaskOptions {
  // ownerInfo: installInfoManager.OwnerInfo;
  ownerInfo: ESObject;
  callerName: string;
}