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

import { i18n } from '@kit.LocalizationKit';
import { LengthMetrics } from '@ohos.arkui.node';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { RTLUtil } from '@ohos/componenthelper';
import { LiveFlightTemplate } from '../../../data/template/LiveFlightTemplate';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { NotificationType } from '../../../../constants/NotificationType';
import { FlightLayoutSpaceType, LayoutStyle } from '../../../common/LiveConstants';
import { FadedText } from './FlightFadedText';
import { ColorModeViewData } from '../../../../template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '../../../../template/newStyle/ColorModeViewModel';
import { ColorModeLiveViewData } from '../../../../template/newStyle/ColorModeLiveViewData';
import { WeatherCapsuleType } from '../../../../live/model/LiveWeatherModel';

const TAG = 'LiveFlightComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 扩展区为左右文本模板：比如列车检票提醒
 */
@Component
export struct FlightComponent {
  @ObjectLink @Watch('onTemplateChange') data: LiveFlightTemplate;
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State colorModeLiveViewData: ColorModeLiveViewData = ColorModeViewModel.getInstance().getLiveViewData();
  @Prop dividerBrightnessOption?: BrightnessOptions;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  @Prop isSmallFoldOuterScreen: boolean = false;

  @State loadImgError: boolean = false;

  private onTemplateChange(): void {
    log.showInfo(`template data change`);
    this.loadImgError = false;
  }
  build() {
    if (this.data) {
      Column() {
        Divider()
          .width('100%')
          .height('1px')
          .color(this.colorModeViewData.calcSecondarySolidColor($r('app.color.live_card_divider_bg_color'),
            this.dividerBrightnessOption, this.colorModeLiveViewData.liveBgPickColor))
          .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined : this.dividerBrightnessOption)
          .visibility(this.getDividerVisibility())
          .alignSelf(ItemAlign.Start)

        // 用来占位，使得下面的元素底部排列
        Row().layoutWeight(1)

        this.buildInformation()

        this.buildAdditionalText()
      }
      .width('100%')
      .height(this.isSmallFoldOuterScreen ? 46 : 72)
      .opacity(undefined)
      .padding(this.isSmallFoldOuterScreen ? undefined : {
        left: 12,
        right: 12,
      })
    }
  }

  @Builder
  buildInformation() {
    Row() {
      Column() {
        FadedText({
          textProps: {
            text: this.data?.firstTitle,
            fontFamily: 'HarmonyHeiTi',
            fontWeight: FontWeight.Bold,
            fontSize: this.getTitleFontSize(),
            fontColor: this.getTitleFontColor(),
          },
          isRTL: this.isRTL([this.data?.firstTitle, this.data?.firstContent]),
        })
          .margin(this.getTitleMargin())
        FadedText({
          textProps: {
            text: this.data?.firstContent,
            fontFamily: 'HarmonyHeiTi',
            fontWeight: FontWeight.Regular,
            fontSize: this.getContentFontSize(),
            fontColor: this.getContentFontColor(),
          },
          isRTL: this.isRTL([this.data?.firstTitle, this.data?.firstContent]),
        })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      this.buildSpaceContent()

      Column() {
        FadedText({
          textProps: {
            text: this.data?.lastTitle,
            fontFamily: 'HarmonyHeiTi',
            fontWeight: FontWeight.Bold,
            fontSize: this.getTitleFontSize(),
            fontColor: this.getTitleFontColor(),
          },
          badgeText: this.getBadgeText(this.data?.lastTitleSuperscript),
          badgeAccessibilityText: this.getBadgeAccessibilityText(this.data?.lastTitleSuperscript),
          badgeFontSize: this.getNumberVp($r('sys.float.ohos_id_text_size_caption')),
          badgeFontColor: this.getTitleFontColor(),
          isRTL: this.isRTL([this.data?.lastTitle, this.data?.lastContent]),
          isReserve: true,
          weatherInfo: this.data.liveCardWeatherInfo,
          weatherCapsuleType: WeatherCapsuleType.WEATHER_ICON,
        })
          .margin(this.getTitleMargin())
        FadedText({
          textProps: {
            text: this.data?.lastContent,
            fontFamily: 'HarmonyHeiTi',
            fontWeight: FontWeight.Regular,
            fontSize: this.getContentFontSize(),
            fontColor: this.getContentFontColor(),
          },
          badgeText: this.getBadgeText(this.data?.lastContentSuperscript),
          badgeAccessibilityText: this.getBadgeAccessibilityText(this.data?.lastContentSuperscript),
          badgeFontSize: this.getNumberVp($r('sys.float.ohos_id_text_size_caption')),
          badgeFontColor: this.getContentFontColor(),
          isRTL: this.isRTL([this.data?.lastTitle, this.data?.lastContent]),
          isReserve: true,
          weatherInfo: this.data.liveCardWeatherInfo,
          weatherCapsuleType: WeatherCapsuleType.WEATHER_TEMPERATURE,
        })
      }
      .alignItems(HorizontalAlign.End)
      .layoutWeight(1)
    }
    .width('100%')
    .height(this.isSmallFoldOuterScreen ? 40 : undefined)
    .padding(this.isSmallFoldOuterScreen ? undefined : { left: 4, right: 4 })
    .alignItems(this.isSmallFoldOuterScreen ? VerticalAlign.Bottom : VerticalAlign.Center)
  }

  @Builder
  buildSpaceContent() {
    if (!CommonUtils.isInvalid(this.data?.spaceIcon) || !CommonUtils.isInvalid(this.data?.spaceText)) {
      if (this.data?.spaceType === FlightLayoutSpaceType.SPACE_TYPE_TEXT) {
        if (CommonUtils.isInvalid(this.data?.spaceText) || !this.data?.spaceText?.length) {
          this.buildSpaceIcon()
        } else {
          this.buildSpaceText()
        }
      } else {
        if (CommonUtils.isInvalid(this.data?.spaceIcon)) {
          this.buildSpaceText()
        } else {
          this.buildSpaceIcon()
        }
      }
    } else {
      this.buildSpaceCircle();
    }
  }

  @Builder
  buildSpaceText() {
    if (!this.data?.spaceText?.length) {
      this.buildSpaceCircle()
    } else {
      Row() {
        Row()
          .height($r('app.float.live_view_card_flight_space_text_divider_height'))
          .width($r('app.float.live_view_card_flight_space_text_divider_width'))
          .backgroundColor(this.getSpaceTextBorderColor())

        Row() {
          Text(this.data?.spaceText)
            .fontFamily('HarmonyHeiTi')
            .fontWeight(FontWeight.Regular)
            .fontSize(this.getNumberVp($r('sys.float.ohos_id_text_size_body3')))
            .fontColor(this.getSpaceTextFontColor())
            .textAlign(TextAlign.Center)
            .maxLines(1)
            .wordBreak(WordBreak.BREAK_ALL)
        }
        .constraintSize({
          maxWidth: $r('app.float.live_view_card_flight_space_text_max_width'),
          minWidth: this.getNumberVp($r('sys.float.ohos_id_text_size_body3')),
          minHeight: this.getNumberVp($r('sys.float.ohos_id_text_size_body3')),
        })
        .padding({
          left: $r('app.float.live_view_card_flight_space_text_padding_horizontal'),
          right: $r('app.float.live_view_card_flight_space_text_padding_horizontal'),
          top: $r('app.float.live_view_card_flight_space_text_padding_vertical'),
          bottom: $r('app.float.live_view_card_flight_space_text_padding_vertical'),
        })
        .border({
          width: $r('app.float.live_view_card_flight_space_text_border_width'),
          radius: $r('app.float.live_view_card_flight_space_text_border_radius'),
          color: this.getSpaceTextBorderColor(),
        })

        Row()
          .height($r('app.float.live_view_card_flight_space_text_divider_height'))
          .width($r('app.float.live_view_card_flight_space_text_divider_width'))
          .backgroundColor(this.getSpaceTextBorderColor())
      }
      .margin({
        left: $r('app.float.live_view_card_flight_space_text_margin'),
        right: $r('app.float.live_view_card_flight_space_text_margin')
      })
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
  }

  @Builder
  buildSpaceIcon() {
    if (this.data?.spaceIconRes?.endsWith('.svg')) {
      this.buildSpaceIconWithSvg()
    } else if (this.data?.spaceIcon && !this.loadImgError) {
      this.buildSpaceIconWithPng()
    } else {
      this.buildSpaceCircle()
    }
  }

  @Builder
  buildSpaceIconWithPng() {
    Image(this.data?.spaceIcon)
      .objectFit(ImageFit.ScaleDown)
      .constraintSize({
        maxWidth: 64,
        maxHeight: 32
      })
      .margin({
        left: $r('app.float.live_view_card_content_margin_right'),
        right: $r('app.float.live_view_card_content_margin_right')
      })
      .scale({
        x: this.getSpaceImageScale(),
        y: this.getSpaceImageScale(),
      })
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
      .visibility(this.data?.spaceIcon ? Visibility.Visible : Visibility.Hidden)
      .onError((e) => {
        log.showError(`LoadImg error: ${e}`)
        this.loadImgError = true;
      })
  }
  @Builder
  buildSpaceCircle() {
    Row() {
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), false);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), false);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), false);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), false);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), false);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), false);
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
  buildSpaceIconWithSvg() {
    Row() {
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), false);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), false);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), false);
      if (this.data?.spaceIcon) {
        Image(this.data?.spaceIcon)
          .objectFit(ImageFit.Contain)
          .draggable(false)
          .interpolation(ImageInterpolation.Medium)
          .height($r('app.float.live_view_card_flight_svg_size'))
          .width($r('app.float.live_view_card_flight_svg_size'))
      }
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_3'), true);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_2'), true);
      this.buildCircle($r('app.float.live_view_card_flight_circle_opacity_1'), true);
    }
    .scale({
      x: this.getSpaceImageScale(),
      y: this.getSpaceImageScale(),
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
  buildCircle(opacityResourse: Resource, isReversal: boolean){
    Circle()
      .fill($r('sys.color.ohos_id_color_foreground'))
      .width($r('app.float.live_view_card_flight_circle_size'))
      .height($r('app.float.live_view_card_flight_circle_size'))
      .margin(isReversal ? {
        start: LengthMetrics.resource($r('app.float.live_view_card_flight_circle_size'))
      } : {
        end: LengthMetrics.resource($r('app.float.live_view_card_flight_circle_size'))
      })
      .opacity(ResUtils.getNumber(opacityResourse))
  }

  @Builder
  buildAdditionalText() {
    Row() {
      Text(this.data.additionalText ?? '')
        .fontSize(this.getNumberVp($r('sys.float.ohos_id_text_size_caption')))
        .fontColor($r('app.color.flight_template_additional_text_color'))
          // [n1]指定数字一个个读
        .accessibilityText('[n1]' + (this.data.additionalText ?? ''))
        .fontWeight(FontWeight.Regular)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(14)
    .padding({ left: 4, right: 4 })
    .margin(this.isSmallFoldOuterScreen ? undefined : { bottom: 4 })
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  private getDividerVisibility(): Visibility {
    if (this.isSmallFoldOuterScreen) {
      return Visibility.Hidden;
    }
    return this.data?.isDisplayHorizontalLine ? Visibility.Visible : Visibility.None;
  }

  private getTitleFontSize(): Length {
    if (this.isSmallFoldOuterScreen) {
      return '18vp';
    }
    if (this.data?.style === LayoutStyle.SUB_TYPE_BALANCE) {
      return this.getNumberVp($r('sys.float.ohos_id_text_size_sub_title1'));
    } else {
      return this.getNumberVp($r('sys.float.ohos_id_text_size_headline7'));
    }
  }

  private getTitleFontColor(): ResourceColor | undefined {
    if (this.data?.style === LayoutStyle.SUB_TYPE_BALANCE) {
      return $r('app.color.flight_template_title_color');
    } else {
      return $r('sys.color.ohos_id_color_text_primary');
    }
  }

  private getSpaceImageScale(): number {
    return this.data.liveCardWeatherInfo?.isWeatherCapsuleShow ? 0.9 : 1;
  }

  private getTitleMargin(): Margin | undefined {
    if (this.data?.style === LayoutStyle.SUB_TYPE_BALANCE) {
      return { bottom: $r('app.float.live_view_card_flight_title_margin_bottom') };
    } else {
      return undefined;
    }
  }

  private getContentFontSize(): Length {
    if (this.isSmallFoldOuterScreen) {
      return '12vp';
    }
    if (this.data?.style === LayoutStyle.SUB_TYPE_BALANCE) {
      return this.getNumberVp($r('sys.float.ohos_id_text_size_body1'));
    } else {
      return this.getNumberVp($r('sys.float.ohos_id_text_size_body3'));
    }
  }

  private getContentFontColor(): ResourceColor | undefined {
    if (this.data?.style === LayoutStyle.SUB_TYPE_BALANCE) {
      return $r('app.color.flight_template_title_color');
    } else {
      return $r('sys.color.ohos_id_color_text_secondary');
    }
  }

  private getSpaceTextFontColor(): ResourceColor | undefined {
    return $r('app.color.flight_template_space_text_color');
  }

  private getSpaceTextBorderColor(): ResourceColor | undefined {
    return $r('app.color.flight_template_space_text_border_color');
  }

  // 限制格式为+X
  private getBadgeText(text: string | undefined): string {
    if (!text) {
      return '';
    }
    const badgeText = text.slice(0, 2);
    return /\+\d/.test(badgeText) ? badgeText : '';
  }

  // 在符号后加[n0]，可将语境分离，+X不会读成正X
  private getBadgeAccessibilityText(text: string | undefined): string {
    let badgeAccessibilityText = this.getBadgeText(text);
    return badgeAccessibilityText ? badgeAccessibilityText.split('').join('[n0]') : '';
  }

  private isRTL(strings: Array<string | undefined>): boolean {
    return strings.some(text => {
      const str = text?.replaceAll(/[\d\s\.\+-:]/g, '') ?? '';
      if (!str) {
        return RTLUtil.isRTL();
      }
      return i18n.Unicode.isRTL(str);
    });
  }

  // 直接使用资源会被系统字体大小影响
  private getNumberVp(resource: Resource): string {
    return ResUtils.getNumber(resource) + 'vp';
  }
}