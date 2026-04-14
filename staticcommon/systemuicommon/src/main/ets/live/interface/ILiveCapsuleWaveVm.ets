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

export interface ILiveCapsuleWaveVm {
  /**
   * 波浪图片
   */
  waveImageResource: Resource;
  /**
   * 进度波浪左外边距
   */
  processWaveMarginLeft: number;
  /**
   * 移动波浪透明度
   */
  moveWaveOpacity: number;
  /**
   * 移动波浪左外边距
   */
  moveWaveMarginLeft: number;
  /**
   * 是否显示
   */
  isVisible: boolean;
  /**
   * 刷新进度波浪位置
   */
  refreshProgressWaveMarginLeft(): void;
  /**
   * 组件下树时，销毁扫光
   */
  destroy(): void;
}
