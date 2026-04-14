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

import lazy { BusinessError } from '@ohos.base';
import lazy DeviceInfo from '@ohos.deviceInfo';
import lazy systemParameterEnhance from '@ohos.systemParameterEnhance';
import lazy display from '@ohos.display';
import { Log } from './Log';

const TAG: string = 'DeviceUtil';
const FOLD_PRODUCT_TYPE: string = 'const.window.foldscreen.type';
const DEFAULTS_FOLD_TYPE: string = '0,0,0,0';

/**
 * 超大屏新增折展状态
 */
export enum UltraScreenStatus {
  /**
   * 超大屏-G态
   */
  ULTRA_SCREEN_FULL_EXPAND = 11,

  /**
   * 超大屏-N态
   */
  FOLD_INVALID = 12,

  /**
   * 超大屏-半折和展开(G态),AB屏展开，C屏半折
   */
  LEFT_EXPAND_RIGHT_HALF = 13,

  /**
   * 超大屏-	展开和半折(G态),A屏半折，BC屏展开
   */
  LEFT_HALF_RIGHT_EXPAND = 21,

  /**
   * 超大屏-	折叠和半折(F态),A屏半折，BC屏折叠
   */
  FOLD_LEFT_HALF_INVALID = 22,

  /**
   * 超大屏-半折和半折(G态),A屏半折，C屏半折
   */
  LEFT_HALF_EXPAND_HALF = 23,
}

const enum FoldableType {
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
   * 大屏设备
   */
  BIG_SCREEN = 5,

  /**
   * 超大屏
   */
  TRI_FOLD = 6,
}

/**
 * 设备工具类
 *
 * @since 2024-3-13
 */
export class DeviceUtil {
  public static foldProductTypeValue: FoldableType = FoldableType.INVALID_VALUE;

  /**
   * 设备类型 默认
   */
  public static readonly TYPE_DEFAULT: string = 'default';

  /**
   * 设备类型 手机
   */
  public static readonly TYPE_PHONE: string = 'phone';

  /**
   * 设备类型 平板
   */
  public static readonly TYPE_TABLET: string = 'tablet';

  /**
   * 设备类型, 2in1
   */
  public static readonly TYPE_2IN1: string = '2in1';

  /**
   * 设备类型, tv
   */
  public static readonly TYPE_TV: string = 'tv';

  /**
   * 设备类型, 模拟器
   */
  public static readonly EMULATOR: string = 'emulator';

  /**
   * 折叠屏外屏屏幕宽度索引
   */
  public static readonly FOLD_OUTER_INDEX: number = 0;

  /**
   * 折叠屏内屏屏幕宽度索引
   */
  public static readonly FOLD_INNER_INDEX: number = 2;

  /**
   * 超大屏展开宽度索引
   */
  public static readonly FULL_FOLD_INNER_INDEX: number = 4;

  /**
   * 折叠屏屏幕信息数据 屏幕方向以竖向为准 [0]: 外屏宽 [1]:外屏高 [2]:内屏宽 [3]:内屏高
   */
  private static FOLD_DEVICE_DISPLAY_INFO: number[] = [];

  /**
   * 超大屏屏幕信息数据，屏幕方向以竖向为准 [0]: F态宽 [1]:F态高 [2]:M态宽 [3]:M态高 [4]:G态宽 [5]:G态高
   */
  private static TRI_FOLD_DEVICE_DISPLAY_INFO: number[] = [];

