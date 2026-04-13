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
import { AnimationItem } from '@ohos/lottie';
import { ILiveHeadsUpCardVm } from './ILiveHeadsUpCardVm';

export interface ILiveHeadsUpFaceLockVm extends ILiveHeadsUpCardVm {
  componentId: string;

  borderRadius: number;

  translateY: number;

  width: number;

  height: number;

  successWidth: number;

  successHeight: number;

  scaleX: number;

  scaleY: number;

  backgroundColor: boolean;

  opacity: number;

  showRenderingSettings: RenderingContextSettings;

  showCanvasRenderingContext: CanvasRenderingContext2D;

  successRenderingSettings: RenderingContextSettings;

  successCanvasRenderingContext: CanvasRenderingContext2D;

  showAnimateItem: AnimationItem | null;

  showScaleX: number;

  showScaleY: number;

  showOpacity: number;

  successAnimateItem: AnimationItem | null;

  successScaleX: number;

  successScaleY: number;

  successOpacity: number;

  isSupport3DFace: boolean;

  playShowAnimation(): void;

  playSuccessAnimation(): void;

  destroyAnimation(name?: string): void;
}