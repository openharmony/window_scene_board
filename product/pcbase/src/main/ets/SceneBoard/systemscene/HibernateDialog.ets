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

import { LengthMetrics } from '@kit.ArkUI';
import { StyleConstants } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import power from '@ohos.power';
import batteryInfo from '@ohos.batteryInfo';
import KeyCodeConstants from '@ohos/multiinput/src/main/ets/default/common/constants/KeyCodeConstants';
import { PowerManagerEventType } from '@ohos/shutdownview/src/main/ets/utils/Constants';
import { hibernateDialogStyle } from './HibernateDialogStyle';
import { HibernateDialogChangeCallback, HibernateDialogFoldModel } from './ViewModel/HibernateDialogFoldModel';

const TAG = 'HibernateDialog';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@CustomDialog
export struct HibernateDialog {
  public dialogController?: CustomDialogController;
  private warningText: Resource = $r('app.string.confirm_hibernate');
  private cancelFontColor: ResourceColor = $r('sys.color.ohos_id_color_text_primary_activated');
  private warningFontColor: ResourceColor = $r('sys.color.ohos_id_color_warning');
  private cancelButtonBkgColor: ResourceColor = $r('sys.color.ohos_id_color_button_normal');
  private warningButtonHover: boolean = false;
  private shutdownTimer: number | undefined = 30000;
  @State cancelText: Resource | undefined = undefined;
  @State @Watch('judgeCancelText') countDownNumber: number = hibernateDialogStyle.countDownNumber;
  @Link offsetY: number;

  judgeCancelText() {
    this.cancelText = $r('app.plural.common_cancel', this.countDownNumber, this.countDownNumber);
  }

  countDown() {
    this.shutdownTimer = setInterval(() => {
      if (this.countDownNumber > 0) {
        log.showInfo(`remaining ${this.countDownNumber} second`);
        this.closeDialogDueToAc();
        this.countDownNumber--;
      } else {
        log.showInfo(`${hibernateDialogStyle.countDownNumber} seconds to close dialog`);
        HiSysEventUtil.reportHibernateDialog('timeout');
        clearInterval(this.shutdownTimer);
        this.dialogController?.close();
      }
    }, hibernateDialogStyle.shutdownTimerConstant);
  }

  private closeDialogDueToAc(): void {
    log.showInfo('closeDialogDueToAc start');
    let isCharging: boolean = batteryInfo.chargingStatus === batteryInfo.BatteryChargeState.ENABLE;
    if (isCharging) {
      log.showInfo('close hibernate dialog due to ac');
      HiSysEventUtil.reportHibernateDialog('ac');
      clearInterval(this.shutdownTimer);
      this.dialogController?.close();
      return;
    }
    if (batteryInfo.batteryCapacityLevel === batteryInfo.BatteryCapacityLevel.LEVEL_WARNING ||
      batteryInfo.batteryCapacityLevel === batteryInfo.BatteryCapacityLevel.LEVEL_LOW ||
      batteryInfo.batteryCapacityLevel === batteryInfo.BatteryCapacityLevel.LEVEL_NORMAL ||
      batteryInfo.batteryCapacityLevel === batteryInfo.BatteryCapacityLevel.LEVEL_HIGH ||
      batteryInfo.batteryCapacityLevel === batteryInfo.BatteryCapacityLevel.LEVEL_FULL) {
      log.showInfo(`close hibernate dialog due to SOC more than hibernate level`);
      HiSysEventUtil.reportHibernateDialog('SOC');
      clearInterval(this.shutdownTimer);
      this.dialogController?.close();
      return;
    }
    if (batteryInfo.batteryCapacityLevel === batteryInfo.BatteryCapacityLevel.LEVEL_SHUTDOWN) {
      log.showInfo(`close hibernate dialog due to SOC is low to shutdown`);
      HiSysEventUtil.reportHibernateDialog('shutdown');
      clearInterval(this.shutdownTimer);
      this.dialogController?.close();
      return;
    }
    return;
  }

  @Styles
  shutdownButtonStyle() {
    .width(hibernateDialogStyle.confirmButtonWidth)
    .height(hibernateDialogStyle.buttonHeight)
    .borderRadius(hibernateDialogStyle.confirmButtonBorderRadius)
  }