  private static FOLD_STATUS_ARRAY: number[] = [display.FoldStatus.FOLD_STATUS_FOLDED, UltraScreenStatus.FOLD_INVALID,
    UltraScreenStatus.FOLD_LEFT_HALF_INVALID];
  private static FOLD_EXPANDED_STATUS_ARRAY: number[] = [display.FoldStatus.FOLD_STATUS_EXPANDED,
    UltraScreenStatus.ULTRA_SCREEN_FULL_EXPAND, display.FoldStatus.FOLD_STATUS_HALF_FOLDED,
    UltraScreenStatus.LEFT_EXPAND_RIGHT_HALF, UltraScreenStatus.LEFT_HALF_RIGHT_EXPAND, UltraScreenStatus.LEFT_HALF_EXPAND_HALF];
  private static TRI_FOLD_STATUS_G_ARRAY: number[] =
    [UltraScreenStatus.ULTRA_SCREEN_FULL_EXPAND, UltraScreenStatus.LEFT_EXPAND_RIGHT_HALF,
      UltraScreenStatus.LEFT_HALF_RIGHT_EXPAND, UltraScreenStatus.LEFT_HALF_EXPAND_HALF];
  private static HALF_FOLDED_STATUS_ARRAY: number[] = [FoldStatus.FOLD_STATUS_HALF_FOLDED,
    UltraScreenStatus.LEFT_EXPAND_RIGHT_HALF, UltraScreenStatus.LEFT_HALF_EXPAND_HALF, UltraScreenStatus.LEFT_HALF_RIGHT_EXPAND];
  /**
   * 获取折叠屏屏幕信息数据
   *
   * @returns 折叠屏屏幕信息数据
   */
  public static async getFoldDeviceScreenInfo(): Promise<number[]> {
    if (DeviceUtil.FOLD_DEVICE_DISPLAY_INFO.length > 0) {
      return DeviceUtil.FOLD_DEVICE_DISPLAY_INFO;
    }
    try {
      let infos: display.DisplayPhysicalResolution[] = await display.getAllDisplayPhysicalResolution();
      if (infos && infos.length > 1) {
        Log.info(TAG, `getFoldDeviceScreenInfo:{mode:[${infos[0].foldDisplayMode}][${infos[1].foldDisplayMode}]}`);

        // 折叠屏展开态的物理宽度对应orientation为0时屏幕高度，物理高度对应orientation为0时屏幕宽度，所以此处进行翻转
        if (DeviceUtil.isDoubleDisplayPocketProduct()) {
          DeviceUtil.FOLD_DEVICE_DISPLAY_INFO =
            [infos[0].physicalWidth, infos[0].physicalHeight, infos[1].physicalWidth, infos[1].physicalHeight];
        } else {
          DeviceUtil.FOLD_DEVICE_DISPLAY_INFO =
            [infos[0].physicalWidth, infos[0].physicalHeight, infos[1].physicalHeight, infos[1].physicalWidth];
        }
        return DeviceUtil.FOLD_DEVICE_DISPLAY_INFO;
      }
    } catch (err) {
      Log.error(TAG, `Failed to obtain physical resolution. Code: ${err?.code}, message: ${err?.message}`);
    }
    return [];
  }

  /**
   * 获取超大屏屏幕信息数据
   *
   * @returns 超大屏屏幕信息数据
   */
  public static async getTriFoldDeviceScreenInfo(): Promise<number[]> {
    if (DeviceUtil.TRI_FOLD_DEVICE_DISPLAY_INFO.length > 0) {
      return DeviceUtil.TRI_FOLD_DEVICE_DISPLAY_INFO;
    }
    try {
      let infos: display.DisplayPhysicalResolution[] = await display.getAllDisplayPhysicalResolution();
      if (infos && infos.length > 2) {
        // G态的物理宽度对应orientation为0时屏幕高度，物理高度对应orientation为0时屏幕宽度，所以此处进行翻转
        DeviceUtil.TRI_FOLD_DEVICE_DISPLAY_INFO =
          [infos[0].physicalWidth, infos[0].physicalHeight, infos[1].physicalWidth, infos[1].physicalHeight,
            infos[2].physicalHeight, infos[2].physicalWidth];
        return DeviceUtil.TRI_FOLD_DEVICE_DISPLAY_INFO;
      }
    } catch (err) {
      Log.error(TAG, `Failed to obtain physical resolution. Code: ${err?.code}, message: ${err?.message}`);
    }
    return [];
  }

  /**
   * 是否是直板机
   *
   * @return true是，false不是
   */
  public static isPortraitPhone(): boolean {
    return (DeviceInfo.deviceType === DeviceUtil.TYPE_PHONE || DeviceInfo.deviceType === DeviceUtil.TYPE_DEFAULT) &&
      !DeviceUtil.isFold();
  }

  /**
   * 设备类型是否为 phone
   *
   * @return true是，false不是
   */
  public static isPhone(): boolean {
    return (DeviceInfo.deviceType === DeviceUtil.TYPE_PHONE || DeviceInfo.deviceType === DeviceUtil.TYPE_DEFAULT);
  }

  /**
   * 设备类型是否为 PC
   *
   * @return true是，false不是
   */
  public static isPC(): boolean {
    return DeviceInfo.deviceType === DeviceUtil.TYPE_2IN1;
  }

  /**
   * 设备类型是否为 pad
   *
   * @return true是，false不是
   */
  public static isPad(): boolean {
    return DeviceInfo.deviceType === DeviceUtil.TYPE_TABLET;
  }

