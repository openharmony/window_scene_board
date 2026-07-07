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
import { LogDomain, LogHelper, ModeChangeUtils } from './BasicCommon';
import { DisplayAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DisplayAdapter';

const TAG = 'DeviceHelper';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const FOLD_PRODUCT_TYPE = 'const.window.foldscreen.type';
const DEFAULTS_FOLD_TYPE = '0,0,0,0';

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
  EXPANDING_SUPER_FOLD = 5,
  /**
   * 三折设备
   */
  EXPANDING_THREE_FOLD_PRODUCT = 6,
}

/**
 * XT布局类型, 待API更新后，切换到系统定义
 */
export enum XTLayoutType {
  NONE = 0, //非XT设备
  M = 1, //双屏状态
  F = 2, //单屏状态
  G = 5 //三屏状态
}

export class DeviceHelper {
  /**
   * device type, default
   */
  public static readonly TYPE_DEFAULT = 'default';

  /**
   * device type, phone
   */
  public static readonly TYPE_PHONE = 'phone';

  /**
   * device type, tablet
   */
  public static readonly TYPE_TABLET = 'tablet';

  /**
   * 设备类型, 2in1
   */
  public static readonly TYPE_2IN1 = '2in1';

  /**
   * 获取设备类型，初始化一次，后续不再重复读取
   */
  public static readonly DEVICE_TYPE = DeviceInfo.deviceType;

  /**
   * 获取设备类型，初始化一次，后续不再重复读取
   */
  public static readonly PRODUCT_MODEL = DeviceInfo.productModel;

  /**
   * LEM内屏Id
   */
  public static readonly INNER_SCREEN_ID = 0;

  /**
   * LEM外屏Id
   */
  public static readonly OUTER_SCREEN_ID = 5;

  public static sFoldProductTypeValue: FoldPhoneTypeValue = FoldPhoneTypeValue.INVALID_VALUE;

  public static sIsFold?: boolean = undefined;

  // radius is cnfigured, default false
  public static isConfigured: boolean = false;

  public static sIsSupportVoiceCapability?: boolean = undefined;

  /**
   * whether the device type is phone
   *
   * @return true phone
   */
  static isPhone(): boolean {
    return (DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_PHONE ||
      DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_DEFAULT);
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
   * whether the device type is pad
   *
   * @return true pad
   */
  static isPad(): boolean {
    return DeviceHelper.DEVICE_TYPE === DeviceHelper.TYPE_TABLET;
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
   * get device type
   *
   * @return device type
   */
  static getDeviceType(): string {
    return DeviceHelper.DEVICE_TYPE;
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
    const status = DisplayAdapter.getFoldStatus();
    try {
      isFoldExpanded = display.isFoldable() && (status === display.FoldStatus.FOLD_STATUS_EXPANDED ||
        status === display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
    } catch (error) {
      log.showError('isFoldExpanded -> try error:', error);
    }
    return isFoldExpanded;
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
   * 是否为折叠机产品展开态OR半展开态（非小内折）
   *
   * @returns true是，false不是
   */
  static isFoldExpandedOrHalfButNotSmallFoldProduct(): boolean {
    return !DeviceHelper.isSmallFoldProduct() && DeviceHelper.isFoldExpandedOrHalf();
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
   * 是否是对应XT布局
   * @returns true:对应传入XT布局 false:不是对应XT布局
   */
  static isMatchXTFoldMode(targetMode: XTLayoutType): boolean {
    if (!DeviceHelper.isXTProductType()) {
      return XTLayoutType.NONE === targetMode;
    }

    let foldDisplayMode: display.FoldDisplayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
    try {
      foldDisplayMode = display.getFoldDisplayMode();
    } catch (error) {
      log.showError('getFoldDisplayMode -> try error:', error);
    }

    let displayMode = foldDisplayMode as number as XTLayoutType;
    return displayMode === targetMode;
  }

  /**
   * 是否XT产品
   * @returns true:XT产品 false:非XT产品
   */
  static isXTProductType(): boolean {
    return DeviceHelper.getFoldProductType() === FoldPhoneTypeValue.EXPANDING_THREE_FOLD_PRODUCT;
  }

  /**
   * 是否hopper
   * @returns true:是hopper false:非hopper
   */
  static isSuperFoldDevice(): boolean {
    return DeviceHelper.getFoldProductType() === FoldPhoneTypeValue.EXPANDING_SUPER_FOLD;
  }
}