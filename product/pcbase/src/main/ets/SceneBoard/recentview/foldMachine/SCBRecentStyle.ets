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
import { LogDomain, LogHelper, SingleBase, SingleContext, singleManager } from '@ohos/basicutils';
import { Rect } from '@ohos/basicutils/src/main/ets/utils/CommonUtils';
import { LayoutViewModel, StyleConstants } from '@ohos/launchercommon';
import { SCBRecentSessionsViewModel } from '../SCBRecentSessionsViewModel';
import { SCBRecentStyleConstants } from '../SCBRecentStyleConstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'Recent-SCBRecentStyle';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
const DEFAULT_FLING_SPEED_LIMIT: number = 12000;

export class SCBRecentStyleManager extends SingleBase {
  public static singleName: string = 'SCBRecentStyleManager';
  private static instancesMap: Map<number, SCBRecentStyleManager> = new Map();
  private isSplitStyle: boolean = false;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(ctx?: SingleContext): SCBRecentStyleManager {
    const screenID: number = ctx?.extendScreenId ?? 0;
    let recentStyleManager: SCBRecentStyleManager | undefined = SCBRecentStyleManager.instancesMap.get(screenID);
    if (!recentStyleManager) {
      recentStyleManager = new SCBRecentStyleManager(ctx);
      SCBRecentStyleManager.instancesMap.set(screenID, recentStyleManager);
    }
    return recentStyleManager;
  }

  public setSplitStyle(isSplitState: boolean): void {
    this.isSplitStyle = isSplitState;
  }

  public getStyle(): SCBRecentStyle {
    let recentStyle: SCBRecentStyle | undefined = new SCBRecentStyle(this.singleContext);;
    recentStyle.setSplitStyle(this.isSplitStyle);
    return recentStyle;
  }
}

export class SCBRecentStyle extends SingleBase {
  public static singleName: string = 'SCBRecentStyle';
  protected _isSplitStyle: boolean = false;
  protected _cardHeightMaxPercent: number = SCBRecentStyleConstants.CARD_MAX_HEIGHT_PERCENT;
  protected _cardHeightMinPercent: number = SCBRecentStyleConstants.CARD_MIN_HEIGHT_PERCENT;
  protected _cardLineSpacePercent: number = SCBRecentStyleConstants.CARD_BOTTOM_MARGIN_RATIO;
  protected _cardsMarginTop: number = SCBRecentStyleConstants.LIST_MARGIN_TOP;
  protected _scrollBarMarginRight: number = SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT;
  protected _avoidAreaHeight: number = 48;
  protected _flingSpeedLimit: number = DEFAULT_FLING_SPEED_LIMIT;
  protected _avoidVirKeyBoardMarginBottom: number = 16;
  protected _isNeedAvoidVirKeyboard: boolean = false;
  protected _animationChainMaxRowNum: number = SCBRecentStyleConstants.CARDS_SHOW_ROW_NUM;
  protected _workSpacePercent: number = SCBRecentStyleConstants.PC_USABLE_WIDTH;
  protected _scrollBarHeightPercent: number = SCBRecentStyleConstants.SCROLL_BAR_HEIGHT_PERCENT;

  protected _bPanel: Rect = { left: 0, top: 0, height: 0, width: 0 };
  protected _cPanel: Rect = { left: 0, top: 0, height: 0, width: 0 };

  protected _barHeight: number = StyleConstants.DEFAULT_PC_BAR_HEIGHT;
  protected _scrollBarYOffset: number = 0;
  protected _cardsMaxVisibleRowNum: number = SCBRecentStyleConstants.CARD_THIRD_ROW;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public setSplitStyle(isSplitStyle: boolean): void {
    this._isSplitStyle = isSplitStyle;
  }

  public getRecentShowHeight(): number {
    return this.bPanel.height;
  }

  setBPanel(rect: Rect): void {
    this._bPanel = rect;
  }

