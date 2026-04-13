/**
  * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { LengthMetrics } from '@kit.ArkUI';
import systemparameter from '@ohos.systemParameterEnhance';
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { StyleConstants } from '../constants/StyleConstants';
import {
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import {
  DeviceHelper,
  localEventManager,
} from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { ResUtils } from '@ohos/windowscene';
import { DeviceState } from '../constants/CommonConstants';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { StyleConfig } from './StyleConfig';
import { EventConstants } from '../constants/EventConstants';
import { ReceiveEventInfo } from '../bean/ReceiveEventInfo';
import { DialogController, DialogControllerType } from '../viewmodel/DialogController';

const TAG = 'RemoveFormDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_BUTTON_WIDTH = '153vp';
const DEFAULT_PAD_BUTTON_WIDTH = 182;
const PAD_DIALOG_WIDTH = 400;

@CustomDialog
export struct RemoveFormDialog {
  @StorageLink('showUninstallDialog') @Watch('showUninstallDialogChange') showUninstallDialog: boolean = false;
  @StorageLink('folderStatus') @Watch('folderStatusChange') folderStatus: number = DeviceState.DEFAULT_STATE;
  controller?: CustomDialogController;
  cancel?: Function;
  confirm?: Function;
  @State dialogName: string | Resource = '';
  @State formName: string = '';
  @State isDialogShow: boolean = false;
  @State dialogOffsetY: Resource | string | number = 0;
  private isPc: boolean = DeviceHelper.isPC();
  private isPad: boolean = DeviceHelper.isPad();
  private isNewStyle: boolean = true;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.isDialogShow = true;
    this.isNewStyle = (systemparameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
    const dialogController = DialogController.getDialogController(DialogControllerType.DESKTOP_FORM);
    this.dialogOffsetY = dialogController?.getDialogOffsetY() ?? 0;
    localEventManager.registerEventListener(this.dialogOffsetChangeListener,
      [EventConstants.EVENT_UPDATE_DIALOG_POSITION]);
  }

  aboutToDisappear() {
    localEventManager.unregisterEventListener(this.dialogOffsetChangeListener);
  }

  private showUninstallDialogChange() {
    log.showInfo(`RemoveFormDialog showUninstallDialog=${this.showUninstallDialog}`);
    if (!this.showUninstallDialog) {
      this.controller?.close();
      this.cancel?.()
    }
  }

  private folderStatusChange(): void {
    if (this.isDialogShow) {
      log.showInfo(`RemoveFormDialog folderStatusChange: ${this.folderStatus}`);
      this.isDialogShow = false;
      this.controller?.close();
      this.cancel?.();
    }
  }

  private getDialogContent(): string {
    let dialogContent = ResUtils.getOutString($r('app.string.remove_form_dialog_content'));
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      dialogContent = ResUtils.getInnerStringNumS($r('app.string.pinch_to_enter_the_editing_page'),
        ResUtils.getOutString($r('app.string.add_form_to_desktop')), this.formName);
    }
    return dialogContent;
  }

  private readonly dialogOffsetChangeListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string) => {
      const dialogController = DialogController.getDialogController(DialogControllerType.DESKTOP_FORM);
      this.dialogOffsetY = dialogController?.getDialogOffsetY() ?? 0;
    }
  }

  @Builder
  platformAlertDialog() {
    AlertDialog({
      primaryTitle: this.dialogName,
      content: this.getDialogContent(),
      primaryButton: {
        value: $r('app.string.cancel'),
        background: !this.isPc ? StyleConstants.DEFAULT_BG_COLOR : StyleConstants.DEFAULT_BUTTON_COLOR_FORM_DIALOG,
        action: () => {
          this.controller?.close();
          this.cancel?.()
        },
      },
      secondaryButton: {
        value: $r('app.string.delete_form'),
        background: !this.isPc ? StyleConstants.DEFAULT_BG_COLOR : StyleConstants.DEFAULT_BUTTON_COLOR_FORM_DIALOG,
        fontColor: $r('sys.color.ohos_id_color_warning'),
        action: () => {
          this.controller?.close();
          this.confirm?.()
        }
      },
    })
  }

  @Builder
  customAlertDialog() {
    Column() {
      Row() {
        Text(this.dialogName).draggable(false)
          .id(`${TAG}_Text_dialogName`)
          .fontSize($r('sys.float.ohos_id_text_size_dialog_tittle'))
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .width(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .justifyContent(FlexAlign.Center)
      .padding({
        start: LengthMetrics.vp(StyleConstants.PADDING_LEFT),
        end: LengthMetrics.vp(StyleConstants.PADDING_RIGHT),
      })
      .margin({
        top: Math.floor(vp2px(StyleConstants.DEFAULT_2)) + 'px'
      })

      Row() {
        Text($r('app.string.remove_form_dialog_content')).draggable(false)
          .id(`${TAG}_Text_removeFormDiglogContent`)
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .fontWeight(StyleConstants.DEFAULT_FORM_FONT_CONTENT_WEIGHT)
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
      }
      .width(StyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .justifyContent(this.isPc ? FlexAlign.Center : FlexAlign.Start)
      .margin({
        top: DeviceHelper.isPhone() ? StyleConstants.DEFAULT_DIALOG_CONTENT_MARGIN_TOP :
          StyleConstants.PC_DIALOG_CONTENT_MARGIN_TOP,
        bottom: !this.isPc ? StyleConstants.DEFAULT_8 : StyleConstants.DEFAULT_16
      })
      .padding({
        start: LengthMetrics.vp(StyleConstants.PADDING_LEFT),
        end: LengthMetrics.vp(StyleConstants.PADDING_RIGHT),
      })

      Flex({ justifyContent: FlexAlign.SpaceEvenly }) {
        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Text($r('app.string.cancel')).draggable(false)
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
            .padding({top:DeviceHelper.isPC() ? StyleConstants.DEFAULT_1 : StyleConstants.DEFAULT_0})
        }.id(`${TAG}_Button_cancel`)
        .backgroundColor(!this.isPc ? StyleConstants.DEFAULT_BG_COLOR : StyleConstants.DEFAULT_BUTTON_COLOR_FORM_DIALOG)
        .height(StyleConstants.DEFAULT_BUTTON_HEIGHT)
        .width(StyleConfig.buttonStyle().width)
        .margin({
          start: this.isPad ? LengthMetrics.vp(StyleConstants.DEFAULT_16) : LengthMetrics.vp(StyleConstants.DEFAULT_0),
          end: this.isPad ? LengthMetrics.vp(StyleConstants.DEFAULT_4) : LengthMetrics.vp(StyleConstants.DEFAULT_0),
        })
        .borderRadius(StyleConstants.PC_DIALOG_BUTTON_RADIUS)
        .onClick(() => {
          this.controller?.close();
          this.cancel?.()
        })

        if (StyleConfig.showDivider()) {
          Divider().vertical(true).height(StyleConstants.DEFAULT_DIVIDER_HEIGHT)
            .color($r('sys.color.ohos_id_color_list_separator'))
            .alignSelf(ItemAlign.Center)
        }

        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Text($r('app.string.delete_form')).draggable(false)
            .fontSize($r('sys.float.ohos_id_text_size_button1'))
            .fontColor($r('sys.color.ohos_id_color_warning'))
            .padding({top:DeviceHelper.isPC() ? StyleConstants.DEFAULT_1 : StyleConstants.DEFAULT_0})
            .focusable(true)
        }.id(`${TAG}_BUtton_deleteForm`)
        .backgroundColor(!this.isPc ? StyleConstants.DEFAULT_BG_COLOR : StyleConstants.DEFAULT_BUTTON_COLOR_FORM_DIALOG)
        .height(StyleConstants.DEFAULT_BUTTON_HEIGHT)
        .width(StyleConfig.buttonStyle().width)
        .margin({
          start: this.isPad ? LengthMetrics.vp(StyleConstants.DEFAULT_4) : LengthMetrics.vp(StyleConstants.DEFAULT_0),
          end: this.isPad ? LengthMetrics.vp(StyleConstants.DEFAULT_16) : LengthMetrics.vp(StyleConstants.DEFAULT_0),
        })
        .borderRadius(StyleConstants.PC_DIALOG_BUTTON_RADIUS)
        .defaultFocus(true)
        .onClick(() => {
          this.controller?.close();
          this.confirm?.()
        })
        .onKeyEvent((keyEvent?: KeyEvent) => {
          log.showInfo(`RemoveFormDialog onKeyEvent  keyCode: ${keyEvent?.keyCode}`);
          if (keyEvent?.keyCode === KeyCode.KEYCODE_ENTER) {
            this.controller?.close();
            this.confirm?.();
          }
        })
      }
    }

    .backgroundBlurStyle(DeviceHelper.isPC() ? BlurStyle.COMPONENT_ULTRA_THICK : BlurStyle.Regular,
      { policy: 1 }, { disableSystemAdaptation: true })
    .shadow(ShadowStyle.OUTER_DEFAULT_LG)
    .padding({
      top: DeviceHelper.isPhone() ? StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN :
        StyleConstants.PC_DIALOG_BOTTOM_MARGIN,
      bottom: !this.isPc ? StyleConstants.DEFAULT_DIALOG_BOTTOM_MARGIN : StyleConstants.PC_DIALOG_BOTTOM_MARGIN
    })
    .margin({
      start: LengthMetrics.vp(StyleConstants.DEFAULT_16),
      end: LengthMetrics.vp(StyleConstants.DEFAULT_16),
    })
    .border({
      radius: $r('sys.float.ohos_id_corner_radius_dialog')
    })
    .width(StyleConfig.rootContainerStyle().width)
    .visibility(this.isDialogShow ? Visibility.Visible : Visibility.Hidden)
    .offset({ x: 0, y: this.dialogOffsetY })
  }

  build() {
    if (this.isNewStyle && !this.isPc) {
      this.platformAlertDialog();
    } else {
      this.customAlertDialog();
    }
  }
}
