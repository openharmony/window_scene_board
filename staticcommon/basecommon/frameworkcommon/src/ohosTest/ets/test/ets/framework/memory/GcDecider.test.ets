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
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { MemoryInfo } from '../../../../../../main/ets/memory/MemoryInfo';
import { ClearMissionFullGcDecider, PssGcDecider } from '../../../../../../main/ets/memory/GcDecider';
import { DEFAULT_MEMORY_GC_PSS_KB, MemoryUtils } from '@hw-ohos/memorytool';

export function GcDeciderTest() {
  describe('GcDeciderTest', () => {
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
    it('test_PssGcDecider', 0, () => {
      expect(new PssGcDecider(null).monitorPss).assertEqual(DEFAULT_MEMORY_GC_PSS_KB);
      expect(new PssGcDecider(BigInt(1)).monitorPss).assertEqual(BigInt(1));
    })
    it('test_isNeedRequestGc', 0, () => {
      let tempInfo: MemoryInfo = new MemoryInfo();
      tempInfo.pss = BigInt(102400);
      expect(new PssGcDecider(BigInt(51200)).isNeedRequestGc(tempInfo)).assertTrue();
      expect(new PssGcDecider(BigInt(204800)).isNeedRequestGc(tempInfo)).assertFalse();
      expect(new PssGcDecider(BigInt(204800)).isNeedRequestGc(new MemoryInfo())).assertFalse();
      expect(new PssGcDecider(BigInt(204800)).isNeedRequestGc(null)).assertFalse();
    })
    it('test_ClearMissionFullGcDecider', 0, () => {
      expect(new ClearMissionFullGcDecider(BigInt(204800)).isNeedRequestGc(null))
        .assertEqual(MemoryUtils.isMemoryScene());
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(MemoryUtils, MemoryUtils.isMemoryScene);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(new ClearMissionFullGcDecider(BigInt(204800)).isNeedRequestGc(null)).assertEqual(false);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(new ClearMissionFullGcDecider(BigInt(204800)).isNeedRequestGc(null)).assertEqual(true);
      mocker.clear(MemoryUtils);
      mocker.clearAll();
    })
  })
}