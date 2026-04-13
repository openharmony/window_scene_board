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
import { ResUtils } from '@ohos/windowscene';

const TAG = 'ScreenLock-PowerDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const COMPONENT_ID_CONTENT = TAG + '_Text_title';
const COMPONENT_ID_NEGATIVE = TAG + '_Button_negative';
const COMPONENT_ID_POSITIVE = TAG + '_Button_positive';

/**
 * 关机/重启 确认弹框
 *
 * @since 2023-07-06
 */
@CustomDialog
export default struct PowerDialog {
  public controller?: CustomDialogController;
  private positiveButton: Resource | null = null;
  private dialogMessage: Resource | undefined = undefined;
  private onConfirm: () => void = () =>{};
  private onCancel: () => void = () =>{};

  /**
   * ShutDownDialog aboutToAppear
   */
  public aboutToAppear(): void {
    log.showInfo('aboutToAppear')
  }

  /**
   * ShutDownDialog aboutToDisappear
   */
  public aboutToDisappear(): void {
    log.showInfo('aboutToDisappear')
  }

  /**
   * ShutDownDialog build
   */
  public build(): void {
    Stack() {
      Column() {
        Text(this.dialogMessage).draggable(false)
          .id(COMPONENT_ID_CONTENT)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
          .fontWeight(FontWeight.Regular)
          .fontColor($r('app.color.shutdown_dialog_message_font_color'))
          .lineHeight($r('app.float.screenLock_shutdown_dialog_line_height'))
          .padding($r('app.float.screenLock_shutdown_dialog_padding'))

        Row({ space: ResUtils.getNumber($r('app.float.screenLock_shutdown_dialog_button_space')) }) {
          Button($r('app.string.power_dialog_negative_button'), { type: ButtonType.Capsule })
            .id(COMPONENT_ID_NEGATIVE)
            .layoutWeight(1)
            .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.shutdown_dialog_negative_font_color'))
            .height($r('app.float.screenLock_shutdown_dialog_button_height'))
            .borderRadius($r('app.float.screenLock_shutdown_dialog_button_radio'))
            .backgroundColor($r('app.color.shutdown_dialog_negative_button_background'))
            .tabIndex(1)
            .onClick(() => {
              this.onCancel();
              this.controller?.close()
            })

          Button(this.positiveButton!, { type: ButtonType.Capsule })
            .id(COMPONENT_ID_POSITIVE)
            .layoutWeight(1)
            .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.shutdown_dialog_positive_font_color'))
            .height($r('app.float.screenLock_shutdown_dialog_button_height'))
            .borderRadius($r('app.float.screenLock_shutdown_dialog_button_radio'))
            .backgroundColor($r('app.color.shutdown_dialog_negative_button_background'))
            .tabIndex(2)
            .onClick(() => {
              this.onConfirm();
            })
        }
        .padding({
          left: $r('app.float.screenLock_shutdown_dialog_button_padding'),
          right: $r('app.float.screenLock_shutdown_dialog_button_padding'),
          bottom: $r('app.float.screenLock_shutdown_dialog_padding')
        })
      }
      .width($r('app.float.screenLock_shutdown_dialog_width'))
      .backgroundColor($r('app.color.shutdown_dialog_background'))
      .saturate(2.4)
      .borderRadius($r('app.float.screenLock_shutdown_dialog_radio'))
      .backgroundBlurStyle(BlurStyle.Thick, {
        colorMode: ThemeColorMode.LIGHT,
        adaptiveColor: AdaptiveColor.AVERAGE,
        policy: 1
      }, { disableSystemAdaptation: true })
    }
    .width('100%')
  }
}