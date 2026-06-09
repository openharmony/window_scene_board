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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { OuterHomeManager } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/common/OuterHomeManager';
import { AppSwitchContinuation } from '@ohos/phonebase/src/main/ets/service/singlepocket/executor/impl/AppSwitchContinuation';


/**
 * AppSwitchContinuation DT测试套
 */
export default function AppSwitchContinuationTest() {
  describe('AppSwitchContinuationTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('appSwitchContinuation_execute_return_true', Level.LEVEL0, (): void => {
      let appSwitchContinuation: AppSwitchContinuation = new AppSwitchContinuation();
      appSwitchContinuation.execute(true);
      let result: boolean = OuterHomeManager.getInstance().getAppSwitchContinuation()
      expect(result).assertEqual(true);
    })

    it('appSwitchContinuation_execute_return_false', Level.LEVEL0, (): void => {
      let appSwitchContinuation: AppSwitchContinuation = new AppSwitchContinuation();
      appSwitchContinuation.execute(false);
      let result: boolean = OuterHomeManager.getInstance().getAppSwitchContinuation()
      expect(result).assertEqual(false);
    })
  })
}