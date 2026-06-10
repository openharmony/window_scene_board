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

import { ImmCardLiveCardSystemVm } from '../ImmCardLiveCardSystemVm';

/**
 * 小外屏系统实况大卡业务管理器
 */
@ObservedV2
export class ImmOuterCardLiveCardSysVm extends ImmCardLiveCardSystemVm {
  // sim卡图标颜色
  @Computed get simIconColor(): Array<ResourceColor> {
    // 与副文本颜色保持一致
    let contentColor = this.cardSecondaryTextStyleState?.getFontColor();
    if (contentColor) {
      return [contentColor];
    }
    return super.simIconColor;
  }

  // 内容文本颜色
  @Computed
  get textFontColor(): ResourceColor | undefined {
    return this.cardSecondaryTextStyleState?.getFontColor();
  }

  // 内容文本提亮参数
  @Computed
  get textForegroundBrightness(): BrightnessOptions | undefined {
    // 固定前景提亮
    return this.cardSecondaryTextStyleState?.getFgBrightness();
  }

  // 副文本前景色
  getSolidTextColor(): ResourceColor | undefined {
    // 前景色保持副文本颜色
    return this.cardSecondaryTextStyleState?.getFgColor();
  }
}