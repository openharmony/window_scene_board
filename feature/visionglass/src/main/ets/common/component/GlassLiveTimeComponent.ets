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

import { LiveTimerData, LiveViewCommonConstants } from '@ohos/systemuicommon';

@Component
export struct GlassLiveTimeComponent {
  @ObjectLink timeData: LiveTimerData;
  @Prop viewFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  @Prop foreBrightnessOption: BrightnessOptions | undefined = undefined;
  private dateFormat: Date = new Date();
  private viewFontSize: Resource | string | number = $r('app.float.live_view_card_text_font_size');

  build() {
    if (this.timeData) {
      Text(this.getTimeText())
        .fontColor(this.viewFontColor)
        .fontSize(this.viewFontSize)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
  }

  private getTimeText(): string {
    return LiveViewCommonConstants.formatDate(this.timeData?.initialTime, this.dateFormat, this.timeData?.isCountDown);
  }
}