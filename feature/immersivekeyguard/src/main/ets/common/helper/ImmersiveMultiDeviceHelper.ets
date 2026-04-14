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

import { SingletonHelper, CommonUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DisplayUtils } from '@ohos/screenlockcommon';
import { ImmersiveConstants } from '../ImmersiveConstants';
import display from '@ohos.display';
import { slCtxHelper } from '@ohos/screenlockcommon/Index';

const TAG = 'ImmersiveMultiDeviceHelper';

/**
 * 多设备相关常量
 */
export enum MultiDeviceConst {
  /**
   * 直板机默认胶囊宽度
   */
  DEFAULT_CAPSULE_WIDTH = 208,

  /**
   * 锁屏胶囊两侧按钮的宽度加边距
   */
  DEFAULT_EDGE = 152,

  /**
   * 折叠屏展开态胶囊占屏幕宽度的比例
   */
  FOLD_EXPAND_CAPSULE_WIDTH = 1 / 3,

  /**
   * 折叠屏展开态屏幕宽度阈值，用于处理半折态
   */
  FOLD_EXPAND_WIDTH_THRESHOLDS = 2000,

  /**
   * PAD竖屏模式下胶囊宽度占屏幕宽度的比例
   */
  PAD_PORTRAIT_CAPSULE_WIDTH_PERCENTAGE = 1 / 3,

  /**
   * PAD横屏模式下胶囊宽度占屏幕宽度的比例
   */
  PAD_LANDSCAPE_CAPSULE_WIDTH_PERCENTAGE = 0.25,

  /**
   * 设备竖屏状态
   */
  DEVICE_PORTRAIT_STATE = 0,

  /**
   * 设备横屏状态
   */
  DEVICE_LANDSCAPE_STATE = 1,

  /**
   * 设备竖屏反向状态
   */
  DEVICE_PORTRAIT_REVERSE_STATE = 2,

  /**
   * 设备横屏反向状态
   */
  DEVICE_LANDSCAPE_REVERSE_STATE = 3,

  /**
   * 锁屏胶囊默认按钮数量
   */
  CAPSULE_DEFAULT_BTN_COUNT = 1,

  /**
   * 锁屏胶囊中等屏幕按钮数量
   */
  CAPSULE_MID_SCREEN_BTN_COUNT = 1,

  /**
   * 锁屏胶囊大屏按钮数量
   */
  CAPSULE_LARGE_SCREEN_BTN_COUNT = 3,

  /**
   * 卡片折叠屏外边距
   */
  CARD_FOLD_MARGIN = 48,

  /**
   * 卡片折叠屏栅格间距
   */
  CARD_FOLD_GUTTER = 12,

  /**
   * 卡片折叠屏栅格数量
   */
  CARD_FOLD_GRID_COUNT = 8,

  /**
   * 卡片折叠屏占用栅格数量
   */
  CARD_FOLD_USE_CRID_COUNT = 6,

  /**
   * 卡片pad外边距
   */
  CARD_PAD_MARGIN = 64,

  /**
   * 卡片pad栅格间距
   */
  CARD_PAD_GUTTER = 16,

  /**
   * 卡片pad栅格数量
   */
  CARD_PAD_GRID_COUNT = 12,

  /**
   * 卡片pad占用栅格数量
   */
  CARD_PAD_USE_CRID_COUNT = 6,

  /**
   * 卡片外边距宽度，左右边距
   */
  CARD_MARGIN_WIDTH = 72,

  /**
   * 卡片外边距高度，上下边距
   */
  CARD_MARGIN_HEIGHT = 48,

  /**
   * 内容区高度
   */
  CARD_CONTENT_HEIGHT = 122
}

/**
 * 沉浸锁屏多设备适配工具
 */
