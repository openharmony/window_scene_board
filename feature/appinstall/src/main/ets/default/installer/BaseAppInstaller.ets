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

import {
  AppCategoryInfoManager,
  AppInstallUtils,
  GridLayoutItemInfo,
  AppGalleryEventInfo,
  AppStatus,
  CommonConstants,
  DownloadInfoItem,
  AppItemInfo,
  AppModel,
  GetHideAppsFromConfig,
  DockItemInfo,
  DisposedEventManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppDownloadInfo, AppGalleryData } from '../data/AppGalleryData';
import { BusinessError } from '@kit.BasicServicesKit';
import { CacheManager } from '../manager/CacheManager';
import { InstallDataManager } from '../manager/InstallDataManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  CommonEvent,
  HiDfxEventUtil,
  HiSysEventUtil,
  IconResourceManager
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AppGalleryEventStatus, InstallType } from '../constants/AppInstallConstants';
import { InstallUtils } from '../utils/InstallUtils';
import { InstallEventManager } from '../manager/InstallEventManager';
import { UpdateType } from '@ohos/commonconstants';

const TAG = 'appInstall_BaseAppInstaller';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 安装基类
 */
export abstract class BaseAppInstaller {
  protected type: InstallType = InstallType.NEW_INSTALLER;
  protected installDataManager: InstallDataManager = InstallDataManager.getInstance();

  /**
   * 存放每个下载任务数据
   */
  private appGalleryDataMap: Map<string, AppGalleryData> = new Map();
  protected appGallerDatas: AppGalleryData[] = [];
  protected taskPoolNum: number = 0;
  protected isRunning: boolean = false;

  protected constructor() {
  }

  /**
   * 获取下载类型
   * @returns
   */
  public getInstallType(): InstallType {
    return this.type;
  }

  /**
   * 处理EVENT_DOWNLOAD_STATUS_CHANGE事件
   * @param event
   */
  public dealWithDownloadStatusChange(event: CommonEvent): void {
    if (!event) {
      log.showWarn('dealWithDownloadStatusChange data is undefined');
      return;
    }
    this.downloadStatusChange(event);
  }

  private downloadStatusChange(event: CommonEvent): void {
    let eventData: AppGalleryData = event.parameters as AppGalleryData;
    let bundleName: string = eventData.bundleName;
    let eventCode: number | undefined = event.code;
    let updateStatus: number | undefined = eventData.updateStatus;
    log.showWarn('downloadStatusChange:%{public}s,eventCode:%{public}d,updateStatus:%{public}d,installer:%{public}d',
      bundleName, eventCode, updateStatus, this.getInstallType());
    switch (eventCode) {
      case AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT:
        this.code501(eventData, bundleName, event);
        // 更新应用分享标识
        break;
      case AppGalleryEventStatus.DOWNLOAD_WAIT_EVENT:
        this.code502(eventData);
        break;
      case AppGalleryEventStatus.DOWNLOAD_PAUSE_EVENT:
        this.code503(eventData);
        break;
      case AppGalleryEventStatus.DOWNLOAD_RESUME_EVENT:
        this.code504(eventData);
        break;
      case AppGalleryEventStatus.DOWNLOAD_WLAN_EVENT:
        this.code505(eventData);
        break;
      case AppGalleryEventStatus.DOWNLOAD_FAILED_EVENT:
        this.code506(eventData);
        break;
      case AppGalleryEventStatus.DOWNLOAD_SUCCEED_EVENT:
        this.code507(eventData);
        break;
      case AppGalleryEventStatus.DOWNLOAD_CANCEL_EVENT:
        this.code508(eventData);
        break;
      case AppGalleryEventStatus.COMPANY_APP_RESET_EVENT:
        this.code518(eventData);
        break;
      default:
        log.showError('dealWithDownloadStatusChange not support eventData %{public}s', JSON.stringify(eventData));
    }
  }

