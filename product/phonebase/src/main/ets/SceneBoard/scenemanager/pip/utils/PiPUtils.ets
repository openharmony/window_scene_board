/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import {
  ScbNumber,
  SCBSessionRect,
  SCBScreenProperty,
  ResUtils
} from '@ohos/windowscene';
import { LogDomain, LogHelper, CommonUtils, RectItem} from '@ohos/basicutils';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import { Constants, PipRectUpdateReason } from './PictureInPictureConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { display } from '@kit.ArkUI';
import { GridConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SCBPiPManager } from '../SCBPiPManager';

const TAG = 'PipRectCalculator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const SCALE_NORMAL: number = 1;
const SCALE_LARGE: number = 2;
const SCALE_MANUAL: number = 3;
const PAD_VP_BELOW: number = 840;
const FOLD_SCREEN_VP_BELOW: number = 520;
const PAD_GRID_COLUMN_NUMBER: number = 12;
const FOLD_GRID_COLUMN_NUMBER: number = 8;
const PHONE_GRID_COLUMN_NUMBER: number = 4;
const GRID_ROW_GUTTER = 12;
const LONG_PIP_GRID_COLUMN: number = 3;
const SHORT_PIP_GRID_COLUMN = 5;
const POSITIVE_COORDINATE = 0;
const NEGATIVE_COORDINATE = 1;
const SQUARE_MIN_GRID_COLUMN = 2;
const SQUARE_MAX_GRID_COLUMN = 4;
const SQUARE_RATIO_LOWER = 0.89;
const SQUARE_RATIO_UPPER = 1;
const MIN_PIP_WIDTH = 96;
const MIN_PIP_HEIGHT = 48;
const PAD_GRID_GUTTER = 16;
const PAD_GRID_MARGIN = 32;
const SIZE_TYPE_NOT_SET = 0;
const SIZE_TYPE_SMALL = 1;
const SIZE_TYPE_LARGE = 2;

PersistentStorage.persistProp(Constants.KEY_PIP_SCALE, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_POS_X, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_POS_Y, 0);
PersistentStorage.persistProp(Constants.PIP_OLD_SCREEN_STATUS, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_WIDTH, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_HEIGHT, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_MIN_SCALE_VALUE, 1);
PersistentStorage.persistProp(Constants.KEY_PIP_DRAG_SCALE_VALUE, 1);

export class RectChangeItem {
  public rect: sceneSessionManager.SessionRect;
  public reason: sceneSessionManager.SessionSizeChangeReason;

  constructor(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason) {
    this.rect = rect;
    this.reason = reason;
  }
}

/*
 * Fix Point when drag
 * */
export enum Pin {
  LEFT_TOP,
  CENTER_TOP,
  RIGHT_TOP,
  CENTER_BOTTOM,
  LEFT_BOTTOM,
  RIGHT_BOTTOM
}

export class PipRect extends RectItem {
  public pinTmp: Pin = Pin.LEFT_TOP;
  public axisX: boolean = true;
  public dragDownRect: RectItem = new RectItem(0, 0, 0, 0);
  public aspectRatio: number = 1;
  public scale: number = 1;

  private setScaleWithCalculate(scaleValue: number): void {
    this.scale = scaleValue;
    this.right = this.width() * scaleValue + this.left;
    this.bottom = this.height() * scaleValue + this.top;
  }
  /**
   * generate pipRect with containerSession
   * @param currRect
   * @param currScale
   */
  public static generateWithContainerSession(currRect: SCBSessionRect, currScale: number): PipRect {
    let rect = new PipRect(currRect.left.getVp(), currRect.top.getVp(),
      currRect.width.getVp() + currRect.left.getVp(), currRect.height.getVp() + currRect.top.getVp());
    let scale = currScale;
    rect.setScaleWithCalculate(scale);
    let height = rect.height();
    if (height !== 0) {
      rect.aspectRatio = rect.width() / height;
    }
    rect.dragDownRect.setRect(rect);
    return rect;
  }
  /**
   * expand width consider aspect ratio
   * @param added
   */
  public expandWidthWithAspect(added: number): void {
    this.right += added;
    if (this.aspectRatio === 0) {
      return;
    }
    this.bottom = this.top + this.width() / this.aspectRatio;
  }
  /**
   * expand height consider aspect ratio
   * @param added
   */
  public expandHeightWithAspect(added: number): void {
    this.bottom += added;
    this.right = this.left + this.height() * this.aspectRatio;
  }
  /**
   * pip dragScale pinToAnchor
   */
  public pinToAnchor(): void {
    if (this.pinTmp === Pin.LEFT_TOP) {
      this.offset(this.dragDownRect.left - this.left, this.dragDownRect.top - this.top);
    } else if (this.pinTmp === Pin.RIGHT_TOP) {
      this.offset(this.dragDownRect.right - this.right, this.dragDownRect.top - this.top);
    } else if (this.pinTmp === Pin.CENTER_TOP) {
      this.offset(this.dragDownRect.centerX() - this.centerX(), this.dragDownRect.top - this.top);
    } else if (this.pinTmp === Pin.CENTER_BOTTOM) {
      this.offset(this.dragDownRect.centerX() - this.centerX(), this.dragDownRect.bottom - this.bottom);
    } else if (this.pinTmp === Pin.LEFT_BOTTOM) {
      this.offset(this.dragDownRect.left - this.left, this.dragDownRect.bottom - this.bottom);
    } else {
      this.offset(this.dragDownRect.right - this.right, this.dragDownRect.bottom - this.bottom);
    }
  }
}

export enum Pivot {
  UNDEFINED = 0,
  START,
  MIDDLE,
  END,
}

export enum ScaleChangeType {
  NORMAL_TO_MIDDLE = 0,
  LARGE_TO_MIDDLE = 1,
  DEFAULT = 2
}

