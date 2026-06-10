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

/**
 * 文本操作类
 *
 * @since 2023-11-13
 */
export class TextUtil {
  /**
   * 字符串是否为空
   *
   * @param str 字符串
   */
  public static isEmpty(str: string): boolean {
    return !(str && str !== '');
  }

  /**
   * 将字符串参数转换为boolean;
   *
   * @param str 字符串
   * @returns true/false
   */
  public static parseBoolean(str: string): boolean {
    let tmpStr: string = str.toLowerCase();
    return tmpStr === 'true';
  }
}