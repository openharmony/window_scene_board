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

import DeviceInfo from '@ohos.deviceInfo';
import display from '@ohos.display';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { SCBConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { BusinessError } from '@ohos.base';
import call from '@ohos.telephony.call';
import { ScreenState, ScreenStateMonitor } from '../devicemanager/ScreenStateMonitor';
import { ModeChangeUtils } from '../utils/ModeChangeUtils';

const TAG = 'DeviceHelper';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const FOLD_PRODUCT_TYPE = 'const.window.foldscreen.type';
const DEFAULTS_FOLD_TYPE = '0,0,0,0';

/**
 * 设备圆角配置模式
 */

const enum DeviceRadiusConfigMode {
  /**
   * 直板机（大折叠屏外屏）圆角配置
   */
  GENERAL_CONFIG_MODE = 0,
   /**
    * 大折叠屏内屏圆角配置
    */
  BIG_FOLDER_CONFIG_MODE = 1,
}
export const enum FoldPhoneTypeValue {
  /**
   * 无效值
   */
  INVALID_VALUE = -1,
  /**
   * 直板机
   */
  STRAIGHT = 0,
  /**
   * 大折（内折） X5
   */
  LARGE_FOLD = 1,
  /**
   * 小折叠（只有内折） pocket
   */
  SMALL_FOLD = 2,
  /**
   * 外折 XS2
   */
  EXTERNAL_FOLD = 3,
  /**
   * 扩展新形态
   */
  EXPANDING_NEX_FORMS = 4,
  /**
   * super fold
   */
  EXPANDING_BIG_SCREEN = 5,
  /**
   * 超大屏设备
   */
  EXPANDING_ULTRA_SCREEN_PRODUCT = 6,
}

/**
 * device info sendevent
 *
 * @since 2022-10-19
 */
export class DeviceHelper {
  /**
   * device type, default
   */
  static readonly TYPE_DEFAULT = 'default';

  /**
   * device type, phone
   */
  static readonly TYPE_PHONE = 'phone';

  /**
   * device type, tablet
   */
  static readonly TYPE_TABLET = 'tablet';

  /**
   * 设备类型, 2in1
   */
  static readonly TYPE_2IN1 = '2in1';

  /**
   * device type: watch
   */
  static readonly TYPE_WATCH = 'wearable';

  /**
   * device type: car
   */
  static readonly TYPE_CAR = 'car';

  /**
   * device type, HYM
   */
  static readonly KLV_PRODUCT_MODEL = 'HYM';

  /**
   * device type, emulator
   */
  static readonly EMULATOR_MODEL = 'emulator';

  /**
   * 获取设备类型，初始化一次，后续不再重复读取
   */
  static readonly DEVICE_TYPE = DeviceInfo.deviceType;

  /**
   * device feature: large_screen
   */
  static readonly LARGE_SCREEN = 'large_screen';

  /**
   * 获取设备类型，初始化一次，后续不再重复读取
   */
  static readonly PRODUCT_MODEL = DeviceInfo.productModel;

  /**
   * fold status, G
   */
  static readonly FOLD_STATE_EXPAND_WITH_SECOND_EXPAND: number = 11;
  static readonly FOLD_STATE_EXPAND_WITH_SECOND_HALF_FOLDED: number = 21;
  static readonly FOLD_STATE_HALF_FOLDED_WITH_SECOND_EXPAND: number = 13;
  static readonly FOLD_STATE_HALF_FOLDED_WITH_SECOND_HALF_FOLDED: number = 23;

  /**
   * device type super fold
   */
  private static isBigScreen: boolean | undefined = undefined;

  /**
   * LEM内屏Id
   */
  static readonly INNER_SCREEN_ID = 0;

  /**
   * LEM外屏Id
   */
  static readonly OUTER_SCREEN_ID = 5;

  static sFoldProductTypeValue: FoldPhoneTypeValue = FoldPhoneTypeValue.INVALID_VALUE;

  static sIsFold: boolean | undefined = undefined;

  static deviceRadiusConfig: number[] = [SCBConstants.DEFAULT_WINDOWS_RADIUS, SCBConstants.DEFAULT_WINDOWS_RADIUS];
  // radius is cnfigured, default false
  static isConfigured: boolean = false;

  static sIsSupportVoiceCapability: boolean = true;

  static sIsSupportVoiceCapabilityInit: boolean = false;

  /**
   * 产品参数
   */
  private static readonly DEVICE_FEATURES_KEY: string = 'const.product.providedDeviceFeatures';

  /**
   * whether the device type is phone
   *
   * @return true phone
   */
  static isPhone(): boolean {
    return (DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_PHONE || DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_DEFAULT);
  }

  /**
   * whether the device type is PC
   *
   * @return true PC
   */
  static isPC(): boolean {
    if (ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      return ModeChangeUtils.isPcMode();
    }
    return DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_2IN1;
  }

  /**
   *  whether the device type is CAR
   */
  static isCAR(): boolean {
    return DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_CAR;
  }

  /**
   * whether the device type is BarPhone
   *
   * @return true BarPhone
   */
  static isBarPhone(): boolean {
    return DeviceHelper.isPhone() && !DeviceHelper.isFold();
  }

  /**
   * whether the device type is Watch
   *
   * @returns true Watch
   */
  static isWatch(): boolean {
    return DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_WATCH;
  }

  /**
   * whether the device type is HYM
   *
   * @return true HYM
   */
  static isHYM(): boolean {
    return DeviceHelper.PRODUCT_MODEL.includes(DeviceHelper.KLV_PRODUCT_MODEL);
  }

  /**
   * whether the device type is pad
   *
   * @return true pad
   */
  static isPad(): boolean {
    if (ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      return !ModeChangeUtils.isPcMode();
    }
    return DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_TABLET;
  }

  /**
   * whether the device type is had
   *
   * @return true had
   */
  static isHAD(): boolean {
    return DeviceHelper.isPC() && !DeviceHelper.isHYM();
  }

  /**
   * phone和pad
   *
   * @returns true phone或pad
   */
  static isPhoneOrPad(): boolean {
    return DeviceHelper.isPhone() || DeviceHelper.isPad();
  }

  /**
   * whether the device type is emulator
   *
   * @return true emulator
   */
  static isEmulator(): boolean {
    return DeviceHelper.PRODUCT_MODEL.includes(DeviceHelper.EMULATOR_MODEL);
  }

  /**
   * Check whether the device type matches the current device type.
   *
   * @param deviceType device type
   * @return true match
   */
  static isMatchDevice(deviceType: string): boolean {
    if (deviceType == null) {
      return false;
    }
    switch (deviceType) {
      // phone、tablet保持一致
      case DeviceHelper.TYPE_DEFAULT:
      case DeviceHelper.TYPE_PHONE:
      case DeviceHelper.TYPE_TABLET:
        return DeviceHelper.isPhone() || DeviceHelper.isPad();
      // PC
      case DeviceHelper.TYPE_2IN1:
        return DeviceHelper.isPC();
      // CAR
      case DeviceHelper.TYPE_CAR:
        return DeviceHelper.isCAR();
      // Wearable
      case DeviceHelper.TYPE_WATCH:
        return DeviceHelper.isWatch();
      default:
        return false;
    }
  }

  /**
   * get device type
   *
   * @return device type
   */
  static getDeviceType(): string {
    // 开源代码默认类型DEFAULT按PHONE
    return DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_DEFAULT ? DeviceHelper.TYPE_PHONE : DeviceHelper.DEVICE_TYPE;
  }

  /**
   * 设备是否支持通话
   *
   * @returns
   */
  static isSupportVoiceCapability(): boolean {
    if (DeviceHelper.sIsSupportVoiceCapabilityInit) {
      return DeviceHelper.sIsSupportVoiceCapability;
    }

    try {
      DeviceHelper.sIsSupportVoiceCapability = call.hasVoiceCapability();
      DeviceHelper.sIsSupportVoiceCapabilityInit = true;
    } catch (error) {
      log.showError('isSupportVoiceCapability try error:', error);
    }
    return DeviceHelper.sIsSupportVoiceCapability;
  }


  /**
   * 是否为折叠屏
   *
   * @returns true是，false不是
   */
  static isFold(): boolean {
    if (DeviceHelper.sIsFold !== undefined) {
      return DeviceHelper.sIsFold;
    }
    DeviceHelper.sIsFold = false;
    try {
      DeviceHelper.sIsFold = display.isFoldable();
    } catch (error) {
      log.showError('isFold -> isFoldable try error:', error);
    }
    return DeviceHelper.sIsFold;
  }

  /**
   * 是否为折叠屏展开态
   *
   * @returns true是，false不是
   */
  static isFoldExpanded(): boolean {
    let isFoldExpanded: boolean = false;
    try {
      isFoldExpanded = display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED;
    } catch (error) {
      log.showError('isFoldExpanded -> try error:', error);
    }
    return isFoldExpanded;
  }

  /**
   * 是否为折叠屏展开or半展开态
   *
   * @returns true是，false不是
   */
  static isFoldExpandedOrHalf(): boolean {
    let isFoldExpanded: boolean = false;
    try {
      const status = display.getFoldStatus();
      isFoldExpanded = display.isFoldable() && (status === display.FoldStatus.FOLD_STATUS_EXPANDED ||
        status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
    } catch (error) {
      log.showError('isFoldExpanded -> try error:', error);
    }
    return isFoldExpanded;
  }

  /**
   * 获取当前设备转轴信息
   *
   * @returns foldStatus
   */
  static getFoldStatus(): number {
    try {
      return display.getFoldStatus();
    } catch (error) {
      log.showError(`getFoldStatus code: ${error?.code}, msg: ${error?.message}`);
    }
    return display.FoldStatus.FOLD_STATUS_FOLDED;
  }

  /**
   * 获取折叠屏显示模式
   *
   * @returns Main Display or Full Display
   */
  static getFoldDisplayMode(): display.FoldDisplayMode {
    let foldDisplayMode: display.FoldDisplayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
    try {
      foldDisplayMode = display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED ? display.FoldDisplayMode
        .FOLD_DISPLAY_MODE_MAIN : display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
    } catch (error) {
      log.showError('getFoldDisplayMode -> try error:', error);
    }
    return foldDisplayMode;
  }

  /**
   * 获取代表产品形态的配置项值
   *
   * @returns FoldPhoneTypeValue
   */
  static getFoldProductType(): FoldPhoneTypeValue {
    if (DeviceHelper.sFoldProductTypeValue !== FoldPhoneTypeValue.INVALID_VALUE) {
      return DeviceHelper.sFoldProductTypeValue;
    }
    try {
      let productValue: string = systemParameterEnhance.getSync(FOLD_PRODUCT_TYPE, DEFAULTS_FOLD_TYPE);
      log.showInfo(`productValue: ${productValue}`);
      const result: string[] = productValue?.split(',');
      if (result.length > 0) {
        DeviceHelper.sFoldProductTypeValue = Number.parseInt(result[0]);
        return DeviceHelper.sFoldProductTypeValue;
      }
    } catch (e) {
      log.showError('Get fold product type value failed: %{public}s', e);
    }
    return FoldPhoneTypeValue.INVALID_VALUE;
  }

  /**
   * 是否是小内折产品
   *
   * @returns boolean 如果为小折叠产品返回true
   */
  public static isSmallFoldProduct(): boolean {
    return FoldPhoneTypeValue.SMALL_FOLD === DeviceHelper.getFoldProductType();
  }

  /**
   * 是否是super fold
   *
   * @returns boolean 如果为super fold返回true
   */

  public static isBigScreenMachine(): boolean {
    if (DeviceHelper.isBigScreen !== undefined) {
      return DeviceHelper.isBigScreen;
    }
    DeviceHelper.isBigScreen = FoldPhoneTypeValue.EXPANDING_BIG_SCREEN === DeviceHelper.getFoldProductType();
    return DeviceHelper.isBigScreen;
  }

  /**
   * 当前显示屏幕是否为副屏（Lem）
   *
   * @returns boolean
   */
  public static isSubDisplayMode(): boolean {
    let isSubDisplayMode: boolean = false;
    try {
      isSubDisplayMode = display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_SUB;
    } catch (error) {
      log.showError('isSubDisplayMode error:', error);
    }
    return isSubDisplayMode;
  }

  /**
   * 是否是大内折产品 X5
   *
   * @returns boolean
   */
  static isLargeInFoldProduct(): boolean {
    return FoldPhoneTypeValue.LARGE_FOLD === DeviceHelper.getFoldProductType();
  }
  /**
   * 是否是三屏设备
   * @returns true是，false不是
   */
  static isUltraScreenProduct(): boolean {
    return FoldPhoneTypeValue.EXPANDING_ULTRA_SCREEN_PRODUCT === DeviceHelper.getFoldProductType();
  }

  /**
   * 是否是 M 态
   * @returns
   */
  static isMState(): boolean {
    return ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState === ScreenState.M;
  }
  /**
   * 是否是 F 态
   * @returns
   */
  static isFState(): boolean {
    return ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState === ScreenState.F;
  }
  /**
   * 是否是 G 态
   * @returns
   */
  static isGState(): boolean {
    return ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState === ScreenState.G;
  }

  /**
   * 超大屏G态，竖屏
   * @returns
   */
  static isUltraScreenGPortrait(): boolean {
    return DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState() && !DeviceHelper.isLandscape();
  }

  /**
   * 是否为大屏幕机产品展开态（非小内折）
   *
   * @returns true是，false不是
   */
  static isFoldExpandedButNotSmallFoldProduct(): boolean {
    return !DeviceHelper.isSmallFoldProduct() && DeviceHelper.isFoldExpanded();
  }

  /**
   * 是否为大屏幕机产品展开态OR半展开态（非小内折）
   *
   * @returns true是，false不是
   */
  static isFoldExpandedOrHalfButNotSmallFoldProduct(): boolean {
    return !DeviceHelper.isSmallFoldProduct() && DeviceHelper.isFoldExpandedOrHalf();
  }

  /**
   * 是否为非小折叠的大屏幕机产品（非小内折）
   *
   * @returns true是，false不是
   */
  static isFoldButNotSmallFoldProduct(): boolean {
    return !DeviceHelper.isSmallFoldProduct() && DeviceHelper.isFold();
  }

  /**
   * 是否为非小折叠和非singleDisplay的大屏幕机产品（非小内折）
   *
   * @returns true是，false不是
   */
  static isFoldButNotSmallFoldAndSingleDisplay(): boolean {
    return DeviceHelper.isFold();
  }

  /**
   * 获取设备横竖屏方向
   *
   * @returns 横竖屏方向 0：竖屏 1：横屏 2：内容与竖屏模式方向相反 3：内容与横屏模式方向相反
   */
  static getOrientation(): number {
    let orientation: number = 0;
    try {
      orientation = display.getDefaultDisplaySync()?.orientation.valueOf();
    } catch (error) {
      log.showError('getOrientation -> getDefaultDisplaySync try error:', error);
    }
    return orientation;
  }

  /**
   * 是否是横屏
   *
   * @returns 是否是横屏
   */
  static isLandscape(): boolean {
    let orientation: display.Orientation = 0;
    try {
      orientation = display.getDefaultDisplaySync()?.orientation;
    } catch (error) {
      log.showError('getOrientation -> getDefaultDisplaySync try error:', error);
    }
    return orientation === display.Orientation.LANDSCAPE ||
      orientation === display.Orientation.LANDSCAPE_INVERTED;
  }

  /**
   *  string to Number Array
   */
  private static stringToArray(str: string): number[] {
    let strArr: string[] = [];
    let arr: number[] = [];
    if (str === undefined) {
      arr[0] = SCBConstants.DEFAULT_WINDOWS_RADIUS;
    } else {
      if (str?.indexOf(',') !== -1) {
        strArr = str?.split(',');
      } else {
        strArr[0] = str;
      }
      arr = strArr?.map((item) => {
        let configItem = parseInt(item);
        if (Number.isNaN(configItem)) {
          log.showWarn('configItem is NaN');
          return SCBConstants.DEFAULT_WINDOWS_RADIUS;
        }
        return parseInt(item);
      });
    }
    return arr;
  }

  /**
   * From System Param file get the device radius config
   *
   * @returns number[]  [0]: Outer General Screen Device Radius,  [1]: BigFolder Inner Screen Device Radius
   */
  private static getDeviceRadiusConfig(): number[] {
    // if already get radius config value, directly return the value!
    if (DeviceHelper.isConfigured) {
      return DeviceHelper.deviceRadiusConfig;
    }
    // set default Device Radius
    let deviceRadiusArr: number[] = DeviceHelper.deviceRadiusConfig;
    let value: string = '';
    try {
      value = systemParameterEnhance.getSync('const.product.device_radius');
      log.showInfo(`getDeviceRadiusConfig, read config file success, device_radius: ${value}`);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      log.showWarn(`getDeviceRadiusConfig, read config file failed, error code: ${code}, message: ${message}`);
    }
    if (value === '') {
      deviceRadiusArr = DeviceHelper.stringToArray(SCBConstants.DEFAULT_WINDOWS_RADIUS.toString());
    } else {
      deviceRadiusArr = DeviceHelper.stringToArray(value);
    }
    DeviceHelper.deviceRadiusConfig = deviceRadiusArr;
    DeviceHelper.isConfigured = true;
    return deviceRadiusArr;
  }

  /**
   * Get General Outer Screen Device Radius
   */
  private static getGeneralDeviceRadius(): number {
    let radius = DeviceHelper.getDeviceRadiusConfig()[DeviceRadiusConfigMode.GENERAL_CONFIG_MODE];
    return radius;
  }

  /**
   * Get BigFolder Inner Screen Device Radius
   */
  private static getBigFolderDeviceRadius(): number {
    //BigFolder is not config, General is config as BigFolder
    let radiusConfig = DeviceHelper.getDeviceRadiusConfig();
    let radius = radiusConfig[DeviceRadiusConfigMode.BIG_FOLDER_CONFIG_MODE];
    let generalRadius = radiusConfig[DeviceRadiusConfigMode.GENERAL_CONFIG_MODE];
    log.showInfo('RADIUS_CONFIG, get BigFolder Inner Screen Device Radius is: ' +
      (radiusConfig.length > 1 ? radius : generalRadius));
    return radiusConfig.length > 1 ? radius : generalRadius;
  }

  /**
   * Get Device Radius
   */
  public static getDeviceRadius(isFoldExpanded: boolean = false): number {
    // Is fold expanded screen.
    if (isFoldExpanded) {
      return DeviceHelper.getBigFolderDeviceRadius();
    }
    // Is not fold screen.
    return DeviceHelper.getGeneralDeviceRadius();
  }

  /**
   * 当前显示屏幕是否为展开屏
   *
   * @returns boolean true是，false不是
   */
  public static isFullDisplayMode(): boolean {
    try {
      return display.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL;
    } catch (error) {
      log.error(`getFoldDisplayMode fail:${error}`);
    }
    return false;
  }

  /**
   * 获取当前设备场景:设备类型+设备形态
   *
   * @returns string 当前设备场景
   */
  public static getCurrentDeviceScene(): string {
    return '';
  }

  /**
   * 是否是大屏
   *
   * @returns true, 表示是大屏
   */
  public static isLargeScreen(): boolean {
    return DeviceHelper.isPad() || (DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState());
  }

  /**
   * judge the G state, used by multi-window
   *
   * @returns true, is G state
   */
  public static isSecondaryFoldablePhoneExpandStatus(foldStatus: display.FoldStatus): boolean {
    return foldStatus === DeviceHelper.FOLD_STATE_EXPAND_WITH_SECOND_EXPAND ||
      foldStatus === DeviceHelper.FOLD_STATE_EXPAND_WITH_SECOND_HALF_FOLDED ||
      foldStatus === DeviceHelper.FOLD_STATE_HALF_FOLDED_WITH_SECOND_EXPAND ||
      foldStatus === DeviceHelper.FOLD_STATE_HALF_FOLDED_WITH_SECOND_HALF_FOLDED;
  }

  public static isPadOr2in1PcType(): boolean {
    return DeviceHelper.isPad() || DeviceHelper.is2In1DevicePcType();
  }
  /**
   * 是否pc/pad 2in1下的pad模式
   */
  public static is2In1DevicePadType(): boolean {
    return ModeChangeUtils.isSupportWindowPcModeSwitch() && !ModeChangeUtils.isPcMode();
  }

  /**
   * 是否pc/pad 2in1下的pc模式
   */
  public static is2In1DevicePcType(): boolean {
    return ModeChangeUtils.isSupportWindowPcModeSwitch() && ModeChangeUtils.isPcMode();
  }

  /**
   * 不支持pc模式/pad模式切换的pc设备
   * @returns
   */
  public static isPcNot2in1Device(): boolean {
    return DeviceHelper.isPC() && !ModeChangeUtils.isSupportWindowPcModeSwitch();
  }

  /**
   * 是否为默认竖屏的平板
   *
   * @returns {boolean} true是，false不是
   */
  public static isTabletRotationPortrait(): boolean {
    if (!DeviceHelper.isPad()) {
      return false;
    }
    // 0 PORTRAIT
    let productValue: string = systemParameterEnhance.getSync('const.window.device.default_screen_rotation', '-1');
    log.showInfo(`tablet rotation portrait: ${productValue}`);
    if (productValue === '0') {
      return true;
    }
    return false;
  }

  /**
   * 是否为large_screen设备
   *
   * @returns {boolean} true是，false不是
   */
  public static isLargeScreenDevice(): boolean {
    let isSupport: boolean = false;
    try {
      isSupport = systemParameterEnhance.getSync(DeviceHelper.DEVICE_FEATURES_KEY, '') === DeviceHelper.LARGE_SCREEN;
    } catch (error) {
      log.showError('get isLargeScreenDevice fail', error);
    }
    return isSupport;
  }

  public static isSingleDisplayPocketFoldDevice() {
    // TODO
    return false;
  }
}