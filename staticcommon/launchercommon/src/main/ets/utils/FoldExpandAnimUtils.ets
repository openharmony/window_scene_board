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

import curves from '@ohos.curves';
import {
  LogDomain,
  LogHelper,
  RectInfo
} from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FoldAnimationConstants } from '../constants/FoldAnimationConstants';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { DockItemInfo } from '../bean/DockItemInfo';
import { LayoutViewModel } from '../viewmodel/LayoutViewModel';
import { DeviceState, CommonConstants } from '../constants/CommonConstants';
import { RecentLayoutCacheMgr, ResidentLayoutCacheMgr } from '../TsIndex';

const TAG: string = 'FoldExpandAnimUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class FoldExpandAnimUtils {
  // true for big or small fold product
  public static isSupportProduct: boolean = FoldExpandAnimUtils.checkIfSupportProduct();
  // true for big fold product
  private static isLargeFoldProduct: boolean = DeviceHelper.isLargeInFoldProduct();
  // true for three fold product
  public static isUltraScreenProduct: boolean = DeviceHelper.isUltraScreenProduct();

  /**
   * Judge whether the large or small fold product
   *
   * @returns true for fold product
   */
  public static checkIfSupportProduct(): boolean {
    let isLargeFold: boolean = DeviceHelper.isLargeInFoldProduct();
    return isLargeFold;
  }

  /**
   * Calculate item initial translate in X-axis direction
   *
   * @param itemColumn item column in desktop
   * @param totalColumns number of total columns
   * @param translateX default translateX
   * @param screenWidth width of screen
   * @param isExpand expanded state
   * @returns item animation initial translateX
   */
  public static initItemTransX(itemColumn: number, totalColumns: number, translateX: number, screenWidth: number,
    isExpand: boolean): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      let initialTransX: number = FoldAnimationConstants.INITIAL_VALUE;
      let relativeColumn: number = 0;
      if (isExpand) {
        relativeColumn = FoldExpandAnimUtils.getItemRelativeCol(itemColumn, totalColumns);
        if (relativeColumn === FoldAnimationConstants.CENTER_COLUMN) {
          return initialTransX;
        }
        initialTransX = FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.TRANS_EDGE * screenWidth,
          FoldAnimationConstants.TRANS_MID * screenWidth, relativeColumn);
        if (itemColumn >= totalColumns / 2) {
          initialTransX = -initialTransX;
        }
        return RTLUtil.isRTL() ? -initialTransX : initialTransX;
      } else {
        relativeColumn = itemColumn + (FoldAnimationConstants.MAX_COLUMN / 2 - totalColumns) / 2;
        initialTransX = -FoldExpandAnimUtils.getFoldLinearParam(FoldAnimationConstants.FOLD_TRANS_EDGE * screenWidth,
          FoldAnimationConstants.FOLD_TRANS_MID * screenWidth, relativeColumn);
        return initialTransX;
      }
    }
    return translateX;
  }

  /**
   * Calculate item initial translate in Y-axis direction
   *
   * @param itemRow number of item column
   * @param screenHeight height of screen
   * @returns item animation initial translateY
   */
  public static initItemTransY(itemRow: number, screenHeight: number, isExpand: boolean = true): number {

    return 0;
  }

  /**
   * Calculate item animation delay for different column of row
   *
   * @param itemRow number of item row
   * @param itemColumn number of item column
   * @param number of total columns
   * @param isExpand expanded state
   * @returns animation delay time
   */
  public static getFoldExpandDelayTime(itemRow: number, itemColumn: number, totalColumns: number,
    isExpand: boolean): number {
    let itemDelay: number = 0;

    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      if (isExpand) {
        let relativeColumn: number = FoldExpandAnimUtils.getItemRelativeCol(itemColumn, totalColumns);
        itemDelay =
          FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE, FoldAnimationConstants.DELAY_MID,
            relativeColumn);
      } else {
        itemDelay = FoldExpandAnimUtils.getFoldLinearParam(FoldAnimationConstants.DELAY_EDGE,
          FoldAnimationConstants.DELAY_MID, itemColumn);
      }
      return itemDelay;
    }
    let delayFactor: number = isExpand ? FoldAnimationConstants.EXPAND_DELAY : FoldAnimationConstants.FOLD_DELAY;
    return (totalColumns - 1 - itemColumn) * delayFactor / (totalColumns - 1);
  }

  /**
   * Calculate alpha offset delay of middle col or row
   *
   * @param itemRow number of item row
   * @param itemColumn number of item column
   * @returns alpha offset delay time
   */
  public static getMidColOrRowAlphaDelayOffsetTime(itemRow: number, itemColumn: number): number {
    let totalRows: number = FoldExpandAnimUtils.getTotalRows();
    let totalColumns: number = 2 * FoldExpandAnimUtils.getTotalColumns();
    if (FoldExpandAnimUtils.isMiddleRow(itemRow, totalRows)) {
      return FoldAnimationConstants.MIDDLE_ROW_DELAY;
    }
    if (FoldExpandAnimUtils.isMiddleCol(itemColumn, totalColumns)) {
      return FoldAnimationConstants.MIDDLE_DELAY;
    }
    return 0;
  }

  /**
   * Judge whether the middle column in large fold
   *
   * @param itemColumn item column
   * @param totalColumn  total columns
   * @returns true for middle column
   */
  public static isMiddleCol(itemColumn: number, totalColumn: number): boolean {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      let relativeColumn: number = FoldExpandAnimUtils.getItemRelativeCol(itemColumn, totalColumn);
      return (relativeColumn === Math.floor(FoldAnimationConstants.CENTER_COLUMN) ||
        relativeColumn === FoldAnimationConstants.CENTER_COLUMN);
    }
    return false;
  }

  /**
   * Judge whether the middle row in small fold
   *
   * @param itemRow item row
   * @param totalColumn  total rows
   * @returns true for middle row
   */
  public static isMiddleRow(itemRow: number, totalRow: number): boolean {
    let centerRow: number = (LayoutViewModel.getInstance().calculateDesktop().mRows ?? 0) / 2;
    return false;
  }

  /**
   * Calculate dock item expand animation delay time
   *
   * @param rectInfo dock item param
   * @param screenWidth width of screen
   * @param itemColumn number of dock item column
   * @param totalColumn number of dock total columns
   * @returns delay time
   */
  public static getDockExpandAnimDelay(rectInfo: RectInfo, screenWidth: number, itemColumn: number,
    totalColumn: number): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      let relativeColumn: number = FoldExpandAnimUtils.getItemRelativeCol(itemColumn, totalColumn);
      relativeColumn = (relativeColumn === FoldAnimationConstants.CENTER_COLUMN) ?
      Math.floor(FoldAnimationConstants.CENTER_COLUMN) : relativeColumn;
      return FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.DELAY_EDGE,
        FoldAnimationConstants.DELAY_MID, relativeColumn);
    }
    return (screenWidth - rectInfo.right + (rectInfo.right - rectInfo.left) / 2) / screenWidth *
      FoldAnimationConstants.EXPAND_DELAY;
  }

  /**
   * Calculate dock item fold animation delay time
   *
   * @param itemColumn item column
   * @param totalColumn total columns
   * @returns delay time
   */
  public static getDockFoldAnimDelay(itemColumn: number, totalColumn: number): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      let relativeColumn: number = itemColumn + (FoldAnimationConstants.MAX_COLUMN / 2 - totalColumn) / 2;
      return FoldExpandAnimUtils.getFoldLinearParam(FoldAnimationConstants.DELAY_EDGE, FoldAnimationConstants.DELAY_MID,
        relativeColumn);
    }
    let totalColumns: number = FoldExpandAnimUtils.getTotalColumns();
    return (totalColumns - 1 - itemColumn) * FoldAnimationConstants.FOLD_DELAY / (totalColumns - 1);
  }

  /**
   * Calculate the relative column of the central axis
   *
   * @param itemColumn item column
   * @param totalColumn total columns
   * @returns number of relative column
   */
  private static getItemRelativeCol(itemColumn: number, totalColumn: number): number {
    let column: number = 0;
    if (itemColumn < totalColumn / 2) {
      column = itemColumn + (FoldAnimationConstants.MAX_COLUMN - totalColumn) / 2;
    } else {
      column = Math.floor(totalColumn / 2) - 1 - itemColumn % Math.ceil(totalColumn / 2) +
        (FoldAnimationConstants.MAX_COLUMN - totalColumn) / 2;
    }
    return column;
  }

  /**
   * Calculate the relative row of the central axis
   *
   * @param itemRow item row
   * @param totalRow total rows
   * @returns number of relative row
   */
  private static getItemRelativeRow(itemRow: number, totalRow: number): number {
    let row: number = 0;
    if (itemRow < totalRow / 2) {
      row = itemRow;
    } else {
      row = Math.floor((totalRow - 1) / 2) - itemRow % Math.ceil((totalRow - 1) / 2);
    }
    return row;
  }

  /**
   * Calculate linear mapping expand animation parameters
   *
   * @param max maximum boundary value
   * @param min minimum boundary value
   * @param itemColOrRow item column or row
   * @returns linear mapping value
   */
  public static getExpandLinearParam(max: number, min: number, itemColOrRow: number): number {
    return (1 - itemColOrRow / (FoldAnimationConstants.MAX_COLUMN / 2 - 1)) * (max - min) + min;
  }

  /**
   * Calculate linear mapping fold animation parameters
   *
   * @param max maximum boundary value
   * @param min minimum boundary value
   * @param itemColumn item column
   * @returns linear mapping value
   */
  public static getFoldLinearParam(max: number, min: number, itemColumn: number): number {
    return itemColumn / (FoldAnimationConstants.MAX_COLUMN / 2 - 1) * (max - min) + min;
  }

  /**
   * Get initial scale of animation
   *
   * @returns number of initial item scale
   */
  public static getFoldExpandAnimScale(): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return FoldAnimationConstants.START_SCALE;
    }
    return 1;
  }

  /**
   * Calculate items animation curve when expand
   *
   * @param itemRow number of item row
   * @param itemColumn number of item column
   * @returns ICurve
   */
  public static getIconExpandAnimCurve(itemRow: number, itemColumn: number): ICurve {
    let totalRows: number = FoldExpandAnimUtils.getTotalRows();
    let totalColumns: number = 2 * FoldExpandAnimUtils.getTotalColumns();
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      let relativeColumn: number = FoldExpandAnimUtils.getItemRelativeCol(itemColumn, totalColumns);
      relativeColumn = (relativeColumn === FoldAnimationConstants.CENTER_COLUMN) ?
        Math.floor(FoldAnimationConstants.CENTER_COLUMN) : relativeColumn;
      return curves.springMotion(FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE,
        FoldAnimationConstants.RESPONSE_MID, relativeColumn), 1, 0);
    }
    return FoldAnimationConstants.TRANSLATE_CURVES;
  }

  /**
   * Calculate dock items animation curve when expand
   *
   * @param itemColumn number of item column
   * @param number of total columns
   * @returns ICurve
   */
  public static getDockItemExpandAnimCurve(itemColumn: number, totalColumns: number): ICurve {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      let relativeColumn: number = FoldExpandAnimUtils.getItemRelativeCol(itemColumn, totalColumns);
      relativeColumn = (relativeColumn === FoldAnimationConstants.CENTER_COLUMN) ?
        Math.floor(FoldAnimationConstants.CENTER_COLUMN) : relativeColumn;
      return curves.springMotion(FoldExpandAnimUtils.getExpandLinearParam(FoldAnimationConstants.RESPONSE_EDGE,
        FoldAnimationConstants.RESPONSE_MID, relativeColumn), 1, 0);
    }
    return FoldAnimationConstants.TRANSLATE_CURVES;
  }

  /**
   * Get Icon item Animate Curve while devices is in Folded status
   *
   * @returns ICurve
   */
  public static getIconFoldedAnimCurve(): ICurve {
    return FoldExpandAnimUtils.isLargeFoldProduct ?
      FoldAnimationConstants.ITEM_FOLD_CURVE : FoldAnimationConstants.TRANSLATE_CURVES;
  }

  /**
   * Calculate desktop item column
   *
   * @param item item information
   * @param indexInSwiper
   * @param totalColumn total columns
   * @returns number of item column
   */
  public static getSwiperPageColumns(item: GridLayoutItemInfo, indexInSwiper: number, totalColumn: number): number {
    let foldStatus: number = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() ?
      DeviceState.EXPAND_STATE : DeviceState.FOLDED_STATE;
    let column: number = 0;
    if (foldStatus === DeviceState.EXPAND_STATE && indexInSwiper && indexInSwiper % 2 === 1) {
      column = (item.column ? item.column : 0) + totalColumn;
    } else {
      column = item.column ? item.column : 0;
    }
    let area: number[] = item.area ? item.area : [0, 0];
    return column + (area[0] - 1) / 2;
  }

  /**
   * Calculate desktop item row
   *
   * @param item item information
   * @returns number of item row
   */
  public static getSwiperPageRows(item: GridLayoutItemInfo): number {
    let row: number = item.row ?? 0;
    let area: number[] = item.area ? item.area : [0, 0];
    return row + (area[1] - 1) / 2;
  }

  /**
   * Get end scale of dock backplane animation
   *
   * @param dockWidth the width of backplane
   * @returns scale of backplane
   */
  public static getBackPlaneAnimScale(dockWidth: number): number {
    return FoldExpandAnimUtils.isLargeFoldProduct ? 1 : (dockWidth - FoldAnimationConstants.INIT_DOCK_BG_WIDTH) /
      FoldAnimationConstants.DIFF_DOCK_BG_WIDTH * FoldAnimationConstants.DIFF_DOCK_BG_SCALE + 2;
  }

  /**
   * Get the total columns
   *
   * @returns number of total columns
   */
  private static getTotalColumns(): number {
    const result = LayoutViewModel.getInstance().calculateDesktop();
    return (result.mColumns === undefined) ? FoldAnimationConstants.MAX_COLUMN / 2 : result.mColumns;
  }

  /**
   * Get the total columns
   *
   * @returns number of total columns
   */
  private static getTotalRows(): number {
    return LayoutViewModel.getInstance().calculateDesktop().mRows ?? 0;
  }

  /**
   * Get dock item column
   *
   * @param index item column
   * @param isResident whether item in Resident Dock
   * @returns [itemColumn, totalColumn]
   */
  public static getDockColumn(index: number, isResident: boolean = true): number[] {
    const recentList: DockItemInfo[] = RecentLayoutCacheMgr.getInstance().getAllDockItems();
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let itemColumn: number = isResident ? index : (residentList.length ? index + residentList.length : index + 1);
    let visibleRecentLength: number | undefined = RecentLayoutCacheMgr.getInstance().getVisibleCount();
    if (visibleRecentLength === 0 || visibleRecentLength === undefined) {
      visibleRecentLength = recentList.length;
    }
    let totalColumn: number = residentList.length ? visibleRecentLength + residentList.length : visibleRecentLength + 1;
    return [itemColumn, totalColumn];
  }

  /**
   * Get indicator animation delay time in different product
   *
   * @returns indicator animation delay time
   */
  public static getIndicatorAnimDelay(): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return 0;
    }
    return FoldAnimationConstants.EXPAND_DELAY / 2;
  }

  /**
   * Init indicator translateX in different product
   *
   * @returns initial translateX
   */
  public static initIndicatorTransX(screenWidth: number, isExpand: boolean = true): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      if (isExpand) {
        return FoldAnimationConstants.INITIAL_VALUE;
      }
      return -FoldAnimationConstants.INDICATOR_TRANS * screenWidth;
    }
    return FoldAnimationConstants.EXPAND_FACTOR * screenWidth;
  }

  /**
   * Init indicator translateY in different product
   *
   * @returns initial translateY
   */
  public static initIndicatorTransY(screenHeight: number): number {
    return 0;
  }

  /**
   * Init Indicator animation scale in different product
   *
   * @returns indicator initial scale
   */
  public static initIndicatorScale(): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return FoldAnimationConstants.START_SCALE;
    }
    return 1;
  }

  /**
   * Get indicator animation param in different product
   *
   * @param delayTime delay time
   * @returns indicator animation param
   */
  public static getIndicatorExpandAnimParam(delayTime: number): AnimateParam {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return {
        curve: FoldAnimationConstants.SCALE_CURVE,
      } as AnimateParam;
    }
    return {
      curve: FoldAnimationConstants.TRANSLATE_CURVES,
      delay: delayTime,
    } as AnimateParam;
  }

  /**
   * Get Indicator's Alpha AnimateParam
   *
   * @param delayTime Animate Delay Time
   * @returns AnimateParam
   */
  public static getIndicatorAlphaAnimParam(delayTime: number): AnimateParam {

    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return {
        curve: FoldAnimationConstants.SHARP_BEZIER_CURVE,
        duration: FoldAnimationConstants.INDICATOR_ALPHA_DURATION,
        delay: delayTime,
      } as AnimateParam;
    }
    return { curve: FoldAnimationConstants.ALPHA_CURVES, delay: delayTime } as AnimateParam;
  }

  /**
   * Get Indicator's Translate Curve
   *
   * @returns ICurve
   */
  public static getIndicatorTranslateCurve(): ICurve {
    return FoldExpandAnimUtils.isLargeFoldProduct ? FoldAnimationConstants.INDICATOR_CURVE :
      FoldAnimationConstants.TRANSLATE_CURVES;
  }

  /**
   * Get Status Bar Start translateX
   *
   * @param factor translate offset factor
   * @param screenWidth screen' width(vp)
   * @returns number of translateX
   */
  public static getStatusBarTranslateX(factor: number, screenWidth: number): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return 0;
    }
    return factor * screenWidth;
  }

  /**
   * Get Status Bar Start Opacity value
   *
   * @returns number of Opacity Value
   */
  public static getStatusBarStartOpacity(): number {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return 1;
    }
    return 0;
  }

  /**
   * Get Status Bar's Alpha AnimateParam
   *
   * @returns AnimateParam
   */
  public static getStatusBarAlphaAnimParam(): AnimateParam {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return {
        curve: FoldAnimationConstants.SHARP_BEZIER_CURVE,
        duration: FoldAnimationConstants.STATUS_BAR_ALPHA_DURATION,
        delay: FoldAnimationConstants.BAR_ALPHA_DELAY,
      } as AnimateParam;
    }
    return { curve: FoldAnimationConstants.ALPHA_CURVES } as AnimateParam;
  }

  /**
   * Get Icon item or Dock Background Alpha AnimateParam
   *
   * @param delayTime Animate Delay Time
   * @returns AnimateParam
   */
  public static getIconOrDockBgAlphaAnimParam(delayTime: number): AnimateParam {
    if (FoldExpandAnimUtils.isLargeFoldProduct) {
      return {
        curve: FoldAnimationConstants.SHARP_BEZIER_CURVE,
        duration: FoldAnimationConstants.ICON_OR_DOCK_ALPHA_DURATION,
        delay: delayTime
      } as AnimateParam;
    }
    return { curve: FoldAnimationConstants.ALPHA_CURVES, delay: delayTime } as AnimateParam;
  }

  /**
   * Get Dock Background Scale Curve
   *
   * @returns ICurve
   */
  public static getDockBgPanelScaleCurve(): ICurve {
    return FoldExpandAnimUtils.isLargeFoldProduct ? FoldAnimationConstants.SCALE_CURVE :
      FoldAnimationConstants.SCALE_CURVES;
  }

  /**
   * Get Dock Background start translateX while devices is in Expand status
   *
   * @param screenWidth screen' width
   * @returns number of translateX
   */
  public static getDockBgExpandAnimStartTranslateX(screenWidth: number): number {
    return FoldExpandAnimUtils.isLargeFoldProduct ? 0 : FoldAnimationConstants.EXPAND_FACTOR * screenWidth;
  }

  /**
   * Get Dock Background start scale size while devices is in Expand status
   *
   * @returns number of scale
   */
  public static getDockBgExpandAnimStartScaleSize(): number {
    return FoldExpandAnimUtils.isLargeFoldProduct ? FoldAnimationConstants.BACKPLANE_SCALE : 1;
  }

  /**
   * Get Dock Background animate delay value while devices is in Expand status
   *
   * @param delayFactor
   * @returns delay time
   */
  public static getRecentBgDelay(delayFactor: number): number {
    return FoldExpandAnimUtils.isLargeFoldProduct ?
      FoldAnimationConstants.DELAY_EDGE : delayFactor * FoldAnimationConstants.EXPAND_DELAY;
  }
}