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

import display from '@ohos.display';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SCBScreenProperty } from '@ohos/windowscene';
import { SlMainStateType, SlStaticStateType } from '../constants/SlStateType';
import { slUiStateMgr } from '../manager/ScreenLockUiStateManager';
import { BpCalculator, ScreenBp, SizeBp } from '../immersivekgcommon/base/utils/ScreenBreakPoint';

const TAG = 'DisplayUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const IS_THREE_FOLD: boolean = DeviceHelper.isThreeFoldProduct();

/**
 * 三折叠状态
 */
export enum ThreeFoldStatus {
  F_STATUS,
  M_STATUS,
  G_STATUS
}

/**
 * display工具类
 */
export class DisplayUtils {
  private static _isFoldAble?: boolean;
  private constructor() {
  }

  /**
   * 判断设备是否可折叠
   *
   * @returns 是否可折叠
   */
  public static isFoldAble(): boolean {
    if (DisplayUtils._isFoldAble !== undefined) {
      return DisplayUtils._isFoldAble;
    }
    try {
      DisplayUtils._isFoldAble = display.isFoldable();
      log.showInfo(`isFoldable ${DisplayUtils._isFoldAble}`);
      return DisplayUtils._isFoldAble;
    } catch (error) {
      log.showError(`isFoldable failed. ${error.code}`);
    }
    return false;
  }

  /**
   * 获取显示信息
   *
   * @returns display.Display
   */
  public static getDefaultDisplaySync(): display.Display | undefined {
    try {
      return display.getDefaultDisplaySync();
    } catch (error) {
      log.showError(`getDefaultDisplaySync failed. ${error.code}`);
    }
    return undefined;
  }

  /**
   * 获取设备折叠状态
   *
   * @returns 设备折叠状态
   */
  public static getFoldStatus(): display.FoldStatus {
    try {
      return display.getFoldStatus();
    } catch (error) {
      log.showError(`getFoldStatus failed. ${error.code}`);
    }
    return display.FoldStatus.FOLD_STATUS_UNKNOWN;
  }

  /**
   * 获取设备当前FoldDisplayMode
   *
   * @returns display.FoldDisplayMode
   */
  public static getFoldDisplayMode(): display.FoldDisplayMode {
    let foldDisplayMode: display.FoldDisplayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
    try {
      foldDisplayMode = display.getFoldDisplayMode();
    } catch (error) {
      log.showError('getFoldDisplayMode failed');
    }
    return foldDisplayMode;
  }

  /**
   * 获得三折叠当前状态
   *
   * @param screenProperty 屏幕属性
   * @returns 折展状态
   */
  public static getThreeFoldStatus(screenProperty?: SCBScreenProperty): ThreeFoldStatus | undefined {
    if (!IS_THREE_FOLD) {
      return undefined;
    }
    let screenBp: ScreenBp;
    if (screenProperty) {
      screenBp = BpCalculator.calcScreenBp(screenProperty.width, screenProperty.height);
    } else {
      // 否则从全局断点信息直接获取断点状态
      screenBp =
        slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    }
    if (!screenBp) {
      return DeviceHelper.isFState() ? ThreeFoldStatus.F_STATUS :
        (DeviceHelper.isMState() ? ThreeFoldStatus.M_STATUS : ThreeFoldStatus.G_STATUS);
    }
    // F态竖屏：宽MSmall，高Large；F态横屏：宽Medium，高Small；M态横&竖屏：宽Medium，高Medium
    if ((screenBp.widthBp === SizeBp.SM && screenBp.heightBp === SizeBp.LG) ||
      (screenBp.widthBp === SizeBp.MD && screenBp.heightBp === SizeBp.SM)) {
      return ThreeFoldStatus.F_STATUS;
    } else if (screenBp.widthBp === SizeBp.MD && screenBp.heightBp === SizeBp.MD) {
      return ThreeFoldStatus.M_STATUS;
    } else {
      return ThreeFoldStatus.G_STATUS;
    }
  }

  /**
   * 三折叠是否是F态
   *
   * @param screenProperty 屏幕属性
   * @returns true, 三折叠是F态
   */
  public static isThreeFoldFStatus(screenProperty?: SCBScreenProperty): boolean {
    return DisplayUtils.getThreeFoldStatus(screenProperty) === ThreeFoldStatus.F_STATUS;
  }

  /**
   * 三折叠是否是M态
   *
   * @param screenProperty 屏幕属性
   * @returns true, 三折叠是M态
   */
  public static isThreeFoldMStatus(screenProperty?: SCBScreenProperty): boolean {
    return DisplayUtils.getThreeFoldStatus(screenProperty) === ThreeFoldStatus.M_STATUS;
  }

  /**
   * 三折叠是否是G态
   *
   * @param screenProperty 屏幕属性
   * @returns true, 三折叠是G态
   */
  public static isThreeFoldGStatus(screenProperty?: SCBScreenProperty): boolean {
    return DisplayUtils.getThreeFoldStatus(screenProperty) === ThreeFoldStatus.G_STATUS;
  }

  /**
   * 是否是大屏
   *
   * @param screenProperty 屏幕属性
   * @returns true, 表示是大屏
   */
  public static isLargeScreen(screenProperty?: SCBScreenProperty): boolean {
    return DeviceHelper.isPadOr2in1PcType() || DisplayUtils.isThreeFoldGStatus(screenProperty);
  }
}