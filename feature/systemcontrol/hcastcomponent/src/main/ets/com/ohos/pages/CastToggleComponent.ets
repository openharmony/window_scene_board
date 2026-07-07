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
import { DropDownEvent, TargetPanel, DeviceHelper } from '@ohos/frameworkwrapper';
import {
  DropDownPanelManager,
  ToggleState
} from '@ohos/systemuicommon/Index';
import { CastToggleController } from '../controller/CastToggleController';
import { AlertDialog, ButtonOptions, CustomContentDialog } from '@kit.ArkUI';
import Constants from '../common/Constants';
import { castReportUtils } from '../common/CastReportUtils';
import { DialogInfo } from '../model/DialogInfo';
import { i18n } from '@kit.LocalizationKit';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';

const TAG = 'Toggle.CastToggleComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const BO_CAPTION_M_HEIGHT: number = 17;
const DIALOG_TEXT_PADDING: number = 24;

@Component
export default struct CastToggleComponent {
  @State state: ToggleState = {};
  @State isSymbolActive: boolean = false;
  @State dialogTitle: ResourceStr | undefined = $r('app.string.title_open_wlan_and_bluetooth');
  @State dialogMessage: ResourceStr = $r('app.string.text_open_wlan_and_bluetooth');
  @State cancelButton: ButtonOptions | undefined = undefined;
  @State confirmButton: ButtonOptions | undefined = undefined;
  @StorageProp('castDialogCode') @Watch('updateDialogType') castDialogCode: number = Constants.DIALOG_DEFAULT;
  @StorageLink('dropDownEvent') @Watch('onDropdownChanged')
  dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  @Consume @Watch('refreshCloseDialog') castDialogIsOpen: boolean;
  private activeTask: number = -1;

