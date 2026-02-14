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

import ArrayList from '@ohos.util.ArrayList';
import HashMap from '@ohos.util.HashMap';
import HashSet from '@ohos.util.HashSet';
import { CommonUtils } from './CommonUtils';

type AnyType = string | boolean | number | bigint | null | object | undefined;

/**
 * 数组工具
 *
 * @since 2022-10-08
 */
export class ArrayUtils {
  /**
   * 数组集合判空
   *
   * @param arr 集合
   */
  static isEmpty<T, U = AnyType>(arr?: Array<T> | Set<T> | Map<T, U> | ArrayList<T> | HashMap<T, U> | HashSet<T>): boolean {
    if (CommonUtils.isInvalid(arr)) {
      return true;
    }
    if ((arr instanceof ArrayList) || (arr instanceof HashMap) || (arr instanceof HashSet)) {
      return arr.isEmpty();
    }
    if (arr instanceof Array) {
      return arr.length === 0;
    }
    return arr === null ? false : arr.size === 0;
  }

  /**
   * 检测map集合中的集合数据，如果为空则删除该key
   *
   * @param map 待检测map
   * @param key 待检测key
   */
  static checkDeleteIfEmpty(map: Map<AnyType, Map<AnyType, AnyType> | Set<AnyType> | Array<AnyType>>,
    key: AnyType): void {
    if (CommonUtils.isInvalid(map)) {
      return;
    }
    if (ArrayUtils.isEmpty(map.get(key))) {
      map.delete(key);
    }
  }

  /**
   * 获取集合大小
   *
   * @param arr 集合
   * @return 集合大小
   */
  static getSize<T, U = AnyType>(arr: Array<T> | Set<T> | Map<T, U> | undefined): number {
    if (CommonUtils.isInvalid(arr)) {
      return 0;
    }
    if (!arr) {
      return 0;
    }
    if (arr instanceof Array) {
      return arr.length;
    }
    return arr.size;
  }

  /**
   * 集合是否包含元素
   *
   * @param arr 集合
   * @param element 元素
   */
  static contains<T>(arr: Array<T> | Set<T> | undefined, element: T): boolean {
    return ArrayUtils.find(arr, element) != null;
  }

  /**
   * 查找集合中的指定元素
   *
   * @param arr 集合
   * @param element 指定元素
   */
  static find<T>(arr: Array<T> | Set<T> | undefined, element: T): T | null {
    if (ArrayUtils.isEmpty<T>(arr)) {
      return null;
    }
    if (!arr) {
      return null;
    }
    for (let value of arr) {
      if (CommonUtils.equals(element, value)) {
        return value;
      }
    }
    return null;
  }

  /**
   * 查询集合指定元素索引
   *
   * @param arr 集合
   * @param element 指定元素
   * @return 索引，-1未找到
   */
  static findIndex<T>(arr: Array<T> | undefined, element: T): number {
    if (ArrayUtils.isEmpty<T>(arr)) {
      return -1;
    }
    let result = arr?.findIndex((value, index, tarArr) => {
      return CommonUtils.equals(element, value);
    });
    return result as number;
  }

  /**
   * 查询集合指定索引处元素
   *
   * @param arr 集合
   * @param index 指定索引
   * @returns 目标元素
   */
  static findArr<T>(arr: Array<T>, index: number): T | null {
    if (ArrayUtils.isEmpty<T>(arr)) {
      return null;
    }
    if (index < 0 || index >= ArrayUtils.getSize<T>(arr)) {
      return null;
    }
    return arr[index];
  }

  /**
   * 删除元素
   *
   * @param arr 集合
   * @param element 元素
   * @return 删除元素索引
   */
  static deleteArr<T>(arr: Array<T> | undefined, element: T): number {
    if (CommonUtils.isInvalid(arr)) {
      return -1;
    }
    let index = ArrayUtils.findIndex(arr, element);
    if (index >= 0) {
      arr?.splice(index, 1);
    }
    return index;
  }

  /**
   * 删除元素
   *
   * @param arr 集合
   * @param index 元素索引
   * @return 删除元素
   */
  static deleteArrByIndex<T>(arr: Array<T>, index: number): T | null {
    if (CommonUtils.isInvalid(arr)) {
      return null;
    }
    if (index >= ArrayUtils.getSize<T>(arr)) {
      return null;
    }
    return arr.splice(index, 1)[0];
  }

