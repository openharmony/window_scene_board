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

import text from '@ohos.graphics.text';
const HEXADECIMAL_VALUE: number = 36;

export class FormThemeDeleteManager {
  static equals(oriObj: string | null | undefined | number | number[] | Map<string, string>,
    other: string | null | undefined | number | number[] | Map<string, string>): boolean {
    if (oriObj === undefined || oriObj === null) {
      return false;
    }
    if (other === undefined || other === null) {
      return false;
    }
    if (typeof oriObj === 'string' && !(typeof other === 'string')) {
      return false;
    }
    if (typeof other === 'string' && !(typeof oriObj === 'string')) {
      return false;
    }
    if (typeof oriObj === 'number' && !(typeof other === 'number')) {
      return false;
    }
    if (typeof other === 'number' && !(typeof oriObj === 'number')) {
      return false;
    }
    if (Array.isArray(oriObj) && !Array.isArray(other)) {
      return false;
    }
    if (Array.isArray(other) && !Array.isArray(oriObj)) {
      return false;
    }
    if (Array.isArray(oriObj) && Array.isArray(other)) {
      if (oriObj.length === 0 || other.length === 0) {
        return false;
      }
      if (oriObj.length !== other.length) {
        return false;
      }
      for (let i = 0; i < oriObj.length; i++) {
        if (oriObj[i] != other[i]) {
          return false;
        }
      }
      return true;
    }
    return oriObj === other;
  }

  public static isEmpty(str: string | null | undefined | number | [],
    defaultVal?: null | undefined | boolean ): boolean {
    if (str === undefined || str === null) {
      return true;
    }
    if (str === '' || str === 0) {
      return true;
    }
    if (Array.isArray(str)) {
      return str.length <= 0;
    }
    if (defaultVal === null || defaultVal === undefined) {
      return true;
    }
    if (defaultVal) {
      return defaultVal;
    }
    return false;
  }

  public static getBinaryData(data: number | string | undefined | null, split: string | null | undefined): string {
    if (data == null || data == undefined) {
      return '';
    }
    if (split == null || split === undefined) {
      return '';
    }
    let num = parseInt(data as string);
    if (isNaN(num)) {
      return '';
    }
    if (num < 0) {
      return '';
    }
    let ret: number[] = [];
    while (num > 0) {
      ret.push(num & 1);
      num >>= 1;
    }
    if (ret.length <= 0) {
      return '';
    }
    return ret.join(split);
  }

  public static getArraySum(data: (number | undefined | null)[] | undefined | null,
    data2: (number | undefined | null)[] | undefined | null): number {
    if (data === undefined || data === null) {
      return -1;
    }
    if (data2 === undefined || data2 === null) {
      return -1;
    }
    if (data.length != data2.length) {
      return -1;
    }
    let sum = 0;
    for (let i = 0; i < data.length; i++) {
      if (data[i] == null || data[i] == undefined) {
        return -1;
      }
      if (data2[i] == null || data2[i] == undefined) {
        return -1;
      }
      let num1 = data[i] ?? 0;
      let num2 = data2[i] ?? 0;
      if (num1 < 0 || num2 < 0) {
        return -1;
      }
      sum += num1 + num2;
    }
    return sum;
  }

  public static getSum(text: string | undefined | null, text2: string | undefined | null): number {
    if (text === undefined || text === null || text === '') {
      return -1;
    }
    if (text2 === undefined || text2 === null || text2 === '') {
      return -1;
    }
    return FormThemeDeleteManager.verifyValue(parseInt(text) + parseInt(text2), -1);
  }

  public static verifyValue(value: number, defaultValue: number): number {
    if (Number.isNaN(value)) {
      return defaultValue;
    }
    return value;
  }

  public static stringToArray(target: string | undefined | null, separator: string | undefined | null): string[] {
    const values: string[] = [];
    if (target === undefined || target === null || target === '') {
      return values;
    }
    if (separator === null || separator === undefined) {
      return values;
    }
    const arr = target.trim().split(separator);
    if (!arr || arr[0].startsWith('ohos')) {
      return values;
    }
    for (let index = 0; index < arr.length; index++) {
      values.push(arr[index].trim());
    }
    return values;
  }

  public static getFloatValues(target: string | undefined | null, separator: string | undefined | null): number[] {
    const values: number[] = [];
    if (target === null || target === undefined || target === '') {
      return values;
    }
    if (separator === null || separator === undefined) {
      return values;
    }
    const arr = target.split(separator);
    if (!arr || arr[0][0] == '-') {
      return values;
    }
    for (let index = 0; index < arr.length; index++) {
      values.push(FormThemeDeleteManager.verifyValue(Number.parseFloat(arr[index].trim()), 0));
    }
    return values;
  }

  public static getIntValues(target: string | undefined | null, separator: string | undefined | null): number[] {
    const values: number[] = [];
    if (target === null || target === undefined || target === '') {
      return values;
    }
    if (separator === null || separator === undefined) {
      return values;
    }
    const arr = target.split(separator);
    if (!arr || arr[0][0] == '-') {
      return values;
    }
    for (let index = 0; index < arr.length; index++) {
      values.push(FormThemeDeleteManager.verifyValue(Number.parseInt(arr[index].trim()), 0));
    }
    return values;
  }

  public static isNumber(text: string | undefined | null): boolean {
    if (text === null || text === undefined || text === '') {
      return false;
    }
    const result = text.match('-?[0-9]+(\\\\.[0-9]+)?');
    if (result == null) {
      return false;
    }
    return true;
  }

  public static getUUID(): string {
    let id = Date.now().toString(HEXADECIMAL_VALUE);
    id += Math.random().toString(HEXADECIMAL_VALUE).substring(2);
    return id;
  }

  public static getStrByCount(str: string | null | undefined, count: number, split?: string): string {
    if (str === null || str === undefined || str === '') {
      return '';
    }
    if (count <= 0) {
      return '';
    }
    const strArr: string[] = [];
    for (let i = 0; i < count; i++) {
      strArr.push(str);
    }
    return split ? strArr.join(split) : strArr.join('');
  }

  public static getDefaultId(key: string | undefined | null): string {
    if (key === null || key === undefined || key === '') {
      return key as string;
    }
    if (key === 'default') {
      return key + FormThemeDeleteManager.getUUID();
    }
    if (key === 'ohos') {
      return '';
    }
    return FormThemeDeleteManager.getUUID();
  }

  public static getIndexByString(resKey: string | null | undefined, arr: Array<string> | undefined | null): number {
    if (resKey === null || resKey === undefined || resKey === '') {
      return -1;
    }
    if (arr === null || arr === undefined) {
      return -1
    }
    for (let i = 0; i < arr.length; i++) {
      if (arr[i] === resKey) {
        return i;
      }
    }
    return -1;
  }

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

  public static drawFontWidth(fontWeight?: number): text.FontWidth | number {
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

  public static drawTextAlign(fontWeight?: number): text.TextAlign | number {
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
      return false;
    }
    if (arr.length > 3) {
      return false;
    }
    return true;
  }
}