  /**
   * 处理EVENT_INSTALL_STATUS_CHANGE事件
   * @param event
   */
  public dealWithInstallStatusChange(event: CommonEvent): void {
    if (!event) {
      log.showWarn('dealWithInstallStatusChange data is undefined');
      return;
    }
    let eventData: AppGalleryData = event.parameters as AppGalleryData;
    let bundleName: string = eventData.bundleName;
    let updateStatus: number | undefined = eventData.updateStatus;
    let eventCode: number | undefined = event.code;
    log.showWarn('dealWithInstallStatusChange:%{public}s,code:%{public}d,updateStatus:%{public}s,installer:%{public}d',
      bundleName, eventCode, updateStatus, this.getInstallType());
    switch (eventCode) {
      case AppGalleryEventStatus.INSTALL_START_EVENT:
        this.code510(bundleName);
        break;
      case AppGalleryEventStatus.INSTALL_FAILED_EVENT:
        this.code511(eventData, bundleName);
        break;
      case AppGalleryEventStatus.INSTALL_SUCCEED_EVENT: {
        this.code512(eventData, event);
        break;
      }
      default: {
        log.showError('dealWithInstallStatusChange not support statusCode %{public}s', JSON.stringify(eventData));
      }
    }
  }

  protected code501(appGalleryData: AppGalleryData, bundleName: string, event: CommonEvent): void {
    if (GetHideAppsFromConfig.getInstance().isHideApp(bundleName)) {
      log.showWarn('deal with app install 501, bundleName:%{public}s is hide app, return', bundleName);
      return;
    }
    log.showInfo('code501 data: %{public}s', JSON.stringify(appGalleryData));
    // 加入任务列表
    appGalleryData.status = AppStatus.WAITING;
    appGalleryData.startTime = Date.now();
    this.addDownloadTaskInfo(appGalleryData);
    let item: GridLayoutItemInfo = InstallUtils.buildInsertItem(appGalleryData);
    this.getAppIcon(item, bundleName);
  }

  protected getAppIcon(item: GridLayoutItemInfo, bundleName: string): void {
    AppInstallUtils.getInstance().getIconFromAppGalleryPool([bundleName]).then((icon: string) => {
      let appGalleryData: AppGalleryData | undefined = this.appGalleryDataMap.get(bundleName);
      if (appGalleryData && appGalleryData.status !== undefined) {
        item.appStatus = appGalleryData.status;
      }
      if (CheckEmptyUtils.isEmpty(icon)) {
        HiDfxEventUtil.reportIconStatusAbnormal('get icon from app gallery invalid when 501', bundleName,
          `${item.appIndex}_${item.typeId}`);
      }
      CacheManager.getInstance().insertGridLayoutItemInfo(item, icon);
      AppCategoryInfoManager.getInstance().updateAppCatInfo([bundleName]);
    }).catch((err: BusinessError) => {
      log.showError('dealWithDownloadStatusChange error[%{public}d]: %{public}s', err.code, err.message);
    }).finally(() => {
      this.taskPoolNum--;
    });
  }

  protected code502(eventData: AppGalleryData): void {
    this.dealWithDownloadStatusChangeEvent(eventData, AppStatus.WAITING);
  }

  protected code503(eventData: AppGalleryData): void {
    this.dealWithDownloadStatusChangeEvent(eventData, AppStatus.PAUSING);
  }

  protected code504(eventData: AppGalleryData): void {
    this.dealWithDownloadStatusChangeEvent(eventData, AppStatus.DOWNLOADING);
  }

  protected code505(eventData: AppGalleryData): void {
    this.dealWithDownloadStatusChangeEvent(eventData, AppStatus.PAUSING);
  }

  protected code506(data: AppGalleryData): void {
    // 主应用下载取消和失败时，同步移除所有分身应用
    this.removeApp(data.bundleName);
  }

