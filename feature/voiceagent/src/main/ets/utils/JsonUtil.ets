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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';

const TAG: string = 'JsonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * json工具类
 *
 * @since 2023-07-17
 */
export class JsonUtil {
  private static readonly TAG = 'JsonUtil';

  private constructor() {
  }

  /**
   * 将对象转换成Json string
   *
   * @param obj 待转换的目标对象
   * @returns Json 字符串
   */
  public static parseObjToStr(obj: object): string {
    log.showInfo(`parseObjToStr`);
    let jsonStr: string = '';
    if (obj == null) {
      log.showError(`parseObjToStr::object is null`);
      return jsonStr;
    }
    try {
      jsonStr = JSON.stringify(obj);
    } catch (ex) {
      log.showDebug(`parseObjToStr exception: ${JSON.stringify(ex)}`);
    }
    return jsonStr;
  }

  public static replaceAll(str: string, searchValue: string | RegExp, newValue: string): string {
    return str.replace(searchValue, newValue);
  }

  /**
   * 判断obj是否是json数组
   *
   * @param obj 目标对象
   * @returns 结果
   */
  public static isArray(obj: object): boolean {
    return typeof obj === 'object' && Array.isArray(obj);
  }
}