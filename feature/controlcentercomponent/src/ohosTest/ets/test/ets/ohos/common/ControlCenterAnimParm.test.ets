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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import ControlCenterAnim from '../../../../../../main/ets/com/ohos/common/ControlCenterAnimParm';

export function ControlCenterAnimParmTest() {
  describe('ControlCenterAnimParmTest', () => {
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

    it('ControlCenterAnimParmTest001', 0, (): void => {
      let value =  ControlCenterAnim.APPEAR_DURATION
      expect(value > 0).assertEqual(true);
    })

    it('ControlCenterAnimParmTest002', 0, (): void => {
      let value =  ControlCenterAnim.SCALE_VAL
      expect(value > 0).assertEqual(true);
    })

    it('ControlCenterAnimParmTest003', 0, (): void => {
      let value =  ControlCenterAnim.DISAPPEAR_DURATION
      expect(value > 0).assertEqual(true);
    })

    it('ControlCenterAnimParmTest004', 0, (): void => {
      let value =  ControlCenterAnim.DISAPPEAR_DELAY_INTERVAL
      expect(value > 0).assertEqual(true);
    })

    it('ControlCenterAnimParmTest005', 0, (): void => {
      let value =  ControlCenterAnim.TRANSITION_Y
      expect(value > 0).assertEqual(true);
    })

    it('ControlCenterAnimParmTest006', 0, (): void => {
      let value =  ControlCenterAnim.TRANSITION_Y
      expect(value).assertInstanceOf('Number');
    })

    it('ControlCenterAnimParmTest007', 0, (): void => {
      let value =  ControlCenterAnim.APPEAR_DELAY_INTERVAL
      expect(value > 0).assertEqual(true);
    })

    it('ControlCenterAnimParmTest008', 0, (): void => {
      let value =  ControlCenterAnim.APPEAR_DELAY_INTERVAL
      expect(value).assertInstanceOf('Number');
    })

    it('ControlCenterAnimParmTest009', 0, (): void => {
      let value =  ControlCenterAnim.TRANSITION_Y
      expect(value > 10).assertEqual(true);
    })

    it('ControlCenterAnimParmTest0010', 0, (): void => {
      let value =  ControlCenterAnim.DISAPPEAR_DELAY_INTERVAL
      expect(value).assertInstanceOf('Number');
    })

    it('ControlCenterAnimParmTest011', 0, (): void => {
      let value =  ControlCenterAnim.APPEAR_DURATION
      expect(value).assertInstanceOf('Number');
    })

    it('ControlCenterAnimParmTest012', 0, (): void => {
      let value =  ControlCenterAnim.TRANSITION_Y
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest013', 0, (): void => {
      let value =  ControlCenterAnim.APPEAR_DURATION
      expect(value > 10).assertEqual(true);
    })

    it('ControlCenterAnimParmTest014', 0, (): void => {
      let value =  ControlCenterAnim.APPEAR_DURATION
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest015', 0, (): void => {
      let value =  ControlCenterAnim.APPEAR_DURATION
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest016', 0, (): void => {
      let value =  ControlCenterAnim.TRANSITION_Y
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest0017', 0, (): void => {
      let value =  ControlCenterAnim.DISAPPEAR_DELAY_INTERVAL
      expect(value > 10).assertEqual(true);
    })

    it('ControlCenterAnimParmTest0018', 0, (): void => {
      let value =  ControlCenterAnim.DISAPPEAR_DELAY_INTERVAL
      expect(value > 10).assertEqual(true);
    })

    it('ControlCenterAnimParmTest019', 0, (): void => {
      let value = ControlCenterAnim.TRANSITION_Y
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest020', 0, (): void => {
      let value = ControlCenterAnim.TRANSITION_Y
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest021', 0, (): void => {
      let value = ControlCenterAnim.TRANSITION_Y
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest022', 0, (): void => {
      let value = ControlCenterAnim.TRANSITION_Y
      expect(value > 20).assertEqual(true);
    })

    it('ControlCenterAnimParmTest023', 0, (): void => {
      let value = ControlCenterAnim.TRANSITION_Y
      expect(value > 20).assertEqual(true);
    })
  })
}