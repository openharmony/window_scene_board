/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { RectItem, LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import type { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { ScbNumber, SCBSessionRect } from './SCBSessionRect';
import { NeedRenderTranslate, SCBSceneContainerSession } from './SCBSceneContainerSession';
import { SCBGestureActionId } from '../../common/SCBGestureAction';
import { RotationConstants } from '@ohos/commonconstants';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { isLargeFoldProductInExpand } from './SCBDividerParam';
import { SCBSceneSessionManager } from './SCBSceneSessionManager';

const TAG = 'SCBFloatingParam';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const MAIN_SCREEN_ID = 5;
const DEFAULT_RATIO: number = 2;
const DEFAULT_RATIO_POINT = 2;
const ONE_HALF: number = 1 / 2;
const PHONE_STATUS_BAR_HEIGHT: number = 39;
const SHADOW_INIT_COLOR: Resource = $r('app.color.transparent');
const BORDER_LINE_TRANSPARENT: string = '#00317af7';
const UNFOCUSED_SHADOW_COLOR: string = '#40000000';
const FOCUSED_SHADOW_COLOR: string = '#73000000';
const RECENT_BOARD_RADIUS = 16;
const ULTRA_SCREEN_F_MAIN_WIDTH = 1008;
const ULTRA_SCREEN_M_MAIN_WIDTH = 2048;

export class FloatingRectCache extends RectItem {
  public isMiniScene: boolean = false;
  public scale: number = 1;
  public screenWidth: number = 1;
  public screenHeight: number = 1;

  public setFloatingRect(src: FloatingRectCache): void {
    this.setRect(src);
    this.isMiniScene = src.isMiniScene;
    this.scale = src.scale;
  }
}

/**
 * param of SCBFloating
 */
@Observed
export class SCBFloatingParam {
  /* --- Attributes associated with the UI ---*/
  /**
   * Floating scene scale
   */
  @Track scale: number = 1.0;

  /**
   * Floating scene shadow options
   */
  @Track shadowOptions?: ShadowOptions;

  /**
   * Floating scene border color
   */
  @Track borderColor: string = BORDER_LINE_TRANSPARENT;

  /**
   * Floating scene border width
   */
  @Track borderWidth: number = 0;

  /**
   * whether the background mask at the bottom of the container need show
   */
  @Track needShowBackground: boolean = false;

  /* --- Attributes used for auxiliary judgment --- */
  /**
   * Floating scene floatingScaleHelper
   */
  @Track floatingScaleHelper: number = 1.0;

  /**
   * Floating scene defaultWidthRatio
   */
  @Track defaultWidthRatio: number = 0;

  /**
   * Floating scene aspectRatio
   */
  @Track aspectRatio: number = 0;

  /**
   * Floating scene maxWidthRatio
   */
  @Track maxWidthRatio: number = 0;

  /**
   * float full screen maxWidthRatio
   */
  @Track maxFullScreenRatio: number = Number.MAX_VALUE;

  /**
   * Floating scene miniWidthRatio
   */
  @Track miniWidthRatio: number = 0;

  /**
   * Set borderRadius
   *
   * @param { maxWidthRatio } number
   * @param { callerFunctionName } string
   */
  public setMaxWidthRatio(maxWidthRatio: number, callerFunctionName: string): void {
    if (this.maxWidthRatio === maxWidthRatio) {
      return;
    }
    log.showInfo(`setMaxWidthRatio from ${this.maxWidthRatio} to ${maxWidthRatio}` +
      ` , caller function name: ${callerFunctionName}`);
    this.maxWidthRatio = maxWidthRatio;
  }

  /**
   * Floating scene calcRatioBaseWidth
   * unit: px
   */
  @Track calcRatioBaseWidth: number = 0;

  /**
   * Floating scene mini scene`s top margin
   */
  @Track miniSceneTopMargin: number = 0;

  /**
   * Floating scene mini scene`s right margin
   */
  @Track miniSceneRightMargin: number = 0;

  /**
   * Floating scene cornerRadius
   */
  @Track cornerRadius: number = 0;

  /**
   * cache rect for minimize floating
   */
  @Track cacheRect: RectItem = new RectItem(0, 0, 0, 0);

  @Track aspectWithTitleBar: number = 1.0;


  /**
   * Set borderRadius
   *
   * @param { aspectWithTitleBar } number
   * @param { callerFunctionName } string
   */
  public setAspectWithTitleBar(aspectWithTitleBar: number, callerFunctionName: string): void {
    if (this.aspectWithTitleBar === aspectWithTitleBar) {
      return;
    }
    log.showInfo(`setAspectWithTitleBar from ${this.aspectWithTitleBar} to ${aspectWithTitleBar}` +
      ` , caller function name: ${callerFunctionName}`);
    this.aspectWithTitleBar = aspectWithTitleBar;
  }

  @Track cornerParam: CornerParam = new CornerParam();

  @Track recentParams: RecentParams = new RecentParams();

  /**
   * SCBSideEdgeBarCover need show flag
   */
  @Track showSideBarCover: boolean = false;
  /**
   * SCBSideEdgeBarCover center line's offset-x
   */
  @Track highLightBarOffsetX: number = 0;
  /**
   * SCBSideEdgeBarCover alpha
   */
  @Track sideBarAlpha: number = 0;
  /**
   * floating component touchable
   */
  @Track touchable: boolean = true;

  @Track floatRecentAnimateFinished: boolean = true;
  /**
   * floating keep in recent after animation
   */
  @Track floatInRecentFinished: boolean = false;

  /**
   * cache rect for single click mini scene
   */
  @Track cacheRectForMini: RectItem = new RectItem(0, 0, 0, 0);

  /**
   * floating component translate
   */
  @Track needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();

  /**
   * cache scale for single click mini scene
   */
  @Track cacheScaleForMini: number = 0;

  @Track isFocused :boolean = true;

  /**
   * judge if floating scene is closed by user
   */
  @Track isClosed: boolean = false;

  @Track isTerminated: boolean = false;

  @Track isMinimized: boolean = false;

  @Track isSkipFocusShadow: boolean = false;

  @Track private userAction: UserAction = UserAction.NONE;

  /**
   * record screen change after minimizing floating scene
   */
  @Track doFoldOrExpand: boolean = false;

  @Track isMinFloating: boolean = false;

  /**
   * Interrupt and close animation scene process identification
   */
  @Track isClosingFloat: boolean = false;


  @Track titleBarOpacity: number = 1;

  @Track titleOpacity: number = 1;

  /**
   * start from dock animation param
   */
  @Track transitionAnimationCount: number = 0;

  @Track boardOpacity: number = 0;

  @Track minAnimationNum: number = 0;

  @Track intoRecentAnimationNum: number = 0;

  /**
   * mini scene is dragging
   */
  @Track isFloatDragging = false;

  /**
   * needFloatScale
   */
  @Track needFloatScale: boolean = true;

  /**
   * isShowTitleBar
   */
  @Track isShowTitleBar = false;

  @Track isFloatEdgeDrag: boolean = false;

  @Track effectCompOpacity: number = 1;

  @Track needEffectComponent: boolean = false;

  /**
   * isLandscapeFloat
   */
  @Track isLandscapeFloat: boolean = false;

  @Track isHandleTouchEvent: boolean = false;

  @Track isInFullHotspot: boolean = false;

  @Track private transformCallbackList: Array<(id?: SCBGestureActionId) => void> = [];
  /**
   * 保存悬浮窗隐藏、退出等时的rect, 单位vp
   */
  @Track private recordRectMap: Map<RecordType, FloatingRectCache> = new Map();

  needRecoverStatusBar: boolean = false;

  /**
   * 关闭的悬浮窗动效结束需要恢复圆角值
   */
  needRecoverBorder: boolean = false;

  recentBorderRadius: number = RECENT_BOARD_RADIUS;

  /**
   * Timestamp when the floating window enters the side bar
   */
  timestampEnterSideBar: number = Date.now();

  /**
   * show floating titleBar with animation
   */
  needShowTitleWithAnim: boolean = false;

  /**
   * the width for snapshot in multiWindow scene, unit: px
   */
  @Track snapshotWidthPx: number = 0;

  /**
   * the height for snapshot in multiWindow scene, unit: px
   */
  @Track snapshotHeightPx: number = 0;

  /**
   * whether to switch from full screen to split by title bar menu
   */
  @Track isFullToOneSplitAnimation: boolean = false;

  public setScale(value: number): void {
    this.scale = value;
  }

  public getScale(): number {
    return this.scale;
  }

  /**
   * ui type, contains: phone、pad、pc
   */
  uiType: string = 'undefined';

  isUseShortSide: boolean = true;

  public recordRect(rect: FloatingRectCache, recordType: RecordType): void {
    let recordRect = new FloatingRectCache(0, 0, 0, 0);
    recordRect.setFloatingRect(rect);
    this.recordRectMap.set(recordType, recordRect);
  }

  public delRecordRect(recordType?: RecordType): void {
    if (recordType) {
      this.recordRectMap.delete(recordType);
      return;
    }
    this.recordRectMap.clear();
  }

  public getRectRecordByType(recordType: RecordType): FloatingRectCache | null {
    let rect: FloatingRectCache | null = null;
    if (this.recordRectMap.has(recordType)) {
      rect = this.recordRectMap.get(recordType);
      this.recordRectMap.delete(recordType);
    }
    return rect;
  }

  public checkRecordByType(recordType: RecordType): Boolean {
    return this.recordRectMap.has(recordType) && !CommonUtils.isInvalid(this.recordRectMap.get(recordType));
  }

  /**
   * Check if current is vertical or not by rotation
   *
   * @param rotation rotation with 0/90/180/270/360
   * @returns true if current is vertical or not
   */
  public isVertical(rotation: number): boolean {
    // should return 90 270 in horizontal
    return rotation === RotationConstants.ROTATION_0 || rotation === RotationConstants.ROTATION_180 ||
      rotation === RotationConstants.ROTATION_360;
  }

  /**
   * Initializing Device Information
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { Boolean } isDeviceExpanded
   */
  public initWithDeviceInfo(screenProperty: SCBScreenProperty, isDeviceExpanded?: boolean, isLandscapeFloat?: boolean,
    isUseShortSide: boolean = true): void {
    this.isLandscapeFloat = isLandscapeFloat;
    this.isUseShortSide = isUseShortSide;
    this.miniWidthRatio = isLandscapeFloat ? FloatingSceneCommonStyle.LANDSCAPE_MINI_WIDTH_RATIO : FloatingSceneCommonStyle.MINI_WIDTH_RATIO;
    this.cornerRadius = FloatingSceneCommonStyle.CORNER_RADIUS;
    this.miniSceneTopMargin = FloatingSceneCommonStyle.MINI_SCENE_TOP_MARGIN;
    if (isDeviceExpanded) {
      if (this.isLandscapeFloat) {
        this.initWithDeviceExpandLandscape(screenProperty);
      } else {
        this.initWithDeviceExpandedPortrait(screenProperty);
      }
    } else if (this.uiType === SCBConstants.UITYPE_PAD && isLandscapeFloat) {
      this.initWithDevicePadLandscape(screenProperty);
    } else {
      if (this.isLandscapeFloat) {
        this.initLandscapeFloatParam(screenProperty);
      } else {
        this.initPortraitFloatParam(screenProperty);
      }

      this.miniSceneRightMargin = FloatingScenePortraitStyle.MINI_SCENE_RIGHT_MARGIN;
      this.aspectRatio = this.getAspectRatio(screenProperty);
    }

    if (this.calcRatioBaseWidth === 0) {
      return;
    }

    this.doFoldOrExpand = false;
    this.setScale(1.0);
    if (this.defaultWidthRatio === 0) {
      return;
    }
    this.borderWidth = FloatingSceneCommonStyle.BORDER_WIDTH / this.defaultWidthRatio;
    this.setAspectWithTitleBar(this.aspectRatio, 'initWithDeviceInfo');
    this.titleBarOpacity = 1;
    this.effectCompOpacity = 1;
    this.highLightBarOffsetX = 0;
  }

  /**
   * phone or foldState floatingAspectRatio:
   * landscapeFloat: 16/9
   * SingleDisplayPocket: 3/4.815
   * other: 3/4.575
   *
   * @param isLandscapeFloat floating is landscapeFloating or not
   */
  private getAspectRatio(screenProperty: SCBScreenProperty): number {
    if (this.isLandscapeFloat) {
      return FloatingScenePortraitStyle.LANDSCAPE_ASPECT_RATIO;
    } else {
      let normalAspectRatio = FloatingScenePortraitStyle.ASPECT_RATIO;
      let physicsScreenWidth = Math.min(screenProperty.width, screenProperty.height);
      let physicsScreenHeight = Math.max(screenProperty.width, screenProperty.height);
      let titleBarRealHeight = vp2px(FloatingSceneCommonStyle.TITLEBAR_HEIGHT) / this.defaultWidthRatio;
      let normalRatioHeight = physicsScreenWidth / normalAspectRatio + titleBarRealHeight;
      if (normalRatioHeight > physicsScreenHeight) {
        return physicsScreenWidth / (physicsScreenHeight - titleBarRealHeight);
      } else {
        return normalAspectRatio;
      }
    }
  }

  /**
   * init pad portrait float param:
   *
   * @param screenProperty the screenProperty
   */
  private initWithDevicePadLandscape(screenProperty: SCBScreenProperty): void {
    if (this.isUseShortSide) {
      this.calcRatioBaseWidth = Math.min(screenProperty.width, screenProperty.height);
    } else {
      this.calcRatioBaseWidth = Math.max(screenProperty.width, screenProperty.height);
    }
    if (this.calcRatioBaseWidth === 0) {
      return;
    }

    this.calcPadLandscapeWidthRatio(screenProperty);
  }

  /**
   * calculate pad landscape width ratio:
   *
   * @param screenProperty the screenProperty
   */
  public calcPadLandscapeWidthRatio(screenProperty: SCBScreenProperty): void {
    if (this.calcRatioBaseWidth === 0) {
      return;
    }
    if (this.isUseShortSide) {
      let screenWidth = screenProperty.width;
      this.defaultWidthRatio = FloatingScenePadLayoutStyle.LANDSCAPE_DEFAULT_HEIGHT_RATIO *
        screenWidth / this.calcRatioBaseWidth;
      this.maxWidthRatio = FloatingScenePadLayoutStyle.LANDSCAPE_MAX_WIDTH_RATIO *
        screenWidth / this.calcRatioBaseWidth;
      this.miniSceneRightMargin = FloatingScenePortraitStyle.MINI_SCENE_RIGHT_MARGIN;
      this.aspectRatio = FloatingScenePadLayoutStyle.LANDSCAPE_ASPECT_RATIO;
      this.miniWidthRatio = FloatingScenePadLayoutStyle.MINI_WIDTH_RATIO;
      return;
    }
    let screenWidth = screenProperty.width;
    this.miniWidthRatio = FloatingScenePadLayoutStyle.MINI_WIDTH_RATIO;
    this.defaultWidthRatio = FloatingScenePadLayoutStyle.LANDSCAPE_DEFAULT_HEIGHT_RATIO *
      screenWidth / this.calcRatioBaseWidth;
    this.setMaxWidthRatio(FloatingScenePadLayoutStyle.LANDSCAPE_MAX_WIDTH_RATIO *
      screenWidth / this.calcRatioBaseWidth, 'calcPadLandscapeWidthRatio');
    this.maxFullScreenRatio = this.maxWidthRatio * (FloatingScenePadLayoutStyle.MAX_FULL_SCREEN_RATIO /
    FloatingScenePadLayoutStyle.MAX_WIDTH_RATIO);

    this.miniSceneRightMargin = FloatingScenePortraitStyle.MINI_SCENE_RIGHT_MARGIN;
    this.aspectRatio = FloatingScenePadLayoutStyle.LANDSCAPE_ASPECT_RATIO;
  }

  /**
   * init phone or expandState portrait float param:
   *
   * @param screenProperty the screenProperty
   */
  private initWithDeviceExpandedPortrait(screenProperty: SCBScreenProperty): void {
    this.calcExpandPortraitWidthRatio(screenProperty);

    this.miniSceneRightMargin = FloatingSceneExpandStyle.MINI_SCENE_RIGHT_MARGIN;
    this.aspectRatio = FloatingSceneExpandStyle.ASPECT_RATIO;
  }

  /**
   * rescale the maxWidthRatio in the expandState
   *
   */
  private anchorByPortraitStyle(): number {
    return 1.0 - (FloatingScenePortraitStyle.ORIGINAL_MAX_WIDTH_RATIO - FloatingScenePortraitStyle.MAX_WIDTH_RATIO) /
      FloatingScenePortraitStyle.ORIGINAL_MAX_WIDTH_RATIO;
  }

  /**
   * calculate phone or expandState portrait width ratio:
   *
   * @param screenProperty the screenProperty
   */
  public calcExpandPortraitWidthRatio(screenProperty: SCBScreenProperty): void {
    if (DeviceHelper.isUltraScreenProduct()) {
      this.calcRatioBaseWidth = ULTRA_SCREEN_F_MAIN_WIDTH;
    } else {
      let mainScreenProperty = SCBScreenSessionManager.getInstance().getPhyScreenProperty(MAIN_SCREEN_ID);
      this.calcRatioBaseWidth = mainScreenProperty.width > 0 ? mainScreenProperty.width :
        screenProperty.width / DEFAULT_RATIO;
    }

    if (this.calcRatioBaseWidth === 0) {
      return;
    }

    let screenWidth = Math.min(screenProperty.width, screenProperty.height);
    let screenHeight = Math.max(screenProperty.width, screenProperty.height);
    if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      screenWidth = Math.min(ULTRA_SCREEN_M_MAIN_WIDTH, screenWidth);
    }

    this.defaultWidthRatio = FloatingSceneExpandStyle.DEFAULT_WIDTH_RATIO * screenWidth / this.calcRatioBaseWidth;
    let maxWidthRatio = FloatingSceneExpandStyle.MAX_WIDTH_RATIO * screenWidth / this.calcRatioBaseWidth;
    maxWidthRatio *= this.anchorByPortraitStyle();
    if (!(DeviceHelper.isUltraScreenProduct() && screenHeight >= 2.5 * this.calcRatioBaseWidth)) {
      maxWidthRatio *= (screenProperty.height / screenHeight);
    }
    this.setMaxWidthRatio(maxWidthRatio, 'calcExpandPortraitWidthRatio');
    this.maxFullScreenRatio = this.maxWidthRatio * (FloatingScenePortraitStyle.MAX_FULL_SCREEN_RATIO /
      FloatingScenePortraitStyle.MAX_WIDTH_RATIO);
  }

  /**
   * init phone or expandState landscape float param:
   *
   * @param screenProperty the screenProperty
   */
  private initWithDeviceExpandLandscape(screenProperty: SCBScreenProperty): void {
    this.calcExpandLandscapeWidthRatio(screenProperty);
    this.miniSceneRightMargin = FloatingSceneExpandStyle.MINI_SCENE_RIGHT_MARGIN;
    this.aspectRatio = FloatingSceneExpandStyle.LANDSCAPE_ASPECT_RATIO;
  }

  private initWithDeviceExpanded(screenProperty: SCBScreenProperty, isLandscapeFloat: boolean | undefined): void {
    let screenWidth = Math.min(screenProperty.width, screenProperty.height);
    if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      screenWidth = Math.min(ULTRA_SCREEN_M_MAIN_WIDTH, screenProperty.height);
    }
    this.defaultWidthRatio = FloatingSceneExpandStyle.DEFAULT_WIDTH_RATIO * screenWidth / this.calcRatioBaseWidth;
    this.maxWidthRatio = isLandscapeFloat ?
      FloatingSceneExpandStyle.LANDSCAPE_MAX_WIDTH_RATIO * screenWidth / this.calcRatioBaseWidth :
      FloatingSceneExpandStyle.MAX_WIDTH_RATIO * screenWidth / this.calcRatioBaseWidth;
    this.miniSceneRightMargin = FloatingSceneExpandStyle.MINI_SCENE_RIGHT_MARGIN;
    this.aspectRatio =
      isLandscapeFloat ? FloatingSceneExpandStyle.LANDSCAPE_ASPECT_RATIO : FloatingSceneExpandStyle.ASPECT_RATIO;
  }

  /**
   * calculate phone or expandState landscape width ratio:
   *
   * @param screenProperty the screenProperty
   */
  public calcExpandLandscapeWidthRatio(screenProperty: SCBScreenProperty): void {
    if (this.isUseShortSide) {
      let mainScreenProperty = SCBScreenSessionManager.getInstance().getPhyScreenProperty(MAIN_SCREEN_ID);
      if (DeviceHelper.isUltraScreenProduct()) {
        this.calcRatioBaseWidth = ULTRA_SCREEN_F_MAIN_WIDTH;
      } else {
        this.calcRatioBaseWidth = mainScreenProperty.width > 0 ? mainScreenProperty.width :
          screenProperty.width / DEFAULT_RATIO;
      }
      if (this.calcRatioBaseWidth === 0) {
        return;
      }
      this.initWithDeviceExpanded(screenProperty, true);

      this.maxFullScreenRatio = this.maxWidthRatio * (FloatingScenePortraitStyle.MAX_FULL_SCREEN_RATIO /
      FloatingScenePortraitStyle.MAX_WIDTH_RATIO);
      return;
    }

    this.calcRatioBaseWidth = screenProperty.height > 0 ? screenProperty.height : screenProperty.width / DEFAULT_RATIO;
    if (this.calcRatioBaseWidth === 0) {
      return;
    }

    let screenWidth = Math.min(screenProperty.width, screenProperty.height);
    if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      screenWidth = Math.min(ULTRA_SCREEN_M_MAIN_WIDTH, screenWidth);
    }

    let widthScale = parseFloat((screenWidth / this.calcRatioBaseWidth).toFixed(DEFAULT_RATIO_POINT));
    this.miniWidthRatio = FloatingSceneCommonStyle.MINI_WIDTH_RATIO * widthScale;
    let defaultRatio = (screenWidth - FloatingSceneExpandStyle.MINI_SCENE_RIGHT_MARGIN * DEFAULT_RATIO -
      FloatingSceneExpandStyle.GUTTER) / DEFAULT_RATIO / screenWidth;
    this.defaultWidthRatio = defaultRatio * widthScale;
    this.setMaxWidthRatio(FloatingSceneExpandStyle.LANDSCAPE_MAX_WIDTH_RATIO * widthScale,
      'calcExpandLandscapeWidthRatio');
    this.maxFullScreenRatio = FloatingSceneExpandStyle.LANDSCAPE_MAX_FULLSCREEN_WIDTH_RATIO * widthScale;
  }

  /**
   * init phone or foldState portrait float param:
   * use screen width as calcRatioBaseWidth
   *
   * @param screenProperty the screenProperty
   */
  private initPortraitFloatParam(screenProperty: SCBScreenProperty) : void {
    this.calcRatioBaseWidth = Math.min(screenProperty.width, screenProperty.height);

    if (this.calcRatioBaseWidth === 0) {
      return;
    }

    this.calcPortraitWidthRatio();
  }

  /**
   * calculate phone or foldState portrait width ratio:
   *
   * @param screenProperty the screenProperty
   */
  public calcPortraitWidthRatio(): void {
    this.defaultWidthRatio = FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
    this.setMaxWidthRatio(this.uiType === SCBConstants.UITYPE_PAD ?
      FloatingScenePadLayoutStyle.MAX_WIDTH_RATIO * this.anchorByPortraitStyle() :
      FloatingScenePortraitStyle.MAX_WIDTH_RATIO, 'calcPortraitWidthRatio');
    this.maxFullScreenRatio = this.uiType === SCBConstants.UITYPE_PAD ?
      FloatingScenePadLayoutStyle.MAX_FULL_SCREEN_RATIO * this.anchorByPortraitStyle() :
      FloatingScenePortraitStyle.MAX_FULL_SCREEN_RATIO;
  }

  /**
   * init phone or foldState landscape float param:
   * use screen height as calcRatioBaseWidth
   * landscapeFloat: 16/9
   *
   * @param screenProperty the screenProperty
   */
  private initLandscapeFloatParam(screenProperty: SCBScreenProperty) : void {
    if (this.isUseShortSide) {
      this.calcRatioBaseWidth = Math.min(screenProperty.width, screenProperty.height);
    } else {
      this.calcRatioBaseWidth = Math.max(screenProperty.width, screenProperty.height);
    }
    if (this.calcRatioBaseWidth === 0) {
      return;
    }
    this.calcLandscapeWidthRatio(screenProperty);
  }

  /**
   * calculate phone or foldState landscape width ratio:
   *
   * @param screenProperty the screenProperty
   */
  public calcLandscapeWidthRatio(screenProperty: SCBScreenProperty): void {
    if (this.isUseShortSide) {
      this.defaultWidthRatio = FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
      this.maxWidthRatio = FloatingScenePortraitStyle.MAX_WIDTH_RATIO;
      this.miniSceneRightMargin = FloatingScenePortraitStyle.MINI_SCENE_RIGHT_MARGIN;
      this.aspectRatio = this.getAspectRatio(screenProperty);

      this.maxFullScreenRatio = this.maxWidthRatio * (FloatingScenePortraitStyle.MAX_FULL_SCREEN_RATIO /
      FloatingScenePortraitStyle.MAX_WIDTH_RATIO);
      return;
    }
    let widthScale = parseFloat((Math.min(screenProperty.width, screenProperty.height) /
    this.calcRatioBaseWidth).toFixed(DEFAULT_RATIO_POINT));

    this.miniWidthRatio = FloatingSceneCommonStyle.LANDSCAPE_MINI_WIDTH_RATIO * widthScale;
    this.defaultWidthRatio = FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO * widthScale;
    this.setMaxWidthRatio(FloatingScenePortraitStyle.MAX_LANDSCAPE_WIDTH_RATIO * widthScale, 'calcLandscapeWidthRatio');
    this.maxFullScreenRatio = FloatingScenePortraitStyle.MAX_LANDSCAPE_FULL_SCREEN_RATIO * widthScale;
  }

  /**
   * calculate phone or foldState landscape corner radius:
   *
   * @param screenProperty the screen property
   * @param defaultRadius default radius
   * @param isVertical isVertical
   * @returns
   */
  public calcLandscapeRadius(screenProperty: SCBScreenProperty, defaultRadius: number, isVertical: boolean) : number {
    if (!this.isLandscapeFloat) {
      return defaultRadius;
    }

    if (isVertical) {
      return this.defaultWidthRatio > 0 ? defaultRadius / this.defaultWidthRatio : defaultRadius;
    }

    if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      return this.cornerRadius / this.defaultWidthRatio;
    }

    let screenWidth = Math.min(screenProperty.width, screenProperty.height);
    let widthScale = parseFloat((screenWidth / this.calcRatioBaseWidth).toFixed(DEFAULT_RATIO_POINT));
    let defaultRatio = FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO * widthScale;
    return defaultRatio > 0 ? defaultRadius / defaultRatio :
      defaultRadius / FloatingSceneCommonStyle.LANDSCAPE_MINI_WIDTH_RATIO;
  }

  /**
   * initCacheForMini
   */
  public initCacheForMini(): void {
    this.cacheRectForMini = new RectItem(0, 0, 0, 0);
    this.cacheScaleForMini = 0;
  }

  /**
   * getRotationOnExpandStatus
   *
   * @param screenProperty
   * @returns rotation
   */
  public getRotationOnExpandStatus(screenProperty: SCBScreenProperty): number {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (!screenSession) {
      return RotationConstants.ROTATION_0;
    }
    return screenSession.scbScreenProperty.rotation;
  }

  /**
   * Method of Setting Whether to Disable the Floating Scenario
   *
   * @param { Boolean } isClosed
   */
  public setBorderColor(color: string): void {
    this.borderColor = color;
  }

  /**
   * Method of Setting Whether to needDestruction the Floating Scenario
   *
   * @param { Boolean } isClosed
   * @param { Boolean } isTerminated
   */
  public setFloatingSceneClosed(isClosed: boolean): void {
    this.isClosed = isClosed;
    if (!isClosed) {
      this.isTerminated = isClosed;
    }
  }

  /**
   * Check whether the floating scenario is disabled.
   *
   * @returns { Boolean } Returns a boolean
   */
  public isFloatingSceneClosed(): boolean {
    return this.isClosed || this.isTerminated;
  }

  /**
   * Set User Action
   *
   * @param { UserAction } action
   */
  public setUserAction(action: UserAction): void {
    this.userAction = action;
  }

  /**
   * Method for obtaining user action
   *
   * @returns { UserAction } Return the user Action object.
   */
  public getUserAction(): UserAction {
    return this.userAction;
  }

  public registerTransformCallback(callback: (id?: SCBGestureActionId) => void): void {
    this.transformCallbackList.push(callback);
  }

  public unregisterTransformCallback(callback: (id?: SCBGestureActionId) => void): void {
    let index = this.transformCallbackList.indexOf(callback);
    if (index !== -1) {
      this.transformCallbackList.splice(index, 1);
    }
  }

  public notifyTransform(id?: SCBGestureActionId): void {
    for (let callback of this.transformCallbackList) {
      callback?.(id);
    }
  }

  /**
   * IS Float Edge Drag
   *
   * @param { Boolean } isClosed
   */
  public setFloatEdgeDrag(isFloatEdgeDrag: boolean): void {
    this.isFloatEdgeDrag = isFloatEdgeDrag;
  }
}