  protected code507(data: AppGalleryData): void {
    let appGalleryData: AppGalleryData | undefined = this.appGalleryDataMap.get(data.bundleName);
    if (appGalleryData) {
      HiSysEventUtil.reportAnimationDurationAppDownload(data.bundleName, Date.now() - (appGalleryData.startTime ?? 0));
    }
  }

  protected code508(data: AppGalleryData): void {
    log.showInfo('code508 bundleName: %{public}s', data.bundleName);
    this.deleteDownloadProgressInfo(data.bundleName);
    this.removeApp(data.bundleName);
  }

  protected code510(bundleName: string): void {
    let statusChangeEventDate: AppGalleryData = {
      bundleName: bundleName,
      status: AppStatus.INSTALLING
    };
    this.dealWithDownloadStatusChangeEvent(statusChangeEventDate, AppStatus.INSTALLING);
  }

  protected code511(eventData: AppGalleryData, bundleName: string): void {
    this.deleteDownloadProgressInfo(bundleName);
    // 主应用安装失败时，同步移除所有分身应用
    this.removeApp(bundleName);
  }

  protected code512(data: AppGalleryData, event: CommonEvent): void {
    log.showInfo('code512 bundleName: %{public}s', data.bundleName);
    data.status = AppStatus.INSTALLED;
    this.updateAppGalleryDataStatus(data, AppStatus.INSTALLED);
    this.dealNoImageIconCache(data.bundleName);
    // 标记应用安装完成，触发dh数据往HM应用恢复
    DisposedEventManager.getInstance().handleAppInstalled(event);
  }

  /**
   * 无图标应用更新安装完成时，清理图标缓存，通知systemui重新获取图标
   * @param bundleName
   * @param code
   */
  private dealNoImageIconCache(bundleName: string): void {
    let appItem: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(bundleName);
    if (CheckEmptyUtils.isEmpty(appItem)) {
      IconResourceManager.getInstance().deleteIconResource(bundleName, UpdateType.UPDATE);
    }
  }

  /**
   * 企业应用重置通知，企业应用安装失败后，重置图标状态
   *
   * @param data ag发送的重置通知
   */
  protected code518(data: AppGalleryData): void {
    this.deleteDownloadProgressInfo(data.bundleName);
    CacheManager.getInstance().resetCompanyApp(data, AppStatus.PENDING);
  }

  /**
   * appStatus变化执行操作
   * @param data
   * @param statusCode
   * @param bundleName
   */
  protected dealWithDownloadStatusChangeEvent(data: AppGalleryData, newAppStatus: AppStatus,
    isUpdating: boolean = false): void {
    log.showInfo('dealWithDownloadStatusChangeEvent %{public}s newAppStatus:%{public}d, isUpdating: %{public}s ',
      data.bundleName, newAppStatus, isUpdating);
    let eventInfo: AppGalleryEventInfo = data as AppGalleryEventInfo;
    eventInfo.status = newAppStatus;
    this.updateAppStatus(eventInfo, isUpdating);
    if (newAppStatus !== AppStatus.PENDING) {
      this.updateAppGalleryDataStatus(data, newAppStatus);
    }
  }

  protected updateAppStatus(eventInfo: AppGalleryEventInfo, isUpdating: boolean = false): void {
    let cacheManager: CacheManager = CacheManager.getInstance();
    let app = cacheManager.getAppFromCache(eventInfo.bundleName);
    if (!app) {
      log.showWarn('can not find app[%{public}s] return', eventInfo.bundleName);
      return;
    }
    cacheManager.updateAppStatus(app, eventInfo);
    InstallEventManager.notifyAppStatusChangeEvent(eventInfo, InstallUtils.getFolderId(app), isUpdating);
  }

