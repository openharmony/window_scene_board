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
 * 状态栏分区
 */
export enum PluginPositionType {
  INVALID,
  TOP_LEFT,
  TOP_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_RIGHT
}

/**
 * 状态栏同一分区内的分组
 */
export enum PluginGroupType {
  INVALID = 0,
  DYNAMIC_LEFT = 1,
  FIRST_GROUP = 2,
  SECOND_GROUP = 3,
  THIRD_GROUP = 4,
  FOURTH_GROUP = 5,
  FIFTH_GROUP = 6,
  TEMPORARY = 7,
  TRAY = 8,
}

export enum PluginDisplayStyle {
  INVALID,
  WINDOWS_STYLE,
  MAC_STYLE
}