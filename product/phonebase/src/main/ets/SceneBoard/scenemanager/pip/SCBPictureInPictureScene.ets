/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
  ScbNumber,
  SCBPropertyChangeReason,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect,
  SCBSpecificSession,
  SCBSystemSceneSession,
  SystemSessionInfo,
  SCBScenePanelManager,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBEventId,
  windowMgr,
  SCBKeyboardManager,
  SCBKeyboardSession,
  scbEventExclusiveManager,
  EventType,
  ResUtils,
  ScenePanelState,
  SpecificPanelZOrder,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { AppStorageUtil, CommonUtils, LogDomain, LogHelper, Trace, } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import curves from '@ohos.curves';
import hiSysEvent from '@ohos.hiSysEvent';
import { BusinessError } from '@ohos.base';
import { SCBDefaultZIndex } from '../SCBScreen';
import { PiPOverlay } from './overlay/PiPOverlay';
import { Constants, PipRectUpdateReason } from './utils/PictureInPictureConstants';
import { Pin, PipRect, PipRectCalculator, RectChangeItem, ScaleLevel, ScaleChangeType} from './utils/PiPUtils';
import { Queue } from '@kit.ArkTS';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import image from '@ohos.multimedia.image';
import lazy { SCBPiPManager } from './SCBPiPManager';
import { systemDateTime } from '@kit.BasicServicesKit';
import { FoldExpandAnimUtils } from '@ohos/launchercommon/Index';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { PipOneShotAnimHelper } from './utils/PipOneShotAnimHelper';
import { PipSceneManager } from '@ohos/systemuicommon/newTsIndex';
import { promptAction } from '@kit.ArkUI';

const TAG = 'SCBPictureInPictureScene';
const SIDE_EDGE_WIDTH = 20;
const SIDE_EDGE_HEIGHT = 104;
const SIDE_EDGE_BAR_DARK_COLOR = '#66666666';
const SIDE_EDGE_BAR_LIGHT_COLOR = '#667e7e7e';
const LIGHT_BAR_BORDER_COLOR = '#66666666';
const DARK_BAR_BORDER_COLOR = '#66FFFFFF';
const DEFAULT_SIZE: number = 500;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const id = 'pip_window_frame';
const MID_ZOOM_RATIO = 0.8875;
const SIZE_UPDATE_DELAY_TIME = 50;
const PIP_HIDE = 0;
const PIP_SHOW = 1;
const DAMPING_MIN_SCALE_PERCENT: number = 0.85;
const DAMPING_MAX_SCALE_PERCENT: number = 1.15;
const SCALE_NORMAL: number = 1;
const SCALE_LARGE: number = 2;
const SCALE_MANUAL: number = 3;

export class PipReportEventUtil {
  private static readonly MULTIWINDOW_UE: string = 'MULTIWINDOW_UE';
  private static readonly PNAMEID: string = 'SCB';
  private static readonly PVERSION: string = '1.0';

  private static reportEvent(eventName: string, msg: Object): void {
    hiSysEvent.write({
      domain: PipReportEventUtil.MULTIWINDOW_UE,
      name: eventName,
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: msg
    }).then((val) => {
      log.showDebug('success');
    }).catch((err: BusinessError) => {
      log.showError('report false ' + err.message);
    })
  }

  static reportPipDisplayEvent(isShow: number, reason: number, operationPackage: string): void {
    let eventName: string = 'DISPLAY_PIP';
    let params: PipDisplayParams = {
      PNAMEID: PipReportEventUtil.PNAMEID,
      PVERSION: PipReportEventUtil.PVERSION,
      IS_SHOW: isShow,
      REASON: reason,
      OPERATION_PACKAGE_NAME: operationPackage
    };
    PipReportEventUtil.reportEvent(eventName, params);
  }

  static reportPipMoveEvent(operationPackage: string) {
    let params: PipMoveParams = {
      PNAMEID: PipReportEventUtil.PNAMEID,
      PVERSION: PipReportEventUtil.PVERSION,
      OPERATION_PACKAGE_NAME: operationPackage
    };
    PipReportEventUtil.reportEvent('MOVE_PIP', params);
  }

  static reportPipResizeEvent(scaleLevel: number, width: number, height: number, operationPackage: string) {
    let params: PipResizeParams = {
      PNAMEID: PipReportEventUtil.PNAMEID,
      PVERSION: PipReportEventUtil.PVERSION,
      SCALE_LEVEL: scaleLevel,
      WINDOW_WIDTH: width,
      WINDOW_HEIGHT: height,
      OPERATION_PACKAGE_NAME: operationPackage
    };
    PipReportEventUtil.reportEvent('RESIZE_PIP_SIZE', params);
  }
}

interface PipDisplayParams {
  PNAMEID: string;
  PVERSION: string;
  IS_SHOW: number;
  REASON: number;
  OPERATION_PACKAGE_NAME: string;
}

interface PipResizeParams {
  PNAMEID: string;
  PVERSION: string;
  SCALE_LEVEL: number;
  WINDOW_WIDTH: number;
  WINDOW_HEIGHT: number;
  OPERATION_PACKAGE_NAME: string;
}

interface PipMoveParams {
  PNAMEID: string;
  PVERSION: string;
  OPERATION_PACKAGE_NAME: string;
}

export enum DisplayReason {
  DEFAULT,
  BORDER,
  FILE,
  RECENT
}

