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

import { IBaseStateChangeListener } from './IBaseStateChangeListener';

// 基础类型
export type BaseObj = undefined | string | number | boolean | object;

/**
 * 抽象状态接口
 */
export interface IBaseState {
  /**
   * 注册状态切换监听器
   *
   * @param listener 监听器
   */
  registerStateChangeListener?(listener: IBaseStateChangeListener): void;

  /**
   * 注销状态切换监听器
   *
   * @param listener 监听器
   */
  unregisterStateChangeListener?(listener: IBaseStateChangeListener): void;

  /**
   * 状态类型，唯一标示
   *
   * @returns 唯一标示
   */
  getStateType(): string;

  /**
   * 设置单一状态值
   *
   * @param property 单一状态(映射成员变量)
   * @param value 状态值
   * @returns 链式
   */
  setStateValue(property: string, value: BaseObj): IBaseState;

  /**
   * 获取单一状态值
   *
   * @param property 单一状态
   * @param scene 取值场景
   * @returns 状态值
   */
  getStateValue(property: string, scene?: BaseObj): BaseObj;
}