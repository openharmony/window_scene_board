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
 * 应用包信息工具类
 *
 * @since 2023-02-21
 */
export default class BundleInfoUtil {
  /**
   * 以下是26个英文字母对应的在拼音排序里的第一个汉字，比如a对应啊，b对应八，c对应嚓；
   * 其中iuv没有对应的汉字，用前一个音的最后一个替代，或者后一个音的第一个汉字替代
   */
  public static readonly zh: string = '阿八嚓哒妸发旮哈靃讥咔垃呣拏噢妑七呥仨它唾畖窊夕丫帀';
  public static readonly en: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  /**
   * 把英文字母转换为汉字在拼音排序中的第一个字
   *
   * @param input 待转换的字符串
   * @return 转换后的字符串
   */
  static getStringZh(input: string): string {
    let result: string = '';
    for (let char of input.toLocaleUpperCase()) {
      if (char >= 'A' && char <= 'Z') {
        let index = char.charCodeAt(0) - 'A'.charCodeAt(0);
        let ch = BundleInfoUtil.zh.charAt(index);
        result += ch;
      } else {
        result += char;
      }
    }
    return result;
  }

  /**
   * 中文对应的拼音首字母
   *
   * @param zhCharacter 中文字符
   * @return 对应的拼音首字母
   */
  static findZhIndex(zhCharacter: string): string {
    if (zhCharacter.trim().length === 0 || zhCharacter.localeCompare(BundleInfoUtil.zh[0], 'zh') < 0) {
      return '#';
    }
    for (let left = 0; left < BundleInfoUtil.zh.length - 1; left++) {
      let next = left + 1;
      if (
        zhCharacter.localeCompare(BundleInfoUtil.zh[left], 'zh') >= 0 &&
        zhCharacter.localeCompare(BundleInfoUtil.zh[next], 'zh') < 0
      ) {
        return BundleInfoUtil.en[left];
      }
      if (next === BundleInfoUtil.zh.length - 1 && zhCharacter.localeCompare(BundleInfoUtil.zh[next], 'zh') >= 0) {
        return BundleInfoUtil.en[next];
      }
    }
    return '';
  }
}

/**
 * 通知来源Bundle信息
 *
 */
export interface NtfBundleInfo {
  appTitle: string;
  appVersion: string;
  appBundleName: string;
  appUid: number;
  systemApp: boolean;
  appIcon: string;
  appIndex: number;
  appSwitch?: boolean;
  appSlot?: number;
  isdeliverApp?: boolean;
}