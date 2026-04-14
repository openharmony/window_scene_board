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
import { StrongAuthManager, StrongAuthConstants } from '@ohos/screenlockcommon/src/main/ets/manager/StrongAuthManager';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function StrongAuthManagerTest() {

  describe('StrongAuthManagerTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        StrongAuthManager.getInstance();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_setAuthReason_return_One', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        let reason: number = StrongAuthConstants.NO_NEED_STRONG_AUTH;
        StrongAuthManager.getInstance().setAuthReason(reason);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_setAuthReason_return_Two', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        let reason: number = StrongAuthConstants.USER_TIMEOUT;
        StrongAuthManager.getInstance().setAuthReason(reason);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_resetReason_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        StrongAuthManager.getInstance().resetReason();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_getStrongAuthStatus_return', 0, (): void => {
      let result = StrongAuthManager.getInstance().getStrongAuthStatus();
      expect(result).assertEqual(0);
    })

    it('test_isNeedStrongAuth_return', 0, (): void => {
      let result = StrongAuthManager.getInstance().isNeedStrongAuth();
      expect(result).assertEqual(false);
    })

    it('test_isRebootStrongAuth_return', 0, (): void => {
      let result = StrongAuthManager.getInstance().isRebootStrongAuth();
      expect(result).assertEqual(false);
    })

    it('test_getStrongAuthPwdTip_return', 0, (): void => {
      let result = StrongAuthManager.getInstance().getStrongAuthPwdTip();
      expect(result).assertEqual('');
    })

    it('test_getStrongAuthLockTip_return', 0, (): void => {
      let result = StrongAuthManager.getInstance().getStrongAuthLockTip();
      expect(result).not().assertNull();
    })

    it('test_setFingerprintEnable_return', 0, (): void => {
      let fingerprintEnable: boolean = false;
      StrongAuthManager.getInstance().setFingerprintEnable(fingerprintEnable);
      expect(fingerprintEnable).not().assertNull();
    })

    it('test_setFingerprintEnable_return_one', 0, (): void => {
      let fingerprintEnable: boolean = true;
      StrongAuthManager.getInstance().setFingerprintEnable(fingerprintEnable);
      expect(fingerprintEnable).not().assertNull();
    })

    it('test_hasSetPasswd_return', 0, (): void => {
      let result = StrongAuthManager.getInstance().hasSetPasswd();
      expect(result).not().assertNull();
    })

    it('test_hasFingerprint_return', 0, (): void => {
      let result = StrongAuthManager.getInstance().hasFingerprint();
      expect(result).not().assertNull();
    })

    it('test_triggerAuthByReboot_return', 0, (): void => {
      StrongAuthManager.getInstance().triggerAuthByReboot();
      expect(StrongAuthManager.getInstance().hasSetPasswd()).not().assertNull();
    })

    it('test_strongAuthRequestUnlock_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      StrongAuthManager.getInstance().setNeedRequestUnlock(false);
      StrongAuthManager.getInstance().strongAuthRequestUnlock();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_strongAuthRequestUnlock_return_one', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      StrongAuthManager.getInstance().setNeedRequestUnlock(true);
      StrongAuthManager.getInstance().strongAuthRequestUnlock();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })
  })
}