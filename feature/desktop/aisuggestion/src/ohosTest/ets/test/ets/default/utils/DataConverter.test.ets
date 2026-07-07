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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { InputRefreshData } from '../../../../../../main/ets/default/bean/InputRefreshData';
import { BaseCommand } from '../../../../../../main/ets/default/command/BaseCommand';
import { DataConverter } from '../../../../../../main/ets/default/utils/DataConverter';
import { InputComposedData } from '../../../../../../main/ets/default/bean/InputComposedData';

export default function DataConverterTest() {
  describe('DataConverterTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('DataConverterTest_convertToCommands_01', 0, async (done: Function): Promise<void> => {
      let instance: DataConverter = new DataConverter();
      let results: Map<Number, Map<string, BaseCommand[]>> = await instance.convertToCommands([]);
      expect(results.size).assertEqual(0);
      done();
    });

    it('DataConverterTest_convertToCommands_02', 0, async (done: Function): Promise<void> => {
      let instance: DataConverter = new DataConverter();
      const lists: InputRefreshData[] = [];
      const items1: InputRefreshData = new InputRefreshData();
      items1.formIds = [];
      items1.dataList = [];
      lists.push(items1);
      const items2: InputRefreshData = new InputRefreshData();
      items2.formIds = ['123'];
      items2.dataList = [];
      lists.push(items2);
      const items3: InputRefreshData = new InputRefreshData();
      items3.formIds = ['345'];
      items3.dataList = [];
      const refreshData: InputComposedData = new InputComposedData();
      refreshData.optType = AiSuggestionUpdateConstants.OptType.SWITCH_CARD;
      items3.dataList.push(refreshData);
      const items4: InputRefreshData = new InputRefreshData();
      items4.formIds = ['345'];
      items4.dataList = [];
      const refreshData1: InputComposedData = new InputComposedData();
      refreshData1.optType = AiSuggestionUpdateConstants.OptType.ADD_CARD;
      refreshData1.stackId = '';
      items4.dataList.push(refreshData1);
      lists.push(items4);

      let results: Map<Number, Map<string, BaseCommand[]>> = await instance.convertToCommands(lists);
      expect(results.size).assertEqual(3);
      done();
    });


    it('DataConverterTest_convertCardResourceInfo', 0, async (done: Function): Promise<void> => {
      let instance: DataConverter = new DataConverter();
      expect(await (instance as object)['convertCardResourceInfo'](undefined)).not().assertTrue();
      done();
    });

    it('DataConverterTest_convertDisplayData', 0, async (done: Function): Promise<void> => {
      let instance: DataConverter = new DataConverter();
      expect(await (instance as object)['convertDisplayData'](undefined)).not().assertTrue();
      done();
    });
  });
}