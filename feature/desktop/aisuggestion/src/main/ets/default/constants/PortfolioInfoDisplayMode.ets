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
 * 场景栏显示模式
 *
 * @since 2023-11-11
 */
export const enum PortfolioInfoDisplayMode {
  /**
   * 可见3s后消失
   */
  DISPLAY_MODE_DISAPPEAR = 0,

  /**
   * 常驻显示
   */
  DISPLAY_MODE_EXIST = 1,

  /**
   * 不显示
   */
  DISPLAY_MODE_NOT_EXIST = 2
}