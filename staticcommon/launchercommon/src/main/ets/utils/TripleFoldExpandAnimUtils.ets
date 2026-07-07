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

import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil, desktopUtil } from '@ohos/componenthelper';
import { ApsUtils, ScreenState, ScreenStateMonitor } from '@ohos/frameworkwrapper';
import lazy { SCBTripleFoldState } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import { TripleFoldAnimationConstants } from '../constants/TripleFoldAnimationConstants';
import { DockItemInfo, GridLayoutItemInfo, RecentLayoutCacheMgr, ResidentLayoutCacheMgr } from '../TsIndex';
import { FoldExpandAnimUtils } from './FoldExpandAnimUtils';
import { PageInfoManager } from '../cache/layout/PageInfoManager';
import { performanceMonitor } from '@kit.ArkUI';
// import apsManager from '@ohos.graphic.apsManager';

const TAG = 'TripleFoldExpandAnimUtils';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const DEFAULT_TRANSLATE: number = 100;
const DEFAULT_TWO: number = 2;
const DEFAULT_THREE: number = 3;
const DEFAULT_SIX: number = 6;
const START_SCALE: number = 0.7;

/**
 * state change for three fold device
 */
export enum SCBTripleStateChange {
  INVALID,
  F_TO_M,
  F_TO_G,
  M_TO_F,
  M_TO_G,
  G_TO_F,
  G_TO_M,
}

// 记录当前形态的屏幕属性
export class ScreenProperty {
  private mMargin: number = 0;
  private mFoldPadding: number = 0;
  private mWorkSpaceWidth: number = 0;

  public setScreenProperty(margin: number, foldPadding: number, workSpaceWidth: number): void {
    if (this.mWorkSpaceWidth !== 0) {
      log.showInfo('The data has been updated and no further updates are needed.');
      return;
    }
    this.mMargin = margin;
    this.mFoldPadding = foldPadding;
    this.mWorkSpaceWidth = workSpaceWidth;
  }

  public getScreenProperty(): number[] {
    return [this.mMargin, this.mFoldPadding, this.mWorkSpaceWidth];
  }
}

export class TripleFoldExpandAnimUtils {
  private static IndexMap: Map<ScreenState, number> = new Map();
  private static screenPropertyF: ScreenProperty = new ScreenProperty();
  private static screenPropertyM: ScreenProperty = new ScreenProperty();
  private static screenPropertyG: ScreenProperty = new ScreenProperty();

  public static setScreenProperty(marginLeft: number, marginRight: number, foldPaddingLeft: number,
    foldPaddingRight: number, workSpaceWidth: number): void {
    let margin: number = Math.max(marginLeft, marginRight);
    let foldPadding: number = Math.max(foldPaddingLeft, foldPaddingRight);
    let currentState: ScreenState = ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState;
    switch (currentState) {
      case ScreenState.F:
        TripleFoldExpandAnimUtils.screenPropertyF.setScreenProperty(margin, foldPadding, workSpaceWidth);
        break;
      case ScreenState.M:
        TripleFoldExpandAnimUtils.screenPropertyM.setScreenProperty(margin, foldPadding, workSpaceWidth);
        break;
      case ScreenState.G:
        TripleFoldExpandAnimUtils.screenPropertyG.setScreenProperty(margin, foldPadding, workSpaceWidth);
        break;
      default:
        return;
    }
    log.showInfo(`updateScreenProperty, current state is ${currentState}, margin is ${margin},
      foldPadding is ${foldPadding}, workSpaceWidth is ${workSpaceWidth}`);
  }

  public static updateCurrentMainIndex(): void {
    let mainPageIndex: number = desktopUtil.getPageIndexValue();
    let currentState: ScreenState = ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState;
    switch (currentState) {
      case ScreenState.M:
        mainPageIndex = Math.floor(mainPageIndex / DEFAULT_TWO) * DEFAULT_TWO;
        break;
      case ScreenState.G:
        mainPageIndex = Math.floor(mainPageIndex / DEFAULT_THREE) * DEFAULT_THREE;
        break;
      default:
        break;
    }
    TripleFoldExpandAnimUtils.IndexMap.set(currentState, mainPageIndex);
    log.showInfo(`updateCurrentIndex, mianPageIndex is ${mainPageIndex}, currentState is ${currentState}`);
  }

  public static getIsThreeScreenDisplay(): boolean {
    return PageInfoManager.getInstance().getMaxDisplayCount() === 3;
  }

