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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { clockLayoutHelper, GridAmount } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutHelper';
import { ClockComFamily, ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

import { GlobalStatusCache, StatusCacheConst }  from '@ohos/screenlockcommon/src/main/ets/base/GlobalStatusCache';
import TestConst from '../../constants/TestConst';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';

// Layout margin in horizontal
const NORMAL_GRID_MARGIN: number = 24;
const THREE_FOLD_M_GRID_MARGIN = 54;
const PAD_GRID_MARGIN: number = 99;
const SMALL_FOLD_GRID_MARGIN: number = 20;

// Layout margin in vertical
const NORMAL_VERTICAL_GRID_MARGIN: number = 104;
const FOLD_GRID_MARGIN_BOTTOM: number = 111;
const FOLD_GRID_WIDTH: number = 78;
const SMALL_FOLD_GRID_WIDTH: number = 48;
const PAD_GRID_MARGIN_BOTTOM: number = 112;

// Layout grid amount
const NORMAL_GRID_AMOUNT_X: number = 4;
const NORMAL_GRID_AMOUNT_Y: number = 7;
const SINGLE_POCKET_GRID_AMOUNT_X: number = 6;
const SINGLE_POCKET_GRID_AMOUNT_Y: number = 4;
const SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y: number = 7;
const PAD_GRID_INSIDE_AMOUNT_X: number = 10;
const PAD_GRID_INSIDE_AMOUNT_Y: number = 6;
const FOLDER_GRID_INSIDE_AMOUNT_X: number = 8;
const FOLDER_GRID_INSIDE_AMOUNT_Y: number = 7;
const GRID_AMOUNT_4: number = 4;

export default function ClockLayoutHelperTest() {
  let mocker: MockKit = new MockKit();
  const isDevicePad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
  const IS_THREE_FOLD: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isThreeFoldProduct);
  const IS_SMALL_FOLD: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
  const IS_FOLD_DEVICE: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
  const isFoldButNot: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
  const IS_LANDSCAPE: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
  const mockResultTrue: boolean = true;
  const mockResultFalse: boolean = false;
  const layoutGridAmount: GridAmount = { x: 400, y: 600 }

  describe('ClockLayoutHelperTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_setScreenSessionRotatable_01', 0, (): void => {
      clockLayoutHelper.setScreenSessionRotatable();
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_setScreenSessionRotatable_02', 0, (): void => {
      clockLayoutHelper.setScreenSessionRotatable(true);
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_setScreenSessionRotatable_03', 0, (): void => {
      clockLayoutHelper.setScreenSessionRotatable(false);
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_getScreenWidth_01', 0, (): void => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.SCREEN_WIDTH_KEY, 0);
      let res = clockLayoutHelper.getScreenWidth();
      expect(res).not().assertNull();
    });

    it('test_getScreenWidth_02', 0, (): void => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.SCREEN_WIDTH_KEY, 400);
      let res = clockLayoutHelper.getScreenWidth();
      expect(res).not().assertNull();
    });

    it('test_getScreenHeight_01', 0, (): void => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, 0);
      let res = clockLayoutHelper.getScreenHeight();
      expect(res).not().assertNull();
    });

    it('test_getScreenHeight_02', 0, (): void => {
      GlobalStatusCache.getInstance().setStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, 500);
      let res = clockLayoutHelper.getScreenHeight();
      expect(res).not().assertNull();
    });

    it('test_isFoldExpanded', 0, (): void => {
      let res = clockLayoutHelper.isFoldExpanded();
      expect(res).assertFalse();
    });


    it('test_isFullDisplayMode_01', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultTrue);

      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFullDisplayMode_02', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultTrue);

      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFullDisplayMode_03', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultTrue);
      when(IS_SINGLE_DISPLAY_POCKET_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFullDisplayMode_04', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultTrue);
      when(IS_SINGLE_DISPLAY_POCKET_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).not().assertNull();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFullDisplayMode_05', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultFalse);

      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFullDisplayMode_06', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultFalse);

      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFullDisplayMode_07', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultFalse);
      when(IS_SINGLE_DISPLAY_POCKET_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFullDisplayMode_08', 0, (): void => {
      when(isFoldButNot)().afterReturn(mockResultFalse);
      when(IS_SINGLE_DISPLAY_POCKET_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      let res = clockLayoutHelper.isFullDisplayMode();
      expect(res).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFoldButNotSmallFoldProduct);

      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_getHorizontalGridMargin_01', 0, (): void => {
      let res = clockLayoutHelper.getHorizontalGridMargin(true);
      expect(res).assertEqual(NORMAL_GRID_MARGIN);
    });

    it('test_getHorizontalGridMargin_02', 0, (): void => {
      let res = clockLayoutHelper.getHorizontalGridMargin(false);
      expect(res).assertEqual(NORMAL_GRID_MARGIN);
    });

    it('test_getHorizontalGridMargin_03', 0, (): void => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(true);
      expect(result).not().assertNull();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getHorizontalGridMargin_04', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(true);
      expect(result).not().assertNull();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_getHorizontalGridMargin_05', 0, (): void => {
      const result: number = clockLayoutHelper.getHorizontalGridMargin(true);
      expect(result).not().assertNull();
    });

    it('test_getHorizontalGridMargin_06', 0, (): void => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(false);
      expect(result).not().assertNull();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getHorizontalGridMargin_07', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(false);
      expect(result).not().assertNull();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_getHorizontalGridMargin_08', 0, (): void => {
      const result: number = clockLayoutHelper.getHorizontalGridMargin(false);
      expect(result).not().assertNull();
    });

    it('test_getHorizontalLockIconMargin_01', 0, (): void => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getHorizontalLockIconMargin();
      expect(result).assertEqual(NORMAL_GRID_MARGIN);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getHorizontalLockIconMargin_02', 0, (): void => {
      const result: number = clockLayoutHelper.getHorizontalLockIconMargin();
      expect(result).assertEqual(NORMAL_GRID_MARGIN);
    });

    it('test_getHorizontalLockIconMargin_03', 0, (): void => {
      const result: number = clockLayoutHelper.getHorizontalLockIconMargin();
      expect(result).assertEqual(NORMAL_GRID_MARGIN);
    });

    it('test_getLayoutGridAmount_01', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridAmount(true);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutGridAmount_02', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridAmount(false);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutGridAmount_03', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridAmount(true, true);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutGridAmount_04', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridAmount(true, false);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutGridAmount_05', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridAmount(false, true);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutGridAmount_06', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridAmount(false, false);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutGridAmount_07', TestConst.TEST_LEVEL, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutGridAmount_08', TestConst.TEST_LEVEL, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutGridAmount_21', TestConst.TEST_LEVEL, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutGridAmount_22', TestConst.TEST_LEVEL, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutGridAmount_23', TestConst.TEST_LEVEL, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(false, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutGridAmount_24', TestConst.TEST_LEVEL, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(false, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutGridAmount_25', TestConst.TEST_LEVEL, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true);
      expect(result.x).assertEqual(NORMAL_GRID_AMOUNT_X);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getLayoutGridAmount_26', TestConst.TEST_LEVEL, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(false);
      expect(result.x).assertEqual(NORMAL_GRID_AMOUNT_X);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getLayoutGridAmount_27', TestConst.TEST_LEVEL, () => {
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true);
      expect(result.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_isUseLargeLayoutAmount_01', 0, (): void => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount']();
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_isUseLargeLayoutAmount_02', 0, (): void => {
      when(isDevicePad)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount']();
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseLargeLayoutAmount_03', 0, (): void => {
      when(isDevicePad)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount']();
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_01', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultTrue);
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](true);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_02', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultTrue);
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](true);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_03', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](true);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_04', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](true);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_05', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultTrue);
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](false);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_06', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultTrue);
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](false);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_07', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](false);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isUseMediumLayoutAmount_08', 0, (): void => {
      when(IS_SMALL_FOLD)().afterReturn(mockResultFalse);
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isUseLargeLayoutAmount'](false);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_getLayoutAmount_01', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(true, true);
      expect(res.x).assertEqual(FOLDER_GRID_INSIDE_AMOUNT_X);
    });

    it('test_getLayoutAmount_02', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(true, false);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutAmount_03', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(false, true);
      expect(res.x).assertEqual(FOLDER_GRID_INSIDE_AMOUNT_X);
    });

    it('test_getLayoutAmount_04', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(false, false);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutAmount_05', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(true, true, true);
      expect(res.x).assertEqual(FOLDER_GRID_INSIDE_AMOUNT_X);
    });

    it('test_getLayoutAmount_06', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(true, true, false);
      expect(res.x).assertEqual(FOLDER_GRID_INSIDE_AMOUNT_X);
    });

    it('test_getLayoutAmount_07', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(true, false, true);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutAmount_08', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(true, false, false);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutAmount_09', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(false, true, true);
      expect(res.x).assertEqual(FOLDER_GRID_INSIDE_AMOUNT_X);
    });

    it('test_getLayoutAmount_10', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(false, true, false);
      expect(res.x).assertEqual(FOLDER_GRID_INSIDE_AMOUNT_X);
    });

    it('test_getLayoutAmount_11', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(false, false, true);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutAmount_12', 0, (): void => {
      let res = clockLayoutHelper.getLayoutAmount(false, false, false);
      expect(res.x).assertEqual(NORMAL_GRID_AMOUNT_X);
    });

    it('test_getLayoutAmount_13', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(true, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_14', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(true, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_15', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(false, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_16', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(false, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_17', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(true, true, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_18', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(true, true, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_19', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(true, false, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_20', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(true, false, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_21', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(false, true, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_22', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(false, true, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_23', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(false, false, true);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_24', 0, () => {

      const result: GridAmount = clockLayoutHelper.getLayoutAmount(false, false, false);
      expect(result.y).assertEqual(SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y);

    });

    it('test_getLayoutAmount_25', 0, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true, true);
      expect(result.x).assertEqual(SINGLE_POCKET_GRID_AMOUNT_Y);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getLayoutAmount_26', 0, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true, false);
      expect(result.x).assertEqual(SINGLE_POCKET_GRID_AMOUNT_Y);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getLayoutAmount_27', 0, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(false, true);
      expect(result.x).assertEqual(SINGLE_POCKET_GRID_AMOUNT_Y);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getLayoutAmount_28', 0, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(false, false);
      expect(result.x).assertEqual(SINGLE_POCKET_GRID_AMOUNT_Y);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_getLayoutAmount_29', 0, () => {
      const result: GridAmount = clockLayoutHelper.getLayoutGridAmount(true, true);
      expect(result.x).assertEqual(SINGLE_POCKET_GRID_AMOUNT_Y);
    });

    it('test_getLayoutGridWidth_01', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridWidth(false);
      expect(res).not().assertNull();
    });

    it('test_getLayoutGridWidth_02', 0, (): void => {
      let res = clockLayoutHelper.getLayoutGridWidth(true);
      expect(res).not().assertNull();
    });

    it('test_getLayoutGridWidth_03', 0, (): void => {
      when(IS_FOLD_DEVICE)().afterReturn(mockResultTrue);
      when(IS_LANDSCAPE)().afterReturn(mockResultFalse);
      when(IS_SINGLE_DISPLAY_POCKET_FOLD)().afterReturn(mockResultFalse);
      let res = clockLayoutHelper.getLayoutGridWidth(true);
      expect(res).not().assertNull();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isFold);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isLandscape);

    });

    it('test_getLayoutGridWidthThreeFold_01', 0, (): void => {
      let gridAmount: GridAmount = { x: 0, y: 100 }
      const result: boolean = (clockLayoutHelper as object)['getLayoutGridWidthThreeFold'](gridAmount, 300, 200, false);
      expect(result).assertEqual(FOLD_GRID_WIDTH);
    });

    it('test_getLayoutGridWidthThreeFold_02', 0, (): void => {
      let gridAmount: GridAmount = { x: 110, y: 0 }
      const result: boolean = (clockLayoutHelper as object)['getLayoutGridWidthThreeFold'](gridAmount, 300, 200, true);
      expect(result).assertEqual(FOLD_GRID_WIDTH);
    });

    it('test_getLayoutGridWidthThreeFold_03', 0, (): void => {
      const result: boolean = (clockLayoutHelper as object)['getLayoutGridWidthThreeFold'](layoutGridAmount, 300, 200, false);
      expect(result).not().assertNull();
    });

    it('test_getLayoutGridWidthThreeFold_03', 0, (): void => {
      const result: boolean = (clockLayoutHelper as object)['getLayoutGridWidthThreeFold'](layoutGridAmount, 300, 200, true);
      expect(result).not().assertNull();
    });

    it('test_px2vpWithUiContext', 0, (): void => {
      const result: boolean = (clockLayoutHelper as object)['px2vpWithUiContext'](300);
      expect(result).not().assertNull();
    });

    it('test_isFoldFixedGrid_01', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](true, true);
      expect(result).assertTrue();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFoldFixedGrid_02', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](true, false);
      expect(result).assertTrue();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFoldFixedGrid_03', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](false, true);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFoldFixedGrid_04', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultTrue);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](false, false);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFoldFixedGrid_05', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](true, true);
      expect(result).assertTrue();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFoldFixedGrid_06', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](true, false);
      expect(result).assertTrue();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFoldFixedGrid_07', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](false, true);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_isFoldFixedGrid_08', 0, (): void => {
      when(IS_THREE_FOLD)().afterReturn(mockResultFalse);
      const result: boolean = (clockLayoutHelper as object)['isFoldFixedGrid'](false, false);
      expect(result).assertFalse();
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isThreeFoldProduct);
    });

    it('test_getGridMarginBottom_01', 0, (): void => {
      const result: number = (clockLayoutHelper as object)['getGridMarginBottom']();
      expect(result).assertEqual(PAD_GRID_MARGIN_BOTTOM);
    });

    it('test_getGridMarginBottom_02', 0, (): void => {
      const result: number = (clockLayoutHelper as object)['getGridMarginBottom']();
      expect(result).assertEqual(PAD_GRID_MARGIN_BOTTOM);
    });

    it('test_getLayoutSize', 0, (): void => {
      let res = clockLayoutHelper.getLayoutSize(1920, {
        x: 100,
        y: 100,
      });
      expect(res).not().assertNull();
    });

    it('test_getWidgetSize', 0, (): void => {
      let res = clockLayoutHelper.getWidgetSize();
      expect(res).not().assertNull();
    });

    it('test_adapterTimeViewFontFamily', 0, (): void => {
      let res = true;
      clockLayoutHelper.adapterTimeViewFontFamily('');
      expect(res).assertTrue();
    });

    it('test_adapterTimeViewPositionX', 0, (): void => {
      let res = true;
      clockLayoutHelper.adapterTimeViewPositionX(1000, 50, { x: 10, y: 10 }, { x: 20, y: 20 });
      clockLayoutHelper.adapterTimeViewPositionX(1000, 50, { x: 10, y: 10 }, { x: 4, y: 4 });
      clockLayoutHelper.adapterTimeViewPositionX(-1000, 50, { x: 10, y: 10 }, { x: 4, y: 4 });
      expect(res).not().assertNull();
    });

    it('test_isN4Layout_01', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.DIMENSION_2_4);
      expect(res).assertTrue();
    });

    it('test_isN4Layout_02', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.NORMAL_CLOCK_LAYOUT);
      expect(res).assertTrue();
    });

    it('test_isN4Layout_03', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT);
      expect(res).assertTrue();
    });

    it('test_isN4Layout_04', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL);
      expect(res).assertTrue();
    });

    it('test_isN4Layout_05', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.MOUNTAIN_CLOCK_LAYOUT);
      expect(res).assertTrue();
    });

    it('test_isN4Layout_06', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL);
      expect(res).assertTrue();
    });

    it('test_isN4Layout_07', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR);
      expect(res).assertTrue();
    });

    it('test_isN4Layout_08', 0, (): void => {
      let res = clockLayoutHelper.isN4Layout(ClockLayout.DIMENSION_4_4);
      expect(res).assertFalse();
    });

    it('test_alignSizeForAod', 0, (): void => {
      let res = true;
      clockLayoutHelper.alignSizeForAod(10);
      expect(res).assertTrue();
    });

    it('test_align8ByteForAod', 0, (): void => {
      let res = true;
      clockLayoutHelper.align8ByteForAod(10);
      expect(res).assertTrue();
    });

    it('test_updateClockPosition_01', 0, (): void => {
      let anyClock:AnyClock = new AnyClock();
      const anyClockFun: Function = mocker.mockFunc(anyClock, anyClock.getGridAmountWidth);
      when(anyClockFun)().afterReturn(GRID_AMOUNT_4);
      clockLayoutHelper.updateClockPosition(ClockLayout.DEFAULT_CLOCK_LAYOUT, anyClock, layoutGridAmount, 30, 40);
      clockLayoutHelper.updateClockPosition(ClockLayout.DEFAULT_CLOCK_SPECIAL, anyClock, layoutGridAmount, 30, 40);
      mocker.ignoreMock(anyClock,anyClock.getGridAmountWidth);
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_updateClockPosition_02', 0, (): void => {
      let anyClock:AnyClock = new AnyClock();
      const anyClockFun: Function = mocker.mockFunc(anyClock, anyClock.getGridAmountWidth);
      when(anyClockFun)().afterReturn(2);
      clockLayoutHelper.updateClockPosition(ClockLayout.DEFAULT_CLOCK_LAYOUT, anyClock, layoutGridAmount, 30, 40);
      clockLayoutHelper.updateClockPosition(ClockLayout.DEFAULT_CLOCK_SPECIAL, anyClock, layoutGridAmount, 30, 40);
      mocker.ignoreMock(anyClock,anyClock.getGridAmountWidth);
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_updateClockPosition_03', 0, (): void => {
      let anyClock:AnyClock = new AnyClock();
      clockLayoutHelper.updateClockPosition(ClockLayout.NORMAL_CLOCK_LAYOUT, anyClock, layoutGridAmount, 30, 40);
      clockLayoutHelper.updateClockPosition(ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT, anyClock, layoutGridAmount, 30, 40);
      clockLayoutHelper.updateClockPosition(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL, anyClock, layoutGridAmount, 30, 40);
      clockLayoutHelper.updateClockPosition(ClockLayout.MOUNTAIN_CLOCK_LAYOUT, anyClock, layoutGridAmount, 30, 40);
      clockLayoutHelper.updateClockPosition(ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR, anyClock, layoutGridAmount, 30, 40);
      clockLayoutHelper.updateClockPosition(ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL, anyClock, layoutGridAmount, 30, 40);
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_ClockLayoutHelper_getSingleGridWidth', TestConst.TEST_LEVEL, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getLayoutGridWidth(true);
      expect(result).not().assertEqual(-1);
      mocker.ignoreMock(DeviceHelper,  DeviceHelper.isPad);
    });

    it('test_default_value_adapterTimeViewFontFamily', 0, () => {
      expect(clockLayoutHelper.adapterTimeViewFontFamily('HarmonyHeiTi')).assertEqual(ClockComFamily.HARMONY_CLOCK_01);
      expect(clockLayoutHelper.adapterTimeViewFontFamily('HarmonyOS_Serif')).assertEqual(ClockComFamily.HARMONY_CLOCK_01);
      expect(clockLayoutHelper.adapterTimeViewFontFamily('HarmonyOS_Sans')).assertEqual(ClockComFamily.HARMONY_CLOCK_01);
      expect(clockLayoutHelper.adapterTimeViewFontFamily('HarmonyOS-Sans')).assertEqual(ClockComFamily.HARMONY_CLOCK_01);
    });

    it('test_ClockLayoutHelper_getHorizontalGridMargin1', 0, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      when(IS_SMALL_FOLD)().afterReturn(mockResultFalse);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(false);
      expect(result).not().assertEqual(-1);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
    });

    it('test_ClockLayoutHelper_getHorizontalGridMargin2', 0, () => {
      when(isDevicePad)().afterReturn(mockResultTrue);
      when(IS_SMALL_FOLD)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(false);
      expect(result).not().assertEqual(-1);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
    });

    it('test_ClockLayoutHelper_getHorizontalGridMargin3', 0, () => {
      when(isDevicePad)().afterReturn(mockResultFalse);
      when(IS_SMALL_FOLD)().afterReturn(mockResultFalse);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(false);
      if (clockLayoutHelper.isFullDisplayMode()) {
        expect(result).not().assertEqual(-1);
      } else {
        expect(result).assertEqual(24);
      }
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
    });

    it('test_ClockLayoutHelper_getHorizontalGridMargin4', 0, () => {
      when(isDevicePad)().afterReturn(mockResultFalse);
      when(IS_SMALL_FOLD)().afterReturn(mockResultTrue);
      const result: number = clockLayoutHelper.getHorizontalGridMargin(false);
      expect(result).assertEqual(24);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
    });

    it('test_getLayoutGridWidthPad', 0, () => {
      let gridAmount: GridAmount = {x: 0, y: 0};
      (clockLayoutHelper as object)['getLayoutGridWidthPad'](10, gridAmount);

      gridAmount.x = 10;
      gridAmount.y = 10;
      (clockLayoutHelper as object)['getLayoutGridWidthPad'](10, gridAmount);
      expect(true).assertTrue();
    });

    it('test_getHorizontalGridMargin_05', 0, () => {
      const isFold: Function = mocker.mockFunc(clockLayoutHelper, clockLayoutHelper.isFoldExpanded);
      when(isFold)().afterReturn(false);
      when(isDevicePad)().afterReturn(mockResultFalse);
      when(IS_SMALL_FOLD)().afterReturn(mockResultFalse);
      when(IS_FOLD_DEVICE)().afterReturn(mockResultTrue);
      clockLayoutHelper.getHorizontalGridMargin(false);
      expect(clockLayoutHelper).not().assertNull();
      mocker.ignoreMock(clockLayoutHelper, clockLayoutHelper.isFoldExpanded);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
    });

    it('test_calculateGridMargin_01', 0, () => {
      (clockLayoutHelper as object)['calculateGridMargin'](true, 10);
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_calculateGridMargin_02', 0, () => {
      (clockLayoutHelper as object)['calculateGridMargin'](false, 10);
      expect(clockLayoutHelper).not().assertNull();
    });



    it('test_updateClockObjectX', TestConst.TEST_LEVEL, () => {
      let anyClock:AnyClock = new AnyClock();
      const anyClockFun: Function = mocker.mockFunc(anyClock, anyClock.getGridAmountWidth);
      when(anyClockFun)().afterReturn(2);
      (clockLayoutHelper as object)['updateClockObjectX'](anyClock, 10);
      expect(clockLayoutHelper).not().assertNull();
      mocker.ignoreMock(anyClock,anyClock.getGridAmountWidth)
    });

    it('test_updateClockObjectY_01', TestConst.TEST_LEVEL, () => {
      let anyClock:AnyClock = new AnyClock();
      anyClock.y = 0;
      (clockLayoutHelper as object)['updateClockObjectY'](ClockLayout.DIMENSION_4_4, anyClock, 4, 40, 30);
      expect(clockLayoutHelper).not().assertNull();
    });

    it('test_updateClockObjectY_02', TestConst.TEST_LEVEL, () => {
      let anyClock:AnyClock = new AnyClock();
      anyClock.y = 6;
      (clockLayoutHelper as object)['updateClockObjectY'](ClockLayout.DIMENSION_4_4, anyClock, 2, 40, 30);
      expect(clockLayoutHelper).not().assertNull();
    });
  })
}