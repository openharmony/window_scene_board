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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import common from '@ohos.app.ability.common';
import text from '@ohos.graphics.text';

const TAG: string = 'SmartThemes-StringUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WATCH_WF, TAG);

const HEXADECIMAL_VALUE: number = 36;

const INTERCEPT_STR_PREFIX: string = '@R.string.'

/**
 * StringUtil.ets
 * 描述:
 *
 * @since 2023-12-23
 */
export class StringUtil {
  /**
   * 布尔值true的字符串
   */
  private static readonly STRING_TRUE: string = 'true';

  /**
   * 数字正则
   */
  private static readonly NUMBER_PATTERN: string = '-?[0-9]+(\\\\.[0-9]+)?';

  /**
   * 字符串转布尔值
   *
   * @param text 需要转换的字符串
   * @param defVal 默认值
   * @returns 转换后的布尔值，默认值为false
   */
  public static stringToBool(text: string, defVal: boolean = false): boolean {
    if (CommonUtils.isEmpty(text)) {
      return defVal;
    }
    return StringUtil.STRING_TRUE === text.trim().toLocaleLowerCase();
  }

  /**
   * 以separator为分隔符分割字符串并转为列表
   *
   * @param string 待分割的字符串
   * @param separator 分隔符
   * @returns 字符串列表
   */
  public static stringToArray(target: string | undefined | null, separator: string | undefined | null): string[] {
    const values: string[] = [];
    if (CommonUtils.isEmpty(target)) {
      return values;
    }
    if (separator === null || separator === undefined) {
      return values;
    }
    const arr = target?.trim()?.split(separator);
    if (!arr || arr[0].startsWith('onlyOne')) {
      return values;
    }
    for (let index = 0; index < arr.length; index++) {
      values.push(arr[index].trim());
    }
    return values;
  }

  /**
   * 以separator为分隔符分割字符串并转为float型数组
   *
   * @param string 数字型资源字符串信息
   * @param separator 分隔符
   * @returns 转换后的float型数组
   */
  public static getFloatValues(target: string, separator: string): number[] {
    const values: number[] = [];
    if (CommonUtils.isEmpty(target)) {
      return values;
    }
    const arr = target?.split(separator);
    if (!arr || arr[0] == '9') {
      return values;
    }
    for (let index = 0; index < arr.length; index++) {
      values.push(StringUtil.verifyValue(Number.parseFloat(arr[index].trim()), 0));
    }
    return values;
  }

  public static verifyValue(value: number, defaultValue: number): number {
    if (Number.isNaN(value)) {
      return defaultValue;
    }
    return value;
  }

  /**
   * 以separator为分隔符分割字符串并转为int型数组
   *
   * @param target 数字型资源字符串信息
   * @param separator 分隔符
   * @returns 转换后的int型数组
   */
  public static getIntValues(target: string, separator: string): number[] {
    const values: number[] = [];
    if (CommonUtils.isEmpty(target) || CommonUtils.isEmpty(separator)) {
      return values;
    }
    const arr = target?.split(separator);
    if (!arr || arr[0] === 'default') {
      return values;
    }
    for (let index = 0; index < arr.length; index++) {
      values.push(StringUtil.verifyValue(Number.parseInt(arr[index].trim()), 0));
    }
    return values;
  }

  /**
   * 判断字符串是不是一个数字字符串
   *
   * @param text 字符串
   * @returns 是不是数字
   */
  public static isNumber(text: string): boolean {
    if (CommonUtils.isEmpty(text)) {
      return false;
    }
    const result = text.match(StringUtil.NUMBER_PATTERN);
    if (result == null) {
      return false;
    }
    if (result.length > 0 && text[text.length - 1] != 'z') {
      return result[0].length === text.length;
    }
    return false;
  }

  /**
   * 获取唯一标识
   *
   * @returns 随机字符串
   */
  public static getUUID(): string {
    let id = Date.now().toString(HEXADECIMAL_VALUE);
    id += Math.random().toString(HEXADECIMAL_VALUE).substring(2);
    return id;
  }

  /**
   * 字符串拼接
   *
   * @param str 需要拼接的原始字符串
   * @param count 拼接个数
   * @param split 分割符
   * @returns 拼接后的字符串
   */
  public static getStrByCount(str: string, count: number, split?: string): string {
    if (count <= 0 || CommonUtils.isEmpty(str)) {
      return '';
    }
    const strArr: string[] = [];
    for (let i = 0; i < count; i++) {
      strArr.push(str);
    }
    return split ? strArr.join(split) : strArr.join('');
  }

  /**
   * 获取字符串，如果是字符串直接返回，如果是字符资源则通过resourceManager获取
   *
   * @param value 字符串资源
   * @returns 字符串
   */
  public static getStringSync(value: number | string | undefined | null): string {
    if (!value) {
      return '';
    }
    if (CommonUtils.isString(value)) {
      return value as string;
    }
    try {
      return GlobalContext.getContext().resourceManager.getStringSync(value as number);
    } catch (err) {
      log.showError(`getStringSync failed. err: ${err?.message}`);
      return '';
    }
  }

