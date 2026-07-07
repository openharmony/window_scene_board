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

import { RTLUtil } from '@ohos/componenthelper';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { AiSuggestionLargeLayoutStyle } from './AiSuggestionLargeLayoutStyle';
import { LayoutComponentId } from './AiSuggestionLayoutStyle';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';

/**
 * 语音助手建议卡片2*2卡片布局样式
 *
 * @since 2024-06-21
 */
export class AiSuggestionMinLayoutStyle extends AiSuggestionLargeLayoutStyle {
  chip1AlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.PORTFOLIO_DESC2, align: VerticalAlign.Bottom },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  chip2AlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.AGENT_CHIP1, align: VerticalAlign.Bottom },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  gridItemAlignment(recItem: LauncherRecItem, isAlignCenter: boolean): Alignment {
    if (isAlignCenter) {
      return Alignment.Center;
    }
    return Alignment.Bottom;
  }

  /**
   * 获取分身胶囊距离参数
   *
   * @returns 距离参数
   */
  getChipItemMargin(): Margin {
    return { top: 8, left: 12, right: RTLUtil.isRTL() ? 12 : 0 };
  }

  /**
   * 获取标题栏高度
   *
   * @returns 标题栏高度
   */
  public getHeaderHeight(displayCardInfo: LauncherDisplayCardInfo | undefined,
    isOuterDesktop: boolean = false, formItemHeight: number): number {
    if (!displayCardInfo || displayCardInfo.headerHeight === 0) {
      return 0;
    }
    // 先计算图标高度：（卡片高度-宫格间距-两个内边距）/列数
    const iconHeight = (formItemHeight - (displayCardInfo.row * displayCardInfo.rowGap) -
      (2 * displayCardInfo.gridPadding)) / displayCardInfo.column;

    // 标题栏高度：卡片高度-两个图标高度-两个内边距-宫格间距
    const headerHeight = formItemHeight - iconHeight * displayCardInfo.row - displayCardInfo.gridPadding * 2 -
      displayCardInfo.rowGap * (displayCardInfo.row - 1);

    // 有1x2卡片，减少标题栏高度，给卡片加高度，消除视觉差
    const has1x2 = displayCardInfo.recItems?.some(item => item.dimension === 1);
    if (has1x2) {
      return headerHeight - displayCardInfo.rowGap * 2;
    }
    return headerHeight;
  }
}