  /**
   * 删除指定元素
   *
   * @param arr 集合
   * @param element 指定元素
   * return T被删除old元素
   */
  static delete<T>(arr: Array<T> | Set<T>, element: T): T | null {
    // array 删除元素
    if (arr instanceof Array) {
      let index = ArrayUtils.findIndex(arr, element);
      if (index >= 0) {
        return arr.splice(index, 1)[0];
      }
      return null;
    }
    // set 删除元素
    let value = ArrayUtils.find(arr, element);
    if (value) {
      arr?.delete(value);
    }
    return value;
  }

  /**
   * 清空集合
   *
   * @param arr 集合
   */
  static clearArr(arr: Array<AnyType>): void {
    if (ArrayUtils.isEmpty(arr)) {
      return;
    }
    arr.splice(0, arr.length);
  }

  /**
   * 移动元素
   *
   * @param arr 集合
   * @param from 元素原始值
   * @param to 元素终值
   */
  static moveArr<T>(arr: Array<T>, from: number, to: number): boolean {
    if (CommonUtils.isInvalid(arr)) {
      return false;
    }
    let length = ArrayUtils.getSize<T>(arr);
    if (from >= length || to >= length) {
      return false;
    }
    let delItem = arr.splice(from, 1);
    arr.splice(to, 0, delItem[0]);
    return true;
  }

  /**
   * 添加指定索引元素
   *
   * @param arr 集合
   * @param index 指定索引
   * @param element 元素
   */
  static addArr<T>(arr: Array<T>, index: number, element: T): void {
    if (CommonUtils.isInvalid(arr)) {
      return;
    }
    if (ArrayUtils.getSize<T>(arr) <= index) {
      arr.push(element);
    } else {
      arr.splice(index, 0, element);
    }
  }

  /**
   * 更新或添加元素
   *
   * @param arr 集合
   * @param element 元素
   * @return 更新元素索引
   */
  static updateArr<T>(arr: Array<T>, element: T): number {
    if (CommonUtils.isInvalid(arr)) {
      return -1;
    }
    let index = ArrayUtils.findIndex(arr, element);
    if (index >= 0) {
      arr.splice(index, 1, element)
      return index;
    }
    arr.push(element);
    return -1;
  }

  /**
   * 更新指定元素
   *
   * @param arr 集合
   * @param element 指定元素
   * @return T被替换old元素
   */
  static update<T>(arr: Array<T> | Set<T>, element: T): T | null {
        // array 更新或新增
    if (arr instanceof Array) {
      let index = ArrayUtils.findIndex(arr, element);
      if (index >= 0) {
         return arr.splice(index, 1, element)[0];
      }
      arr.push(element);
      return null;
    }
        // set 更新或新增
    let oldElement = ArrayUtils.delete(arr, element);
    arr?.add(element);
    return oldElement;
  }

  /**
   * 更新指定索引位置元素
   *
   * @param arr 集合
   * @param element 指定元素
   */
  static updateByIndex<T>(arr: Array<T>, index: number, element: T): void {
    arr.splice(index, 1, element);
  }

  /**
   * 更新指定元素集
   *
   * @param arr 集合
   * @param elements 指定元素集
   */
  static updateAll<T>(arr: Array<T> | Set<T>, elements: Array<T> | Set<T>): void {
    elements?.forEach((element: T) => ArrayUtils.update<T>(arr, element));
  }

  /**
   * 判断集合相等
   *
   * @param oriArr 集合1
   * @param other 集合2
   */
  static equalsArr<T>(oriArr: Array<T> | undefined, other: Array<T>): boolean {
    if (ArrayUtils.isEmpty(oriArr) || ArrayUtils.isEmpty(other)) {
      return ArrayUtils.isEmpty(oriArr) && ArrayUtils.isEmpty(other);
    }
    if (oriArr && oriArr.length !== other.length) {
      return false;
    }
    let result = oriArr?.find((value: T, index: number) => {
      return !CommonUtils.equals(value, other[index]);
    });
    // 判断存在不相等的数据
    return CommonUtils.isInvalid(result);
  }
}