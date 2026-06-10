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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import KeyBoardLayoutConstants, { DeviceClassification, DevicesGrids, KeyboardPageType } from '../../../../../../main/ets/common/LayoutConstants';
import ScreenLockKeyboardUtil from '../../../../../../main/ets/common/ScreenLockKeyboardUtil';
import TestConst from '../constants/TestConst';


export default function ScreenLockKeyboardUtilTest() {

  describe('ScreenLockKeyboardUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_ScreenLockKeyboardUtilTest_should_return_number_288', TestConst.TEST_LEVEL, (): void => {
      let displayWidth: number = 1137.78;
      let deviceGridData: DevicesGrids = {
        index: DeviceClassification.PSD_NO_FINGER,
        psdMargin: 24,
        psdGutter: 8,
        psdColumn: 4,
      }
      let result: number = ScreenLockKeyboardUtil.inputTipWidthLayout(displayWidth, deviceGridData);
      expect(result).not().assertNull();
    })

    it('test_ScreenLockKeyboardUtilTest_should_return_number', TestConst.TEST_LEVEL, (): void => {
      let displayWidth: number = 1137.78;
      let deviceGridData: DevicesGrids = {
        index: DeviceClassification.PSD_PAD_LANDSCAPE,
        psdMargin: 12,
        psdGutter: 16,
        psdColumn: 12,
      }
      let inputTipWidth = ((displayWidth - (deviceGridData.psdColumn - KeyBoardLayoutConstants.GUTTER_COUNT) *
      deviceGridData.psdGutter - KeyBoardLayoutConstants.MARGIN_BOTH_SIDE_COUNT * deviceGridData.psdMargin) /
      deviceGridData.psdColumn) * KeyBoardLayoutConstants.INPUT_TIP_WIDTH_COUNT_COLUMNS +
        KeyBoardLayoutConstants.INPUT_TIP_WIDTH_COUNT_GUTTER * deviceGridData.psdGutter;
      let result: number = ScreenLockKeyboardUtil.inputTipWidthLayout(displayWidth, deviceGridData);
      expect(inputTipWidth.toFixed(0)).assertEqual(result.toFixed(0));
    })
    it('test_keyboardHeightCount_should_return_number', TestConst.TEST_LEVEL, (): void => {
      let displayHeight: number = 1137.78;
      let pageType: number = 1;
      let index: DeviceClassification = DeviceClassification.PSD_PAD_LANDSCAPE;
      ScreenLockKeyboardUtil.keyboardHeightCount(displayHeight,index,pageType);
      let result: number = displayHeight / KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_RATIO_LANDSCAPE;
      expect(result).assertEqual(1137.78/2);

      let displayHeight1: number = 1137.78;
      let pageType1: number = 1;
      let index1: DeviceClassification = DeviceClassification.PSD_PAD_PORTRAIT;
      ScreenLockKeyboardUtil.keyboardHeightCount(displayHeight1,index1,pageType1);
      let result1: number = displayHeight / KeyBoardLayoutConstants.PAD_KEYBOARD_HEIGHT_RATIO_PORTRAIT;
      expect(result1).assertEqual(1137.78/3);

      let displayHeight2: number = 1137.78;
      let pageType2: number = 2;
      let index2: DeviceClassification = DeviceClassification.PSD_PAD_LANDSCAPE;
      ScreenLockKeyboardUtil.keyboardHeightCount(displayHeight2,index2,pageType2);

      let displayHeight3: number = 1137.78;
      let pageType3: number = 2;
      let index3: DeviceClassification = DeviceClassification.PSD_PAD_PORTRAIT;
      ScreenLockKeyboardUtil.keyboardHeightCount(displayHeight3,index3,pageType3);
    })

    it('test_keyboardHeightCount1_should_return_number', TestConst.TEST_LEVEL, (): void => {
      let displayHeight: number = 1137.78;
      let pageType: number = KeyboardPageType.PSD_MIX;
      let index: DeviceClassification = DeviceClassification.PSD_FOLD_EXPAND;
      ScreenLockKeyboardUtil.keyboardHeightCount(displayHeight,index,pageType);
      let result: number = KeyBoardLayoutConstants.KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_NO_FINGER;
      expect(result).assertEqual(410);

      let displayHeight1: number = 1137.78;
      let pageType1: number = KeyboardPageType.PSD_MIX;
      let index1: DeviceClassification = DeviceClassification.PSD_LOW_FINGER_PRINT_PHONE;
      ScreenLockKeyboardUtil.keyboardHeightCount(displayHeight1,index1,pageType1);
      let result1: number = KeyBoardLayoutConstants.KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_LOW_FINGER;
      expect(result1).assertEqual(468);

      let displayHeight2: number = 1137.78;
      let pageType2: number = KeyboardPageType.PSD_MIX;
      let index2: DeviceClassification = DeviceClassification.PSD_HEIGHT_FINGER_PRINT_PHONE;
      ScreenLockKeyboardUtil.keyboardHeightCount(displayHeight2,index2,pageType2);
      let result2: number = KeyBoardLayoutConstants.KEYBOARD_MIX_MARGIN_BOTTOM_PHONE_HIGH_FINGER;
      expect(result2).assertEqual(432);
    })

    it('test_getGStateKeyboardWidthPercent_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let displayWidth: number = 1107.48;
      let isLandscape: boolean = true;
      let widthPercent: number = ScreenLockKeyboardUtil.getGStateKeyboardWidthPercent(displayWidth, isLandscape);
      expect(widthPercent > 0.34 && widthPercent < 0.35).assertTrue();
      displayWidth = 776.35;
      isLandscape = false;
      widthPercent = ScreenLockKeyboardUtil.getGStateKeyboardWidthPercent(displayWidth, isLandscape);
      expect(widthPercent > 0.51 && widthPercent < 0.52).assertTrue();
    })
  })
}