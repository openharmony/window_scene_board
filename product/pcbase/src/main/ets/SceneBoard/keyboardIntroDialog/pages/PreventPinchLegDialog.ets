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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'PreventPinchLegDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const TOTAL_WIDTH: number = 400;
const TOTAL_HEIGHT: number = 472;
const IMAGE_WIDTH: number = 352;
const IMAGE_HEIGHT: number = 228;
const CONTENT_WIDTH: number = 352;
const CHECKBOX_HEIGHT_AREA: number = 48;
const CHECKBOX_HEIGHT: number = 24;
const CHECKBOX_WIDTH: number = 24;
const CHECKBOX_MARGIN_RIGHT: number = 10;

const DEFAULT_NUMBER_0 = 0;
const DEFAULT_NUMBER_1 = 1;
const DEFAULT_MARGIN_SIZE_8 = 8;
const DEFAULT_MARGIN_SIZE_16 = 16;
const DEFAULT_MARGIN_SIZE_24 = 24;
const DEFAULT_MARGIN_SIZE_36 = 36;
const DEFAULT_BUTTON_HEIGHT_40 = 40;
const DEFAULT_FONT_SIZE_12 = 12;
const DEFAULT_FONT_SIZE_16 = 16;
const DEFAULT_FONT_SIZE_20 = 20;
const DEFAULT_LINE_HEIGHT_21 = 21;
const DEFAULT_LINE_HEIGHT_27 = 27;

@CustomDialog
export struct PreventPinchLegDialog {
  @State isChecked: boolean = false;
  @State buttonContent: Resource = $r('app.string.get_it');
  @StorageLink('systemLanguage') language: string = '';
  @State isUyghurMode: boolean = false;
  public static isDoNotRemind: boolean = false;
  public diaLogController?: CustomDialogController;
  public close?: () => void;
  public closeDialogCount: number = 0;

  aboutToAppear(): void {
    log.showInfo(`this.language ${this.language}`);
    this.isUyghurMode = (this.language === 'ug-CN' || this.language === 'ug');
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Column() {
      Image($r('app.media.expand_reminder_icon'))
        .width(IMAGE_WIDTH)
        .height(IMAGE_HEIGHT)
        .margin({
          top: DEFAULT_MARGIN_SIZE_24,
          bottom: DEFAULT_MARGIN_SIZE_24
        })
      Column() {
        Text($r('app.string.friendly_reminder'))
          .width(CONTENT_WIDTH)
          .fontSize(DEFAULT_FONT_SIZE_20)
          .maxFontScale(DEFAULT_NUMBER_1)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.font_primary'))
          .textAlign(TextAlign.Center)
          .lineHeight(DEFAULT_LINE_HEIGHT_27)
          .margin({ bottom: DEFAULT_MARGIN_SIZE_8 })
        Text($r('app.string.hopper_expand_reminder'))
          .width(CONTENT_WIDTH)
          .fontSize(DEFAULT_FONT_SIZE_16)
          .maxFontScale(DEFAULT_NUMBER_1)
          .fontWeight(FontWeight.Medium)
          .letterSpacing(DEFAULT_NUMBER_0)
          .fontColor($r('sys.color.font_primary'))
          .textAlign(TextAlign.Center)
          .lineHeight(DEFAULT_LINE_HEIGHT_21)
      }
      .height(84)

      Row() {
        if (this.closeDialogCount > 0) {
          Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
            .select(this.isChecked)
            .selectedColor($r('sys.color.ohos_id_color_focused_bg'))
            .shape(CheckBoxShape.CIRCLE)
            .width(CHECKBOX_WIDTH)
            .height(CHECKBOX_HEIGHT)
            .margin({
              right: CHECKBOX_MARGIN_RIGHT
            })
            .onChange((value: boolean) => {
              log.showInfo(`isDoNotRemind : ${value}`);
              this.isChecked = value;
              PreventPinchLegDialog.isDoNotRemind = value;
            })
          Text($r('app.string.do_not_remind_again'))
            .fontSize(DEFAULT_FONT_SIZE_12)
            .fontColor($r('sys.color.font_primary'))
            .onClick(() => {
              this.isChecked = !this.isChecked;
              log.showInfo(`isDoNotRemind : ${!this.isChecked}`);
              PreventPinchLegDialog.isDoNotRemind = this.isChecked;
            })
        }
      }
      .width('100%')
      .height(CHECKBOX_HEIGHT_AREA)
      .margin({
        left: this.isUyghurMode ? 0 : DEFAULT_MARGIN_SIZE_36,
        right: this.isUyghurMode ? DEFAULT_MARGIN_SIZE_36 : 0
      })

      Button($r('app.string.get_it'))
        .width(TOTAL_WIDTH - DEFAULT_MARGIN_SIZE_16 - DEFAULT_MARGIN_SIZE_16)
        .height(DEFAULT_BUTTON_HEIGHT_40)
        .margin(DEFAULT_MARGIN_SIZE_16)
        .fontSize($r('sys.float.Body_L'))
        .fontColor($r('sys.color.font_emphasize'))
        .type(ButtonType.Normal)
        .borderRadius($r('sys.float.corner_radius_level4'))
        .backgroundColor($r('sys.color.comp_background_tertiary'))
        .onClick(() => {
          this.close?.();
        })
    }
    .width(TOTAL_WIDTH)
    .height(TOTAL_HEIGHT)
  }
}