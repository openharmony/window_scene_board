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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { RtlCalculateUtils } from '../../../../../../main/ets/utils/RtlCalculateUtils';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import FormPlaceHolderInfo from '@ohos/screenlockwidget/src/main/ets/form/drag/FormPlaceHolderInfo';
import { ClockLayout, LockscreenFormConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { DeviceHelper } from '@ohos/frameworkwrapper';


export default function RtlCalculateUtilsTest() {

  describe('RtlCalculateUtilsTest', (): void => {

    let mocker: MockKit = new MockKit();
    let clockStyle:AnyClock = new AnyClock();
    let card: LockscreenFormConfig = new LockscreenFormConfig();
    let holderInfo: FormPlaceHolderInfo = {
      positionX: 0,
      positionY: 0,
      dimensionX: 0,
    }
    beforeAll((): void => {

    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it("test_getScreenLockPanelPositionX", TestConst.TEST_LEVEL, (): void => {
      clockStyle.x = 0;
      clockStyle.layout = ClockLayout.DIMENSION_4_4;
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunc)().afterReturn(false);
      const mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc2)().afterReturn(false);
      let position: number = RtlCalculateUtils.getScreenLockPanelPositionX(false, false, clockStyle);
      expect(position === 1).assertEqual(true);
    })

    it("test_getScreenLockPanelPositionX_isN4", TestConst.TEST_LEVEL, (): void => {
      clockStyle.x = 0;
      clockStyle.layout = ClockLayout.DIMENSION_2_4;
      const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunc)().afterReturn(false);
      const mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc2)().afterReturn(false);
      let position: number = RtlCalculateUtils.getScreenLockPanelPositionX(false, false, clockStyle);
      expect(position === 2).assertEqual(false);
    })

    it("test_getFoldRealPositionForMargin", TestConst.TEST_LEVEL, (): void => {
      let position: number = RtlCalculateUtils.getFoldRealPositionForMargin(false, false, 0);
      expect(position === 2).assertEqual(true);
    })

    it("test_getFoldRealPositionForMargin_unfold", TestConst.TEST_LEVEL, (): void => {
      let position: number = RtlCalculateUtils.getFoldRealPositionForMargin(true, false, 0);
      expect(position === 0).assertEqual(true);
    })

    it("test_getFoldRealPositionForMargin_expand", TestConst.TEST_LEVEL, (): void => {
      let position: number = RtlCalculateUtils.getFoldRealPositionForMargin(true, true, 0);
      expect(position === 4).assertEqual(true);
    })

    it("test_getPadRealPositionXForMargin", TestConst.TEST_LEVEL, (): void => {
      let position: number = RtlCalculateUtils.getPadRealPositionXForMargin(false, true, 0);
      expect(position === 4).assertEqual(true);
    })

    it("test_getPadRealPositionXForMargin_notN4", TestConst.TEST_LEVEL, (): void => {
      let position: number = RtlCalculateUtils.getPadRealPositionXForMargin(true, false, 0);
      expect(position === 6).assertEqual(true);
    })

    it("test_getPadRealPositionXForMargin_isN4", TestConst.TEST_LEVEL, (): void => {
      let position: number = RtlCalculateUtils.getPadRealPositionXForMargin(true, true, 0);
      expect(position === 2).assertEqual(true);
    })

    it("test_getEndFormPositionX_notN4", TestConst.TEST_LEVEL, (): void => {
      card.dimensionX = 1;
      card.positionX = 1;
      let position: number = RtlCalculateUtils.getEndFormPositionX(card, 10, false);
      expect(position === 25).assertEqual(true);
    })

    it("test_getEndFormPositionX_isN4", TestConst.TEST_LEVEL, (): void => {
      card.dimensionX = 1;
      card.positionX = 0;
      let position: number = RtlCalculateUtils.getEndFormPositionX(card, 10, true);
      expect(position === 35).assertEqual(true);
    })

    it("test_getFormBorderMargin_isN4", TestConst.TEST_LEVEL, (): void => {

      let position: number = RtlCalculateUtils.getFormBorderMargin(holderInfo, true, 10);
      expect(position === 36).assertEqual(true);
    })

    it("test_getFormBorderMargin_isN4_two", TestConst.TEST_LEVEL, (): void => {
      holderInfo.dimensionX = 2;
      let position: number = RtlCalculateUtils.getFormBorderMargin(holderInfo, true, 10);
      expect(position === 26).assertEqual(true);
    })

    it("test_getFormBorderMargin_notN4_two", TestConst.TEST_LEVEL, (): void => {
      holderInfo.dimensionX = 2;
      holderInfo.positionX = 1;
      let position: number = RtlCalculateUtils.getFormBorderMargin(holderInfo, false, 10);
      expect(position === 16).assertEqual(true);
    })

  })
}