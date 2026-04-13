/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

const LOGGER: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, 'PreferenceStore');

export class PreferenceStore {
  private context: common.Context | common.ApplicationContext;
  private storeName: string;
  private storePromise?: Promise<data_preferences.Preferences>;

  constructor(context: common.Context | common.ApplicationContext, storeName = 'DesktopSetting') {
    this.context = context;
    this.storeName = storeName;
    this.subscribeChange('multiProcessChange', this.preferenceCallback);
  }

  private async getStore(): Promise<data_preferences.Preferences | undefined>{
    if (!this.storePromise) {
      try {
        let oldArea = this.context.area;
        this.context.area = contextConstant.AreaMode.EL1;
        this.storePromise = data_preferences.getPreferences(this.context, this.storeName);
        this.storePromise.then((store: data_preferences.Preferences) => {
          this.context.area = oldArea;
        });
      } catch (e) {
        LOGGER.showError(`getPreferences error: ${e.message}`);
      }
    }
    return this.storePromise;
  }

  public async removeStoreCache(): Promise<void> {
    await data_preferences.removePreferencesFromCache(this.context, this.storeName);
    this.unSubscribeChange('multiProcessChange', this.preferenceCallback);
    this.storePromise = undefined;
    await this.getStore();
    this.subscribeChange('multiProcessChange', this.preferenceCallback);
  }

  public async put(key: string, value: data_preferences.ValueType, isFlush: boolean = true): Promise<void> {
    try {
      this.getStore()
        .then((store: data_preferences.Preferences | undefined) => {
          store?.put(key, value);
        })
        .then(() => {
          if (isFlush) {
            this.flushData();
          }
        })
        .catch((err: BusinessError) => {
          LOGGER.showError(`${this.put.name}, ${err.message}, ${key}`);
        });
    } catch (err) {
      LOGGER.showError(`${this.put.name}, ${err}, ${key}`);
    }
  }

  public async get(key: string, defaultValue: data_preferences.ValueType): Promise<data_preferences.ValueType> {
    try {
      return this.getStore().then((store: data_preferences.Preferences | undefined) => {
        return store?.get(key, defaultValue) ?? defaultValue;
      }).catch((err: BusinessError) => {
        LOGGER.showError(`$${this.get.name}, ${err.message}, ${key}`);
        return defaultValue;
      });
    } catch (err) {
      LOGGER.showError(`${this.put.name}, ${err}, ${key}`);
      return defaultValue;
    }

  }

  private async flushData(): Promise<void> {
    return this.getStore().then((store: data_preferences.Preferences | undefined) => {
      return store?.flush();
    }).catch((err: BusinessError) => {
      LOGGER.showError(`store flush error, ${err}`);
    });
  }

  public preferenceCallback = async (key: string): Promise<void> => {
    try {
      await this.removeStoreCache();
    } catch (err) {
      LOGGER.showError(`preference error:, ${(err as BusinessError).message}`);
    }
  };

  public async subscribeChange(type: string, func: (key: string) => void): Promise<void> {
    try {
      this.getStore().then((store: data_preferences.Preferences | undefined) => {
        LOGGER.showInfo(`subscribeChange success`);
        if (type === 'change') {
          store?.on('change', func);
        } else {
          store?.on('multiProcessChange', func);
        }
      }).catch((err: BusinessError) => {
        LOGGER.showError(`subscribe error, ${err.message}`);
      });
    } catch (err) {
      LOGGER.showError(`subscribeChange error:, ${(err as BusinessError).message}`);
    }

  }

  public async unSubscribeChange(type: string, func: (key: string) => void): Promise<void> {
    try {
      this.getStore().then((store: data_preferences.Preferences | undefined) => {
        if (type === 'change') {
          store?.off('change', func);
        } else {
          store?.off('multiProcessChange', func);
        }
      }).catch((err: BusinessError) => {
        LOGGER.showError(`unSubscribe error, ${err.message}`);
      });
    } catch (err) {
      LOGGER.showError(`$unSubscribeChange error:, ${(err as BusinessError).message}`);
    }

  }
}