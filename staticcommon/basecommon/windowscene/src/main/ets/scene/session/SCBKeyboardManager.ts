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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, ObjUtil } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBSceneMode } from './SCBSceneInfo';
import { SCBSceneSession } from './SCBSceneSession';
import { SCBSessionRect } from './SCBSessionRect';
import { SCBSpecificSession } from './SCBSpecificSession';
import { SCBKeyboardSession } from './SCBKeyboardSession';
import { SCBKeyboardPanelSession } from './SCBKeyboardPanelSession';
import { SCBSceneContainerSession, SCBSceneContainerSessionArray } from './SCBSceneContainerSession';
import { SCBSystemSceneSession, SystemSessionChangeCallback } from './SCBSystemSceneSession';
import type { SCBScreenProperty, SCBScreenSession } from '../../screen/session/SCBScreenSession';
import { SCBScreenSessionManager, SCBPropertyChangeReason } from '../../screen/session/SCBScreenSessionManager';
import {
  ACTIVE_STATUS_MAP,
  SpecificPanelZOrder,
  SCBInputMethodList,
  SCBSceneSessionManager,
  ScenePanelState,
  ClassType
} from './SCBSceneSessionManager';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { SCBKeyboardPanelManager } from './SCBKeyboardPanelManager';
import { SCBScenePanelManager } from '../manager/SCBScenePanelManager';
import { SCBKeyboardDebugCommands } from '../dump/SCBKeyboardDebugCommands';
import { SplitLifeCycle } from './SCBSplitParam';
import { MidSceneLifeCycle } from './SCBMidSceneParam';

const TAG = 'SCBKeyboardManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const INVALID_PERSISTENT_ID: number = 0;

export enum KeyboardState {
  UNDEFINED,
  SHOW_IN_BELOW_SCENE_PANEL,
  SHOW_IN_BELOW_SPECIFIC_SCENE,
  SHOW_IN_ABOVE_SCENE_PANEL,
  SHOW_IN_ABOVE_SPECIFIC_SCENE,
  SHOW_IN_ABOVE_SPLIT_SCENE,
  SHOW_IN_ABOVE_FLOAT_CONTAINER_SCENE
};

export const KEYBOARD_STATE_MAP: Map<string, KeyboardState> = new Map([
  ['BelowScenePanel', KeyboardState.SHOW_IN_BELOW_SCENE_PANEL],
  ['BelowSpecificScene', KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE],
  ['AboveScenePanel', KeyboardState.SHOW_IN_ABOVE_SCENE_PANEL],
  ['AboveSpecificScene', KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE],
  ['AboveSplitScene', KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE],
  ['AboveFloatContainerScene', KeyboardState.SHOW_IN_ABOVE_FLOAT_CONTAINER_SCENE]
]);

export interface KeyboardChangeCallback {
  /**
   * keyboardRect change
   *
   * @param rect sceneSessionManager.SessionRect
   * @param reason sceneSessionManager.SessionSizeChangeReason
   */
  onRectChangeChange: ((rect: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason) => void);

  /**
   * keyboard touchable change
   *
   * @param isTouchable isTouchable
   */
  onSessionTouchableChange: ((isTouchable: boolean) => void);

  /**
   * keyboard gravity change
   *
   * @param sessionGravity new session gravity
   */
  onKeyboardGravityChange: ((sessionGravity: sceneSessionManager.KeyboardGravity) => void);

  /**
   * keyboard on CustomAnimationPlaying
   *
   * @param isPlaying isCustomAnimationPlaying
   */
  onCustomAnimationPlaying: ((isPlaying: boolean) => void);

  /**
   * keyboard ForceHide
   *
   * @param hide hide keyboard
   */
  onForceHide: ((hide: boolean) => void);

  /**
   * get keyboard ZIndex
   *
   */
  getZIndex: (() => number);

  /**
   * virtrual screen state change
   *
   * @param screenId
   * @param persistentId
   * @param state
   */
  onVirtualScreenStateChange: (
  (screenId: number, persistentId: number, state: sceneSessionManager.SessionState) => void);

  /**
   * calling session change
   *
   * @param callingSessionId
   */
  onCallingSessionChange: ((callingSessionId: number) => void);
};

export interface KeyboardAnimationSyncCallback {
  (keyboardSession : SCBKeyboardSession) : void;
}

/**
 * Keyboard manager
 */
export class SCBKeyboardManager {
  /**
   * Switch of enable keyboard panel.
   */
  private raisedPosYOffset: number = 0;
  public keyboardSessionList: SCBInputMethodList = new SCBInputMethodList();
  public keyboardTranslateChangeCallback: Function;
  public requestKeyboardAnimate : boolean = true;

  private keyboardState: KeyboardState = KeyboardState.UNDEFINED;
  private isAboveFloatContainer: boolean = false;

  private unInterruptableAnimationCallbackCnt: number = 0;
  private keyboardSession: SCBKeyboardSession;
  private keyboardPanelSession: SCBKeyboardPanelSession;
  private systemKeyboardPanelSession: SCBKeyboardPanelSession;
  private createKeyboardCallbacksForPC: Array<Function> = new Array();
  private keyboardSessionStateChangeCallbacksForPC: Array<Function> = new Array();
  private screenPropertyChangeCallbacksForPC: Array<Function> = new Array();
  private keyboardActiveChangeCallback: Function;
  private keyboardSessionCacheList: Array<SCBKeyboardSession> = new Array;
  private keyboardShowCallbacks: Array<Function> = new Array();
  private keyboardRectChangeCallbacks: Array<Function> = new Array();
  private sysSessionChangeCallback?: SystemSessionChangeCallback;
  private hideAnimationInterruptionCallback: Function | null = null;

  /**
   * @description: callback of keyboard change
   */
  private keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();

  /**
   * @description: callback of keyboard rect change.
   */
  private keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();

  /**
   * @description: callback of keyboard animation synchronization
   */
  private animationSyncCallbacks: Map<string, KeyboardAnimationSyncCallback> =
    new Map<string, KeyboardAnimationSyncCallback>();

  /**
   * @description: debug commands for keyboard
   */
  private keyboardDebugCommands = new SCBKeyboardDebugCommands(this.keyboardSessionList);

  /**
   * @description: Get the singleton of the keyboard manager.
   */
  static getInstance(): SCBKeyboardManager {
    if (!globalThis.SCBKeyboardManagerInstance) {
      globalThis.SCBKeyboardManagerInstance = new SCBKeyboardManager();
    }
    return globalThis.SCBKeyboardManagerInstance;
  }

  private constructor() {
    this.keyboardDebugCommands.register();
    log.showInfo('construct SCBKeyboardManager');
  }

  /**
   * @description: Get the keyboard session by keyboard session Id.
   * @param keyboardSessionId : the persistentId of keyboard session
   * @return: SCBKeyboardSession
   */
  public getKeyboardSessionById(keyboardSessionId: number): SCBKeyboardSession | undefined {
    if (this.keyboardSession?.session?.persistentId === keyboardSessionId) {
      return this.keyboardSession;
    }
    let keyboardSession = this.keyboardSessionList.find((item) => {
      return item?.session?.persistentId === keyboardSessionId;
    });
    if (!this.isValidSession(keyboardSession)) {
      log.showInfo(`getKeyboardSessionById not found keyboard session, id: ${keyboardSessionId}`);
      return undefined;
    }
    return keyboardSession;
  }

  /**
   * @description: Get the keyboard panel session by keyboard session Id.
   * @param keyboardSessionId : the persistentId of keyboard session
   * @return: SCBSystemSceneSession
   */
  public getPanelSessionById(keyboardSessionId: number): SCBKeyboardPanelSession | undefined {
    let keyboardSession = this.getKeyboardSessionById(keyboardSessionId);
    if (!this.isValidSession(keyboardSession)) {
      log.showInfo(`getPanelSessionById not found keyboard session, id: ${keyboardSessionId}`);
      return undefined;
    }
    if (keyboardSession.session?.isSystemKeyboard) {
      return this.systemKeyboardPanelSession;
    }
    return this.keyboardPanelSession;
  }

  /**
   * @description: Get keyboard session
   *
   * @returns {SCBKeyboardSession}
   */
  public getKeyboardSession(): SCBKeyboardSession {
    return this.keyboardSession;
  }

  /**
   * @description: Get the keyboard panel session.
   * @return: SCBSystemSceneSession
   */
  public getPanelSession(): SCBKeyboardPanelSession {
    return this.keyboardPanelSession;
  }

  /**
   * @description: Get system keyboard session
   *
   * @returns SCBKeyboardSession
   */
  public getSystemKeyboardSession(): SCBKeyboardSession | undefined {
    let systemKeyboardSession = this.keyboardSessionList.find((item) => {
      return item?.session?.isSystemKeyboard;
    });
    if (!this.isValidSession(systemKeyboardSession)) {
      log.showInfo(`not found system keyboard session`);
      return undefined;
    }
    return systemKeyboardSession;
  }