  /**
   * 设备类型是否为 tv
   *
   * @return true是，false不是
   */
  public static isTV(): boolean {
    return DeviceInfo.deviceType === DeviceUtil.TYPE_TV;
  }

  /**
   * 获取设备类型
   *
   * @return device type
   */
  public static getDeviceType(): string {
    return DeviceInfo.deviceType;
  }

  /**
   * 设备类型是否为折叠屏
   *
   * @returns true是，false不是
   */
  public static isFold(): boolean {
    let isFold: boolean = false;
    try {
      isFold = display.isFoldable();
    } catch (error) {
      Log.error(TAG, 'isFold -> isFoldable try error:', error);
    }
    return isFold;
  }

  /**
   * 是否为折叠半折叠状态
   * 双折场景: AB面半折
   * 超大屏场景：AB面半折、BC面半折、AB面半折以及BC面半折
   *
   * @param foldStatusParaValue 变量foldStatus值
   * @param foldStatus getFoldStatus返回值
   * @returns true表示当前是半折状态，false表示是折叠状态
   */
  public static isHalfFolded(foldStatusParaValue: string, foldStatus: number): boolean {
    let foldStatusNumber: number = -1;
    if (foldStatusParaValue && !Number.isNaN(foldStatusParaValue)) {
      foldStatusNumber = Number(foldStatusParaValue);
    }
    return DeviceUtil.HALF_FOLDED_STATUS_ARRAY.includes(foldStatusNumber) ||
      DeviceUtil.HALF_FOLDED_STATUS_ARRAY.includes(foldStatus);
  }

  /**
   * 是否为折叠屏展开态
   * 双折场景：AB面之间组合：AB面半折，AB面全展
   * 超大屏场景：ABC面之间的组合(AB展开&&BC展开,AB展开&&BC半折,AB半折&&BC展开,AB半折&&BC半折)
   *
   * @param foldStatus 折叠状态
   * @returns true表示当前是展开态
   */
  public static isFoldExpandedStatus(foldStatus: number) : boolean {
    return DeviceUtil.FOLD_EXPANDED_STATUS_ARRAY.includes(foldStatus);
  }

  /**
   * 是否为折叠屏折叠态
   * 双折场景：折叠态
   * 超大屏场景：F态，N态，折叠和半折
   *
   * @param foldStatus 折叠状态
   * @returns true表示当前是折叠态
   */
  public static isFoldedStatus(foldStatus: number): boolean {
    return DeviceUtil.FOLD_STATUS_ARRAY.includes(foldStatus);
  }

  /**
   * 是否为折叠屏展开态
   *
   * @returns true是，false不是
   */
  public static isFoldExpanded(): boolean {
    try {
      if (!display.isFoldable() && !DeviceUtil.isSmallFoldProduct()) {
        return false;
      }
      const foldStatus: display.FoldStatus = display.getFoldStatus();
      Log.info(TAG, `isFoldExpanded: current foldStatus is ${foldStatus}`);

      // 半折叠与完全展开时都会点亮内屏，都判定为展开
      return DeviceUtil.isFoldExpandedStatus(foldStatus);
    } catch (error) {
      Log.error(TAG, `isFoldExpanded -> try error: code: ${error?.code}, message : ${error?.message}}`);
    }
    return false;
  }

  /**
   * 是否为折叠屏折叠态
   *
   * @returns true是，false不是
   */
  public static isFoldStatus(): boolean {
    let isFoldStatus: boolean = false;
    try {
      isFoldStatus = display.isFoldable() && display.getFoldStatus() === display.FoldStatus.FOLD_STATUS_FOLDED;
    } catch (error) {
      Log.error(TAG, `isFoldStatus -> try error: code: ${error?.code}, message : ${error?.message}}`);
    }
    return isFoldStatus;
  }

  /**
   * 获取设备显示信息，消除快速变化时连续获取的display变化
   *
   * @returns display 显示全量信息
   */
  public static getDisplay(): display.Display | undefined {
    try {
      return display.getDefaultDisplaySync();
    } catch (error) {
      Log.error(TAG, `getDisplay -> getDefaultDisplaySync try error:code: ${error?.code}`);
    }
    return undefined;
  }

