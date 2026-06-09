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

import { HybridAnimParam } from '../constants/ImmComConst';
import { IImmBaseAnim } from './IImmBaseAnim';

/**
 * 沉浸模块联合动效抽象
 */
export interface IImmHybridAnim extends IImmBaseAnim {
  /**
   * 联合动效扩展参数
   *
   * @param param 扩展参数
   */
  setHybridAnimParam(param?: HybridAnimParam): void;

  /**
   * 打断动效
   */
  interruptAnim(): void;

  /**
   * 联合动效启动
   */
  onHybridAnim(): void;
}