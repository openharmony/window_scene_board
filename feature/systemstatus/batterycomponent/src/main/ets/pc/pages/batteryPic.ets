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
import { ResUtils, SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper, AbsResourceManager as ResourceManager } from '@ohos/frameworkwrapper';
import { StyleConfigurationCommon } from '@ohos/systemuicommon';
import { CommonStyle } from '@ohos/systemuicommon';
import StyleConfiguration from '../../default/common/StyleConfiguration';
import { BatteryPicStyle } from '../../default/common/StyleConfiguration';
import charger from '@ohos.charger';
import Constants from '../../default/common/constants';
import { BatteryPicVM } from '../vm/BatteryPicVM';

const TAG = 'BatteryComponent-batteryPic';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const COMPONENT_ID_BORDER = TAG + '_border';
const COMPONENT_ID_SOC_NUMBER = TAG + '_Soc_Number';
const COMPONENT_ID_OUTER_CHARGING_ICON = TAG + '_Outer_Charging_Icon';
const COMPONENT_ID_INNER_BACKGROUND = TAG + '_Inner_Background';
const COMPONENT_ID_BATTERY_STACK = TAG + '_Battery_Stack';
const COMPONENT_ID_BATTERY = TAG + '_Battery';

@Component
export default struct BatteryPic {
  @StorageProp('smartDockVisible') @Watch('smartDockVisibleChange') smartDockVisible: boolean = true;
  @StorageProp('isLock') @Watch('onLock') isLock: boolean = true;
  @StorageProp('isSystemLanguageRTL') @Watch('refreshRTLLanguageStateChange') isSystemLanguageRTL: boolean =
    RTLUtil.isRTL();
  @StorageLink('batterySoc') batterySoc: number = 100;
  @StorageLink('batteryCharging') batteryCharging: boolean = false;
  @StorageLink('chargerType') chargerType: charger.ChargeType = charger.ChargeType.NONE;
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @StorageLink('powerSaveMode') powerSaveMode: number = Constants.POWER_SAVE_MODE_OFF;
  @State style: BatteryPicStyle = StyleConfiguration.getBatteryPicStyle();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @Prop @Watch('showBatterySocChange') showBatterySoc: boolean = false;
  @State viewModel: BatteryPicVM = new BatteryPicVM();
  isScreenLock: boolean = false;
  private resourceMgr: ResourceManager | null = null;

  /**
   * 桌面沉浸式内容颜色
   */
  @Consume contentColor: string;

