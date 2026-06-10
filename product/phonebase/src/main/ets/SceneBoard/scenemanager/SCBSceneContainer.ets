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

import {
  CloseAppManager,
  StyleConstants,
  CustomBadgeManager,
  StartAndExitVisualEffectManager,
} from '@ohos/launchercommon';
import { CompanionIcon } from '@ohos/launchercommon/Index';
import { OverlayCardComponent } from '@ohos/systemuicommon/Index';
import { ScenePanelState } from './SCBScenePanel';
import { SCBScene } from './SCBScene'
import { SCBSpecificScene } from './SCBSpecificScene'
import { SCBKeyboardPanel } from '../keyboard/SCBKeyboardPanel';
import { RecentTitleView } from '../recent/RecentTitleView';
import { RecentEventView } from '../recent/RecentEventView';
import { RecentRotationUtil } from '../recent/common/RecentRotationUtil';
import AppStartBadge from '@ohos/pagedesktop/src/main/ets/default/common/components/AppStartBadge';
import sceneSessionManager from '@ohos.sceneSessionManager'
import {
  SCBSceneContainerSession,
  SCBDividerParam,
  SceneParam,
  SCBFloatingParam,
  SCBSceneSession,
  ScbNumber,
  SCBSessionRect,
  SCBPropertyChangeReason,
  NeedRenderTranslate,
  NeedRenderAlpha,
  NeedRenderBlurRadius,
  NeedRenderBorderRadius,
  NeedRenderPos,
  NeedRenderLockIconOpacity,
  NeedRenderLockIconScale,
  NeedRenderLockIconTranslate,
  NeedRenderTitleViewScale,
  NeedRenderScale,
  NeedRenderVisibility,
  NeedRenderShowInRecent,
  NeedRenderShowRecentTitle,
  NeedRenderZIndex,
  NeedRenderMotionBlur,
  NeedRenderRotate,
  NeedRenderClip,
  NeedPreBuild,
  PreBuildStage,
  SCBSpecificSession,
  SCBSpecificSceneSessionList,
  SCBScreenProperty,
  KeyboardState,
  SCBGestureAction,
  SCBContainerRotationReason,
  SCBSceneContainerState,
  SCBScreenSessionManager,
  SCBScreenSession,
  SCBSceneMode,
  RecentsStyleConstants,
  FloatingSceneCommonStyle,
  SCBKeyboardManager,
  SCBKeyboardSession,
  SCBKeyboardPanelSession,
  ResUtils,
  SCBSplitParam,
  SCBAppIconParam,
  scbEventExclusiveManager,
  EventType,
  FSMCallbackArgsType,
  SCBSceneSessionManager,
  SCBScenePanelManager,
  SCBTransitionManager,
  SCBGestureActionId,
  SCBRotateChangeReason
} from '@ohos/windowscene';
import {
  NeedRenderTranslateIcon,
  NeedRenderSwiperTranslate,
  SCBDividerParamArray,
  SingleStartFrom
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { sOutSideWindowMgr, SCBWindowSceneConfig, GlobalContext, DeviceHelper } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, StartType, Log, CommonUtils } from '@ohos/basicutils';
import { desktopUtil, ItemUtils, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { SCBConstants, RotationConstants, VisualEffectConstants, } from '@ohos/commonconstants';
import { OverlayCardInfo, OverlayCardState } from '@ohos/systemuicommon';
import { ConfigurationConstant } from '@kit.AbilityKit';
import power from '@ohos.power';
import thermal from '@ohos.thermal';
import { SCBSceneContainerViewModel } from './viewmodel/SCBSceneContainerViewModel';
import { RecentStateManager } from '../recent/innerstate/RecentStates';
import { RecentForegroundBlurAniMgr } from '../recent/scenepanel/recentpanel/RecentForegroundBlurAniMgr';
import { RecentDelete } from '../recent/scenepanel/recentpanel/RecentDelete';
import { SCBRotateUtils } from './utils/SCBRotateUtils';
import { SCBDivider } from './SCBDivider';
import { SCBScalingScene } from './SCBScalingScene';

const TAG = 'SCBSceneContainer';
const homeLog: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const RECENT_TAG = 'RecentContainer';
const SCENE_ROTATE_PERSPECTIVE: number = -60;
const BLEND_MODE_SRC_OVER: number = 4;
const BLEND_MODE_SRC_IN: number = 6;
const winLog: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const recentLog = LogHelper.getLogHelper(LogDomain.RECENT, RECENT_TAG);
const FOCUSED_SHADOW_RADIUS: number = ResUtils.getNumber($r('app.float.floating_scene_focused_shadow_radius'));
const FOCUSED_SHADOW_OFFSET_X: number = ResUtils.getNumber($r('app.float.floating_scene_focused_shadow_offset_x'));
const FOCUSED_SHADOW_OFFSET_Y: number = ResUtils.getNumber($r('app.float.floating_scene_focused_shadow_offset_y'));
const FOCUSED_SHADOW_COLOR: Resource = $r('app.color.floating_scene_focused_shadow_color');
const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

export const ACTIVE_STATUS_MAP: Map<sceneSessionManager.SessionState, boolean> = new Map([
  [sceneSessionManager.SessionState.STATE_CONNECT, false],
  [sceneSessionManager.SessionState.STATE_FOREGROUND, true],
  [sceneSessionManager.SessionState.STATE_ACTIVE, true],
  [sceneSessionManager.SessionState.STATE_INACTIVE, false],
  [sceneSessionManager.SessionState.STATE_BACKGROUND, false],
  [sceneSessionManager.SessionState.STATE_DISCONNECT, false],
]);

interface SCBSceneBuilderParam {
  sceneSession: SCBSceneSession;
}

interface SCBSpecificSceneBuilderParam {
  specificSceneSessionList: SCBSpecificSceneSessionList;
}

interface SCBSceneSessionStylesParam {
  sceneParam: SceneParam;
}

@Extend(Stack)
function sceneSessionStyles($$: SCBSceneSessionStylesParam) {
  .position({ x: 0, y: 0 })
  .scale({
    x: $$.sceneParam.sessionScaleX,
    y: $$.sceneParam.sessionScaleY,
    centerX: $$.sceneParam.sessionScaleCenterX,
    centerY: $$.sceneParam.sessionScaleCenterY,
  })
  .direction(Direction.Ltr)
  .opacity($$.sceneParam.sessionOpacity)
  .freeze($$.sceneParam.sceneInnerFreeze)
  .blendMode(
    ($$.sceneParam.blendMode ? BLEND_MODE_SRC_IN : BlendMode.NORMAL),
    ($$.sceneParam.blendMode ? BlendApplyType.OFFSCREEN : BlendApplyType.FAST)
  );
}
@Extend(Stack)
function linearOpacityStyles($$: SCBSceneSessionStylesParam) {
  .blendMode(
    ($$.sceneParam.blendMode ? BLEND_MODE_SRC_OVER : BlendMode.NORMAL),
    ($$.sceneParam.blendMode ? BlendApplyType.OFFSCREEN : BlendApplyType.FAST)
  )
}

@Extend(Stack)
function sceneRectStyles($$: SCBSceneSessionStylesParam) {
  .position({
    x: $$.sceneParam.posX,
    y: $$.sceneParam.posY
  })
  .width($$.sceneParam.width)
  .height($$.sceneParam.height)
  .translate({
    x: $$.sceneParam.translateX + $$.sceneParam.touchTranslateX,
    y: $$.sceneParam.translateY + $$.sceneParam.touchTranslateY,
  })
  .constraintSize($$.sceneParam.isSplitExchange? $$.sceneParam.maxDividerWidth : $$.sceneParam.minDividerWidth)
}

@Extend(Stack)
function sceneStyles($$: SCBSceneSessionStylesParam, blurScale: number, isMidSupport?: boolean) {
  .rotate({
    x: $$.sceneParam.rotateX,
    y: $$.sceneParam.rotateY,
    z: $$.sceneParam.rotateZ,
    angle: $$.sceneParam.rotateAngle,
    centerX: $$.sceneParam.rotateCenterX,
    centerY: $$.sceneParam.rotateCenterY,
    perspective: isMidSupport ? 0 : SCENE_ROTATE_PERSPECTIVE
  })
  .border(SCBRotateUtils.getSceneContainerBorderOptions1())
  .scale({
    x: $$.sceneParam.scaleX,
    centerX: $$.sceneParam.scaleCenterX,
    y: $$.sceneParam.scaleY,
    centerY: $$.sceneParam.scaleCenterY,
  })
  .opacity($$.sceneParam.opacity)
  .borderRadius($$.sceneParam.borderRadius)
  .foregroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, {
    scale: blurScale,
  }, { disableSystemAdaptation: true })
  .shadow($$.sceneParam.shadowOptions)
  .zIndex($$.sceneParam.zIndex)
  .freeze($$.sceneParam.sceneFreeze)
  .direction(Direction.Ltr)
  .foregroundEffect({ radius: $$.sceneParam.blurRadius })
}

