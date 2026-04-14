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

import { HashMap } from '@kit.ArkTS';
import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'CloneStatusCallbackManager';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

/**
 *  settingData克隆状态监听
 */
export class CloneStatusCallbackManager {
  public readonly SETTING_DATA_DB_CLONE_FLAG: string = 'settingsCloneStatus';
  private cloneStatusCallbacks: HashMap<string, Function> = new HashMap();
  private static _instance: CloneStatusCallbackManager | null = null;

  public static getInstance(): CloneStatusCallbackManager {
    if (!CloneStatusCallbackManager._instance) {
      CloneStatusCallbackManager._instance = new CloneStatusCallbackManager();
    }
    return CloneStatusCallbackManager._instance;
  }

  public registerCloneStatusMonitor(): void {
    try {
      let result: boolean = settings.registerKeyObserver(GlobalContext.getContext(), this.SETTING_DATA_DB_CLONE_FLAG,
        settings.domainName.DEVICE_SHARED, () => {
          this.executeCloneStatusCallback();
        });

      log.showInfo(TAG, `registerCloneStatusMonitor result:${result}`);
    } catch (e) {
      log.showError(TAG, `registerCloneStatusMonitor error:${e}`);
    }
  }

  public unregisterCloneStatusMonitor(): void {
    try {
      let result: boolean = settings.unregisterKeyObserver(GlobalContext.getContext(), this.SETTING_DATA_DB_CLONE_FLAG,
        settings.domainName.DEVICE_SHARED);
      log.showInfo(TAG, `unregisterCloneStatusMonitor result:${result}`);
    } catch (e) {
      log.showError(TAG, `unregisterCloneStatusMonitor error:${e}`);
    }
  }


  /**
   * 注册克隆状态监听
   * @param tag 标识
   * @param callback 回调
   */
  public registerCloneStatusCallbacks(tag: string, callback: Function): boolean {
    if (!tag) {
      log.showError(TAG, `registercloneStatusCallbacks tag is null`);
      return false;
    }
    log.showInfo(TAG, `registercloneStatusCallbacks --- ${tag}`);
    if (!this.cloneStatusCallbacks.hasKey(tag)) {
      this.cloneStatusCallbacks.set(tag, callback);
      return true;
    }
    return false;
  }

  /**
   * 反注册克隆状态监听
   * @param tag 标识
   */
  public unRegisterCloneStatusCallbacks(tag: string): void {
    if (!tag) {
      log.showError(TAG, `unRegistercloneStatusCallbacks tag is null`);
      return;
    }
    if (this.cloneStatusCallbacks.get(tag)) {
      log.showInfo(TAG, `unRegistercloneStatusCallbacks --- ${tag}`);
      this.cloneStatusCallbacks.remove(tag);
    }
  }

  /**
   * 执行克隆状态回调
   */
  public executeCloneStatusCallback(): void {
    try {
      // 使用对象解析
      for (let myEntry of this.cloneStatusCallbacks) {
        let key = myEntry[0];
        let value = myEntry[1];
        log.showInfo(TAG, `executeCloneStatusCallback :${key}`);
        value?.();
      }
    } catch (e) {
      log.showError(TAG, `executeCloneStatusCallback error:${e}`);
    }
  }
}
