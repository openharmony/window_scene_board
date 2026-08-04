/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
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
