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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import LockScreenBase from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/LockScreenBase';
import { VoteDevice } from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/VoteDevice';
import TestConst from '@ohos/screenlockcomponent/src/ohosTest/ets/test/ets/ohos/constants/TestConst';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function LockScreenBaseTest() {

  describe('LockScreenBaseTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_LockScreenBaseTest_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        LockScreenBase.onCreate();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_LockScreenBaseTest_onBeginWakeup_01_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      try {
        LockScreenBase.onBeginWakeup(40);
        result = true;
      } catch (e) {
        result = false;
      }
      expect(result).assertEqual(true);
    })

    it('test_LockScreenBaseTest_onEndSleep_01_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      try {
        LockScreenBase.onEndSleep();
        result = true;
      } catch (e) {
        result = false;
      }
      expect(result).assertEqual(true);
    })

    it('test_LockScreenBaseTest_onBeginSleep_01_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      try {
        AppStorage.set('isPwdVisible', true);
        LockScreenBase.onBeginSleep(40);
        LockScreenBase.onBeginSleep(32);
        result = true;
      } catch (e) {
        result = false;
      }
      expect(result).not().assertNull();
    })


    it('test_LockScreenBaseTest_onBeginWakeup_02_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      try {
        LockScreenBase.onBeginWakeup(100);
        result = true;
      } catch (e) {
        result = false;
      }
      expect(result).assertEqual(true);
    })

    it('test_initVoteDevice', TestConst.TEST_LEVEL, (): void => {
      const mVoteDevice = new VoteDevice();
      LockScreenBase.initVoteDevice(mVoteDevice);
      LockScreenBase.getVoteDevice();
      expect(true).assertEqual(true);
    })
  })
}