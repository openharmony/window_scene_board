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
import { LiveNotification } from '../model/LiveNotification';
import { LiveWeatherCapsuleView } from './LiveWeatherCapsuleView';
import { LiveCardFlightModel } from '../model/LiveCardFlightModel';
import { WeatherCapsuleType } from '../model/LiveWeatherModel';
import { ResourceVm } from '../../vm/ResourceVm'
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'FadedText';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 文字渐隐组件
 */
@ComponentV2
export struct FadedText {
  // 文本相关属性
  @Param text: string = '';
  @Param fontFamily: string | Resource = 'HarmonyHeiTi';
  @Param fontWeight: number | FontWeight | string = FontWeight.Bold;
  @Param fontSize: Length = $r('sys.float.ohos_id_text_size_sub_title1');
  @Param fontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  // 角标文本相关属性
  @Param badgeText: string = '';
  @Param badgeAccessibilityText: string = '';
  @Param badgeFontFamily: string | Resource = 'HarmonyHeiTi';
  @Param badgeFontWeight: number | FontWeight | string = FontWeight.Regular;
  @Param badgeFontSize: Length = $r('sys.float.ohos_id_text_size_caption');
  @Param badgeFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary');
  // 组件宽高
  @Param componentWidth: Length = '100%';
  @Param componentHeight: Length = 'auto';
  // 是否启用渐隐
  @Param isEllipsis: boolean = true;
  // 是否布局水平翻转
  @Param isReserve: boolean = false;
  // 是否文本镜像
  @Param isRTL: boolean = false;
  // 是否开启缓存组
  @Param isRenderGroup: boolean = false;

  @Param live?: LiveNotification | undefined = undefined;

  @Param weatherCapsuleType?: WeatherCapsuleType | undefined = undefined;

  @Local viewWidth: number = 0;
  @Local textWidth: Length = '100%';
  @Local ellipsisHeight: Length = 0;
  @Local badgePosition: Position | Edges | LocalizedEdges = { x: 0, y: 0 };

  private badgePositionDiff: Position = { x: 0, y: 0}

  aboutToAppear(): void {
    this.initBadgePositionDiff();
    this.isTextEllipsis();
  }

  build() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: this.checkWeatherInfo() ? FlexAlign.End : FlexAlign.Start,
      alignItems: this.checkWeatherInfo() ? ItemAlign.Center : ItemAlign.End,
    }) {
      if ((!this.live || !this.checkWeatherInfo()) && this.isReserve) {
        Row().layoutWeight(1)
      }
      if (this.live && this.checkWeatherInfo()) {
        LiveWeatherCapsuleView({ live: this.live, weatherCapsuleType: this.weatherCapsuleType })
      }
      Row() {
        Stack({ alignContent: ResourceVm.instance.isTextRTL(this.text) ? Alignment.Start : Alignment.End }) {
          Marquee({ src: this.text, start: false })
            .width(this.textWidth)
            .fontFamily(this.fontFamily)
            .fontWeight(this.fontWeight)
            .fontSize(this.fontSize)
            .fontColor(this.fontColor)
            .renderGroup(true)
          if (this.isEllipsis && this.isTextEllipsis()) {
            Column() {}
            .width(this.fontSize)
            .height(this.ellipsisHeight)
            .blendMode(7, BlendApplyType.OFFSCREEN)
            .linearGradient({
              direction: ResourceVm.instance.isTextRTL(this.text) ? GradientDirection.Left : GradientDirection.Right,
              colors: [[this.fontColor, 0], [Color.Transparent, 1]]
            })
          }
        }
        .direction(Direction.Ltr)
        .blendMode(4, BlendApplyType.OFFSCREEN)
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
      .justifyContent(FlexAlign.End)
      .displayPriority(2)

      if ((!this.live || !this.checkWeatherInfo()) && !this.isReserve) {
        Row().layoutWeight(1)
      }
    }
    .onAreaChange((oldValue: Area, newValue: Area) => {
      log.showInfo(`FadedText width changed, width: ${newValue.width}`);
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
    this.badgePositionDiff = {
      x: -1 * px2vp(size.width as number / 2),
      y: -1 * px2vp(size.height as number / 2),
    };
  }

  private isTextEllipsis(): boolean {
    const textSize = measure.measureTextSize({
      textContent: this.text,
      fontSize: this.fontSize,
      fontWeight: this.fontWeight,
      fontFamily: this.fontFamily
    })
    const textWidth = textSize.width as number ?? 0;
    const textHeight = textSize.height as number ?? 0;
    const viewWidth = vp2px(this.viewWidth);
    const isEllipsis = textWidth > viewWidth;

    this.textWidth = isEllipsis ? this.viewWidth : px2vp(textWidth);
    this.ellipsisHeight = px2vp(textHeight);
    this.badgePosition = {
      start: LengthMetrics.vp(this.textWidth + (this.badgePositionDiff.x as number)),
      top: LengthMetrics.vp(this.badgePositionDiff.y as number),
    }
    return isEllipsis;
  }

  private checkWeatherInfo(): boolean {
    if (!this.live) {
      return false;
    }
    if (!this.live.card.isFlightCard()) {
      return false;
    }
    if (!(this.live?.card as LiveCardFlightModel).liveCardWeatherInfo?.isWeatherCapsuleShow) {
      return false;
    }
    return true;
  }
}