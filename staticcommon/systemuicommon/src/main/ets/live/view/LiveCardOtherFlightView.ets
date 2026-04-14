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

import { image } from '@kit.ImageKit';
import { LengthMetrics } from '@kit.ArkUI';
import { CommonUtils } from '@ohos/basicutils';
import { LiveCardFlightModel } from '../model/LiveCardFlightModel';
import { SystemUIColorVm } from '../../vm/SystemUIColorVm';
import { LiveNotification } from '../model/LiveNotification';
import { ILiveCardOtherVm } from '../interface/ILiveCardOtherVm';
import { FlightLayoutSpaceType } from '../../liveview/common/LiveConstants';
import { FadedText } from './LiveFadedTextView';
import { ResourceVm } from '../../vm/ResourceVm';
import { ILiveCardOtherFlightVm } from '../interface/ILiveCardOtherFlightVm';
import { LiveStyle } from '../constants/LiveStyle';
import { WeatherCapsuleType } from '../model/LiveWeatherModel';

export interface LiveCardOtherFlightViewParam {
  live: LiveNotification;
  cardInfo: LiveCardFlightModel;
  cardVm: ILiveCardOtherVm;
  cardFlightVm: ILiveCardOtherFlightVm;
  colorVm: SystemUIColorVm;
}

@Builder
export function LiveCardOtherFlightView($$: LiveCardOtherFlightViewParam) {
  if ($$.live) {
    Column() {
      Divider()
        .width('100%')
        .height('1px')
        .color($$.cardVm.dividerFgColor)
        .foregroundBrightness($$.cardVm.dividerBrightness)
        .visibility($$.cardInfo?.layoutIsDisplayHorizontalLine ? Visibility.Visible : Visibility.None)
        .alignSelf(ItemAlign.Start)

      // 用来占位，使得下面的元素底部排列
      Row().layoutWeight(1)

      buildInformation($$)

      buildAdditionalText($$)
    }
    .width('100%')
    .height(72)
    .opacity($$.cardVm.extendOpacity)
    .padding({
      left: 12,
      right: 12,
    })
  }
}

@Builder
function buildInformation($$: LiveCardOtherFlightViewParam) {
  Row() {
    Column() {
      FadedText({
        text: $$.cardInfo?.layoutFirstTitle,
        fontFamily: 'HarmonyHeiTi',
        fontWeight: FontWeight.Bold,
        fontSize: $$.cardFlightVm.layoutTitleSize,
        fontColor: $$.cardFlightVm.layoutTitleColor,
        isRTL: $$.cardFlightVm.isLayoutFirstRTL,
        isRenderGroup: true,
      })
        .margin($$.cardFlightVm.layoutTitleMargin)
      FadedText({
        text: $$.cardInfo?.layoutFirstContent,
        fontFamily: 'HarmonyHeiTi',
        fontWeight: FontWeight.Regular,
        fontSize: $$.cardFlightVm.layoutContentSize,
        fontColor: $$.cardFlightVm.layoutContentColor,
        isRTL: $$.cardFlightVm.isLayoutFirstRTL,
        isRenderGroup: $$.cardVm.contentRenderGroup,
      })
    }
    .alignItems(HorizontalAlign.Start)
    .layoutWeight(1)

    buildSpaceContent($$)

    Column() {
      FadedText({
        text: $$.cardInfo?.layoutLastTitle,
        fontFamily: 'HarmonyHeiTi',
        fontWeight: FontWeight.Bold,
        fontSize: $$.cardFlightVm.layoutTitleSize,
        fontColor: $$.cardFlightVm.layoutTitleColor,
        badgeText: $$.cardFlightVm.layoutLastTitleBadgeText,
        badgeAccessibilityText: $$.cardFlightVm.layoutLastTitleBadgeAccessibilityText,
        badgeFontSize: ResourceVm.instance.getNumberVp(LiveStyle.FLIGHT_BADGE_FONT_SIZE),
        badgeFontColor: $$.cardFlightVm.layoutTitleColor,
        isRTL: $$.cardFlightVm.isLayoutLastRTL,
        isRenderGroup: true,
        isReserve: true,
        live: $$.live,
        weatherCapsuleType: WeatherCapsuleType.WEATHER_ICON,
      })
        .margin($$.cardFlightVm.layoutTitleMargin)
      FadedText({
        text: $$.cardInfo?.layoutLastContent,
        fontFamily: 'HarmonyHeiTi',
        fontWeight: FontWeight.Regular,
        fontSize: $$.cardFlightVm.layoutContentSize,
        fontColor: $$.cardFlightVm.layoutContentColor,
        badgeText: $$.cardFlightVm.layoutLastContentBadgeText,
        badgeAccessibilityText: $$.cardFlightVm.layoutLastContentBadgeAccessibilityText,
        badgeFontSize: ResourceVm.instance.getNumberVp(LiveStyle.FLIGHT_BADGE_FONT_SIZE),
        badgeFontColor: $$.cardFlightVm.layoutContentColor,
        isRTL: $$.cardFlightVm.isLayoutLastRTL,
        isRenderGroup: $$.cardVm.contentRenderGroup,
        isReserve: true,
        live: $$.live,
        weatherCapsuleType: WeatherCapsuleType.WEATHER_TEMPERATURE,
      })
    }
    .alignItems(HorizontalAlign.End)
    .layoutWeight(1)
  }
  .width('100%')
  .padding({ left: 4, right: 4 })
  .alignItems(VerticalAlign.Center)
}

