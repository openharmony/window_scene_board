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

import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  LogDomain,
  LogHelper,
  PixelMapUtil,
  RectInfo,
  AnimateToScheduleUtils,
  WindowPanelType,
  SingleContext,
  TraceUtil,
  DomainName
} from '@ohos/basicutils';
import {
  SCBWindowSceneConfig,
  ResourceManager,
  ViewArea,
  HiSysEventUtil,
  ViewType,
  viewMgrPolicy,
  ApsUtils,
  GlobalContext,
  localEventManager
} from '@ohos/frameworkwrapper';
import {
  SCBKeyboardManager,
  SCBGestureAction,
  SCBGestureActionId,
  SCBSceneSession,
  SCBDividerParam,
  SCBSessionRect,
  SCBSessionEventId,
  SCBScreenProperty,
  NeedRenderRecentSceneBorderRadius,
  SCBSceneMode,
  ResUtils,
  SCBSystemBarProperty,
  WindowDragHotAreaType,
  SCBWindowShadowConfig,
  ScenePanelState,
  INVALID_SCREEN_ID,
  INVALID_PID,
  SessionChangeInfo,
  SessionDisplayChangeReason,
  SCBSceneSessionManager,
  SCBSpecificSession,
  SCBSpecificSceneSessionList,
  sSCBOobeManager,
  NeedRenderDragHotAreaAnimConfig,
  NeedRenderSplitBackgroundColor,
  SCBScreenSessionManager,
  SCBAppUseControlManager,
  ControlType,
  SystemBarType,
  ScbNumber,
  SCBSceneContainerSession,
  NeedRenderSnapShotAnimConfig,
  SCBSceneResourceManager,
} from '@ohos/windowscene';
import { PowerStatus } from '@ohos/commonconstants';
import { EventConstants, StyleConstants } from '@ohos/launchercommon'
import { styleMgr } from '@ohos/systemuicommon';
// import apsManager from '@hms.graphic.apsManager';
import PowerStatusChangeAnimationController from './PowerStatusChangeAnimationController';
import { SCBRecentStyleConstants } from '../recentview/SCBRecentStyleConstants';
import curves from '@ohos.curves';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import bundleManager from '@ohos.bundle.bundleManager';
import display from '@ohos.display';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { LayoutViewModel } from '@ohos/launchercommon';
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { multiInputManager } from '@ohos/multiinput';
import { PCUtils } from '../../common/utils/PCUtils';
import { SCBSpecificScene } from './SCBSpecificScene';
import { SCBSceneSnapShot, SCBSceneHelper, IFreeWindowsViewModel, SCBFreeWindowsViewModelManager,
  LayoutPolicyHelper } from '@ohos/pcmode';
import {
  SCBPcScenePanelManager,
  DividerStyle,
  SystemAnimatedScene,
  systemAniSceneCtrl,
  SCBSessionListManager,
  sceneAnimationManager,
  AttractionAnimController,
  SCBSystemSceneUtils
} from '@ohos/pcmode';
import { SCBWindowStrokeConfig } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSession';
import { SCBAppUseControlComponent} from '@ohos/windowscene/Index';
import { SplitState, NeedTrackSplitState } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneContainerSession';
import { PcDockIndepentIconMgr } from '@ohos/pcsmartdock/src/main/ets/default/manager/PcDockIndependentIconMgr';
import { PcSmartDockModel } from '@ohos/pcsmartdock/src/main/ets/default/model/PcSmartDockModel';
import { fileIo as fs } from '@kit.CoreFileKit';

const TAG = 'SCBScene'
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const MASK_SPLIT_SWITCHING_SCALE = 0.95;
const DEFAULT_PENDING_MODE_TRANSITION = 0;
const SPLIT_VERTICAL_MOVE_RECOVER_DISTANCE = 32;
const SPLIT_VERTICAL_MOVE_EXIT_RATIO = 0.1;
const RESIZE_WHEN_DRAG_END_BORDER_WIDTH: string = `${vp2px(4)}px`;
const RESIZE_WHEN_DRAG_END_BORDER_COLOR: string = 'rgba(255, 255, 255, 0.3)';
const RESIZE_WHEN_DRAG_END_OUTLINE_WIDTH: PX = `${vp2px(2)}px`;
const RESIZE_WHEN_DRAG_END_OUTLINE_COLOR: string = 'rgba(0, 0, 0, 0.1)';
const RESIZE_WHEN_DRAG_END_LINE_WIDTH: number = Math.round(vp2px(6));

const INVALID_TIMER_ID = -1;

const MASK_OFFSET = vp2px(10);

const SCREEN_INDEX = 1000;
const BASE_DENSITY: number = 160;
const B_C_SPLIT_LINE = 1608;
const TARGET_OPACITY_VALUE: number = 0.99;
const MAIN_TRANSITION_DURATION: number = 250;
const RECENT_TRANSITION_DURATION: number = 500;
const USE_CONTROL_COMPONENT_Z_INDEX = 100;

class SessionSafeArea {
  public targetPositionX: number = 0;
  public targetPositionY: number = 0;
  public targetWidth: number = 0;
  public targetHeight: number = 0;
}

interface SCBSpecificSceneBuilderParam {
  specificSceneSessionList: SCBSpecificSceneSessionList;
}

export enum WindowPosition {
  NOT_BIG_SCREEN_DEVICE = -1,
  B_WINDOW,
  C_WINDOW,
}

@Component
export struct SCBScene {
  @StorageLink('currColorMode')@Watch('onColorModeChange') currColorMode: number =
    GlobalContext.getContext()?.config?.colorMode as number ?? -1;
  @StorageLink('isDockAutoHide') isDockAutoHide: boolean = false;
  @ObjectLink sceneSession: SCBSceneSession;
  @ObjectLink needRenderRecentSceneBorderRadius: NeedRenderRecentSceneBorderRadius;
  @ObjectLink currRect: SCBSessionRect;
  @ObjectLink shadowConfig: SCBWindowShadowConfig;
  @ObjectLink strokeConfig: SCBWindowStrokeConfig;
  @ObjectLink subSessionList: SCBSpecificSceneSessionList;
  @ObjectLink needRenderDragHotAreaAnimConfig: NeedRenderDragHotAreaAnimConfig;
  @ObjectLink needRenderSplitBackgroundColor: NeedRenderSplitBackgroundColor;
  @ObjectLink needTrackSplitState: NeedTrackSplitState;
  @Link dividerParam: SCBDividerParam
  @Link screenProperty: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @Link scenePanelState: ScenePanelState;
  isStartMove: boolean = false;
  isStartDrag: boolean = false;
  apsWindowMoveTimer: number = -1;
  onGestureChange: Function = (): void => {};
  onSceneRectChange: Function = (): void => {};
  onCreateSubSession: Function = () => {};
  subSessionRaiseToTop: Function = () => {};
  subSessionRaiseAboveTarget: Function = () => {};
  subSessionStateChange: Function = () => {};
  subSessionZLevelChange: Function = () => {};
  onCreateDialog: Function = () => {};
  maskToAppear: Function = () => {};
  maskToDisAppear: Function = () => {};
  updateDragHotAreaAnimConfig: Function = () => {};
  onSplitPartnerMoveEvent: Function = () => {};
  getScreenDpiDensity: Function = (): number => 0;
  maskAppearTimerId: number = -1;
  isFullScreenStartMove: boolean = false;

  // drag variable
  private dragStartPosition: Position | null = null;
  private dragStartSize: SizeOptions | null = null;
  @State dragPosition: Position | null = null;
  @State dragSize: SizeOptions | null = null;
  @State isSessionActive: boolean = false;
  @State isShowUseControl: boolean = false;
  @State controlType: ControlType | null = null;

  @Link isNeedHideSubWin: boolean;

  // windowShadowEnableChange
  @State isWindowShadowEnable: boolean = true;

  private presenter: IFreeWindowsViewModel | null =
    SCBFreeWindowsViewModelManager.getInstance().getPresenter(this.screenProperty.screenId);

  private isSessionActiveCallBack = (isActive: boolean) => {
    log.showInfo(`[UseControl]Use control isActive:${isActive} persistentId:${this.sceneSession?.session.persistentId}`);
    this.isSessionActive = isActive;
  };
  private isShowUseControlCallBack = (isShow: boolean) => {
    log.showInfo(`[UseControl]use control isShow:${isShow} persistentId:${this.sceneSession?.session.persistentId}`);
    this.isShowUseControl = isShow;
    this.controlType = this.sceneSession?.getControlType();
    let isMainWindowControl = this.isMainWindowControl(isShow);
    this.isNeedHideSubWin = isMainWindowControl;
    this.sceneSession?.setActivateDragBySystem(!isMainWindowControl);
    if (isMainWindowControl) {
      if (SCBSceneHelper.isOverScreen(this.sceneSession, this.screenProperty)) {
        let statusBarHeight: number = 0;
        let statusBar = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithSystemType(
          sceneSessionManager.SessionType.TYPE_STATUS_BAR, this.screenProperty.screenId);
        if (statusBar && !this.isDockAutoHide) {
          statusBarHeight = statusBar.currRect.height.getPx();
        }
        let dockHeight = 0;
        let dock = SCBSceneSessionManager.getInstance()
          .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, this.screenProperty.screenId);
        if (dock && !this.isDockAutoHide) {
          dockHeight = dock.currRect.height.getPx();
        }
        SCBSceneHelper.updateRectAfterMainWindowControl(this.sceneSession, this.screenProperty,
          statusBarHeight, dockHeight);
      }
    }