/**
 * Put in Corner area
 */
export enum CornerArea {
  NONE,
  MAIN,
  SECONDARY
}

/**
 * Enumeration type, which is used to define the type of the floating window.
 */
export enum FloatingType {
  MINI,
  NORMAL,
}

/**
 * Exports the CornerParam class, which is used to define corner parameters.
 */
export class CornerParam {
  public area: CornerArea = CornerArea.NONE;
  public anotherSceneRectVp: RectItem = new RectItem(0, 0, 0, 0);
}

/**
 * Floating Scene Common Style Class
 */
export class FloatingSceneCommonStyle {
  static readonly MINI_WIDTH_RATIO: number = 0.3;
  static readonly MINI_AVOID_RATIO: number = 0.315;
  static readonly MINI_HEIGHT_RATIO: number = 0.5;
  static readonly TITLEBAR_INSCENE: boolean = false;
  static readonly TITLEBAR_HEIGHT: number = 32;
  static readonly TITLE_BAR_BTN_HEIGHT: number = 32;
  static readonly TITLE_BAR_BTN_WIDTH: number = 96;
  static readonly CORNER_RADIUS: number = 24;
  static readonly MENU_WIDTH: number = 222;
  static readonly MENU_HEIGHT: number = 74;
  static readonly MENU_DOWN_OFFSET: number = 13;
  static readonly MARGIN_PIXEL: number = 24;
  static readonly DRAG_HOT_WIDTH_OUTER: number = 16;
  static readonly DRAG_HOT_WIDTH_INNER: number = 8;
  static readonly MINI_SAFE_MARGIN: object = { top: 64, right: 32 };
  static readonly BORDER_WIDTH: number = 2;
  static readonly MINI_SCENE_TOP_MARGIN: number = 12;
  static readonly LANDSCAPE_MINI_WIDTH_RATIO: number = 0.55;
  static readonly LANDSCAPE_HORIZONTAL_WIDTH_RATIO: number = 0.6;
  static readonly DARK_BORDER_COLOR = '#33FFFFFF';
  static readonly DARK_BORDER_WIDTH: number = 1;
  static readonly DARK_BLUR_STAND_IN_COLOR = '#ff999999';
}

