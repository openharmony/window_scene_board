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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  AppGalleryEventInfo,
  AppStatus,
  CommonConstants,
  GridLayoutItemInfo,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { InstallType } from '../constants/AppInstallConstants';
import { AppGalleryData } from '../data/AppGalleryData';
import { InstallEventManager } from '../manager/InstallEventManager';
import { InstallUtils } from '../utils/InstallUtils';
import { BaseAppInstaller } from './BaseAppInstaller';
import { AppInstallingDataManager } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallingDataManager';
import { CommonEvent } from '@ohos/frameworkwrapper';
import { CacheManager } from '../manager/CacheManager';

const TAG = 'appInstall_EnterpriseAppUpdater';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 企业应用更新类
 */
export class EnterpriseAppUpdater extends BaseAppInstaller {
  constructor() {
    super();
    this.type = InstallType.ENTERPRISE_UPDATER;
  }

  protected code501(appGalleryData: AppGalleryData, bundleName: string, event: CommonEvent): void {
    log.showInfo('code501 bundleName: %{public}s', appGalleryData.bundleName);
    let eventData: AppGalleryEventInfo = appGalleryData as AppGalleryEventInfo;
    // 加入任务列表
    appGalleryData.status = AppStatus.UPDATING;
    appGalleryData.startTime = Date.now();
    this.addDownloadTaskInfo(appGalleryData);

    this.updateAppStatus(eventData, true);
    // 清除正在安装应用的缓存
    AppInstallingDataManager.getInstance().removeInstallingData(eventData.bundleName);
  }

  protected code503(eventData: AppGalleryData): void {
    log.showInfo('code503 bundleName: %{public}s', eventData.bundleName);
    this.dealWithDownloadStatusChangeEvent(eventData, AppStatus.PAUSING);
  }

  protected code504(eventData: AppGalleryData): void {
    this.dealWithDownloadStatusChangeEvent(eventData, AppStatus.UPDATING);
  }

  protected code505(eventData: AppGalleryData): void {
    log.showInfo('code505 bundleName: %{public}s', eventData.bundleName);
    this.dealWithDownloadStatusChangeEvent(eventData, AppStatus.PAUSING);
  }

  protected code506(data: AppGalleryData): void {
    log.showInfo('code506 bundleName: %{public}s', data.bundleName);
    this.dealWithDownloadStatusChangeEvent(data, AppStatus.INSTALLED);
  }

  protected code508(data: AppGalleryData): void {
    let bundleName = data.bundleName;
    log.showInfo('code508 bundleName: %{public}s', bundleName);
    let cacheManager: CacheManager = CacheManager.getInstance();
    let findApp = cacheManager.getAppFromCache(bundleName);
    if (!findApp) {
      log.showWarn('cancelAppUpdate can not find app[%{public}s] return', bundleName);
      return;
    }

    this.deleteDownloadProgressInfo(bundleName);
    cacheManager.cancelAppUpdate(findApp);
    InstallEventManager.notifyInstallStatusChangeEvent(bundleName, InstallUtils.getFolderId(findApp));
  }

  /**
   * 开始安装
   * @param bundleName
   */
  protected code510(bundleName: string): void {
    super.code510(bundleName);
    AppInstallingDataManager.getInstance().addInstallingData(bundleName);
  }

  /**
   * 开始失败
   * @param bundleName
   */
  protected code511(data: AppGalleryData, bundleName: string): void {
    log.showInfo('code511 bundleName: %{public}s', bundleName);
    this.dealWithDownloadStatusChangeEvent(data, AppStatus.INSTALLED);
    AppInstallingDataManager.getInstance().removeInstallingData(bundleName);
  }

  /**
   * 安装完成
   * @param bundleName
   */
  protected code512(data: AppGalleryData, event: CommonEvent): void {
    super.code512(data, event);
    AppInstallingDataManager.getInstance().removeInstallingData(data.bundleName);
  }
}