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
 * 窗口常量
 */
export class StatusBarAnimConstants {
  /**
   * 出入场动效起始终止scale
   */
  static readonly SCALE: number = 0.7;

  /**
   * 入场动效透明度变化时间
   */
  static readonly INSERT_OPACITY_DURATION: number = 200;

  /**
   * 出场动效透明度变化时间
   */
  static readonly DEL_OPACITY_DURATION: number = 100;

  /**
   * 出入场动效scale弹性曲线响应值
   */
  static readonly SPRING_MOTION_RESPONSE: number = 0.268;

  /**
   * 出入场动效scale弹性曲线阻尼
   */
  static readonly SPRING_MOTION_DAMP: number = 0.75;
}