export class FloatingSceneOneStepStyle {
  static readonly WIDTH_RATIO: number = 0.3;
  static readonly MIN_WIDTH: number = 3;
  static readonly MIN_HEIGHT: number = 4.575;
  static readonly ASPECT_RATIO: number = FloatingSceneOneStepStyle.MIN_WIDTH / FloatingSceneOneStepStyle.MIN_HEIGHT;
  static readonly LANDSCAPE_WIDTH_RATIO: number = 0.55;
}

export class FloatingScenePadLayoutStyle {
  static readonly MAX_HEIGHT_RATIO_PORTRAIT: number = 0.7;
  static readonly DEFAULT_HEIGHT_RATIO: number = 0.8;
  static readonly DEFAULT_PC_HEIGHT_RATIO: number = 1;
  static readonly MAX_WIDTH_RATIO: number = 0.9;
  static readonly MAX_FULL_SCREEN_RATIO: number = 0.95;
  static readonly MIN_WIDTH: number = 9;
  static readonly MIN_HEIGHT: number = 16;
  static readonly ASPECT_RATIO: number = FloatingScenePadLayoutStyle.MIN_WIDTH / FloatingScenePadLayoutStyle.MIN_HEIGHT;
  static readonly MINI_SCENE_RIGHT_MARGIN: number = 24;
  static readonly LANDSCAPE_MAX_WIDTH_RATIO: number = 0.8;
  static readonly LANDSCAPE_DEFAULT_HEIGHT_RATIO: number = 0.6;
  static readonly LANDSCAPE_MIN_WIDTH: number = 16;
  static readonly LANDSCAPE_MIN_HEIGHT: number = 9;
  static readonly LANDSCAPE_ASPECT_RATIO: number = FloatingScenePadLayoutStyle.LANDSCAPE_MIN_WIDTH /
                      FloatingScenePadLayoutStyle.LANDSCAPE_MIN_HEIGHT;
  static readonly MINI_WIDTH_RATIO: number = 0.3;
}

