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

import BatteryInfo from '@ohos.batteryInfo';
import { BatterySocVm } from '@ohos/batterycomponent/src/main/ets/default/batteryModel';
import { CommonStyle, StyleConfigurationCommon } from '@ohos/systemuicommon';
import StyleConfiguration, {
  BatteryComponentStyle
} from '@ohos/batterycomponent/src/main/ets/default/common/StyleConfiguration';
import Constants from '@ohos/batterycomponent/src/main/ets/default/common/constants';
import charger from '@ohos.charger';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { BatterySoc } from '../common/BatteryConstants';

const TAG: string = 'BatteryIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const ICON_HEIGHT: string = '36px';

interface IconConfig {
  showBatterySoc: boolean;
}

/**
 * 电池
 */
@Component
export default struct BatteryIcon {
  @State mIconConfig: IconConfig = {
    showBatterySoc: true,
  };
  @StorageLink('batterySoc') batterySoc: number = 100;
  @StorageLink('batteryCharging') batteryCharging: boolean = false;
  @StorageLink('batteryPluggedType') batteryPluggedType: BatteryInfo.BatteryPluggedType = 0;
  @StorageLink('chargerType') chargerType: charger.ChargeType = charger.ChargeType.NONE;
  @StorageLink('powerSaveMode') powerSaveMode: number = Constants.POWER_SAVE_MODE_OFF;
  @State isClip: boolean = false;
  @State style: BatteryComponentStyle = StyleConfiguration.getBatteryComponentStyle();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  private socVm: BatterySocVm = new BatterySocVm();
  @Consume contentColor: string;

  initStyle(): void {
    this.styleCommon.statusBarMarginLeftRight = ResUtils.getNumberFromLength(this.styleCommon.statusBarMarginLeftRight);
  }

  onBatterySoc(showBatterySoc: boolean) {
    log.showInfo(`onBatterySoc ${showBatterySoc}`);
    this.mIconConfig.showBatterySoc = showBatterySoc;
  }

  /*
   * 填充电池颜色
   * @returns string
   */
  private getBatteryLevelProgressColor(): string {
    if (!this.batteryCharging) {
      if (this.batterySoc <= BatterySoc.BATTERY_10) {
        return Constants.BATTERY_RED;
      }
      if (this.batterySoc <= BatterySoc.BATTERY_20) {
        return Constants.BATTERY_ORANGE;
      }
    }
    return this.contentColor;
  }

  /*
   *  获取充电模式Icon
   */
  private getChargingImage() {
    if (this.mIconConfig.showBatterySoc) {
      if (this.batteryPluggedType === BatteryInfo.BatteryPluggedType.WIRELESS) {
        switch (this.chargerType) {
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double_figure');
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge_figure');
          default:
            return $r('app.media.ic_statusbar_battery_charge_figure');
        }
      } else {
        switch (this.chargerType) {
          case charger.ChargeType.WIRED_QUICK:
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double_figure_beside');
          case charger.ChargeType.WIRED_SUPER_QUICK:
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge_figure_beside');
          default:
            return $r('app.media.ic_statusbar_battery_charge_figure_beside');
        }
      }
    } else {
      if (this.batteryPluggedType === BatteryInfo.BatteryPluggedType.WIRELESS) {
        switch (this.chargerType) {
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double');
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge');
          default:
            return $r('app.media.ic_statusbar_battery_charge');
        }
      } else {
        switch (this.chargerType) {
          case charger.ChargeType.WIRED_QUICK:
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double_figure_inner');
          case charger.ChargeType.WIRED_SUPER_QUICK:
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge_figure_inner');
          default:
            return $r('app.media.ic_statusbar_battery_charge_figure_inner');
        }
      }
    }
  }

