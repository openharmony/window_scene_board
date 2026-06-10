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
import { VolumeControlConstants } from '../constants/VolumeControlConstants';
import { calculateSize } from '../constants/WifiConstants';
import { BrightnessManager } from '../manager/BrightnessManager';

const TAG = 'BrightnessControlComponent';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct BrightnessControlComponent {
  @State brightnessMgr: BrightnessManager = new BrightnessManager();
  @Consume windowSize: SizeOptions;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Slider({
        value: this.brightnessMgr.brightnessValue,
        min: this.brightnessMgr.minBrightnessValue,
        max: this.brightnessMgr.maxBrightnessValue,
        style: SliderStyle.NONE
      })
        .trackColor(VolumeControlConstants.VOLUME_CONTROL_TRACK_COLOR)
        .selectedColor(VolumeControlConstants.BUTTON_BACKGROUND_COLOR)
        .flexGrow(1)
        .flexShrink(1)
        .flexBasis(1)
        .trackThickness(VolumeControlConstants.VOLUME_CONTROL_HEIGHT)
        .width(VolumeControlConstants.FULL_SIZE)
        .onChange(async (value: number, mode: SliderChangeMode) => {
          if (mode === SliderChangeMode.Click || mode === SliderChangeMode.Moving) {
            log.showInfo(`setBrightnessValue to ${value},current mode is ${mode}`);
            this.brightnessMgr.setBrightnessValue(value);
          }
        })
      Row() {
        Image($r('app.media.glass_brightness_icon'))
          .width(VolumeControlConstants.VOLUME_CONTROL_IMAGE_WIDTH)
          .height(VolumeControlConstants.VOLUME_CONTROL_IMAGE_HEIGHT)
          .fillColor(VolumeControlConstants.CAPSULE_ICON_CLOSE_COLOR)
          .hitTestBehavior(HitTestMode.Transparent)
      }
      .height(calculateSize(this.windowSize.height as number, VolumeControlConstants.SLIDER_HEIGHT_SCALE))
      .width(calculateSize(this.windowSize.height as number, VolumeControlConstants.SLIDER_HEIGHT_SCALE))
      .justifyContent(FlexAlign.Center)
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .height(calculateSize(this.windowSize.height as number, VolumeControlConstants.SLIDER_HEIGHT_SCALE))
    .width(VolumeControlConstants.FULL_SIZE)
  }
}