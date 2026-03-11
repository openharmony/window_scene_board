/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { ScbNumber, SCBSessionRect, SCBScreenProperty,
  SCBSceneSessionManager,
  SystemBarType,
  SCBScreenSessionManager} from '@ohos/windowscene';
import { LogDomain, LogHelper, CommonUtils, } from '@ohos/basicutils';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import { Constants, PipRectUpdateReason } from './PictureInPictureConstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
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
const SIZE_TYPE_SMALL = 1;
const SIZE_TYPE_LARGE = 2;

PersistentStorage.persistProp(Constants.KEY_PIP_SCALE, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_POS_X, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_POS_Y, 0);
PersistentStorage.persistProp(Constants.PIP_OLD_SCREEN_STATUS, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_WIDTH, 0);
PersistentStorage.persistProp(Constants.KEY_PIP_WINDOW_HEIGHT, 0);

export class RectChangeItem {
  public rect: sceneSessionManager.SessionRect;
  public reason: sceneSessionManager.SessionSizeChangeReason;

  constructor(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason) {
    this.rect = rect;
    this.reason = reason;
  }
}

export enum Pivot {
  UNDEFINED = 0,
  START,
  MIDDLE,
  END,
}

export enum ScaleLevel {
  SCALE_LEVEL_NORMAL = 0,
  SCALE_LEVEL_LARGE = 1,
  COUNT = 2,
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
  private requestRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private currentRotation: number = 0;

  // these vars are used to save the rect position and quadrant before ratioChange,
  // to ensure a correct transform when ratioChange happen
  private basePosX: number = 0;
  private basePosY: number = 0;
  public quadrantX: number = 0;
  public quadrantY: number = 0;
  private isSizeInfoInitialized: boolean = false;

  public sizeInfo: SizeInfo = {
    originWidth: 0,
    originHeight: 0,
    pivot: { pivotX: Pivot.UNDEFINED, pivotY: Pivot.UNDEFINED },
    scaleLevel: ScaleLevel.SCALE_LEVEL_NORMAL,
    isSquare: false
  };

