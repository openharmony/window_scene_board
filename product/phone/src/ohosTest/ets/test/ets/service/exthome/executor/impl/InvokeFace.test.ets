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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { InvokeFace } from '@ohos/phonebase/src/main/ets/service/exthome/executor/impl/InvokeFace';

/**
 * InvokeFace DT测试套
 */
export default function InvokeFaceTest() {
  describe('InvokeFaceTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('InvokeFace_verifyIdentity_return_true', Level.LEVEL0, async (done: Function) => {
      let invokeFace: InvokeFace = new InvokeFace();
      expect(invokeFace).not().assertNull();
      let result: boolean = await invokeFace.verifyIdentity('com.ohos.sceneboard');
      expect(result).assertTrue();
      done();
    })

    it('InvokeFace_verifyIdentity_return_false', Level.LEVEL0, async (done: Function) => {
      let invokeFace: InvokeFace = new InvokeFace();
      expect(invokeFace).not().assertNull();
      let result: boolean = await invokeFace.verifyIdentity('com.test.test');
      expect(result).assertFalse();
      done();
    })
  })
}