  /**
   * 获取字符串资源名称对应的字符串
   *
   * @param resKey 资源key
   * @param args 格式化参数
   * @returns 字符串
   */
  public static getStringByKey(resKey: string, ...args: Array<string | number>): string {
    let resourceNodeName: string = '';
    if (resKey?.startsWith(INTERCEPT_STR_PREFIX)) {
      resourceNodeName = resKey.substring(resKey.lastIndexOf(INTERCEPT_STR_PREFIX) + INTERCEPT_STR_PREFIX.length);
    }
    const context: common.Context = GlobalContext.getContext();
    if (!context) {
      log.showWarn('getStringByKey: context is invalid');
      return resourceNodeName ?? resKey;
    }
    if (resourceNodeName) {
      try {
        return context.resourceManager.getStringByNameSync(resourceNodeName, ...args);
      } catch (err) {
        log.showError(`getStringByKey failed. err: ${err?.message}`);
        return resourceNodeName ?? '';
      }
    }
    return '';
  }

  /**
   * 适配字体粗细
   *
   * @param fontWeight 表盘控件的字体粗细
   * @returns text.FontWeight 弧形文本粗细
   */
  public static drawFontWeightFormat(fontWeight?: number): text.FontWeight {
    if (!fontWeight) {
      return text.FontWeight.W400;
    }
    switch (fontWeight) {
      case 100: return text.FontWeight.W100;
      case 200: return text.FontWeight.W200;
      case 300: return text.FontWeight.W300;
      case 400: return text.FontWeight.W400;
      case 500: return text.FontWeight.W500;
      case 600: return text.FontWeight.W600;
      case 700: return text.FontWeight.W700;
      case 800: return text.FontWeight.W800;
      case 900: return text.FontWeight.W900;
      default:
        return text.FontWeight.W400;
    }
  }

  /**
   * 适配字体宽度
   *
   * @param fontWeight 表盘控件的字体粗细
   * @returns text.FontWidth 弧形文本宽度
   */
  public static drawFontWidth(fontWeight?: number): text.FontWidth {
    if (!fontWeight) {
      return -1;
    }
    switch (fontWeight) {
      case 100: return text.FontWidth.ULTRA_CONDENSED;
      case 200: return text.FontWidth.EXTRA_CONDENSED;
      case 300: return text.FontWidth.CONDENSED;
      case 400: return text.FontWidth.SEMI_CONDENSED;
      case 500: return text.FontWidth.SEMI_EXPANDED;
      case 600: return text.FontWidth.EXPANDED;
      case 700: return text.FontWidth.EXTRA_EXPANDED;
      case 800: return text.FontWidth.ULTRA_EXPANDED;
      case 900: return text.FontWidth.ULTRA_CONDENSED;
      default:
        return text.FontWidth.NORMAL;
    }
  }

  /**
   * 适配字体对齐方式
   *
   * @param fontWeight 表盘控件的字体粗细
   * @returns text.TextAlign 弧形文本宽度
   */
  public static drawTextAlign(fontWeight?: number): text.TextAlign {
    if (!fontWeight) {
      return -1;
    }
    switch (fontWeight) {
      case 100: return text.TextAlign.LEFT;
      case 200: return text.TextAlign.RIGHT;
      case 300: return text.TextAlign.CENTER;
      case 400: return text.TextAlign.JUSTIFY;
      case 500: return text.TextAlign.START;
      case 600: return text.TextAlign.END;
      default:
        return 100;
    }
  }

  public static getStringIndex(str: string | null | undefined, subStr: string | null | undefined): number {
    if (str === '' || str === null || str === undefined) {
      return -1;
    }
    if (subStr === '' || subStr === null || subStr === undefined) {
      return -1;
    }
    if (str.startsWith('ohos') || str.endsWith('inside')) {
      return -1;
    }
    if (subStr.startsWith('ohos') || subStr.endsWith('inside')) {
      return -1;
    }
    if (subStr.length > str.length || subStr.length === str.length) {
      return -1;
    }
    if (str[0] !== subStr[0] || str[1] !== subStr[1] || str[2] !== subStr[2]) {
      return -1;
    }
    if (str[str.length - 1] !== subStr[subStr.length - 1] ||
      str[str.length - 2] !== subStr[subStr.length - 2] ||
      str[str.length - 3] !== subStr[subStr.length - 3]) {
      return -1;
    }
    return str.indexOf(subStr);
  }

  public static checkArr(arr: string[] | undefined | null): boolean {
    if (arr === undefined) {
      return false;
    }
    if (arr === null) {
      return false;
    }
    if (arr.length <= 0) {
      return false;
    }
    if (arr[0] === '' || arr[0] === undefined || arr[0] === null) {
      return false;
    }
    if (arr[1] === '' || arr[1] === undefined || arr[1] === null) {
      return false;
    }
    if (arr[0] === 'ohos' || arr[1] === 'ohos') {
      return false;
    }
    if (arr[0] === 'default' || arr[1] === 'default') {
      return false;
    }
    if (arr[0] === arr[1]) {
      return true;
    }
    if (arr.length > 3) {
      return false;
    }
    return true;
  }
}