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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { PortfolioInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/PortfolioInfo';

export class LayoutComponentId {
  public static CONTAINER: string = '__container__';
  public static ILLUSTRATION: string = 'portfolio_res_pic';
  public static PORTFOLIO_TITLE: string = 'portfolio_info_title';
  public static PORTFOLIO_DESC: string = 'portfolio_info_desc';
  public static PORTFOLIO_DESC1: string = 'portfolio_info_desc1';
  public static PORTFOLIO_DESC2: string = 'portfolio_info_desc2';
  public static AGENT_CHIP1: string = 'agent_chip1';
  public static AGENT_CHIP2: string = 'agent_chip2';
  public static CHANGE_BALL: string = 'change_ball';
  public static BLANK: string = 'blank';
}

/**
 * 语音助手建议卡片布局
 *
 * @since 2024-04-27
 */
export abstract class AiSuggestionLayoutStyle {
  protected displayCardInfo: LauncherDisplayCardInfo | undefined;
  protected portfolioInfo: PortfolioInfo | undefined = undefined;

  titleAlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  desc1AlignRules(): AlignRuleOption {
    return {
      top: this.portfolioInfo?.title ?
        { anchor: LayoutComponentId.PORTFOLIO_TITLE, align: VerticalAlign.Bottom } :
        { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  desc2AlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.PORTFOLIO_DESC1, align: VerticalAlign.Bottom },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  changeBallAlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  blankAlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start },
    };
  }

  abstract descAlignRules(): AlignRuleOption;

  abstract gridAlignRules(): AlignRuleOption;

  abstract chip1AlignRules(): AlignRuleOption;

  abstract chip2AlignRules(): AlignRuleOption;

  gridItemAlignment(recItem: LauncherRecItem, isAlignCenter: boolean): Alignment {
    return Alignment.Center;
  }

  /**
   * 场景卡&常规卡的插画位置
   *
   * @returns
   */
  illustrationAlignRules(): AlignRuleOption {
    return {
      top: { anchor: LayoutComponentId.CONTAINER, align: VerticalAlign.Top },
      left: { anchor: LayoutComponentId.CONTAINER, align: HorizontalAlign.Start }
    };
  }

  /**
   * 获取场景语距离参数
   *
   * @returns 距离参数
   */
  getDescPadding(isOuterDesktop: boolean = false): Padding {
    if (isOuterDesktop) {
      return { top: 8, left: 8, right: 8 };
    }
    let paddingTop = 16;
    if (DeviceHelper.isFold()) {
      if (DeviceHelper.isLandscape()) {
        paddingTop = 10;
      } else {
        paddingTop = 14;
      }
    }
    return { top: paddingTop, left: 12, right: 12 };
  }

  /**
   * 获取分身胶囊距离参数
   *
   * @returns 距离参数
   */
  getChipItemMargin(isOuterDesktop: boolean = false): Margin {
    return { top: 8, left: 12, right: RTLUtil.isRTL() ? 12 : 0 };
  }

  /**
   * 获取场景语文字大小
   *
   * @returns 文字大小
   */
  public getDescFontSize(isOuterDesktop: boolean = false): string {
    if (isOuterDesktop) {
      return '14vp'
    }
    return DeviceHelper.isFold() ? '17vp' : '19vp';
  }

  /**
   * 获取场景语行高
   *
   * @returns 行高
   */
  public getDescLineHeight(isOuterDesktop: boolean = false): string {
    if (isOuterDesktop) {
      return '20vp'
    }
    return DeviceHelper.isFold() ? '24vp' : '26vp';
  }

  /**
   * 获取标题栏高度
   *
   * @returns 标题栏高度
   */
  abstract getHeaderHeight(displayCardInfo: LauncherDisplayCardInfo | undefined,
    isOuterDesktop: boolean, formItemHeight: number): number;

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