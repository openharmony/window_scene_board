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

import measure from '@ohos.measure';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveWeatherModel, WeatherCapsuleType } from '../../../../live/model/LiveWeatherModel';
import { LiveWeatherCapsuleView } from './LiveWeatherCapsuleView';

interface TextProps {
  text?: string;
  fontFamily?: string | Resource;
  fontWeight?: number | FontWeight | string;
  fontSize?: Length;
  fontColor?: ResourceColor;
}

const BLEND_MODE_SRC_OVER: number = 4;

/**
 * 文字渐隐组件
 */
@Component
export struct FadedText {
  @Prop @Watch('isTextEllipsis') textProps: TextProps = {
    text: '',
    fontFamily: 'HarmonyHeiTi',
    fontWeight: FontWeight.Bold,
    fontSize: $r('sys.float.ohos_id_text_size_sub_title1'),
    fontColor: $r('sys.color.ohos_id_color_text_primary'),
  };
  @Prop fadedFontColor: ResourceColor | undefined = '#FFFFFFFF';
  @Prop badgeText: string = '';
  @Prop badgeAccessibilityText: string = '';
  @Prop badgeFontFamily: string | Resource = 'HarmonyHeiTi';
  @Prop badgeFontWeight: number | FontWeight | string = FontWeight.Regular;
  @Prop badgeFontSize: Length = $r('sys.float.ohos_id_text_size_caption');
  @Prop badgeFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  @Prop componentWidth: Length = '100%';
  @Prop componentHeight: Length = 'auto';
  @Prop isReserve: boolean = false;
  @Prop isRTL: boolean = false;
  @State weatherInfo?: LiveWeatherModel = undefined;
  @Prop weatherCapsuleType: WeatherCapsuleType | undefined = undefined;

  @State @Watch('isTextEllipsis') viewWidth: number = 0;
  @State textWidth: Length = '100%';
  @State isEllipsis: boolean = false;
  @State ellipsisHeight: Length = 0;
  @State badgePosition: Position | Edges | LocalizedEdges = { x: 0, y: 0 };

  private badgePositionDiffX = 0;
  private badgePositionDiffY = 0;

  aboutToAppear(): void {
    this.initBadgePositionDiff();
    this.isTextEllipsis();
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: this.weatherInfo?.isWeatherCapsuleShow ? FlexAlign.End : FlexAlign.Start,
      alignItems: this.weatherInfo?.isWeatherCapsuleShow ? ItemAlign.Center : ItemAlign.End,
    }) {
      if (this.isReserve) {
        Row().layoutWeight(1)
      }
      if (this.weatherInfo?.isWeatherCapsuleShow) {
        LiveWeatherCapsuleView({ weatherInfo: this.weatherInfo, weatherCapsuleType: this.weatherCapsuleType});
      }
      Row(){
        Stack({ alignContent: this.isRTL ? Alignment.Start : Alignment.End }) {
          Marquee({ src: this.textProps.text, start: false })
            .width(this.textWidth)
            .fontFamily(this.textProps.fontFamily)
            .fontWeight(this.textProps.fontWeight)
            .fontSize(this.textProps.fontSize)
            .fontColor(this.isEllipsis ? this.fadedFontColor : this.textProps.fontColor)
          if (this.isEllipsis){
            Column() {}
            .width(this.textProps.fontSize)
            .height(this.ellipsisHeight)
            .blendMode(7, BlendApplyType.OFFSCREEN)
            .linearGradient({
              direction: this.isRTL ? GradientDirection.Left : GradientDirection.Right,
              colors: [[this.textProps.fontColor, 0], [Color.Transparent, 1]]
            })
          }
        }
        .direction(Direction.Ltr)
        .blendMode(this.isEllipsis ? BLEND_MODE_SRC_OVER : BlendMode.NORMAL, BlendApplyType.OFFSCREEN)
        .clip(true)

        if (this.badgeText) {
          Text(this.badgeText)
            .direction(this.isRTL ? Direction.Rtl : Direction.Ltr)
            .accessibilityText(this.badgeAccessibilityText)
            .fontFamily(this.badgeFontFamily)
            .fontWeight(this.badgeFontWeight)
            .fontSize(this.badgeFontSize)
            .fontColor(this.badgeFontColor)
            .position(this.badgePosition)
            .maxLines(1)
        }
      }
      .displayPriority(2)
      .flexGrow(1)

      if (!this.isReserve) {
        Row().layoutWeight(1)
      }
    }
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.viewWidth = newValue.width as number;
    })
    .width(this.componentWidth)
    .height(this.componentHeight)
  }

  private initBadgePositionDiff(): void {
    const size = measure.measureTextSize({
      textContent: ' ',
      fontSize: this.badgeFontSize,
      fontWeight: this.badgeFontWeight,
      fontFamily: this.badgeFontFamily
    });
    this.badgePositionDiffX = -1 * px2vp(size.width as number / 2);
    this.badgePositionDiffY = -1 * px2vp(size.height as number / 2)
  }

  private isTextEllipsis(): void {
    const textSize = measure.measureTextSize({
      textContent: this.textProps.text,
      fontSize: this.textProps.fontSize,
      fontWeight: this.textProps.fontWeight,
      fontFamily: this.textProps.fontFamily
    })
    const textWidth = textSize.width as number ?? 0;
    const textHeight = textSize.height as number ?? 0;
    const viewWidth = vp2px(this.viewWidth);

    this.isEllipsis = textWidth > viewWidth;
    this.textWidth = this.isEllipsis ? this.viewWidth : px2vp(textWidth);
    this.ellipsisHeight = px2vp(textHeight);
    this.badgePosition = {
      start: LengthMetrics.vp(this.textWidth + this.badgePositionDiffX),
      top: LengthMetrics.vp(this.badgePositionDiffY),
    }
  }
}