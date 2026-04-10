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
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'ExtendedScreenDialogView';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@CustomDialog
export struct ExtendedScreenDialogView {
  private controller?: CustomDialogController;
  private onCancel: () => void = () =>{};
  @Link isChecked: boolean;

  @Builder
  dialogImage() {
    Column(){
      Image($r('app.media.extend_screen_img'))
        .width(352)
        .height($r('app.float.common_size240'))
        .draggable(false)
        .fillColor($r('sys.color.ohos_id_color_primary'))
    }
    .width('100%')
    .padding({
      top: $r('app.float.common_padding16'),
      bottom: $r('app.float.common_padding12'),
      left: $r('app.float.common_padding24'),
      right: $r('app.float.common_padding24')
    })
  }

  @Builder
  dialogContent() {
    Column() {
      Text($r('app.string.extended_screen_dialog_title'))
        .fontSize($r('sys.float.Title_S'))
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Bold)
        .constraintSize({
          minHeight: $r('app.float.common_line_height27')
        })
      Text($r('app.string.extended_screen_dialog_content'))
        .fontSize($r('sys.float.Subtitle_M'))
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Medium)
        .margin({ top: $r('app.float.common_margin8') })
        .constraintSize({
          minHeight: $r('app.float.common_line_height21')
        })
    }
    .width('100%')
    .padding({
      left: $r('app.float.common_padding24'),
      right: $r('app.float.common_padding24')
    })
    .alignItems(HorizontalAlign.Center)

  }

  @Builder
  dialogCheckbox() {
    Row() {
      Checkbox()
        .select(false)
        .onChange((value: boolean) => {
          log.info(`check res: ${value}`);
          this.isChecked = value;
        })
        .width($r('app.float.common_size24'))
        .height($r('app.float.common_size24'))

      Text($r('app.string.do_not_remind_again'))
        .fontSize($r('sys.float.Body_S'))
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .fontWeight(FontWeight.Regular)
        .margin({ start: LengthMetrics.resource($r('app.float.common_padding10')) })
        .constraintSize({
          minHeight: $r('app.float.common_font_size19')
        })
    }
    .width('100%')
    .height($r('app.float.common_line_height48'))
    .padding({
      left: $r('app.float.common_padding24'),
      right: $r('app.float.common_padding24')
    })
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  dialogButton() {
    Row() {
      Button($r('app.string.confirm'), { type: ButtonType.Normal, stateEffect: true })
        .layoutWeight(1)
        .borderRadius($r('app.float.common_borderRadius8'))
        .fontSize($r('sys.float.Subtitle_M'))
        .height($r('app.float.common_size40'))
        .onClick(() => {
          log.info(`click button`);
          this.controller?.close();
          this.onCancel();
        })
    }
    .width('100%')
    .padding({
      top: $r('app.float.common_padding16'),
      bottom: $r('app.float.common_padding16'),
      left: $r('app.float.common_padding24'),
      right: $r('app.float.common_padding24')
    })
  }

  build() {
    Column() {
      this.dialogImage();
      this.dialogContent();
      this.dialogCheckbox();
      this.dialogButton();
    }
    .width($r('app.float.common_size400'))
    .saturate(2.4)
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
    .borderRadius($r('sys.float.ohos_id_corner_radius_default_l'))
    .backgroundBlurStyle(BlurStyle.Thick, { colorMode: ThemeColorMode.LIGHT, adaptiveColor: AdaptiveColor.AVERAGE })
  }

}
