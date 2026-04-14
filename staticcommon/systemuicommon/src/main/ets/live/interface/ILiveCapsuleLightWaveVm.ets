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
import { AnimateParams } from '../../animation/AnimationBase';

export interface ILiveCapsuleLightWaveVm {

  /**
   * 光波是否显示
   */
  lightShow: boolean;

  /**
   * 光波透明度
   * @returns
   */
  positionX: number;

  /**
   * 光波动效
   * @returns
   */
  doWaveAnim(delay?: number, lightOffset?: number): AnimateParams[];

  /**
   * 设置光波出现初始值
   * @param 光波初始位置offset（胶囊宽度）
   */
  setAnimStartState(offset: number): void;

  /**
   * 光波动效结束后重置
   * @param 光波初始位置offset（胶囊宽度）
   */
  setAnimFinishState(): void;
}
