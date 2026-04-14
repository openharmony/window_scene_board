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

import rpc from '@ohos.rpc';
import { CheckEmptyUtils } from '@ohos/basicutils';
import {
  COMMAND_ON_EVENT_CHANGE,
  EMPTY_STRING,
  onEventChangeCallback,
  SLICE_NUMBER,
  WRITE_STRING_CAPACITY,
  WRITE_STRING_MAX_SIZE,
  WRITE_STRING_THRESHOLD
} from './IIdlVisionGlassExtServiceCallback';
import IIdlVisionGlassExtServiceCallback from './IIdlVisionGlassExtServiceCallback';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'VisionGlassExtCallbackStub';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export default class IdlVisionGlassExtServiceCallbackStub
extends rpc.RemoteObject implements IIdlVisionGlassExtServiceCallback {
  public constructor(des: string) {
    super(des);
  }

  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): Promise<boolean> {
    const descriptor = data.readInterfaceToken();
    if (this.getDescriptor() !== descriptor) {
      log.showError(`invalidate descriptor is:${descriptor}`);
      return false;
    }
    switch (code) {
      case COMMAND_ON_EVENT_CHANGE: {
        // event 较短使用普通读写， data 字段采用分段读写，增强数据传输能力
        let eventVar = data.readString();
        if (CheckEmptyUtils.isEmpty(eventVar)) {
          log.showWarn('idl failed for event is empty');
          return false;
        }
        let dataVar = this.getRemoteString(data);
        let promiseMessage = new Promise<void>((resolve, reject) => {
          this.onEventChange(eventVar, dataVar, (errCode, data) => {
            reply.writeInt(errCode);
            this.writeStringInSegments(reply, data);
          });
          resolve();
        });
        await promiseMessage;
        return true;
      }
      default: {
        log.showWarn(`invalid request code = ${code}`);
        break;
      }
    }
    return false;
  }

  // 分段写入string
  private writeStringInSegments(data: rpc.MessageSequence, result: string): boolean {
    // 1、writeString单次写入要小于40kb，大于200kb要设置容量大小，
    // 2、writeRawData容量大，但是要求传入字节数组，加上转换时间，整体时延更大(60kb proxy->stub约250ms)
    // 3、考虑到直接计算字节数可能会出现2中的情况，同样影响性能，所以采用以长度而不是字节分割字符串的方式
    // 4、10000个字符按每个字符占用最多4个字节计算，最多占用39KB，因此直接使用10000作为分割点，每10000字符调用一次writeString
    // 5、writeString极限为500kb，最多分割12次，因此将写入控制在12次(含12次)以内
    const strLength: number = result.length;
    const numChunks: number = Math.ceil(strLength / SLICE_NUMBER);
    if (numChunks > WRITE_STRING_MAX_SIZE) {
      return false;
    }
    if (numChunks >= WRITE_STRING_THRESHOLD) {
      data.setCapacity(WRITE_STRING_CAPACITY);
    }
    data.writeInt(numChunks);
    let index: number = 0;
    log.showDebug(`writeStringInSegments string is ${result.slice(index, index + SLICE_NUMBER)},index is ${index}`);
    while (index < strLength) {
      data.writeString(result.slice(index, index + SLICE_NUMBER));
      index += SLICE_NUMBER;
    }
    return true;
  }

  private getRemoteString(data: rpc.MessageSequence): string {
    let arr: string[] = [];
    try {
      let count: number = data.readInt();
      if (count > WRITE_STRING_MAX_SIZE) {
        log.showInfo(`getRemoteString exceeding the limit ${count}}`);
        return EMPTY_STRING;
      }
      while (count > 0) {
        let segment = data.readString();
        arr.push(segment);
        count--;
      }
    } catch (err) {
      log.showError('getRemoteString err');
      return EMPTY_STRING;
    }
    return arr.join(EMPTY_STRING);
  }

  onEventChange(event: string, data: string, callback: onEventChangeCallback): void {
  }
}

