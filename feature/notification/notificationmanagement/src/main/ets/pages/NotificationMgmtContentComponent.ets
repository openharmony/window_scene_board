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

import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { DeviceHelper } from '@ohos/managementcomponent';
import { FontScaleState, fontScaleManager } from '@ohos/managementcomponent';
import { LabelToggleView, SlotsView, VisualReminderView } from './NotificationMgmtCompments';
import {
  AppVersionInfo,
  NotificationMgmtViewData, ObservedArray, VisualReminderConfig } from '../vm/NotificationMgmtViewData';
import { PinTopLimitDialog, PinTopDialogOption
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { RemindType } from '../common/NotificationMgmtCommon';
import { LengthMetrics } from '@ohos.arkui.node';
import { SystemParameterUtil } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/SystemParameterUtil';
import {
  notificationSettingManager
} from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/NotificationSettingManager';
import { NotificationMgmtHalfModeViewEvent } from '../vm/NotificationMgmtHalfModeViewEvent';
import { AppIconWithIndexSubIcon } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicUiCommon';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import SelectComponent from './SelectComponent';
import { StatusBarModel } from '../model/StatusBarModel';
import NtfConfigUtil from '../config/NtfConfigUtil';
import NtfSettingUtil from '@ohos/managementcomponent/src/main/ets/com/ohos/common/NtfSettingUtil';

const TAG = 'NotificationMgmtContent_Component';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const APP_ICON_ID = TAG + '_APP_ICON';

const borderRadius: Length = DeviceHelper.isPC() ? '16vp' : '20vp';
const containerBorder: BorderOptions = { color: $r('app.color.card_panel_bg'), radius: borderRadius };

@Component
export struct NotificationMgmtContentComponent {
  private appInfo: ESObject = {};
  @State visualReminderConfigs: ObservedArray<VisualReminderConfig> = new ObservedArray();
  private eventView: NotificationMgmtHalfModeViewEvent = new NotificationMgmtHalfModeViewEvent();
  @Provide pinTopLimitDialogClose: boolean = true;
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @Link viewData: NotificationMgmtViewData;
  @ObjectLink appVersionInfo: AppVersionInfo;
  // 单个菜单按钮边距
  private singleMenuPadding: Padding = this.getMenuPadding();
  // 列表菜单按钮边距
  private listMenuPadding: Padding = this.getMenuPadding(0);

  aboutToAppear(): void {
    log.showInfo('AboutToAppear.');
    this.eventView.initDialog(this.buildPinTopExceededDialogController);
    this.eventView.load();
    this.setVisualReminderConfigs();
  }

  aboutToDisappear(): void {
    log.showInfo('AboutToDisappear.');
  }

  private async setVisualReminderConfigs(): Promise<void> {
    log.showInfo('setVisualReminderConfigs.');
    if (!DeviceHelper.isPC()) {
      this.visualReminderConfigs.push({
        label: $r('app.string.lock_screen_notification'),
        viewData: this.viewData.getScreenLockReminderViewData(),
        onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.LOCK_SCREEN, isOn)
      });
    }
    this.visualReminderConfigs.push({
      label: $r('app.string.banners'),
      viewData: this.viewData.getBannerReminderViewData(),
      onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.BANNER, isOn)
    });
    if (await notificationSettingManager.hasLauncher(this.appInfo?.['appBundleName'], this.appInfo?.['appUid'])) {
      this.visualReminderConfigs.push({
        label: $r('app.string.badges'),
        viewData: this.viewData.getCornerReminderViewData(),
        onChange: (isOn: boolean) => this.eventView.badgeStateChanged(isOn)
      });
    }
  }

  build() {
    Scroll() {
      Column() {
        this.buildBundleInfoView();
        this.buildEnableView();
        if (this.viewData.isOn()) {
          this.buildPinTopView();
          this.buildRemindersView();
          this.buildSlotsView();
        }
      }
      .padding({ bottom: 36 })
      .margin({ end: LengthMetrics.resource($r('app.float.ntf_half_mode_view_margin_end')) })
    }
    .align(Alignment.Top)
    .edgeEffect(EdgeEffect.Spring)
    .scrollBar(DeviceHelper.isPC() ? BarState.On : BarState.Off)
    .padding({end: LengthMetrics.resource($r('app.float.ntf_half_mode_padding_end'))})
    .layoutWeight(1)
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  buildBundleInfoView() {
    Row() {
      this.buildIcon()

      Column() {
        Text(this.appVersionInfo.appTitle)
          .id('NotificationMgmtView_BUNDLE_NAME')
          .fontColor($r('sys.color.ohos_id_color_text_primary'))
          .fontSize($r('sys.float.ohos_id_text_size_body1'))
          .maxFontScale(2)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Start)
          .margin({ bottom: 4 })

        Text($r('app.string.version', this.appVersionInfo.appVersion))
          .id('NotificationMgmtView_BUNDLE_VERSION')
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(2)
          .fontWeight(FontWeight.Regular)
          .textAlign(TextAlign.Start)
      }
      .margin({ start: LengthMetrics.vp(12) })
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Start)
    }
    .padding({
      start: LengthMetrics.vp(8),
      end: LengthMetrics.vp(64)
    })
    .constraintSize({ minHeight: 96 })
    .width('100%')
    .margin({top: 8})
  }

  @Builder
  buildIcon() {
    AppIconWithIndexSubIcon({
      index: this.appInfo.appIndex,
      compAlignRules: {
        top: { anchor: '__container__', align: VerticalAlign.Top },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      },
      appIcon: this.appVersionInfo.appIcon,
      appIconId: APP_ICON_ID,
      appIconSize: LengthMetrics.resource($r('app.float.appitem_notice_info_icon_width_l')).value
    })
  }

  @Builder
  buildEnableView() {
    LabelToggleView({
      label: $r('app.string.allowNotification'),
      state: this.viewData.getAllowState(),
      onChange: this.eventView?.allowStateChanged,
      isEnabled: this.viewData.isEnabled(),
      properties: {
        height: $r('app.float.switchComp_height'),
        bgColor: $r('sys.color.ohos_id_color_card_bg'),
        border: containerBorder,
        padding: this.singleMenuPadding
      }
    })
  }

  @Builder
  buildPinTopView() {
    if (this.viewData?.isNativeApp()) {
      LabelToggleView({
        label: $r('app.string.pinTopShowNotification'),
        state: this.viewData.getPinTopState(),
        onChange: this.eventView.pinTopStateChanged,
        properties: {
          margin: { top: $r('app.float.ntf_setting_item_margin') },
          height: $r('app.float.switchComp_height'),
          border: {
            width: $r('app.float.border_width'),
            color: $r('sys.color.ohos_id_color_card_bg'),
            radius: borderRadius
          },
          bgColor: $r('sys.color.ohos_id_color_card_bg'),
          padding: this.singleMenuPadding
        }
      })
    }
  }

  @Builder
  buildRemindersView() {
    Text($r('app.string.notification_style'))
      .draggable(false)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontSize($r('sys.float.ohos_id_text_size_body2'))
      .maxFontScale(2)
      .fontWeight(FontWeight.Medium)
      .fontFamily('HarmonyHeiTi-Medium')
      .margin({ left: 12, top: $r('app.float.notification_style_margin_top'), bottom: 8 })
      .constraintSize({
        minHeight: 20
      })
      .alignSelf(ItemAlign.Start)

    this.buildSilenceView();
    this.buildVisualReminderViews()
    this.buildNonVisualReminderViews()
  }

  @Builder
  buildVisualReminderViews() {
    VisualReminderView({
      remindConfigs: this.visualReminderConfigs,
      containerBorder: containerBorder,
      isHalfMode: true,
      silenceState: this.viewData.getSilenceState(),
    })
  }

  @Builder
  buildNonVisualReminderViews() {
    if (DeviceHelper.isPC()) {
      Column() {
        SelectComponent({
          title: $r('app.string.hide_banner_content_title'),
          opts: [$r('app.string.hide_banner_content_app_follow_system'),
            $r('app.string.hide_banner_content_app_always'),
            $r('app.string.hide_banner_content_app_never')],
          selectedIndex: this.viewData.getHideBannerContentReminder(),
          settingAction: this.eventView.hideBannerContentChanged
        })
      }
      .margin({ top: 12 })
      .padding({ top: $r('app.float.hide_banner_content_title_padding'),
        bottom: $r('app.float.hide_banner_content_title_padding') })
      .border(containerBorder)
      .backgroundColor($r('sys.color.comp_background_list_card'))
    }

    Column() {
      LabelToggleView({
        label: $r('app.string.remind_sound'),
        state: this.viewData.getSoundReminderState(),
        onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.SOUND, isOn),
        properties: { height: 48, padding: this.listMenuPadding },
        silenceState: this.viewData.getSilenceState(),
      });

      if (!DeviceHelper.isPC() && SystemParameterUtil.IS_SUPPORT_VIBRATE) {
        Divider()
          .strokeWidth('1px')
          .color($r('sys.color.ohos_id_color_list_separator'))
          .margin({ left: 12, right: 12 });

        LabelToggleView({
          label: $r('app.string.ntfSoundModeOnlyVibration'),
          state: this.viewData.getVibrationReinderState(),
          onChange: (isOn: boolean) => this.eventView.remindStateChanged(RemindType.VIBRATION, isOn),
          properties: { height: 48, padding: this.listMenuPadding },
          silenceState: this.viewData.getSilenceState(),
        });
      }
    }
    .margin({ top: 12 })
    .padding({ top: $r('app.float.remind_sound_padding'), bottom: $r('app.float.remind_sound_padding') })
    .border(containerBorder)
    .backgroundColor($r('sys.color.ohos_id_color_card_bg'))
  }

  @Builder
  buildSlotsView() {
    SlotsView({
      slots: this.viewData.getSlotsViewData(),
      properties: { border: containerBorder, padding: this.listMenuPadding },
      onSlotChange: this.eventView.slotStateChanged,
    })
  }

  @Builder
  buildSilenceView() {
    LabelToggleView({
      label: $r('app.string.silent_notification'),
      state: this.viewData.getSilenceState(),
      onChange: this.eventView.silentStateChanged,
      properties: {
        margin: { top: $r('app.float.ntf_setting_item_margin') },
        height: $r('app.float.switchComp_height'),
        border: {
          width: $r('app.float.border_width'),
          color: $r('app.color.card_panel_bg'),
          radius: borderRadius
        },
        bgColor: $r('sys.color.comp_background_list_card')
      }
    })
    this.buildSilenceContentTxt();
  }

  @Builder
  buildSilenceContentTxt() {
    Row() {
      Text() {
        Span($r('app.string.silent_notification_description'))
      }
      .width('100%')
      .fontSize(12)
      .maxFontScale(2)
      .fontFamily('HarmonyHeiTi')
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .fontWeight(FontWeight.Regular)
      .constraintSize({ minHeight: $r('app.float.ntf_hide_banner_txt_lineHeight') })
    }
    .margin({
      top: $r('app.float.ntf_hide_banner_txt_margin'),
      bottom: $r('app.float.title_text_margin_start')
    })
    .width('100%')
    .padding({
      left: $r('app.float.ntf_hide_banner_txt_padding'),
      right: $r('app.float.ntf_hide_banner_txt_padding')
    })
  }

  private buildPinTopExceededDialogController = (option: PinTopDialogOption): CustomDialogController => {
    return new CustomDialogController({
      builder: PinTopLimitDialog({
        limit: option.limit,
        onSelected: option.onSelected,
        onCancel: option.onCancel,
        dialogWidth: NtfConfigUtil.dialogWidth,
        statusBarHeight: StatusBarModel.get().height,
        windowWidth: ContextManager.windowWidthByVp,
      }),
      autoCancel: false,
      alignment: NtfConfigUtil.alignment,
      showInSubWindow: NtfConfigUtil.showInSubWindow,
      customStyle: NtfConfigUtil.customStyle,
      width: NtfConfigUtil.dialogWidth,
      height: NtfConfigUtil.dialogHeight,
      cornerRadius: NtfConfigUtil.cornerRadius,
      backgroundBlurStyle: BlurStyle.NONE
    })
  };

  // 适老化布局，菜单按钮内边距取值 默认8vp；字体1.75倍以上16vp；字体2倍以上20vp
  private getMenuPadding(basePadding: number = 4): Padding {
    let paddingValue: number =
      this.fontScaleState.fontSizeScale < 1.75 ? 8 : (this.fontScaleState.fontSizeScale < 2 ? 16 : 20);
    return { top: paddingValue + basePadding, bottom: paddingValue + basePadding };
  }
}