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

import dataPreferences from '@ohos.data.preferences';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'AiSuggestionDataPreference';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 配置项存贮工具类
 */
export class DataPreference {
  private readonly preferencesFileName: string;

  constructor(preferencesFileName: string) {
    if (!preferencesFileName) {
      throw new Error('preferencesFileName can not be null!');
    }
    this.preferencesFileName = preferencesFileName;
    log.showInfo('create DataPreference instance');
  }

  /**
   * 保存数据
   *
   * @param key key
   * @param value 值
   */
  save(key: string, value: dataPreferences.ValueType): Promise<void> {
    try {
      return dataPreferences.getPreferences(GlobalContext.getContext(), this.preferencesFileName)
        .then(preferences => {
          return preferences.put(key, value).then(() => preferences.flush());
        });
    } catch (err) {
      log.error('save preference failed, error message:', err);
      return Promise.reject();
    }
  }

  /**
   * 读取数据
   *
   * @param key key
   * @param defaultValue 默认值
   */
  get(key: string, defaultValue: dataPreferences.ValueType): Promise<dataPreferences.ValueType> {
    try {
      return dataPreferences.getPreferences(GlobalContext.getContext(), this.preferencesFileName)
        .then(preferences => preferences.get(key, defaultValue));
    } catch (err) {
      log.error('save preference failed, error message:', err);
      return Promise.reject();
    }
  }

  /**
   * 删除指定键值对
   *
   * @param key key
   * @returns true：存在
   */
  delete(key: string): Promise<void> {
    try {
      return dataPreferences.getPreferences(GlobalContext.getContext(), this.preferencesFileName)
        .then(preferences => {
          return preferences.delete(key).then(() => preferences.flush());
        });
    } catch (err) {
      log.error('save preference failed, error message:', err);
      return Promise.reject();
    }
  }
}


