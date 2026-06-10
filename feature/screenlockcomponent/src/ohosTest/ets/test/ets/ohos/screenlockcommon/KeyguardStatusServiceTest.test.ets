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
import TestConst from '../constants/TestConst';
import {
  CacheValue,
  KeyGuardLockStatus,
  KeyGuardMode,
  KeyGuardPage,
  KeyguardStatusService
} from '@ohos/screenlockcommon';

export default function KeyguardStatusServiceTest() {

  describe('KeyguardStatusServiceTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('test_KeyguardStatusService', TestConst.TEST_LEVEL, (): void => {
      KeyguardStatusService.switchToPage(KeyGuardPage.HOME_PAGE);
      KeyguardStatusService.switchToOccluded(0);
      KeyguardStatusService.setLockStatus(KeyGuardLockStatus.DEFAULT);
      KeyguardStatusService.setLockStatus(KeyGuardLockStatus.UNLOCKED);
      KeyguardStatusService.openMode(KeyGuardMode.LOST_MODE);
      expect(KeyguardStatusService.isMode(KeyGuardMode.REMOTE_LOCK)).assertEqual(false);
      expect(KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE)).assertEqual(true);
      expect(KeyguardStatusService.isLockStatus(KeyGuardLockStatus.LOCKING)).assertEqual(false);
      expect(KeyguardStatusService.isPage(KeyGuardPage.LOWE_FINGER_PAGE)).assertEqual(false);
    })

    it('test_isOccluded_return-true', 0, (): void => {
      let result = KeyguardStatusService.isOccluded();
      expect(result).assertEqual(false);
    })

    it('test_getMode_return', 0, (): void => {
      let result = KeyguardStatusService.getMode();
      expect(result).assertEqual(32);
    })

    it('test_isSpecialMode_return-true', 0, (): void => {
      let result = KeyguardStatusService.isSpecialMode();
      let eventType: string = 'res';
      let callback: Callback<CacheValue> = ()=>{};
      KeyguardStatusService.onAuthTypeDisabledChanged(callback);
      KeyguardStatusService.onLockStateChanged(callback);
      KeyguardStatusService.onModeChanged(callback);
      KeyguardStatusService.onModeChangedUnsubscribe(callback);
      KeyguardStatusService.onPageChanged(callback);
      KeyguardStatusService.subscribeInGeneral(eventType, callback);
      KeyguardStatusService.onPageChangedUnScribe(callback);
      KeyguardStatusService.unsubscribeInGeneral(eventType, callback);
      expect(result).assertEqual(true);
    })

  })
}