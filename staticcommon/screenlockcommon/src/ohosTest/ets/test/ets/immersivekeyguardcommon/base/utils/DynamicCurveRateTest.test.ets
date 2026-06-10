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

import { it, describe, expect } from '@ohos/hypium';
import { DynamicCurveRate } from '../../../../../../../main/ets/immersivekgcommon/base/utils/DynamicCurveRate';

export function DynamicCurveRateTest() {
  describe('DynamicCurveRateTest', (): void => {
    it('test_initDynamicCurveRate', 0, (): void => {
      let testInstance: DynamicCurveRate = new DynamicCurveRate(10);
      expect(testInstance instanceof DynamicCurveRate).assertTrue();
    });
    it('test_getRate', 0, (): void => {
      let testInstance: DynamicCurveRate = new DynamicCurveRate(10);
      let res = testInstance.getRate(10, 100);
      expect(res !== undefined).assertTrue();
    });
    it('test_setMaxDeltaX', 0, (): void => {
      let testInstance: DynamicCurveRate = new DynamicCurveRate(10);
      let res = testInstance.setMaxDeltaX(10);
      expect(res instanceof DynamicCurveRate).assertTrue();
    });
    it('test_setK', 0, (): void => {
      let testInstance: DynamicCurveRate = new DynamicCurveRate(10);
      let res = testInstance.setK(10);
      expect(res instanceof DynamicCurveRate).assertTrue();
    });
    it('DynamicCurveRateTest_001', 0, (): void => {
      let dynamicCurveR: DynamicCurveRate = new DynamicCurveRate(0);
      let result = dynamicCurveR.getRate(10, 100);
      expect(result).assertEqual(0);
    });
    it('DynamicCurveRateTest_002', 0, (): void => {
      let dynamicCurveR = new DynamicCurveRate(100);
      let result = dynamicCurveR.getRate(10, 100);
      expect(result >= 0).assertTrue();
    });
  });
}