  public static isCurrentPageWithAnimation(index: number, mainIndex: number, stateChange: SCBTripleStateChange): boolean {
    let indexM: number = TripleFoldExpandAnimUtils.IndexMap.get(ScreenState.M) ?? 0;
    let indexG: number = TripleFoldExpandAnimUtils.IndexMap.get(ScreenState.G) ?? 0;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
      case SCBTripleStateChange.M_TO_F:
      case SCBTripleStateChange.F_TO_G:
      case SCBTripleStateChange.INVALID:
        return PageInfoManager.getInstance().isCurrentPageShow(index, mainIndex);
      case SCBTripleStateChange.G_TO_F:
        return PageInfoManager.getInstance().isCurrentPageShow(index, mainIndex) || index === indexG + 1 ||
          index === indexG + 2 || index === indexG + 3;
      case SCBTripleStateChange.M_TO_G:
        return PageInfoManager.getInstance().isCurrentPageShow(index, mainIndex) || index === indexM ||
          index === indexM + 1;
      case SCBTripleStateChange.G_TO_M:
        return PageInfoManager.getInstance().isCurrentPageShow(index, mainIndex) || index === indexG ||
          index === indexG + 1 || index === indexG + 2;
      default:
        return PageInfoManager.getInstance().isCurrentPageShow(index, mainIndex);
    }
  }

  /**
   * get alpha animation's curve of snapshot
   *
   * @returns ICurve curve of alpha animation
   */
  public static getScenePanelSnapshotAlphaCurve(stateChange: SCBTripleStateChange): ICurve | Curve {
    let alphaCurve: ICurve | Curve = TripleFoldAnimationConstants.ALPHA_SNAPSHOT_CURVES_DEFAULT;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_G:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_SNAPSHOT_CURVES_F2G;
        break;
      case SCBTripleStateChange.M_TO_G:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_SNAPSHOT_CURVES_M2G;
        break;
      case SCBTripleStateChange.G_TO_F:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_SNAPSHOT_CURVES_G2F;
        break;
      case SCBTripleStateChange.G_TO_M:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_SNAPSHOT_CURVES_G2M;
        break;
      default:
        break;
    }
    return alphaCurve;
  }

  /**
   * get alpha animation's curve of scene panel
   *
   * @returns ICurve curve of alpha animation
   */
  public static getScenePanelAlphaCurve(stateChange: SCBTripleStateChange): ICurve | Curve {
    let alphaCurve: ICurve | Curve = TripleFoldAnimationConstants.ALPHA_CURVES_DEFAULT;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_CURVES_F2M;
        break;
      case SCBTripleStateChange.F_TO_G:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_CURVES_F2G;
        break;
      case SCBTripleStateChange.M_TO_F:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_CURVES_M2F;
        break;
      case SCBTripleStateChange.M_TO_G:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_CURVES_M2G;
        break;
      case SCBTripleStateChange.G_TO_F:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_CURVES_G2F;
        break;
      case SCBTripleStateChange.G_TO_M:
        alphaCurve = TripleFoldAnimationConstants.ALPHA_CURVES_G2M;
        break;
      default:
        break;
    }
    return alphaCurve;
  }

  /**
   * get translate animation's curve of scene panel
   *
   * @returns ICurve curve of translate animation
   */
  public static getScenePanelTransCurve(stateChange: SCBTripleStateChange): ICurve | Curve {
    let transCurve: ICurve | Curve = TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_DEFAULT;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
        transCurve = TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_F2M;
        break;
      case SCBTripleStateChange.F_TO_G:
        transCurve = TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_F2G;
        break;
      case SCBTripleStateChange.M_TO_F:
        transCurve = TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_M2F;
        break;
      case SCBTripleStateChange.M_TO_G:
        transCurve = TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_M2G;
        break;
      case SCBTripleStateChange.G_TO_M:
        transCurve = TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_G2M;
        break;
      case SCBTripleStateChange.G_TO_F:
        transCurve = TripleFoldAnimationConstants.SYSTEM_TRANSLATE_CURVES_G2F;
        break;
      default:
        break;
    }
    return transCurve;
  }

  /**
   * get animType of scene panel
   *
   * @returns animType animation type of state change
   */
  public static getScenePanelAnimType(stateChange: SCBTripleStateChange): string {
    let animType: string = 'DEFAULT_WINDOWS';
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
        animType = 'F_TO_M_WINDOWS';
        break;
      case SCBTripleStateChange.F_TO_G:
        animType = 'F_TO_G_WINDOWS';
        break;
      case SCBTripleStateChange.M_TO_F:
        animType = 'M_TO_F_WINDOWS';
        break;
      case SCBTripleStateChange.M_TO_G:
        animType = 'M_TO_G_WINDOWS';
        break;
      case SCBTripleStateChange.G_TO_F:
        animType = 'G_TO_F_WINDOWS';
        break;
      case SCBTripleStateChange.G_TO_M:
        animType = 'G_TO_M_WINDOWS';
        break;
      default:
        break;
    }
    return animType;
  }

  /**
   * get animFactor of scene panel
   *
   * @returns animFactor animation factor of state change
   */
  public static getScenePanelAnimFactor(stateChange: SCBTripleStateChange): number {
    let animFactor: number = 0;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
        animFactor = TripleFoldAnimationConstants.F2M_FACTOR;
        break;
      case SCBTripleStateChange.F_TO_G:
        animFactor = TripleFoldAnimationConstants.F2G_FACTOR;
        break;
      case SCBTripleStateChange.M_TO_F:
        animFactor = TripleFoldAnimationConstants.M2F_FACTOR;
        break;
      case SCBTripleStateChange.M_TO_G:
        animFactor = TripleFoldAnimationConstants.M2G_FACTOR;
        break;
      case SCBTripleStateChange.G_TO_F:
        animFactor = TripleFoldAnimationConstants.G2F_FACTOR;
        break;
      case SCBTripleStateChange.G_TO_M:
        animFactor = TripleFoldAnimationConstants.G2M_FACTOR;
        break;
      default:
        break;
    }
    return animFactor;
  }

  /**
   * get state change info of three fold device
   *
   * @returns SCBTripleStateChange like STATE_TO_STATE, state can be F/M/G
   */
  public static getTripleStateChange(curTripleFoldState: SCBTripleFoldState,
    lastTripleFoldState: SCBTripleFoldState): SCBTripleStateChange {
    if (!FoldExpandAnimUtils.isThreeFoldProduct) {
      return SCBTripleStateChange.INVALID;
    }
    if (lastTripleFoldState === SCBTripleFoldState.F) {
      if (curTripleFoldState === SCBTripleFoldState.M) {
        return SCBTripleStateChange.F_TO_M;
      }
      if (curTripleFoldState === SCBTripleFoldState.G) {
        return SCBTripleStateChange.F_TO_G;
      }
    }
    if (lastTripleFoldState === SCBTripleFoldState.M) {
      if (curTripleFoldState === SCBTripleFoldState.F) {
        return SCBTripleStateChange.M_TO_F;
      }
      if (curTripleFoldState === SCBTripleFoldState.G) {
        return SCBTripleStateChange.M_TO_G;
      }
    }
    if (lastTripleFoldState === SCBTripleFoldState.G) {
      if (curTripleFoldState === SCBTripleFoldState.F) {
        return SCBTripleStateChange.G_TO_F;
      }
      if (curTripleFoldState === SCBTripleFoldState.M) {
        return SCBTripleStateChange.G_TO_M;
      }
    }
    return SCBTripleStateChange.INVALID;
  }

  public static getDesktopAnimFactor(stateChange: SCBTripleStateChange): number {
    let animFactor: number = 0;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
        animFactor = TripleFoldAnimationConstants.ITEM_TRANS_FTM;
        break;
      case SCBTripleStateChange.F_TO_G:
        animFactor = TripleFoldAnimationConstants.ITEM_TRANS_FTG;
        break;
      case SCBTripleStateChange.M_TO_F:
        animFactor = TripleFoldAnimationConstants.ITEM_TRANS_MTF;
        break;
      case SCBTripleStateChange.M_TO_G:
        animFactor = TripleFoldAnimationConstants.ITEM_TRANS_MTG;
        break;
      case SCBTripleStateChange.G_TO_F:
        animFactor = TripleFoldAnimationConstants.ITEM_TRANS_GTF;
        break;
      case SCBTripleStateChange.G_TO_M:
        animFactor = TripleFoldAnimationConstants.ITEM_TRANS_GTM;
        break;
      default:
        break;
    }
    return animFactor;
  }

  public static getTripleDesktopStateChange(curTripleFoldState: ScreenState,
    lastTripleFoldState: ScreenState): SCBTripleStateChange {
    if (!FoldExpandAnimUtils.isThreeFoldProduct) {
      return SCBTripleStateChange.INVALID;
    }
    if (lastTripleFoldState === ScreenState.F) {
      if (curTripleFoldState === ScreenState.M) {
        return SCBTripleStateChange.F_TO_M;
      }
      if (curTripleFoldState === ScreenState.G) {
        return SCBTripleStateChange.F_TO_G;
      }
    }
    if (lastTripleFoldState === ScreenState.M) {
      if (curTripleFoldState === ScreenState.F) {
        return SCBTripleStateChange.M_TO_F;
      }
      if (curTripleFoldState === ScreenState.G) {
        return SCBTripleStateChange.M_TO_G;
      }
    }
    if (lastTripleFoldState === ScreenState.G) {
      if (curTripleFoldState === ScreenState.F) {
        return SCBTripleStateChange.G_TO_F;
      }
      if (curTripleFoldState === ScreenState.M) {
        return SCBTripleStateChange.G_TO_M;
      }
    }
    return SCBTripleStateChange.INVALID;
  }

  /**
   * Calculate item initial translate in X-axis direction of three fold product
   *
   * @param screenWidth width of screen
   * @param stateChange F/M/G change state
   * @param itemColumn item column in desktop
   * @param item information of desktop item
   * @param screenData screen data array, screenData[0] is previous screen data, screenData[1] is current screen data
   * @returns item animation initial translateX
   */
  public static initTripleItemTransX(screenWidth: number, stateChange: SCBTripleStateChange,
    itemColumn?: number, item?: GridLayoutItemInfo, screenData?: number[][]): number {
    if (itemColumn === undefined || itemColumn < 0 || itemColumn > TripleFoldAnimationConstants.MAX_COLUMN) {
      log.showError('itemColumn error');
      return 0;
    }
    if (item === undefined || item.area === undefined) {
      log.showError('item error');
      return 0;
    }
    if (screenData === undefined || screenData.length !== 2 || screenData[0].length !== 3 ||
      screenData[1].length !== 3) {
      log.showError('screenData error');
      return 0;
    }
    let translateX: number = 0;
    let mWorkSpaceDiff: number = screenData[1][0] - screenData[0][0];

    let mMarginDiff: number = screenData[1][1] - screenData[0][1];
    let mFoldPaddingDiff: number = screenData[1][2] - screenData[0][2];
    let mGridWidthDiff: number = mWorkSpaceDiff / TripleFoldAnimationConstants.MAX_PAGE_COLUMN;
    let mGridNumberRemain: number = 0;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
      case SCBTripleStateChange.M_TO_F:
        translateX = TripleFoldExpandAnimUtils.getDesktopAnimFactor(stateChange) * screenWidth;
        break;
      case SCBTripleStateChange.M_TO_G:
      case SCBTripleStateChange.G_TO_M:
      case SCBTripleStateChange.G_TO_F:
      case SCBTripleStateChange.F_TO_G:
        itemColumn = RTLUtil.isRTL() ? TripleFoldAnimationConstants.MAX_COLUMN - 1 - itemColumn : itemColumn;
        mGridNumberRemain = TripleFoldExpandAnimUtils.calculateGridNumberRemain(itemColumn, stateChange, item);
        translateX = mMarginDiff + mFoldPaddingDiff + mGridWidthDiff * mGridNumberRemain +
          0.5 * mWorkSpaceDiff * (item.area[0] / TripleFoldAnimationConstants.MAX_PAGE_COLUMN);
        if (stateChange === SCBTripleStateChange.F_TO_G) {
          if ((RTLUtil.isRTL() && itemColumn < TripleFoldAnimationConstants.MAX_PAGE_COLUMN) ||
            (!RTLUtil.isRTL() && itemColumn >= TripleFoldAnimationConstants.MAX_PAGE_COLUMN)) {
            translateX = TripleFoldAnimationConstants.ITEM_TRANS_MTG * screenWidth;
          }
        }
        if (stateChange === SCBTripleStateChange.F_TO_G || stateChange === SCBTripleStateChange.G_TO_F) {
          translateX = -1 * translateX;
        }
        break;
      default:
        translateX = 0;
        break;
    }
    log.showInfo('initTripleItemTransX, stateChange is %{public}d, itemColumn is %{public}d, translateX is %{public}f',
      stateChange, itemColumn, translateX);
    return translateX;
  }

  public static calculateGridNumberRemain(itemColumn: number, stateChange: SCBTripleStateChange,
    item?: GridLayoutItemInfo): number {
    if (item === undefined || item.area === undefined) {
      log.showError('item error');
      return 0;
    }
    if (stateChange === SCBTripleStateChange.M_TO_G || stateChange === SCBTripleStateChange.G_TO_M) {
      return TripleFoldAnimationConstants.MAX_COLUMN - 1 - itemColumn - (item?.area[0] - 1) / 2;
    }
    if (stateChange === SCBTripleStateChange.F_TO_G || stateChange === SCBTripleStateChange.G_TO_F) {
      return itemColumn - (item?.area[0] - 1) / 2;
    }
    return 0;
  }

  /**
   * Calculate items animation curve when fold or expand of three fold product
   *
   * @param itemColumn number of item column
   * @param stateChange F/M/G change state
   * @returns animation curve
   */
  public static getIconTripleFoldExpandAnimCurve(itemColumn: number, stateChange: SCBTripleStateChange): ICurve {
    let cubicBezierCurveParam: number = 0;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
        cubicBezierCurveParam =
          TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.FTM_CURVES_PARAM_RIGHT,
            TripleFoldAnimationConstants.FTM_CURVES_PARAM_LEFT, itemColumn, TripleFoldAnimationConstants.MAX_COLUMN);
        break;
      case SCBTripleStateChange.M_TO_F:
        itemColumn = TripleFoldAnimationConstants.MAX_COLUMN / 2 - itemColumn - 1;
        cubicBezierCurveParam = TripleFoldExpandAnimUtils.getTripleLinearParam(
          TripleFoldAnimationConstants.MTF_CURVES_PARAM_LEFT, TripleFoldAnimationConstants.MTF_CURVES_PARAM_RIGHT,
            itemColumn, TripleFoldAnimationConstants.MAX_COLUMN / 2);
        break;
      case SCBTripleStateChange.M_TO_G:
        itemColumn = TripleFoldAnimationConstants.MAX_COLUMN - itemColumn - 1;
        cubicBezierCurveParam =
          TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.MTG_CURVES_PARAM_LEFT,
            TripleFoldAnimationConstants.MTG_CURVES_PARAM_RIGHT, itemColumn, TripleFoldAnimationConstants.MAX_COLUMN);
        break;
      case SCBTripleStateChange.G_TO_M:
        cubicBezierCurveParam =
          TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.GTM_CURVES_PARAM_RIGHT,
            TripleFoldAnimationConstants.GTM_CURVES_PARAM_LEFT, itemColumn, TripleFoldAnimationConstants.MAX_COLUMN);
        break;
      case SCBTripleStateChange.F_TO_G:
        cubicBezierCurveParam =
          TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.FTG_CURVES_PARAM_RIGHT,
            TripleFoldAnimationConstants.FTG_CURVES_PARAM_LEFT, itemColumn, TripleFoldAnimationConstants.MAX_COLUMN);
        break;
      case SCBTripleStateChange.G_TO_F:
        itemColumn = TripleFoldAnimationConstants.MAX_COLUMN / 2 - itemColumn - 1;
        cubicBezierCurveParam =
          TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.GTF_CURVES_PARAM_LEFT,
          TripleFoldAnimationConstants.GTF_CURVES_PARAM_RIGHT, itemColumn, TripleFoldAnimationConstants.MAX_COLUMN / 2);
        break;
      default:
        cubicBezierCurveParam = 0;
        break;
    }
    return curves.cubicBezierCurve(cubicBezierCurveParam, TripleFoldAnimationConstants.ITEM_CURVES_PARAM_Y_FIRST,
      cubicBezierCurveParam, TripleFoldAnimationConstants.ITEM_CURVES_PARAM_Y_SECOND);
  }

  /**
   * Calculate alpha animation delay time of different column in triple fold product
   *
   * @param itemColumn number of item column
   * @param stateChange F/M/G change state
   * @returns alpha animation delay time
   */
  public static getTripleFoldExpandAlphaDelayTime(itemColumn: number, stateChange: SCBTripleStateChange): number {
    if (stateChange === SCBTripleStateChange.F_TO_M) {
      return TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.ALPHA_DELAY_TWO_HUNDRED,
        TripleFoldAnimationConstants.ALPHA_DELAY_ZERO, itemColumn, TripleFoldAnimationConstants.MAX_COLUMN);
    }
    if (stateChange === SCBTripleStateChange.M_TO_F || stateChange === SCBTripleStateChange.G_TO_F) {
      return TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.ALPHA_DELAY_ONE_HUNDRED,
        TripleFoldAnimationConstants.ALPHA_DELAY_ZERO, itemColumn, TripleFoldAnimationConstants.MAX_COLUMN / 2);
    }
    if (stateChange === SCBTripleStateChange.F_TO_G) {
      itemColumn = itemColumn - TripleFoldAnimationConstants.MAX_COLUMN / 2;
      return TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.ALPHA_DELAY_ONE_HUNDRED,
        TripleFoldAnimationConstants.ALPHA_DELAY_ZERO, itemColumn, stateChange);
    }
    return TripleFoldAnimationConstants.ALPHA_DELAY_ZERO;
  }

  /**
   * Calculate linear mapping triple fold and expand animation parameters
   *
   * @param max maximum boundary value
   * @param min minimum boundary value
   * @param itemColumn item column
   * @param stateChange F/M/G change state
   * @returns linear mapping value
   */
  public static getTripleLinearParam(max: number, min: number, itemColumn: number, totalColumns: number): number {
    return itemColumn / (totalColumns - 1) * (max - min) + min;
  }

  /**
   * Get initial alpha of item when device is three fold product
   *
   * @param stateChange F/M/G change state
   * @itemColumn item column
   * @returns initial item alpha
   */
  public static initTripleItemAlpha(stateChange: SCBTripleStateChange, itemColumn: number): number {
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.M_TO_F) {
      return 0;
    }
    if (stateChange === SCBTripleStateChange.F_TO_G && itemColumn >= TripleFoldAnimationConstants.MAX_COLUMN / 2) {
      return 0;
    }
    return 1;
  }

  /**
   * Calculate desktop item column
   *
   * @param item item information
   * @param indexInSwiper swiper page index
   * @param totalColumn total columns
   * @param stateChange F/M/G change state
   * @returns number of item column
   */
  public static getSwiperPageColumns(item: GridLayoutItemInfo, indexInSwiper: number, totalColumn: number,
    stateChange: SCBTripleStateChange): number {
    let column: number = 0;
    if (stateChange === SCBTripleStateChange.M_TO_F || stateChange === SCBTripleStateChange.G_TO_F) {
      column = item.column ? item.column : 0;
    } else {
      column = (item.column ? item.column : 0) + totalColumn * (indexInSwiper % TripleFoldAnimationConstants.PAGES_M);
    }
    // item.area[0] indicate the width of item: appIcon: 1, folder: 2, form: 2, 4
    // item.column indicate the left-based column, but center-based column required here
    item.area = item.area ? item.area : [0, 0];
    column = column + (item.area[0] - 1) / 2;
    log.showInfo('Swiper page column is %{public}d', column);
    return column;
  }

  /**
   * Calculate desktop item row
   *
   * @param item item information
   * @returns number of item row
   */
  public static getSwiperPageRows(item: GridLayoutItemInfo): number {
    let row: number = item.row ? item.row : 0;
    // item.area[0] indicate the width of item: appIcon: 1, folder: 2, form: 2, 4
    // item.column indicate the left-based column, but center-based column required here
    item.area = item.area ? item.area : [0, 0];
    row + (item.area[1] - 1) / 2;
    return row;
  }

  /**
   * Get init translateX of status bar
   *
   * @param screenWidth the width of current screen
   * @param stateChange F/M/G change state
   * @returns inital translateX
   */
  public static initTripleStatusBarTransX(screenWidth: number, stateChange: SCBTripleStateChange): number {
    let translateX: number = 0;
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.M_TO_F) {
      translateX = TripleFoldExpandAnimUtils.getDesktopAnimFactor(stateChange) * screenWidth;
    }
    return translateX;
  }

  /**
   * Get init translateX of indicator
   *
   * @param screenWidth the width of current screen
   * @param stateChange the state change of triple fold product
   * @returns translateX
   */
  public static initTripleIndicatorTransX(screenWidth: number, stateChange: SCBTripleStateChange): number {
    let translateX: number = 0;
    translateX = TripleFoldExpandAnimUtils.getDesktopAnimFactor(stateChange) * screenWidth;
    return translateX;
  }

  /**
   * Get indicator animation param in three fold product
   *
   * @param stateChange F/M/G change state
   * @returns indicator animation param
   */
  public static getIndicatorExpandAnimParam(stateChange: SCBTripleStateChange): AnimateParam {
    let traceName: string = 'Desktop-TripleFoldExpandAnimation_' + TripleFoldExpandAnimUtils.getTraceName(stateChange);
    if (stateChange === SCBTripleStateChange.M_TO_F || stateChange === SCBTripleStateChange.G_TO_F) {
      return {
        curve: TripleFoldExpandAnimUtils.getIconTripleFoldExpandAnimCurve(
          TripleFoldAnimationConstants.INDICATOR_COLUMN_F, stateChange),
        duration: TripleFoldAnimationConstants.ANIMATION_DURATION,
        onFinish: () => {
          performanceMonitor.end(traceName);
          // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, 0);
        }
      } as AnimateParam;
    }
    return {
      curve: TripleFoldExpandAnimUtils.getIconTripleFoldExpandAnimCurve(
        TripleFoldAnimationConstants.INDICATOR_COLUMN_MG, stateChange),
      duration: TripleFoldAnimationConstants.ANIMATION_DURATION,
      onFinish: () => {
        performanceMonitor.end(traceName);
        // ApsUtils.setApsScene(apsManager.SceneAnimation.FOLDING_SCREEN, 0);
      }
    } as AnimateParam;
  }

  /**
   * Get dock item column
   *
   * @param index item column
   * @param isResident whether item in Resident Dock
   * @returns [itemColumn, totalColumn]
   */
  public static getTripleDockColumn(index: number, isResident: boolean = true): number[] {
    const recentList: DockItemInfo[] = RecentLayoutCacheMgr.getInstance().getAllDockItems();
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let itemColumn: number = isResident ? index : (residentList.length ? index + residentList.length : index + 1);
    let visibleRecentLength: number | undefined = AppStorage.get<number>('visibleCount');
    if (visibleRecentLength === 0 || visibleRecentLength === undefined) {
      visibleRecentLength = recentList.length;
    }
    let totalColumn: number = residentList.length ? visibleRecentLength + residentList.length : visibleRecentLength + 1;
    return [itemColumn, totalColumn];
  }

  /**
   * Get Dock Background start translateX while devices is three fold product
   *
   * @param screenWidth screen' width
   * @returns number of translateX
   */
  public static initTripleDockAnimTranslateX(screenWidth: number, stateChange: SCBTripleStateChange): number {
    let translateX: number = 0;
    translateX = TripleFoldExpandAnimUtils.getDesktopAnimFactor(stateChange) * screenWidth;
    return translateX;
  }

  /**
   * Get Dock Background start alpha while devices is three fold product
   *
   * @param stateChange F/M/G change state
   * @returns initial dock background plane alpha
   */
  public static initTripleDockBgAnimAlpha(stateChange: SCBTripleStateChange): number {
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.F_TO_G) {
      return 0;
    }
    return 1;
  }

  /**
   * Get Dock Background end alpha while devices is three fold product
   *
   * @param stateChange F/M/G change state
   * @returns finial dock background plane alpha
   */
  public static getTripleDockBgAnimEndAlpha(stateChange: SCBTripleStateChange): number {
    return stateChange === SCBTripleStateChange.G_TO_F ? 0 : 1;
  }

  /**
   * Get Resident Dock item start alpha while devices is three fold product
   *
   * @returns initial dock item alpha
   */
  public static initTripleResidentDockItemAnimAlpha(stateChange: SCBTripleStateChange): number {
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.M_TO_F) {
      return 0;
    }
    return 1;
  }

  /**
   * Get Recent Dock item start alpha while devices is three fold product
   *
   * @returns initial dock item alpha
   */
  public static initTripleRecentDockItemAnimAlpha(stateChange: SCBTripleStateChange): number {
    if (stateChange === SCBTripleStateChange.F_TO_M || stateChange === SCBTripleStateChange.F_TO_G) {
      return 0;
    }
    return 1;
  }

  /**
   * get trace name when expand or fold
   * @param stateChange
   * @returns
   */
  public static getTraceName(stateChange: SCBTripleStateChange): string {
    let traceName: string = 'invalid';
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
        traceName = 'F_TO_M';
        break;
      case SCBTripleStateChange.M_TO_F:
        traceName = 'M_TO_F';
        break;
      case SCBTripleStateChange.M_TO_G:
        traceName = 'M_TO_G';
        break;
      case SCBTripleStateChange.G_TO_M:
        traceName = 'G_TO_M';
        break;
      case SCBTripleStateChange.F_TO_G:
        traceName = 'F_TO_G';
        break;
      case SCBTripleStateChange.G_TO_F:
        traceName = 'G_TO_F';
        break;
      default:
        traceName = 'invalid';
        break;
    }
    return traceName;
  }

  private static calculateSmallTransX(index: number): number {
    let screenF: number[] = TripleFoldExpandAnimUtils.screenPropertyF.getScreenProperty();
    let screenM: number[] = TripleFoldExpandAnimUtils.screenPropertyM.getScreenProperty();
    let screenG: number[] = TripleFoldExpandAnimUtils.screenPropertyG.getScreenProperty();
    let transX: number = 0;
    switch (index) {
      case 0:
        // F <-> G场景，如F态第0页展开至G态第0、1、2页
        if (screenF[2] !== 0 && screenG[2] !== 0) {
          transX = (screenG[0] + screenG[1]) - (screenF[0] + screenF[1]) + (screenG[2] - screenF[2]);
        }
        break;
      case 1:
        // M <-> G场景，ABC屏与B屏布局
        if (screenM[2] !== 0 && screenG[2] !== 0) {
          transX = (screenG[0] + screenG[1]) - (screenM[0] + screenM[1]) + (screenG[0] + screenG[1]) -
            (screenG[0] - screenG[1]) + screenG[0] + (screenG[2] - screenM[2]);
        }
        break;
      case 2:
        // M <-> G场景，ABC屏与C\A屏布局
        if (screenM[2] !== 0 && screenG[2] !== 0) {
          transX = (screenG[0] + screenG[1]) - (screenM[0] + screenM[1]) + (screenG[2] - screenM[2]);
        }
        break;
      default:
        transX = 0;
        break;
    }
    return transX;
  }

  public static getThreeDisplayColumn(item: GridLayoutItemInfo, index: number, mainIndex: number, totalColumn: number,
    stateChange: SCBTripleStateChange): number {
    let column: number = 0;
    if (!PageInfoManager.getInstance().isCurrentPageShow(index, mainIndex)) {
      return item.column ? item.column : 0;
    }
    switch (stateChange) {
      case SCBTripleStateChange.M_TO_F:
      case SCBTripleStateChange.G_TO_F:
      case SCBTripleStateChange.F_TO_M:
      case SCBTripleStateChange.G_TO_M:
        column = TripleFoldExpandAnimUtils.getSwiperPageColumns(item, index, totalColumn, stateChange);
        break;
      case SCBTripleStateChange.F_TO_G:
      case SCBTripleStateChange.M_TO_G:
        column = (item.column ? item.column : 0) + totalColumn * (index % TripleFoldAnimationConstants.PAGES_G);
        item.area = item.area ? item.area : [0, 0];
        column = column + (item.area[0] - 1) / 2;
        break;
      default:
        column = 0;
        break;
    }
    log.showInfo('Three display swiper page column is %{public}d', column);
    return column;
  }

  public static initThreeDisplayItemAnimationParam(screenWidth: number, stateChange: SCBTripleStateChange,
    isReversed: boolean, pageIndex: number): number[] {
    let itemAnimationParams: number[] = [0, 1, 1];
    let indexF: number = TripleFoldExpandAnimUtils.IndexMap.get(ScreenState.F) ?? 0;
    let indexM: number = TripleFoldExpandAnimUtils.IndexMap.get(ScreenState.M) ?? 0;
    let indexG: number = TripleFoldExpandAnimUtils.IndexMap.get(ScreenState.G) ?? 0;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
      case SCBTripleStateChange.M_TO_F:
        itemAnimationParams[0] = TripleFoldExpandAnimUtils.getDesktopAnimFactor(stateChange) * screenWidth;
        itemAnimationParams[1] = 0;
        itemAnimationParams[2] = 1;
        break;
      case SCBTripleStateChange.M_TO_G:
        itemAnimationParams =
          RTLUtil.isRTL() ? TripleFoldExpandAnimUtils.initMTGParamsRTL(screenWidth, isReversed, pageIndex, indexM,
            indexG) : TripleFoldExpandAnimUtils.initMTGParams(screenWidth, isReversed, pageIndex, indexM, indexG);
        break;
      case SCBTripleStateChange.G_TO_M:
        itemAnimationParams =
          RTLUtil.isRTL() ? TripleFoldExpandAnimUtils.initGTMParamsRTL(screenWidth, isReversed, pageIndex, indexM,
            indexG) : TripleFoldExpandAnimUtils.initGTMParams(screenWidth, isReversed, pageIndex, indexM, indexG);
        break;
      case SCBTripleStateChange.G_TO_F:
        let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(0);
        itemAnimationParams = [RTLUtil.isRTL() ? 2 * screenWidth : diff, 1, 1];
        if (pageIndex === indexG) {
          itemAnimationParams = [RTLUtil.isRTL() ? 2 * screenWidth + DEFAULT_TRANSLATE: diff, 1, 1];
        }
        break;
      case SCBTripleStateChange.F_TO_G:
        itemAnimationParams =
          RTLUtil.isRTL() ? TripleFoldExpandAnimUtils.initFTGParamsRTL(screenWidth, isReversed, pageIndex, indexF) :
            TripleFoldExpandAnimUtils.initFTGParams(screenWidth, isReversed, pageIndex, indexF);
        break;
      default:
        itemAnimationParams = [0, 1, 1];
        break;
    }
    log.showInfo(`initThreeDisplayItemAnimationParam, stateChange is ${stateChange}, params is ${itemAnimationParams}`);
    return itemAnimationParams;
  }

  private static initMTGParams(screenWidth: number, isReversed: boolean, pageIndex: number, indexM: number,
    indexG: number): number[] {
    let params: number[] = [0, 1, 1];
    let diff1: number = TripleFoldExpandAnimUtils.calculateSmallTransX(1);
    let diff2: number = TripleFoldExpandAnimUtils.calculateSmallTransX(2);
    switch (indexM % DEFAULT_THREE) {
      case 0:
        let diff: number = (pageIndex === indexM) ? diff2 : diff1;
        params[0] = isReversed ? -1 * diff : screenWidth / DEFAULT_THREE;
        params[1] = (isReversed && pageIndex === indexM + 2) ? 0 : 1;
        params[2] = (isReversed && pageIndex === indexM + 2) ? START_SCALE : 1;
        break;
      case 1:
          if (pageIndex === indexM - 1) {
          params = [isReversed ? -1 * screenWidth / DEFAULT_THREE : 0, isReversed ? 1 : 0, isReversed ? 1 : START_SCALE];
        } else {
          let diff: number = (pageIndex === indexM) ? diff1 : diff2;
          params = [isReversed ? -1 * screenWidth / DEFAULT_THREE : diff, 1, 1];
        }
        break;
      case 2:
        if (indexM < indexG) {
          params[0] = isReversed ? screenWidth / DEFAULT_THREE : 2 * screenWidth / DEFAULT_THREE;
        } else {
          params[0] = isReversed ? -2 * screenWidth / DEFAULT_THREE : -1 * screenWidth / DEFAULT_THREE;
        }
        params[1] = 1;
        params[2] = 1;
        break;
      default:
        params = [0, 1, 1];
        break;
    }
    return params;
  }

  private static initMTGParamsRTL(screenWidth: number, isReversed: boolean, pageIndex: number, indexM: number,
    indexG: number): number[] {
    let params: number[] = [0, 1, 1];
    let diff1: number = TripleFoldExpandAnimUtils.calculateSmallTransX(1);
    let diff2: number = TripleFoldExpandAnimUtils.calculateSmallTransX(2);
    let diff: number = 0;
    switch (indexM % DEFAULT_THREE) {
      case 0:
        diff = (pageIndex === indexM + 1) ? diff1 : 0;
        params[0] = isReversed ? -1 * screenWidth / DEFAULT_THREE : diff;
        if (pageIndex === indexM + 2) {
          params[1] = isReversed ? 1 : 0;
          params[2] = isReversed ? 1 : START_SCALE;
        }
        break;
      case 1:
        diff = (pageIndex === indexM - 1) ? 0 : ((pageIndex === indexM) ? diff1 : diff2);
        params[0] = isReversed ? -1 * diff : screenWidth / DEFAULT_THREE;
        if (pageIndex === indexM - 1) {
          params[1] = isReversed ? 0 : 1;
          params[2] = isReversed ? START_SCALE : 1;
        }
        break;
      case 2:
        params[0] =
          indexM < indexG ? (isReversed ? -2 * screenWidth / DEFAULT_THREE : -1 * screenWidth / DEFAULT_THREE) :
            (isReversed ? screenWidth / DEFAULT_THREE : 2 * screenWidth / DEFAULT_THREE);
        break;
      default:
        params = [0, 1, 1];
        break;
    }
    return params;
  }

  private static initGTMParams(screenWidth: number, isReversed: boolean, pageIndex: number, indexM: number,
    indexG: number): number[] {
    let params: number[] = [0, 1, 1];
    switch (indexG % DEFAULT_SIX) {
      case 0:
        if (indexG === indexM && pageIndex === indexM) {
          let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(2);
          params[0] = isReversed ? diff : -1 * screenWidth / 2;
        } else if (indexG === indexM && (pageIndex === indexM + 1 || pageIndex === indexM + 2)) {
          let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(1);
          params[0] = isReversed ? diff : -1 * screenWidth / 2;
        } else {
          params[0] = isReversed ? screenWidth : 1 * screenWidth / 2;
        }
        params[1] = 1;
        params[2] = 1;
        break;
      case 3:
        if (indexM === indexG - 1) {
          params[0] = isReversed ? -1 * screenWidth / 2 : -1 * screenWidth;
        } else {
          if (pageIndex === indexM) {
            let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(1);
            params[0] = isReversed ? screenWidth / 2 : -1 * diff;
          } else {
            let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(2);
            params[0] = isReversed ? screenWidth / 2 : -1 * diff;
          }
        }
        params[1] = 1;
        params[2] = 1;
        break;
      default:
        params = [0, 1, 1];
        break;
    }
    return params;
  }

  private static initGTMParamsRTL(screenWidth: number, isReversed: boolean, pageIndex: number, indexM: number,
    indexG: number): number[] {
    let params: number[] = [0, 1, 1];
    switch (indexG % DEFAULT_SIX) {
      case 0:
        if (indexG === indexM && pageIndex === indexM) {
          params[0] = isReversed ? screenWidth / 2 : 0;
        } else if (indexG === indexM && pageIndex === indexM + 1) {
          let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(1);
          params[0] = isReversed ? screenWidth / 2 : -1 * diff;
        } else {
          params[0] = isReversed ? -1 * screenWidth / 2 : -1 * screenWidth;
        }
        params[1] = 1;
        params[2] = 1;
        break;
      case 3:
        if (indexM === indexG - 1) {
          params[0] = isReversed ? screenWidth : screenWidth / 2;
        } else {
          if (pageIndex === indexM) {
            let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(1);
            params[0] = isReversed ? diff : -1 * screenWidth / 2;
          } else {
            let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(2);
            params[0] = isReversed ? diff : -1 * screenWidth / 2;
          }
        }
        params[1] = 1;
        params[2] = 1;
        break;
      default:
        params = [0, 1, 1];
        break;
    }
    return params;
  }

  private static initFTGParams(screenWidth: number, isReversed: boolean, pageIndex: number, indexF: number): number[] {
    let params: number[] = [0, 1, 1];
    switch (indexF % DEFAULT_THREE) {
      case 0:
        if (pageIndex === indexF) {
          let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(0);
          params = [isReversed ? 2 * screenWidth / DEFAULT_THREE : -1 * diff, 1, 1];
        } else {
          params = [isReversed ? -2 * screenWidth / DEFAULT_THREE : 0, isReversed ? 1 : 0, isReversed ? 1 : START_SCALE];
        }
        break;
      case 1:
        params = [isReversed ? screenWidth / DEFAULT_THREE : -1 * screenWidth / DEFAULT_THREE, 1, 1];
        break;
      case 2:
        if (pageIndex === indexF + 2) {
          let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(0);
          params = [isReversed ? -1 * diff : -2 * screenWidth / DEFAULT_THREE, 1, 1];
        } else {
          params = [isReversed ? 0 : -2 * screenWidth / DEFAULT_THREE, isReversed ? 0 : 1, isReversed ? START_SCALE : 1];
        }
        break;
      default:
        params = [0, 1, 1];
        break;
    }
    return params;
  }

  private static initFTGParamsRTL(screenWidth: number, isReversed: boolean, pageIndex: number,
    indexF: number): number[] {
    let params: number[] = [0, 1, 1];
    switch (indexF % DEFAULT_THREE) {
      case 0:
        params = [isReversed ? 2 * screenWidth / DEFAULT_THREE : -2 * screenWidth / DEFAULT_THREE, 1, 1];
        break;
      case 1:
        params = [isReversed ? screenWidth / DEFAULT_THREE : -1 * screenWidth / DEFAULT_THREE, 1, 1];
        break;
      case 2:
        if (pageIndex === indexF) {
          let diff: number = TripleFoldExpandAnimUtils.calculateSmallTransX(0);
          params = [-1 * diff, 1, 1];
        } else {
          params = [0, 0, START_SCALE];
        }
        break;
      default:
        params = [0, 1, 1];
        break;
    }
    return params;
  }

  public static getThreeDisplayItemCurves(itemColumn: number, index: number, mainIndex: number,
    stateChange: SCBTripleStateChange): ICurve {
    let curveParam: number = 0;
    let itemCurve: ICurve = TripleFoldAnimationConstants.TRANSLATE_CURVES;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
      case SCBTripleStateChange.M_TO_F:
        return TripleFoldExpandAnimUtils.getIconTripleFoldExpandAnimCurve(itemColumn, stateChange);
      case SCBTripleStateChange.M_TO_G:
        curveParam =
          TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.THREE_DISPLAY_MTG_CURVES_LEFT,
            TripleFoldAnimationConstants.THREE_DISPLAY_MTG_CURVES_RIGHT, itemColumn,
            TripleFoldAnimationConstants.THREE_DISPLAY_COLUMN);
        itemCurve = curves.cubicBezierCurve(curveParam, 0.1, curveParam, 1);
        // G态实际显示页面左侧页面，动画曲线参数保持一致，并且等于最左侧一列的曲线
        if (index < mainIndex) {
          itemCurve = TripleFoldAnimationConstants.CURVES_LEFT_MARGINAL;
        }
        // G态实际显示页面右侧页面，动画曲线参数保持一致，并且等于最右侧一列的曲线
        if (index > mainIndex + 2) {
          itemCurve = TripleFoldAnimationConstants.CURVES_RIGHT_MARGINAL;
        }
        return itemCurve;
      case SCBTripleStateChange.G_TO_M:
        curveParam =
          TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.THREE_DISPLAY_GTM_CURVES_RIGHT,
            TripleFoldAnimationConstants.THREE_DISPLAY_GTM_CURVES_LEFT, itemColumn,
            TripleFoldAnimationConstants.MAX_COLUMN);
        itemCurve = curves.cubicBezierCurve(curveParam, 0.1, curveParam, 1);
        // M态实际显示页面左侧页面，动画曲线参数保持一致，并且等于最左侧一列的曲线
        if (index < mainIndex) {
          itemCurve = TripleFoldAnimationConstants.CURVES_LEFT_MARGINAL;
        }
        // M态实际显示页面右侧页面，动画曲线参数保持一致，并且等于最右侧一列的曲线
        if (index > mainIndex + 1) {
          itemCurve = TripleFoldAnimationConstants.CURVES_RIGHT_MARGINAL;
        }
        return itemCurve;
      case SCBTripleStateChange.F_TO_G:
        curveParam = TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.FTG_CURVES_PARAM_RIGHT,
          TripleFoldAnimationConstants.FTG_CURVES_PARAM_LEFT, itemColumn,
          TripleFoldAnimationConstants.THREE_DISPLAY_COLUMN);
        itemCurve = curves.cubicBezierCurve(curveParam, 0.1, curveParam, 1);
        return itemCurve;
      case SCBTripleStateChange.G_TO_F:
        itemCurve = TripleFoldExpandAnimUtils.getIconTripleFoldExpandAnimCurve(itemColumn, stateChange);
        if (index < mainIndex || (index > mainIndex && RTLUtil.isRTL())) {
          itemCurve = TripleFoldAnimationConstants.CURVES_LEFT_MARGINAL;
        }
        return itemCurve;
      default:
        return curves.cubicBezierCurve(curveParam, TripleFoldAnimationConstants.ITEM_CURVES_PARAM_Y_FIRST,
          curveParam, TripleFoldAnimationConstants.ITEM_CURVES_PARAM_Y_SECOND);
    }
  }

  public static getThreeDisplayAlphaDelayTime(itemColumn: number, stateChange: SCBTripleStateChange): number {
    switch(stateChange) {
      case SCBTripleStateChange.F_TO_M:
      case SCBTripleStateChange.G_TO_M:
      case SCBTripleStateChange.M_TO_F:
      case SCBTripleStateChange.G_TO_F:
        return TripleFoldExpandAnimUtils.getTripleFoldExpandAlphaDelayTime(itemColumn, stateChange);
      case SCBTripleStateChange.F_TO_G:
      case SCBTripleStateChange.M_TO_G:
        return TripleFoldExpandAnimUtils.getTripleLinearParam(TripleFoldAnimationConstants.ALPHA_DELAY_TWO_HUNDRED,
          TripleFoldAnimationConstants.ALPHA_DELAY_ZERO, itemColumn, TripleFoldAnimationConstants.THREE_DISPLAY_COLUMN);
      default:
        return TripleFoldAnimationConstants.ALPHA_DELAY_ZERO;
    }
  }

  public static getThreeDisplayItemDuration(stateChange: SCBTripleStateChange): number {
    let indexM: number = TripleFoldExpandAnimUtils.IndexMap.get(ScreenState.M) ?? 0;
    let indexG: number = TripleFoldExpandAnimUtils.IndexMap.get(ScreenState.G) ?? 0;
    switch (stateChange) {
      case SCBTripleStateChange.F_TO_M:
      case SCBTripleStateChange.M_TO_F:
      case SCBTripleStateChange.F_TO_G:
      case SCBTripleStateChange.INVALID:
        return TripleFoldAnimationConstants.ANIMATION_DURATION;
      case SCBTripleStateChange.M_TO_G:
        if (indexM % DEFAULT_THREE === 1 && !RTLUtil.isRTL()) {
          // 非镜像语言：45->345场景
          return TripleFoldAnimationConstants.SHORT_ANIMATION_DURATION;
        }
        if (indexM % DEFAULT_THREE === 0 && RTLUtil.isRTL()) {
          // 镜像语言：01->012场景
          return TripleFoldAnimationConstants.SHORT_ANIMATION_DURATION;
        }
        return TripleFoldAnimationConstants.ANIMATION_DURATION;
      case SCBTripleStateChange.G_TO_M:
        if (indexG % DEFAULT_SIX === DEFAULT_THREE && indexM === indexG + 1 && !RTLUtil.isRTL()) {
          // 非镜像语言：345->45
          return TripleFoldAnimationConstants.SHORT_ANIMATION_DURATION;
        }
        if (indexG % DEFAULT_SIX === 0 && indexM === indexG && RTLUtil.isRTL()) {
          // 镜像语言：012->01
          return TripleFoldAnimationConstants.SHORT_ANIMATION_DURATION;
        }
        return TripleFoldAnimationConstants.ANIMATION_DURATION;
      case SCBTripleStateChange.G_TO_F:
        return RTLUtil.isRTL() ? TripleFoldAnimationConstants.LONG_ANIMATION_DURATION :
        TripleFoldAnimationConstants.SHORT_ANIMATION_DURATION;
    }
  }
}