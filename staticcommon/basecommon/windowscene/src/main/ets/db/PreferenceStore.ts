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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { Context, contextConstant } from '@kit.AbilityKit';
import { ContextModifyUtils } from '@ohos/frameworkwrapper';

const TAG: string = 'LandscapeSettings_PreferenceStore: ';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, TAG);

/**
 * 首选项工具类
 */
export class PreferenceStore {
  private context: common.ApplicationContext; // 单应用级数据存储
  private storeName: string;
  private static instance: PreferenceStore | null;

  constructor(context: common.ApplicationContext, storeName = 'LandscapeSettings') {
    this.context = context;
    this.storeName = storeName;
    log.showInfo(`context dir: ${JSON.stringify(this.context)}`);
  }

  static getInstance(appContext: common.ApplicationContext): PreferenceStore {
    if (PreferenceStore.instance == null) {
      log.showInfo(`create instance success`);
      let applicationContext = GlobalContext.getContext()?.getApplicationContext();
      PreferenceStore.instance = new PreferenceStore(applicationContext ?? appContext);
    }
    return PreferenceStore.instance;
  }

  private getStoreSync(): data_preferences.Preferences {
    let options: data_preferences.Options = { name: this.storeName };
    let preferences: data_preferences.Preferences = {} as data_preferences.Preferences;
    let callback: Function = (callbackContext: Context) => {
      data_preferences.removePreferencesFromCacheSync(callbackContext, this.storeName);
      log.showInfo(`remove preferences ${this.storeName} from caches`);
      preferences = data_preferences.getPreferencesSync(callbackContext, options);
    };
    ContextModifyUtils.modifyTargetContext(this.context, contextConstant.AreaMode.EL2, callback, `${TAG}-getStoreSync`);
    return preferences;
  }

  public putSync(key: string, value: data_preferences.ValueType, isFlush: boolean = true): void {
    try {
      let store: data_preferences.Preferences = this.getStoreSync();
      store?.putSync(key, value);
      if (isFlush) {
        store.flush();
      }
    } catch (err) {
      log.showError(`${TAG}, ${err.message}, ${key}`);
    }
  }

  public getSync(key: string, defaultValue: data_preferences.ValueType): data_preferences.ValueType | undefined {
    try {
      let store: data_preferences.Preferences = this.getStoreSync();
      return store?.getSync(key, defaultValue);
    } catch (err) {
      log.showError(`${TAG}, ${err.message}, ${key}`);
      return defaultValue;
    }
  }

  /**
   * 清空持久化数据
   * @returns
   */
  public async clear(): Promise<void> {
    try {
      let store: data_preferences.Preferences = this.getStoreSync();
      store.clearSync();
      await store.flush();
      log.showInfo(`${TAG}, clear all app mode, success`);
    } catch (err) {
      log.showError(`${TAG}, clear fail, ${err.message}`);
    }
  }
}