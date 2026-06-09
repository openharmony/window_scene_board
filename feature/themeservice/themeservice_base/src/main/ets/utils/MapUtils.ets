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

import HashMap from '@ohos.util.HashMap';
import LightWeightMap from '@ohos.util.LightWeightMap';
import TreeMap from '@ohos.util.TreeMap';
import { AnyType } from './Types';


/**
 * Map工具类
 *
 * @since 2023-09-04
 */
export class MapUtils {
  /**
   * 判断Map是否为空
   *
   * @param hashMap Map对象
   * @returns 是否为空
   */
  public static isNull(map: HashMap<AnyType, AnyType>
    | LightWeightMap<AnyType, AnyType> | TreeMap<AnyType, AnyType> | Map<AnyType, AnyType> | undefined): boolean {
    if (map === undefined || map === null) {
      return true;
    }
    if (map instanceof HashMap || map instanceof LightWeightMap || map instanceof TreeMap) {
      return map.isEmpty();
    }
    if (map instanceof Map) {
      return map.size <= 0;
    }
    return false;
  }

  /**
   * 判断是否是MapType类型
   *
   * @param value
   * @returns 是否为MapType联合类型
   */
  public static isMapType(value: object): boolean {
    return (value instanceof Map) || (value instanceof HashMap) || (value instanceof TreeMap) ||
      (value instanceof LightWeightMap);
  }
}