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

/**
 * 字符串工具类
 */
export namespace StringUtils {
  export const EMPTY: string = '';

  /**
   * 字符串是否为空
   * @param src 目标字符串
   */
  export function isEmpty(str: string | String | undefined): boolean {
    if (str === undefined || str === null) {
      return true;
    }
    if (typeof str === 'string' || str instanceof String) {
      return !str.trim();
    }
    return false;
  }

  /**
   * 拼接字符串 "a|b|c"
   * @param prefix 拼接字符
   * @param strList 字符串列表
   * @returns 结果值
   */
  export function join(prefix: string, strList: Array<string | String | undefined>): string {
    return strList.filter(str =>!isEmpty(str)).join(prefix);
  }

  /**
   * 两个字符串是否相等
   *
   * @param str1 string1
   * @param str2 string2
   */
  export function equals(str1: string | undefined, str2: string | undefined): boolean {
    if (str1 === undefined) {
      return str2 === undefined;
    } else if (str1 === null) {
      return str2 === null;
    } else {
      return str1.toString() === str2?.toString();
    }
  }
}
