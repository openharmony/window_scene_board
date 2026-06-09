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
import { Constants } from '../../keyboardWarningDialog/common/Constants';
import { KeyBoardWarningDialogContent } from '../../keyboardWarningDialog/pages/FirstUseKeyBoardWarningDialog';

const TAG = 'FirstUseKeyboardIntroductionDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Component
export struct KeyBoardIntroductionDialogContent {
  @State isShow: Visibility = Visibility.Visible;
  @State title: Resource = $r('app.string.connect_keyboard');
  @State turnOnKeyboard: Resource = $r('app.string.turn_on_keyboard', Constants.FIRST);
  @State popupDialog: Resource = $r('app.string.pop_up_dialog', Constants.SECOND, Constants.THIRD);
  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Image($r('app.media.keyboard_introduction'))
        .width(Constants.CONTENT_WIDTH)
        .height(Constants.IMAGE_HEIGHT)
        .margin({
          top: Constants.DEFAULT_MARGIN_SIZE_25,
          left: Constants.DEFAULT_MARGIN_SIZE_24,
          right: Constants.DEFAULT_MARGIN_SIZE_24,
          bottom: Constants.DEFAULT_MARGIN_SIZE_150
        })

      Column() {
        Text(this.title)
          .width(Constants.CONTENT_WIDTH)
          .height(Constants.TITLE_HEIGHT)
          .fontSize(Constants.DEFAULT_FONT_SIZE_20)
          .maxFontScale(Constants.DEFAULT_NUMBER_1)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .textAlign(TextAlign.Center)
          .lineHeight(Constants.DEFAULT_LINE_HEIGHT_27)
          .visibility(this.isShow)
          .margin({ bottom: Constants.DEFAULT_MARGIN_SIZE_8 })

        Text(this.turnOnKeyboard)
          .width(Constants.CONTENT_WIDTH)
          .constraintSize({ minHeight: Constants.TEXT_HEIGHT })
          .fontSize(Constants.DEFAULT_FONT_SIZE_16)
          .maxFontScale(Constants.DEFAULT_NUMBER_1)
          .fontWeight(FontWeight.Medium)
          .letterSpacing(Constants.DEFAULT_NUMBER_0)
          .fontColor($r('sys.color.font_primary'))
          .lineHeight(Constants.DEFAULT_LINE_HEIGHT_21)
          .margin({
            left: Constants.DEFAULT_MARGIN_SIZE_24,
            right: Constants.DEFAULT_MARGIN_SIZE_24
          })
          .visibility(this.isShow)



        Text(this.popupDialog)
          .width(Constants.CONTENT_WIDTH)
          .constraintSize({ minHeight: Constants.TEXT_HEIGHT })
          .fontSize(Constants.DEFAULT_FONT_SIZE_16)
          .maxFontScale(Constants.DEFAULT_NUMBER_1)
          .fontWeight(FontWeight.Medium)
          .letterSpacing(Constants.DEFAULT_NUMBER_0)
          .fontColor($r('sys.color.font_primary'))
          .lineHeight(Constants.DEFAULT_LINE_HEIGHT_21)
          .margin({
            left: Constants.DEFAULT_MARGIN_SIZE_24,
            right: Constants.DEFAULT_MARGIN_SIZE_24
          })
          .visibility(this.isShow)
      }
      .margin({
        bottom: Constants.DEFAULT_MARGIN_SIZE_32
      })
    }
  }
}

@Component
export struct KeyBoardCustomButton {
  @Prop buttonText?: Resource = $r('app.string.get_it');
  public closeCallback?: () => void;

  build() {
    Button(this.buttonText)
      .width(Constants.TOTAL_WIDTH - Constants.DEFAULT_MARGIN_SIZE_16 - Constants.DEFAULT_MARGIN_SIZE_16)
      .height(Constants.DEFAULT_BUTTON_HEIGHT_40)
      .margin({
        top: Constants.DEFAULT_MARGIN_SIZE_16,
        left: Constants.DEFAULT_MARGIN_SIZE_16,
        right: Constants.DEFAULT_MARGIN_SIZE_16,
        bottom: Constants.DEFAULT_MARGIN_SIZE_16
      })
      .fontSize($r('sys.float.Body_L'))
      .fontColor($r('sys.color.font_emphasize'))
      .type(ButtonType.Normal)
      .borderRadius($r('sys.float.corner_radius_level4'))
      .visibility(Visibility.Visible)
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .opacity(1.0)
      .onClick(() => {
        this.closeCallback?.();
      })
  }
}

@CustomDialog
export struct FirstUseKeyboardIntroductionDialog {
  public diaLogController?: CustomDialogController;
  public close?: () => void;
  private swiperController: SwiperController = new SwiperController();

  @State buttonState: number = Constants.INTRODUCTION_BUTTON_ENABLE;
  @State buttonContent: Resource = $r('app.string.get_it');

  aboutToAppear(): void {
    log.showInfo(`${TAG} aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`${TAG} aboutToDisappear`);
  }

  closePage:() => void = () => {
    this.close?.();
  }

  public introButtonCallback:() => void = () => {
    this.swiperController.changeIndex(Constants.SECOND_PAGE);
    this.buttonState = Constants.WARNING_BUTTON_ENABLE;
  }

  @Builder
  IntroButtonEnableBuilder() {
    KeyBoardCustomButton({
      buttonText: this.buttonContent,
      closeCallback: this.introButtonCallback
    })
  }

  @Builder
  WarningButtonEnableBuilder() {
    KeyBoardCustomButton({
      buttonText: this.buttonContent,
      closeCallback: this.closePage
    })
  }

  build() {
    Column() {
      Swiper(this.swiperController) {
        KeyBoardIntroductionDialogContent();
        KeyBoardWarningDialogContent();
      }
      .index(Constants.FIRST_PAGE)

      if (this.buttonState === Constants.INTRODUCTION_BUTTON_ENABLE) {
        this.IntroButtonEnableBuilder();
      } else {
        this.WarningButtonEnableBuilder();
      }
    }
    .width(Constants.TOTAL_WIDTH)
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Center)
  }
}