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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { ColorUtil } from '../../../../../../main/ets/TsIndex';

export default function ColorUtilTest() {
  describe('ColorUtilTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_convertRGBA2ResourceColor', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let red: number = 10;
      let green: number = 20;
      let blue: number = 30;
      let alpha = undefined;

      let retVal = ColorUtil.convertRGBA2ResourceColor(red, green, blue, alpha);
      expect(retVal).not().assertEqual('');
    })

    it('test_convertRGBA2ResourceColorEmpty', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let red = undefined;
      let green = undefined;
      let blue = undefined;
      let alpha: number = 255.0;
      try {
      let retVal = ColorUtil.convertRGBA2ResourceColor(red, green, blue, alpha);
      expect(retVal).assertEqual('');

      retVal = ColorUtil.convertRGBA2ResourceColor(100, green, blue, alpha);
      expect(retVal).assertEqual('');

      retVal = ColorUtil.convertRGBA2ResourceColor(100, 100, blue, alpha);
      expect(retVal).assertEqual('');
      } catch (e) {}
    })

    it('test_contrast2White', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let luminance: number = 100;
      const retValue = ColorUtil.contrast2White(luminance);
      expect(retValue).assertLarger(0);
    })

    it('test_calAlphaFromRGBAndLuminance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let luminance: number = 0.2;
      const red = 80;
      const green = 20;
      const blue = 30;
      const retValue = ColorUtil.calAlphaFromRGBAndLuminance(red, green, blue, luminance);
      expect(retValue).assertLarger(0);
    })

    it('test_contrast', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const luminance1: number = 100;
      const luminance2: number = 50;

      let retValue = ColorUtil.contrast(luminance1, luminance1);
      expect(retValue).assertEqual(1);

      retValue = ColorUtil.contrast(luminance1, luminance2);
      expect(retValue).assertLarger(1.0);

      retValue = ColorUtil.contrast(luminance2, luminance1);
      expect(retValue).assertLess(1.0);
    })

    it('test_rgb2Luminance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const red = 1;
      const green = 127;
      const blue = 128;

      let retValue = ColorUtil.rgb2Luminance(red, green, blue);
      expect(retValue).assertLarger(0);
      expect(retValue).assertLess(1);
    })

    it('test_rgb2LuminanceEmpty', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let red = undefined;
      let green = undefined;
      let blue = undefined;

      let retValue = ColorUtil.rgb2Luminance(red, green, blue);
      expect(retValue).assertNaN();

      retValue = ColorUtil.rgb2Luminance(125, green, blue);
      expect(retValue).assertNaN();

      retValue = ColorUtil.rgb2Luminance(125, 125, blue);
      expect(retValue).assertNaN();
    })
  })
}