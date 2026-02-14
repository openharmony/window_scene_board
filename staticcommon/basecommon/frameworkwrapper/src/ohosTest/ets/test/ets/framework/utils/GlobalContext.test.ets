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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, Size, TestType } from '@ohos/hypium';
import { GlobalContext } from '../../../../../../main/ets/utils/GlobalContext';

export function GlobalContextTest() {
  describe('GlobalContextTest', (): void => {
    let globalContext: GlobalContext = GlobalContext.getInstance();
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('setObject01', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, (): void => {
      let key = 'a';
      let objectClass = '1';
      globalContext.setObject(key, objectClass);
      expect(globalContext.getObject(key)).assertEqual(objectClass)
    })
    it('setObject02', 0, (): void => {
      let key = 'b';
      let objectClass = '1';
      globalContext.setObject(key, objectClass);
      expect(globalContext.getObject(key)).assertEqual(objectClass)
    })
    it('setObject03', 0, (): void => {
      let key = 'a';
      let objectClass = '2';
      globalContext.setObject(key, objectClass);
      expect(globalContext.getObject(key)).assertEqual(objectClass)
    })
    it('getObject01', 0, (): void => {
      let key = 'a';
      expect(globalContext.getObject(key)).assertEqual('2')
    })
    it('getObject02', 0, (): void => {
      let key = 'c';
      expect(globalContext.getObject(key)).assertEqual(undefined)
    })
    it('hasObject01', 0, (): void => {
      let key = 'a';
      expect(globalContext.hasObject(key)).assertTrue()
    })
    it('hasObject02', 0, (): void => {
      let key = 'c';
      expect(globalContext.hasObject(key)).assertFalse()
    })
  })
}