  @Builder
  ButtonBuilder() {
    Row() {
      Button(this.cancelText, { type: ButtonType.Normal, stateEffect: true })
        .defaultFocus(true)
        .id(hibernateDialogStyle.cancelButtonId)
        .shutdownButtonStyle()
        .backgroundColor(this.cancelButtonBkgColor)
        .margin({ start: LengthMetrics.vp(hibernateDialogStyle.confirmButtonSpacingSize) })
        .fontColor(this.cancelFontColor)
        .onClick(() => {
          log.showInfo('click cancel');
          HiSysEventUtil.reportHibernateDialog('cancel');
          clearInterval(this.shutdownTimer);
          this.dialogController?.close();
        })
      Button(this.warningText, { type: ButtonType.Normal, stateEffect: true })
        .shutdownButtonStyle()
        .backgroundColor(this.warningButtonHover ? $r('sys.color.ohos_id_color_hover') :
            $r('sys.color.ohos_id_color_button_normal'))
        .margin({ start: LengthMetrics.vp(hibernateDialogStyle.confirmButtonSpacingSize) })
        .fontColor(this.warningFontColor)
        .onHover((isHover: boolean) => {
          if (isHover) {
            this.warningButtonHover = true;
          } else {
            this.warningButtonHover = false;
          }
        })
        .onBlur(() => {
          focusControl.requestFocus(hibernateDialogStyle.cancelButtonId);
        })
        .onClick(() => {
          log.showInfo('click warning');
          HiSysEventUtil.reportHibernateDialog('warning');
          HiSysEventUtil.reportPowerManagerEvent(PowerManagerEventType.lowBatteryHibernate);
          clearInterval(this.shutdownTimer);
          this.dialogController?.close();
          power.hibernate(false);
        })
    }
    .width(StyleConstants.PERCENTAGE_100)
    .margin({ bottom: hibernateDialogStyle.buttonMarginBottom })
  }

  @Builder
  IconBuilder() {
    Stack() {
      Circle()
        .width(hibernateDialogStyle.iconWidth)
        .height(hibernateDialogStyle.iconHeight)
        .fill($r('sys.color.ohos_id_color_alert'))
        .margin({
          left: hibernateDialogStyle.iconMarginLeft,
          right: hibernateDialogStyle.iconMarginRight,
          top: hibernateDialogStyle.iconMarginTop,
          bottom: hibernateDialogStyle.iconMarginBottom,
        })
      Image($r('app.media.icon_battery_only'))
        .width(hibernateDialogStyle.iconWidth)
        .height(hibernateDialogStyle.iconHeight)
        .margin({
          left: hibernateDialogStyle.iconMarginLeft,
          right: hibernateDialogStyle.iconMarginRight,
          top: hibernateDialogStyle.iconMarginTop,
          bottom: hibernateDialogStyle.iconMarginBottom,
        })
    }
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    HiSysEventUtil.reportHibernateDialog('open');
    this.countDownNumber = hibernateDialogStyle.countDownNumber;
    this.countDown();
    this.judgeCancelText();
    HibernateDialogFoldModel.getInstance().registerHibernateDialogChangeCallback(this.hibernateDialogChangeCallback);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    HibernateDialogFoldModel.getInstance().unregisterHibernateDialogChangeCallback(this.hibernateDialogChangeCallback);
  }

  private hibernateDialogChangeCallback: HibernateDialogChangeCallback = {
    onCustomDialogOffsetYChange: (offsetY: number) => {
      log.showInfo(`onCustomDialogOffsetYChange, offsetY: ${offsetY}`);
      this.offsetY = offsetY;
    },
  }

  build() {
    Column() {
      this.IconBuilder();
      Text($r('app.string.low_battery_title'))
        .fontSize($r('sys.float.ohos_id_text_size_headline8'))
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Bold)
        .lineHeight(hibernateDialogStyle.titleLineHeight)
        .margin({
          left: hibernateDialogStyle.titleMarginLeft,
          right: hibernateDialogStyle.titleMarginRight,
          bottom: hibernateDialogStyle.titleMarginBottom,
        })
      Text($r('app.string.low_battery_tip', '5%'))
        .maxFontSize(hibernateDialogStyle.bigFontSize)
        .minFontSize(hibernateDialogStyle.minFontSize)
        .maxLines(hibernateDialogStyle.confirmTitleMaxLines)
        .heightAdaptivePolicy(TextHeightAdaptivePolicy.MAX_LINES_FIRST)
        .fontFamily('HarmonyHeiTi')
        .fontColor($r('sys.color.font_primary'))
        .fontWeight(FontWeight.Medium)
        .lineHeight(hibernateDialogStyle.tipLineHeight)
        .margin({
          left: hibernateDialogStyle.tipMarginLeft,
          right: hibernateDialogStyle.tipMarginRight,
          bottom: hibernateDialogStyle.tipMarginBottom,
        })
      this.ButtonBuilder();
    }
    .borderRadius(hibernateDialogStyle.confirmBorderRadius)
    .width(hibernateDialogStyle.confirmDialogWidth)
    .offset({ x: 0, y: this.offsetY })
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
    .onKeyEvent((event?: KeyEvent) => {
      if (event?.keyCode === KeyCodeConstants.KEYCODE_ESC && event?.type === KeyType.Up) {
        log.showInfo('close shutdown dialog due to esc');
        HiSysEventUtil.reportHibernateDialog('esc');
        clearInterval(this.shutdownTimer);
        this.dialogController?.close();
      }
    })
    .focusable(true)
  }
}