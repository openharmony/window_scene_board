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
 * 位状态工具类
 */
export class BitStatesUtil {
  /**
   * 是否包含某种状态
   * @param states 总值
   * @param value  某一状态值
   * @returns
   */
  public static hasState(states: number, value: number): boolean {
    return (states & value) !== 0;
  }

  /**
   * 添加某种状态
   * @param states
   * @param value
   * @returns
   */
  public static addState(states: number, value: number): number {
    if (BitStatesUtil.hasState(states, value)) {
      return states;
    }
    return (states | value);
  }

  /**
   * 删除某种状态
   * @param states
   * @param value
   * @returns
   */
  public static removeState(states: number, value: number): number {
    if (!BitStatesUtil.hasState(states, value)) {
      return states;
    }
    return (states ^ value);
  }
}