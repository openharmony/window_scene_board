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

/**
 * 系统实况进度环VM
 */
export interface ILiveCardSystemProgressVm {
  /**
   * 进度值
   */
  progressValue: number;
  /**
   * 进度环高度
   */
  progressHeight: Length;
  /**
   * 进度环宽度
   */
  progressWidth: Length;
  /**
   * 进度环线条填充颜色
   */
  progressStrokeWidth: Length;
  /**
   * 进度透明度
   */
  progressOpacity: number | undefined;

  /**
   * 是否展示进度文本
   */
  isShowText: boolean;

  /**
   * 是否显示中间的按钮
   */
  isShowButton: boolean;
  /**
   * 中间按钮是否处于暂停态
   */
  isButtonPaused: boolean;
  /**
   * 进度环颜色
   */
  getProgressColor(): ResourceColor;
  /**
   * 点击中间的按钮
   * @param live
   */
  onClickButton(): void;
  /**
   * 获取进度环背景提亮
   */
  getProgressBgBrightness(): BrightnessOptions | undefined;

  /**
   * 获取进度环无提亮时的背景颜色
   */
  getLiveProgressNoBrightnessBgColor(): ResourceColor | undefined;
}