export class FloatingScenePortraitStyle {
  static readonly DEFAULT_WIDTH_RATIO: number = 0.79;
  static readonly ORIGINAL_MAX_WIDTH_RATIO: number = 0.85;
  static readonly ORIGINAL_MIN_WIDTH_RATIO: number = 0.3;
  static readonly MAX_WIDTH_RATIO: number = 0.8;
  static readonly MAX_FULL_SCREEN_RATIO: number = 0.85;
  static readonly MAX_LANDSCAPE_WIDTH_RATIO: number = 0.85;
  static readonly MAX_LANDSCAPE_FULL_SCREEN_RATIO: number = 0.90;
  static readonly MAX_PC_WIDTH_RATIO: number = 1;
  static readonly MIN_WIDTH: number = 3;
  static readonly MIN_HEIGHT: number = 4.575;
  static readonly LANDSCAPE_ASPECT_RATIO: number = 16 / 9;
  /**
   * w/h ratio
   */
  static readonly ASPECT_RATIO: number = FloatingScenePortraitStyle.MIN_WIDTH / FloatingScenePortraitStyle.MIN_HEIGHT;

  /**
   * Floating scene calcRatioBaseWidth
   */
  static readonly CALC_RATIO_BASE_WIDTH: number = 0;
  static readonly MINI_SCENE_RIGHT_MARGIN: number = 24;
}

