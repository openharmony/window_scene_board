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

export class StringUtil {
  /**
   * 格式化字符串，使用{0} ，{1} ...做占位符
   *
   * @param source 模板字符串
   * @param args 用于替换占位符的内容，args[0]替换模板字符串中的{0}
   *
   * @returns 格式化后的字符串
   */
  public static format(source: string, ...args: Array<string | number>): string {
    if (!source || args.length === 0) {
      return source;
    }
    let result: string = source;
    for (let i = 0; i < args.length; i++) {
      result = result.replace(`{${i}}`, args[i].toString());
    }
    return result;
  }

  /**
   * 字符串是否为空
   * @param src 目标字符串
   */
  public static isEmpty(str: string | String | undefined): boolean {
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
  public static join(prefix: string, strList: Array<string | String | undefined>): string {
    if (strList) {
      return strList.filter(str =>!StringUtil.isEmpty(str)).join(prefix);
    }
    return '';
  }
}