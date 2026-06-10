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
import { ResUtils } from '@ohos/windowscene';
import { PowerMenuType } from './PowerViewModel';
import { settingsDataManager } from '@ohos/frameworkwrapper';

const TAG = 'ScreenLock-PowerDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const COMPONENT_ID_CONTENT = TAG + '_Text_title';
const COMPONENT_ID_HEAD = TAG + '_Text_head';
const COMPONENT_ID_NEGATIVE = TAG + '_Button_negative';
const COMPONENT_ID_POSITIVE = TAG + '_Button_positive';

const HWF_TERMINATE_FLAG: string = 'hwf.terminate.flag';

/**
 * 关机/重启 确认弹框
 *
 *
 */
@CustomDialog
export default struct PowerDialog {
  public controller?: CustomDialogController;
  private positiveButton: Resource | null = null;
  private dialogMessage: Resource | undefined = undefined;
  private onConfirm: () => void = () =>{};
  private onCancel: () => void = () =>{};
  @Link isVirtualMachineUpdating: boolean;
  private powerType: PowerMenuType | undefined = undefined;

  /**
   * ShutDownDialog aboutToAppear
   */
  public aboutToAppear(): void {
    log.showInfo('aboutToAppear')
    if (this.isVirtualMachineUpdating) {
      this.undateHwfTerminateflag('true');
    }
  }

  /**
   * ShutDownDialog aboutToDisappear
   */
  public aboutToDisappear(): void {
    log.showInfo('aboutToDisappear')
  }

  private getVirtualTips(): string {
    if (this.powerType === PowerMenuType.RESTART) {
      return ResUtils.getInnerString($r('app.string.virtual_machine_reboot_tips'));
    } else if (this.powerType === PowerMenuType.POWER_OFF) {
      return ResUtils.getInnerString($r('app.string.virtual_machine_shut_down_tips'));
    } else {
      return ''
    }
  }

  private undateHwfTerminateflag(flag: string): void {
    log.showInfo(`undateHwfTerminateflag ${flag}`);
    settingsDataManager.setValue(null, HWF_TERMINATE_FLAG, flag);
  }

  @Builder
  VirtualDialogContent() {
    Column() {
      Text($r('app.string.virtual_machine_updating'))
        .draggable(false)
        .id(COMPONENT_ID_HEAD)
        .width('100%')
        .height(56)
        .textAlign(TextAlign.Center)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.shutdown_dialog_message_font_color'))
      Text(this.getVirtualTips())
        .draggable(false)
        .id(COMPONENT_ID_CONTENT)
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
        .fontWeight(FontWeight.Regular)
        .fontColor($r('app.color.shutdown_dialog_message_font_color'))
        .lineHeight($r('app.float.screenLock_shutdown_dialog_line_height'))
        .padding({
          left: $r('app.float.screenLock_shutdown_dialog_padding'),
          right: $r('app.float.screenLock_shutdown_dialog_padding'),
          bottom: 16
        })
      Row({ space: ResUtils.getNumber($r('app.float.screenLock_shutdown_dialog_button_space')) }) {
        Button($r('app.string.got_it'), { type: ButtonType.Normal })
          .id(COMPONENT_ID_NEGATIVE)
          .layoutWeight(1)
          .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.shutdown_dialog_negative_font_color'))
          .height($r('app.float.screenLock_shutdown_dialog_button_height'))
          .borderRadius(8)
          .backgroundColor($r('app.color.shutdown_dialog_negative_button_background'))
          .tabIndex(1)
          .onClick(() => {
            this.onCancel();
            this.controller?.close()
            this.undateHwfTerminateflag('false');
          })
      }
      .padding({
        left: $r('app.float.screenLock_shutdown_dialog_button_padding'),
        right: $r('app.float.screenLock_shutdown_dialog_button_padding'),
        bottom: 16
      })
    }
    .width(400)
    .backgroundColor($r('app.color.shutdown_dialog_background'))
    .saturate(2.4)
    .borderRadius($r('app.float.screenLock_shutdown_dialog_radio'))
    .backgroundBlurStyle(BlurStyle.Thick, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.AVERAGE,
      policy: 1
    })
  }

  @Builder
  DialogContent(){
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
        .padding({
          left: $r('app.float.screenLock_shutdown_dialog_padding'),
          right: $r('app.float.screenLock_shutdown_dialog_padding'),
          top: $r('app.float.screenLock_shutdown_dialog_padding'),
          bottom: 16
        })

      Row({ space: ResUtils.getNumber($r('app.float.screenLock_shutdown_dialog_button_space')) }) {
        Button($r('app.string.power_dialog_negative_button'), { type: ButtonType.Normal })
          .id(COMPONENT_ID_NEGATIVE)
          .layoutWeight(1)
          .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.shutdown_dialog_negative_font_color'))
          .height($r('app.float.screenLock_shutdown_dialog_button_height'))
          .borderRadius(8)
          .backgroundColor($r('app.color.shutdown_dialog_negative_button_background'))
          .tabIndex(1)
          .onClick(() => {
            this.onCancel();
            this.controller?.close()
          })

        Button(this.positiveButton!, { type: ButtonType.Normal })
          .id(COMPONENT_ID_POSITIVE)
          .layoutWeight(1)
          .fontSize($r('app.float.screenLock_shutdown_dialog_font_size'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.shutdown_dialog_positive_font_color'))
          .height($r('app.float.screenLock_shutdown_dialog_button_height'))
          .borderRadius(8)
          .backgroundColor($r('app.color.shutdown_dialog_negative_button_background'))
          .tabIndex(2)
          .onClick(() => {
            this.onConfirm();
          })
      }
      .padding({
        left: $r('app.float.screenLock_shutdown_dialog_button_padding'),
        right: $r('app.float.screenLock_shutdown_dialog_button_padding'),
        bottom: 16
      })
    }
    .width(400)
    .backgroundColor($r('app.color.shutdown_dialog_background'))
    .saturate(2.4)
    .borderRadius($r('app.float.screenLock_shutdown_dialog_radio'))
    .backgroundBlurStyle(BlurStyle.Thick, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.AVERAGE,
      policy: 1
    })
  }

  /**
   * ShutDownDialog build
   */
  public build(): void {
    Stack() {
      if (this.isVirtualMachineUpdating) {
        this.VirtualDialogContent()
      } else {
        this.DialogContent()
      }
    }
    .width('100%')
  }
}