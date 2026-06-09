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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import OuterHomeRemoteService from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/idlService/OuterHomeRemoteService'
import IdlOuterHomeServiceProxy from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/idlService/IdlOuterHomeServiceProxy';

export default function IdlOuterHomeServiceProxyTest() {
  describe('IdlOuterHomeServiceProxyTest', () => {

    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_IdlOuterHomeServiceProxyTest_getScreenOffDelayOfOuterHome', 0, () => {
      let serviceAbility = new OuterHomeRemoteService(GlobalContext.getContext());
      let callback = (code: number, value: number) => {
        serviceAbility.disConnect();
      };
      let thenCallback = (proxy: IdlOuterHomeServiceProxy) => {
        proxy.getScreenOffDelayOfOuterHome(callback);
      };
      let catchCallback = (err: Error) => {
        serviceAbility.disConnect();
      };
      try {
        serviceAbility.getProxy()
          .then(thenCallback)
          .catch(catchCallback);
      }
      catch (e) {
        expect(false).assertFalse();
      }
    })
  })
}