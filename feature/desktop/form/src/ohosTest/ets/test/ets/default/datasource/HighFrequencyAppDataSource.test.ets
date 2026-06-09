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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, TestType,
  MockKit,
  when} from '@ohos/hypium';
import HighFrequencyAppDataSource from '../../../../../../main/ets/default/datasource/HighFrequencyAppDataSource';
import FormConstants from '../../../../../../main/ets/default/common/constants/FormConstants';
import { CardItemInfo } from '@ohos/launchercommon';
import RecommendCardsDataPool from '../../../../../../main/ets/default/datapool/RecommendCardsDataPool';
import AppFormWeightManager from '../../../../../../main/ets/default/manager/AppFormWeightManager';

export function HighFrequencyAppDataSourceTest() {
  describe('HighFrequencyAppDataSourceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('HighFrequencyAppDataSourceTest_getName', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: HighFrequencyAppDataSource = HighFrequencyAppDataSource.getInstance();
      const rstName: string = dataSource.getName();
      expect(rstName).assertEqual('HighFrequencyAppDataSource');
    });

    it('HighFrequencyAppDataSourceTest_getThreshold', TestType.FUNCTION | Level.LEVEL0, () => {
      const dataSource: HighFrequencyAppDataSource = HighFrequencyAppDataSource.getInstance();
      const threshold: number = dataSource.getThreshold();
      expect(threshold).assertEqual(FormConstants.SERVICE_FORM_POOL_HIGH_FREQUENCY_APP_THRESHOLD);
    });

    it('HighFrequencyAppDataSourceTest_001', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mocker2: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RecommendCardsDataPool, RecommendCardsDataPool.getInstance);
      let mockFunc2: Function = mocker2.mockFunc(AppFormWeightManager, AppFormWeightManager.getInstance);
      when(mockFunc)().afterReturn({
        getAllDataMap() {
          const m = new Map<string, CardItemInfo>();
          m.set('a', new CardItemInfo());
          return m
        }
      });

      when(mockFunc2)().afterReturn({
        getSortedAppUsageWeight() {
          const arr: string[][] = new Array(FormConstants.SERVICE_FORM_POOL_HIGH_FREQUENCY_APP_THRESHOLD + 2).fill(0).map(() => ['a']);
          arr[1] = ['b'];
          return arr
        }
      });

      const dataSource: HighFrequencyAppDataSource = HighFrequencyAppDataSource.getInstance();
      const ret = dataSource['getInitDataList']();
      expect(ret.length === undefined).assertFalse();
      mocker.clear(RecommendCardsDataPool);
      mocker2.clear(AppFormWeightManager);
      mocker.clearAll();
      mocker2.clearAll();
    });
  })
}