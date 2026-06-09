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
import { IBaseState } from './IBaseState';

/**
 * 状态可嵌套性
 */
export interface INestableState<T extends IBaseState> {
  /**
   * 添加子状态
   *
   * @param childStateName 子状态标识
   * @param childState 子状态
   * @returns 链式
   */
  addChildState(childState: T): INestableState<T>;

  /**
   * 移除子状态
   *
   * @param childStateName 子状态标识
   * @returns 链式
   */
  removeChildState(childStateName: string): INestableState<T>;

  /**
   * 获取子状态
   *
   * @param childStateName 子状态标识
   * @returns 子状态
   */
  getChildState(childStateName: string): T | undefined;
}