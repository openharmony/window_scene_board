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
import { util } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'TextCodec';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export namespace TextCodec {
  const textEncoder: util.TextEncoder = new util.TextEncoder();
  const textDecoder: util.TextDecoder = util.TextDecoder.create();

  export function encodeToUint8Array(str: string): Uint8Array {
    let result: Uint8Array = new Uint8Array();
    if (CheckEmptyUtils.isEmpty(str)) {
      return result;
    }
    try {
      result = textEncoder.encodeInto(str);
    } catch (error) {
      log.error('stringToUint8Array fail');
    }
    return result;
  }

  export function decodeToString(bytes: Uint8Array): string {
    let result: string = '';
    if (!bytes || bytes.length === 0) {
      return result;
    }
    try {
      result = textDecoder.decodeWithStream(bytes);
    } catch (error) {
      log.error('uint8ArrayToString fail');
    }
    return result;
  }
}