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

import data_preferences from '@ohos.data.preferences';
import type common from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import contextConstant from '@ohos.app.ability.contextConstant';
import { DesktopSettingConstants } from '../constants/CommonConstants';
import { lockLayoutManager } from '../manager/LockLayoutManager';

const TAG = 'DesktopSettingsPerefrence';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DesktopSettingsPerefrence {
  private context: common.Context | common.ApplicationContext;
  private storeName: string;
  private storePromise?: Promise<data_preferences.Preferences>;
  private lockLayoutStatus: boolean = false;

  constructor(context: common.Context | common.ApplicationContext, storeName = 'DesktopSetting') {
    this.context = context;
    this.storeName = storeName;
    this.get(DesktopSettingConstants.LOCK_LAYOUT_STATE, false).then((res) => {
      this.lockLayoutStatus = res as boolean;
      lockLayoutManager.setlockLayoutStatus(this.lockLayoutStatus);
      log.showWarn(`constructor created. lockLayoutStatus: ${res}, preferencesDir: ${this.context.preferencesDir}`);
    });
    this.subscribeChange(this.preferenceCallback);
  }

  /*
   * 获取锁定布局开关状态
   */
  public getlockLayoutStatus(): boolean {
    log.showInfo(`get lockLayoutStatus value is , ${this.lockLayoutStatus}`);
    return this.lockLayoutStatus;
  }

  private getStore(): Promise<data_preferences.Preferences> {
    if (!this.storePromise) {
      let oldArea = this.context.area;
      this.context.area = contextConstant.AreaMode.EL1;
      this.storePromise = data_preferences.getPreferences(this.context, this.storeName);
      this.storePromise.then((store: data_preferences.Preferences) => {
        this.context.area = oldArea;
      });
    }
    return this.storePromise;
  }

  public async removeStoreCache(): Promise<void> {
    await data_preferences.removePreferencesFromCache(this.context, this.storeName);
    this.unSubscribeChange(this.preferenceCallback);
    this.storePromise = undefined;
    await this.getStore();
    this.subscribeChange(this.preferenceCallback);
  }

  public async get(key: string, defaultValue: data_preferences.ValueType): Promise<data_preferences.ValueType> {
    try {
      return this.getStore().then((store: data_preferences.Preferences) => {
        return store.get(key, defaultValue);
      }).catch((err: BusinessError) => {
        log.showError(`$${this.get.name}, ${err.message}, ${key}`);
        return defaultValue;
      });
    } catch (err) {
      log.showError(`${this.get.name}, ${err}, ${key}`);
      return defaultValue;
    }
  }

  public preferenceCallback = async (key: string): Promise<void> => {
    try {
      await this.removeStoreCache();
      this.lockLayoutStatus = await this.get(DesktopSettingConstants.LOCK_LAYOUT_STATE, false) as boolean;
      lockLayoutManager.setlockLayoutStatus(this.lockLayoutStatus);
      log.showWarn(`preferenceCallback, ${this.lockLayoutStatus}`);
    } catch (err) {
      log.showError(`preference error:, ${(err as BusinessError).message}`);
    }
  };

  public async subscribeChange(func: (key: string) => void): Promise<void> {
    try {
      this.getStore().then((store: data_preferences.Preferences) => {
        log.showInfo(`subscribeChange success`);
        store.on('multiProcessChange', func);
      }).catch((err: BusinessError) => {
        log.showError(`subscribe error, ${err.message}`);
      });
    } catch (err) {
      log.showError(`subscribeChange error:, ${(err as BusinessError).message}`);
    }
  }

  public async unSubscribeChange(func: (key: string) => void): Promise<void> {
    try {
      this.getStore().then((store: data_preferences.Preferences) => {
        log.showInfo(`unSubscribeChange success`);
        store.off('multiProcessChange', func);
      }).catch((err: BusinessError) => {
        log.showError(`unSubscribe error, ${err.message}`);
      });
    } catch (err) {
      log.showError(`$unSubscribeChange error:, ${(err as BusinessError).message}`);
    }
  }
}