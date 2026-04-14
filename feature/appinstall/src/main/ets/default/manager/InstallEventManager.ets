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

import { AppGalleryEventInfo, AppStatus } from '@ohos/launchercommon/src/main/ets/TsIndex';
import type ctx from '@ohos.app.ability.common';
import {
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  GlobalContext,
  InstallStatusChangeEvent
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AppInstallEventKey, AppInstallEventType } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallEventKey';

const TAG = 'appInstall_InstallEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 应用下载事件类
 */
export class InstallEventManager {
  /**
   * 通知AppStatus变化事件
   * @param data 事件data
   * @param folderId 如果应用在文件夹中，folderId为文件夹的folderId
   * @param isUpdate 是否是应用更新事件
   */
  public static notifyAppStatusChangeEvent(data: AppGalleryEventInfo, folderId: string,
    isUpdate: boolean = false): void {
    data.eventType = DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE;
    InstallEventManager.notifyEvent(folderId, data, isUpdate);
  }

  /**
   * 通知安装事件
   * @param data 事件data
   * @param folderId 如果应用在文件夹中，folderId为文件夹的folderId
   * @param isUpdate 是否是应用更新事件
   */
  public static notifyInstallStatusChangeEvent(bundleName: string, folderId: string, isUpdate: boolean = false): void {
    let data: AppGalleryEventInfo = {
      bundleName: bundleName,
      status: AppStatus.INSTALLED,
      eventType: InstallStatusChangeEvent.INSTALL_STATUS_CHANGE
    };
    InstallEventManager.notifyEvent(folderId, data, isUpdate);
  }

  /**
   * 通知下载进度变化事件
   * @param data 事件data
   * @param folderId 如果应用在文件夹中，folderId为文件夹的folderId
   */
  public static notifyProgressChangeEvent(data: AppGalleryEventInfo, folderId: string): void {
    data.eventType = DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE;
    InstallEventManager.notifyEvent(folderId, data);
  }

  private static notifyEvent(folderId: string, data: AppGalleryEventInfo, isUpdate: boolean = false): void {
    const eventHub: ctx.EventHub =
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.eventHub;
    if (!eventHub) {
      return;
    }
    let bundleName = data.bundleName;
    log.showInfo('notify event, folderId:%{public}s, isUpdate:%{public}s, data:%{public}s',
      folderId, isUpdate, JSON.stringify(data));
    if (folderId) {
      eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.FOLDER), data);
      eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.SMALL_FOLDER), data);
    }
    // 只有企业应用更新会走到这里
    if (isUpdate) {
      eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.UPDATE_NAME), data);
      eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.UPDATE_ICON), data);
      if (folderId) {
        eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(folderId, AppInstallEventType.UPDATE_FOLDER));
      }
    } else {
      eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.ICON), data);
      eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.NAME), data);
      // 如果是安装完成，更新应用名称
      if (data.status === AppStatus.INSTALLED) {
        eventHub.emit(AppInstallEventKey.getStatusChangeEventKey(bundleName, AppInstallEventType.UPDATE_NAME), data);
      }
    }
  }
}