  /**
   * 获取设备横竖屏方向
   *
   * @returns 横竖屏方向 0：竖屏 1：横屏 2：内容与竖屏模式方向相反 3：内容与横屏模式方向相反
   */
  public static getOrientation(): number {
    let orientation: number = 0;
    try {
      let displayInfo: display.Display = display.getDefaultDisplaySync();
      if (displayInfo) {
        orientation = displayInfo.orientation.valueOf();
      } else {
        Log.error(TAG, 'getOrientation -> getDefaultDisplaySync error: displayInfo is null');
      }
    } catch (error) {
      Log.error(TAG, 'getOrientation -> getDefaultDisplaySync try error:', error);
    }
    return orientation;
  }

  /**
   * 获取可折叠设备的折叠状态
   *
   * @returns 折叠状态 0：折叠状态未知 1：完全展开 2：折叠 3：半折叠
   */
  public static getFoldStatus(): number {
    let foldStatus: number = display.FoldStatus.FOLD_STATUS_FOLDED;
    try {
      if (display.isFoldable() || DeviceUtil.isSmallFoldProduct()) {
        foldStatus = display.getFoldStatus()
      }
    } catch (error) {
      Log.error(TAG, `getFoldStatus failed, code: ${(error as BusinessError)?.code}`);
    }
    return foldStatus;
  }

  /**
   * 获取代表产品形态的配置项值
   *
   * @returns FoldableType
   */
  private static getFoldProductType(): FoldableType {
    if (DeviceUtil.foldProductTypeValue !== FoldableType.INVALID_VALUE) {
      return DeviceUtil.foldProductTypeValue;
    }
    try {
      let productValue: string = systemParameterEnhance.getSync(FOLD_PRODUCT_TYPE, DEFAULTS_FOLD_TYPE);
      if (!productValue) {
        Log.error(TAG, 'Get fold product type value failed: productValue is null');
        return FoldableType.INVALID_VALUE;
      }
      const result: string[] = productValue.split(',');
      if (result.length > 0) {
        DeviceUtil.foldProductTypeValue = Number.parseInt(result[0]);
        return DeviceUtil.foldProductTypeValue;
      }
    } catch (e) {
      Log.error(TAG, 'Get fold product type value failed: %{public}s', e);
    }
    return FoldableType.INVALID_VALUE;
  }

  /**
   * 获取代表产品形态的配置项值
   *
   * @returns FoldableType
   */
  public static getFoldProductTypes(): FoldableType {
    return DeviceUtil.getFoldProductType();
  }

  /**
   * 是否是小内折产品 Lem
   *
   * @returns boolean 如果为小折叠产品返回true
   */
  public static isSmallFoldProduct(): boolean {
    return FoldableType.SMALL_FOLD === DeviceUtil.getFoldProductType();
  }

  /**
   * 是否是超大屏
   *
   * @returns boolean 如果是超大屏返回true
   */
  public static isTriFoldProduct(): boolean {
    return FoldableType.TRI_FOLD === DeviceUtil.getFoldProductType();
  }

  /**
   * 是否是超大屏G态
   *
   * @returns boolean 如果是超大屏G态返回true
   */
  public static isUltraScreenG(): boolean {
    if (!DeviceUtil.isTriFoldProduct()) {
      return false;
    }
    try {
      const foldStatus: display.FoldStatus = display.getFoldStatus();
      return DeviceUtil.TRI_FOLD_STATUS_G_ARRAY.includes(foldStatus);
    } catch (error) {
      Log.error(TAG, `isUltraScreenG -> try error: ${error}`);
      return false;
    }
  }

  /**
   * 是否是大内折产品
   *
   * @returns boolean 如果为大折叠产品返回true
   */
  public static isLargeInFoldProduct(): boolean {
    return DeviceUtil.getFoldProductType() === FoldableType.LARGE_FOLD;
  }

  /**
   * 是否是扩展折叠产品
   *
   * @returns boolean 如果是扩展折叠产品返回true
   */
  public static isDoubleDisplayPocketProduct(): boolean {
    return DeviceUtil.getFoldProductType() === FoldableType.EXPANDING_NEX_FORMS;
  }

  /**
   * 是否是大屏设备
   *
   * @returns boolean 如果为大屏设备返回true
   */
  public static isBigScreenProduct(): boolean {
    return FoldableType.BIG_SCREEN === DeviceUtil.getFoldProductType();
  }

  /**
   * 获取屏幕宽度
   *
   * @returns 像素
   */
  public static getScreenWidth(): number {
    let screenWidth: number = 0;
    try {
      screenWidth = display.getDefaultDisplaySync().width;
    } catch (err) {
      Log.error(TAG,
        `getScreenWidth failed, code: ${err?.code}, message: ${err?.message}`);
    }
    return screenWidth;
  }

