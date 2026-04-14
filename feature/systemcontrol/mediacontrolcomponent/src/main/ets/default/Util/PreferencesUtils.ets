/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { preferences } from '@kit.ArkData';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';

const TAG: string = 'PreferenceUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

let preferenceUtils: PreferenceUtils | undefined;

/**
 * 数据存储工具类
 */
export default class PreferenceUtils {
  public static WHETHER_TO_DISPLAY: string = 'whetherToDisplay';
  private PREFERENCE_NAME: string = 'AnimData';
  private dataPreferences: preferences.Preferences | null = null;

  /**
   * 创建单例对象
   *
   * @returns 单例对象
   */
  public static getInstance(): PreferenceUtils {
    if (!preferenceUtils) {
      preferenceUtils = new PreferenceUtils();
    }
    return preferenceUtils;
  }

  /**
   * 构造方法，创建preferences对象
   */
  private constructor() {
    try {
      let options: preferences.Options = { name: this.PREFERENCE_NAME };
      this.dataPreferences = preferences.getPreferencesSync(GlobalContext.getContext(), options);
      if (this.dataPreferences == null) {
        throw new Error('Failed to initialize dataPreferences');
      }
    } catch (error) {
      log.error(`get preferences fail, err=${JSON.stringify(error)}`);
      throw new Error('Failed to initialize PreferencesUtils');
    }
}

  /**
   * 存储数据至缓存
   *
   * @param key 数据名称
   * @param value 数据值
   */
  public putDataToPreference(key: string, value: preferences.ValueType) {
    this.dataPreferences?.putSync(key, value);
    this.flushPreference();
  }

  /**
   * 获取数据
   *
   * @param key 数据名称
   * @param defaultValue 默认值
   */
  public getDataFromPreference(key: string,
    defaultValue: preferences.ValueType): preferences.ValueType | undefined {
    return this.dataPreferences?.getSync(key, defaultValue);
  }

  /**
   * 持久化数据
   */
  public flushPreference() {
    this.dataPreferences?.flush((error: BusinessError) => {
      if (error) {
        log.showError(`Failed to flush. Code:${error.code}, message:${error.message}`);
        return;
      }
      log.showInfo('Succeeded in flushing.');
    })
  }
}