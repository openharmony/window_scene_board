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

import { NtfSettingsDialog } from './NtfSettingsDialog';
import { NotificationType } from '../../common/NotificationType';
import { BlurButtonVM, blurButtonVM } from '../../vm/BlurButtonVM';
import { ScreenLockBlurButtonVM, screenLockBlurButtonVM } from '../../vm/ScreenLockBlurButtonVM'
import { ntfSettingsDC } from '../../controller/NtfSettingsDialogController';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { ColorModeViewData,
  ColorModeViewModel } from '@ohos/systemuicommon/Index';
import curves from '@ohos.curves';
import { NotificationConfig } from '../../common/NotificationConfig';
import { ScreenOnOffListener, ScreenOnOffService } from '@ohos/screenlockcommon/src/main/ets/services/ScreenOnOffService';
import { ColorModeNCViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeNCViewData';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'NotificationSettingBtn');

@Component
export struct NotificationSettingBtn {
  /**
   * 朗读模式是否开启
   */
  @StorageLink('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 背景模糊VM
   */
  @State blurButtonVM: BlurButtonVM | ScreenLockBlurButtonVM = blurButtonVM;
  /**
   * 背景模糊VM-锁屏
   */
  @State screenLockBlurButtonVM: ScreenLockBlurButtonVM = screenLockBlurButtonVM;
  /**
   * 灰阶提亮参数
   */
  colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private colorModeNCViewData: ColorModeNCViewData = ColorModeViewModel.getInstance().getNCViewData();

  /**
   * 是否显示设置菜单
   */
  @State isShowSettingMenu: boolean = false;

  @Consume closeNtfDialogClose: boolean;
  @Consume pinTopLimitDialogClose: boolean;
  @Consume ntfSilenceDialogClose: boolean;

  /**
   * 区分显示的pannel类型：锁屏、通知中心
   */
  private type: number = NotificationType.TYPE_PHONE_DROPDOWN;

  private readonly _screenOnOffListener: ScreenOnOffListener = {
    onPreBeginSleep: (): void => {
      this.isShowSettingMenu = false;
      this.closeNtfDialogClose = true;
      this.pinTopLimitDialogClose = true;
      this.ntfSilenceDialogClose = true;
      this.unblur(true);
    }
  };

  aboutToAppear(): void {
    // 监听亮灭屏事件
    ScreenOnOffService.getInstance().registerObserver(this._screenOnOffListener);
  }

  aboutToDisappear(): void {
    // 取消监听亮灭屏事件
    ScreenOnOffService.getInstance().unRegisterObserver(this._screenOnOffListener);
  }

  build() {
    RelativeContainer() {
      Button({
        type: ButtonType.Circle,
        stateEffect: true
      }) {
        Image($r('app.media.ic_public_more'))
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.ntf_phone_menu_bg_color'))
          .width($r('app.float.ntf_action_send_icon_size'))
          .height($r('app.float.ntf_action_send_icon_size'))
      }
      .onClick(this.isAccessibilityMode ? () => {
        this.unblur();
      } : undefined)
      .accessibilityText(this.isAccessibilityMode ?
      ResUtils.getInnerString($r('app.string.accessibility_notification_setting_bar')) : ''
      )
      .width($r('app.float.ntf_item_menu_icon_size'))
      .height($r('app.float.ntf_item_menu_icon_size'))
      .backgroundColor(this.colorModeViewData.calcPrimarySolidColor(
        $r('app.color.ntf_phone_clear_button_bg_color'), this.colorModeViewData.themeAllClearButtonBgOptions,
        this.colorModeNCViewData.pickColor))
      .backgroundBrightnessInternal(this.colorModeViewData.getNCBrightnessOption(
        this.colorModeViewData.themeAllClearButtonBgOptions))
      .margin(NotificationType.isKeyguard(this.type) ? this.screenLockBlurButtonVM.getButtonMargin()
        : this.blurButtonVM.getButtonMargin())
      .bindMenu(this.getDialogVisible(), this.buildNtfSettingsDialog(), {
        placement: Placement.BottomRight,
        transition: TransitionEffect.asymmetric(
          NotificationConfig.SETTING_DIALOG_APPEAR_ANIM_TRANSITION_EFFECT,
          NotificationConfig.SETTING_DIALOG_DISAPPEAR_ANIM_TRANSITION_EFFECT
        ),
        onDisappear: () => {
          this.isShowSettingMenu = false;
          this.unblur();
        }
      })
    }
    .width('100%')
    .height('100%')
    .onTouch((event?: TouchEvent) => {
      if (event?.type === TouchType.Up) {
        this.isShowSettingMenu = false;
        this.unblur();
      }
    })
    .visibility(this.getVisibility())
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      this.isShowSettingMenu = isVisible;
    })
  }

  @Builder
  buildNtfSettingsDialog() {
    NtfSettingsDialog({
      dialogVM: ntfSettingsDC.getSettingsDialogVM(this.type),
      ntfType: this.type,
      changeAppPinTopConfig:
      ntfSettingsDC.getSettingEvents(this.type)?.changeAppPinTopConfig,
      changeSilenceConfig:
      ntfSettingsDC.getSettingEvents(this.type)?.changeSilenceConfig,
    })
  }
  private getDialogVisible(): boolean {
    // 消失时弹窗需要在按钮前消失
    let isButtonClick = NotificationType.isKeyguard(this.type) ? this.screenLockBlurButtonVM.getIsButtonClick()
      : this.blurButtonVM.getIsButtonClick();
    if (this.isShowSettingMenu) {
      return isButtonClick;
    }
    return this.isShowSettingMenu;
  }
  private unblur(closeBlur?: boolean) {
    if (NotificationType.isKeyguard(this.type)) {
      this.screenLockBlurButtonVM.unblur(closeBlur);
      return;
    }
    this.blurButtonVM.unblur();
  }

  /**
   * 设置按钮的显隐设置
   */
  private getVisibility(): Visibility {
    if (NotificationType.isKeyguard(this.type)) {
      if (this.screenLockBlurButtonVM.getIsDialogDirectHidden()) {
        return Visibility.None;
      }
      return this.screenLockBlurButtonVM.getShouldBlur() ? Visibility.Visible : Visibility.None;
    }
    return this.blurButtonVM.getShouldBlur() ? Visibility.Visible : Visibility.None;
  }
}