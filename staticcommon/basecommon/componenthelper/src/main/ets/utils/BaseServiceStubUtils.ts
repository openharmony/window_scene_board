/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { util } from '@kit.ArkTS';

const TAG = 'BaseServiceStubUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class BaseServiceStubUtils {
  private static readonly EMPTY_STRING: string = '';

  private static readonly SLICE_NUMBER: number = 10000;

  private static readonly WRITE_STRING_MAX: number = 480;

  private static readonly WRITE_STRING_CAPACITY: number = BaseServiceStubUtils.WRITE_STRING_MAX * 1024;

  private static readonly WRITE_STRING_THRESHOLD: number = 5;

  private static readonly WRITE_STRING_MAX_SIZE: number = 12;

  // readInt为报文分割次数，目前统一Sdk最大支持发送报文约为1024KB，接收报文段数是50
  private static readonly MAX_READ_INT: number = 50;

  private static textEncoder: util.TextEncoder = new util.TextEncoder();

  /**
   * 非分段场景下写数据
   * @param data 待发送给对端的MessageSequence
   * @param result 待发送的字符串
   * @returns 写数据是否成功
   */
  public static writeStringInNormal(data: rpc.MessageSequence, result: string): boolean {
    if (CheckEmptyUtils.isEmpty(data) || CheckEmptyUtils.checkStrIsEmpty(result)) {
      log.showError('writeStringInNormal params error');
      return false;
    }
    data.writeString(result);
    return true;
  }

  /**
   * 分段并拼接string
   * @param data 远端发送过来的data
   * @returns 拼接的字符串
   */
  public static getRemoteString(data: rpc.MessageSequence): string {
    if (CheckEmptyUtils.isEmpty(data)) {
      log.showError('getRemoteString params error');
      return '';
    }
    let arr: string[] = [];

    try {
      let count: number = data.readInt();
      if (count > BaseServiceStubUtils.MAX_READ_INT) {
        log.showWarn(`getRemoteString exceeding the limit ${count}`);
        return '';
      }
      while (count > 0) {
        let segment = data.readString();
        arr.push(segment);
        count--;
      }
    } catch (err) {
      log.showError('getRemoteString err');
      return '';
    }

    return arr.join(BaseServiceStubUtils.EMPTY_STRING);
  }

  /**
   * 获取remoteObject
   *
   * @param data client发送的数据
   * @returns remoteObject
   */
  public static getRemoteObject(data: rpc.MessageSequence): rpc.IRemoteObject | null {
    if (CheckEmptyUtils.isEmpty(data)) {
      log.showError('getRemoteObject params error');
      return null;
    }
    try {
      return data.readRemoteObject();
    } catch (e) {
      return null;
    }
  }

  /**
   * 分段写入string
   * @param data 待发送给对端的MessageSequence
   * @param result 待发送的字符串
   * @returns 写数据是否成功
   */
  public static writeStringInSegments(data: rpc.MessageSequence, result: string): boolean {
    if (CheckEmptyUtils.isEmpty(data) || CheckEmptyUtils.checkStrIsEmpty(result)) {
      log.showError('writeStringInSegments params error');
      return false;
    }
    // 1、writeString单次写入要小于40kb，大于200kb要设置容量大小，
    // 2、writeRawData容量大，但是要求传入字节数组，加上转换时间，整体时延更大(60kb proxy->stub约250ms)
    // 3、考虑到直接计算字节数可能会出现2中的情况，同样影响性能，所以采用以长度而不是字节分割字符串的方式
    // 4、10000个字符按每个字符占用最多4个字节计算，最多占用39KB，因此直接使用10000作为分割点，每10000字符调用一次writeString
    // 5、writeString极限为500kb，最多分割12次，因此将写入控制在12次(含12次)以内
    let strLength: number = result.length;
    let numChunks: number = Math.ceil(strLength / BaseServiceStubUtils.SLICE_NUMBER);
    if (numChunks > BaseServiceStubUtils.WRITE_STRING_MAX_SIZE) {
      return false;
    }

    if (numChunks >= BaseServiceStubUtils.WRITE_STRING_THRESHOLD) {
      data.setCapacity(BaseServiceStubUtils.WRITE_STRING_CAPACITY);
    }
    data.writeInt(numChunks);
    let index: number = 0;
    while (index < strLength) {
      data.writeString(result.slice(index, index + BaseServiceStubUtils.SLICE_NUMBER));
      index += BaseServiceStubUtils.SLICE_NUMBER;
    }

    return true;
  }

  /**
   * 数据量很大写RawData  但最大不能超过128M,目前用于获取保留清单，目前分片最多12 * 10000 ，
   *  如果超过这个长度可以考虑使用writeRawDataBuffer 读取的时候先读取一个int,然后使用readRawDataBuffer读取到buffer
   * @link ohos.rpc.MessageSequence#readRawDataBuffer
   * @param data 待发送给对端的MessageSequence
   * @param result 待发送的字符串
   * @returns 写数据是否成功
   */
  public static writeRawDataBuffer(data: rpc.MessageSequence, result: string): boolean {
    if (CheckEmptyUtils.isEmpty(result)) {
      log.showInfo(`writeRawData result string length = 0`);
      data.writeInt(0);
      return true;
    }
    let resultUint8Array: ArrayBuffer = this.textEncoder.encodeInto(result).buffer as ArrayBuffer;
    data.writeInt(resultUint8Array.byteLength);
    data.writeRawDataBuffer(resultUint8Array, resultUint8Array.byteLength);
    return true;
  }

  /**
   * 将ArrayBuffer转成string
   * @param buffer ArrayBuffer
   * @returns string
   */
  public static parseArrayBufferToStr(buffer: ArrayBuffer): string {
    if (buffer === null) {
      return '';
    }
    let result: Uint8Array = new Uint8Array(buffer);
    const decoder: util.TextDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    return decoder.decodeWithStream(result, { stream: false });
  }
}