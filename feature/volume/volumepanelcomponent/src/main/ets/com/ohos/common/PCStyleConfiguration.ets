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
import { AnimationSegment } from '@ohos/lottie';

import { CommonStyleManager } from '@ohos/systemuicommon';

const TAG = 'volumepanel-StyleConfiguration';

export class VolumePanelComponentStyle {
  public imageWidth: Length = $r('app.float.pc_volume_image_width');
  public imageHeight: Length = $r('app.float.pc_volume_image_height');
  public imageLeftMargin: Length = $r('app.float.pc_volume_image_left_margin');

  public sliderWidth: Length = $r('app.float.volume_slider_width');
  public sliderHeight: Length = $r('app.float.volume_slider_height');
  public sliderTrackThickness: Length = $r('app.float.volume_slider_trackthickness_height');
  public sliderTrackColor: ResourceColor = $r('sys.color.ohos_id_color_component_normal');
  public sliderSelectedColor: ResourceColor = $r('sys.color.ohos_id_color_component_activated');
  public sliderLeftMargin: Length = $r('app.float.volume_slider_left_margin');
  public sliderRadius: Length = $r('app.float.volume_slider_radius');

  public panelBorderRadius: Length = $r('app.float.pc_volume_panel_radius');
  public panelBorderWidth: Length = $r('app.float.pc_volume_border_width');
  public panelBorderColor: string = '#33ffffff';
  public panelBorderLightColor: string = '#1a000000';
  public panelBorderDarkColor: string = '#66000000';

}

export default class StyleConfiguration {
  public static getVolumePanelComponentStyle(): VolumePanelComponentStyle {
    const key: string = TAG + '-VolumePanelComponent';
    return CommonStyleManager.getStyle(key, VolumePanelComponentStyle);
  }
}