@Component
export struct SCBPictureInPictureScene {
  rectBeforeAvoid:SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  isAvoidNavigationIndicator: boolean = false;
  isRecoveryAvoidInput: boolean = false;
  isRecoveryAvoidNav: boolean = false;
  navAvoidHeight: number = vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA);
  bottomAvoidHeight: number = vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA);
  topAvoidHeight: number = windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height +
    vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA);
  isRotating: boolean = false;
  timeoutIds: number[] = [];

  // pip overlay
  private overlaySystemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PIP,
    sceneName: 'pip_overlay',
    sceneZIndex: SCBDefaultZIndex.PIP_SCENE_PANEL_OVERLAY,
    isFocusable: false,
    isTouchable: true,
    privacyMode: false,
    isRotatable: true,
    hitTestMode: HitTestMode.None,
    sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
  };

  private dragScaleSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PIP,
    sceneName: 'pip_dragScale',
    sceneZIndex: SCBDefaultZIndex.PIP_SCENE_PANEL_OVERLAY,
    privacyMode: false,
    isFocusable: false,
    isTouchable: true,
    isRotatable: true,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
  }

  private dragScaleSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.dragScaleSessionInfo);

  private overlaySceneSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.overlaySystemSessionInfo);
  // HiView info
  bundleName: string = '';
  private rectCalculator: PipRectCalculator = new PipRectCalculator();
  private sideEdgeZoomScale: number = 0;
  // real specificSession rect
  @State realRectWidth: number = 0;
  @State realRectHeight: number = 0;
  private zooming: boolean = false;
  private needDelayProcessHide: boolean = false;
  private hasZoomed: boolean = false;
  private zoomScale: number = 1;
  private sourceRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private parentId: number = -1;
  private lastMode: SCBSceneMode = SCBSceneMode.UNDEFINED;
  private useSnapshot: boolean = false;
  private isRestoreFromBg: boolean = false;
  private shouldAnimToSource: boolean = false;
  private isDumpsterClosePip: boolean = false;
  private isEdgeHideInterrupt: boolean = false;
  private isClickInSidebarInterrupt: boolean = false;
  @State isShowDefaultBackground: boolean = true;
  @ObjectLink specificSession: SCBSpecificSession;
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink rect: SCBSessionRect;
  @State @Watch('overlayRectChange') overlayRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  @State moveStartOverlayRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  @State moveStartRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  @State clickInSideBarRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  @State isInSideManager: boolean = false;
  @State @Watch('scaleValueChange')scaleValue: number = 1;
  @State moveStartScale: number = 1;
  @State centerScaleX: string = '0';
  @State centerScaleY: string = '0';
  @State pipBorderRadius: number = 4;
  @State opacityNum: number = 1;
  @State transX: number = 0;
  @State transY: number = 0;
  // used to move pip to an offset position when dragging. pip real translateX = transX + transXOffset
  @State transXOffset: number = 0;
  @State transYOffset: number = 0;
  // trans change caused by move pip
  @State moveEndTransX: number = 0;
  @State moveEndTransY: number = 0;
  @State shadowStyle: ShadowStyle | undefined = undefined;
  // trans change caused by pip scale anim
  @State scaleTransX: number = 0;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @State showSideBar: boolean = false;
  @State clipPiPWindow: boolean = false;
  @Prop @Watch('onScreenPropChange') propChangeReason: SCBPropertyChangeReason;
  @Link msgQueue: Queue<RectChangeItem>;
  @State closed: boolean = false;
  @State cachePixMap: image.PixelMap | null = null;
  @State foregroundBlur: number = -1;
  avoidHeight: number = 0;
  @State needBlockCover: boolean = false;
  @State needDragScale: boolean = false;
  @State isDragScalePip: boolean = false;
  @Link panelZIndex: number;
  @State overlayZIndex: number = this.panelZIndex + 1;
  @State moveAnimateCount: number = 0;

  @Link delayRotation: boolean;
  @Link pipBackgroundOpacity: number;
  @State isPiPVisibility: boolean = true;
  private restoreOneShot: boolean = false;
  private isRestoreFromRecent: boolean = false;
  @State isNeedFreeze: boolean = false;
  private shouldDoRestore: boolean = false;
  private isRestoreDone: boolean = false;
  activeRotation?: () => void;
  recoverRotation?: () => void;
  private notifyRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private notifyScale: number = 0;
  private displayRect: PipRect = new PipRect(0, 0, 0, 0);
  private rectBeforeScale: PipRect = new PipRect(0, 0, 0, 0);
  private gesturePin: Pin = Pin.LEFT_TOP;
  private minScale: number = 1;
  private beforeDragScale: number = 0;
  private afterDragScale: number = 0;
  private rectSizeLevel: number = 0;
  @State blurScale: number = 0;

  onMoveEdgeSpringBackAnimationFinished = (): void => {
    this.moveAnimateCount--;
    if (this.moveAnimateCount == 0) {
      // restore zIndex after edge spring back.
      if (this.panelZIndex !== SCBDefaultZIndex.PIP_SCENE_PANEL) {
        this.updatePanelZIndex(SCBDefaultZIndex.PIP_SCENE_PANEL);
      }
    }
  }

  recentCallback = (property: boolean): void => {
    this.isRecoveryAvoidInput = false;
    this.updateBottomAvoidHeight();
    this.processEdgeSpringBack();
  }

  // inputShowAvoid
  inputShowCallback = (inputSession: SCBKeyboardSession): void => {
    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (CommonUtils.isInvalid(inputSession) || CommonUtils.isInvalid(keyboardPanelSession)) {
      return;
    }

    if (this.rectCalculator.isMoveOrDrag()) {
      this.bottomAvoidHeight = this.navAvoidHeight;
      return;
    }
    if (inputSession.isFloatGravity()) {
      return;
    }
    let pipRectBottom: number = this.overlayRect.top.getPx() + this.overlayRect.height.getPx();
    let inputMethodHeight: number = keyboardPanelSession.getPanelRealHeight();
    let avoidRect = new SCBSessionRect(0, this.screenProperty.height - inputMethodHeight, this.screenProperty.width,
      inputMethodHeight);
    log.showInfo(`inputShowCallback inputMethodHeight: ${inputMethodHeight}}`);
    let avoidTop: number = 0;
    if (inputSession.isKeyboardShowing()) {
      this.bottomAvoidHeight = Math.min(this.screenProperty.height - vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA) -
        windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height -
        this.overlayRect.height.getPx(), avoidRect.height.getPx());
      if (pipRectBottom > avoidRect.top.getPx()) {
        this.isRecoveryAvoidInput = true;
        this.rectBeforeAvoid.copyFrom(this.overlayRect);
        animateTo({ curve: curves.springMotion(0.45, 0.825) }, () => {
          avoidTop = Math.max(this.overlayRect.top.getPx() - inputMethodHeight, this.topAvoidHeight);
          this.overlayRectMoveTo(this.overlayRect.left.getPx(), avoidTop);
          this.checkSafePadding();
        });
      }
    } else {
      this.bottomAvoidHeight = this.navAvoidHeight;
      if (this.isRecoveryAvoidInput) {
        this.isRecoveryAvoidInput = false;
        log.showInfo(`input recover now.`);
        animateTo({ curve: curves.springMotion(0.45, 0.825) }, () => {
          this.overlayRectMoveTo(this.rectBeforeAvoid.left.getPx(), this.rectBeforeAvoid.top.getPx());
          this.checkSafePadding();
        });
        this.rectCalculator.savePipPositionAndLevel(this.rect.left.getPx(), this.rect.top.getPx());
      }
    }
  };

  // Input method rect change callback
  keyboardRectChangeCallback = (): void => {
    if (this.rectCalculator.isMoveOrDrag()) {
      this.bottomAvoidHeight = this.navAvoidHeight;
      return;
    }
    log.showInfo(`keyboardRectChange now.`);
    let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (keyboardSession === undefined || keyboardSession === null) {
      return;
    }
    if (keyboardSession.isFloatGravity()) {
      return;
    }
    this.updateBottomAvoidHeight();
    if (this.screenProperty.rotation !== this.rectCalculator.getCurrentScreenRotation() || this.isRotating) {
      return;
    }
    this.processEdgeSpringBack();
  }

  private onParentForeground = (): void => {
    SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    this.processDoRestore();
  }

  private onPIPActionEvent = (action: string): void => {
    log.showInfo(`onPIPActionEvent action: ${action}`);
    switch (action) {
      case Constants.ACTION_DOCK_CLOSE:
        this.onActionClose();
        break;
      case Constants.ACTION_DOCK_RESTORE:
        // click the pip window in the side manager.
        this.clickInSideManager();
        break;
      case Constants.ACTION_DOCK_STEP_RESTORE:
        // click the side bar to restore pip window.
        this.clickInSideBar();
        break;
      default:
        break;
    }
  }

  private resetPrivacyMode() {
    let parentSession: SCBSceneSession = SCBSceneSessionManager.getInstance()
      .getSessionById(this.parentId) as SCBSceneSession;
    if (!parentSession) {
      log.showError(`parentSession is null`);
      return;
    }
    let isPrivacyMode: boolean = parentSession.sessionData.isPrivacyWindow;
    try {
      this.specificSession.session.setPrivacyMode(isPrivacyMode);
      log.showInfo(`resetPrivacyMode: ${isPrivacyMode}`);
    } catch (err) {
      log.showError('resetPrivacyMode failed');
    }
  }

  private clickInSideManager() {
    PipReportEventUtil.reportPipDisplayEvent(PIP_SHOW, DisplayReason.BORDER, this.bundleName);
    this.isInSideManager = false;
    this.hasZoomed = false;
    this.scaleValue = SCBPiPManager.getInstance().pipSideManagerInfo.originScale;
    this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
    if (this.overlaySceneSession !== null && this.overlaySceneSession !== undefined) {
      this.overlaySceneSession.setVisibility(true);
      this.overlaySceneSession.setActive(true);
      this.overlaySceneSession.setSessionTouchable(true);
    }
    this.resetPrivacyMode();
    this.updatePanelZIndex(SCBDefaultZIndex.PIP_SCENE_PANEL);
  }

  private clickInSideBar() {
    PipReportEventUtil.reportPipDisplayEvent(PIP_SHOW, DisplayReason.BORDER, this.bundleName);
    this.isInSideManager = false;
    this.hasZoomed = false;
    this.showSideBar = true;
    this.clipPiPWindow = true;
    let tempRectLeft: number = this.rect.left.getPx();
    this.clickInSideBarRect = this.rect.copy();
    if (SCBPiPManager.getInstance().pipSideManagerInfo.sideDirect === 'left') {
      tempRectLeft = - vp2px(SIDE_EDGE_WIDTH / 2);
    } else {
      tempRectLeft = this.screenProperty.width - vp2px(SIDE_EDGE_WIDTH / 2);
    }
    let tempRect: SCBSessionRect = this.rect.copy();
    this.rect.setPosNum(tempRectLeft, vp2px(0));
    this.opacityNum = 0;
    this.resetPrivacyMode();
    this.updatePanelZIndex(SCBDefaultZIndex.PIP_SCENE_PANEL);
    this.isClickInSidebarInterrupt = true;
    if (this.overlaySceneSession !== null && this.overlaySceneSession !== undefined) {
      this.overlaySceneSession.setVisibility(true);
      this.overlaySceneSession.setActive(true);
      this.overlaySceneSession.setSessionTouchable(true);
    }
    // side bar to pip window of a mirror to the end of the dynamic effect
    animateTo({
      curve: curves.springMotion(0.4, 0.8),
      onFinish: () => {
        this.showSideBar = false;
        this.clipPiPWindow = false;
        this.isClickInSidebarInterrupt = false;
      }
    }, () => {
      this.realRectWidth = this.overlayRect.width.getVp();
      this.realRectHeight = this.overlayRect.height.getVp();
      this.scaleValue = SCBPiPManager.getInstance().pipSideManagerInfo.originScale;
      this.opacityNum = 1;
      this.rect.setSizeNum(tempRect.width.getPx(), tempRect.height.getPx());
      this.rect.setPosNum(tempRect.left.getPx(), tempRect.top.getPx());
      this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
      this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
    })
  }

  /**
   * interrupt animation of processing clickInSideBar
   */
  private clickInsideBarInterrupt() {
    this.isClickInSidebarInterrupt = false;
    let tempRect: SCBSessionRect = this.clickInSideBarRect.copy();
    this.realRectWidth = this.overlayRect.width.getVp();
    this.realRectHeight = this.overlayRect.height.getVp();
    this.scaleValue = SCBPiPManager.getInstance().pipSideManagerInfo.originScale;
    this.opacityNum = 1;
    this.rect.setSizeNum(tempRect.width.getPx(), tempRect.height.getPx());
    this.rect.setPosNum(tempRect.left.getPx(), tempRect.top.getPx());
    this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
    this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
    this.showSideBar = false;
    this.clipPiPWindow = false;
  }

  private onSceneRaiseToTop = (persistentId?: number): void => {
    if (!persistentId) {
      return;
    }
    if (persistentId !== this.parentId) {
      return;
    }
    this.lastMode = this.getParentWindowMode();
    log.showInfo(`onSceneRaiseToTop lastMode = ${this.lastMode}`);
  }

  private updatePanelZIndex(zIndex: number): void {
    log.showInfo(`updatePanelZIndex from ${this.panelZIndex} to ${zIndex}`);
    this.panelZIndex = zIndex;
  }

  enableShow(): boolean {
    if (this.specificSession === null || this.specificSession === undefined) {
      log.showError('enable show is false, specificSession is null');
      return false;
    }

    if (this.specificSession.isCustomAnimationPlaying) {
      log.showDebug('enable show is true, is playing custom animation');
      return true;
    }

    if (this.specificSession.isActive) {
      log.showDebug('enable show is true, is in active state');
      return true;
    }

    log.showError('enable show is false');
    return false;
  }

  private getSCBSessionRectInfo(rect?: SCBSessionRect): string {
    if (rect === null || rect === undefined) {
      return '[]';
    }
    return `[ ${rect.left.getPx()}, ${rect.top.getPx()}, ${rect.width.getPx()}, ${rect.height.getPx()} ]`;
  }

  overlayRectChange() {
    if (this.isInSideManager) {
      log.showInfo(`overlayRectChange overlayRect: ${this.getSCBSessionRectInfo(this.overlayRect)}`);
      SCBPiPManager.getInstance().pipSideManagerInfo.originRect.setRect(this.overlayRect.left, this.overlayRect.top,
        this.rect.width, this.rect.height);
    }
  }

  scaleValueChange() {
    if (this.isInSideManager) {
      log.showInfo(`scaleValueChange scaleValue: ${this.scaleValue}`);
      SCBPiPManager.getInstance().pipSideManagerInfo.originScale = this.scaleValue;
    }
  }

  private init() {
    this.initBundleInfo();
    this.initMessage();
    this.initCallbacks();
    this.initOverlay();
  }

  private initBundleInfo() {
    this.specificSession?.addRefCount();
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.specificSession.session.parentId);
    if (parentSession !== null && parentSession instanceof SCBSceneSession) {
      this.bundleName = parentSession.sceneInfo.bundleName;
      this.parentId = this.specificSession.session.parentId;
      let isPrivacyMode: boolean = parentSession.sessionData.isPrivacyWindow;
      log.showInfo(`bundleName: ${this.bundleName} parentId: ${this.parentId} PrivacyMode: ${isPrivacyMode}}`);
      this.specificSession.session.setPrivacyMode(isPrivacyMode);
    }
  }

  private initMessage() {
    while (this.msgQueue.length > 0) {
      let rectItem: RectChangeItem = this.msgQueue.pop();
      log.showInfo(`execute cached sessionRectChange msg, reason:${rectItem.reason}`);
      this.specificSession?.currRect.setRectNum(
        rectItem.rect.posX_, rectItem.rect.posY_, rectItem.rect.width_, rectItem.rect.height_);
      this.onSessionRectChange(rectItem.rect, rectItem.reason);
    }
  }

  private initCallbacks() {
    this.specificSession?.registerSessionRectChangeCallback(
      (rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason) => {
        this.onSessionRectChange(rect, reason);
      });
    this.specificSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    });
    this.specificSession?.registerClosePiPCallback(() => {
      this.onActionClose();
    });
    this.specificSession?.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      log.showInfo('set isCustomAnimationPlaying ' + isPlaying);
      this.specificSession.isCustomAnimationPlaying = isPlaying;
    });
    this.specificSession?.registerSessionPrepareCloseCallback(() => {
      log.showInfo('registerSessionPrepareCloseCallback ');
      this.processClose(Constants.ACTION_REQUEST_CLOSE);
      // pip is processing edge
      if (this.isEdgeHideInterrupt) {
        this.processEdgeHideInterrupt();
      }
      if (this.isInSideManager) {
        this.isInSideManager = false;
      }
    });
    SCBKeyboardManager.getInstance().registerKeyboardShowCallback(this.inputShowCallback);
    SCBKeyboardManager.getInstance().registerkeyboardRectChangeCallbacks(this.keyboardRectChangeCallback);
    SCBSceneSessionManager.getInstance().registerSystemBarPropertyRecentCallbacks(this.recentCallback);
    SCBSceneSessionManager.getInstance().registerPiPOcclusiveChangeCallback((occluded: boolean) => {
      try {
        this.specificSession?.session?.notifyPipOcclusionChange(occluded);
      } catch (err) {
        log.showError(`notifyPipOcclusionChange ${occluded} err`);
      }
    });
    this.lastMode = this.getParentWindowMode();
    SCBSceneSessionManager.getInstance().on(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId,
      this.onSceneRaiseToTop);
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.specificSession.session.parentId);
    if (parentSession !== null && parentSession instanceof SCBSceneSession) {
      parentSession.registerForegroundCallback(this.onParentForeground);
    }
    SCBPiPManager.getInstance().registerPiPActionEvent(this.onPIPActionEvent);
  }

  private initOverlay() {
    this.overlaySceneSession?.setVisibility(true);
    this.overlaySceneSession?.setActive(true);
    if (this.overlaySceneSession !== null && this.overlaySceneSession !== undefined) {
      this.overlaySceneSession.visibility = true;
    }
  }

  aboutToAppear(): void {
    log.showDebug(`aboutToAppear, id: ${this.specificSession?.session.persistentId}, ` +
      `currRect: ${this.getSCBSessionRectInfo(this.specificSession?.currRect)}`);
    this.bottomAvoidHeight = this.avoidHeight;
    this.init();
    this.specificSession.setSkipEventAndShowOnVirtualScreen(true);
    this.overlaySceneSession.setSkipEventAndShowOnVirtualScreen(true);
    this.dragScaleSession.setSkipEventAndShowOnVirtualScreen(true);
    SCBSceneSessionManager.getInstance().registerPipCallback((persistentId: number) => {
      if (this.specificSession?.session?.parentId === persistentId) {
        log.showInfo(`onActionRestore: persistentId = ${persistentId}`);
        this.onActionRestore();
      }
    });
    this.needDragScale = true;
    this.rectSizeLevel = this.rectCalculator.getScaleLevelInt().valueOf();
  }

  aboutToDisappear() {
    SCBPiPManager.getInstance().needBlockShowOverlayCount = 0;
    SCBPiPManager.getInstance().isRotationDelayed = false;
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.specificSession.session.parentId);
    if (parentSession !== null && parentSession instanceof SCBSceneSession) {
      parentSession.unregisterForegroundCallback();
    }
    this.specificSession.setSkipEventAndShowOnVirtualScreen(false);
    this.overlaySceneSession.setSkipEventAndShowOnVirtualScreen(false);
    this.dragScaleSession.setSkipEventAndShowOnVirtualScreen(false);
    this.needDragScale = false;
    this.rectCalculator.saveScaleLevel();
    this.specificSession?.decRefCount();
    this.specificSession?.unRegisterAll();
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.overlaySceneSession);
    SCBSceneSessionManager.getInstance().requestSystemSceneSessionDestruction(this.dragScaleSession);
    SCBSceneSessionManager.getInstance().off(SCBEventId.SESSION_RAISE_TO_TOP, this.screenProperty.screenId,
      this.onSceneRaiseToTop);
    SCBKeyboardManager.getInstance().unRegisterKeyboardShowCallback(this.inputShowCallback);
    SCBKeyboardManager.getInstance().unRegisterkeyboardRectChangeCallbacks(this.keyboardRectChangeCallback);
    SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyRecentCallbacks(this.recentCallback);
    SCBPiPManager.getInstance().unregisterPiPActionEvent(this.onPIPActionEvent);
    SCBSceneSessionManager.getInstance().unRegisterPiPOcclusiveChangeCallback();
    this.specificSession?.unregisterClosePiPCallback();
    this.cachePixMap?.release();
    this.cachePixMap = null;
    this.timeoutIds.forEach((id) => {
      clearTimeout(id);
    });
    SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    SCBSceneSessionManager.getInstance().unregisterPipCallback();
  }

  private equalSize(oldRect: SCBSessionRect, newRect: SCBSessionRect, oldScale: number, newScale: number) {
    return oldRect.width.getPx() === newRect.width.getPx() && oldRect.height.getPx() === newRect.height.getPx() &&
      oldScale === newScale;
  }

  onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.specificSession?.setTouchable(isTouchable);
  }

  onFoldChange() {
    if (!DeviceHelper.isFoldButNotSmallFoldProduct()) {
      return;
    }
    if (this.isEdgeHideInterrupt) {
      this.processEdgeHideInterrupt();
    }
    if (this.isDragScalePip) {
      this.handleDragScaleEventCancel();
    }
    if (this.propChangeReason === SCBPropertyChangeReason.EXPAND_TO_FOLD ||
      this.propChangeReason === SCBPropertyChangeReason.FOLD_TO_EXPAND) {
      log.showInfo(`ScreenPropChange change: ${this.propChangeReason}`);
      let res: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
      if (FoldExpandAnimUtils.isSupportProduct) {
        // if support fold effect, break PIP rect and scale animation
        animateTo({
          duration: 0
        }, () => {
          this.rect.setSizeNum(res.width.getPx(), res.height.getPx());
          this.rect.setPosNum(res.left.getPx(), res.top.getPx());
          this.overlayRect.setPosNum(res.left.getPx(), res.top.getPx());
          this.scaleValue = 0;
        });
      }
      let reason = this.propChangeReason === SCBPropertyChangeReason.FOLD_TO_EXPAND ?
      PipRectUpdateReason.REASON_PIP_EXPAND : PipRectUpdateReason.REASON_PIP_FOLD;
      let targetRect = this.rectCalculator.updatePipRect(res, reason, this.screenProperty);
      let largeRect = this.getLargeRealSize(targetRect, reason);
      if (this.isInSideManager === true) {
        this.setRect(targetRect);
        this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
        this.scaleValue = this.getScaleValue(this.rect, targetRect);
        this.zoomScale = this.scaleValue;
      } else {
        this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
        this.rect.setPosNum(targetRect.left.getPx(), targetRect.top.getPx());
        this.scaleValue = this.getScaleValue(this.rect, targetRect);
        this.overlayRect.copyFrom(targetRect);
        this.centerScaleX = '0';
        this.centerScaleY = '0';
        log.showInfo(`rotaion show rect move to [${targetRect.left.getPx()}, ${targetRect.top.getPx()}] ` +
          `centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} scaleValue: ${this.scaleValue}`);
      }
    }
  }

  /**
   * restore pip if in side edge bar or manager
   */
  private restoreSideEdge(): void {
    if (this.propChangeReason !== SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      return;
    }
    // pip is processing edge
    if (this.isEdgeHideInterrupt) {
      this.processEdgeHideInterrupt();
    }
    if (this.isInSideManager && this.propChangeReason === SCBPropertyChangeReason.EXPAND_TO_FOLD) {
      log.showInfo('restore in side manager');
      this.clickInSideManager();
    }
  }

  // notify app pip window size changed
  private notifyPipSizeChange(): void {
    if (SCBPiPManager.getInstance().notifyPipSizeChange(this.notifyRect, this.rect, this.notifyScale,
      this.scaleValue)) {
      this.notifyScale = this.scaleValue;
    }
  }

  onScreenPropChange() {
    if (this.propChangeReason === SCBPropertyChangeReason.UNDEFINED) {
      return;
    }
    if (this.rectCalculator.isMoveOrDrag()) {
      this.onActionMoveEndOrCancel(undefined);
    }
    if (this.propChangeReason === SCBPropertyChangeReason.ROTATION ||
      this.propChangeReason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      log.showInfo('ScreenPropChange change: ROTATION');
      this.isRecoveryAvoidInput = false;
      setTimeout(()=> {
        this.processRotation();
        this.notifyPipSizeChange();
      })
    }
    this.onFoldChange();
    let nowRect: SCBSessionRect = this.overlayRect.copy()
    this.saveMinScaleValue(nowRect);
    this.notifyPipSizeChange();
  }

  private updateBottomAvoidHeight() {
    let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (CommonUtils.isInvalid(keyboardSession) || CommonUtils.isInvalid(keyboardPanelSession)) {
      return;
    }
    if (keyboardSession.isKeyboardShowing()) {
      let inputMethodHeight: number = keyboardPanelSession.getPanelRealHeight();
      let avoidRect = new SCBSessionRect(0, this.screenProperty.height - inputMethodHeight, this.screenProperty.width,
        inputMethodHeight);
      log.showInfo(`avoidRect: ${avoidRect}`);
      this.bottomAvoidHeight = Math.min(this.screenProperty.height - vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA) -
        windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height -
        this.overlayRect.height.getPx(), avoidRect.height.getPx());
      log.showInfo(`updateBottomAvoidHeight: ${this.bottomAvoidHeight}`);
    }
  }

  onSessionRectChange(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason) {
    if (this.specificSession === null || this.specificSession === undefined) {
      log.showError('onRectChange: specificSession is null');
      return;
    }
    log.showInfo(`onSessionRectChange start, id: ${this.specificSession.session.persistentId}, reason: ${reason}, ` +
      `rect: [ ${rect.posX_}, ${rect.posY_}, ${rect.width_}, ${rect.height_} ], ` +
      `currRect: ${this.getSCBSessionRectInfo(this.specificSession.currRect)}`);

    if ((rect.width_ === 0 || rect.height_ === 0) &&
      reason !== sceneSessionManager.SessionSizeChangeReason.PIP_RESTORE) {
      rect.width_ = DEFAULT_SIZE;
      rect.height_ = DEFAULT_SIZE;
    }
    let scbRect = new SCBSessionRect(rect.posX_, rect.posY_, rect.width_, rect.height_);
    switch (reason) {
      case sceneSessionManager.SessionSizeChangeReason.UNDEFINED:
      case sceneSessionManager.SessionSizeChangeReason.PIP_START:
        // UNDEFINED & PIP_START's purpose is to record source window position
        this.specificSession.visibility = false;
        this.processStart(rect);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_SHOW:
        // PIP_SHOW's purpose is to display the window and move it to the recorded position
        this.processShow(scbRect);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_AUTO_START:
        this.delayRotation = false;
        this.processAutoStart(rect, scbRect);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_RATIO_CHANGE:
        this.addBlur();
        // PIP_RATIO_CHANGE's purpose is to adapt to content size change and delay time is to adjust size after rotation
        setTimeout(() => {
          this.processRatioChange(scbRect, rect);
        }, SIZE_UPDATE_DELAY_TIME);
        break;
      case sceneSessionManager.SessionSizeChangeReason.TRANSFORM:
        // TRANSFORM's purpose is to update source window position
        this.sourceRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
        break;
      case sceneSessionManager.SessionSizeChangeReason.PIP_RESTORE:
        this.processAfterRestore(rect);
        this.notifyRect.setRectNum(0, 0, 0, 0);
        this.notifyScale = 0;
        break;
    }
    if (reason !== sceneSessionManager.SessionSizeChangeReason.PIP_RESTORE) {
      setTimeout(() => {
        this.notifyPipSizeChange();
      }, SIZE_UPDATE_DELAY_TIME)
    }
    log.showInfo(`onSessionRectChange end, id: ${this.specificSession.session.persistentId}, reason: ${reason}, ` +
      `rect: ${this.getSCBSessionRectInfo(this.rect)}, overlayRect: ${this.getSCBSessionRectInfo(this.overlayRect)} ` +
      `centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} scaleValue: ${this.scaleValue}`);
  }

  private processShow(scbRect: SCBSessionRect) {
    let showRect = this.rectCalculator.updatePipRect(scbRect, PipRectUpdateReason.REASON_PIP_START,
      this.screenProperty);
    let isReuseWindow: boolean = !this.overlayRect.isEmpty();
    let largeRect = this.getLargeRealSize(scbRect, PipRectUpdateReason.REASON_PIP_START);
    if (isReuseWindow) {
      this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
    }
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    // update rect to source rect directly
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.scaleValue = 1;
    let targetScale: number = this.getScaleValue(this.rect, showRect);
    if (!isReuseWindow) {
      this.setRectToSource();
      this.specificSession.visibility = true;
      animateTo({ curve: curves.responsiveSpringMotion(0.55, 0.825, 0.25), onFinish: () => {
        this.isShowDefaultBackground = true;
        SCBPiPManager.getInstance().deleteColdStartScale(this.specificSession?.session?.parentId);
      }}, () => {
        this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
        this.scaleValue = targetScale;
        this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
        this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
      });
    } else {
      this.isShowDefaultBackground = true;
      this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
      this.specificSession.visibility = true;
      this.scaleValue = targetScale;
      this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
      this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
      SCBPiPManager.getInstance().deleteColdStartScale(this.specificSession?.session?.parentId);
    }
    if (this.recoverRotation !== undefined) {
      this.recoverRotation();
    }
    this.overlayRect = showRect.copy();
    SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_show')));

    let nowRect = this.overlayRect.copy();
    this.saveMinScaleValue(nowRect);
    // 通知systemUI手动拉起画中画
    const containerSession = this.getParentContainerSession();
    if (containerSession) {
      PipSceneManager.instance.addPipScene(containerSession);
    }
  }

  private addBlur() {
    animateTo({
      curve: Curve.Linear,
      duration: SIZE_UPDATE_DELAY_TIME
    }, () => {
      this.blurScale = 200;
    });
  }

  private destroyBlur() {
    setTimeout(() => {
      animateTo({
        curve: Curve.Linear,
        duration: SIZE_UPDATE_DELAY_TIME,
      }, () => {
        this.blurScale = 0;
      });
    }, 100);
  }

  private processRatioChange(scbRect: SCBSessionRect, rect: sceneSessionManager.SessionRect) {
    let ratioRect = this.rectCalculator.updatePipRect(scbRect,
      PipRectUpdateReason.REASON_PIP_RATIO_CHANGE, this.screenProperty);
    let largeRect = this.getLargeRealSize(scbRect, PipRectUpdateReason.REASON_PIP_RATIO_CHANGE);
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    this.overlayRect = ratioRect.copy();
    let targetScale: number = this.getScaleValue(this.rect, ratioRect);
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.rect.setPosNum(ratioRect.left.getPx(), ratioRect.top.getPx());
    this.scaleValue = targetScale;
    if (this.isInSideManager) {
      this.zoomScale = this.getScaleValue(this.rect, ratioRect);
    }
    let nowRect = this.overlayRect.copy();
    this.saveMinScaleValue(nowRect);
    setTimeout(() => {
      this.destroyBlur();
    }, 200);
  }

  processAutoStart(rect: sceneSessionManager.SessionRect, scbRect: SCBSessionRect): void {
    if (SCBPiPManager.getInstance().isRotationDelayed) {
      SCBPiPManager.getInstance().isRotationDelayed = false;
      if (this.recoverRotation !== undefined && this.recoverRotation !== null) {
        this.recoverRotation();
      }
    }
    let showRect = this.rectCalculator.updatePipRect(scbRect, PipRectUpdateReason.REASON_PIP_START,
      this.screenProperty);
    let largeRect = this.getLargeRealSize(scbRect, PipRectUpdateReason.REASON_PIP_START);
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    this.overlayRect = showRect.copy();
    let targetScale: number = this.getScaleValue(this.rect, showRect);
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.rect.setPosNum(showRect.left.getPx(), showRect.top.getPx());
    this.scaleValue = targetScale;
    this.updateScaleWithoutMove(0.5, 0.5);

    let containerSession = this.getParentContainerSession();
    if (containerSession?.isAutoPiPOneShot) {
      log.showInfo(`processAutoStart: processAutoStartOneShot`);
      this.processAutoStartOneShot(targetScale);
    } else {
      log.showInfo(`processAutoStart: processAutoStartNormal`);
      this.processAutoStartDefault(targetScale);
    }
    let nowRect = this.overlayRect.copy();
    this.saveMinScaleValue(nowRect);
  }

  private processAutoStartOneShot(targetScale: number): void {
    let originScale: number = targetScale;
    this.scaleValue = originScale;
    this.opacityNum = 0;
    this.specificSession.visibility = true;
    this.pipBorderRadius = 16;
    let delayTime = SCBPiPManager.getInstance().isNeedVisualEffectChange() ? 200 : 250;
    this.shadowStyle = undefined;
    if (DeviceHelper.isEmulator()) {
      delayTime = 0;
    }
    setTimeout(() => {
      SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'pipAutoStart');
      this.foregroundBlur = 0;
      animateTo({
        curve: Curve.Linear, duration: SCBPiPManager.getInstance().isNeedVisualEffectChange() ? 400 : 600,
        onFinish: () => {
          this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
          SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_show')));
          SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'pipAutoStart');
          SCBPiPManager.getInstance().deleteColdStartScale(this.specificSession?.session?.parentId);
        }
      }, () => {
        this.opacityNum = 1;
      });
      this.notifyPipSizeChange();
    }, delayTime);
  }

  private processAutoStartDefault(targetScale: number): void {
    let originScale: number = targetScale / 4;
    this.scaleValue = originScale;
    this.opacityNum = 0;
    this.specificSession.visibility = true;
    let delayTime = 600;
    if (DeviceHelper.isEmulator()) {
      delayTime = 0;
    }
    this.shadowStyle = undefined;
    setTimeout(() => {
      SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'pipAutoStart');
      this.foregroundBlur = 200;
      animateTo({ curve: curves.cubicBezierCurve(0, 0, 0.67, 1.00), duration: 200,
        onFinish: () => {
          this.foregroundBlur = -1;
        }
      }, () => {
        this.foregroundBlur = 0;
      });
      animateTo({ curve: curves.springMotion(0.55, 0.825),
        onFinish: () => {
          SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_window_show')));
          SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'pipAutoStart');
          SCBPiPManager.getInstance().deleteColdStartScale(this.specificSession?.session?.parentId);
        }
      }, () => {
        this.pipBorderRadius = Constants.DEFAULT_PIP_RADIUS;
        this.scaleValue = targetScale;
        this.opacityNum = 1;
        this.shadowStyle = ShadowStyle.OUTER_FLOATING_SM;
      });
      this.notifyPipSizeChange();
    }, delayTime);
  }

  private saveMinScaleValue(scbRect: SCBSessionRect): void {
    let reason = PipRectUpdateReason.DEFAULT;
    let normalRect = this.getNormalRealSize(scbRect, reason);
    let largeRect = this.getLargeRealSize(scbRect, reason);
    this.minScale = this.getScaleValue(largeRect, normalRect);
    AppStorageUtil.setOrCreate<number>(Constants.KEY_PIP_MIN_SCALE_VALUE, this.minScale);
  }

  private getLargeRealSize(scbRect: SCBSessionRect, reason: PipRectUpdateReason) {
    let rotation = this.screenProperty.rotation;
    let isLandscape: boolean = (Math.abs(rotation) === RotationConstants.ROTATION_90 ||
      rotation === RotationConstants.ROTATION_270);
    let largeRect = this.rectCalculator.getRectByScale(this.screenProperty.width, this.screenProperty.height,
      ScaleLevel.SCALE_LEVEL_LARGE, scbRect, isLandscape, reason);
    this.rectCalculator.fixRectSizeIfNeeded(largeRect, this.screenProperty.width, this.screenProperty.height,
      isLandscape);
    return largeRect;
  }

  private getNormalRealSize(scbRect: SCBSessionRect, reason: PipRectUpdateReason) {
    let rotation = this.screenProperty.rotation;
    let isLandscape: boolean = (Math.abs(rotation) === RotationConstants.ROTATION_90 ||
      rotation === RotationConstants.ROTATION_270);
    let normalRect = this.rectCalculator.getRectByScale(this.screenProperty.width, this.screenProperty.height,
      ScaleLevel.SCALE_LEVEL_NORMAL, scbRect, isLandscape, reason);
    this.rectCalculator.fixRectSizeIfNeeded(normalRect, this.screenProperty.width, this.screenProperty.height,
      isLandscape);
    return normalRect;
  }

  private getParentContainerSession(): SCBSceneContainerSession | null {
    if (this.parentId < 0) {
      return null;
    }
    let containerSessionList = SCBScenePanelManager.getInstance().getTotalSessionList();
    let containerSession = containerSessionList.findByPersistentId(this.parentId);
    return containerSession;
  }

  private getParentWindowMode(): SCBSceneMode {
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.parentId);
    if (parentSession && parentSession instanceof SCBSceneSession) {
      return (parentSession as SCBSceneSession).sceneInfo.windowMode;
    }
    return SCBSceneMode.UNDEFINED;
  }

  processStart(rect: sceneSessionManager.SessionRect): void {
    this.isShowDefaultBackground = false;
    this.delayRotation = true;
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showError(`processStart: container session not valid`);
      this.calculateNormalSourceRect(rect);
      return;
    }

    try {
      if (containerSession.isFloat) {
        this.calculateFloatSourceRect(containerSession, rect);
      } else if (containerSession.isSplit) {
        this.calculateSplitSourceRect(containerSession, rect);
      } else if (containerSession.isMidScene) {
        this.calculateMidSourceRect(containerSession, rect);
      } else {
        this.calculateNormalSourceRect(rect);
      }
    } catch (err) {
      log.showError(`processStart: error occured, use normal replace.`);
      this.calculateNormalSourceRect(rect);
    }
  }

  processPreRestore(): void {
    log.showInfo(`processPreRestore is called`);
    this.delayRotation = true;
    this.shouldDoRestore = true;
    this.isShowDefaultBackground = false;
    let containerSession = this.getParentContainerSession();
    const screenSession = SCBScreenSessionManager.getInstance()
      .getScreenSession(containerSession?.screenProperty.screenId);
    if (!screenSession) {
      log.showError('processPreRestore: fail to get screenSession');
      return;
    }
    // 通知systemUI退出画中画
    if (containerSession) {
      PipSceneManager.instance.removePipScene(containerSession);
    }
    if (!containerSession) {
      log.showError('processPreRestore: fail to get containerSession');
      return;
    }
    // whether rotation is required during vertical restoration
    let targetRotation: number = SCBPiPManager.getInstance().executeRestoreWithRotationCallback(containerSession,
      screenSession, false);
    let sensorRotation: number = screenSession.sensorScreenProperty.rotation;
    let isSensorVertical: boolean = sensorRotation === 0 || sensorRotation === 180;
    let isTargetHorizontal: boolean = targetRotation !== 0 && targetRotation !== 180;
    let isVerticalRotation: boolean = isSensorVertical && isTargetHorizontal;
    let isFoldLandscape = !screenSession.sensorScreenProperty.isScreenVertical();
    if (containerSession?.isMidScene || AppStorage.get('scenePanelState') === ScenePanelState.SPLIT ||
        this.isRestoreFromRecent || isFoldLandscape || isVerticalRotation) {
      log.showInfo(`processPreRestore: processPreRestoreDefault`);
      this.processPreRestoreDefault();
    } else {
      log.showInfo(`processPreRestore: processPreRestoreOneShot`);
      this.restoreOneShot = true;
      this.processPreRestoreOneShot();
    }
    // make sure black background can be destroy
    setTimeout(() => {
      this.makeSureRestore();
    }, Constants.RESTORE_TIME_OUT);
  }

  private processPreRestoreDefault(): void {
    this.updateScaleWithoutMove(0, 0);
    animateTo({ curve: curves.springMotion(0.45, 0.825)}, () => {
      this.setRectToFitScreen();
      this.pipBorderRadius = 4;
    });
    animateTo({ curve: Curve.Linear, duration: 200, onFinish: ()=> {
      SCBSceneSessionManager.getInstance().startSceneFromPiP(this.parentId);
      const restoreTimeId = setTimeout(()=> {
        SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
      }, Constants.RESET_PIP_RESTORE_TIMEOUT);
      this.timeoutIds.push(restoreTimeId);
    }}, () => {
      this.pipBackgroundOpacity = 1;
    });
  }

  private processPreRestoreOneShot(): void {
    SCBSceneSessionManager.getInstance().startSceneFromPiP(this.parentId, true);
    const restoreTimeId = setTimeout(()=> {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    }, Constants.RESET_PIP_RESTORE_TIMEOUT);
    this.timeoutIds.push(restoreTimeId);
    this.restoreOneShot = true;
    this.shadowStyle = undefined;
    animateTo({
      curve: Curve.Linear,
      duration: 200,
      onFinish: () => {
        this.isPiPVisibility = false;
      }
    }, () => {
      this.opacityNum = 0;
    });
  }

  processDoRestore(): void {
    if (this.shouldDoRestore) {
      log.showInfo(`processDoRestore is called`);
      this.shouldDoRestore = false;
      // when app is in foreground state, get XComponent position
      setTimeout(() => {
        this.fetchComponentRect();
      }, 200)
    }
  }

  fetchComponentRect() {
    this.specificSession?.session?.setPipActionEvent(Constants.ACTION_PREPARE_SOURCE);
    setTimeout(() => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_LOCATE_SOURCE);
    }, Constants.DELAY_GET_LOCATE_SOURCE)
  }

  processAfterRestore(rect: sceneSessionManager.SessionRect): void {
    log.showInfo(`processAfterRestore is called`);
    if (!this.isRestoreFromBg) {
      this.processAfterRestoreFromFg(rect);
      return;
    }
    this.shouldAnimToSource = (rect.width_ > 0 && rect.height_ > 0) &&
      this.nearEqual(this.overlayRect.width.getPx() * rect.height_, this.overlayRect.height.getPx() * rect.width_);
    if (!this.restoreOneShot && this.shouldAnimToSource) {
      this.processAfterRestoreFromBgWithAnim(rect);
    } else {
      this.processAfterRestoreFromBg(id, rect);
    }
  }

  private processAfterRestoreFromBg(id: string, rect: sceneSessionManager.SessionRect): void {
    let isPrivacyMode: boolean = false;
    let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.specificSession.session.parentId);
    if (parentSession !== null && parentSession instanceof SCBSceneSession) {
      isPrivacyMode = parentSession.sessionData.isPrivacyWindow;
    }
    this.isNeedFreeze = isPrivacyMode;
    Trace.start(`processAfterRestoreFromBg-${id}`);
    componentSnapshot.get(id).then((pixelMap: image.PixelMap) => {
      this.processAfterRestoreInner(pixelMap, rect);
      Trace.end(`processAfterRestoreFromBg-${id}`);
    }).catch((err: Error) => {
      log.showError(`processAfterRestoreFromBg error, msg: ${err.message}`);
      this.processAfterRestoreInner(null, rect);
      Trace.end(`processAfterRestoreFromBg-${id}`);
    })
  }

  private processAfterRestoreInner(pixelMap: image.PixelMap | null, rect: sceneSessionManager.SessionRect) {
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showInfo(`processAfterRestore: container session not valid`);
      this.calculateNormalSourceRect(rect);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    // Use component snapshot
    if (!this.isNeedFreeze) {
      this.useSnapshot = true;
      this.cachePixMap = pixelMap;
    }
    const restoreInnerTimeoutId = setTimeout(()=> {
      this.specificSession.visibility = this.isNeedFreeze ? true : false;
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
    }, Constants.DELAY_CLOSE_FOR_SNAPSHOT);
    this.timeoutIds.push(restoreInnerTimeoutId);
    this.calculateSourceRect(rect, containerSession);
    if (!this.restoreOneShot) {
      this.opacityNum = 1;
      animateTo({ delay: 150, curve: Curve.Linear, duration: 150}, () => {
        this.pipBackgroundOpacity = 0;
        this.opacityNum = 0;
      });
    }
    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
    const restoreActionTimeoutId = setTimeout(() => {
      this.isNeedFreeze = false;
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
    }, 300);
    this.timeoutIds.push(restoreActionTimeoutId);
  }

  private processAfterRestoreFromBgWithAnim(rect: sceneSessionManager.SessionRect) {
    log.showInfo(`processAfterRestoreFromBgWithAnim is called`);
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showInfo(`processAfterRestore: container session not valid`);
      this.calculateNormalSourceRect(rect);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    this.calculateSourceRect(rect, containerSession);
    animateTo({ curve: Curve.Linear, duration: 400}, () => {
      this.pipBackgroundOpacity = 0;
    });

    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
    animateTo({ curve: curves.springMotion(0.2733, 1.157)}, () => {
      this.setRectToSource();
      this.pipBorderRadius = 4;
    });

    setTimeout(() => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
    }, 400);
  }

  private processAfterRestoreFromFg(rect: sceneSessionManager.SessionRect) {
    log.showInfo(`processAfterRestoreFromFg is called`);
    if (rect.width_ === 0 || rect.height_ === 0) {
      this.processClose();
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    let containerSession = this.getParentContainerSession();
    if (containerSession === null || containerSession === undefined) {
      log.showInfo(`processAfterRestore: container session not valid`);
      this.calculateNormalSourceRect(rect);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
      return;
    }
    this.calculateSourceRect(rect, containerSession);
    this.updateScaleWithoutMove(0, 0);
    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
    animateTo({ curve: curves.springMotion(0.2733, 1.157)}, () => {
      this.setRectToSource();
      this.isShowDefaultBackground = false;
      this.pipBorderRadius = 4;
    });
    const restoreFromFgTimeId = setTimeout(() => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
      scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, false);
    }, 500);
    this.timeoutIds.push(restoreFromFgTimeId);
  }

  private nearEqual(a: number, b: number): boolean {
    return Math.abs(a - b) < Constants.MINI_VALUE;
  }

  private calculateSourceRect(rect: sceneSessionManager.SessionRect, containerSession: SCBSceneContainerSession) {
    this.isRestoreDone = true;
    if (rect.width_ === 0 || rect.height_ === 0) {
      rect.width_ = this.sourceRect.width.getPx();
      rect.height_ = this.sourceRect.height.getPx();
    }
    try {
      if (containerSession.isFloat) {
        this.calculateFloatSourceRect(containerSession, rect);
      } else if (containerSession.isSplit && containerSession.isActive) {
        this.calculateSplitSourceRect(containerSession, rect);
      } else if (containerSession.isMidScene && containerSession.isActive) {
        this.calculateMidSourceRect(containerSession, rect);
      } else {
        this.calculateNormalSourceRect(rect);
      }
    } catch (err) {
      log.showError(`processAfterRestore: error occured, use normal replace.`);
      this.calculateNormalSourceRect(rect);
    }
  }

  makeSureRestore() {
    if (this.isRestoreDone) {
      return;
    }
    log.showInfo(`makeSureRestore is called`);
    animateTo({ curve: Curve.Linear, duration: 100, onFinish: () => {
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_RESTORE);
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
    }}, () => {
      this.opacityNum = 0;
      this.pipBackgroundOpacity = 0;
    });
    if (this.activeRotation !== undefined) {
      this.activeRotation();
    }
  }

  calculateNormalSourceRect(rect: sceneSessionManager.SessionRect): void {
    this.sourceRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
    log.showInfo(`calculateNormalSourceRect, normal source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  calculateFloatSourceRect(containerSession: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (containerSession === null || containerSession === undefined) {
      throw new Error(`container session is not valid`);
    }
    if (!containerSession.isFloat) {
      throw new Error(`container session is not in floating`);
    }
    let scale = containerSession.floatingParam.scale;
    let posX = vp2px(containerSession.needRenderPos.posX);
    let posY = vp2px(containerSession.needRenderPos.posY);
    this.sourceRect.setRectNum(posX + scale * rect.posX_, posY + scale * rect.posY_,
      rect.width_ * scale, rect.height_ * scale);
    log.showInfo(`calculateFloatSourceRect, floating source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  calculateSplitSourceRect(containerSession: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (containerSession === null || containerSession === undefined) {
      throw new Error(`container session is not valid`);
    }
    if (!containerSession.isSplit) {
      throw new Error(`container session is not in split`);
    }
    if (containerSession.isOneStepSplit()) {
      log.showInfo(`calculateSplitSourceRect: one step`);
      SCBSceneSessionManager.getInstance().maximizeSplit(this.screenProperty.screenId, this.parentId);
      this.calculateNormalSourceRect(rect);
      return;
    }
    let session: SCBSceneSession | null = null;
    if (containerSession.primarySession?.session.persistentId === this.parentId) {
      session = containerSession.primarySession;
    } else if (containerSession.secondarySession?.session.persistentId === this.parentId) {
      session = containerSession.secondarySession;
    } else {
      throw new Error(`container session can't find parent session`);
    }
    if (session === null) {
      throw new Error(`container session can't find parent session`);
    }
    let posX = session?.currRect.left.getPx();
    let posY = session?.currRect.top.getPx();
    this.sourceRect.setRectNum(posX + rect.posX_, posY + rect.posY_, rect.width_, rect.height_);
    log.showInfo(`calculateSplitSourceRect: split source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  calculateMidSourceRect(containerSession: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (containerSession === null || containerSession === undefined) {
      throw new Error(`container session is not valid`);
    }
    if (!containerSession.isMidScene) {
      throw new Error(`container session is not in midScene`);
    }

    let session: SCBSceneSession | undefined = undefined;
    for (let value of containerSession.midSceneMap) {
      if (value[1]?.session.persistentId === this.parentId) {
        session = value[1];
        break;
      }
    }
    if (!session) {
      throw new Error(`container session can't find parent session`);
    }
    let posX = session?.currRect.left.getPx();
    let posY = session?.currRect.top.getPx();
    this.sourceRect.setRectNum(posX + rect.posX_ * MID_ZOOM_RATIO, posY + rect.posY_ * MID_ZOOM_RATIO,
      rect.width_ * MID_ZOOM_RATIO, rect.height_ * MID_ZOOM_RATIO);
    log.showInfo(`calculateMidSourceRect: mid source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  private calculateFreeWindowsRect(container: SCBSceneContainerSession, rect: sceneSessionManager.SessionRect): void {
    if (container === null || container === undefined) {
      throw new Error(`container session is not valid`);
    }
    let scene: SCBSceneSession | null = null;
    if (container.primarySession?.session.persistentId === this.parentId) {
      scene = container.primarySession;
    } else if (container.secondarySession?.session.persistentId === this.parentId) {
      scene = container.secondarySession;
    } else {
      throw new Error(`container session can't find parent session`);
    }
    if (!scene) {
      throw new Error(`container session can't find parent session`);
    }
    let posX = scene.currRect.left.getPx();
    let posY = scene.currRect.top.getPx();
    this.sourceRect.setRectNum(posX + rect.posX_, posY + rect.posY_, rect.width_, rect.height_);
    log.showInfo(`calculateFreeWindowsRect, source rect = ${this.getSCBSessionRectInfo(this.sourceRect)}`);
  }

  private setRect(targetRect: SCBSessionRect) {
    this.rect && this.rect.copyFrom(targetRect);
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.scaleValue = 1;
    this.overlayRect.copyFrom(targetRect);
  }

  private setRectToFitScreen(): void {
    let screenRect = new SCBSessionRect(0, 0, this.screenProperty.width, this.screenProperty.height);
    let screenScale: number = this.getScaleValue(this.rect, screenRect);
    let sourceWidth = this.rect.width.getPx() * screenScale;
    let sourceHeight = this.rect.height.getPx() * screenScale;
    let x = screenRect.left.getPx() + screenRect.width.getPx() / 2;
    let y = screenRect.top.getPx() + screenRect.height.getPx() / 2;
    let newX = x - sourceWidth / 2;
    let newY = y - sourceHeight / 2;
    this.scaleValue = screenScale;
    this.shouldAnimToSource = (newY !== 0 || newX === 0);
    this.rect && this.rect.setPosNum(newX, newY);
    this.overlayRect.setRectNum(newX, newY, sourceWidth, sourceHeight);
  }

  private setRectToSource(): void {
    let sourceScale: number = this.getScaleValue(this.rect, this.sourceRect);
    let sourceWidth = this.rect.width.getPx() * sourceScale;
    let sourceHeight = this.rect.height.getPx() * sourceScale;
    let x = this.sourceRect.left.getPx() + this.sourceRect.width.getPx() / 2;
    let y = this.sourceRect.top.getPx() + this.sourceRect.height.getPx() / 2;
    let newX = x - sourceWidth / 2;
    let newY = y - sourceHeight / 2;
    this.scaleValue = sourceScale;
    this.rect && this.rect.setPosNum(newX, newY);
  }

  private getScaleValue(originRect: SCBSessionRect, targetRect: SCBSessionRect): number {
    let scaleX = targetRect.width.getPx() / originRect.width.getPx();
    let scaleY = targetRect.height.getPx() / originRect.height.getPx();
    return Math.min(scaleX, scaleY);
  }

  private overlayRectMoveTo(x: number, y: number) {
    let offsetX = x - this.overlayRect.left.getPx();
    let offsetY = y - this.overlayRect.top.getPx();
    this.overlayRect.setPosNum(x, y);
    this.rect.setPosNum(this.rect.left.getPx() + offsetX, this.rect.top.getPx() + offsetY);
}

  private checkSafePadding() {
    let displayWidth: number = this.screenProperty.width;
    let displayHeight: number = this.screenProperty.height;
    let safePaddingHorizontal: number = vp2px(Constants.SAFE_PADDING_HORIZONTAL_VP);
    if (this.overlayRect.left.getPx() < safePaddingHorizontal) {
      this.overlayRect.left = new ScbNumber(safePaddingHorizontal);
      this.rect.left = new ScbNumber(safePaddingHorizontal);
    } else if ((this.overlayRect.left.getPx() + this.overlayRect.width.getPx()) >
      (displayWidth - safePaddingHorizontal)) {
      this.overlayRect.left = new ScbNumber(displayWidth - safePaddingHorizontal - this.overlayRect.width.getPx());
      this.rect.left = new ScbNumber(displayWidth - safePaddingHorizontal - this.rect.width.getPx());
    }

    if (this.overlayRect.top.getPx() < Constants.SAFE_PADDING_VERTICAL_TOP) {
      this.overlayRect.top = new ScbNumber(Constants.SAFE_PADDING_VERTICAL_TOP);
      this.rect.top = new ScbNumber(Constants.SAFE_PADDING_VERTICAL_TOP);
    } else if ((this.overlayRect.top.getPx() + this.overlayRect.height.getPx()) >
      (displayHeight - vp2px(Constants.DEFAULT_PIP_CONTENT_AVOID_AREA))) {
      this.overlayRect.top = new ScbNumber(displayHeight - this.navAvoidHeight - this.overlayRect.height.getPx());
      this.rect.top = new ScbNumber(displayHeight - this.navAvoidHeight - this.overlayRect.height.getPx());
    }
  }

  private updateScaleWithoutMove(px: number, py: number) {
    let x = this.overlayRect.left.getPx() + px * this.overlayRect.width.getPx() - px * this.rect.width.getPx();
    let y = this.overlayRect.top.getPx() + py * this.overlayRect.height.getPx() - py * this.rect.height.getPx();
    log.showInfo(`updateScaleWithoutMove x = ${x}, y = ${y}, px = ${px}, py = ${py}`);
    this.centerScaleX = (px * 100) + '%';
    this.centerScaleY = (py * 100) + '%';
    this.rect && this.rect.setPosNum(x, y);
  }

  private processEdge(onFinishCallback?: () => void) {
    if (!this.hasZoomed) {
      this.processEdgeSpringBack(onFinishCallback);
    } else {
      this.processEdgeHide();
    }
  }

  private processEdgeHide() {
    log.showInfo(`processEdgeHide centerX = ${this.centerScaleX}, centerY = ${this.centerScaleY}`);
    if (this.zooming) {
      // rect edge zoom is animating
      log.showInfo('processEdgeHide: zooming, delay half hide');
      this.needDelayProcessHide = true;
      return;
    }
    this.isEdgeHideInterrupt = true;
    PipReportEventUtil.reportPipDisplayEvent(PIP_HIDE, DisplayReason.BORDER, this.bundleName);
    this.showSideBar = true;
    // store before hide in sideManager status
    SCBPiPManager.getInstance().pipSideManagerInfo.originScale = this.moveStartScale;
    SCBPiPManager.getInstance().pipSideManagerInfo.originRadius = this.pipBorderRadius / this.moveStartScale;
    SCBPiPManager.getInstance().pipSideManagerInfo.sideDirect = this.moveEndTransX < 0 ? 'left' : 'right';
    SCBPiPManager.getInstance().pipSideManagerInfo.originRect.setRect(this.moveStartOverlayRect.left,
      this.moveStartOverlayRect.top, this.moveStartRect.width, this.moveStartRect.height);
    // cal real specificSession current rect
    this.realRectWidth = this.rect.width.getVp() * this.scaleValue;
    this.realRectHeight = this.rect.height.getVp() * this.scaleValue;
    // update pip window postion
    this.centerScaleX = '0';
    this.centerScaleY = '0';
    this.rect.left = new ScbNumber(this.rect.left.getPx() + vp2px(this.scaleTransX));
    this.rect.top = new ScbNumber(this.rect.top.getPx());
    SCBPiPManager.getInstance().needBlockShowOverlayCount++;
    // do hide in sideManager animation
    animateTo({
      curve: curves.springMotion(0.4, 0.8),
      onFinish: () => {
        if (this.isEdgeHideInterrupt) {
          this.isEdgeHideInterrupt = false;
          this.pipWindowHideInSideManager();
          this.specificSession.session.setPrivacyMode(false);
          SCBPiPManager.getInstance().needBlockShowOverlayCount--;
          this.moveAnimateCount--;
        }
      }
    }, () => {
      if (this.overlaySceneSession !== null && this.overlaySceneSession !== undefined) {
        this.overlaySceneSession.setVisibility(false);
        this.overlaySceneSession.setActive(false);
        this.overlaySceneSession.setSessionTouchable(false);
      }
      this.pipWindowHideAmin();
    })
  }

  /**
   * interrupt animation of processing edge
   */
  private processEdgeHideInterrupt(): void {
    log.showInfo('processEdgeHideInterrupt');
    if (this.overlaySceneSession) {
      this.overlaySceneSession.setVisibility(true);
      this.overlaySceneSession.setActive(true);
      this.overlaySceneSession.setSessionTouchable(true);
    }
    SCBPiPManager.getInstance().needBlockShowOverlayCount--;
    this.isEdgeHideInterrupt = false;
    this.pipWindowHideInSideManager();
  }

  private pipWindowHideAmin() {
    this.realRectWidth = SIDE_EDGE_WIDTH;
    this.realRectHeight = SIDE_EDGE_HEIGHT;
    this.opacityNum = 0;
    this.shadowStyle = undefined;
    if (this.moveEndTransX < 0) {
      this.rect.setPosNum(vp2px(-SIDE_EDGE_WIDTH / 2), vp2px(0));
    } else {
      this.rect.setPosNum(this.screenProperty.width - vp2px(SIDE_EDGE_WIDTH / 2),
        vp2px(0));
    }
    log.showInfo(`transX: ${this.transX}, transY: ${this.transY}`);
  }

  private pipWindowHideInSideManager() {
    let containerSession = SCBScenePanelManager.getInstance().getTotalSessionList().
    findByPersistentId(this.specificSession.session.parentId);
    if (containerSession) {
      SCBSceneSessionManager.getInstance().enterSideEdgeBar(containerSession.screenProperty.screenId,
        this.specificSession.session.persistentId);
    }
    this.rect.setPosNum(this.moveStartOverlayRect.left.getPx(), this.moveStartOverlayRect.top.getPx());
    this.overlayRect.setPosNum(this.moveStartOverlayRect.left.getPx(), this.moveStartOverlayRect.top.getPx());
    this.isInSideManager = true;
    this.opacityNum = 1;
    this.showSideBar = false;
  }

  private avoidHorizontalCamera(rect: SCBSessionRect, avoidRect: SCBSessionRect): SCBSessionRect {
    let retRect = rect.copy();
    let left = rect.left.getPx();
    let right = rect.left.getPx() + rect.width.getPx();
    let width = rect.width.getPx();

    let avoidLeft = avoidRect.left.getPx();
    let avoidRight = avoidRect.left.getPx() + avoidRect.width.getPx();

    if (left < avoidRight && right > avoidLeft) {
      if (this.screenProperty.rotation === RotationConstants.ROTATION_90) {
        retRect.setPosNum(left - (right - avoidLeft) - vp2px(Constants.DEFAULT_PIP_CAMERA_AVOID_AREA),
          rect.top.getPx());
      } else if (this.screenProperty.rotation === RotationConstants.ROTATION_270) {
        retRect.setPosNum(avoidRight + vp2px(Constants.DEFAULT_PIP_CAMERA_AVOID_AREA),
          rect.top.getPx());
      }
    }
    return retRect;
  }

  private processEdgeSpringBack(onFinishCallback?: () => void) {
    log.showInfo('processEdgeSpringBack: start');
    let horAvoid = vp2px(Constants.DEFAULT_PIP_LEFT_AVOID_AREA);
    animateTo({
      curve: curves.springMotion(0.45, 0.825),
      onFinish: onFinishCallback
    }, () => {
      let top = this.overlayRect.top.getPx();
      let bottom = this.overlayRect.top.getPx() + this.overlayRect.height.getPx();
      let height = this.overlayRect.height.getPx();
      let left = this.overlayRect.left.getPx();
      let right = this.overlayRect.left.getPx() + this.overlayRect.width.getPx();
      let width = this.overlayRect.width.getPx();
      let overlayTop = this.overlayRect.top.getPx();
      let overlayLeft = this.overlayRect.left.getPx();
      if (this.rectCalculator.isFolded() && DeviceHelper.isLandscape() &&
        PipRectCalculator.calculateOverlap(this.overlayRect, this.rectCalculator.getCameraAvoidArea()) !== null) {
        let movedRect = PipRectCalculator.positionAfterAvoid(this.overlayRect,
          this.rectCalculator.getCameraAvoidArea(), this.screenProperty);
        top = movedRect.top.getPx();
        bottom = movedRect.top.getPx() + movedRect.height.getPx();
        left = movedRect.left.getPx();
        right = movedRect.left.getPx() + this.overlayRect.width.getPx();
        overlayTop = movedRect.top.getPx();
        overlayLeft = movedRect.left.getPx();
      }
      if (top < this.topAvoidHeight) {
        overlayTop = this.topAvoidHeight;
      }
      if (bottom > this.screenProperty.height - this.bottomAvoidHeight) {
        overlayTop = this.screenProperty.height - height - this.bottomAvoidHeight;
      }
      if (left < horAvoid) {
        overlayLeft = horAvoid;
      }
      if (right > this.screenProperty.width - horAvoid) {
        overlayLeft = this.screenProperty.width - width - horAvoid;
      }
      if (this.rectCalculator.isFolded() && DeviceHelper.isLandscape()) {
        let realtimeRect = new SCBSessionRect(overlayLeft, overlayTop, width, height);
        if (PipRectCalculator.calculateOverlap(realtimeRect, this.rectCalculator.getCameraAvoidArea()) !== null) {
          let updatedRect = this.avoidHorizontalCamera(realtimeRect, this.rectCalculator.getCameraAvoidArea());
          overlayLeft = updatedRect.left.getPx();
          overlayTop = updatedRect.top.getPx();
        }
      }
      this.overlayRectMoveTo(overlayLeft, overlayTop);
    });
    log.showInfo(`processEdgeSpringBack, overlayRect: ${this.getSCBSessionRectInfo(this.overlayRect)}, ` +
      `rect: ${this.getSCBSessionRectInfo(this.rect)} centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} ` +
      `scaleValue: ${this.scaleValue}`);
  }

  private processEdgeZoom() {
    let left: number = this.overlayRect.left.getPx() + vp2px(this.transX);
    let threshold: number = this.overlayRect.width.getPx() / 2;
    if ((left < -threshold) || left > (this.screenProperty.width - threshold)) {
      if (!this.hasZoomed) {
        this.processEdgeZoomIn();
      }
    } else {
      if (this.hasZoomed) {
        this.hasZoomed = false;
        animateTo({ curve: Curve.Smooth, duration: 200 }, () => {
          this.scaleValue = this.zoomScale;
          this.opacityNum = 1;
        });
        this.zoomScale = 1;
      }
    }
  }

  private processEdgeZoomIn() {
    this.updateScaleWithoutMove(0.5, 0);
    this.hasZoomed = true;
    this.zoomScale = this.scaleValue;
    this.zooming = true;
    SCBPiPManager.getInstance().needBlockShowOverlayCount++;
    // trans calculation is incorrect during scale animate
    this.scaleTransX = (1 - this.sideEdgeZoomScale) * this.rect.width.getVp() / 2;
    animateTo({
      curve: Curve.Smooth, duration: 250, onFinish: () => {
        this.zooming = false;
        SCBPiPManager.getInstance().needBlockShowOverlayCount--;
        if (this.needDelayProcessHide) {
          this.needDelayProcessHide = false;
          this.processEdgeHide();
        }
      }
    }, () => {
      this.scaleValue = this.sideEdgeZoomScale;
    });
  }

  private processRotation() {
    let newRect: SCBSessionRect = this.rectCalculator.updatePipRect(
      this.rect.copy(), PipRectUpdateReason.REASON_ROTATION_CHANGE, this.screenProperty);
    log.showInfo(`rotationRect = ${this.getSCBSessionRectInfo(newRect)}`);
    if (newRect.width.getPx() === 0 || newRect.height.getPx() === 0) {
      log.showWarn('rotation failed: rect not valid');
      return;
    }
    log.showInfo('process rotation');
    this.isRotating = true;
    let largeRect = this.getLargeRealSize(newRect, PipRectUpdateReason.REASON_ROTATION_CHANGE);
    this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
    if (this.isInSideManager === false) {
      this.updateScaleWithoutMove(0, 0);
    }
    animateTo({
      curve: curves.springMotion(0.45, 0.825, 0),
      onFinish: () => {
        this.isRotating = false;
        SCBPiPManager.getInstance().isNeedRotation = false;
        this.updateBottomAvoidHeight();
        this.processEdgeSpringBack();
        }
      }, () => {
      if (this.isInSideManager === true) {
        this.setRect(newRect);
        this.rect.setSizeNum(largeRect.width.getPx(), largeRect.height.getPx());
        this.scaleValue = this.getScaleValue(this.rect, newRect);
        this.zoomScale = this.scaleValue;
      } else {
        this.rect.setPosNum(newRect.left.getPx(), newRect.top.getPx());
        this.overlayRect = newRect.copy();
        this.scaleValue = this.getScaleValue(this.rect, newRect);
        log.showInfo(`rotaion show rect move to ${this.getSCBSessionRectInfo(this.rect)}, overlayRect: ` +
          `${this.getSCBSessionRectInfo(this.overlayRect)} ` +
          `centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} scaleValue: ${this.scaleValue}`);
      }
    })
  }

  private processScale(): void {
    if (this.isClickInSidebarInterrupt) {
      this.clickInsideBarInterrupt();
    }
    let oldRect = this.overlayRect.copy();
    let type = ScaleChangeType.DEFAULT;
    if (this.rectSizeLevel === SCALE_NORMAL && this.afterDragScale > this.beforeDragScale) {
      type = ScaleChangeType.NORMAL_TO_MIDDLE;
    } else if (this.rectSizeLevel === SCALE_LARGE && this.afterDragScale < this.beforeDragScale) {
      type = ScaleChangeType.LARGE_TO_MIDDLE;
    } else {
      type = ScaleChangeType.DEFAULT;
    }
    let newRect = this.rectCalculator.updatePipRect(oldRect, PipRectUpdateReason.REASON_PIP_SCALE_CHANGE,
      this.screenProperty, type);
    log.showInfo(`scale: newRect = ${this.getSCBSessionRectInfo(newRect)}, ` +
      `oldRect = ${this.getSCBSessionRectInfo(oldRect)}`);
    if (newRect.width.getPx() === 0 || newRect.height.getPx() === 0 ||
      newRect.width.getPx() == oldRect.width.getPx() || newRect.height.getPx() == oldRect.height.getPx()) {
      log.showError('scale: rect not valid');
      return;
    }
    // update new center
    let centerX = (newRect.left.getPx() - oldRect.left.getPx()) / (oldRect.width.getPx() - newRect.width.getPx());
    let centerY = (newRect.top.getPx() - oldRect.top.getPx()) / (oldRect.height.getPx() - newRect.height.getPx());
    this.updateScaleWithoutMove(centerX, centerY);

    let scaleValue = this.getScaleValue(this.rect, newRect);
    animateTo({
      curve: curves.springMotion(0.45, 0.825, 0)
    }, () => {
      this.scaleValue = scaleValue;
    });
    this.overlayRect && this.overlayRect.copyFrom(newRect);
    let scaleLevel: number = this.rectCalculator.getScaleLevelInt();
    PipReportEventUtil.reportPipResizeEvent(
      scaleLevel, this.rect.width.getPx(), this.rect.height.getPx(), this.bundleName);
    this.updateBottomAvoidHeight();
    this.processEdgeSpringBack();
    this.notifyPipSizeChange();
    let containerSession = this.getParentContainerSession();
    if (containerSession && containerSession.isStartPiPInterrupt) {
      PipOneShotAnimHelper.onFinishStartPiPInterrupt(containerSession);
    }
    log.showInfo(`scale: end. overlayRect = ${this.getSCBSessionRectInfo(this.overlayRect)}, ` +
      `rect = ${this.getSCBSessionRectInfo(this.rect)}`);
  }

  private processClose(closeType: string = Constsnts.ACTION_CLOSE) {
    Trace.start(`processClose_snapshot_${id}`);
    componentSnapshot.get(id).then((pixelMap: image.PixelMap) => {
      this.processCloseInner(pixelMap, closeType);
      Trace.end(`processClose_snapshot_${id}`);
    }).catch((err: Error) => {
      log.showError(`processClose error, msg: ${err.message}`);
      this.processCloseInner(null, closeType);
      Trace.end(`processClose_snapshot_${id}`);
    })
  }

  private processCloseInner(pixelMap: image.PixelMap | null, closeType: string): void {
    this.closed = true;
    this.useSnapshot = true;
    this.opacityNum = 1;
    this.updateScaleWithoutMove(0.5, 0.5);
    this.cachePixMap = pixelMap;
    PipOneShotAnimHelper.unSubscribeGestureEvent();
    const closeTimeId = setTimeout(()=> {
      this.specificSession.visibility = false;
      this.specificSession?.session?.setPipActionEvent(closeType);
    }, Constants.DELAY_CLOSE_FOR_SNAPSHOT);
    this.timeoutIds.push(closeTimeId);
    if (this.hasZoomed) {
      this.isShowDefaultBackground = false;
      this.opacityNum = 0;
    }
    this.shadowStyle = undefined;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'pipClose');
    animateTo({ curve: curves.springMotion(0.55, 1, 0), onFinish: ()=> {
      SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'pipClose');
    }}, () => {
      this.scaleValue = this.scaleValue * 0.25;
      this.pipBorderRadius = 4;
    });
    this.foregroundBlur = 25;
    animateTo({
      curve: Curve.Linear, duration: 200, onFinish: ()=> {
        this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
        this.foregroundBlur = -1;
      }
    }, () => {
      this.opacityNum = 0;
      this.foregroundBlur = 200;
    });

    // 通知systemUI退出画中画
    const containerSession = this.getParentContainerSession();
    if (containerSession) {
      PipSceneManager.instance.removePipScene(containerSession);
    }
  }

  private onActionMoveStart(event: GestureEvent): void {
    log.showInfo('onActionMoveStart');
    SCBPiPManager.getInstance().needBlockShowOverlayCount++;
    // adjust zIndex to show above the input method when move.
    this.moveAnimateCount++;
    this.updatePanelZIndex(SCBDefaultZIndex.INPUT_METHOD_BELOW_KEYGUARD + 2);
    let containerSession = this.getParentContainerSession();
    if (containerSession && containerSession.isStartPiPInterrupt) {
      PipOneShotAnimHelper.onFinishStartPiPInterrupt(containerSession);
    }
    this.rectCalculator.setIsMoving(true);
    let rectHeight = this.rect.height.getPx();
    let rectWidth = this.rect.width.getPx();
    if (rectHeight === 0 || rectWidth === 0) {
      log.showError('rectHeight or rectWidth is zero');
      return;
    }
    this.updateScaleWithoutMove(0.5, 0);
    this.sideEdgeZoomScale = vp2px(SIDE_EDGE_HEIGHT) / rectHeight;
    PipReportEventUtil.reportPipMoveEvent(this.bundleName);
    this.moveStartOverlayRect.copyFrom(this.overlayRect);
    this.moveStartRect.copyFrom(this.rect);
    this.moveStartScale = this.scaleValue;
    this.doGestureMoveStartScale();
  }

  private onActionMove(event: GestureEvent): void {
    animateTo({
      curve: Constants.DRAG_MOVE_CURVE
    }, () => {
      this.transX = event.offsetX;
      this.transY = event.offsetY;
    });
    this.processEdgeZoom();
  }

  private onActionMoveEndOrCancel(event?: GestureEvent): void {
    log.showInfo('onActionMoveEndOrCancel');
    SCBPiPManager.getInstance().needBlockShowOverlayCount--;
    this.doGestureMoveRestore();
    this.doGestureMoveInertialSliding(event);
    this.rectCalculator.setIsMoving(false);
    this.rect.setPosNum(this.rect.left.getPx() + vp2px(this.transX) + vp2px(this.transXOffset),
      this.rect.top.getPx() + vp2px(this.transY) + vp2px(this.transYOffset));
    this.overlayRect.setPosNum(this.overlayRect.left.getPx() + vp2px(this.transX) + vp2px(this.transXOffset),
      this.overlayRect.top.getPx() + vp2px(this.transY) + vp2px(this.transYOffset));
    // restore transX
    this.moveEndTransX = this.transX + this.transXOffset;
    this.moveEndTransY = this.transY + this.transYOffset;
    this.transX = 0;
    this.transY = 0;
    this.transXOffset = 0;
    this.transYOffset = 0;
    if (this.isDumpsterClosePip) {
      log.showInfo('onActionMoveEndOrCancel skip processing edge and saving pip position for closing by dumpster');
      return;
    }
    this.processEdge(this.onMoveEdgeSpringBackAnimationFinished);
    if (this.hasZoomed) {
      return;
    }
    let newRect: SCBSessionRect = this.overlayRect.copy();
    this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
    this.rectCalculator.updatePipRectPivotInfo(newRect, this.screenProperty.width, this.screenProperty.height);
    this.rectCalculator.updateQuadrantAndPos(this.overlayRect, this.screenProperty.width, this.screenProperty.height);
    this.isRecoveryAvoidInput = false;
  }

  private doGestureMoveStartScale() {
    animateTo({
      curve: Constants.DRAG_MOVE_SCALE_CURVE
    }, () => {
      this.scaleValue *= Constants.DRAG_MOVE_SCALE;
    })
  }

  private doGestureMoveRestore() {
    if (this.hasZoomed) {
      log.showInfo('doGestureMoveRestore skip for has zoomed in edge');
      return;
    }
    animateTo({
      curve: Constants.DRAG_MOVE_SCALE_CURVE
    }, () => {
      this.scaleValue = this.moveStartScale;
      this.opacityNum = 1;
    })
  }

  private doGestureMoveInertialSliding(event?: GestureEvent) {
    if (!event) {
      return;
    }
    if (this.hasZoomed) {
      log.showInfo('doGestureMoveInertialSliding skip for has zoomed in edge');
      return;
    }
    // move distance = speed * 1 * 0.08
    let distanceX = event.velocityX * Constants.DRAG_MOVE_INERTIAL_SLIDING_PERCENTAGE;
    let distanceY = event.velocityY * Constants.DRAG_MOVE_INERTIAL_SLIDING_PERCENTAGE;
    animateTo({
      curve: Constants.DRAG_MOVE_INERTIAL_SLIDING_CURVE
    }, () => {
      this.transX += distanceX;
      this.transY += distanceY;
    });
  }

  private onDoubleClick(): void {
    log.showDebug('onDoubleClick');
    this.processScale();
  }

  private onActionClose(): void {
    log.showDebug('onActionClose');
    this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
    this.processClose(Constants.ACTION_PANEL_CLOSE);
    this.notifyRect.setRectNum(0, 0, 0, 0);
    this.notifyScale = 0;
  };

  private doMoveAnimationForDumpsterClosePip(opacity: number, scale: number, transXOffset: number,
    transYOffset: number) {
    if (this.hasZoomed) {
      return;
    }
    animateTo({
      curve: Constants.DRAG_MOVE_DUMPSTER_CLOSE_CURVE
    }, () => {
      this.opacityNum = opacity;
      this.scaleValue = scale;
      this.transXOffset = transXOffset;
      this.transYOffset = transYOffset;
    })
  }

  private onActionMoveEnterDumpsterPreCloseHotArea() {
    log.showInfo('onActionMoveEnterDumpsterPreCloseHotArea');
    this.doMoveAnimationForDumpsterClosePip(1, this.moveStartScale * Constants.DRAG_MOVE_SCALE, 0, 0);
  }

  private onActionMoveEnterDumpsterCloseHotArea() {
    this.updateScaleWithoutMove(0.5, 0.5);
    let rect = this.rect.copy();
    let normalRect = this.getNormalRealSize(rect, PipRectUpdateReason.DEFAULT);
    let normalScale = this.getScaleValue(rect, normalRect);
    let scale = normalScale * Constants.DRAG_MOVE_DUMPSTER_CLOSE_SCALE;
    let pipCenterX = rect.left.getVp() + this.transX + this.transXOffset + rect.width.getVp() / 2;
    let transXOffset = pipCenterX;

    let pipCenterY = rect.top.getVp() + this.transY + this.transYOffset + rect.height.getVp() / 2;
    let transYOffset = (pipCenterY) / 2;
    SCBPiPManager.getInstance().sendAccessibilityEvent(ResUtils.getInnerString($r('app.string.pip_close')));
    this.doMoveAnimationForDumpsterClosePip(Constants.DRAG_MOVE_DUMPSTER_CLOSE_OPACITY, scale, transXOffset,
      transYOffset);
  }

  private onActionMoveDumpsterRecover() {
    log.showInfo('onActionMoveDumpsterRecover');
    this.doMoveAnimationForDumpsterClosePip(1, this.moveStartScale * Constants.DRAG_MOVE_SCALE, 0, 0);
  }

  private onActionUpDumpsterClose() {
    log.showInfo('onActionUpDumpsterClose');
    this.isDumpsterClosePip = true;
    this.processCloseForDumpster();
    this.notifyRect.setRectNum(0, 0, 0, 0);
    this.notifyScale = 0;
  }

  private processCloseForDumpster() {
    Trace.start(`processCloseForDumpster_snapshot_${id}`);
    componentSnapshot.get(id).then((pixelMap: image.PixelMap) => {
      this.processCloseForDumpsterInner(pixelMap);
      Trace.end(`processCloseForDumpster_snapshot_${id}`);
    }).catch((err: Error) => {
      log.showError(`processCloseForDumpster error, msg: ${err.message}`);
      this.processCloseForDumpsterInner(null);
      Trace.end(`processCloseForDumpster_snapshot_${id}`);
    })
  }

  private processCloseForDumpsterInner(pixelMap: image.PixelMap | null) {
    this.closed = true;
    this.useSnapshot = true;
    this.opacityNum = 1;
    this.cachePixMap = pixelMap;
    const closeTimeId = setTimeout(() => {
      this.specificSession.visibility = false;
      this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DUMPSTER_CLOSE);
    }, Constants.DELAY_CLOSE_FOR_SNAPSHOT);
    this.timeoutIds.push(closeTimeId);
    if (this.hasZoomed) {
      this.isShowDefaultBackground = false;
      this.opacityNum = 0;
    }
    this.shadowStyle = undefined;
    SCBSceneSessionManager.getInstance().setVmaCacheStatus(true, 'pipClose');
    animateTo({
      curve: Constants.DRAG_MOVE_DUMPSTER_CLOSE_CURVE, onFinish: () => {
        SCBSceneSessionManager.getInstance().setVmaCacheStatus(false, 'pipClose');
      }
    }, () => {
      this.scaleValue = 0.125;
      this.pipBorderRadius = 4;
    });
    this.foregroundBlur = 25;
    animateTo({
      curve: Constants.DRAG_MOVE_DUMPSTER_CLOSE_CURVE, duration: 200, onFinish: () => {
        this.specificSession?.session?.setPipActionEvent(Constants.ACTION_DESTROY);
        this.foregroundBlur = -1;
        this.isDumpsterClosePip = false;
        this.updatePanelZIndex(SCBDefaultZIndex.PIP_SCENE_PANEL);
      }
    }, () => {
      this.opacityNum = 0;
      this.foregroundBlur = 200;
    });
  }

  private onActionRestore(): void {
    log.showInfo('onActionRestore');
    let scenePanelState: ScenePanelState | undefined = AppStorage.get('scenePanelState');
    if (scenePanelState === ScenePanelState.RECENT) {
      log.showInfo('Restore in recent');
      this.isRestoreFromRecent = true;
      SCBSceneSessionManager.getInstance().exitRecent(this.screenProperty.screenId);
    }
    this.closed = true;
    this.isRecoveryAvoidInput = false;
    // Save point
    this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
    // get valid parentId and start scene, return when not valid
    if (this.parentId < 0) {
      this.parentId = this.specificSession.session.parentId;
      if (this.parentId < 0) {
        log.showError(`Failed to restore pip as invalid parentId: ${this.parentId}`);
        return;
      }
    }
    scbEventExclusiveManager.setEventExclusive(EventType.PIP_RESTORE, true);
    SCBPiPManager.getInstance().startExcludeEventTimeStamp =
      systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    this.specificSession?.session?.setPipActionEvent(Constants.ACTION_PRE_RESTORE);
    let containerSession = this.getParentContainerSession();
    if (containerSession?.isOneStepSplit()) {
      containerSession.dividerParam.isShowIcon = false;
    }
    if (!containerSession?.isActive) {
      this.isRestoreFromBg = true;
      this.processPreRestore();
      return;
    }
    log.showInfo(`onActionRestore: active animation`);
    this.isRestoreFromBg = false;
    this.fetchComponentRect();
    SCBSceneSessionManager.getInstance().startSceneFromPiP(this.parentId);
    const actionRestoreTimeId = setTimeout(()=> {
      SCBSceneSessionManager.getInstance().resetStartingSceneFromPiP();
    }, Constants.RESET_PIP_RESTORE_TIMEOUT);
    this.timeoutIds.push(actionRestoreTimeId);
  }

  private handleDragScaleEventCancel() {
    if (this.isDragScalePip) {
      let nowRatio = this.displayRect.width() / this.rect.width.getVp();
      let limitRatio = Math.min(Math.max(nowRatio, this.minScale), Constants.MAX_RATIO);
      if (!CommonUtils.equals(nowRatio, limitRatio)) {
        this.displayRect.set(0, 0, this.rect.width.getVp() * limitRatio, this.rect.height.getVp() * limitRatio);
        this.displayRect.pinToAnchor();
        animateTo({
          curve: curves.springMotion(0.4, 0.8)
        }, () => {
          this.refreshTrans(false);
        })
      }
      this.overlayRect = this.rect.copy();
      this.overlayRect.setSizeNum(vp2px(this.displayRect.width()), vp2px(this.displayRect.height()));
      this.afterDragScale = this.scaleValue;
      this.dragScaleSpringBack();
      this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
      AppStorage.set(Constants.KEY_PIP_WINDOW_WIDTH, this.overlayRect.width.getPx());
      AppStorage.set(Constants.KEY_PIP_WINDOW_HEIGHT, this.overlayRect.height.getPx());
      AppStorage.set(Constants.KEY_PIP_DRAG_SCALE_VALUE, this.scaleValue);
      this.rectCalculator.setScaleLevel(ScaleLevel.SCALE_LEVEL_MIDDLE);
      this.notifyPipSizeChange();
      this.isDragScalePip = false;
      if (this.overlaySceneSession) {
        this.overlaySceneSession.setVisibility(true);
        this.overlaySceneSession.setActive(true);
        this.overlaySceneSession.setSessionTouchable(true);
      }
    }
    AppStorage.delete(Constants.IS_DRAGGING_PIP);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    log.showInfo(`rotationAfterDraggingIfNeeded rotaion: ${screenSession?.sensorScreenProperty?.rotation}`);
    screenSession?.rotationChangeEntry(screenSession?.sensorScreenProperty?.rotation,
      'AfterDraggingIfNeeded rotation change');
  }
  private handleTouchEvent(event: TouchEvent) {
    if (event) {
      switch (event.type) {
        case TouchType.Down:
          AppStorageUtil.setOrCreate<boolean>(Constants.IS_DRAGGING_PIP, true);
          this.displayRect = PipRect.generateWithContainerSession(this.rect, this.scaleValue);
          break;
        case TouchType.Up:
        case TouchType.Cancel:
          this.handleDragScaleEventCancel();
          break;
        default:
          break;
      }
    }
  }

  private generateResponseRegion(onWindow: boolean = false): Rectangle[] {
    let leftRegion: Rectangle = {
      x: -Constants.DRAG_HOT_WIDTH_OUTER,
      y: 0,
      width: Constants.DRAG_HOT_WIDTH_OUTER + Constants.DRAG_HOT_WIDTH_INNER,
      height: this.rect.height.getVp()
    }
    let rightRegion: Rectangle = {
      x: this.rect.width.getVp() - Constants.DRAG_HOT_WIDTH_INNER,
      y: 0,
      width: Constants.DRAG_HOT_WIDTH_OUTER + Constants.DRAG_HOT_WIDTH_INNER,
      height: this.rect.height.getVp()
    }
    let bottomRegion: Rectangle = {
      x: -Constants.DRAG_HOT_WIDTH_OUTER,
      y: this.rect.height.getVp() - Constants.DRAG_HOT_WIDTH_INNER,
      width: this.rect.width.getVp() + Constants.DRAG_HOT_WIDTH_OUTER * 2,
      height: Constants.DRAG_HOT_WIDTH_OUTER + Constants.DRAG_HOT_WIDTH_INNER
    }
    let topRegion: Rectangle = {
      x: -Constants.DRAG_HOT_WIDTH_OUTER,
      y: -Constants.DRAG_HOT_WIDTH_OUTER,
      width: this.rect.width.getVp() + Constants.DRAG_HOT_WIDTH_OUTER * 2,
      height: Constants.DRAG_HOT_WIDTH_OUTER + Constants.DRAG_HOT_WIDTH_INNER
    }

    return [leftRegion, bottomRegion, rightRegion, topRegion].map(rect => {
      if (onWindow) {
        let newRect: Rectangle = {
          x: vp2px(rect.x as number),
          y: vp2px(rect.y as number),
          width: vp2px(rect.width as number),
          height: vp2px(rect.height as number)
        };
        return newRect;
      }
      return rect;
    });
  }

  private generateOverlayResponseRegion(): Rectangle[] {
    return [{
      x:Constants.DRAG_HOT_WIDTH_INNER,
      y:Constants.DRAG_HOT_WIDTH_INNER,
      width: vp2px(this.overlayRect?.width.getVp() - Constants.DRAG_HOT_WIDTH_INNER),
      height: vp2px(this.overlayRect?.height.getVp() - Constants.DRAG_HOT_WIDTH_INNER)
    }]
  }

  private calcTargetPositionX(reachMaxRatio: boolean, scaleValue: number): number {
    if (!reachMaxRatio) {
      let res = vp2px(this.displayRect.left);
      return res;
    }
    if (this.rectBeforeScale.scale >= scaleValue || this.gesturePin === Pin.LEFT_TOP) {
      return vp2px(this.rectBeforeScale.left);
    }
    if (this.gesturePin === Pin.RIGHT_TOP) {
      return vp2px(this.rectBeforeScale.right - this.displayRect.width());
    }
    return vp2px(this.rectBeforeScale.centerX() - this.displayRect.width() / 2);
  }

  private refreshTrans(reachMaxRatio: boolean): void {
    if (CommonUtils.isInvalid(this.specificSession)) {
      return;
    }
    let beforeScale = this.scaleValue;
    let newScaleValue = this.displayRect.width() / this.rect.width.getVp();
    if (!CommonUtils.equals(beforeScale, newScaleValue)) {
      this.scaleValue = newScaleValue;
    }
    let targetPositionX = this.calcTargetPositionX(reachMaxRatio, newScaleValue);
    let targetPositionY = vp2px(this.displayRect.top);
    if (!CommonUtils.equals(targetPositionX, this.rect.left.getPx()) ||
      !CommonUtils.equals(targetPositionY, this.rect.top.getPx())) {
      this.rect.setPosNum(targetPositionX, targetPositionY);
    }
  }

  private dragScaleSpringBack(onFinishCallback?: () => void) {
    log.showInfo('dragScaleSpringBack: start');
    let horAvoid = vp2px(Constants.DEFAULT_PIP_LEFT_AVOID_AREA);
    let top = this.overlayRect.top.getPx();
    let bottom = this.overlayRect.top.getPx() + this.overlayRect.height.getPx();
    let height = this.overlayRect.height.getPx();
    let left = this.overlayRect.left.getPx();
    let right = this.overlayRect.left.getPx() + this.overlayRect.width.getPx();
    let width = this.overlayRect.width.getPx();
    let overlayTop = this.overlayRect.top.getPx();
    let overlayLeft = this.overlayRect.left.getPx();
    if (this.rectCalculator.isFolded() && DeviceHelper.isLandscape() &&
      PipRectCalculator.calculateOverlap(this.overlayRect, this.rectCalculator.getCameraAvoidArea()) !== null) {
      let movedRect = PipRectCalculator.positionAfterAvoid(this.overlayRect,
        this.rectCalculator.getCameraAvoidArea(), this.screenProperty);
      top = movedRect.top.getPx();
      bottom = movedRect.top.getPx() + movedRect.height.getPx();
      left = movedRect.left.getPx();
      right = movedRect.left.getPx() + this.overlayRect.width.getPx();
      overlayTop = movedRect.top.getPx();
      overlayLeft = movedRect.left.getPx();
    }
    if (top < this.topAvoidHeight) {
      overlayTop = this.topAvoidHeight;
    }
    if (bottom > this.screenProperty.height - this.bottomAvoidHeight) {
      overlayTop = this.screenProperty.height - height - this.bottomAvoidHeight;
    }
    if (left < horAvoid) {
      overlayLeft = horAvoid;
    }
    if (right > this.screenProperty.width - horAvoid) {
      overlayLeft = this.screenProperty.width - width - horAvoid;
    }
    if (this.rectCalculator.isFolded() && DeviceHelper.isLandscape()) {
      let realtimeRect = new SCBSessionRect(overlayLeft, overlayTop, width, height);
      if (PipRectCalculator.calculateOverlap(realtimeRect, this.rectCalculator.getCameraAvoidArea()) !== null) {
        let updatedRect = this.avoidHorizontalCamera(realtimeRect, this.rectCalculator.getCameraAvoidArea());
        overlayLeft = updatedRect.left.getPx();
        overlayTop = updatedRect.top.getPx();
      }
    }
    animateTo({
      curve: curves.springMotion(0.4, 0.8),
      onFinish: onFinishCallback
    }, () => {
      this.overlayRectMoveTo(overlayLeft, overlayTop);
    });
    log.showInfo(`dragScaleSpringBack, overlayRect: ${this.getSCBSessionRectInfo(this.overlayRect)}, ` +
      `rect: ${this.getSCBSessionRectInfo(this.rect)} centerX: ${this.centerScaleX} centerY: ${this.centerScaleY} ` +
      `scaleValue: ${this.scaleValue}`);
  }

  private handlePanGestureStart(event: GestureEvent) {
    if (!event || event.fingerList.length < 1 || !event.fingerList[0]) {
      return;
    }
    this.isDragScalePip = true;
    if (this.overlaySceneSession) {
      this.overlaySceneSession.setVisibility(false);
      this.overlaySceneSession.setActive(false);
      this.overlaySceneSession.setSessionTouchable(false);
    }
    this.updateScaleWithoutMove(0, 0);
    this.displayRect = PipRect.generateWithContainerSession(this.rect, this.scaleValue);
    this.rectSizeLevel = this.rectCalculator.getScaleLevelInt().valueOf();
    this.rectBeforeScale = new PipRect(this.rect.left.getVp(), this.rect.top.getVp(),
      this.rect.left.getVp() + this.rect.width.getVp(), this.rect.top.getVp() + this.rect.height.getVp());
    this.rectBeforeScale.scale = this.scaleValue;
    this.beforeDragScale = this.scaleValue;
    let localX = event.fingerList[0].displayX - this.displayRect.left;
    let localY = event.fingerList[0].displayY - this.displayRect.top;
    const responseWidth = Constants.DRAG_HOT_WIDTH_INNER;
    if (localY < responseWidth) {
      this.displayRect.axisX = false;
      this.displayRect.pinTmp = Pin.CENTER_BOTTOM;
      if (localX < this.displayRect.width() / Constants.NUMBER_THREE) {
        this.displayRect.pinTmp = Pin.RIGHT_BOTTOM;
      } else if (localX < this.displayRect.width() / Constants.NUMBER_THREE * Constants.NUMBER_TWO) {
        this.displayRect.pinTmp = Pin.CENTER_BOTTOM;
      } else {
        this.displayRect.pinTmp = Pin.LEFT_BOTTOM;
      }
    } else if (localY > this.displayRect.height() - responseWidth) {
      this.displayRect.axisX = false;
      this.displayRect.pinTmp = Pin.CENTER_TOP;
      if (localX < this.displayRect.width() / Constants.NUMBER_THREE) {
        this.displayRect.pinTmp = Pin.RIGHT_TOP;
      } else if (localX < this.displayRect.width() / Constants.NUMBER_THREE * Constants.NUMBER_TWO) {
        this.displayRect.pinTmp = Pin.CENTER_TOP;
      } else {
        this.displayRect.pinTmp = Pin.LEFT_TOP;
      }
    } else if (localX <  this.displayRect.width() / Constants.NUMBER_TWO) {
      this.displayRect.axisX = true;
      this.displayRect.pinTmp = Pin.RIGHT_TOP;
    } else if (localX > this.displayRect.width() / Constants.NUMBER_TWO) {
      this.displayRect.axisX = true;
      this.displayRect.pinTmp = Pin.LEFT_TOP;
    } else {
      this.displayRect.pinTmp = Pin.LEFT_TOP;
    }
    this.gesturePin = this.displayRect.pinTmp;
  }
  // Max area damping animation functions
  private maxAreaFunction(scale: number): number {
    return -0.778 + 2.889 * scale - 1.111 * scale * scale;
  }
  // Min area damping animation functions
  private minAreaFunction(scale: number): number {
    return 1.175 - 1.3 * scale + 1.125 * scale * scale;
  }

  private judgeEventIsTop(pinType: Pin): boolean{
    return pinType === Pin.CENTER_BOTTOM || pinType === Pin.LEFT_BOTTOM || pinType === Pin.RIGHT_BOTTOM;
  }

  private handlePanGestureUpdate(event: GestureEvent) {
    if (!event || event.fingerList.length < 1 || !event.fingerList[0]) {
      return;
    }
    this.isDragScalePip = true;
    if (this.overlaySceneSession) {
      this.overlaySceneSession.setVisibility(false);
      this.overlaySceneSession.setActive(false);
      this.overlaySceneSession.setSessionTouchable(false);
    }
    this.displayRect.setRect(this.displayRect.dragDownRect);
    if (this.displayRect.axisX) {
      let offsetX: number = 0;
      this.displayRect.expandWidthWithAspect(this.displayRect.pinTmp === Pin.LEFT_TOP ? offsetX : -offsetX);
    } else {
      let offsetY: number = 0;
      let tempHeight: number = this.judgeEventIsTop(this.displayRect.pinTmp) ? -offsetY : offsetY;
      this.displayRect.expandHeightWithAspect(tempHeight);
    }
    this.displayRect.pinToAnchor();
    let minScale = this.minScale;
    let nowScale = this.displayRect.width() / this.rect.width.getVp();
    if (nowScale > (Constants.MAX_RATIO * DAMPING_MAX_SCALE_PERCENT) ||
      nowScale < minScale * DAMPING_MIN_SCALE_PERCENT) {
      return;
    }
    if (nowScale < Constants.MAX_RATIO && nowScale > minScale) {
      animateTo({ curve: curves.responsiveSpringMotion() }, () => {
        this.refreshTrans(false);
      });
    } else {
      if (nowScale > Constants.MAX_RATIO && nowScale < Constants.MAX_RATIO * DAMPING_MAX_SCALE_PERCENT) {
        nowScale = this.maxAreaFunction(nowScale);
      } else if (nowScale < minScale && nowScale > minScale * DAMPING_MIN_SCALE_PERCENT) {
        nowScale = this.minAreaFunction(nowScale / minScale) * minScale;
      }
      this.displayRect.expandWidthWithAspect(nowScale * this.rect.width.getVp() - this.displayRect.width());
      this.displayRect.pinToAnchor();
      animateTo({
        curve: curves.responsiveSpringMotion(0.4, 1),
      }, () => {
        this.refreshTrans(false);
      });
    }
    return;
  }

  private handlePanGestureEnd(event: GestureEvent) {
    if (!event || event.fingerList.length < 1 || !event.fingerList[0]) {
      return;
    }
    let nowRatio = this.displayRect.width() / this.rect.width.getVp();
    let limitRatio = Math.min(Math.max(nowRatio, this.minScale), Constants.MAX_RATIO);
    if (!CommonUtils.equals(nowRatio, limitRatio)) {
      this.displayRect.set(0, 0, this.rect.width.getVp() * limitRatio, this.rect.height.getVp() * limitRatio);
      this.displayRect.pinToAnchor();
      animateTo({
        curve: curves.springMotion(0.4, 0.8),
        onFinish: () => {
          this.isDragScalePip = false;
        }
      }, () => {
        this.refreshTrans(false);
      })
    } else {
      this.isDragScalePip = false;
    }
    this.overlayRect = this.rect.copy();
    this.overlayRect.setSizeNum(vp2px(this.displayRect.width()), vp2px(this.displayRect.height()));
    this.afterDragScale = this.scaleValue;
    this.dragScaleSpringBack();
    this.rectCalculator.savePipPositionAndLevel(this.overlayRect.left.getPx(), this.overlayRect.top.getPx());
    AppStorage.set(Constants.KEY_PIP_WINDOW_WIDTH, this.overlayRect.width.getPx());
    AppStorage.set(Constants.KEY_PIP_WINDOW_HEIGHT, this.overlayRect.height.getPx());
    AppStorage.set(Constants.KEY_PIP_DRAG_SCALE_VALUE, this.scaleValue);
    this.rectCalculator.setScaleLevel(ScaleLevel.SCALE_LEVEL_MIDDLE);
    this.notifyPipSizeChange();
    if (this.overlaySceneSession) {
      this.overlaySceneSession.setVisibility(true);
      this.overlaySceneSession.setActive(true);
      this.overlaySceneSession.setSessionTouchable(true);
    }
    AppStorage.delete(Constants.IS_DRAGGING_PIP);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    log.showInfo(`rotationAfterDraggingIfNeeded rotaion: ${screenSession?.sensorScreenProperty?.rotation}`);
    screenSession?.rotationChangeEntry(screenSession?.sensorScreenProperty?.rotation,
      'AfterDraggingIfNeeded rotation change');
  }

  @Builder
  defaultBackgroundBuilder() {
    Stack() {
      Stack()
        .size({ width: '100%', height: '100%' })
        .backgroundColor(Color.Black)
        .borderRadius(this.pipBorderRadius / this.scaleValue)
    }
    .size({ width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
    .borderRadius(this.pipBorderRadius / this.scaleValue)
    .opacity(this.opacityNum)
    .visibility(this.isShowDefaultBackground ? Visibility.Visible : Visibility.Hidden)
    .padding(2)
  }

  @Builder
  sideBarBackgroundBuilder() {
    Stack() {
      Stack()
        .size({ width: '100%', height: '100%' })
        .backgroundBlurStyle(this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
        BlurStyle.COMPONENT_THIN : BlurStyle.COMPONENT_THICK)
        .backgroundColor(this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
          SIDE_EDGE_BAR_DARK_COLOR : SIDE_EDGE_BAR_LIGHT_COLOR)
        .border({
          width: 0.5,
          color: this.currColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
            DARK_BAR_BORDER_COLOR : LIGHT_BAR_BORDER_COLOR
        })
        .borderRadius(this.pipBorderRadius / this.scaleValue)
    }
    .size({ width: '100%', height: '100%' })
    .borderRadius(this.pipBorderRadius / this.scaleValue)
    .visibility(this.showSideBar ? Visibility.Visible : Visibility.None)
    .opacity(1 - this.opacityNum)
  }

  build() {
    if (this.enableShow() && !this.isInSideManager) {
      Stack({ alignContent: Alignment.Center }) {
        Stack({ alignContent : this.moveEndTransX > 0 ? Alignment.Start : Alignment.End }) {
          WindowScene(this.specificSession?.session.persistentId) {
            this.defaultBackgroundBuilder();
          }
          .zIndex(this.panelZIndex)
          .id(`session${this.specificSession?.session.persistentId}`)
          .size({ width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
          .visibility(this.specificSession?.visibility ? Visibility.Visible : Visibility.Hidden)
          .borderRadius(this.pipBorderRadius / this.scaleValue)
          .opacity(this.opacityNum)
          .freeze(this.isNeedFreeze)
          .renderFit(RenderFit.RESIZE_FILL)
          Image(this.cachePixMap)
            .size({ width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
            .visibility(this.useSnapshot ? Visibility.Visible : Visibility.None)
            .opacity(this.opacityNum)
          this.sideBarBackgroundBuilder();
        }
        .position({ x: this.rect?.left.getPxStr(), y: this.rect?.top.getPxStr() })
        .size(this.showSideBar ? { width: this.realRectWidth / this.scaleValue,
          height: this.realRectHeight / this.scaleValue } :
          { width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
        .scale({
          x: this.scaleValue,
          y: this.scaleValue,
          centerX: this.centerScaleX,
          centerY: this.centerScaleY
        })
        .foregroundEffect(CommonUtils.equals(this.foregroundBlur, -1) ? null : {radius: this.foregroundBlur})
        .focusable(this.specificSession?.isFocusable)
        .hitTestBehavior(this.specificSession?.isTouchable ? HitTestMode.Block : HitTestMode.None)
        .borderRadius(this.pipBorderRadius / this.scaleValue)
        .clip(this.specificSession?.specialBoarderRadius > 0 || this.clipPiPWindow ? true : false)
        .translate({ x: this.transX + this.transXOffset, y: this.transY + this.transYOffset, z: 0 })
        .id(id)
        .blur(this.blurScale)
        this.overlayBuilder();
        this.dragScaleBuilder();
      }
      .hitTestBehavior(HitTestMode.None)
      .visibility(this.isPiPVisibility ? Visibility.Visible : Visibility.Hidden)
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  dragScaleBuilder() {
    if (this.specificSession.isActive) {
      WindowScene(this.dragScaleSession?.session.persistentId) {
        Stack()
          .size({ width: '100%', height: '100%' })
          .onTouch(event => this.handleTouchEvent(event))
          .responseRegion(this.generateResponseRegion())
          .gesture(PanGesture({ distance: 1 })
            .onActionStart((event?: GestureEvent) => {
              this.handlePanGestureStart(event);
            })
            .onActionUpdate((event?: GestureEvent) => {
              this.handlePanGestureUpdate(event);
            })
            .onActionEnd((event?: GestureEvent) => {
              if (event){
                this.handlePanGestureEnd(event);
              }
            })
          )
      }
      .borderRadius(this.pipBorderRadius / this.scaleValue)
      .scale({
        x: this.scaleValue,
        y: this.scaleValue,
        centerX: this.centerScaleX,
        centerY: this.centerScaleY
      })
      .clip(this.specificSession?.specialBoarderRadius > 0 || this.clipPiPWindow ? true : false)
      .shadow(this.shadowStyle)
      .position({ x: this.rect?.left.getPxStr(), y: this.rect?.top.getPxStr() })
      .translate({ x: this.transX + this.transXOffset, y: this.transY + this.transYOffset, z: 0 })
      .size(this.showSideBar ? { width: this.realRectWidth / this.scaleValue,
        height: this.realRectHeight / this.scaleValue } :
        { width: this.rect?.width.getPxSizeStr(), height: this.rect?.height.getPxSizeStr() })
      .responseRegion(this.generateResponseRegion(true))
    }
  }

  @Builder
  overlayBuilder() {
    WindowScene(this.overlaySceneSession?.session.persistentId) {
      PiPOverlay({
        radius: this.pipBorderRadius,
        isDragScaling: this.isDragScalePip,
        onActionMoveStart: (event: GestureEvent): void => this.onActionMoveStart(event),
        onActionMove: (event: GestureEvent): void => this.onActionMove(event),
        onActionMoveEnd: (event?: GestureEvent): void => this.onActionMoveEndOrCancel(event),
        onDoubleClick: (): void => this.onDoubleClick(),
        onActionClose: (): void => this.onActionClose(),
        onActionRestore: (): void => this.onActionRestore(),
      })
      .position({ x: 0, y: 0 })
      .size({ width: '100%', height: '100%' });
    }
    .responseRegion(this.generateOverlayResponseRegion())
    .backgroundColor(Color.Transparent)
    .borderRadius(this.pipBorderRadius)
    .position({ x: this.overlayRect?.left.getPxStr(), y: this.overlayRect?.top.getPxStr() })
    .size({ width: this.overlayRect?.width.getPxSizeStr(), height: this.overlayRect?.height.getPxSizeStr() })
    .id('SCBPipSceneOverlay')
    .focusable(true)
    .visibility(this.specificSession?.visibility && !this.closed ? Visibility.Visible : Visibility.None)
    .zIndex(this.overlayZIndex)
    .hitTestBehavior(HitTestMode.Default)
  }
}