  /**
   * 获取屏幕高度
   *
   * @returns 像素
   */
  public static getScreenHeight(): number {
    let screenHeight: number = 0;
    try {
      screenHeight = display.getDefaultDisplaySync().height;
    } catch (err) {
      Log.error(TAG,
        `getScreenHeight failed, code: ${err?.code}, message: ${err?.message}`);
    }
    return screenHeight;
  }

  /**
   * 获取屏幕刷新率
   *
   * @returns 刷新率
   */
  public static getScreenRefreshRate(): number {
    let screenRefreshRate: number = 0;
    try {
      screenRefreshRate = display.getDefaultDisplaySync().refreshRate;
    } catch (err) {
      Log.error(TAG,
        `get screen refresh rate from getDefaultDisplaySync failed, code: ${err?.code}, message: ${err?.message}`);
    }
    return screenRefreshRate;
  }

  /**
   * 判断当前设备是否为横屏（直板机/大屏幕机的折叠态）
   * 优先根据传入的screenOrientation判断横竖屏专题，如果未传入或者传入的是undefined，则从display获取orientation来判断横竖屏状态
   *
   * @param screenOrientation 设备旋转角度参数，可选参数，无此参数是自动从display获取
   * @returns true为横屏
   */
  public static isPhoneInLandscape(screenOrientation?: number): boolean {
    let isPortraitPhone: boolean = DeviceUtil.isPortraitPhone();
    let orientation: number = screenOrientation ?? DeviceUtil.getOrientation();
    let isLandscape: boolean = orientation === display.Orientation.LANDSCAPE ||
      orientation === display.Orientation.LANDSCAPE_INVERTED;
    let isFoldStatus: boolean = DeviceUtil.isFold() && (DeviceUtil.getFoldStatus() ===
      display.FoldStatus.FOLD_STATUS_FOLDED);

    return (isPortraitPhone || isFoldStatus) && isLandscape;
  }

  /**
   * 是否为横屏态
   *
   * @returns true为横屏
   */
  public static isInLandscape(): boolean {
    let orientation: number = DeviceUtil.getOrientation();
    return orientation === display.Orientation.LANDSCAPE || orientation === display.Orientation.LANDSCAPE_INVERTED;
  }

  /**
   * 是否是新形态小折叠产品
   *
   * @returns boolean 如果是扩展折叠产品返回true
   */
  public static isSingleDisplayPocketFoldDevice(): boolean {
    let isSingleDisplayPocketFoldDevice: boolean | undefined = AppStorage.get<boolean>('singleDisplayPocketFoldDevice');
    if (isSingleDisplayPocketFoldDevice === undefined) {
      let result: boolean = (FoldableType.EXPANDING_NEX_FORMS === DeviceUtil.getFoldProductType());
      AppStorage.setOrCreate('singleDisplayPocketFoldDevice', result);
      return result;
    }
    return isSingleDisplayPocketFoldDevice;
  }

  /**
   * 利用合一编辑已有的ccm配置，判断是否是西安平台或者性能差的产品【当前生效的设备是M、M+、T、H】
   *
   * @returns true表示是，false表示不是
   */
  public static isLiteSpecDevice(): boolean {
    let isLiteSpecDevice: string = 'false';
    try {
      isLiteSpecDevice = systemParameterEnhance.getSync('const.theme.editor.light_animation.enabled');
    } catch (err) {
      Log.error(TAG, `isLiteSpecDevice error: ${err?.code}, ${err?.message}`);
    }
    Log.info(TAG, `isLiteSpecDevice: ${isLiteSpecDevice}`);
    return isLiteSpecDevice.includes('true');
  }

  /**
   * 是否使能壁纸渐亮效果
   *
   * @returns true表示是，false表示不是
   */
  public static isEnabledLightUpEffectDevice(): boolean {
    let enable: string = 'true';
    try {
      enable = systemParameterEnhance.getSync('const.theme.engine.light_up_effect.enabled');
    } catch (err) {
      Log.error(TAG, `isEnabledLightUpEffectDevice error: ${err?.code}, ${err?.message}`);
    }
    Log.info(TAG, `isEnabledLightUpEffectDevice: ${enable}`);
    return enable.includes('true');
  }

  /**
   * 是否为模拟器
   *
   * @returns true是，false不是
   */
  public static isEmulator(): boolean {
    return DeviceInfo.productModel === DeviceUtil.EMULATOR;
  }
}