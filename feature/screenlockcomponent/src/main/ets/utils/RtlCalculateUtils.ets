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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';

import FormPlaceHolderInfo from '@ohos/screenlockwidget/src/main/ets/form/drag/FormPlaceHolderInfo';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { clockLayoutHelper } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { ClockLayout, LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import PasswordConstants from '../password/common/PasswordConstants';
import { DigitalKeyboardItem } from '../password/common/DigitalKeyboardItem';
import Constants from '../common/Constants';
import { DisplayUtils, ThreeFoldStatus } from '@ohos/screenlockcommon';

const TAG = 'RtlCalculateUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const IS_PAD: boolean = DeviceHelper.isPadOr2in1PcType();
const IS_FOLD_BUT_NOT_SMALL_FOLD: boolean = DeviceHelper.isLargeInFoldProduct();
const PHONE_GRID_AMOUNT_X = 4;
const CLOCK_GRID_AMOUNT_X = 2;
const N4CLOCK_GRID_AMOUNT_X = 4;
const SINGLE_POCKET_PHONE_GRID_AMOUNT_X: number = 6;
const FOLD_PHONE_GRID_AMOUNT_X = 8;
const PAD_GRID_AMOUNT_X = 6;
const PAD_GRID_AMOUNT_PORTRAIT_X = 10; // 横屏网格数量
const LAST_FORM_POSITION_X = 3;
const LAST_FORM_POSITION_X_TWO_ROW = 2;
const FORM_BORDER_MARGIN = 6;

export class RtlCalculateUtils {

  public static getScreenLockPanelPositionX(isFoldExpand: boolean, isPadPortrait: boolean,
    clockStyle: AnyClock): number {
    let isN4Layout: boolean = clockLayoutHelper.isN4Layout(clockStyle.layout);
    let threeSt = DisplayUtils.getThreeFoldStatus();
    // 大折叠，三折叠M态
    if (IS_FOLD_BUT_NOT_SMALL_FOLD || threeSt === ThreeFoldStatus.M_STATUS) {
      return RtlCalculateUtils.getFoldRealPositionForMargin(isN4Layout, isFoldExpand, clockStyle.x);
    }

    let positionX: number = clockStyle.x;
    if (clockStyle.layout === ClockLayout.DIMENSION_4_4) {
      positionX = clockStyle.x + 1;
    }

    // 平板，三折叠G态
    if (IS_PAD || threeSt === ThreeFoldStatus.G_STATUS) {
      return RtlCalculateUtils.getPadRealPositionXForMargin(isN4Layout, isPadPortrait, positionX);
    }

    return !isN4Layout ? PHONE_GRID_AMOUNT_X - CLOCK_GRID_AMOUNT_X - positionX : positionX;
  }

  public static getFoldRealPositionForMargin(isN4Layout: boolean, isExpand: boolean, position: number): number {
    if (isExpand) {
      return Math.max(FOLD_PHONE_GRID_AMOUNT_X - N4CLOCK_GRID_AMOUNT_X - position +
        (isN4Layout ? 0 : CLOCK_GRID_AMOUNT_X), 0);
    }
    if (isN4Layout) {
      return 0;
    }
    return Math.max(PHONE_GRID_AMOUNT_X - CLOCK_GRID_AMOUNT_X - position, 0);
  }

  public static getPadRealPositionXForMargin(isN4Layout: boolean, isPortrait: boolean, position: number): number {
    let clockWidth = isN4Layout ? N4CLOCK_GRID_AMOUNT_X : CLOCK_GRID_AMOUNT_X;
    if (!isPortrait) {
      return Math.max(PAD_GRID_AMOUNT_PORTRAIT_X - clockWidth - position, 0);
    }
    return Math.max(PAD_GRID_AMOUNT_X - clockWidth - position, 0);
  }

  /**
   *  计算维吾尔语下终点form的 x 坐标。
   *
   * @param card
   * @param gridWidth 一个网格宽度
   * @param isN4
   * @returns
   */
  public static getEndFormPositionX(card: LockscreenFormConfig, gridWidth: number, isN4: boolean): number {
    if (isN4) {
      return ((LAST_FORM_POSITION_X - card.positionX) +
        (RtlCalculateUtils.isTwoDimension(card.dimensionX) ? 0 : card.dimensionX / 2)) * gridWidth;
    } else {
      return ((LAST_FORM_POSITION_X_TWO_ROW / card.positionX) +
        (RtlCalculateUtils.isTwoDimension(card.dimensionX) ? 0 : card.dimensionX / 2)) *
        gridWidth;
    }
  }

  public static getFormBorderMargin(item: FormPlaceHolderInfo, isN4: boolean, gridWidth: number): number {
    let xRes = 0;
    if (isN4) {
      xRes = (LAST_FORM_POSITION_X - item.positionX) * gridWidth + FORM_BORDER_MARGIN;
    } else {
      xRes = (LAST_FORM_POSITION_X_TWO_ROW / item.positionX) * gridWidth + FORM_BORDER_MARGIN;
    }
    xRes -= RtlCalculateUtils.isTwoDimension(item.dimensionX) ? gridWidth : 0;
    return xRes;
  }

  private static isTwoDimension(dimensionX: number): boolean {
    return dimensionX === 2;
  }

  public static getNumberKeyBoard(): DigitalKeyboardItem[] {
    return !RTLUtil.isRTL() ? PasswordConstants.NUM_KEYBOARD : PasswordConstants.RTL_NUM_KEYBOARD;
  }

  public static getDelPwdIndex(): number {
    return !RTLUtil.isRTL() ? Constants.DEL_PWD_INDEX : Constants.DEL_PWD_INDEX_RTL;
  }
}