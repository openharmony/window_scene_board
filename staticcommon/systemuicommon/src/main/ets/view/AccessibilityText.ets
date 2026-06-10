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

import { AccessibilityVm } from '../vm/AccessibilityVm';

interface AccessibilityTextParam {
  text: ResourceStr;
}

/**
 * 无障碍时渲染出来的空文本，用来做屏幕朗读
 */
@Builder
export function AccessibilityText($$: AccessibilityTextParam) {
  if (AccessibilityVm.instance.isEnabled) {
    Text($$.text)
      .width('1px')
      .height('1px')
      .opacity(0)
      .position({ x: 0, y: 0 }) // 指定position，不参加布局计算
  }
}