  /**
   * @description: Get the system keyboard panel session.
   * @return: SCBSystemSceneSession
   */
  public getSystemPanelSession(): SCBKeyboardPanelSession {
    return this.systemKeyboardPanelSession;
  }

  /**
   * @description: Get the z_order state of keyboard.
   * @return: keyboardState of keyboard
   */
  public getKeyboardState(): KeyboardState {
    return this.keyboardState;
  }

  private updateKeyboardPanelRectAfterScreenConnected(scbScreenProperty: SCBScreenProperty,
                                                      expandStatus?: boolean): void {
    if (scbScreenProperty === undefined || scbScreenProperty === null ||
      scbScreenProperty.width === 0 || scbScreenProperty.height === 0) {
      log.showWarn('onMainScreenConnected, scbScreenProperty is empty');
      return;
    }
    if (!(this.keyboardSession instanceof SCBKeyboardSession &&
      this.keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
      log.showWarn('onMainScreenConnected, keyboard or panel is not created');
      return;
    }
    // recalculate panelRect incase of empty size
    if ((this.keyboardSession.currRect instanceof SCBSessionRect) &&
      !(this.keyboardSession.currRect.isEmpty()) &&
      (this.keyboardPanelSession.currRect?.isEmpty())) {
      log.showWarn('onMainScreenConnected, scbScreenProperty is null when update keyboardRect, reculate panel rect');
      SCBKeyboardPanelManager.getInstance().updateKeyboardAndPanelRect(this.keyboardSession.session?.persistentId,
        this.keyboardSession.currRect, this.keyboardPanelSession.currRect,
        this.keyboardSession.rectForFingerprint);
    }
  }

  /*
   * @description: keyboard may be created before construct screenSession, screenProperty is null when update keyboard
   * rect by imf. Notify keyboard when screen connected, reculate panelRect by screenProperty
   */
  public onMainScreenConnected(scbScreenProperty: SCBScreenProperty, expandStatus?: boolean): void {
    this.updateKeyboardPanelRectAfterScreenConnected(scbScreenProperty, expandStatus);
    SCBKeyboardPanelManager.getInstance().onMainScreenConnected(scbScreenProperty);
    // register screen change callback
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty,
                                                                                 reason: SCBPropertyChangeReason) => {
      this.updateKeyboardPanelRectOnRotationChange(screenProperty, reason);
      this.updateKeyboardPanelRectAfterScreenConnected(screenProperty);
      this.updateKeyboardTranslateChange(screenProperty, reason);
      log.showInfo('OnScreenPropertyChange, reason: ' + reason);
    });
  }

  registerKeyboardTranslateChangeCallback(callback: Function): void {
    this.keyboardTranslateChangeCallback = callback;
  }

  unRegisterKeyboardTranslateChangeCallback(): void {
    this.keyboardTranslateChangeCallback = null;
  }

  private updateKeyboardTranslateChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    this.keyboardTranslateChangeCallback && this.keyboardTranslateChangeCallback(screenProperty, reason);
  }

  /**
   * register KeyboardChange Callback for keyboardPanel
   *
   * @param callback
   */
  public registerKeyboardChangeCallback(keyboardName: string, callback: KeyboardChangeCallback): void {
    this.keyboardChangeCallbackMap.set(keyboardName, callback);
    log.showInfo('registerKeyboardChangeCallback, size:' + this.keyboardChangeCallbackMap.size +
      ', name' + keyboardName);
  }

  /**
   * Registers the keyboard hide animation interruption callback.
   *
   * @param callback
   */
  public registerHideAnimationInterruptionCallback(callback: Function): void {
      this.hideAnimationInterruptionCallback = callback;
  }

  /**
   * Unregisters the keyboard hide animation interruption callback.
   */
  public unregisterHideAnimationInterruptionCallback(): void {
    this.hideAnimationInterruptionCallback = null;
  }

  /**
   * Handles keyboard hide animation interruption events.
   *
   */
  private hideAnimationInterruption(): void {
    this.hideAnimationInterruptionCallback && this.hideAnimationInterruptionCallback();
  }

  /**
   * unregister KeyboardChange Callback for keyboardPanel
   */
  public unRegisterRectChangeCallbackOfKeyboardPanel(keyboardName: string): void {
    this.keyboardChangeCallbackMap.delete(keyboardName);
    log.showInfo('unRegisterRectChangeCallbackOfKeyboardPanel, size:' + this.keyboardChangeCallbackMap.size +
      ', name:' + keyboardName);
  }

  /**
   * use focus session if calling session invalid.
   *
   * @returns
   */
  public useFocusSessionIfCallingSessionInvalid(state: sceneSessionManager.SessionState): SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null {
    let callingSession = this.keyboardSession?.getCallingSession();
    if (callingSession === null || callingSession === undefined) {
      let focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession();
      let callingSessionId = INVALID_PERSISTENT_ID;
      if (focusedSession !== null && focusedSession !== undefined) {
        callingSessionId = SCBSceneSessionManager.getInstance().getFocusedSessionId();
        this.keyboardSession?.setCallingSession(focusedSession);
        callingSession = focusedSession;
        log.showInfo('use focusedSession instead id: ' + callingSessionId);
      }
      this.keyboardSession?.setCallingSessionId(callingSessionId);
    }

    return callingSession;
  }

  private closeAnimationWhenUnlockToLock(callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession,
    state: sceneSessionManager.SessionState): boolean {
    if (callingSession?.session?.type !== sceneSessionManager.SessionType.TYPE_KEYGUARD &&
      state === sceneSessionManager.SessionState.STATE_BACKGROUND &&
      SCBSceneSessionManager.getInstance().isScreenLocked()) {
      log.showInfo('Turn off animation when switching from non-lock screen to lock screen');
      return true;
    }
    return false;
  }

  /**
   * @description: Register keyboard active change callback
   * @param callback
   */
  public registerKeyboardActiveChangeCallback(callback: Function): void {
    this.keyboardActiveChangeCallback = callback;
  }

  /**
   * @description: Register callback for keyboard showing callback
   */
  public registerKeyboardShowCallback(callback: Function): void {
    log.showDebug('registerKeyboardShowCallback');
    this.keyboardShowCallbacks.push(callback);
  }

  /**
   * @description: Unregister callback for keyboard showing callback
   */
  public unRegisterKeyboardShowCallback(callback: Function): void {
    let index = this.keyboardShowCallbacks.indexOf(callback);
    if (index !== -1) {
      this.keyboardShowCallbacks.splice(index, 1);
    }
  }

  /**
   * @description: Register callback for animation synchronization
   */
  public registerAnimationSyncCallback(callerName: string, callback: KeyboardAnimationSyncCallback): void {
    log.showDebug('registerKeyboardShowCallback, callerName: ' + callerName);
    this.animationSyncCallbacks.set(callerName, callback);
  }

  /**
   * @description: Unregister callback for animation synchronization
   */
  public unRegisterAnimationSyncCallback(callerName: string): void {
    if (!this.animationSyncCallbacks.delete(callerName)) {
      log.showInfo('registerKeyboardShowCallback failed, callerName: ' + callerName);
    }
  }

  public NotifyAnimationSyncCallbacks() : void {
    this.animationSyncCallbacks.forEach((callback, callerName) => {
      if (callback) {
        callback(this.keyboardSession);
        log.showWarn('NotifyAnimationSyncCallbacks, callName: ' + callerName);
      } else {
        log.showWarn('NotifyAnimationSyncCallbacks, callback is null, callName: ' + callerName);
      }
    });
  }

  /**
   * @description: Register callback for keyboard rect change callback
   */
  public registerkeyboardRectChangeCallbacks(callback: Function): void {
    log.showInfo('registerKeyboardShowCallback');
    let index = this.keyboardRectChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      return;
    }
    this.keyboardRectChangeCallbacks.push(callback);
  }

  /**
   * @description: Unregister callback for keyboard rect change callback
   */
  public unRegisterkeyboardRectChangeCallbacks(callback: Function): void {
    let index = this.keyboardRectChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.keyboardRectChangeCallbacks.splice(index, 1);
    }
  }

  /**
   * @description: notify keyboard rect Change
   */
  public notifyKeyboardRectChange(keyboardSessionId: number): void {
    let keyboardSession = this.getKeyboardSessionById(keyboardSessionId);
    if (keyboardSession?.keyboardHeightChangeCallback) {
      let panelSession = this.getPanelSessionById(keyboardSessionId);
      const panelHeight : number = panelSession?.getPanelRealHeight();
      log.showInfo('Notify keyboardHeight' + panelHeight + ', keyboard session id: ' + keyboardSessionId);
      keyboardSession?.keyboardHeightChangeCallback(panelHeight);
    }

    this.keyboardRectChangeCallbacks.forEach((callback) => {
      if (callback) {
        callback();
      }
    });
  }

  /**
   * @description: Register callback for keyboard rect change callback
   */
  public registerkeyboardGravityChangeCallbacks(keyboardChangeCallback: KeyboardChangeCallback): void {
    log.showInfo('registerkeyboardGravityChangeCallbacks');
    let index = this.keyboardChangeListenerList.indexOf(keyboardChangeCallback);
    if (index !== -1) {
      return;
    }
    this.keyboardChangeListenerList.push(keyboardChangeCallback);
  }

  /**
   * @description: Unregister callback for keyboard rect change callback
   */
  public unRegisterkeyboardGravityChangeCallbacks(keyboardChangeCallback: KeyboardChangeCallback): void {
    let index = this.keyboardChangeListenerList.indexOf(keyboardChangeCallback);
    if (index !== -1) {
      this.keyboardChangeListenerList.splice(index, 1);
    }
  }

  /**
   * @description:
   */
  public notifyKeyboardGravityChange(sessionGravity): void {
    this.keyboardChangeListenerList.forEach((keyboardChangeCallback) => {
      if (keyboardChangeCallback && keyboardChangeCallback.onKeyboardGravityChange) {
        keyboardChangeCallback.onKeyboardGravityChange(sessionGravity);
      }
    });
  }

  /**
   * @description: Request hide keyboard
   */
  public requestHideKeyboard(sceneSession: SCBSceneSession | SCBSystemSceneSession): void {
    if (this.keyboardSession?.isKeyboardShowing() && this.isValidSession(sceneSession)) {
      log.showInfo('requestHideKeyboard');
      try {
        sceneSession.session.requestHideKeyboard();
        this.requestKeyboardAnimate = true;
      } catch {
        log.showError('requestHideKeyboard error');
      }
    }
  }

  /**
   * @description: Set keyboard offset for fingerprint
   */
  public setKeyboardPosYOffset(posYOffset: number, isChangeKeyboardRect: boolean = false): void {
    log.showInfo(`setKeyboardPosYOffset param height: ${posYOffset}`);
    if (!this.isValidSession(this.keyboardSession) || ObjUtil.isInvalid(this.keyboardPanelSession)) {
      log.showError('setKeyboardPosYOffset no keyboardSession or keyboardPanelSession');
      return;
    }
    this.raisedPosYOffset = posYOffset;
    this.updateRectForFingerPrint(posYOffset, this.keyboardPanelSession?.currRect,
      this.keyboardSession?.rectForFingerprint);
    if (this.keyboardSession.isKeyboardShowing() && isChangeKeyboardRect) {
      log.showInfo(`forFingerprint scene recalculate keyboardrect, isChangeKeyboardRect: ${isChangeKeyboardRect}`);
      SCBKeyboardPanelManager.getInstance().calculateKeyboardAndPanelRect(this.keyboardSession.session?.persistentId,
        this.keyboardSession.currRect, this.keyboardPanelSession.currRect, this.keyboardSession.rectForFingerprint);
    }
  }

  public getKeyboardPosYOffset(): number {
    return this.raisedPosYOffset;
  }

  /**
   * @description: Register create keyboard callback for pc
   */
  public registerCreateKeyboardCallbackForPC(callback: Function): void {
    log.showDebug('register CreateKeyboardCallback');
    if (!callback) {
      log.showInfo(`Create keyboard callback for pc is invalid.`);
      return;
    }
    this.createKeyboardCallbacksForPC.push(callback);
    this.keyboardSessionCacheList.forEach((keyboardSession: SCBKeyboardSession) => {
      if (!this.isValidSession(keyboardSession) || !this.isValidSession(keyboardSession.session)) {
        log.showError(`this is a invalid keyboard session.`);
        return;
      }
      const state = keyboardSession.sessionData?.sessionState;
      log.showInfo(`callback keyboardSceneSessionCache`);
      callback(keyboardSession);
      if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
        this.onKeyboardStateChangeForPC(keyboardSession.session.parentId, keyboardSession.session.persistentId, state);
      }
    });
    this.keyboardSessionCacheList.splice(0, this.keyboardSessionCacheList.length);
  }

  /**
   * @description: Unregister create keyboard callback for pc
   */
  public unRegisterCreateKeyboardCallbackForPC(callback: Function): void {
    log.showDebug('unregister CreateKeyboardCallback');
    let index = this.createKeyboardCallbacksForPC.indexOf(callback);
    if (index !== -1) {
      this.createKeyboardCallbacksForPC.splice(index, 1);
    }
  }

  /**
   * @description: Register keyboard session state change callback for pc
   */
  public registerKeyboardSessionStateChangeCallbackForPC(callback: Function): void {
    log.showDebug('register KeyboardSessionStateChangeCallback');
    this.keyboardSessionStateChangeCallbacksForPC.push(callback);
  }

  /**
   * @description: Unregister keyboard session state change callback for pc
   */
  public unRegisterKeyboardSessionStateChangeCallbackForPC(callback: Function): void {
    log.showDebug('unregister KeyboardSessionStateChangeCallback');
    let index = this.keyboardSessionStateChangeCallbacksForPC.indexOf(callback);
    if (index !== -1) {
      this.keyboardSessionStateChangeCallbacksForPC.splice(index, 1);
    }
  }

  /**
   * @description: Register screen property change callback for PC
   */
  public registerScreenPropertyChangeCallbackForPC(callback: Function): void {
    log.showDebug('register screen property change callback for PC');
    let index = this.screenPropertyChangeCallbacksForPC.indexOf(callback);
    if (index === -1) {
      this.screenPropertyChangeCallbacksForPC.push(callback);
    }
  }

  /**
   * @description: Unregister screen property change callback for pc
   */
  public unRegisterScreenPropertyChangeCallbackForPC(callback: Function): void {
    log.showDebug('unregister screen property change callback for PC');
    let index = this.screenPropertyChangeCallbacksForPC.indexOf(callback);
    if (index !== -1) {
      this.screenPropertyChangeCallbacksForPC.splice(index, 1);
    }
  }

  /**
   * @description: Get keyboard list callback
   */
  public getKeyboardList(): SCBInputMethodList {
    return this.keyboardSessionList;
  }

  /**
   * @description: Whether the callingSession is voice assistant and is in recent.
   */
  private isVoiceInteractionWindowInRecent(): boolean {
    if (!this.keyboardSession?.isKeyboardShowing()) {
      return false;
    }
    let callingSession = this.keyboardSession?.getCallingSession();
    if (callingSession instanceof SCBSpecificSession &&
        callingSession.session?.type === sceneSessionManager.SessionType.TYPE_VOICE_INTERACTION &&
        AppStorage.get<number>('scenePanelState') === ScenePanelState.RECENT) {
      return true;
    }

    if (callingSession instanceof SCBSystemSceneSession && (callingSession.name.includes('SCBSysDialogUpper') ||
        callingSession.name.includes('SCBSysDialogDefault')) &&
        AppStorage.get<number>('scenePanelState') === ScenePanelState.RECENT) {
      log.showInfo('SCBSysDialogUpper or SCBSysDialogDefault window in recent is touchable');
      return true;
    }
    return false;
  }

  /**
   * @description: Set keyboard session touchable
   *
   * @param touchable
   */
  public setKeyboardSessionTouchable(touchable: boolean): void {
    if (!touchable && this.isVoiceInteractionWindowInRecent()) {
      log.showInfo('VOICE_INTERACTION window in recent is touchable');
      return;
    }

    try {
      if (this.isValidSession(this.keyboardSession) && this.keyboardSession?.session) {
        this.keyboardSession?.session.setTouchable(touchable);
      }
    } catch (err) {
      log.showError('setKeyboardSessionTouchable failed, with reason ' + JSON.stringify(err));
    }

    try {
      if (this.isValidSession(this.keyboardPanelSession) && this.keyboardPanelSession?.session) {
        this.keyboardPanelSession?.session.setTouchable(touchable);
      }
    } catch (err) {
      log.showError('setKeyboardPanelSessionTouchable failed, message: ' + err?.message);
    }
  }

  public getKeyboardChangeCallbackMap(): Map<string, KeyboardChangeCallback> {
    return this.keyboardChangeCallbackMap;
  }

  private createSystemKeyboardAndSystemPanelSession(systemKeyboardSession: sceneSessionManager.SceneSession,
    systemKeyboardPanelSession: sceneSessionManager.SceneSession): void {
    log.showInfo('create system keyboard session');
    let sysKeyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
    let sysKeyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
    let scbSystemKeyboardSession = new SCBKeyboardSession(systemKeyboardSession,
      this.onKeyboardStateChangeForPC.bind(this), sysKeyboardChangeCallbackMap, sysKeyboardChangeListenerList);
    this.createKeyboardCallbacksForPC.forEach((callback) => {
      if (callback) {
        callback(scbSystemKeyboardSession);
      }
    });
    if (this.createKeyboardCallbacksForPC.length === 0) {
      this.keyboardSessionCacheList.push(scbSystemKeyboardSession);
    }

    if (!this.isValidSession(this.systemKeyboardPanelSession)) {
      this.systemKeyboardPanelSession =
        SCBSceneSessionManager.getInstance().requestKeyboardPanelSession(systemKeyboardPanelSession,
          SCBKeyboardPanelManager.getInstance().getPanelSessionInfo(), this.sysSessionChangeCallback);
      log.showInfo(`create system panel session, id: ${systemKeyboardPanelSession.persistentId}`);
    } else if (this.systemKeyboardPanelSession.session?.persistentId !== systemKeyboardPanelSession.persistentId) {
      log.showInfo('re-create system keyboardPanel session, curId: ' +
        this.systemKeyboardPanelSession.session?.persistentId + ', newId: ' + systemKeyboardPanelSession.persistentId);
      this.systemKeyboardPanelSession =
        SCBSceneSessionManager.getInstance().requestKeyboardPanelSession(systemKeyboardPanelSession,
          SCBKeyboardPanelManager.getInstance().getPanelSessionInfo(), this.sysSessionChangeCallback);
    } else {
      log.showInfo(`system keyboardPanel is existed, id: ${this.systemKeyboardPanelSession?.session.persistentId}`);
    }
    // The system keyboard is not displayed on the virtual screen.
    log.showDebug(`Set skip system keyboard on virtual screen`);
    SCBKeyboardPanelManager.getInstance().setSkipSelfWhenShowOnVirtualScreen(scbSystemKeyboardSession,
      this.systemKeyboardPanelSession);
  }

  /**
   * @description: Handle create keyboard session
   * @param: specificSession
   */
  public onCreateKeyboardAndPanelSession(keyboardSession: sceneSessionManager.SceneSession,
    keyboardPanelSession: sceneSessionManager.SceneSession): void {
    if (!this.isValidSession(keyboardSession) || !this.isValidSession(keyboardPanelSession)) {
      log.showError('keyboardSession or keyboardPanelSession is null, create failed');
      return;
    }
    log.showInfo('create keyboard session');
    // callback of create keyboard UI for pc
    if (SCBSceneSessionManager.getInstance().isPc()) {
      if (keyboardSession.isSystemKeyboard) {
        this.createSystemKeyboardAndSystemPanelSession(keyboardSession, keyboardPanelSession);
        return;
      }
      let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
      let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
      this.keyboardSession = new SCBKeyboardSession(keyboardSession, this.onKeyboardStateChangeForPC.bind(this),
        keyboardChangeCallbackMap, keyboardChangeListenerList);
      this.createKeyboardCallbacksForPC.forEach((callback) => {
        if (callback) {
          callback(this.keyboardSession);
        }
      });
      if (this.createKeyboardCallbacksForPC.length === 0) {
        this.keyboardSessionCacheList.push(this.keyboardSession);
      }
    } else {
      if (!this.isValidSession(this.keyboardSession)) {
        this.keyboardSession = new SCBKeyboardSession(keyboardSession, this.onKeyboardStateChange.bind(this),
          this.keyboardChangeCallbackMap, this.keyboardChangeListenerList);
        log.showInfo(`create keyboard session, id: ${keyboardSession.persistentId}`);
      } else if (this.keyboardSession.session?.persistentId !== keyboardSession.persistentId) {
        log.showInfo('disconnect and re-create keyboard session, curId: ' + this.keyboardSession.session?.persistentId +
          ', newId: ' + keyboardSession.persistentId);
        this.onKeyboardStateChange(INVALID_PERSISTENT_ID, this.keyboardSession?.session.persistentId,
          sceneSessionManager.SessionState.STATE_DISCONNECT);

        this.keyboardSession = new SCBKeyboardSession(keyboardSession, this.onKeyboardStateChange.bind(this),
          this.keyboardChangeCallbackMap, this.keyboardChangeListenerList);
      } else {
        log.showInfo(`keyboard is existed, id: ${this.keyboardSession?.session.persistentId}`);
      }
    }

    if (!this.isValidSession(this.keyboardPanelSession)) {
      this.keyboardPanelSession = SCBSceneSessionManager.getInstance().
        requestKeyboardPanelSession(keyboardPanelSession, SCBKeyboardPanelManager.getInstance().getPanelSessionInfo(),
          this.sysSessionChangeCallback);
      log.showInfo(`create panel session, id: ${keyboardPanelSession.persistentId}`);
    } else if (this.keyboardPanelSession.session?.persistentId !== keyboardPanelSession.persistentId) {
      log.showInfo('re-create keyboardPanel session, curId: ' + this.keyboardPanelSession.session?.persistentId +
        ', newId: ' + keyboardPanelSession.persistentId);
      this.keyboardPanelSession = SCBSceneSessionManager.getInstance().
        requestKeyboardPanelSession(keyboardPanelSession, SCBKeyboardPanelManager.getInstance().getPanelSessionInfo(),
          this.sysSessionChangeCallback);
    } else {
      log.showInfo(`keyboardPanel is existed, id: ${this.keyboardPanelSession?.session.persistentId}`);
    }
    this.keyboardPanelSession?.registerListener();
    SCBKeyboardPanelManager.getInstance().setSkipEventOnCastPlus(this.keyboardSession,
      this.keyboardPanelSession);
    SCBKeyboardPanelManager.getInstance().setSkipSelfWhenShowOnVirtualScreen(this.keyboardSession,
      this.keyboardPanelSession);
  }

  public getSceneContainerSessionForKeyboard(persistentId: number): SCBSceneContainerSession | null {
    let containerList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    let specialContainerSessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager.getInstance().
      getSpecialContainerSessionList();
    let sessionLists: Array<SCBSceneContainerSessionArray> = [specialContainerSessionList, containerList];
    for (let curList of sessionLists) {
      let index = curList.findIndex((item) => {
        return item.haveSessionWithPersistentId(persistentId);
      });
      if (index !== -1) {
        return curList[index];
      }
    }
    return null;
  }

  private updateSystemKeyboardCallingSessionIdChange(newCallingId: number): void {
    if (!SCBSceneSessionManager.getInstance().isPc()) {
      return;
    }
    let callingSession = SCBSceneSessionManager.getInstance().getSessionById(newCallingId);
    if (newCallingId < 0 || !this.isValidSession(callingSession)) {
      // if the newCallingId or the calling session is invalid, use the focused session as calling session default
      newCallingId = SCBSceneSessionManager.getInstance().getFocusedSessionId();
      callingSession = SCBSceneSessionManager.getInstance().getSessionById(newCallingId);
      if (newCallingId < 0 || !this.isValidSession(callingSession)) {
        log.showInfo(`both the calling session and focused session are invalid`);
        return;
      }
    }
    let systemKeyboardSession = this.getSystemKeyboardSession();
    let oriCallingId: number = systemKeyboardSession?.getCallingSessionId();
    log.showInfo('system keyboard, oriCallingId: ' + oriCallingId + ', newCallingId: ' + newCallingId);
    if (oriCallingId === newCallingId) {
      return;
    }
    systemKeyboardSession?.setCallingSessionId(newCallingId);
    systemKeyboardSession?.setCallingSession(callingSession);
  }

  /**
   * calling window id change callback executed by C++
   * @param newCallingWindowId: calling window id
   */
  public onCallingSessionIdChange(newCallingId: number): void {
    this.updateSystemKeyboardCallingSessionIdChange(newCallingId);
    let oriCallingId: number = this.keyboardSession?.getCallingSessionId();
    this.keyboardSession?.setCallingSessionId(newCallingId);

    log.showInfo('oriCallingId: ' + oriCallingId + ', newCallingId: ' + newCallingId);
    if (oriCallingId === newCallingId) {
      return;
    }
    this.keyboardSession?.setCallingSession(SCBSceneSessionManager.getInstance().getSessionById(newCallingId));
    if (!this.keyboardSession?.isKeyboardShowing()) {
      log.showInfo('keyboard is not foreground, not need modify keyboard layer.');
      return;
    }
    this.keyboardSession?.handleKeyboardRectChange(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);

    if (SCBSceneSessionManager.getInstance().isPc()) {
      this.keyboardSession?.closeKeyboardSyncTransaction(this.keyboardSession.isActive, false, false);
      return;
    }

    // When the keyboard layer is modified, isKeyboardEnableShow of the original window need set to false.
    this.keyboardSession?.updateKeyboardEnableShow(false);
    
    // When the keyboard layer is modified, the animation needs to be disabled.
    this.closeKeyboardAnimation(true);
    this.onKeyboardStateChange(INVALID_PERSISTENT_ID, this.keyboardSession?.session.persistentId,
      this.keyboardSession?.sessionState);
  }

  /**
   * @description: Disable keyboard Animation
   * @param {boolean} isCloseKeyboardAnimation
   */
  public closeKeyboardAnimation(isCloseKeyboardAnimation): void {
    if (this.isValidSession(this.keyboardSession) &&
      this.keyboardSession.sessionData.isCloseKeyboardAnimation !== isCloseKeyboardAnimation) {
      log.showInfo('isCloseKeyboardAnimation: ' + isCloseKeyboardAnimation);
      this.keyboardSession.sessionData.isCloseKeyboardAnimation = isCloseKeyboardAnimation;
    }
  }

  public updateRectForFingerPrint(offset: number, panelRect: SCBSessionRect,
    rectForFingerprint: SCBSessionRect): void {
    if (!(panelRect instanceof SCBSessionRect && rectForFingerprint instanceof SCBSessionRect)) {
      log.showWarn('updateRectForFingerPrint, rect is null');
      return;
    }
    rectForFingerprint?.copyFrom(panelRect);
    let newPosY = panelRect?.top.getPx() - offset;
    rectForFingerprint?.top.setNumber(newPosY);
    log.showInfo('updateRectForFingerPrint, raiseOffset' + offset + ', panelRect: ' + panelRect?.printPx() +
      ', rectRaised: ' + rectForFingerprint?.printPx());
  }

  private checkIfNeedChangeKeyboardState(persistentId: number, state: sceneSessionManager.SessionState): boolean {
    if (ObjUtil.isInvalid(this.keyboardSession)) {
      log.showError('checkIfNeedChangeKeyboardState, keyboardSession is null');
      return false;
    }

    if (persistentId !== this.keyboardSession.session.persistentId) {
      log.showError('onKeyboardStateChange, invalId: ' + persistentId +
        ', realKeyboardId: ' + this.keyboardSession?.session.persistentId);
      return false;
    }

    if (state === sceneSessionManager.SessionState.STATE_CONNECT) {
      log.showInfo('Skip state change, persistentId: ' + persistentId + 'SessionState: ' + state);
      if (this.keyboardActiveChangeCallback) {
        this.keyboardActiveChangeCallback(this.keyboardState, state, false);
      }
      return false;
    }

    SCBKeyboardPanelManager.getInstance().onKeyboardStateChange(state);
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
      if (this.keyboardActiveChangeCallback) {
        this.keyboardActiveChangeCallback(this.keyboardState, state, false);
      }
      this.keyboardSession.setCallingSessionId(INVALID_PERSISTENT_ID);
      this.keyboardSession.setCallingSession(null);
      this.keyboardSession.updateKeyboardEnableShow(false);
      this.keyboardSession = null;
      this.keyboardState = KeyboardState.UNDEFINED;
      SCBSceneSessionManager.getInstance().refreshZOrder();
      log.showInfo('onKeyboardStateChange, disconnect keyboard session');
      return false;
    }
    return true;
  }

  private onKeyboardStateChange(parentId: number, persistentId: number, state: sceneSessionManager.SessionState):
    void {
    if (!this.checkIfNeedChangeKeyboardState(persistentId, state)) {
      return;
    }

    let callingSession = this.useFocusSessionIfCallingSessionInvalid(state);
    if (!callingSession) {
        log.showError('calling Session is null, focusSession is still null, change keyboard state failed.');
        return;
    }

    if (this.closeAnimationWhenUnlockToLock(callingSession, state)) {
      this.closeKeyboardAnimation(true);
    }

    // When the keyboard is show, SCBSceneContiner needs to be triggered to rebuild.
    let mainSession: SCBSceneSession | null = null;
    if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
      // 重置动画标志，确保应用从后台恢复时能有回弹动效
      this.requestKeyboardAnimate = true;
      if (this.isVoiceInteractionWindowInRecent()) {
        log.showInfo('VOICE_INTERACTION window in recent is touchable');
        this.setKeyboardSessionTouchable(true);
      }
      this.keyboardSession.updateKeyboardEnableShow(true);
      if (callingSession.classType === ClassType.SPECIFIC_SESSION && !ObjUtil.isInvalid(callingSession.session) && (
        callingSession.session.type === sceneSessionManager.SessionType.TYPE_DIALOG ||
        callingSession.session.type === sceneSessionManager.SessionType.TYPE_SUB_APP)) {
        mainSession = SCBSceneSessionManager.getInstance().findMainSessionById(callingSession.session.parentId);
        if (this.isValidSession(mainSession) && mainSession.classType === ClassType.SCENE_SESSION) {
          this.keyboardSession.setParentComponentId((mainSession as SCBSceneSession).session.persistentId);
          this.keyboardSession.updateKeyboardOffset(mainSession);
        }
      } else {
        this.keyboardSession.updateKeyboardOffset(callingSession);
      }
    }

    log.showInfo('onKeyboardStateChange, id: ' + persistentId + ', callingId: ' + callingSession.session.persistentId +
      ', sessionState: ' + state);
    let keyboardState = this.updateKeyboardState(callingSession, mainSession);
    if (keyboardState !== KeyboardState.UNDEFINED) {
      this.updateKeyboardContainer(keyboardState, state);
    }
    if (state === sceneSessionManager.SessionState.STATE_BACKGROUND) {
      this.keyboardSession.setCallingSessionId(INVALID_PERSISTENT_ID);
      this.keyboardSession.setParentComponentId(INVALID_PERSISTENT_ID);
      this.keyboardSession.setCallingSession(null);
      if (this.requestKeyboardAnimate) {
        this.requestKeyboardAnimate = false;
      }
    }
  }

  /**
   * notify keyboard across display
   *
   * @param keyboardId: number
   * @param targetDisplayId: number
   * @returns { void }
   */
  public notifyKeyboardAcrossDisplay(keyboardId: number, targetDisplayId: number): void {
    log.showInfo('notifyKeyboardAcrossDisplay, keyboardId: ' + keyboardId + ', targetDisplayId:' + targetDisplayId);
    if (!this.isValidSession(this.keyboardSession) || !this.isValidSession(this.keyboardSession.session)) {
      log.showError(`this keyboard is invalid.`);
      return;
    }
    if (keyboardId !== this.keyboardSession.session.persistentId) {
      log.showError('keyboardId ' + keyboardId + ' not equal to current keyboardSession ' +
        this.keyboardSession.session.persistentId);
      return;
    }
    if (!this.keyboardSession.isKeyboardShowing()) {
      log.showInfo('keyboard is not showing');
      return;
    }
    this.keyboardSession.screenId = targetDisplayId;
    this.keyboardSessionStateChangeCallbacksForPC.forEach((callback: Function)=> {
      if (callback) {
        callback(this.keyboardSession.session.parentId, this.keyboardSession.session.persistentId,
          this.keyboardSession.sessionState, targetDisplayId);
      } else {
        log.showError('on keyboard across screen, callback is null.');
      }
    });
  }

  public keyboardStateChangeForPCScreenModeChange(mainScreenId: number): void {
    log.showInfo('On screen mode change mainScreenId: ' + mainScreenId);
    this.keyboardSessionStateChangeCallbacksForPC.forEach((callback: Function)=> {
      if (callback) {
        if (!this.isValidSession(this.keyboardSession) || !this.isValidSession(this.keyboardSession.session)) {
          log.showError(`this keyboard is invalid.`);
          return;
        }
        const mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
        this.keyboardSession.screenId = mainScreenId;
        callback(this.keyboardSession.session.parentId, this.keyboardSession.session.persistentId,
          this.keyboardSession.sessionState, mainScreenId);
      } else {
        log.showError('onScreenModeChange, stateChangeCallback is null.');
      }
    });
  }

  public keyboardStateChangeForPCScreenConnect(screenSession: SCBScreenSession): void {
    log.showInfo('onScreenConnect isExtend: ' + screenSession?.session?.isExtend + ', isExtendScreen: ' +
    screenSession?.isExtendScreen + ', screenId: ' + screenSession?.session?.screenId);
    if (screenSession?.isExtendScreen) {
      return;
    }
    // register screen property change callback
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason) => {
      this.updateSystemKeyboardRotateForPC(screenProperty, reason);
    });
  }

  private checkIfNeedUpdateSystemKeyboardRotate(reason: SCBPropertyChangeReason): boolean {
    if (reason !== SCBPropertyChangeReason.ROTATION) {
      log.showInfo('no need to update system keyboard rotate, for screen property change reason: ' + reason);
      return false;
    }
    let systemKeyboardSession = this.getSystemKeyboardSession();
    if (!this.isValidSession(systemKeyboardSession) || !this.isValidSession(this.systemKeyboardPanelSession)) {
      log.showInfo('no need to update system keyboard rotate, for system keyboard or system panel is null');
      return false;
    }
    if (!systemKeyboardSession.isKeyboardShowing()) {
      log.showInfo('no need to update system keyboard rotate, for system keyboard is not showing');
      return false;
    }
    return true;
  }

  private updateSystemKeyboardRotateForPC(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    if (!this.checkIfNeedUpdateSystemKeyboardRotate(reason)) {
      return;
    }

    let systemKeyboardSession = this.getSystemKeyboardSession();
    if (!this.isValidSession(systemKeyboardSession)) {
      log.showInfo(`system keyboard session is null`);
      return;
    }
    let newRectKeyboardRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let newPanelRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    if (screenProperty?.width < screenProperty?.height) {
      newRectKeyboardRect = systemKeyboardSession.keyboardPanelRects.getPortraitKeyboardRect();
      newPanelRect = systemKeyboardSession.keyboardPanelRects.getPortraitPanelRect();
    } else {
      newRectKeyboardRect = systemKeyboardSession.keyboardPanelRects.getLandscapeKeyboardRect();
      newPanelRect = systemKeyboardSession.keyboardPanelRects.getLandscapePanelRect();
    }

    if (!(newRectKeyboardRect instanceof SCBSessionRect) || !(newPanelRect instanceof SCBSessionRect)) {
      log.showInfo('Update system keyboard rotate failed, keyboard or panel rect is null');
      return;
    }

    systemKeyboardSession.updateRect(newRectKeyboardRect.left, newRectKeyboardRect.top,
      newRectKeyboardRect.width, newRectKeyboardRect.height, sceneSessionManager.SessionSizeChangeReason.ROTATION);
    systemKeyboardSession.handleKeyboardRectChange(sceneSessionManager.SessionSizeChangeReason.ROTATION);
    this.notifySCBInputMethodRotate(screenProperty, reason);
  }

  public notifySCBInputMethodRotate(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason): void {
    this.screenPropertyChangeCallbacksForPC.forEach((callback: Function)=> {
      if (callback) {
        callback(screenProperty, reason);
      } else {
        log.showError('notify scb input method failed, screen property change callbacks for pc is null.');
      }
    });
  }
  public keyboardStateChangeForPCScreenDisconnect(screenId: number): void {
    log.showInfo('On screen disconnect, screenId: ' + screenId);
    this.keyboardSessionStateChangeCallbacksForPC.forEach((callback: Function)=> {
      if (callback) {
        if (!this.isValidSession(this.keyboardSession) || !this.isValidSession(this.keyboardSession.session)) {
          log.showError(`this keyboard is invalid.`);
          return;
        }

        const mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
        if (screenId !== mainScreenId && this.keyboardSession.screenId === screenId) {
          this.keyboardSession.screenId = mainScreenId;
        }
        callback(this.keyboardSession.session.parentId, this.keyboardSession.session.persistentId,
          this.keyboardSession.sessionState, mainScreenId);
      } else {
        log.showError('onScreenDisconnect, stateChangeCallback is null.');
      }
    });
  }

  private onKeyboardStateChangeForPC(parentId: number, persistentId: number, state: sceneSessionManager.SessionState,
    isCloseKeyboardAnimation: boolean = false): void {
      let keyboardSession = this.getKeyboardSessionById(persistentId);
      if (!this.isValidSession(keyboardSession) || !this.isValidSession(keyboardSession.session)) {
        log.showError(`keyboard session is invalid, id: ${persistentId}, parentId: ${parentId}, state: ${state}`);
        return;
      }

      if (state === sceneSessionManager.SessionState.STATE_CONNECT) {
        log.showInfo('Skip state change, persistentId: ' + persistentId + 'SessionState: ' + state);
        return;
      }

      let callingSession = keyboardSession?.getCallingSession();
      let screenId = SCBSceneSessionManager.getInstance().mainScreenId;
      if (!keyboardSession.session.isSystemKeyboard && this.isValidSession(callingSession)) {
        if (callingSession instanceof SCBSceneSession) {
          screenId = callingSession?.sceneInfo.screenId;
        } else if (callingSession instanceof SCBSpecificSession) {
          screenId = callingSession?.screenId;
        } else if (callingSession instanceof SCBSystemSceneSession) {
          screenId = callingSession?.session?.screenId;
        }
        log.showInfo('onKeyboardStateChangeForPC, id: ' + persistentId + ', callingId: ' +
          callingSession.session.persistentId + ', screenId: ' + screenId +
          ', callbacksLength:' + this.keyboardSessionStateChangeCallbacksForPC.length);
      }
      keyboardSession.screenId = screenId;
      this.keyboardSessionStateChangeCallbacksForPC.forEach((callback: Function)=> {
        if (callback) {
          callback(parentId, persistentId, state, screenId);
        } else {
          log.showError('onKeyboardStateChangeForPC, stateChangeCallback is null.');
        }
      });
  }

  public resetSystemKeyboardCallingSession(): void {
    let systemKeyboardSession = this.getSystemKeyboardSession();
    if (!this.isValidSession(systemKeyboardSession)) {
      log.showInfo('this system keyboard session is already null.');
      return;
    }
    systemKeyboardSession.setCallingSessionId(INVALID_PERSISTENT_ID);
    systemKeyboardSession.setCallingSession(null);
    systemKeyboardSession.updateKeyboardEnableShow(false);
  }

  public onKeyboardStateChangeInCompatibleMode(): void {
    this.closeKeyboardAnimation(true);
    this.onKeyboardStateChange(INVALID_PERSISTENT_ID, this.keyboardSession?.session.persistentId,
      this.keyboardSession?.sessionState);
  }

  private isSupportCompatibleMode(callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    if (!callingSession) {
      log.showInfo(`updateKeyboardState isSupportCompatibleMode callingSession null`);
      return false;
    }
    let classType = callingSession.classType;
    if (classType === ClassType.SCENE_SESSION) {
      log.showInfo(`updateKeyboardState typeof SCBSceneSession`);
      return false;
    }
    if (classType === ClassType.SPECIFIC_SESSION) {
      log.showInfo(`updateKeyboardState typeof SCBSpecificSession`);
      let parentSession: SCBSceneSession = (callingSession as SCBSpecificSession).getParentSession();
      if (parentSession) {
        return false;
      }
    }
    return false;
  }

  private updateKeyboardStateInCompatibleMode(callingSession: SCBSceneSession | SCBSpecificSession |
    SCBSystemSceneSession): KeyboardState {
    let specificPanel = SCBSceneSessionManager.getInstance().getPanelZorderByType(callingSession.session.type);
    let isScreenLock: boolean = SCBSceneSessionManager.getInstance().isScreenLocked();
    let showBelowKeyguard: boolean = !callingSession.isShowWhenLocked || !isScreenLock;
    const type: sceneSessionManager.SessionType = callingSession.session.type;
    log.showInfo('[Compatible] getKeyboardState, isScreenLocked: ' + isScreenLock + ', showBelowKeyguard: ' +
      showBelowKeyguard + ', specificPanel: ' + specificPanel + ', type: ' + type);

    // keyboard show in belowSpecificScene
    const classType = callingSession.classType;
    if (((showBelowKeyguard && specificPanel === undefined) ||
         (specificPanel !== undefined && specificPanel < SpecificPanelZOrder.VOICE_INTERACTION)) &&
        (classType === ClassType.SPECIFIC_SESSION || classType === ClassType.SYSTEM_SCENE_SESSION ||
         classType === ClassType.SCENE_SESSION)) {
      log.showInfo('[CompatibleMode] getKeyboardState, keyboardState: ' + KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE);
      return KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE;
    }

    log.showInfo('[Compatible] getKeyboardState failed, keyboardState: ' + KeyboardState.UNDEFINED);
    return KeyboardState.UNDEFINED;
  }

  private isValidSession(session: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | SCBKeyboardSession |
    SCBSceneContainerSession | sceneSessionManager.SceneSession): boolean {
    if (session === undefined || session === null) {
      return false;
    }
    return true;
  }

  private isCalledByKeyguardOrPanel(type : sceneSessionManager.SessionType,
    callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    // keyboard show in keyguard or DropdownPanel
    if ((type === sceneSessionManager.SessionType.TYPE_KEYGUARD) ||
      ((callingSession.classType === ClassType.SYSTEM_SCENE_SESSION) &&
      (callingSession as SCBSystemSceneSession).name.includes('SCBDropdownPanel') &&
        type === sceneSessionManager.SessionType.TYPE_PANEL)) {
      return true;
    }
    return false;
  }

  private isShowInBelowScenePanel(type : sceneSessionManager.SessionType,
    callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    let classType = callingSession.classType;
    if (classType === ClassType.SCENE_SESSION &&
        (callingSession as SCBSceneSession).sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
      return true;
    }

    if (classType === ClassType.SPECIFIC_SESSION &&
      (type === sceneSessionManager.SessionType.TYPE_DIALOG || type === sceneSessionManager.SessionType.TYPE_SUB_APP)) {
      let parentSession = SCBSceneSessionManager.getInstance().getSessionById(callingSession.session?.parentId);
      if (this.isValidSession(parentSession) && parentSession.classType === ClassType.SCENE_SESSION &&
          (parentSession as SCBSceneSession).sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
        return true;
      }
    }

    if (classType === ClassType.SCENE_SESSION || classType === ClassType.SPECIFIC_SESSION) {
      let containerSession = this.getSceneContainerSessionForKeyboard(callingSession.session?.persistentId);
      if (containerSession?.isMidScene &&
        containerSession.midSceneParam.getLifeCycle() === MidSceneLifeCycle.EXIT_MIDSCENE_TO_FULL) {
        return true;
      }
    }

    return false;
  }

  private isShowAboveMidScene(type: sceneSessionManager.SessionType,
    callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    if (!(callingSession.classType === ClassType.SPECIFIC_SESSION)) {
      return false;
    }
    let callingId: number = INVALID_PERSISTENT_ID;
    if (type === sceneSessionManager.SessionType.TYPE_APP) {
      callingId = callingSession.session.persistentId;
    } else if (type === sceneSessionManager.SessionType.TYPE_SUB_APP) {
      callingId = callingSession.session.parentId;
    }
    let containerSession = SCBSceneSessionManager.getInstance().getSceneContainerSessionFromScenePanel(callingId);
    return !!containerSession && containerSession.isMidScene &&
      containerSession.midSceneParam.getLifeCycle() !== MidSceneLifeCycle.EXIT_MIDSCENE_TO_FULL;
  }

  private isShowAboveSplitScene(showBelowKeyguard : boolean,
                              callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    if (!showBelowKeyguard) {
      return false;
    }
    if (callingSession.classType === ClassType.SCENE_SESSION &&
        SCBSceneSessionManager.getInstance().isSplitMode(callingSession.session.persistentId)) {
      return true;
    }
    let containerSession = this.getSceneContainerSessionForKeyboard(callingSession.session.persistentId);
    if (!this.isValidSession(containerSession)) {
      return false;
    }
    return containerSession.isSplitView() ||
      (containerSession.isMidScene && containerSession.splitParam.getLifeCycle() === SplitLifeCycle.EXIT_MIDSCENE_TO_SPLIT);
  }

  private isShowInBelowSpecificScene(showBelowKeyguard : boolean,
    callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    let specificPanel = SCBSceneSessionManager.getInstance().getPanelZorderByType(callingSession.session.type);
    let classType = callingSession.classType;
    if (((showBelowKeyguard && specificPanel === undefined) ||
        (specificPanel !== undefined && specificPanel < SpecificPanelZOrder.VOICE_INTERACTION)) &&
        (classType === ClassType.SPECIFIC_SESSION || classType === ClassType.SYSTEM_SCENE_SESSION ||
         (classType === ClassType.SCENE_SESSION &&
          (callingSession as SCBSceneSession).sceneInfo.windowMode === SCBSceneMode.FLOATING))) {
      return true;
    }
    return false;
  }

  private isShowInAboveScenePanel(type : sceneSessionManager.SessionType,
    callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): boolean {
    let classType = callingSession.classType;
    if (classType === ClassType.SCENE_SESSION) {
      return true;
    }

    if (classType === ClassType.SPECIFIC_SESSION && type === sceneSessionManager.SessionType.TYPE_SUB_APP) {
      return true;
    }

    if (classType === ClassType.SPECIFIC_SESSION && type === sceneSessionManager.SessionType.TYPE_DIALOG) {
      let parentSession = SCBSceneSessionManager.getInstance().getSessionById(callingSession.session?.parentId);
      if (this.isValidSession(parentSession) && parentSession.classType === ClassType.SCENE_SESSION) {
        return true;
      }
    }
    return false;
  }

  /**
   * add app animation callback flag
   *
   */
  public addUnInterruptableAnimationCallbackFlag(): void {
    this.unInterruptableAnimationCallbackCnt++;
  }

  /**
   * remove app animation callback flag
   *
   */
  public removeUnInterruptableAnimationCallbackFlag(): void {
    this.unInterruptableAnimationCallbackCnt--;
    if (this.unInterruptableAnimationCallbackCnt < 0) {
      this.unInterruptableAnimationCallbackCnt = 0;
    }
  }

  private aboveFloatContainerStateChangeIfHaveGesture(isAboveFloat: boolean): void {
    this.isAboveFloatContainer = false;
    if (this.keyboardState === KeyboardState.SHOW_IN_ABOVE_FLOAT_CONTAINER_SCENE) {
      if (this.keyboardSession?.isKeyboardShowing()) {
        this.closeKeyboardAnimation(true);
        this.onKeyboardStateChange(this.keyboardSession?.session.parentId, this.keyboardSession?.session.persistentId,
          this.keyboardSession?.sessionState);
      }
    }
    return;
  }

  /**
   * notify keyboard window state change
   *
   */
  public notifyKeyboardAboveFloatContainerStateChange(haveGestureNavigationEvent: boolean = false): void {
    if (this.unInterruptableAnimationCallbackCnt !== 0 && haveGestureNavigationEvent === false) {
      return;
    }

    let isAboveFloat: boolean = (SCBScenePanelManager.getInstance().getActiveFloatContainerList().length !== 0);

    if (haveGestureNavigationEvent) {
      this.aboveFloatContainerStateChangeIfHaveGesture(isAboveFloat);
      return;
    }

    this.isAboveFloatContainer = isAboveFloat;
    if ((this.keyboardState === KeyboardState.UNDEFINED) ||
    (isAboveFloat && this.keyboardState === KeyboardState.SHOW_IN_BELOW_SCENE_PANEL) ||
    (isAboveFloat && this.keyboardState === KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE) ||
    (!isAboveFloat && this.keyboardState === KeyboardState.SHOW_IN_ABOVE_FLOAT_CONTAINER_SCENE)) {
      if (this.keyboardSession?.isKeyboardShowing()) {
        if (this.requestKeyboardAnimate) {
          return;
        } else {
          this.closeKeyboardAnimation(true);
          this.onKeyboardStateChange(this.keyboardSession?.session.parentId, this.keyboardSession?.session.persistentId,
            this.keyboardSession?.sessionState);
        }
     }
    }
  }

  private updateKeyboardState(callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession,
    mainSession: SCBSceneSession | null):
    KeyboardState {
    if (!this.isValidSession(callingSession)) {
      return KeyboardState.UNDEFINED;
    }
    if (this.isSupportCompatibleMode(callingSession)) {
      return this.updateKeyboardStateInCompatibleMode(callingSession);
    }
    let specificPanel = SCBSceneSessionManager.getInstance().getPanelZorderByType(callingSession.session.type);
    let isScreenLock: boolean = SCBSceneSessionManager.getInstance().isScreenLocked();
    const type : sceneSessionManager.SessionType = callingSession.session.type;
    let isShowWhenLocked = (type === sceneSessionManager.SessionType.TYPE_SUB_APP && mainSession !== null) ?
      mainSession.isShowWhenLocked : callingSession.isShowWhenLocked;
    let showBelowKeyguard: boolean = !isShowWhenLocked || !isScreenLock;
    log.showInfo(`getKeyboardState, specificPanel: ${specificPanel}, type: ${type}` +
      `, mainId: ${mainSession?.session.persistentId}` +
      `, showBelowKeyguard: ${showBelowKeyguard}, isScreenLocked: ${isScreenLock}` +
      `, isShowWhenLocked calling: ${callingSession.isShowWhenLocked}, main: ${mainSession?.isShowWhenLocked}`);

    if (this.isCalledByKeyguardOrPanel(type, callingSession)) {
      log.showInfo('getKeyboardState, keyboardState: ' + KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE);
      return KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE;
    }
    // keyboard show in belowScenePanel when scene is midScene
    if (this.isShowAboveMidScene(type, callingSession)) {
      log.showInfo('getKeyboardState, keyboardState: ' + KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE);
      return KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE;
    }

    // keyboard show in belowScenePanel when scene not floating
    if (this.isShowAboveSplitScene(showBelowKeyguard, callingSession)) {
      log.showInfo(`getKeyboardState, Split isAboveFloatContainer: ${this.isAboveFloatContainer}`);
      return (this.isAboveFloatContainer ? KeyboardState.SHOW_IN_ABOVE_FLOAT_CONTAINER_SCENE : KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE);
    }

    // keyboard show in belowScenePanel when mainScene not floating or is subScene
    if (showBelowKeyguard && this.isShowInBelowScenePanel(type, callingSession)) {
      log.showInfo(`getKeyboardState, IsAboveFloatContainer: ${this.isAboveFloatContainer}`);
      return (this.isAboveFloatContainer ? KeyboardState.SHOW_IN_ABOVE_FLOAT_CONTAINER_SCENE : KeyboardState.SHOW_IN_BELOW_SCENE_PANEL);
    }

    // keyboard show in belowSpecificScene
    if (this.isShowInBelowSpecificScene(showBelowKeyguard, callingSession)) {
      log.showInfo(`getKeyboardState, keyboardState: ${KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE}`);
      return KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE;
    }

    // keyboard show in aboveScenePanel, calling session can be mainScene or subScene
    if (!showBelowKeyguard && this.isShowInAboveScenePanel(type, callingSession)) {
      log.showInfo(`getKeyboardState, keyboardState: ${KeyboardState.SHOW_IN_ABOVE_SCENE_PANEL}`);
      return KeyboardState.SHOW_IN_ABOVE_SCENE_PANEL;
    }

    let classType = callingSession.classType;
    // keyboard show in aboveSpecificScene
    if (((specificPanel !== undefined && specificPanel >= SpecificPanelZOrder.VOICE_INTERACTION) &&
      (classType === ClassType.SPECIFIC_SESSION || classType === ClassType.SYSTEM_SCENE_SESSION))) {
      log.showInfo('getKeyboardState, keyboardState: ' + KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE);
      return KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE;
    }
    log.showInfo('getKeyboardState failed, use default');
    return showBelowKeyguard ? KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE : KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE;
  }

  private updateKeyboardContainer(keyboardState: KeyboardState, state: sceneSessionManager.SessionState): void {
    let isActive = ACTIVE_STATUS_MAP.get(state);
    if (isActive === undefined || !this.isValidSession(this.keyboardSession)) {
      log.showError('invalid session state: ' + state);
      return;
    }

    log.showInfo('updateKeyboardContainer, newKeyboardState: ' + keyboardState + ', curKeyboardState: ' +
      this.keyboardState + ', sessionState: ' + state + ', isActive: ' + isActive);

    this.keyboardState = keyboardState;
    this.keyboardShowCallbacks.forEach((callback) => {
      if (callback) {
        callback(this.keyboardSession);
      }
    });
    if (this.keyboardActiveChangeCallback) {
      this.keyboardActiveChangeCallback(keyboardState, state, isActive);
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  /**
   * Get whether the rotation is vertical
   *
   * @param rotation number
   * @param screenProperty: SCBScreenProperty
   * @returns { Boolean }
   */
  public isVertical(rotation: number, screenProperty: SCBScreenProperty): boolean {
    if (screenProperty?.defaultScreenOrientation === 0) {
      return rotation === RotationConstants.ROTATION_0 || rotation === RotationConstants.ROTATION_180 ||
        rotation === RotationConstants.ROTATION_360;
    } else {
      return rotation === RotationConstants.ROTATION_90 || rotation === RotationConstants.ROTATION_270;
    }
  }

  private checkIfNeedUpdateKeyboardRectOnRotation(reason: SCBPropertyChangeReason, screenProperty: SCBScreenProperty): boolean {
    if (ObjUtil.isInvalid(this.keyboardSession) || ObjUtil.isInvalid(this.keyboardPanelSession)) {
      log.showInfo('noNeedUpdateKeyboardOnRotation, keyboard or panel is null');
      return false;
    }

    if (ObjUtil.isInvalid(screenProperty)) {
      log.showInfo('noNeedUpdateKeyboardOnRotation, screen property is null');
      return false;
    }

    if (!this.keyboardSession.isKeyboardShowing()) {
      // The keyboard hide animation is interrupted by screen rotation or fold-to-expand actions.
      if (this.keyboardSession.animCnt !== 0 &&
        (reason === SCBPropertyChangeReason.ROTATION || reason === SCBPropertyChangeReason.FOLD_TO_EXPAND)) {
        this.hideAnimationInterruption();
      }
      log.showInfo('noNeedUpdateKeyboardOnRotation, keyboard is not showing');
      return false;
    }

    if (reason !== SCBPropertyChangeReason.ROTATION && reason !== SCBPropertyChangeReason.FOLD_SCREEN_ROTATION &&
      reason !== SCBPropertyChangeReason.FOLD_LANDSCAPE_START &&
      reason !== SCBPropertyChangeReason.PAGE_ROTATION) {
      log.showInfo('noNeedUpdateKeyboardOnRotation, No need update, rotation reason: ' + reason);
      return false;
    }

    return true;
  }

  private isScreenRotateLandscapeStart(screenSession: SCBScreenSession, screenProperty: SCBScreenProperty): boolean {
    return (!screenSession?.isRotateScreenPolicy()) || (screenProperty?.rotation !== 0);
  }

  private updateKeyboardPanelRectOnRotationChange(screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason) : void {
    if (!this.checkIfNeedUpdateKeyboardRectOnRotation(reason, screenProperty)) {
      return;
    }
    let newRectKeyboardRect : SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let newPanelRect : SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let newAvoidHeight: number = 0;
    let screenRotation: number = screenProperty?.rotation ?? 0;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty?.screenId);
    if (!screenSession) {
      log.showInfo('screenSession is null');
    } else if (screenSession.isRotateScreenPolicy()) {
      screenRotation = screenSession.scbScreenProperty?.rotation;
    }

    if (this.isScreenRotateLandscapeStart(screenSession, screenProperty)) {
      let callingSession = this.keyboardSession.getCallingSession();
      if (callingSession instanceof SCBSystemSceneSession && callingSession.rotation !== screenRotation) {
        log.showInfo('No need rotate keyboard, callingSession rotation: ' + callingSession.rotation +
          ', screenRotation: ' + screenRotation);
        return;
      }
      if (callingSession instanceof SCBSceneSession && callingSession.currentRotation !== screenRotation) {
        log.showInfo('No need rotate keyboard, callingSession currentRotation: ' + callingSession.currentRotation +
          ', screenRotation: ' + screenRotation);
        return;
      }
    }

    if (screenSession === null) {
        log.showError('screenSession is null');
        return;
    }
    if (screenSession.scbScreenProperty?.isScreenVertical()) {
      newRectKeyboardRect = this.keyboardSession.keyboardPanelRects.getPortraitKeyboardRect();
      newPanelRect = this.keyboardSession.keyboardPanelRects.getPortraitPanelRect();
      newAvoidHeight = this.keyboardSession.keyboardPanelRects.getPortraitAvoidHeight();
    } else {
      newRectKeyboardRect = this.keyboardSession.keyboardPanelRects.getLandscapeKeyboardRect();
      newPanelRect = this.keyboardSession.keyboardPanelRects.getLandscapePanelRect();
      newAvoidHeight = this.keyboardSession.keyboardPanelRects.getLandscapeAvoidHeight();
    }

    if (!(newRectKeyboardRect instanceof SCBSessionRect) || !(newPanelRect instanceof SCBSessionRect)) {
      log.showInfo('UpdateKeyboardOnRotation failed, keyboard or panel rect is null');
      return;
    }

    this.keyboardSession.updateRect(newRectKeyboardRect.left, newRectKeyboardRect.top, newRectKeyboardRect.width,
      newRectKeyboardRect.height, sceneSessionManager.SessionSizeChangeReason.ROTATION);
    this.keyboardPanelSession.currRect.copyFrom(newPanelRect);
    this.keyboardPanelSession.setPanelRealHeight(newAvoidHeight);
    this.keyboardPanelSession.setPanelAdjustHeight(newPanelRect.height.getPx());
    this.notifyKeyboardRectChange(this.keyboardSession.session?.persistentId);
    log.showInfo('updateKeyboardPanelRectOnRotationChange, newRectKeyboardRect: ' + newRectKeyboardRect.printPx() +
      ', newPanelRect: ' + newPanelRect.printPx() + 'screenRotation: ' + screenRotation);
  }

  /**
   * notify virtual screen calling window change
   *
   * @param callingSessionId
   */
  public notifyVirtualScreenCallingSessionChange(callingSessionId: number): void {
    this.keyboardChangeListenerList.forEach((keyboardChangeCallback) => {
        keyboardChangeCallback?.onCallingSessionChange?.(callingSessionId);
    });
  }

  /**
   * get current calling session screen id
   *
   */
  public getCallingSessionScreenId(): number {
    return SCBSceneSessionManager.getInstance().getScreenIdByWindowId(this.keyboardSession?.getCallingSessionId());
  }
}