export class FloatingSceneExpandStyle {
  static readonly DEFAULT_WIDTH_RATIO: number = 0.45;
  static readonly LANDSCAPE_DEFAULT_WIDTH_RATIO: number = 0.45;
  static readonly MAX_WIDTH_RATIO: number = 0.5;
  static readonly LANDSCAPE_MAX_WIDTH_RATIO: number = 0.9;
  static readonly LANDSCAPE_MAX_FULLSCREEN_WIDTH_RATIO: number = 0.95;
  static readonly MIN_WIDTH: number = 9;
  static readonly MIN_HEIGHT: number = 16;
  static readonly ASPECT_RATIO: number = FloatingSceneExpandStyle.MIN_WIDTH / FloatingSceneExpandStyle.MIN_HEIGHT;
  static readonly LANDSCAPE_ASPECT_RATIO: number = 16 / 9;
  static readonly CALC_RATIO_BASE_WIDTH: number = 0;
  static readonly MINI_SCENE_RIGHT_MARGIN: number = 24;
  static readonly GUTTER: number = 12;
  static readonly defaultRightMargin: number = 24;
}

export class FloatSceneSizeData {
  // 悬浮窗窗口显示的size大小
  private static realDataMap: Map<FloatSizeState, FloatingRectCache> = new Map();
  // 默认比例下悬浮窗实际显示的窗口rect
  private static defaultDataMap: Map<FloatSizeState, FloatingRectCache> = new Map();

