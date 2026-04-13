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

import { CardAnimScene } from '../../../common/constants/ImmCardConst';
import { IImmLifeCycleAnimChain } from './IImmLifeCycleAnimChain';

/**
 * 沉浸大卡生命周期动效检测链条抽象
 */
export interface ICardLifeCycleAnimChain extends IImmLifeCycleAnimChain {
  /**
   * 添加检测链条
   *
   * @param nextChain 检测链条
   */
  addNextChain(nextChain: ICardLifeCycleAnimChain): void;

  /**
   * 检测生命周期动效
   *
   * @returns 动效场景，undefined表示检测不满足条件
   */
  checkLifeCycleAnim(): CardAnimScene | undefined;
}