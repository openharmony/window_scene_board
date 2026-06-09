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

import { systemParameter } from '@kit.BasicServicesKit';
import { TsLog } from '@ohos/themeservicebase';

const TAG: string = 'DeviceHelper';

/**
 * 设备类型工具类
 *
 * @since 2024-4-22
 */
export class DeviceHelper {
  private static readonly LEM_FOLD: string = 'LEM';

  private static readonly PSD_FOLD = 'PSD';

  private static readonly SINGLE_DISPLAY_SMALL_FOLD: number = 4;

  private static readonly DEFAULTS_FOLD_TYPE: string = '0,0,0,0';

  private static readonly SMALL_FOLD: number = 2;

  private static readonly FOLD_TYPE_INDEX: number = 0;

  private static sIsLem: Nullable<boolean> = undefined;

  private static sIsPsd: Nullable<boolean> = undefined;

  private static sIsSmallFold: Nullable<boolean> = undefined;

  /**
   * 是否是LEM产品
   * @returns 是否LEM设备
   */
  public static isLemFoldProduct(): boolean {
    if (DeviceHelper.sIsLem !== undefined) {
      return DeviceHelper.sIsLem;
    }
    try {
      let productType: string = systemParameter.getSync('const.build.product', '');
      DeviceHelper.sIsLem = productType === DeviceHelper.LEM_FOLD;
    } catch (e) {
      TsLog.error(TAG, 'lem get productType error');
      return false;
    }
    return DeviceHelper.sIsLem;
  }

  /**
   * 是否是小方屏折叠产品
   * @returns 是否小方屏折叠设备
   */
  public static isSmallSquareScreenFoldProduct(): boolean {
    if (DeviceHelper.sIsPsd !== undefined) {
      return DeviceHelper.sIsPsd;
    }
    try {
      let productType: string = systemParameter.getSync('const.build.product', '');
      DeviceHelper.sIsPsd = productType === DeviceHelper.PSD_FOLD;
    } catch (e) {
      TsLog.error(TAG, 'psd get productType error');
      return false;
    }
    return DeviceHelper.sIsPsd;
  }

  /**
   * 是否是扩展新形态小折叠产品
   * @returns 是否扩展新形态小折叠产品
   */
  public static isSingleDisplayFoldProduct(): boolean {
    let isSingleDisplayFoldProduct: boolean = false;
    try {
      let screenType: string = systemParameter.getSync('const.window.foldscreen.type', DeviceHelper.DEFAULTS_FOLD_TYPE);
      let type: string = screenType.split(',')[0];
      if (Number(type) === DeviceHelper.SINGLE_DISPLAY_SMALL_FOLD) {
        isSingleDisplayFoldProduct = true;
      }
    } catch (e) {
      TsLog.error(TAG, 'screenType error');
    }
    return isSingleDisplayFoldProduct;
  }

  /**
   * 是否小折叠设备
   * @returns 是否小折叠设备
   */
  public static isSmallFoldProduct(): boolean {
    if (DeviceHelper.sIsSmallFold !== undefined) {
      return DeviceHelper.sIsSmallFold;
    }
    try {
      let screenType: string = systemParameter.getSync('const.window.foldscreen.type', '0,0,0,0');
      let type: string = screenType.split(',')[DeviceHelper.FOLD_TYPE_INDEX];
      DeviceHelper.sIsSmallFold =
        Number(type) === DeviceHelper.SMALL_FOLD || Number(type) === DeviceHelper.SINGLE_DISPLAY_SMALL_FOLD;
    } catch (e) {
      TsLog.error(TAG, 'screenType error');
      return false;
    }
    return DeviceHelper.sIsSmallFold;
  }
}
