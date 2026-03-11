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

/**
 * 模拟打桩工具类
 * <p>
 * 做为Mockkit的补充，Mockkit对对象方法的mock支持比较，对于非对象方法或其他特殊场景的mock可通过此工具类来实现
 * </p>
 */
export class MockUtil {
  private static clearFunctions = [];

  /**
   * 清空所有mock，恢复所有打桩对象到mock前的状态
   */
  public static clearAll() {
    let clearFunc: Function | undefined = this.clearFunctions.pop();
    while (clearFunc) {
      clearFunc();
      clearFunc = this.clearFunctions.pop();
    }
  }

  /**
   * 为对象方法打桩
   * <p>对Mockkit#mockFunc的补充，能够突破private修饰符的限制，实现对私有方法mock；
   * 推荐主要用于历史代码补充测试或重构前补充测试的场景，新开发的生产代码不推荐对private方法打桩</p>
   *
   * @param obj 需要打桩的对象
   * @param funcName 需要打桩的对象方法名
   * @param funcImpl 打桩的目标方法，默认值为空实现
   */
  public static mockFuncForObj(obj: Object, funcName: string, funcImpl: Function = () => {}) {
    const originImpl = obj[funcName];
    obj[funcName] = funcImpl;
    this.clearFunctions.push(() => {
      obj[funcName] = originImpl;
    });
  }
}