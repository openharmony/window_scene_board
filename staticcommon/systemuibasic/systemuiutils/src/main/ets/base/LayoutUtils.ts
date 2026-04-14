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
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import display from '@ohos.display';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'Notification-LayoutUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export const STATUSBAR_MIN_LEFT_WIDTH = 145;


/**
 * XT布局类型
 */
export enum XTLayoutType {
  NONE = 0, //非XT设备
  M = 1, //双屏状态
  F = 2, //单屏状态
  G = 5 //三屏状态
}

/**
 * 超大屏折叠状态类型
 */
export enum XTFoldStatus {
  NONE = 0, //非XT设备
  /**
   * 显示单屏
   */
  XTFoldStatus_SINGLE = 2,
  XTFoldStatus_TRIPLE_TO_SINGLE = 12,
  XTFoldStatus_SINGLE_TO_TRIPLE_HALF = 22,
  /**
   * 显示双屏
   */
  XTFoldStatus_DOUBLE = 1,
  XTFoldStatus_DOUBLE_TO_SINGLE = 3,
  /**
   * 显示三屏
   */
  XTFoldStatus_TRIPLE = 11,
  XTFoldStatus_TRIPLE_TO_SINGLE_HALF = 13,
  XTFoldStatus_TRIPLE_TO_DOUBLE = 21,
  XTFoldStatus_SINGLE_TO_TRIPLE = 23,
}

/**
 * 布局通用工具
 */
export class LayoutUtils {
  static XT_FOLD_PRODUCT_TYPE: number = 6;

  /**
   * 是否是Pad布局
   * @returns true:pad布局 false:非pad布局
   */
  static isPadLayout(): boolean {
    let isXTGDisplay = LayoutUtils.isMatchXTFoldMode(XTLayoutType.G);
    return DeviceHelper.isPad() || isXTGDisplay;
  }

  /**
   * 是否是对应XT布局
   * @returns true:对应传入XT布局 false:不是对应XT布局
   */
  static isMatchXTFoldMode(targetMode: XTLayoutType): boolean {
    if (!LayoutUtils.isXTProductType()) {
      return XTLayoutType.NONE === targetMode;
    }

    let foldDisplayMode = LayoutUtils.getFoldDisplayMode() as XTLayoutType;
    return foldDisplayMode === targetMode;
  }

  /**
   * 是否XT产品
   * @returns true:XT产品 false:非XT产品
   */
  static isXTProductType(): boolean {
    let foldProductType = DeviceHelper.getFoldProductType() as number;
    return foldProductType === LayoutUtils.XT_FOLD_PRODUCT_TYPE;
  }

  /**
   * 获取折叠屏显示模式
   *
   * @returns 折叠屏显示模式
   */
  static getFoldDisplayMode(): number {
    let foldDisplayMode: display.FoldDisplayMode = display.FoldDisplayMode.FOLD_DISPLAY_MODE_UNKNOWN;
    try {
      let foldStatus = display.getFoldStatus();
      foldDisplayMode = LayoutUtils.getFoldDisplayModeByStatus(foldStatus) as number;
    } catch (error) {
      log.showError('getFoldDisplayMode -> try error:', error);
    }
    return foldDisplayMode;
  }

  /**
   * 获取超大屏的折叠屏显示模式
   *
   * @returns 折叠屏显示模式
   */
  static getFoldDisplayModeByStatus(foldStatus: display.FoldStatus): XTLayoutType {
    let newFoldStatus = foldStatus as number;
    log.showInfo(`getFoldDisplayModeByStatus newFoldStatus is ${newFoldStatus}`);
    if (newFoldStatus === XTFoldStatus.XTFoldStatus_SINGLE ||
      newFoldStatus === XTFoldStatus.XTFoldStatus_TRIPLE_TO_SINGLE ||
      newFoldStatus === XTFoldStatus.XTFoldStatus_SINGLE_TO_TRIPLE_HALF) {
      return XTLayoutType.F;
    }
    if (newFoldStatus === XTFoldStatus.XTFoldStatus_DOUBLE ||
      newFoldStatus === XTFoldStatus.XTFoldStatus_DOUBLE_TO_SINGLE) {
      return XTLayoutType.M;
    }
    return XTLayoutType.G;
  }
}