  public getStatusBarHeight(screenId: number): number {
    let statusBarHeight: number = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar) {
      statusBarHeight = statusBar.currRect.height.getPx();
    }
    return statusBarHeight;
  }

  public getDockHeight(screenId: number): number {
    let dockHeight: number = 0
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    if (dock) {
      dockHeight = dock.currRect.height.getPx();
    }
    return dockHeight;
  }

  public updatePipRectPivotInfo(rect: SCBSessionRect, displayWidth: number, displayHeight: number): void {
    if (!CommonUtils.isInvalid(rect)) {
      let pivot: ScalePivot = this.getScalePivot(rect, displayWidth, displayHeight);
      this.sizeInfo.pivot = pivot;
    }
  }

  private getScalePivot(rect: SCBSessionRect, displayWidth: number, displayHeight: number): ScalePivot {
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

  private getRectByPivot(rect: SCBSessionRect, originRect: SCBSessionRect, displayWidth: number,
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

  private isSquare(): boolean {
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

  public getRectByScale(width: number, height: number, scaleLevel: ScaleLevel,
    sourceRect: SCBSessionRect, isLandscape: boolean, reason: PipRectUpdateReason): SCBSessionRect {
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
    switch (scaleLevel) {
      case ScaleLevel.SCALE_LEVEL_NORMAL: {
        this.getRectOnNormalScale(width, height, sourceRect, rect, reason);
        break;
      }
      case ScaleLevel.SCALE_LEVEL_LARGE: {
        this.getRectOnLargeScale(width, height, sourceRect, isLandscape, rect);
        break;
      }
      default:
        break;
    }
    return rect;
  }

  private getRectOnLargeScale(width: number, height: number,
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

  private getRectOnNormalScale(width: number, height: number,
    sourceRect: SCBSessionRect, rect: SCBSessionRect, reason: PipRectUpdateReason) {
    let winWidth: number = sourceRect.width.getPx();
    let winHeight: number = sourceRect.height.getPx();
    if (winWidth === 0 || winHeight === 0) {
      log.showError(`getRectOnNormalScale winWidth or winHeight is 0`);
      return;
    }
    let proportion = Constants.DEFAULT_EXPAND_PROPORTION;
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

  private getWidthByLandScreenWidth(landScreenWidth: number, occupiedGrid: number): number {
    if (px2vp(landScreenWidth) >= PAD_VP_BELOW) {
      return this.getGridRowWidth(landScreenWidth, PAD_GRID_COLUMN_NUMBER, occupiedGrid);
    } else if (px2vp(landScreenWidth) >= FOLD_SCREEN_VP_BELOW) {
      return this.getGridRowWidth(landScreenWidth, FOLD_GRID_COLUMN_NUMBER, occupiedGrid);
    } else {
      return this.getGridRowWidth(landScreenWidth, PHONE_GRID_COLUMN_NUMBER, occupiedGrid);
    }
  }

  private getGridRowWidth(landScreenWidth: number, gridCount: number, occupiedGrid: number): number {
    if (gridCount === 0) {
      log.showInfo(`gridCount is 0`);
      gridCount = PHONE_GRID_COLUMN_NUMBER;
    }
    let gutter = vp2px(GRID_ROW_GUTTER);
    let aveWidth = (landScreenWidth - gutter * (gridCount + 1)) / gridCount;
    return aveWidth * occupiedGrid + gutter * (occupiedGrid - 1);
  }

  private initPipRectInfo(requestRct: SCBSessionRect): boolean {
    if (requestRct.width.getPx() === 0 || requestRct.height.getPx() === 0) {
      return false;
    }
    this.clearPipRectPivotInfo();
    this.sizeInfo.originWidth = requestRct.width.getPx();
    this.sizeInfo.originHeight = requestRct.height.getPx();
    this.sizeInfo.scaleLevel = this.getScaleLevel();
    this.sizeInfo.isSquare = this.isSquare();
    this.isSizeInfoInitialized = true;
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

  private updateRectPosition(rect: SCBSessionRect, displayWidth: number, displayHeight: number) {
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

  private updateRectPosWhenRotate(rect: SCBSessionRect, screenProperty: SCBScreenProperty,
    isSameOrientation: boolean): void {
    const newScreenWidth: number = screenProperty.width;
    const newScreenHeight: number = screenProperty.height;
    let oldScreenWidth: number = screenProperty.width;
    let oldScreenHeight: number = screenProperty.height

    if (!isSameOrientation) {
      oldScreenWidth = newScreenHeight;
      oldScreenHeight = newScreenWidth;
    }

    const statusbarHeight: number = this.getStatusBarHeight(screenProperty.screenId);
    const dockHeight: number = this.getDockHeight(screenProperty.screenId);
    const marginTop: number = rect.top.getPx() - statusbarHeight;
    const marginBottom: number = oldScreenHeight - rect.top.getPx() - rect.height.getPx() - dockHeight;
    const top = (newScreenHeight - dockHeight - statusbarHeight - rect.height.getPx()) * this.getRatio(
      marginTop, marginBottom) + statusbarHeight;
    rect.top = new ScbNumber(top);
    const marginLeft = rect.left.getPx();
    const marginRight = oldScreenWidth - rect.width.getPx() - marginLeft;
    let left: number = (newScreenWidth - rect.width.getPx()) * this.getRatio(marginLeft, marginRight);
    rect.left = new ScbNumber(left);
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

  private calcNewPipRect(screenProp: SCBScreenProperty, sourceRect: SCBSessionRect,
    isLandscape: boolean, reason: PipRectUpdateReason, isSameOrientation: boolean): SCBSessionRect {
    let displayWidth: number = screenProp.width;
    let displayHeight: number = screenProp.height;
    let rect: SCBSessionRect = this.getRectByScale(
      displayWidth, displayHeight, this.sizeInfo.scaleLevel, sourceRect, isLandscape, reason);
    log.showInfo(`scale rect[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},` +
      `${rect.height.getPx()}],isLandscape:${isLandscape}`);

    this.fixRectSizeIfNeeded(rect, displayWidth, displayHeight, isLandscape);

    if (reason === PipRectUpdateReason.REASON_PIP_RATIO_CHANGE) {
      this.updateRectPosition(rect, displayWidth, displayHeight);
    } else if (reason === PipRectUpdateReason.REASON_ROTATION_CHANGE) {
      this.updateRectPosWhenRotate(rect, screenProp, isSameOrientation);
    } else {
      if ((reason !== PipRectUpdateReason.REASON_PIP_START) && rect.width.getPx() !== 0 &&
        rect.height.getPx() !== 0) {
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
    this.fixRectPositionIfNeeded(rect, screenProp);
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
    let shortEdge = landscape ? displayHeight : displayWidth;
    if (rect.width.getPx() + safePaddingHorizontal * Constants.NUMBER_TWO > shortEdge) {
      rect.width.setNumber(shortEdge - safePaddingHorizontal * Constants.NUMBER_TWO);
      rect.height.setNumber(rect.width.getPx() * (pipHeight / pipWidth));
    }

    if (!landscape) {
      if (rect.height.getPx() > displayHeight / Constants.NUMBER_TWO) {
        rect.height = new ScbNumber(displayHeight / Constants.NUMBER_TWO);
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

  private fixRectIfNeeded(rect: SCBSessionRect) {
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

  private fixRectPositionIfNeeded(rect: SCBSessionRect, screenProp: SCBScreenProperty) {
    if (CommonUtils.isInvalid(rect)) {
      log.showError(`fixRectPositionIfNeeded rect is null`);
      return;
    }
    let displayWidth = screenProp.width;
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);

    // avoid left right
    if (rect.left.getPx() < safePaddingHorizontal) {
      rect.left = new ScbNumber(safePaddingHorizontal);
    } else if ((rect.left.getPx() + rect.width.getPx()) > (displayWidth - safePaddingHorizontal)) {
      rect.left = new ScbNumber(displayWidth - safePaddingHorizontal - rect.width.getPx());
    }

    // avoid top
    let statusBarHeight = this.getStatusBarHeight(screenProp.screenId);
    if (rect.top.getPx() < statusBarHeight + vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA)) {
      rect.top = new ScbNumber(statusBarHeight + vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA));
      return;
    }
    let availableHeight = screenProp.height;
    let dockHeight = this.getDockHeight(screenProp.screenId);
    if ((rect.top.getPx() + rect.height.getPx()) >
      availableHeight - dockHeight - vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA)) {
      rect.top = new ScbNumber(availableHeight - dockHeight - vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA) -
        rect.height.getPx());
    }
  }

  private judgeObtainOldPosition(reason: PipRectUpdateReason) {
    return reason !== PipRectUpdateReason.REASON_PIP_EXPAND &&
      reason !== PipRectUpdateReason.REASON_PIP_FOLD;
  }

  private updatePipRectInner(reason: PipRectUpdateReason, screenProp: SCBScreenProperty): SCBSessionRect {
    if (CommonUtils.isInvalid(screenProp)) {
      log.showError(`updatePipRectInner screenProp is null`);
      return new SCBSessionRect(0, 0, this.sizeInfo.originWidth, this.sizeInfo.originHeight);
    }
    let displayWidth: number = screenProp.width;
    let displayHeight: number = screenProp.height;
    let shouldUpdateRatioChangPosition = (reason !== PipRectUpdateReason.REASON_PIP_RATIO_CHANGE);

    // default pos of pc is the left top
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, this.sizeInfo.originWidth, this.sizeInfo.originHeight);
    if (this.judgeObtainOldPosition(reason)) {
      rect.setPosNum(AppStorage.get(Constants.KEY_PIP_WINDOW_POS_X), AppStorage.get(Constants.KEY_PIP_WINDOW_POS_Y));
    }

    let newRotation = screenProp.rotation;
    let isLandscape: boolean = this.isLandscape(newRotation);
    let isSameOrientation = isLandscape === this.isLandscape(this.currentRotation);
    this.currentRotation = newRotation;

    log.showInfo(`window rect:[${rect.left.getPx()},${rect.top.getPx()},${rect.width.getPx()},` +
      `${rect.height.getPx()}], newRotation:${newRotation}`);

    let finalRect: SCBSessionRect = this.calcNewPipRect(screenProp, rect, isLandscape, reason, isSameOrientation);

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

  private isLandscape(rotation: number): boolean {
    return (Math.abs(rotation) === RotationConstants.ROTATION_90 ||
      rotation === RotationConstants.ROTATION_270);
  }

  public updatePipRect(originRect: SCBSessionRect, reason: PipRectUpdateReason,
    screenProp: SCBScreenProperty): SCBSessionRect {
    if (CommonUtils.isInvalid(originRect)) {
      log.showError(`updatePipRect originRect is null`);
      return new SCBSessionRect(0, 0, this.sizeInfo.originWidth, this.sizeInfo.originHeight);
    }
    this.requestRect = originRect.copy();
    switch (reason) {
      case PipRectUpdateReason.REASON_PIP_START:
        this.initPipRectInfo(originRect);
        break;
      case PipRectUpdateReason.REASON_PIP_SCALE_CHANGE:
        this.sizeInfo.scaleLevel = (this.sizeInfo.scaleLevel + 1) % ScaleLevel.COUNT;
        break;
      case PipRectUpdateReason.REASON_PIP_EXPAND:
      case PipRectUpdateReason.REASON_PIP_FOLD:
        this.clearPipRectPivotInfo();
        break;
      case PipRectUpdateReason.REASON_PIP_RATIO_CHANGE:
        this.clearPipRectPivotInfo();
        this.sizeInfo.originWidth = this.requestRect.width.getPx();
        this.sizeInfo.originHeight = this.requestRect.height.getPx();
        this.sizeInfo.isSquare = this.isSquare();
        break;
      case PipRectUpdateReason.REASON_ROTATION_CHANGE:
        this.clearPipRectPivotInfo();
        if (!this.isSizeInfoInitialized) {
          this.initPipRectInfo(originRect);
        }
        break;
      default:
        break;
    }
    return this.updatePipRectInner(reason, screenProp);
  }

  private getRatio(numerator: number, denominator: number): number {
    if (numerator + denominator === 0) {
      return 0;
    }
    return numerator / (numerator + denominator);
  }
}
