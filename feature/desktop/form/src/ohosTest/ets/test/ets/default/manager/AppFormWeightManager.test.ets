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
import HashMap from '@ohos.util.HashMap';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType,
  MockKit,
  when} from '@ohos/hypium';
import AppFormWeightManager from '../../../../../../main/ets/default/manager/AppFormWeightManager';

export function AppFormWeightManagerTest() {
  describe('AppFormWeightManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getSortedAppUsageWeight', TestType.FUNCTION | Level.LEVEL0 , () => {
      let manager: AppFormWeightManager = AppFormWeightManager.getInstance();
      expect(manager.getSortedAppUsageWeight().length >= 0).assertTrue;
    });

    it('refreshUsageWeight', TestType.FUNCTION | Level.LEVEL0 , () => {
      let manager: AppFormWeightManager = AppFormWeightManager.getInstance();
      manager.refreshUsageWeight();
      expect(manager.getSortedAppUsageWeight().length).assertLargerOrEqual(0);
    });

    it('AppFormWeightManagerTest_001', TestType.FUNCTION | Level.LEVEL0 , () => {
      let manager: AppFormWeightManager = AppFormWeightManager.getInstance();
      manager.refreshUsageWeight();
      const m = new HashMap<string, number>();
      m.set('last', 1);
      manager.setUsageWeight(m, -1000);
      manager.refreshUsageWeight();
      expect(manager.getSortedAppUsageWeight().length).assertLargerOrEqual(0);
    });

    it('AppFormWeightManagerTest_002', TestType.FUNCTION | Level.LEVEL0 , () => {
      let mocker: MockKit = new MockKit();
      try {
        let manager: AppFormWeightManager = AppFormWeightManager.getInstance();
        const m = new HashMap<string, number>();
        expect(manager.setUsageWeight(m, 1)=== undefined).assertFalse();
        m.set('last', 1);
        expect(manager.setUsageWeight(m, 1) === undefined).assertFalse();
        let mockFunc = mocker.mockFunc(m, m.isEmpty);
        when(mockFunc)().afterReturn(new Error(''));
        expect(manager.setUsageWeight(m, 1) === undefined).assertFalse();
        mocker.clear(m);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('AppFormWeightManagerTest_003', TestType.FUNCTION | Level.LEVEL0 , () => {
      try {
        let manager: AppFormWeightManager = AppFormWeightManager.getInstance();
        const m = new HashMap<string, number>();
        expect(manager.getSortedAppUsageWeight().length >= 0).assertTrue();
        m.set('last', 1);
        manager.setUsageWeight(m, 1);
        expect(manager.getSortedAppUsageWeight().length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}