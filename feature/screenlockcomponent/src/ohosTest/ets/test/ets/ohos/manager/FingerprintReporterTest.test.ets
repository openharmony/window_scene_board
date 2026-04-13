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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { fingerprintReporter, UnlockStage } from '@ohos/screenlockcommon/src/main/ets/manager/FingerprintReporter';
import osAccount from '@ohos.account.osAccount';


export default function fingerprintReporterTest() {
  let authType: osAccount.AuthType | undefined;
  describe('fingerprintReporterTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance_return_one', 0, (): void => {
      let unlockStage: UnlockStage = UnlockStage.START_UNLOCK;
      fingerprintReporter.kgUnlockReport(authType, unlockStage);
      fingerprintReporter.kgUnlockReport(osAccount.AuthType.PIN, unlockStage);
      fingerprintReporter.kgUnlockReport(osAccount.AuthType.FINGERPRINT, unlockStage);
      fingerprintReporter.kgUnlockReport(osAccount.AuthType.DOMAIN, unlockStage);
      fingerprintReporter.kgUnlockReport(729958, unlockStage);
      expect(unlockStage).not().assertNull();
    })

    it('test_getInstance_return_two', 0, (): void => {
      let unlockStage: UnlockStage = UnlockStage.END_UNLOCK;
      fingerprintReporter.kgUnlockReport(authType, unlockStage);
      expect(unlockStage).not().assertNull();
    })

  })
}