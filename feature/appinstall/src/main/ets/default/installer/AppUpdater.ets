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

import { BaseAppInstaller } from './BaseAppInstaller';
import { AppGalleryEventStatus, InstallType } from '../constants/AppInstallConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AppDownloadInfo, AppGalleryData } from '../data/AppGalleryData';
import { AppInstallingDataManager } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallingDataManager';
import { DisposedEventManager } from '@ohos/launchercommon';

const TAG = 'appInstall_AppUpdater';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 普通应用更新类
 */
export class AppUpdater extends BaseAppInstaller {
  constructor() {
    super();
    this.type = InstallType.UPDATER;
  }

  public dealWithDownloadStatusChange(event: CommonEvent): void {
    if (!event) {
      log.showWarn('dealWithDownloadStatusChange data is undefined');
      return;
    }
    log.showInfo('downloadStatusChange');
    let eventCode: number | undefined = event.code;
    if (eventCode === AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT) {
      let eventData: AppGalleryData = event.parameters as AppGalleryData;
      // 清除正在安装应用的缓存
      AppInstallingDataManager.getInstance().removeInstallingData(eventData.bundleName);
    }
  }

  /**
   * 开始安装
   * @param bundleName
   */
  protected code510(bundleName: string): void {
    AppInstallingDataManager.getInstance().addInstallingData(bundleName);
  }

  /**
   * 开始失败
   * @param bundleName
   */
  protected code511(eventData: AppGalleryData, bundleName: string): void {
    AppInstallingDataManager.getInstance().removeInstallingData(bundleName);
  }

  /**
   * 安装完成
   * @param bundleName
   */
  protected code512(data: AppGalleryData, event: CommonEvent): void {
    // 标记出湖应用安装完成，触发dh数据往HM应用恢复
    DisposedEventManager.getInstance().handleAppInstalled(event);
    AppInstallingDataManager.getInstance().removeInstallingData(data.bundleName);
  }

  public dealWithDownloadProgressChange(eventData: AppDownloadInfo): void {
    log.showDebug('dealWithDownloadProgressChange');
  }
}