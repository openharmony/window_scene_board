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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper';
import KeyBoardLayoutConstants, { DevicesGrids, DeviceClassification, KeyboardPageType,
  PassWordLayout } from './LayoutConstants';
import { CommonConstants } from '@ohos/screenlockcommon';

const TAG = 'Keyboard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class ScreenLockKeyboardTipUtil {
  public static keyboardWidthLayout(displayWidth: number,
                                    deviceGridData: DevicesGrids,
                                    pageType: KeyboardPageType = KeyboardPageType.PSD_DIGITAL): number {
    log.showInfo(`displayWidth: ${displayWidth}, keyboardWidthPad: ${deviceGridData.index}, pageType:${pageType}`);
    if (DeviceHelper.isPadOr2in1PcType()) {
      let keyboardWidthPad = ScreenLockKeyboardTipUtil.getMultiColumn(displayWidth, deviceGridData,
        KeyBoardLayoutConstants.KEYBOARD_WIDTH_COUNT_COLUMNS_PAD);
      if (pageType === KeyboardPageType.PSD_PATTERN) {
        return keyboardWidthPad;
      }
      // keyboardWidthPad - (keyboardWidthPad / 3 - 68) 适配RelativeContainer
      return (2 / 3) * keyboardWidthPad + 68;
    }
    /**
     *  手机的图形密码宽度是298，pad 图形密码的宽度和其他的密码一样
     */
    if (pageType === KeyboardPageType.PSD_PATTERN) {
      return KeyBoardLayoutConstants.PHONE_PATTERN_WIDTH;
    }
    if (deviceGridData.index === DeviceClassification.PSD_SMALL_FOLD_PHONE) {
      return KeyBoardLayoutConstants.OUTER_PHONE_KEYBOARD_WIDTH;
    }
    let keyboardWidth = KeyBoardLayoutConstants.PHONE_KEYBOARD_WIDTH;
    return keyboardWidth;
  }

  public static getMultiColumn(displayWidth: number, deviceGridData: DevicesGrids, countColumn: number = 1): number {
    if (DeviceHelper.isPadOr2in1PcType() || DeviceHelper.isFoldExpanded()) {
      let singleColumn = ((displayWidth - (deviceGridData.psdColumn - KeyBoardLayoutConstants.GUTTER_COUNT) *
      deviceGridData.psdGutter - KeyBoardLayoutConstants.MARGIN_BOTH_SIDE_COUNT * deviceGridData.psdMargin) /
      deviceGridData.psdColumn) * countColumn + (countColumn - 1) * deviceGridData.psdGutter;
      return singleColumn;
    }
    return 0;
  }

  /**
   * 获取密码页面箭头的距离侧边的距离
   *
   * @param displayWidth 屏幕宽度
   * @param deviceGridData 栅格类型
   * @returns 箭头的距离侧边的距离
   */
  public static componentArrowMarginLeft(displayWidth: number,
    deviceGridData: DevicesGrids): number {
    // (2 col + 1 gutter - ArrowWidth)/2 + deviceGridData.psdMargin
    let marginLeft: number = (((displayWidth - (deviceGridData.psdColumn - KeyBoardLayoutConstants.GUTTER_COUNT) *
    deviceGridData.psdGutter - KeyBoardLayoutConstants.MARGIN_BOTH_SIDE_COUNT * deviceGridData.psdMargin) /
    deviceGridData.psdColumn) * KeyBoardLayoutConstants.ARROW_MARGIN_COLUMN_COUNT + deviceGridData.psdGutter -
    KeyBoardLayoutConstants.ARROW_WIDTH) / 2 + deviceGridData.psdMargin;
    log.showInfo(`displayWidth: ${displayWidth}, keyboardWidthPad: ${deviceGridData.index},marginLeft:${marginLeft}`);
    return marginLeft;
  }

  /**
   * 根据密码类型获取拉起密码页面类型， 默认6位密码
   *
   * @param passwordType 密码类型
   * @returns 页面类型
   */
  private static gainPageType(passwordType: string): KeyboardPageType {
    switch (passwordType) {
      case CommonConstants.PIN_TYPE_NUMBER:
        return KeyboardPageType.PSD_CUSTOM;
      case CommonConstants.PIN_TYPE_MIX:
        return KeyboardPageType.PSD_MIX;
      case CommonConstants.PIN_TYPE_PATTERN:
        return KeyboardPageType.PSD_PATTERN;
      case CommonConstants.PIN_TYPE_FOUR:
        return KeyboardPageType.PSD_FOUR;
      default:
        return KeyboardPageType.PSD_DIGITAL;
    }
  }

  /**
   * 获取密码页面箭头的距离底部的距离
   *
   * @param displayHeight 屏幕高度
   * @param psdLayoutData 密码页面布局参数
   * @param passwordType 密码类型
   * @returns 箭头的距离底部的距离
   */
  public static componentArrowMarginBottom(displayHeight: number, psdLayoutData: PassWordLayout,
    passwordType: string): number {
    const pageType = ScreenLockKeyboardTipUtil.gainPageType(passwordType);
    const halfNumKeyboardHeight: number =
      ScreenLockKeyboardTipUtil.keyboardHeightCount(displayHeight, psdLayoutData.index, pageType) / 2;
    const marginBottomResId: Resource = (passwordType === CommonConstants.PIN_TYPE_PATTERN) ?
    psdLayoutData.patternPSDMarginBottom : psdLayoutData.psdBottomMargin;
    const keyboardMarginBottom: number = ResourceManager.getInstance().getNumberByResource(marginBottomResId);
    const marginBottom = halfNumKeyboardHeight + px2vp(keyboardMarginBottom) -
    KeyBoardLayoutConstants.HALF_ARROW_HEIGHT;
    log.showInfo(`marginBottom:${marginBottom},psdLayoutData:${psdLayoutData.index},passwordType:${passwordType},` +
      ` halfNumKeyboardHeight:${halfNumKeyboardHeight},keyboardMarginBottom:${keyboardMarginBottom}`);
    return marginBottom;
  }

  public static inputTipWidthLayout(displayWidth: number, deviceGridData: DevicesGrids): number {
    if (deviceGridData.index === DeviceClassification.PSD_PAD_LANDSCAPE ||
      deviceGridData.index === DeviceClassification.PSD_PAD_PORTRAIT) {
      let inputTipWidth = ((displayWidth - (deviceGridData.psdColumn - KeyBoardLayoutConstants.GUTTER_COUNT) *
      deviceGridData.psdGutter - KeyBoardLayoutConstants.MARGIN_BOTH_SIDE_COUNT * deviceGridData.psdMargin) /
      deviceGridData.psdColumn) * KeyBoardLayoutConstants.INPUT_TIP_WIDTH_COUNT_COLUMNS +
        KeyBoardLayoutConstants.INPUT_TIP_WIDTH_COUNT_GUTTER * deviceGridData.psdGutter;
      return inputTipWidth;
    }
    if (deviceGridData.index === DeviceClassification.PSD_SMALL_FOLD_PHONE) {
      return KeyBoardLayoutConstants.OUTER_PHONE_INPUT_WIDTH;
    }
    return KeyBoardLayoutConstants.PHONE_INPUT_WIDTH;
  }

  public static keyboardHeightCount(displayHeight: number,
                                    index: DeviceClassification,
                                    pageType: KeyboardPageType): number {
    log.showInfo(`keyboardHeightCount displayHeight：${displayHeight} index:${index} pageType: ${pageType}`);
    if (index === DeviceClassification.PSD_PAD_LANDSCAPE && pageType !== KeyboardPageType.PSD_MIX) {
      return displayHeight / KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_RATIO_LANDSCAPE;
    }
    if (index === DeviceClassification.PSD_PAD_PORTRAIT && pageType !== KeyboardPageType.PSD_MIX) {
      return displayHeight / KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_RATIO_PORTRAIT;
    }

    // PAD MIX PSD
    if (index === DeviceClassification.PSD_PAD_LANDSCAPE && pageType === KeyboardPageType.PSD_MIX) {
      let mixKeyboardMarginBottom = displayHeight / KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_RATIO_LANDSCAPE +
      KeyBoardLayoutConstants.PAD_KEYBOARD_MIX_HEIGHT_MARGIN_BOTTOM_LANDSCAPE +
      KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_MARGIN_INPUT_LANDSCAPE - KeyBoardLayoutConstants.PAD_EMERGENCY_HEIGHT;
      return mixKeyboardMarginBottom;
    }
    if (index === DeviceClassification.PSD_PAD_PORTRAIT && pageType === KeyboardPageType.PSD_MIX) {
      let mixKeyboardMarginBottom = displayHeight / KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_RATIO_PORTRAIT +
      KeyBoardLayoutConstants.PAD_KEYBOARD_MIX_HEIGHT_MARGIN_BOTTOM_PORTRAIT +
      KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_MARGIN_INPUT_PORTRAIT - KeyBoardLayoutConstants.PAD_EMERGENCY_HEIGHT;
      return mixKeyboardMarginBottom;
    }

    // PHONE MIX PSD NO FINGER OR FOLD EXPAND
    if ((index === DeviceClassification.PSD_NO_FINGER || index === DeviceClassification.PSD_FOLD_EXPAND ||
      index === DeviceClassification.PSD_THREE_FOLD_G_HORIZONTAL) && pageType === KeyboardPageType.PSD_MIX) {
      return KeyBoardLayoutConstants.KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_NO_FINGER;
    }

    // THREE FOLD MIX PSD G PORTRAIT
    if (index === DeviceClassification.PSD_THREE_FOLD_G_PORTRAIT && pageType === KeyboardPageType.PSD_MIX) {
      return KeyBoardLayoutConstants.THREE_FOLD_G_PORTRAIT_KEYBOARD_MIX_MARGIN_BOTTOM;
    }

    // PHONE MIX PSD PSD_LOW_FINGER_PRINT_PHONE
    if (index === DeviceClassification.PSD_LOW_FINGER_PRINT_PHONE && pageType === KeyboardPageType.PSD_MIX) {
      return KeyBoardLayoutConstants.KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_LOW_FINGER;
    }
    // PHONE MIX PSD PSD_HEIGHT_FINGER_PRINT_PHONE
    if (index === DeviceClassification.PSD_HEIGHT_FINGER_PRINT_PHONE && pageType === KeyboardPageType.PSD_MIX) {
      return KeyBoardLayoutConstants.KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_HIGH_FINGER;
    }

    // SMALL OUTER SCREEN MIX PSD
    if (index === DeviceClassification.PSD_SMALL_FOLD_PHONE && pageType === KeyboardPageType.PSD_MIX) {
      return KeyBoardLayoutConstants.KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_OUTER_SCREEN;
    }

    // PHONE OUTER SCREEN
    if (index === DeviceClassification.PSD_SMALL_FOLD_PHONE) {
      return KeyBoardLayoutConstants.KEYBOARD_HEIGHT_PHONE_OUTER_SCREEN;
    }

    return KeyBoardLayoutConstants.KEYBOARD_HEIGHT_PHONE;
  }

  /**
   * 获取三折叠G态密码盘宽度比例
   *
   * @param displayWidth 屏幕宽度
   * @param isLandscape 是否横屏
   * @returns 三折叠G态密码盘宽度比例
   */
  public static getGStateKeyboardWidthPercent(displayWidth: number, isLandscape: boolean): number {
    const deviceClassification: DeviceClassification = isLandscape ? DeviceClassification.PSD_THREE_FOLD_G_HORIZONTAL :
      DeviceClassification.PSD_FOLD_EXPAND;
    const deviceGrid = KeyBoardLayoutConstants.DEVICES_GRIDS.get(deviceClassification) as DevicesGrids;
    const columnWidth = (displayWidth -
      deviceGrid.psdMargin * KeyBoardLayoutConstants.THREE_FOLD_G_COUNT_MARGINS -
      deviceGrid.psdGutter * (deviceGrid.psdColumn - 1)) / deviceGrid.psdColumn;
    const gStateKeyboardWidthPercent = (columnWidth * KeyBoardLayoutConstants.THREE_FOLD_G_KEYBOARD_COUNT_COLUMNS +
      deviceGrid.psdGutter * KeyBoardLayoutConstants.THREE_FOLD_G_KEYBOARD_COUNT_GUTTERS +
      deviceGrid.psdMargin * KeyBoardLayoutConstants.THREE_FOLD_G_KEYBOARD_COUNT_MARGIN) / displayWidth;
    log.showInfo(`displayWidth: ${displayWidth} gStateKeyboardWidthPercent: ${gStateKeyboardWidthPercent}`);
    return gStateKeyboardWidthPercent;
  }

  /**
   * 获取sim卡页面puk和记住pin的prop宽度
   *
   * @param displayWidth 屏幕宽度
   * @param deviceGridData 栅格类型
   * @returns 提示框的宽度
   */
  public static simPukTipColumnWidth(displayWidth: number, deviceGridData: DevicesGrids): number {
    // 4col + 3gutter  折叠机展开态和pad
    let width: number = 0;
    if (deviceGridData.index === DeviceClassification.PSD_FOLD_EXPAND ||
    DeviceClassification.PSD_FOLD_EXPAND_HORIZONTAL ||
      deviceGridData.index === DeviceClassification.PSD_PAD_LANDSCAPE ||
      deviceGridData.index === DeviceClassification.PSD_PAD_PORTRAIT) {
      width = ((displayWidth - (deviceGridData.psdColumn - KeyBoardLayoutConstants.GUTTER_COUNT) *
      deviceGridData.psdGutter - KeyBoardLayoutConstants.MARGIN_BOTH_SIDE_COUNT * deviceGridData.psdMargin) /
      deviceGridData.psdColumn) * KeyBoardLayoutConstants.SIM_PROP_COLUMN_COUNT +
        deviceGridData.psdGutter * KeyBoardLayoutConstants.SIM_PROP_GUTTER_COUNT;
      return width;
    } else {
      // 距离两侧24
      width = displayWidth - KeyBoardLayoutConstants.SIM_PROP_MARGIN_BOTH_SIZE;
    }
    log.showInfo(`simPukTipColumnWidth width:${width},index:${deviceGridData.index}`);
    return width;
  }
}