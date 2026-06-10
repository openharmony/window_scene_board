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
import { SCBSceneMode } from './SCBSceneInfo';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { DividerStyleConstants, RotationConstants, WindowConstants } from '@ohos/commonconstants';
import { SplitStyle } from './SCBSceneContainerSession';
import { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '../../scene/session/SCBSceneSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import lazy { MidSceneConstants } from '@ohos/commonconstants';
import { SystemBarType, windowMgr } from '../../TsIndex';
import display from '@ohos.display';

/**
 *  the offset of folded one step split scene
 */
const ONE_STEP_SPLIT_OFFSET_FOR_FOLDED: number = 56;
/**
 *  the offset of expand one step split scene
 */
const ONE_STEP_SPLIT_OFFSET_FOR_EXPAND: number = 48;

const TAG = 'SCBDividerParam';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Observed
export class SceneParam {
  // pri+sec的参数用，map不需要
  @Track persistentId: number = 0;
  // Layout
  @Track posX: string = '0%';
  @Track posY: string = '0%';
  @Track width: string = '100%';
  @Track height: string = '100%';
  @Track sessionWidth:number = 0;
  @Track sessionHeight:number = 0;
  @Track minWidth: number = DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_WIDTH;
  @Track minHeight: number = DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_HEIGHT;
  @Track maxWidthRatio: number = 1;

  // Affine
  // -rotate
  @Track rotateX: number = 0;
  @Track rotateY: number = 0;
  @Track rotateZ: number = 0;
  @Track rotateAngle: number = 0;
  @Track rotateCenterX: number | string = 0;
  @Track rotateCenterY: number | string = 0;
  // -translate
  @Track translateX: number = 0;
  @Track translateY: number = 0;
  @Track touchTranslateX: number = 0;
  @Track touchTranslateY: number = 0;
  // -scale
  @Track sessionScaleX: number = 1;
  @Track sessionScaleCenterX: number | string = 0;
  @Track sessionScaleY: number = 1;
  @Track sessionScaleCenterY: number | string = 0;
  @Track scaleX: number = 1;
  @Track scaleY: number = 1;
  @Track scaleCenterX: number | string = 0;
  @Track scaleCenterY: number | string = 0;
  // linear gradient params
  @Track gradientAngle: number = 0;
  @Track gradient1: number = 0;
  @Track gradient2: number = 0;
  @Track gradientPos: number = 0;
  // blendMode
  @Track blendMode: boolean = false;

  // Draw
  @Track opacity: number = 1;
  @Track sessionOpacity: number = 1;
  @Track blurScale: number = 0;
  @Track shadowOptions: ShadowOptions = { radius: 0 };
  @Track borderRadius: BorderRadiuses = { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 };
  @Track floatingShadowStyle: ShadowStyle | null = null;
  @Track zIndex: number = 0;
  @Track needClip: boolean = true;
  @Track isNeedFreeze: boolean = false;
  @Track effectRatio: number = 0;
  @Track sceneFreeze: boolean = false;
  @Track shadowRadius: number = 0;
  @Track blurDirection: GradientDirection | null = null;
  @Track blurRadius: number = -1;
  @Track sceneInnerFreeze: boolean = false;
  /**
   * Replacing Blur with Masks
   */
  @Track useBlurStandIn: boolean = false;
  // is need mid scene block cover
  @Track needMidSceneBlockCover: boolean = true;
  // is need mid scene blur cover
  @Track needMidSceneBlurCover: boolean = true;
  /**
   * primary mask color
   */
  @Track blurStandInColor: string = '#ffffffff';
  @Track maxDividerWidth: ConstraintSizeOptions =  { maxWidth: 3000 };
  @Track minDividerWidth: ConstraintSizeOptions =  { minWidth: 0 };
  @Track isSplitExchange: boolean = false;

  /**
   * Set borderRadius
   *
   * @param { borderRadius } BorderRadiuses
   * @param { callerFunctionName } string
   */
  public setBorderRadius(borderRadius: BorderRadiuses, callerFunctionName: string): void {
    if (this.borderRadius.topLeft === borderRadius.topLeft &&
      this.borderRadius.topRight === borderRadius.topRight &&
      this.borderRadius.bottomLeft === borderRadius.bottomLeft &&
      this.borderRadius.bottomRight === borderRadius.bottomRight) {
      return;
    }
    log.showInfo(`setBorderRadius from [${this.borderRadius.topLeft}, ${this.borderRadius.topRight}, ` +
      `${this.borderRadius.bottomLeft}, ${this.borderRadius.bottomRight}] to [${borderRadius.topLeft}, ` +
      `${borderRadius.topRight}, ${borderRadius.bottomLeft}, ${borderRadius.bottomRight}]` +
      ` , caller function name: ${callerFunctionName}`);
    this.borderRadius = borderRadius;
  }

  public midSceneCopyTo(param: SceneParam): void {
    if (!param) {
      return;
    }
    this.persistentId = param.persistentId;
    this.posX = param.posX;
    this.posY = param.posY;
    this.width = param.width;
    this.height = param.height;
    this.sessionWidth = param.sessionWidth;
    this.sessionHeight = param.sessionHeight;
    this.minWidth = param.minWidth;
    this.maxWidthRatio = param.maxWidthRatio;
    this.rotateX = param.rotateX;
    this.rotateY = param.rotateY;
    this.rotateZ = param.rotateZ;
    this.rotateAngle = param.rotateAngle;
    this.rotateCenterX = param.rotateCenterX;
    this.rotateCenterY = param.rotateCenterY;
    this.translateX = param.translateX;
    this.translateY = param.translateY;
    this.touchTranslateX = param.touchTranslateX;
    this.touchTranslateY = param.touchTranslateY;
    this.sessionScaleX = param.sessionScaleX;
    this.sessionScaleCenterX = param.sessionScaleCenterX;
    this.sessionScaleY = param.sessionScaleY;
    this.sessionScaleCenterY = param.sessionScaleCenterY;
    this.scaleX = param.scaleX;
    this.scaleY = param.scaleY;
    this.scaleCenterX = param.scaleCenterX;
    this.scaleCenterY = param.scaleCenterY;
    this.gradientAngle = param.gradientAngle;
    this.gradient1 = param.gradient1;
    this.gradient2 = param.gradient2;
    this.blendMode = param.blendMode;
    this.opacity = param.opacity;
    this.sessionOpacity = param.sessionOpacity;
    this.blurScale = param.blurScale;
    this.shadowOptions = param.shadowOptions;
    this.setBorderRadius(param.borderRadius, 'midSceneCopyTo');
    this.floatingShadowStyle = param.floatingShadowStyle;
    this.zIndex = param.zIndex;
    this.needClip = param.needClip;
    this.isNeedFreeze = param.isNeedFreeze;
    this.effectRatio = param.effectRatio;
    this.sceneFreeze = param.sceneFreeze;
    this.shadowRadius = param.shadowRadius;
    this.blurDirection = param.blurDirection;
    this.blurRadius = param.blurRadius;
    this.needMidSceneBlockCover = param.needMidSceneBlockCover;
  }
}

const BACKBOARD_WIDTH = 8;
const BACKBOARD_HEIGHT = 30;
const DIVIDER_RESPONSE_WIDTH = 100;

/**
 * param of SCBDivider
 */
@Observed
export class SCBDividerParam {

  /**
   * is do hide divider animation
   */
  @Track doHideAnimation: boolean = false;

  @Track dividerId :number = -1;
  @Track isPrimaryRaise: boolean = false;
  @Track primary: SceneParam = new SceneParam();
  @Track secondary: SceneParam = new SceneParam();

  public getByPersistentId(id: number): SceneParam | null {
    if (id === this.primary.persistentId) {
      return this.primary;
    } else if (id === this.secondary.persistentId) {
      return this.secondary;
    } else {
      return null;
    }
  }

  /**
   * count of drag and exchange split scene
   */
  public dragExchangeCount: number = 0;

  /**
   * is need input method
   */
  @Track isNeedInputMethod: boolean = true;

  /**
   * width of button
   */
  @Track buttonWidth: number = 0;

  /**
   * height of button
   */
  @Track buttonHeight: number = 0;

  /**
   * width of divider
   */
  @Track dividerWidth: number | string = 0;

  /**
   * height of divider
   */
  @Track dividerHeight: number | string = 0;

  /**
   * width of backboard
   */
  @Track backboardWidth: number | string = 0;

  /**
   * height of backboard
   */
  @Track backboardHeight: number | string = 0;

  /**
   * translateX of divider
   */
  @Track dividerTranslateX: number = 0;

  /**
   * translateY of divider
   */
  @Track dividerTranslateY: number = 0;

  /**
   * scaleX of Divider
   */
  @Track scaleX: number = 1;

  /**
   * scaleY of Divider
   */
  @Track scaleY: number = 1;

  /**
   * positionX of divider
   */
  @Track positionX: string = '0%';

  /**
   * positionY of divider
   */
  @Track positionY: string = '0%';

  /**
   * zIndex of divider WindowScene
   */
  @Track dividerZIndex: number = 0;

  /**
   * need crop the hole area
   */
  needCutOut: boolean = false;

  /**
   * primary session's mode
   */
  @Track isSplitPrimaryMode: boolean = true;
  /**
   * isDividerDragging
   */
  @Track isDividerDragging: boolean = false;

  /**
   * isTitleBarDragging
   */
  @Track isTitleBarDragging: boolean = false;

  /**
   * opacity od divider
   */
  @Track dividerOpacity: number = 1;

  statusBarPct: number = 0;
  /**
   * Split divider background is visible or not
   * split style for expand mode
   * 0 for left and right split
   * 1 for up and down split
   */
  @Track splitStyle: SplitStyle = SplitStyle.UNDEFINED;

  @Track dividerCircleHeight: number = 0;

  @Track dividerCircleWidth: number = 0;

  @Track dividerCircleMargin: Margin = { left: 2, right: 2, top: 2, bottom: 2 };

  @Track needClip: boolean = false;
  /**
   * alpha of divider bar
   */
  @Track dividerAlpha: number = 0;
  /**
   * alpha of divider background
   */
  @Track blackBackgroundOpacity: number = 0;

  @Track blackBackgroundColor: ResourceColor = Color.Black;

  @Track blackBackgroundBorderRadius: BorderRadiuses = { topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 };

  @Track blackBackgroundWindowScene: boolean = true;

  /**
   * container session rotate param
   */
  @Track containerRotateX: number = 0;
  @Track containerRotateY: number = 0;
  @Track containerRotateZ: number = 0;
  @Track containerRotateAngle: number = 0;
  @Track containerRotateCenterX: number | string = 0;
  @Track containerRotateCenterY: number | string = 0;




  /**
   * is need container rotate
   */
  @Track isNeedContainerRotate: boolean = false;

  /**
   * is need set Divider ZIndex
   */
  @Track isNeedSetDividerZIndex: boolean = false;

  /**
   * is focus to primary scene
   */
  @Track isFocusPrimary: boolean = false;

  /**
   * Splits whether the scene is moving and indicates the movement mode
   */
  @Track splitMovingMode: SCBSceneMode = SCBSceneMode.UNDEFINED;

  splitOrderIsNotReverse: boolean = true;

  @Track isShowIcon: Boolean = false;

  /**
   * is need freeze on scene
   */
  @Track isNeedFreeze: boolean = false;

  /**
   * is primary or secondary on split
   */
  @Track isEndSplit: boolean = true;

  /**
   * primaryScene secondaryScene divider translate
   */
  containerTranYPct: number = 0;

  /**
   * is pair split on split recent view
   */
  @Track isSplitRecentPair: boolean = false;

  private _primSizePct: number = 1;
  private _secSizePct: number = 0;
  private avoidXPct: number = 0;
  private avoidYPct: number = 0;
  private positionChangeCallbackMap: Map<number, () => void> = new Map();
  private needNotifyPositionChange: boolean = true;
  /**
   * if screen direction is vertical
   */
  @Track private isVertical: boolean = true;

  private _deviceRadius: number = 0;

  private _eventFromGesture = false;

  iconScale: number = 1;

  /**
   * if outer bluir is open / inner blur is closed
   */
  @Track splitToMidEnter: boolean = false;

  /**
   * if enter midscene from quick switch
   */
  @Track quickSwitchToMidEnter: boolean = false;

  /**
   * whether cancel divider event
   */
  public needCancelDividerEvent: boolean = false;

  @Track grayscaleOpacity: number = 0;

  public get eventFromGesture(): boolean {
    let flag = this._eventFromGesture;
    this._eventFromGesture = false;
    return flag;
  }

  /**
   * Percentage of primary scene size.
   */
  public get primSizePct(): number {
    return this._primSizePct;
  }

  public set primSizePct(primSizePct: number) {
    this._primSizePct = primSizePct;
  }

  /**
   * Percentage of secondary scene size.
   */
  public get secSizePct(): number {
    return this._secSizePct;
  }

  public set secSizePct(secSizePct: number) {
    this._secSizePct = secSizePct;
  }

  public get deviceRadius(): number {
    return this._deviceRadius;
  }

  public set deviceRadius(radius: number) {
    this._deviceRadius = radius;
  }

  /**
   * Determine whether the screen is split up and down
   *
   * @returns { Boolean } Returns a boolean indicating whether the screen is split top and bottom
   */
  public isUpDownSplit(): boolean {
    if (isLargeFoldProductInExpand()) {
      return this.isExpandUpDownSplit();
    } else {
      return this.isVertical;
    }
  }

  /**
   * Determine whether it is a top-bottom split style
   *
   * @returns { Boolean } Returns true if the style is split top and bottom, false otherwise
   */
  public isExpandUpDownSplit(): boolean {
    return this.splitStyle === SplitStyle.UP_AND_DOWN_POS;
  }

  /**
   * Setting the Split Style
   *
   * @param { SplitStyle } newSplitStyle
   */
  public setSplitStyle(newSplitStyle: SplitStyle): void {
    this.splitStyle = newSplitStyle;
  }

  /**
   * Get the split style
   *
   * @returns { SplitStyle }
   */
  public getSplitStyle(): SplitStyle {
    return this.splitStyle;
  }

  /**
   * Set whether is vertical
   *
   * @param { boolean } isVertical
   */
  public setIsVertical(isVertical: boolean): void {
    if (this.isVertical === isVertical) {
      return;
    }
    this.isVertical = isVertical;
  }

  /**
   * Get whether is vertical
   *
   * @returns
   */
  public getIsVertical(): boolean {
    return this.isVertical;
  }

  /**
   * Registers the callback function for interaction status changes.
   *
   * @param { Function } callback
   */
  public registerInteractiveStateChangeCallback(callback: (state: boolean) => void): void {
    this.interactiveStateChangeCallback = callback;
  }

  /**
   * Deregister the callback function for interaction status change.
   */
  public unregisterInteractiveStateChangeCallback(): void {
    this.interactiveStateChangeCallback = undefined;
  }

  /**
   * Notify the change of the interaction status.
   *
   * @param { Boolean } state
   */
  public notifyInteractiveStateChange(state: boolean): void {
    if (!!this.interactiveStateChangeCallback) {
      this.interactiveStateChangeCallback(state);
    }
  }

  /**
   * Marker events triggered by gestures
   */
  public markEventFromGesture(): void {
    this._eventFromGesture = true;
  }

  /**
   * Reset Scene Rotation
   */
  public resetSceneRotate(): void {
    this.primary.rotateX = 0;
    this.primary.rotateY = 0;
    this.primary.rotateZ = 0;
    this.primary.rotateAngle = 0;
    this.primary.rotateCenterX = 0;
    this.primary.rotateCenterY = 0;

    this.secondary.rotateX = 0;
    this.secondary.rotateY = 0;
    this.secondary.rotateZ = 0;
    this.secondary.rotateAngle = 0;
    this.secondary.rotateCenterX = 0;
    this.secondary.rotateCenterY = 0;
  }

  /**
   * Sets the transparency of the primary color
   *
   * @param { Number } opacity
   */
  public setPrimaryOpacity(opacity: number): void {
    this.primary.opacity = opacity;
  }

  /**
   * Set secondary transparency
   *
   * @param { Number } opacity
   */
  public setSecondaryOpacity(opacity: number): void {
    this.secondary.opacity = opacity;
  }

  /**
   * Sets the primary Z-axis index
   *
   * @param { Number } zIndex
   */
  public setPrimaryZIndex(zIndex: number): void {
    this.primary.zIndex = zIndex;
  }

  /**
   * Sets the secondary Z-axis index.
   *
   * @param { Number } zIndex
   */
  public setSecondaryZIndex(zIndex: number): void {
    this.secondary.zIndex = zIndex;
  }

  /**
   * Set the divider Z-axis index
   *
   * @param { Number } zIndex
   */
  public setDividerZIndex(zIndex: number): void {
    this.dividerZIndex = zIndex;
  }

  /**
   * Reset primary, secodary and divider ZIndex
   */
  public resetZIndex(): void {
    this.setPrimaryZIndex(this.isPrimaryRaise ? 0 : -1);
    this.setSecondaryZIndex(this.isPrimaryRaise ? -1 : 0);
    this.setDividerZIndex(0);
  }

  /**
   * Set the transparency of a black background
   *
   * @param { Number } opacity
   */
  public setBlackBackgroundOpacity(opacity: number): void {
    this.blackBackgroundOpacity = opacity;
  }

  /**
   * Sets the transparency of the divider line
   *
   * @param { Number } opacity
   */
  public setDividerOpacity(opacity: number): void {
    this.dividerOpacity = opacity;
  }

  /**
   * Gets the percentage value of the primary location X
   *
   * @returns { Number } Returns a numeric percentage of the primary position X
   */
  public getPriPosXPct(): number {
    return this.parseStrPctToNum(this.primary.posX);
  }

  /**
   * Gets the percentage value of the primary location Y
   *
   * @returns { Number } Returns the numeric value of the primary position Y
   */
  public getPriPosYPct(): number {
    return this.parseStrPctToNum(this.primary.posY);
  }

  /**
   * Get the percentage value of the secondary position X
   *
   * @returns { Number } Returns the percent converted to a number
   */
  public getSecPosXPct(): number {
    return this.parseStrPctToNum(this.secondary.posX);
  }

  /**
   * Get the percentage value of the secondary position Y
   *
   * @returns { Number } Returns the percent converted to a number
   */
  public getSecPosYPct(): number {
    return this.parseStrPctToNum(this.secondary.posY);
  }

  /**
   * initializer
   */
  public init(): void {
    this.initAnimationParam();
    this.doHideAnimation = false;
    this.primary.posX = '0%';
    this.primary.posY = '0%';
    this.primary.height = '100%';
    this.primary.width = '100%';
    this.secondary.height = '0%';
    this.secondary.width = '0%';
    this.primSizePct = 1;
    this.secSizePct = 0;
    this.secondary.posX = '0%';
    this.secondary.posY = '0%';
    this.splitOrderIsNotReverse = true;
    this.primary.minWidth = DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_WIDTH;
    this.secondary.minWidth = DividerStyleConstants.DEFAULT_SPLIT_MIN_SCENE_WIDTH;
    this.primary.maxWidthRatio = 1;
    this.secondary.maxWidthRatio = 1;
    this.isDividerDragging = false;
    this.dividerOpacity = 1;
    this.dividerCircleHeight = 0;
    this.dividerCircleWidth = 0;
    this.dividerCircleMargin = {
      left: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
      right: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
      top: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
      bottom: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN
    };
    this.unSetBorderRadius();
    this.resetSceneRotate();
    this.dividerAlpha = 0;
    this.avoidXPct = 0;
    this.avoidYPct = 0;
    this.needCutOut = false;
    this.notifyPositionChange();
    this.isNeedFreeze = false;
    this.primary.sceneFreeze = false;
    this.secondary.sceneFreeze = false;
    this.needCancelDividerEvent = false;
    this.primary.blurRadius = -1;
    this.secondary.blurRadius = -1;
    this.containerTranYPct = 0;
  }

  public initFloatView(): void {
    this.primary.translateX = 0;
    this.primary.translateY = 0;
    this.primary.scaleX = 1;
    this.primary.scaleY = 1;
    this.primary.scaleCenterX = 0;
    this.primary.scaleCenterY = 0;
    this.blackBackgroundOpacity = 0;
    this.primary.height = '100%';
    this.primary.width = '100%';
    this.resetSceneRotate();
    this.primary.blurRadius = -1;
    this.blackBackgroundColor = Color.Black;
  }

  public freezeScene(reason: string): void {
    if (this.primary) {
      this.primary.sceneFreeze = true;
    }

    if (this.secondary) {
      this.secondary.sceneFreeze = true;
    }
    log.showInfo(`freezeScene reason:${reason}`);
  }

  public releaseSceneFreeze(reason: string): void {
    if (this.primary) {
      this.primary.sceneFreeze = false;
    }

    if (this.secondary) {
      this.secondary.sceneFreeze = false;
    }
    log.showInfo(`releaseSceneFreeze reason:${reason}`);
  }

  public initInMid(): void {
    this.dividerTranslateX = 0;
    this.dividerTranslateY = 0;
    this.scaleX = 1;
    this.scaleY = 1;
    this.blackBackgroundOpacity = 0;
    this.splitOrderIsNotReverse = true;
    this.isDividerDragging = false;
    this.dividerOpacity = 0;
    this.dividerAlpha = 0;
    this.avoidXPct = 0;
    this.avoidYPct = 0;
    this.needCutOut = false;
    this.isVertical = false;

    this.buttonWidth = DividerStyleConstants.DIVIDER_BUTTON_WIDTH;
    this.buttonHeight = DividerStyleConstants.DIVIDER_BUTTON_HEIGHT;
    this.dividerWidth = DividerStyleConstants.DIVIDER_HEIGHT;
    this.dividerHeight = '100%';
    this.dividerCircleWidth = DividerStyleConstants.DIVIDER_CIRCLE_HEIGHT;
    this.dividerCircleHeight = DividerStyleConstants.DIVIDER_CIRCLE_WIDTH;
    this.dividerZIndex = MidSceneConstants.MAX_SCENE_INDEX + 1;
    this.dividerCircleMargin = {
      left: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
      right: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
      top: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN,
      bottom: DividerStyleConstants.DIVIDER_CIRCLE_MARGIN
    };
    this.backboardWidth = BACKBOARD_WIDTH;
    this.backboardHeight = BACKBOARD_HEIGHT;
    this.needClip = true;
    this.isShowIcon = false;
    if (this.primary) {
      this.primary.sceneFreeze = false;
      this.primary.needMidSceneBlockCover = true;
    }
    if (this.secondary) {
      this.secondary.sceneFreeze = false;
      this.secondary.needMidSceneBlockCover = true;
    }
  }

  public updateSplitStackPosition(screenProperty: SCBScreenProperty): void {
    let toPercent = 100;
    let screenLength = this.isUpDownSplit() ? px2vp(screenProperty.height) : px2vp(screenProperty.width);
    let statusBarPct: number = this.getStatusBarHeight() / screenLength;
    this.resetPrimAndSecPos();
    if (this.splitOrderIsNotReverse) {
      if (this.isUpDownSplit()) {
        this.primary.posY = this.needCutOut ? `${(this.avoidYPct + this.containerTranYPct) * toPercent}%` :
          `${(this.containerTranYPct + statusBarPct) * 100}%`;
        this.secondary.posY = `${(1 - this.secSizePct + this.containerTranYPct) * toPercent}%`;
      } else {
        this.primary.posY = `${statusBarPct * toPercent}%`;
        this.secondary.posY = `${statusBarPct * toPercent}%`;
        this.primary.posX = this.needCutOut ? `${this.avoidXPct * toPercent}%` : `0%`;
        this.secondary.posX = `${(1 - this.secSizePct - this.getAvoidPctIfNeeded(screenProperty)) * toPercent}%`;
      }
    } else {
      if (this.isUpDownSplit()) {
        this.primary.posY = `${(1 - this.primSizePct + this.containerTranYPct) * toPercent}%`;
        this.secondary.posY = this.needCutOut ? `${(this.avoidYPct + this.containerTranYPct) * toPercent}%` :
          `${(this.containerTranYPct + statusBarPct) * 100}%`;
      } else {
        this.primary.posY = `${statusBarPct * toPercent}%`;
        this.secondary.posY = `${statusBarPct * toPercent}%`;
        this.secondary.posX = this.needCutOut ? `${this.avoidXPct * toPercent}%` : `0%`;
        this.primary.posX = `${(1 - this.primSizePct - this.getAvoidPctIfNeeded(screenProperty)) * toPercent}%`;
      }
    }
  }

  public notifyAvoidAreaChange(screenProperty: SCBScreenProperty): void {
    this.resetAvoidParam();
    if (!this.needCutOut) {
      return;
    }
    let screenLength = this.isUpDownSplit() ? px2vp(screenProperty.height) : px2vp(screenProperty.width);
    if (screenLength === 0) {
      log.showError('Failed to check number, screenLength is zero');
      return;
    }
    let statusBarPct: number = this.needCutOut ? this.getStatusBarHeight() / screenLength : 0;
    let rotation = screenProperty.rotation;
    this.statusBarPct = statusBarPct;
    if (isLargeFoldProductInExpand() || SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      if (this.isUpDownSplit()) {
        this.avoidXPct = 0;
        this.avoidYPct = statusBarPct;
      } else {
        this.needCutOut = false;
        this.resetAvoidParam();
      }
    } else {
      if (rotation === RotationConstants.ROTATION_0 || rotation === RotationConstants.ROTATION_360) {
        this.avoidXPct = 0;
        this.avoidYPct = statusBarPct;
      } else if (rotation === RotationConstants.ROTATION_90) {
        this.avoidXPct = 0;
        this.avoidYPct = 0;
      } else if (rotation === RotationConstants.ROTATION_270) {
        this.avoidXPct = statusBarPct;
        this.avoidYPct = 0;
      }
    }
    log.showDebug(`update split avoidArea: avoidx ${this.avoidXPct} avoidy ${this.avoidYPct}` +
      `statusBar ${statusBarPct}`);
  }

  public setPrimaryMinWidth(minWidth: number): void {
    this.primary.minWidth = minWidth;
  }

  public setPrimaryMinHeight(minHeight: number): void {
    this.primary.minHeight = minHeight;
  }

  public setSecondaryMinWidth(minWidth: number): void {
    this.secondary.minWidth = minWidth;
  }

  public setSecondaryMinHeight(minHeight: number): void {
    this.secondary.minHeight = minHeight;
  }

  /**
   * Registers the location change callback function.
   *
   * @param { Number } key
   * @param { Function } callback
   */
  public registerPositionChangeCallback(key: number, callback: () => void): void {
    if (!!key) {
      this.positionChangeCallbackMap.set(key, callback);
    }
  }

  /**
   * unregister Position Change Callback
   *
   * @param { Number } key
   */
  public unregisterPositionChangeCallback(key: number): void {
    if (!!key) {
      this.positionChangeCallbackMap.delete(key);
    }
  }

  /**
   * Invoked when the position and translate of the divider change.
   */
  public notifyPositionChange(): void {
    if (!this.needNotifyPositionChange) {
      return;
    }
    for (let callback of this.positionChangeCallbackMap.values()) {
      if (callback) {
        callback();
      }
    }
  }

  /**
   * Set whether to notify the location change.
   *
   * @param { Boolean } need
   */
  public setNeedNotifyPositionChange(need: boolean): void {
    this.needNotifyPositionChange = need;
  }

  /**
   * Get divider position X in percent
   *
   * unit: percent
   *
   * @returns position X in percent
   */
  public getDividerPctPositionX(): number {
    if (this.isUpDownSplit()) {
      return 0;
    } else {
      return this.splitOrderIsNotReverse ? this.primSizePct + this.avoidXPct : this.secSizePct + this.avoidXPct;
    }
  }

  /**
   * Get divider position Y in percent
   *
   * unit: percent
   *
   * @returns position Y in percent
   */
  public getDividerPctPositionY(): number {
    if (this.isUpDownSplit()) {
      return this.splitOrderIsNotReverse ? this.primSizePct + this.avoidYPct : this.secSizePct + this.avoidYPct;
    } else {
      return 0;
    }
  }

  /**
   * Get target scene avoid X in percent
   *
   * unit: percent
   *
   * @returns { Number } avoid X in percent
   */
  public getAvoidXPct(): number {
    return this.avoidXPct;
  }

  /**
   * Get target scene avoid Y in percent
   *
   * unit: percent
   *
   * @returns { Number } avoid Y in percent
   */
  public getAvoidYPct(): number {
    return this.avoidYPct;
  }

  /**
   * Get target scene position X in percent
   *
   * unit: percent
   *
   * @param { SCBSceneMode } mode scene mode
   * @returns { Number } position X in percent
   */
  public getScenePctPositionX(mode: SCBSceneMode): number {
    if (this.splitOrderIsNotReverse) {
      return mode !== SCBSceneMode.SECONDARY ? this.getPriPosXPct() : this.getSecPosXPct();
    } else {
      return mode !== SCBSceneMode.SECONDARY ? this.getSecPosXPct() : this.getPriPosXPct();
    }
  }

  /**
   * Get target scene position Y in percent
   *
   * unit: percent
   *
   * @param { SCBSceneMode } mode scene mode
   * @returns { Number } position Y in percent
   */
  public getScenePctPositionY(mode: SCBSceneMode): number {
    if (this.splitOrderIsNotReverse) {
      return mode !== SCBSceneMode.SECONDARY ? this.getPriPosYPct() : this.getSecPosYPct();
    } else {
      return mode !== SCBSceneMode.SECONDARY ? this.getSecPosYPct() : this.getPriPosYPct();
    }
  }

  /**
   * Get target scene translate X, include translate and touch translate
   *
   * unit: vp
   *
   * @param { SCBSceneMode } mode scene mode
   * @returns { Number } total translate
   */
  public getSceneTotalTranslateX(mode: SCBSceneMode): number {
    if (this.splitOrderIsNotReverse) {
      return mode !== SCBSceneMode.SECONDARY ? this.primary.translateX + this.primary.touchTranslateX :
        this.secondary.translateX + this.secondary.touchTranslateX;
    } else {
      return mode !== SCBSceneMode.SECONDARY ? this.secondary.translateX + this.secondary.touchTranslateX :
        this.primary.translateX + this.primary.touchTranslateX;
    }
  }

  /**
   * Get target scene total translate Y, include translate and touch translate
   *
   * unit: vp
   *
   * @param { SCBSceneMode } mode scene mode
   * @returns { Number } total translate
   */
  public getSceneTotalTranslateY(mode: SCBSceneMode): number {
    if (this.splitOrderIsNotReverse) {
      return mode !== SCBSceneMode.SECONDARY ? this.primary.translateY + this.primary.touchTranslateY :
        this.secondary.translateY + this.secondary.touchTranslateY;
    } else {
      return mode !== SCBSceneMode.SECONDARY ? this.secondary.translateY + this.secondary.touchTranslateY :
        this.primary.translateY + this.primary.touchTranslateY;
    }
  }

  /**
   * Get target scene width
   *
   * unit: percent
   *
   * @param { SCBSceneMode } mode scene mode
   * @returns { Number } width in percent
   */
  public getScenePctWidth(mode: SCBSceneMode): number {
    if (this.splitOrderIsNotReverse) {
      return mode !== SCBSceneMode.SECONDARY ? this.parseStrPctToNum(this.primary.width) :
        this.parseStrPctToNum(this.secondary.width);
    } else {
      return mode !== SCBSceneMode.SECONDARY ? this.parseStrPctToNum(this.secondary.width) :
        this.parseStrPctToNum(this.primary.width);
    }
  }

  /**
   * Get target scene height
   *
   * unit: percent
   *
   * @param { SCBSceneMode } mode scene mode
   * @returns { Number } height in percent
   */
  public getScenePctHeight(mode: SCBSceneMode): number {
    if (this.splitOrderIsNotReverse) {
      return mode !== SCBSceneMode.SECONDARY ? this.parseStrPctToNum(this.primary.height) :
        this.parseStrPctToNum(this.secondary.height);
    } else {
      return mode !== SCBSceneMode.SECONDARY ? this.parseStrPctToNum(this.secondary.height) :
        this.parseStrPctToNum(this.primary.height);
    }
  }

  public getScenePositionX(primary: boolean, referenceValue: number): number {
    if (primary === this.splitOrderIsNotReverse) {
      return this.parseStrPctToNum(this.primary.posX) * referenceValue;
    } else {
      return this.parseStrPctToNum(this.secondary.posX) * referenceValue;
    }
  }

  public getScenePositionY(primary: boolean, referenceValue: number): number {
    if (primary === this.splitOrderIsNotReverse) {
      return this.parseStrPctToNum(this.primary.posY) * referenceValue;
    } else {
      return this.parseStrPctToNum(this.secondary.posY) * referenceValue;
    }
  }

  public getSceneWidth(primary: boolean, referenceValue: number): number {
    if (primary === this.splitOrderIsNotReverse) {
      return this.parseStrPctToNum(this.primary.width) * referenceValue;
    } else {
      return this.parseStrPctToNum(this.secondary.width) * referenceValue;
    }
  }

  public getSceneHeight(primary: boolean, referenceValue: number): number {
    if (primary === this.splitOrderIsNotReverse) {
      return this.parseStrPctToNum(this.primary.height) * referenceValue;
    } else {
      return this.parseStrPctToNum(this.secondary.height) * referenceValue;
    }
  }

  public getSceneScaleX(primary: boolean): number {
    if (primary === this.splitOrderIsNotReverse) {
      return this.primary.scaleX;
    } else {
      return this.secondary.scaleX;
    }
  }

  public getSceneScaleY(primary: boolean): number {
    if (primary === this.splitOrderIsNotReverse) {
      return this.primary.scaleY;
    } else {
      return this.secondary.scaleY;
    }
  }

  public clearDynamicVariable(): void {
    this.primary.translateX = 0;
    this.primary.translateY = 0;
    this.secondary.translateX = 0;
    this.secondary.translateY = 0;
    this.dividerTranslateX = 0;
    this.dividerTranslateY = 0;
    this.primary.scaleX = 1;
    this.primary.scaleY = 1;
    this.secondary.scaleX = 1;
    this.secondary.scaleY = 1;
    this.isDividerDragging = false;
    this.notifyPositionChange();
  }

  /**
   * do one step translate for one step split scene
   *
   * @param { Number } translate: translate of primary and divider
   */
  public doOneStepTranslate(translate: number): void {
    if (this.isUpDownSplit()) {
      this.primary.translateX = 0;
      this.primary.translateY = translate;
      this.dividerTranslateX = 0;
      this.dividerTranslateY = translate;
    } else {
      this.primary.translateX = translate;
      this.primary.translateY = 0;
      this.dividerTranslateX = translate;
      this.dividerTranslateY = 0;
    }
    this.notifyPositionChange();
  }

  /**
   * calOneStepDefaultTrans in vp
   * @param screenProperty
   * @param isPrimarySession
   * @returns OneStepDefaultTrans in vp
   */
  public calOneStepDefaultTrans(screenProperty: SCBScreenProperty, isPrimarySession: boolean = true): number {
    let screenLength = this.getDividerVerticalDirectionScreenLength(screenProperty.width, screenProperty.height);
    let sizePct = isPrimarySession ? this.primSizePct : this.secSizePct;
    return getOneStepSplitOffset() - px2vp(screenLength) * sizePct;
  }

  /**
   * set one step pos with translate attribute instead position
   * @param translate
   * @param isPrimarySession
   * @returns
   */
  public setOneStepDefaultTranslate(translate: number, isPrimarySession: boolean = true): void {
    // reset divider actual position
    this.updateDividerPosition();
    if (isPrimarySession) {
      this.primary.posX = '0';
      this.primary.posY = '0';
      this.doOneStepTranslate(translate);
    } else {
      this.secondary.posX = '0';
      this.secondary.posY = '0';
      this.doSecondSceneTranslate(translate);
    }
  }

  /**
   * set one step pos with position attribute instead translate
   * determine the one step position before or after the animation when there is only the primary session
   * @param oneStepTrans
   * @param screenProperty
   * @param isPrimarySession decide the size of the session
   */
  public setOneStepDefaultPos(oneStepTrans: number, screenProperty: SCBScreenProperty): void {
    const PERCENT = 100;
    let screenLength = px2vp(this.getDividerVerticalDirectionScreenLength(screenProperty.width, screenProperty.height));
    let oneStepTranPct = oneStepTrans / screenLength * PERCENT;
    let dividerPosPct = (oneStepTrans / screenLength + this.primSizePct) * PERCENT;
    if (this.isUpDownSplit()) {
      this.primary.posX = '0';
      this.primary.posY = `${oneStepTranPct}%`;
      this.positionX = '0';
      this.positionY = `${dividerPosPct}%`;
    } else {
      this.primary.posX = `${oneStepTranPct}%`;
      this.primary.posY = '0';
      this.positionX = `${dividerPosPct}%`;
      this.positionY = '0';
    }
    this.primary.translateX = 0;
    this.primary.translateY = 0;
    this.dividerTranslateX = 0;
    this.dividerTranslateY = 0;
  }

  /**
   * do one step translate for one step secondary split scene
   *
   * @param { Number } translate: translate of primary and divider
   */
  public doSecondSceneTranslate(translate: number): void {
    if (this.isUpDownSplit()) {
      this.secondary.translateX = 0;
      this.secondary.translateY = translate;
      this.dividerTranslateX = 0;
      this.dividerTranslateY = translate;
    } else {
      this.secondary.translateX = translate;
      this.secondary.translateY = 0;
      this.dividerTranslateX = translate;
      this.dividerTranslateY = 0;
    }
    this.notifyPositionChange();
  }

  /**
   * do one step translate for one step split scene on vertical direction
   *
   * @param { Number } translate: translate of primary and divider
   */
  public doOneStepVerticalTranslate(translate: number): void {
    if (this.isUpDownSplit()) {
      this.primary.translateX = translate;
      this.dividerTranslateX = translate;
    } else {
      this.primary.translateY = translate;
      this.dividerTranslateY = translate;
    }
    this.notifyPositionChange();
  }

  /**
   * When dragging changing the scale, translate of the primary and secondary
   *
   * @param { Number } primScale
   * @param { Number } secScale
   * @param { Number } translate
   * @param { Number } primaryTranslate
   */
  public updateDynamicVariable(primScale: number, secScale: number, translate: number, primaryTranslate: number): void {
    if (this.isUpDownSplit()) {
      this.primary.translateY = primaryTranslate;
      this.secondary.translateY = translate;
      this.dividerTranslateY = translate;
      this.primary.scaleY = primScale;
      this.secondary.scaleY = secScale;
    } else {
      this.primary.translateX = primaryTranslate;
      this.secondary.translateX = translate;
      this.dividerTranslateX = translate;
      this.primary.scaleX = primScale;
      this.secondary.scaleX = secScale;
    }
    this.notifyPositionChange();
  }

  /**
   * Sets the border radius of primary scene
   */
  public setPrimaryBorderRadiuses(radius: number, callerFunctionName: string): void {
    this.primary.setBorderRadius({
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius
    }, callerFunctionName);
  }

  /**
   * Sets the border radius of secondary scene
   */
  public setSecondaryBorderRadiuses(radius: number, callerFunctionName: string): void {
    this.secondary.setBorderRadius({
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius
    }, callerFunctionName);
  }

  /**
   * set border radius
   * @param isFullSet if true will set 8 border radius, if false only set 4 center border radius plus one cut out edge
   * radius
   */
  public setBorderRadius(isFullSet: boolean = false): void {
    this.needClip = true;
    let centerRadius = DividerStyleConstants.SPLIT_BORDER_RADIUS;
    let edgeRadius = isFullSet ? this._deviceRadius : 0;
    this.initCenterBorderRadius(centerRadius, edgeRadius);
    if (!this.needCutOut) {
      return;
    }
    this.setAvoidEdgeBorderRadius();
  }

  private initCenterBorderRadius(center: number, edge: number): void {
    if (this.isUpDownSplit()) {
      let firstSceneBorderRadius = {
        topLeft: edge,
        topRight: edge,
        bottomLeft: center,
        bottomRight: center
      };
      let secondSceneBorderRadius = {
        topLeft: center,
        topRight: center,
        bottomLeft: edge,
        bottomRight: edge
      };
      this.primary.setBorderRadius(this.splitOrderIsNotReverse ? firstSceneBorderRadius : secondSceneBorderRadius,
        'initCenterBorderRadius');
      this.secondary.setBorderRadius(this.splitOrderIsNotReverse ? secondSceneBorderRadius : firstSceneBorderRadius,
        'initCenterBorderRadius');
    } else {
      let firstSceneBorderRadius = {
        topRight: center,
        bottomRight: center,
        topLeft: edge,
        bottomLeft: edge
      };
      let secondSceneBorderRadius = {
        topLeft: center,
        bottomLeft: center,
        topRight: edge,
        bottomRight: edge
      };
      this.primary.setBorderRadius(this.splitOrderIsNotReverse ? firstSceneBorderRadius : secondSceneBorderRadius,
      'initCenterBorderRadius');
      this.secondary.setBorderRadius(this.splitOrderIsNotReverse ? secondSceneBorderRadius : firstSceneBorderRadius,
      'initCenterBorderRadius');
    }
  }

  /**
   * set one edge border radius when needCutout
   * @param borderRadius
   */
  private setAvoidEdgeBorderRadius(): void {
    let borderRadius = DividerStyleConstants.SPLIT_BORDER_RADIUS;
    let mainBorderRadius = this.splitOrderIsNotReverse ? this.primary.borderRadius : this.secondary.borderRadius;
    let subBorderRaidus = this.splitOrderIsNotReverse ? this.secondary.borderRadius : this.primary.borderRadius;
    if (this.avoidXPct === 0 && this.avoidYPct !== 0) {
      mainBorderRadius.topLeft = borderRadius;
      mainBorderRadius.topRight = borderRadius;
    } else if (this.avoidXPct !== 0 && this.avoidYPct === 0) {
      mainBorderRadius.topLeft = borderRadius;
      mainBorderRadius.bottomLeft = borderRadius;
    } else if (this.avoidXPct === 0 && this.avoidYPct === 0 && this.statusBarPct !== 0) {
      subBorderRaidus.topRight = borderRadius;
      subBorderRaidus.bottomRight = borderRadius;
    }
  }

  /**
   * Unset Border Radius
   */
  public unSetBorderRadius(): void {
    this.primary.setBorderRadius({ topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 }, 'unSetBorderRadius');
    this.secondary.setBorderRadius({ topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0 }, 'unSetBorderRadius');
    this.needClip = false;
  }

  /**
   * set primBorderRadius to DeviceBorderRadius
   */
  public primSetDeviceBorderRadius(): void {
    let raidus = this._deviceRadius;
    this.primary.setBorderRadius({
      topLeft: raidus,
      topRight: raidus,
      bottomLeft: raidus,
      bottomRight: raidus
    }, 'primSetDeviceBorderRadius');
  }

  /**
   * primary scene rotate
   *
   * @param { Number } angle
   */
  public doPrimRotate(angle: number): void {
    if (this.isUpDownSplit()) {
      this.primary.rotateX = 1;
      this.primary.rotateY = 0;
      this.primary.rotateZ = 0;
      this.primary.rotateAngle = angle;
      if (this.splitOrderIsNotReverse) {
        this.primary.rotateCenterX = '50%';
        this.primary.rotateCenterY = '0%';
        this.primary.scaleCenterX = '50%';
        this.primary.scaleCenterY = '0%';
      } else {
        this.primary.rotateCenterX = '50%';
        this.primary.rotateCenterY = '100%';
        this.primary.scaleCenterX = '50%';
        this.primary.scaleCenterY = '100%';
      }
    } else {
      this.primary.rotateX = 0;
      this.primary.rotateY = 1;
      this.primary.rotateZ = 0;
      this.primary.rotateAngle = -angle;
      if (this.splitOrderIsNotReverse) {
        this.primary.rotateCenterX = '0%';
        this.primary.rotateCenterY = '50%';
        this.primary.scaleCenterX = '0%';
        this.primary.scaleCenterY = '50%';
      } else {
        this.primary.rotateCenterX = '100%';
        this.primary.rotateCenterY = '50%';
        this.primary.scaleCenterX = '100%';
        this.primary.scaleCenterY = '50%';
      }
    }
  }

  /**
   * secondary scene rotate
   *
   * @param { Number } angle
   */
  public doSecRotate(angle: number): void {
    if (this.isUpDownSplit()) {
      this.secondary.rotateX = 1;
      this.secondary.rotateY = 0;
      this.secondary.rotateZ = 0;
      this.secondary.rotateAngle = angle;
      if (this.splitOrderIsNotReverse) {
        this.secondary.rotateCenterX = '50%';
        this.secondary.rotateCenterY = '100%';
        this.secondary.scaleCenterX = '50%';
        this.secondary.scaleCenterY = '100%';
      } else {
        this.secondary.rotateCenterX = '50%';
        this.secondary.rotateCenterY = '0%';
        this.secondary.scaleCenterX = '50%';
        this.secondary.scaleCenterY = '0%';
      }
    } else {
      this.secondary.rotateX = 0;
      this.secondary.rotateY = 1;
      this.secondary.rotateZ = 0;
      this.secondary.rotateAngle = -angle;
      if (this.splitOrderIsNotReverse) {
        this.secondary.rotateCenterX = '100%';
        this.secondary.rotateCenterY = '50%';
        this.secondary.scaleCenterX = '100%';
        this.secondary.scaleCenterY = '50%';
      } else {
        this.secondary.rotateCenterX = '0%';
        this.secondary.rotateCenterY = '50%';
        this.secondary.scaleCenterX = '0%';
        this.secondary.scaleCenterY = '50%';
      }
    }
  }

  /**
   * primary and secondary scene scale
   *
   * @param { Number } firstSceneScale
   * @param { Number } secondSceneScale
   */
  public doSceneScale(firstSceneScale: number, secondSceneScale: number): void {
    if (this.isUpDownSplit()) {
      this.setFirstSceneScaleY(firstSceneScale);
      this.setSecondSceneScaleY(secondSceneScale);
    } else {
      this.setFirstSceneScaleX(firstSceneScale);
      this.setSecondSceneScaleX(secondSceneScale);
    }
  }

  /**
   * use width and height to scale window scene
   *
   * @param { Number } scale
   */
  public preSplitScale(scale: number): void {
    let scalePercent = Math.floor(scale * 100) + '%';
    if (this.isUpDownSplit()) {
      if (this.splitOrderIsNotReverse) {
        this.primary.height = scalePercent;
      } else {
        this.secondary.height = scalePercent;
      }
    } else {
      if (this.splitOrderIsNotReverse) {
        this.primary.width = scalePercent;
      } else {
        this.secondary.width = scalePercent;
      }
    }
  }

  /**
   * container rotate
   *
   * @param { Number } angle
   */
  public doContainerRotate(angle: number, isLeftRotate: boolean, isUpDownSplit: boolean): void {
    if (isUpDownSplit) {
      this.containerRotateX = 1;
      this.containerRotateY = 0;
      this.containerRotateZ = 0;
      if (isLeftRotate) {
        this.containerRotateAngle = angle;
        this.containerRotateCenterX = '50%';
        this.containerRotateCenterY = '50%';
      } else {
        this.containerRotateAngle = -angle;
        this.containerRotateCenterX = '50%';
        this.containerRotateCenterY = '50%';
      }
    } else {
      this.containerRotateX = 0;
      this.containerRotateY = 1;
      this.containerRotateZ = 0;
      if (isLeftRotate) {
        this.containerRotateAngle = -angle;
        this.containerRotateCenterX = '50%';
        this.containerRotateCenterY = '50%';
      } else {
        this.containerRotateAngle = angle;
        this.containerRotateCenterX = '50%';
        this.containerRotateCenterY = '50%';
      }
    }
  }

  /**
   * reset primary and secondary scene scale
   */
  public resetContainerRotate(): void {
    this.containerRotateX = 0;
    this.containerRotateY = 0;
    this.containerRotateZ = 0;
    this.containerRotateAngle = 0;
    this.containerRotateCenterX = 0;
    this.containerRotateCenterY = 0;
  }

  /**
   * primary and secondary scene scale
   *
   * @param { Number } firstSceneScale
   * @param { Number } secondSceneScale
   */
  public doSceneSessionScale(firstSceneScale: number, secondSceneScale: number): void {
    if (this.isUpDownSplit()) {
      this.setFirstSceneSessionScaleY(firstSceneScale);
      this.setSecondSceneSessionScaleY(secondSceneScale);
      if (this.splitOrderIsNotReverse) {
        this.primary.sessionScaleCenterX = '50%';
        this.primary.sessionScaleCenterY = '0%';
        this.secondary.sessionScaleCenterX = '50%';
        this.secondary.sessionScaleCenterY = '0%';
      } else {
        this.primary.sessionScaleCenterX = '50%';
        this.primary.sessionScaleCenterY = '0%';
        this.secondary.sessionScaleCenterX = '50%';
        this.secondary.sessionScaleCenterY = '0%';
      }
    } else {
      this.setFirstSceneSessionScaleX(firstSceneScale);
      this.setSecondSceneSessionScaleX(secondSceneScale);
      if (this.splitOrderIsNotReverse) {
        this.primary.sessionScaleCenterX = '0%';
        this.primary.sessionScaleCenterY = '50%';
        this.secondary.sessionScaleCenterX = '0%';
        this.secondary.sessionScaleCenterY = '50%';
      } else {
        this.primary.sessionScaleCenterX = '0%';
        this.primary.sessionScaleCenterY = '50%';
        this.secondary.sessionScaleCenterX = '0%';
        this.secondary.sessionScaleCenterY = '50%';
      }
    }
  }

  /**
   * reset primary and secondary scene scale
   */
  public resetSceneSessionScale(): void {
    if (this.isUpDownSplit()) {
      this.setFirstSceneSessionScaleY(1);
      this.setSecondSceneSessionScaleY(1);
      this.primary.sessionScaleCenterX = 0;
      this.primary.sessionScaleCenterY = 0;
      this.secondary.sessionScaleCenterX = 0;
      this.secondary.sessionScaleCenterY = 0;
    } else {
      this.setFirstSceneSessionScaleX(1);
      this.setSecondSceneSessionScaleX(1);
      this.primary.sessionScaleCenterX = 0;
      this.primary.sessionScaleCenterY = 0;
      this.secondary.sessionScaleCenterX = 0;
      this.secondary.sessionScaleCenterY = 0;
    }
  }

  /**
   * primary and secondary scene scale when touch
   *
   * @param { Number } firstSceneScale: first container scene scale X
   * @param { Number } firstSceneScale: first container scene scale Y
   * @param { Number } secondSceneScale: second container scene scale X
   * @param { Number } secondSceneScale: second container scene scale Y
   */
  public doSceneTouchScale(firstSceneScaleX: number, firstSceneScaleY: number, secondSceneScaleX: number, secondSceneScaleY: number): void {
    if (this.isUpDownSplit()) {
      this.setFirstSceneScaleX(firstSceneScaleX);
      this.setFirstSceneScaleY(firstSceneScaleY);
      this.setSecondSceneScaleX(secondSceneScaleX);
      this.setSecondSceneScaleY(secondSceneScaleY);
    } else {
      this.setFirstSceneScaleX(firstSceneScaleY);
      this.setFirstSceneScaleY(firstSceneScaleX);
      this.setSecondSceneScaleX(secondSceneScaleY);
      this.setSecondSceneScaleY(secondSceneScaleX);
    }
  }

  /**
   * primary and secondary scene translate when touch
   *
   * @param { Number } offset
   */
  public doSceneTouchTranslate(offset: number): void {
    if (this.splitOrderIsNotReverse) {
      if (this.isUpDownSplit()) {
        this.primary.touchTranslateX = 0;
        this.primary.touchTranslateY = offset;
        this.secondary.touchTranslateX = 0;
        this.secondary.touchTranslateY = -offset;
      } else {
        this.primary.touchTranslateX = offset;
        this.primary.touchTranslateY = 0;
        this.secondary.touchTranslateX = -offset;
        this.secondary.touchTranslateY = 0;
      }
    } else {
      if (this.isUpDownSplit()) {
        this.primary.touchTranslateX = 0;
        this.primary.touchTranslateY = -offset;
        this.secondary.touchTranslateX = 0;
        this.secondary.touchTranslateY = offset;
      } else {
        this.primary.touchTranslateX = -offset;
        this.primary.touchTranslateY = 0;
        this.secondary.touchTranslateX = offset;
        this.secondary.touchTranslateY = 0;
      }
    }
  }

  /**
   * Divider Translate
   *
   * @param { Number } offset: offset
   */
  public doDividerTranslate(offset: number): void {
    if (this.isUpDownSplit()) {
      this.dividerTranslateY = offset;
    } else {
      this.dividerTranslateX = offset;
    }
  }

  /**
   * Primary scene Translate
   *
   * @param { Number } translate: translate of primary
   */
  public doPrimaryTranslate(translate: number): void {
    if (this.isUpDownSplit()) {
      this.primary.translateY = translate;
    } else {
      this.primary.translateX = translate;
    }
  }


  /**
   * Reset Divider Position and trans
   */
  public resetDividerPositionAndTrans(): void {
    this.resetDividerTrans();
    this.updateDividerPosition();
  }

  /**
   * Update the Params of the Divider, notifyPositionChange called in method updateDividerPosition
   */
  public updateDividerParam(screenProperty: SCBScreenProperty): void {
    this.updateSplitStackPositionAndSize(screenProperty);
    this.updateDividerPosition();
    this.setBorderRadius();
  }

  /**
   * Update the Params of the Divider with 1:1 ratio
   */
  public updateDividerParamWithDefaultRatio(screenProperty: SCBScreenProperty): void {
    this.notifyAvoidAreaChange(screenProperty);
    this.restoreToDefaultRatio(screenProperty);
    this.updateSplitStackPositionAndSize(screenProperty);
    this.updateDividerPosition();
  }

  /**
   * updateDividerParamWithRatio, default 1 / 2
   * @param { SCBScreenProperty } screenProperty
   */
  /**
   * updateDividerParamWithRatio, default 1 / 2
   * @param { SCBScreenProperty } screenProperty
   */
  public updateDividerParamWithRatio(screenProperty: SCBScreenProperty, ratio: number = 1 / 2): void {
    // screenLength orthogonal to divider
    this.needCutOut = true;
    this.splitOrderIsNotReverse = true;
    this.notifyAvoidAreaChange(screenProperty);
    let screenLength = this.isUpDownSplit() ? px2vp(screenProperty.height) : px2vp(screenProperty.width);
    let dividerPct = DividerStyleConstants.DIVIDER_HEIGHT / screenLength;
    let statusBarPct = this.needCutOut ? this.statusBarPct : 0;
    this._primSizePct = ratio * (1 - dividerPct - statusBarPct);
    this._secSizePct = 1 - dividerPct - statusBarPct - this._primSizePct;
    this.updateDividerParam(screenProperty);
  }

  public updateDividerParamWithRatioForMidScene(screenProperty: SCBScreenProperty, ratio: number = 1 / 2): void {
    this.notifyAvoidAreaChange(screenProperty);
    const isUltraScreenStateG = SCBTriFoldManager.getInstance().isCurGState();
    let screenLength =
      this.isUpDownSplit() && !isUltraScreenStateG ? px2vp(screenProperty.height) : px2vp(screenProperty.width);
    let dividerPct = DividerStyleConstants.DIVIDER_HEIGHT / screenLength;
    let statusBarPct = this.needCutOut && !isUltraScreenStateG ? this.statusBarPct : 0;
    this._primSizePct = ratio * (1 - dividerPct - statusBarPct);
    this._secSizePct = 1 - dividerPct - statusBarPct - this._primSizePct;
    this.updateDividerParam(screenProperty);
  }

  /**
   * Reset Scene Position And Size
   */
  public updateSplitStackPositionAndSize(screenProperty: SCBScreenProperty): void {
    this.notifyAvoidAreaChange(screenProperty);
    this.notifyLayoutChange();
    this.updateSplitStackSize(screenProperty);
    this.updateSplitStackPosition(screenProperty);
  }

  /**
   * set variable params when init or after each gesture according to
   * this.primSizePct and this.secSizePct.
   * @param isVertical
   */
  public updateDividerPosition(): void {
    const toPercent: number = 100;
    this.resetDividerPos();
    if (this.splitOrderIsNotReverse) {
      if (this.isUpDownSplit()) {
        this.positionY = `${(this.primSizePct + this.avoidYPct + this.containerTranYPct) * toPercent}%`;
      } else {
        this.positionX = `${(this.primSizePct + this.avoidXPct) * toPercent}%`;
      }
    } else {
      if (this.isUpDownSplit()) {
        this.positionY = `${(this.secSizePct + this.avoidYPct + this.containerTranYPct) * toPercent}%`;
      } else {
        this.positionX = `${(this.secSizePct + this.avoidXPct) * toPercent}%`;
      }
    }
    this.notifyPositionChange();
  }

  /**
   * Reset Blur Opacity
   */
  public resetBlurOpacity(): void {
    this.primary.blurScale = 0;
    this.secondary.blurScale = 0;
  }

  public getFirstSceneTranslateX(): number {
    return this.splitOrderIsNotReverse ? this.primary.translateX : this.secondary.translateX;
  }

  /**
   * Obtain an X-axis translation value of the second scene
   *
   * @returns { Number } Returns the X-axis translation value of the second scene
   */
  public getSecondSceneTranslateX(): number {
    return this.splitOrderIsNotReverse ? this.secondary.translateX : this.primary.translateX;
  }

  /**
   * Gets the Y translation value of the first scene
   *
   * @returns { Number } Return the Y translation value of the first scene
   */
  public getFirstSceneTranslateY(): number {
    return this.splitOrderIsNotReverse ? this.primary.translateY : this.secondary.translateY;
  }

  /**
   * Obtain a Y-axis displacement of the second scenario
   *
   * @returns { number } Returns the Y-axis displacement of the second scene
   */
  public getSecondSceneTranslateY(): number {
    return this.splitOrderIsNotReverse ? this.secondary.translateY : this.primary.translateY;
  }

  /**
   * Get the percentage of the first scene
   *
   * @returns Returns the percentage of the first scene
   */
  public getFirstScenePct(): number {
    return this.splitOrderIsNotReverse ? this.primSizePct : this.secSizePct;
  }

  /**
   * Set the percentage of the first scene
   *
   * @param { Number } sizePct Percentage of Scenarios
   */
  public setFirstScenePct(sizePct: number): void {
    if (this.splitOrderIsNotReverse) {
      this.primSizePct = sizePct;
    } else {
      this.secSizePct = sizePct;
    }
  }

  /**
   * Obtains the percentage of the second scenario.
   *
   * @returns { Number } Returns the percentage of the second scenario
   */
  public getSecondScenePct(): number {
    return this.splitOrderIsNotReverse ? this.secSizePct : this.primSizePct;
  }

  /**
   * Set the percentage of the second scene
   *
   * @param { Number } sizePct
   */
  public setSecondScenePct(sizePct: number): void {
    if (this.splitOrderIsNotReverse) {
      this.secSizePct = sizePct;
    } else {
      this.primSizePct = sizePct;
    }
  }

  /**
   * Sets the X scale of the first scene
   *
   * @param { Number } scaleX
   */
  public setFirstSceneScaleX(scaleX: number): void {
    if (this.splitOrderIsNotReverse) {
      this.primary.scaleX = scaleX;
    } else {
      this.secondary.scaleX = scaleX;
    }
  }

  /**
   * Gets the X-axis scale of the first scene
   *
   * @return { number } Returns the X-axis scaling
   */
  public getFirstSceneScaleX(): number {
    return this.splitOrderIsNotReverse ? this.primary.scaleX : this.secondary.scaleX;
  }

  /**
   * Sets the Y-axis scaling of the first scene
   *
   * @param { Number } scaleY Scaling Ratio
   */
  public setFirstSceneScaleY(scaleY: number): void {
    if (this.splitOrderIsNotReverse) {
      this.primary.scaleY = scaleY;
    } else {
      this.secondary.scaleY = scaleY;
    }
  }

  /**
   * Obtains the zoom ratio (Y) of the first scene.
   *
   * @return { number } Returns the scale Y of the first scene
   */
  public getFirstSceneScaleY(): number {
    return this.splitOrderIsNotReverse ? this.primary.scaleY : this.secondary.scaleY;
  }

  /**
   * Set the X-axis scaling of the second scene
   *
   * @param { Number } scaleX Scaling Ratio
   */
  public setSecondSceneScaleX(scaleX: number): void {
    if (this.splitOrderIsNotReverse) {
      this.secondary.scaleX = scaleX;
    } else {
      this.primary.scaleX = scaleX;
    }
  }

  /**
   * Acquire an X-axis scaling ratio of the second scene
   *
   * @return { number } Returns the X-axis scaling
   */
  public getSecondSceneScaleX(): number {
    return this.splitOrderIsNotReverse ? this.secondary.scaleX : this.primary.scaleX;
  }

  /**
   * Sets the Y-axis scaling of the second scene
   *
   * @param { Number } scaleY Scaling Ratio
   */
  public setSecondSceneScaleY(scaleY: number): void {
    if (this.splitOrderIsNotReverse) {
      this.secondary.scaleY = scaleY;
    } else {
      this.primary.scaleY = scaleY;
    }
  }

  /**
   * Acquire a Y-axis scaling ratio of the second scene
   *
   * @return { number } Returns the Y-axis scaling factor
   */
  public getSecondSceneScaleY(): number {
    return this.splitOrderIsNotReverse ? this.secondary.scaleY : this.primary.scaleY;
  }

  /**
   * Calculates and sets the displacement of the dividing line based on the given width and height
   *
   * @param { Number } width
   * @param { Number } height
   */
  public reverseDividerTrans(width: number, height: number): void {
    const diffPercent: number = this.secSizePct - this.primSizePct;
    if (this.isUpDownSplit()) {
      this.dividerTranslateX = 0;
      this.dividerTranslateY = this.splitOrderIsNotReverse ? diffPercent * height : -diffPercent * height;
    } else {
      this.dividerTranslateX = this.splitOrderIsNotReverse ? diffPercent * width : -diffPercent * width;
      this.dividerTranslateY = 0;
    }
    this.notifyPositionChange();
  }

  /**
   * Sets the position of the separator line.
   *
   * @param { Number } translateX
   * @param { Number } translateY
   */
  public setDividerTrans(translateX: number, translateY: number): void {
    this.dividerTranslateX = translateX;
    this.dividerTranslateY = translateY;
    this.notifyPositionChange();
  }

  /**
   * Sets the primary zoom center point
   *
   * @param { String|Number } scaleCenterX
   * @param { String|Number } scaleCenterY
   */
  public setPrimaryScaleCenter(scaleCenterX: string | number, scaleCenterY: string | number): void {
    this.primary.scaleCenterX = scaleCenterX;
    this.primary.scaleCenterY = scaleCenterY;
  }

  /**
   * Set the position of the center point of the secondary scale
   *
   * @param { String|Number } scaleCenterX
   * @param { String|Number } scaleCenterY
   */
  public setSecondaryScaleCenter(scaleCenterX: string | number, scaleCenterY: string | number): void {
    this.secondary.scaleCenterX = scaleCenterX;
    this.secondary.scaleCenterY = scaleCenterY;
  }

  /**
   * Set the primary zoom factor
   *
   * @param { Number } scaleX
   * @param { Number } scaleY
   */
  public setPrimaryScale(scaleX: number, scaleY: number): void {
    this.primary.scaleX = scaleX;
    this.primary.scaleY = scaleY;
  }

  /**
   * Set the secondary scaling ratio.
   *
   * @param { Number } scaleX
   * @param { Number } scaleY
   */
  public setSecondaryScale(scaleX: number, scaleY: number): void {
    this.secondary.scaleX = scaleX;
    this.secondary.scaleY = scaleY;
  }

  /**
   * Set the primary translation amount
   *
   * @param { Number } translateX
   * @param { Number } translateY
   */
  public setPrimaryTrans(translateX: number, translateY: number): void {
    this.primary.translateX = translateX;
    this.primary.translateY = translateY;
  }

  /**
   * Set the X and Y coordinates of the second-level transformation
   *
   * @param { Number } translateX
   * @param { Number } translateY
   */
  public setSecondaryTrans(translateX: number, translateY: number): void {
    this.secondary.translateX = translateX;
    this.secondary.translateY = translateY;
  }

  /**
   * Calculate the position of the main transition based on the width and height
   *
   * @param { Number } width
   * @param { Number } height
   */
  public reversePrimaryTrans(width: number, height: number): void {
    const diff = 1 - this.primSizePct;
    const cutOutLength = this.needCutOut ? this.getStatusBarHeight() : 0;
    if (this.isUpDownSplit()) {
      let translateY = diff * height - cutOutLength;
      this.primary.translateX = 0;
      this.primary.translateY = this.splitOrderIsNotReverse ? translateY : -translateY;
    } else {
      let translateX = diff * width - cutOutLength;
      this.primary.translateX = this.splitOrderIsNotReverse ? translateX : -translateX;
      this.primary.translateY = 0;
    }
  }

  /**
   * Reverse split scene border radius
   *
   * @param { Boolean } isPrimaryScene
   * @param { Boolean } reverseRadius
   */
  public reverseSplitSceneBorderRadius(isPrimaryScene: boolean, reverseRadius?: boolean): void {
    if (!reverseRadius) {
      if (isPrimaryScene) {
        this.primary.setBorderRadius(this.splitOrderIsNotReverse ? this.getFirstSceneBorderRadius() :
        this.getSecondSceneBorderRadius(), 'reverseSplitSceneBorderRadius');
      } else {
        this.secondary.setBorderRadius(this.splitOrderIsNotReverse ? this.getSecondSceneBorderRadius() :
        this.getFirstSceneBorderRadius(), 'reverseSplitSceneBorderRadius');
      }
    } else {
      // reverse borderRadius
      if (isPrimaryScene) {
        this.primary.setBorderRadius(this.splitOrderIsNotReverse ? this.getSecondSceneBorderRadius() :
        this.getFirstSceneBorderRadius(), 'reverseSplitSceneBorderRadius');
      } else {
        this.secondary.setBorderRadius(this.splitOrderIsNotReverse ? this.getFirstSceneBorderRadius() :
        this.getSecondSceneBorderRadius(), 'reverseSplitSceneBorderRadius');
      }
    }
  }

  /**
   * Calculates and sets the conversion value of the level-2 area based on the width and height.
   *
   * @param { Number } width
   * @param { Number } height
   */
  public reverseSecondaryTrans(width: number, height: number): void {
    const diff = 1 - this.secSizePct;
    const cutOutLength = this.needCutOut ? this.getStatusBarHeight() : 0;
    if (this.isUpDownSplit()) {
      let translateY = diff * height - cutOutLength;
      this.secondary.translateX = 0;
      this.secondary.translateY = this.splitOrderIsNotReverse ? -translateY : translateY;
    } else {
      let translateX = diff * width - cutOutLength;
      this.secondary.translateX = this.splitOrderIsNotReverse ? -translateX : translateX;
      this.secondary.translateY = 0;
    }
  }

  /**
   * getAvoidPctIfNeeded when 270
   * @param screenProperty
   * @returns
   */
  public getAvoidPctIfNeeded(screenProperty: SCBScreenProperty): number {
    let res = 0;
    let rotation = screenProperty.rotation;
    if (!isLargeFoldProductInExpand() && rotation === RotationConstants.ROTATION_90) {
      res = this.statusBarPct;
    }
    return res;
  }

  /**
   * notification when the interaction status changes. true indicates can interact with containers.
   */
  private interactiveStateChangeCallback: (state: boolean) => void;

  private initAnimationParam(): void {
    this.primary.translateX = 0;
    this.primary.translateY = 0;
    this.secondary.translateX = 0;
    this.secondary.translateY = 0;
    this.dividerTranslateX = 0;
    this.dividerTranslateY = 0;
    this.scaleX = 1;
    this.scaleY = 1;
    this.primary.scaleX = 1;
    this.primary.scaleY = 1;
    this.primary.sessionScaleX = 1;
    this.primary.sessionScaleY = 1;
    this.secondary.scaleX = 1;
    this.secondary.scaleY = 1;
    this.secondary.sessionScaleX = 1;
    this.primary.sessionScaleCenterX = 0;
    this.secondary.sessionScaleCenterX = 0;
    this.secondary.sessionScaleY = 1;
    this.primary.sessionScaleCenterY = 0;
    this.secondary.sessionScaleCenterY = 0;
    this.primary.scaleCenterX = 0;
    this.primary.scaleCenterY = 0;
    this.secondary.scaleCenterX = 0;
    this.secondary.scaleCenterY = 0;
    this.primary.zIndex = 0;
    this.secondary.zIndex = 0;
    this.primary.opacity = 1;
    this.secondary.opacity = 1;
    this.primary.sessionOpacity = 1;
    this.secondary.sessionOpacity = 1;
    this.primary.blurScale = 0;
    this.secondary.blurScale = 0;
    this.blackBackgroundOpacity = 0;
    this.primary.touchTranslateX = 0;
    this.primary.touchTranslateY = 0;
    this.secondary.touchTranslateX = 0;
    this.secondary.touchTranslateY = 0;
    this.primary.effectRatio = 0;
    this.secondary.effectRatio = 0;
  }

  /**
   * Gets the bounding radius of the first scene
   *
   * @returns { BorderRadiuses } Returns an object with the radius of the four corners rounded
   */
  private getFirstSceneBorderRadius(): BorderRadiuses {
    let edgeBorderRadius = this._deviceRadius;
    let centerBorderRadius = DividerStyleConstants.SPLIT_BORDER_RADIUS;
    if (this.isUpDownSplit()) {
      return {
        topLeft: edgeBorderRadius, topRight: edgeBorderRadius,
        bottomLeft: centerBorderRadius, bottomRight: centerBorderRadius
      };
    }
    return {
      topRight: centerBorderRadius, bottomRight: centerBorderRadius,
      topLeft: edgeBorderRadius, bottomLeft: edgeBorderRadius
    };
  }

  private getSecondSceneBorderRadius(): BorderRadiuses {
    let edgeBorderRadius = this._deviceRadius;
    let centerBorderRadius = DividerStyleConstants.SPLIT_BORDER_RADIUS;
    if (this.isUpDownSplit()) {
      return {
        topLeft: centerBorderRadius, topRight: centerBorderRadius,
        bottomLeft: edgeBorderRadius, bottomRight: edgeBorderRadius
      };
    }
    return {
      topLeft: centerBorderRadius, bottomLeft: centerBorderRadius,
      topRight: edgeBorderRadius, bottomRight: edgeBorderRadius
    };
  }


  private setSecondSceneSessionScaleX(scaleX: number): void {
    if (this.splitOrderIsNotReverse) {
      this.secondary.sessionScaleX = scaleX;
    } else {
      this.primary.sessionScaleX = scaleX;
    }
  }

  private setSecondSceneSessionScaleY(scaleY: number): void {
    if (this.splitOrderIsNotReverse) {
      this.secondary.sessionScaleY = scaleY;
    } else {
      this.primary.sessionScaleY = scaleY;
    }
  }

  /**
   * Sets the X-axis scaling ratio of the session in the first scenario.
   *
   * @param { Number } scaleX
   */
  private setFirstSceneSessionScaleX(scaleX: number): void {
    if (this.splitOrderIsNotReverse) {
      this.primary.sessionScaleX = scaleX;
    } else {
      this.secondary.sessionScaleX = scaleX;
    }
  }

  private setFirstSceneSessionScaleY(scaleY: number): void {
    if (this.splitOrderIsNotReverse) {
      this.primary.sessionScaleY = scaleY;
    } else {
      this.secondary.sessionScaleY = scaleY;
    }
  }

  /**
   * update split stack size with size pct
   */
  public updateSplitStackSize(screenProperty?: SCBScreenProperty): void {
    const toPercent: number = 100;
    if (this.isUpDownSplit()) {
      // primary scene
      this.primary.width = '100%';
      this.primary.height = `${this.primSizePct * toPercent}%`;
      // secondary scene
      this.secondary.width = '100%';
      this.secondary.height = `${this.secSizePct * toPercent}%`;
    } else {
      let height = '100%';
      // primary scene
      this.primary.width = `${this.primSizePct * toPercent}%`;
      this.primary.height = height;
      // secondary scene
      this.secondary.width = `${this.secSizePct * toPercent}%`;
      this.secondary.height = height;
    }
  }

  public resetSplitStackSize(): void {
    this.primary.width = '100%';
    this.primary.height = '100%';
    this.secondary.width = '0%';
    this.secondary.height = '0%';
  }

  private resetPrimAndSecPos(): void {
    this.primary.posX = '0%';
    this.primary.posY = '0%';
    this.secondary.posX = '0%';
    this.secondary.posY = '0%';
  }

  private resetDividerPos(): void {
    this.positionX = '0%';
    this.positionY = '0%';
  }

  private resetAvoidParam(): void {
    this.avoidXPct = 0;
    this.avoidYPct = 0;
    this.statusBarPct = 0;
  }

  private resetDividerTrans(): void {
    this.dividerTranslateX = 0;
    this.dividerTranslateY = 0;
  }

  private getStatusBarHeight(): number {
    let statusBarH: number = px2vp(windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height);
    if (statusBarH !== 0) {
      statusBarH++;
    }
    return Math.ceil(statusBarH);
  }

  private notifyLayoutChange(): void {
    if (this.isUpDownSplit()) {
      // divider
      this.buttonWidth = DIVIDER_RESPONSE_WIDTH;
      this.buttonHeight = DividerStyleConstants.DIVIDER_HEIGHT;
      this.dividerWidth = '100%';
      this.dividerHeight = DividerStyleConstants.DIVIDER_HEIGHT;
      this.dividerCircleWidth = DividerStyleConstants.DIVIDER_CIRCLE_WIDTH;
      this.dividerCircleHeight = DividerStyleConstants.DIVIDER_CIRCLE_HEIGHT;
      this.backboardWidth = BACKBOARD_HEIGHT;
      this.backboardHeight = BACKBOARD_WIDTH;
    } else {
      // divider
      this.buttonWidth = DividerStyleConstants.DIVIDER_HEIGHT;
      this.buttonHeight = DIVIDER_RESPONSE_WIDTH;
      this.dividerWidth = DividerStyleConstants.DIVIDER_HEIGHT;
      this.dividerHeight = '100%';
      this.dividerCircleWidth = DividerStyleConstants.DIVIDER_CIRCLE_HEIGHT;
      this.dividerCircleHeight = DividerStyleConstants.DIVIDER_CIRCLE_WIDTH;
      this.backboardWidth = BACKBOARD_WIDTH;
      this.backboardHeight = BACKBOARD_HEIGHT;
    }
  }

  private parseStrPctToNum(pctStr: string): number {
    return parseFloat(pctStr) / DividerStyleConstants.PERCENT;
  }

  /**
   * set the same default ratio for two split scenes
   *
   * @param  { SCBScreenProperty } screenProperty
   */
  public restoreToDefaultRatio(screenProperty: SCBScreenProperty): void {
    if (screenProperty.height === 0 || screenProperty.width === 0) {
      log.showError('Failed to check screenProperty, height or width is zero');
      return;
    }
    let dividerPct = this.isUpDownSplit() ?
      DividerStyleConstants.DIVIDER_HEIGHT / px2vp(screenProperty.height) :
      DividerStyleConstants.DIVIDER_HEIGHT / px2vp(screenProperty.width);
    let statusPct = this.needCutOut ? this.statusBarPct : 0;
    let sizePercent = (1 - dividerPct - statusPct) / 2;
    this.primSizePct = sizePercent;
    this.secSizePct = sizePercent;
  }

  /**
   * get screen length in the same direction as divider, in any screen rotation or any splitStyle
   * @returns screen length in the same direction as divider
   */
  public getDividerSameDirectionScreenLength(screenWidth: number, screenHeight: number): number {
    if (this.isUpDownSplit()) {
      return screenWidth;
    } else {
      return screenHeight;
    }
  }

  /**
   * get screen length in the direction that vertical to divider, in any screen rotation or any splitStyle
   * @returns screen length in the vertical direction to divider
   */
  public getDividerVerticalDirectionScreenLength(screenWidth: number, screenHeight: number): number {
    if (this.isUpDownSplit()) {
      return screenHeight;
    } else {
      return screenWidth;
    }
  }

  public setScenePctSize(pctWidth: number, pctHeight: number, toPrimary: boolean): void {
    if (toPrimary === this.splitOrderIsNotReverse) {
      this.primary.width = `${pctWidth * 100}%`;
      this.primary.height = `${pctHeight * 100}%`;
    } else {
      this.secondary.width = `${pctWidth * 100}%`;
      this.secondary.height = `${pctHeight * 100}%`;
    }
  }

  public setScenePctPosition(pctX: number, pctY: number, toPrimary: boolean): void {
    if (toPrimary === this.splitOrderIsNotReverse) {
      this.primary.posX = `${pctX * 100}%`;
      this.primary.posY = `${pctY * 100}%`;
    } else {
      this.secondary.posX = `${pctX * 100}%`;
      this.secondary.posY = `${pctY * 100}%`;
    }
  }

  public setSceneBorderRadius(borderRadius: BorderRadiuses, toPrimary: boolean): void {
    if (toPrimary === this.splitOrderIsNotReverse) {
      this.primary.setBorderRadius(borderRadius, 'setSceneBorderRadius');
    } else {
      this.secondary.setBorderRadius(borderRadius, 'setSceneBorderRadius');
    }
  }

  public applyDevicesRadius(radius: number, toPrimary: boolean): void {
    this.needClip = true;
    this.setSceneBorderRadius({
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius,
    }, toPrimary);
  }

  public setSceneScale(x: number, y: number, primary: boolean): void {
    if (primary === this.splitOrderIsNotReverse) {
      this.primary.scaleX = x;
      this.primary.scaleY = y;
    } else {
      this.secondary.scaleX = x;
      this.secondary.scaleY = y;
    }
  }

  public setSceneSessionScale(x: number, y: number, primary: boolean): void {
    if (primary === this.splitOrderIsNotReverse) {
      this.primary.sessionScaleX = x;
      this.primary.sessionScaleY = y;
    } else {
      this.secondary.sessionScaleX = x;
      this.secondary.sessionScaleY = y;
    }
  }

  public setSceneSessionScaleCenter(x: number | string, y: number | string, primary: boolean): void {
    if (primary === this.splitOrderIsNotReverse) {
      this.primary.sessionScaleCenterX = x;
      this.primary.sessionScaleCenterY = y;
    } else {
      this.secondary.sessionScaleCenterX = x;
      this.secondary.sessionScaleCenterY = y;
    }
  }

  public setShadowOptions(options: ShadowOptions, primary: boolean): void {
    if (primary === this.splitOrderIsNotReverse) {
      this.primary.shadowOptions = options;
    } else {
      this.secondary.shadowOptions = options;
    }
  }

  public clearPrimaryDynamicVariable(): void {
    this.primary.translateX = 0;
    this.primary.translateY = 0;
    this.dividerTranslateX = 0;
    this.dividerTranslateY = 0;
    this.primary.scaleX = 1;
    this.primary.scaleY = 1;
    this.isDividerDragging = false;
    this.notifyPositionChange();
  }

  public setPrimSize(primaryW: string, primaryH: string): void {
    this.primary.width = primaryW;
    this.primary.height = primaryH;
  }

  public setSecondarySize(width: string, height: string): void {
    this.secondary.width = width;
    this.secondary.height = height;
  }

  public setBothSceneScale(scale: number = 1): void {
    this.setPrimaryScale(scale, scale);
    this.setSecondaryScale(scale, scale);
  }

  public isDragging(): boolean {
    return this.isDividerDragging;
  }

  public setPrimaryScaleCenterAlongDivider(): void {
    if (this.isUpDownSplit()) {
      this.primary.scaleCenterX = '50%';
      this.primary.scaleCenterY = this.splitOrderIsNotReverse ? '100%' : '0%';
    } else {
      this.primary.scaleCenterX = this.splitOrderIsNotReverse ? '100%' : '0%';
      this.primary.scaleCenterY = '50%';
    }
  }

  public setSecondaryScaleCenterAlongDivider(): void {
    if (this.isUpDownSplit()) {
      this.secondary.scaleCenterX = '50%';
      this.secondary.scaleCenterY = this.splitOrderIsNotReverse ? '0%' : '100%';
    } else {
      this.secondary.scaleCenterX = this.splitOrderIsNotReverse ? '0%' : '100%';
      this.secondary.scaleCenterY = '50%';
    }
  }

  private getStatusBarOrDockHeightInPc(screenProperty: SCBScreenProperty, systemBarType: SystemBarType): number {
    if (SCBSceneSessionManager.getInstance().isPc()) {
      let statusBar = SCBSceneSessionManager.getInstance()
        .getSystemSceneSessionWithSystemBarType(systemBarType, screenProperty.screenId);
      if (statusBar && !AppStorage.get<boolean>('isDockAutoHide')) {
        return statusBar.currRect.height.getPx();
      }
    }
    return 0;
  }
}

export interface BorderRadiuses {
  topLeft?: number;
  topRight?: number;
  bottomLeft?: number;
  bottomRight?: number;
}

/**
 * Defines an interface for describing the margins of an element.
 */
interface Margin {
  top?: number;
  left?: number;
  right?: number;
  bottom?: number;
}

/**
 * one step offset in screen, offset is positive
 * @returns offset in vp
 */
export function getOneStepSplitOffset(): number {
  return isLargeFoldProductInExpand() ?
    ONE_STEP_SPLIT_OFFSET_FOR_EXPAND : ONE_STEP_SPLIT_OFFSET_FOR_FOLDED;
}

/**
 * Method for handling large folds in the limited expanded state.
 *
 * @returns true if:
 * - A single large fold is in the expanded state, or
 * - A tri-fold of large fold is in M state.
 */
export function isLargeFoldProductInExpand(): boolean {
  if (DeviceHelper.isUltraScreenProduct()) {
    let foldStatus: display.FoldStatus = SCBScreenSessionManager.getInstance().getCurFoldStatus();
    if (foldStatus === display.FoldStatus.FOLD_STATUS_EXPANDED) {
      if (SCBTriFoldManager.getInstance().isCurFState()) {
        return false;
      }
      return true;
    }
    return foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED;
  }
  return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() && DeviceHelper.isLargeInFoldProduct();
}