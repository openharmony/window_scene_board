/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

@CustomDialog
export struct ConfirmAlertDialog {
  public message?: Resource;
  public controller?: CustomDialogController;
  public cancel?: () => void;
  public confirm?: () => void;

  public aboutToDisappear() {
    AppStorage.setOrCreate('isShowEnterpriseAlertDialog', false);
  }

  public build() {
    Column() {
      Text(this.message)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .fontSize(16)
        .lineHeight(19)
        .margin({ top: 24, bottom: 16 })
      Button($r('app.string.enterprise_confirm'))
        .onClick(() => {
          this.controller?.close();
        })
        .width(250)
        .height(40)
        .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
        .fontFamily('HarmonyHeiT')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .backgroundColor($r('sys.color.ohos_id_color_button_normal'))
    }
    .backgroundColor($r('sys.color.ohos_id_color_dialog_bg'))
    .width(394)
    .height(125)
    .borderRadius(16)
    .align(Alignment.Top)
  }
}

export class ConfirmAlertDialogShower {
  public static updateConfirmAlertDialogShow(dialogController: CustomDialogController, isShow: boolean): void {
    if (isShow) {
      dialogController.open();
    } else {
      dialogController.close();
    }
  }
}