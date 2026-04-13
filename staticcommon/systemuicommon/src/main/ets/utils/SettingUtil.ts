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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Settings from '@ohos.settings';
import { Context } from '@kit.AbilityKit';

const TAG = 'SettingUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 获取设置数据工具类
 */
export class SettingUtil {
  /**
   * 从settingsdata中获取值
   * @param context 表示Context实例
   * @param name 字符串的名称
   * @param defValue 指定字符串的默认值
   * @param domainName 要设置的域名名称
   * @returns
   */
  public static getValueSyncByContext(context: Context, name: string, defValue: string, domainName?: string): string {
    let value: string = null;
    try {
      if (domainName) {
        value = Settings.getValueSync(context, name, defValue, domainName);
      } else {
        value = Settings.getValueSync(context, name, defValue);
      }
    } catch (e) {
      log.error(`getValueSyncByContext for ${name} error:`, e);
      return defValue;
    }
    return value;
  }
}