  setCPanel(rect: Rect): void {
    this._cPanel = rect;
  }

  get avoidVirKeyBoardMarginBottom(): number {
    return this._avoidVirKeyBoardMarginBottom;
  }

  get isNeedAvoidVirKeyboard(): boolean {
    return this._isNeedAvoidVirKeyboard;
  }

  get cardHeightMaxPercent(): number {
    return this._cardHeightMaxPercent;
  }

  get workSpacePercent(): number {
    return this._workSpacePercent;
  }

  get scrollBarHeightPercent(): number {
    return this._scrollBarHeightPercent;
  }

  get cardHeightMinPercent(): number {
    return this._cardHeightMinPercent;
  }

  get cardLineSpacePercent(): number {
    return this._cardLineSpacePercent;
  }

  get animationChainMaxRowNum(): number {
    return this.isSplitStyle ? SCBRecentStyleConstants.CARDS_SHOW_ROW_NUM : this._animationChainMaxRowNum;
  }

  get cardTitleHeight(): number {
    return SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE +
      SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2;
  }

  /**
   * 卡片显示区域距离顶部高度/第一行卡片距离顶部高度
   * @returns
   */
  get cardsMarginTop(): number {
    return this._cardsMarginTop + this.cardTitleHeight;
  }

  get scrollBarMarginRight(): number {
    return this._scrollBarMarginRight;
  }

  get avoidAreaHeight(): number {
    return this._avoidAreaHeight;
  }

  get flingSpeedLimit(): number {
    if (this.isSplitStyle) {
      return DEFAULT_FLING_SPEED_LIMIT;
    }
    return this._flingSpeedLimit;
  }

  get cardsMaxVisibleRowNum(): number {
    return this._cardsMaxVisibleRowNum;
  }

  get isSplitStyle(): boolean {
    return this._isSplitStyle;
  }

  get bPanel(): Rect {
    return this._bPanel;
  }

  get cPanel(): Rect {
    return this._cPanel;
  }

  public getAxisHalfHeight(screenID: number): number {
    return 0;
  }

  public getDockAndLogoGap(): number {
    return LayoutViewModel.getInstance(this.singleContext).getDockHeight();
  }

  protected getScrollBarMarginRight(): number {
    return SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT;
  }

  public getUsableScreenHeight(showHeight: number): number {
    if (this.isSplitStyle) {
      return showHeight;
    }
    return showHeight - LayoutViewModel.getInstance(this.singleContext).getDockHeight();
  }

  public getScrollBarStyles(showHeight: number, showWidth: number, offsetX: number, offsetY: number): number[] {
    let scrollBarStyles: number[] = [];
    const sysUIBottomHeight = LayoutViewModel.getInstance(this.singleContext).getSysUIBottomHeight();
    log.showInfo(`initArg:${showHeight}, ${showWidth}, ${sysUIBottomHeight}, ${offsetX}, ${offsetY}`);
    let effectHeight: number = showHeight - sysUIBottomHeight;
    offsetX -= this.getScrollBarMarginRight();
    offsetY -= (this.isSplitStyle ? 0 : this._scrollBarYOffset);
    scrollBarStyles[0] = (effectHeight - this._barHeight) * this.scrollBarHeightPercent;
    scrollBarStyles[1] = 8;
    scrollBarStyles[2] = showWidth + offsetX;
    scrollBarStyles[3] = (effectHeight - scrollBarStyles[0]) / 2 + offsetY;
    // 滚动条高、 宽、 X方向偏移、 Y方向偏移
    return scrollBarStyles;
  }
}

/**
 * 水平展开态
 */
