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
import { LiveRichTextModel } from '../../../model/LiveCommonModel';
import { LiveStyle } from '../../../constants/LiveStyle';
import { LiveCardOtherVm } from '../../../vm/LiveCardOtherVm';

@ObservedV2
export class LiveCardOtherDropdownVm extends LiveCardOtherVm {
  public flightCircleColor: ResourceColor = $r('sys.color.ohos_id_color_foreground');

  @Computed
  get dividerFgColor(): ResourceColor {
    return this.vmInjector.getColorVm()
      .calcSecondarySolidColor(this.dividerColor, this.vmInjector.getColorVm().dividerBrightness,
        this.vmInjector.getColorVm().liveBgPickColor);
  }

  @Computed
  get dividerBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().isSolidEnable() ? undefined :
    this.vmInjector.getColorVm().dividerBrightness;
  }

  get providerNameColor(): ResourceColor {
    return $r('sys.color.ohos_id_color_text_tertiary');
  }

  get titleFontColor(): ResourceColor | undefined {
    return $r('sys.color.ohos_id_color_text_primary');
  }

  get contentFontColor(): ResourceColor | undefined {
    return $r('sys.color.ohos_id_color_text_secondary');
  }

  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    return richText.textColor ?? LiveStyle.SYS_TEXT_COLOR_SECONDARY;
  }
}