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
import { ArrayType, SetType } from './Types';

/**
 * 数组工具类
 */
export namespace ArrayUtils {
  /**
   * 判断list是否为空
   *
   * @param list list对象
   * @returns 是否为空
   */
  export function isNull<T>(list: ArrayType<T> | SetType<T> | undefined): boolean {
    return ArrayUtils.size(list) === 0;
  }

  /**
   * 判断list长度
   *
   * @param list list对象
   * @returns list length
   */
  export function size<T>(list: ArrayType<T> | SetType<T> | undefined): number {
    if (list === undefined || list === null) {
      return 0;
    }
    if (list instanceof Set) {
      return (list as SetType<T>).size;
    } else {
      return (list as ArrayType<T>).length;
    }
  }

  /**
   * 是否是数组
   *
   * @param list 数组
   * @returns 是否是数组
   */
  export function isArray<T>(list: ArrayType<T> | undefined): boolean {
    return Array.isArray(list);
  }

  /**
   * 对数组进行转换的函数
   * @param array 输入的数组，可能为undefined
   * @param transformer 转换函数，将数组中的每个元素转换为新的类型
   * @return 返回转换后的数组，如果输入的数组为undefined或者空数组，则返回空数组
   */
  export function map<T, V>(array: T[] | undefined, transformer: (t: T) => V | undefined): V[] {
    let values: V[] = [];
    if (!array) {
      return values;
    }
    for (const element of array) {
      let value: V | undefined = transformer(element);
      if (value) {
        values.push(value);
      }
    }
    return values;
  }
}