  /**
   * @param floatState 尺寸状态
   * @param screenWidth 当前屏幕的宽度px.
   * @param screenHeight 当前屏幕的高度px.
   *
   * 获取当前屏幕状态悬浮窗窗口显示的size大小.
   */
  static getRealFloatRect(floatState: FloatSizeState, screenWidth: number, screenHeight: number): RectItem {
    let shortEdgeLength = Math.min(screenWidth, screenHeight);
    let longEdgeLength = Math.max(screenWidth, screenHeight);
    switch (floatState) {
      // 旋转横竖屏悬浮窗size无变化  展开态悬浮窗size
      case FloatSizeState.EXPAND_PORTRAIT:
      case FloatSizeState.EXPAND_LANDSCAPE:
        if (!this.isNoNeedCalcSize(this.realDataMap, floatState, shortEdgeLength, longEdgeLength)) {
          // 大屏幕机 悬浮窗窗口size宽度 = 折叠态屏幕宽度
          let calcRatioBaseWidth;
          let mainScreenProperty = SCBScreenSessionManager.getInstance().getPhyScreenProperty(MAIN_SCREEN_ID);
          if (DeviceHelper.isUltraScreenProduct()) {
            calcRatioBaseWidth = ULTRA_SCREEN_F_MAIN_WIDTH;
          } else {
            calcRatioBaseWidth = mainScreenProperty.width > 0 ? mainScreenProperty.width : shortEdgeLength * ONE_HALF;
          }
          let aspectRatio = FloatingSceneExpandStyle.ASPECT_RATIO;
          // 默认比例 = 展开态屏幕宽度 * defaultWithRatio / 实际窗口宽度.
          let defaultRatio = shortEdgeLength * FloatingSceneExpandStyle.DEFAULT_WIDTH_RATIO / calcRatioBaseWidth;
          // 大屏幕机 悬浮窗窗口size高度 = 折叠态屏幕宽度 / 宽高显示比 + title栏高度 / 默认比例.
          let floatHeight =
            calcRatioBaseWidth / aspectRatio + vp2px(FloatingSceneCommonStyle.TITLEBAR_HEIGHT) / defaultRatio;
          let floatRectItem = new RectItem(0, 0, calcRatioBaseWidth, floatHeight);
          let floatingParamCache = this.constructFloatData(floatRectItem, shortEdgeLength, longEdgeLength);
          this.realDataMap.set(FloatSizeState.EXPAND_PORTRAIT, floatingParamCache);
          this.realDataMap.set(FloatSizeState.EXPAND_LANDSCAPE, floatingParamCache);
        }
        return this.realDataMap.get(floatState);
      case FloatSizeState.PORTRAIT_PAD:
      case FloatSizeState.LANDSCAPE_PAD:
        if (!this.isNoNeedCalcSize(this.realDataMap, floatState, shortEdgeLength, longEdgeLength)) {
          let aspectRatio = FloatingScenePadLayoutStyle.ASPECT_RATIO;
          // pad窗口size 高度 = 屏幕宽度 - 2倍顶部栏, 宽度 = 高 * 宽高比
          let floatHeight = shortEdgeLength - vp2px(FloatingSceneCommonStyle.TITLEBAR_HEIGHT) * 2;
          let floatWidth = floatHeight * aspectRatio;
          let floatRectItem = new RectItem(0, 0, floatWidth, floatHeight);
          let floatingParamCache = this.constructFloatData(floatRectItem, floatWidth, longEdgeLength);
          this.realDataMap.set(FloatSizeState.PORTRAIT_PAD, floatingParamCache);
          this.realDataMap.set(FloatSizeState.LANDSCAPE_PAD, floatingParamCache);
        }
        return this.realDataMap.get(floatState);
      case FloatSizeState.LANDSCAPE:
      case FloatSizeState.PORTRAIT:
      default:
        if (!this.isNoNeedCalcSize(this.realDataMap, floatState, shortEdgeLength, longEdgeLength)) {
          let normalAspectRatio = FloatingScenePortraitStyle.ASPECT_RATIO;
          let aspectRatio = this.getLimitRatio(normalAspectRatio, screenWidth, screenHeight);
          // 悬浮窗窗口size 宽度 = 屏幕宽度,高度 =  折叠态屏幕宽度 / 宽高显示比 + title栏高度 / 默认比例.
          let floatHeight = shortEdgeLength / aspectRatio +
            vp2px(FloatingSceneCommonStyle.TITLEBAR_HEIGHT) / FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
          let floatRectItem = new RectItem(0, 0, shortEdgeLength, floatHeight);
          let floatingParamCache = this.constructFloatData(floatRectItem, shortEdgeLength, longEdgeLength);
          this.realDataMap.set(FloatSizeState.LANDSCAPE, floatingParamCache);
          this.realDataMap.set(FloatSizeState.PORTRAIT, floatingParamCache);
        }
        return this.realDataMap.get(floatState);
    }
  }

  private static constructFloatData(floatRectItem: RectItem, shortEdgeLength: number,
    longEdgeLength: number): FloatingRectCache {
    let floatingParamCache: FloatingRectCache = new FloatingRectCache(0, 0, 0, 0);
    floatingParamCache.setRect(floatRectItem);
    floatingParamCache.screenWidth = shortEdgeLength;
    floatingParamCache.screenHeight = longEdgeLength;
    return floatingParamCache;
  }

