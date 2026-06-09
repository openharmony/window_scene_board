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

import { CommonStyleManager } from '@ohos/systemuicommon';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';

const TAG = 'brightness-StyleConfiguration';

export class BrightnessComponentStyle {
  public marginTop: number = ResUtils.getConvertNumber($r('app.float.brightness_margin_top'));
  public paddingLeft: number = ResUtils.getConvertNumber($r('app.float.brightness_padding_left'));
  public paddingRight: number = ResUtils.getConvertNumber($r('app.float.brightness_padding_right'));
  public componentGap: number = ResUtils.getConvertNumber($r('app.float.brightness_component_gap'));
  public brightnessIconColor: ResourceColor = $r('sys.color.ohos_id_color_secondary');
  public brightnessReduceWidth: number = ResUtils.getConvertNumber($r('app.float.brightness_reduce_width'));
  public brightnessReduceHeight: number = ResUtils.getConvertNumber($r('app.float.brightness_reduce_height'));
  public brightnessPlusWidth: number = ResUtils.getConvertNumber($r('app.float.brightness_plus_width'));
  public brightnessPlusHeight: number = ResUtils.getConvertNumber($r('app.float.brightness_plus_height'));
  public brightnessHeight: number = ResUtils.getConvertNumber($r('app.float.brightness_height'));
  public sliderHeight: number = ResUtils.getConvertNumber($r('app.float.brightness_slider_height'));
  public sliderBlockColor: ResourceColor = $r('app.color.brightness_slider_block_color');
  public sliderTrackColor: ResourceColor = $r('app.color.batch_modif_id_color_component_normal');
  public sliderSelectedColor: ResourceColor = $r('app.color.batch_modif_id_color_emphasize');
}

export default class StyleConfiguration {
  static getBrightnessComponentStyle(): BrightnessComponentStyle {
    const key: string = TAG + '-BrightnessComponent';
    return CommonStyleManager.getStyle(key, BrightnessComponentStyle);
  }
}