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

import { rpc } from '@kit.IPCKit';
import { buffer } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'FormRemoteUtils'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_READ_INT: number = 35;
const SLICE_NUMBER: number = 10000;
const EMPTY_STRING: string = '';
const WRITE_STRING_CAPACITY: number = 640 * 1024;
const WRITE_STRING_THRESHOLD_REAL: number = 99 * 1024;
const WRITE_STRING_MAX_SIZE_REAL: number = 640 * 1024;

export default class FormRemoteUtils {
  public static writeStringInSegments(data: rpc.MessageSequence, msg: string): boolean {
    let strLength: number = msg.length;
    let numChunks: number = Math.ceil(strLength / SLICE_NUMBER);
    let strSize: number = buffer.byteLength(msg, 'utf8');

    if ((2 * strSize) > WRITE_STRING_MAX_SIZE_REAL) {
      log.showError('callbackresult size is larger than limit');
      return false;
    }

    if (strSize > WRITE_STRING_THRESHOLD_REAL) {
      log.showWarn(`callbackresult size is larger than threshold, need to setcapacity, the data capacity is ${data.getCapacity()}`);
      data.setCapacity(WRITE_STRING_CAPACITY);
    }
    data.writeInt(numChunks);
    let index: number = 0;
    while (index < strLength) {
      data.writeString(msg.slice(index, index + SLICE_NUMBER));
      index += SLICE_NUMBER;
    }
    log.showInfo('writeStringInSegments success');
    return true;
  }

  public static getRemoteString(data: rpc.MessageSequence): string {
    let count: number = data.readInt();
    if (count < 0 || count > MAX_READ_INT) {
      log.showError('ServiceCallbackProxy', 'read int is too large, invalid data');
      return EMPTY_STRING;
    }
    let arr: string[] = [];
    while (count !== 0) {
      arr.push(data.readString());
      count--;
    }
    return arr.join(EMPTY_STRING);
  }
}