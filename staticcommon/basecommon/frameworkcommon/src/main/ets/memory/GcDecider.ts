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
import type { MemoryInfo } from './MemoryInfo';

/**
 * Gc决策接口定义
 *
 *
 * @since 2023-11-04
 */
export interface GcDecider {
  /**
   * 根据memoryInfo判断是否需要请求触发Gc
   *
   * @param info memoryInfo
   * @returns boolean true or false
   */
  isNeedRequestGc(info: MemoryInfo): boolean;

  /**
   * 打印内容
   *
   * @returns 内容
   */
  toString(): string;
}

/**
 * 基于pss数值监控的Gc决策器
 */
export class PssGcDecider implements GcDecider {
  monitorPss: bigint;

  constructor(monitorPss?: bigint) {
    // this.monitorPss = monitorPss ?? DEFAULT_MEMORY_GC_PSS_KB;
  }

  public isNeedRequestGc(info: MemoryInfo): boolean {
    if (!info || !info.pss) {
      return false;
    }
    return info.pss > this.monitorPss;
  }

  public toString(): string {
    return this.monitorPss.toString();
  }
}

/**
 * 多任务清理场景Gc决策器
 */
export class ClearMissionFullGcDecider extends PssGcDecider {
  public isNeedRequestGc(info: MemoryInfo): boolean {
    // if (MemoryUtils.isMemoryScene()) {
    //   return true;
    // }
    return super.isNeedRequestGc(info);
  }
}

// export const DEFAULT_PSS_DECIDER: PssGcDecider = new PssGcDecider(MemoryUtils.getDefaultPssThreshold());
export const DEFAULT_PSS_DECIDER: PssGcDecider = new PssGcDecider();