  /**
   * 更新下载进度EVENT_DOWNLOAD_STATUS_CHANGE事件
   * @param event
   */
  public dealWithDownloadProgressChange(eventData: AppDownloadInfo): void {
    if (eventData.totalSize <= 0) {
      return;
    }
    let bundleName: string = eventData.bundleName;
    let downloadedSize: number = eventData.downloadedSize ?? 0;
    let totalSize: number = eventData.totalSize;
    let progress: number = downloadedSize / totalSize;
    log.showInfo('dealWithDownloadProgressChange installer:%{public}d, bundleName:%{public}s, progress:%{public}d',
      this.getInstallType(), bundleName, progress);
    let downloadInfo: DownloadInfoItem = {
      bundleName: bundleName,
      downloadProgress: progress
    };
    let status = this.getInstallType() === InstallType.ENTERPRISE_UPDATER ? AppStatus.UPDATING : AppStatus.DOWNLOADING;
    let cacheManager: CacheManager = CacheManager.getInstance();
    let findApp = cacheManager.getAppFromCache(bundleName);
    if (!findApp) {
      log.showWarn('updateDownloadProgress can not find app[%{public}s]', bundleName);
      return;
    }

    cacheManager.updateDownloadProgress(findApp, progress, status);
    let appGalleryEventInfo: AppGalleryEventInfo = eventData as AppGalleryEventInfo;
    appGalleryEventInfo.status = status;
    InstallEventManager.notifyProgressChangeEvent(appGalleryEventInfo, InstallUtils.getFolderId(findApp));
    this.updateAppGalleryDataProgress(downloadInfo, totalSize, downloadedSize, status);
  }

  private updateAppGalleryDataProgress(downloadInfo: DownloadInfoItem, total: number, downloadedSize: number,
    newAppStatus: AppStatus): void {
    let appGalleryData: AppGalleryData | undefined = this.appGalleryDataMap.get(downloadInfo.bundleName);
    if (!appGalleryData) {
      appGalleryData = this.initAppGalleryData(downloadInfo, newAppStatus);
    }
    appGalleryData.downloadedSize = downloadedSize;
    appGalleryData.totalSize = total;
    appGalleryData.moduleName = downloadInfo.moduleName;
    appGalleryData.status = newAppStatus;
  }

  private updateAppGalleryDataStatus(downloadInfo: DownloadInfoItem, newAppStatus: AppStatus): void {
    let appGalleryData: AppGalleryData | undefined = this.appGalleryDataMap.get(downloadInfo.bundleName);
    if (!appGalleryData) {
     appGalleryData = this.initAppGalleryData(downloadInfo, newAppStatus);
    }
    appGalleryData.status = newAppStatus as number;
  }

  private initAppGalleryData(downloadInfo: DownloadInfoItem, newAppStatus: AppStatus): AppGalleryData {
    let appGalleryData: AppGalleryData = {
      bundleName: downloadInfo.bundleName,
      moduleName: '',
      status: newAppStatus
    };
    this.appGalleryDataMap.set(downloadInfo.bundleName, appGalleryData);
    log.showWarn('initAppGalleryData task not create %{public}s', downloadInfo.bundleName);
    return appGalleryData;
  }

  protected addDownloadTaskInfo(data: AppGalleryData): void {
    this.appGalleryDataMap.set(data.bundleName, data);
  }

  /**
   * 应用市场事件发送完毕后删除本地缓存
   * @param bundleName
   */
  public deleteDownloadProgressInfo(bundleName: string): void {
    this.appGalleryDataMap.delete(bundleName);
    this.installDataManager.removeTask(bundleName);
  }

  protected removeApp(bundleName: string): void {
    let cacheManager: CacheManager = CacheManager.getInstance();
    let appList: GridLayoutItemInfo[] = cacheManager.getAllSameBundleNameAppItem(bundleName);
    appList.forEach(item => {
      log.showWarn(`remove item, bundleName:${item.bundleName}, appIndex:${item.appIndex}, status:${item.appStatus}`);
      if (item.appStatus !== AppStatus.INSTALLED) {
        cacheManager.removeItem(item.bundleName, item.appIndex);
      }
    });
  }
}