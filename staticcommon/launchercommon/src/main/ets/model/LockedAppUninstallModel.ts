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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { FolderManager } from '../TsIndex';

const TAG = 'LockedAppUninstallModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 文件夹中加锁应用卸载工具类
 */
class LockedAppUninstallModel {
  private uninstallData: LockedAppUninstallData = new LockedAppUninstallData();

  /**
   * 设置加锁应用的回调，用于收到成功广播后回调处理
   * @param bundleName 应用bundleName
   * @param callback 回调方法
   */
  public setUninstallData(bundleName: string, callback: () => void): void {
    this.uninstallData.bundleName = bundleName;
    this.uninstallData.callback = callback;
  }

  /**
   * 重置卸载信息
   */
  public resetUninstallData(): void {
    this.uninstallData.bundleName = '';
    this.uninstallData.callback = (): void => {};
  }

  /**
   * 收到卸载成功广播后，拦截加锁应用的处理，待补位动效完成后
   * @param bundleName 卸载成功应用bundleName
   * @returns true：卸载完成后进行补位动效
   */
  public doLockedAppUninstalledAnim(bundleName: string): boolean {
    let doAnimationAfterAnim: boolean = false;
    if (this.isUninstallLockedApp(bundleName)) {
      const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
      if (isOpenFolder) {
        this.uninstallData.callback?.();
        doAnimationAfterAnim = true;
      } else {
        log.showError('skip animation for folder closed');
        doAnimationAfterAnim = false;
      }
      this.resetUninstallData();
    }
    return doAnimationAfterAnim;
  }

  /**
   * 判断是否正在卸载加锁应用
   * @param bundleName  应用bundleName
   * @returns true：加锁应用正在卸载
   */
  public isUninstallLockedApp(bundleName: string): boolean {
    return this.uninstallData.bundleName === bundleName;
  }
}

class LockedAppUninstallData {
  bundleName?: string;
  callback?: () => void;
}

export let lockedAppUninstallModel: LockedAppUninstallModel = SingletonHelper.getInstance(LockedAppUninstallModel, TAG);