export enum ScaleLevel {
  SCALE_LEVEL_NORMAL = 0,
  SCALE_LEVEL_LARGE = 1,
  SCALE_LEVEL_MIDDLE = 2,
  COUNT = 3
}

export interface ScalePivot {
  pivotX: Pivot;
  pivotY: Pivot;
}

export interface SizeInfo {
  originWidth: number;
  originHeight: number;
  pivot: ScalePivot;
  scaleLevel: ScaleLevel;
  isSquare: boolean;
}

export class PipRectCalculator {
  public isMoving: boolean = false;
  private requestRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private currentRotation: number = 0;

  // these vars are used to save the rect position and quadrant before ratioChange,
  // to ensure a correct transform when ratioChange happen
  private basePosX: number = 0;
  private basePosY: number = 0;
  public quadrantX: number = 0;
  public quadrantY: number = 0;

  public cameraAvoidArea: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);

  public sizeInfo: SizeInfo = {
    originWidth: 0,
    originHeight: 0,
    pivot: { pivotX: Pivot.UNDEFINED, pivotY: Pivot.UNDEFINED },
    scaleLevel: ScaleLevel.SCALE_LEVEL_NORMAL,
    isSquare: false
  };

  private async resetCameraAvoidArea(): Promise<void> {
    try {
      let info = await display.getDefaultDisplaySync().getCutoutInfo();
      if (info.boundingRects.length >= 1) {
        this.cameraAvoidArea.setRectNum(info.boundingRects[0].left, info.boundingRects[0].top,
          info.boundingRects[0].width, info.boundingRects[0].height);
      }
    } catch (err) {
      log.showError(`resetCameraAvoidArea error msg: ${err.message}`);
      this.cameraAvoidArea.setRectNum(0, 0, 0, 0);
    }
  }

  public getCameraAvoidArea(): SCBSessionRect {
    return this.cameraAvoidArea;
  }

  public setIsMoving(isMove: boolean): void {
    this.isMoving = isMove;
  }

  public isMoveOrDrag(): boolean {
    return this.isMoving;
  }

  public isFolded(): boolean {
    return false;
  }

  public isExpanded(reason: PipRectUpdateReason): boolean {
    return (DeviceHelper.isFoldButNotSmallFoldProduct()) &&
      (this.getFoldStatus() === display.FoldStatus.FOLD_STATUS_EXPANDED ||
        this.getFoldStatus() === display.FoldStatus.FOLD_STATUS_HALF_FOLDED ||
        reason === PipRectUpdateReason.REASON_PIP_EXPAND);
  }

  public getFoldStatus(): display.FoldStatus {
    try {
      return display.getFoldStatus();
    } catch (e) {
      log.showError(`getFoldStatus error: ${e}`);
    }
    return display.FoldStatus.FOLD_STATUS_UNKNOWN;
  }

  public updatePipRectPivotInfo(rect: SCBSessionRect, displayWidth: number, displayHeight: number): void {
    if (!CommonUtils.isInvalid(rect)) {
      let pivot: ScalePivot = this.getScalePivot(rect, displayWidth, displayHeight);
      this.sizeInfo.pivot = pivot;
    }
  }

  public getCurrentScreenRotation(): number {
    return this.currentRotation;
  }

  public getScalePivot(rect: SCBSessionRect, displayWidth: number, displayHeight: number): ScalePivot {
    let scalePivot: ScalePivot = { pivotX: Pivot.UNDEFINED, pivotY: Pivot.UNDEFINED };
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`getScalePivot rect is null`);
      return scalePivot;
    }
    let endX = displayWidth - rect.left.getPx() - rect.width.getPx();
    if (Math.floor(rect.left.getPx()) > Math.floor(endX)) {
      scalePivot.pivotX = Pivot.END;
    } else if (Math.floor(rect.left.getPx()) < Math.floor(endX)) {
      scalePivot.pivotX = Pivot.START;
    } else {
      scalePivot.pivotX = Pivot.MIDDLE;
    }

    let endY = displayHeight - rect.top.getPx() - rect.height.getPx();
    if (Math.floor(rect.top.getPx()) > Math.floor(endY)) {
      scalePivot.pivotY = Pivot.END;
    } else if (Math.floor(rect.top.getPx()) < Math.floor(endY)) {
      scalePivot.pivotY = Pivot.START;
    } else {
      scalePivot.pivotY = Pivot.MIDDLE;
    }
    return scalePivot;
  }

  public getRectByPivot(rect: SCBSessionRect, originRect: SCBSessionRect, displayWidth: number,
    displayHeight: number, pivot: ScalePivot): SCBSessionRect {
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`getRectByPivot rect is null`);
      return rect;
    }
    let res: SCBSessionRect = rect.copy();
    switch (pivot.pivotX) {
      case Pivot.START:
        break;
      case Pivot.MIDDLE:
        res.left = new ScbNumber((displayWidth - rect.width.getPx()) / Constants.NUMBER_TWO);
        break;
      case Pivot.END:
        res.left = new ScbNumber(rect.left.getPx() - (rect.width.getPx() - originRect.width.getPx()));
        break;
      default:
        break;
    }
    switch (pivot.pivotY) {
      case Pivot.START:
        break;
      case Pivot.MIDDLE:
        res.top = new ScbNumber((displayHeight - rect.height.getPx()) / Constants.NUMBER_TWO);
        break;
      case Pivot.END:
        res.top = new ScbNumber(rect.top.getPx() - (rect.height.getPx() - originRect.height.getPx()));
        break;
      default:
        break;
    }
    return res;
  }

  public isSquare(): boolean {
    let dividend = this.sizeInfo.originWidth;
    let divider = this.sizeInfo.originHeight;
    if (dividend === 0 || divider === 0) {
      return false;
    }
    if (dividend > divider) {
      dividend = this.sizeInfo.originHeight;
      divider = this.sizeInfo.originWidth;
    }
    let ratio = dividend / divider;
    return (ratio - SQUARE_RATIO_LOWER > -Number.EPSILON) && (ratio - SQUARE_RATIO_UPPER < Number.EPSILON);
  }

  public calcWinRectLand(width: number, height: number, winWidth: number, winHeight: number): SCBSessionRect {
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    if (winWidth === 0 || winHeight === 0) {
      log.showError(`calcWinRectLand winWidth or winHeight is 0`);
      return rect;
    }
    let heightTmp: number = height - Constants.SAFE_PADDING_VERTICAL_TOP - Constants.SAFE_PADDING_VERTICAL_BOTTOM;
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);
    if (winWidth <= winHeight || this.sizeInfo.isSquare) {
      let widthTmp: number =
        (Constants.NUMBER_THREE * width) - Constants.NUMBER_SEVEN * safePaddingHorizontal / Constants.NUMBER_FOUR;
      rect.width = new ScbNumber(widthTmp);
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
      if (rect.height.getPx() > heightTmp) {
        rect.height = new ScbNumber(heightTmp);
        rect.width = new ScbNumber(rect.height.getPx() * winWidth / winHeight);
      }
    } else {
      rect.width = new ScbNumber(height - 2 * safePaddingHorizontal);
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
    }
    return rect;
  }

  public getGridRowWidth(landScreenWidth: number, gridCount: number, occupiedGrid: number): number {
    if (gridCount === 0) {
      log.showInfo(`gridCount is 0`);
      gridCount = PHONE_GRID_COLUMN_NUMBER;
    }
    let gutter = vp2px(GRID_ROW_GUTTER);
    let aveWidth = (landScreenWidth - gutter * (gridCount + 1)) / gridCount;
    return aveWidth * occupiedGrid + gutter * (occupiedGrid - 1);
  }

  public getWidthByLandScreenWidth(landScreenWidth: number, occupiedGrid: number): number {
    if (px2vp(landScreenWidth) >= PAD_VP_BELOW) {
      return this.getGridRowWidth(landScreenWidth, PAD_GRID_COLUMN_NUMBER, occupiedGrid);
    } else if (px2vp(landScreenWidth) >= FOLD_SCREEN_VP_BELOW) {
      return this.getGridRowWidth(landScreenWidth, FOLD_GRID_COLUMN_NUMBER, occupiedGrid);
    } else {
      return this.getGridRowWidth(landScreenWidth, PHONE_GRID_COLUMN_NUMBER, occupiedGrid);
    }
  }

  public calculateRectWhenExpand(width: number, height: number,
    sourceRect: SCBSessionRect, isLandscape: boolean, rect: SCBSessionRect) {
    if (CommonUtils.isInvalid(rect) || CommonUtils.isInvalid(sourceRect)) {
      log.showError(`calculateRectWhenExpand sourceRect or rect is null`);
      return;
    }
    let winWidth: number = sourceRect.width.getPx();
    let winHeight: number = sourceRect.height.getPx();
    let widthTmp: number = 0;
    let mainWidth: number = width;
    if (isLandscape) {
      mainWidth = height;
    }
    if (this.sizeInfo.isSquare) {
      widthTmp = this.getWidthByLandScreenWidth(mainWidth, SQUARE_MAX_GRID_COLUMN);
    } else if (winWidth < winHeight) {
      widthTmp = this.getWidthByLandScreenWidth(mainWidth, LONG_PIP_GRID_COLUMN);
    } else {
      widthTmp = this.getWidthByLandScreenWidth(mainWidth, SHORT_PIP_GRID_COLUMN);
    }
    rect.width = new ScbNumber(widthTmp);
    if (winWidth !== 0) {
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
    }
  }

  public calcWinRectForPad(width: number, height: number, sourceRect: SCBSessionRect,
                            scaleLevel: ScaleLevel): SCBSessionRect {
    if (CommonUtils.isInvalid(sourceRect)) {
      log.showError(`calcWinRectForPad sourceRect is null`);
      return sourceRect;
    }
    let winWidth: number = sourceRect.width.getPx();
    let winHeight: number = sourceRect.height.getPx();
    if (winWidth === 0 || winHeight === 0) {
      log.showError(`calcWinRectLand winWidth or winHeight is 0`);
      return sourceRect;
    }
    let rect: SCBSessionRect = sourceRect.copy();
    let shortEdge: number = width < height ? width : height;
    let longEdge: number = width > height ? width : height;
    if (scaleLevel === ScaleLevel.SCALE_LEVEL_NORMAL) {
      if (winWidth <= winHeight) {
        let statusHeight = vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height')));
        rect.width = new ScbNumber((shortEdge - statusHeight * 2) *
        Constants.DEFAULT_PROPORTION * Constants.PAD_DEFAULT_PROPORTION);
        rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
      } else {
        rect.width = new ScbNumber(shortEdge * Constants.DEFAULT_PROPORTION);
        rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
      }
      return rect;
    }
    if (scaleLevel === ScaleLevel.SCALE_LEVEL_LARGE) {
      let heightTmp: number = shortEdge - Constants.SAFE_PADDING_VERTICAL_TOP - Constants.SAFE_PADDING_VERTICAL_BOTTOM;
      let gutter = vp2px(PAD_GRID_GUTTER);
      const aveWidth = (longEdge - gutter * (GridConstants.RESPECT_NUM_MAX - 1) - vp2px(PAD_GRID_MARGIN * 2)) /
      GridConstants.RESPECT_NUM_MAX;
      if (winWidth <= winHeight) {
        rect.width = new ScbNumber(aveWidth * Constants.NUMBER_THREE + gutter * Constants.NUMBER_TWO);
        rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
        if (rect.height.getPx() > heightTmp) {
          rect.height = new ScbNumber(heightTmp);
          rect.width = new ScbNumber(rect.height.getPx() * winWidth / winHeight);
        }
      } else {
        rect.width = new ScbNumber(aveWidth * Constants.NUMBER_FIVE + gutter * Constants.NUMBER_FOUR);
        rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
      }
    }
    log.showDebug('calcWinRectForPad scaleLevel is abnormal');
    return rect;
  }

  private getRectOnDragScaleForPad(width: number, height: number, sourceRect: SCBSessionRect,
    isLandscape: boolean, reason: PipRectUpdateReason): SCBSessionRect {
    if (CommonUtils.isInvalid(sourceRect)) {
      log.showError(`calcWinRectForPad sourceRect is null`);
      return sourceRect;
    }
    let winWidth: number = sourceRect.width.getPx();
    let winHeight: number = sourceRect.height.getPx();
    if (winWidth === 0 || winHeight === 0) {
      log.showError(`calcWinRectLand winWidth or winHeight is 0`);
      return sourceRect;
    }
    let rect: SCBSessionRect = sourceRect.copy();
    let shortEdge: number = width < height ? width : height;
    let longEdge: number = width > height ? width : height;

    let nowScale: number = this.getMiddleScale(width, height, sourceRect, isLandscape, reason);
    let heightTmp: number = shortEdge - Constants.SAFE_PADDING_VERTICAL_TOP - Constants.SAFE_PADDING_VERTICAL_BOTTOM;
    let gutter = vp2px(PAD_GRID_GUTTER);
    const aveWidth = (longEdge - gutter * (GridConstants.RESPECT_NUM_MAX - 1) - vp2px(PAD_GRID_MARGIN * 2)) /
    GridConstants.RESPECT_NUM_MAX;
    if (winWidth <= winHeight) {
      rect.width = new ScbNumber(aveWidth * Constants.NUMBER_THREE + gutter * Constants.NUMBER_TWO);
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
      if (rect.height.getPx() > heightTmp) {
        rect.height = new ScbNumber(heightTmp);
        rect.width = new ScbNumber(rect.height.getPx() * winWidth / winHeight);
      }
    } else {
      rect.width = new ScbNumber(aveWidth * Constants.NUMBER_FIVE + gutter * Constants.NUMBER_FOUR);
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
    }
    this.fixRectSizeIfNeeded(rect, width, height, isLandscape);
    rect.width = new ScbNumber(rect.width.getPx() * nowScale);
    rect.height = new ScbNumber(rect.height.getPx() * nowScale);
    return rect;
  }

  private getRectOnDragScale(width: number, height: number,
    sourceRect: SCBSessionRect, isLandscape: boolean, reason: PipRectUpdateReason): SCBSessionRect {
    log.showInfo(`calculate after dragScale rectSize`);
    let winWidth: number = sourceRect.width.getPx();
    let winHeight: number = sourceRect.height.getPx();
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);
    let nowScale: number = this.getMiddleScale(width, height, sourceRect, isLandscape, reason);
    let rect: SCBSessionRect = sourceRect.copy();
    if (this.isExpanded(reason)) {
      this.calculateRectWhenExpand(width, height, sourceRect, isLandscape, rect);
    }
    if (isLandscape) {
      let landRect = this.calcWinRectLand(width, height, winWidth, winHeight);
      if (landRect.width.getPx() !== 0 && landRect.height.getPx() !== 0) {
        rect.width = landRect.width;
        rect.height = landRect.height;
      }
    } else {
      let widthTmp: number = 0;
      if (this.sizeInfo.isSquare || winWidth >= winHeight) {
        widthTmp = width - Constants.NUMBER_TWO * safePaddingHorizontal;
      } else {
        widthTmp = (Constants.NUMBER_THREE * width -
          Constants.NUMBER_SEVEN * safePaddingHorizontal) / Constants.NUMBER_FOUR;
      }
      rect.width = new ScbNumber(widthTmp);
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
    }
    this.fixRectSizeIfNeeded(rect, width, height, isLandscape);
    rect.width = new ScbNumber(rect.width.getPx() * nowScale);
    rect.height = new ScbNumber(rect.height.getPx() * nowScale);
    return rect;
  }

  private getMiddleScale(width: number, height: number,
    sourceRect: SCBSessionRect, isLandscape: boolean, reason: PipRectUpdateReason): number {
    let nowScale: number = AppStorage.get(Constants.KEY_PIP_DRAG_SCALE_VALUE) as number;
    let rectNormal = this.getRectByScale(width, height, ScaleLevel.SCALE_LEVEL_NORMAL, sourceRect, isLandscape, reason);
    let rectLarge = this.getRectByScale(width, height, ScaleLevel.SCALE_LEVEL_LARGE, sourceRect, isLandscape, reason);
    let scaleX = rectNormal.width.getPx() / rectLarge.width.getPx();
    let scaleY = rectNormal.height.getPx() / rectLarge.height.getPx();
    let normalScale = Math.min(scaleX, scaleY);
    return Math.max(normalScale, Math.min(nowScale, 1));
  }

  public getRectOnNormalScale(width: number, height: number,
                               sourceRect: SCBSessionRect, rect: SCBSessionRect, reason: PipRectUpdateReason) {
    let winWidth: number = sourceRect.width.getPx();
    let winHeight: number = sourceRect.height.getPx();
    if (winWidth === 0 || winHeight === 0) {
      log.showError(`getRectOnNormalScale winWidth or winHeight is 0`);
      return;
    }
    let proportion = this.isExpanded(reason) ? Constants.DEFAULT_EXPAND_PROPORTION : Constants.DEFAULT_PROPORTION;
    let shortScreenLength = width < height ? width : height;
    let shortBorder: number = shortScreenLength * proportion;
    if (this.sizeInfo.isSquare) {
      shortBorder = this.getWidthByLandScreenWidth(shortScreenLength, SQUARE_MIN_GRID_COLUMN);
      rect.width = new ScbNumber(shortBorder);
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
    } else if (winWidth < winHeight) {
      rect.width = new ScbNumber(shortBorder);
      rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
    } else {
      rect.height = new ScbNumber(shortBorder);
      rect.width = new ScbNumber(rect.height.getPx() * winWidth / winHeight);
    }
  }


  /**
   * get pipRect by scaleLevel
   * @param width
   * @param height
   * @param scaleLevel
   * @param sourceRect
   * @param isLandscape
   * @param reason
   * @return pipRect
   */
  public getRectByScale(width: number, height: number, scaleLevel: ScaleLevel, sourceRect: SCBSessionRect,
    isLandscape: boolean, reason: PipRectUpdateReason): SCBSessionRect {
    //calculate pad or G state of triple fold product
    if (uiType === SCBConstants.UITYPE_PAD || SCBTriFoldManager.getInstance().isCurGState()) {
      log.showInfo('calculate pad or triple fold product');
      if (scaleLevel === ScaleLevel.SCALE_LEVEL_MIDDLE) {
        return this.getRectOnDragScaleForPad(width, height, sourceRect, isLandscape, reason);
      }
      return this.calcWinRectForPad(width, height, sourceRect, scaleLevel);
    }
    if (CommonUtils.isInvalid(sourceRect)) {
      log.showError(`getRectByScale sourceRect is null`);
      return sourceRect;
    }
    let winWidth: number = sourceRect.width.getPx();
    let winHeight: number = sourceRect.height.getPx();
    if (winWidth === 0 || winHeight === 0) {
      return sourceRect;
    }
    let rect: SCBSessionRect = sourceRect.copy();
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);
    switch (scaleLevel) {
      case ScaleLevel.SCALE_LEVEL_NORMAL: {
        this.getRectOnNormalScale(width, height, sourceRect, rect, reason);
        break;
      }
      case ScaleLevel.SCALE_LEVEL_LARGE: {
        if (this.isExpanded(reason)) {
          this.calculateRectWhenExpand(width, height, sourceRect, isLandscape, rect);
          break;
        }
        if (isLandscape) {
          let landRect = this.calcWinRectLand(width, height, winWidth, winHeight);
          if (landRect.width.getPx() !== 0 && landRect.height.getPx() !== 0) {
            rect.width = landRect.width;
            rect.height = landRect.height;
          }
        } else {
          let widthTmp: number = 0;
          if (this.sizeInfo.isSquare || winWidth >= winHeight) {
            widthTmp = width - Constants.NUMBER_TWO * safePaddingHorizontal;
          } else {
            widthTmp = (Constants.NUMBER_THREE * width -
              Constants.NUMBER_SEVEN * safePaddingHorizontal) / Constants.NUMBER_FOUR;
          }
          rect.width = new ScbNumber(widthTmp);
          rect.height = new ScbNumber(rect.width.getPx() * winHeight / winWidth);
        }
        break;
      }
      case ScaleLevel.SCALE_LEVEL_MIDDLE: {
        rect = this.getRectOnDragScale(width, height, sourceRect, isLandscape, reason);
        break;
      }
      default:
        break;
    }
    return rect;
  }
  /**
   * set pip ScaleLevel
   * @param scaleLevel
   */
  public setScaleLevel(scaleLevel: ScaleLevel): void {
    this.sizeInfo.scaleLevel = scaleLevel;
  }

  public initPipRectInfo(requestRct: SCBSessionRect): boolean {
    if (requestRct.width.getPx() === 0 || requestRct.height.getPx() === 0) {
      return false;
    }
    this.clearPipRectPivotInfo();
    this.sizeInfo.originWidth = requestRct.width.getPx();
    this.sizeInfo.originHeight = requestRct.height.getPx();
    this.sizeInfo.scaleLevel = this.getScaleLevel();
    this.sizeInfo.isSquare = this.isSquare();
    return true;
  }

  private clearPipRectPivotInfo(): void {
    this.sizeInfo.pivot.pivotX = Pivot.UNDEFINED;
    this.sizeInfo.pivot.pivotY = Pivot.UNDEFINED;
  }

  public saveScaleLevel(): void {
    AppStorage.set(Constants.KEY_PIP_SCALE, this.sizeInfo.scaleLevel.valueOf());
  }

  public getScaleLevelInt(): number {
    if (this.sizeInfo.scaleLevel === ScaleLevel.SCALE_LEVEL_NORMAL) {
      return SCALE_NORMAL;
    }
    if (this.sizeInfo.scaleLevel === ScaleLevel.SCALE_LEVEL_LARGE) {
      return SCALE_LARGE;
    }
    return SCALE_MANUAL;
  }

  private getStorageScaleLevel(): ScaleLevel {
    return AppStorage.get(Constants.KEY_PIP_SCALE) as ScaleLevel;
  }

  private getScaleLevel(): ScaleLevel {
    let sceneSession = SCBPiPManager.getInstance().getPipSceneSession();
    if (!sceneSession) {
      return this.getStorageScaleLevel();
    }
    let isPipFirstStart = sceneSession.sessionData.pipStartCount === 0;
    sceneSession.sessionData.pipStartCount++;
    if (!isPipFirstStart) {
      let scaleLevel = SCBPiPManager.getInstance().getColdStartScale(sceneSession.session.persistentId);
      if (scaleLevel > -1) {
        return scaleLevel;
      }
      return this.getStorageScaleLevel();
    }
    let pipOptionScaleLevel: ScaleLevel | undefined = undefined;
    let defaultWindowSizeType = sceneSession.session?.pipTemplateInfo?.defaultWindowSizeType;
    switch (defaultWindowSizeType) {
      case SIZE_TYPE_SMALL:
        pipOptionScaleLevel = ScaleLevel.SCALE_LEVEL_NORMAL;
        break;
      case SIZE_TYPE_LARGE:
        pipOptionScaleLevel = ScaleLevel.SCALE_LEVEL_LARGE;
        break;
    }
    if (pipOptionScaleLevel !== undefined) {
      SCBPiPManager.getInstance().recordColdStartScale(sceneSession.session.persistentId, pipOptionScaleLevel);
      log.showInfo(`getScaleLevel, pipOptionScaleLevel: ${pipOptionScaleLevel}`);
      return pipOptionScaleLevel;
    }
    return this.getStorageScaleLevel();
  }

  public savePipPositionAndLevel(posX: number, posY: number): void {
    AppStorage.set(Constants.KEY_PIP_WINDOW_POS_X, posX);
    AppStorage.set(Constants.KEY_PIP_WINDOW_POS_Y, posY);
    this.saveScaleLevel();
  }

  public updateRectPosition(rect: SCBSessionRect, displayWidth: number, displayHeight: number) {
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`updateRectPosition rect is null`);
      return;
    }
    if (this.quadrantX === POSITIVE_COORDINATE) {
      rect.left = new ScbNumber(this.basePosX - rect.width.getPx());
    } else {
      rect.left = new ScbNumber(this.basePosX);
    }
    if (this.quadrantY === POSITIVE_COORDINATE) {
      rect.top = new ScbNumber(this.basePosY);
    } else {
      rect.top = new ScbNumber(this.basePosY - rect.height.getPx());
    }
    this.updatePipRectPivotInfo(rect, displayWidth, displayHeight);
    log.showInfo(`ratio change rect[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},` +
      `${rect.height.getPx()}], quadrant[${this.quadrantX},${this.quadrantY}]`);
  }

  public updateQuadrantAndPos(rect: SCBSessionRect, displayWidth: number, displayHeight: number) {
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`updateQuadrantAndPos rect is null`);
      return;
    }
    let rectCenterX = rect.left.getPx() + rect.width.getPx() / Constants.NUMBER_TWO;
    let rectCenterY = rect.top.getPx() + rect.height.getPx() / Constants.NUMBER_TWO;
    if (Math.floor(rectCenterX) >= Math.floor(displayWidth / Constants.NUMBER_TWO)) {
      this.quadrantX = POSITIVE_COORDINATE;
      this.basePosX = rect.left.getPx() + rect.width.getPx();
    } else {
      this.quadrantX = NEGATIVE_COORDINATE;
      this.basePosX = rect.left.getPx();
    }

    if (Math.floor(rectCenterY) <= Math.floor(displayHeight / Constants.NUMBER_TWO)) {
      this.quadrantY = POSITIVE_COORDINATE;
      this.basePosY = rect.top.getPx();
    } else {
      this.quadrantY = NEGATIVE_COORDINATE;
      this.basePosY = rect.top.getPx() + rect.height.getPx();
    }
    log.showInfo(`updateQuadrantAndPos pos:[${this.basePosX},${this.basePosY}]` +
      ` quadrant:[${this.quadrantX},${this.quadrantY}]`);
  }

  public calcNewPipRect(displayWidth: number, displayHeight: number, sourceRect: SCBSessionRect,
    isLandscape: boolean, reason: PipRectUpdateReason): SCBSessionRect {
    let rect: SCBSessionRect = this.getRectByScale(
      displayWidth, displayHeight, this.sizeInfo.scaleLevel, sourceRect, isLandscape, reason);
    log.showInfo(`scale rect[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},` +
      `${rect.height.getPx()}],isLandscape:${isLandscape}`);

    this.fixRectSizeIfNeeded(rect, displayWidth, displayHeight, isLandscape);

    if (reason === PipRectUpdateReason.REASON_PIP_RATIO_CHANGE) {
      this.updateRectPosition(rect, displayWidth, displayHeight);
    } else {
      if ((reason !== PipRectUpdateReason.REASON_PIP_START) && rect.width.getPx() !== 0 &&
        rect.height.getPx() !== 0 && !this.isMoving) {
        if (this.sizeInfo.pivot.pivotX === Pivot.UNDEFINED || this.sizeInfo.pivot.pivotY === Pivot.UNDEFINED) {
          // If no anchor, create anchor
          let pivot = this.getScalePivot(rect, displayWidth, displayHeight);
          this.sizeInfo.pivot = pivot;
        }
        let res = this.getRectByPivot(rect, this.requestRect, displayWidth, displayHeight, this.sizeInfo.pivot);
        rect.setPos(res.left, res.top);
        log.showInfo(
          `pivot rect[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},${rect.height.getPx()}],` +
            `pivot[${this.sizeInfo.pivot.pivotX.valueOf()},${this.sizeInfo.pivot.pivotY.valueOf()}]`);
      }
    }
    this.fixRectPositionIfNeeded(rect, displayWidth, displayHeight);
    log.showInfo(`valid rect:[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},${rect.height.getPx()}]`);
    return rect;
  }

  public fixRectSizeIfNeeded(rect: SCBSessionRect, displayWidth: number, displayHeight: number, isLandscape: boolean) {
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`fixRectSizeIfNeeded rect is null`);
      return;
    }
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);
    let heightTmp: number = displayHeight - Constants.SAFE_PADDING_VERTICAL_TOP -
      Constants.SAFE_PADDING_VERTICAL_BOTTOM;
    let pipWidth : number = rect.width.getPx();
    let pipHeight : number = rect.height.getPx();
    let landscape : boolean = isLandscape;
    if (uiType === SCBConstants.UITYPE_PAD || SCBTriFoldManager.getInstance().isCurGState()) {
      landscape = (displayWidth > displayHeight);
    }
    let shortEdge = landscape ? displayHeight : displayWidth;

    if (rect.width.getPx() + safePaddingHorizontal * Constants.NUMBER_TWO > shortEdge) {
      rect.width.setNumber(shortEdge - safePaddingHorizontal * Constants.NUMBER_TWO);
      rect.height.setNumber(rect.width.getPx() * (pipHeight / pipWidth));
    }

    if (!landscape) {
      if (rect.height.getPx() > displayHeight / 2) {
        rect.height = new ScbNumber(displayHeight / 2);
        rect.width = new ScbNumber(rect.height.getPx() * pipWidth / pipHeight);
        log.showInfo('the height of pip exceeds half of the screen height,' +
          'set it to half of the current screen height.');
      }
    } else if (rect.height.getPx() > heightTmp) {
      rect.height.setNumber(heightTmp);
      rect.width.setNumber(heightTmp * (pipWidth / pipHeight));
    }
    this.fixRectIfNeeded(rect);
    log.showInfo(`fixed rect[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},` +
      `${rect.height.getPx()}],isLandscape:${landscape}`);
  }

  public fixRectIfNeeded(rect: SCBSessionRect) {
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`fixRectIfNeeded rect is null`);
      return;
    }
    if (rect.width.getPx() < vp2px(MIN_PIP_WIDTH)) {
      rect.width.setNumber(vp2px(MIN_PIP_WIDTH));
    }
    if (rect.height.getPx() < vp2px(MIN_PIP_HEIGHT)) {
      rect.height.setNumber(vp2px(MIN_PIP_HEIGHT));
    }
  }

  public fixRectPositionIfNeeded(rect: SCBSessionRect, displayWidth: number, displayHeight: number) {
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`fixRectPositionIfNeeded rect is null`);
      return;
    }
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);
    if (rect.left.getPx() < safePaddingHorizontal) {
      rect.left = new ScbNumber(safePaddingHorizontal);
    } else if ((rect.left.getPx() + rect.width.getPx()) > (displayWidth - safePaddingHorizontal)) {
      rect.left = new ScbNumber(displayWidth - safePaddingHorizontal - rect.width.getPx());
    }
    if (rect.top.getPx() < Constants.SAFE_PADDING_VERTICAL_TOP) {
      rect.top = new ScbNumber(Constants.SAFE_PADDING_VERTICAL_TOP);
    } else if ((rect.top.getPx() + rect.height.getPx()) > (displayHeight - Constants.SAFE_PADDING_VERTICAL_BOTTOM)) {
      rect.top = new ScbNumber(displayHeight - Constants.SAFE_PADDING_VERTICAL_BOTTOM - rect.height.getPx());
    }
  }

  public judgeObtainOldPosition(reason: PipRectUpdateReason) {
    let flag = true;
    let oldStatus: number | undefined = undefined;
    return flag && (reason !== PipRectUpdateReason.REASON_ROTATION_CHANGE &&
      reason !== PipRectUpdateReason.REASON_PIP_EXPAND &&
      reason !== PipRectUpdateReason.REASON_PIP_FOLD);
  }

  public updatePipRectInner(reason: PipRectUpdateReason, screenProp: SCBScreenProperty): SCBSessionRect {
    if (CommonUtils.isInvalid(screenProp)) {
      log.showError(`updatePipRectInner screenProp is null`);
      return new SCBSessionRect(0, 0, this.sizeInfo.originWidth, this.sizeInfo.originHeight);
    }
    let displayWidth: number = screenProp.width;
    let displayHeight: number = screenProp.height;
    let shouldUpdateRatioChangPosition = (reason !== PipRectUpdateReason.REASON_PIP_RATIO_CHANGE);
    // default pos of phone is the right top
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, this.sizeInfo.originWidth, this.sizeInfo.originHeight);
    if (this.judgeObtainOldPosition(reason)) {
      rect.setPosNum(AppStorage.get(Constants.KEY_PIP_WINDOW_POS_X), AppStorage.get(Constants.KEY_PIP_WINDOW_POS_Y));
    }

    if (rect.left.getPx() === 0) {
      rect.left = new ScbNumber(displayWidth);
    }
    let rotation = screenProp.rotation;
    this.currentRotation = rotation;
    let isLandscape: boolean = (Math.abs(rotation) === RotationConstants.ROTATION_90 ||
      rotation === RotationConstants.ROTATION_270);
    log.showInfo(`window rect:[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},` +
      `${rect.height.getPx()}],rotation:${rotation}`);

    let finalRect: SCBSessionRect = this.calcNewPipRect(displayWidth, displayHeight, rect, isLandscape, reason);

    log.showInfo(`window new rect:[${finalRect.left.getPx()},${finalRect.top.getPx()},` +
      `${finalRect.width.getPx()},${finalRect.height.getPx()}]`);
    this.savePipPositionAndLevel(finalRect.left.getPx(), finalRect.top.getPx());
    if (shouldUpdateRatioChangPosition) {
      this.updateQuadrantAndPos(finalRect, displayWidth, displayHeight);
    }
    AppStorage.set(Constants.KEY_PIP_WINDOW_WIDTH, finalRect.width.getPx());
    AppStorage.set(Constants.KEY_PIP_WINDOW_HEIGHT, finalRect.height.getPx());
    return finalRect;
  }

  public updatePipRect(originRect: SCBSessionRect, reason: PipRectUpdateReason,
    screenProp: SCBScreenProperty, dragType?: number): SCBSessionRect {
    if (CommonUtils.isInvalid(originRect)) {
      log.showError(`updatePipRect originRect is null`);
      return new SCBSessionRect(0, 0, this.sizeInfo.originWidth, this.sizeInfo.originHeight);
    }
    this.requestRect = originRect.copy();
    switch (reason) {
      case PipRectUpdateReason.REASON_PIP_START:
        this.resetCameraAvoidArea();
        this.initPipRectInfo(originRect);
        break;
      case PipRectUpdateReason.REASON_PIP_SCALE_CHANGE:
        if (dragType === ScaleChangeType.NORMAL_TO_MIDDLE) {
          this.sizeInfo.scaleLevel = (this.sizeInfo.scaleLevel + Constants.NUMBER_TWO) % Constants.NUMBER_FOUR;
        } else if (dragType === ScaleChangeType.LARGE_TO_MIDDLE) {
          this.sizeInfo.scaleLevel = ScaleLevel.COUNT - this.sizeInfo.scaleLevel;
        } else {
          this.sizeInfo.scaleLevel = (this.sizeInfo.scaleLevel + Constants.NUMBER_ONE) % Constants.NUMBER_TWO;
        }
        break;
      case PipRectUpdateReason.REASON_PIP_EXPAND:
      case PipRectUpdateReason.REASON_PIP_FOLD:
        this.resetCameraAvoidArea();
        this.sizeInfo.scaleLevel = ScaleLevel.SCALE_LEVEL_NORMAL;
        this.clearPipRectPivotInfo();
        break;
      case PipRectUpdateReason.REASON_PIP_RATIO_CHANGE:
        this.clearPipRectPivotInfo();
        this.sizeInfo.originWidth = this.requestRect.width.getPx();
        this.sizeInfo.originHeight = this.requestRect.height.getPx();
        this.sizeInfo.isSquare = this.isSquare();
        break;
      case PipRectUpdateReason.REASON_ROTATION_CHANGE:
        this.resetCameraAvoidArea();
        this.clearPipRectPivotInfo();
        break;
      default:
        break;
    }
    return this.updatePipRectInner(reason, screenProp);
  }

  /**
   * calculate the overlapping area between two rects
   *
   * @param mainRect SCBSessionRect
   * @param otherRect SCBSessionRect
   * @returns null or rect SCBSessionRect
   */
  public static calculateOverlap(mainRect: SCBSessionRect, otherRect: SCBSessionRect): SCBSessionRect | null {
    let maxLeft = Math.max(mainRect.left.getPx(), otherRect.left.getPx());
    let maxTop = Math.max(mainRect.top.getPx(), otherRect.top.getPx());
    let minRight = Math.min(mainRect.left.getPx() + mainRect.width.getPx(),
      otherRect.left.getPx() + otherRect.width.getPx());
    let minBottom = Math.min(mainRect.top.getPx() + mainRect.height.getPx(),
      otherRect.top.getPx() + otherRect.height.getPx());
    if (minRight < maxLeft || minBottom < maxTop) {
      // no overlap
      return null;
    }
    return new SCBSessionRect(maxLeft, maxTop, minRight - maxLeft, minBottom - maxTop);
  }

  /**
   * calculate the updated area after moving if overlapped
   *
   * @param pipRect SCBSessionRect
   * @param avoidRect SCBSessionRect
   * @param margin number
   * @returns avoidSCBSessionRect SCBSessionRect
   */
  public static positionAfterAvoid(pipRect: SCBSessionRect, avoidRect: SCBSessionRect, screenProp: SCBScreenProperty,
    margin: number = Constants.DEFAULT_PIP_CAMERA_AVOID_AREA): SCBSessionRect {
    let overlap = PipRectCalculator.calculateOverlap(pipRect, avoidRect);
    if (overlap === null) {
      // return the original rect if there is no overlap
      return pipRect;
    }
    let screenWidth: number = px2vp(screenProp.width);
    let screenHeight: number = px2vp(screenProp.height);

    let avoidRectLeftVp = avoidRect.left.getVp();
    let avoidRectTopVp = avoidRect.top.getVp();
    let avoidRectWidthVp = avoidRect.width.getVp();
    let avoidRectHeightVp = avoidRect.height.getVp();

    let left = pipRect.left.getVp();
    let right = left + pipRect.width.getVp();
    let top = pipRect.top.getVp();
    let bottom = top + pipRect.height.getVp();

    let distanceLeft = avoidRectLeftVp - right - margin;
    let distanceRight = avoidRectLeftVp + avoidRectWidthVp - left + margin;
    let distanceTop = avoidRectTopVp - bottom - margin;
    let distanceBottom = avoidRectTopVp + avoidRectHeightVp - top + margin;

    // the shortest avoid distance with ONE_ACCURACY Calculate
    let avoidDistanceArray = [Math.abs(distanceLeft), Math.abs(distanceRight),
      Math.abs(distanceTop), Math.abs(distanceBottom)];
    avoidDistanceArray.sort((a, b) => a - b);

    let avoidSCBSessionRect = pipRect.copy();
    for (let minDistance of avoidDistanceArray) {
      if (minDistance === Math.abs(distanceLeft) || minDistance === Math.abs(distanceRight)) {
        minDistance = Math.abs(distanceLeft) === minDistance ? distanceLeft : distanceRight;
        let isOverScreen = right + minDistance > screenWidth ||
          left + minDistance < 0;
        if (isOverScreen) {
          continue;
        }
        log.showInfo(`positionAfterAvoid left or right minDistance: ${minDistance} ${isOverScreen}`);
        avoidSCBSessionRect = new SCBSessionRect(vp2px(left + minDistance), vp2px(top),
          pipRect.width.getPx(), pipRect.height.getPx());
        return avoidSCBSessionRect;
      } else {
        minDistance = Math.abs(distanceTop) === minDistance ? distanceBottom : distanceTop;
        let isOverScreen = bottom + minDistance > screenHeight ||
          top + minDistance < 0;
        if (isOverScreen) {
          continue;
        }
        log.showInfo(`positionAfterAvoid top or bottom minDistance: ${minDistance} ${isOverScreen}`);
        avoidSCBSessionRect = new SCBSessionRect(vp2px(left), vp2px(top + minDistance),
          pipRect.width.getPx(), pipRect.height.getPx());
        return avoidSCBSessionRect;
      }
    }
    return avoidSCBSessionRect;
  }
}
