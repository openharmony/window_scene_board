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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSessionInfo } from './SCBSessionInfo';
import { SCBSceneSession, SCBWindowShadowConfig, SCBSessionEventId, SCBSceneMemoryInfo,
  SCBWindowMovePointerPosition } from './SCBSceneSession';
import type { ScbNumber } from './SCBSessionRect';
import { SCBSessionRect } from './SCBSessionRect';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import { SCBWindowSceneConfig, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, SCBSpecificSceneSessionList, SessionChangeInfo, SessionDisplayChangeReason,
  SessionRectChangeInfo, INVALID_PID, ClassType } from './SCBSceneSessionManager';
import type { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { SCBSystemSceneSession } from './SCBSystemSceneSession';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { CommonUtils } from '@ohos/basicutils';
import { FocusChangeReason } from '../../common/FocusChangeReason';
import { SCBWindowRaiseReason } from '../../common/SCBWindowRaiseReason';
import { SCBSideEdgeManagerParam } from './SCBSideEdgeManagerParam';
import BundleManager from '@ohos.bundle.bundleManager';
import { SCBSceneInfo, SCBSceneMode } from './SCBSceneInfo';
import { image } from '@kit.ImageKit';
import { ACTIVE_STATUS_MAP } from './SCBSceneSessionManager';
import { WinLog, WinLogDomain } from '../../utils/WinLog';
import { SCBSceneMissionManager } from '../manager/SCBSceneMissionManager';

const TAG = 'SCBSpecificSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const LANDSCAPE_INPUT_HEIGHT_RATIO: number = 0.5833;
const PORTRAIT_INPUT_HEIGHT_RATIO: number = 0.4271;
const SINCE_API_VERSION: number = 14;
const API_MOD: number = 1000;
const INVALID_SCREEN_ID: number = -1;
const INVALID_DPI: number = -1;
const NORMAL_SUB_WINDOW_MAXIMUM_Z_LEVEL = 10000;
const WINDOW_GRAY_OUT_MAXIMIZE_EVENT = 'win_gray_out_maximize_event';

class SCBSpecificSessionData {
  isFocused: boolean = false;
  sessionState: sceneSessionManager.SessionState;
  needUpdateSubSessionState: boolean = false;
  // whether session is dragging
  isDragging: boolean = false;
  isMaximizeFloating: boolean = false;
  lastRect: SCBSessionRect = new SCBSessionRect();
  lastDpi: number = -1;

  refCount: number = 0;

  setParentSessionCallback: Function | null = null;
  subSessionRaiseToTopCallback: Function | null;
  subSessionRaiseAboveTargetCallback: Function | null;
  subSessionStateChangeCallback: Function | null;
  subSessionZLevelChangeCallback: Function | null;
  screenIdChangeCallback: Function | null;
  createSubSessionCallback: Function;

  /*
   * callback of touchable
   */
  sessionTouchableChangeCallback: Function;

  /*
   * callback of click outside
   */
  clickModalWindowOutsideCallback: Function;

  /*
   * callback of whether custom animation is playing
   */
  customAnimationPlayingCallback: Function;

  /*
   * callback of session forceHide change
   */
  sessionForceHideCallback: Function;

  /*
   * callback of session prepare close
   */
  sessionPrepareCloseCallback: Function;

  getZIndexCallback: Function;

  updateMaximizeRectCallback: Function;

  /*
   * callback of session pip control status change
   */
  sessionControlStatusChangeCallback: Function;

  /*
   * callback of session state change
   */
  stateChangeCallback: Function;

  /*
   * callback of raise to top
   */
  raiseToTopCallback?: Function;

  /*
   * callback of close PiP
   */
  closePiPCallback: Function;

  /*
   * callback of raise to top
   */
  raiseAboveTargetCallback?: Function;

  /*
   * callback of zLevel change
   */
  zLevelChangeCallback?: Function;

  /*
   * callback of set window shadows
   */
  setWindowShadowsCallback: Function;

  // process id
  pid: number = INVALID_PID;
  source: number = SCBSpecificSessionSource.SOURCE_UNKNOWN;
}

class SCBSpecificSessionTransformData {
  translateX: number = 0;
  translateY: number = 0;
  scale: number = 1;
}

 @Observed
 export class SCBSubWindowAnchorInfo {
   isFollowParent: boolean = false;
   anchor: sceneSessionManager.WindowAnchor = sceneSessionManager.WindowAnchor.TOP_START;
   offsetX: number = 0;
   offsetY: number = 0;
 }

export interface SCBSpecificSessionOptions {
  stateChangeCallback: Function;
  raiseToTopCallback?: Function;
  raiseAboveTargetCallback?: Function;
  zLevelChangeCallback?: Function;
  screenId?: number;
}

/**
 * Source of specific session
 */
export enum SCBSpecificSessionSource {
  SOURCE_UNKNOWN = 0,
  TYPE_ARKUI = 1,
}

/**
 * Session of system scene or sub scene
 */
@Observed
export class SCBSpecificSession {
  readonly classType: ClassType = ClassType.SPECIFIC_SESSION;
  /**
   * public data of a session,which should not trigger ui flush
   */
  sessionData: SCBSpecificSessionData = new SCBSpecificSessionData();
  /*
   * get function provide to sessionData only. forbid ui flush
   */
  get isFocused(): boolean {
    return this.sessionData.isFocused;
  }
  get sessionState(): sceneSessionManager.SessionState {
    return this.sessionData.sessionState;
  }

  get isDragging(): boolean {
    return this.sessionData.isDragging;
  }

  get isMaximizeFloating(): boolean {
    return this.sessionData.isMaximizeFloating;
  }
  get lastRect(): SCBSessionRect {
    return this.sessionData.lastRect;
  }

  get pid(): number {
    if (this.sessionData.pid !== INVALID_PID) {
      return this.sessionData.pid;
    }
    try {
      this.sessionData.pid = sceneSessionManager.getWindowPid(this.session.persistentId);
      return this.sessionData.pid;
    } catch (e) {
      log.showError('get window pid failed');
      return INVALID_PID;
    }
  }

  get source(): SCBSpecificSessionSource {
    return this.sessionData.source;
  }

  /**
   * get id of this session
   * @returns id
   */
  get persistentId(): number {
    return this.session.persistentId;
  }

  /**
   * 获取当前窗口的沉浸式状态或全屏时开关状态，开关打开时，全屏场景切换为类似沉浸式状态
   * @returns 当前窗口的沉浸式状态
   */
  public get layoutFullScreen(): boolean {
    return this.layoutFullScreen_ || (AppStorage.get<boolean>('isDockAutoHide') &&
      this.windowMode === SCBSceneMode.FULLSCREEN);
  }

  public set layoutFullScreen(layoutFullScreen: boolean) {
    this.layoutFullScreen_ = layoutFullScreen;
  }

  /**
   * 获取当前窗口的真实沉浸式状态
   * @returns 当前窗口的真实沉浸式状态
   */
  public getRealLayoutFullScreen(): boolean {
    return this.layoutFullScreen_;
  }

  sceneInfo: SCBSceneInfo;
  windowMode: SCBSceneMode = SCBSceneMode.UNDEFINED;
  private layoutFullScreen_: boolean = false;
  titleHoverShowEnabled: boolean = true;
  dockHoverShowEnabled: boolean = true;
  isPairSplitScene: boolean = false;
  animActionId: number = 0;
  animVisible: boolean = false;
  animSceneAlpha: number = 1;
  needAvoid: boolean = false;
  statusVisible: boolean = false;

  readonly session: sceneSessionManager.SceneSession;
  isActive: boolean = false;
  isFocusable: boolean = true;
  isTouchable: boolean = true;
  readonly isShowWhenLocked: boolean = false;
  visibility: boolean = true;
  screenId: number = -1;
  translateX: number = 0;
  translateY: number = 0;
  scaleX: number = 1;
  scaleY: number = 1;
  specialBoarderRadius: number = 0;
  currRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  requestedRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  shadowConfig: SCBWindowShadowConfig = new SCBWindowShadowConfig();
  subWindowAnchorInfo: SCBSubWindowAnchorInfo = new SCBSubWindowAnchorInfo();
  isWindowShowAnimate: boolean = true;
  isCustomAnimationPlaying: boolean = false;
  sessionInfo: SCBSessionInfo = new SCBSessionInfo();
  opacity: number = 1;
  parentId: number = -1;
  isTopmost: boolean = false;
  subSessionCacheList: sceneSessionManager.SceneSession[] = [];
  subSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  isSessionMoving: boolean = false;

  isBufferAvailable: boolean = false;
  isCrossingScreen: boolean = false;
  specificCornerRadius: number = 0;
  syncSpecificCornerRadius: number = -1; // the specific corner radius set by application, -1 is invalid value
  isFollowScreenChange: boolean = false;
  syncShadowConfig: SCBWindowShadowConfig;

  // used for PC Clear screen/restore dynamic effect
  transformData: SCBSpecificSessionTransformData = new SCBSpecificSessionTransformData();

  /*
   * callback of session rect change
   */
  sessionRectChangeCallbackMap: Map<number, Function> = new Map();

  setWindowCornerRadiusCallback: Function;

  /*
   * callback of session rect change relative to parent
   */
  sessionRectChangeRelativeParentCallbackMap: Map<number, Function> = new Map();

  sessionTitleActionCallbackMap: Map<number, Array<Function>> = new Map();

  /**
   * Offset X of the WindowScene associated with the session
   */
  private windowOffsetX: number = 0;

  /**
   * Offset Y of the WindowScene associated with the session
   */
  private windowOffsetY: number = 0;

  /**
   * Scale X of the WindowScene associated with the session
   */
  private windowScaleX: number = 1;

  /**
   * Scale Y of the WindowScene associated with the session
   */
  private windowScaleY: number = 1;

  public sideEdgeManagerParam: SCBSideEdgeManagerParam = new SCBSideEdgeManagerParam();

  public isFollowParentRect: boolean = false;

  private followParentWindowLayoutMap: Map<number, Function> = new Map();

  private subWindowOutlineEnabled: boolean = false;

  currMovePointerPos: SCBWindowMovePointerPosition = new SCBWindowMovePointerPosition();

  windowMovingCallbackMap: Map<number, Array<Function>> = new Map(); // <displayId, array<callback>>

  startMovePointerPos: SCBWindowMovePointerPosition = new SCBWindowMovePointerPosition();

  /**
   * Constructor.
   * @param session Session of the scene
   * @param sceneInfo Information of the scene
   */
  constructor(session: sceneSessionManager.SceneSession, stateChangeCallback: Function, raiseToTopCallback?: Function,
    raiseAboveTargetCallback?: Function, screenId?: number);
  constructor(session: sceneSessionManager.SceneSession, options: SCBSpecificSessionOptions);
  constructor(session: sceneSessionManager.SceneSession, stateChangeCallbackOrOptions: Function | SCBSpecificSessionOptions, raiseToTopCallback?: Function,
    raiseAboveTargetCallback?: Function, screenId?: number) {
    log.showInfo(`constructor, id: ${session.persistentId}, type: ${session.type}, parentId: ${session.parentId}, type: ${typeof stateChangeCallbackOrOptions}`);
    this.session = session;
    if (typeof stateChangeCallbackOrOptions === 'function') {
      this.sessionData.stateChangeCallback = stateChangeCallbackOrOptions;
      this.sessionData.raiseToTopCallback = raiseToTopCallback;
      this.sessionData.raiseAboveTargetCallback = raiseAboveTargetCallback;
    } else {
      this.sessionData.stateChangeCallback = stateChangeCallbackOrOptions.stateChangeCallback;
      this.sessionData.raiseToTopCallback = stateChangeCallbackOrOptions.raiseToTopCallback;
      this.sessionData.raiseAboveTargetCallback = stateChangeCallbackOrOptions.raiseAboveTargetCallback;
      this.sessionData.zLevelChangeCallback = stateChangeCallbackOrOptions.zLevelChangeCallback;
    }

    this.isActive = false;
    this.screenId = session.screenId;
    this.sessionData.sessionState = sceneSessionManager.SessionState.STATE_DISCONNECT;
    this.isTopmost = session.isTopmost;
    this.specificCornerRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    this.subWindowOutlineEnabled = session.subWindowOutlineEnabled;
    this.session.on('sessionFocusableChange', (isFocusable) => {
      this.onSessionFocusableChange(isFocusable);
    });
    this.session.on('sessionTouchableChange', (isTouchable) => {
      this.onSessionTouchableChange(isTouchable);
    });
    this.session.on('clickModalWindowOutside', () => {
      this.onClickModalWindowOutside();
    });
    this.session.on('sessionRectChange', (rect, reason, displayId) => {
      this.setRequestedRect(new SCBSessionRect(rect.posX_, rect.posY_, rect.width_, rect.height_));
      this.onSessionRectChange(rect, reason, displayId);
    });
    this.session.on('sessionDisplayIdChange', (displayId) => {
      this.onSessionDisplayIdChange(displayId);
    });
    this.session.on('sessionPiPControlStatusChange', (type, status) => {
      this.onSessionControlStatusChange(type, status);
    });
    this.session.on('sessionForceHideChange', (hide) => {
      this.onSessionForceHideChange(hide);
    });
    this.session.on('raiseToTop', () => {
      this.onRaiseToTop();
    });
    this.session.on('raiseToTopForPointDown', () => {
      this.onRaiseToTopForPointDown();
    });
    this.session.on('raiseAboveTarget', (err, subWindowId) => {
      this.onRaiseAboveTarget(subWindowId);
    });
    this.session.on('zLevelChange', (zLevel: number) => {
      this.onZLevelChange(zLevel);
    });
    this.session.on('needDefaultAnimationFlagChange', (isWindowShowAnimate) => {
      this.onNeedDefaultAnimationFlagChange(isWindowShowAnimate);
    });
    this.session.on('isCustomAnimationPlaying', (isPlaying) => {
      this.onCustomAnimationPlaying(isPlaying);
    });

    this.session.on('prepareClosePiPSession', () => {
      if (this.sessionData.sessionPrepareCloseCallback) {
        this.sessionData.sessionPrepareCloseCallback();
      }
    });

    this.session.on('sessionEvent', (actionId, param) => {
      this.onSessionEvent(actionId, param);
    });

    this.session.on('subModalTypeChange', (subWindowModalType) => {
      this.onSessionModalTypeChange(subWindowModalType);
    });
    this.session.on('followParentRect', (isFollow) => {
      this.onFollowParentRect(isFollow);
    });
    this.session.on('windowAnchorInfoChange', (windowAnchorInfo) => {
      this.onFollowRelativePositionToParent(windowAnchorInfo);
    });
    this.session.on('sessionUpdateFollowScreenChange', (isFollowScreenChange) => {
      this.UpdateFollowScreenChange(isFollowScreenChange);
    });

    this.registerSessionLife();
    this.registerPCOrPadListeners();
    this.registerFullscreenChangeCallback();
    this.registerWindowCornerRadiusChangeCallback();
    this.session.on('setWindowShadows', (shadowsInfo: SCBWindowShadowConfig) => {
      if (shadowsInfo) {
        log.showInfo(`setWindowShadows,shadow radius:${shadowsInfo.radius}, color:${shadowsInfo.color}, ` +
          `offsetX:${shadowsInfo.offsetX}, offsetY:${shadowsInfo.offsetY}`);
        this.syncShadowConfig = shadowsInfo;
        this.onSessionSetWindowShadows(shadowsInfo);
      }
    });

    this.session.on('setSubWindowSource', (source) => {
      log.showInfo(`setSubWindowSource, source: ${source}`);
      this.sessionData.source = source;
    });
  }

  private registerWindowCornerRadiusChangeCallback(): void {
    this.session.on('setWindowCornerRadius', (cornerRadius: number) => {
      if (!this.onSessionSetWindowCornerRadius) {
        log.showWarn('onSessionSetWindowCornerRadius is invalid');
        return;
      }
      if (this.isSubWindow() || this.isFloatWindow()) {
        log.showInfo(`setWindowCornerRadius: ${cornerRadius}, defaultCornerRadius: ${this.specificCornerRadius}`);
        this.syncSpecificCornerRadius = cornerRadius;
        this.onSessionSetWindowCornerRadius(cornerRadius);
      }
    });
  }

  private registerSessionLife(): void {
    // update state after properties updated
    if (this.session.type !== sceneSessionManager.SessionType.TYPE_PIP) {
      this.enableSessionStateChange();
    }

    this.session.on('createSpecificSession', (specificSession) => {
      this.onCreateSpecificSession(specificSession);
    });

    this.session.on('clearSubSession', (subSessionId) => {
      this.onClearSubSession(subSessionId);
    });
  }

  private registerFullscreenChangeCallback(): void {
    this.session.on('layoutFullScreenChange', (isLayoutFullScreen: boolean) => {
      this.layoutFullScreen = isLayoutFullScreen;
    });

    this.session.on('titleAndDockHoverShowChange', (isTitleHoverShowEnabled: boolean, isDockHoverShowEnabled: boolean) => {
      log.showInfo('titleAndDockHoverShowChange isTitleHoverShowEnabled: ' + isTitleHoverShowEnabled +
        ' dockHoverShowEnabled: ' + isDockHoverShowEnabled);
      this.titleHoverShowEnabled = isTitleHoverShowEnabled;
      this.dockHoverShowEnabled = isDockHoverShowEnabled;
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    });
  }

  /**
   * set app surface node gravity
   *
   * @param gravity gravity
   */
  public setGravity(gravity: sceneSessionManager.Gravity): void {
    if (!this.session) {
      log.showError('setGravity failed, session is null');
      return;
    }
    try {
      this.session.setFrameGravity(gravity);
    } catch (err) {
      log.showError('setGravity failed, reason: ' + JSON.stringify(err));
    }
  }

  public getRect(): SCBSessionRect {
    let parentSession = this.getParentSession(this.screenId);
    if (this.isFollowParentRect && parentSession) {
      return parentSession.currRect;
    }
    return this.currRect;
  }

  /**
   * get window outline by parent
   */
  public getOutline(): OutlineOptions {
    const mainSession: SCBSceneSession | null =
      SCBSceneSessionManager.getInstance().findMainSessionById(this.session.persistentId);
    if (CommonUtils.isInvalid(mainSession)) {
      log.showWarn('mainSession is invalid.');
      return {
        width: 0,
        color: '#00000000'
      };
    }
    if (!this.subWindowOutlineEnabled) {
      return {
        width: 0,
        color: '#00000000'
      };
    }
    return {
      width: mainSession.isHideShadow ? 0 : px2vp(mainSession.strokeConfig.outlineWidth),
      color: mainSession.isHideShadow ? '#00000000' : mainSession.strokeConfig.outlineColor,
      radius: this.specialBoarderRadius
    };
  }

  private registerPCOrPadListeners(): void {
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (!(uiType === SCBConstants.UITYPE_PC || uiType === SCBConstants.UITYPE_PAD)) {
      return;
    }

    this.session.on('windowMoving', (displayId: number, pointerX: number, pointerY: number) => {
      this.processWindowMoving(displayId, pointerX, pointerY);
    });

    if (this.isSubWindow()) {
      this.session.on('setParentSession', (oldParentWindowId: number, newParentWindowId: number) => {
        this.onSetParentSession(oldParentWindowId, newParentWindowId);
      });
    }
  }

  public setWindowLastSafeRect(posX: number, posY: number, width: number, height: number): void {
    try {
      this.session?.setWindowLastSafeRect(posX, posY, width, height);
    } catch (err) {
      log.showError('setWindowLastSafeRect failed, reason: ' + JSON.stringify(err));
    }
  }

  public saveLastRect(): void {
    this.lastRect.setRect(this.currRect.left, this.currRect.top, this.currRect.width, this.currRect.height);
  }

  /**
   * enable Session State Change
   */
  public enableSessionStateChange(): void {
    this.session.on('sessionStateChange', (state) => {
      if (typeof state !== 'number') {
        log.showError('invalid state type: ' + typeof state);
        return;
      }
      this.onSessionStateChange(state);
    });
  }

  /**
   * register Session Rect Change Callback
   *
   * @param callback
   */
  public registerSessionRectChangeCallback(callback: Function, screenId?: number): void {
    // register session rect change callback
    let screen = screenId !== undefined ? screenId : this.screenId;
    log.showInfo(`registerSessionRectChangeCallback screenId:${screen}`);
    this.sessionRectChangeCallbackMap.set(screen, callback);
  }

  /**
   * register Session PiP Control Status Callback
   *
   * @param callback
   */
  public registerSessionControlStatusChangeCallback(callback: Function): void {
    this.sessionData.sessionControlStatusChangeCallback = callback;
  }

  /**
   * register Session Rect Change Relative To Parent Callback
   *
   * @param callback
   */
  public registerSessionRectChangeRelativeParentCallback(callback: Function, screenId?: number): void {
    // register session rect change callback
    let screen = screenId !== undefined ? screenId : this.screenId;
    log.showInfo(`registerSessionRectChangeRelativeParentCallback screenId:${screen}`);
    this.sessionRectChangeRelativeParentCallbackMap.set(screen, callback);
  }

  /**
   * register Session Custom Animation Playing Callback
   *
   * @param callback
   */
  public registerSessionCustomAnimationPlayingCallback(callback: Function): void {
    // register session rect change callback
    this.sessionData.customAnimationPlayingCallback = callback;
  }

  /**
   * register Session Force Hide Callback
   *
   * @param callback
   */
  public registerSessionForceHideCallback(callback: Function): void {
    // register session forceHide change callback
    this.sessionData.sessionForceHideCallback = callback;
  }

  /**
   * register Get ZIndex Callback
   *
   * @param callback
   */
  public registerGetZIndexCallback(callback: Function): void {
    this.sessionData.getZIndexCallback = callback;
  }

  public registerSetWindowCornerRadiusCallback(callback: Function): void {
    log.showInfo('registerSetWindowCornerRadiusCallback');
    if (this.isSubWindow() || this.isFloatWindow()) {
      this.setWindowCornerRadiusCallback = callback;
    }
  }

  /**
   * register Set Window Shadows Callback
   *
   * @param callback
   */
  public registerSetWindowShadowsCallback(callback: Function): void {
    log.showInfo('registerSetWindowShadowsCallback');
    this.sessionData.setWindowShadowsCallback = callback;
  }

  /**
   * get ZIndex
   *
   * @returns
   */
  public getZIndex(): number {
    return this.sessionData.getZIndexCallback ? this.sessionData.getZIndexCallback() : 0;
  }

  /**
   * register Session Touchable Change Callback
   *
   * @param callback
   */
  public registerSessionTouchableChangeCallback(callback: Function): void {
    log.showInfo('registerSessionTouchableChangeCallback');
    this.sessionData.sessionTouchableChangeCallback = callback;
    if (this.sessionData.sessionTouchableChangeCallback) {
      this.sessionData.sessionTouchableChangeCallback(this.isTouchable);
    }
  }

  /**
   * register close PiP callback
   *
   * @param callback
   */
  public registerClosePiPCallback(callback: Function): void {
    log.showInfo('registerClosePiPCallback success');
    this.sessionData.closePiPCallback = callback;
  }

  /**
   * unregister close PiP callback
   *
   * @param callback
   */
  public unregisterClosePiPCallback(): void {
    log.showInfo('unregisterClosePiPCallback success');
    this.sessionData.closePiPCallback = null;
  }

  /**
   * notify close PiP
   *
   */
  public notifyClosePiP(): void {
    if (this.sessionData.closePiPCallback) {
      log.showInfo('notifyClosePiP success');
      this.sessionData.closePiPCallback();
    }
  }

  /**
   * register click outside the modal window Callback
   *
   * @param callback
   */
  public registerClickModalWindowOutsideCallback(callback: Function): void {
    log.showInfo('registerClickModalWindowOutsideCallback');
    this.sessionData.clickModalWindowOutsideCallback = callback;
  }

  /**
   * unregister Session Rect Change Callback
   */
  public unregisterSessionRectChangeCallback(screenId?: number): void {
    // unregister session rect change callback
    let screen = screenId !== undefined ? screenId : this.screenId;
    // unregister session rect change callback
    this.sessionRectChangeCallbackMap.delete(screen);
    log.showDebug(`unregisterSessionRectChangeCallback screenId:${screen}`);
  }

  /**
   * unregister Session Rect Change Relative To Parent Callback
   */
  public unregisterSessionRectChangeRelativeParentCallback(screenId?: number): void {
    // unregister session rect change callback
    let screen = screenId !== undefined ? screenId : this.screenId;
    // unregister session rect change callback
    this.sessionRectChangeRelativeParentCallbackMap.delete(screen);
    log.showDebug(`unregisterSessionRectChangeRelativeParentCallback screenId:${screen}`);
  }

  /**
   * unRegister Session PiP Control Status Callback
   */
  public unregisterSessionControlStatusChangeCallback(): void {
    this.sessionData.sessionControlStatusChangeCallback = null;
    log.showDebug('unregisterSessionControlEnableChangeCallback');
  }

  /**
   * register session title action callback
   *
   * @param callback
   * @param screenId
   */
  public registerSessionTitleActionCallback(callback: Function, screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.screenId;
    log.showInfo(`registerSessionTitleActionCallback, screenId: ${screenId}, ` +
      `persistentId: ${this.session?.persistentId}`);
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      let callbackArray: Function[] = this.sessionTitleActionCallbackMap.get(screenId);
      const index = callbackArray.indexOf(callback);
      if (index === -1) {
        callbackArray.push(callback);
      }
      log.showDebug(`registerSessionTitleActionCallback length: ${callbackArray.length}`);
      return;
    }
    let callbackArray: Function[] = [];
    callbackArray.push(callback);
    this.sessionTitleActionCallbackMap.set(screenId, callbackArray);
    log.showDebug(`registerSessionTitleActionCallback length: ${callbackArray.length}`);
  }

  /**
   * unregister session title action callback
   *
   * @param callback
   * @param screenId
   */
  public unRegisterSessionTitleActionCallback(callback: Function, screenId?: number): void {
    let screen = screenId !== undefined ? screenId : this.screenId;
    log.showInfo(`unRegisterSessionTitleActionCallback, screenId: ${screen}, ` +
      `persistentId: ${this.session.persistentId}`);
    if (!this.sessionTitleActionCallbackMap.has(screen)) {
      return;
    }
    let callbackArray: Function[] = this.sessionTitleActionCallbackMap.get(screen);
    let index = callbackArray.indexOf(callback);
    if (index !== -1) {
      callbackArray.splice(index, 1);
      log.showDebug(`unRegisterSessionTitleActionCallback length: ${callbackArray.length}, screenId: ${screen}`);
    }
    if (callbackArray.length === 0) {
      this.sessionTitleActionCallbackMap.delete(screenId);
      log.showDebug(`unRegisterSessionTitleActionCallback delete map, screenId: ${screen}`);
    }
  }

  /**
   * Set offset of the window to ensure that multi-mode input events can be correctly distributed.
   *
   * Usually refers to the position of the parent component.
   *
   * Unit: px
   *
   * @param x parent component position x
   * @param y parent component position y
   */
  public setWindowOffset(x: number, y: number): void {
    if (x === this.windowOffsetX && y === this.windowOffsetY) {
      return;
    }
    try {
      if (CommonUtils.isInvalid(this.session)) {
        log.showError('setWindowOffset null session');
        return;
      }
      let floatContainer = SCBSceneSessionManager.getInstance().getFloatingSessionList().findByPersistentId(
        this.getParentSession()?.sceneInfo?.persistentId);
      if (floatContainer) {
        x = x - this.currRect.left.getPx() * (1 - floatContainer.floatingParam.scale);
        y = y - this.currRect.top.getPx() * (1 - floatContainer.floatingParam.scale);
      }
      this.session.setOffset(x, y);
      this.windowOffsetX = x;
      this.windowOffsetY = y;
    } catch (err) {
      log.showError('setWindowOffset failed, with reason ' + JSON.stringify(err));
    }
  }

  /**
   * Set offset of the window to ensure that multi-mode input events can be correctly distributed.
   *
   * Usually refers to the position of the parent component.
   *
   * Unit: px
   *
   * @param x parent component position x
   * @param y parent component position y
   */
  public setWindowScale(scaleX: number, scaleY: number): void {
    if (scaleX === this.windowScaleX && scaleY === this.windowScaleY) {
      return;
    }
    try {
      if (CommonUtils.isInvalid(this.session)) {
        log.showError('setWindowScale null session');
        return;
      }
      this.session.setScale(scaleX, scaleY, 0, 0);
      this.windowScaleX = scaleX;
      this.windowScaleY = scaleY;
    } catch (err) {
      log.showError('setWindowScale failed, with reason ' + JSON.stringify(err));
    }
  }

  /**
   * set Focused
   *
   * @param isFocused
   */
  public setFocused(isFocused: boolean): void {
    WinLog.showDebug(WinLogDomain.WMS_FOCUS, `setFocused, persistentId: ${this.session.persistentId} is setFocused: ${isFocused}!`);
    if (this.isFocused === isFocused) {
      return;
    }
    if (isFocused && !this.isFocusable) {
      return;
    }
    this.sessionData.isFocused = isFocused;
    this.setSpecialWindowEffectConfig();
  }

  /**
   * set Touchable
   *
   * @param isTouchable
   */
  public setTouchable(isTouchable: boolean): void {
    log.showDebug(`persistentId: ${this.session.persistentId} is setTouchable: ${isTouchable}!`);
    this.isTouchable = isTouchable;
  }

  /**
   * set ZOrder
   *
   * @param zOrder
   */
  public setZOrder(zOrder: number): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    if (this.sessionInfo.zOrder !== zOrder) {
      this.sessionInfo.zOrder = zOrder;
      try {
        this.session.setZOrder(zOrder);
      } catch (err) {
        log.showError('setZOrder failed, reason: ' + JSON.stringify(err));
      }
    }
  }

  private onCreateSpecificSession(specificSession: sceneSessionManager.SceneSession): void {
    log.showInfo('onCreateSpecificSession');
    specificSession.subWindowAppModalType = specificSession.subWindowModalType;
    if (this.sessionData.createSubSessionCallback) {
      this.sessionData.createSubSessionCallback(this, specificSession);
    } else {
      log.showInfo('[WMSRecover] createSubSessionCallback is null, cache it, persistentId = ' +
      specificSession.persistentId);
      if (!this.subSessionCacheList.includes(specificSession)) {
        this.subSessionCacheList.push(specificSession);
      }
    }
  }

  private onClearSubSession(subSessionId: number): void {
    log.showInfo('onClearSubSession');
    if (this.subSessionCacheList.length > 0) {
      let index = this.subSessionCacheList.findIndex(subSession => subSession.persistentId === subSessionId);
      if (index !== -1) {
        this.subSessionCacheList.splice(index, 1);
      }
    }
  }

  public registerCreateSubSessionCallback(callback: Function): void {
    log.showInfo('registerCreateSubSessionCallback');
    this.sessionData.createSubSessionCallback = callback;
    this.subSessionCacheList.forEach((item) => {
      try {
        log.showInfo('[WMSRecover] RecoverSubSession persistentId = ' + item.persistentId);
        callback(this, item);
      } catch (error) {
        log.showWarn(`[WMSRecover] CreateCachedSubSession error, code: ${error.code}, message: ${error.message}`);
      }
    });
    this.subSessionCacheList.length = 0;
  }

  private onSetParentSession(oldParentWindowId: number, newParentWindowId: number): void {
    log.showInfo(`setParentSession subWindowId: ${this.session.persistentId}, oldParentWindowId: ` +
      `${oldParentWindowId}, newParentWindowId ${newParentWindowId}`);
    if (this.sessionData.setParentSessionCallback) {
      this.sessionData.setParentSessionCallback(oldParentWindowId, newParentWindowId);
    } else {
      log.showError(`setParentSession setParentSessionCallback is null`);
    }
  }

  public registerSetParentSessionCallback(callback: Function): void {
    this.sessionData.setParentSessionCallback = callback;
  }

  public registerRaiseToTopCallback(callback: Function): void {
    this.sessionData.raiseToTopCallback = callback;
  }

  public registerRaiseAboveTargetCallback(callback: Function): void {
    this.sessionData.raiseAboveTargetCallback = callback;
  }

  public registerStateChangeCallback(callback: Function): void {
    log.showInfo(`registerStateChangeCallback, id: ${this.session.persistentId}, type: ${this.session.type}`);
    this.sessionData.stateChangeCallback = callback;
  }

  public registerZLevelChangeCallback(callback: Function): void {
    this.sessionData.zLevelChangeCallback = callback;
  }

  public getSubSessionRaiseToTopCallback(): Function | null {
    return this.sessionData.subSessionRaiseToTopCallback;
  }

  public registerSubSessionRaiseToTopCallback(callback: Function): void {
    this.sessionData.subSessionRaiseToTopCallback = callback;
  }

  public getSubSessionRaiseAboveTargetCallback(): Function | null {
    return this.sessionData.subSessionRaiseAboveTargetCallback;
  }

  public registerSubSessionRaiseAboveTargetCallback(callback: Function): void {
    this.sessionData.subSessionRaiseAboveTargetCallback = callback;
  }

  public registerSubSessionStateChangeCallback(callback: Function): void {
    this.sessionData.subSessionStateChangeCallback = callback;
  }

  public getSubSessionStateChangeCallback(): Function | null {
    return this.sessionData.subSessionStateChangeCallback;
  }

  public registerSubSessionZLevelChangeCallback(callback: Function): void {
    this.sessionData.subSessionZLevelChangeCallback = callback;
  }

  public getSubSessionZLevelChangeCallback(): Function | null {
    return this.sessionData.subSessionZLevelChangeCallback;
  }

  public registerScreenIdChangeCallback(callback: Function): void {
    this.sessionData.screenIdChangeCallback = callback;
  }

  /**
   * register Session Prepare Close Callback
   *
   * @param callback
   */
  public registerSessionPrepareCloseCallback(callback: Function): void {
    log.showInfo('registerSessionPrepareCloseCallback');
    this.sessionData.sessionPrepareCloseCallback = callback;
  }

  /**
   * set skip event and show on virtual screen
   *
   * @param isSkip
   */
  public setSkipEventAndShowOnVirtualScreen(isSkip: boolean): void {
    try {
      this.session.setSkipSelfWhenShowOnVirtualScreen(isSkip);
    } catch (err) {
      log.showError('setSkipEventAndShowOnVirtualScreen failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set main window status bar prop applied
   */
  public setIsSystemBarPropertyApplied(): void {
    const mainSession: SCBSceneSession | null =
      SCBSceneSessionManager.getInstance().findMainSessionById(this.session.persistentId);
    if (CommonUtils.isInvalid(mainSession)) {
      log.showInfo('mainSession is null');
      return;
    }
    if (!mainSession.sessionData._isSystemBarPropertyApplied) {
      log.showInfo(`win:${this.session.persistentId} app prop is applied from subSession`);
      mainSession.sessionData._isSystemBarPropertyApplied = true;
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }
  }

  /**
   * set Special Window Effect Config
   */
  public setSpecialWindowEffectConfig(): void {
    if (this.needSetSpecialWindowShadowConfig()) {
      this.setSpecialWindowShadowConfig();
    }
    if (this.needSetSpecialWindowCornerConfig()) {
      this.setSpecialWindowCornerConfig();
    }
  }

  public refreshSubSessionCornerConfig(): void {
    this.setSpecialWindowCornerConfig();
  }

  /**
   * is Sub Window
   *
   * @returns
   */
  public isSubWindow(): boolean {
    return this.session.type === sceneSessionManager.SessionType.TYPE_SUB_APP;
  }

  public isFloatWindow(): boolean {
    return this.session.type === sceneSessionManager.SessionType.TYPE_FLOAT;
  }

  public isVoiceInteractionWindow(): boolean {
    return this.session.type === sceneSessionManager.SessionType.TYPE_VOICE_INTERACTION;
  }
  /**
   * is dialog Window
   *
   * @returns
   */
  public isDialogWindow(): boolean {
    return this.session.type === sceneSessionManager.SessionType.TYPE_DIALOG;
  }

  /**
   * modal subwindow is topmost if topmost flag is true and seesion type is TYPE_SUB_APP
   * @returns true if topmost
   */
  public isTopmostSubWindow(): boolean {
    return this.session.isTopmost && this.isSubWindow();
  }

  public getZLevel(): number {
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `getZLevel, id: ${this.session.persistentId}, zLevel: ${this.session.zLevel}`);
    return this.session.zLevel;
  }

  private isSyncShadowConfigInvalid(): boolean {
    return CommonUtils.isInvalid(this.syncShadowConfig) || this.syncShadowConfig.radius < 0;
  }

  private needSetSpecialWindowShadowConfig(): boolean {
    if (this.isSubWindow() || this.isDialogWindow()) {
      if (!this.isWindowShowAnimate) {
        this.resetSpecialWindowShadowConfig();
        log.showDebug('No shadow effect');
        return false;
      }
      return true;
    }

    if (this.session.type === sceneSessionManager.SessionType.TYPE_FLOAT ||
      this.session.type === sceneSessionManager.SessionType.TYPE_FLOAT_CAMERA) {
      // If app has already set the syncShadowConfig, then the syncShadowConfig makes effect even if isAppType is false
      if ((!this.session.isAppType && this.isSyncShadowConfigInvalid()) || !this.isWindowShowAnimate) {
        this.resetSpecialWindowShadowConfig();
        log.showDebug('Not app type, no shadow effect');
        return false;
      }
      return true;
    }
    return false;
  }

  private needSetSpecialWindowCornerConfig(): boolean {
    if (this.isSubWindow() || this.isDialogWindow()) {
      if (!this.isWindowShowAnimate) {
        this.resetSpecialWindowCornerConfig();
        log.showDebug('No corner effect');
        return false;
      }
      return true;
    }

    if (this.session.type === sceneSessionManager.SessionType.TYPE_FLOAT ||
      this.session.type === sceneSessionManager.SessionType.TYPE_FLOAT_CAMERA) {
      if ((!this.session.isAppType && this.syncSpecificCornerRadius < 0) || !this.isWindowShowAnimate) {
        this.resetSpecialWindowCornerConfig();
        log.showDebug('Not app type, no corner effect');
        return false;
      }
      return true;
    }
    return false;
  }

  private resetSpecialWindowShadowConfig(): void {
    if (this.shadowConfig.radius > 0) {
      this.shadowConfig.radius = 0;
    }
  }

  private resetSpecialWindowCornerConfig(): void {
    if (this.specialBoarderRadius > 0) {
      this.specialBoarderRadius = 0;
    }
  }

  private setSpecialWindowCornerConfig(): void {
    log.showDebug('Set special corner radius, radius: ' + this.specificCornerRadius);
    if (this.syncSpecificCornerRadius >= 0) {
      this.specialBoarderRadius = this.syncSpecificCornerRadius;
    } else if (this.specificCornerRadius >= 0) {
      this.specialBoarderRadius = this.specificCornerRadius;
    }
  }
  
  private onSessionSetWindowCornerRadius(cornerRadius): void {
    log.showInfo('onSessionSetWindowCornerRadius Set special corner radius, radius: ' + cornerRadius);
    if (!this.setWindowCornerRadiusCallback) {
      log.showError('setWindowCornerRadiusCallback is undefined');
      return;
    }
    if (cornerRadius >= 0) {
      this.setWindowCornerRadiusCallback(cornerRadius);
    }
  }

  private setSpecialWindowShadowConfig(): void {
    if ((SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PC ||
      SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD) &&
      this.isBufferAvailable === false) {
      return;
    }

    let shadowConfigTmp = this.shadowConfig;
    this.shadowConfig = new SCBWindowShadowConfig(); // trigger component update

    if (this.syncShadowConfig?.radius !== undefined && this.syncShadowConfig.radius >= 0) {
      this.shadowConfig.radius = this.syncShadowConfig.radius ?? shadowConfigTmp.radius;
      this.shadowConfig.color = this.syncShadowConfig.color ?? shadowConfigTmp.color;
      this.shadowConfig.offsetX = this.syncShadowConfig.offsetX ?? shadowConfigTmp.offsetX;
      this.shadowConfig.offsetY = this.syncShadowConfig.offsetY ?? shadowConfigTmp.offsetY;
    } else {
      const windowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
      if (this.isFocused) {
        let focusedRadius = windowSceneConfig.focusedShadow.radius;
        log.showDebug('Set special window shadow, focusedRadius: ' + focusedRadius);
        if (focusedRadius > 0) {
          this.shadowConfig.radius = focusedRadius;
          this.shadowConfig.offsetX = windowSceneConfig.focusedShadow.offsetX;
          this.shadowConfig.offsetY = windowSceneConfig.focusedShadow.offsetY;
          this.shadowConfig.color = windowSceneConfig.focusedShadow.color;
        }
      } else {
        let unfocusedRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.radius;
        log.showDebug('Set special window shadow, unfocusedRadius: ' + unfocusedRadius);
        if (unfocusedRadius > 0) {
          this.shadowConfig.radius = unfocusedRadius;
          this.shadowConfig.offsetX = windowSceneConfig.unfocusedShadow.offsetX;
          this.shadowConfig.offsetY = windowSceneConfig.unfocusedShadow.offsetY;
          this.shadowConfig.color = windowSceneConfig.unfocusedShadow.color;
        }
      }
    }
  }

  private onSessionSetWindowShadows(shadowsInfo: SCBWindowShadowConfig): void {
    log.showInfo('onSessionSetWindowShadows Set special shadows, radius: ' + shadowsInfo.radius +
      ' color: ' + shadowsInfo.color + ' offsetX: ' + shadowsInfo.offsetX + ' offsetY: ' + shadowsInfo.offsetY);
    if (this.sessionData.setWindowShadowsCallback === undefined ||
      this.sessionData.setWindowShadowsCallback === null) {
      log.showError('setWindowShadowsCallback is undefined');
      return;
    }
    if (shadowsInfo.radius !== undefined && shadowsInfo.radius >= 0) {
      this.sessionData.setWindowShadowsCallback(shadowsInfo);
    }
  }

  private onSessionControlStatusChange(type: sceneSessionManager.PiPControlType, status: sceneSessionManager.PiPControlStatus): void {
    if (this.sessionData.sessionControlStatusChangeCallback) {
      this.sessionData.sessionControlStatusChangeCallback(type, status);
    }
  }

  public notifyParentRectChange(rect: SCBSessionRect, reason: sceneSessionManager.SessionSizeChangeReason,
    displayId: number, fromParent: boolean = true): void {
    if (!this.subWindowAnchorInfo.isFollowParent) {
      return;
    }
    log.showInfo('notifyParentRectChange');
    this.onSessionRectChangeRelativeToParent(rect, reason, fromParent, displayId);
  }

  public calculateAnchorRect(parentRect: SCBSessionRect, anchorRect: SCBSessionRect) : void {
    if (anchorRect.width.getPx() === 0 || anchorRect.height.getPx() === 0) {
      log.showError('calculateAnchorRect error');
      return;
    }
    const centerX = parentRect.left.getPx() + parentRect.width.getPx() / 2;
    const centerY = parentRect.top.getPx() + parentRect.height.getPx() / 2;
    const endX = parentRect.left.getPx() + parentRect.width.getPx();
    const endY = parentRect.top.getPx() + parentRect.height.getPx();
    switch (this.subWindowAnchorInfo.anchor) {
      case sceneSessionManager.WindowAnchor.TOP_START:
        anchorRect.setPosNum(parentRect.left.getPx(), parentRect.top.getPx());
        break;
      case sceneSessionManager.WindowAnchor.TOP:
        anchorRect.setPosNum(centerX - anchorRect.width.getPx() / 2, parentRect.top.getPx());
        break;
      case sceneSessionManager.WindowAnchor.TOP_END:
        anchorRect.setPosNum(endX - anchorRect.width.getPx(), parentRect.top.getPx());
        break;
      case sceneSessionManager.WindowAnchor.START:
        anchorRect.setPosNum(parentRect.left.getPx(), centerY - anchorRect.height.getPx() / 2);
        break;
      case sceneSessionManager.WindowAnchor.CENTER:
        anchorRect.setPosNum(centerX - anchorRect.width.getPx() / 2, centerY - anchorRect.height.getPx() / 2);
        break;
      case sceneSessionManager.WindowAnchor.END:
        anchorRect.setPosNum(endX - anchorRect.width.getPx(), centerY - anchorRect.height.getPx() / 2);
        break;
      case sceneSessionManager.WindowAnchor.BOTTOM_START:
        anchorRect.setPosNum(parentRect.left.getPx(), endY - anchorRect.height.getPx());
        break;
      case sceneSessionManager.WindowAnchor.BOTTOM:
        anchorRect.setPosNum(centerX - anchorRect.width.getPx() / 2, endY - anchorRect.height.getPx());
        break;
      case sceneSessionManager.WindowAnchor.BOTTOM_END:
        anchorRect.setPosNum(endX - anchorRect.width.getPx(), endY - anchorRect.height.getPx());
        break;
      default:
        break;
    }
    anchorRect.setPosNum(anchorRect.left.getPx() + this.subWindowAnchorInfo.offsetX,
      anchorRect.top.getPx() + this.subWindowAnchorInfo.offsetY);
  }

  private onSessionRectChangeRelativeToParent(rect: SCBSessionRect, reason: sceneSessionManager.SessionSizeChangeReason,
    fromParent: boolean, displayId?: number): void {
    if (!SCBSceneSessionManager.getInstance().isPcOrPcMode()) {
      return;
    }
    if (!fromParent && !this.getParentSession(this.screenId)) {
      log.showError('getParentSession() error');
      return;
    }
    let anchorRect = this.currRect.copy();
    let changeRect = rect.copy();
    if (fromParent) {
      this.calculateAnchorRect(changeRect, anchorRect);
    } else {
      anchorRect = rect.copy();
      changeRect = this.getParentSession(this.screenId)?.currRect.copy();
      this.calculateAnchorRect(changeRect, anchorRect);
    }
    let changedRect : sceneSessionManager.SessionRect = {
      posX_ : anchorRect.left.getPx(),
      posY_ : anchorRect.top.getPx(),
      width_ : anchorRect.width.getPx(),
      height_ : anchorRect.height.getPx(),
    }
    this.onSessionDisplayIdChange(displayId, changedRect, reason);
    let sessionRectChangeRelativeParentCallback = this.sessionRectChangeRelativeParentCallbackMap.get(this.screenId);
    if (sessionRectChangeRelativeParentCallback) {
      WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'rectChangeRelativeParentCallback exists, id: ' + this.session.persistentId +
        ', reason: ' + reason +
        ', changeRect: [' + changedRect.posX_ + ', ' + changedRect.posY_ + ', ' + changedRect.width_ + ', ' +
      changedRect.height_ + ']' +
        `, displayId:${displayId}` + `, screenId:${this.screenId}`);
      if (displayId !== undefined && displayId !== -1 && displayId !== this.screenId) {
        sessionRectChangeRelativeParentCallback = this.sessionRectChangeRelativeParentCallbackMap.get(displayId);
      }
      if (sessionRectChangeRelativeParentCallback) {
        sessionRectChangeRelativeParentCallback(changedRect, reason, fromParent);
        this.updateSizeChangeReason(reason);
        return;
      } else {
        log.showWarn(`rectChangeRelativeParentCallback is null. displayId:${displayId}`);
      }
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE && !fromParent) {
      this.currRect.setRectNum(changedRect.posX_, changedRect.posY_, changedRect.width_, changedRect.height_);
    } else {
      this.currRect.setPosNum(changedRect.posX_, changedRect.posY_);
    }
    WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'rectChangeRelativeParentCallback is undefined, id: ' + this.session.persistentId +
      ', reason: ' + reason + ', rect: [' + changedRect.posX_ + ', ' + changedRect.posY_ + ', ' + changedRect.width_ +
      ', ' + changedRect.height_ + ']' + ', currRect: [' + this.currRect.left.getPx() + ', ' +
    this.currRect.top.getPx() + ', ' + this.currRect.width.getPx() + ', ' + this.currRect.height.getPx() + ']');
    this.updateSizeChangeReason(reason);
  }

  public notifyParenLayoutChange(rect: sceneSessionManager.SessionRect,
      reason: sceneSessionManager.SessionSizeChangeReason, displayId: number): void {
    if (this.subWindowAnchorInfo.isFollowParent) {
      return;
    }
    if (!this.isFollowParentRect) {
      return;
    }
    log.showInfo('follow parent change display');
    this.onSessionRectChange(rect, reason, displayId);
  }

  public onSessionRectChange(rect: sceneSessionManager.SessionRect, reason: sceneSessionManager.SessionSizeChangeReason, displayId?: number): void {
    if (this.subWindowAnchorInfo.isFollowParent) {
      if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE ||
        reason === sceneSessionManager.SessionSizeChangeReason.RESIZE_BY_LIMIT) {
        let changedRect = new SCBSessionRect(rect.posX_, rect.posY_, rect.width_, rect.height_);
        this.onSessionRectChangeRelativeToParent(changedRect, reason, false, displayId);
      }
      return;
    }
    let isPcModeAndSupportCompatibleMode: boolean = false;
    this.onSessionDisplayIdChange(displayId, rect, reason);
    let sessionRectChangeCallback = this.sessionRectChangeCallbackMap.get(this.screenId);
    if (sessionRectChangeCallback) {
      WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'rectChangeCallback exists, id: ' + this.session.persistentId + ', reason: ' + reason +
        ', rect: [' + rect.posX_ + ', ' + rect.posY_ + ', ' + rect.width_ + ', ' + rect.height_ + ']' + `, displayId:${displayId}`);
      if (displayId !== undefined && displayId !== -1 && displayId !== this.screenId) {
        sessionRectChangeCallback = this.sessionRectChangeCallbackMap.get(displayId);
      }
      if (sessionRectChangeCallback) {
        sessionRectChangeCallback(rect, reason, displayId);
        this.updateSizeChangeReason(reason);
        return;
      } else {
        log.showWarn(`onSessionRectChange sessionRectChangeCallback is null. displayId:${displayId}`);
      }
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE && !isPcModeAndSupportCompatibleMode) {
      this.currRect.setPosNum(rect.posX_, rect.posY_);
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE && !isPcModeAndSupportCompatibleMode) {
      this.currRect.setSizeNum(rect.width_, rect.height_);
    } else {
      this.currRect.setRectNum(rect.posX_, rect.posY_, rect.width_, rect.height_);
    }
    WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'rectChangeCallback is undefined, id: ' + this.session.persistentId +
      ', reason: ' + reason + ', rect: [' + rect.posX_ + ', ' + rect.posY_ + ', ' + rect.width_ +
      ', ' + rect.height_ + ']' + ', currRect: [' + this.currRect.left.getPx() + ', ' +
    this.currRect.top.getPx() + ', ' + this.currRect.width.getPx() + ', ' + this.currRect.height.getPx() + ']');
    this.updateSizeChangeReason(reason);
  }

  private onSessionForceHideChange(hide: boolean): void {
    log.showInfo('onSessionForceHideChange, hide:' + hide + `id: ${this.session.persistentId}`);
    if (this.sessionData.sessionForceHideCallback) {
      this.sessionData.sessionForceHideCallback(hide);
    } else {
      this.visibility = !hide;
    }
  }

  /**
   * register session state change callback
   *
   * @param callback
   */
  public registerSessionStateChangeCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`registerSessionStateChangeCallback, invalid callback`);
      return;
    }
    log.showInfo(`registerSessionStateChangeCallback success, id: ${this.session.persistentId}`);
    this.sessionData.stateChangeCallback = callback;
    if (this.sessionData.needUpdateSubSessionState) {
      this.sessionData.stateChangeCallback(this.session.parentId, this.session.persistentId,
        this.sessionData.sessionState, this.session.zIndex);
      this.sessionData.needUpdateSubSessionState = false;
    }
  }

  /**
   * unregister session state change Callback
   *
   * @param callback, callback to be unregistered
   */
  public unregisterSessionStateChangeCallback(callback: Function): void {
    if (this.sessionData.stateChangeCallback === callback) {
      this.sessionData.stateChangeCallback = null;
      log.showInfo(`unregisterSessionStateChangeCallback successfully, id: ${this.session.persistentId}`);
      return;
    }
    log.showWarn(`unregisterSessionStateChangeCallback fail, param is not equal to current callback`);
  }

  private onSessionStateChange(state: sceneSessionManager.SessionState): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    if (typeof this.session.persistentId !== 'number') {
      log.showError('invalid id type: ' + typeof this.session.persistentId);
      return;
    }
    log.showInfo('onSessionStateChange, id: ' + this.session.persistentId + ', state: ' + state);
    if (state === sceneSessionManager.SessionState.STATE_ACTIVE || state === sceneSessionManager.SessionState.STATE_INACTIVE) {
      log.showInfo('Skip state change, SessionState: ' + state);
      return;
    }
    this.sessionData.sessionState = state;
    if (this.sessionData.stateChangeCallback) {
      this.sessionData.stateChangeCallback(this.session.parentId, this.session.persistentId, state, this.session.zIndex);
    } else {
      this.sessionData.needUpdateSubSessionState = true;
      log.showWarn(`stateChangeCallback is null, id: ${this.session.persistentId}, type: ${this.session.type}`);
    }

    // refresh containerSessionList to remove duplicate containerSession
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
      sessionChangeInfo.persistentIds.push(this.session.parentId);
      sessionChangeInfo.curScreenId = this.session.screenId;
      SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.REFRESH, sessionChangeInfo);
    }
  };

  private onRaiseToTop(): void {
    if (this.sessionData.raiseToTopCallback) {
      this.sessionData.raiseToTopCallback(this.session.parentId, this.session.persistentId, false);
      WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, 'onRaiseToTop, parentId: ' + this.session.parentId +
        ', id: ' + this.session.persistentId + ', type: ' + this.session.type);
    }
  }

  private onRaiseToTopForPointDown(): void {
    if (this.sessionData.raiseToTopCallback) {
      this.sessionData.raiseToTopCallback(this.session.parentId, this.session.persistentId, true, FocusChangeReason.CLICK);
      WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, 'onRaiseToTopForPointDown, parentId: ' + this.session.parentId +
        ', id: ' + this.session.persistentId + ', type: ' + this.session.type);
    }
    if (this.session.type === sceneSessionManager.SessionType.TYPE_DIALOG) {
      let parentSession = SCBSceneSessionManager.getInstance().getSessionById(this.session.parentId);
      if (parentSession && parentSession instanceof SCBSceneSession) {
        SCBSceneSessionManager.getInstance().requestToTop((parentSession as SCBSceneSession).sceneInfo.screenId,
          this.session.parentId, SCBWindowRaiseReason.SUBSESSION_POINT_DOWN);
        SCBSceneSessionManager.getInstance().refreshZOrder();
        WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, 'onRaiseToTopForPointDown, raise app to top for dialog, parentId: ' +
          this.session.parentId + ', id: ' + this.session.persistentId);
      } else {
        WinLog.showError(WinLogDomain.WMS_HIERARCHY, 'onRaiseToTopForPointDown, can not find parent for this dialog');
      }
    }
  }

  private onRaiseAboveTarget(subWindowId: number): void {
    if (this.sessionData.raiseAboveTargetCallback) {
      this.sessionData.raiseAboveTargetCallback(this.session.parentId, this.session.persistentId, subWindowId);
    }
  }

  private isSpecialHierarchyStrategy(newZLevel: number): boolean {
    let bundleName: string = this.getBundleName();
    if ((bundleName === 'cn.wps.office.hap' || bundleName === 'cn.wps.office.hap.ent.openharmony') &&
      (this.session.zLevel !== newZLevel && (this.session.zLevel > NORMAL_SUB_WINDOW_MAXIMUM_Z_LEVEL ||
      newZLevel > NORMAL_SUB_WINDOW_MAXIMUM_Z_LEVEL))) {
        return true;
    }
    return false;
  }

  private onZLevelChange(zLevel: number): void {
    if (this.isSpecialHierarchyStrategy(zLevel)) {
      WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, 'special hierarchy strategy, zLevel change block!');
      return;
    }
    if (this.sessionData.zLevelChangeCallback) {
      this.sessionData.zLevelChangeCallback(this.session.parentId, this.session.persistentId, zLevel);
      WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, `onZLevelChange, parentId:${this.session.parentId}, id: ${this.session.persistentId}, ` +
        `zLevel: ${zLevel}`);
    }
  }

  private onSessionFocusableChange(isFocusable: boolean): void {
    WinLog.showDebug(WinLogDomain.WMS_FOCUS, `onSessionFocusable, state: ${isFocusable}`);
    this.isFocusable = isFocusable;
  }

  private onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, state: ${isTouchable}`);
    if (this.sessionData.sessionTouchableChangeCallback) {
      this.sessionData.sessionTouchableChangeCallback(isTouchable);
    } else {
      this.isTouchable = isTouchable;
    }
  }

  private onClickModalWindowOutside(): void {
    log.showInfo(`onClickModalWindowOutside`);
    if (this.sessionData.clickModalWindowOutsideCallback) {
      this.sessionData.clickModalWindowOutsideCallback();
    }
  }

  private onCustomAnimationPlaying(isPlaying: boolean): void {
    log.showInfo(`onCustomAnimationPlaying, state: ${isPlaying}`);
    if (this.sessionData.customAnimationPlayingCallback) {
      this.sessionData.customAnimationPlayingCallback(isPlaying);
    }
  }

  private onNeedDefaultAnimationFlagChange(isWindowShowAnimate: boolean): void {
    log.showDebug(`onNeedDefaultAnimationFlagChange, state: ${isWindowShowAnimate}`);
    this.isWindowShowAnimate = isWindowShowAnimate;
  }

  private onSessionEvent(eventId: SCBSessionEventId, param: sceneSessionManager.SessionEventParam): void {
    log.showDebug(`onSessionEvent persistentId:${this.session?.persistentId}, eventId: ${eventId}`);
    switch (eventId) {
      case SCBSessionEventId.EVENT_START_MOVE:
        this.isSessionMoving = true;
        break;
      case SCBSessionEventId.EVENT_DRAG_START:
        this.isSessionMoving = true;
        break;
      case SCBSessionEventId.EVENT_END_MOVE:
        this.isSessionMoving = false;
        break;
      default:
        break;
    }
    this.onSessionTitleAction(eventId, param);
  }

  private onSessionTitleAction(eventId: number, param: sceneSessionManager.SessionEventParam): void {
    let screenId = this.screenId;
    if (this.sessionTitleActionCallbackMap.has(screenId)) {
      let callbackArray: Function[] = this.sessionTitleActionCallbackMap.get(screenId);
      if (!callbackArray) {
        return;
      }
      for (let callback of callbackArray) {
        if (callback) {
          callback(eventId, param);
        }
      }
    }
  }

  private getBundleName(): string {
    const mainSession: SCBSceneSession | null =
      SCBSceneSessionManager.getInstance().findMainSessionById(this.session.persistentId);
    if (CommonUtils.isInvalid(mainSession)) {
      return '';
    }
    return mainSession.sceneInfo?.bundleName;
  }

  private onSessionModalTypeChange(subWindowModalType: sceneSessionManager.SubWindowModalType): void {
    if (CommonUtils.isInvalid(this.session)) {
      return;
    }
    WinLog.showInfo(WinLogDomain.WMS_HIERARCHY, `onSessionModalTypeChange, state: ${subWindowModalType}`);
    this.session.subWindowAppModalType = subWindowModalType;
    if (SCBSceneSessionManager.getInstance().getTargetVersion(
        this.session.persistentId) % API_MOD >= SINCE_API_VERSION) {
        let bundleName: string = this.getBundleName();
        if (bundleName !== 'cn.wps.office.hap' && bundleName !== 'cn.wps.office.hap.ent.openharmony') {
          this.session.subWindowModalType = subWindowModalType;
        }
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  /**
   * is Modal SubSession
   */
  public isModal(): boolean {
    let subWindowAppModalType = this.session.subWindowAppModalType;
    return subWindowAppModalType === sceneSessionManager.SubWindowModalType.TYPE_APPLICATION_MODALITY ||
        subWindowAppModalType === sceneSessionManager.SubWindowModalType.TYPE_WINDOW_MODALITY ||
        subWindowAppModalType === sceneSessionManager.SubWindowModalType.TYPE_DIALOG;
  }

  /**
   * is Modal Application SubSession
   */
  public isModalApplication(): boolean {
    return this.session.subWindowAppModalType === sceneSessionManager.SubWindowModalType.TYPE_APPLICATION_MODALITY;
  }

  /**
   * get Focused
   *
   * @returns
   */
  public getFocused(): boolean {
    return this.isFocused;
  }

  /**
   * get Focusable
   *
   * @returns
   */
  public getFocusable(): boolean {
    return this.isFocusable;
  }

  /**
   * set Focusable
   *
   * @param isFocusable
   */
  public setFocusable(isFocusable): void {
    this.isFocusable = isFocusable;
  }

  /**
   * get Visibility
   *
   * @returns
   */
  public getVisibility(): boolean {
    return this.visibility;
  }

  /**
   * set Visibility
   *
   * @param visibility
   */
  public setVisibility(visibility: boolean): void {
    this.visibility = visibility;
  }

  /**
   * add Ref Count
   */
  public addRefCount(): void {
    this.sessionData.refCount++;
  }

  /**
   * dec Ref Count
   */
  public decRefCount(): void {
    this.sessionData.refCount--;
  }

  /**
   * get ref count
   */
  public getRefCount(): number {
    return this.sessionData.refCount;
  }

  /**
   * un Register All
   */
  public unRegisterAll(): void {
    if (this.getRefCount() !== 0) {
      return;
    }
    this.sessionData.createSubSessionCallback = null;
    this.sessionData.setWindowShadowsCallback = null;
    this.sessionData.getZIndexCallback = null;
    this.sessionData.sessionControlStatusChangeCallback = null;
    this.sessionData.sessionTouchableChangeCallback = null;
    this.sessionData.customAnimationPlayingCallback = null;
    this.sessionData.sessionForceHideCallback = null;
    this.sessionData.sessionPrepareCloseCallback = null;
    this.sessionData.clickModalWindowOutsideCallback = null;
    this.setWindowCornerRadiusCallback = null;
  }

  /**
   * update Size Change Reason
   *
   * @param reason
   */
  public updateSizeChangeReason(reason: sceneSessionManager.SessionSizeChangeReason): void {
    try {
      if (this.session == null) {
        log.showError('[SCBMain]updateSizeChangeReason null session');
        return;
      }
      this.session.updateSizeChangeReason(reason);
    } catch (err) {
      log.showError('[SCBMain]updateSizeChangeReason failed, with reason ' + JSON.stringify(err));
    }
    log.showInfo(`id:${this.session?.persistentId} updateSizeChangeReason:${reason}`);
  }

  /*
   * update displayId from native
   */
  private onSessionDisplayIdChange(displayId: number, rect?: sceneSessionManager.SessionRect,
    reason?: sceneSessionManager.SessionSizeChangeReason): void {
    if (displayId !== undefined && displayId !== -1 && displayId !== this.screenId) {
      let sessionChangeInfo: SessionChangeInfo = new SessionChangeInfo();
      sessionChangeInfo.persistentIds.push(this.session.persistentId);
      sessionChangeInfo.targetScreenId = displayId;
      sessionChangeInfo.curScreenId = this.screenId;
      sessionChangeInfo.sessionType = this.session.type;
      if (rect && reason !== undefined) {
        let sessionRectChangeInfo = new SessionRectChangeInfo();
        sessionRectChangeInfo.newRect = rect;
        sessionRectChangeInfo.reason = reason;
        sessionChangeInfo.sessionRectChangeMap.set(this.session.persistentId, sessionRectChangeInfo);
      }
      if (this.session.type === sceneSessionManager.SessionType.TYPE_SUB_APP || this.session.type === sceneSessionManager.SessionType.TYPE_DIALOG) {
        SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.MOVE_SUB_WINDOW_TO_TARGET_DISPLAY,
          sessionChangeInfo);
      } else {
        SCBSceneSessionManager.getInstance().sessionDisplayChange(SessionDisplayChangeReason.MOVE_SPECIFIC_WINDOW_TO_TARGET_DISPLAY,
          sessionChangeInfo);
      }
      this.updateDisplayId(displayId);
    } else {
      log.showDebug(`id: ${this.session.persistentId} screenId: ${displayId} not change displayId`);
    }
  }

  /**
   * update ts session displayId and C++ session displayId
   */
  public updateDisplayId(screenId: number): void {
    this.session.screenId = screenId;
    if (this.sessionData.screenIdChangeCallback) {
      this.sessionData.screenIdChangeCallback(screenId);
    } else {
      this.screenId = screenId;
    }
    SCBSceneSessionManager.getInstance().updateSessionDisplayId(this.session.persistentId, screenId);
  }

  public updateDisplayIdRecursively(targetScreenId: number, currentScreenId: number): void {
    if (this.screenId === currentScreenId) {
      this.updateDisplayId(targetScreenId);
    }
    this.subSessionList.forEach((item)=> {
      item?.updateDisplayIdRecursively(targetScreenId, currentScreenId);
    });
  }

  public updateSessionStateChangeFunc(stateChangeCallback: Function) : void {
    log.showInfo(`updateSessionStateChangeFunc, id: ${this.session.persistentId}, type: ${this.session.type}`);
    this.sessionData.stateChangeCallback = stateChangeCallback;
  }

  /**
   * update Rect
   *
   * @param left
   * @param top
   * @param width
   * @param height
   * @param reason
   */
  public updateRect(left: ScbNumber, top: ScbNumber, width: ScbNumber, height: ScbNumber,
                    reason?: sceneSessionManager.SessionSizeChangeReason): void {
    this.updateSizeChangeReason(reason);
    this.currRect.setRect(left, top, width, height);
    WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'updateRect, id: ' + this.session?.persistentId + ', reason: ' + reason + ', rect: [' +
      left?.getPx() + ', ' + top?.getPx() + ', ' + width?.getPx() + ', ' + height?.getPx() + ']');
  }

  /**
   * @param mainRect
   */
  public updateSubRectForSplit(screenProperty: SCBScreenProperty, mainRect: SCBSessionRect,
    reason?: sceneSessionManager.SessionSizeChangeReason): void {
    if (this.requestedRect.isEmpty()) {
      // if create sub window without setting size will setRequestedRect fullscreen
      this.setRequestedRect(new SCBSessionRect(0, 0, screenProperty.width, screenProperty.height));
    }
    reason = reason ? reason : sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
    this.onSessionRectChange(this.updateSubRectAlgorithm(mainRect).transfer2SessionRect(),
      reason);
  }

  /**
   * @param mainRect
   */
  public updateSubRectForFloat(screenProperty: SCBScreenProperty, mainRect: SCBSessionRect): void {
    if (this.requestedRect.isEmpty()) {
      // if create sub window without setting size will setRequestedRect fullscreen
      this.setRequestedRect(new SCBSessionRect(0, 0, screenProperty.width, screenProperty.height));
    }
    this.onSessionRectChange(this.updateSubRectAlgorithm(mainRect).transfer2SessionRect(),
      sceneSessionManager.SessionSizeChangeReason.FULL_TO_FLOATING);
  }

  /**
   * algorithm keeps sub rect inside main rect
   * @param mainRect
   * @returns
   */
  public updateSubRectAlgorithm(mainRect: SCBSessionRect): SCBSessionRect {
    let subRect = new SCBSessionRect(this.requestedRect.left.getPx(), this.requestedRect.top.getPx(),
      this.requestedRect.width.getPx(), this.requestedRect.height.getPx());
    if (mainRect.width.getPx() === 0 || mainRect.height.getPx() === 0) {
      log.showWarn('updateSubRectAlgorithm invalid width or height of mainRect');
      return subRect;
    }
    subRect.width.setNumber(Math.min(subRect.width.getPx(), mainRect.width.getPx()));
    subRect.height.setNumber(Math.min(subRect.height.getPx(), mainRect.height.getPx()));
    subRect.left.setNumber(Math.max(0, Math.min(subRect.left.getPx(), mainRect.width.getPx() - subRect.width.getPx())));
    subRect.top.setNumber(Math.max(0, Math.min(subRect.top.getPx(), mainRect.height.getPx() - subRect.height.getPx())));
    return subRect;
  }

  /**
   * recalculate SubRect if in multiWindow
   * @param screenProperty
   * @returns
   * @param screenProperty
   * @returns
   */
  public calSubRectInMultiWindow(screenProperty: SCBScreenProperty): SCBSessionRect | null {
    let parentSession: SCBSceneSession = this.getParentSession();
    if (!(this.isDialogWindow() || this.isSubWindow())) {
      return null;
    }
    if (parentSession === null) {
      return null;
    }
    let floatContainer = SCBSceneSessionManager.getInstance().getFloatingSessionList().findByPersistentId(
      parentSession.sceneInfo?.persistentId);
    if (parentSession.isInSplit() || floatContainer) {
      let mainRect: SCBSessionRect = parentSession.currRect;
      if (this.requestedRect.isEmpty()) {
        this.setRequestedRect(mainRect.copy());
      }
      this.setWindowOffset(mainRect.left.getPx(), mainRect.top.getPx());
      if (floatContainer) {
        let posX = floatContainer.needRenderPos.posX;
        let posY = floatContainer.needRenderPos.posY;
        this.setWindowOffset(vp2px(posX), vp2px(posY));
        this.setWindowScale(floatContainer.floatingParam.scale, floatContainer.floatingParam.scale);
        parentSession?.updateFloatingScale(floatContainer.floatingParam.scale);
      }
      let resRect: SCBSessionRect = this.updateSubRectAlgorithm(mainRect);
      return resRect;
    }
    let isMidScene = SCBSceneSessionManager.getInstance().getContainerSessionList()
      .findByPersistentId(parentSession.sceneInfo?.persistentId)?.isMidScene;
    if (isMidScene) {
      let mainRect: SCBSessionRect = parentSession.currRect;
      if (this.requestedRect.isEmpty()) {
        this.setRequestedRect(mainRect.copy());
      }
      this.setWindowOffset(mainRect.left.getPx(), mainRect.top.getPx());
      if (parentSession && parentSession.sceneParam) {
        parentSession.updateFloatingScale(parentSession.sceneParam.sessionScaleX);
      }
      let resRect: SCBSessionRect = this.updateSubRectAlgorithm(mainRect);
      return resRect;
    }
    return null;
  }

  public getParentSession(screenId ?: number): SCBSceneSession | null {
    let parentId = this.session.parentId;
    let totalSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList(screenId).clone();
    let floatContainerSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
    totalSessionList.push(...floatContainerSessionList);
    let parentSession = totalSessionList.getSceneSessionByPersistentId(parentId);
    if (parentSession === null) {
      parentSession = SCBSceneMissionManager.getInstance().findMainSessionGlobalById(parentId);
    }
    if (CommonUtils.isInvalid(parentSession)) {
      log.showWarn(`getParentSession: fail to find containerSession with persistentId: ${parentId}`);
      return null;
    }
    return parentSession;
  }

  public setRequestedRect(requestedRect: SCBSessionRect): void {
    this.requestedRect = requestedRect.copy();
  }

  public isSessionForeground():boolean {
    if (this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_FOREGROUND ||
      this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE) {
      return true;
    }
    return false;
  }

  public getName(): string {
    return `persistentId: ${this.session.persistentId}`;
  }

  public isSpecialUECSubWindow(): boolean {
    let bundleName: String | undefined = this.session?.bundleName;
    return bundleName === 'com.ohos.notificationdialog' ||
      bundleName === 'com.ohos.security.privacycenter';
  }

  public isSpecialTopmostUECSubWindow(): boolean {
    return this.isSpecialUECSubWindow() && this.isTopmostSubWindow();
  }

  public isSpecialCompatibleUECSubWindow(): boolean {
    return false;
  }

  private onFollowRelativePositionToParent(windowAnchorInfo: sceneSessionManager.WindowAnchorInfo): void {
    if (!windowAnchorInfo) {
      this.session.activateDragBySystem(true);
      this.session.sendContainerModalEvent(WINDOW_GRAY_OUT_MAXIMIZE_EVENT, 'false');
      return;
    }
    if (!windowAnchorInfo.isAnchorEnabled) {
      this.session.activateDragBySystem(true);
      this.session.sendContainerModalEvent(WINDOW_GRAY_OUT_MAXIMIZE_EVENT, 'false');
      this.subWindowAnchorInfo.isFollowParent = false;
      return;
    }
    log.showInfo('onFollowRelativePositionToParent ');
    this.subWindowAnchorInfo.isFollowParent = true;
    this.subWindowAnchorInfo.anchor = windowAnchorInfo.windowAnchor;
    this.subWindowAnchorInfo.offsetX = windowAnchorInfo.offsetX;
    this.subWindowAnchorInfo.offsetY = windowAnchorInfo.offsetY;
    this.session.activateDragBySystem(false);
    this.session.sendContainerModalEvent(WINDOW_GRAY_OUT_MAXIMIZE_EVENT, 'true');
    this.onSessionRectChangeRelativeToParent(this.currRect, sceneSessionManager.SessionSizeChangeReason.UNDEFINED, false);
  }

  private onFollowParentRect(isFollow: boolean): void {
    this.isFollowParentRect = isFollow;
    let parentSession: SCBSceneSession | null = this.getParentSession(this.screenId);
    let needCorssDisplay = parentSession && isFollow && this.screenId !== parentSession.sceneInfo.screenId;
    if (needCorssDisplay) {
      console.info(`curr screenId: ${this.screenId}, parent screen id: ${parentSession.sceneInfo.screenId}`);
      this.onSessionRectChange({
        posX_: parentSession.currRect.left.getPx(),
        posY_: parentSession.currRect.top.getPx(),
        width_: parentSession.currRect.width.getPx(),
        height_: parentSession.currRect.height.getPx(),
      }, sceneSessionManager.SessionSizeChangeReason.MOVE, parentSession.sceneInfo.screenId);
    }
    let func = this.followParentWindowLayoutMap.get(this.screenId);
    if (!func) {
      WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'followParentWindowLayout is null');
      return;
    }
    func(isFollow);
  }

  public registerFollowParentWindowLayout(callback: Function, screenId ?: number): void {
    let screen = screenId !== undefined ? screenId : this.screenId;
    WinLog.showInfo(WinLogDomain.WMS_LAYOUT, `register follow rect callback, screenId: ${screenId}}`);
    this.followParentWindowLayoutMap.set(screen, callback);
    callback(this.isFollowParentRect);
  }

  public unregisterFollowParentWindowLayout(screenId: number): void {
    this.followParentWindowLayoutMap.delete(screenId);
  }

  /**
   * register update maximize rect callback
   *
   * @param callback
   */
  public registerUpdateMaximizeRectCallback(callback: Function): void {
    log.showInfo(`registerMaximizeRectChangeCallback persistentId: ${this.session?.persistentId}`);
    this.sessionData.updateMaximizeRectCallback = callback;
  }

  /**
   * unregister update maximize rect change callback
   */
  public unRegisterUpdateMaximizeRectCallback(): void {
    log.showInfo(`unRegisterLayoutFullScreenChangeCallback persistentId: ${this.session?.persistentId}`);
    if (!this.sessionData.updateMaximizeRectCallback) {
      return;
    }
    this.sessionData.updateMaximizeRectCallback = null;
  }

  public onUpdateMaximizeRect(): void {
    if (this.sessionData.updateMaximizeRectCallback) {
      this.sessionData.updateMaximizeRectCallback(this.layoutFullScreen);
    }
  }

  public UpdateFollowScreenChange(isFollowScreenChange: boolean): void {
    log.showInfo(`persistentId: ${this.session.persistentId} follow screen change : ${isFollowScreenChange}!`);
    this.isFollowScreenChange = isFollowScreenChange;
  }


  /**
   * request close the specific session
   */
  public requestSpecificSessionClose(): void {
    if (!this.session) {
      log.showError('request close failed, session is null');
      return;
    }
    try {
      log.showInfo(`requestSpecificSessionClose persistentId: ${this.session.persistentId}`);
      this.session.requestSpecificSessionClose();
    } catch (err) {
      log.showError('requestSpecificSessionClose failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * run the drag window moving callback function
   * @param displayId
   * @param pointerX
   * @param pointerY
   */
  private processWindowMoving(displayId: number, pointerX: number, pointerY: number): void {
    this.currMovePointerPos.setPointerPos(pointerX, pointerY);
    let callbackArray: Function[] = this.windowMovingCallbackMap.get(displayId);
    if (!callbackArray || callbackArray.length === 0) {
      return;
    }
    const callback = callbackArray[callbackArray.length - 1];
    if (callback) {
      callback(displayId, pointerX, pointerY);
    }
  }

  /**
   * register callback drag window moving
   * @param callback
   * @param screenId
   */
  public registerWindowMovingCallback(callback: (displayId: number, pointerX: number, pointerY: number) => void,
    screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.screenId;
    log.showDebug(`registerWindowMovingCallback screenId: ${screenId}`);
    if (this.windowMovingCallbackMap.has(screenId)) {
      let callbackArray: Function[] = this.windowMovingCallbackMap.get(screenId);
      const index = callbackArray.indexOf(callback);
      if (index === -1) {
        callbackArray.push(callback);
      }
      return;
    }
    let callbackArray: Function[] = [];
    callbackArray.push(callback);
    this.windowMovingCallbackMap.set(screenId, callbackArray);
  }

  /**
   * unregister callback drag window moving
   * @param screenId
   */
  public unregisterWindowMovingCallback(callback: Function, screenId?: number): void {
    screenId = screenId !== undefined ? screenId : this.screenId;
    log.showDebug(`unregisterWindowMovingCallback screenId: ${screenId}`);
    if (!this.windowMovingCallbackMap.has(screenId)) {
      return;
    }
    let callbackArray: Function[] = this.windowMovingCallbackMap.get(screenId);
    let index = callbackArray.indexOf(callback);
    if (index !== -1) {
      callbackArray.splice(index, 1);
    }
    if (callbackArray.length === 0) {
      this.windowMovingCallbackMap.delete(screenId);
    }
  }
}
