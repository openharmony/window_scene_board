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
import { IUserData } from '@ohos/screenlockcommon';
import PowerDialog from './PowerDialog';

const TAG = 'ScreenLock-PowerMenuItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const COMPONENT_ID_BACKGROUND = TAG + '_Image_background';
const COMPONENT_ID_ICON = TAG + '_Image_icon';
const COMPONENT_ID_TXT = TAG + '_Text_state';

/**
 * 电源三键按钮，关机、重启、休眠
 */
@Component
export struct PowerMenuItem {
  @Prop
  private txt: Resource | undefined = undefined;
  private iconRes: Resource | undefined = undefined;
  private dialogMsg: Resource | undefined = undefined;
  private powerType?: PowerMenuType | undefined = undefined;
  private onDialogShow: () => void = () => {};
  private onDialogCancel: () => void = () => {};
  @State
  private fgColor: Resource = $r('app.color.power_item_dark_color');
  @StorageLink('userList')
  private accountList: IUserData[] = [];
  @StorageLink('isScreenLockWallpaperBrightOrDark') @Watch('changFgColor')isBrightOrDark: boolean = true;
  @State
  private fontColor: Resource = $r('app.color.power_text_dark_color');

  private onConfirm:() => void = () =>{
    log.showInfo('onConfirm this.powerType =' + this.powerType);
    if (this.powerType != undefined) {
      ViewModel.handlePowerMenuClick(this.powerType);
    }
  }

  private onCancel:() => void = () =>{
    log.showInfo('onCancel this.powerType =' + this.powerType);
    this.onDialogCancel();
  }

  /**
   * 二次确认弹框
   */
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: PowerDialog({
      positiveButton: this.txt,
      dialogMessage: this.dialogMsg,
      onConfirm: this.onConfirm,
      onCancel:this.onCancel
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
  })

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    // 初始化时StorageLink的变化不会触发watch
    this.changFgColor();
  }

  /**
   *
   */
  private changFgColor(): void {
    this.fgColor = this.isBrightOrDark ? $r('app.color.power_item_bright_color') : $r('app.color.power_item_dark_color');
    this.fontColor = this.isBrightOrDark ? $r('app.color.power_text_bright_color') : $r('app.color.power_text_dark_color');
  }

  private onMenuClick:() => void = () =>{
    log.showInfo('onclicked');
    if (this.powerType === PowerMenuType.DORMANT) {
      ViewModel.handlePowerMenuClick(this.powerType);
    } else {
      this.dialogController.open();
      this.onDialogShow();
    }
  }

  /**
   * PowerMenuItem build
   */
  public build(): void {
    Column({ space: ResUtils.getNumber($r('app.float.screenLock_power_item_space')) }) {
      Button({ type: ButtonType.Normal, stateEffect: false }) {
        Column() {
          Image(this.iconRes).draggable(false)
            .id(COMPONENT_ID_ICON + this.powerType)
            .height($r('app.float.screenLock_power_image_width'))
            .width($r('app.float.screenLock_power_image_height'))
            .objectFit(ImageFit.Contain)
            .fillColor(this.fgColor)
            .focusable(true)
            .borderRadius($r('app.float.screenLock_power_image_border_radio'))
        }
        .height($r('app.float.screenLock_power_column_width'))
        .width($r('app.float.screenLock_power_column_height'))
        .borderRadius($r('app.float.screenLock_power_column_border_radio'))
        .border({
          width: $r('app.float.screenLock_power_button_border_width'),
          color: $r('app.color.power_item_inner_border_color'),
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Center)
      }
      .onClick(this.onMenuClick)
      .onKeyEvent((event?: KeyEvent) => {
        if (event != undefined && this.accountList?.length !== 0) {
          ViewModel.dispatchKeyEvent(event, this.powerType!, this.onMenuClick);
        }
      })
      .backgroundColor(this.isBrightOrDark ? $r('app.color.bg_color_bright') : $r('app.color.bg_color_dark'))
      .backdropBlur(100, undefined, { disableSystemAdaptation: true })
      .saturate(1.4)
      .height($r('app.float.power_image_height'))
      .width($r('app.float.power_image_width'))
      .border({
        width: $r('app.float.screenLock_power_button_border_width'),
        color: $r('app.color.power_item_out_border_border'),
        style: BorderStyle.Solid
      })
      .borderRadius($r('app.float.focus_radius'))

      Text(this.txt).draggable(false)
        .id(COMPONENT_ID_TXT + this.powerType)
        .fontSize($r('app.float.powermenu_font_size'))
        .fontColor(this.fontColor)
        .width($r('app.float.power_text_width'))
        .height($r('app.float.powermenu_txt_height'))
        .fontFamily($r('app.float.menu_font_family'))
        .fontWeight(FontWeight.Medium)
        .align(Alignment.Center)
        .textAlign(TextAlign.Center)
        .textShadow({color: $r('app.color.power_text_shadow_color'), radius: this.isBrightOrDark ? 0 : 2, offsetY: 1})
        .clip(false)
    }
    .alignItems(HorizontalAlign.Center)
  }
}

/**
 * MENU type
 */
export enum PowerMenuType {
  POWER_OFF, RESTART, DORMANT
}