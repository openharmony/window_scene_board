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
import { GlassVolumeModel } from '../../../volume/Index';
import { VolumeControlConstants } from '../constants/VolumeControlConstants';
import { calculateSize } from '../constants/WifiConstants';

const TAG: string = 'GlassVolumeModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct VolumeControlComponent {
  @State volumeInstance: GlassVolumeModel = new GlassVolumeModel();
  @Consume windowSize: SizeOptions;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.volumeInstance.init();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.volumeInstance.unInit();
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Slider({
        value: this.volumeInstance.volumeValue,
        min: this.volumeInstance.minVolumeValue,
        max: this.volumeInstance.maxVolumeValue,
        style: SliderStyle.NONE
      })
        .trackColor(VolumeControlConstants.VOLUME_CONTROL_TRACK_COLOR)
        .selectedColor(VolumeControlConstants.BUTTON_BACKGROUND_COLOR)
        .flexGrow(1)
        .flexShrink(1)
        .flexBasis(1)
        .trackThickness(VolumeControlConstants.VOLUME_CONTROL_HEIGHT)
        .width(VolumeControlConstants.FULL_SIZE)
        .onChange((value: number) => {
          this.volumeInstance.setVolume(value);
        })
      Row() {
        Image($r('app.media.glass_ic_public_volume_filled'))
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