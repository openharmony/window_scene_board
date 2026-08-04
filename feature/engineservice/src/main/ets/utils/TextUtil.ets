/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2025. All rights reserved.
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