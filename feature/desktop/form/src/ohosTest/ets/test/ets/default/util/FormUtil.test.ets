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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import curves from '@ohos.curves';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { CommonConstants, FormCommonUtil } from '@ohos/launchercommon';
import { FormUtil } from '../../../../../../../src/main/ets/default/util/FormUtil';
import { FormStyleConfig } from '../../../../../../main/ets/default/common/FormStyleConfig';
import { FormViewModel } from '../../../../../../main/ets/default/viewmodel/FormViewModel';
import { FormCenterViewModel } from '../../../../../../main/ets/formcenter/viewmodel/FormCenterViewModel';

export function FormUtilTest() {
  describe('FormUtilTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getFormDisplayPXSize', 0, () => {
      try {
        expect(FormUtil.getFormDisplayPXSize(CommonConstants.CARD_DIMENSION_1x2, false)).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFormDisplaySize', 0, () => {
      try {
        expect(FormUtil.getFormDisplaySize(CommonConstants.CARD_DIMENSION_1x2, false)).not().assertEqual(0);
        expect(FormUtil.getFormDisplaySize(CommonConstants.CARD_DIMENSION_2x2, true)).not().assertEqual(0);
        expect(FormUtil.getFormDisplaySize(CommonConstants.CARD_DIMENSION_2x4, false)).not().assertEqual(0);
        expect(FormUtil.getFormDisplaySize(CommonConstants.CARD_DIMENSION_4x4, true)).not().assertEqual(0);
        expect(FormUtil.getFormDisplaySize(CommonConstants.CARD_DIMENSION_6x4, true)).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFormScaleOptions', 0, () => {
      expect(FormUtil.getFormScaleOptions(CommonConstants.CARD_DIMENSION_1x2).x).assertEqual(1.2);
      expect(FormUtil.getFormScaleOptions(CommonConstants.CARD_DIMENSION_2x2).x).assertEqual(1);
      expect(FormUtil.getFormScaleOptions(CommonConstants.CARD_DIMENSION_2x4).x).assertEqual(0.8);
      expect(FormUtil.getFormScaleOptions(CommonConstants.CARD_DIMENSION_4x4).x).assertEqual(0.75);
      expect(FormUtil.getFormScaleOptions(CommonConstants.CARD_DIMENSION_6x4).x).assertEqual(0.55);
    });

    it('getPressAnimateScale', 0, () => {
      expect(FormUtil.getPressAnimateScale(CommonConstants.CARD_DIMENSION_1x2)).assertEqual(0.9);
      expect(FormUtil.getPressAnimateScale(CommonConstants.CARD_DIMENSION_2x2)).assertEqual(0.95);
      expect(FormUtil.getPressAnimateScale(CommonConstants.CARD_DIMENSION_2x4)).assertEqual(0.95);
      expect(FormUtil.getPressAnimateScale(CommonConstants.CARD_DIMENSION_4x4)).assertEqual(0.95);
    });

    it('getWant', 0, () => {
      const mocker: MockKit = new MockKit();
      try {
        expect(FormUtil.getWant(true).parameters).not().assertNull();
        const mockFuncGetCommonWant: Function = mocker.mockFunc(FormCommonUtil, FormCommonUtil.getCommonWant);
        let want: Want = {};
        when(mockFuncGetCommonWant)(ArgumentMatchers.any).afterReturn(want);
        expect(FormUtil.getWant(true).parameters).not().assertNull();
        mocker.clear(FormCommonUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getFormManagerScale', 0, () => {
      const mocker: MockKit = new MockKit();
      try {
        const mockFuncIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        const mockFunkGetCommonWant: Function = mocker.mockFunc(FormCommonUtil, FormCommonUtil.getCommonWant);
        let want: Want = {};
        when(mockFunkGetCommonWant)(ArgumentMatchers.any).afterReturn(want);
        expect(FormUtil.getWant(true).parameters).not().assertNull();

        when(mockFuncIsPhone)(ArgumentMatchers.any).afterReturn(false);
        expect(FormUtil.getFormManagerScale(CommonConstants.CARD_DIMENSION_1x2)).assertEqual(1);

        when(mockFuncIsPhone)(ArgumentMatchers.any).afterReturn(true);
        expect(FormUtil.getFormManagerScale(CommonConstants.CARD_DIMENSION_1x2)).assertEqual(1.2);
        expect(FormUtil.getFormManagerScale(CommonConstants.CARD_DIMENSION_2x4)).assertEqual(0.8);
        expect(FormUtil.getFormManagerScale(CommonConstants.CARD_DIMENSION_4x4)).assertEqual(0.75);
        expect(FormUtil.getFormManagerScale(CommonConstants.CARD_DIMENSION_6x4)).assertEqual(0.55);
        mocker.clear(DeviceHelper);
        mocker.clear(FormCommonUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getPressAnimateCurve', 0, () => {
      let testCurve: curves.ICurve = curves.interpolatingSpring(1, 1, 410, 38);
      let curve: curves.ICurve = FormUtil.getPressAnimateCurve(FormDimension.Dimension_1_2);
      expect(curve.interpolate(10)).assertEqual(testCurve.interpolate(10));

      testCurve = curves.interpolatingSpring(0.5, 1, 350, 35);
      curve = FormUtil.getPressAnimateCurve(FormDimension.Dimension_2_2);
      expect(curve.interpolate(10)).assertEqual(testCurve.interpolate(10));

      testCurve = curves.interpolatingSpring(0, 1, 240, 28);
      curve = FormUtil.getPressAnimateCurve(FormDimension.Dimension_4_4);
      expect(curve.interpolate(10)).assertEqual(testCurve.interpolate(10));
    });

    it('getManagerFormRadius', 0, () => {
      const mocker: MockKit = new MockKit();
      try {
        const desktopFormRadius: number = 16;
        const defaultRadius: number = 24;
        const styleConfig: FormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
        const mockFunc: Function = mocker.mockFunc(styleConfig, styleConfig.getFormBorderRadius);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(defaultRadius);

        let formBorderRadius: number = FormUtil.getManagerFormRadius(CommonConstants.CARD_DIMENSION_2x2);
        expect(formBorderRadius).assertEqual(defaultRadius);

        when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
        formBorderRadius = FormUtil.getManagerFormRadius(CommonConstants.CARD_DIMENSION_2x4);
        expect(formBorderRadius).assertEqual(desktopFormRadius);
        mocker.clear(styleConfig);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getAnimateScale', 0, () => {
      let scale: number = 0;

      scale = FormUtil.getAnimateScale(CommonConstants.CARD_DIMENSION_1x2);
      expect(scale).assertEqual(1.2);
      scale = FormUtil.getAnimateScale(CommonConstants.CARD_DIMENSION_2x2);
      expect(scale).assertEqual(1);
      scale = FormUtil.getAnimateScale(CommonConstants.CARD_DIMENSION_2x4);
      expect(scale).assertEqual(0.8);
      scale = FormUtil.getAnimateScale(CommonConstants.CARD_DIMENSION_4x4);
      expect(scale).assertEqual(0.75);
      scale = FormUtil.getAnimateScale(CommonConstants.CARD_DIMENSION_6x4);
      expect(scale).assertEqual(0.55);
      AppStorage.setOrCreate('dragItemType', CommonConstants.DRAG_FROM_FORM_INTELLIGENT);
      scale = FormUtil.getAnimateScale(CommonConstants.CARD_DIMENSION_2x4);
      expect(scale).assertEqual(1);
    });

    it('getFormServiceScale', 0, () => {
      let scale: number = 1.1;
      FormUtil.setFormServiceScale(scale);
      expect(FormUtil.getFormServiceScale()).assertEqual(scale);
    });

    it('getGridWidth', 0, () => {
      FormCenterViewModel.getInstance().customGridWidth = 100;
      expect(FormUtil.getGridWidth() === 100).assertTrue();
      FormCenterViewModel.getInstance().customGridWidth = -1;
      expect(FormUtil.getGridWidth() === -1).assertFalse();
    });
  })
}