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
import { describe, it, expect, beforeEach, MockKit, ArgumentMatchers, when, afterEach } from '@ohos/hypium';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { NotificationAnimationParas } from '../../../../main/ets/common/NotificationAnimationParas';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { RTLUtil } from '@ohos/componenthelper';
import { fontScaleManager } from '@ohos/systemuiutils';
import { ResUtils } from '@ohos/windowscene';
import { LogHelper } from '@ohos/basicutils';

export default function NotificationUtilsTest() {
  describe('getNtfItemTransX', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_0_when_ntfItemTranslateX_is_invalid', 0, () => {

      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemTranslateX = 0;
      const result = NotificationUtils.getNtfItemTransX(ntfAniParameters);
      expect(result).assertEqual(0);
    });

    it('should_return_ntfItemTranslateX_when_clearAnimTransX_is_valid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemTranslateX = 10;
      const result = NotificationUtils.getNtfItemTransX(ntfAniParameters);
      expect(result).assertEqual(10);
    });
  });

  describe('getNtfItemTransY', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should return 0 when ntfItemTranslateY is invalid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemTranslateY = 0;

      const result = NotificationUtils.getNtfItemTransY(ntfAniParameters);
      expect(result).assertEqual(0);
    });

    it('should return ntfItemTranslateY when it is valid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemTranslateY = 20;
      const result = NotificationUtils.getNtfItemTransY(ntfAniParameters);
      expect(result).assertEqual(20);
    });
  });

  describe('getNtfItemOpacity', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should return 1 when clearAnimOpacity is invalid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.clearAnimOpacity = 1;
      const result = NotificationUtils.getNtfItemOpacity(ntfAniParameters);
      expect(result).assertEqual(1);
    });

    it('should return clearAnimOpacity when it is valid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.clearAnimOpacity = 0.5;
      const result = NotificationUtils.getNtfItemOpacity(ntfAniParameters);
      expect(result).assertEqual(0.5);
    });
  });

  describe('getNtfItemScale', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should return 1 when clearAnimScale is invalid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.clearAnimScale = 1;
      const result = NotificationUtils.getNtfItemScale(ntfAniParameters);
      expect(result).assertEqual(1);
    });

    it('should return clearAnimScale when it is valid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.clearAnimScale = 0.8;
      const result = NotificationUtils.getNtfItemScale(ntfAniParameters);
      expect(result).assertEqual(0.8);
    });
  });

  describe('getNtfItemRotateAngle', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should return 0 when ntfItemRotateAngels is invalid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemRotateAngels = 0;
      const result = NotificationUtils.getNtfItemRotateAngle(ntfAniParameters);
      expect(result).assertEqual(0);
    });

    it('should return ntfItemRotateAngels when it is valid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemRotateAngels = 45;
      const result = NotificationUtils.getNtfItemRotateAngle(ntfAniParameters);
      expect(result).assertEqual(45);
    });
  });

  describe('getNtfItemRotateCenterY', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should return "50%" when ntfItemRotateCenterY is invalid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemRotateCenterY = 0;
      const result = NotificationUtils.getNtfItemRotateCenterY(ntfAniParameters);
      expect(result).assertEqual(0);
    });

    it('should return ntfItemRotateCenterY when it is valid', 0, () => {
      let ntfAniParameters: NotificationAnimationParas = new NotificationAnimationParas(
        0, // transX
        0, // transY
        1, // opacity
        1, // scale
        0  // rotate
      );
      ntfAniParameters.ntfItemRotateCenterY = '60%';
      const result = NotificationUtils.getNtfItemRotateCenterY(ntfAniParameters);
      expect(result).assertEqual('60%');
    });
  });

  describe('getNtfTimeStampByBoard', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_empty_string_when_isKeyGuard_is_true', 0, () => {
      let isKeyGuard: boolean = true;
      const result = NotificationUtils.getNtfTimeStampByBoard(isKeyGuard);
      expect(result).assertEqual('');
    });

    it('should_return_last_dropdown_time_when_isKeyGuard_is_false', 0, () => {
      let isKeyGuard: boolean = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.getLastDropdownTime);
      let lastDropdownTime: number = 1633072800000;
      when(mockfunc)().afterReturn(lastDropdownTime);
      const result = NotificationUtils.getNtfTimeStampByBoard(isKeyGuard);
      expect(result).assertEqual('1633072800000');
      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.getLastDropdownTime);
    });
  });

  describe('getNtfTimeStampByType', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should return empty string when ntfType is keyguard', 0, () => {
      expect(NotificationUtils.getNtfTimeStampByType(3)).assertEqual('');
    });

    it('should return last dropdown time when ntfType is not keyguard', 0, () => {
      DropDownPanelManager.lastDropDownTime = 12345;
      expect(NotificationUtils.getNtfTimeStampByType(1)).assertEqual('12345');
    });
  });

  describe('getRTLValue', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_negative_value_when_isRTL_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(RTLUtil, RTLUtil.isRTL))(ArgumentMatchers.any).afterReturn(true);
      const result = NotificationUtils.getRTLValue(10);
      expect(result).assertEqual(-10);
    });

    it('should_return_positive_value_when_isRTL_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(RTLUtil, RTLUtil.isRTL))(ArgumentMatchers.any).afterReturn(false);
      const result = NotificationUtils.getRTLValue(10);
      expect(result).assertEqual(10);
    });
  });

  describe('getActionBtnHeight', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_height_when_isShowDropBar_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockGetSysFontScaleState: Function = mocker.mockFunc(fontScaleManager, fontScaleManager.getSysFontScaleState);
      let mockFontScaleState: FontScaleState = new FontScaleState();
      when(mockGetSysFontScaleState)([]).afterReturn(mockFontScaleState);

      let mockGetFontScale: Function = mocker.mockFunc(mockFontScaleState, mockFontScaleState.getFontScale);
      when(mockGetFontScale)([ArgumentMatchers.anyBoolean]).afterReturn(1.0);

      let mockGetNumber: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockGetNumber)([ArgumentMatchers.any]).afterReturn(10.0);

      let result = NotificationUtils.getActionBtnHeight(false);
      expect(result).assertEqual(10.0 * 1.0 + 2 * 10.0);

      mocker.ignoreMock(fontScaleManager, fontScaleManager.getSysFontScaleState);
      mocker.ignoreMock(mockFontScaleState, mockFontScaleState.getFontScale);
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });

    it('should_return_correct_height_when_isShowDropBar_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockGetSysFontScaleState: Function = mocker.mockFunc(fontScaleManager, fontScaleManager.getSysFontScaleState);
      let mockFontScaleState: FontScaleState = new FontScaleState();
      when(mockGetSysFontScaleState)([]).afterReturn(mockFontScaleState);

      let mockGetFontScale: Function = mocker.mockFunc(mockFontScaleState, mockFontScaleState.getFontScale);
      when(mockGetFontScale)([ArgumentMatchers.anyBoolean]).afterReturn(1.0);

      let mockGetNumber: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockGetNumber)([ArgumentMatchers.any]).afterReturn(10.0);

      let result = NotificationUtils.getActionBtnHeight(true);
      expect(result).assertEqual(10.0 * 1.0 + 2 * 10.0 + 10.0);

      mocker.ignoreMock(fontScaleManager, fontScaleManager.getSysFontScaleState);
      mocker.ignoreMock(mockFontScaleState, mockFontScaleState.getFontScale);
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });
  });
}