class ImmersiveMultiDeviceHelper {
  /**
   * 根据屏幕显示宽度获取胶囊宽度
   *
   * @param displaySize 屏幕宽高大小
   * @returns 胶囊宽度大小
   */
  getCapsuleWidthDisplay(displaySize: number): number {
    if (displaySize === 0) {
      let screenDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
      if (screenDisplay === undefined) {
        return 0;
      }
      displaySize = screenDisplay.width;
    }
    if (DisplayUtils.isLargeScreen()) {
      return this.getPadCapsuleWidth(displaySize);
    }
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      return this.getFoldCapsuleWidth(displaySize);
    }
    return this.getDefaultCapsuleWidth(displaySize);
  }

  /**
   * 得到胶囊按钮数量
   *
   * @returns 按钮数量
   */
  getCapsuleBtnCount(): number {
    if (DisplayUtils.isLargeScreen()) {
      return MultiDeviceConst.CAPSULE_LARGE_SCREEN_BTN_COUNT;
    }
    if (DeviceHelper.isFullDisplayMode()) {
      return MultiDeviceConst.CAPSULE_MID_SCREEN_BTN_COUNT;
    }
    return MultiDeviceConst.CAPSULE_DEFAULT_BTN_COUNT;
  }

  /**
   * 获取折叠屏胶囊宽度
   *
   * @param displaySize 屏幕宽高大小
   * @returns 胶囊宽度大小
   */
  private getPadCapsuleWidth(displaySize: number): number {
    if (DeviceHelper.getOrientation() === MultiDeviceConst.DEVICE_PORTRAIT_STATE ||
      DeviceHelper.getOrientation() === MultiDeviceConst.DEVICE_PORTRAIT_REVERSE_STATE) {
      return slCtxHelper.px2vp(displaySize * MultiDeviceConst.PAD_PORTRAIT_CAPSULE_WIDTH_PERCENTAGE);
    }

    if (DeviceHelper.getOrientation() === MultiDeviceConst.DEVICE_LANDSCAPE_STATE ||
      DeviceHelper.getOrientation() === MultiDeviceConst.DEVICE_LANDSCAPE_REVERSE_STATE) {
      return slCtxHelper.px2vp(displaySize * MultiDeviceConst.PAD_LANDSCAPE_CAPSULE_WIDTH_PERCENTAGE);
    }

    return slCtxHelper.px2vp(displaySize * MultiDeviceConst.PAD_PORTRAIT_CAPSULE_WIDTH_PERCENTAGE);
  }

  /**
   * 判断屏幕状态
   *
   * @returns 是否横屏状态
   */
  public isLandscape(): boolean {
    if (DeviceHelper.getOrientation() === MultiDeviceConst.DEVICE_LANDSCAPE_STATE ||
      DeviceHelper.getOrientation() === MultiDeviceConst.DEVICE_LANDSCAPE_REVERSE_STATE) {
      return true;
    }
    return false;
  }

  /**
   * 获取Pad胶囊宽度
   *
   * @param displaySize 屏幕宽高大小
   * @returns 胶囊宽度大小
   */
  private getFoldCapsuleWidth(displaySize: number): number {
    if (DeviceHelper.isFullDisplayMode() || displaySize > MultiDeviceConst.FOLD_EXPAND_WIDTH_THRESHOLDS) {
      return slCtxHelper.px2vp(displaySize * MultiDeviceConst.FOLD_EXPAND_CAPSULE_WIDTH);
    } else {
      return this.getDefaultCapsuleWidth(displaySize);
    }
  }

  /**
   * 获取直板机的胶囊宽度
   *
   * @param displaySize 屏幕宽高大小
   * @returns 胶囊宽度大小
   */
  private getDefaultCapsuleWidth(displaySize: number): number {
    return slCtxHelper.px2vp(displaySize) - MultiDeviceConst.DEFAULT_EDGE;
  }

  /**
   * 根据屏幕宽度计算卡片宽度
   *
   * @param displaySize 屏幕宽度
   * @returns 卡片宽度
   */
  getCardWidthDisplay(displaySize: number): number {
    if (displaySize === 0) {
      let screenDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
      if (screenDisplay === undefined) {
        return 0;
      }
      displaySize = screenDisplay.width;
    }
    if (DisplayUtils.isLargeScreen()) {
      return this.calCardWidth(displaySize, MultiDeviceConst.CARD_PAD_MARGIN, MultiDeviceConst.CARD_PAD_GUTTER,
        MultiDeviceConst.CARD_PAD_GRID_COUNT, MultiDeviceConst.CARD_PAD_USE_CRID_COUNT);
    }

    if (DeviceHelper.isFullDisplayMode()) {
      return this.calCardWidth(displaySize, MultiDeviceConst.CARD_FOLD_MARGIN, MultiDeviceConst.CARD_FOLD_GUTTER,
        MultiDeviceConst.CARD_FOLD_GRID_COUNT, MultiDeviceConst.CARD_FOLD_USE_CRID_COUNT);
    }
    // 默认宽度
    return this.calCardWidth(displaySize, MultiDeviceConst.CARD_FOLD_MARGIN, MultiDeviceConst.CARD_FOLD_GUTTER,
      MultiDeviceConst.CARD_FOLD_GRID_COUNT, MultiDeviceConst.CARD_FOLD_USE_CRID_COUNT);
  }

  /**
   * 计算沉浸卡片宽度
   *
   * @param width 设备宽度
   * @param margin 外边距
   * @param gutter 栅格间距
   * @param gridCount 栅格数量
   * @param useGridCount 占用栅格数量
   * @returns 沉浸卡片宽度
   */
  private calCardWidth(width: number, margin: number, gutter: number, gridCount: number, useGridCount: number): number {
    return (slCtxHelper.px2vp(width) - margin - gutter * (gridCount - 1)) / gridCount * useGridCount +
      (useGridCount - 1) * gutter;
  }

  getCardHeightDisplay(width: number, height: number): number {
    let screenDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
    if (width === 0) {
      if (screenDisplay === undefined) {
        return 0;
      }
      width = screenDisplay.width;
    }
    if (height === 0) {
      if (screenDisplay === undefined) {
        return 0;
      }
      height = screenDisplay.height;
    }

    let calWidth: number = 0;
    if (this.isLandscape()) {
      if (DisplayUtils.isLargeScreen()) {
        calWidth = this.getCardWidthDisplay(width);
      } else {
        calWidth = this.getCardWidthDisplay(height);
      }
    } else {
      if (DisplayUtils.isLargeScreen()) {
        calWidth = this.getCardWidthDisplay(height);
      } else {
        calWidth = this.getCardWidthDisplay(width);
      }
    }

    return ((calWidth - MultiDeviceConst.CARD_MARGIN_WIDTH) / 2 + MultiDeviceConst
      .CARD_CONTENT_HEIGHT + MultiDeviceConst.CARD_MARGIN_HEIGHT);
  }
}

// 单例
export let immersiveMultiDeviceHelper: ImmersiveMultiDeviceHelper =
  SingletonHelper.getInstance(ImmersiveMultiDeviceHelper, TAG);