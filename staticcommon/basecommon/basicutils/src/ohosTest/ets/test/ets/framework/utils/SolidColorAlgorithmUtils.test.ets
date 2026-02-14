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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { SolidColorAlgorithmUtils } from '../../../../../../main/ets/utils/SolidColorAlgorithmUtils';
import { effectKit } from '@kit.ArkGraphics2D';
import { ConfigurationConstant } from '@kit.AbilityKit';

/**
 * 纯色模式颜色计算算法工具类的测试套
 */
export function SolidColorAlgorithmUtilsTest() {
  describe('SolidColorAlgorithmUtilsTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    });
    afterAll((): void => {

    });
    afterEach((): void => {

    });

    const options: BrightnessOptions = {
      rate: 0.5,
      lightUpDegree: 0.5,
      cubicCoeff: 0,
      quadCoeff: 0,
      fraction: 0.5,
      saturation: 2,
      posRGB: [1, 2, 3],
      negRGB: [1, 2, 3],
    };
    const color: effectKit.Color = {
      red: 0,
      green: 0,
      blue: 0,
      alpha: 0,
    };

    it('SolidColorAlgorithmUtilsTest_calSolidColor_option_is_undefined', 0, (): void => {
      expect(SolidColorAlgorithmUtils.calSolidColor(undefined, color)).assertEqual(color);
    });

    it('SolidColorAlgorithmUtilsTest_calSolidColor_color_is_undefined', 0, (): void=> {
      expect(SolidColorAlgorithmUtils.calSolidColor(options, undefined)).assertUndefined();
    });

    it('SolidColorAlgorithmUtilsTest_calSolidColor_correct_param', 0, (): void=> {
      expect(SolidColorAlgorithmUtils.calSolidColor(options, color)).not().assertUndefined();
    });

    it('SolidColorAlgorithmUtilsTest_adjustRGB_curMode_is_undefined', 0, (): void=> {
      const adjustedColor: number[] = SolidColorAlgorithmUtils.adjustRGB(color, undefined);
      expect(adjustedColor[0]).assertEqual(color.red);
      expect(adjustedColor[1]).assertEqual(color.green);
      expect(adjustedColor[2]).assertEqual(color.blue);
    });

    it('SolidColorAlgorithmUtilsTest_adjustRGB_with_light_mode', 0, (): void=> {
      const adjustedColor: number[] = SolidColorAlgorithmUtils.adjustRGB(color,
        ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
      expect(adjustedColor).not().assertUndefined();
    });

    it('SolidColorAlgorithmUtilsTest_adjustRGB_with_dark_mode', 0, (): void=> {
      const adjustedColor: number[] = SolidColorAlgorithmUtils.adjustRGB(color,
        ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
      expect(adjustedColor).not().assertUndefined();
    });
  })
}