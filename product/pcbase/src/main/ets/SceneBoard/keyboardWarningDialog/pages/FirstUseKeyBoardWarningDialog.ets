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
import lottie, { AnimationItem } from '@ohos/lottie';
import { Constants } from '../common/Constants';
import { KeyBoardCustomButton } from '../../keyboardIntroDialog/pages/FirstUseKeyboardIntroductionDialog';
const TAG = 'FirstUseKeyBoardWarningDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

class KeyBoardDialogController {
  public closeAnimation = () => {};
}

@Component
export struct KeyBoardWarningDialogContent {
  @Prop keyBoardDialogController: KeyBoardDialogController = new KeyBoardDialogController();
  @Prop keyboardConnectStatus?: boolean = false;
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private mainCanvasRenderingContext1: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.mainRenderingSettings);
  private animateItem: AnimationItem | undefined = undefined;
  private animateName: string = 'keyBoardDialog';
  @State isShow: Visibility = Visibility.Hidden;
  @State textAlign: TextAlign = TextAlign.Center;
  @State title: Resource = $r('app.string.remove_keyboard');
  @State content: Resource = $r('app.string.close_machine_warning');
  aboutToAppear(): void {
    if (this.keyBoardDialogController) {
      this.keyBoardDialogController.closeAnimation = this.closeAnimation;
    }
    // animateName增加时间戳，防止反复快速调起弹窗时根据animateName销毁动画错乱
    const timestamp: string = new Date().getTime().toString();
    this.animateName += timestamp;
    log.showInfo('KeyBoardWarningDialogContent aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('KeyBoardWarningDialogContent aboutToDisappear');
    this.animateItem?.removeEventListener('DOMLoaded');
    log.showInfo('lottie.destroy');
    lottie.destroy(this.animateName);
  }

  loadAnimation() {
    this.animateItem = lottie.loadAnimation({
      container: this.mainCanvasRenderingContext1,
      renderer: 'canvas',
      loop: true,
      autoplay: false,
      name: this.animateName,
      contentMode: 'Contain',
      path: Constants.FIRST_PATH
    });
    this.animateItem?.addEventListener('DOMLoaded', (args: Object): void => {
      log.showInfo('firstAnimateItem play');
      this.isShow = Visibility.Visible;
      this.animateItem?.play();
    });
  }

  closeAnimation(): void {
    this.animateItem?.pause();
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      Stack() {
        Canvas(this.mainCanvasRenderingContext1)
          .onReady(() => {
            this.mainCanvasRenderingContext1.imageSmoothingEnabled = true;
            this.mainCanvasRenderingContext1.imageSmoothingQuality = 'medium';
            this.loadAnimation();
          })
          .renderFit(RenderFit.RESIZE_COVER)
      }
      .margin({
        top: Constants.DEFAULT_MARGIN_SIZE_25,
        left: Constants.DEFAULT_MARGIN_SIZE_24,
        right: Constants.DEFAULT_MARGIN_SIZE_24,
        bottom: this.keyboardConnectStatus ? Constants.DEFAULT_MARGIN_SIZE_75 : Constants.DEFAULT_MARGIN_SIZE_150
      })
      .width(Constants.CONTENT_WIDTH)
      .height(Constants.CANVAS_HEIGHT)
      .clip(true)

      Column() {
        Text(this.title)
          .width(Constants.CONTENT_WIDTH)
          .fontSize(Constants.DEFAULT_FONT_SIZE_20)
          .maxFontScale(Constants.DEFAULT_NUMBER_1)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .textAlign(TextAlign.Center)
          .lineHeight(Constants.DEFAULT_LINE_HEIGHT_27)
          .visibility(this.isShow)
          .margin({ bottom: Constants.DEFAULT_MARGIN_SIZE_8 })
          .onAttach(() => {
            log.showInfo('onAttach, removeKeyboard');
          })

        Text(this.content)
          .width(Constants.CONTENT_WIDTH)
          .fontSize(Constants.DEFAULT_FONT_SIZE_16)
          .maxFontScale(Constants.DEFAULT_NUMBER_1)
          .fontWeight(FontWeight.Medium)
          .letterSpacing(Constants.DEFAULT_NUMBER_0)
          .fontColor($r('sys.color.font_primary'))
          .textAlign(this.textAlign)
          .lineHeight(Constants.DEFAULT_LINE_HEIGHT_21)
          .visibility(this.isShow)
          .onAreaChange((oldValue, newValue) => {
            this.textAlign =
              newValue.height > Constants.DEFAULT_FONT_SIZE_16 * Constants.DEFAULT_NUMBER_2 ? TextAlign.Start :
              TextAlign.Center;
          })
      }
      .margin({
        left: Constants.DEFAULT_MARGIN_SIZE_24,
        right: Constants.DEFAULT_MARGIN_SIZE_24,
        bottom: this.keyboardConnectStatus ? Constants.DEFAULT_NUMBER_0 : Constants.DEFAULT_MARGIN_SIZE_78
      })
    }
  }
}

@CustomDialog
export struct FirstUseKeyBoardWarningDialog {
  public keyBoardDialogChildRef: KeyBoardDialogController = new KeyBoardDialogController();
  public diaLogController?: CustomDialogController;
  public close?: () => void;
  @State buttonContent: Resource = $r('app.string.get_it');
  @State buttonState: number = Constants.WARNING_BUTTON_DISABLE;

  private closeWarningDialog: () => void = () => {
    this.keyBoardDialogChildRef.closeAnimation();
    this.closePage();
  }

  @Builder
  DisableButtonBuilder() {
    KeyBoardCustomButton({buttonText: $r('app.string.get_it_clock')});
  }

  @Builder
  EnableButtonBuilder() {
    KeyBoardCustomButton({
      buttonText: $r('app.string.get_it'),
      closeCallback: this.closeWarningDialog
    });
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  closePage(): void {
    this.close?.();
  }

  build() {
    Column() {
      KeyBoardWarningDialogContent({
        keyBoardDialogController: this.keyBoardDialogChildRef,
        keyboardConnectStatus: true
      });
      this.EnableButtonBuilder();
    }
    .width(Constants.TOTAL_WIDTH)
    .align(Alignment.Top)
    .justifyContent(FlexAlign.Center)
  }
}