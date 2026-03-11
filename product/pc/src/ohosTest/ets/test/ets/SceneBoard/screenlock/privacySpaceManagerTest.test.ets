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
import { privacySpaceManager, AuthState } from '@ohos/pcbase/src/main/ets/SceneBoard/screenlock/refactor/PrivacySpaceManager';
import osAccount from '@ohos.account.osAccount';

export default function privacySpaceManagerTest() {
  let AccountInfoList: Array<osAccount.OsAccountInfo>;
  describe('privacySpaceManagerTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_updatePrivateUser_return', 0, (): void => {
      let result = privacySpaceManager.updatePrivateUser(AccountInfoList)
      expect(result).not().assertNull();
    })

    it('test_isEnterPrivacySpace_return', 0, (): void => {
      let userId: number = 1;
      privacySpaceManager.isEnterPrivacySpace(userId)
      expect(privacySpaceManager.isToPrivacySpace).assertEqual(false);
    })

  })
}