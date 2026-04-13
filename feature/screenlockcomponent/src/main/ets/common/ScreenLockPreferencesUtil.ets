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

import dataPreferences from '@ohos.data.preferences';

import type { ValueType } from '@ohos.data.ValuesBucket';
import type { Context } from '@ohos.abilityAccessCtrl';
import { LogDomain, LogHelper, CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';

const TAG = 'ScreenLockPreferencesUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);


/**
 *  util class for put/get preference value
 *
 */
class ScreenLockPreferencesUtil {
  private static PREFERENCES_NAME = 'ScreenLock';
  private preference: dataPreferences.Preferences | null = null;

  async getPreferencesFromStorage(context: Context): Promise<void> {
    try {
      this.preference = await dataPreferences.getPreferences(context, ScreenLockPreferencesUtil.PREFERENCES_NAME);
    } catch (err) {
      log.showError(`Failed to get preferences, Cause: ${err}`);
    }
  }

  /**
   * Save the data to the Preferences.
   * @param{ context } context
   * @param { string } key - Indicates the key of the preferences to modify. It cannot be {@code null} or empty.
   * @param { ValueType } value - Indicates the value of the preferences.
   */
  async put(context: Context, key: string, value: dataPreferences.ValueType): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(key) || CommonUtils.isInvalid(value)) {
      log.showError('Failed to put value,key is null.');
      return;
    }
    if (!this.preference) {
      await this.getPreferencesFromStorage(context);
    }
    try {
      await this.preference?.put(key, value);
    } catch (err) {
      log.error(`Failed to put value, Cause: ${err}`);
    }
    // Store the Preference instance in the preference persistence file
    await this.preference?.flush();
  }

  /**
   * Get preference data.
   * @param{ context } context
   * @param { string } key - Indicates the key of the preferences. It cannot be {@code null} or empty.
   * @param { ValueType } defValue - Indicates the default value to return.
   */
  async get(context: Context, key: string, defValue: ValueType): Promise<dataPreferences.ValueType> {
    if (CheckEmptyUtils.checkStrIsEmpty(key)) {
      log.showError('Failed to put value,key is null.');
      return defValue;
    }
    if (!this.preference) {
      await this.getPreferencesFromStorage(context);
    }
    try {
      let result = await this.preference?.get(key, defValue) ?? defValue;
      return result;
    } catch (err) {
      log.showError(`Failed to get value, Cause: ${err}`);
    }
    return defValue;
  }
}

export default new ScreenLockPreferencesUtil();