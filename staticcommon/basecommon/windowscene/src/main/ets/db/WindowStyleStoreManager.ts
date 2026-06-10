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

import distributedKVStore from '@ohos.data.distributedKVStore';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SingletonHelper } from '@ohos/basicutils';
import { contextConstant } from '@kit.AbilityKit';
import { ContextModifyUtils } from '@ohos/frameworkwrapper';

const TAG = 'WindowStyleStoreManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class WindowStyleStoreManager {

  KVStore : distributedKVStore.SingleKVStore;
  initStatus : boolean = false;

  /**
   * Create WindowStyleStore
   */
  private async initWindowStyleStore(context): Promise<void> {
    let callback: Function = async (callbackContext) => {
      try {
        const kvManagerConfig: distributedKVStore.KVManagerConfig = {
          context: callbackContext,
          bundleName: 'com.ohos.sceneboard'
        };
        const manager = distributedKVStore.createKVManager(kvManagerConfig);

        // Create KVStore
        const options: distributedKVStore.Options = {
          createIfMissing: true,
          encrypt: false,
          backup: false,
          autoSync: false,
          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
          securityLevel: distributedKVStore.SecurityLevel.S1
        };
        this.KVStore = await manager.getKVStore<distributedKVStore.SingleKVStore>('windowStyle', options);
        this.initStatus = true;
      } catch (error) {
        log.showError(`Failed to WindowStyleKVStoreManager, error: ${error}`);
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(context, contextConstant.AreaMode.EL1, callback,
      `${TAG}-initWindowStyleStore`);
  }

  /**
   * set data
   * @param key
   * @param value 
   * @param context 
   */
  public async setWindowStyleStore(key: string, value: Uint8Array | string | number | boolean, context) : Promise<void> {
    if (!this.KVStore) {
      await this.initWindowStyleStore(context);
    }
    log.showInfo(`set windowStyle data :${value}`);
    try {
      await this.KVStore?.put(key, value);
    } catch (error) {
      log.showError(`Failed to set windowStyle, error: ${error}`);
    }
  }

  /**
   * get data
   * @param key 
   * @param context 
   * @returns 
   */
   public async getWindowStyleStore(key: string, context): Promise<string | number | boolean | Uint8Array | null | undefined> {
    if (!this.KVStore) {
      await this.initWindowStyleStore(context);
    }
    let value: Uint8Array | string | number | boolean | null | undefined = null;
    try {
      value = await this.KVStore?.get(key);
    } catch (error) {
      log.showInfo(`Failed to get windowStyle, error: ${error}`);
    }
    log.showInfo(`get windowStyle value :${value}`);
    return value;
  }

  /**
   * get initStatus
   * @returns 
   */
  public getInitStatus(): boolean {
    return this.initStatus;
  }
}

let sWindowStyleStoreManager = SingletonHelper.getInstance(WindowStyleStoreManager, TAG);

export default sWindowStyleStoreManager as WindowStyleStoreManager;