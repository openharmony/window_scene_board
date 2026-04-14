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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { recentLayoutConfigInstance } from '../../../../../../main/ets/default/common/RecentLayoutConfig';

let recentLayoutConfig = recentLayoutConfigInstance;
export function RecentLayoutConfigTest() {
  describe('RecentLayoutConfigTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('RecentLayoutConfig_test_getInstance', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentLayoutConfig).not().assertFail();
    })

    it('RecentLayoutConfig_test_should_return_true_when_updateMultiRowLayout_input_true', 0, (): void => {
      recentLayoutConfig.updateMultiRowLayout(true);
      expect(recentLayoutConfig.isNeedMultiRowLayout()).assertTrue();
    })

    it('RecentLayoutConfig_test_should_return_false_when_updateMultiRowLayout_input_false', 0, (): void => {
      recentLayoutConfig.updateMultiRowLayout(false);
      expect(recentLayoutConfig.isNeedMultiRowLayout()).assertFalse();
    })

    it('RecentLayoutConfig_test_should_return_true_when_updateMultiRowLayout_input_false_and_true', 0, (): void => {
      recentLayoutConfig.updateMultiRowLayout(false);
      recentLayoutConfig.updateMultiRowLayout(true);
      expect(recentLayoutConfig.isNeedMultiRowLayout()).assertTrue();
    })

    it('RecentLayoutConfig_test_should_return_false_when_updateMultiRowLayout_input_true_and_false', 0, (): void => {
      recentLayoutConfig.updateMultiRowLayout(true);
      recentLayoutConfig.updateMultiRowLayout(false);
      expect(recentLayoutConfig.isNeedMultiRowLayout()).assertFalse();
    })
  })
}