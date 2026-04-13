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
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ResourceVm } from '../vm/ResourceVm';

const TAG = 'SilenceDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const SILENCE_DIALOG_TITLE = TAG + '_SILENCE_DIALOG_TITLE';
const SILENCE_DIALOG_CONTENT = TAG + '_SILENCE_DIALOG_CONTENT';
const COMPONENT_ID_CANCEL = TAG + '_COMPONENT_ID_CANCEL';
const COMPONENT_ID_CONFIRM = TAG + '_COMPONENT_ID_CONFIRM';
const PANEL_CURVES = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
const BUTTON_LINE_HEIGHT = 24;

@CustomDialog
export default struct SilenceDialog {
  controller?: CustomDialogController
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }
  private silenceDialogTitle: string = '';
  @Consume @Watch('refreshNtfSilenceDialogClose') ntfSilenceDialogClose: boolean;

  aboutToAppear() {
    this.ntfSilenceDialogClose = false;
    log.showInfo(TAG, 'aboutToAppear');
  }

  aboutToDisappear() {
    this.ntfSilenceDialogClose = true;
    log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Column() {
      this.buildSilenceDialog()
    }
    .onDisAppear(() => {
      this.cancel();
    })
    .id(TAG)
    .width('100%')
    .height('100%')
    .backgroundBlurStyle(true ? BlurStyle.BACKGROUND_ULTRA_THICK :
    BlurStyle.NONE, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT,
      scale: 0.1,
      blurOptions: { grayscale: true ? [38, 38] : [0, 0] }
    })
    .animation({ duration: true ? 250 : 100, curve: PANEL_CURVES, })
    .visibility(true ? Visibility.Visible : Visibility.None)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildSilenceDialog() {
    Column() {
      this.buildTitle();
      this.buildDialogContent();
      this.buildActionButton();
    }
    .backgroundColor($r('sys.color.comp_background_primary'))
    .borderRadius($r('sys.float.corner_radius_level16'))
    .alignSelf(ItemAlign.Center)
    .width(DeviceHelper.isLandscape() ? '50%' : '90%')
    .height('auto')
  }

  @Builder
  buildTitle() {
    Text(this.silenceDialogTitle ?? '')
      .draggable(false)
      .id(SILENCE_DIALOG_TITLE)
      .width('100%')
      .textAlign(TextAlign.Center)
      .fontWeight(FontWeight.Bold)
      .constraintSize({ minHeight: $r('app.float.ntf_settings_dialog_title_height') })
      .fontSize($r('sys.float.Title_S'))
      .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
      .fontColor($r('sys.color.font_primary'))
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(2)
      .padding({
        top: $r('app.float.ntf_silence_dialog_padding_top_bottom'),
        bottom: $r('app.float.ntf_silence_dialog_padding_top_bottom'),
        left: $r('app.float.ntf_silence_dialog_padding_left_right'),
        right: $r('app.float.ntf_silence_dialog_padding_left_right')
      })
  }

  @Builder
  buildDialogContent() {
    Text($r('app.string.silent_notifications_dialog'))
      .draggable(false)
      .id(SILENCE_DIALOG_CONTENT)
      .width('100%')
      .textAlign(TextAlign.Center)
      .fontSize($r('sys.float.Body_L'))
      .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
      .fontColor($r('sys.color.font_primary'))
      .lineHeight($r('app.float.ntf_settings_dialog_content_line_height_fp'))
      .fontWeight(FontWeight.Medium)
      .padding({
        bottom: $r('app.float.ntf_menu_dialog_text_padding'),
        left: $r('app.float.ntf_menu_dialog_text_padding'),
        right: $r('app.float.ntf_menu_dialog_text_padding')
      })
  }

  @Builder
  buildActionButton() {
    Row() {
      Button({ type: ButtonType.Capsule }) {
        Text($r('app.string.cancel'))
          .fontSize($r('sys.float.Body_L'))
          .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
          .fontColor($r('sys.color.font_emphasize'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
      }
      .id(COMPONENT_ID_CANCEL)
      .backgroundColor(Color.Transparent)
      .layoutWeight(1)
      .constraintSize({ minHeight: $r('app.float.ntf_setting_dialog_item_height') })
      .onClick(() => {
        this.cancel();
      })

      Line()
        .width($r('app.float.ntf_pin_top_app_dialog_bottom_divider_width'))
        .height(ResourceVm.instance.getFontSize(BUTTON_LINE_HEIGHT))
        .backgroundColor($r('sys.color.comp_divider'))
        .margin({
          left: $r('app.float.ntf_menu_dialog_button_margin'),
          right: $r('app.float.ntf_menu_dialog_button_margin')
        })

      Button({ type: ButtonType.Capsule }) {
        Text($r('app.string.confirm'))
          .fontSize($r('sys.float.Body_L'))
          .maxFontScale(ResourceVm.DEFAULT_MAX_SCALE)
          .fontColor($r('sys.color.font_emphasize'))
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
      }
      .id(COMPONENT_ID_CONFIRM)
      .constraintSize({ minHeight: $r('app.float.ntf_setting_dialog_item_height') })
      .backgroundColor(Color.Transparent)
      .layoutWeight(1)
      .onClick(() => {
        this.confirm();
      })
    }
    .height('auto')
    .margin({
      left: $r('app.float.ntf_silence_dialog_content_padding_left'),
      right: $r('app.float.ntf_silence_dialog_content_padding_left'),
      bottom: $r('app.float.ntf_settings_dialog_bottom_button_margin_bottom')
    })
  }

  refreshNtfSilenceDialogClose(): void {
    if (this.ntfSilenceDialogClose) {
      this.cancel();
      this.controller?.close();
    }
  }
}