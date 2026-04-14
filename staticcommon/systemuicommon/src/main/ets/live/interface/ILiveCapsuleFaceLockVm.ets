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
import { ILiveCapsuleVm } from './ILiveCapsuleVm';

export enum ShowStage {
  SHOW = 0,
  UPDATE = 1,
  HIDE = 2,
}

export interface ILiveCapsuleFaceLockVm extends ILiveCapsuleVm {
  successWidth: number;
  successHeight: number;
  showScaleX: number;
  showScaleY: number;
  showOpacity: number;
  successScaleX: number;
  successScaleY: number;
  successOpacity: number;
  showRenderingSettings?: RenderingContextSettings;
  showCanvasRenderingContext?: CanvasRenderingContext2D;
  successRenderingSettings?: RenderingContextSettings;
  successCanvasRenderingContext?: CanvasRenderingContext2D;
  showStage: ShowStage;
  showAnimateName: string;
  isOnTree: boolean;

  showFaceLock(isNeedAnimation?: boolean): Promise<void>;

  playShowAnimation(): void;

  playSuccessAnimation(): void;

  hideFaceLock(): void;

  destroyAnimation(name?: string): void;
}