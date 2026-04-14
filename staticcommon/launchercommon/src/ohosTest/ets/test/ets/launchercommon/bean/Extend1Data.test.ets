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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Extend1Data, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex'

export default function Extend1DataTest() {
  describe('Extend1DataTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_getCardSourceTypeOfOne', 0, () => {
      expect(Extend1Data.getCardSourceType('')).assertUndefined()
    });
    it('test_getCardSourceTypeTwo', 0, () => {
      let extend1Data: Extend1Data = new Extend1Data();
      extend1Data.parameters?.set('ohos.extra.param.key.source_type', () => 1);
      const str = JSON.stringify(extend1Data);
      expect(Extend1Data.getCardSourceType(str)).not().assertUndefined();
      extend1Data.parameters?.clear();
      expect(Extend1Data.getCardSourceType(str)).assertEqual('');
    });

    it('test_unsetMigrateForm', 0, () => {
      let extend1Data: Extend1Data = new Extend1Data();
      expect(Extend1Data.unsetMigrateForm(JSON.stringify(extend1Data))).assertInstanceOf('String');
      expect(Extend1Data.unsetMigrateForm('')).assertInstanceOf('String');
      extend1Data.parameters = new Map();
      expect(Extend1Data.unsetMigrateForm(JSON.stringify(extend1Data))).assertInstanceOf('String');
    })

    it('test_setCardSourceType', 0, () => {
      let extend1Data: Extend1Data = new Extend1Data();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      Extend1Data.setCardSourceType(undefined,'1');
      gridLayoutItemInfo.extend1 = JSON.stringify(extend1Data);
      Extend1Data.setCardSourceType(gridLayoutItemInfo,'1');
      extend1Data.parameters = new Map();
      Extend1Data.setCardSourceType(gridLayoutItemInfo,'1');
      expect(gridLayoutItemInfo.extend1).assertInstanceOf('String');
    })

    it('test_getCardSourceType', 0, () => {
      let extend1Data: Extend1Data = new Extend1Data();
      extend1Data.parameters = new Map();
      expect(Extend1Data.getCardSourceType(JSON.stringify(extend1Data))).assertEqual('');
    })

    it('test_setMigrateForm', 0, () => {
      let extend1Data: Extend1Data = new Extend1Data();
      expect(Extend1Data.setMigrateForm(JSON.stringify(extend1Data))).assertInstanceOf('String');
      extend1Data.parameters = new Map();
      expect(Extend1Data.setMigrateForm(JSON.stringify(extend1Data))).assertInstanceOf('String');
    })
  })
}