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
import { sSettingsUtil } from '@ohos/frameworkwrapper';

const KEY_OWNER_INFO_SWITCH: string = 'lock_screen_owner_info_enabled';
const KEY_OWNER_INFO: string = 'lock_screen_owner_info';
const TAG = 'SettingDbUtils';
const GREET_FLAG: string = 'intelligent.scene.greet';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class SettingDbUtils {

  public static getSignatureText(): string {
    return SettingDbUtils.getValFromDbWithCatch(KEY_OWNER_INFO);
  }

  public static getSignatureVisible(): string {
    return SettingDbUtils.getValFromDbWithCatch(KEY_OWNER_INFO_SWITCH);
  }

  public static setSignatureText(val: string): Promise<void> {
    return SettingDbUtils.setValToDbWithCatchAsync(KEY_OWNER_INFO, val);
  }

  public static setSignatureVisible(val: boolean): Promise<void> {
    return SettingDbUtils.setValToDbWithCatchAsync(KEY_OWNER_INFO_SWITCH, '' + val);
  }

  /**
   *
   * @returns ‘0’：不显示  ‘1’：显示
   */
  public static getSlGreetFlagText(): string {
    return SettingDbUtils.getValFromDbWithCatch(GREET_FLAG);
  }

  /**
   *
   * @param val  ‘0’：不显示  ‘1’：显示
   * @returns
   */
  public static setSlGreetFlagText(val: string): Promise<void> {
    return SettingDbUtils.setValToDbWithCatchAsync(GREET_FLAG, val);
  }

  public static getValFromDbWithCatch(dbKey: string): string {
    let res: string = '';
    try {
      res = sSettingsUtil.getSecureValue(dbKey);
      log.showInfo(`get from db succeed, dbKey = ${dbKey}`);
    } catch (error) {
      log.showError(`get from db error, dbKey = ${dbKey}`);
    }
    return res;
  }

  public static setValToDbWithCatch(dbKey: string, val: string): void {
    try {
      sSettingsUtil.setSecureValue(dbKey, val);
    } catch (error) {
      log.showError('set db error');
    }
  }

  public static setNormalValToDbWithCatch(dbKey: string, val: string): void {
    try {
      sSettingsUtil.setValue(dbKey, val);
    } catch (error) {
      log.showError('set db error');
    }
  }

  public static setValToDbWithCatchAsync(dbKey: string, val: string): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        // 调用同步的setSecureValue方法
        log.showInfo(`set to db succeed, dbKey = ${dbKey}`);
        sSettingsUtil.setSecureValue(dbKey, '' + val);
        // 同步操作成功，立即解决Promise
        resolve();
      } catch (error) {
        // 如果setSecureValue抛出异常，拒绝Promise
        log.showError('set to db error');
        reject(error);
      }
    });
  }
}