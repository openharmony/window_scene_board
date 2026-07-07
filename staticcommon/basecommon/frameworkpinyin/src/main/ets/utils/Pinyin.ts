/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
 * Pinyin.
 *
 * @typedef Option.
 * @type Object.
 * @property {Boolean} [checkPolyphone=false] Whether to check for polyphonic words.
 * @property {Number} [charCase=0] Output pinyin case mode, 0- first letter capitalization; 1- All lowercase; 2 - all uppercase.
 */

import { CHAR_DICT, FULL_DICT, POLYPHONE } from './PinyinDict';

export class PinyinOptions {
  checkPolyphone: boolean;
  charCase: number;
}

export class Pinyin {
  private options: PinyinOptions = new PinyinOptions();
  private charDict: string = '';
  private fullDict: Record<string, string> = {};
  private polyphone: Record<string, string> = {};

  /**
   * Constructor.
   *
   * @param {object} options - the options for chinese transform to pinyin
   */
  constructor(options?: PinyinOptions) {
    this.setOptions(options);
    this.initialize();
  }

  /**
   * set params.
   *
   * @param {object} options - the options for chinese transform to pinyin
   */
  setOptions(options?: PinyinOptions): void {
    if (!options) {
      options = {} as PinyinOptions;
    }
    this.options.checkPolyphone = options?.checkPolyphone ? options?.checkPolyphone : false;
    this.options.charCase = options?.charCase ? options?.charCase : 0;
  }

  /**
   * initialize data.
   *
   */
  initialize(): void {
    this.charDict = CHAR_DICT;
    this.fullDict = FULL_DICT;
    this.polyphone = POLYPHONE;
  }

  /**
   * Get the initials of pinyin.
   *
   * @param {string} str - The input Chinese string
   * @return {object} - result for CamelChars.
   */
  getCamelChars(str: string): string {
    if (typeof (str) !== 'string') {
      throw new Error('getCamelChars need string param!');
    }
    const chars: string [] = [];
    for (let i = 0, len = str.length; i < len; i++) {
      //get unicode
      const ch = str.charAt(i);
      //Check whether the Unicode code is within the range of processing,
      // if it returns the pinyin first letter of the Chinese character reflected by the code,
      // if it is not, call other functions to process
      chars.push(this.getChar(ch));
    }

    let result = this.getResult(chars);

    if (typeof result === 'string') {
      this.options.charCase === 1 ?
        result = result.toLowerCase() :
        this.options.charCase === 2 ?
          result = result.toUpperCase() :
          '';
      return result;
    } else {
      return this.options.charCase === 1 ? result[0].toLowerCase() : this.options.charCase === 2 ? result[0].toUpperCase() : '';
    }
  }

  /**
   * Get Pinyin.
   *
   * @param {string} str - The input Chinese string.
   * @return {object} result for FullChars.
   */
  getFullChars(str: string): string {
    const len = str.length;
    let result = '';
    const reg = new RegExp('[a-zA-Z0-9\- ]');
    for (let i = 0; i < len; i++) {
      const ch = str.substr(i, 1);
      const unicode = ch.charCodeAt(0);

      if (unicode > 40869 || unicode < 19968) {
        result += ch;
      } else {
        const name = this.getFullChar(ch);
        if (name !== false) {
          result += name;
        }
      }
    }

    if (this.options.charCase === 1) {
      result = result.toLowerCase();
    } else if (this.options.charCase === 2) {
      result = result.toUpperCase();
    }
    return result;
  }

  getFullChar(ch: string): string | boolean {
    const keys = Object.keys(this.fullDict);
    for (let idx = 0; idx < keys.length; idx++) {
      let key = keys[idx];
      if (this.fullDict[key].indexOf(ch) !== -1) {
        return this.capitalize(key);
      }
    }
    return false;
  }

  capitalize(str: string): string {
    if (str.length > 0) {
      const first = str.substr(0, 1).toUpperCase();
      const spare = str.substr(1, str.length);
      return first + spare;
    }
    return '';
  }

  getChar(ch: string): string {
    const unicode = ch.charCodeAt(0);
    //If not within the scope of Chinese character processing, return the original character, you can also call their own handler function
    if (unicode > 40869 || unicode < 19968) {
      return ch; //dealWithOthers(ch);
    }
    //To check if it is polyphonic, it is polyphonic rather than looking for the corresponding letter in the string strChineseFirstPY
    if (!this.options.checkPolyphone) {
      return this.charDict.charAt(unicode - 19968);
    }
    return this.polyphone[unicode] ? this.polyphone[unicode] : this.charDict.charAt(unicode - 19968);
  }

  getResult(chars: string[]): string | string[] {
    if (!this.options.checkPolyphone) {
      return chars.join('');
    }
    let result = [''];
    for (let i = 0, len = chars.length; i < len; i++) {
      const str = chars[i];
      const strlen = str.length;
      if (strlen === 1) {
        for (let j = 0; j < result.length; j++) {
          result[j] += str;
        }
      } else {
        const swap1 = result.slice(0);
        result = [];
        for (let j = 0; j < strlen; j++) {
          const swap2 = swap1.slice(0);
          for (let k = 0; k < swap2.length; k++) {
            swap2[k] += str.charAt(j);
          }
          result = result.concat(swap2);
        }
      }
    }
    return result;
  }
}