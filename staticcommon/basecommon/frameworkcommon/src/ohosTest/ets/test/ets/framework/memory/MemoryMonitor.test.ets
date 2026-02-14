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
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { MemoryMonitor } from '../../../../../../main/ets/memory/MemoryMonitor';
import { DEFAULT_PSS_DECIDER, GcDecider } from '../../../../../../main/ets/memory/GcDecider';
import { MemoryInfo } from '../../../../../../main/ets/memory/MemoryInfo';

export function MemoryMonitorTest() {
  describe('MemoryMonitorTest', () => {
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

    it('test_trimMonitorOnce_default_decider', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();

      let emptyInfo = new MemoryInfo();
      let mockFunc = mocker.mockFunc(MemoryMonitor.getInstance(), MemoryMonitor.getInstance().getMemoryInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(emptyInfo);

      await MemoryMonitor.getInstance().startMonitor();
      mocker.mockFunc(DEFAULT_PSS_DECIDER, DEFAULT_PSS_DECIDER.isNeedRequestGc);
      await MemoryMonitor.getInstance().trimMonitorOnce('dtTest', null);
      mocker.verify('isNeedRequestGc', [emptyInfo]).once();
      mocker.clear(MemoryMonitor.getInstance());
      mocker.clearAll();
      done();
    });

    it('test_trimMonitorOnce_dt_decider', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();

      let emptyInfo = new MemoryInfo();
      let mockFunc = mocker.mockFunc(MemoryMonitor.getInstance(), MemoryMonitor.getInstance().getMemoryInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(emptyInfo);

      await MemoryMonitor.getInstance().startMonitor();

      class DtGcDecider implements GcDecider {
        isNeedRequestGc(info: MemoryInfo): boolean {
          return true;
        }

        toString(): string {
          return 'DtGcDecider';
        }
      }

      let dtDecider: DtGcDecider = new DtGcDecider();
      mocker.mockFunc(dtDecider, dtDecider.isNeedRequestGc);
      await MemoryMonitor.getInstance().trimMonitorOnce('dtTest', dtDecider)
      mocker.verify('isNeedRequestGc', [emptyInfo]).once();
      mocker.clear(MemoryMonitor.getInstance());
      mocker.clearAll();
      done();
    });
  })
}