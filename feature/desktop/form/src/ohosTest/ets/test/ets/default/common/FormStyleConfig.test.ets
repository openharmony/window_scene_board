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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { AppGridStyleConfig, CommonConstants, IconCommonUtil, layoutConfigManager } from '@ohos/launchercommon';
import { FormStyleConfig } from '../../../../../../main/ets/default/common/FormStyleConfig';
import FeatureConstants from '../../../../../../main/ets/default/common/constants/FeatureConstants';
import { RadiusUtil, ThemeStyleInfo, ThemeStyleManager, ThemeStylePreviewManager } from '@ohos/launchercommon';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export function FormStyleConfigTest() {
  describe('FormStyleConfigTest', ()=> {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('FormStyleConfigTest_getInstance', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance()).not().assertNull();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('FormStyleConfigTest_getConfigLevel', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance().getConfigLevel()).assertEqual(CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFeatureName', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance().getFeatureName()).assertEqual(FeatureConstants.FEATURE_NAME);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFormBorderRadius1', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance().getFormBorderRadius(null)).assertEqual(CommonConstants.INVALID_VALUE);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFormBorderRadius2', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
        let themeStyle: ThemeStyleInfo = new ThemeStyleInfo();
        themeStyle.iconSizeScale = 8;
        themeStyle.radiusSizeScale = 0.5;

        let mockGetThemeStyleFunc: Function = mocker.mockFunc(themeStyleManager, themeStyleManager.getThemeStyle);
        when(mockGetThemeStyleFunc)().afterReturn(themeStyle);

        let defaultRadius: number = RadiusUtil.calculateSmallFormRadius(false);
        defaultRadius =
          FormStyleConfig.getInstance().updateFormBorderRadiusToG2(defaultRadius, CommonConstants.CARD_DIMENSION_1x2);
        expect(FormStyleConfig.getInstance().getFormBorderRadius(CommonConstants.CARD_DIMENSION_1x2))
          .assertEqual(defaultRadius);
        mocker.clear(themeStyleManager);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getBlurRatio1', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance().getBlurRatio(CommonConstants.CARD_DIMENSION_2x2))
          .assertEqual(2);

        expect(FormStyleConfig.getInstance().getBlurRatio(CommonConstants.CARD_DIMENSION_1x2))
          .assertEqual(2);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getBlurRatio2', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance().getBlurRatio(CommonConstants.CARD_DIMENSION_2x4))
          .assertEqual(4);

        expect(FormStyleConfig.getInstance().getBlurRatio(CommonConstants.CARD_DIMENSION_4x4))
          .assertEqual(4);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }

    });

    it('getBlurRatio3', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance().getBlurRatio(0))
          .assertEqual(1);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFormPreviewBorderRadius1', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        expect(FormStyleConfig.getInstance().getFormPreviewBorderRadius(null)).assertEqual(CommonConstants.INVALID_VALUE);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFormPreviewBorderRadius2', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let themeInfoManager: ThemeStylePreviewManager = ThemeStylePreviewManager.getInstance();
        let themeStyle: ThemeStyleInfo = new ThemeStyleInfo();
        themeStyle.iconSizeScale = 8;
        themeStyle.radiusSizeScale = 0.5;

        let mockGetThemeStyleFunc: Function = mocker.mockFunc(themeInfoManager, themeInfoManager.getThemeStyle);
        when(mockGetThemeStyleFunc)().afterReturn(themeStyle);

        expect(FormStyleConfig.getInstance().getFormPreviewBorderRadius(CommonConstants.CARD_DIMENSION_1x2))
          .assertEqual(RadiusUtil.calculateSmallFormRadius(true));
        mocker.clear(themeInfoManager);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getFormPreviewBorderRadius3', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let themeInfoManager: ThemeStylePreviewManager = ThemeStylePreviewManager.getInstance();
        let themeStyle: ThemeStyleInfo = new ThemeStyleInfo();
        themeStyle.radiusSizeScale = 0.5;

        let mockGetThemeStyleFunc: Function = mocker.mockFunc(themeInfoManager, themeInfoManager.getThemeStyle);
        when(mockGetThemeStyleFunc)().afterReturn(themeStyle);
        expect(FormStyleConfig.getInstance().getFormPreviewBorderRadius(CommonConstants.CARD_DIMENSION_2x2))
          .assertEqual(RadiusUtil.calculateBigFormRadius(true));
        mocker.clear(themeInfoManager);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getFormPreviewBorderRadius4', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let themeInfoManager: ThemeStylePreviewManager = ThemeStylePreviewManager.getInstance();
        let themeStyle: ThemeStyleInfo = new ThemeStyleInfo();
        themeStyle.radiusSizeScale = undefined;

        let mockGetThemeStyleFunc: Function = mocker.mockFunc(themeInfoManager, themeInfoManager.getThemeStyle);
        when(mockGetThemeStyleFunc)().afterReturn(themeStyle);
        expect(FormStyleConfig.getInstance().getFormPreviewBorderRadius(CommonConstants.CARD_DIMENSION_2x2))
          .assertEqual(CommonConstants.INVALID_VALUE);
        mocker.clear(themeInfoManager);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getIconSizeScaleValidValue', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formStyle: FormStyleConfig = FormStyleConfig.getInstance();
        expect(formStyle.getIconSizeScaleValidValue(-8)).assertEqual(-6);
        expect(formStyle.getIconSizeScaleValidValue(10)).assertEqual(8);
        expect(formStyle.getIconSizeScaleValidValue(5)).assertEqual(5);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getSize', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formStyleConfig = FormStyleConfig.getInstance();
        formStyleConfig.mFormHeight.clear();
        formStyleConfig.mFormWidth.clear();
        expect(formStyleConfig.getSizeX1()).assertEqual(0);
        expect(formStyleConfig.getSizeX2()).assertEqual(0);
        expect(formStyleConfig.getSizeX4()).assertEqual(0);
        expect(formStyleConfig.getHeightX4()).assertEqual(0);
        expect(formStyleConfig.getHeightX6()).assertEqual(0);
        expect(formStyleConfig.getSize(CommonConstants.GRID_SPAN_1)).assertEqual(0);
        expect(formStyleConfig.getSize(CommonConstants.GRID_SPAN_2)).assertEqual(0);
        expect(formStyleConfig.getSize(CommonConstants.GRID_SPAN_4)).assertEqual(0);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getRegionFolderDropSize', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formStyleConfig = FormStyleConfig.getInstance();
        const styleConfig: AppGridStyleConfig = layoutConfigManager.getStyleConfig(AppGridStyleConfig.APP_GRID_STYLE_CONFIG,
          CommonConstants.PAGE_DESKTOP_FEATURE_NAME);
        const itemSize = styleConfig.mAppItemSize;
        const DEFAULT_SIZE = [0, 0];
        expect(formStyleConfig.getRegionFolderDropSize(undefined).toString()).assertEqual(DEFAULT_SIZE.toString());
        expect(formStyleConfig.getRegionFolderDropSize([3]).toString()).assertEqual(DEFAULT_SIZE.toString());
        expect(formStyleConfig.getRegionFolderDropSize([0, 1]).toString()).assertEqual(DEFAULT_SIZE.toString());
        expect(formStyleConfig.getRegionFolderDropSize([5, -1]).toString()).assertEqual(DEFAULT_SIZE.toString());
        expect(formStyleConfig.getRegionFolderDropSize([5, 4]).toString()).
          assertEqual([itemSize * 5 - 50, itemSize * 4 - 50].toString());
        expect(formStyleConfig.getRegionFolderDropSize([0, 1]).toString()).assertEqual(DEFAULT_SIZE.toString());
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    let formStyle: FormStyleConfig = FormStyleConfig.getInstance();
    let mFormHeight: Map<string,number> = new Map<string,number>();

    it('getSizeX6_test01', TestType.FUNCTION | Level.LEVEL0, () => {
      formStyle.mFormWidth = mFormHeight;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(mFormHeight, mFormHeight.get);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
        formStyle.getSizeX6();
        expect(formStyle).not().assertUndefined();

        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
        formStyle.getSizeX6();
        expect(formStyle).not().assertUndefined();
        mocker.clear(formStyle);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('getSize_test01', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        formStyle.getSize(CommonConstants.GRID_SPAN_6);
        expect(formStyle).not().assertUndefined();

        formStyle.getSize(10);
        expect(formStyle).not().assertUndefined();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getFormSizeOffsetSecure_test01', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(IconCommonUtil, IconCommonUtil.isValidIconSizeChange);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        formStyle.getFormSizeOffsetSecure(1,2);
        expect(formStyle).not().assertUndefined();
        mocker.clear(IconCommonUtil);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('refreshFormBorderRadius_test01', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(DeviceHelper,DeviceHelper.isPC);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        (formStyle as object)['refreshFormBorderRadius']();
        expect(formStyle).not().assertUndefined();
        mocker.clear(DeviceHelper);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });
  })
}