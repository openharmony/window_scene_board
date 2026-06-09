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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level } from '@ohos/hypium';
import { ThemeStyleManager } from '../../../../../../main/ets/TsIndex';
import { ThemeStylePreviewManager } from '../../../../../../main/ets/TsIndex';
import { CommonConstants, DesktopMode } from '../../../../../../main/ets/TsIndex';
import { RadiusUtil } from '../../../../../../main/ets/TsIndex';

export default function RadiusUtilTest() {
  describe('RadiusUtilTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('defaultRadius', Level.LEVEL0, (): void => {
      expect(RadiusUtil.calculateRadius(0)).assertEqual(CommonConstants.DEFAULT_ICON_RADIUS);
    })

    it('getRadius', Level.LEVEL0, (): void => {
      let themeStyle = ThemeStyleManager.getInstance().getThemeStyle();
      themeStyle.iconSizeScale = 0;
      expect(RadiusUtil.calculateRadius(1) > 0).assertTrue();
    })

    it('getRadiusPreview', Level.LEVEL0, (): void => {
      let themeStyle = ThemeStylePreviewManager.getInstance().getThemeStyle();
      themeStyle.iconSizeScale = 0;
      ThemeStylePreviewManager.getInstance().updatePreviewStyleInfo(themeStyle);
      expect(RadiusUtil.calculateRadius(themeStyle.iconSizeScale, DesktopMode.PREVIEW_MODE)).assertEqual(CommonConstants.DEFAULT_ICON_RADIUS);
    });

    it('test_RadiusUtil_calculateRadius', 0, () => {
      let iconSize: number = 0;
      RadiusUtil.calculateRadius(iconSize);
    });

    it('test_RadiusUtil_calculateRadius_01', 0, () => {
      let iconSize: number = 1;
      RadiusUtil.calculateRadius(iconSize);
    });

    it('test_RadiusUtil_calculateRadius_02', 0, () => {
      let iconSize: number = -1;
      RadiusUtil.calculateRadius(iconSize);
    });

    it('test_RadiusUtil_calculateRadius_03', 0, () => {
      let iconSize: number = 0;
      let desktopMode: DesktopMode = 0;
      RadiusUtil.calculateRadius(iconSize, desktopMode);
    });

    it('test_RadiusUtil_calculateRadius_04', 0, () => {
      let iconSize: number = 1;
      let desktopMode: DesktopMode = 1;
      RadiusUtil.calculateRadius(iconSize, desktopMode);
    });

    it('test_RadiusUtil_calculateRadius_05', 0, () => {
      let iconSize: number = -1;
      let desktopMode: DesktopMode = 2;
      RadiusUtil.calculateRadius(iconSize, desktopMode);
    });

    it('test_RadiusUtil_calculateSmallFormRadius', 0, () => {
      let isInPreviewMode: boolean = true;
      RadiusUtil.calculateSmallFormRadius(isInPreviewMode);
    });

    it('test_RadiusUtil_calculateSmallFormRadius_01', 0, () => {
      let isInPreviewMode: boolean = false;
      RadiusUtil.calculateSmallFormRadius(isInPreviewMode);
    });

    it('test_RadiusUtil_calculateBigFormRadius', 0, () => {
      let isInPreviewMode: boolean = false;
      RadiusUtil.calculateBigFormRadius(isInPreviewMode);
    });

    it('test_RadiusUtil_calculateBigFormRadius_01', 0, () => {
      let isInPreviewMode: boolean = true;
      RadiusUtil.calculateBigFormRadius(isInPreviewMode);
    });

  })
}
