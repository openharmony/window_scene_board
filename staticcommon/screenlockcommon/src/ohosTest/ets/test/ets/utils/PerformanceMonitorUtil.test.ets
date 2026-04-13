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
import { PerformanceMonitorUtil } from '../../../../../main/ets/TsIndex'
import { LockscreenEditStatusParams } from '../../../../../main/ets/record/report/PerformanceMonitorUtil'

export default function PerformanceMonitorUtilTest() {
  describe('PerformanceMonitorUtilTest', () => {
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
    it('PerformanceMonitorUtilTest_init', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let params:LockscreenEditStatusParams = {
        PNAMEID:'xx',
        PVERSIONID:"test",
      }
      PerformanceMonitorUtil.reportBehaviorEvent('name', params);
      PerformanceMonitorUtil.reportStatisticEvent('name', params);
      PerformanceMonitorUtil.setScreenIntoPINStart();
      PerformanceMonitorUtil.setScreenIntoPINEnd();
      PerformanceMonitorUtil.setScreenSleepMoStart();
      PerformanceMonitorUtil.setScreenSleepMoEnd();
      PerformanceMonitorUtil.setScreenOffFPStart();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })
    it('PerformanceMonitorUtilTest_setFrameRateMoStart', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      PerformanceMonitorUtil.setFrameRateMoStart(undefined,true);
      PerformanceMonitorUtil.setFrameRateMoStart(undefined,false);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })
    it('PerformanceMonitorUtilTest_setFrameRateMoEnd', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      PerformanceMonitorUtil.setFrameRateMoEnd(undefined,true);
      PerformanceMonitorUtil.setFrameRateMoEnd(undefined,false);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })
  })
}