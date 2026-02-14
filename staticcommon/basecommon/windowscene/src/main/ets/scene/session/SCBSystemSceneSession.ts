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
import { SCBSessionInfo } from './SCBSessionInfo';
import { SCBSessionRect } from './SCBSessionRect';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBEventId, SCBSceneSessionManager, SCBSpecificSceneSessionList, ClassType } from './SCBSceneSessionManager';
import type { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import type { SCBPropertyChangeReason } from '../../screen/session/SCBScreenSessionManager';
import {viewMgrPolicy} from '@ohos/frameworkwrapper';
import { RotationConstants } from '@ohos/commonconstants';
import { CommonUtils } from '@ohos/basicutils';
import { FocusChangeReason } from '../../common/FocusChangeReason';
import { SCBWindowRotateController } from '../manager/SCBWindowRotateController';
import { SCBWindowRaiseReason } from '../../common/SCBWindowRaiseReason';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBSystemSceneSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export interface SystemSessionChangeCallback {
  /**
   * system scene session active status change
   *
   * @param isActive active status
   */
  onActiveChange(isActive: boolean): void;

  /**
   * system scene session visibility status change
   *
   * @param visibility visibility status
   */
  onVisibilityChange(visibility: boolean): void;

  /**
   * system scene session focusable status change
   *
   * @param visibility focusable status
   */
  onFocusableChange(isFocusable: boolean): void;

  /**
   * system scene session hitTestMode status change
   *
   * @param hitTestMode hitTestMode status
   */
  onHitTestModeChange(hitTestMode: HitTestMode): void;

  /**
   * position of system scene session
   *
   * @param rect position of scene session
   */
  onUpdateRect(rect: SCBSessionRect): void;

  /**
   * notify touch outside
   *
   */
  onTouchOutside(x: number, y: number): void;

  /**
   * system scene session translate change
   */
  onTranslateChange(x: number, y: number, z: number): void;

  /**
   * system scene session backgroundColor change
   */
  onBackgroundColorChange(backgroundColor: string): void;

  /**
   * system scene session backdropBlur change
   */
  onBackdropBlurChange(backdropBlur: number): void;

  /**
   * system scene session borderRadius change
   */
  onBorderRadiusChange(borderRadius: number): void;

  /**
   * system scene session shadow change
   */
  onShadowChange(radius: number, color: string, offsetX: number, offsetY: number): void;

  /**
   * system scene session opacity change
   */
  onOpacityChange(opacity: number): void;

  /**
   * system scene session touchable change
   *
   * @param touchable touchable status
   */
  onTouchableChange(touchable: boolean): void;

  /**
   * system scene session rotation change
   */
  onRotationChange(screenProperty: SCBScreenProperty): void;

  onActiveModeChange(oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty): void;

  /**
   * system scene session fold property change
   */
  onFoldChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void;

  /**
   * system scene session zIndex change
   * @param zIndex
   */
  onZIndexChange(zIndex: number): void;
  onResponseRegionChange(responseRegion: Array<Rectangle>): void;
};

export enum SystemBarType {
  STATUS_BAR,
  SMART_DOCK,
  UNDEFINE,
};

/**
 * config that controls some statements in onSessionStateChange
 * skipUnFocus: true means to skip the default unFocus statement,
 *  you should unFocus the session yourself if it's true
 * unFocusDelay: setting value means activate the delay unFocus notification and delay for set time;
 */
export interface SystemSessionBackgroundOptions {
  skipUnFocus: boolean;
  unFocusDelay?: number;
}

export interface SystemSessionInfo {
  systemType: sceneSessionManager.SessionType;
  sceneName: string;
  sceneZIndex: number;
  currRect?: SCBSessionRect;
  isActive?: boolean;
  visibility?: boolean;
  isFocusable?: boolean;
  isBlockingFocus?: boolean; // true: block lower zOrder session requestFocus
  isTouchable?: boolean;
  privacyMode?: boolean;
  hitTestMode: HitTestMode;
  isRotatable?: boolean;
  isLandscapeStartRotatable?: boolean;
  sceneType?: sceneSessionManager.SceneType;
  isSetPointerAreas?: boolean;
  windowInputType?: number;
  opacity?: number;
  translate?: {
    x?: number,
    y?: number,
    z?: number
  };
  backgroundColor?: string;
  borderRadius?: number;
  backdropBlur?: number;
  systemBarType?: SystemBarType;
  shadow?: {
    radius?: number,
    color?: string,
    offsetX?: number,
    offsetY?: number
  };
  scbKeepKeyboardFlag?: boolean;
  isOverlayScene?:boolean;
  responseRegion?:Array<Rectangle>;
  mainWindowPersistentId?: number;
  screenId?: number;
  isAppUseControl?: boolean;
  isFollowDeskTop?: boolean;
  enableActiveModeChange?: boolean;
  alwaysNeedAnimateWhenRotation?: boolean;
}

/**
 * Callback for Background event of System SceneSession
 */
export type SysSessionBackCallback = (persistentId: number,
                                                 backOptions?: SystemSessionBackgroundOptions) => void;

class PropertyUnrelatedToBuild {
  isFocused: boolean = false;
}
/**
 * Session of system scene or sub scene
 */
class SCBSystemSceneSessionData {
  sessionState: sceneSessionManager.SessionState;
  isRotatable: boolean = false;
  isLandscapeStartRotatable: boolean = false;
  systemType: sceneSessionManager.SessionType = sceneSessionManager.SessionType.TYPE_UNDEFINED;
  id: number = 0;
  systemBarType: SystemBarType = SystemBarType.UNDEFINE;
  transformRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  avoidRect?: SCBSessionRect;
  isFollowDeskTop: boolean = false;
  enableActiveModeChange: boolean = true;
}

class SCBSystemSceneSessionDataInner {
  property: PropertyUnrelatedToBuild = new PropertyUnrelatedToBuild();
  sessionInfo: SCBSessionInfo = new SCBSessionInfo();
  /**
   * Offset X of the WindowScene associated with the session
   */
  windowOffsetX: number = 0;

  /**
   * Offset Y of the WindowScene associated with the session
   */
  windowOffsetY: number = 0;

  /**
   * scale of the WindowScene associated with the session
   */
  scale: number = 1;
}

@Observed
export class SCBSystemSceneSession {
  readonly session: sceneSessionManager.SceneSession;

  readonly classType: ClassType = ClassType.SYSTEM_SCENE_SESSION;
  /**
   * public data of a session,which should not trigger ui flush
   */
  sessionData: SCBSystemSceneSessionData = new SCBSystemSceneSessionData();
  /**
   * private data of a session,which should not exposed to widgets
   */
  private sessionDataInner: SCBSystemSceneSessionDataInner = new SCBSystemSceneSessionDataInner();
  /*
   get function provide to sessionData only. forbid ui flush
   */
  get sessionState(): sceneSessionManager.SessionState {
    return this.sessionData.sessionState;
  }
  get isRotatable(): boolean {
    if (this.sessionData.isFollowDeskTop) {
      return SCBWindowRotateController.getInstance().isDesktopRotatable();
    }
    return this.sessionData.isRotatable;
  }
  get isLandscapeStartRotatable(): boolean {
    return this.sessionData.isLandscapeStartRotatable;
  }
  get systemType(): sceneSessionManager.SessionType {
    return this.sessionData.systemType;
  }
  get id(): number {
    return this.sessionData.id;
  }
  get systemBarType(): SystemBarType {
    return this.sessionData.systemBarType;
  }

  get transformRect(): SCBSessionRect {
    return this.sessionData.transformRect;
  }

  get avoidRect(): SCBSessionRect | undefined {
    return this.sessionData.avoidRect;
  }

  get isFollowDeskTop(): boolean {
    return this.sessionData.isFollowDeskTop;
  }

  get isEnableActiveModeChange(): boolean {
    return this.sessionData.enableActiveModeChange;
  }

  isActive: boolean = false;
  isFocusable: boolean = false;
  isFocusbaleOnShow: boolean = true;
  isBlockingFocus: boolean = false;
  isTouchable: boolean = false;
  hitTestMode: HitTestMode = HitTestMode.None;
  readonly isShowWhenLocked: boolean = false;
  visibility: boolean = false;
  alwaysNeedAnimateWhenRotation: boolean = false;
  name: string = '';
  zIndex: number = 0;
  readonly isOverlayScene: boolean = false;
  currRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  translateX: number = 0;
  translateY: number = 0;
  translateZ: number = 0;
  private _rotation: number = 0;
  opacity: number = 1;
  backgroundColor: string = '';
  borderRadius: number = 0;
  backdropBlur: number = 0;
  radius: number = 0;
  color: string = '';
  offsetX: number = 0;
  offsetY: number = 0;
  inputChangeCallback: Function;
  responseRegion:Array<Rectangle> = [];

  /**
   * Hierarchy lifting for app use control
   */
  mainWindowScreenId?: number = 0;
  mainWindowPersistentId?: number = 0;
  isAppUseControl?: boolean = false;

  private touchOutsideCallback: (x: number, y: number) => void;

  /**
   * @deprecated
   */
  private rotateChangeCallback: (angle: number) => void;
  private sessionStateBackgroundCallbackMap: Map<string, Function> = new Map();
  private sessionStateBackgroundDelayCallbackMap: Map<string, Function> = new Map();
  private afterUpdateRectCallback: (rect: SCBSessionRect) => void;

  /*
   * callback of session state change
   */
  sessionChangeCallback?: SystemSessionChangeCallback;

  subSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  subSessionRaiseToTopCallback: Function | null;
  subSessionRaiseAboveTargetCallback: Function | null;
  subSessionStateChangeCallback: Function | null;
  subSessionZLevelChangeCallback: Function | null;

  /**
   * Constructor.
   * @param session Session of the scene
   * @param sceneInfo Information of the scene
   */
  constructor(session: sceneSessionManager.SceneSession, systemSessionInfo: SystemSessionInfo,
    sessionChangeCallback?: SystemSessionChangeCallback) {
    if (systemSessionInfo === null || systemSessionInfo === undefined) {
      log.showError(`constructor, id: ${session.persistentId}, type: ${session.type} systemInfo is null`);
      return;
    }
    this.name = systemSessionInfo.sceneName;
    this.zIndex = systemSessionInfo.sceneZIndex;
    log.showInfo(`constructor, id: ${session.persistentId}, type: ${session.type}, systemName: ${this.name}`);
    this.session = session;
    this.setSystemSessionStat(systemSessionInfo);
    this.sessionData.systemType = systemSessionInfo.systemType;
    this.sessionData.systemBarType = systemSessionInfo.systemBarType;
    this.sessionChangeCallback = sessionChangeCallback;
    this.responseRegion = systemSessionInfo.responseRegion;
    this.isOverlayScene = systemSessionInfo.isOverlayScene;
    this.mainWindowScreenId = systemSessionInfo.screenId;
    this.mainWindowPersistentId = systemSessionInfo.mainWindowPersistentId;
    this.isAppUseControl = systemSessionInfo.isAppUseControl;

    this.session.on('click', (requestFocus:boolean = true, isClick:boolean = true) => {
      this.onClick(requestFocus, isClick);
    });
  }

  private setSystemSessionStat(systemSessionInfo: SystemSessionInfo): void {
    if (systemSessionInfo.isActive) {
      this.isActive = systemSessionInfo.isActive;
    }
    if (systemSessionInfo.isFocusable) {
      this.setFocusable(systemSessionInfo.isFocusable);
    } else {
      this.setFocusable(false);
    }
    if (systemSessionInfo.isBlockingFocus) {
      this.setBlockingFocus(systemSessionInfo.isBlockingFocus);
    } else {
      this.setBlockingFocus(false);
    }
    this.setTouchable(systemSessionInfo.isTouchable === undefined ? true : systemSessionInfo.isTouchable);
    if (systemSessionInfo.privacyMode) {
      this.setPrivacyMode(systemSessionInfo.privacyMode);
    }
    this.hitTestMode = systemSessionInfo.hitTestMode;
    this.setSystemSessionRotableStat(systemSessionInfo);
    if (systemSessionInfo.visibility) {
      this.visibility = systemSessionInfo.visibility;
    }
    if (systemSessionInfo.currRect) {
      this.currRect = systemSessionInfo.currRect;
      log.showInfo(`[SCBSystem]systemName: ${this.name} aboutToAppear currRect: ${JSON.stringify(this.currRect)}!` );
    }
    if (systemSessionInfo.opacity) {
      this.opacity = systemSessionInfo.opacity;
    }
    if (systemSessionInfo.translate?.x) {
      this.translateX = systemSessionInfo.translate.x;
    }
    if (systemSessionInfo.translate?.y) {
      this.translateY = systemSessionInfo.translate.y;
    }
    if (systemSessionInfo.translate?.z) {
      this.translateZ = systemSessionInfo.translate.z;
    }
    if (systemSessionInfo.backgroundColor) {
      this.backgroundColor = systemSessionInfo.backgroundColor;
    }
    if (systemSessionInfo.borderRadius) {
      this.borderRadius = systemSessionInfo.borderRadius;
    }
    if (systemSessionInfo.backdropBlur) {
      this.backdropBlur = systemSessionInfo.backdropBlur;
    }
    if (systemSessionInfo.shadow?.radius) {
      this.radius = systemSessionInfo.shadow.radius;
    }
    if (systemSessionInfo.shadow?.color) {
      this.color = systemSessionInfo.shadow.color;
    }
    if (systemSessionInfo.shadow?.offsetX) {
      this.offsetX = systemSessionInfo.shadow.offsetX;
    }
    if (systemSessionInfo.shadow?.offsetY) {
      this.offsetY = systemSessionInfo.shadow.offsetY;
    }
    if (systemSessionInfo.scbKeepKeyboardFlag) {
      this.setSCBKeepKeyboard(systemSessionInfo.scbKeepKeyboardFlag);
    } else {
      this.setSCBKeepKeyboard(false);
    }
    if (systemSessionInfo.alwaysNeedAnimateWhenRotation) {
      this.alwaysNeedAnimateWhenRotation = systemSessionInfo.alwaysNeedAnimateWhenRotation;
    }
    this.sessionData.systemType = systemSessionInfo.systemType;
    this.sessionData.systemBarType = systemSessionInfo.systemBarType;
    this.sessionData.isFollowDeskTop = systemSessionInfo.isFollowDeskTop;
    this.sessionData.enableActiveModeChange = systemSessionInfo.enableActiveModeChange ?? true;
  }

  private setSystemSessionRotableStat(systemSessionInfo: SystemSessionInfo): void {
    if (systemSessionInfo.isRotatable) {
      this.sessionData.isRotatable = systemSessionInfo.isRotatable;
    }
    if (systemSessionInfo.isLandscapeStartRotatable) {
      this.sessionData.isLandscapeStartRotatable = systemSessionInfo.isLandscapeStartRotatable;
    }
  }

  public setTransformRect(transformRect: SCBSessionRect): void {
    this.sessionData.transformRect = transformRect;
  }

  /**
   * Register input method change listener
   *
   * @param { Function } callback
   */
  public registerInputMethodChangeListener(callback: Function) : void {
    if (!this.inputChangeCallback) {
      this.inputChangeCallback = callback;
      log.showDebug('registerInputMethodChangeListener, id: ' + this.session.persistentId);
    } else {
      log.showDebug('registerInputMethodChangeListener, callback exists, id: ' + this.session.persistentId);
    }
  }

  /**
   * Unregister input method change listener
   */
  public unregisterInputMethodChangeListener() : void {
    this.inputChangeCallback = null;
  }

  /**
   * The callback function of Register touch outside
   *
   * @param { Function } callback
   */
  public registerTouchOutsideCallback(callback: (x: number, y: number) => void): void {
    this.touchOutsideCallback = callback;
  }

  /**
   * The callback function of unregister touch outside
   */
  public unregisterTouchOutsideCallback(): void {
    this.touchOutsideCallback = null;
  }

  /**
   * Get whether the callback function of touch outside has valve
   *
   * @returns { Boolean }
   */
  public hasTouchOutsideCallback(): boolean {
    if (this.touchOutsideCallback) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * Notify when touch outside
   *
   * @param { Number } x
   * @param { Number } y
   */
  public notifyTouchOutside(x: number, y: number): void {
    if (this.touchOutsideCallback) {
      this.touchOutsideCallback(x, y);
    }
  }

  /**
   * set session touch outside callback
   *
   * Note: **Gesture back will not trigger this callback**
   *
   * @param { Function } callback null|undefined will covert to void callback
   */
  public setTouchOutsideCallback(callback: (() => void) | undefined | null): void {
    try {
      if (callback) {
        this.session.on('touchOutside', callback);
      } else {
        this.session.on('touchOutside', () => {});
      }
    } catch (e) {
      log.showError(`set touchOutside failed. reason: ${e}`);
    }
  }

  /**
   * register callback function of after systemSceneSession update rect
   *
   * @param { Function } callback
   */
  public registerAfterUpdateRectCallback(callback: (rect: SCBSessionRect) => void): void {
    this.afterUpdateRectCallback = callback;
  }

  /**
   * unregister callback function of after systemSceneSession update rect
   *
   * @param { Function } callback
   */
  public unregisterAfterUpdateRectCallback(): void {
    this.afterUpdateRectCallback = null;
  }

  /**
   * callback function of register rotate change
   * @deprecated
   * @param { Function } callback
   */
  public registerRotateChangeCallback(callback: (angle: number) => void): void {
    this.rotateChangeCallback = callback;
  }

  /**
   * callback function of unregister rotate change
   * @deprecated
   */
  public unregisterRotateChangeCallback(): void {
    this.rotateChangeCallback = null;
  }

  /**
   * Notify rotate change
   * @deprecated
   * @param { Number } angle
   */
  public notifyRotateChange(angle: number): void {
    if (this.rotateChangeCallback) {
      this.rotateChangeCallback(angle);
    }
  }

  /**
   * Notify input method change
   *
   * @param { Number } keyboardHeight
   */
  public notifyInputMethodChange(keyboardHeight: number) : void {
    if (this.inputChangeCallback) {
      this.inputChangeCallback(keyboardHeight);
      log.showDebug('notifyInputMethodChange, id: ' + this.session.persistentId +
        ', keyboardHeight: ' + keyboardHeight);
    }
  }

  /**
   * Process state change
   *
   * @param { sceneSessionManager.SessionState } state
   */
  public processStateChange(state: sceneSessionManager.SessionState): void {
    log.showInfo(`[SCBSystem]processStateChange, state: ${state} id: ${this.id} name: ${this.name}`);
    this.onSessionStateChange(state);
    return;
  }

  /**
   * System scene process back event
   */
  public systemSceneProcessBackEvent(): void {
    log.showInfo(`[SCBSystem]systemSceneProcessBackEvent, this.id: ${this.id} name: ${this.name}`);
    viewMgrPolicy.gestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.id);
  }

  /**
   * System scene process home event
   */
  public systemSceneProcessHomeEvent(): void {
    log.showInfo(`[SCBSystem]systemSceneProcessHomeEvent, this.id: ${this.id} name: ${this.name}`);
    viewMgrPolicy.gestureCallback(SCBEventId.HOME_GESTURE_EVENT, this.id);
  }

  /**
   * System scene process recent event
   */
  public systemSceneProcessRecentEvent(): void {
    log.showInfo(`[SCBSystem]systemSceneProcessRecentEvent, this.id: ${this.id} name: ${this.name}`);
    viewMgrPolicy.gestureCallback(SCBEventId.ENTER_RECENT_EVENT, this.id);
  }

  public registerSessionStateBackgroundCallback(key: string, callback: SysSessionBackCallback): void {
    this.sessionStateBackgroundCallbackMap.set(key, callback);
  }

  public unRegisterSessionStateBackgroundCallback(key: string): void {
    if (this.sessionStateBackgroundCallbackMap.has(key)) {
      this.sessionStateBackgroundCallbackMap.delete(key);
    }
  }

  public registerSessionStateBackgroundDelayCallback(key: string, callback: SysSessionBackCallback): void {
    this.sessionStateBackgroundDelayCallbackMap.set(key, callback);
  }

  public unRegisterSessionStateBackgroundDelayCallback(key: string): void {
    if (this.sessionStateBackgroundDelayCallbackMap.has(key)) {
      this.sessionStateBackgroundDelayCallbackMap.delete(key);
    }
  }

  /**
   * create a config that controls some statements in onSessionStateChange
   * @returns SystemSessionBackgroundOptions
   */
  private getSessionBackgroundOptions(): SystemSessionBackgroundOptions {
    const options: SystemSessionBackgroundOptions = { skipUnFocus: false };
    const propMarks: Map<string | symbol, boolean> = new Map();
    const skipOptionsProxy = new Proxy(options, {
      set: (obj, prop, value): boolean => {
        const objPropHasBeenSet = propMarks.get(prop);
        if (objPropHasBeenSet) {
          log.showError('not allowed to change a non default value');
          return false;
        }
        obj[prop] = value;
        propMarks.set(prop, true);
        return true;
      }
    });
    return skipOptionsProxy;
  }

  private notifySessionStateBackground(backgroundOptions: SystemSessionBackgroundOptions): void {
    this.sessionStateBackgroundCallbackMap.forEach((callback: Function) => {
      callback(this.session.persistentId, backgroundOptions);
    });
  }

  private delayNotifySessionStateBackground(backgroundOptions: SystemSessionBackgroundOptions): Promise<void> {
    const delayFn = (): void => {
      this.sessionStateBackgroundDelayCallbackMap.forEach((callback: Function) => {
        callback(this.session.persistentId, backgroundOptions);
      });
    };
    return new Promise((resolve, reject) => {
      try {
        setTimeout(() => {
          delayFn();
          resolve();
        }, backgroundOptions.unFocusDelay);
      } catch (e) {
        reject(e);
      }
    });
  }

  private slowUnfocus(): void {
    const DELAY_MS = 50;
    setTimeout(() => {
      SCBSceneSessionManager.getInstance().requestUnfocus(this.session.persistentId, FocusChangeReason.SCB_SESSION_REQUEST_UNFOCUS);
    }, DELAY_MS);
  }

  /**
   * callback when sessionState changes
   * notifySessionStateBackground: call all callback funcs that registered before
   * delayNotifySessionStateBackground: call all delay callback funcs that registered before,
   *  see SystemSessionBackgroundOptions for more detail
   * if unFocusDelay is set , that will make the program wait for 'unFocusDelay' ms
   * if skipUnFocus is set true , that will make the program skip the default unFocus statement
   * @param state
   * @returns
   */
  private async onSessionStateChange(state: sceneSessionManager.SessionState): Promise<void> {
    if (!this.session) {
      log.showError('[SCBSystem] onSessionStateChange session is null');
      return;
    }
    if (typeof this.session.persistentId !== 'number') {
      log.showError('[SCBSystem] onSessionStateChange invalid id type: ' + typeof this.session.persistentId);
      return;
    }
    log.showInfo('[SCBSystem]onSessionStateChange, id: ' + this.session.persistentId + ', state: ' + state);
    this.sessionData.sessionState = state;
    switch (this.sessionState) {
      case sceneSessionManager.SessionState.STATE_FOREGROUND:
        log.showDebug(`[SCBSystem] go foreground, name: ${this.name}, focusable:
             ${this.isFocusable}, focused: ${this.sessionDataInner.property.isFocused}`);
        if (this.isFocusable && this.isFocusbaleOnShow) {
          SCBSceneSessionManager.getInstance().requestFocus(this.session.persistentId, true, FocusChangeReason.FOREGROUND);
        }
        break;
      case sceneSessionManager.SessionState.STATE_BACKGROUND:
        log.showDebug(`[SCBSystem]sysSession go background, name: ${this.name}`);
        const backgroundOptions: SystemSessionBackgroundOptions = this.getSessionBackgroundOptions();
        this.notifySessionStateBackground(backgroundOptions);
        if (backgroundOptions.unFocusDelay || backgroundOptions.unFocusDelay === 0) {
          await this.delayNotifySessionStateBackground(backgroundOptions);
        }
        if (backgroundOptions.skipUnFocus === false) {
          SCBSceneSessionManager.getInstance().requestUnfocus(this.session.persistentId, FocusChangeReason.BACKGROUND);
        }
        break;
      default:
        break;
    }
  }

  private onClick(requestFocus: boolean = true, isClick = true): void {
    WinLog.showDebug(WinLogDomain.WMS_HIERARCHY, `onClick, requestFocus: ${requestFocus}, isClick: ${isClick}, ` +
      `mainWindowPersistentId: ${this.mainWindowPersistentId}, isAppUseControl: ${this.isAppUseControl}`);
    if (isClick && this.isAppUseControl) {
      SCBSceneSessionManager.getInstance()
        .requestToTop(this.mainWindowScreenId, this.mainWindowPersistentId, SCBWindowRaiseReason.ON_CLICK);
    }
  }

  /**
   * Set whether property is focused
   *
   * @param { Boolean } isFocused
   */
  public setFocused(isFocused: boolean): void {
    WinLog.showDebug(WinLogDomain.WMS_FOCUS, `setFocused, persistentId: ${this.session.persistentId} is setFocused: ${isFocused}!`);
    if (this.sessionDataInner.property.isFocused === isFocused) {
      WinLog.showDebug(WinLogDomain.WMS_FOCUS, 'session has been focused!');
      return;
    }
    if (isFocused && !this.isFocusable) {
      WinLog.showDebug(WinLogDomain.WMS_FOCUS, 'session is not focusable!');
      return;
    }
    this.sessionDataInner.property.isFocused = isFocused;
  }

  /**
   * Get whether property is focused
   *
   * @returns { Boolean }
   */
  public getFocused(): boolean {
    return this.sessionDataInner.property.isFocused;
  }

  /**
   * Get whether view is focusable
   *
   * @returns
   */
  public getFocusable(): boolean {
    return this.isFocusable;
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
   * get needAnimation
   *
   * @returns
   */
  public get isAlwaysNeedAnimateWhenRotation(): boolean {
    return this.alwaysNeedAnimateWhenRotation;
  }

  /**
   * set Focusable
   *
   * @param isFocusable
   */
  public setFocusable(isFocusable: boolean): void {
    this.isFocusable = isFocusable;
    try {
      this.session.setFocusable(isFocusable);
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_FOCUS, 'setFocusable failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set focusable on show
   *
   * @param isFocusableOnShow
   */
  public setFocusableOnShow(isFocusableOnShow: boolean): void {
    WinLog.showInfo(WinLogDomain.WMS_FOCUS, `setFocusableOnShow: ${isFocusableOnShow}, systemName: ${this.name} id: ${this.id}`);
    this.isFocusbaleOnShow = isFocusableOnShow;
    try {
      this.session.setFocusableOnShow(isFocusableOnShow);
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_FOCUS, 'setFocusableOnShow failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set Blocking Focus
   *
   * @param isBlockingFocus
   */
  public setBlockingFocus(isBlockingFocus: boolean): void {
    this.isBlockingFocus = isBlockingFocus;
    try {
      this.session.setSystemSceneBlockingFocus(isBlockingFocus);
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_FOCUS, 'setBlockingFocus failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set Hit Test Mode
   *
   * @param hitTestMode
   */
  public setHitTestMode(hitTestMode: HitTestMode): void {
    log.showInfo(`[SCBSystem]setHitTestMode ${this.name} id：${this.id} hitTestMode: ${hitTestMode} `);
    this.sessionChangeCallback?.onHitTestModeChange(hitTestMode);
  }

  /**
   * set Visibility
   *
   * @param visibility
   */
  public setVisibility(visibility: boolean): void {
    if (!this.sessionChangeCallback) {
      log.showWarn(`${this.name} sessionChangeCallback is null `);
      this.visibility = visibility;
    }
    this.sessionChangeCallback?.onVisibilityChange(visibility);
    try {
      this.session.updateNativeVisibility(visibility);
    } catch (err) {
      log.showError('updateNativeVisibility failed, reason: ' + JSON.stringify(err));
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  /**
   * sets whether the dragEnable attribute of the window by scb is Activate or deactivate
   *
   * @param activateDrag: Activate or deactivate
   */
  public setActivateDragBySystem(activateDrag: boolean): void {
    if (!this.session) {
      log.showError('session is null');
      return;
    }
    try {
      this.session.activateDragBySystem(activateDrag);
    } catch (err) {
      log.showError('setActivateDragBySystem failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set Privacy Mode
   *
   * @param isPrivacyMode
   */
  public setPrivacyMode(isPrivacyMode: boolean): void {
    log.showInfo(`set ${this.name} setPrivacyMode: ${isPrivacyMode} `);
    if (!this.session) {
      log.showError(`${this.name} session is null `);
      return;
    }
    try {
      this.session.setPrivacyMode(isPrivacyMode);
    } catch (err) {
      log.showError('setPrivacyMode failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set skip input event on cast plus
   *
   * @param isSkip
   */
  public setSkipEventOnCastPlus(isSkip: boolean): void {
    log.showInfo(`set ${this.name} setSkipEventOnCastPlus: ${isSkip}`);
    if (!this.session) {
      log.showError(`${this.name} session is null`);
      return;
    }
    try {
      this.session.setSkipEventOnCastPlus(isSkip);
    } catch (err) {
      log.showError('setSkipEventOnCastPlus failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set skip self when show on virtual screen
   *
   * @param isSkip
   */
  public setSkipSelfWhenShowOnVirtualScreen(isSkip: boolean): void {
    log.showInfo(`set ${this.name} setSkipSelfWhenShowOnVirtualScreen: ${isSkip}`);
    if (!this.session) {
      log.showError(`${this.name} session is null`);
      return;
    }
    try {
      this.session.setSkipSelfWhenShowOnVirtualScreen(isSkip);
    } catch (err) {
      log.showError('setSkipSelfWhenShowOnVirtualScreen failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set skip event and show on virtual screen
   *
   * @param isSkip
   */
  public setSkipEventAndShowOnVirtualScreen(isSkip: boolean): void {
    log.showInfo(`set ${this.name} setSkipEventAndShowOnVirtualScreen: ${isSkip}`);
    try {
      this.session.setSkipEventOnCastPlus(isSkip);
      this.session.setSkipSelfWhenShowOnVirtualScreen(isSkip);
    } catch (err) {
      log.showError('setSkipEventAndShowOnVirtualScreen failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set System Scene Occlusion Alpha
   *
   * @param alpha
   */
  public setSystemSceneOcclusionAlpha(alpha: number): void {
    // alpha = [0, 1.0]
    log.showInfo(`set ${this.name} setSystemSceneOcclusionAlpha: ${alpha} `);
    if (!this.session) {
      log.showError(`${this.name} session is null `);
      return;
    }
    try {
      this.session.setSystemSceneOcclusionAlpha(alpha);
    } catch (err) {
      log.showError('setSystemSceneOcclusionAlpha failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set System Scene force use uiFirst
   *
   * @param forceUIFirst
   */
  public setSystemSceneForceUIFirst(forceUIFirst: boolean): void {
    log.showInfo(`set ${this.name} setSystemSceneForceUIFirst: ${forceUIFirst} `);
    if (!this.session) {
      log.showError(`${this.name} session is null `);
      return;
    }
    try {
      this.session.setSystemSceneForceUIFirst(forceUIFirst);
    } catch (err) {
      log.showError('setSystemSceneForceUIFirst failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set Active
   *
   * @param isActive
   */
  public setActive(isActive: boolean): void {
    if (!this.sessionChangeCallback) {
      log.showWarn(`${this.name} sessionChangeCallback is null `);
      this.isActive = isActive;
    }
    this.sessionChangeCallback?.onActiveChange(isActive);
    if (!this.session) {
      log.showError(`setActive ${this.name} session is null `);
      return;
    }
    try {
      this.session.setSystemActive(isActive);
    } catch (err) {
      log.showError('setSystemActive failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set Rotation
   *
   * @param screenProperty
   */
  public setRotation(screenProperty: SCBScreenProperty): void {
    log.showInfo(`set ${this.name} setRotation: ${screenProperty.rotation}, ` +
      `isRotatable ${this.sessionData.isRotatable}, getRotatable ${this.isRotatable}`);
    if (!this.sessionChangeCallback) {
      log.showError(`${this.name} sessionChangeCallback is null `);
    }
    this.sessionChangeCallback?.onRotationChange(screenProperty);
  }

  set rotation(rotation: number) {
    this._rotation = rotation;
    WinLog.showDebug(WinLogDomain.WMS_ROTATION, `[set rotation] ${this._rotation}`);
    this.session.setCurrentRotation(rotation);
  }

  get rotation(): number {
    return this._rotation;
  }

  /**
   * change Active Mode
   *
   * @param oldScreenProperty
   * @param newScreenProperty
   */
  public changeActiveMode(oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    log.showInfo(`set ${this.name} changeActiveMode. `);
    if (!this.sessionChangeCallback) {
      log.showError(`${this.name} sessionChangeCallback is null `);
    }
    this.sessionChangeCallback?.onActiveModeChange(oldScreenProperty, newScreenProperty);
  }

  /**
   * change Fold Screen
   *
   * @param screenProperty
   * @param reason
   */
  public changeFoldScreen(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    log.showInfo(`set ${this.name} changeFoldScreen, isRotatable ${this.sessionData.isRotatable}, ` +
      `getRotatable ${this.isRotatable}`);
    if (!this.sessionChangeCallback) {
      log.showError(`${this.name} sessionChangeCallback is null `);
    }
    this.sessionChangeCallback?.onFoldChange(screenProperty, reason);
  }

  /**
   * prepare System Scene Rotation Before Animation
   *
   * @param rotation
   */
  public prepareSystemSceneRotationBeforeAnimation(rotation: number): void {
    if (rotation === 0 && this.rotation === RotationConstants.ROTATION_270) {
      // avoid animation 270, 240, 210 ... 30, 0, should play from 90->0
      // change current Rotation
      this.rotation = -RotationConstants.ROTATION_90;
    } else if (rotation === RotationConstants.ROTATION_270 &&
      this.rotation === RotationConstants.ROTATION_0) {
      // avoid animation 0, 30, 60 ... 270, should play from 360->270
      this.rotation = RotationConstants.ROTATION_360;
    }
  }

  /**
   * update Rect vp
   *
   * @param left
   * @param top
   * @param width
   * @param height
   */
  public updateRect(left: number, top: number, width: number, height: number): void {
    let scbRect = new SCBSessionRect(Math.round(vp2px(left)), Math.round(vp2px(top)),
      Math.floor(vp2px(width)), Math.floor(vp2px(height)));
    this.sessionChangeCallback?.onUpdateRect(scbRect);
    this.afterUpdateRectCallback?.(scbRect);
  }

  /**
   * update Rect px
   *
   * @param left
   * @param top
   * @param width
   * @param height
   */
  public updateRectInPx(left: number, top: number, width: number, height: number): void {
    let scbRect = new SCBSessionRect(left, top, width, height);
    this.sessionChangeCallback?.onUpdateRect(scbRect);
    this.afterUpdateRectCallback?.(scbRect);
  }

  /**
   * set Translate
   *
   * @param x
   * @param y
   * @param z
   */
  public setTranslate(x: number, y: number, z: number): void {
    log.showInfo(`setTranslate x: ${x}, y: ${y}, z: ${z}, this.sessionChangeCallback:${this.sessionChangeCallback}`);
    this.sessionChangeCallback?.onTranslateChange(x, y, z);
  }

  /**
   * set Background Color
   *
   * @param backgroundColor
   */
  public setBackgroundColor(backgroundColor: string): void {
    log.showInfo(`setBackgroundColor backgroundColor: ${backgroundColor} this.sessionChangeCallback:${this.sessionChangeCallback}`);
    this.sessionChangeCallback?.onBackgroundColorChange(backgroundColor);
  }

  /**
   * set Backdrop Blur
   *
   * @param backdropBlur
   */
  public setBackdropBlur(backdropBlur: number): void {
    log.showInfo(`BackdropBlur backdropBlur: ${backdropBlur} this.sessionChangeCallback:${this.sessionChangeCallback}`);
    this.sessionChangeCallback?.onBackdropBlurChange(backdropBlur);
  }

  /**
   * set Border Radius
   *
   * @param borderRadius
   */
  public setBorderRadius(borderRadius: number): void {
    log.showInfo(`setBorderRadius borderRadius: ${borderRadius} this.sessionChangeCallback:${this.sessionChangeCallback}`);
    this.sessionChangeCallback?.onBorderRadiusChange(borderRadius);
  }

  /**
   * set Shadow Change
   *
   * @param radius
   * @param color
   * @param offsetX
   * @param offsetY
   */
  public setShadowChange(radius: number, color: string, offsetX: number, offsetY: number): void {
    log.showInfo(`setShadowChange radius: ${radius}, color: ${color}, offsetX: ${offsetX}, offsetY: ${offsetY}, this.sessionChangeCallback:${this.sessionChangeCallback}`);
    this.sessionChangeCallback?.onShadowChange(radius, color, offsetX, offsetY);
  }

  /**
   * set Opacity
   *
   * @param opacity
   */
  public setOpacity(opacity: number): void {
    log.showInfo(`setOpacity opacity: ${opacity} this.sessionChangeCallback:${this.sessionChangeCallback}`);
    this.sessionChangeCallback?.onOpacityChange(opacity);
  }

  /**
   * set Touchable
   *
   * @param touchable
   * @deprecated since 12
   * @useinstead setSessionTouchable
   */
  public setTouchable(touchable: boolean): void {
    this.setSessionTouchable(touchable);
  }

  /**
   * set Response Region
   *
   * @param responseRegion
   */
  public setResponseRegion(responseRegion: Array<Rectangle>): void {
    log.showInfo(TAG, `setResponseRegion  this.sessionChangeCallback:${this.sessionChangeCallback}`);
    this.sessionChangeCallback?.onResponseRegionChange(responseRegion);
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
    if (this.sessionDataInner.sessionInfo.zOrder !== zOrder) {
      this.sessionDataInner.sessionInfo.zOrder = zOrder;
      try {
        this.session.setZOrder(zOrder);
      } catch (err) {
        log.showError('setZOrder failed, reason: ' + JSON.stringify(err));
      }
    }
  }

  /**
   * set Session Touchable
   *
   * @param touchable
   */
  public setSessionTouchable(touchable: boolean): void {
    try {
      log.showInfo(`setSessionTouchable:${touchable} this.sessionChangeCallback:${this.sessionChangeCallback}`);
      if (this.sessionChangeCallback) {
        this.sessionChangeCallback.onTouchableChange(touchable);
      } else {
        this.isTouchable = touchable;
      }
      if (this.session) {
        this.session.setTouchable(touchable);
      }
    } catch (err) {
      log.showError('setSessionTouchable failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * change zIndex in hierarchy
   *
   * @param zIndex
   * @returns: successfully set
   */
  public setZIndex(zIndex: number): void {
    this.sessionChangeCallback?.onZIndexChange(zIndex);
  }

  /**
   * getZIndex
   *
   * @returns
   */
  public getZIndex(): number {
    return this.zIndex;
  }

  /**
   * set SCBKeep Keyboard
   *
   * @param scbKeepKeyboardFlag
   */
  public setSCBKeepKeyboard(scbKeepKeyboardFlag: boolean): void {
    try {
      this.session.setSCBKeepKeyboard(scbKeepKeyboardFlag);
    } catch (err) {
      log.showError('setSCBKeepKeyboard failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * get ZOrder
   *
   * @returns
   */
  public getZOrder() : number {
    let zOrder: number = this.sessionDataInner.sessionInfo.zOrder;
    if (SCBSceneSessionManager.getInstance().isCoreEnable) {
      zOrder = this.getZIndex();
    }
    log.showInfo(`getZorder: ${zOrder}`);
    return zOrder;
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
    if (x === this.sessionDataInner.windowOffsetX && y === this.sessionDataInner.windowOffsetY) {
      return;
    }
    try {
      if (!this.session) {
        log.showError('setWindowOffset null session');
        return;
      }
      this.session.setOffset(x, y);
      this.sessionDataInner.windowOffsetX = x;
      this.sessionDataInner.windowOffsetY = y;
    } catch (err) {
      log.showError('setWindowOffset failed with reason ' + err);
    }
  }

  public setWindowScale(scale: number, updateFlag: boolean = true): void {
    if (CommonUtils.equals(scale, this.sessionDataInner.scale)) {
      return;
    }
    try {
      if (CommonUtils.isInvalid(this.session)) {
        log.showError('setWindowScale failed: null session');
        return;
      }
      if (updateFlag) {
        this.session.setScale(scale, scale, 0, 0);
      }
      this.session.setFloatingScale(scale);
      this.sessionDataInner.scale = scale;
    } catch (err) {
      log.showError('setWindowScale failed with reason ' + err);
    }
  }

  public registerContextTransparentCallback(callback: Function) : void {
    this.session.on('contextTransparent', () => {
      callback();
    });
  }

  public setWaterMarkFlag(isWaterMarkAdded: boolean): void {
    try {
      if (this.session) {
        this.session.setWaterMarkFlag(isWaterMarkAdded);
      }
    } catch (err) {
      log.showError('setWaterMarkFlag failed, reason: ' + JSON.stringify(err));
    }
  }

  public setSkipDraw(skip: boolean): void {
    try {
      if (this.session) {
        this.session.setSkipDraw(skip);
      }
    } catch (err) {
      log.showError('setSkipDraw failed, reason: ' + JSON.stringify(err));
    }
  }

  public isSessionForeground():boolean {
    if (this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_FOREGROUND ||
      this.sessionData.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE) {
      return true;
    }
    return false;
  }

  /**
   * set systemScene isRotatable
   */
  public setRotatable(): void {
    if (!this.sessionData.isLandscapeStartRotatable) {
      this.sessionData.isRotatable = SCBWindowRotateController.getInstance().isDesktopRotatable();
    }
  }

  /**
   * set systemScene colorSpace
   *
   * @param colorSpace
   */
  public setColorSpace(colorSpace: number): void {
    log.showInfo(`set ${this.name} setColorSpace: ${colorSpace} `);
    if (!this.session) {
      log.showError(`${this.name} session is null `);
      return;
    }
    try {
      this.session.setColorSpace(colorSpace);
    } catch (err) {
      log.showError('setColorSpace failed, reason: ' + JSON.stringify(err));
    }
  }

  /**
   * set focusable on show
   *
   * @param isFocusableOnShow
   */
  public setExclusivelyHighlighted(isExclusivelyHighlighted: boolean): void {
    WinLog.showInfo(WinLogDomain.WMS_FOCUS, `setExclusivelyHighlighted: ${isExclusivelyHighlighted}, systemName: ${this.name} id: ${this.id}`);
    try {
      this.session.setExclusivelyHighlighted(isExclusivelyHighlighted).catch((err) => {
        WinLog.showError(WinLogDomain.WMS_FOCUS, 'setExclusivelyHighlighted failed, error:', err);
      });
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_FOCUS, 'set focusable failed, error:', err);
    }
  }

  public getSubSessionRaiseToTopCallback(): Function | null {
    return this.subSessionRaiseToTopCallback;
  }

  public registerSubSessionRaiseToTopCallback(callback: Function): void {
    this.subSessionRaiseToTopCallback = callback;
  }

  public getSubSessionRaiseAboveTargetCallback(): Function | null {
    return this.subSessionRaiseAboveTargetCallback;
  }

  public registerSubSessionRaiseAboveTargetCallback(callback: Function): void {
    this.subSessionRaiseAboveTargetCallback = callback;
  }

  public registerSubSessionStateChangeCallback(callback: Function): void {
    this.subSessionStateChangeCallback = callback;
  }

  public getSubSessionStateChangeCallback(): Function | null {
    return this.subSessionStateChangeCallback;
  }

  public registerSubSessionZLevelChangeCallback(callback: Function): void {
    this.subSessionZLevelChangeCallback = callback;
  }

  public getSubSessionZLevelChangeCallback(): Function | null {
    return this.subSessionZLevelChangeCallback;
  }
}

