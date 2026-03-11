/*
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

type AnyType = string | boolean | number | bigint | object;

export class ObjUtil {
  /**
   * 判断对象是否不可用
   *
   * @param obj 待判断对象
   * @returns true不可用
   * @deprecated since 2025.07.26
   * @useinstead CommonUtils.isInvalid
   */
  public static isInvalid(obj): boolean {
    return obj === undefined || obj === null;
  }

  /**
   * 判断对象是否可用
   *
   * @param obj 待判断对象
   * @return true可用
   * @deprecated since 2025.07.26
   * @useinstead CommonUtils.isValid
   */
  public static isValid(obj): boolean {
    return !ObjUtil.isInvalid(obj);
  }

  public static keys(obj: Object): Object[] {
    return Object.keys(obj);
  }

  /**
   * weather the obj is illegal
   *
   * @param obj obj to be checked
   * @returns the valid obj
   */
  public static requireNonNull<T>(obj: T): T {
    if (!obj) {
      throw new Error('obj is illegal!');
    }
    return obj;
  }

  /**
   * 多层嵌套赋值
   *  --设置obj对象中对应path属性路径上的值，如果path不存在，则创建
   * @param obj   赋值对象
   * @param path  赋值路径，支持字符串&数组两种方式
   * @param value 赋值的值
   */
  public static setNested(obj: Object, path: string | string[], value: string | number): void {
    if (Number.isNaN(value)) {
      return;
    }
    if (!Array.isArray(path)) {
      path = path.toString().match(/[^.[\]]+/g) || [];
    }
    const len = path.length;
    if (len === 0) {
      return;
    }
    let record: Record<string, AnyType> = obj as Record<string, AnyType>;
    for (let i = 0; i < len - 1; i++) {
      const key = path[i];
      if (!ObjUtil.hasKey(record, key)) {
        Reflect.set(record, key, typeof path[i + 1] === 'number' ? [] : {})
      }
      record = record[key] as Record<string, AnyType>;
    }
    Reflect.set(record, path[len - 1], value);
  }

  private static hasKey(obj: Record<string, AnyType>, dstKey: string): boolean {
    for (let key of Object.keys(obj)) {
      if (key === dstKey) {
        return true;
      }
    }
    return false;
  }
}