  private static isNoNeedCalcSize(dataMap: Map<FloatSizeState, FloatingRectCache>, screenState: FloatSizeState,
                        screenWidth: number, screenHeight: number): boolean {
    return dataMap.has(screenState) && dataMap.get(screenState)?.screenWidth === screenWidth &&
      dataMap.get(screenState)?.screenHeight === screenHeight;
  }

  /**
   * @param floatState 屏幕状态
   * @param screenWidth 当前屏幕的宽度px.
   * @param screenHeight 当前屏幕的高度px.
   *
   * 获取当前屏幕状态默认比例悬浮窗窗口显示的size大小.
   */
  static getDefaultRect(floatState: FloatSizeState, screenWidth: number, screenHeight: number): RectItem {
    let realFloatRect = this.getRealFloatRect(floatState, screenWidth, screenHeight);
    let shortEdgeLength = Math.min(screenWidth, screenHeight);
    let longEdgeLength = Math.max(screenWidth, screenHeight);
    switch (floatState) {
      case FloatSizeState.EXPAND_PORTRAIT:
      case FloatSizeState.EXPAND_LANDSCAPE:
        if (!this.isNoNeedCalcSize(this.defaultDataMap, floatState, shortEdgeLength, longEdgeLength)) {
          if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
            shortEdgeLength = Math.min(ULTRA_SCREEN_M_MAIN_WIDTH, shortEdgeLength);
          }
          // 大屏幕机默认比例 = 当前屏幕宽 * 默认显示比例的屏幕宽度比 / 悬浮窗口size宽度
          let defaultRatio = shortEdgeLength * FloatingSceneExpandStyle.DEFAULT_WIDTH_RATIO / realFloatRect.width();
          // 默认比例实际大小 = 真实大小 * 默认比例
          let floatWidth = realFloatRect.width() * defaultRatio;
          let floatHeight = realFloatRect.height() * defaultRatio;
          let left = screenWidth - vp2px(FloatingSceneExpandStyle.MINI_SCENE_RIGHT_MARGIN) - floatWidth;
          let top = (screenHeight - floatHeight) * ONE_HALF;
          let floatRectItem = new RectItem(left, top, left + floatWidth, top + floatHeight);
          let floatingParamCache = this.constructFloatData(floatRectItem, shortEdgeLength, longEdgeLength);
          floatingParamCache.scale = defaultRatio;
          this.defaultDataMap.set(floatState, floatingParamCache);
        }
        return this.defaultDataMap.get(floatState);
      case FloatSizeState.PORTRAIT_PAD:
      case FloatSizeState.LANDSCAPE_PAD:
        if (!this.isNoNeedCalcSize(this.defaultDataMap, floatState, shortEdgeLength, longEdgeLength)) {
          // pad窗口默认比例0.8
          let defaultRatio = FloatingScenePadLayoutStyle.DEFAULT_HEIGHT_RATIO;
          let floatWidth = realFloatRect.width() * defaultRatio;
          let floatHeight = realFloatRect.height() * defaultRatio;
          let left = screenWidth - floatWidth - vp2px(FloatingScenePadLayoutStyle.MINI_SCENE_RIGHT_MARGIN);
          let top = (screenHeight - floatHeight) * ONE_HALF;
          let floatRectItem = new RectItem(left, top, left + floatWidth, top + floatHeight);
          let floatingParamCache = this.constructFloatData(floatRectItem, shortEdgeLength, longEdgeLength);
          floatingParamCache.scale = defaultRatio;
          this.defaultDataMap.set(floatState, floatingParamCache);
        }
        return this.defaultDataMap.get(floatState);
      case FloatSizeState.LANDSCAPE:
        if (!this.isNoNeedCalcSize(this.defaultDataMap, floatState, shortEdgeLength, longEdgeLength)) {
          let floatHeight = shortEdgeLength - 2 * vp2px(PHONE_STATUS_BAR_HEIGHT);
          let defaultRatio = floatHeight / realFloatRect.height();
          let floatWidth = realFloatRect.width() * defaultRatio;
          let left = longEdgeLength - vp2px(FloatingScenePortraitStyle.MINI_SCENE_RIGHT_MARGIN) - floatWidth;
          let top = (shortEdgeLength - floatHeight) * ONE_HALF;
          let floatRectItem = new RectItem(left, top, left + floatWidth, top + floatHeight);
          let floatingParamCache = this.constructFloatData(floatRectItem, shortEdgeLength, longEdgeLength);
          floatingParamCache.scale = defaultRatio;
          this.defaultDataMap.set(FloatSizeState.LANDSCAPE, floatingParamCache);
        }
        return this.defaultDataMap.get(FloatSizeState.LANDSCAPE);
      case FloatSizeState.PORTRAIT:
      default:
        if (!this.isNoNeedCalcSize(this.defaultDataMap, floatState, shortEdgeLength, longEdgeLength)) {
          let defaultWidthRatio = FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
          let floatWidth = realFloatRect.width() * defaultWidthRatio;
          let floatHeight = realFloatRect.height() * defaultWidthRatio;
          let left = (shortEdgeLength - floatWidth) * ONE_HALF;
          let top = (longEdgeLength - floatHeight) * ONE_HALF;
          let floatRectItem = new RectItem(left, top, left + floatWidth, top + floatHeight);
          let floatingParamCache = this.constructFloatData(floatRectItem, shortEdgeLength, longEdgeLength);
          floatingParamCache.scale = defaultWidthRatio;
          this.defaultDataMap.set(FloatSizeState.PORTRAIT, floatingParamCache);
        }
        return this.defaultDataMap.get(FloatSizeState.PORTRAIT);
    }
  }

  static getLimitRatio(normalAspectRatio: number, screenWidth: number, screenHeight: number): number {
    let physicsScreenWidth = Math.min(screenWidth, screenHeight);
    let physicsScreenHeight = Math.max(screenWidth, screenHeight);
    let titleBarRealHeight =
      vp2px(FloatingSceneCommonStyle.TITLEBAR_HEIGHT) / FloatingScenePortraitStyle.DEFAULT_WIDTH_RATIO;
    let normalRatioHeight = physicsScreenWidth / normalAspectRatio + titleBarRealHeight;
    if (normalRatioHeight > physicsScreenHeight) {
      return physicsScreenWidth / (physicsScreenHeight - titleBarRealHeight);
    } else {
      return normalAspectRatio;
    }
  }

  /**
   * @param screenProperty 当前屏幕属性
   *
   * 通过当前屏幕属性获取悬浮窗窗口size大小.
   */
  static getRealRectByScreenProperty(screenProperty: SCBScreenProperty): RectItem {
    if (isLargeFoldProductInExpand()) {
      let state =
        this.isVertical(screenProperty.rotation) ? FloatSizeState.EXPAND_PORTRAIT : FloatSizeState.EXPAND_LANDSCAPE;
      return FloatSceneSizeData.getDefaultRect(state, screenProperty.width, screenProperty.height);
    }
    let state = this.isVertical(screenProperty.rotation) ? FloatSizeState.PORTRAIT : FloatSizeState.LANDSCAPE;
    return FloatSceneSizeData.getDefaultRect(state, screenProperty.width, screenProperty.height);
  }

  /**
   * @param screenProperty 当前屏幕属性
   *
   * 通过当前屏幕属性获取默认比例悬浮窗窗口size大小.
   */
  static getDefaultRectByScreenProperty(screenProperty: SCBScreenProperty): RectItem {
    if (isLargeFoldProductInExpand()) {
      let state =
        this.isVertical(screenProperty.rotation) ? FloatSizeState.EXPAND_PORTRAIT : FloatSizeState.EXPAND_LANDSCAPE;
      return FloatSceneSizeData.getDefaultRect(state, screenProperty.width, screenProperty.height);
    }
    let state = this.isVertical(screenProperty.rotation) ? FloatSizeState.PORTRAIT : FloatSizeState.LANDSCAPE;
    return FloatSceneSizeData.getDefaultRect(state, screenProperty.width, screenProperty.height);
  }

  /**
   * Check if current is vertical or not by rotation
   *
   * @param rotation rotation with 0/90/180/270/360
   * @returns true if current is vertical or not
   */
  static isVertical(rotation: number): boolean {
    // should return 90 270 in horizontal
    return rotation === RotationConstants.ROTATION_0 || rotation === RotationConstants.ROTATION_180 ||
      rotation === RotationConstants.ROTATION_360;
  }
}

