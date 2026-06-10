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

import ArrayList from '@ohos.util.ArrayList';
import HashMap from '@ohos.util.HashMap';
import LightWeightMap from '@ohos.util.LightWeightMap';
import LinkedList from '@ohos.util.LinkedList';
import List from '@ohos.util.List';
import TreeMap from '@ohos.util.TreeMap';
import { TsLog } from '../log/TsLog';
import { MapUtils } from './MapUtils';
import { AnyType, MapTypes, OhosListTypes } from './Types';

const TAG: string = `JsonUtils`;

/**
 * json工具类
 */
export namespace JsonUtils {
  type Transformer = (field: object, value: object) => object | undefined;

  const transformerSet: Transformer[] =
    [transformerMap((field: object) => field instanceof Map ? new Map() : undefined),
      transformerMap((field: object) => field instanceof HashMap ? new HashMap<AnyType, AnyType>() : undefined),
      transformerMap((field: object) => field instanceof TreeMap ? new TreeMap<AnyType, AnyType>() : undefined),
      transformerMap((field: object) => field instanceof LightWeightMap ? new LightWeightMap<AnyType, AnyType>() :
        undefined),
      transformerOhosListTypes((field: object) => field instanceof ArrayList ? new ArrayList<AnyType>() : undefined),
      transformerOhosListTypes((field: object) => field instanceof List ? new List<AnyType>() : undefined),
      transformerOhosListTypes((field: object) => field instanceof LinkedList ? new LinkedList<AnyType>() : undefined),
    ];

  /**
   * json字符串转对象
   * @param jsonStr 字符串
   * @returns 对象
   */
  export function parse<T>(jsonStr: string, obj?: T | undefined, reviver?: (key: string, value: AnyType) => AnyType):
  T | undefined {
    try {
      if (jsonStr === undefined || jsonStr === null) {
        return undefined;
      }
      if (obj === undefined || obj === null) {
        if (reviver) {
          return JSON.parse(jsonStr, reviver) as T;
        } else {
          return JSON.parse(jsonStr) as T;
        }
      }
      return parseObj<T>(jsonStr, obj as object, reviver);
    } catch (err) {
      TsLog.error(TAG, `parse catch exception.`, err);
    }
    return undefined;
  }

  function transformerMap<T extends MapTypes>(builder: (field: object) => T | undefined): Transformer {
    return (field: object, value: object) => {
      const map: T | undefined = builder(field);
      if (map !== undefined) {
        Object.entries(value).forEach((val: [string, T]) => map.set(val[0], val[1]));
        return map;
      }
      return undefined;
    };
  }

  function transformerOhosListTypes<T extends OhosListTypes>(builder: (field: object) => T | undefined): Transformer {
    return (field: object, value: object) => {
      const ohosList: T | undefined = builder(field);
      if (ohosList !== undefined) {
        Object.entries(value).forEach((val: [string, T]) => ohosList.add(val[1]));
        return ohosList;
      }
      return undefined;
    };
  }

  function parseObj<T>(jsonStr: string, obj: object, reviver?: (key: string, value: AnyType) => AnyType): T {
    return JSON.parse(jsonStr, (key: string, value: AnyType) => {
      if (reviver) {
        let reviverValue: AnyType = reviver(key, value);
        if (reviverValue !== undefined) {
          return reviverValue;
        }
      }
      if (value === null || value === undefined) {
        return value;
      }
      if (typeof obj[key] !== 'object') {
        return value;
      }
      for (const transformer of transformerSet) {
        let data: object | undefined = transformer(obj[key], value as object);
        if (data) {
          return data;
        }
      }
      return value;
    }) as T;
  }

  /**
   * 对象转json字符串
   *
   * @param obj 对象
   * @returns json字符串
   */
  export function stringify<T>(obj: T, replacer?: (key: string, value: AnyType) => AnyType,
    space?: string | number): string | undefined {
    try {
      if (obj === undefined || obj === null) {
        TsLog.error(TAG, `stringify obj null`);
        return undefined;
      }
      return JSON.stringify(obj, (key:string, value:AnyType) => {
        if (replacer != null) {
          let replaceValue: AnyType = replacer(key, value);
          if (replaceValue !== undefined) {
            return replaceValue;
          }
        }
        if (MapUtils.isMapType(value as object)) {
          let objMap: Record<string, Object> = {};
          (value as Map<string, AnyType>).forEach((value, key) => {
            if (key != undefined && value != undefined) {
              objMap[key] = value;
            }
          })
          return objMap;
        }
        if ((value instanceof ArrayList) || (value instanceof List) || (value instanceof LinkedList)) {
          return value.convertToArray();
        }
        return value;
      }, space);
    } catch (error) {
      TsLog.error(TAG, `stringify fail`);
      return undefined;
    }
  }
}