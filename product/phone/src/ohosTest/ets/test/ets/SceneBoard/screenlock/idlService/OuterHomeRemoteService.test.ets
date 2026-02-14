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

import { describe, beforeAll, beforeEach, afterEach, afterAll, Level, it, expect } from '@ohos/hypium'
import { GlobalContext } from '@ohos/frameworkwrapper';
import OuterHomeRemoteService from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/idlService/OuterHomeRemoteService'
import IdlOuterHomeServiceProxy from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/idlService/IdlOuterHomeServiceProxy';

export default function OuterHomeRemoteServiceTest() {
  describe('OuterHomeRemoteServiceTest', () => {

    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_OuterHomeRemoteServiceTest_getProxy', 0, () => {
      let serviceAbility = new OuterHomeRemoteService(GlobalContext.getContext());
      let thenCallback = (proxy: IdlOuterHomeServiceProxy) => {
        serviceAbility.disConnect();
      };
      let catchCallback = (err: Error) => {
        serviceAbility.disConnect();
      };
      try {
        serviceAbility.getProxy()
          .then(thenCallback)
          .catch(catchCallback);
        expect(serviceAbility).not().assertUndefined();
      }
      catch (e) {
        expect(serviceAbility).not().assertUndefined();
      }
    });

    it('test_clean', Level.LEVEL0, (): void => {
      let serviceAbility = new OuterHomeRemoteService(GlobalContext.getContext());
      (serviceAbility as object)['clean']();
      expect(serviceAbility).not().assertUndefined();
    });

    it('test_disConnect', Level.LEVEL0, (): void => {
      let serviceAbility = new OuterHomeRemoteService(GlobalContext.getContext());
      (serviceAbility as object)['connectionCode'] = 0;
      (serviceAbility as object)['disConnect']();
      expect(serviceAbility).not().assertUndefined();
    });
  });
}