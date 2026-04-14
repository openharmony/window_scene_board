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
import { ClockLayout } from '../../../common/WidgetParam';
import { BaseClockStyleConfig } from './BaseClockStyleConfig';

/**
 * 时钟样式配置
 */
export class ClockStyleConfig extends BaseClockStyleConfig {
  /**
   * 实例构造
   *
   * @param clockLayout 时钟样式类型
   * @returns 样式配置
   */
  public static wrap(clockLayout: ClockLayout): ClockStyleConfig {
    return new ClockStyleConfig(clockLayout ?? ClockLayout.DEFAULT_CLOCK_LAYOUT);
  }

  /**
   * 样式复制
   *
   * @param clockLayout 样式类型
   * @returns 复制实例
   */
  public copy(clockLayout?: ClockLayout): ClockStyleConfig {
    const newCfg = new ClockStyleConfig(clockLayout ?? this.getClockLayout());
    super.copyProperties(newCfg);
    return newCfg;
  }
}