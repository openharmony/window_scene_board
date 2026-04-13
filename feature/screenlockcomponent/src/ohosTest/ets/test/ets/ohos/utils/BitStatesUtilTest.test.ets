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
import { BitStatesUtil }  from '@ohos/screenlockcommon/src/main/ets/utils/BitStatesUtil';

export default function BitStatesUtilTest() {

  describe('BitStatesUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_hasState_should_return', 0, (): void => {
      let states: number = 1;
      let value: number = 2;
      BitStatesUtil.hasState(states,value);
      let result = states & value;
      expect(result !== 0).assertEqual(false);
    })
    it('test_addState_should_return', 0, (): void => {
      let states: number = 1;
      let value: number = 2;
      BitStatesUtil.addState(states,value);
      expect(states).assertEqual(1);
    })
    it('test_removeState_should_return', 0, (): void => {
      let states: number = 0;
      let value: number = 0;
      BitStatesUtil.removeState(states,value);
      expect(states).assertEqual(0);
    })

  })
}