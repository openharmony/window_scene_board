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

export class SysApiWrapper {
  /**
   * animateTo的代理，用于DT测试时替换animateTo的实现，解决animateTo无法测试问题
   */
  public static animateTo = (value: AnimateParam, event: () => void): void => {
    animateTo(value, event);
  }
  /**
   * setTimeout的代理，用于DT测试时替换setTimeout的实现，解决setTimeout异步执行导致用例失败问题
   */
  public static setTimeout = (handler: Function | string, delay?: number): number => {
    return setTimeout(handler, delay);
  }
}