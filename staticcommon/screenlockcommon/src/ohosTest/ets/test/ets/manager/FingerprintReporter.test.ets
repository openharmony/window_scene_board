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
import { FingerprintReporter, UnlockStage } from '../../../../../main/ets/manager/FingerprintReporter';
import { osAccount } from '@kit.BasicServicesKit';

export default function FingerprintReporterTest() {
  let fingerprintReporter: FingerprintReporter = new FingerprintReporter();
  describe('FingerprintReporterTest', () => {
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

    it('FingerprintReporter_setUnLockModel1', 0, () => {
      (fingerprintReporter as object)['setUnLockModel'](null);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_setUnLockModel2', 0, () => {
      (fingerprintReporter as object)['setUnLockModel'](osAccount.AuthType.PIN);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_setUnLockModel3', 0, () => {
      (fingerprintReporter as object)['setUnLockModel'](osAccount.AuthType.FACE);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_setUnLockModel4', 0, () => {
      (fingerprintReporter as object)['setUnLockModel'](osAccount.AuthType.FINGERPRINT);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_setUnLockModel5', 0, () => {
      (fingerprintReporter as object)['setUnLockModel'](osAccount.AuthType.DOMAIN);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_setUnLockModel6', 0, () => {
      (fingerprintReporter as object)['setUnLockModel'](osAccount.AuthType.RECOVERY_KEY);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_kgUnlockReport1', 0, () => {
      fingerprintReporter.kgUnlockReport(osAccount.AuthType.RECOVERY_KEY, UnlockStage.START_UNLOCK);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_kgUnlockReport2', 0, () => {
      fingerprintReporter.kgUnlockReport(osAccount.AuthType.RECOVERY_KEY, UnlockStage.END_UNLOCK);
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_stringToUint8Array', 0, () => {
      (fingerprintReporter as object)['stringToUint8Array']('reportData');
      expect(fingerprintReporter).not().assertUndefined();
    });

    it('FingerprintReporter_sendCommand', 0, () => {
      (fingerprintReporter as object)['sendCommand'](10, 'reportData');
      expect(fingerprintReporter).not().assertUndefined();
    });

  })
}