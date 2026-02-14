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
export { BaseViewController } from './manager/view/BaseViewController';

export { MemoryManager, IS_IN_TEST_END_PHRASE as IS_IN_END } from './memory/MemoryManager';

export { GridLayoutMemoryOptimizer, GridlayoutMemoryListener, MemoryStateEx } from './memory/MemoryOptimizer';

export { PerformanceReporter, CurrentMemScene, CurrentCpuScene } from './memory/PerformanceReporter';

export { MemoryMonitor } from './memory/MemoryMonitor';

export { ClearMissionFullGcDecider, PssGcDecider } from './memory/GcDecider';

export { TrimScene } from './memory/MemoryManager';

export { GcMonitorStrategy, TrimStrategy } from './memory/StrategyFactory';

export { PhoneStrategyFactory, StrategyFactory } from './memory/StrategyFactory';

export { AppItemInfoBase } from './bean/AppItemInfoBase';