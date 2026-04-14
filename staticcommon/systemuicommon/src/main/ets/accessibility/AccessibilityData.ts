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

export class AccessibilityPageShowHide {
  static readonly HIDE: number = 0;
  static readonly SHOW: number = 1;
}

export enum AccessibilityLevel {
  /**
   *  根据组件不同会转换为“yes”或者“no”
   */
  AUTO = 'auto',
  /**
   *  当前组件可被无障碍辅助服务所识别
   */
  YES = 'yes',
  /**
   *  当前组件不可被无障碍辅助服务所识别
   */
  NO = 'no',
  /**
   *  当前组件及其所有子组件不可被无障碍辅助服务所识别
   */
  NO_HIDE_DESCENDANTS = 'no-hide-descendants',
}