/**
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
import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from './LogHelper';

const TAG = 'CheckEmptyUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

type AnyType = string | boolean | number | bigint | null | object | undefined;

export class CheckEmptyUtils {

  /**
   * Check obj is empty.
   *
   * @param {any} obj
   * @return {boolean} true(empty)
   */
  static isEmpty<T>(obj: AnyType | T): boolean {
    return (typeof obj === 'undefined' || obj == null || obj === '');
  }

  /**
   * Check str is empty.
   *
   * @param {string} str
   * @return {boolean} true(empty)
   */
  static checkStrIsEmpty(str: string | undefined): boolean {
    return str === undefined || str === null || (typeof str === 'string' && str.trim().length === 0);
  }

  /**
   * Check array is empty.
   *
   * @param {Array} arr An array to check if is empty.
   * @return {boolean} true(empty)
   */
  static isEmptyArr<T>(arr: T[] | undefined): boolean {
    return arr === undefined || arr === null || (Array.isArray(arr) && arr.length === 0);
  }

  /**
   * Check PixelMap is empty.
   *
   * @param {image.PixelMap} pixelMap
   * @return {boolean} true(empty)
   */
  static isEmptyPixelMap(pixelMap: image.PixelMap | undefined): boolean {
    try {
      return CheckEmptyUtils.isEmpty(pixelMap) || !pixelMap?.getPixelBytesNumber();
    } catch (err) {
      if (String(err?.code) === '501') {
        // 当PixelMap通过Worker跨线程后，原线程的PixelMap的所有接口均不能调用，否则将报错501
        log.showWarn('isEmptyPixelMap getPixelBytesNumber throw error code: 501, return false');
        return false;
      }
    }
    return true;
  }

  static isEmptyStringOrPixelMap(pixelMap: string | image.PixelMap): boolean {
    if (typeof pixelMap === 'string') {
      return CheckEmptyUtils.checkStrIsEmpty(pixelMap);
    } else {
      return CheckEmptyUtils.isEmptyPixelMap(pixelMap);
    }
  }
}