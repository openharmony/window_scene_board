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
import { BaseCommand } from '../../../../../../main/ets/default/command/BaseCommand';
import { DataConverter } from '../../../../../../main/ets/default/utils/DataConverter';

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

    it('DataConverterTest_convertPortfolioInfo', 0, async (done: Function): Promise<void> => {
      let instance: DataConverter = new DataConverter();
      expect(await (instance as object)['convertPortfolioInfo'](undefined)).not().assertTrue();
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