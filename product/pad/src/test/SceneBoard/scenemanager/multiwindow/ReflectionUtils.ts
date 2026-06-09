/**
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
// The created class is treated as map types to store attributes and methods.
// obj represents the created instance.
// attrName represents the name of property or function.
export class ReflectionUtils {
  /*
   * Use private function, ...args represent input parameters.
   * function usage guidelines:
   * e.g., private replaceSceneParam(oldSession: SCBSceneSession, session: SCBSceneSession): void {};
   * ReflectionUtils.useFunc(filledState, 'replaceSceneParam', primarySession, primarySession);
   */
  static useFunc(obj:any, funcName: string, ...args: any[]):any {
    if (funcName in obj) {
      return obj[funcName](...args);
    } else {
      throw new Error(`Attribute ${funcName} not found in ${obj.constructor.name}`);
    }
  }
  // Set private property of obj.
  static setProperty(obj: any, attrName: string, value: any): void {
    if (attrName in obj) {
      obj[attrName] = value;
    } else {
      throw new Error(`Attribute ${attrName} not found in ${obj.constructor.name}`);
    }
  }
  // Get private property of obj.
  static getProperty(obj: any, attrName: string): any {
    if (attrName in obj) {
      return obj[attrName];
    } else {
      throw new Error(`Attribute ${attrName} not found in ${obj.constructor.name}`);
    }
  }
}

export function creatObject<T>(arr: T[], object?: any): T {
  if (object) {
    return object as T;
  }
  return {} as T;
}