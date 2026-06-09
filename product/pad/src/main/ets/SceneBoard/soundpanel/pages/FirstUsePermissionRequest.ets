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
import TextHelpUtils, { SpanInfo } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/TextHelpUtils';
import { DataConstants, SettingsKeyConstants, StyleConstants, TimeUtil } from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/CommonUtils';
import XmlParseUtil from '@ohos/pcbase/src/main/ets/SceneBoard/microphonepanel/util/XmlParseUtil';
import SettingsUtil from '@ohos/pcbase/src/main/ets/SceneBoard/soundpanel/util/SettingsUtil';

const TAG: string = 'FirstUsePermissionRequest';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const maxLines: number = 1
const buttonLayoutWeight: number = 1;
const needScrollBarHeight: number = 2;
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
export default struct FirstUsePermissionRequest {
  @State buttonFontSize: Length = $r('sys.float.ohos_id_text_size_button1');
  @State spanData: SpanInfo[] = [];
  @State backButtonColor: ResourceColor = Color.Transparent;
  private textHelper: TextHelpUtils = new TextHelpUtils();
  private isClose_: boolean = false;
  private textIndex: number = 1;
  private swiperController: SwiperController = new SwiperController();
  private isSupport: boolean = XmlParseUtil.getLogSupport();

  private closeWindow() {
    if (this.isClose_) {
      return;
    }
    getContext().eventHub.emit('closeFirstUseWindow');
    this.isClose_ = true;
  }

  aboutToAppear(): void {
    log.info(TAG, 'aboutToAppear');
    this.textHelper.parseContent(this.textIndex).then((result: SpanInfo[]) => {
      this.spanData = result;
    });
  }

  aboutToDisappear(): void {
    log.info(TAG, 'aboutToDisappear');
    this.closeWindow();
  }

