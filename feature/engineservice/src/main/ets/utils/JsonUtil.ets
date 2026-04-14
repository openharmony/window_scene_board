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
import lazy { FileUtils } from './FileUtils';
import { Log } from './Log';
import lazy { AnyType } from './Types';

const TAG: string = 'JsonUtil';

/**
 * json解析工具类，集成异常捕获
 */
export namespace JsonUtil {
  /**
   * JSON.parse方法
   *
   * @param content 传入的json内容
   * @returns 经解析转换后的结果或解析失败undefined
   */
  export function jsonParse(content: Nullable<string>): object | undefined {
    if (content == undefined) {
      return undefined;
    }
    let res: object | undefined;
    try {
      res = JSON.parse(content);
    } catch (e) {
      Log.error(TAG, `JSON parse error! code is ${e.code}, message is ${e.message}`);
    }
    return res;
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
        Log.error(TAG, `stringify obj null`);
        return undefined;
      }

      return JSON.stringify(obj, (key: string, value: AnyType) => {
        if (replacer != null) {
          let replaceValue: AnyType = replacer(key, value);
          if (replaceValue !== undefined) {
            return replaceValue;
          }
        }
        return value;
      }, space);
    } catch (error) {
      Log.error(TAG, `stringify fail`);
      return undefined;
    }
  }

  /**
   * 解析文件
   *
   * @param path 文件路径
   * @returns 返回转换后的结果
   */
  export function parseFile<T>(path: string): Nullable<T> {
    if (!FileUtils.isExists(path)) {
      Log.error(TAG, 'No file exists');
      return undefined;
    }
    let text: Nullable<string> = FileUtils.readTextSync(path);
    if (!text) {
      Log.error(TAG, 'read text error');
      return undefined;
    }

    try {
      let res: Nullable<T> = JSON.parse(text);
      return res;
    } catch (err) {
      Log.error('parse catch exception, err = ', err);
      return undefined;
    }
  }

  /**
   * 将一个对象转换为Map。
   *
   * @param obj 要转换的对象。
   * @returns 一个Map，其中包含了对象的键值对。
   */
  export function objectToMap<R>(obj: ESObject): Map<string, R> {
    const map = new Map<string, R>();
    (Object.entries(obj) as Array<[string, R]>).forEach((entry) => {
      const key = entry[0];
      const value = entry[1] as R;
      map.set(key, value);
    });
    return map;
  }
}