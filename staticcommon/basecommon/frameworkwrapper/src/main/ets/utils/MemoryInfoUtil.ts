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

import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import fs from '@ohos.file.fs';

const TAG = 'MemoryInfoUtil';
const MEM_INFO_FILE_PATH = 'proc/meminfo';
const UNIT_BYTE = 'B';
const UNIT_KB = 'kB';
const UNIT_KB_UPPER = 'KB';
const UNIT_MB = 'MB';
const UNIT_GB = 'GB';
const KILO_BYTES = 1024;
const MEGA_BYTES = 1024 * KILO_BYTES;
const GIGA_BYTES = 1024 * MEGA_BYTES;
const DEFAULT_FILE_LENGTH = 4096;
const PAIR_ARRAY_LENGTH: number = 2;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 获取内存信息
 *
 * @since 2023-03-20
 */
export default class MemoryInfoUtil {
  static getMemoryTotalSize(): number {
    try {
      let stream: fs.Stream = fs.createStreamSync(MEM_INFO_FILE_PATH, 'r');
      let buf = new ArrayBuffer(DEFAULT_FILE_LENGTH);
      let len = stream.readSync(buf);
      let arr = new Uint8Array(buf);
      let charAt = ' '.charCodeAt(0);
      for (let i = len; i < DEFAULT_FILE_LENGTH; i++) {
        arr[i] = charAt;
      }
      let content: string = String.fromCharCode.apply(null, arr);
      stream.closeSync();
      let configs: Array<string> = content.split('\n');
      for (let i = 0; i < configs.length; i++) {
        let item: string = configs[i];
        if (CommonUtils.isEmpty(item)) {
          continue;
        }
        let pair = item.split(':');
        if (ArrayUtils.isEmpty(pair) || pair.length < PAIR_ARRAY_LENGTH) {
          continue;
        }
        let name = pair[0].trim();
        let value = pair[1].trim();
        if (name === 'MemTotal') {
          let totalMem = value;
          let arr = totalMem.split(' ');
          return MemoryInfoUtil.getBytes(parseInt(arr[0]), arr[1]);
        }
      }
    } catch (error) {
      log.error('readConfigFile error:', error);
    }
    return 0;
  }

  /**
   * 获取字节数
   *
   * @param size 数值
   * @param unit 单位
   * @return 字节数
   */
  private static getBytes(size: number, unit: string): number {
    log.showInfo(`getBytes size:${size}, unit:${unit}`);
    let multiple;
    if (unit === UNIT_BYTE) {
      multiple = 1;
    } else if (unit === UNIT_KB || unit === UNIT_KB_UPPER) {
      multiple = KILO_BYTES;
    } else if (unit === UNIT_MB) {
      multiple = MEGA_BYTES;
    } else if (unit === UNIT_GB) {
      multiple = GIGA_BYTES;
    } else {
      log.showWarn(`getBytes ,unkown unit:${unit}`);
      multiple = 0;
    }
    return size * multiple;
  }
}