class UnfoldHorizontalStyle extends SCBRecentStyle {
  public static singleName: string = 'UnfoldHorizontalStyle';
  protected _cardHeightMaxPercent: number = SCBRecentStyleConstants.CARD_MAX_HEIGHT_PERCENT;
  protected _cardHeightMinPercent: number = SCBRecentStyleConstants.CARD_MIN_HEIGHT_PERCENT_HORIZONTAL;
  protected _cardLineSpacePercent: number = SCBRecentStyleConstants.CARD_ROW_SPACE_PERCENT;
  protected _scrollBarMarginRight: number = SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT_HORIZONTAL;
  protected _barHeight: number = 0;
  protected _isNeedAvoidVirKeyboard = true;
  protected _animationChainMaxRowNum: number = SCBRecentStyleConstants.CARDS_SHOW_ROW_NUM_HOR;
  protected _workSpacePercent: number = SCBRecentStyleConstants.PC_USABLE_WIDTH;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  get animationChainMaxRowNum(): number {
    return this._animationChainMaxRowNum;
  }

  public getRecentShowHeight(): number {
    return super.getRecentShowHeight();
  }

  public getDockAndLogoGap(): number {
    return LayoutViewModel.getInstance(this.singleContext).getDockHeight();
  }

  protected getScrollBarMarginRight(): number {
    return this.bPanel.width * SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT_PERCENT_HPR_HOR;
  }
}

/**
 * 竖直展开态
 */
class UnfoldVerticalStyle extends SCBRecentStyle {
  public static singleName: string = 'UnfoldVerticalStyle';
  protected _cardHeightMaxPercent: number = SCBRecentStyleConstants.CARD_MAX_HEIGHT_PERCENT_VERTICAL;
  protected _cardHeightMinPercent: number = SCBRecentStyleConstants.CARD_MIN_HEIGHT_PERCENT_VERTICAL;
  protected _cardLineSpacePercent: number = SCBRecentStyleConstants.CARD_LINE_SPACE_PERCENT;
  protected _scrollBarMarginRight: number = SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT_VERTICAL;
  protected _barHeight: number = 0;
  protected _isNeedAvoidVirKeyboard = true;
  protected _cardsMaxVisibleRowNum: number = SCBRecentStyleConstants.CARD_SIXTH_ROW;
  protected _animationChainMaxRowNum: number = SCBRecentStyleConstants.CARDS_SHOW_ROW_NUM_VER;
  protected _workSpacePercent: number = SCBRecentStyleConstants.PC_USABLE_WIDTH_HPR;
  protected _scrollBarHeightPercent: number = SCBRecentStyleConstants.SCROLL_BAR_HEIGHT_PERCENT_VERTICAL;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  get cardsMaxVisibleRowNum(): number {
    return this.isSplitStyle ?
      SCBRecentStyleConstants.CARD_THIRD_ROW : this._cardsMaxVisibleRowNum;
  }

  get scrollBarHeightPercent(): number {
    if (this.isSplitStyle) {
      return SCBRecentStyleConstants.SCROLL_BAR_HEIGHT_PERCENT;
    }
    return this._scrollBarHeightPercent;
  }

  public getRecentShowHeight(): number {
    return super.getRecentShowHeight();
  }

  protected getScrollBarMarginRight(): number {
    const marginToLeftEdge = SCBRecentSessionsViewModel.getInstance(this.singleContext).getMarginToLeftEdge();
    return marginToLeftEdge * SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT_PERCENT_HPR;
  }
}

/**
 * 半折叠态
 */
class FoldHalfStyle extends SCBRecentStyle {
  public static singleName: string = 'FoldHalfStyle';
  protected _cardHeightMaxPercent: number = SCBRecentStyleConstants.CARD_MAX_HEIGHT_PERCENT_VERTICAL;
  protected _cardHeightMinPercent: number = SCBRecentStyleConstants.CARD_MIN_HEIGHT_PERCENT_VERTICAL;
  protected _cardLineSpacePercent: number = SCBRecentStyleConstants.CARD_LINE_SPACE_PERCENT;
  protected _barHeight: number = 0;
  protected _cardsMarginTop = SCBRecentStyleConstants.MIN_MARGIN_TOP_HPR;
  protected _flingSpeedLimit: number = 1;
  protected _animationChainMaxRowNum: number = SCBRecentStyleConstants.CARDS_SHOW_ROW_NUM_VER;
  protected _workSpacePercent: number = SCBRecentStyleConstants.PC_USABLE_WIDTH_HPR;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public getDockAndLogoGap(): number {
    return LayoutViewModel.getInstance(this.singleContext).getDockHeight() +
    px2vp(this.getAxisHalfHeight(this.singleContext?.extendScreenId ?? 0));
  }