  aboutToAppear() {
    log.showInfo('aboutToAppear Start');
    this.style.initStyle();
    if (!this.isScreenLock) {
      this.viewModel.init(this.refreshPrivacyStage);
      this.viewModel.setShowBatterySoc(this.showBatterySoc);
      this.viewModel.isRTL = this.isSystemLanguageRTL;
    }
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.viewModel.unInit(this.refreshPrivacyStage);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallBack);
  }

  private refreshPrivacyStage = (): void => {
    this.viewModel.refreshPrivacyStage();
  }

  screenPropertyChangeCallBack = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`screenPropertyChangeCallBack reason: ${reason}`);
    if (reason && reason === SCBPropertyChangeReason.CHANGE_MODE) {
      this.onScreenPropertyChange();
    }
  }

  async onScreenPropertyChange(): Promise<void> {
    this.viewModel.batteryPositionChange();
  }

  isWhiteOrBlack(): boolean {
    if (this.isScreenLock) {
      return !this.isBrightOrDark;
    }
    return this.contentColor === Constants.BRIGHT_CONTENT_COLOR;
  }

  /**
   * 麦克风图标
   */
  @Builder
  microphoneIcon() {
    Image($r('app.media.microphone'))
      .opacity(this.viewModel.privacyMicrophoneOpacity)
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .width(this.viewModel.batteryHeight)
      .height(this.viewModel.batteryHeight)
      .translate({ x: this.viewModel.privacyMicrophoneTranslateX })
      .scale({ x: this.viewModel.privacyMicrophoneScale, y: this.viewModel.privacyMicrophoneScale })
      .id('privacy_microphone_icon')
  }

  /**
   *  麦克风圆点
   */
  @Builder
  microphoneCircle() {
    Circle()
      .draggable(false)
      .opacity(this.viewModel.privacyMicrophoneCircleOpacity)
      .width(this.viewModel.batteryHeight)
      .height(this.viewModel.batteryHeight)
      .scale({ x: this.viewModel.privacyMicrophoneCircleScale, y: this.viewModel.privacyMicrophoneCircleScale })
      .fill($r('app.color.microphone_circle'))
      .translate({ x: this.viewModel.privacyMicrophoneCircleTranslateX })
      .zIndex(0)
      .id('privacy_microphone_circle')
  }

  /**
   *  相机图标
   */
  @Builder
  cameraIcon() {
    Image($r('app.media.camera'))
      .draggable(false)
      .objectFit(ImageFit.Contain)
      .opacity(this.viewModel.privacyCameraOpacity)
      .width(this.viewModel.batteryHeight)
      .height(this.viewModel.batteryHeight)
      .translate({ x: this.viewModel.privacyCameraTranslateX })
      .scale({ x: this.viewModel.privacyCameraScale, y: this.viewModel.privacyCameraScale })
      .id('privacy_camera_icon')
  }

  /**
   *  相机圆点
   */
  @Builder
  cameraCircle() {
    Circle()
      .draggable(false)
      .opacity(this.viewModel.privacyCameraCircleOpacity)
      .width(this.viewModel.batteryHeight)
      .height(this.viewModel.batteryHeight)
      .scale({ x: this.viewModel.privacyCameraCircleScale, y: this.viewModel.privacyCameraCircleScale })
      .fill($r('app.color.battery_component_pic_level_low_color'))
      .translate({ x: this.viewModel.privacyCameraCircleTranslateX })
      .zIndex(1)
      .id('privacy_camera_circle')
  }

  build() {
    Row() {
      // outer charging icon
      Stack({ alignContent: Alignment.Center }) {
        if (this.viewModel.isCurAnimating()) {
          // 麦克风图标
          this.microphoneIcon()
          // 相机图标
          this.cameraIcon()
          // 相机圆点
          this.cameraCircle()
          // 麦克风圆点
          this.microphoneCircle()
        }

        Image(this.getBattery())
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .width('100%')
          .height('100%')
          .fillColor(this.isWhiteOrBlack() ? Constants.BRIGHT_CONTENT_COLOR : Constants.DARK_CONTENT_COLOR)
          .id(this.getBatteryId())
          .onAreaChange((oldArea, newArea) => {
            let oldX = Number(oldArea.globalPosition.x);
            let newX = Number(newArea.globalPosition.x);
            if (isNaN(oldX) || isNaN(newX)) {
              log.warn('onAreaChange invalid args');
              return;
            }
            if (Math.abs(oldX - newX) < 0.001) {
              log.info('global x not change');
              return;
            }
            this.viewModel.batteryPositionChange();
          })
          .interpolation(ImageInterpolation.Low)
          .translate({ x: this.viewModel.batteryTranslateX })
          .opacity(this.viewModel.batteryOpacity)
          .scale({ x: this.viewModel.batteryScale, y: this.viewModel.batteryScale })
          .renderGroup(true)

        // 显示进度条progress
        Image(this.getProgress())
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .width('100%')
          .height('100%')
          .id(COMPONENT_ID_INNER_BACKGROUND)
          .fillColor(this.getProgressColor())
          .margin({
            right: this.getMarginRight()
          })
          .interpolation(ImageInterpolation.Low)
          .translate({ x: this.viewModel.batteryTranslateX })
          .opacity(this.viewModel.batteryOpacity)
          .scale({ x: this.viewModel.batteryScale, y: this.viewModel.batteryScale })

        if (this.showBatterySoc) {
          // inner soc number
          Text(this.batterySoc.toString())
            .draggable(false)
            .fontColor(this.isWhiteOrBlack() ? Constants.BRIGHT_CONTENT_COLOR : Constants.DARK_CONTENT_COLOR)
            .fontWeight(FontWeight.Bold)
            .fontFamily('HarmonyHeiTi')
            .fontSize(ResUtils.getNumberFromLength(this.getBatterySocFontSize()) + 'vp')
            .lineHeight(ResUtils.getNumberFromLength(this.style.batteryPicSocLineHeight) + 'vp')
            .margin(this.getTextMargin())
            .id(COMPONENT_ID_SOC_NUMBER)
            .align(Alignment.Center)
            .translate({ x: this.viewModel.batteryTranslateX })
            .opacity(this.viewModel.batteryOpacity)
            .scale({ x: this.viewModel.batteryScale, y: this.viewModel.batteryScale })
            .minFontScale(1)
            .maxFontScale(1)
        }
      }
      .width(this.getBatteryWidth())
      .height(this.getBatteryHeight())
      .id(COMPONENT_ID_BATTERY_STACK)
      .clip(this.viewModel.isClip)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .opacity($r('app.float.icon_component_opacity'))
    .id(COMPONENT_ID_BATTERY)
  }

  private getBatteryId() {
    const id = ((this.showBatterySoc && this.batteryCharging) ? COMPONENT_ID_OUTER_CHARGING_ICON : COMPONENT_ID_BORDER)
        .concat(this.isScreenLock ? '_ScreenLock' : '');
    this.viewModel.batteryId = id;
    return id;
  }

  private getBatteryWidth(): Length {
    if (this.isScreenLock || !DeviceHelper.isHAD()) {
      return this.style.batteryPicImageWidth;
    }
    return this.style.hadBatteryPicImageWidth;
  }

  private getBatterySocFontSize(): Length {
    if (this.isScreenLock || !DeviceHelper.isHAD()) {
      return this.style.batteryPicSocFontSize;
    }
    return this.style.hadBatteryPicSocFontSize;
  }

  private getBatteryHeight(): Length {
    if (this.isScreenLock || !DeviceHelper.isHAD()) {
      return this.style.batteryPicImageHeight;
    }
    return this.style.hadBatteryPicImageHeight;
  }

  private getTextMargin(): Margin {
    if (this.isScreenLock || !DeviceHelper.isHAD()) {
      return {
        right: this.isChargingOrPowerSaveModeON() ?
        this.style.chargingPicInnerPaddingRight :
        this.style.normalPicInnerPaddingRight,
        top: this.style.batteryPicSocMarginTop,
      };
    }
    return {
      right: this.isChargingOrPowerSaveModeON() ?
      this.style.hadChargingPicInnerPaddingRight :
      this.style.hadNormalPicInnerPaddingRight,
      top: this.style.hadBatteryPicSocMarginTop,
    };
  }

  private isChargingOrPowerSaveModeON(): boolean {
    return this.batteryCharging || this.powerSaveMode === Constants.POWER_SAVE_MODE_ON;
  }

  private getProgressColor(): ResourceColor {
    if (this.batterySoc <= 10) {
      return this.style.picLevelVeryLowColor;
    }
    if (this.batterySoc <= 20) {
      return this.style.picLevelLowColor;
    }
    let isBlackOrWhite: boolean = this.isWhiteOrBlack();
    log.showInfo(`isBlackOrWhite: ${isBlackOrWhite} showBatterySoc: ${this.showBatterySoc} batteryCharging: ${this.batteryCharging}`);
    if (!this.showBatterySoc && this.isChargingOrPowerSaveModeON()) {
      return isBlackOrWhite ?
      this.style.batteryPicSocBrightBackgroundColor : this.style.batteryPicSocDarkBackgroundColor;
    }
    return isBlackOrWhite ? Constants.BRIGHT_CONTENT_COLOR : Constants.DARK_CONTENT_COLOR;
  }

  private getBattery(): Resource | undefined {
    if (this.resourceMgr) {
      log.showInfo(`chargerType: ${this.chargerType} showBatterySoc: ${this.showBatterySoc} batteryCharging: ${this.batteryCharging}`);
      if (!this.batteryCharging && this.powerSaveMode === Constants.POWER_SAVE_MODE_ON) {
        // 电池图标外的内省电模式图标
        return this.showBatterySoc ? $r('app.media.ic_statusbar_battery_powersaving_leaf_out')
          : $r('app.media.ic_statusbar_battery_powersaving_leaf_inner');
      }
      return this.resourceMgr.getImage(this.isWhiteOrBlack(),
        this.showBatterySoc, this.batteryCharging, this.chargerType);
    }
    return undefined;
  }

  private getProgress(): Resource | undefined {
    if (this.resourceMgr) {
      return this.resourceMgr.getProgress(this.batterySoc, this.showBatterySoc, this.isChargingOrPowerSaveModeON());
    }
    return undefined;
  }

  private getMarginRight(): Length {
    if (this.showBatterySoc && this.isChargingOrPowerSaveModeON()) {
      if (this.batterySoc <= 20) {
        return '9vp';
      }
      return '3vp';
    }
    return '0vp';
  }

  onLock() {
    log.showInfo(`onLock isLock:${this.isLock}`);
    this.viewModel.setIsLock(this.isLock);
  }

  smartDockVisibleChange() {
    log.showInfo(`smartDockVisibleChange smartDockVisible:${this.smartDockVisible}`);
    this.viewModel.setSmartDockVisible(this.smartDockVisible);
  }

  showBatterySocChange() {
    log.showInfo(`showBatterySocChange :${this.showBatterySoc}`);
    this.viewModel.setShowBatterySoc(this.showBatterySoc);
  }

  refreshRTLLanguageStateChange() {
    this.viewModel.isRTL = this.isSystemLanguageRTL;
  }
}
