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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';
import { PortfolioInfoDisplayMode } from '../constants/PortfolioInfoDisplayMode';
import { AiSuggestionLayoutStyle, LayoutComponentId } from './AiSuggestionLayoutStyle';

/**
 * 语音助手建议卡片4*4卡片布局样式
 *
 * @since 2024-04-27
 */
export class AiSuggestionLargeLayoutStyle extends AiSuggestionLayoutStyle {
  descAlignRules(): AlignRuleOption {
    if (!this.portfolioInfo) {
      return {
        top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
        right: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.End },
        bottom: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Bottom },
      };
    }

    let topAnchor: string = LayoutComponentId.CONTAINER;
    if (this.portfolioInfo.desc2) {
      topAnchor = LayoutComponentId.PORTFOLIO_DESC2;
    } else if (this.portfolioInfo.desc1) {
      topAnchor = LayoutComponentId.PORTFOLIO_DESC1;
    } else {
    }
    return {
      top: { anchor: topAnchor, align: VerticalAlign.Bottom },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  gridAlignRules(): AlignRuleOption {
    if (this.portfolioInfo?.desc1 &&
      (!PortfolioInfo.isPortfolioCard(this.portfolioInfo?.portfolioId) ||
        this.portfolioInfo?.displayMode === PortfolioInfoDisplayMode.DISPLAY_MODE_EXIST)) {
      return {
        top: { anchor: LayoutComponentId.BLANK, align: VerticalAlign.Bottom },
        right: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.End },
        bottom: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Bottom },
      };
    }
    if (this.portfolioInfo?.title) {
      return {
        top: { anchor: LayoutComponentId.PORTFOLIO_TITLE, align: VerticalAlign.Bottom },
        right: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.End },
        bottom: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Bottom },
      };
    }
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
      right: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.End },
      bottom: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Bottom },
    };
  }

  chip1AlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.PORTFOLIO_DESC2, align: VerticalAlign.Bottom },
      left: { anchor: LayoutComponentId.PORTFOLIO_DESC2, align: HorizontalAlign.Start }
    };
  }

  chip2AlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.PORTFOLIO_DESC2, align: VerticalAlign.Bottom },
      left: { anchor: LayoutComponentId.AGENT_CHIP1, align: HorizontalAlign.End }
    };
  }

  /**
   * 获取标题栏高度
   *
   * @returns 标题栏高度
   */
  public getHeaderHeight(displayCardInfo: LauncherDisplayCardInfo | undefined,
    isOuterDesktop: boolean = false, formItemHeight: number): number {
    if (isOuterDesktop && displayCardInfo) {
      return displayCardInfo.headerHeight - 10;
    }
    return displayCardInfo?.headerHeight ?? 0;
  }

  /**
   * 获取分身胶囊距离参数
   *
   * @returns 距离参数
   */
  getChipItemMargin(isOuterDesktop: boolean = false): Margin {
    if (isOuterDesktop) {
      return { top: 4, left: 6, right: 6 };
    }
    let marginTop = 8;
    if (DeviceHelper.isFold()) {
      if (DeviceHelper.isLandscape()) {
        marginTop = 4;
      } else {
        marginTop = 6;
      }
    }
    return { top: marginTop, left: 12, right: 12 };
  }

  update(displayCardInfo: LauncherDisplayCardInfo | undefined, portfolioInfo: PortfolioInfo | undefined,
    isOuterDesktop: boolean = false): void {
    this.displayCardInfo = displayCardInfo;
    this.portfolioInfo = portfolioInfo;
    if (isOuterDesktop && displayCardInfo) {
      displayCardInfo.columnGap = 6;
      displayCardInfo.rowGap = 6;
      displayCardInfo.gridPadding = 6;
    }
  }
}