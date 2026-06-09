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

// 沉浸胶囊强提醒业务抽象层
export interface IImmCapRemindVm {
  /**
   * 强提醒翻转动效启动回调
   */
  onRemindAnimStart(): void;

  /**
   * 当前沉浸状态是否为胶囊态状态切换
   *
   * @param isCapState true胶囊态
   */
  onCapStateChange(isCapState: boolean): void;

  /**
   * 当前状态是否为AOD状态切换
   *
   * @param isAodState true AOD
   */
  onAodStateChange(isAodState: boolean): void;

  /**
   * 强提醒胶囊动效状态切换
   *
   * @param isAnimating true动效中
   */
  onRemindAnimStChange(isAnimating?: boolean): void;
}