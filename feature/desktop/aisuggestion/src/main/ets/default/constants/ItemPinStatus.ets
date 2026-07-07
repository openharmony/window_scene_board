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

/**
 * 卡片/图标 Pin 状态
 *
 * @since 2023-08-11
 */
export const enum ItemPinStatus {
  /**
   * 不支持PIN
   */
  NOT_SUPPORT_PIN = 0,
  /**
   * 未PIN
   */
  UNPIN = 1,
  /**
   * 已经 PIN
   */
  PINED = 2
}