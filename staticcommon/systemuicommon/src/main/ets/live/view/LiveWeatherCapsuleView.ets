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
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveVmInjector } from '../LiveVmInjector';
import { ILiveCardOtherExtendVm } from '../interface/ILiveCardOtherExtendVm';
import { LiveNotification } from '../model/LiveNotification';
import { BaseGesture } from '../../vm/BaseGesture';
import { LiveCardWeatherUtil } from '../../utils/LiveCardWeatherUtil';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveWeatherModel, WeatherCapsuleType } from '../model/LiveWeatherModel';
import { LiveCardFlightModel } from '../model/LiveCardFlightModel';

@ComponentV2
export struct LiveWeatherCapsuleView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;
  @Param weatherCapsuleType: WeatherCapsuleType | undefined = undefined;

  @Computed
  get extendVm(): ILiveCardOtherExtendVm {
    return this.liveVmInjector.getCardOtherExtendVm(this.live);
  }

  @Computed
  get weatherInfo(): LiveWeatherModel | undefined {
    return (this.live.card as LiveCardFlightModel).liveCardWeatherInfo;
  }

  @Computed get baseGesture(): BaseGesture {
    const gesture = new BaseGesture();
    if (this.extendVm?.tapGesture) {
      gesture.addGesture(this.extendVm.tapGesture);
    }
    return gesture;
  }

  build() {
    Row() {
      Button({
        type: ButtonType.Capsule,
        stateEffect: true
      }) {
        Row({ space: 2 }) {
          if (this.weatherCapsuleType === WeatherCapsuleType.WEATHER_ICON) {
            Text() {
              SymbolSpan(LiveCardWeatherUtil.instance.getWeatherImage(this.weatherInfo?.weatherType).resource)
                .fontColor([this.extendVm?.textColor])
                .fontWeight(FontWeight.Normal)
                .fontSize(LiveStyle.WEATHER_CAPSULE_ICON_MIN_SIZE)
            }
            .accessibilityLevel('no')
            .direction(Direction.Ltr)
            .maxFontScale(1)
            .maxLines(1)
            .minFontSize(LiveStyle.WEATHER_CAPSULE_ICON_MIN_SIZE)
            .maxFontSize(LiveStyle.WEATHER_CAPSULE_ICON_MIN_SIZE)
            .height('100%')
          } else {
            Text(this.weatherInfo?.highTemperature + '°' + '/' + this.weatherInfo?.lowTemperature + '°')
              .fontFamily('HarmonyHeiTi')
              .fontWeight(FontWeight.Normal)
              .maxFontSize(LiveStyle.WEATHER_CAPSULE_TEXT_MIN_SIZE)
              .minFontSize(LiveStyle.WEATHER_CAPSULE_TEXT_MIN_SIZE)
              .maxFontScale(1)
              .fontFeature('\"ss08\" on')
              .fontColor(this.extendVm?.textColor)
              .foregroundBrightness(this.extendVm?.fontFgBrightness)
              .opacity(this.extendVm?.buttonTextOpacity)
              .accessibilityLevel('no')
              .textAlign(TextAlign.Center)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .renderGroup(this.extendVm?.isRenderGroup)
              .direction(Direction.Ltr)
          }
        }
        .margin({
          top: LengthMetrics.vp(LiveStyle.WEATHER_CAPSULE_MARGIN),
          bottom: LengthMetrics.vp(LiveStyle.WEATHER_CAPSULE_MARGIN),
          end: LengthMetrics.vp(LiveStyle.WEATHER_CAPSULE_RIGHT_MARGIN),
          start: LengthMetrics.vp(LiveStyle.WEATHER_CAPSULE_RIGHT_MARGIN)
        })
      }
      .margin({
        end: LengthMetrics.vp(4)
      })
      .constraintSize({
        minWidth: this.weatherCapsuleType === WeatherCapsuleType.WEATHER_ICON ? LiveStyle.WEATHER_ICON_MIN_WIDTH :
          undefined,
        minHeight: 16,
        maxWidth: this.extendVm?.capsuleButtonMaxWidth,
        maxHeight: this.extendVm?.capsuleButtonHeight,
      })
      .backgroundColor(this.extendVm?.weatherButtonBgColor)
      .backgroundBrightnessInternal(this.extendVm?.weatherButtonBrightness)
    }
    .height(16)
    .displayPriority(1)
    .accessibilityLevel(this.weatherCapsuleType === WeatherCapsuleType.WEATHER_ICON ? 'no' : 'yes')
    .accessibilityText(LiveCardWeatherUtil.instance.getAccessibilityTemperatureText(this.weatherInfo?.highTemperature,
      this.weatherInfo?.lowTemperature))
    .accessibilityGroup(true)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .borderRadius($r('app.float.live_view_extend_border_radius'))
    .clip(true)
    .gestureModifier(this.baseGesture)
  }
}