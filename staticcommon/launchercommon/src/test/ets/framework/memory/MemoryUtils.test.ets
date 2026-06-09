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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import systemparameter from '@ohos.systemparameter';

export function MemoryUtilsTest() {
  describe('MemoryUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('checkPss', 0, (): void => {
      let pss: bigint = MemoryUtils.getPss();
      expect(pss === ERROR_PSS).assertFalse();
    })
    it('checkNativeHeap', 0, (): void => {
      let nativeHeap: bigint = MemoryUtils.getNativeHeapSize();
      expect(nativeHeap === ERROR_PSS).assertFalse();
    })
    it('testKeyMemoryManageEnable', 0, (): void => {
      expect(MemoryUtils.isMemoryManagerEnable()).assertEqual(DEFAULT_MEMORY_MANAGE_ENABLE);
      setSystemParams(KEY_MEMORY_MANAGE_ENABLE, 'true');
      expect(MemoryUtils.isMemoryManagerEnable()).assertTrue();
      setSystemParams(KEY_MEMORY_MANAGE_ENABLE, 'false');
      expect(MemoryUtils.isMemoryManagerEnable()).assertFalse();
    })
    it('testKeyMemoryMonitorInterval', 0, (): void => {
      expect(MemoryUtils.getMemoryMonitorInterval()).assertEqual(DEFAULT_MEMORY_MONITOR_INTERVAL);
      setSystemParams(KEY_MEMORY_MONITOR_INTERVAL, '15000');
      expect(MemoryUtils.getMemoryMonitorInterval()).assertEqual(15000);
      setSystemParams(KEY_MEMORY_MONITOR_INTERVAL, '3600000');
      expect(MemoryUtils.getMemoryMonitorInterval()).assertEqual(3600000);
    })
    it('testKeyMemoryPssThreshold', 0, (): void => {
      expect(MemoryUtils.getDefaultPssThreshold()).assertEqual(DEFAULT_MEMORY_GC_PSS_KB);
      setSystemParams(KEY_MEMORY_PSS_THRESHOLD, BigInt(500 * 1024).toString());
      expect(MemoryUtils.getDefaultPssThreshold()).assertEqual(BigInt(500 * 1024));
      setSystemParams(KEY_MEMORY_PSS_THRESHOLD, BigInt(200 * 1024).toString());
      expect(MemoryUtils.getDefaultPssThreshold()).assertEqual(BigInt(200 * 1024));
    })
  })
}

function setSystemParams(key: string, value: string): void {
  systemparameter.setSync(key, value);
}