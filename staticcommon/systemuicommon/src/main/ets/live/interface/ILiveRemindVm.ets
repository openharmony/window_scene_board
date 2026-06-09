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
import { LiveNotification } from '../model/LiveNotification'

/**
 * 控制实况抢占信息VM（即时、长时、强提醒）
 */
export interface ILiveRemindVm {
  /**
   * 获取当前抢占胶囊
   * @returns 抢占胶囊，获取为空表示当前非抢占场景
   */
  getCurrentRemindCapsule(): LiveNotification | undefined;

  /**
   * 设置抢占胶囊
   */
  setRemindCapsule(live: LiveNotification): void;

  /**
   * 清除当前抢占胶囊
   */
  clearRemindCapsule(): void;

  /**
   * 胶囊是否是当前抢占胶囊
   */
  isCurrentRemindCapsule(live: LiveNotification): boolean;

  /**
   * 检查新增胶囊是否抢占出场
   */
  checkAddCapsuleScene(live: LiveNotification): void;

  /**
   * 检查更新胶囊是否抢占出场
   */
  checkUpdateCapsuleScene(live: LiveNotification): void;

  /**
   * 校验抢占场景是否还存在
   */
  checkCurrentRemindScene(): void;
}