@Component
export struct SCBSceneContainer {
  private containerViewModel: SCBSceneContainerViewModel = new SCBSceneContainerViewModel();

  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @ObjectLink needRenderTranslate: NeedRenderTranslate;
  @ObjectLink needRenderSwiperTranslate: NeedRenderSwiperTranslate;
  @ObjectLink needRenderTranslateIcon: NeedRenderTranslateIcon;
  @ObjectLink needRenderScale: NeedRenderScale;
  @ObjectLink needRenderPos: NeedRenderPos;
  @ObjectLink needRenderVisibility: NeedRenderVisibility;
  @ObjectLink needRenderAlpha: NeedRenderAlpha;
  @ObjectLink needRenderBlurRadius: NeedRenderBlurRadius;
  @ObjectLink needRenderBorderRadius: NeedRenderBorderRadius;
  @ObjectLink needRenderMotionBlur: NeedRenderMotionBlur;
  @ObjectLink needPreBuild: NeedPreBuild;
  @ObjectLink @Watch('updatePreBuildStage') needRenderShowInRecent: NeedRenderShowInRecent;
  @ObjectLink dividerParam: SCBDividerParam;
  @ObjectLink splitParam: SCBSplitParam;
  @ObjectLink dividerParamList: SCBDividerParamArray;
  @ObjectLink primarySceneParam: SceneParam;
  @ObjectLink secondarySceneParam: SceneParam;
  @ObjectLink needRenderShowRecentTitle: NeedRenderShowRecentTitle;
  @ObjectLink needRenderZIndex: NeedRenderZIndex;
  @ObjectLink needRenderRotate: NeedRenderRotate;
  @ObjectLink needRenderClip: NeedRenderClip;
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @ObjectLink floatingParam: SCBFloatingParam;
  @ObjectLink needRenderLockIconOpacity: NeedRenderLockIconOpacity;
  @ObjectLink needRenderLockIconScale: NeedRenderLockIconScale;
  @ObjectLink needRenderLockIconTranslate: NeedRenderLockIconTranslate;
  @ObjectLink needRenderTitleViewScale: NeedRenderTitleViewScale;
  @Link isScrolling: boolean;
  @Link screenProperty: SCBScreenProperty;
  @Link scenePanelState: ScenePanelState;
  @Link isShowCompanionIcon: boolean;
  @Link isIconWithBadge: boolean;
  @Link keyboardState: KeyboardState;
  @State primAppIconParam: SCBAppIconParam = new SCBAppIconParam(() => this.sceneContainerSession.primarySession);
  @State secAppIconParam: SCBAppIconParam = new SCBAppIconParam(() => this.sceneContainerSession.secondarySession);
  @State needBlockCover: boolean = false;
  @State needMiniCover: boolean = false;
  @State needDragScale: boolean = false;
  @State needCompatibleBlur: boolean = false;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext()?.config?.colorMode as number;
  @State midSceneNum: number = 1;
  @State priSubList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  @State priDialogList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  @State recentInnerState: RecentStateManager = RecentStateManager.getInstance();
  private lastShowState: boolean = false;
  private enableShow: boolean = false;
  private onGestureChange?: (scbAction: SCBGestureAction) => void | Function;
  private innerGestureHandler = (action: SCBGestureAction) => {
    if (this.onGestureChange) {
      this.onGestureChange(action)
    }
  }
  private name: string = '';

  private panelMgr = SCBScenePanelManager.getInstance(this.screenProperty);

  private containerStateChangeCallback = (previousState: SCBSceneContainerState,
      curState: SCBSceneContainerState) => {
    this.notifyKeyboardAboveFloatOrNot(previousState, curState);
    this.floatingParam.notifyTransform();
    if (curState === SCBSceneContainerState.FULL_SCREEN) {
      if (previousState === SCBSceneContainerState.SPLIT) {
        SCBSceneSessionManager.getInstance().notifyFullScreenMenuVisible(false);
      }
    }
  }

  private notifyKeyboardAboveFloatOrNot(previousState: SCBSceneContainerState, curState: SCBSceneContainerState): void {
    if (curState === SCBSceneContainerState.MINI_FLOAT) {
      return;
    }
    if (curState === SCBSceneContainerState.RECENT) {
      return;
    }
    // split to float, fullscreen raise inputmethod and return to screen
    if (curState === SCBSceneContainerState.HIDDEN && previousState === SCBSceneContainerState.FULL_SCREEN) {
      return;
    }
    // close float and start from dock
    if (previousState === curState && previousState !== SCBSceneContainerState.FLOAT) {
      return;
    }
    SCBKeyboardManager.getInstance().notifyKeyboardAboveFloatContainerStateChange();
  }

  private isVertical(rotation: number): boolean {
    // should return 90/ 270 in pc and pad
    if (uiType === SCBConstants.UITYPE_PAD) {
      return this.sceneContainerSession.isVertical(rotation);
    } else {
      let res = rotation % RotationConstants.ROTATION_360;
      return res === RotationConstants.ROTATION_0 || res === RotationConstants.ROTATION_180;
    }
  }

  private isFullScene(currRect: SCBSessionRect, screenProperty: SCBScreenProperty): boolean {
    let screenRect = new SCBSessionRect(screenProperty.left, screenProperty.top,
      screenProperty.width, screenProperty.height);
    if (currRect.equals(screenRect)) {
      return true;
    }
    return false;
  }

  private fullSubSessionRotationChange(screenProperty: SCBScreenProperty,
                                sizeReason: sceneSessionManager.SessionSizeChangeReason,
                                sessionList: SCBSpecificSceneSessionList | undefined, isFloat: boolean = false): void {
      sessionList?.forEach((item: SCBSpecificSession) => {
        let newRect: SCBSessionRect = new SCBSessionRect(item.currRect.left.getPx(), item.currRect.top.getPx(),
          item.currRect.height.getPx(), item.currRect.width.getPx());
        let isOldRectFull: boolean = !isFloat && this.isFullScene(item.currRect, screenProperty);
        let isNewRectFull: boolean = !isFloat && this.isFullScene(newRect, screenProperty);
        homeLog.showInfo('id: ' + item.session?.persistentId + ' currRect: ' + item.currRect.printPx() +
          ' newRect: ' + newRect.printPx() + ' isOldRectFull: ' + isOldRectFull +
          ' isNewRectFull: ' + isNewRectFull);
        if (isOldRectFull || isNewRectFull) {
          item.updateRect(newRect.top, newRect.left,
            newRect.width, newRect.height, sizeReason);
        }
      });
  }