  public getUsableScreenHeight(showHeight: number): number {
    return showHeight;
  }

  public getRecentShowHeight(): number {
    return this.bPanel.height + this.cPanel.height;
  }

  protected getScrollBarMarginRight(): number {
    const marginToLeftEdge = SCBRecentSessionsViewModel.getInstance(this.singleContext).getMarginToLeftEdge();
    return marginToLeftEdge * SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT_PERCENT_HPR;
  }
}

/**
 * 物理键盘态
 */
class FoldPhysicalStyle extends SCBRecentStyle {
  public static singleName: string = 'FoldPhysicalStyle';
  protected _cardHeightMaxPercent: number = SCBRecentStyleConstants.CARD_MAX_HEIGHT_PERCENT_VERTICAL;
  protected _cardHeightMinPercent: number = SCBRecentStyleConstants.CARD_MIN_HEIGHT_PERCENT_VERTICAL;
  protected _barHeight: number = 0;
  protected _cardLineSpacePercent: number = SCBRecentStyleConstants.CARD_LINE_SPACE_PERCENT;
  protected _cardsMarginTop: number = SCBRecentStyleConstants.MIN_MARGIN_TOP_HPR;
  protected _workSpacePercent: number = SCBRecentStyleConstants.PC_USABLE_WIDTH_HPR;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public getDockAndLogoGap(): number {
    return LayoutViewModel.getInstance(this.singleContext).getDockHeight() +
    px2vp(this.getAxisHalfHeight(this.singleContext?.extendScreenId ?? 0));
  }

  public getUsableScreenHeight(showHeight: number): number {
    return showHeight;
  }

  protected getScrollBarMarginRight(): number {
    const marginToLeftEdge = SCBRecentSessionsViewModel.getInstance(this.singleContext).getMarginToLeftEdge();
    return marginToLeftEdge * SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT_PERCENT_HPR;
  }
}

/**
 * 虚拟键盘态
 */
class FoldVirtualStyle extends SCBRecentStyle {
  public static singleName: string = 'FoldVirtualStyle';
  protected _cardHeightMaxPercent: number = SCBRecentStyleConstants.CARD_MAX_HEIGHT_PERCENT_VERTICAL;
  protected _cardHeightMinPercent: number = SCBRecentStyleConstants.CARD_MIN_HEIGHT_PERCENT_VERTICAL;
  protected _barHeight: number = 0;
  protected _cardLineSpacePercent: number = SCBRecentStyleConstants.CARD_LINE_SPACE_PERCENT;
  protected _cardsMarginTop: number = SCBRecentStyleConstants.MIN_MARGIN_TOP_HPR;
  protected _workSpacePercent: number = SCBRecentStyleConstants.PC_USABLE_WIDTH_HPR;

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public getDockAndLogoGap(): number {
    return LayoutViewModel.getInstance(this.singleContext).getDockHeight() +
    px2vp(this.getAxisHalfHeight(this.singleContext?.extendScreenId ?? 0));
  }

  public getUsableScreenHeight(showHeight: number): number {
    return showHeight;
  }

  protected getScrollBarMarginRight(): number {
    const marginToLeftEdge = SCBRecentSessionsViewModel.getInstance(this.singleContext).getMarginToLeftEdge();
    return marginToLeftEdge * SCBRecentStyleConstants.SCROLL_BAR_MARGIN_RIGHT_PERCENT_HPR;
  }
}