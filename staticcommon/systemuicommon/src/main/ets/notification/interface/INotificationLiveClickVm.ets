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

/**
 * 通知中心实况点击管理
 */
export interface INotificationLiveClickVm {
  /**
   * 通知中心实况辅助区点击
   */
  onExtendClick(): Promise<void>;

  /**
   * 通知中心实况关联服务按钮点击
   *
   * @param index 被点击的关联服务按钮的索引
   */
  onButtonClick(index: number): Promise<void>;
}