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

export enum MouseClickType {
  NONE,
  CLICK_LEFT,
  CLICK_RIGHT
}

export enum MouseHoverType {
  NONE,
  HOVER_LEFT,
  HOVER_RIGHT
}

/**
 * hover/click TOP: 效果的top 间距值
 * LEFT: 状态栏左组左右间距
 * RIGHT: 状态栏右组左右间距
 */
export enum ExtraPadding {
  TOP = 2,
  LEFT = 4,
  RIGHT = 8,
}