export enum FloatSizeState {
  /**
   * 折叠态竖屏，直板机竖屏的位置尺寸state.
   */
  PORTRAIT,
  /**
   * 折叠态横屏，直板机横屏的位置尺寸state.
   */
  LANDSCAPE,
  /**
   * PAD竖屏的位置尺寸state.
   */
  PORTRAIT_PAD,
  /**
   * PAD横屏的位置尺寸state.
   */
  LANDSCAPE_PAD,
  /**
   * 大屏幕机展开态，竖屏位置尺寸state.
   */
  EXPAND_PORTRAIT,
  /**
   * 大屏幕机展开态，横屏位置尺寸state.
   */
  EXPAND_LANDSCAPE,
}

export enum FloatSceneStartAnimation {
  NORMAL,
  RECT_T0_FLOAT,
  NONE
}

export enum UserAction {
  NONE,
  QUICK_MIN,
  MENU_MIN,
  QUICK_CLOSE,
  MENU_CLOSE
}

/**
 * cache floating scene params when transfer to recent
 */
export class RecentParams {
  positionX: ScbNumber = new ScbNumber(0);
  positionY: ScbNumber = new ScbNumber(0);
  scaleX: ScbNumber = new ScbNumber(0);
  scaleY: ScbNumber = new ScbNumber(0);
  clipWidth: ScbNumber = new ScbNumber(0);
  clipHeight: ScbNumber = new ScbNumber(0);
  width: ScbNumber = new ScbNumber(0);
  height: ScbNumber = new ScbNumber(0);
  floatBorderWidth: number = 0;
  floatScale: number = 0;
  floatBorderRadius: number = 0;
  floatShadowColor: Resource | string = SHADOW_INIT_COLOR;
  isFloatingSessionClosed: boolean = false;
  isValid: boolean = true;
  readonly RECENT_FILL_COLOR: string = '#FFFFFF';
  readonly RECENT_FILL_OPACITY: number = 0.4;

  constructor() {
    this.positionX = new ScbNumber(0);
    this.positionY = new ScbNumber(0);
    this.width = new ScbNumber(0);
    this.height = new ScbNumber(0);
    this.floatBorderWidth = 0;
    this.floatScale = 0;
    this.floatBorderRadius = 0;
    this.floatShadowColor = SHADOW_INIT_COLOR;
  }

  public copyFrom(container: SCBSceneContainerSession): void {
    if (CommonUtils.isInvalid(container)) {
      return;
    }
    this.positionX = new ScbNumber(vp2px(container.needRenderPos.posX));
    this.positionY = new ScbNumber(vp2px(container.needRenderPos.posY));
    this.width = container.width.copy();
    this.height = container.height.copy();
    this.clipWidth = container.needRenderClip.clipWidth.copy();
    this.clipHeight = container.needRenderClip.clipHeight.copy();
    this.floatBorderRadius = container.needRenderBorderRadius.getDefaultBorderRadius();
    this.floatBorderWidth = container.floatingParam.borderWidth;
    this.floatScale = container.floatingParam.scale;
    this.floatShadowColor = container.primarySession?.isFocused ? FOCUSED_SHADOW_COLOR : UNFOCUSED_SHADOW_COLOR;
    this.isFloatingSessionClosed = container.floatingParam.isFloatingSceneClosed();
  }

  public copyTo(container: SCBSceneContainerSession): void {
    if (CommonUtils.isInvalid(container)) {
      return;
    }
    container.updateRectForFloat(
      new SCBSessionRect(this.positionX.getPx(), this.positionY.getPx(), this.width.getPx(), this.height.getPx()));
    container.updateScaleForFloat(this.floatScale);
    container.needRenderBorderRadius.setBorderRadiusWithDfx(this.floatBorderRadius, TAG, 'copyTo');
    container.floatingParam.borderWidth = this.floatBorderWidth;
    container.floatingParam.setFloatingSceneClosed(this.isFloatingSessionClosed);
    this.isValid = false;
  }

  /**
   * Copy location information from cache
   *
   * @param { RectItem } rect
   */
  public copyCachedPosition(rect: RectItem): void {
    if (rect) {
      this.positionX.setNumber(vp2px(rect.left));
      this.positionY.setNumber(vp2px(rect.top));
    }
  }
}

// floating animate params to/from recent
export class RecentFloatingAnimParams {
  public persistentId: number = 0;
  public positionX: number = 0;
  public positionY: number = 0;
  public scale: number = 1;
  public width: number = 0;

  constructor(persistentId: number, positionX: number, positionY: number, width: number) {
    this.persistentId = persistentId;
    this.positionX = positionX;
    this.positionY = positionY;
    this.width = width;
  }

  /**
   * Get the X coordinate of an object
   *
   * @returns { number } Returns the X coordinate of the object
   */
  public getPositionX(): number {
    return this.positionX;
  }

  /**
   * Gets the Y coordinate of the current object.
   *
   * @returns { Number } Returns the Y coordinate of the current object
   */
  public getPositionY(): number {
    return this.positionY;
  }

  /**
   * How to get the width
   *
   * @returns { Number } Returns the width value
   */
  public getWidth(): number {
    return this.width;
  }

  /**
   * Obtains the persistence ID.
   *
   * @returns { Number } Persistence ID
   */
  public getPersistentId(): number {
    return this.persistentId;
  }
}

export enum RecordType {
  QUICK_MIN,
  MENU_MIN,
  QUICK_CLOSE,
  MENU_CLOSE,
  ENTER_RECENT,
  AVOID_CACHE,
  DRAG_SCALE,
  FOLD_M_STATE,
  FOLD_G_STATE,
  DRAG_FOLD_EXPAND
}