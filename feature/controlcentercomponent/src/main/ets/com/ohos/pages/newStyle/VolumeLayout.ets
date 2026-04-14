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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import StyleConfiguration, { LargeFoldSliderButtonStyle } from '../../common/StyleConfiguration';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { VolumeSliderButton } from '@ohos/soundcomponent/Index';

const TAG = 'Ctrl.VolumeLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct VolumeLayout {
  private style: LargeFoldSliderButtonStyle = StyleConfiguration.getLargeFoldSliderButtonStyle()
  private isLongSliderButton = false;
  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;

  aboutToAppear() {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
  }

  build() {
    Column() {
      if (this.controlCenterState !== ControlCenterState.SOUND_SUB_PAGE) {
        VolumeSliderButton({
          isLargeFoldStyle: this.isLongSliderButton,
        })
          .id('brightnessSliderButton')
          .visibility(this.backgroundOpacity.backgroundOpacity === 1 ? Visibility.Visible : Visibility.Hidden)
      } else {
        Stack().size({
          width: this.style.newCardWidth,
          height: this.style.newCardHeight,
        })
      }
    }
    .opacity(this.animationData.opacity)
    .scale({
      x: this.animationData.scale,
      y: this.animationData.scale
    })
    .translate({ y: this.animationData.itemTranslate + Math.max(this.animationData.translate, 0) })
  }
}
