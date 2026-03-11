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

import { afterAll, afterEach, beforeAll, beforeEach, describe, Level, expect, it } from '@ohos/hypium';
import { OuterHomeManager } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/common/OuterHomeManager';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import { SCBScreenSessionManager } from '@ohos/windowscene';

export default function OuterHomeManagerTest() {

  describe('OuterHomeManagerTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_OuterHomeManagerTest_doOuterHomeScreenOff', 0, (): void => {
      let manager = OuterHomeManager.getInstance() as object;
      MockUtil.mockFuncForObj(SCBScreenSessionManager.getInstance(), 'notifyScreenLockEvent');
      try {
        manager['doOuterHomeScreenOff']();
      } catch (e) {
        expect(false).assertFalse();
      }
      MockUtil.clearAll();
    });

    it('test_OuterHomeManagerTest_clearTimer', 0, async (): Promise<void> => {
      let manager = OuterHomeManager.getInstance() as object;
      MockUtil.mockFuncForObj(SCBScreenSessionManager.getInstance(), 'notifyScreenLockEvent');
      try {
        await manager['doOuterHomeScreenOff']();
        manager['clearTimer']();
      } catch (e) {
        expect(false).assertFalse();
      }
      MockUtil.clearAll();
    });

    it('test_OuterHomeManagerTest_registerPowerKeyDown', 0, async (): Promise<void> => {
      try {
        let manager = OuterHomeManager.getInstance() as object;
        manager['registerPowerKeyDown']();
        manager['unRegisterPowerKeyDown']();
      } catch (e) {
        expect(false).assertFalse();
      }
    });
  })
}