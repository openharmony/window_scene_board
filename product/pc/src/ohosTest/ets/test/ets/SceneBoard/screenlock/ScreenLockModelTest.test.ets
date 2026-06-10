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
import ScreenLockModel from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/ScreenLockModel';
import { Callback } from '@ohos/frameworkwrapper';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function ScreenLockModelTest() {

  describe('ScreenLockModelTest', (): void => {
    let mScreenLockModel: ScreenLockModel = new ScreenLockModel();
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_eventCancelListener_return', 0, (): void => {
      let typeName: string = 'res';
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mScreenLockModel.eventCancelListener(typeName);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_sendScreenLockEvent_return', 0, (): void => {
      let typeName: string = 'res';
      let typeNo: number = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mScreenLockModel.sendScreenLockEvent(typeName, typeNo, () => {
        });
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_showScreenLockWindow_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback = () => {
        execute = 'success';
      };
      mScreenLockModel.showScreenLockWindow(callback);
      expect(execute == 'success' ? true : false).assertEqual(true);
    })

    it('test_hiddenScreenLockWindow_return', 0, (): void => {
      let isHideView: boolean = true;
      let execute: string = '';
      const callback: Callback = () => {
        execute = 'success';
      };
      mScreenLockModel.hiddenScreenLockWindow(callback,isHideView);
      expect(execute == 'success' ? true : false).assertEqual(true);
    })

    it('test_setScreenLockPrivacy_return', 0, (): void => {
      let isPrivacy: boolean = true;
      let result: boolean = false;
      getResultClass.getResult1(() => {
      mScreenLockModel.setScreenLockPrivacy(isPrivacy);
      result = true;
      })
      expect(result).assertEqual(true);
    })

  })
}