  private privacyController: CustomDialogController = new CustomDialogController({
    builder: CustomContentDialog({
      primaryTitle: $r('app.string.wireless_projection_toggle'),
      secondaryTitle: $r('app.string.privacy_hint'),
      contentBuilder: () => {
        this.permissionDialogContent();
      },
      buttons: [{
        value: $r('app.string.cancel'),
        action: () => {
          castReportUtils.reportUEPrivacyDialogEvent(Constants.REPORT_DIALOG_CANCEL);
          this.dialogClose();
        }
      },
        {
          value: $r('app.string.btn_agree'),
          action: () => {
            this.castDialogIsOpen = false;
            CastToggleController.getInstance().setPrivacyAgree();
            castReportUtils.reportUEPrivacyDialogEvent(Constants.REPORT_DIALOG_CONFIRM);
          }
        }],
      contentAreaPadding: {
        left: 0,
        right: 0,
        bottom: 0,
        top: 0
      }
    }),
    alignment: DialogAlignment.Center,
    autoCancel: true,
    cancel: () => {
      log.showInfo(`privacyController cancel`)
      castReportUtils.reportUEPrivacyDialogEvent(Constants.REPORT_DIALOG_CANCEL);
      this.dialogClose();
    }
  });
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: this.dialogBuilder,
    cancel: () => {
      this.dialogClose();
    },
    autoCancel: true,
    alignment: DialogAlignment.Center
  });

  private createCancelButton(text: ResourceStr | undefined): ButtonOptions | undefined {
    return this.createDialogButton(text, () => {
      this.dialogClose();
    });
  }

  private createConfirmButton(text: ResourceStr | undefined): ButtonOptions | undefined {
    return this.createDialogButton(text, () => {
      CastToggleController.getInstance().confirmClick(this.castDialogCode);
      this.castDialogIsOpen = false;
    });
  }

  private createDialogButton(text: ResourceStr | undefined, onClick: () => void): ButtonOptions | undefined {
    if (text === undefined) {
      return undefined;
    }
    return {
      value: text,
      fontColor: $r('sys.color.ohos_id_color_text_primary_activated'),
      action: onClick
    }
  }

  private dialogClose() {
    log.showInfo(`dialogController cancel`);
    CastToggleController.getInstance().cancelClick(this.castDialogCode);
    this.castDialogIsOpen = false;
  }

  @Builder
  dialogBuilder() {
    AlertDialog({
      primaryTitle: this.dialogTitle,
      content: this.dialogMessage,
      primaryButton: this.cancelButton,
      secondaryButton: this.confirmButton,
    })
  }

  @Builder
  permissionDialogContent() {
    Scroll() {
      Text($r('app.string.projection_privacy_statement'))
        .focusable(true)
        .fontSize($r('sys.float.Caption_M'))
        .wordBreak(WordBreak.BREAK_WORD)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('sys.color.font_tertiary'))
        .fontFamily('HarmonyHeiTi')
        .lineHeight(this.adapterLineHeight(BO_CAPTION_M_HEIGHT))
        .padding({ right: DIALOG_TEXT_PADDING, left: DIALOG_TEXT_PADDING })
    }.width('100%')
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    if (this.activeTask !== -1) {
      clearTimeout(this.activeTask);
      this.activeTask = -1;
    }
  }

  build() {
  }

  updateDialogType(): void {
    log.showInfo(`castDialogCode: ${this.castDialogCode}`);
    if (this.castDialogCode === Constants.DIALOG_DEFAULT) {
      if (this.castDialogIsOpen) {
        // 如果正在显示，需关闭
        this.castDialogIsOpen = false;
        this.dialogController.close();
        this.privacyController.close();
      }
      log.showWarn('not phone or dialog code default');
      return;
    }
    if (this.castDialogCode === Constants.DIALOG_PRIVACY) {
      this.privacyController.open();
    } else if (this.castDialogCode === Constants.DIALOG_WIFI_BLUETOOTH) {
      this.dialogTitle = $r('app.string.title_open_wlan_and_bluetooth');
      this.dialogMessage = $r('app.string.text_open_wlan_and_bluetooth');
      this.confirmButton = this.createConfirmButton($r('app.string.btn_turn_on'));
      this.cancelButton = this.createCancelButton($r('app.string.cancel'));
      this.dialogController.open();
    } else {
      let dialogInfo: DialogInfo | undefined = AppStorage.get<DialogInfo>('dialogInfo');
      this.dialogTitle = dialogInfo?.title ?? $r('app.string.title_projection_fail');
      this.dialogMessage = dialogInfo?.message ?? $r('app.string.error_text_code_2');
      this.confirmButton = this.createConfirmButton(dialogInfo?.positiveButton);
      this.cancelButton = this.createCancelButton(dialogInfo?.negativeButton ?? $r('app.string.cancel'));
      this.dialogController.open();
    }
    log.showInfo('dialogInfo success');
    this.castDialogIsOpen = true;
  }

  onDropdownChanged() {
    if (this.dropDownEvent.target !== TargetPanel.CONTROL_CENTER_PANEL) {
      this.dialogController.close();
      this.privacyController.close();
      this.castDialogIsOpen = false;
    }
  }

  refreshCloseDialog() {
    if (!this.castDialogIsOpen) {
      this.dialogController.close();
      this.privacyController.close();
      AppStorage.setOrCreate<number>('castDialogCode', Constants.DIALOG_DEFAULT);
    }
  }

  /**
   * adapterLineHeight
   * @param boLanguageHeight bo language adapter line height
   * @returns if the language not bo return 0, bo return the line height
   */
  private adapterLineHeight(boLanguageHeight: number): Length {
    try {
      let locale: string = i18n.System.getSystemLanguage();
      return Constants.TIBETAN_LANGUAGES.includes(locale) ? boLanguageHeight : 0;
    } catch (error) {
      log.showError(`getSystemLanguage error code: ${error?.code}, message: ${error?.message}`);
    }
    return 0;
  }
}