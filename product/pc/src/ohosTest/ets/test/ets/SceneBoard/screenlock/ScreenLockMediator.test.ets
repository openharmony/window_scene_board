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
import ScreenLockMediator from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/ScreenLockMediator';
import TestConst from '@ohos/screenlockcomponent/src/ohosTest/ets/test/ets/ohos/constants/TestConst';
import type { Observer } from '@ohos/basicutils';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function ScreenLockMediatorTest() {

  describe('ScreenLockMediatorTest', (): void => {
    let observer: Observer;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('test_ScreenLockCutOutUtil_doScreenLockWithLocalCallback_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      try {
        ScreenLockMediator.doScreenLockWithLocalCallback();
        result = true;
      } catch (e) {
        result = false;
      }
      expect(result).assertEqual(true);
    })

    it('test_addObserver_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.addObserver(observer);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_deleteObserver_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.deleteObserver(observer);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_notifyObservers_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.notifyObservers();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_setScreenOn_return', 0, (): void => {
      let isScreenOn: boolean = true;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.setScreenOn(isScreenOn);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_setScreenOnEnd_return', 0, (): void => {
      let isEndScreenOn: boolean = true;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.setScreenOnEnd(isEndScreenOn);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_setScreenOffEnd_return', 0, (): void => {
      let isScreenOffEnd: boolean = true;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.setScreenOffEnd(isScreenOffEnd);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_watchInputDevice_return-one', 0, (): void => {
      let isAddDevice: boolean = false;
      let deviceId: number = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.watchInputDevice(isAddDevice, deviceId);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_watchInputDevice_return-two', 0, (): void => {
      let isAddDevice: boolean = true;
      let deviceId: number = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.watchInputDevice(isAddDevice, deviceId);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_doScreenLock_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.doScreenLock();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_backPage_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.backPage();
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_unlockScreen_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockMediator.unlockScreen();
        result = true;
      })
      expect(result).assertEqual(true);
    })

  })
}