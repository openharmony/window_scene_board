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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { ObjUtil } from '../../../../../../main/ets/utils/ObjUtil';

export function ObjUtilTest() {
  describe('ObjUtilTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('ObjUtilTest_isInvalid', 0, (): void=> {
      expect(ObjUtil.isInvalid(null)).assertTrue();
      expect(ObjUtil.isInvalid(undefined)).assertTrue();
      expect(ObjUtil.isInvalid('test')).assertFalse();
    })
    it('ObjUtilTest_isValid', 0, (): void=> {
      expect(ObjUtil.isValid(null)).assertFalse();
      expect(ObjUtil.isValid('test')).assertTrue();
    })
    it('ObjUtilTest_keys', 0, (): void=> {
      expect(ObjUtil.keys({a:1,b:2})).assertDeepEquals(['a','b'])
    })
    it('ObjUtilTest_requireNonNull', 0, (): void => {
      expect(ObjUtil.requireNonNull({ a: 1, b: 2 })).not().assertNull();
    })
    it('requireNonNull', 0, (): void => {
      try {
        ObjUtil.requireNonNull(null)
      } catch (e) {
        expect(e.message).assertEqual('obj is illegal!')
      }
    })
    it('setNested', 0, (): void => {
      expect(ObjUtil.setNested({a: 1, b: 2}, [], 1) === undefined).assertTrue();
      expect(ObjUtil.setNested({a: 1, b: 2}, 'want.parameters.fileManagerMode', 1) === undefined).assertTrue();
    })
  })
}