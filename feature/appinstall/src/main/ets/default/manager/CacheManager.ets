/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  CommonUtils
} from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  HiDfxEventUtil,
  localEventManager,
  PackageCommonEvent
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AppInstallingDataManager } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallingDataManager';
import { AppGalleryData } from '../data/AppGalleryData';
import {
  AppInstallEventData,
  AppItemInfo,
  AppModel,
  AppStatus,
  CommonConstants,
  DesktopPosition,
  DownloadInfoItem,
  EventConstants,
  FormModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LaunchLayoutCacheManager,
  RdbStoreManager,
  AppGalleryEventInfo,
  scbBlankPositionUtils,
  ResidentLayoutCacheMgr,
  DockItemInfo,
  FolderManager,
  PreInstallUtils
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { InstallUtils } from '../utils/InstallUtils';
import { InstallDataManager } from './InstallDataManager';
import { InstallEventManager } from './InstallEventManager';
import { MatchCardDataManager } from '@ohos/launchercommon/src/main/ets/model/MatchCardDataManager';

const TAG = 'appInstall_CacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FILE_PRE = 'file://';
const APP_TYPE = 'appType';
const DEFAULT_RES = 0;

/**
 * 用来处理跟安装卸载相关的缓存
 */
export class CacheManager {
  private static mInstance: CacheManager;

  public static getInstance(): CacheManager {
    if (!CacheManager.mInstance) {
      CacheManager.mInstance = new CacheManager();
    }
    return CacheManager.mInstance;
  }

  /**
   * 更新下载进度，收到509存库
   */
  public updateDownloadProgress(findApp: GridLayoutItemInfo | DockItemInfo, downloadProgress: number,
    appStatus: AppStatus): void {
    if (appStatus !== undefined) {
      findApp.appStatus = appStatus;
    }
    // 更新数据库
    let updateApp: DownloadInfoItem = {
      bundleName: findApp.bundleName,
      appIndex: CommonConstants.MAIN_APP_INDEX,
      downloadProgress: downloadProgress,
    };
    RdbStoreManager.getInstance().updateDownloadInfo(updateApp);
  }

  /**
   * 更新过程中取消更新
   * @param app
   */
  public cancelAppUpdate(app: GridLayoutItemInfo | DockItemInfo ): void {
    let bundleName = app.bundleName;
    log.showInfo('cancelAppUpdate %{public}s', bundleName);
    app.appStatus = AppStatus.INSTALLED;
    app.downloadProgress = 0;
    let updateApp: DownloadInfoItem = {
      bundleName: bundleName,
      appIndex: CommonConstants.MAIN_APP_INDEX,
      appStatus: AppStatus.INSTALLED,
    };
    RdbStoreManager.getInstance().updateDownloadInfo(updateApp);
  }

  /**
   * 更新下载状态
   */
  public updateAppStatus(app: GridLayoutItemInfo | DockItemInfo, eventInfo: AppGalleryEventInfo): void {
    if (eventInfo.status === undefined) {
      log.showWarn('app[%{public}s] updateAppStatus appStatus is undefined return', eventInfo.bundleName);
      return;
    }
    log.showInfo('updateAppStatus app[%{public}s] appStatus:%{public}d', eventInfo.bundleName, eventInfo.status);
    app.appStatus = eventInfo.status;
    // appStatus=6不存库, 由于数据库是异步执行的，有可能存在先appStatus=0， 这里的异步操作修改成6，存库由BMS监听的安装完成事件处理
    if (app.appStatus === AppStatus.INSTALLING) {
      return;
    }
    let updateApp: DownloadInfoItem = {
      bundleName: eventInfo.bundleName,
      appStatus: eventInfo.status,
      appIndex: CommonConstants.MAIN_APP_INDEX,
    };
    RdbStoreManager.getInstance().updateDownloadInfo(updateApp);
  }

  /**
   * 应用安装或更新
   * @param commonEvent
   * @returns
   */
  public async appAddedOrUpdated(commonEvent: PackageCommonEvent, bundleName: string): Promise<void> {
    if (!bundleName) {
      log.showWarn('appAddedOrUpdated invalid bundleName');
      return;
    }

    let installer = InstallDataManager.getInstance().getTask(bundleName);
    if (installer) {
      installer.deleteDownloadProgressInfo(bundleName);
    } else {
      log.showWarn('appAddedOrUpdated is not from app gallery, maybe from hdc install bundleName:%{public}s',
        bundleName);
    }

    // 应用安装完成，清楚正在安装应用的缓存
    AppInstallingDataManager.getInstance().removeInstallingData(bundleName);
    let appIndex: number | undefined = commonEvent.appIndex;
    AppModel.getInstance().updateShortcutInfo(bundleName, commonEvent.event);
    if (!appIndex) {
      // 只有主应用涉及卡片
      FormModel.getInstance().deleteCardDescriptionCache(bundleName);
    }
    await AppModel.getInstance().appAddedOrUpdated(commonEvent.event, bundleName, appIndex);
    await this.updateNewInstalledApp(bundleName, appIndex);
    let findApp = this.getAppFromCache(bundleName, appIndex, CommonConstants.TYPE_APP);
    let appInstallEvent: AppInstallEventData = new AppInstallEventData();
    appInstallEvent.eventName = commonEvent.event;
    appInstallEvent.bundleName = bundleName;
    appInstallEvent.appIndex = appIndex ?? CommonConstants.MAIN_APP_INDEX;
    localEventManager.sendLocalEventSticky(EventConstants.APP_INSTALL_BMS_CHANGE_EVENT, appInstallEvent);
    // isUpdate设置为false，只有第一次更新的时候设置为true
    const folderId: string = InstallUtils.getFolderId(findApp);
    // 文件夹中应用更新后，清理缓存中旧的文件夹
    if (!CheckEmptyUtils.isEmpty(folderId)) {
      FolderManager.getInstance().deleteFolderCache('appAddedOrUpdated', folderId);
    }
    InstallEventManager.notifyInstallStatusChangeEvent(bundleName, InstallUtils.getFolderId(findApp));
    if (commonEvent.event === EventConstants.EVENT_PACKAGE_CHANGED) {
      localEventManager.sendLocalEvent('updateIconImage_' + bundleName);
    }
  }

  /**
   * 应用卸载调用
   * @param commonEvent
   */
  public packageRemoved(commonEvent: PackageCommonEvent, bundleName: string): void {
    if (!bundleName) {
      log.showWarn('packageRemoved invalid bundleName');
      return;
    }
    let appIndex: number | undefined = commonEvent.appIndex;
    AppModel.getInstance().updateShortcutInfo(bundleName, commonEvent.event);
    if (!appIndex) {
      // 只有主应用涉及卡片
      FormModel.getInstance().deleteCardDescriptionCache(bundleName);
    }
    this.removeItem(bundleName, appIndex);
    let appInstallEvent: AppInstallEventData = new AppInstallEventData();
    appInstallEvent.eventName = commonEvent.event;
    appInstallEvent.bundleName = bundleName;
    appInstallEvent.appIndex = commonEvent.appIndex ?? CommonConstants.MAIN_APP_INDEX;
    localEventManager.sendLocalEventSticky(EventConstants.APP_INSTALL_BMS_CHANGE_EVENT, appInstallEvent);
  }

  /**
   * 移除应用
   * @param bundleName
   * @param appIndex
   */
  public removeItem(bundleName: string, appIndex: number = 0): void {
    log.showInfo('appItem remove bundleName:%{public}s appIndex:%{public}d', bundleName, appIndex);
    AppModel.getInstance().appItemRemove(bundleName, appIndex);
  }

  public updateIconResource(bundleName: string, icon: string): void {
    let findApp = this.getAppFromCache(bundleName);
    if (!findApp) {
      return;
    }
    if (icon) {
      findApp.iconResource = FILE_PRE + icon;
    }
  }

  /**
   * 向缓存中写入应用
   * @param item
   * @param icon
   */
  public insertGridLayoutItemInfo(item: GridLayoutItemInfo, icon: string): void {
    let findApp = this.getAppFromCache(item.bundleName);
    if (findApp) {
      log.showWarn('insertGridLayoutItemInfo find app[%{public}s] in cache', item.bundleName);
      // 如果应用已安装完成，返回
      if (findApp.appStatus === AppStatus.INSTALLED) {
        return;
      }
      this.updateCloneItemInfo(item, icon);
      return;
    }
    // 如果存在oldBundleNames，需要替换占位图标的包名
    if (!CheckEmptyUtils.isEmptyArr(item.oldBundleNames)) {
      this.updatePackageInfo(item, icon);
      return;
    }
    if (icon) {
      item.iconResource = FILE_PRE + icon;
    }
    this.insertGridLayout(item);
    // 这个时候桌面还没有图标，发送通知刷新桌面
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  private insertGridLayout(item: GridLayoutItemInfo | AppItemInfo): void {
    let desktopPosition: DesktopPosition = scbBlankPositionUtils.findBlankPosition(false);
    let gridlayoutItem: GridLayoutItemInfo =
      GridLayoutUtil.buildGridLayoutInfoFromItemInfo(item, desktopPosition.page, desktopPosition.column,
        desktopPosition.row);
    if (!gridlayoutItem.container) {
      log.showWarn('default container');
      gridlayoutItem.container = CommonConstants.CONTAINER_DESKTOP;
    }
    if (gridlayoutItem.typeId === undefined) {
      log.showWarn('default typeId');
      gridlayoutItem.typeId = CommonConstants.TYPE_APP;
    }

    if (!desktopPosition.isFind) {
      log.showWarn('findBlankPosition app[%{public}s] do not find blank position', item.bundleName);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_ADD_APP_WHEN_EXCEED_MAX_PAGE, [gridlayoutItem]);
      return;
    }
    LaunchLayoutCacheManager.getInstance()
      .insertGridLayoutItemInfo(gridlayoutItem, BusinessType.BUSINESS_APP_INSTALL, true, false);
  }

  private updatePackageInfo(item: GridLayoutItemInfo, icon: string): void {
    if (CheckEmptyUtils.isEmptyArr(item.oldBundleNames) || !item.oldBundleNames) {
      return;
    }
    if (icon) {
      item.iconResource = FILE_PRE + icon;
    }
    item.installTime = new Date().getTime().toString();
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [item]);
    log.showInfo(`updatePackageInfo bundleName: ${item.bundleName}, appIndex: ${item.appIndex}` +
      `appStatus: ${item.appStatus} appName: ${item.appName}`);

    let appList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(item.oldBundleNames[0]);

    if (CheckEmptyUtils.isEmptyArr(appList)) {
      return;
    }

    appList.forEach(sameBundleNameItem => {
      if (sameBundleNameItem.appIndex && sameBundleNameItem.appIndex > 0) {
        item.appIndex = sameBundleNameItem.appIndex;
        item.keyName = item.bundleName + sameBundleNameItem.appIndex;
        item.appStatus = AppStatus.PENDING;
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [item]);
        log.showInfo(`updatePackageInfo twin bundleName: ${item.bundleName}, appIndex: ${item.appIndex}` +
          `appStatus: ${item.appStatus} appName: ${item.appName}`);
      }
    });
  }

  private updateCloneItemInfo(item: GridLayoutItemInfo, icon: string): void {
    let appList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(item.bundleName);
    for (let findApp of appList) {
      if (findApp.appStatus === AppStatus.INSTALLED) {
        continue;
      }
      if (findApp.appIndex === undefined) {
        continue;
      }
      if (icon) {
        findApp.iconResource = FILE_PRE + icon;
      }
      findApp.appName = CheckEmptyUtils.checkStrIsEmpty(findApp.appName) ? item.appName : findApp.appName;
      findApp.intent = item.intent ?? '';
      if (findApp.appIndex === CommonConstants.MAIN_APP_INDEX) {
        findApp.appStatus = item.appStatus;
      } else {
        findApp.appStatus = AppStatus.PENDING;
      }
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [findApp]);
      log.showInfo(`updateGridLayoutItemInfo bundleName: ${findApp.bundleName}, appIndex: ${findApp.appIndex}` +
        `appStatus: ${findApp.appStatus} appName: ${findApp.appName}`);
    }
  }

  /**
   * 重置企业应用状态
   *
   * @param data ag发送的通知
   * @param status 需要重置的状态
   */
  public resetCompanyApp(data: AppGalleryData, status: AppStatus): void {
    let appList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(data.bundleName);
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      log.showError('resetCompanyApp fail, can not find app[%{public}s] in cache', data.bundleName);
      return;
    }
    let companyApp: GridLayoutItemInfo = appList[0];
    companyApp.installTime = new Date().getTime().toString();
    companyApp.appStatus = status;
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, [companyApp]);
    log.showWarn(`resetCompanyApp bundleName: ${companyApp.bundleName} appStatus: ${companyApp.appStatus}`);
  }

  /**
   * 从缓存中查找应用
   * @param bundleName
   * @param appIndex
   * @param typeId
   * @returns
   */
  public getAppFromCache(bundleName: string, appIndex: number = CommonConstants.MAIN_APP_INDEX,
    typeId: number = CommonConstants.TYPE_APP): GridLayoutItemInfo | DockItemInfo | undefined {
    // 应用安装只涉及到内屏，所以只查询内屏缓存
    let findApps: GridLayoutItemInfo | DockItemInfo | undefined =
      LaunchLayoutCacheManager.getInstance().findAppFromCache(bundleName, appIndex, typeId, false);
    if (!findApps) {
      findApps = ResidentLayoutCacheMgr.getInstance().getAppTypeItemByBundleName(bundleName, appIndex);
    }
    return findApps;
  }

  // 安装完成更新缓存和数据库
  private async updateNewInstalledApp(bundleName: string, appIndex: number | undefined): Promise<number> {
    /**
     * 更新新安装数据
     * 为什么从AppModel中获取，其中一个原因是拦截元服务，桌面上没有元服务
     */
    let newApp: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleInfo({
      bundleName: bundleName,
      appIndex: appIndex ?? CommonConstants.MAIN_APP_INDEX
    });
    if (!newApp) {
      log.showWarn('updateNewInstalledApp can not find app[%{public}s] in bundleInfo map', bundleName);
      return DEFAULT_RES;
    }
    log.showInfo('updateNewInstalledApp: %{public}s', JSON.stringify(newApp));
    let cacheItem = this.getAppFromCache(newApp.bundleName, newApp.appIndex, newApp.typeId);
    // 如果缓存中没有，就把应用写到缓存中去（通过hdc命令安装的应用）
    if (!cacheItem) {
      let isCodePathNumber = !Number.isNaN(Number(newApp.codePath));
      // 如果是number类型不处理
      if (isCodePathNumber) {
        log.showWarn('%{public}s is dong hu app, do nothing', bundleName);
        return DEFAULT_RES;
      }
      if (MatchCardDataManager.isMatchCardApp(newApp, 'updateNewInstalledApp')) {
        log.showWarn('%{public}s is MatchCardApp, do nothing', bundleName);
        return DEFAULT_RES;
      }
      log.showError('updateNewInstalledApp can not find app[%{public}s] in cache', bundleName);
      newApp.area = [1, 1];
      this.insertGridLayout(newApp);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      return DEFAULT_RES;
    }
    let originItem: GridLayoutItemInfo = new GridLayoutItemInfo();
    // 更新缓存
    this.updateGridLayoutItemInfo(cacheItem, newApp);
    // 安装完成之后，需要对旧缓存中intent字段中的预装应用字段isNeedInstallApp清除
    if (PreInstallUtils.checkIsNeedInstallAppByIntent(cacheItem)) {
      PreInstallUtils.resetIntent(cacheItem);
      log.showInfo(`Get intent of itemInfo after clean isNeedInstallApp, itemInfo: ${cacheItem?.intent}`);
    }
    // 构造更新数据库对象
    this.updateGridLayoutItemInfo(originItem, newApp);
    let res = await RdbStoreManager.getInstance().updateNewInstalledGridInfo(originItem);
    if (res < DEFAULT_RES) {
      // res小于0表示入库失败
      HiDfxEventUtil.reportIconStatusAbnormal('icon app status update installed invalid', bundleName);
    }
    return res;
  }

  private updateGridLayoutItemInfo(originItem: GridLayoutItemInfo | DockItemInfo, newApp: AppItemInfo): void {
    originItem.bundleName = newApp.bundleName;
    originItem.appName = newApp.appName;
    originItem.applicationName = newApp.applicationName;
    originItem.applicationLabelId = newApp.applicationLabelId;
    originItem.appIconId = newApp.appIconId;
    originItem.appLabelId = newApp.appLabelId;
    originItem.isUninstallAble = newApp.isUninstallAble;
    originItem.isSystemApp = newApp.isSystemApp;
    originItem.installTime = newApp.installTime;
    originItem.moduleName = newApp.moduleName;
    originItem.abilityName = newApp.abilityName;
    originItem.keyName = newApp.keyName;
    originItem.appIndex = newApp.appIndex;
    originItem.appStatus = AppStatus.INSTALLED;
  }

  /**
   * 根据bundleName从缓存中查找所有应用
   * @param bundleName
   * @returns
   */
  public getAllSameBundleNameAppItem(bundleName: string): GridLayoutItemInfo[] {
    return LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
  }

  /**
   * 获取所有的app list
   * @returns
   */
  public getAllGridLayoutItemList(): GridLayoutItemInfo[] {
    return LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(TAG);
  }

  /**
   * 暂停所有正在下砸的任务
   */
  public changeAllCacheAppToPause(): void {
    let tasks: string[] = InstallDataManager.getInstance().getAllTask();
    tasks.forEach((bundleName) => {
      let findApp = this.getAppFromCache(bundleName);
      if (findApp && (findApp.appStatus === AppStatus.DOWNLOADING || findApp.appStatus === AppStatus.UPDATING)) {
        let updateApp: DownloadInfoItem = {
          bundleName: bundleName,
          appStatus: AppStatus.PAUSING,
          appIndex: CommonConstants.MAIN_APP_INDEX,
        };
        RdbStoreManager.getInstance().updateDownloadInfo(updateApp);
      }
    });
  }

  /**
   * 应用更新安装，设置正在安装应用的缓存，安装完成清除正在安装应用的缓存
   *
   * @param bundleName
   * @param appStatus 0：应用更新开始安装，1：安装完成
   *
   */
  public updateInstallingData(bundleName: string, appStatus: number): void {
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return;
    }
    log.showInfo(`updateInstallingData bundleName: ${bundleName} appStatus: ${appStatus}`);
    if (appStatus === 0) {
      AppInstallingDataManager.getInstance().addInstallingData(bundleName);
      return;
    }
    AppInstallingDataManager.getInstance().removeInstallingData(bundleName);
  }
}