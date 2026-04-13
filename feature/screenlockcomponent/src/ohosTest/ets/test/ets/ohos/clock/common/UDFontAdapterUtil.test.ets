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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { UDFontAdapterUtil, UDSelectEnum } from '@ohos/screenlockwidget/src/main/ets/clock/common/UDFontAdapterUtil'
import { ClockConstants } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockConstants';
import { ClockComFamily, ClockLayout } from '@ohos/screenlockwidget';

const HARMONY_CLOCK_ULT_LAYOUT1: string = 'HarmonyClock_ult_layout_1';
const HARMONY_CLOCK_ULT_LAYOUT_2_4: string = 'HarmonyClock_ult_layout_2_4';
const DESKTOP_CLOCK_FONT_SIZE_4UD: number = 50;
const DESKTOP_CLOCK_FONT_TOP_PADDING: number = 20;

export default function UDFontAdapterUtilTest() {
  describe('UDFontAdapterUtilTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('UDFontAdapterUtilTest_getRealFontFamily', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      when(mockFunc)().afterReturn(false);
      let res = UDFontAdapterUtil.getRealFontFamily('111');
      expect(res).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
    })

    it('UDFontAdapterUtilTest_getRealFontFamily_02', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      when(mockFunc)().afterReturn(true);
      let res = UDFontAdapterUtil.getRealFontFamily('111');
      expect(res).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
    })

    it('UDFontAdapterUtilTest_getRealFontFamily_03', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      when(mockFunc)().afterReturn(true);
      let res = UDFontAdapterUtil.getRealFontFamily(HARMONY_CLOCK_ULT_LAYOUT_2_4);
      expect(res).assertEqual(HARMONY_CLOCK_ULT_LAYOUT1);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
    })

    it('UDFontAdapterUtilTest_setSceneSelected', 0, () => {
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.DEFAULT);
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.LAYOUT_FONT);
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.FONT);
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.LAYOUT);
      expect(UDFontAdapterUtil).not().assertNull();
    })

    it('UDFontAdapterUtilTest_handleFontChange', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
      when(mockFunc)('111').afterReturn(true);
      UDFontAdapterUtil.handleFontChange('111');
      expect(UDFontAdapterUtil).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
    })

    it('UDFontAdapterUtilTest_handleFontChange_02', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
      when(mockFunc)('111').afterReturn(false);
      UDFontAdapterUtil.handleFontChange('111');
      expect(UDFontAdapterUtil).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
    })

    it('UDFontAdapterUtilTest_getDefaultFont4UD', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      when(mockFunc)().afterReturn(false);
      let res = UDFontAdapterUtil.getDefaultFont4UD(ClockLayout.DEFAULT_CLOCK_LAYOUT,'111');
      expect(res).assertEqual('111');
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
    })

    it('UDFontAdapterUtilTest_getDefaultFont4UD_02', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      when(mockFunc)().afterReturn(true);
      (UDFontAdapterUtil as object)['isInit'] = false;
      let res = UDFontAdapterUtil.getDefaultFont4UD(ClockLayout.DEFAULT_CLOCK_LAYOUT, HARMONY_CLOCK_ULT_LAYOUT1);
      expect(res).assertEqual(HARMONY_CLOCK_ULT_LAYOUT1);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
    })

    it('UDFontAdapterUtilTest_getDefaultFont4UD_03', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      when(mockFunc)().afterReturn(true);
      (UDFontAdapterUtil as object)['isInit'] = false;
      let res = UDFontAdapterUtil.getDefaultFont4UD(ClockLayout.DEFAULT_CLOCK_LAYOUT, ClockComFamily.HARMONY_CLOCK_01);
      expect(res).assertEqual(HARMONY_CLOCK_ULT_LAYOUT1);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
    })

    it('UDFontAdapterUtilTest_getDefaultFont4UD_04', 0, () => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      when(mockFunc)().afterReturn(true);
      (UDFontAdapterUtil as object)['isInit'] = true;
      let res = UDFontAdapterUtil.getDefaultFont4UD(ClockLayout.DEFAULT_CLOCK_LAYOUT, '111');
      expect(res).assertEqual('111');
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
    })

    it('UDFontAdapterUtilTest_getDefaultFont4UD_05', 0, () => {
      UDFontAdapterUtil.isUD();
      UDFontAdapterUtil.getDefaultFont4UD(ClockLayout.DIMENSION_4_4, ClockComFamily.HARMONY_CLOCK_01);
      UDFontAdapterUtil.getDefaultFont4UD(ClockLayout.DIMENSION_2_4,'test');
      UDFontAdapterUtil.removeSceneSelected(UDSelectEnum.DEFAULT);
      expect(UDFontAdapterUtil).not().assertNull();
    })

    it('UDFontAdapterUtilTest_getDesktopClockFontSize', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      let mockFunc_02 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
      when(mockFunc_01)().afterReturn(false);
      when(mockFunc_02)().afterReturn(true);
      let res = UDFontAdapterUtil.getDesktopClockFontSize(15);
      expect(res).assertEqual(15);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
    })

    it('UDFontAdapterUtilTest_getDesktopClockFontSize_02', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      let mockFunc_02 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
      when(mockFunc_01)().afterReturn(true);
      when(mockFunc_02)().afterReturn(true);
      let res = UDFontAdapterUtil.getDesktopClockFontSize(15);
      expect(res).assertEqual(DESKTOP_CLOCK_FONT_SIZE_4UD);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
    })

    it('UDFontAdapterUtilTest_getDesktopClockFontSize_03', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      let mockFunc_02 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
      when(mockFunc_01)().afterReturn(true);
      when(mockFunc_02)().afterReturn(false);
      let res = UDFontAdapterUtil.getDesktopClockFontSize(15);
      expect(res).assertEqual(15);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
    })

    it('UDFontAdapterUtilTest_getDesktopClockFontSize_04', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      let mockFunc_02 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
      when(mockFunc_01)().afterReturn(false);
      when(mockFunc_02)().afterReturn(false);
      let res = UDFontAdapterUtil.getDesktopClockFontSize(15);
      expect(res).assertEqual(15);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDLayout);
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
    })

    it('UDFontAdapterUtilTest_getDesktopClockFontTopPadding', 0, () => {
      let res = UDFontAdapterUtil.getDesktopClockFontTopPadding(ClockComFamily.HARMONY_CLOCK_ULT_01);
      expect(res).assertEqual(DESKTOP_CLOCK_FONT_TOP_PADDING);
      let res2 = UDFontAdapterUtil.getDesktopClockFontTopPadding('test');
      expect(res2).assertEqual(0);
    })

    it('UDFontAdapterUtilTest_handleLayoutChange', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      when(mockFunc_01)().afterReturn(true);
      UDFontAdapterUtil.handleLayoutChange(ClockLayout.DIMENSION_3_6);
      expect(UDFontAdapterUtil).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
    })

    it('UDFontAdapterUtilTest_handleLayoutChange_02', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      when(mockFunc_01)().afterReturn(false);
      UDFontAdapterUtil.handleLayoutChange(ClockLayout.DEFAULT_CLOCK_LAYOUT);
      expect(UDFontAdapterUtil).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
    })

    it('UDFontAdapterUtilTest_handleLayoutChange_03', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      when(mockFunc_01)().afterReturn(true);
      UDFontAdapterUtil.handleLayoutChange(ClockLayout.DEFAULT_CLOCK_LAYOUT);
      expect(UDFontAdapterUtil).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
    })

    it('UDFontAdapterUtilTest_isSupportByLayout', 0, () => {
      let res1 = UDFontAdapterUtil.isSupportByLayout(ClockLayout.DEFAULT_CLOCK_LAYOUT);
      expect(res1).assertTrue();
      let res2 = UDFontAdapterUtil.isSupportByLayout(ClockLayout.NORMAL_CLOCK_LAYOUT);
      expect(res2).assertTrue();
      let res3 = UDFontAdapterUtil.isSupportByLayout(ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT);
      expect(res3).assertTrue();
      let res4 = UDFontAdapterUtil.isSupportByLayout(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL);
      expect(res4).assertTrue();
      let res5 = UDFontAdapterUtil.isSupportByLayout(ClockLayout.DIMENSION_4_4);
      expect(res5).assertFalse();
    })

    it('UDFontAdapterUtilTest_isSupportByFont', 0, () => {
      let res1 = UDFontAdapterUtil.isSupportByFont(HARMONY_CLOCK_ULT_LAYOUT1);
      expect(res1).assertTrue();
      let res2 = UDFontAdapterUtil.isSupportByFont(HARMONY_CLOCK_ULT_LAYOUT_2_4);
      expect(res2).assertTrue();
      let res3 = UDFontAdapterUtil.isSupportByFont('testFont');
      expect(res3).assertFalse();
    })

    it('UDFontAdapterUtilTest_transferLayout4UD', 0, () => {
      let mocker = new MockKit();
      let mockFunc_01 = mocker.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
      when(mockFunc_01)().afterReturn(true);
      UDFontAdapterUtil.transferLayout4UD(ClockLayout.DEFAULT_CLOCK_LAYOUT);
      when(mockFunc_01)().afterReturn(false);
      UDFontAdapterUtil.transferLayout4UD(ClockLayout.DEFAULT_CLOCK_LAYOUT);
      expect(UDFontAdapterUtil).not().assertNull();
      mocker.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUDFont);
    })
  })
}