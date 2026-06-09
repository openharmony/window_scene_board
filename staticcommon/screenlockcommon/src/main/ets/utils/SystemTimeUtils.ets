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

import systemDateTime from '@ohos.systemDateTime';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SystemTimeUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 系统时间工具类.
 */
export class SystemTimeUtils {
  private constructor() {
  }

  /**
   * 返回设备自启动后的时间，包括睡觉时间，单位ms
   *
   * @param isNanoseconds 是否使用纳米时间
   * @returns 时间
   */
  public static getStartUpTime(isNanoseconds?: boolean): number {
    try {
      return systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, isNanoseconds);
    } catch (error) {
      log.showError(`getStartUpTime failed. code ${error.code}`);
    }
    return 0;
  }
}