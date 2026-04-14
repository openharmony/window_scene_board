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
import { LiveOtherExtendData } from '../data/extend/LiveOtherExtendData';

export interface ExtendStyle {
  /**
   * 三方辅助区宽高
   */
  extendWidth?: number;
  extendHeight?: number;

  /**
   * 导航辅助区宽高
   */
  navExtendWidth?: number;
  navExtendHeight?: number;

  /**
   * 普通文本参数
   */
  normalTextWidth?: number;
  normalTextHeight?: number;
  normalTextMaxFont?: number;
  normalTextMinFont?: number;
  textColor?: ResourceColor;

  /**
   * 胶囊文本参数
   */
  capsuleButtonWidth?: number | Resource | Length;
  capsuleButtonMaxWidth?: number | Resource | Length;
  capsuleButtonHeight?: number | Resource | Length;
  capsuleButtonTextHeight?: number;
  capsuleButtonTopMargin?: number;
  capsuleButtonLeftMargin?: number;
  capsuleBackgroundColor?: ResourceColor;

  /**
   * 系统按钮参数
   */
  buttonSpace?: number;
  buttonHeight?: number;
  buttonLength?: number;
  buttonBorderRadius?: number;
  buttonBackground?: ResourceColor;
  buttonColor?: ResourceColor;

  /**
   * 进度按钮参数
   */
  progressHeight?: number | Resource | Length;
  progressWidth?: number | Resource | Length;
  progressStrokeWidth?: number | Resource | Length;
  progressBackgroundColor?: ResourceColor;
  progressColor?: ResourceColor;

  onExtentClick?: (data?: LiveOtherExtendData, clickCount?: number) => void;
}