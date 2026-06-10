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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationVmInjector, NotificationSettingMenu, ResourceVm,
  NotificationSettingMenuType } from '@ohos/systemuicommon/newIndex';
import { curves, LengthMetrics } from '@kit.ArkUI';
import { NotificationStyle } from '../constants/NotificationStyle';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import { NotificationPinTopLimitDialog } from '@ohos/systemuicommon/src/main/ets/view/NotificationPinTopLimitDialog';
import { NotificationSilenceDialogView } from '@ohos/systemuicommon/src/main/ets/view/NotificationSilenceDialogView';

const TAG = 'NotificationSettingDialogView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const FONT_FAMILY = 'HarmonyHeiTi';
const PANEL_CURVES = curves.cubicBezierCurve(0.33, 0, 0.67, 1);

@ComponentV2
export struct NotificationSettingDialogView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  private colorVm = this.ntfVmInjector.getColorVm();

  @Computed
  get dialogVm() {
    const pinTopDialogVm = this.ntfVmInjector.getPinTopDialogVm();
    const controller: CustomDialogController = new CustomDialogController({
      builder: NotificationPinTopLimitDialog({
        pinTopDialogVm: pinTopDialogVm,
      }),
      autoCancel: false,
      gridCount: 4,
      customStyle: false,
      cancel: pinTopDialogVm.cancel,
    });
    const silenceVm = this.ntfVmInjector.getSilenceVm();
    const diagVm = this.ntfVmInjector.getSettingDiagVm();
    const silenceController: CustomDialogController = new CustomDialogController({
      builder: NotificationSilenceDialogView({
        silenceVm: silenceVm,
      }),
      autoCancel: true,
      gridCount: 4,
      customStyle: true,
      cancel:()=>{
        diagVm?.hide();
        silenceVm.onCancel();
      },
    });
    pinTopDialogVm.init(notificationConfigManager, controller);
    silenceVm.init(notificationConfigManager, silenceController);
    return this.ntfVmInjector.getSettingDiagVm();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.dialogVm?.init();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
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
      .id(`${TAG}_button`)
      .width($r('app.float.ntf_item_menu_icon_size'))
      .height($r('app.float.ntf_item_menu_icon_size'))
      .backgroundColor(this.colorVm.menuButtonBgColor)
      .backgroundBrightnessInternal(this.colorVm.buttonBgBrightness)
      .margin(this.dialogVm?.settingDiagData.buttonPosition)
      .bindMenu(this.dialogVm?.settingDiagData.isShowDialog, this.buildSettingMenu(), {
        placement: Placement.BottomRight,
        transition: TransitionEffect.asymmetric(
          TransitionEffect.scale({ x: 0.95, y: 0.95 })
            .animation({ duration: 350, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1) })
            .combine(TransitionEffect.opacity(0)
              .animation({ duration: 350, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1) })),
          TransitionEffect.scale({ x: 0.95, y: 0.95 })
            .animation({ duration: 100, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1), delay: 55 })
            .combine(TransitionEffect.opacity(0)
              .animation({ duration: 100, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), delay: 55 })
            )
        ),
        onAppear: () => {
          if (this.dialogVm) {
            this.dialogVm.showHideButton = true;
          }
        },
        onDisappear: () => {
          if (this.dialogVm?.showHideButton) {
            this.dialogVm?.hide();
          }
        }
      })
    }
    .id(TAG)
    .width('100%')
    .height('100%')
    .backgroundBlurStyle(this.dialogVm?.settingDiagData.isShowDialog ? BlurStyle.BACKGROUND_ULTRA_THICK :
    BlurStyle.NONE, {
      colorMode: ThemeColorMode.LIGHT,
      adaptiveColor: AdaptiveColor.DEFAULT,
      scale: 0.1,
      blurOptions: { grayscale: this.dialogVm?.settingDiagData.isShowDialog ? [38, 38] : [0, 0] }
    })
    .animation({ duration: this.dialogVm?.settingDiagData.isShowDialog ? 250 : 100, curve: PANEL_CURVES, })
    .visibility(this.dialogVm?.settingDiagData.isShowButton ? Visibility.Visible : Visibility.None)
  }

  @Builder
  buildSettingMenu() {
    if (this.dialogVm?.settingDiagData.isShowDialog) {
      Column() {
        this.buildTitle()
        ForEach(this.dialogVm?.settingDiagData.menus, (menu: NotificationSettingMenu, index?: number) => {
          if (index !== undefined && index > 0) {
            Divider()
              .vertical(false)
              .color($r('sys.color.ohos_id_color_list_separator'))
              .margin({
                left: $r('app.float.ntf_content_padding_start_end'),
                right: $r('app.float.ntf_content_padding_start_end')
              })
          }
          this.buildMenuItem(menu, index)
        }, (menu: NotificationSettingMenu, index?: number) => menu.type)
      }
      .id(this.dialogVm.componentId)
      .width($r('app.float.ntf_settings_dialog_width'))
      .borderRadius($r('app.float.ntf_settings_dialog_border_radius'))
    }
  }

  @Builder
  buildTitle() {
    Text(this.dialogVm?.settingDiagData.dialogTitle)
      .draggable(false)
      .id(TAG + '_AppName')
      .fontSize($r('app.float.ntf_title_font_size'))
      .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontWeight(FontWeight.Medium)
      .fontFamily('HarmonyHeiTi')
      .constraintSize({ minHeight: $r('app.float.ntf_settings_dialog_app_name_height') })
      .width('100%')
      .padding({
        left: $r('app.float.ntf_item_padding_start_end'),
        right: $r('app.float.ntf_item_padding_start_end'),
        top: $r('app.float.ntf_settings_dialog_app_name_margin_top')
      })
  }

  @Builder
  buildMenuItem(menu: NotificationSettingMenu, index?: number) {
    MenuItem() {
      Text(menu.title)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .fontWeight(FontWeight.Medium)
        .fontFamily(FONT_FAMILY)
        .fontColor(menu.type === NotificationSettingMenuType.CLOSE ? $r('sys.color.ohos_id_color_warning') : undefined)
        .constraintSize({
          minHeight: $r('app.float.ntf_settings_dialog_menu_item_height')
        })
        .width('100%')
        .padding({
          top: $r('app.float.ntf_content_padding_start_end'),
          bottom: $r('app.float.ntf_content_padding_start_end')
        })
    }
    .id(`${TAG}_menu_${menu.type}`)
    .width('100%')
    .contentFontColor($r('sys.color.ohos_id_color_text_primary'))
    .margin(index === 0 ? {
      top: $r('app.float.ntf_settings_dialog_menu_item_margin')
    } : undefined)
    .borderRadius($r('app.float.ntf_settings_dialog_menu_item_border_radius'))
    .padding({
      left: $r('app.float.ntf_content_padding_start_end'),
      right: $r('app.float.ntf_content_padding_start_end')
    })
    .onClick(menu.onClick)
  }
}