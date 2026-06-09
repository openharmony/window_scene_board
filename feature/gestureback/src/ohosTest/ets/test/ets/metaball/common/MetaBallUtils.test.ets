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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
} from '@ohos/hypium';
import { MetaBallUtils } from '../../../../../../main/ets/metaball/common/MetaBallUtils';

export default function MetaBallUtilsTest() {


  describe('MetaBallUtilsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.·
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
    it('MetaBallUtilsTest_calculateAnimProcess1', 0, (): void => {
      const result = MetaBallUtils.calculateAnimProcess(50);
      expect(result).assertEqual(0.44);
    })

    it('MetaBallUtilsTest_calculateAnimProcess2', 0, (): void => {
      const result = MetaBallUtils.calculateAnimProcess(10);
      expect(result).assertEqual(0.1);
    })

    it('MetaBallUtilsTest_calculateAnimProcess3', 0, (): void => {
      const result = MetaBallUtils.calculateAnimProcess(1700);
      expect(result).assertEqual(1);
    })

    it('MetaBallUtilsTest_calculateAnimProcess4', 0, (): void => {
      const result = MetaBallUtils.calculateAnimProcess(-100);
      expect(result).assertLess(1);
      expect(result).assertLarger(0);
    })

    it('MetaBallUtilsTest_calculateAnimProcess5', 0, (): void => {
      const result = MetaBallUtils.calculateAnimProcess(200);
      expect(result).assertEqual(0.955);
    })

    it('MetaBallUtilsTest_drawMetaBall1', 0, (): void => {
      let settings: RenderingContextSettings = new RenderingContextSettings(true);
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D(settings);
      const result = MetaBallUtils.drawMetaBall(true, 1, 1, context);
      expect(result).assertLarger(30.7);
      expect(result).assertLess(30.9);
    })

    it('MetaBallUtilsTest_drawMetaBall2', 0, (): void => {
      let settings: RenderingContextSettings = new RenderingContextSettings(true);
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D(settings);
      const result = MetaBallUtils.drawMetaBall(true, 1, 0.5, context);
      expect(result).assertLarger(30.7);
      expect(result).assertLess(30.9);
    })

    it('MetaBallUtilsTest_drawMetaBall3', 0, (): void => {
      let settings: RenderingContextSettings = new RenderingContextSettings(true);
      let context: CanvasRenderingContext2D = new CanvasRenderingContext2D(settings);
      const result = MetaBallUtils.drawMetaBall(false, 0.5, 0.5, context);
      expect(result).assertLarger(13.3);
      expect(result).assertLess(13.5);
    })

    it('MetaBallUtilsTest_calculateAlpha1', 0, (): void => {
      const result = MetaBallUtils.calculateAlpha(1);
      expect(result).assertEqual(1);
    })

    it('MetaBallUtilsTest_calculateAlpha2', 0, (): void => {
      const result = MetaBallUtils.calculateAlpha(0);
      expect(result).assertEqual(0);
    })

    it('MetaBallUtilsTest_calculateAlpha3', 0, (): void => {
      const result = MetaBallUtils.calculateAlpha(0.275);
      expect(result).assertEqual(0);
    })

    it('MetaBallUtilsTest_calculateArrowImgTranslateX1', 0, (): void => {
      const result = MetaBallUtils.calculateArrowImgTranslateX(8, true, 3, 3);
      expect(result).assertLarger(5.1);
      expect(result).assertLess(5.4);
    })

    it('MetaBallUtilsTest_calculateArrowImgTranslateX2', 0, (): void => {
      const result = MetaBallUtils.calculateArrowImgTranslateX(10, false, 3, 3);
      expect(result).assertLarger(-9.2);
    })
  })
}
