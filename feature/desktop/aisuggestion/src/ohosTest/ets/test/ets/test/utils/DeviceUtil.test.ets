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

import display from '@ohos.display';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { DeviceUtil } from '../../../../../../main/ets/default/utils/DeviceUtil';

const FOLD_STATE_EXPAND_WITH_SECOND_EXPAND: number = 11;

/**
 * LanguageUtil测试
 *
 * @since 2025-06-11
 */
export default function DeviceUtilTest() {
  describe('getActualFoldStatus_testSuite', () => {


    it('atc_should_return_FOLD_STATUS_EXPANDED_when_status_is_FOLD_STATUS_HALF_FOLDED', 0, () => {
      const result: ESObject = DeviceUtil.getActualFoldStatus(display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
      expect(result).assertEqual(display.FoldStatus.FOLD_STATUS_EXPANDED);
    });

    it('atc_should_return_FOLD_STATUS_FOLDED_when_status_is_22_or_12', 0, () => {
      const result1: ESObject = DeviceUtil.getActualFoldStatus(22);
      const result2: ESObject = DeviceUtil.getActualFoldStatus(12);
      expect(result1).assertEqual(display.FoldStatus.FOLD_STATUS_FOLDED);
      expect(result2).assertEqual(display.FoldStatus.FOLD_STATUS_FOLDED);
    });

    it('atc_should_return_FOLD_STATE_EXPAND_WITH_SECOND_EXPAND_when_status_is_13_or_23_or_21', 0, () => {
      const result1: ESObject = DeviceUtil.getActualFoldStatus(13);
      const result2: ESObject = DeviceUtil.getActualFoldStatus(23);
      const result3: ESObject = DeviceUtil.getActualFoldStatus(21);
      expect(result1).assertEqual(FOLD_STATE_EXPAND_WITH_SECOND_EXPAND);
      expect(result2).assertEqual(FOLD_STATE_EXPAND_WITH_SECOND_EXPAND);
      expect(result3).assertEqual(FOLD_STATE_EXPAND_WITH_SECOND_EXPAND);
    });

    it('atc_should_return_status_itself_when_status_is_not_in_the_above_conditions', 0, () => {
      const result: ESObject = DeviceUtil.getActualFoldStatus(display.FoldStatus.FOLD_STATUS_EXPANDED);
      expect(result).assertEqual(display.FoldStatus.FOLD_STATUS_EXPANDED);
    });
  });
}