@Builder
function buildSpaceContent($$: LiveCardOtherFlightViewParam) {
  if (!CommonUtils.isInvalid($$.cardInfo?.layoutSpaceIcon) || !CommonUtils.isInvalid($$.cardInfo?.layoutSpaceText)) {
    if ($$.cardInfo?.layoutSpaceType === FlightLayoutSpaceType.SPACE_TYPE_TEXT) {
      if (CommonUtils.isInvalid($$.cardInfo?.layoutSpaceText) || !$$.cardInfo?.layoutSpaceText) {
        buildSpaceIcon($$)
      } else {
        buildSpaceText($$)
      }
    } else {
      if (CommonUtils.isInvalid($$.cardInfo?.layoutSpaceIcon)) {
        buildSpaceText($$)
      } else {
        buildSpaceIcon($$)
      }
    }
  } else {
    buildSpaceCircle($$)
  }
}

@Builder
function buildSpaceText($$: LiveCardOtherFlightViewParam) {
  Row() {
    if (!$$.cardInfo?.layoutSpaceText?.length) {
      buildSpaceCircle($$)
    } else {
      buildSpaceTextDivider($$.cardFlightVm.layoutSpaceTextBorderColor)

      Text($$.cardInfo?.layoutSpaceText)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .fontSize(ResourceVm.instance.getNumberVp(LiveStyle.FLIGHT_SPACE_TEXT_FONT_SIZE))
        .fontColor($$.cardFlightVm.layoutSpaceTextColor)
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .wordBreak(WordBreak.BREAK_ALL)
        .constraintSize({
          maxWidth: LiveStyle.FLIGHT_SPACE_TEXT_MAX_WIDTH,
          minWidth: ResourceVm.instance.getNumberVp(LiveStyle.FLIGHT_SPACE_TEXT_FONT_SIZE),
          minHeight: ResourceVm.instance.getNumberVp(LiveStyle.FLIGHT_SPACE_TEXT_FONT_SIZE),
        })
        .padding({
          left: LiveStyle.FLIGHT_SPACE_TEXT_PADDING_X,
          right: LiveStyle.FLIGHT_SPACE_TEXT_PADDING_X,
          top: LiveStyle.FLIGHT_SPACE_TEXT_PADDING_Y,
          bottom: LiveStyle.FLIGHT_SPACE_TEXT_PADDING_Y,
        })
        .border({
          width: $r('app.float.live_view_card_flight_space_text_border_width'),
          radius: $r('app.float.live_view_card_flight_space_text_border_radius'),
          color: $$.cardFlightVm.layoutSpaceTextBorderColor,
        })

      buildSpaceTextDivider($$.cardFlightVm.layoutSpaceTextBorderColor)
    }
  }
  .margin({
    left: LiveStyle.FLIGHT_SPACE_TEXT_MARGIN_X,
    right: LiveStyle.FLIGHT_SPACE_TEXT_MARGIN_X
  })
  .justifyContent(FlexAlign.Center)
  .alignItems(VerticalAlign.Center)
}

