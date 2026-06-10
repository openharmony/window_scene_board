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

export default class ControllerUtils {
  /**
   * 根据输入的key值自动获取映射出来的需要执行的函数合集
   *
   * @param keys 映射的key列表
   * @param methodsMap 映射大表格，里面的key包含入参的key
   * @returns 映射后需要执行的函数合集
   */
  public static getExecuteMethods(keys: Array<string>, methodsMap: Map<string, Array<Function>>): Set<Function> {
    let result: Set<Function> = new Set<Function>();
    keys.forEach(key => {
      let methods = methodsMap.get(key);
      if (methods !== undefined) {
        for (let method of methods) {
          result.add(method);
        }
      }
    });
    return result;
  }

}