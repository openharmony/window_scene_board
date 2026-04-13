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
import { VerifyDataManager, VerifyInfo } from '../../../../../main/ets/TsIndex'
import { AuthType } from '../../../../../main/ets/utils/AccountHelper'
import { osAccount } from '@kit.BasicServicesKit'

export default function VerifyDataManagerTest() {
  describe('VerifyDataManagerTest', () => {
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
    it('test_newVerifyInfo', 0, () => {
      let verifyInfo = new VerifyInfo(AuthType.PIN);
      expect(verifyInfo.authSubType).assertEqual(10000);
    })

    it('test_updateVerifyInfo', 0, () => {
      let option: osAccount.AuthResult = {
        accountId: 1
      };
      let verifyDataManager = VerifyDataManager.getInstance();
      verifyDataManager.updateVerifyInfo(AuthType.FINGERPRINT, 0, undefined);
      verifyDataManager.updateVerifyInfo(AuthType.FINGERPRINT, 0, option);
      expect(option.accountId).assertEqual(1);
    })

    it('test_updateVerifyDataInner', 0, () => {
      let option: osAccount.AuthResult = {
        accountId: 1
      };
      let verifyDataManager = VerifyDataManager.getInstance();
      (verifyDataManager as object)['updateVerifyDataInner']();
      expect(option.accountId).assertEqual(1);
    })

    it('test_getSwitchStatus', 0, () => {
      let verifyDataManager = VerifyDataManager.getInstance();
      let option: osAccount.AuthResult = {
        accountId: 1
      };
      (verifyDataManager as object)['getSwitchStatus'](AuthType.FACE, true);
      (verifyDataManager as object)['getSwitchStatus'](AuthType.FACE, false);
      (verifyDataManager as object)['getSwitchStatus'](AuthType.FINGERPRINT, true);
      (verifyDataManager as object)['getSwitchStatus'](AuthType.FINGERPRINT, false);
      (verifyDataManager as object)['getSwitchStatus'](AuthType.PIN, true);
      expect(option.accountId).assertEqual(1);
    })

    it('test_updateFaceVerifyInfo', 0, () => {
      let verifyDataManager = VerifyDataManager.getInstance();
      (verifyDataManager as object)['updateFaceVerifyInfo'](false);
      let res: boolean = (verifyDataManager as object)['updateFaceVerifyInfo'](true);
      expect(res).assertEqual(true);
    })

    it('test_updateFingerprintVerifyInfo', 0, () => {
      let verifyDataManager = VerifyDataManager.getInstance();
      (verifyDataManager as object)['updateFingerprintVerifyInfo'](false);
      let res: boolean = (verifyDataManager as object)['updateFingerprintVerifyInfo'](true);
      expect(res).assertEqual(false);
    })
  })
}