  build() {
    Column() {
      Column() {
        this.SwiperContent()
      }
      .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
      .width(StyleConstants.DEFAULT_DIALOG_WIDTH)
      .height(StyleConstants.DEFAULT_DIALOG_HEIGHT)
      .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  FirstPage(): void {
    Column() {
      this.IntroduceDescription();
      Column() {
        this.BuildContent();
        this.ButtonBuild();
      }
      .margin({ top: StyleConstants.BUTTON_MARGIN_TOP })
      .layoutWeight(1)
      .justifyContent(FlexAlign.End)
    }
  }

  @Builder
  SecondPage(): void {
    Column() {
      this.BuildPageTitleBar();
      PermissionDetailPage();
    }
  }

  @Builder
  SwiperContent(): void {
    Column() {
      Swiper(this.swiperController) {
        this.FirstPage();
        this.SecondPage();
      }
      .loop(false)
      .indicator(false)
    }
    .width(StyleConstants.DEFAULT_DIALOG_WIDTH)
    .height(StyleConstants.DEFAULT_DIALOG_HEIGHT)
  }

  @Builder
  BuildPageTitleBar() {
    Row() {
      Column() {
        Image($r('app.media.ic_public_left_back'))
          .width(StyleConstants.BACK_IC_WIDTH)
          .height(StyleConstants.BACK_IC_HEIGHT)
          .fillColor($r('sys.color.ohos_id_color_titlebar_text'))
          .matchTextDirection(true)
          .draggable(false)
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .margin({ top: StyleConstants.BACK_IC_MARGIN, bottom: StyleConstants.BACK_IC_MARGIN })
      .width(StyleConstants.BACK_IC_SIZE)
      .height(StyleConstants.BACK_IC_SIZE)
      .backgroundColor(this.backButtonColor)
      .borderRadius($r('sys.float.corner_radius_level4'))
      .onHover((isHover: boolean) => {
        if (isHover) {
          this.backButtonColor = $r('sys.color.interactive_hover');
        } else {
          this.backButtonColor = Color.Transparent;
        }
      })
      .onTouch((event?: TouchEvent) => {
        if (event && event.type === TouchType.Down) {
          this.backButtonColor = $r('sys.color.interactive_pressed');
        } else if (event && event.type === TouchType.Up) {
          this.backButtonColor = Color.Transparent;
        }
      })
      .onClick(() => {
        this.swiperController.showPrevious();
      })
    }
    .height(StyleConstants.HEARD_MARGIN)
    .width(StyleConstants.DEFAULT_DIALOG_WIDTH)
    .padding({ left: StyleConstants.BACK_IC_MARGIN, right: StyleConstants.BACK_IC_MARGIN })
  }

  @Builder
  BuildContent(): void {
    Scroll() {
      Column() {
        this.PermissionDescription()
      }
      .width('100%')
    }
    .align(Alignment.BottomEnd)
    .layoutWeight(1)
    .scrollBar(BarState.Auto)
    .width('100%')
  }

  @Builder
  IntroduceDescription() {

    Text(this.isSupport ? $r('app.string.sound') : $r('app.string.sound'))
      .margin({ top: this.isSupport ? StyleConstants.SUPPORTED_HEARD_MARGIN : StyleConstants.HEARD_MARGIN })
      .fontWeight(FontWeight.Medium)
      .textAlign(TextAlign.Center)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .maxLines(maxLines)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .lineHeight(StyleConstants.TITLE_TEXT_LINEHEIGHT)
      .minFontSize(StyleConstants.TEXT_MINFONTSIZE)
      .maxFontSize(StyleConstants.TEXT_MAXFONTSIZE)
      .draggable(false)
      .padding({
        left: StyleConstants.TEXT_PADDING,
        right: StyleConstants.TEXT_PADDING
      })

    Text($r('app.string.audio_privacy_hint'))
      .margin({ top: StyleConstants.PRIVACY_MARGIN })
      .fontWeight(FontWeight.Regular)
      .textAlign(TextAlign.Center)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .maxLines(maxLines)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .lineHeight(StyleConstants.TEXT_LINEHEIGHT)
      .minFontSize(StyleConstants.PRIVACYTEXT_MINFONTSIZE)
      .maxFontSize(StyleConstants.PRIVACYTEXT_MAXFONTSIZE)
      .draggable(false)
      .padding({
        left: StyleConstants.TEXT_PADDING,
        right: StyleConstants.TEXT_PADDING
      })
  }

  @Builder
  PermissionDescription() {
    Image($r('app.media.security_shield'))
      .width(StyleConstants.PRIVACY_IMAGE_SIZE)
      .height(StyleConstants.PRIVACY_IMAGE_SIZE)
      .draggable(false)

    Text() {
      this.SpanNodeArrayBuilder()
    }
    .draggable(false)
    .width('100%')
    .padding({ left: StyleConstants.TEXT_PADDING, right: StyleConstants.TEXT_PADDING })
    .margin({ top: StyleConstants.TEXT_TOP_MARGIN })
  }

  @Builder
  ButtonBuild() {
    Row() {
      Button($r('app.string.cancel'), { type: ButtonType.Normal, stateEffect: true })
        .id('id_launch_privacy_cancel')
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
        .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
        .layoutWeight(buttonLayoutWeight)
        .borderRadius(StyleConstants.DIALOG_BORDER_RADIUS)
        .padding({
          top: StyleConstants.BUTTON_PADDING_TOP,
          bottom: StyleConstants.BUTTON_PADDING_BOTTOM,
          left: StyleConstants.BUTTON_PADDING_LEFT,
          right: StyleConstants.BUTTON_PADDING_RIGHT
        })
        .fontSize(this.buttonFontSize)
        .onClick(() => {
          this.closeWindow()
        })

      Blank().width($r('sys.float.ohos_id_card_margin_middle')).visibility(Visibility.Hidden)

      Button($r('app.string.agree'), { type: ButtonType.Normal, stateEffect: true })
        .id('id_launch_privacy_agree')
        .layoutWeight(buttonLayoutWeight)
        .borderRadius(StyleConstants.DIALOG_BORDER_RADIUS)
        .padding({
          top: StyleConstants.BUTTON_PADDING_TOP,
          bottom: StyleConstants.BUTTON_PADDING_BOTTOM,
          left: StyleConstants.BUTTON_PADDING_LEFT,
          right: StyleConstants.BUTTON_PADDING_RIGHT
        })
        .fontSize(this.buttonFontSize)
        .onClick(() => {
          SettingsUtil.setSystemValue(SettingsKeyConstants.PRIVACY_AGREEMENT_SIGNED, '1', getContext()).then(() => {
            this.closeWindow();
          });
        })
    }
    .width('100%')
    .padding({
      left: StyleConstants.BUTTON_PADDING_LEFT,
      right: StyleConstants.BUTTON_PADDING_RIGHT,
      top: StyleConstants.BUTTON_MARGIN_TOP,
      bottom: StyleConstants.BUTTON_MARGIN_BOTTOM
    })
  }

  @Builder
  SpanNodeArrayBuilder() {
    ForEach(this.spanData, (item: SpanInfo) => {
      if (item.textStyle === 'active') {
        Span(this.isSupport ? item.text : $r('app.string.ai_sound_detail'))
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Caption_M'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary_activated'))
          .constraintSize({
            minHeight: StyleConstants.FIRST_TEXT_LINEHEIGHT
          })
          .onClick(() => {
            this.swiperController.showNext();
          });
      } else if (item.textStyle === 'wrap') {
        Span(item.text)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Caption_M'))
          .fontColor('#00000000')
          .lineHeight('6vp')
      } else {
        Span(item.text)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Caption_M'))
          .fontColor($r('sys.color.font_tertiary'))
          .constraintSize({
            minHeight: StyleConstants.FIRST_TEXT_LINEHEIGHT
          })
      }
    })
  }
}

@Component
export struct PermissionDetailPage {
  @State spanData: SpanInfo[] = [];
  private textHelper: TextHelpUtils = new TextHelpUtils();
  private textIndex: number = 2;
  private versionTime: string = TimeUtil.formatTime(DataConstants.YEAR, DataConstants.MOUTH, DataConstants.DATE);

