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

import { LiveTimerModel } from '../model/LiveCommonModel'
import { LiveNotification } from '../model/LiveNotification';

/**
 * 实况计时器VM
 */
export interface ILiveTimerVm {
  /**
   * 启动计时
   */
  setLiveTimer(live: LiveNotification): void;

  /**
   * 更新计时
   */
  updateLiveTimer(live: LiveNotification, oldLive: LiveNotification): void;

  /**
   * 删除计时
   */
  deleteLiveTimer(live: LiveNotification, newLive?: LiveNotification): void;

  /**
   * 获取计时器显示文本
   * @param timer 计时数据
   * @returns 显示文本
   */
  getTimerText(timer: LiveTimerModel): string;

  /**
   * 获取计时器无障碍朗读文本
   * @param timer 计时数据
   * @returns 显示文本
   */
  getTimerAccessibilityText(timer: LiveTimerModel): string;
}