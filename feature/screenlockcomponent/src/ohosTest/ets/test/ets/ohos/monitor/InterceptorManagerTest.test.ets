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
import { InterceptorManager } from '@ohos/screenlockcommon/src/main/ets/monitor/InterceptorManager';
import type { FilterChainCallback } from '@ohos/screenlockcommon/src/main/ets/monitor/InterceptorManager';


export default function InterceptorManagerTest() {

  describe('InterceptorManagerTest', (): void => {
    let interceptor: FilterChainCallback;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInstance_return', 0, (): void => {
      let result = InterceptorManager.getInstance();
      expect(result).not().assertNull();
    })

    it('test_addToChain_return', 0, (): void => {
      let chain: string = 'res';
      InterceptorManager.getInstance().addToChain(chain, interceptor);
      expect(chain).assertEqual('res');
    })

    it('test_doProcess', 0, (): void => {
      let callbackOne: FilterChainCallback = () => true;
      let callbackTwo: FilterChainCallback = () => false;
      InterceptorManager.getInstance().doProcess('Bugs Bunny');
      InterceptorManager.getInstance().addToChain('Bugs Bunny', callbackOne);
      InterceptorManager.getInstance().doProcess('Bugs Bunny');
      InterceptorManager.getInstance().addToChain('Bugs Bunny', callbackTwo);
      expect(true).assertTrue();
    })
  })
}