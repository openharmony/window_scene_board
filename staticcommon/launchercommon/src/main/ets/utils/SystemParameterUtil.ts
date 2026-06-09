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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import systemParameter from '@ohos.systemparameter';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'SystemParameterUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * 系统参数工具类
 */
export class SystemParameterUtil {
  /**
   * 最新版api获取系统参数,支持最新的设备系统参数获取
   */
  public static getSync(key: string, def?: string): string {
    let value: string = '';
    try {
      value = systemParameterEnhance.getSync(key, def);
    } catch (err) {
      log.showError(`systemParameterEnhance getSync error: ${err?.code}, ${err?.message}`);
      // 如果系统不支持最新的api,用旧版本api做兜底
      return SystemParameterUtil.getSyncOld(key, def);
    }
    return value;
  }

  /**
   * 旧版本api获取系统参数,此api不再维护
   */
  public static getSyncOld(key: string, def?: string): string {
    let value: string = '';
    try {
      value = systemParameter.getSync(key, def);
    } catch (err) {
      log.showError(`systemParameter getSync error: ${err?.code}, ${err?.message}`);
    }
    return value;
  }

  /**
   * 是否门店版本
   * @returns
   */
  public static isDemoVersion(): boolean {
    let isDemoVersion: boolean = false;
    try {
      isDemoVersion = SystemParameterUtil.getSync('const.dfx.enable_retail', 'false') === 'true';
      log.showInfo(`is demo pc start restore : ${isDemoVersion}`);
    } catch (error) {
      log.showInfo(`judge demo pc error ${error?.code}, ${error?.message}`);
    }
    return isDemoVersion;
  }
}

