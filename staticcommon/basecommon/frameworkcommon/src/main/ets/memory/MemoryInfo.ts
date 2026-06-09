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

const TAG = 'MemoryInfo';

/**
 * 内存信息类
 *
 * @since 2023-11-04
 */
export class MemoryInfo {
  /**
   * 进程总占用pss值
   * 单位KB
   */
  public pss: bigint = BigInt(0);

  /**
   * 进程占用native heap pss值
   * 单位KB
   */
  public nativeHeap: bigint = BigInt(0);

  public static toString(info: MemoryInfo): String {
    return `memory:[pss:${info?.pss?.toString()}KB,native:${info?.nativeHeap?.toString()}KB]`;
  }
}
