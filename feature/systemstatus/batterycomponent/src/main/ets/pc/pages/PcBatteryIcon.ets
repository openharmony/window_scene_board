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
import { DeviceHelper, AbsResourceManager as ResourceManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { StyleConfigurationCommon } from '@ohos/systemuicommon';
import { CommonStyle } from '@ohos/systemuicommon';
import charger from '@ohos.charger';
import mBatteryModel, { BatterySocVm } from '../../default/batteryModel';
import BatteryPic from './batteryPic';
import StyleConfiguration from '../../default/common/StyleConfiguration';
import { BatteryComponentStyle } from '../../default/common/StyleConfiguration';
import Constants from '../../default/common/constants';
import lazy NotificationController from '../NotificationController'

const TAG = 'BatteryComponent-batteryIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const COMPONENT_ID_BATTERY_BORDER = TAG + '_Image_batteryBorder';
const COMPONENT_ID_BATTERY_PROGRESS = TAG + '_Image_batteryProgress';
const COMPONENT_ID_BATTERY_SOC = TAG + '_Text_batterySoc';
const COMPONENT_ID_BATTERY_CHARGING = TAG + '_Image_batteryCharging';

interface IconConfig {
  showBatterySoc: boolean
}

@Component
export default struct PcBatteryIcon {
  @State mIconConfig: IconConfig = {
    showBatterySoc: false,
  };
  @StorageLink('batterySoc') batterySoc: number = 100;
  @StorageLink('batteryCharging') batteryCharging: boolean = false;
  @StorageLink('batteryPluggedType') batteryPluggedType: number = 0;
  @StorageLink('chargerType') chargerType: charger.ChargeType = charger.ChargeType.NONE;
  @State style: BatteryComponentStyle = StyleConfiguration.getBatteryComponentStyle();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';

  private onLanguageChange(): void {
    log.showInfo( `current language is ${this.language}`);
    NotificationController.getInstance().checkLanguageChange();
  }
  /**
   * 沉浸式内容颜色
   */
  @Consume contentColor: string;
  private socVm: BatterySocVm = new BatterySocVm();
  private resourceMgr: ResourceManager | null = null;

  aboutToAppear() {
    mBatteryModel.initBatteryModel();
    this.style.initStyle();
    this.socVm.init(this);
    log.showInfo(`aboutToAppear, mIconConfig: ${this.mIconConfig?.showBatterySoc}`);
  }

  aboutToDisappear() {
    this.socVm.destroy();
    log.showInfo('aboutToDisappear');
  }

  initStyle(): void {
    this.styleCommon.statusBarMarginLeftRight = ResUtils.getNumberFromLength(this.styleCommon.statusBarMarginLeftRight);
  }

  build() {
    if (DeviceHelper.isPhone() || DeviceHelper.isPad()) {
      Row() {
        Stack({}) {
          //border
          Image($r('app.media.ic_statusbar_battery_border'))
            .draggable(false)
            .objectFit(ImageFit.Contain)
            .width(this.style.statusBarBatteryWidth)
            .height(this.style.statusBarBatteryHeight)
            .fillColor(this.contentColor)
            .id(COMPONENT_ID_BATTERY_BORDER)
            .edgeAntialiasing(Constants.IMAGE_EDGE)
            .renderGroup(true)

          //padding
          if (!(this.mIconConfig.showBatterySoc && this.batteryCharging)) { // 显示电量并在充电中，不需要padding
            Image(this.getPaddingImage())
              .draggable(false)
              .objectFit(ImageFit.Contain)
              .width(this.style.statusBarBatteryWidth)
              .height(this.style.statusBarBatteryHeight)
              .fillColor(
                this.batterySoc <= 10 ? Constants.BATTERY_RED :
                  this.batterySoc <= 20 ? Constants.BATTERY_ORANGE :
                  this.contentColor
              )
              .id(COMPONENT_ID_BATTERY_PROGRESS)
              .edgeAntialiasing(Constants.IMAGE_EDGE)
              .renderGroup(true)
          }

          if (this.mIconConfig.showBatterySoc) { //Text*
            Text(this.batterySoc.toString())
              .draggable(false)
              .width(this.style.statusBarBatteryWidth)
              .height(this.style.statusBarBatteryHeight)
              .margin({ right: 3, top: 0.5 })
              .textAlign(TextAlign.Center)
              .fontColor(this.contentColor)
              .fontWeight(FontWeight.Bold)
              .fontSize(11)
              .id(COMPONENT_ID_BATTERY_SOC)
          }
          if (!this.mIconConfig.showBatterySoc && this.batteryCharging) { //charging inner
            Image(this.getChargingImage())
              .draggable(false)
              .objectFit(ImageFit.Contain)
              .width(this.style.statusBarBatteryWidth)
              .height(this.style.statusBarBatteryHeight)
              .visibility(this.batteryCharging ? Visibility.Visible : Visibility.Hidden)
              .fillColor(this.contentColor)// .margin({ right: 1 })
              .id(COMPONENT_ID_BATTERY_CHARGING)
              .edgeAntialiasing(Constants.IMAGE_EDGE)
              .renderGroup(true)
          }
        }
        .width(this.style.statusBarBatteryWidth)

        // charging beside
        if (this.batteryCharging && this.mIconConfig.showBatterySoc) {
          Image(this.getChargingImage())
            .draggable(false)
            .objectFit(ImageFit.Contain)
            .width(this.style.statusBarBatteryChargingWidth)
            .height(this.style.statusBarBatteryChargingHeight)
            .visibility(this.batteryCharging ? Visibility.Visible : Visibility.Hidden)
            .fillColor(this.contentColor)
            .id(COMPONENT_ID_BATTERY_CHARGING)
            .edgeAntialiasing(Constants.IMAGE_EDGE)
            .renderGroup(true)
        }
      }
      .height('100%')
      .opacity($r('app.float.icon_component_opacity'))
      .justifyContent(FlexAlign.Center)
    } else if (DeviceHelper.isPC()) {
      BatteryPic({
        showBatterySoc: this.mIconConfig.showBatterySoc,
        resourceMgr: this.resourceMgr,
      })
    }
  }

  private getChargingImage() {
    if (this.mIconConfig.showBatterySoc) {
      if (this.batteryPluggedType == 3) {
        return $r('app.media.Charge_wireless_slow');
      } else {
        switch (this.chargerType) {
          case charger.ChargeType.WIRED_QUICK:
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double_figure_beside');
          case charger.ChargeType.WIRED_SUPER_QUICK:
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge_figure_beside')
          default:
            return $r('app.media.ic_statusbar_battery_charge_figure_beside');
        }
      }
    } else {
      if (this.batteryPluggedType == 3) {
        return $r('app.media.Charge_wireless_slow');
      } else {
        switch (this.chargerType) {
          case charger.ChargeType.WIRED_QUICK:
          case charger.ChargeType.WIRELESS_QUICK:
            return $r('app.media.ic_statusbar_battery_charge_double_figure_inner');
          case charger.ChargeType.WIRED_SUPER_QUICK:
          case charger.ChargeType.WIRELESS_SUPER_QUICK:
            return $r('app.media.ic_statusbar_battery_supercharge_figure_inner')
          default:
            return $r('app.media.ic_statusbar_battery_charge_figure_inner');
        }
      }
    }
  }

  private getPaddingImage(): Resource {
    let trans = this.mIconConfig.showBatterySoc || this.batteryCharging;
    if (this.batterySoc <= 5) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_5') : $r('app.media.ic_statusbar_battery_solid_5');
    } else if (this.batterySoc <= 10) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_10') : $r('app.media.ic_statusbar_battery_solid_10');
    } else if (this.batterySoc <= 20) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_20') : $r('app.media.ic_statusbar_battery_solid_20');
    } else if (this.batterySoc <= 30) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_30') : $r('app.media.ic_statusbar_battery_solid_30');
    } else if (this.batterySoc <= 40) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_40') : $r('app.media.ic_statusbar_battery_solid_40');
    } else if (this.batterySoc <= 50) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_50') : $r('app.media.ic_statusbar_battery_solid_50');
    } else if (this.batterySoc <= 60) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_60') : $r('app.media.ic_statusbar_battery_solid_60');
    } else if (this.batterySoc <= 70) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_70') : $r('app.media.ic_statusbar_battery_solid_70');
    } else if (this.batterySoc <= 80) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_80') : $r('app.media.ic_statusbar_battery_solid_80');
    } else if (this.batterySoc <= 90) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_90') : $r('app.media.ic_statusbar_battery_solid_90');
    } else if (this.batterySoc <= 95) {
      return trans ? $r('app.media.ic_statusbar_battery_soc_95') : $r('app.media.ic_statusbar_battery_solid_95');
    } else {
      return trans ? $r('app.media.ic_statusbar_battery_soc_100') : $r('app.media.ic_statusbar_battery_solid_100');
    }
  }

  onBatterySoc(showBatterySoc: boolean) {
    log.showInfo(`onBatterySoc ${showBatterySoc}`);
    this.mIconConfig.showBatterySoc = showBatterySoc;
  }
}
