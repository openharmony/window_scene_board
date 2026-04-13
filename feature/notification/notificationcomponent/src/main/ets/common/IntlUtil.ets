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

import Intl from '@ohos.intl';

export class IntlUtil {
  /**
   * @description 格式化百分数，由于各语言百分数不一致，需要使用全球化接口格式化百分数
   * @param number 百分数，阿拉伯数字
   * @param maxDigits 百分数的最大小数位数，默认为3
   * @param minDigits 百分数的最小小数位数，默认为0
   * @returns string 返回格式化后的百分数字符串
   */
  public static formatPercentage(number: number, maxDigits?: number, minDigits?: number): string {
    let locale = new Intl.Locale();
    let numberFormat = new Intl.NumberFormat(locale.baseName, {
      style: 'percent',
      maximumFractionDigits: maxDigits,
      minimumFractionDigits: minDigits
    });
    return numberFormat.format(number);
  }
}
