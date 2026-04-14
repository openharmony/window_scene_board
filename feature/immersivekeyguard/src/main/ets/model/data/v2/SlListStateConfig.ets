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

import { BaseStateConfig } from '@ohos/screenlockcommon/Index';
import { SlListConfigStateV2 } from './SlListConfigStateV2';

/**
 * 列表状态配置
 */
export class SlListStateConfig extends BaseStateConfig<SlListConfigStateV2> {
  /**
   * 实例构造
   *
   * @param name 配置名
   * @returns 配置实例
   */
  public static wrap(name: string): SlListStateConfig {
    return new SlListStateConfig(name);
  }
}