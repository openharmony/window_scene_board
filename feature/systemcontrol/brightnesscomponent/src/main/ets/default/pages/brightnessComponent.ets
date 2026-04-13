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

import { setBrightValue, ControlBrightnessManager } from '../ControlBrightnessManager';
import StyleConfiguration, { BrightnessComponentStyle } from '../common/StyleConfiguration';
import { Log } from '@ohos/basicutils';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import taskpool from '@ohos.taskpool';

const TAG = 'Control-brightnessComponent';
const COMPONENT_ID_BRIGHTNESS_REDUCE = TAG + '_Image_brightnessReduce';
const COMPONENT_ID_BRIGHTNESS_REDUCE_PLUS = TAG + '_Image_brightnessReducePlus';
const COMPONENT_ID_BRIGHTNESS_SLIDER = TAG + '_Slider_brightnessSlider';

class BrightnessItem {
  public min: number = 0
  public max: number = 0
  public value: number = 0
}

@Component
export default struct MyBrightness {
  @StorageLink('BrightnessValue') brightnessValue: number = 0;
  @State style: BrightnessComponentStyle = StyleConfiguration.getBrightnessComponentStyle();
  @State brightnessItem: BrightnessItem = {
    min: ControlBrightnessManager.getInstance().getMin(),
    max: ControlBrightnessManager.getInstance().getMax(),
    value: ControlBrightnessManager.getInstance().getDefault()
  };

  private isSliding: boolean = false;

  aboutToAppear() {
    Log.showDebug(TAG, 'Brightness aboutToAppear');
  }

  aboutToDisappear() {
    Log.showDebug(TAG, 'aboutToDisappear');
  }

  build() {
    Row() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_brightness_reduce')).draggable(false)
          .size({ width: this.style.brightnessReduceWidth,
            height: this.style.brightnessReduceHeight })
          .fillColor(this.style.brightnessIconColor)
          .id(COMPONENT_ID_BRIGHTNESS_REDUCE)
      }
      .width(this.style.brightnessPlusWidth)
      .height('100%')

      Row() {
        Slider({
          value: this.brightnessValue,
          min: this.brightnessItem.min,
          max: this.brightnessItem.max,
          step: 1,
          style: SliderStyle.InSet
        })
          .width('100%')
          .trackThickness(this.style.sliderHeight)
          .blockColor(this.style.sliderBlockColor)
          .trackColor(this.style.sliderTrackColor)
          .selectedColor(this.style.sliderSelectedColor)
          .focusable(false)
          .onChange((value: number, mode: SliderChangeMode) => {
            ControlBrightnessManager.getInstance().sliderChangeMode = mode;
            let continuous: boolean = (mode === SliderChangeMode.Begin) || (mode === SliderChangeMode.Moving);
            if (!continuous) {
              Log.showInfo(TAG, `brightness slide end, mode = ${mode}`)
            }
            try {
              taskpool.execute(setBrightValue, value, continuous).catch((e: object) => {
                Log.error(TAG, e);
              });
            } catch (error) {
              Log.error('taskpool execute error', error);
            }
            if (mode == SliderChangeMode.Moving) {
              this.isSliding = true
            }
            if (mode === SliderChangeMode.End) {
              this.brightnessValue = value;
            };
            HiDfxEventUtil.reportBrightnessDrag(value);
          })
          .onTouch((event) => {
            if (event?.type == TouchType.Move && this.isSliding == true) {
              if (event?.stopPropagation != undefined) {
                event?.stopPropagation();
              }
            } else if (event?.type == TouchType.Down) {
              this.isSliding = false
            }
          })
          .id(COMPONENT_ID_BRIGHTNESS_SLIDER)
      }
      .margin({left: this.style.componentGap, right: this.style.componentGap})
      .height('100%')
      .layoutWeight(1)
      .priorityGesture(PanGesture({direction: PanDirection.Vertical}))

      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_brightness_plus')).draggable(false)
          .size({ width: this.style.brightnessPlusWidth,
            height: this.style.brightnessPlusHeight })
          .fillColor(this.style.brightnessIconColor)
          .id(COMPONENT_ID_BRIGHTNESS_REDUCE_PLUS)
      }
      .width(this.style.brightnessPlusWidth)
      .height(this.style.brightnessPlusWidth)
    }
    .margin({top: this.style.marginTop})
    .width('100%')
    .height(this.style.brightnessHeight)
  }
}