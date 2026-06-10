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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lazy StyleConfiguration, {
  ControlCenterLongButtonLayoutStyle,
  SingleFoldLongButtonStyle,
  SingleExpandLongButtonStyle
} from '../../common/StyleConfiguration';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import BrightnessSliderButton from './BrightnessSliderButton';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { VolumeSliderButton } from '@ohos/soundcomponent/Index';

const TAG = 'Ctrl.VolumeAndBrightLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

@Component
export default struct VolumeAndBrightLayout {
  private style: ControlCenterLongButtonLayoutStyle | SingleFoldLongButtonStyle | SingleExpandLongButtonStyle =
    StyleConfiguration.getControlCenterLongButtonLayoutStyle();
  private isSingleFoldStyle = false;
  private isLandscape: boolean = AppStorage.get<boolean>('isLandscape') ?? false;
  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @Prop isShowButton: boolean = true;

  aboutToAppear() {
    log.showInfo(`aboutToAppear`);
    if (this.isSingleFoldStyle) {
      this.style = StyleConfiguration.getSingleFoldLongButtonStyle();
    }
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
  }

  build() {
    Column() {
      Row({ space: this.style.space }) {
        if ((this.isSingleFoldStyle || this.controlCenterState !== ControlCenterState.SOUND_SUB_PAGE) &&
          this.isShowButton) {
          VolumeSliderButton({
            isSingleFoldStyle: this.isSingleFoldStyle,
            geometryTag: this.isSingleFoldStyle ? 'volumeSingleFold' : 'volume'
          })
            .id('volumeSliderButton')
            .visibility(this.backgroundOpacity.backgroundOpacity === 1 ? Visibility.Visible : Visibility.Hidden);
        } else {
          Stack().size({
            width: this.style.newCardWidth,
            height: this.style.newCardHeight,
          })
        }

        if ((this.isSingleFoldStyle || this.controlCenterState !== ControlCenterState.BRIGHTNESS_SUBPAGE) &&
          this.isShowButton) {
          BrightnessSliderButton({
            isSingleFoldStyle: this.isSingleFoldStyle,
            geometryTag: this.isSingleFoldStyle ? 'brightnessSingleFold' : 'brightness'
          }).id('brightnessSliderButton');
        } else {
          Stack().size({
            width: this.style.newCardWidth,
            height: this.style.newCardHeight,
          })
        }
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

