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

import { LiveNotification } from '../model/LiveNotification'

export interface ILiveHeadsUpCardVm {
  /**
   * 实况数据
   */
  live?: LiveNotification;

  /**
   * 显示实况横幅
   * @param live
   * @param preemption 实况横幅之间是否为抢占出场，抢占出场不需要等融球动效
   */
  show(live: LiveNotification, preemption?: boolean): Promise<void>;

  /**
   * 更新实况横幅
   * @param live
   */
  update(live: LiveNotification): Promise<void>;

  /**
   * 隐藏实况横幅
   */
  hide(): Promise<void>;

  /**
   * 检查该消息是否应该显示
   */
  isNeedShow(live: LiveNotification): boolean;

  /**
   * 动态设置卡片热区
   */
  setCardResponseRegion(isRotate: boolean): void;
}