  /*
   * 获取百分比填充Icon
   */
  private getPaddingImage(): Resource {
    let trans = this.mIconConfig.showBatterySoc || this.batteryCharging ||
      this.powerSaveMode === Constants.POWER_SAVE_MODE_ON;
    if (this.batterySoc <= BatterySoc.BATTERY_5) {
      return this.getImageWithLowBattery(trans, BatterySoc.BATTERY_5);
    } else if (this.batterySoc <= BatterySoc.BATTERY_10) {
      return this.getImageWithLowBattery(trans, BatterySoc.BATTERY_10);
    } else if (this.batterySoc <= BatterySoc.BATTERY_20) {
      return this.getImageWithLowBattery(trans, BatterySoc.BATTERY_20);
    } else if (this.batterySoc <= BatterySoc.BATTERY_30) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_30') : $r('app.media.ic_statusbar_battery_solid_30');
    } else if (this.batterySoc <= BatterySoc.BATTERY_40) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_40') : $r('app.media.ic_statusbar_battery_solid_40');
    } else if (this.batterySoc <= BatterySoc.BATTERY_50) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_50') : $r('app.media.ic_statusbar_battery_solid_50');
    } else if (this.batterySoc <= BatterySoc.BATTERY_60) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_60') : $r('app.media.ic_statusbar_battery_solid_60');
    } else if (this.batterySoc <= BatterySoc.BATTERY_60) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_70') : $r('app.media.ic_statusbar_battery_solid_70');
    } else if (this.batterySoc <= BatterySoc.BATTERY_80) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_80') : $r('app.media.ic_statusbar_battery_solid_80');
    } else if (this.batterySoc <= BatterySoc.BATTERY_90) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_90') : $r('app.media.ic_statusbar_battery_solid_90');
    } else if (this.batterySoc <= BatterySoc.BATTERY_95) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_95') : $r('app.media.ic_statusbar_battery_solid_95');
    } else {
      return trans ? $r('app.media.ic_statusbar_battery_soc_100') : $r('app.media.ic_statusbar_battery_solid_100');
    }
  }

  /*
   * 获取低电量Icon
   */
  private getImageWithLowBattery(trans: boolean, batterySoc: number) {
    if (this.batteryCharging) {
      return $r(`app.media.ic_statusbar_battery_soc_charging_${batterySoc}`);
    }
    return trans ? $r(`app.media.ic_statusbar_battery_soc_${batterySoc}`) :
    $r(`app.media.ic_statusbar_battery_solid_${batterySoc}`);
  }

  aboutToAppear() {
    this.style.initStyle();
    this.socVm.init(this);
  }

  aboutToDisappear() {
    this.socVm.destroy();
  }

  /*
   * 电池图标边框
   */
  @Builder
  batteryIconBorder() {
    Image($r('app.media.ic_statusbar_battery_border'))
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(ICON_HEIGHT)
      .fillColor(this.contentColor)
  }

  /*
   * 电池电量填充占比
   */
  @Builder
  batteryLevelPadding() {
    Image(this.getPaddingImage())
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(ICON_HEIGHT)
      .fillColor(this.getBatteryLevelProgressColor())
  }

  /*
   * 电池电量文本
   */
  @Builder
  batteryLevelText() {
    Text(this.batterySoc.toString())
      .draggable(false)
      .width(ICON_HEIGHT)
      .height(ICON_HEIGHT)
      .margin({ right: 3, top: 1 })
      .textAlign(TextAlign.Center)
      .align(Alignment.Center)
      .fontColor(this.contentColor)
      .fontWeight(FontWeight.Bold)
      .fontSize('6vp')
  }

  /*
   * 显示在电池图标里面的充电图标
   */
  @Builder
  chargingIconInner() {
    Image(this.getChargingImage())
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(ICON_HEIGHT)
      .visibility(this.batteryCharging ? Visibility.Visible : Visibility.Hidden)
      .fillColor(this.contentColor)
  }

  /*
   * 显示在电池图标外面的充电图标
   */
  @Builder
  chargingIconBeside() {
    Image(this.getChargingImage())
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryChargingWidth)
      .height(ICON_HEIGHT)
      .visibility(this.batteryCharging ? Visibility.Visible : Visibility.Hidden)
      .fillColor(this.contentColor)
  }

  /*
   * 电池图标内的省电模式图标
   */
  @Builder
  powerSaveModeIconInner() {
    Image($r('app.media.ic_statusbar_battery_powersaving_figure_inner'))
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarBatteryWidth)
      .height(ICON_HEIGHT)
      .fillColor(this.contentColor)
  }

  /*
   * 电池图标外的省电模式图标
   */
  @Builder
  powerSaveModeIconBeside() {
    Image($r('app.media.ic_statusbar_battery_powersaving_figurein'))
      .matchTextDirection(true)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.style.statusBarPowerSaveWidth)
      .height(ICON_HEIGHT)
      .fillColor(this.contentColor)
  }

  build() {
    Row() {
      Stack() {
        this.batteryIconBorder()
        if (!(this.mIconConfig.showBatterySoc && this.batteryCharging)) {
          this.batteryLevelPadding()
        }
        if (this.mIconConfig.showBatterySoc) {
          this.batteryLevelText()
        }
        if (!this.mIconConfig.showBatterySoc && this.batteryCharging) {
          this.chargingIconInner()
        }
        if (!this.mIconConfig.showBatterySoc && !this.batteryCharging &&
          this.powerSaveMode === Constants.POWER_SAVE_MODE_ON) {
          this.powerSaveModeIconInner()
        }
      }
      .width('58px')

      if (this.batteryCharging && this.mIconConfig.showBatterySoc) {
        this.chargingIconBeside()
      }
      if (!this.batteryCharging && this.mIconConfig.showBatterySoc &&
        (this.powerSaveMode === Constants.POWER_SAVE_MODE_ON)) {
        this.powerSaveModeIconBeside();
      }
    }
    .height(ICON_HEIGHT)
    .opacity($r('app.float.icon_component_opacity'))
    .clip(this.isClip)
    .justifyContent(FlexAlign.Center)
  }
}