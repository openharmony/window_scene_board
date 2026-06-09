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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { LayoutViewModel } from '@ohos/launchercommon';
import { SingleContext } from '@ohos/basicutils';
import {
  RadiusUtil,
  ThemeStyleInfo,
  ThemeStyleManager,
  ThemeStylePreviewManager
} from '@ohos/launchercommon';
import StyleConstants from '../../../../../../../pcbase/src/main/ets/common/constants/StyleConstants';
import PcPageDesktopGridStyleConfig from '../../../../../../../pcbase/src/main/ets/common/PcPageDesktopGridStyleConfig';

export default function PcPageDesktopGridStyleConfigTest() {
  describe('PcPageDesktopGridStyleConfigTest', () => {
    let mocker: MockKit;
    let pcPageDesktopGridStyleConfig: PcPageDesktopGridStyleConfig;
    beforeAll(() => {
    })
    beforeEach(() => {
      mocker = new MockKit();
      pcPageDesktopGridStyleConfig = new PcPageDesktopGridStyleConfig();
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })

    it('initConfigTest', 0, () => {
      let singleContext: SingleContext = {
        isPhoneOuter: false,
        extendScreenId: 1
      }
      let result = new LayoutViewModel(singleContext).calculateDesktop();
      Object.keys(result).forEach(key => {
        result[key] = 1;
      });

      pcPageDesktopGridStyleConfig.initConfig();
      expect(pcPageDesktopGridStyleConfig.mGridSwiperMarginBottom).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mWorkSpaceMarginTop).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mMargin).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mItemPadding).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mColumnsGap).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mRowsGap).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mColumns).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mRows).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mDesktopMarginTop).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mGridWidth).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mWorkSpaceWidth).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mWorkSpaceHeight).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mWorkSpacePaddingTop).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mWorkSpacePaddingBottom).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mGridHeight).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mAppItemSize).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mNameSize).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mNameHeight).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mNameWidth).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mIconNameMargin).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mIconNameMarginTop).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mIconSize).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mNameLines).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mIconMarginHorizontal).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mIconMarginVertical).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mFoldCreaseRegionHeight).assertEqual(10);
      expect(pcPageDesktopGridStyleConfig.mPhysicalAxisAreaHeight).assertEqual(10);
    })

    it('updateIconSizeTest', 0, () => {
      let themeStyleInfo: ThemeStyleInfo = {
        isShowName:true,
        iconSizeScale: 10
      };
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mockFuncGetThemeStyle: Function = mocker.mockFunc(themeStyleManager, themeStyleManager.getThemeStyle);
      when(mockFuncGetThemeStyle)(ArgumentMatchers.any).afterReturn(themeStyleInfo);

      (pcPageDesktopGridStyleConfig as object)['updateIconSize'];

      expect(pcPageDesktopGridStyleConfig.mIconSize).not().assertNull();;
      expect(pcPageDesktopGridStyleConfig.mItemPadding).not().assertNull();
      expect(pcPageDesktopGridStyleConfig.mIconRadius).not().assertNull();

      mocker.ignoreMock(themeStyleManager, themeStyleManager.getThemeStyle);
    });

    it('updateIconSizeFromSettingTest', 0, () => {
      let mockAppStorageGet: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorageGet)(ArgumentMatchers.anyString).afterReturn(10);

      (pcPageDesktopGridStyleConfig as object)['updateIconSizeFromSetting'];

      expect(pcPageDesktopGridStyleConfig.mIconSize).assertEqual(StyleConstants.DEFAULT_APP_ICON_SIZE_WIDTH + 10);
      expect(pcPageDesktopGridStyleConfig.mItemPadding).assertEqual(StyleConstants.DEFAULT_APP_TOP_RATIO - 5);

      mocker.ignoreMock(AppStorage, AppStorage.get);
    });

    it('updatePreviewIconSizeTest', 0, () => {
      let themeStyleInfo: ThemeStyleInfo = {
        isShowName:true,
        iconSizeScale: 10
      };
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mockFuncGetThemeStyle: Function = mocker.mockFunc(themeStyleManager, themeStyleManager.getThemeStyle);
      when(mockFuncGetThemeStyle)(ArgumentMatchers.any).afterReturn(themeStyleInfo);

      (pcPageDesktopGridStyleConfig as object)['updatePreviewIconSize'];

      expect(pcPageDesktopGridStyleConfig.mIconRadiusPreview).not().assertNull();

      mocker.ignoreMock(themeStyleManager, themeStyleManager.getThemeStyle);
    });

    it('updateMoveStateTest', 0, () => {
      let themeStyleInfo: ThemeStyleInfo = {
        isShowName:true,
        iconSizeScale: 10
      };
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mockFuncGetThemeStyle: Function = mocker.mockFunc(themeStyleManager, themeStyleManager.getThemeStyle);
      when(mockFuncGetThemeStyle)(ArgumentMatchers.any).afterReturn(themeStyleInfo);

      (pcPageDesktopGridStyleConfig as object)['updatePreviewIconSize'];

      expect(pcPageDesktopGridStyleConfig.mIconRadiusPreview).not().assertNull();

      mocker.ignoreMock(themeStyleManager, themeStyleManager.getThemeStyle);
    });

  })
}