  aboutToAppear(): void {
    log.info(TAG, 'aboutToAppear');
    this.textHelper.parseContent(this.textIndex).then((result: SpanInfo[]) => {
      this.spanData = result;
    });
  }

  build() {
    Column() {
      this.BuildContent();
    }
    .width(StyleConstants.DEFAULT_DIALOG_WIDTH)
    .height(StyleConstants.DETAIL_DIALOG_HEIGHT)
  }

  @Builder
  BuildContent(): void {
    Row() {
      Scroll() {
        Column() {
          this.ImageDescription();
          this.PermissionDescription();
        }
        .width('100%')
      }
      .layoutWeight(1)
      .margin({ bottom: StyleConstants.DETAIL_CONTENT_MARGIN_BOTTOM })
      .scrollBar(BarState.Auto)
      .width('100%')
    }
    .layoutWeight(1)
    .width(StyleConstants.DEFAULT_DIALOG_WIDTH)
  }

  @Builder
  ImageDescription() {
    Image($r('app.media.security_shield'))
      .width(StyleConstants.DETAIL_IMAGE_SIZE)
      .height(StyleConstants.DETAIL_IMAGE_SIZE)
      .draggable(false)

    Text(XmlParseUtil.getLogSupport() ? $r('app.string.sound_detail') : $r('app.string.ai_sound_detail'))
      .margin({ top: StyleConstants.TEXT_TOP_MARGIN })
      .fontWeight(FontWeight.Medium)
      .textAlign(TextAlign.Center)
      .fontColor($r('sys.color.ohos_id_color_text_primary'))
      .maxLines(maxLines)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontSize($r('sys.float.Subtitle_L'))
      .constraintSize({
        minHeight: StyleConstants.DETAIL_TEXT_LINEHEIGHT
      })
      .draggable(false)
      .padding({ left: StyleConstants.TEXT_PADDING, right: StyleConstants.TEXT_PADDING })

    Text($r('app.string.detail_version', this.versionTime))
      .margin({ bottom: StyleConstants.DETAIL_CONTENT_MARGIN_BOTTOM })
      .fontWeight(FontWeight.Regular)
      .textAlign(TextAlign.Center)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontSize($r('sys.float.Subtitle_S'))
      .constraintSize({
        minHeight: StyleConstants.TEXT_LINEHEIGHT
      })
      .draggable(false)
  }

  @Builder
  PermissionDescription() {
    Text() {
      this.SpanNodeArrayBuilder()
    }
    .draggable(false)
    .width('100%')
    .padding({ left: StyleConstants.TEXT_PADDING, right: StyleConstants.TEXT_PADDING })
  }

  @Builder
  SpanNodeArrayBuilder() {
    ForEach(this.spanData, (item: SpanInfo) => {
      if (item.textStyle === 'bold') {
        Span(item.text)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Bold)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .constraintSize({
            minHeight: StyleConstants.TEXT_LINEHEIGHT
          })
      } else if (item.textStyle === 'wrap') {
        Span(item.text)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Body_M'))
          .fontColor('#00000000')
          .constraintSize({
            //minHeight: $r('app.float.common_size4')
          })
      } else if (item.textStyle === 'title') {
        Span(item.text)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Subtitle_M'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .constraintSize({
            minHeight: StyleConstants.DETAIL_TITLE_LINEHEIGHT
          })
      } else {
        Span(item.text)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('sys.float.Body_M'))
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .constraintSize({
            minHeight: StyleConstants.TEXT_LINEHEIGHT
          })
      }
    })
  }
}