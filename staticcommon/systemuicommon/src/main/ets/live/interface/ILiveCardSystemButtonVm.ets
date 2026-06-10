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

import { LiveButtonModel } from '../model/LiveCommonModel';
import type { image } from '@kit.ImageKit';

/**
 * 系统实况按钮VM
 */
export interface ILiveCardSystemButtonVm {
  /**
   * 按钮大小
   */
  buttonSize: Length;
  /**
   * 按钮透明度
   */
  buttonOpacity: number | undefined;

  /**
   * 是否显示描边
   */
  isShowBorder: boolean;
  /**
   * 按钮背景色
   */
  buttonBgColor?: ResourceColor;
  /**
   * 按钮填充颜色
   */
  filterColor?: ColorFilter | undefined;

  /**
   * 获取按钮ID
   * @param button
   * @returns
   */
  getId(button: LiveButtonModel): string;

  /**
   * 获取按钮图标
   * @returns
   */
  getIcon(button: LiveButtonModel): image.PixelMap | undefined;

  /**
   * 获取按钮背景提亮
   */
  getButtonBgBrightness(button: LiveButtonModel): BrightnessOptions | undefined;

  /**
   * 获取按钮无提亮时的背景颜色
   */
  getLiveButtonNoBrightnessBgColor(buttonData: LiveButtonModel): ResourceColor | undefined;

    /**
   * 点击按钮
   * @param button
   */
  onClickButton(button: LiveButtonModel): void;
}