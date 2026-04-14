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

import { CommonStyleManager } from '@ohos/systemuicommon';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'BrightnessPanel-StyleConfiguration';

export class BrightnessPanelComponentStyle {
  public brightnessBorderRadius: number = ResUtils.getConvertNumber($r('app.float.pad_brightness_borderRadius'));
  public brightnessWidth: number = ResUtils.getConvertNumber($r('app.float.pad_brightness_width'));
  public brightnessHeight: number = ResUtils.getNumber($r('app.float.pad_brightness_height'));
  public sliderLeftMargin: number = ResUtils.getConvertNumber($r('app.float.brightness_slider_left_margin'));
  public panelWidth: number = ResUtils.getConvertNumber($r('app.float.brightness_panel_width'));
  public panelHeight: number = ResUtils.getConvertNumber($r('app.float.brightness_panel_height'));
  public panelTop: number = ResUtils.getNumber($r('app.float.brightness_panel_top'));
  public sliderRadius: number = ResUtils.getConvertNumber($r('app.float.brightness_slider_radius'));
  public imageWidth: number = ResUtils.getNumber($r('app.float.brightness_image_width'));
  public imageHeight: number = ResUtils.getNumber($r('app.float.brightness_image_height'));
  public panelBorderWidth: number = ResUtils.getConvertNumber($r('app.float.brightness_border_width'));

  public sunFillColor: string = '#80000000';
  public brightnessBlockColor: string = '#FFFFFFFF';
  public brightnessBgColor: string = '#FF000000';
}

export default class StyleConfiguration {
  static getBrightnessPanelComponentStyle(): BrightnessPanelComponentStyle {
    const key: string = TAG + '-BrightnessPanelComponent';
    return CommonStyleManager.getStyle(key, BrightnessPanelComponentStyle) as BrightnessPanelComponentStyle;
  }
}
