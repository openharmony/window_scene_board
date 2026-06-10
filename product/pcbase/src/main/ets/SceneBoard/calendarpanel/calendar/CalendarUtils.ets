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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'CalendarUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
// 班休数据写入settingData的domain名称
const SETTINGS_INFO: string = 'recessInfo'; // 新版班休数据
const SETTINGS_DATA: string = 'recessData'; // 旧版班休数据
// 一周开始日写入settingData的domain名称
const SETTING_DATA_START_OF_WEEK_DOMAIN: string = 'settingDataStartOfWeekDomain';
// 班休开关写入settingData的domain名称
const SETTING_DATA_RECESS_SWITCH_DOMAIN: string = 'settingDataRecessSwitchDomain';


export class CalendarUtils {
  public static isOldRecess: boolean = false; // 是否旧版班休数据

  /**
   * 获取班休数据
   * @returns 班休数据
   */
  public static async getRecessData(): Promise<string> {
    try {
      // 优先获取新版班休数据
      let data: string = await CalendarUtils.getNewRecessData();
      if (!data || data === '') {
        data = await CalendarUtils.getOldRecessData();
        CalendarUtils.isOldRecess = data && data !== '' ? true : false;
      }
      return data;
    } catch (err) {
      log.showError(`getRecessData err, code: ${err?.code}, message: ${err?.message}`);
      return '';
    }
  }

  /**
   * 获取新版班休数据
   * @returns 班休数据
   */
  private static async getNewRecessData(): Promise<string> {
    const context: Context = getContext();
    if (context === undefined) {
      return '';
    }
    try {
      let data = await settings.getValue(context, SETTINGS_INFO, settings.domainName.USER_PROPERTY);
      log.showInfo(`getNewRecessData settings getValue data:${data.length}`);
      return data;
    } catch (err) {
      log.showError(`getNewRecessData settings getValue err, code: ${err?.code}, message: ${err?.message}`);
      return '';
    }
  }

  /**
   * 获取旧版班休数据
   * @returns 班休数据
   */
  private static async getOldRecessData(): Promise<string> {
    const context: Context = getContext();
    if (context === undefined) {
      return '';
    }
    try {
      let data = await settings.getValue(context, SETTINGS_DATA, settings.domainName.USER_PROPERTY);
      log.showInfo(`getOldRecessData settings getValue data:${data.length}`);
      return data;
    } catch (err) {
      log.showError(`getOldRecessData settings getValue err, code: ${err?.code}, message: ${err?.message}`);
      return '';
    }
  }

  public static async getRecessSwitch(): Promise<string> {
    const context: Context = getContext();
    if (context === undefined) {
      return '';
    }
    try {
      let data = await settings.getValue(context, SETTING_DATA_RECESS_SWITCH_DOMAIN, settings.domainName.USER_PROPERTY);
      log.showInfo(`getRecessSwitch data:${data}`);
      return data;
    } catch (err) {
      log.showError(`getRecessSwitch settings getValue err, code: ${err?.code}, message: ${err?.message}`);
      return '';
    }
  }

  public static async getStartOfWeek(): Promise<undefined | number> {
    const context: Context = getContext();
    if (context === undefined) {
      return undefined;
    }
    try {
      let data =
        await settings.getValue(context, SETTING_DATA_START_OF_WEEK_DOMAIN, settings.domainName.USER_PROPERTY);
      let startOfWeek: number = Number(data);
      if (isNaN(startOfWeek)) {
        log.showInfo('getStartOfWeek data is null');
        return undefined;
      }
      return startOfWeek;
    } catch (err) {
      log.showError(`getStartOfWeek settings getValueSync err, code: ${err?.code}, message: ${err?.message}`);
      return undefined;
    }
  }
}
