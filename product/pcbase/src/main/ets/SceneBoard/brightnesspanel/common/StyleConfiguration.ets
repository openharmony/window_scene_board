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

const TAG = 'BrightnessPanel-StyleConfiguration';

export class BrightnessPanelComponentStyle {
  imageWidth: Length = $r('app.float.brightness_image_width');
  imageHeight: Length = $r('app.float.brightness_image_height');
  imageLeftMargin: Length = $r('app.float.brightness_image_left_margin');
  sliderWidth: Length = $r('app.float.brightness_slider_width');
  sliderHeight: Length = $r('app.float.brightness_panel_slider_height');

  sliderTrackThickness: Length = $r('app.float.brightness_slider_trackthickness_height');
  sliderTrackColor: ResourceColor = $r('sys.color.ohos_id_color_component_normal');
  sliderSelectedColor: ResourceColor = $r('sys.color.ohos_id_color_component_activated');

  sliderLeftMargin: Length = $r('app.float.brightness_slider_left_margin');
  sliderRadius: Length = $r('app.float.brightness_slider_radius');
  panelBorderRadius: Length = $r('app.float.brightness_panel_radius');

  panelWidth: Length = $r('app.float.brightness_panel_width');
  panelHeight: Length = $r('app.float.brightness_panel_height');

  panelBorderWidth: Length = $r('app.float.brightness_border_width');
  panelBorderColor: string = '#33ffffff';
  panelBorderLightColor: string = '#1a000000';
  panelBorderDarkColor: string = '#66000000';
}

export default class StyleConfiguration {
  static getBrightnessPanelComponentStyle(): BrightnessPanelComponentStyle {
    const key: string = TAG + '-BrightnessPanelComponent';
    return CommonStyleManager.getStyle(key, BrightnessPanelComponentStyle) as BrightnessPanelComponentStyle;
  }
}

