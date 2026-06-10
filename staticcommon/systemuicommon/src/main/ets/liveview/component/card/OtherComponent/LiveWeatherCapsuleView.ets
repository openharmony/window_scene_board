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
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { LiveStyle } from '../../../../live/constants/LiveStyle';
import { LiveWeatherModel, WeatherCapsuleType } from '../../../../live/model/LiveWeatherModel';
import { BrightnessOptionUtils } from '../../../../template/newStyle/BrightnessOptionUtils';
import { ColorModeViewData } from '../../../../template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '../../../../template/newStyle/ColorModeViewModel';
import { LiveCardWeatherUtil } from '../../../../utils/LiveCardWeatherUtil';
import { SystemUIColorVm } from '../../../../vm/SystemUIColorVm';
import { ExtendStyle } from '../../../common/Extendstyle';
import { LiveViewExtendStyle } from '../../../data/extend/LiveViewExtendStyle';

/**
 * 三方卡片辅助区
 */
@Component
export struct LiveWeatherCapsuleView {
  @State weatherInfo?: LiveWeatherModel = undefined;
  @Prop weatherCapsuleType: WeatherCapsuleType | undefined = undefined;
  private extendStyle: ExtendStyle = new LiveViewExtendStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  private getLiveExtendButtonBgColor(): ResourceColor | undefined {
    return $r('app.color.theme_ntf_phone_remaind_bg_color');
  }

  private getTextColor(): ResourceColor | undefined {
    return this.extendStyle?.textColor;
  }

  private isRenderGroup(): boolean {
    return true;
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
                .fontColor([this.getTextColor()])
                .fontWeight(FontWeight.Regular)
                .fontSize(LiveStyle.WEATHER_CAPSULE_ICON_MIN_SIZE)
            }
            .direction(Direction.Ltr)
            .maxFontScale(1)
            .maxLines(1)
            .minFontSize(LiveStyle.WEATHER_CAPSULE_ICON_MIN_SIZE)
            .maxFontSize(LiveStyle.WEATHER_CAPSULE_ICON_MIN_SIZE)
          } else {
            Text(this.weatherInfo?.highTemperature + '°' + '/' + this.weatherInfo?.lowTemperature + '°')
              .fontFamily('HarmonyHeiTi')
              .fontWeight(FontWeight.Regular)
              .maxFontScale(1)
              .maxFontSize(LiveStyle.WEATHER_CAPSULE_TEXT_MIN_SIZE)
              .minFontSize(LiveStyle.WEATHER_CAPSULE_TEXT_MIN_SIZE)
              .fontFeature('\"ss08\" on')
              .fontColor(this.getTextColor())
              .foregroundBrightness(this.colorModeViewData.foregroundSecondaryOption)
              .opacity(undefined)
              .textAlign(TextAlign.Center)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .renderGroup(this.isRenderGroup())
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
        maxWidth: this.extendStyle?.capsuleButtonMaxWidth,
        maxHeight: this.extendStyle?.capsuleButtonHeight,
      })
      .backgroundColor(this.getLiveExtendButtonBgColor())
      .backgroundBrightnessInternal(SystemUIColorVm.instance.weatherButtonBrightness)
    }
    .height(16)
    .displayPriority(1)
    .accessibilityLevel(this.weatherCapsuleType === WeatherCapsuleType.WEATHER_ICON ? 'no' : 'yes')
    .accessibilityGroup(true)
    .accessibilityText(LiveCardWeatherUtil.instance.getAccessibilityTemperatureText(this.weatherInfo?.highTemperature,
      this.weatherInfo?.lowTemperature))
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .borderRadius($r('app.float.live_view_extend_border_radius'))
    .clip(true)
  }
}