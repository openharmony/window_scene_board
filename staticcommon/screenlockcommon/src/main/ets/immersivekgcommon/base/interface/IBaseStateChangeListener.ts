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
import { StateType } from '../constants/BaseType';

/**
 * 状态标识
 */
export interface IStateTag {
  /**
   * 监听状态类型
   */
  stateType: StateType;

  /**
   * 监听状态标识
   */
  stateId: string;
}

/**
 * 抽象状态切换监听器
 */
export interface IBaseStateChangeListener {
  /**
   * 监听器标识
   */
  listenerName?: string;

  /**
   * 监听状态类型
   */
  stateType?: StateType;

  /**
   * 监听状态标识
   */
  stateId?: string;

  /**
   * 状态切换回调
   *
   * @param stateType 状态类型
   * @param stateId 状态对象唯一标识
   * @param property 单一状态属性
   */
  onStateChange(stateType: StateType, stateId: string, property?: string): void;
}