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

import dataPreferences from '@ohos.data.preferences';
import type common from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG: string = 'PreferenceDao';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PreferenceDao {
  private static mInstance: PreferenceDao;
  private context: common.Context | common.ApplicationContext;
  private preferencesName: string;
  private preferencesPromise?: Promise<dataPreferences.Preferences>;

  constructor(storeName = 'EmergencyThermalPreference') {
    this.context = GlobalContext.getContext();
    this.preferencesName = storeName;
  }

  /**
   * preference dao instance
   *
   * @return PreferenceDao instance
   */
  static getInstance(): PreferenceDao {
    if (PreferenceDao.mInstance == null) {
      PreferenceDao.mInstance = new PreferenceDao();
    }
    return PreferenceDao.mInstance;
  }

  private getStore(): Promise<dataPreferences.Preferences> {
    if (!this.preferencesPromise) {
      try {
        this.preferencesPromise = dataPreferences.getPreferences(this.context, this.preferencesName)
          .catch((err: BusinessError) => {
            log.showError(`${TAG}, get preferences err ${err}`);
            return Promise.reject();
          });
      } catch (err) {
        log.showError(`${TAG}, get preferences error ${err}`);
        return Promise.reject();
      }
    }
    return this.preferencesPromise;
  }

  public async removeStoreCache(): Promise<void> {
    await dataPreferences.removePreferencesFromCache(this.context, this.preferencesName);
    this.preferencesPromise = undefined;
    await this.getStore();
  }

  public async put(key: string, value: dataPreferences.ValueType, isFlush: boolean = true): Promise<void> {
    try {
      this.getStore()
        .then((store: dataPreferences.Preferences) => {
          store.putSync(key, value);
        })
        .then(() => {
          if (isFlush) {
            this.flushData();
          }
        })
        .catch((err: BusinessError) => {
          log.showError(`${TAG}, ${this.put.name}, ${err.message}, ${key}`);
        });
    } catch (err) {
      log.showError(`${TAG}, ${this.put.name}, ${err}, ${key}`);
    }
  }

  public async get(key: string, defaultValue: dataPreferences.ValueType): Promise<dataPreferences.ValueType> {
    try {
      return this.getStore().then((store: dataPreferences.Preferences) => {
        return store.getSync(key, defaultValue);
      }).catch((err: BusinessError) => {
        log.showError(`${TAG}, ${this.get.name}, ${err.message}, ${key}`);
        return defaultValue;
      });
    } catch (err) {
      log.showError(`${TAG}, ${this.put.name}, ${err}, ${key}`);
      return defaultValue;
    }
  }

  public async delete(key: string, isFlush: boolean = true): Promise<void> {
    try {
      this.getStore()
        .then((store: dataPreferences.Preferences) => {
          store.deleteSync(key);
        })
        .then(() => {
          if (isFlush) {
            this.flushData();
          }
        })
        .catch((err: BusinessError) => {
          log.showError(`${TAG}, ${this.delete.name}, ${err.message}, ${key}`);
        });
    } catch (err) {
      log.showError(`${TAG}, ${this.delete.name}, ${err}, ${key}`);
    }
  }

  public async clear(isFlush: boolean = true): Promise<void> {
    try {
      this.getStore()
        .then((store: dataPreferences.Preferences) => {
          store.clearSync();
        })
        .then(() => {
          if (isFlush) {
            this.flushData();
          }
        })
        .catch((err: BusinessError) => {
          log.showError(`${TAG}, ${this.clear.name}, ${err.message}`);
        });
    } catch (err) {
      log.showError(`${TAG}, ${this.clear.name}, ${err}`);
    }
  }

  private async flushData(): Promise<void> {
    return this.getStore().then((store: dataPreferences.Preferences) => {
      return store.flush();
    }).catch((err: BusinessError) => {
      log.showError(`${TAG}, store flush error, ${err}`);
    });
  }

}