@Builder
function buildSpaceTextDivider(color?: ResourceColor) {
  Row()
    .height($r('app.float.live_view_card_flight_space_text_divider_height'))
    .width($r('app.float.live_view_card_flight_space_text_divider_width'))
    .backgroundColor(color)
}

@Builder
function buildSpaceIcon($$: LiveCardOtherFlightViewParam) {
  if ($$.cardInfo?.layoutSpaceIconRes?.endsWith('.svg')) {
    buildSpaceIconWithSvg($$)
  } else if ($$.cardInfo?.layoutSpaceIcon) {
    buildSpaceIconWithPng($$)
  } else {
    buildSpaceCircle($$)
  }
}

@Builder
function buildSpaceIconWithPng($$: LiveCardOtherFlightViewParam) {
  Image($$.cardInfo.layoutSpaceIcon)
    .objectFit(ImageFit.ScaleDown)
    .width(64)
    .height(32)
    .margin({
      left: $r('app.float.live_view_card_content_margin_right'),
      right: $r('app.float.live_view_card_content_margin_right')
    })
    .scale({
      x: $$.cardFlightVm.layoutSpaceContentScale,
      y: $$.cardFlightVm.layoutSpaceContentScale,
    })
    .draggable(false)
    .interpolation(ImageInterpolation.Medium)
    .visibility($$.cardInfo.layoutSpaceIcon ? Visibility.Visible : Visibility.Hidden)
}

@Builder
function buildSpaceCircle($$: LiveCardOtherFlightViewParam) {
  Row({ space: 4 }) {
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), $$);
  }
  .height($r('app.float.live_view_card_flight_svg_size'))
  .margin({
    left: $r('app.float.live_view_card_content_margin_right'),
    right: $r('app.float.live_view_card_content_margin_right')
  })
  .alignItems(VerticalAlign.Center)
  .justifyContent(FlexAlign.Center)
}

@Builder
function buildSpaceIconWithSvg($$: LiveCardOtherFlightViewParam) {
  Row({ space: 4 }) {
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), $$);
    if ($$.cardInfo.layoutSpaceIcon) {
      Image($$.cardInfo.layoutSpaceIcon)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .height($r('app.float.live_view_card_flight_svg_size'))
        .width($r('app.float.live_view_card_flight_svg_size'))
    }
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), $$);
    buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), $$);
  }
  .scale({
    x: $$.cardFlightVm.layoutSpaceContentScale,
    y: $$.cardFlightVm.layoutSpaceContentScale,
  })
  .height($r('app.float.live_view_card_flight_svg_size'))
  .margin({
    left: $r('app.float.live_view_card_content_margin_right'),
    right: $r('app.float.live_view_card_content_margin_right')
  })
  .alignItems(VerticalAlign.Center)
  .justifyContent(FlexAlign.Center)
}

@Builder
function buildCircle(opacityResourse: Resource, $$: LiveCardOtherFlightViewParam) {
  Circle()
    .fill($$.cardVm.flightCircleColor)
    .width($r('app.float.live_view_card_flight_circle_size'))
    .height($r('app.float.live_view_card_flight_circle_size'))
    .opacity(ResourceVm.instance.getNumber(opacityResourse))
}

@Builder
function buildAdditionalText($$: LiveCardOtherFlightViewParam) {
  Row() {
    Text($$.cardInfo?.layoutAdditionalText ?? '')
      .fontSize(ResourceVm.instance.getNumberVp($r('sys.float.ohos_id_text_size_caption1')))
      .fontColor($$.cardFlightVm.layoutAdditionalTextColor)
      .fontWeight(FontWeight.Regular)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
  }
  .width('100%')
  .height(14)
  .padding({ left: 4, right: 4 })
  .margin({ bottom: 4 })
  .justifyContent(FlexAlign.Center)
  .alignItems(VerticalAlign.Center)
}