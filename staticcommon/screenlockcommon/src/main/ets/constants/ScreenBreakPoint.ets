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
// 屏幕宽高断点枚举
export enum SizeBreakPoint {
  XS = 'XSmall',
  SM = 'Small',
  MD = 'Medium',
  LG = 'Large',
  XL = 'XLarge',
}

// 宽度断点阈值节点(VP)
export enum WidthBpNode {
  XS = 320,
  SM = 600,
  MD = 840,
  LG = 1440,
}

// 高度断点阈值节点(高宽比)
export enum HeightBpNode {
  SM = 0.8,
  MD = 1.2,
}