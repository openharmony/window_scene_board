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

import { ArrayList } from '@kit.ArkTS';

export class SCBDebugUtils {
  public static buildArrayContext(arr: Array<KeyValueArray>): string {
    let context: string = '[';
    for (let i = 0; i < arr.length; i++) {
      let keyValues = arr[i];
      context += '\{';
      keyValues.forEach((keyValue) => {
        let key = keyValue.key;
        let val = keyValue.value;
        if (val instanceof Number || val instanceof String) {
          context += '\'' + key + '\':' + val + ',';
        } else if (val instanceof Boolean) {
          context += '\'' + key + '\':' + (val === true ? 'true' : 'false') + ',';
        } else {
          context += '\'' + key + '\':' + JSON.stringify(val) + ',';
        }
      });
      context = context.substring(0, context.length - 1);
      context += '},';
    }
    if (arr.length !== 0) {
      context = context.substring(0, context.length - 1);
    }
    return context + ']';
  }

  public static buildContext(keyValues: ArrayList<KeyValue>): string {
    let buildContext: string = '';
    keyValues.forEach((keyValue) => {
      let key = keyValue.key;
      let val = keyValue.value;
      if (keyValue.value instanceof Number || val instanceof String) {
        buildContext += key + ':' + val;
        buildContext += '\r\n';
      } else if (val instanceof Boolean) {
        buildContext += key + ':' + (val === true ? 'true' : 'false');
        buildContext += '\r\n';
      } else {
        buildContext += key + ':' + JSON.stringify(val);
        buildContext += '\r\n';
      }
    });
    return buildContext;
  }
}

/**
 * The list composed of key value is used to replace hashMap
 * to solve the problem that hashMap cannot guarantee the printing order
 */
export class KeyValueArray extends ArrayList<KeyValue> {
  public push(key: string, value: Object | null | undefined): void {
    let keyValue = new KeyValue(key, value);
    this.add(keyValue);
  }
}

export class KeyValue {
  public key: string;
  public value: Object | null | undefined;

  constructor(key: string, value: Object | null | undefined) {
    this.key = key;
    this.value = value;
  }
}