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

import { AnimationViewData } from '../../common/viewmodel/AnimationViewData';
import curves from '@ohos.curves';

export interface FrameAnimationParam {
  /** 动效Id */
  animationId: string;

  /** 动效组件id */
  id: string;

  /** 开始延迟 */
  delay: number;

  /** 动画时长 */
  duration: number;

  /** 动效结束保持 */
  endDelay: number;

  /** 曲线插值器 */
  curves: curves.ICurve;

  /** 开始列表 */
  begins: number[];

  /** 目标列表 */
  targets: number[];

  /** 渲染回调 */
  onRender: (viewData: AnimationViewData, currentVal: number[]) => void
}

export interface FrameAnimationUpdateParam {
  /** 动效组件id */
  id?: string;

  /** 动效Id */
  animationId: string;

  /** 开始延迟 */
  delay?: number;

  /** 动画时长 */
  duration?: number;

  /** 开始延迟 */
  keep?: number;

  /** 曲线插值器 */
  curves?: curves.ICurve;

  /** 目标列表 */
  targets?: number[];
}