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

import { IImmBaseAnim } from './IImmBaseAnim';

/**
 * 沉浸锁屏模块动效工厂抽象层
 */
export interface IImmAnimFactory<T extends IImmBaseAnim, S = string> {
  /**
   * 创建动效实例
   *
   * @param animScene 动效场景
   * @returns 动效实例
   */
  createImmAnim(animScene: S): T | undefined;
}