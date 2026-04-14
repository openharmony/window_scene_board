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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {OuterAppManager} from  '../../../../../../main/ets/manager/OuterAppManager';

export default function OuterAppManagerTest() {
  describe('OuterAppManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('OuterAppManagerTest_01', 0, async (done: Function) => {
      let result = OuterAppManager.getInstance().isFilterCard('com.openharmony.health', false, true);
      expect(result === true).assertTrue();
      done();
    })
    it('OuterAppManagerTest_02', 0, async (done: Function) => {
      let result = OuterAppManager.getInstance().isFilterCard('com.ohos.litegames', false, false);
      expect(result === false).assertTrue();
      done();
    })
    it('OuterAppManagerTest_03', 0, async (done: Function) => {
      let result = OuterAppManager.getInstance().isFilterCard('com.ohos.hiskytone', false, false);
      expect(result === true).assertTrue();
      done();
    })
    it('OuterAppManagerTest_04', 0, async (done: Function) => {
      let result = OuterAppManager.getInstance().isFilterCard('', false, false);
      expect(result === true).assertTrue();
      done();
    })
  })
}
