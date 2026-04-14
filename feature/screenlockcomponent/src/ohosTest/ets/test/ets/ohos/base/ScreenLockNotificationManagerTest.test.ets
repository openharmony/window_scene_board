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
import ScreenLockNotificationManager, {
  RelatedSource
} from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockNotificationManager';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function ScreenLockNotificationManagerTest() {

  describe('ScreenLockNotificationManagerTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_registerNtfRelatedSlidingCallback_return', 0, (): void => {
      let updateCallback: Function;
      let endCallback: Function;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockNotificationManager.registerNtfRelatedSlidingCallback(updateCallback, endCallback);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_notifyNtfRelatedSlidingUpdate_return', 0, (): void => {
      let source: RelatedSource;
      let ratio: number = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockNotificationManager.notifyNtfRelatedSlidingUpdate(source, ratio);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_notifyNtfRelatedSlidingEnd_return', 0, (): void => {
      let source: RelatedSource;
      let isEndSuccess: boolean = true;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        ScreenLockNotificationManager.notifyNtfRelatedSlidingEnd(source, isEndSuccess);
        result = true;
      })
      expect(result).assertEqual(true);
    })

  })
}