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
import { DEFAULT_PSS_DECIDER } from '@ohos/frameworkcommon/src/main/ets/memory/GcDecider';
import { MemoryInfo } from '@ohos/frameworkcommon/src/main/ets/memory/MemoryInfo';
import { PssGcDecider } from '@ohos/frameworkcommon/src/main/ets/TsIndex';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';

export function GcDeciderTest() {
  describe('GcDeciderTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('checkDefaultPssGcDecider', 0, (): void => {
      expect(DEFAULT_PSS_DECIDER.isNeedRequestGc(null)).assertFalse();
      expect(DEFAULT_PSS_DECIDER.isNeedRequestGc(undefined)).assertFalse();
      let memoryInfo: MemoryInfo = new MemoryInfo();
      memoryInfo.pss = DEFAULT_PSS_DECIDER.monitorPss + BigInt(1);
      memoryInfo.nativeHeap = BigInt(200 * 1024);
      expect(DEFAULT_PSS_DECIDER.isNeedRequestGc(memoryInfo)).assertTrue();
    })

    it('checkBigPssGcDecider', 0, (): void => {
      let memoryInfo: MemoryInfo = new MemoryInfo();
      memoryInfo.pss = BigInt(500 * 1024);
      memoryInfo.nativeHeap = BigInt(200 * 1024);
      let tempDecider = new PssGcDecider(BigInt(800 * 1024));
      expect(tempDecider.isNeedRequestGc(memoryInfo)).assertFalse();
    })

    it('checkSmallPssGcDecider', 0, (): void => {
      let memoryInfo: MemoryInfo = new MemoryInfo();
      memoryInfo.pss = BigInt(500 * 1024);
      memoryInfo.nativeHeap = BigInt(200 * 1024);
      let tempDecider = new PssGcDecider(BigInt(200 * 1024));
      expect(tempDecider.isNeedRequestGc(memoryInfo)).assertTrue();
    })
  })
}