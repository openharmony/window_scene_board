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

import { describe } from '@ohos/hypium';
import { MemoryManagerTest } from './ets/framework/memory/MemoryManager.test';
import { MemoryUtilsTest } from './ets/framework/memory/MemoryUtils.test';
import { MemoryMonitorTest } from './ets/framework/memory/MemoryMonitor.test';
import { MemoryInfoTest } from './ets/framework/memory/MemoryInfo.test';
import { GcDeciderTest } from './ets/framework/memory/GcDecider.test';
import { GcControllerTest } from './ets/framework/memory/GcController.test';
import PerformanceReporterTest from './ets/framework/memory/PerformanceReporter.test';

export default function PipelineDemoSuite() {
  describe("sceneboard_framework",  () => {
    MemoryManagerTest();
    MemoryUtilsTest();
    MemoryMonitorTest();
    MemoryInfoTest();
    GcDeciderTest();
    GcControllerTest();
    PerformanceReporterTest();
  });
}