  private onContainerRotationChange(lastRotation: number, screenProperty: SCBScreenProperty,
                                    reason: SCBContainerRotationReason): void {
    let isVertical: boolean = this.isVertical(screenProperty.rotation);
    // update SceneSession rotation
    if (this.sceneContainerSession.primarySession) {
      this.sceneContainerSession.primarySession.sessionData.currentRotation = screenProperty.rotation;
    }
    if (this.sceneContainerSession.secondarySession) {
      this.sceneContainerSession.secondarySession.sessionData.currentRotation = screenProperty.rotation;
    }
    if (this.sceneContainerSession.isSplit && this.dividerParam.getIsVertical() !== isVertical) {
      homeLog.showInfo(`divider vertical change, previous: ${this.dividerParam.getIsVertical()}, now: ${isVertical}`);
      this.dividerParam.setIsVertical(isVertical);
      this.dividerParam.updateDividerParam(screenProperty);
    }
    let sizeReason: sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
    if (reason === SCBContainerRotationReason.SCREEN_ROTATION || reason === SCBContainerRotationReason.PANEL_ROTATION) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.ROTATION;
    }
    // need fix posX, posY as float scene
    homeLog.showInfo(`onContainerRotationChange, reason: ${sizeReason}, ` +
      `lastRotation: ${lastRotation}, curr: ${screenProperty.rotation}`)
    if (isVertical !== this.isVertical(lastRotation)) {
      // need add subsession rect change
      this.fullSubSessionRotationChange(screenProperty, sizeReason,
        this.sceneContainerSession.primarySession?.subSessionList, this.sceneContainerSession.isFloat);
      this.fullSubSessionRotationChange(screenProperty, sizeReason,
        this.sceneContainerSession.secondarySession?.subSessionList, this.sceneContainerSession.isFloat);
      this.fullSubSessionRotationChange(screenProperty, sizeReason,
        this.sceneContainerSession.primarySession?.dialogSessionList, this.sceneContainerSession.isFloat);
      this.fullSubSessionRotationChange(screenProperty, sizeReason,
        this.sceneContainerSession.secondarySession?.dialogSessionList, this.sceneContainerSession.isFloat);
    }
    this.checkContainerStateIfNeed();
  }

  private onContainerFoldChangeForUltraScreen() {
    this.needCompatibleBlur = false;
    homeLog.showInfo(`needCompatibleBlur: ${this.needCompatibleBlur},`)
  }

  private onContainerFoldChange(oldScreenProperty: SCBScreenProperty, screenProperty: SCBScreenProperty,
                                reason: SCBPropertyChangeReason) {
    this.sceneContainerSession.updateFullScreenSpecificSessionRect(oldScreenProperty, screenProperty, reason);
    this.checkContainerStateIfNeed();
    if (reason === SCBPropertyChangeReason.EXPAND_TO_FOLD &&
      this.sceneContainerSession.primarySession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      SCBSceneSessionManager.getInstance().notifyHotRegionStateChange();
    }
  }

  private onContainerActiveModeChangeInner: Function = (item: SCBSpecificSession, widthRatio: number,
                                                        heightRatio: number) => {
    let left = item.currRect.left.getPx() * widthRatio;
    let top = item.currRect.top.getPx() * heightRatio;
    let width = item.currRect.width.getPx() * widthRatio;
    let height = item.currRect.height.getPx() * heightRatio;
    item.currRect.setRectNum(left, top, width, height);
  }

  private onContainerActiveModeChange(oldScreenProperty: SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    homeLog.showInfo('onContainerActiveModeChange curr: ' + newScreenProperty.rotation)
    let widthRatio = newScreenProperty.width / oldScreenProperty.width;
    let heightRatio = newScreenProperty.height / oldScreenProperty.height;
    let priSubList: SCBSpecificSceneSessionList | undefined = this.sceneContainerSession.
      primarySession?.subSessionList;
    let secSubList: SCBSpecificSceneSessionList | undefined = this.sceneContainerSession.
      secondarySession?.subSessionList;
    let priDialogList: SCBSpecificSceneSessionList | undefined = this.sceneContainerSession.
      primarySession?.dialogSessionList;
    let secDialogList: SCBSpecificSceneSessionList | undefined = this.sceneContainerSession.
      secondarySession?.dialogSessionList;
    priSubList?.forEach((item: SCBSpecificSession) => {
      this.onContainerActiveModeChangeInner(item, widthRatio, heightRatio);
    });
    secSubList?.forEach((item: SCBSpecificSession) => {
      this.onContainerActiveModeChangeInner(item, widthRatio, heightRatio);
    });
    priDialogList?.forEach((item) => {
      this.onContainerActiveModeChangeInner(item, widthRatio, heightRatio);
    });
    secDialogList?.forEach((item) => {
      this.onContainerActiveModeChangeInner(item, widthRatio, heightRatio);
    });
  }

  aboutToAppear() {
    homeLog.showDebug("aboutToAppear containerId: " + this.sceneContainerSession?.containerId +
      ' bundleName1: ' + this.sceneContainerSession?.primarySession?.sceneInfo.bundleName + ' bundleName2: ' +
      this.sceneContainerSession?.secondarySession?.sceneInfo.bundleName + 'showInRecent: ' +
      this.sceneContainerSession.needRenderShowInRecent.showInRecent);
    this.containerViewModel.init();

    this.sceneContainerSession.addRefCount();
    if (this.sceneContainerSession.primarySession) {
      this.priSubList = this.sceneContainerSession.primarySession.subSessionList;
    }
    if (this.sceneContainerSession.primarySession) {
      this.priDialogList = this.sceneContainerSession.primarySession.dialogSessionList;
    }
    this.registerCallback();
    this.checkContainerStateIfNeed();
    scbEventExclusiveManager.registerEventExclusive(EventType.SPLIT_GESTURE, () => {
      scbEventExclusiveManager.setEventExclusive(EventType.SPLIT_GESTURE, false);
    });
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.screenRotateChangeCallback);
  }

  private registerCallback(): void {
    this.sceneContainerSession.registerContainerRotationChangeCallback(
      (lastRotation: number, screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason) => {
        this.onContainerRotationChange(lastRotation, screenProperty, reason);
      });

    this.sceneContainerSession.registerContainerActiveModeChangeCallback(
      (oldScreenProperty: SCBScreenProperty, newScreenProperty: SCBScreenProperty) => {
        this.onContainerActiveModeChange(oldScreenProperty, newScreenProperty);
      });

    this.sceneContainerSession.registerContainerFoldChangeCallback(
      (oldScreenProperty: SCBScreenProperty, screenProperty : SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        this.onContainerFoldChange(oldScreenProperty, screenProperty, reason);
      });
    this.sceneContainerSession.registerInteractiveStateChangeCallback(state => {
      let dividerList = this.sceneContainerSession.getDividerParamList();
      for (let dividerParam of dividerList) {
        dividerParam.notifyInteractiveStateChange(state);
      }
    });
    this.sceneContainerSession.registerContainerStateChangeCallback(this.containerStateChangeCallback);
    this.sceneContainerSession.registerContainerFoldChangeForUltraScreenCallback(
      () => {
        this.onContainerFoldChangeForUltraScreen();
      });
  }

  aboutToDisappear(): void {
    homeLog.showDebug('aboutToDisappear containerId: ' + this.sceneContainerSession?.containerId +
      ' bundleName1: ' + this.sceneContainerSession?.primarySession?.sceneInfo.bundleName +
      ' bundleName2: ' + this.sceneContainerSession?.secondarySession?.sceneInfo.bundleName)
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.screenRotateChangeCallback);
    SCBKeyboardManager.getInstance().unRegisterAnimationSyncCallback(this.sceneContainerSession.containerId.toString());
    this.sceneContainerSession.unregisterContainerStateChangeCallback(this.containerStateChangeCallback);
    this.sceneContainerSession.unregisterInteractiveStateChangeCallback();
    this.sceneContainerSession.decRefCount();
    this.sceneContainerSession.unRegisterAll();
    scbEventExclusiveManager.unRegisterEventExclusive(EventType.SPLIT_GESTURE);

    this.containerViewModel.release();
  }

  private screenRotateChangeCallback = (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void => {
    if (!(this.sceneContainerSession.isSplit || this.sceneContainerSession.isFloat) || !this.sceneContainerSession.enableShow()) {
      return;
    }
    if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
      homeLog.showDebug('split scene, ROTATE_BEGIN');
      animateTo({
        curve: Curve.Sharp,
        duration: 200
      }, () => {
        this.sceneContainerSession.dividerParam.primary.blurScale = 0.85;
        this.sceneContainerSession.dividerParam.secondary.blurScale = 0.85;
      })
    }
    if (reason === SCBRotateChangeReason.ROTATE_END) {
      homeLog.showDebug('split scene, ROTATE_END');
      animateTo({
        curve: Curve.Sharp,
        duration: 200,
        delay: 200
      }, () => {
        this.sceneContainerSession.dividerParam.primary.blurScale = 0;
        this.sceneContainerSession.dividerParam.secondary.blurScale = 0;
      })
    }
  }

  private checkContainerStateIfNeed() {
    let state = this.sceneContainerSession.getState();
    switch (state) {
      case SCBSceneContainerState.FLOAT:
        this.containerStateChangeCallback(SCBSceneContainerState.UNDEFINED, state);
        break;
      case SCBSceneContainerState.ONE_STEP:
        break;
      case SCBSceneContainerState.MINI_FLOAT:
        break;
    }
  }

  private isScreenRotateLandscapeStart(screenSession: SCBScreenSession): boolean {
    return (screenSession.isRotateScreenPolicy() && this.screenProperty.rotation !== 0);
  }

  private getPositionInRecent(): Position {
    let offset: Position = {
      x: this.needRenderPos.posX,
      y: this.needRenderPos.posY
    }
    let screenRotation: number = this.screenProperty.rotation;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      recentLog.showError('getRotateOptionsInRecent screenSession is null');
      return offset;
    }
    if (this.isScreenRotateLandscapeStart(screenSession)) {
      return offset;
    }
    if (screenSession.isRotateScreenPolicy()) {
      if (this.sceneContainerSession.currentRotation !== screenSession.scbScreenProperty.rotation &&
        this.sceneContainerSession.isOneStepSplit()) {
        screenRotation = this.sceneContainerSession.currentRotation;
      } else {
        screenRotation = screenSession.scbScreenProperty.rotation;
      }
    }
    if (screenRotation === -RotationConstants.ROTATION_90) {
      screenRotation = RotationConstants.ROTATION_270;
    } else if (screenRotation === RotationConstants.ROTATION_360) {
      screenRotation = 0;
    }
    if (screenRotation - this.sceneContainerSession.currentRotation === 0) {
      return offset;
    }

    // current screen property
    let screenH = px2vp(this.screenProperty.height);
    let screenW = px2vp(this.screenProperty.width);
    if (this.isVertical(this.sceneContainerSession.currentRotation) !== this.isVertical(screenRotation)) {
      if (this.isVertical(screenRotation)) {
        offset.x = -(screenH - screenW) / 2 + this.needRenderPos.posX;
        offset.y = (screenH - screenW) / 2 + this.needRenderPos.posY;
      } else {
        offset.x = (screenW - screenH) / 2 + this.needRenderPos.posX;
        offset.y = -(screenW - screenH) / 2 + this.needRenderPos.posY;
      }
    }
    return offset;
  }

  private getRotateOptionsInRecent(): RotateOptions {
    if (this.splitParam.isPreSplit && this.dividerParam.isNeedContainerRotate) {
      return {
        x: this.dividerParam.containerRotateX,
        y: this.dividerParam.containerRotateY,
        z: this.dividerParam.containerRotateZ,
        centerX: this.dividerParam.containerRotateCenterX,
        centerY: this.dividerParam.containerRotateCenterY,
        perspective: 51,
        angle: -this.dividerParam.containerRotateAngle
      }
    }

    let option: RotateOptions = {
      x: 0,
      y: 0,
      z: 1,
      angle: 0,
      centerX: '50%',
      centerY: '50%'
    };
    let screenRotation: number = this.screenProperty.rotation;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      recentLog.showError('getRotateOptionsInRecent screenSession is null');
      return option;
    }
    if (this.isScreenRotateLandscapeStart(screenSession)) {
      return option;
    }
    if (screenSession.isRotateScreenPolicy()) {
      if (this.sceneContainerSession.currentRotation !== screenSession.scbScreenProperty.rotation &&
        this.sceneContainerSession.isOneStepSplit()) {
        homeLog.showDebug('getRotateOptionsInRecent: screenRotation change from ' + screenRotation + ' to ' +
          this.sceneContainerSession.currentRotation + ' reason: isOneStepSplit');
        screenRotation = this.sceneContainerSession.currentRotation;
      } else {
        homeLog.showDebug('getRotateOptionsInRecent: screenRotation change from ' + screenRotation + ' to ' + screenSession.scbScreenProperty.rotation);
        screenRotation = screenSession.scbScreenProperty.rotation;
      }
    }
    if ((screenRotation - this.sceneContainerSession.currentRotation) % RotationConstants.ROTATION_180 === 0) {
      return option;
    }
      const tempRotation: number = screenRotation - this.sceneContainerSession.currentRotation;
      if (Math.abs(tempRotation) < RotationConstants.ROTATION_180) {
        option.angle = tempRotation;
      } else {
        option.angle = (tempRotation + RotationConstants.ROTATION_360) % RotationConstants.ROTATION_360;
      }
    homeLog.showDebug('getRotateOptionsInRecent: The option angle is ' + option.angle);

    return option;
  }

  private getPanGestureRotate(): RotateOptions {
    let screenRotation: number = RecentRotationUtil.getScreenRotation(this.screenProperty);
    let centerZFactor = this.isVertical(screenRotation) ? 0.5 : 0.1;
    if (RecentRotationUtil.isSameRotation(screenRotation, this.sceneContainerSession.currentRotation)) {
      let rotateAngle = this.needRenderRotate.angle;
      let centerX = '98%';
      homeLog.showDebug('getPanGestureRotate: The RotateOption angle is ' + rotateAngle);
      return {
        x: this.needRenderRotate.rotateX,
        centerX: this.needRenderRotate.centerX,
        centerY: centerX,
        centerZ: -this.needRenderClip.clipHeight.getVp() * centerZFactor,
        perspective: 51,
        angle: rotateAngle,
      };
    } else {
      let rotateAngle = -this.needRenderRotate.angle;
      let centerX = '98%';
      let centerY = this.needRenderRotate.centerX;
      if ((screenRotation - this.sceneContainerSession.currentRotation + RotationConstants.ROTATION_360) %
        RotationConstants.ROTATION_360 === RotationConstants.ROTATION_270) {
        rotateAngle = this.needRenderRotate.angle;
        centerX = '2%';
      }
      homeLog.showDebug('getPanGestureRotate: The RotateOption angle is ' + rotateAngle);
      return {
        y: this.needRenderRotate.rotateX,
        centerY: centerY,
        centerX: centerX,
        centerZ: -this.needRenderClip.clipWidth.getVp() * centerZFactor,
        perspective: 51,
        angle: rotateAngle,
      };
    }
  }

  private getScaleInRecent(rotateValue: number): number {
    return 1 - 0.5 * (1 - Math.cos(rotateValue * Math.PI / 180));
  }

  private getScaleRatio(rotateValue: number): number {
    let scale = 1;
    if (this.sceneContainerSession.isFloat && this.floatingParam.needFloatScale) {
      scale = this.floatingParam.scale;
    } else if (this.scenePanelState === ScenePanelState.RECENT || this.sceneContainerSession.pendingRemove) {
      scale = this.getScaleInRecent(rotateValue);
    }
    return scale;
  }

  private getContainerComponentTranslate(): TranslateOptions {
    if (this.sceneContainerSession.isFloat && this.sceneContainerSession.isActive &&
      (!this.sceneContainerSession.floatingParam.floatRecentAnimateFinished ||
      this.sceneContainerSession.floatingParam.floatInRecentFinished)) {
      // 前台悬浮窗在多任务中保持缩放中心(0,0)带来的额外偏移量
      let translateXForScale = this.needRenderClip.clipWidth.getVp() * ((1 - this.needRenderScale.scaleX) / 2 +
        0.5 * (1 - Math.cos(this.needRenderRotate.angle * Math.PI / 180)) * this.needRenderScale.scaleX / 2);
      let translateYForScale = this.needRenderClip.clipHeight.getVp() * (1 - this.needRenderScale.scaleY) / 2;
      return {
        x: this.needRenderSwiperTranslate.translateX +
          translateXForScale,
        y: this.needRenderSwiperTranslate.translateY +
          translateYForScale
      }
    } else {
      let removeFloatingTranslate: number = 0;
      if (this.sceneContainerSession.isFloat) {
        removeFloatingTranslate = this.needRenderClip.clipWidth.getVp() * (
          0.5 * (1 - Math.cos(this.needRenderRotate.angle * Math.PI / 180)) * this.needRenderScale.scaleX / 2)
      }
      return {
        x: this.needRenderSwiperTranslate.translateX + this.floatingParam.needRenderTranslate.translateX +
          removeFloatingTranslate,
        y: this.needRenderSwiperTranslate.translateY + this.floatingParam.needRenderTranslate.translateY
      }
    }
  }

  private getAlphaInRecent(angle: number): number {
    if (!RecentForegroundBlurAniMgr.getInstance().isForegroundEffectSupport() &&
    RecentDelete.isAppLocked(this.sceneContainerSession)) {
      homeLog.showWarn(`app locked.`);
      return 1;
    }
    if (angle > RecentsStyleConstants.MIN_DEL_ANI_ANGLE) {
      return 1;
    }
    if (angle <= RecentsStyleConstants.MAX_DEL_ANI_ANGLE) {
      return 0;
    }
    return (angle - RecentsStyleConstants.MAX_DEL_ANI_ANGLE) /
      (RecentsStyleConstants.MIN_DEL_ANI_ANGLE - RecentsStyleConstants.MAX_DEL_ANI_ANGLE);
  }

  private isPanGestureTranslateChange(screenRotation: number, sessionRotation: number): boolean {
    return screenRotation - sessionRotation === -90 || (screenRotation === 270 && sessionRotation === 0);
  }

  private getPanGestureTranslate(): TranslateOptions {
    let screenRotation: number = RecentRotationUtil.getScreenRotation(this.screenProperty);
    if (RecentRotationUtil.isSameRotation(screenRotation, this.sceneContainerSession.currentRotation)) {
      let translateY = this.getTranslateY(this.needRenderRotate.angle, this.sceneContainerSession.height.getVp());
      let translateX = this.getTranslateX(this.needRenderRotate.angle, this.sceneContainerSession.width.getVp());
      return {
        y: translateY,
        x: translateX
      };
    } else {
      let translateY = this.getTranslateY(this.needRenderRotate.angle, this.sceneContainerSession.width.getVp());
      let translateX = this.getTranslateX(this.needRenderRotate.angle, this.sceneContainerSession.height.getVp());
      if (this.isPanGestureTranslateChange(screenRotation, this.sceneContainerSession.currentRotation)) {
        translateY = -translateY;
      }
      return {
        y: translateX,
        x: translateY
      };
    }
  }

  private getTranslateY(angle: number, height: number): number {
    if (this.scenePanelState === ScenePanelState.RECENT || this.sceneContainerSession.pendingRemove) {
      let result = Math.sin(angle * Math.PI / 180) * 0.57 * height;
      return result;
    }
    return 0;
  }

  private getTranslateXInRecent(angle: number, width: number): number {
    if (typeof this.needRenderRotate.centerX === 'string') {
      return 0;
    }
    return 2.5 * (this.needRenderRotate.centerX === px2vp(this.screenProperty.width) / 2 ? 0 :
      (this.needRenderRotate.centerX > 0 ? 1 : -1) * (1 - this.getScaleInRecent(angle)) *
        width * this.needRenderScale.scaleX);
  }

  private getTranslateX(angle: number, width: number): number {
    if (this.scenePanelState === ScenePanelState.RECENT || this.sceneContainerSession.pendingRemove) {
      return this.getTranslateXInRecent(angle, width);
    }
    return 0;
  }

  private getScreenPxSize(): SizeOptions {
    return {
      width: ItemUtils.num2PxStr(this.scenePanelState === ScenePanelState.RECENT ?
      this.panelMgr.getViewParam().recentW : this.screenProperty?.width),
      height: ItemUtils.num2PxStr(this.scenePanelState === ScenePanelState.RECENT ?
      this.panelMgr.getViewParam().recentH : this.screenProperty?.height)
    };
  }

  private updatePreBuildStage() {
    if (this.needPreBuild == undefined) {
      return;
    }
    if (this.needRenderShowInRecent.showInRecent) {
      this.needPreBuild.setPreBuildStageWithDfx(PreBuildStage.PRE_BUILD_DONE);
    } else {
      this.needPreBuild.setPreBuildStageWithDfx(PreBuildStage.NOT_PRE_BUILD);
    }
  }

  private enableShowByPreBuild(stage: PreBuildStage): boolean {
    const isPrebuildStageEnableShow: boolean = this.needPreBuild != undefined && this.needPreBuild.preBuildStage >= stage;
    const enableShow: boolean = isPrebuildStageEnableShow || this.needRenderShowInRecent.showInRecent ||
      this.sceneContainerSession.enableShow() || this.showInScrolling();
    if (this.enableShow !== enableShow) {
      homeLog.showWarn(`[SCBMain] ${this.sceneContainerSession.getName()} enableShow change from ${this.enableShow} to ${enableShow}. Detail:` +
        `isPrebuildStageEnableShow:${isPrebuildStageEnableShow}, ` +
        `showInRecent:${this.needRenderShowInRecent.showInRecent}, ` +
        `sceneContainerSession.enableShow:${this.sceneContainerSession.enableShow()}, ` +
        `showInScrolling:${this.showInScrolling()}`);
      this.enableShow = enableShow;
    }
    return enableShow;
  }

  private showInScrolling(): boolean {
    return this.isScrolling && this.lastShowState;
  }

  /**
   * overlay组件的层级
   *
   * @returns 层级
   */
  private getOverlayZIndex(): number {
    let overlayCardInfo = this.sceneContainerSession.overlayCardTransition?.overlayCardInfo as OverlayCardInfo;
    return overlayCardInfo?.overlayComponentZIndex ?? 0;
  }

  private getContainerSize(): SizeOptions {
    if (this.sceneContainerSession.isFloat) {
      return {
        width: StyleConstants.PERCENTAGE_100,
        height: StyleConstants.PERCENTAGE_100
      };
    }
    return { // width, height should use container self, since screen rotation may change global screen property
      width: this.sceneContainerSession.width.getPxSizeStr(),
      height: this.sceneContainerSession.height.getPxSizeStr()
    };
  }

  private getTranslateIcon(): TranslateOptions {
    if (this.sceneContainerSession.getState() === SCBSceneContainerState.SPLIT || (this.sceneContainerSession.isFloat
      && SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0)) {
      return {x: 0, y: 0};
    }
    return {
      x: this.needRenderTranslateIcon.translateIconX,
      y: this.needRenderTranslateIcon.translateIconY
    };
  }

  /**
   * 获取切割圆角
   *
   * @returns 圆角
   */
  private getBorderRadius(): BorderRadiuses {
    return {
      topLeft: this.needRenderBorderRadius.topLeft,
      topRight: this.needRenderBorderRadius.topRight,
      bottomLeft: this.needRenderBorderRadius.bottomLeft,
      bottomRight: this.needRenderBorderRadius.bottomRight
    };
  }

  private getBadgeNumber(): number {
    let bundleName: string = this.sceneContainerSession.primarySession?.sceneInfo.bundleName as string;
    let appIndex: number = this.sceneContainerSession.primarySession?.sceneInfo.appIndex ?? 0;
    return CustomBadgeManager.getInstance().getAppBadgeValue({
      bundleName: bundleName,
      appIndex: appIndex
    });
  }

  private getBorderColor(): string {
    if (!this.floatingParam.isFloatEdgeDrag &&
      this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      return FloatingSceneCommonStyle.DARK_BORDER_COLOR;
    }
    return this.floatingParam.borderColor;
  }

  private getOuterBorderWidth(): number {
    let borderWidth = FloatingSceneCommonStyle.BORDER_WIDTH;
    if (!this.floatingParam.isFloatEdgeDrag &&
      this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      borderWidth = FloatingSceneCommonStyle.DARK_BORDER_WIDTH;
    }
    return vp2px(borderWidth / this.floatingParam.defaultWidthRatio);
  }

  /**
   * 动效场景加载桌面图标或通知卡片等替代组价
   */
  @Builder
  transitionIconOrCard() {
    // 通知、胶囊卡片启动动效场景，overlay卡片组件
    if (this.shouldShowOverlayComponent()) {
      OverlayCardComponent({
        overlayCardInfo: this.sceneContainerSession.overlayCardTransition?.overlayCardInfo as OverlayCardInfo,
        overlayCardState: this.sceneContainerSession.overlayCardTransition?.overlayCardState as OverlayCardState
      })
        .zIndex(this.getOverlayZIndex())
        .size({
          width: '100%',
          height: '100%'
        })
        .position({ x: 0, y: 0 })
    } else if (this.sceneContainerSession?.companionIconInfo?.isSameLocation) {
      CompanionIcon({
        screenProperty: this.screenProperty,
        sceneContainerSession: this.sceneContainerSession,
        nonAdaptiveIconRadius: this.needRenderBorderRadius,
      })
        .position({ x: 0, y: 0 })
    } else if (this.isShowCompanionIcon) {
      CompanionIcon({
        screenProperty: this.screenProperty,
        sceneContainerSession: this.sceneContainerSession,
        nonAdaptiveIconRadius: this.needRenderBorderRadius,
      })
        .position({ x: 0, y: 0 })
    }
  }

  /**
   * 是否需要overlay组件
   */
  private shouldShowOverlayComponent(): boolean {
    if (this.sceneContainerSession.overlayCardTransition == null) {
      return false;
    }

    const cardInfo = this.sceneContainerSession.overlayCardTransition.overlayCardInfo as OverlayCardInfo;
    if (cardInfo) {
      return cardInfo.isShowOverlayComponent;
    } else {
      homeLog.showWarn('ShouldShowOverlayComponent. cardInfo is undefined.');
      return true;
    }
  }

  @Builder
  appStartBadgeBuilder() {
    if (this.isIconWithBadge) {
      AppStartBadge({
        screenHeight: this.screenProperty.height,
        screenWidth: this.screenProperty.width,
        bundleName: this.sceneContainerSession.primarySession?.sceneInfo.bundleName as string,
        appIndex: this.sceneContainerSession.primarySession?.sceneInfo.appIndex ?? 0,
        badgeAlpha: this.sceneContainerSession.badgeAlpha,
        badgeVisibility: this.sceneContainerSession.badgeVisibility,
      })
    }
  }

  @Builder
  splitBorderBuilder(primary: boolean) {
    if (this.isNeedShowSplitBorder()) {
      Stack()
        .width(StyleConstants.PERCENTAGE_100)
        .height(StyleConstants.PERCENTAGE_100)
        .hitTestBehavior(HitTestMode.None)
        .border({
          width: `${vp2px(1)}px`,
          radius: primary ? this.primarySceneParam.borderRadius : this.secondarySceneParam.borderRadius,
          color: '#33FFFFFF',
        })
        .pixelRound({
          start: PixelRoundCalcPolicy.FORCE_FLOOR,
          top: PixelRoundCalcPolicy.FORCE_FLOOR,
          end: PixelRoundCalcPolicy.FORCE_CEIL,
          bottom: PixelRoundCalcPolicy.FORCE_CEIL,
        });
    }
  }

  @Builder
  sceneBgBuilder() {
    Stack() {
      Stack()
        .draggable(false)
        .width(StyleConstants.PERCENTAGE_100)
        .height(StyleConstants.PERCENTAGE_100)
        .backgroundColor(SCBConstants.COMPATIBILITYMODE_SCENE_BG_COLOR)
    }
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
  }

  @Builder
  sceneBuilder($$: SCBSceneBuilderParam) {
    SCBScene({
      sceneSession: $$.sceneSession,
      screenProperty: this.screenProperty,
      sceneContainerSession: this.sceneContainerSession,
      keyboardSession: this.keyboardSession,
      keyboardPanelSession: this.keyboardPanelSession,
      keyboardState: this.keyboardState,
      name: this.name,
      subSessionList: $$.sceneSession.subSessionList,
      dialogSessionList: $$.sceneSession.dialogSessionList,
      dividerParam: this.dividerParam,
      needShowTitleBar: this.sceneContainerSession.splitParam.needShowTitleBar,
      scenePanelState: $scenePanelState,
      onGestureChange: this.innerGestureHandler,
      floatingParam: this.floatingParam,
      needRenderScale: this.sceneContainerSession.needRenderScale,
      isKeyboardEnableShow: this.sceneContainerSession.isKeyboardEnableShow,
      pcAppPositionX: this.sceneContainerSession.pcLeft,
      pcAppPositionY: this.sceneContainerSession.pcTop,
    })
      .onAppear(() => {
        this.lastShowState = (this.sceneContainerSession.enableShow() || this.needRenderShowInRecent.showInRecent) && this.isScrolling;
      })
      .onDisAppear(() => {
        this.lastShowState = false;
      })
  }

  @Builder
  specificSceneBuilder($$: SCBSpecificSceneBuilderParam) {
    ForEach($$.specificSceneSessionList, (item: SCBSpecificSession) => {
      SCBSpecificScene({
        specificSession: item,
        screenProperty: $screenProperty,
        subSessionList: item.subSessionList,
        rect: item.currRect,
        parentRect: this.sceneContainerSession.primarySession?.currRect,
      })
    }, (item: SCBSpecificSession) => item.session.persistentId.toString())
  }

  @Builder
  effectComponentBuilder(primary: boolean) {
    if (this.enableShowEffectComponent()) {
      EffectComponent() {
        Stack()
          .width('100%')
          .height('100%')
          .borderRadius(primary ? this.primarySceneParam.borderRadius : this.secondarySceneParam.borderRadius)
          .opacity(this.floatingParam.effectCompOpacity)
          .useEffect(true)
      }
      .width('100%')
      .height('100%')
      .backgroundEffect({ radius: primary ? this.primarySceneParam.effectRatio : this.secondarySceneParam.effectRatio },
        { disableSystemAdaptation: true })
      .backgroundBlurStyle(BlurStyle.Thick, {
        colorMode: ThemeColorMode.LIGHT,
        adaptiveColor: AdaptiveColor.DEFAULT,
        scale: primary ? this.primarySceneParam.blurScale : this.secondarySceneParam.blurScale
      }, { disableSystemAdaptation: true })
      .freeze(primary ? this.primarySceneParam.isNeedFreeze : this.secondarySceneParam.isNeedFreeze)
    }
  }

  @Builder
  blurStandInBuilder(primary: boolean) {
    if (this.buildBlurStandIn(primary)) {
      Column()
        .size({ width: '100%', height: '100%' })
        .opacity(primary ? this.primarySceneParam.blurScale : this.secondarySceneParam.blurScale)
        .backgroundColor(this.getBlurStandInColor(primary))
        .pixelRound({ end: PixelRoundCalcPolicy.FORCE_CEIL })
    }
  }

  private buildBlurStandIn(primary: boolean): boolean {
    if (primary && this.sceneContainerSession.primarySession && this.primarySceneParam.useBlurStandIn) {
      return true;
    }
    if (!primary && this.sceneContainerSession.secondarySession && this.secondarySceneParam.useBlurStandIn) {
      return true;
    }
    return false;
  }

  private getBlurStandInColor(primary: boolean): string {
    if (this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      return FloatingSceneCommonStyle.DARK_BLUR_STAND_IN_COLOR;
    }
    return primary ? this.primarySceneParam.blurStandInColor : this.secondarySceneParam.blurStandInColor;
  }

  @Builder
  linearGradientBuilder($$: SCBSceneSessionStylesParam) {
    Stack() {
    }
    .height('100%')
    .width('100%')
    .linearGradient(
        ({
          angle: $$.sceneParam.gradientAngle,
          colors: [[`rgba(255, 255, 255, ${$$.sceneParam.gradient1})`, 0],
            [`rgba(255, 255, 255, ${$$.sceneParam.gradient2})`, 1]],
        })
    )
  }

  @Builder
  recentTabFocusBorderBuilder() {
    if (uiType === SCBConstants.UITYPE_PAD && this.sceneContainerSession.tabSelected) {
      Stack({ alignContent: Alignment.TopStart })
        .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
        .border({
          width: this.getTabSelectedBorderWidth(),
          color: this.getTabSelectedBorderColor(),
          radius: this.getBorderRadius()
        })
    }
  }

  @Builder
  animSnapshotBuilder() {
    if (this.sceneContainerSession.primarySession?.isPcAppInPad && this.sceneContainerSession.isShowContainerSnapshot) {
      Image(this.sceneContainerSession.containerSnapshotResource)
        .syncLoad(true)
        .objectFit(ImageFit.Fill)
    }
  }

  private enableShowEffectComponent(): boolean {
    if (this.scenePanelState === ScenePanelState.RECENT) {
      return false;
    }
    if (this.dividerParam.isDividerDragging) {
      return false;
    }
    return this.floatingParam.needEffectComponent;
  }

  private isNeedShowSplitBorder(): boolean {
    if (this.sceneContainerSession.isSplit && this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK &&
      this.scenePanelState !== ScenePanelState.RECENT) {
      return true;
    }
    return false;
  }

  private getTabSelectedBorderColor(): string {
    if (this.sceneContainerSession.tabSelected) {
      return RecentsStyleConstants.DEFAULT_SELECTED_BORDER_COLOR;
    }
    return RecentsStyleConstants.DEFAULT_BG_COLOR;
  }

  private getTabSelectedBorderWidth(): number {
    return this.sceneContainerSession.tabSelected ? RecentsStyleConstants.DEFAULT_SELECTED_BORDER_WIDTH :
    RecentsStyleConstants.DEFAULT_BORDER_WIDTH;
  }

  private getMotionBlurOptions(): MotionBlurOptions {
    let motionBlurOptions: MotionBlurOptions = { radius: 0, anchor: { x: 0, y: 0 } };
    if (StartAndExitVisualEffectManager.getInstance().isMotionBlurDisable()) {
      return motionBlurOptions;
    }
    let radius = this.needRenderMotionBlur.motionBlurRadius;
    if (CommonUtils.equals(radius, 0)) {
      return motionBlurOptions;
    }
    if (this.sceneContainerSession.isFloat) {
      // 悬浮窗场景不需要运动模糊
      return motionBlurOptions;
    }
    let refreshRate = StartAndExitVisualEffectManager.getInstance().getDeviceRate();
    if (this.shouldMotionBlurEnable(refreshRate)) {
      motionBlurOptions = {
        radius: refreshRate === 60 ? radius : radius * 0.67,
        anchor: {
          x : this.getAnchorX(),
          y : this.getAnchorY(),
        },
      };
    }
    return motionBlurOptions;
  }

  /**
   * 运动模糊是否生效判断
   * 产品配置运动模糊不生效则不做此判断
   * 当前判断条件
   * 1、如果配置有运动模糊最高生效帧率，则按照最高生效帧率校验是否生效运动模糊
   * 2、省电模式不生效运动模糊
   * 3、折叠屏展开态不生效运动模糊
   * 4、温控在低温和正常状态才允许生效运动模糊
   * @param refreshRate 屏幕刷新率
   * @returns 是否生效运动模糊
   */
  private shouldMotionBlurEnable(refreshRate: number): boolean {
    return this.checkMotionBlurEnable(refreshRate) &&
      power.getPowerMode() != power.DevicePowerMode.MODE_POWER_SAVE &&
      thermal.getLevel() <= thermal.ThermalLevel.NORMAL;
  }

  /**
   * 判断当前帧率是否生效运动模糊
   * 1、如果未配置运动模糊 则默认90hz以下生效运动模糊
   * 2、如果配置最高生效帧率，则在最高生效帧率以下生效运动模糊
   * @param refreshRate 屏幕刷新率
   * @returns 当前帧率是否生效运动模糊
   */
  private checkMotionBlurEnable(refreshRate: number) {
    const highestMotionBlurEnable = StartAndExitVisualEffectManager.getInstance().getHighestMotionBlurEnable();
    homeLog.showWarn(`checkMotionBlurEnable highestMotionBlurEnable:${highestMotionBlurEnable}, refreshRate:${refreshRate}`);
    if (highestMotionBlurEnable < 0) {
      return refreshRate === 60 || refreshRate === 90;
    }
    return refreshRate <= highestMotionBlurEnable;
  }

  /**
   * get motion blur anchor x
   * @returns number
   */
  private getAnchorX(): number {
    let anchorX = 0;
    let iconRectInfo = this.sceneContainerSession.sessionData.iconRectInfo;
    if (iconRectInfo) {
      let windowWidth = px2vp(this.screenProperty.width);
      anchorX = (iconRectInfo.left + (iconRectInfo.right - iconRectInfo.left) / 2) / windowWidth;
    }
    return anchorX;
  }

  /**
   * get motion blur anchor y
   * @returns number
   */
  private getAnchorY(): number {
    let anchorY = 0;
    let iconRectInfo = this.sceneContainerSession.sessionData.iconRectInfo;
    if (iconRectInfo) {
      let windowHeight = px2vp(this.screenProperty.height);
      anchorY = (iconRectInfo.top + (iconRectInfo.bottom - iconRectInfo.top) / 2) / windowHeight;
    }
    return anchorY;
  }

  private getBlurRadius(): ForegroundEffectOptions | null {
    return CommonUtils.equals(this.needRenderBlurRadius.blurRadius, -1) ? null : {
      radius: this.needRenderBlurRadius.blurRadius
    };
  }

  private getBlurScale(primary: boolean): number {
    if (this.floatingParam.needEffectComponent) {
      return 0;
    }
    if ((primary && this.primarySceneParam.useBlurStandIn) ||
      (!primary && this.secondarySceneParam.useBlurStandIn)) {
      return 0;
    }
    return primary ? this.primarySceneParam.blurScale : this.secondarySceneParam.blurScale;
  }

  build() {
      if (this.enableShowByPreBuild(PreBuildStage.PRE_BUILD_TITLE)) {
      Stack({ alignContent: Alignment.TopStart }) {
        if (this.needRenderShowRecentTitle.showRecentTitle) {
            RecentTitleView({
              sceneContainerSession: this.sceneContainerSession,
              screenProperty: this.screenProperty,
              needRenderScale: this.needRenderScale,
              needRenderPos: this.needRenderPos,
              titleViewAlpha: this.sceneContainerSession.needRenderTitleViewAlpha,
              needRenderLockIconOpacity: this.needRenderLockIconOpacity,
              needRenderLockIconScale: this.needRenderLockIconScale,
              needRenderLockIconTranslate: this.needRenderLockIconTranslate,
              needRenderTitleViewScale: this.needRenderTitleViewScale
            })
        }
        if (this.enableShowByPreBuild(PreBuildStage.PRE_BUILD_SCENE)) {
          Stack({ alignContent: Alignment.TopStart }) {
            Stack() {
              Stack({
                alignContent: CloseAppManager.getInstance().getStartAppType() === StartType.CARD ?
                Alignment.Top : Alignment.Center
              }) {
                // 动效场景，桌面图标、通知卡片等替代组件
                if (this.sceneContainerSession.getState() !== SCBSceneContainerState.RECENT &&
                  this.sceneContainerSession.getState() !== SCBSceneContainerState.SPLIT) {
                  this.transitionIconOrCard()
                }
                Stack() {
                  if (!this.sceneContainerSession.isMidScene) {
                    // primary scene
                    Stack({ alignContent: Alignment.TopStart }) {
                      ForEach(this.sceneContainerSession.getPrimarySessionList(), (sessionItem: SCBSceneSession) => {
                        if (sessionItem) {
                          Stack() {
                            if (this.primarySceneParam.blendMode) {
                              this.linearGradientBuilder({ sceneParam: this.primarySceneParam})
                            }
                            // Scene Session
                            if (this.enableShowByPreBuild(PreBuildStage.PRE_BUILD_DONE)) {
                              Stack({ alignContent: Alignment.Start }) {
                                this.sceneBuilder({
                                  sceneSession: sessionItem
                                })
                                this.animSnapshotBuilder();
                              }
                              .sceneSessionStyles({ sceneParam: this.primarySceneParam })

                              if (sessionItem.isPcAppInPad &&
                                this.sceneContainerSession.pcLeft !== 0 && this.sceneContainerSession.pcTop != 0) {
                                this.specificSceneBuilder({ specificSceneSessionList: this.priSubList })
                                this.specificSceneBuilder({ specificSceneSessionList: this.priDialogList })
                              }
                            }
                          }
                          .linearOpacityStyles({ sceneParam: this.primarySceneParam })
                          .onAppear(() => {
                            this.primarySceneParam.persistentId = sessionItem.session.persistentId;
                          }).onDisAppear(() => {
                            this.primarySceneParam.persistentId = -1;
                          })
                        }

                      }, (item: SCBSceneSession) => item?.session.persistentId.toString())
                      this.effectComponentBuilder(true);
                      this.splitBorderBuilder(true)
                      this.blurStandInBuilder(true)
                    }
                    .id('primaryStack')
                    .sceneRectStyles({ sceneParam: this.primarySceneParam })
                    .sceneStyles({ sceneParam: this.primarySceneParam }, this.getBlurScale(true), false)
                    .clip(this.dividerParam.needClip)

                    // secondary scene
                    if (this.sceneContainerSession.secondarySession) {
                      Stack({ alignContent: Alignment.TopStart }) {
                        ForEach(this.sceneContainerSession.getSecondarySessionList(),
                          (sessionItem: SCBSceneSession) => {
                            if (sessionItem) {
                              Stack() {
                                if (this.sceneContainerSession.getState() === SCBSceneContainerState.SPLIT &&
                                  !sOutSideWindowMgr.isShowGlobalSearch()) {
                                  this.transitionIconOrCard()
                                }
                                if (this.secondarySceneParam.blendMode) {
                                  this.linearGradientBuilder({ sceneParam: this.secondarySceneParam })
                                }
                                if (sessionItem && this.enableShowByPreBuild(PreBuildStage.PRE_BUILD_DONE)) {
                                  Stack() {
                                    this.sceneBuilder({
                                      sceneSession: sessionItem
                                    })
                                  }
                                  .sceneSessionStyles({ sceneParam: this.secondarySceneParam })
                                }
                              }
                              .flexShrink(1)
                              .linearOpacityStyles({ sceneParam: this.secondarySceneParam })
                              .onAppear(() => {
                                this.secondarySceneParam.persistentId = sessionItem.session.persistentId;
                              })
                              .onDisAppear(() => {
                                this.secondarySceneParam.persistentId = -1;
                              })
                            }
                          }, (item: SCBSceneSession) => item?.session.persistentId.toString())
                        this.effectComponentBuilder(false);
                        this.splitBorderBuilder(false)
                        this.blurStandInBuilder(false)
                      }
                      .id('secondaryStack')
                      .sceneRectStyles({ sceneParam: this.secondarySceneParam })
                      .sceneStyles({ sceneParam: this.secondarySceneParam }, this.getBlurScale(false), false)
                      .clip(this.dividerParam.needClip)
                    }

                    if(this.sceneContainerSession.isSplit){
                      SCBDivider({
                        dividerParam: $dividerParam,
                        primarySceneParam: this.dividerParam.primary,
                        secondarySceneParam: this.dividerParam.secondary,
                        sceneContainerSession: $sceneContainerSession,
                        screenProperty: $screenProperty,
                        onGestureChange: this.onGestureChange,
                      })
                    }
                  }

                }
                .direction(Direction.Ltr)
                .size(this.getContainerSize())
                .opacity(this.needRenderAlpha.sceneAlpha)
                .translate(this.getTranslateIcon())

                if (this.recentInnerState.isInRecentView()) {
                  this.recentTabFocusBorderBuilder();
                  RecentEventView({
                    sceneContainerSession: this.sceneContainerSession,
                    screenProperty: $screenProperty
                  })
                }
              }
              .direction(Direction.Ltr)
              .width(StyleConstants.PERCENTAGE_100)
              .height(StyleConstants.PERCENTAGE_100)
            }
            .rotate(this.getPanGestureRotate())
            .border(SCBRotateUtils.getSceneContainerBorderOptions2())
            .translate(this.getPanGestureTranslate())
            .borderRadius(this.getBorderRadius())
            .foregroundEffect(this.getBlurRadius())
            .foregroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK, {
              scale: this.sceneContainerSession.containerBlurScale
            }, { disableSystemAdaptation: true })
            .clip(this.scenePanelState === ScenePanelState.HOME || this.needRenderBorderRadius.hasBorderRadius())
            if (this.sceneContainerSession.getState() !== SCBSceneContainerState.RECENT) {
              this.appStartBadgeBuilder();
            }

            if (this.sceneContainerSession.isFloat) {
              SCBScalingScene({
                sceneContainerSession: this.sceneContainerSession,
                screenProperty: this.screenProperty,
                floatingParam: this.floatingParam,
              })
            }
          }
          .direction(Direction.Ltr)
          .id(this.sceneContainerSession.getSceneContainerComponentId())
          .position(this.getPositionInRecent())
          .opacity(this.getAlphaInRecent(this.needRenderRotate.angle))
          .size({
            width: this.needRenderClip.clipWidth.getPxSizeStr(),
            height: this.needRenderClip.clipHeight.getPxSizeStr()
          })
          .rotate(this.getRotateOptionsInRecent())
          .border(SCBRotateUtils.getSceneContainerBorderOptions3())
          .scale({
            x: this.getScaleRatio(this.needRenderRotate.angle) * this.needRenderScale.scaleX,
            y: this.getScaleRatio(this.needRenderRotate.angle) * this.needRenderScale.scaleY,
            centerX: this.needRenderScale.centerX,
            centerY: this.needRenderScale.centerY,
          })
          .flexShrink(0)
          .motionBlur(this.getMotionBlurOptions())
          .translate(this.getContainerComponentTranslate())
        }
      }
      .direction(Direction.Ltr)
      .translate({
        x: this.needRenderTranslate.translateX,
        y: this.needRenderTranslate.translateY
      })
      .size(this.getScreenPxSize())
      .visibility(this.needRenderVisibility.visibility ? Visibility.Visible : Visibility.Hidden)
      .zIndex(this.needRenderZIndex.zIndex)
      .hitTestBehavior(HitTestMode.None)
    }
  }
}
