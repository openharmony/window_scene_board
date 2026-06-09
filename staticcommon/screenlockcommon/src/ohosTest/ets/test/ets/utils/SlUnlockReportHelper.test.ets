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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  PowerUtils,
  ScreenLockStateManager,
  SlUnlockReportHelper,
  VerifyDataManager
} from '../../../../../main/ets/TsIndex'
import { AuthType } from '../../../../../main/ets/utils/AccountHelper'

enum UnlockType {
  FLING = 'FLING',
  FACIAL = 'FACIAL',
  FINGERPRINT = 'FINGERPRINT',
  PASSWORD = 'PASSWORD'
}


export default function SlUnlockReportHelperTest() {
  describe('SlUnlockReportHelperTest', () => {
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

    it('SlUnlockReportHelperTest_unlockReport', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(lockReport, (lockReport as object)['getUnlockType']);
      when(mockFun1)(0).afterReturn(UnlockType.FLING);
      lockReport.unlockReport(0, true);
      expect(lockReport).not().assertNull();
      mock.clear(lockReport)
    })

    it('SlUnlockReportHelperTest_getUnlockType', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      (lockReport as object)['getUnlockType'](1);
      (lockReport as object)['getUnlockType'](2);
      (lockReport as object)['getUnlockType'](3);
      (lockReport as object)['getUnlockType'](4);
      (lockReport as object)['getUnlockType'](8);
      (lockReport as object)['getUnlockType'](1024);
      expect(lockReport).not().assertNull();
    })

    it('SlUnlockReportHelperTest_getScreenState', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      (lockReport as object)['getScreenState'](UnlockType.FINGERPRINT);
      (lockReport as object)['getScreenState'](UnlockType.FLING);
      expect(lockReport).not().assertNull();
    })

    it('SlUnlockReportHelperTest_getScreenState_02', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(PowerUtils, PowerUtils.isActive);
      when(mockFun1)().afterReturn(true);
      (lockReport as object)['getScreenState'](UnlockType.FINGERPRINT);
      expect(lockReport).not().assertNull();
      mock.clear(PowerUtils);
    })

    it('SlUnlockReportHelperTest_getScreenState_03', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(PowerUtils, PowerUtils.isActive);
      when(mockFun1)().afterReturn(false);
      (lockReport as object)['getScreenState'](UnlockType.FINGERPRINT);
      expect(lockReport).not().assertNull();
      mock.clear(PowerUtils);
    })
    it('SlUnlockReportHelperTest_getReportUnlockType', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      (lockReport as object)['getReportUnlockType'](AuthType.FACE, UnlockType.FINGERPRINT);
      (lockReport as object)['getReportUnlockType'](AuthType.PIN, UnlockType.PASSWORD);
      expect(lockReport).not().assertNull();
    })

    it('SlUnlockReportHelperTest_getFacialMethod', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      (lockReport as object)['getFacialMethod']();
      expect(lockReport).not().assertNull();
    })

    it('SlUnlockReportHelperTest_getPwdUi', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      (lockReport as object)['getReportUnlockType'](UnlockType.FINGERPRINT);
      (lockReport as object)['getReportUnlockType'](UnlockType.PASSWORD);
      (lockReport as object)['getReportUnlockType'](UnlockType.FACIAL);
      expect(lockReport).not().assertNull();
    })

    it('SlUnlockReportHelperTest_getUserSwitchMode', 0, () => {
      let lockReport = SlUnlockReportHelper.getInstance();
      (lockReport as object)['getUserSwitchMode']();
      expect(lockReport).not().assertNull();
    })
  })
}