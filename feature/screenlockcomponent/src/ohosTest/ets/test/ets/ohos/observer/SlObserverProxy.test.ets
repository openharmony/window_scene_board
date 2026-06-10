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
import { LockStateInfo } from '@ohos/screenlockcommon/src/main/ets/TsIndex'
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper'
import { BouncerStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/BouncerFsm'
import { MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm'
import { CoreStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm'
import { SlObserverProxy } from '../../../../../../main/ets/observer/SlObserverProxy'

export default function SlObserverProxyTest() {
  describe('SlObserverProxyTest', () => {
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

    it('test_isVerifying_1', 0, () => {
      let observer = new SlObserverProxy();
      let authType = AuthType.PIN;
      let isVerifying = observer.isVerifying(authType);
      expect(isVerifying).assertEqual(false);
    })

    it('test_isVerifying_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let authType = AuthType.PIN;
      let isVerifying = observer.isVerifying(authType, (isVerifying: boolean) => {
        done();
      });
      expect(isVerifying).assertEqual(false);
    })

    it('test_isInRequestUnlock_1', 0, () => {
      let observer = new SlObserverProxy();
      let isInRequestUnlock = observer.isInRequestUnlock();
      expect(isInRequestUnlock).assertEqual(false);
    })

    it('test_isInRequestUnlock_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let isInRequestUnlock = observer.isInRequestUnlock((isInRequestUnlock: boolean) => {
        done();
      });
      expect(isInRequestUnlock).assertEqual(false);
    })

    it('test_isScreenOn_1', 0, () => {
      let observer = new SlObserverProxy();
      let result = observer.isScreenOn();
      expect(result).not().assertNull();
    })

    it('test_isScreenOn_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let result = observer.isScreenOn((isScreenOn: boolean) => {
        done();
      });
      expect(result).not().assertNull();
    })

    it('test_isIntoSleep_1', 0, () => {
      let observer = new SlObserverProxy();
      let result = observer.isIntoSleep();
      expect(result).not().assertNull();
    })

    it('test_isIntoSleep_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let result = observer.isIntoSleep((isIntoSleep: boolean) => {
        done();
      });
      expect(result).not().assertNull();
    })

    it('test_getLockState_1', 0, () => {
      let observer = new SlObserverProxy();
      let result = observer.getLockState();
      expect(result).not().assertNull();
    })

    it('test_getLockState_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let result = observer.getLockState((lockState: LockStateInfo) => {
        done();
      });
      expect(result).not().assertNull();
    })

    it('test_getCoreFsmState_1', 0, () => {
      let observer = new SlObserverProxy();
      let stateType = observer.getCoreFsmState(6);
      expect(stateType).assertEqual(CoreStateType.INIT_STATE);
    })

    it('test_getCoreFsmState_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let stateType = observer.getCoreFsmState(6, (oldState: CoreStateType, newState: CoreStateType) => {
        done();
      });
      expect(stateType).assertEqual(CoreStateType.INIT_STATE);
    })

    it('test_getMpFsmState_1', 0, () => {
      let observer = new SlObserverProxy();
      let stateType = observer.getMpFsmState(66);
      expect(stateType).assertEqual(MpStateType.INIT_STATE);
    })

    it('test_getMpFsmState_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let stateType = observer.getMpFsmState(66, (oldState: MpStateType, newState: MpStateType) => {
        done();
      });
      expect(stateType).assertEqual(MpStateType.INIT_STATE);
    })

    it('test_getBouncerFsmState_1', 0, () => {
      let observer = new SlObserverProxy();
      let stateType = observer.getBouncerFsmState(666);
      expect(stateType).assertEqual(BouncerStateType.INIT_STATE);
    })

    it('test_getBouncerFsmState_2', 0, (done: Function) => {
      let observer = new SlObserverProxy();
      let stateType = observer.getBouncerFsmState(666, (oldState: BouncerStateType, newState: BouncerStateType) => {
        done();
      });
      expect(stateType).assertEqual(BouncerStateType.INIT_STATE);
    })
  })
}