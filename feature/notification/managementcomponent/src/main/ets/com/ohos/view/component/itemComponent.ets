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

import ConfigData from '../../common/constants';
import { LengthMetrics } from '@ohos.arkui.node';
import { NtfSettingRtlUtil } from '../../common/NtfSettingRtlUtil';

const TAG = 'ManagementComponent-ItemComponent';
const COMPONENT_ID_TITLE = TAG + '_Text_title';
const COMPONENT_ID_VALUE = TAG + '_Text_value';
const COMPONENT_ID_ARROW = TAG + '_Image_arrow';

@Component
export default struct ItemComponent {
  @Prop title: Resource;
  @State value: string = '';
  @State arrow: Resource = $r('app.media.ic_settings_arrow');

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Row() {
        this.buildItemContent()
      }
      .width(ConfigData.WH_100_100)
      .alignItems(VerticalAlign.Center)
      .padding({
        left: $r('app.float.hover_Comp_margin_padding'),
        right: $r('app.float.hover_Comp_margin_padding')
      })
    }
    .width(ConfigData.WH_100_100)
    .constraintSize({ minHeight: $r('app.float.itemComp_height') })
  }

  @Builder
  buildItemContent() {
    Text(this.title).draggable(false)
      .id(COMPONENT_ID_TITLE)
      .fontSize($r('sys.float.ohos_id_text_size_body1'))
      .maxFontScale(2)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .width(ConfigData.WH_80_100)
      .textAlign(TextAlign.Start)
      .fontWeight(FontWeight.Medium)
    Blank()
    Text(this.value).draggable(false)
      .id(COMPONENT_ID_VALUE)
      .fontSize($r('app.float.itemComp_value_font'))
      .maxFontScale(2)
      .fontColor($r('app.color.itemComp_font_color'))
    Image(this.arrow).draggable(false)
      .id(COMPONENT_ID_ARROW)
      .width($r('app.float.itemComp_image_width'))
      .height($r('app.float.itemComp_image_height'))
      .align(Alignment.End)
      .margin({ start: LengthMetrics.resource($r('app.float.itemComp_image_margin_left')) })
      .fillColor($r('sys.color.ohos_id_color_fourth'))
      .rotate({ z: 1, angle: NtfSettingRtlUtil.getSystemRTL() ? 180 : 0})
  }
}