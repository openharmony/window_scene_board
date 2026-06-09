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
// 波浪组件宽度
const WAVE_WIDTH: number = 32;
// 扫光波浪组件透明度
const MOVE_WAVE_OPACITY: number = 0.8;

/**
 * 进度类胶囊波浪状态，主要用于控制进度胶囊上层波浪相关状态
 */
@Observed
export class ProgressCapsuleWaveState {
  /**
   * 进度波浪左外边距
   */
  processWaveMarginLeft: number = -WAVE_WIDTH;
  /**
   * 移动波浪透明度
   */
  moveWaveOpacity: number = MOVE_WAVE_OPACITY;
  /**
   * 移动波浪左外边距
   */
  moveWaveMarginLeft: number = -WAVE_WIDTH;

  /**
   * 获取波浪组件宽度
   * @returns 宽度
   */
  getWaveWidth(): number {
    return WAVE_WIDTH;
  }

  resetMoveWaveParm(): void {
    this.moveWaveMarginLeft = -WAVE_WIDTH;
    this.moveWaveOpacity = MOVE_WAVE_OPACITY;
  }
}