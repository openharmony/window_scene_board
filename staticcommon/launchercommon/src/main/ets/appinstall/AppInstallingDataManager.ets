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

import { promptAction } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'appInstall_AppInstallingDataManager';
const TOAST_DURATION = 3000;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 安装中的应用清单
 * 目前为止改类只记录更新中的安装
 */
export class AppInstallingDataManager {
  private static mInstance: AppInstallingDataManager;
  private installingSet: Set<string> = new Set<string>();

  private constructor() {
  }

  public static getInstance(): AppInstallingDataManager {
    if (!AppInstallingDataManager.mInstance) {
      AppInstallingDataManager.mInstance = new AppInstallingDataManager();
    }
    return AppInstallingDataManager.mInstance;
  }

  /**
   * 应用正在安装时添加到缓存中
   * @param bundleName
   */
  public addInstallingData(bundleName: string): void {
    log.showInfo('addInstallingData bundleName: %{public}s', bundleName);
    this.installingSet.add(bundleName);
  }

  /**
   * 应用安装时移除缓存
   * @param bundleName
   */
  public removeInstallingData(bundleName: string): void {
    log.showInfo('removeInstallingData bundleName: %{public}s', bundleName);
    this.installingSet.delete(bundleName);
  }

  /**
   * 是否正在安装中
   * @param bundleName
   * @returns
   */
  public isInstalling(bundleName: string): boolean {
    return this.installingSet.has(bundleName);
  }

  /**
   * 应用安装中弹出toast框
   */
  public toastInstalling(bundleName: string): void {
    try {
      log.showInfo('toastInstalling bundleName: %{public}s', bundleName);
      promptAction.showToast({
        message: $r('app.string.wait_installing_toast'),
        duration: TOAST_DURATION,
        showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST,
      })
    } catch (error) {
      log.showError(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
  }
}