    if (isMainWindowControl) {
      this.sceneSession?.useControlSession?.setFocusable(true);
      SCBSessionListManager.refreshZOrder();
      if (this.sceneSession?.isInSplit()) {
        SCBSceneSessionManager.getInstance()
          .processRecover(this.sceneSession?.sceneInfo?.screenId, this.sceneSession?.session.persistentId);
      }
    }
  };

  private isMainWindowControl(isShow: boolean): boolean {
    if (isShow && (this.sceneSession?.useControlList?.[0] === ControlType.PARENT_CONTROL ||
      this.sceneSession?.useControlList?.[0] === ControlType.APP_LOCK) && !this.sceneSession?.isControlRecentOnly()) {
      return true;
    }
    return false;
  }

  setWindowEffectConfig() {
    this.sceneSession.setFloatCornerRadiusConfig();
    this.sceneSession.setWindowShadowConfig();
    this.sceneSession.setWindowStrokeConfig();
  }

  onColorModeChange() {
    log.showDebug('onColorModeChange currColorMode=' + this.currColorMode + ', id: ' + this.sceneSession?.session.persistentId);
    this.sceneSession.setWindowStrokeConfig();
    this.sceneSession.setWindowShadowConfig(this.currColorMode);
    this.sceneSession.setSidebarBlur(true, true);
  }

  onNeedAvoid(): boolean {
    if (!this.sceneSession) {
      return false;
    }
    if (this.sceneSession.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      return false;
    }
    if (this.sceneSession.statusVisible === false) {
      return false;
    }
    return this.sceneSession.needAvoid;
  }

  onSessionTitleAction(actionId: SCBSessionEventId, param?: sceneSessionManager.SessionEventParam) {
    log.showInfo('OnSessionTitleAction actionId ' + actionId + ' id: ' + this.sceneSession?.session.persistentId);
    switch (actionId) {
      case SCBSessionEventId.EVENT_MAXIMIZE:
        SCBSceneSessionManager.getInstance().setMaximizeFloatingMode(false);
        this.sceneSession!.isSessionResizeWhenDragEnd = false;
        this.onMaximize();
        break;
      case SCBSessionEventId.EVENT_RECOVER:
        this.onRecover();
        break;
      case SCBSessionEventId.EVENT_START_MOVE:
        performanceMonitor.begin('WINDOW_RECT_MOVE', performanceMonitor.ActionType.FIRST_MOVE,
          this.sceneSession.sceneInfo?.bundleName);
        this.onMoveStart(param);
        break;
      case SCBSessionEventId.EVENT_DRAG_START:
        this.onDragStartEvent(param);
        break;
      case SCBSessionEventId.EVENT_DRAG:
        this.onEventDrag(param);
        break;
      case SCBSessionEventId.EVENT_END_MOVE:
        performanceMonitor.end('WINDOW_RECT_MOVE');
        this.onMoveEnd(param);
        break;
      case SCBSessionEventId.EVENT_MAXIMIZE_FLOATING:
        SCBSceneSessionManager.getInstance().setMaximizeFloatingMode(true);
        this.sceneSession!.isSessionResizeWhenDragEnd = false;
        this.onMaximizeFloating();
        break;
      case SCBSessionEventId.EVENT_SPLIT_PRIMARY:
        this.sceneSession!.isSessionResizeWhenDragEnd = false;
        this.onSplitPrimary();
        break;
      case SCBSessionEventId.EVENT_SPLIT_SECONDARY:
        this.sceneSession!.isSessionResizeWhenDragEnd = false;
        this.onSplitSecondary();
        break;
      default:
        break;
    }
    this.onSplitMoveAction(actionId);
  }

  private onSplitMoveAction(actionId: SCBSessionEventId): void {
    switch (actionId) {
      case SCBSessionEventId.EVENT_SPLIT_SWITCH:
        this.onSplitSwitch();
        break;
      case SCBSessionEventId.EVENT_SPLIT_POSITION_RECOVER:
        this.onSplitPositionRecover();
        break;
      case SCBSessionEventId.EVENT_SPLIT_STATE_RESTORATION:
        this.onSplitStateRestoration();
        break;
      default:
        break;
    }
  }

  onMaximize() {
    if (!this.sceneSession) {
      log.showError('onMaximize sceneSession is undefined');
      return;
    }
    if (this.presenter === null) {
      return;
    }
    const compatibleModeCallback = () => {
      this.onMaximizePhoneApp();
    }
    this.presenter.maximizeFromScene(this.sceneSession.persistentId, compatibleModeCallback);
  }

  private handleSceneSessionRectDpiChange(): SCBSessionRect {
    const statusBarHeight = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(this.screenProperty.screenId);
    const dockHeight =
      SCBSystemSceneUtils.getInstance().getDockHeightPx(this.screenProperty.screenId, this.getUIContext());
    let lastLeft = this.sceneSession.lastRect.left.getPx();
    let lastTop = this.sceneSession.lastRect.top.getPx();
    let lastWidth = this.sceneSession.lastRect.width.getPx();
    let lastHeight = this.sceneSession.lastRect.height.getPx();
    const lastDpi: number = this.sceneSession.sessionData.lastDpi;
    const currentDpi: number = this.getScreenDpiDensity();

    if (lastDpi != -1 && lastDpi != currentDpi) {
      lastWidth = lastWidth / lastDpi * currentDpi;
      lastHeight = lastHeight / lastDpi * currentDpi;
      if (lastWidth > this.screenProperty.width) {
        lastWidth = this.screenProperty.width;
      }
      if ((lastHeight > (this.screenProperty.height - statusBarHeight - vp2px(dockHeight))) &&
        !sSCBOobeManager.isOobeActivated()) {
        lastHeight = this.screenProperty.height - statusBarHeight - vp2px(dockHeight);
      }
      if (lastTop + lastHeight > this.screenProperty.height - vp2px(dockHeight)) {
        lastTop = this.screenProperty.height - vp2px(dockHeight) - lastHeight;
      }
      if (lastLeft + lastWidth > this.screenProperty.width) {
        lastLeft = this.screenProperty.width - lastWidth;
      }
    }
    return new SCBSessionRect(lastLeft, lastTop, lastWidth, lastHeight);
  }

  private handleSceneSessionDpiChange(sceneSessionRectWithDpiChange: SCBSessionRect): SCBSessionRect {
    if (this.sceneSession.sessionData.lastDpi !== this.getScreenDpiDensity()) {
      sceneSessionRectWithDpiChange = this.handleSceneSessionRectDpiChange();
    }
    this.sceneSession.sessionData.lastDpi = this.getScreenDpiDensity();
    return sceneSessionRectWithDpiChange;
  }

  private calculateMaxRect(): SCBSessionRect {
    return LayoutPolicyHelper.getInstance().calculateMaxRect(this.sceneSession, this.screenProperty);
  }

  private onMaximizePhoneApp(): void {
    this.playMaximizeAnimation();
    this.sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    this.sceneSession.sessionData.isMaximizeFloating = false;
  }

  onSplitPrimary() {
    log.showInfo('onSplitPrimary, ' + this.sceneSession?.currRect.width.getPx() + ', ' +
    this.sceneSession?.currRect.height.getPx() + ', mode:' + this.sceneSession.sceneInfo.windowMode);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE,
      { 'isVisible': false, 'screenId': this.screenProperty.screenId });
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
        !this.sceneSession.isMaximizeFloating &&
        !this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_LEFT | WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT |
        WindowDragHotAreaType.HOT_AREA_TYPT_TOP,
          this.sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0) &&
        !this.sceneSession.isLastSplit) {
      this.sceneSession.saveLastRect();
    }
    let sceneSessionRectWithDpiChange: SCBSessionRect =
      this.handleSceneSessionDpiChange(this.sceneSession.lastRect.copy());
    if (this.sceneSession.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      this.sceneSession.floatBorderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    }
    this.sceneSession.needRenderSnapShotAnimConfig.animActionId = SCBSessionEventId.EVENT_SPLIT_PRIMARY;
    sceneAnimationManager.setFreezeImmediately(this.sceneSession, true);
    if (!this.sceneSession.isInSplit()) {
      this.sceneSession.sessionData.lastWindowMode = this.sceneSession.sceneInfo.windowMode;
    }
    this.sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    this.maskToDisAppear();
    this.sceneSession.sessionData.isMaximizeFloating = false;
    performanceMonitor.begin('PC_SPLIT_START_ANIMATE', performanceMonitor.ActionType.LAST_UP,
      this.sceneSession.sceneInfo?.bundleName);
    this.initAnimatePara(SCBSessionEventId.EVENT_SPLIT_PRIMARY);
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_SPLIT_WINDOW);
    this.sceneSession.setGravity(sceneSessionManager.Gravity.RESIZE);
    this.setCommonAnimate();
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT_PRE, StyleConstants.DEFAULT_1);
    this.sceneSession.addAnimCount();
    const animCount = this.sceneSession.getAnimCount();
    this.getUIContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT_PRE, StyleConstants.DEFAULT_0);
        this.sceneSession.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_SPLIT_WINDOW);
        AppStorage.setOrCreate('isEnterSplitAnimating', false);
        if (this.sceneSession?.isPairSplitScene) {
          AppStorage.setOrCreate('isSplitAnimating', false);
        }
        this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = false;
        if (animCount === this.sceneSession.getAnimCount()) {
          this.sceneSession.clearAnimCount();
        }
        performanceMonitor.end('PC_SPLIT_START_ANIMATE');
      }
    }, () => {
      this.sceneSession.floatBorderRadius = 0;
      this.sceneSession.initSceneState();
      this.notifySubSessionEvent(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
    })
    sceneAnimationManager.setFreezeImmediately(this.sceneSession, false);
    this.sceneSession.lastRect.copyFrom(sceneSessionRectWithDpiChange);
  }

  onSplitSecondary() {
    log.showInfo('onSplitSecondary, ' + this.sceneSession?.currRect.width.getPx() + ', ' +
    this.sceneSession?.currRect.height.getPx() + ', mode:' + this.sceneSession.sceneInfo.windowMode);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_POPUP_VISIBLE_CHANGE,
      { 'isVisible': false, 'screenId': this.screenProperty.screenId });
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
        !this.sceneSession.isMaximizeFloating &&
        !this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT,
          this.sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0) &&
        !this.sceneSession.isLastSplit) {
      this.sceneSession.saveLastRect();
    }
    let sceneSessionRectWithDpiChange: SCBSessionRect =
      this.handleSceneSessionDpiChange(this.sceneSession.lastRect.copy());
    if (this.sceneSession.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      this.sceneSession.floatBorderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    }
    this.sceneSession.needRenderSnapShotAnimConfig.animActionId = SCBSessionEventId.EVENT_SPLIT_SECONDARY;
    sceneAnimationManager.setFreezeImmediately(this.sceneSession, true);
    if (!this.sceneSession.isInSplit()) {
      this.sceneSession.sessionData.lastWindowMode = this.sceneSession.sceneInfo.windowMode;
    }
    this.sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
    this.maskToDisAppear();
    this.sceneSession.sessionData.isMaximizeFloating = false;
    performanceMonitor.begin('PC_SPLIT_START_ANIMATE', performanceMonitor.ActionType.LAST_UP,
      this.sceneSession.sceneInfo?.bundleName);
    this.initAnimatePara(SCBSessionEventId.EVENT_SPLIT_SECONDARY);
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_SPLIT_WINDOW);
    this.sceneSession.setGravity(sceneSessionManager.Gravity.RESIZE);
    this.setCommonAnimate();
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT_PRE, StyleConstants.DEFAULT_1);
    this.sceneSession.addAnimCount();
    const animCount = this.sceneSession.getAnimCount();
    this.getUIContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT_PRE, StyleConstants.DEFAULT_0);
        this.sceneSession.setGravity(sceneSessionManager.Gravity.BOTTOM_RIGHT);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_SPLIT_WINDOW);
        AppStorage.setOrCreate('isEnterSplitAnimating', false);
        if (this.sceneSession?.isPairSplitScene) {
          AppStorage.setOrCreate('isSplitAnimating', false);
        }
        this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = false;
        if (animCount === this.sceneSession.getAnimCount()) {
          this.sceneSession.clearAnimCount();
        }
        performanceMonitor.end('PC_SPLIT_START_ANIMATE');
      }
    }, () => {
      this.sceneSession.floatBorderRadius = 0;
      this.sceneSession.initSceneState();
      this.notifySubSessionEvent(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
    })
    sceneAnimationManager.setFreezeImmediately(this.sceneSession, false);
    this.sceneSession.lastRect.copyFrom(sceneSessionRectWithDpiChange);
  }

  private onRecoverInRecent(): void {
    if (!this.sceneSession.isLastSplit) {
      this.sceneSession.currRect.copyFrom(this.sceneSession.lastRect);
    }
    this.setWindowEffectConfig();
    AppStorage.setOrCreate('isSplitAnimating', false);
    this.springBackIfNeeded();
  }

  private getSplitHeightPx(needPrimaryHeight: boolean): number {
    if (this.dividerParam.isSplitPrimaryMode && needPrimaryHeight ||
      !this.dividerParam.isSplitPrimaryMode && !needPrimaryHeight) {
      return Number.parseFloat(this.dividerParam.primary.height) * 0.01 * this.screenProperty.height;
    }
    return Number.parseFloat(this.dividerParam.secondary.height) * 0.01 * this.screenProperty.height;
  }

  onRecover() {
    if (!this.sceneSession) {
      log.showError('onRecover sceneSession is undefined');
      return;
    } else {
      log.showInfo(`onRecover id: ${this.sceneSession.session.persistentId} ` +
        `lastRect: ${this.sceneSession.lastRect.printPx()}`);
    }
    const lastWindowMode = this.sceneSession.sceneInfo.windowMode;
    this.sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER);
    this.sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    this.sceneSession.sessionData.lastWindowMode = SCBSceneMode.FLOATING;
    this.sceneSession.isRecoveredFullScreen = false;
    this.sceneSession.sessionData.isMaximizeFloating = false;

    if (this.isScenePanelSplitOrRecentState() && this.needTrackSplitState.state !== SplitState.EXIT_SPLIT) {
      log.showInfo('onRecover in Recent!');
      this.onRecoverInRecent();
      this.onSceneRectChange();
      return;
    }

    performanceMonitor.begin('WINDOW_TITLE_BAR_RECOVER', performanceMonitor.ActionType.LAST_UP,
      this.sceneSession.sceneInfo.bundleName);
    /*if (lastWindowMode === SCBSceneMode.SECONDARY || lastWindowMode === SCBSceneMode.PRIMARY) {
      ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT_RECOVER, StyleConstants.DEFAULT_1);
    } else {
      ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MAX_RECOVER, StyleConstants.DEFAULT_1);
    }*/
    if (lastWindowMode === SCBSceneMode.FULLSCREEN) {
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_WINDOW_FULL_SCREEN, true);
      AnimateToScheduleUtils.reportMaximizeToRss(WindowPanelType.RECOVERY, this.sceneSession.sceneInfo.bundleName);
    } else if (lastWindowMode === SCBSceneMode.FLOATING &&
    this.sceneSession.isMaximizeFloating) {
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_MAX_WINDOW, true);
    } else if (lastWindowMode === SCBSceneMode.PRIMARY ||
      lastWindowMode === SCBSceneMode.SECONDARY) {
      const isAttractionEnabled = AttractionAnimController.getInstance().isAttractionEnabled();
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_SPLIT_WINDOW, !isAttractionEnabled);
    }
    this.onRecoverDefaultApp(lastWindowMode);
    this.sceneSession.sessionData.lastDpi = this.getScreenDpiDensity();
  }

  onRecoverDefaultApp(lastWindowMode: SCBSceneMode) {
    log.showInfo('onRecoverDefaultApp, useImplicitAnimation=' + this.sceneSession.sessionData.useImplicitAnimation);
    let isFreeze = false;
    if (!this.sceneSession.isLastSplit) {
      this.sceneSession.needRenderSnapShotAnimConfig.animActionId = SCBSessionEventId.EVENT_RECOVER;
      if (!this.sceneSession.sessionData.useImplicitAnimation) {
        isFreeze = true;
        sceneAnimationManager.setFreezeImmediately(this.sceneSession, true);
      } else {
        this.sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER_IN_IMPLICIT);
      }
      this.initAnimatePara(SCBSessionEventId.EVENT_RECOVER);
      if (!this.sceneSession.sessionData.useImplicitAnimation) {
        this.setCommonAnimate(lastWindowMode === SCBSceneMode.FULLSCREEN &&
        this.sceneSession.sessionData.isLastMaximizeInImmersive);
      }
    }
    this.sceneSession.floatBorderRadius = 0;
    this.getUIContext()?.animateTo({
      duration: 0,
    }, () => {
      if (!this.sceneSession.isLastSplit && !AppStorage.get('isLock')) {
        this.sceneSession.floatBorderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
      }
    })
    this.sceneSession.addAnimCount();
    const animCount = this.sceneSession.getAnimCount();
    this.getUIContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        this.springBackIfNeeded();
        if (animCount === this.sceneSession.getAnimCount()) {
          this.sceneSession.setGravity(sceneSessionManager.Gravity.TOP_LEFT);
          this.sceneSession.clearAnimCount();
        }
        performanceMonitor.end('WINDOW_TITLE_BAR_RECOVER');
        /*if (lastWindowMode === SCBSceneMode.SECONDARY || lastWindowMode === SCBSceneMode.PRIMARY) {
          ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_SPLIT_RECOVER, StyleConstants.DEFAULT_0);
          ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MIN_RECOVER, StyleConstants.DEFAULT_0);
        } else {
          ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MAX_RECOVER, StyleConstants.DEFAULT_0);
        }*/
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_WINDOW_FULL_SCREEN);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_MAX_WINDOW);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_SPLIT_WINDOW);
        this.needTrackSplitState.setState(SplitState.UNDEFINED);
      }
    }, () => {
      if (!this.sceneSession.isLastSplit && !AppStorage.get('isLock')) {
        this.sceneSession.translateX = 0;
        this.sceneSession.translateY = 0;
        this.sceneSession.scaleX = 1;
        this.sceneSession.scaleY = 1;
      }
      this.setWindowEffectConfig();
      AppStorage.setOrCreate('isSplitAnimating', false);
      this.notifySubSessionEvent(sceneSessionManager.SessionSizeChangeReason.RECOVER_IN_IMPLICIT);
    })
    this.sceneSession.setSidebarBlurMaximize(false);
    if (isFreeze) {
      sceneAnimationManager.setFreezeImmediately(this.sceneSession, false);
    }
  }

  onRecoverPhoneApp() {
    log.showInfo('onRecoverPhoneApp');
    this.getUIContext()?.animateToImmediately({
      duration: 0,
      onFinish: () => {
        this.springBackIfNeeded();
        performanceMonitor.end('WINDOW_TITLE_BAR_RECOVER');
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_WINDOW_FULL_SCREEN);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_MAX_WINDOW);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_SPLIT_WINDOW);
        this.needTrackSplitState.setState(SplitState.UNDEFINED);
      },
    }, () => {
      if (!this.sceneSession.isLastSplit) {
        if (!AppStorage.get('isLock')) {
          this.sceneSession.initSceneState();
        }
        this.sceneSession.currRect.copyFrom(this.sceneSession.lastRect);
      }
      this.setWindowEffectConfig();
      AppStorage.setOrCreate('isSplitAnimating', false);
    })
  }

  onRecoverWhenLock() {
    log.showInfo('onRecoverWhenLock');
    if (!this.sceneSession) {
      log.showError('onRecover sceneSession is undefined');
      return;
    } else {
      log.showInfo('onRecover' + ' id: ' + this.sceneSession.session.persistentId +
        ' lastRect: [' + this.sceneSession.lastRect.left.getPx() + ',' + this.sceneSession.lastRect.top.getPx() + ',' +
      this.sceneSession.lastRect.width.getPx() + ',' + this.sceneSession.lastRect.height.getPx() + ']');
    }
    performanceMonitor.begin('WINDOW_TITLE_BAR_RECOVER', performanceMonitor.ActionType.LAST_UP,
      this.sceneSession.sceneInfo?.bundleName);

    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_WINDOW_FULL_SCREEN, true);
    } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
      this.sceneSession.isMaximizeFloating) {
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_MAX_WINDOW, true);
    } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY ||
      this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
      systemAniSceneCtrl.enqueue(SystemAnimatedScene.EXIT_SPLIT_WINDOW);
    }
    SCBSceneSessionManager.getInstance()
      .processRecover(this.sceneSession.sceneInfo.screenId, this.sceneSession.session.persistentId);
    this.sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER);
    this.sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    this.getUIContext()?.animateToImmediately({
      curve: Curve.EaseOut,
      duration: 400,
      onFinish: () => {
        this.springBackIfNeeded();
        performanceMonitor.end('WINDOW_TITLE_BAR_RECOVER');
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_WINDOW_FULL_SCREEN);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_MAX_WINDOW);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.EXIT_SPLIT_WINDOW);
      },
    }, () => {
      if (!this.sceneSession.isLastSplit) {
        if (!AppStorage.get('isLock')) {
          this.sceneSession.initSceneState();
        }
        this.sceneSession.currRect.copyFrom(this.sceneSession.lastRect);
      }
      this.setWindowEffectConfig();
      AppStorage.setOrCreate('isSplitAnimating', false);
    })
    this.sceneSession.sessionData.isMaximizeFloating = false;
  }

  private onSplitPositionRecover(): void {
    if (!this.sceneSession) {
      log.showError('onSplitPositionRecover sceneSession is undefined');
      return;
    } else {
      log.showInfo('onSplitPositionRecover' + ' id: ' + this.sceneSession.session.persistentId +
        ' lastRect: [' + this.sceneSession.lastRect.left.getPx() + ',' + this.sceneSession.lastRect.top.getPx() + ',' +
        this.sceneSession.lastRect.width.getPx() + ',' + this.sceneSession.lastRect.height.getPx() + ']');
    }

    this.sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.RECOVER);
    this.getUIContext()?.animateTo({
      curve: Curve.EaseOut,
      duration: 200,
      onFinish: () => {
        if (this.sceneSession?.sceneInfo.windowMode === this.dividerParam.splitMovingMode) {
          this.dividerParam.splitMovingMode = SCBSceneMode.UNDEFINED;
        }
      },
    }, () => {
        if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
          const priRect = LayoutPolicyHelper.getInstance()
            .getSplitCurrRect(this.screenProperty, this.dividerParam, true);
          this.sceneSession.currRect.copyFrom(priRect)
        } else if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
          const secRect = LayoutPolicyHelper.getInstance()
            .getSplitCurrRect(this.screenProperty, this.dividerParam, false);
          this.sceneSession.currRect.copyFrom(secRect)
        } else {
        }
      this.notifySubSessionEvent(sceneSessionManager.SessionSizeChangeReason.UNDEFINED)
    })
    if (this.sceneSession.sceneInfo.windowMode === this.dividerParam.splitMovingMode &&
      (this.sceneSession.isActive || AppStorage.get('isLock'))) {
      this.getUIContext()?.animateTo({
        curve: Curve.Sharp,
        duration: 200,
      }, () => {
        this.dividerParam.setDividerOpacity(1);
      })
    }
  }

  private onSplitSwitch(): void {
    if (!this.sceneSession) {
      log.showError('onSplitSwitch sceneSession is undefined');
      return;
    } else {
      log.showInfo('onSplitSwitch' + ' id: ' + this.sceneSession.session.persistentId +
        ' lastRect: [' + this.sceneSession.lastRect.left.getPx() + ',' + this.sceneSession.lastRect.top.getPx() + ',' +
        this.sceneSession.lastRect.width.getPx() + ',' + this.sceneSession.lastRect.height.getPx() + ']');
    }
    const priRect = LayoutPolicyHelper.getInstance().getSplitCurrRect(this.screenProperty, this.dividerParam, true);
    this.getUIContext()?.animateTo({
      curve: Curve.EaseOut,
      duration: 300,
    }, () => {
      if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
        const secRect = LayoutPolicyHelper.getInstance()
          .getSplitCurrRect(this.screenProperty, this.dividerParam, false);
        let left: number = secRect.left.getPx();
        let top: number = secRect.top.getPx();
        if (this.dividerParam.isExpandUpDownSplit()) {
          top = priRect.top.getPx() + secRect.height.getPx() + vp2px(DividerStyle.DIVIDER_WIDTH);
        } else {
          left = priRect.left.getPx() + secRect.width.getPx() + vp2px(DividerStyle.DIVIDER_WIDTH);
        }
        this.sceneSession.currRect.setPosNum(left, top);
      } else if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
        this.sceneSession.currRect.setPosNum(priRect.left.getPx(), priRect.top.getPx());
      }
      this.sceneSession.setScale(MASK_SPLIT_SWITCHING_SCALE, MASK_SPLIT_SWITCHING_SCALE);
      this.sceneSession.setTran(0, 0);
    })
  }

  private onSplitStateRestoration(): void {
    if (!this.sceneSession) {
      log.showError('onSplitStateRestoration sceneSession is undefined');
      return;
    } else {
      log.showInfo('onSplitStateRestoration id: ' + this.sceneSession.session.persistentId);
    }

    this.getUIContext()?.animateTo({
      curve: Curve.EaseOut,
      duration: 300,
    }, () => {
      this.sceneSession.setTran(0, 0);
      this.sceneSession.setScale(1, 1);
    })
  }

  onHideDivider() {
    this.getUIContext()?.animateTo({
      curve: Curve.Sharp,
      duration: 200,
    }, () => {
      this.dividerParam.setDividerOpacity(0);
    })
  }

  onMaximizeFloating() {
    let statusBarHeight: number = 0;
    const topArea: ViewArea = viewMgrPolicy.getArea(ViewType.STATUS_BAR);
    if (topArea !== undefined) {
      statusBarHeight = styleMgr.vp2pxStatusBarPCHeight();
    }
    const dockHeight = AppStorage.get('dockHeight') as number;
    log.showInfo('onMaximizeFloating statusBarHeight = ' + statusBarHeight + ' dockHeight = ' + dockHeight +
      ' screenHeight = ' + this.screenProperty.height + ' windowMode: ' + this.sceneSession.sceneInfo.windowMode +
      ' rect: [' + this.currRect.left.getPx() + ',' + this.currRect.top.getPx() + ',' +
      this.currRect.width.getPx() + ',' + this.currRect.height.getPx() + ']');
    performanceMonitor.begin('WINDOW_TITLE_BAR_MAXIMIZED_FLOATING', performanceMonitor.ActionType.LAST_UP,
      this.sceneSession.sceneInfo?.bundleName);
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
      !this.sceneSession.isMaximizeFloating &&
      !this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_TOP,
        this.sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0)) {
      this.sceneSession.saveLastRect();
    }
    systemAniSceneCtrl.enqueue(SystemAnimatedScene.ENTER_MAX_WINDOW, true);
    this.sceneSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.MAXIMIZE);
    this.sceneSession.addAnimCount();
    const animCount = this.sceneSession.getAnimCount();
    this.getUIContext()?.animateTo({
      curve: Curve.EaseOut,
      duration: 400,
      onFinish: () => {
        this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = false;
        if (animCount === this.sceneSession.getAnimCount()) {
          this.sceneSession.clearAnimCount();
        }
        performanceMonitor.end('WINDOW_TITLE_BAR_MAXIMIZED_FLOATING');
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_MAX_WINDOW);
      },
    }, () => {
      this.sceneSession.initSceneState();
      this.sceneSession.currRect.setRectNum(0, statusBarHeight, this.screenProperty.width,
        this.screenProperty.height - statusBarHeight - vp2px(dockHeight));
    })
    this.sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    this.sceneSession.sessionData.isMaximizeFloating = true;
  }

  onMoveStart(param?: sceneSessionManager.SessionEventParam) {
    this.isStartMove = true;
    this.sceneSession.sessionData.windowDragHotAreaTypeMap
      .set(this.screenProperty.screenId, DEFAULT_PENDING_MODE_TRANSITION);
    AppStorage.SetOrCreate('isWindowMoving', true);
    this.sceneSession?.saveSessionMovingState(true);
    this.apsWindowMoveBegin();
    if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.FLOATING) {
      this.sceneSession?.saveLastRect();
    }
    if (this.sceneSession && param) {
      this.sceneSession.moveFarthestPointY = param.pointerY;
      this.sceneSession.startMovePointerPos.setPointerPos(param.pointerX, param.pointerY);
      if (this.sceneSession.isInSplit()) {
        SCBSceneSessionManager.getInstance().updateWindowDragHotArea(this.sceneSession.sceneInfo.screenId,
          this.sceneSession.session.persistentId);
        this.dividerParam.splitMovingMode = this.sceneSession?.sceneInfo.windowMode;
        this.onSplitPartnerMoveEvent(this.sceneSession?.sceneInfo.persistentId,
          SCBSessionEventId.EVENT_SPLIT_START_MOVE);
        this.onHideDivider();
      }
    }

    if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN) {
      this.sceneSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      this.sceneSession.sessionData.isMaximizeFloating = false;
      sceneSessionManager.updateWindowMode(this.sceneSession.session.persistentId, SCBSceneMode.FLOATING);
      this.setWindowEffectConfig();
      this.isFullScreenStartMove = true;
    }

    if (this.sceneSession?.sceneInfo.windowMode !== SCBSceneMode.PRIMARY &&
      this.sceneSession?.sceneInfo.windowMode !== SCBSceneMode.SECONDARY) {
      this.sceneSession.sessionData.isDragging = true;
      let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
      sessionChangeInfo.persistentIds.push(this.sceneSession?.sceneInfo.persistentId);
      sessionChangeInfo.curScreenId = this.sceneSession?.sceneInfo.screenId;
      SCBSceneSessionManager.getInstance()
        .sessionDisplayChange(SessionDisplayChangeReason.START_MOVE, sessionChangeInfo);
    }
  }

  private onWindowMoving = (displayId: number, pointerX: number, pointerY: number): void => {
    if (displayId !== this.sceneSession?.sceneInfo.screenId) {
      return;
    }
    if (this.sceneSession.isInSplit()) {
      this.sceneSession.moveFarthestPointY = Math.max(pointerY, this.sceneSession.moveFarthestPointY);
      this.onSplitPartnerMoveEvent(this.sceneSession?.sceneInfo.persistentId,
        SCBSessionEventId.EVENT_SPLIT_MOVING);
    }
    if (this.isFullScreenStartMove && this.sceneSession?.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      this.isFullScreenStartMove = false;
    }
  }

  onMoveEnd(param?: sceneSessionManager.SessionEventParam) {
    log.showDebug(`onMoveEnd called`);
    AppStorage.SetOrCreate('isWindowMoving', false);
    this.sceneSession?.saveSessionMovingState(false);
    if (this.sceneSession?.isSessionResizeWhenDragEnd) {
      this.updateDragRect(param);
      log.showInfo('to update rect for resize when drag end type');
      if (!this.dragPosition || this.dragPosition.x === undefined || this.dragPosition.y === undefined ||
        !this.dragSize || this.dragSize.width === undefined || this.dragSize.height === undefined) {
        log.showError('drag var is undefined, not to update rect');
        return;
      }
      this.sceneSession.updateRect(new ScbNumber(this.dragPosition.x as number),
        new ScbNumber(this.dragPosition.y as number), new ScbNumber(this.dragSize.width as number),
        new ScbNumber(this.dragSize.height as number), sceneSessionManager.SessionSizeChangeReason.DRAG_END, true);
      this.springBackIfNeeded();
    }
    this.sceneSession!.isSessionResizeWhenDragEnd = false;
    clearInterval(this.apsWindowMoveTimer);
    this.apsWindowMoveTimer = -1;
    /*if (this.isStartDrag) {
      ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_DRAG, StyleConstants.DEFAULT_2);
    } else if (this.isStartMove) {
      ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MOVE, StyleConstants.DEFAULT_2);
    }*/
    this.isStartMove = false;
    this.isStartDrag = false;
    this.isFullScreenStartMove = false;
    if (!this.sceneSession) {
      log.showDebug(`onMoveEnd, sceneSession is null`);
      return;
    }
    this.clearWindowDragHotArea();
    this.sceneSession.sessionData.isDragging = false;
    let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
    sessionChangeInfo.persistentIds.push(this.sceneSession.sceneInfo.persistentId);
    sessionChangeInfo.curScreenId = this.sceneSession.sceneInfo.screenId;
    SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.END_MOVE, sessionChangeInfo);
  }

  private clearWindowDragHotArea(): void {
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      log.showInfo(`clearWindowDragHotArea screenId: ${screenSession.session.screenId}`);
      let invalidRect: RectInfo = new RectInfo();
      invalidRect.left = -1;
      invalidRect.top = -1;
      invalidRect.right = -1;
      invalidRect.bottom = -1;
      sceneSessionManager.addWindowDragHotArea(screenSession.session.screenId,
        WindowDragHotAreaType.HOT_AREA_TYPT_EXIT_SPLIT, invalidRect);
      sceneSessionManager.addWindowDragHotArea(screenSession.session.screenId,
        WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT, invalidRect);
      sceneSessionManager.addWindowDragHotArea(screenSession.session.screenId,
        WindowDragHotAreaType.HOT_AREA_TYPT_REDUCE_SPLIT, invalidRect);
    }
  }

  private apsWindowDragBegin(): void {
    let apsSendTimes: number = 0;
    let apsWindowMoveTimerId: number = -1;
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_DRAG, StyleConstants.DEFAULT_1);
    this.apsWindowMoveTimer = setInterval(() => {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_DRAG, StyleConstants.DEFAULT_1);
      // If the timer exceeds 60 seconds, the timer is disabled.
      apsSendTimes++;
      if (apsSendTimes >= 30) {
        clearInterval(apsWindowMoveTimerId);
        this.apsWindowMoveTimer = -1;
      }
    }, 2000);
    apsWindowMoveTimerId = this.apsWindowMoveTimer;
  }

  onDragStartEvent(param?: sceneSessionManager.SessionEventParam) {
    this.isStartDrag = true;
    this.sceneSession?.saveSessionMovingState(true);
    let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
    this.apsWindowDragBegin();
    this.sceneSession.sessionData.isDragging = true;
    sessionChangeInfo.persistentIds.push(this.sceneSession.sceneInfo.persistentId);
    sessionChangeInfo.curScreenId = this.sceneSession.sceneInfo.screenId;
    SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.DRAG_START, sessionChangeInfo);
    if (!this.sceneSession) {
      log.showError('onEventDragStart with sceneSession null');
      return;
    }
    log.showInfo(`onEventDragStart called: get resizeType = ${param?.dragResizeType}}`);
    let resizeType = sceneSessionManager.DragResizeType.RESIZE_TYPE_UNDEFINED;
    if (param?.dragResizeType !== undefined) {
      resizeType = param.dragResizeType as sceneSessionManager.DragResizeType;
    }
    log.showInfo(`onEventDragStart called: final resizeType = ${resizeType}}`);
    if (resizeType === sceneSessionManager.DragResizeType.RESIZE_EACH_FRAME) {
      return;
    } else if (resizeType === sceneSessionManager.DragResizeType.RESIZE_WHEN_DRAG_END && param) {
      this.dragPosition = this.getPosition();
      this.dragSize = this.getSize();
      this.dragStartPosition = {
        x: param.pointerX,
        y: param.pointerY
      };
      this.dragStartSize = {
        width: param.sessionWidth,
        height: param.sessionHeight
      }
      this.sceneSession.isSessionResizeWhenDragEnd = true;
    } else {
      log.showError(`get bad resizeType: ${resizeType}`);
      return;
    }
  }

  onEventDrag(param?: sceneSessionManager.SessionEventParam) {
    this.updateDragRect(param);
  }

  private updateDragRect(param?: sceneSessionManager.SessionEventParam): void {
    if (!param) {
      log.showError('onDrag get no param');
      return;
    }
    if (param.sessionWidth === 0 || param.sessionHeight === 0) {
      log.showWarn('onDrag get wrong parm, skip');
      return;
    }
    if (this.dragStartPosition === null || this.dragStartSize === null) {
      log.showWarn('drag start info not set, skip');
      return;
    }
    let dragPosition: Position = {
      x: this.dragStartPosition.x,
      y: this.dragStartPosition.y
    };
    let dragSize: SizeOptions = {
      width: this.dragStartSize.width,
      height: this.dragStartSize.height
    }
    this.updateDragPositionSize(dragPosition, dragSize, param);
    this.dragPosition = {
      x: dragPosition.x,
      y: dragPosition.y,
    };
    this.dragSize = {
      width: dragSize.width,
      height: dragSize.height,
    };
  }

  private updateDragPositionSize(dragPosition: Position, dragSize: SizeOptions,
    param: sceneSessionManager.SessionEventParam) : void {
    if (!dragSize || !param || !dragPosition || dragPosition.x === undefined || dragPosition.y === undefined) {
      log.showError('drag param invalid');
      return;
    }
    if (Math.abs(param.pointerX - (dragPosition.x as number)) >= 1) {
      // 左
      dragPosition.x = param.pointerX;
      if (param.pointerX <= 0) {
        dragPosition.x = 0;
        dragSize.width = param.sessionWidth + param.pointerX;
      } else if (param.pointerX >= this.screenProperty.width - RESIZE_WHEN_DRAG_END_LINE_WIDTH) {
        dragPosition.x = this.screenProperty.width - RESIZE_WHEN_DRAG_END_LINE_WIDTH;
        dragSize.width = param.sessionWidth + (param.pointerX - dragPosition.x);
      } else {
        dragSize.width = param.sessionWidth;
      }
    } else {
      // 右且有更新
      if (Math.abs(param.sessionWidth - (dragSize.width as number)) >= 1) {
        if (param.pointerX < 0 && param.sessionWidth + param.pointerX < RESIZE_WHEN_DRAG_END_LINE_WIDTH) {
          // 限制拖拽超出左屏幕边
          dragSize.width = RESIZE_WHEN_DRAG_END_LINE_WIDTH - param.pointerX;
        } else {
          dragSize.width = Math.min(this.screenProperty.width - (dragPosition.x as number), param.sessionWidth);
        }
      }
    }
    if (Math.abs(param.pointerY - (dragPosition.y as number)) >= 1) {
      // 上
      dragPosition.y = param.pointerY;
      if (param.pointerY <= 0) {
        dragPosition.y = 0;
        dragSize.height = param.sessionHeight + param.pointerY;
      } else if (param.pointerY >= this.screenProperty.height - RESIZE_WHEN_DRAG_END_LINE_WIDTH) {
        dragPosition.y = this.screenProperty.height - RESIZE_WHEN_DRAG_END_LINE_WIDTH;
        dragSize.height = param.sessionHeight + (param.pointerY - dragPosition.y);
      } else {
        dragSize.height = param.sessionHeight;
      }
    } else {
      // 下且有更新
      if (param.pointerY < 0 && param.sessionHeight + param.pointerY < RESIZE_WHEN_DRAG_END_LINE_WIDTH) {
        // 限制拖拽超出上屏幕边
        dragSize.height = RESIZE_WHEN_DRAG_END_LINE_WIDTH - param.pointerY;
      } else {
        if (Math.abs(param.sessionHeight - (dragSize.height as number)) >= 1) {
          dragSize.height = Math.min(this.screenProperty.height - (dragPosition.y as number), param.sessionHeight);
        }
      }
    }
    log.showDebug(`updateDragPositionSize [${dragPosition.x} ${dragPosition.y} ${dragSize.width} ${dragSize.height}]`);
  }

  private apsWindowMoveBegin(): void {
    let apsSendTimes: number = 0;
    let apsWindowMoveTimerId: number = -1;
    // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MOVE, StyleConstants.DEFAULT_1);
    this.apsWindowMoveTimer = setInterval(() => {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MOVE, StyleConstants.DEFAULT_1);
      // If the timer exceeds 60 seconds, the timer is disabled.
      apsSendTimes++;
      if (apsSendTimes >= 30) {
        clearInterval(apsWindowMoveTimerId);
        this.apsWindowMoveTimer = -1;
      }
    }, 2000);
    apsWindowMoveTimerId = this.apsWindowMoveTimer;
  }

  private isWindowLimitsValid(windowLimits: sceneSessionManager.WindowLimits ): boolean {
    if (windowLimits && windowLimits.minWidth > 0 && windowLimits.minHeight > 0 &&
        windowLimits.maxWidth > 0 && windowLimits.maxHeight > 0 &&
        windowLimits.maxWidth > windowLimits.minWidth &&
        windowLimits.maxHeight > windowLimits.minHeight) {
      return true;
    }
    return false;
  }

  private getWindowLimits(): sceneSessionManager.WindowLimits | null {
    try {
      const persistentId = this.sceneSession.session.persistentId;
      let windowLimits: sceneSessionManager.WindowLimits = sceneSessionManager.getWindowLimits(persistentId);
      return windowLimits;
    } catch (err) {
      log.showError(`getWindowlimits error: ${err?.message}`);
      return null;
    }
  }

  onSessionRectChange(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason,
    displayId: number) {
    if (!this.sceneSession) {
      log.showError('sceneSession is null');
      return;
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END &&
      this.sceneSession.isSessionResizeWhenDragEnd) {
      log.showInfo('block by isSessionResizeWhenDragEnd is true, update by onMoveEnd');
      return;
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE_BY_LIMIT) {
      let windowLimits: sceneSessionManager.WindowLimits | null = this.getWindowLimits();
      if (windowLimits && this.isWindowLimitsValid(windowLimits)) {
        let width = this.currRect.width.getPx();
        let height = this.currRect.height.getPx();
        if (width >= windowLimits.minWidth && width <= windowLimits.maxWidth &&
          height >= windowLimits.minHeight && height <= windowLimits.maxHeight) {
          log.showInfo('onSessionRectChange return, rect size inside limit, ' +
            `id: ${this.sceneSession.session.persistentId}, reason: ` +
            `${reason}, rect: ${this.currRect.printPx()}, minWidth: ${windowLimits.minWidth}, minHeight: ` +
            `${windowLimits.minHeight}, maxWidth: ${windowLimits.maxWidth}, maxHeight: ${windowLimits.maxHeight}`);
          return;
        } else {
          reason = sceneSessionManager.SessionSizeChangeReason.RESIZE;
          log.showInfo('onSessionRectChange resize by limit, rect size exceed limit, ' +
            `id: ${this.sceneSession.session.persistentId}, ` +
            `reason: ${reason}, rect: ${this.currRect.printPx()}, minWidth: ${windowLimits.minWidth}, minHeight: ` +
            `${windowLimits.minHeight}, maxWidth: ${windowLimits.maxWidth}, maxHeight: ${windowLimits.maxHeight}`);
        }
      } else {
        reason = sceneSessionManager.SessionSizeChangeReason.RESIZE;
        log.showInfo('windowLimits is invalid');
      }
    } else {
      log.showInfo('reason is not RESIZE_BY_LIMIT');
    }
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN &&
      reason === sceneSessionManager.SessionSizeChangeReason.MOVE && this.sceneSession.isRecoveredFullScreen) {
      log.showInfo('recovered fullscreen sceneSession cannot move');
      return;
    }
    if ((this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN ||
      this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY ||
      this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) &&
      reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
      log.showInfo('fullscreen or split sceneSession cannot resize');
      return;
    }
    let originalPosY = this.currRect.top.getPx();
    let area = this.initAvoidanceArea(reason, rect, displayId);
    this.updateAvoidanceArea(area, reason);

    // When drag to other screen, using 'animateTo' to update rect immediately rather then next vSync to avoid blink.
    let uiContext: UIContext = this.getUIContext();
    const targetRect = new SCBSessionRect(area.targetPositionX, area.targetPositionY,
      area.targetWidth, area.targetHeight);
    if (uiContext && this.sceneSession.isCrossingScreen ||
      reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END &&
        (this.currRect.equalsOfSize(targetRect) || !this.sceneSession.isInSplit())) {
      uiContext.animateTo({
        duration: 0
      }, () => {
        this.updateCurrentRect(area);
      })
    } else {
      this.updateCurrentRect(area);
    }

    this.notifySubSessionEvent(reason);
    let windowDragHotAreaType =
      this.sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0;
    log.showInfo(`onSessionRectChange end, id: ${this.sceneSession.session.persistentId}, reason: ${reason}, ` +
      `rect: [${this.currRect.left.getPx()}, ${this.currRect.top.getPx()}, ${area.targetWidth}, ` +
      `${area.targetHeight}], pendingModeTransition: ${windowDragHotAreaType}`);

    // Drag the window into split screen
    if (reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END &&
      this.onWindowDragHotAreaTriggered(windowDragHotAreaType, displayId, originalPosY)) {
      this.sceneSession.sessionData.windowDragHotAreaTypeMap
        .set(this.screenProperty.screenId, DEFAULT_PENDING_MODE_TRANSITION);
      return;
    }
    this.sceneSession.sessionData.lastDpi = this.getScreenDpiDensity();
    this.springBackIfNeeded();
    this.onSceneRectChange();
  }

  private updateCurrentRect(area: SessionSafeArea) {
    if ((area.targetPositionX !== this.currRect.left.getPx()) ||
      (area.targetPositionY !== this.currRect.top.getPx())) {
      this.sceneSession.currRect.setPosNum(area.targetPositionX, area.targetPositionY);
    }
    if ((area.targetWidth !== this.currRect.width.getPx()) ||
      (area.targetHeight !== this.currRect.height.getPx())) {
      this.sceneSession.currRect.setSizeNum(area.targetWidth, area.targetHeight);
    }
  }

  private initAvoidanceArea(reason: sceneSessionManager.SessionSizeChangeReason,
                            rect: sceneSessionManager.SessionRect, displayId: number): SessionSafeArea {
    let safeArea: SessionSafeArea = new SessionSafeArea();
    safeArea.targetPositionX = this.currRect.left.getPx();
    safeArea.targetPositionY = this.currRect.top.getPx();
    safeArea.targetWidth = this.currRect.width.getPx();
    safeArea.targetHeight = this.currRect.height.getPx();
    let windowDragHotAreaType =
      this.sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0;
    log.showInfo(`onSessionRectChange start, id: ${this.sceneSession.session.persistentId}, reason: ${reason}, ` +
      `newRect: [${rect.posX_}, ${rect.posY_}, ${rect.width_}, ${rect.height_}], ` +
      `currRect: ${this.currRect.printPx()}, pendingModeTransition: ${windowDragHotAreaType}`);
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      safeArea.targetPositionX = rect.posX_;
      safeArea.targetPositionY = rect.posY_;
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
      safeArea.targetWidth = rect.width_;
      safeArea.targetHeight = rect.height_;
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END && displayId !== INVALID_SCREEN_ID) {
      // 跨屏场景已在SCBPcScenePanelManager里处理
      log.showInfo(`initAvoidanceArea cross screen drag`);
    } else {
      safeArea.targetPositionX = rect.posX_;
      safeArea.targetPositionY = rect.posY_;
      safeArea.targetWidth = rect.width_;
      safeArea.targetHeight = rect.height_;
    }
    return safeArea;
  }

  private playMaximizeAnimation(): void {
    if (this.sceneSession.needMaxWithoutAnim) {
      this.sceneSession.initSceneState();
      // on finish
      setTimeout(() => {
        this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = false;
        performanceMonitor.end('WINDOW_TITLE_BAR_MAXIMIZED');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MAX, StyleConstants.DEFAULT_0);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_WINDOW_FULL_SCREEN);
      }, 0);
    }
    this.getUIContext()?.animateTo({
      duration: 0,
      onFinish: () => {
        this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = false;
        performanceMonitor.end('WINDOW_TITLE_BAR_MAXIMIZED');
        // ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MAX, StyleConstants.DEFAULT_0);
        systemAniSceneCtrl.dequeue(SystemAnimatedScene.ENTER_WINDOW_FULL_SCREEN);
        this.needTrackSplitState.setState(SplitState.UNDEFINED);
      },
    }, () => {
      this.sceneSession.initSceneState();
    })
  }

  private updateAvoidanceArea(safeArea: SessionSafeArea, reason: sceneSessionManager.SessionSizeChangeReason): void {
    const screenWidth = this.screenProperty.width;
    const screenId = this.screenProperty.screenId;
    // top area
    let topThreshold = this.getTopThreshold(this.sceneSession?.sceneInfo.screenId);
    if (safeArea.targetPositionY < topThreshold && reason != sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
      log.showDebug(`onSessionRectChange, reaching top threshold: ${topThreshold}`);
      safeArea.targetPositionY = topThreshold;
      if (Math.floor(safeArea.targetPositionY) !== Math.floor(topThreshold)) {
        safeArea.targetHeight = this.currRect.height.getPx();
      }
    }
    // bottom area
    let titleHeight = this.getTitleActualHeight();
    let bottomThreshold = this.getBottomThreshold(titleHeight, screenId);
    if (safeArea.targetPositionY > bottomThreshold && reason != sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
      log.showDebug(`onSessionRectChange, reaching bottom threshold: ${bottomThreshold}`);
      safeArea.targetPositionY = bottomThreshold;
      safeArea.targetHeight = this.currRect.height.getPx();
    }
    // left area
    const leftThreshold = vp2px(StyleConstants.DEFAULT_AVOID_AREA);
    if (safeArea.targetPositionX + safeArea.targetWidth < leftThreshold) {
      log.showDebug(`onSessionRectChange, reaching left threshold: ${leftThreshold}`);
      safeArea.targetPositionX = leftThreshold - safeArea.targetWidth;
    }
    // right area
    const rightThreshold = screenWidth - vp2px(StyleConstants.DEFAULT_AVOID_AREA);
    if (safeArea.targetPositionX > rightThreshold) {
      log.showDebug(`onSessionRectChange, reaching right threshold: ${rightThreshold}`);
      safeArea.targetPositionX = rightThreshold;
    }
  }

  private getTopThreshold(screenId: number): number {
    let topThreshold = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar && viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)) {
      topThreshold = statusBar.currRect.height.getPx() + statusBar.currRect.top.getPx();
    }
    return topThreshold;
  }

  private getDockHeight(screenId: number): number {
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    let mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    if (dock && screenId === mainScreenId && viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK)) {
      dockHeight = dock.currRect.height.getPx();
    }
    if (dock && screenId !== mainScreenId && viewMgrPolicy.isViewShowing(ViewType.SMART_DOCK_EXT_SCREEN)) {
      dockHeight = dock.currRect.height.getPx();
    }
    return dockHeight;
  }

  private getBottomThreshold(titleHeight: number, screenId: number): number {
    let screenHeight = this.screenProperty.height;
    let dockHeight = this.getDockHeight(screenId);
    let bottomThreshold = screenHeight - titleHeight - dockHeight;
    return bottomThreshold;
  }

  private getTouchPointY(): number {
    let lastTouchPointY = this.sceneSession.startMovePointerPos.pointerPosY;
    let windowDisplacement = this.currRect.top.getPx() - this.sceneSession.lastRect.top.getPx();
    let curTouchPointY = lastTouchPointY + windowDisplacement;
    return curTouchPointY;
  }

  private getTitleActualHeight(): number {
    let titleHeight = StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT;
    try {
      const customDecorHeight = sceneSessionManager.getCustomDecorHeight(this.sceneSession?.session.persistentId);
      if (customDecorHeight !== 0 && customDecorHeight !== titleHeight) {
        titleHeight = customDecorHeight;
      }
    } catch (error) {
      log.showError(`get customDecorHeight failed, error: ${error}`);
    }
    return this.getScreenDpiDensity() / BASE_DENSITY * titleHeight;
  }

  private springBackIfNeeded(): void {
    if (!this.sceneSession) {
      log.showError('springBackIfNeeded sceneSession is null');
      return;
    }
    let screenWidth = this.screenProperty.width;
    const screenId = this.screenProperty.screenId;
    let titleHeight = this.getTitleActualHeight();
    let topThreshold = this.getTopThreshold(screenId);
    let bottomThreshold = this.getBottomThreshold(titleHeight, screenId);
    let leftThreshold = vp2px(StyleConstants.DEFAULT_AVOID_AREA);
    let rightThreshold = screenWidth - vp2px(StyleConstants.DEFAULT_AVOID_AREA);
    let currRect = this.currRect;
    let safePos = new SessionSafeArea();
    safePos.targetPositionX = currRect.left.getPx();
    safePos.targetPositionY = currRect.top.getPx();

    this.getSafePositionY(currRect, topThreshold, bottomThreshold, safePos);
    this.getSafePositionX(currRect, leftThreshold, rightThreshold, safePos);
    if (safePos.targetPositionX !== currRect.left.getPx() || safePos.targetPositionY !== currRect.top.getPx()) {
      log.showInfo(`springBackWithAnimation, targetPositionX: ${safePos.targetPositionX}, ` +
        `targetPositionY: ${safePos.targetPositionY}`);
      this.springBackWithAnimation(safePos.targetPositionX, safePos.targetPositionY);
    }
  }

  private getSafePositionY(currRect: SCBSessionRect, topThreshold: number, bottomThreshold: number,
    safePos: SessionSafeArea): void {
    if (currRect.top.getPx() < topThreshold) {
      safePos.targetPositionY = topThreshold;
    }
    if (currRect.top.getPx() > bottomThreshold) {
      safePos.targetPositionY = bottomThreshold;
    }
  }

  private getSafePositionX(currRect: SCBSessionRect, leftThreshold: number, rightThreshold: number,
    safePos: SessionSafeArea): void {
    if (currRect.left.getPx() + currRect.width.getPx() < leftThreshold) {
      safePos.targetPositionX = leftThreshold - this.currRect.width.getPx();
    }
    if (currRect.left.getPx() > rightThreshold) {
      safePos.targetPositionX = rightThreshold;
    }
  }

  private springBackWithAnimation(positionX: number, positionY: number): void {
    this.getUIContext()?.animateTo({ curve: Curve.EaseOut, duration: 200 }, () => {
      log.showInfo(`springBackWithAnimation, PositionX: ${positionX} PositionY: ${positionY}`);
      this.currRect.setPosNum(positionX, positionY);
      this.notifySubSessionEvent(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
    })
  }

  onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.sceneSession?.setTouchable(isTouchable);
  }

  private onClickModalWindowOutside(): void {
    animateTo(
      {
        duration: 10,
        curve: Curve.Linear,
      }, () => {
      this.sceneSession.translateX += 1;
    });
    animateTo(
      {
        delay: 10,
        duration: 1000,
        curve: curves.interpolatingSpring(300, 1, 428, 13),
      }, () => {
      this.sceneSession.translateX -= 1;
    });
  }

  onWindowDragHotArea(windowDragHotAreaType: number, reason: sceneSessionManager.SessionSizeChangeReason,
                      rect: sceneSessionManager.SessionRect) {
    log.showInfo(`window drag hot area callback, reason:${reason}, windowDragHotAreaType:${windowDragHotAreaType}, ` +
      `posX:${rect.posX_}, posY_:${rect.posY_}, width:${rect.width_}, height:${rect.height_}, ` +
      `screenId:${this.screenProperty.screenId}`);
    if (reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END &&
      (this.isTouchSplitDragHotArea(windowDragHotAreaType) ||
      this.isTouchFloatingDragHotArea(windowDragHotAreaType))) {
      this.sceneSession.sessionData.windowDragHotAreaTypeMap.set(this.screenProperty.screenId, windowDragHotAreaType);
      return;
    }

    if (this.sceneSession?.isInSplit() && reason === sceneSessionManager.SessionSizeChangeReason.DRAG_MOVE) {
      this.onWindowSplitDragHotArea(windowDragHotAreaType);
    }

    let isMultiScreen: boolean = SCBScreenSessionManager.getInstance().getScreenSessionList().length > 1;
    if (this.sceneSession?.sceneInfo.windowMode === SCBSceneMode.FLOATING &&
      reason === sceneSessionManager.SessionSizeChangeReason.DRAG_MOVE) {
      if (this.isFullScreenStartMove &&
        (this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_TOP, windowDragHotAreaType))) {
        this.isFullScreenStartMove = false;
      } else {
        if (this.isTouchFloatingDragHotArea(windowDragHotAreaType)) {
          if (isMultiScreen) {
            if (this.maskAppearTimerId === INVALID_TIMER_ID) {
              log.showInfo(`onWindowDragHotArea start maskAppearTimer`);
              this.maskAppearTimerId = setTimeout(() => {
                this.maskToAppear(windowDragHotAreaType, rect);
                this.maskAppearTimerId = INVALID_TIMER_ID;
              }, 300);
            }
          } else {
            this.maskToAppear(windowDragHotAreaType, rect);
          }
        } else {
          this.maskToDisAppear();
          if (this.maskAppearTimerId !== INVALID_TIMER_ID) {
            clearTimeout(this.maskAppearTimerId);
            this.maskAppearTimerId = INVALID_TIMER_ID;
          }
        }
      }
    }

    this.sceneSession.sessionData.windowDragHotAreaTypeMap.set(this.screenProperty.screenId, windowDragHotAreaType);
  }

  private onWindowSplitDragHotArea(windowDragHotAreaType: number): void {
    if (!this.isLastDragHotType(WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT) &&
    this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT, windowDragHotAreaType)) {
      this.onSplitPartnerMoveEvent(this.sceneSession?.sceneInfo.persistentId, SCBSessionEventId.EVENT_SPLIT_SWITCH);
    }

    if (this.isLastDragHotType(WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT) &&
      !this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT, windowDragHotAreaType)) {
      this.onSplitPartnerMoveEvent(this.sceneSession?.sceneInfo.persistentId,
        SCBSessionEventId.EVENT_SPLIT_POSITION_RECOVER);
    }

    if (this.isLastDragHotType(WindowDragHotAreaType.HOT_AREA_TYPT_REDUCE_SPLIT) &&
      !this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_REDUCE_SPLIT, windowDragHotAreaType)) {
      this.onSplitPartnerMoveEvent(this.sceneSession?.sceneInfo.persistentId,
        SCBSessionEventId.EVENT_SPLIT_STATE_RESTORATION);
    }
  }

  private initAnimatePara(actionId: SCBSessionEventId) {
    const currentWidth = this.currRect.width.getPx();
    const currentHeight = this.currRect.height.getPx();
    const currentLeft = this.currRect.left.getPx() - (this.sceneSession.scaleX - 1) * currentWidth / 2;
    const currentTop = this.currRect.top.getPx() - (this.sceneSession.scaleY - 1) * currentHeight / 2;
    if (actionId == SCBSessionEventId.EVENT_RECOVER) {
      let statusBarHeight: number = 0;
      const topArea: ViewArea = viewMgrPolicy.getArea(ViewType.STATUS_BAR);
      if (topArea !== undefined) {
        statusBarHeight = styleMgr.vp2pxStatusBarPCHeight();
      }
      const dockHeight = AppStorage.get('dockHeight') as number;
      let lastLeft = this.sceneSession.lastRect.left.getPx();
      let lastTop = this.sceneSession.lastRect.top.getPx();
      let lastWidth = this.sceneSession.lastRect.width.getPx();
      let lastHeight = this.sceneSession.lastRect.height.getPx();
      const lastDpi: number = this.sceneSession.sessionData.lastDpi;
      const currentDpi: number = this.getScreenDpiDensity();
      if (lastDpi != -1 && lastDpi != currentDpi) {
        lastWidth = lastWidth / lastDpi * currentDpi;
        lastHeight = lastHeight / lastDpi * currentDpi;
        if (lastWidth > this.screenProperty.width) {
          lastWidth = this.screenProperty.width;
        }
        if ((lastHeight > (this.screenProperty.height - statusBarHeight - vp2px(dockHeight))) &&
          !sSCBOobeManager.isOobeActivated()) {
          lastHeight = this.screenProperty.height - statusBarHeight - vp2px(dockHeight);
        }
        if (lastTop + lastHeight > this.screenProperty.height - vp2px(dockHeight)) {
          lastTop = this.screenProperty.height - vp2px(dockHeight) - lastHeight;
        }
        if (lastLeft + lastWidth > this.screenProperty.width) {
          lastLeft = this.screenProperty.width - lastWidth;
        }
      }
      const sessionLeft = currentLeft +
        0.5 * (1 - this.sceneSession.scaleX) * currentWidth + vp2px(this.sceneSession.translateX);
      const sessionTop = currentTop +
        0.5 * (1 - this.sceneSession.scaleY) * currentHeight + vp2px(this.sceneSession.translateY);
      const sessionWidth = currentWidth * this.sceneSession.scaleX;
      const sessionHeight = currentHeight * this.sceneSession.scaleY;
      if (!AppStorage.get('isLock')) {
        this.sceneSession.scaleX = sessionWidth / lastWidth;
        this.sceneSession.scaleY = sessionHeight / lastHeight;
        this.sceneSession.resetAnimationProperty();
        this.sceneSession.translateX = px2vp(sessionLeft - (lastLeft + 0.5 * (lastWidth - sessionWidth)));
        this.sceneSession.translateY = px2vp(sessionTop - (lastTop + 0.5 * (lastHeight - sessionHeight)));
      }
      this.sceneSession.currRect.setRectNum(lastLeft, lastTop, lastWidth, lastHeight);
      log.showInfo(`recover rect: [${lastLeft}, ${lastTop}, ${lastWidth}, ${lastHeight}]`);
    } else if (actionId == SCBSessionEventId.EVENT_SPLIT_PRIMARY) {
      const sessionRect: SCBSessionRect =
        LayoutPolicyHelper.getInstance().getSplitInitialRect(this.screenProperty, this.dividerParam, true);
      const width: number = sessionRect.width.getPx();
      const height: number = sessionRect.height.getPx();
      const top: number = sessionRect.top.getPx();
      this.sceneSession.scaleX = currentWidth / width * this.sceneSession.scaleX;
      this.sceneSession.scaleY = currentHeight / height * this.sceneSession.scaleY;
      this.sceneSession.resetAnimationProperty();
      this.sceneSession.currRect.copyFrom(sessionRect);
      this.sceneSession.translateX =
        px2vp(currentLeft) - (1 - this.sceneSession.scaleX) * this.getScaleCenterX();
      this.sceneSession.translateY =
        px2vp(currentTop - top) - (1 - this.sceneSession.scaleY) * this.getScaleCenterY();
      log.showInfo(`split primary rect: [${this.currRect.left.getPx()}, ${this.currRect.top.getPx()}, ` +
        `${this.currRect.width.getPx()}, ${this.currRect.height.getPx()}]`);
    } else if (actionId == SCBSessionEventId.EVENT_SPLIT_SECONDARY) {
      const sessionRect: SCBSessionRect =
        LayoutPolicyHelper.getInstance().getSplitInitialRect(this.screenProperty, this.dividerParam, false);
      const width: number = sessionRect.width.getPx();
      const height: number = sessionRect.height.getPx();
      const left: number = sessionRect.left.getPx();
      const top: number = sessionRect.top.getPx();
      this.sceneSession.scaleX = currentWidth / width * this.sceneSession.scaleX;
      this.sceneSession.scaleY = currentHeight / height * this.sceneSession.scaleY;
      this.sceneSession.resetAnimationProperty();
      this.sceneSession.currRect.copyFrom(sessionRect);
      this.sceneSession.translateX =
        px2vp(currentLeft - left) - (1 - this.sceneSession.scaleX) * this.getScaleCenterX();
      this.sceneSession.translateY = px2vp(currentTop - top) - (1 - this.sceneSession.scaleY) * this.getScaleCenterY();
      log.showInfo(`split secondary rect: [${this.currRect.left.getPx()}, ${this.currRect.top.getPx()}, ` +
        `${this.currRect.width.getPx()}, ${this.currRect.height.getPx()}]`);
    } else {
      log.showInfo('do nothing in actionId:' + actionId)
    }
  }

  private notifySubSessionEvent(reason: sceneSessionManager.SessionSizeChangeReason): void {
    this.sceneSession.subSessionList.forEach((item) => {
      item.notifyParentRectChange(this.sceneSession.currRect, reason, this.sceneSession.sceneInfo.screenId);
    });
  }

  private setCommonAnimate(isImmersiveChange: boolean = false) {
    this.sceneSession.needRenderSnapShotAnimConfig.animVisible = true;
    this.sceneSession.needRenderSnapShotAnimConfig.animSceneAlpha = 1;
    this.getUIContext()?.animateTo({
      duration: 0,
      onFinish: () => {
        this.sceneSession.needRenderSnapShotAnimConfig.animVisible = false;
        this.sceneSession.needRenderSnapShotAnimConfig.animSnapshot = undefined;
        this.sceneSession.needRenderSnapShotAnimConfig.animActionId = 0;
      }
    }, () => {
      this.sceneSession.needRenderSnapShotAnimConfig.animSceneAlpha = 0;
    });
  }

  private onWindowDragHotAreaTriggered(windowDragHotAreaType: number, displayId: number, posY: number): boolean {
    log.showInfo(`onWindowDragHotAreaTriggered start, windowDragHotAreaType is: ${windowDragHotAreaType}, ` +
      `maskAppearTimerId: ${this.maskAppearTimerId}`);
    if (this.handleFloatingWindowDragHotAreaTriggered(windowDragHotAreaType) ||
      this.handleSplitWindowDragHotAreaTriggered(windowDragHotAreaType, displayId, posY)) {
      return true;
    }
    return false;
  }

  private getWindowState(topPx: number): number {
    let windowState: number = WindowPosition.NOT_BIG_SCREEN_DEVICE;
    return windowState;
  }

  private handleFloatingWindowDragHotAreaTriggered(windowDragHotAreaType: number): boolean {
    if (this.sceneSession.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
      return false;
    }
    clearInterval(this.apsWindowMoveTimer);
    this.apsWindowMoveTimer = -1;
    /*if (this.isStartDrag) {
      ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_DRAG, StyleConstants.DEFAULT_2);
    } else if (this.isStartMove) {
      ApsUtils.setApsScene(apsManager.SceneAnimation.WINDOW_MOVE, StyleConstants.DEFAULT_2);
    }*/
    if (AppStorage.get('isLock') && this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea) {
      log.showWarn(`handleFloatingWindowDragHotAreaTriggered is interrupted and reverting`);
      this.needRenderDragHotAreaAnimConfig.isWindowDragHotArea = false;
      this.onRecoverWhenLock();
      return false;
    }

    // If timerId exists, the mask appear animation is not triggered.
    if (this.maskAppearTimerId !== INVALID_TIMER_ID) {
      clearTimeout(this.maskAppearTimerId);
      this.maskAppearTimerId = INVALID_TIMER_ID;
      this.sceneSession.sessionData.windowDragHotAreaTypeMap
        .set(this.screenProperty.screenId, DEFAULT_PENDING_MODE_TRANSITION);
      return false;
    }

    this.sceneSession.updateDragHotAreaAnimConfigNotInCurrentScreen(false, this.screenProperty.screenId);

    if (this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_TOP, windowDragHotAreaType) &&
        this.sceneSession.isSupportFullScreenMode()) {
      if (SCBSceneSessionManager.getInstance().isNeedMaximizeFloating()) {
        sceneSessionManager.updateWindowMode(this.sceneSession.session.persistentId, SCBSceneMode.FLOATING);
        this.sceneSession.maximizeFloating();
        sceneSessionManager.updateMaximizeMode(this.sceneSession.session.persistentId, true);
      } else {
        sceneSessionManager.updateWindowMode(this.sceneSession.session.persistentId, SCBSceneMode.FULLSCREEN);
        SCBSceneSessionManager.getInstance().maximize(this.sceneSession.sceneInfo.screenId,
          this.sceneSession.session.persistentId);
        this.sceneSession.systemBarProperty.set(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
          new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR, false, '#00FFFFFF', '#FF000000'));
        SCBSceneSessionManager.getInstance().updateSystemBarProperty();
        sceneSessionManager.updateMaximizeMode(this.sceneSession.session.persistentId, false);
      }
      let state: number = this.getWindowState(this.sceneSession.currRect.top.getPx());
      HiSysEventUtil.reportWinDragToHotarea(this.sceneSession.sceneInfo.bundleName, 3, state);
      return true;
    }
    if (this.handleFloatingWindowDragHotAreaSplitTriggered(windowDragHotAreaType)) {
      return true;
    }
    return false;
  }

  private handleFloatingWindowDragHotAreaSplitTriggered(windowDragHotAreaType: number): boolean {
    if (this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_LEFT, windowDragHotAreaType) &&
      this.sceneSession.isSupportSplitMode()) {
      SCBSceneSessionManager.getInstance()
        .splitPrimary(this.sceneSession.sceneInfo.screenId, this.sceneSession.session.persistentId);
      let state: number = this.getWindowState(this.sceneSession.currRect.top.getPx());
      HiSysEventUtil.reportWinDragToHotarea(this.sceneSession.sceneInfo.bundleName, 1, state);
      return true;
    }

    if (this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT, windowDragHotAreaType) &&
      this.sceneSession.isSupportSplitMode()) {
      SCBSceneSessionManager.getInstance()
        .splitSecondary(this.sceneSession.sceneInfo.screenId, this.sceneSession.session.persistentId);
      let state: number = this.getWindowState(this.sceneSession.currRect.top.getPx());
      HiSysEventUtil.reportWinDragToHotarea(this.sceneSession.sceneInfo.bundleName, 2, state);
      return true;
    }
    return false;
  }

  private handleSplitWindowDragHotAreaTriggered(windowDragHotAreaType: number, displayId: number,
    posY: number): boolean {
    if (!this.sceneSession?.isInSplit()) {
      return false;
    }
    this.onSplitPartnerMoveEvent(this.sceneSession?.sceneInfo.persistentId,
      SCBSessionEventId.EVENT_SPLIT_STATE_RESTORATION);
    // displayId不等于-1，表示拖拽分屏窗口到另一个屏幕，需要触发退出分屏
    if (((this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_EXIT_SPLIT, windowDragHotAreaType) ||
      (displayId !== INVALID_SCREEN_ID && displayId != this.screenProperty.screenId)) &&
      !this.dividerParam.isExpandUpDownSplit() ||
      !this.needVerticalMoveRecovery(windowDragHotAreaType, posY)) && this.sceneSession.isActive) {
      let action = new SCBGestureAction({
        id: SCBGestureActionId.EXIT_SPLIT,
        sessionId: this.sceneSession?.sceneInfo.persistentId
      });
      this.onGestureChange?.(action, displayId);
      this.dividerParam.splitMovingMode = SCBSceneMode.UNDEFINED;
      return true;
    }

    if (this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT, windowDragHotAreaType)) {
      SCBSceneSessionManager.getInstance()
        .switchSplitScene(this.sceneSession.sceneInfo.screenId, this.sceneSession.session.persistentId);
      return true;
    } else {
      this.onSplitPositionRecover();
      return true;
    }
  }

  private isTouchFloatingDragHotArea(windowDragHotAreaType: number): boolean {
    let flagOfDragHotAreaType = DEFAULT_PENDING_MODE_TRANSITION;
    if (this.sceneSession.isSupportFullScreenMode()) {
      flagOfDragHotAreaType |= WindowDragHotAreaType.HOT_AREA_TYPT_TOP;
    }
    if (this.sceneSession.isSupportSplitMode()) {
      flagOfDragHotAreaType |= WindowDragHotAreaType.HOT_AREA_TYPT_LEFT;
      flagOfDragHotAreaType |= WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT;
    }
    return this.isTouchDragHotArea(flagOfDragHotAreaType, windowDragHotAreaType);
  }

  private isTouchSplitDragHotArea(windowDragHotAreaType: number): boolean {
    const flagOfDragHotAreaType = WindowDragHotAreaType.HOT_AREA_TYPT_EXIT_SPLIT |
      WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT | WindowDragHotAreaType.HOT_AREA_TYPT_REDUCE_SPLIT;
    return this.isTouchDragHotArea(flagOfDragHotAreaType, windowDragHotAreaType);
  }

  private isTouchDragHotArea(hotAreaType: number, windowDragHotAreaType: number): boolean {
    return (hotAreaType & windowDragHotAreaType) !== DEFAULT_PENDING_MODE_TRANSITION;
  }

  private isLastDragHotType(windowDragHotAreaType: number): boolean {
    return ((this.sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0) &
      windowDragHotAreaType) === windowDragHotAreaType;
  }

  private onSplitPartnerMoving = (): void => {
    if (this.dividerParam.isExpandUpDownSplit()) {
      this.handleSplitVerticalOffset();
    } else {
      this.handleSplitHorizontalOffset();
    }
  }

  private handleSplitHorizontalOffset(): void {
    const offsetX = this.sceneSession.currMovePointerPos.pointerPosX -
      this.sceneSession.startMovePointerPos.pointerPosX;
    let overlapWidth: number = 0;
    let tran: number = 0;
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      overlapWidth = - offsetX - vp2px(DividerStyle.DIVIDER_WIDTH);
      tran = 1;
    } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
      overlapWidth = offsetX - vp2px(DividerStyle.DIVIDER_WIDTH);
      tran = -1;
    }

    if (overlapWidth > 0) {
      if (overlapWidth < this.sceneSession.currRect.width.getPx() / 2) {
        const scale = MASK_SPLIT_SWITCHING_SCALE + (1 - MASK_SPLIT_SWITCHING_SCALE) *
          (1 - (overlapWidth * 2 / this.sceneSession.currRect.width.getPx()));
        tran = tran * (1 - MASK_SPLIT_SWITCHING_SCALE) * overlapWidth;
        if (Math.abs(vp2px(this.sceneSession.translateX) - tran) > 1) {
          this.getUIContext()?.animateTo({ duration: 150 }, () => {
            this.sceneSession.setScale(scale, scale);
            this.sceneSession.setTran(px2vp(tran), 0);
          })
        }
      }
    } else if (this.sceneSession.translateX !== 0) {
      this.sceneSession.setTran(0, 0);
      this.sceneSession.setScale(1, 1);
    }
  }

  private handleSplitVerticalOffset(): void {
    const pointerY: number = this.sceneSession.currMovePointerPos.pointerPosY;
    const offsetY = pointerY - this.sceneSession.startMovePointerPos.pointerPosY;
    let overlapHeight: number = 0;
    let tran: number = 0;

    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      overlapHeight = - offsetY - vp2px(DividerStyle.DIVIDER_WIDTH);
      tran = 1;
    } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
      overlapHeight = offsetY - vp2px(DividerStyle.DIVIDER_WIDTH);
      tran = -1;
    }

    if (overlapHeight > 0) {
      if (overlapHeight < this.sceneSession.currRect.height.getPx() / 2) {
        const scale = MASK_SPLIT_SWITCHING_SCALE + (1 - MASK_SPLIT_SWITCHING_SCALE) *
          (1 - (overlapHeight * 2 / this.sceneSession.currRect.height.getPx()));
        tran = tran * (1 - MASK_SPLIT_SWITCHING_SCALE) * overlapHeight;
        if (Math.abs(vp2px(this.sceneSession.translateY) - tran) > 1) {
          this.getUIContext()?.animateTo({ duration: 150 }, () => {
            this.sceneSession.setScale(scale, scale);
            this.sceneSession.setTran(0, px2vp(tran));
          })
        }
      }
    } else if (this.sceneSession.translateX !== 0) {
      this.sceneSession.setTran(0, 0);
      this.sceneSession.setScale(1, 1);
    }
  }

  private needVerticalMoveRecovery(windowDragHotAreaType: number, originalPosY: number): boolean {
    if (!this.dividerParam.isExpandUpDownSplit() ||
    this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_SWITCH_SPLIT, windowDragHotAreaType)) {
      return true;
    }
    const endPosY = this.currRect.top.getPx() - originalPosY + this.sceneSession.startMovePointerPos.pointerPosY;
    const exitDistance = (this.getSplitHeightPx(true) + this.getSplitHeightPx(false) +
      vp2px(DividerStyle.DIVIDER_WIDTH)) * SPLIT_VERTICAL_MOVE_EXIT_RATIO;
    if (this.sceneSession.isInSplit()) {
      return endPosY <= this.sceneSession.startMovePointerPos.pointerPosY + exitDistance ||
        this.sceneSession.moveFarthestPointY - endPosY >= vp2px(SPLIT_VERTICAL_MOVE_RECOVER_DISTANCE);
    }
    return true;
  }

  private getBoardRadiusInRecent(radius: number): BorderRadiuses {
    let radiuses: BorderRadiuses = {
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius
    };
    if (!this.dividerParam.isSplitRecentPair) {
      if (this.dividerParam.isExpandUpDownSplit()) {
        if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
          radiuses.bottomRight = 0;
          radiuses.bottomLeft = 0;
        } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
          radiuses.topRight = 0;
          radiuses.topLeft = 0;
        }
      } else {
        if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
          radiuses.topRight = 0;
          radiuses.bottomRight = 0;
        } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
          radiuses.topLeft = 0;
          radiuses.bottomLeft = 0;
        }
      }
    }
    return radiuses;
  }

  private getBoardRadius(): BorderRadiuses {
    if (this.needRenderRecentSceneBorderRadius.borderRadius > 0) {
      // According to the ux design, board radius are required for recent state.
      const radius: number = this.needRenderRecentSceneBorderRadius.borderRadius;
      log.showInfo(`getBoardRadius radius is ${radius}`);
      if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN ||
      this.sceneSession.isInFloat() || this.sceneSession.isInSplit()) {
        return this.getBoardRadiusInRecent(radius);
      } else {
        log.showDebug(`do nothing in recent for current windowMode:${this.sceneSession.sceneInfo.windowMode}`);
      }
    }
    if (this.sceneSession.isRightAngle) {
      return {};
    }
    // floatBorderRadius is assigned in SCBSceneSession class, and the value is not 0 only in floating mode
    const screenDpiDendity: number = this.getScreenDpiDensity();
    const scaleRatio: number = screenDpiDendity / 160;
    log.showInfo(`getBoardRadius floatBorderRadius is ${this.sceneSession?.floatBorderRadius} ` +
      `scaleRatio is ${scaleRatio}`);
    return {
      topLeft: (this.sceneSession.floatBorderRadius * scaleRatio) + 'px',
      topRight: (this.sceneSession.floatBorderRadius * scaleRatio) + 'px',
      bottomLeft: (this.sceneSession.floatBorderRadius * scaleRatio) + 'px',
      bottomRight: (this.sceneSession.floatBorderRadius * scaleRatio) + 'px'
    };
  }

  private getOutlineRadiusInRecent(radius: number): OutlineRadiuses {
    let radiuses: OutlineRadiuses = {
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius
        };
    if (!this.dividerParam.isSplitRecentPair) {
        if (this.dividerParam.isExpandUpDownSplit()) {
            if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
                radiuses.bottomRight = 0;
                radiuses.bottomLeft = 0;
              } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
                radiuses.topRight = 0;
                radiuses.topLeft = 0;
              }
          } else {
            if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
                radiuses.topRight = 0;
                radiuses.bottomRight = 0;
              } else if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.SECONDARY) {
                radiuses.topLeft = 0;
                radiuses.bottomLeft = 0;
              }
          }
      }
    return radiuses;
  }

  private setRightAngleIfNeed(): void {
    if (!this.sceneSession.session.isRightAngle || this.sceneSession.isRightAngle) {
      return;
    }
    try {
      let applicationInfo = bundleManager.getApplicationInfoSync(this.sceneSession.sceneInfo.bundleName,
        bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT);
      if (applicationInfo && applicationInfo.systemApp) {
        this.sceneSession.isRightAngle = true;
      }
      log.showInfo(`isRightAngle: ${this.sceneSession.isRightAngle}, id: ${this.sceneSession.sceneInfo.persistentId}`);
    } catch (error) {
      log.showError(`getApplicationInfoSync error code: ${error.code}, message: ${error.message}}`);
    }
  }

  private getOutlineRadiuses(): OutlineRadiuses {
    if (this.needRenderRecentSceneBorderRadius.borderRadius > 0) {
      // According to the ux design, board radius are required for recent state.
      const radius: number = this.needRenderRecentSceneBorderRadius.borderRadius;
      log.showInfo(`getBoardRadius radius is ${radius}`);
      if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN ||
      this.sceneSession.isInFloat() || this.sceneSession.isInSplit()) {
        return this.getOutlineRadiusInRecent(radius);
      } else {
        log.showDebug(`do nothing in recent for current windowMode:${this.sceneSession.sceneInfo.windowMode}`);
      }
    }
    if (this.sceneSession.isRightAngle) {
      return {};
    }
    // floatBorderRadius is assigned in SCBSceneSession class, and the value is not 0 only in floating mode
    const screenDpiDendity: number = this.getScreenDpiDensity();
    const scaleRatio: number = screenDpiDendity / 160;
    log.showInfo(`getOutlineRadiuses floatBorderRadius is ${this.sceneSession?.floatBorderRadius} ` +
      `scaleRatio is ${scaleRatio}`);
    return {
      topLeft: `${(this.sceneSession.floatBorderRadius * scaleRatio)}px`,
      topRight: `${(this.sceneSession.floatBorderRadius * scaleRatio)}px`,
      bottomLeft: `${(this.sceneSession.floatBorderRadius * scaleRatio)}px`,
      bottomRight: `${(this.sceneSession.floatBorderRadius * scaleRatio)}px`,
    };
  }

  private getScaleCenterX(): number {
    if (!this.isCenterStatus()) {
      let centerX = px2vp(this.screenProperty.width) * PowerStatusChangeAnimationController.VISION_CENTER_RATIO_X -
        this.sceneSession.translateX - this.currRect.left.getVp();
      return centerX;
    }
    const windowMode = this.sceneSession.sceneInfo.windowMode;
    const isSplit = (windowMode === SCBSceneMode.PRIMARY || windowMode === SCBSceneMode.SECONDARY);
    if (isSplit && !this.sceneSession.isPairSplitScene) {
      let containerCenterX = px2vp(this.screenProperty.width) / 2;
      if (!this.sceneSession.isActive) {
        const containerSession = SCBSceneSessionManager.getInstance().
          getContainerSessionList().findByPersistentId(this.sceneSession.sceneInfo.persistentId);
        if (containerSession) {
          containerCenterX = containerSession.getSceneContainerWidth() / 2;
        }
      }
      return containerCenterX - this.currRect.left.getVp();
    }
    return this.currRect.width.getVp() / 2;
  }

  private getScaleCenterY(): number {
    if (!this.isCenterStatus()) {
      let positionY = this.currRect.top.getVp();
      if (this.onNeedAvoid()) {
        positionY += Math.floor(ResUtils.getNumber($r('app.float.status_bar_pc_height')));
      }
      return px2vp(this.screenProperty.height) * PowerStatusChangeAnimationController.VISION_CENTER_RATIO_Y -
        positionY;
    }
    if (this.sceneSession.isInSplit() && this.dividerParam.isExpandUpDownSplit()) {
      let statusBar = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithSystemType(
        sceneSessionManager.SessionType.TYPE_STATUS_BAR, this.screenProperty.screenId);
      const topThreshold = statusBar && !this.isDockAutoHide ? statusBar.currRect.height.getPx() : 0;
      const dockHeight = this.isDockAutoHide ? 0 : this.getDockHeight(this.screenProperty.screenId);
      let containerCenterY = px2vp(this.screenProperty.height - dockHeight + topThreshold) / 2;
      if (!this.sceneSession.isActive) {
        const containerSession = SCBSceneSessionManager.getInstance().
          getContainerSessionList().findByPersistentId(this.sceneSession.sceneInfo.persistentId);
        if (containerSession) {
          containerCenterY = containerSession.getSceneContainerHeight() / 2 + px2vp(topThreshold);
        }
      }
      return containerCenterY - this.currRect.top.getVp();
    }
    return this.currRect.height.getVp() / 2;
  }

  private isCenterStatus(): boolean {
    const isWindowScenesUnlock = AppStorage.get('isWindowScenesUnlock') as boolean;
    return AppStorage.get('powerStatus') === PowerStatus.RUNNING && !isWindowScenesUnlock;
  }

  private getSplitRecentTranslateForPair(): TranslateOptions {
    if (this.sceneSession === null) {
      return { x: 0, y: 0 };
    }
    if (this.dividerParam.isExpandUpDownSplit()) {
      if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
        return { x: this.sceneSession.translateX, y: this.sceneSession.translateY };
      }
      return { x: this.sceneSession.translateX,
        y: this.sceneSession.translateY + SCBRecentStyleConstants.SPLIT_UP_DOWN_SPACE };
    }
    if (this.sceneSession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      return { x: this.sceneSession.translateX + this.sceneSession.translateOffsetX, y: this.sceneSession.translateY };
    } else {
      return {
        x: this.sceneSession.translateX - DividerStyle.DIVIDER_WIDTH * this.sceneSession.scaleX +
        this.sceneSession.translateOffsetX + SCBRecentStyleConstants.SESSION_SHADOW_SPACE_SIZE +
        SCBRecentStyleConstants.SESSION_OUTER_SIZE,
        y: this.sceneSession.translateY
      };
    }
  }

  private getTranslate(): TranslateOptions {
    if (this.dividerParam.isSplitRecentPair) {
      return this.getSplitRecentTranslateForPair();
    } else {
      return {
        x: Math.round(PCUtils.vp2px(this.getUIContext(), this.sceneSession.translateX)) + 'px',
        y: Math.round(PCUtils.vp2px(this.getUIContext(), this.sceneSession.translateY)) + 'px'
      };
    }
  }

  private getSize(): SizeOptions {
    return {
      width: this.currRect.width.getPx(),
      height: this.onNeedAvoid() ?
        (this.currRect.height.getPx() - Math.floor(this.getStatusBarHeightVp2Px(0))) :
        (this.currRect.height.getPx()),
    }
  }

  private getPxSizeStr(): SizeOptions {
    return {
      width: this.currRect.width.getPxSizeStr(),
      height: this.onNeedAvoid() ?
        (this.currRect.height.getPx() - Math.floor(this.getStatusBarHeightVp2Px(0))) + 'px' :
        (this.currRect.height.getPxSizeStr()),
    }
  }

  private getPosition(): Position {
    return {
      x: this.currRect.left.getPx(),
      y: this.onNeedAvoid() ?
        (this.currRect.top.getPx() + Math.floor(this.getStatusBarHeightVp2Px(0))) :
        (this.currRect.top.getPx()),
    }
  }

  private getPxPositionStr(): Position {
    return {
      x: this.currRect.left.getPxStr(),
      y: this.onNeedAvoid() ?
        (this.currRect.top.getPx() + Math.floor(this.getStatusBarHeightVp2Px(0))) + 'px' :
        (this.currRect.top.getPxStr()),
    }
  }

  private getDragPxSizeStr(): SizeOptions {
    return {
      width: this.dragSize?.width + 'px',
      height: this.dragSize?.height + 'px'
    }
  }

  private getDragPxPositionStr(): Position {
    return {
      x: this.dragPosition?.x + 'px',
      y: this.dragPosition?.y + 'px'
    }
  }

  private getStatusBarHeightVp2Px(statusBarHeight: number): number {
    const topArea: ViewArea = viewMgrPolicy.getArea(ViewType.STATUS_BAR);
    return topArea !== undefined ? styleMgr.vp2pxStatusBarPCHeight() : statusBarHeight;
  }

  private getSceneShadow(): ShadowOptions {
    return {
      radius: (this.sceneSession.isAttracting || !this.isWindowShadowEnable) ? 0 : this.shadowConfig.radius,
      color: (this.sceneSession.isAttracting || !this.isWindowShadowEnable) ? '#00000000' : this.shadowConfig.color,
      offsetX: this.shadowConfig.offsetX,
      offsetY: this.shadowConfig.offsetY
    }
  }

  private isScenePanelSplitOrRecentState(): boolean {
    return SCBSceneSessionManager.getInstance()
      .isScenePanelInState(this.screenProperty.screenId, ScenePanelState.SPLIT, ScenePanelState.RECENT);
  }

  private isSubWindowSamePidAsParent(subSession: SCBSpecificSession): boolean {
    if (this.sceneSession && subSession) {
      return this.sceneSession.pid === subSession.pid && this.sceneSession.pid !== INVALID_PID;
    } else {
      log.showError('session invalid');
      return false;
    }
  }

  private doSessionTitleAction = (actionId: number, param?: sceneSessionManager.SessionEventParam) => {
      this.onSessionTitleAction(actionId, param);
  }

  private sessionRectChangeByTimeoutOrHotArea = () : boolean=> {
    let windowDragHotAreaType =
      this.sceneSession.sessionData.windowDragHotAreaTypeMap.get(this.screenProperty.screenId) ?? 0;
    log.showInfo(`sessionRectChangeByTimeoutOrHotArea: persistentId ${this.sceneSession?.session.persistentId}` +
      `, scenescreenid ${this.sceneSession?.sceneInfo.screenId}, screenid ${this.screenProperty.screenId}` +
      `, pendingModeTransition ${windowDragHotAreaType}, maskAppearTimerId ${this.maskAppearTimerId}`);
    return this.getMaskAppearIsTimeout() &&
      this.getWindowIsDragToHotArea(windowDragHotAreaType);
  }

  private getMaskAppearIsTimeout(): boolean {
    if (this.maskAppearTimerId === INVALID_TIMER_ID) {
      return true;
    }
    return false;
  }

  private getWindowIsDragToHotArea(windowDragHotAreaType: number): boolean {
    if ((this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_TOP, windowDragHotAreaType)) &&
         this.sceneSession.isSupportFullScreenMode()) {
      return true;
    }
    if (this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_LEFT, windowDragHotAreaType) &&
        this.sceneSession.isSupportSplitMode()) {
      return true;
    }
    if (this.isTouchDragHotArea(WindowDragHotAreaType.HOT_AREA_TYPT_RIGHT, windowDragHotAreaType) &&
        this.sceneSession.isSupportSplitMode()) {
      return true;
    }
    return false;
  }

  private onWindowShadowEnableChange(isWindowShadowEnable: boolean): void {
    log.showInfo(`onWindowShadowEnableChange, state: ${isWindowShadowEnable}`);
    this.isWindowShadowEnable = isWindowShadowEnable;
  }

  aboutToAppear() {
    this.sceneSession?.registerOnUpdateSessionLabelCallback((label: string) => {
      this.onUpdateSessionLabel(label);
    });
    this.sceneSession?.registerOnUpdateSessionIconCallback((iconPath: string) => {
      this.onUpdateSessionIcon(iconPath);
    });
    this.sceneSession?.registerOnUpdateSessionLabelAndIconCallback((label: string, icon: image.PixelMap) => {
      this.onUpdateSessionLabelAndIcon(label, icon);
    });
    this.sceneSession?.addRefCount();
    log.showDebug('aboutToAppear ' + 'SCBScene: ' + this.sceneSession?.sceneInfo.bundleName + ' id: ' +
    this.sceneSession?.session.persistentId);
    // registerCreateSubSessionCallback
    this.sceneSession?.registerCreateSubSessionCallback(this.onCreateSubSession);
    this.sceneSession?.registerSessionTitleActionCallback(this.doSessionTitleAction, this.screenProperty.screenId);
    this.sceneSession?.registerSessionRectChangeCallback((rect: sceneSessionManager.SessionRect,
                                                          reason: sceneSessionManager.SessionSizeChangeReason,
                                                          displayId: number) => {
      this.onSessionRectChange(rect, reason, displayId);
    }, this.screenProperty.screenId);
    this.sceneSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    })
    this.sceneSession?.registerClickModalWindowOutsideCallback(() => {
      this.onClickModalWindowOutside();
    })
    this.sceneSession?.registerNeedAvoidCallback((status: boolean) => {
      if (this.sceneSession) {
        this.sceneSession.needAvoid = status;
      }
    })
    this.sceneSession?.registerSessionSystemBarPropertyCallback((property: SCBSystemBarProperty) => {
      if (this.sceneSession) {
        this.sceneSession.statusVisible = property.enable;
      }
    })
    this.sceneSession?.registerSessionStateChange((state: sceneSessionManager.SessionState) => {
      if (this.sceneSession && this.sceneSession.isRecoveredScene &&
        state === sceneSessionManager.SessionState.STATE_ACTIVE) {
        this.sceneSession.isRecoveredScene = false;
        if (this.sceneSession.isRecoveredFullScreen) {
          this.sceneSession.setWindowLastSafeRect(this.sceneSession.lastRect.left.getPx(),
            this.sceneSession.lastRect.top.getPx(),
            this.sceneSession.lastRect.width.getPx(),
            this.sceneSession.lastRect.height.getPx());
          this.sceneSession.setGravity(sceneSessionManager.Gravity.RESIZE);
        }
      }
    });
    this.sceneSession?.registerCreateDialogCallback((
      specificSession: sceneSessionManager.SceneSession) => {
      log.showInfo('create dialog window begin');
      this.onCreateDialog(specificSession);
    });
    this.setWindowEffectConfig();
    this.sceneSession?.registerWindowDragHotAreaCallback((windowDragHotAreaType: number,
                                                          reason: sceneSessionManager.SessionSizeChangeReason,
                                                          rect: sceneSessionManager.SessionRect) => {
      this.onWindowDragHotArea(windowDragHotAreaType, reason, rect);
    }, this.screenProperty.screenId);
    this.sceneSession?.registerSessionRectChangeByTimeoutOrHotAreaCallback(() => {
      return this.sessionRectChangeByTimeoutOrHotArea();
    }, this.screenProperty.screenId);
    this.sceneSession?.registerGetMaxRectCallback(this.screenProperty.screenId, () => {
      return this.calculateMaxRect();
    });
    this.sceneSession?.registerWindowMovingCallback(this.onWindowMoving, this.screenProperty.screenId);
    this.sceneSession?.registerSplitPartnerMovingCallback(this.onSplitPartnerMoving, this.screenProperty.screenId);
    this.sceneSession?.registerIsShowUseControlCallback(this.isShowUseControlCallBack);
    this.sceneSession?.registerIsActiveCallback(this.isSessionActiveCallBack);
    this.isShowUseControl = this.sceneSession?.useControlList?.length > 0;
    this.controlType = this.sceneSession?.getControlType();
    this.isSessionActive = this.sceneSession?.isActive;
    let isMainWindowControl = this.isMainWindowControl(this.isShowUseControl);
    this.isNeedHideSubWin = isMainWindowControl;
    if (isMainWindowControl) {
      this.sceneSession?.setActivateDragBySystem(false);
      this.sceneSession?.useControlSession?.setFocusable(true);
      SCBSessionListManager.refreshZOrder();
    }
    this.setRightAngleIfNeed();
    this.sceneSession?.registerSubSessionRaiseToTopCallback(this.subSessionRaiseToTop);
    this.sceneSession?.registerSubSessionRaiseAboveTargetCallback(this.subSessionRaiseAboveTarget);
    this.sceneSession?.registerSubSessionStateChangeCallback(this.subSessionStateChange);
    this.sceneSession?.registerSubSessionZLevelChangeCallback(this.subSessionZLevelChange);
    this.sceneSession?.addSidebarBlur();
    this.sceneSession?.setSidebarBlur(true, false);
    this.sceneSession?.registerUpdateDragHotAreaAnimConfigCallback(this.updateDragHotAreaAnimConfig,
      this.screenProperty.screenId);
    this.sceneSession?.registerOnWindowShadowEnableChangeCallback((isWindowShadowEnable: boolean) => {
      this.onWindowShadowEnableChange(isWindowShadowEnable);
    });
  }

  aboutToDisappear(): void {
    if (this.sceneSession?.isSessionResizeWhenDragEnd) {
      log.showInfo('stop drag for aboutToDisappear');
      this.sceneSession.isSessionResizeWhenDragEnd = false;
    }
    this.sceneSession?.decRefCount();
    this.sceneSession?.unregisterSessionStateChange();
    this.sceneSession?.unRegisterAll();
    this.sceneSession?.unregisterWindowMovingCallback(this.onWindowMoving, this.screenProperty.screenId);
    this.sceneSession?.unregisterSplitPartnerMovingCallback(this.onSplitPartnerMoving, this.screenProperty.screenId);
    this.sceneSession?.unregisterIsShowUseControlCallback(this.isShowUseControlCallBack);
    this.sceneSession?.unregisterIsActiveCallback(this.isSessionActiveCallBack);
    this.sceneSession?.unRegisterSessionTitleActionCallback(this.doSessionTitleAction, this.screenProperty.screenId);
    this.sceneSession?.unRegisterOnUpdateSessionLabelCallback();
    this.sceneSession?.unRegisterOnUpdateSessionIconCallback();
    this.sceneSession?.unRegisterOnUpdateSessionLabelAndIconCallback();
    this.sceneSession?.unregisterGetMaxRectCallback(this.screenProperty.screenId);
    this.sceneSession?.unregisterUpdateDragHotAreaAnimConfigCallback(this.screenProperty.screenId);
    this.sceneSession?.unRegisterOnWindowShadowEnableChangeCallback();
  }

  private async onUpdateSessionLabel(label: string): Promise<void> {
    if (!this.sceneSession) {
      return;
    }
    const persistentId = this.sceneSession.session.persistentId;
    SCBSceneResourceManager.getInstance().setSessionLabelCache(persistentId, label);
    SCBSceneSessionManager.getInstance().updateSessionLabelByPersistentId(persistentId, label);
    log.showInfo(`onUpdateSessionLabel ${this.sceneSession.session.persistentId}`);
  }

  private async onUpdateSessionIcon(iconPath: string): Promise<void> {
    if (!this.sceneSession) {
      return;
    }
    const persistentId = this.sceneSession.session.persistentId;
    const iconPixelMap = await SCBSceneResourceManager.getInstance().getIconByPath(iconPath);
    if (iconPixelMap) {
      SCBSceneResourceManager.getInstance().setSessionIconCache(persistentId, iconPixelMap);
      SCBSceneSessionManager.getInstance().updateSessionIconByPersistentId(String(persistentId), iconPixelMap);
      log.showInfo(`onUpdateSessionIcon ${this.sceneSession.session.persistentId}`);
    } else {
      log.showError(`onUpdateSessionIcon get iconPixelMap error ${this.sceneSession.session.persistentId}`);
    }
  }

  private onUpdateSessionLabelAndIcon(label: string, iconPixelMap: image.PixelMap): void {
    if (!this.sceneSession) {
      return;
    }
    const persistentId = this.sceneSession.session?.persistentId;
    if (label && label.length > 0) {
      SCBSceneResourceManager.getInstance().setSessionLabelCache(persistentId, label);
      SCBSceneSessionManager.getInstance().updateSessionLabelByPersistentId(persistentId, label);
    }
    log.showInfo(`onUpdateSessionLabelAndIcon label:${label} bundleName:${this.sceneSession.sceneInfo?.bundleName},` +
      `abilityName:${this.sceneSession.sceneInfo?.abilityName}, persistentId:${persistentId}`);
    if (iconPixelMap) {
      HiSysEventUtil.reportDockIndependentIcon(this.sceneSession.sceneInfo?.bundleName);
      log.showInfo(`onUpdateSessionLabelAndIcon iconPixelMap: ${!iconPixelMap}, cacheKey: ${persistentId}`);
      SCBSceneResourceManager.getInstance().setSessionIconCache(persistentId, iconPixelMap);
      PcDockIndepentIconMgr.getInstance().addIndependentIconAbility(this.sceneSession.sceneInfo?.bundleName,
        String(this.sceneSession.session?.persistentId));
      let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
      PcSmartDockModel.getInstance().initRecentDataList(containerSessionList);
      SCBSceneSessionManager.getInstance().updateSessionIconByPersistentId(String(persistentId), iconPixelMap);
    } else {
      log.showWarn(`onUpdateSessionLabelAndIcon invaild icon!`);
    }
  }

  @Builder
  specificSceneBuilder($$: SCBSpecificSceneBuilderParam) {
    ForEach($$.specificSceneSessionList, (item: SCBSpecificSession) => {
      if (item !== null && this.isSubWindowSamePidAsParent(item)) {
        SCBSpecificScene({
          specificSession: item,
          screenProperty: this.screenProperty,
          singleContext: this.singleContext,
          rect: item.currRect,
          parentRect: this.currRect,
          parentSceneSession: this.sceneSession,
          getScreenDpiDensity: this.getScreenDpiDensity,
          subWindowAnchorInfo: item.subWindowAnchorInfo,
        })
      }
    }, (item: SCBSpecificSession) => item.session.persistentId.toString())
  }

  @Builder
  showResizeWhenDragEnd() {
    Stack() {
    }
    .enabled(false)
    .size(this.getDragPxSizeStr())
    .position(this.getDragPxPositionStr())
    .borderRadius(this.getBoardRadius())
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .border({
      width: RESIZE_WHEN_DRAG_END_BORDER_WIDTH,
      color: RESIZE_WHEN_DRAG_END_BORDER_COLOR,
      radius: this.getBoardRadius(),
    })
    .outline({
      width: RESIZE_WHEN_DRAG_END_OUTLINE_WIDTH,
      color: RESIZE_WHEN_DRAG_END_OUTLINE_COLOR,
      radius: this.getOutlineRadiuses(),
    })
  }

  enableShow(): boolean {
    log.showInfo(`sceneSession id: ${this.sceneSession.persistentId}` +
                 ` sceneSession screenid: ${this.sceneSession?.sceneInfo.screenId}` +
                 ` screenProperty screenid: ${this.screenProperty.screenId}`);
    if (this.sceneSession?.sceneInfo.screenId !== this.screenProperty.screenId) {
      return false;
    }

    if (!this.sceneSession?.isCrossingScreen) {
      log.showInfo(`isCrossingScreen: ${!this.sceneSession?.isCrossingScreen}`);
      return true;
    }
    this.sceneSession.isCrossingScreen = false;
    return true;
  }

  build() {
    if (this.enableShow()) {
      WindowScene(this.sceneSession?.session.persistentId) {
        if (this.isShowUseControl && this.isNeedShowUseControlComponent(this.controlType)) {
          SCBAppUseControlComponent({
            isSessionActive: this.isSessionActive,
            scenePanelState: this.scenePanelState,
            sceneSession: this.sceneSession,
            builderParam: SCBAppUseControlManager.getInstance()
              .getComponentBuilderParamByControlType(this.controlType),
          })
            .transition(this.getUseControlTransition())
            .hitTestBehavior(HitTestMode.Block)
            .size({
              width: '100%',
              height: '100%',
            })
            .position({
              x: 0,
              y: 0,
            })
            .zIndex(USE_CONTROL_COMPONENT_Z_INDEX)
        }

        SCBSceneSnapShot({
          needRenderSnapShotAnimConfig: this.sceneSession.needRenderSnapShotAnimConfig
        })
        .size({width: '100%', height: '100%'})
      }
        .id(`session${this.sceneSession.session.persistentId}`)
        .focusable(this.sceneSession.isFocusable)
        .hitTestBehavior(this.sceneSession.isTouchable ? HitTestMode.Block : HitTestMode.None)
        .borderRadius(this.getBoardRadius())
        .clip(this.needRenderRecentSceneBorderRadius.borderRadius > 0 || this.sceneSession.floatBorderRadius > 0)
        .shadow(this.getSceneShadow())
        .size(this.getPxSizeStr())
        .position(this.getPxPositionStr())
        .translate(this.getTranslate())
        .scale({
          x: 1,
          y: 1,
          centerX: this.getScaleCenterX(),
          centerY: this.getScaleCenterY(),
        })
        .attractionEffect({
          x: this.sceneSession.attractionTransX,
          y: this.sceneSession.attractionTransY
        }, this.sceneSession.attractionVal)
        .opacity(this.sceneSession.opacity)
        .blur(this.sceneSession.blurRadius)
        .backgroundColor(this.needRenderSplitBackgroundColor.backgroundColor)
        .outlineRadius(this.getOutlineRadiuses())
        .outlineColor((this.sceneSession?.isHideShadow ||
          !this.isWindowShadowEnable) ? '#00000000' : this.strokeConfig.outlineColor)
        .outlineWidth((this.sceneSession?.isHideShadow ||
          !this.isWindowShadowEnable) ? 0 : `${this.strokeConfig.outlineWidth}px`)

      if (this.sceneSession.isSessionResizeWhenDragEnd) {
        this.showResizeWhenDragEnd()
      }
    }
  }

  private isNeedShowUseControlComponent(controlType: ControlType | null): boolean {
    let componentBuilderParam = SCBAppUseControlManager.getInstance()
      .getComponentBuilderParamByControlType(controlType);
    if (componentBuilderParam?.isNeedShowUseControlComponent) {
      return componentBuilderParam?.isNeedShowUseControlComponent(this.sceneSession, this.scenePanelState);
    }
    return true;
  }

  private getUseControlTransition(): TransitionEffect {
    if (this.sceneSession?.useControlList?.[0] !== ControlType.APP_LOCK) {
      return TransitionEffect.IDENTITY;
    }

    if (this.sceneSession?.isControlRecentOnly()) {
      return TransitionEffect.asymmetric(
        TransitionEffect.IDENTITY,
        TransitionEffect.opacity(TARGET_OPACITY_VALUE)
          .animation({ duration: RECENT_TRANSITION_DURATION, curve: Curve.EaseIn })
      );
    } else {
      return TransitionEffect.asymmetric(
        TransitionEffect.IDENTITY,
        TransitionEffect.OPACITY.animation({ duration: MAIN_TRANSITION_DURATION, curve: Curve.Sharp })
      );
    }
  }
}