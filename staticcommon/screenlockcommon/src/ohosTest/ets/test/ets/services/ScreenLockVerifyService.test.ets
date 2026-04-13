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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { AcquireExtraInfo, ResultHandler, VerifyInterceptor } from '../../../../../main/ets/services/ScreenLockVerifyService';
import { ScreenLockVerifyService,VerifyInfo} from '../../../../../main/ets/TsIndex'
import { AuthType } from '../../../../../main/ets/utils/AccountHelper';

export default function ScreenLockVerifyServiceTest() {
  describe('ScreenLockVerifyServiceTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('ScreenLockVerifyServiceTest_verifyDataChangeListener_001', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      if(screenLock['_verifyDataChangeListener'].onVerifyStateChange){
        let result = screenLock['_verifyDataChangeListener'].onVerifyStateChange(AuthType.PIN, new VerifyInfo(0));
        expect(result == null).assertTrue();
      }
    })

    it('ScreenLockVerifyServiceTest_isVerifying_004', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      let result = screenLock.isVerifying(AuthType.PIN);
      expect(result).assertFalse();
    })

    it('ScreenLockVerifyServiceTest_setOperateOpenState_006', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      let result = screenLock.setOperateOpenState(AuthType.PIN, true);
      expect(result == null).assertTrue();

      result = screenLock.setOperateOpenState(AuthType.DOMAIN, true);
      expect(result == null).assertTrue();
    })

    it('ScreenLockVerifyServiceTest_registerInterceptor_007', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      let result = screenLock.registerInterceptor(new VerifyInterceptorSon(AuthType.PIN));
      expect(result == null).assertTrue();
    })

    it('ScreenLockVerifyServiceTest_unRegisterInterceptor_008', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      let result = screenLock.unRegisterInterceptor(new VerifyInterceptorSon(AuthType.PIN));
      expect(result == null).assertTrue();
    })

    it('ScreenLockVerifyServiceTest_doInit_009', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      let result = screenLock['doInit']();
      expect(result == null).assertTrue();
    })

    it('ScreenLockVerifyServiceTest_doRelease_010', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      let result = screenLock['doRelease']();
      expect(result == null).assertTrue();
    })

    it('ScreenLockVerifyServiceTest_setPageOpenState_011', Level.LEVEL0, () => {
      let screenLock = ScreenLockVerifyService.getInstance();
      let result = screenLock.setPageOpenState(AuthType.PIN, true);
      expect(result == null).assertTrue();

      result = screenLock.setPageOpenState(AuthType.DOMAIN, true);
      expect(result == null).assertTrue();
    })

    it('VerifyInterceptor_getnext_012', Level.LEVEL0, () => {
      let verify = new VerifyInterceptorSon(AuthType.PIN);
      let result = verify.next;
      expect(result == null).assertTrue();
    })

    it('VerifyInterceptor_setnext_013', Level.LEVEL0, () => {
      let verify = new VerifyInterceptorSon(AuthType.PIN);
      let verify1 = new VerifyInterceptorSon(AuthType.FACE);
      verify.next = verify1;
      expect(verify.next == null).assertFalse();
    })

    it('VerifyInterceptor_onVerifyResult_014', Level.LEVEL0, () => {
      let verify = new VerifyInterceptorSon(AuthType.PIN);
      let handler: ResultHandler = {
        authType: AuthType.PIN,
        authTypeStr: '',
        setHasHandleResult: (): void => {
        },
        setHasHandleAcquireInfo: (): void => {
        },
        broadcastResult: (result: number): void => {
        },
        broadcastAcquireInfo: (module: number, acquire: number, extraInfo: AcquireExtraInfo): void => {
        },
        sendAuthResultToOuterHome: (result: number): void => {
        }
      }
      let result = verify.onVerifyResult(handler, 1);
      expect(result).assertFalse();
    })

    it('VerifyInterceptor_onAcquireInfo_015', Level.LEVEL0, () => {
      let verify = new VerifyInterceptorSon(AuthType.PIN);
      let handler: ResultHandler = {
        authType: AuthType.PIN,
        authTypeStr: '',
        setHasHandleResult: (): void => {
        },
        setHasHandleAcquireInfo: (): void => {
        },
        broadcastResult: (result: number): void => {
        },
        broadcastAcquireInfo: (module: number, acquire: number, extraInfo: AcquireExtraInfo): void => {
        },
        sendAuthResultToOuterHome: (result: number): void => {
        }
      };
      let info: AcquireExtraInfo = {
        authResult: 0,
        authRemainAttempts: 0,
        lockoutDuration: 0,
        userId: 0
      };
      let result = verify.onAcquireInfo(handler, 1, 1, info);
      expect(result).assertFalse();
    })

    it('VerifyInterceptor_doInit_016', Level.LEVEL0, () => {
      let verify = new VerifyInterceptorSon(AuthType.PIN);
      let result: Object = (verify as object)['doInit']();
      expect(result == null).assertTrue();
    })

    it('VerifyInterceptor_doRelease_017', Level.LEVEL0, () => {
      let verify = new VerifyInterceptorSon(AuthType.PIN);
      let result: Object = (verify as object)['doRelease']();
      expect(result == null).assertTrue();
    })

  })

  class VerifyInterceptorSon extends VerifyInterceptor {

  }
}