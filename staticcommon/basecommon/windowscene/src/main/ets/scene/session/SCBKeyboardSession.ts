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

import display from '@ohos.display';
import sceneSessionManager from '@ohos.sceneSessionManager';
import transactionManager from '@ohos.transactionManager';
import { SCBSessionInfo } from './SCBSessionInfo';
import { SCBSceneSession, SCBWindowShadowConfig } from './SCBSceneSession';
import type { ScbNumber } from './SCBSessionRect';
import { SCBSessionRect } from './SCBSessionRect';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager, ACTIVE_STATUS_MAP, INVALID_SCREEN_ID } from './SCBSceneSessionManager';
import type { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { SCBKeyboardManager, KEYBOARD_STATE_MAP, KeyboardChangeCallback, KeyboardState } from './SCBKeyboardManager';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSpecificSession } from './SCBSpecificSession';
import { SCBSceneContainerSession } from './SCBSceneContainerSession';
import { CommonUtils } from '@ohos/basicutils';
import type { RectInfo } from '@ohos/basicutils';
import { SCBSystemSceneSession } from './SCBSystemSceneSession';
import { SCBKeyboardPanelManager } from './SCBKeyboardPanelManager';
import { image } from '@kit.ImageKit';
import screenSessionManager from '@ohos.screenSessionManager';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { HiSysDataShowHide } from '@ohos/frameworkwrapper';
// import apsManager from '@ohos.graphic.apsManager';
import { ApsUtils } from '@ohos/frameworkwrapper';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBKeyboardSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const LANDSCAPE_KEYBOARD_HEIGHT_RATIO: number = 0.5833;
const PORTRAIT_KEYBOARD_HEIGHT_RATIO: number = 0.4271;
const INVALID_PERSISTENT_ID: number = 0;

export class SCBKeyboardPanelRects {
  constructor() {
    this.landscapeKeyboardRect = new SCBSessionRect(0, 0, 0, 0);
    this.portraitKeyboardRect = new SCBSessionRect(0, 0, 0, 0);
    this.landscapePanelRect = new SCBSessionRect(0, 0, 0, 0);
    this.portraitPanelRect = new SCBSessionRect(0, 0, 0, 0);
  }

  /**
   * set Landscape Rect
   *
   * @param rect
   */
  public setLandscapeKeyboardRect(rect: SCBSessionRect): void {
    this.landscapeKeyboardRect.copyFrom(rect);
  }

  /**
   * set Portrait Rect
   *
   * @param rect
   */
  public setPortraitKeyboardRect(rect: SCBSessionRect): void {
    this.portraitKeyboardRect.copyFrom(rect);
  }

  /**
   * get Landscape Rect
   *
   * @returns
   */
  public getLandscapeKeyboardRect(): SCBSessionRect {
    return this.landscapeKeyboardRect;
  }

  /**
   * get Portrait Rect
   *
   * @returns
   */
  public getPortraitKeyboardRect(): SCBSessionRect {
    return this.portraitKeyboardRect;
  }

  /**
   * set Landscape Rect
   *
   * @param rect
   */
  public setLandscapePanelRect(rect: SCBSessionRect): void {
    this.landscapePanelRect.copyFrom(rect);
  }

  /**
   * set Portrait Rect
   *
   * @param rect
   */
  public setPortraitPanelRect(rect: SCBSessionRect): void {
    this.portraitPanelRect.copyFrom(rect);
  }

  /**
   * get Landscape Rect
   *
   * @returns
   */
  public getLandscapePanelRect(): SCBSessionRect {
    return this.landscapePanelRect;
  }

  /**
   * get Portrait Rect
   *
   * @returns
   */
  public getPortraitPanelRect(): SCBSessionRect {
    return this.portraitPanelRect;
  }

  /**
   * set Landscape Avoid Height
   *
   * @param rect
   */
  public setLandscapeAvoidHeight(height: number): void {
    this.landscapeAvoidHeight = height;
  }

  /**
   * set Portrait Avoid Height
   *
   * @param rect
   */
  public setPortraitAvoidHeight(height: number): void {
    this.portraitAvoidHeight = height;
  }

  /**
   * get Landscape Avoid Height
   *
   * @returns
   */
  public getLandscapeAvoidHeight(): number {
    return this.landscapeAvoidHeight;
  }

  /**
   * get Portrait Avoid Height
   *
   * @returns
   */
  public getPortraitAvoidHeight(): number {
    return this.portraitAvoidHeight;
  }

  private landscapeKeyboardRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private portraitKeyboardRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private landscapePanelRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private portraitPanelRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  private landscapeAvoidHeight: number = -1;
  private portraitAvoidHeight: number = -1;
}

class SCBKeyboardSessionData {
  isFocused: boolean = false;
  sessionState: sceneSessionManager.SessionState;
  animCnt: number = 0;
  parentComponentId: number = INVALID_PERSISTENT_ID;
  callingSessionId: number = INVALID_PERSISTENT_ID;
  callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null = null;
  containerSession: SCBSceneContainerSession | null = null;
  isCloseKeyboardAnimation: boolean = false;
  animSnapshot: image.PixelMap | undefined = undefined;
  isShowAnimation: boolean = false;
  isRotating: boolean = false;
}

/**
 * Session of system scene or sub scene
 */
@Observed
export class SCBKeyboardSession {
  /**
   * public data of a session, which should not trigger ui flush
   */
  public sessionData: SCBKeyboardSessionData = new SCBKeyboardSessionData();

  get sessionState(): sceneSessionManager.SessionState {
    return this.sessionData.sessionState;
  }

  get animCnt(): number {
    return this.sessionData.animCnt;
  }

  get isCloseKeyboardAnimation(): boolean {
    return this.sessionData.isCloseKeyboardAnimation;
  }

  get animSnapshot(): image.PixelMap | undefined {
    return this.sessionData.animSnapshot;
  }

  get isShowAnimation(): boolean {
    return this.sessionData.isShowAnimation;
  }

  get isRotating(): boolean {
    return this.sessionData.isRotating;
  }

  public refCount: number = 0;
  public isActive: boolean = false;
  public visibility: boolean = true;
  public isFocusable: boolean = true;
  public specialBoarderRadius: number = 0;
  public keyboardPanelRects: SCBKeyboardPanelRects = new SCBKeyboardPanelRects();
  public rectForFingerprint: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  public currRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
  public shadowConfig: SCBWindowShadowConfig = new SCBWindowShadowConfig();
  public isWindowShowAnimate: boolean = true;
  public isCustomAnimationPlaying: boolean = false;
  public isTouchable: boolean = true;
  public keyboardOffset: number = 0;
  public translatePosY: number = 0;
  public sessionGravity: sceneSessionManager.KeyboardGravity = sceneSessionManager.KeyboardGravity.GRAVITY_BOTTOM;
  public screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
  private isKeyboardSyncTransactionOpen_ = false;

  readonly session: sceneSessionManager.SceneSession;
  readonly isShowWhenLocked: boolean = false;

  // used for system keyboard resize animation
  private systemKeyboardScaleX: number = 1;
  private systemKeyboardScaleY: number = 1;
  private systemKeyboardTranslateX: number = 0;
  private systemKeyboardTranslateY: number = 0;
  private animVisible: boolean = false;

  private opacity: number = 1;
  private parentId: number = -1;
  private sessionInfo: SCBSessionInfo = new SCBSessionInfo();
  private callingWindowInfoData: CallingWindowInfoData;


  private getCallingWindowInfoData(): void {
    // 使用默认值，不调用不存在的 getCallingSession() 方法
    this.callingWindowInfoData = {
      callingWindowState: 0,  // STATE_FOREGROUND
      scaleX: 1.0,
      scaleY: 1.0
    };
  }


  /*
   * callback of session state change
   */
  stateChangeCallback: Function;

  /*
   * callback of session rect change, used for keyboardPanel
   */
  keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();

  /**
   * @description: callback of keyboard change
   */
  keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();

  /*
   * callback of session rect change
   */
  keyboardHeightChangeCallback: Function;

  /*
   * callback of touchable
   */
  sessionTouchableChangeCallback: Function;

  /*
 * callback of whether custom animation is playing
 */
  customAnimationPlayingCallback: Function;

  /*
   * callback of session forceHide change
   */
  sessionForceHideCallback: Function;

  /*
   * callback ofget ZIndex
   */
  getZIndexCallback: Function;

  /**
   * Constructor.
   * @param session Session of the scene
   * @param sceneInfo Information of the scene
   */
  constructor(session: sceneSessionManager.SceneSession, stateChangeCallback: Function,
              keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback>,
              keyboardChangeListenerList: Array<KeyboardChangeCallback>) {
    if (session === null || session === undefined) {
      log.showError(`constructor error, session is undefined`);
      return;
    }
    log.showInfo(`constructor, id: ${session.persistentId}, type: ${session.type}, parentId: ${session.parentId}`);
    this.session = session;
    this.stateChangeCallback = stateChangeCallback;
    this.isActive = false;
    this.sessionData.sessionState = sceneSessionManager.SessionState.STATE_DISCONNECT;
    this.keyboardChangeCallbackMap = keyboardChangeCallbackMap;
    this.keyboardChangeListenerList = keyboardChangeListenerList;
    this.sessionGravity = session.keyboardGravity;
    this.session?.on('sessionTouchableChange', (isTouchable) => {
      this.onSessionTouchableChange(isTouchable);
    });
    this.session.on('adjustKeyboardLayout', (keyboardLayoutParams) => {
      this.onAdjustKeyboardLayout(keyboardLayoutParams);
    });
    this.session?.on('sessionForceHideChange', (hide) => {
      this.onSessionForceHideChange(hide);
    });
    this.session?.on('needDefaultAnimationFlagChange', (isWindowShowAnimate) => {
      this.onNeedDefaultAnimationFlagChange(isWindowShowAnimate);
    });
    this.session?.on('isCustomAnimationPlaying', (isPlaying) => {
      this.onCustomAnimationPlaying(isPlaying);
    });
    this.session?.on('keyboardStateChange', (state, keyboardEffectOption: sceneSessionManager.KeyboardEffectOption) => {
      if (typeof state !== 'number') {
        log.showError('invalid state type: ' + typeof state);
        return;
      }
      this.notifyKeyboardStateChange(state);
      // updateKeyboardEffectOption by imf for phone and pad
      if (keyboardEffectOption === null || keyboardEffectOption === undefined) {
        log.showError('keyboardEffectOption is null');
        return;
      }
      log.showInfo(`keyboardStateChange, ViewMode: ${keyboardEffectOption.viewMode},` + 
        `blurHeight: ${keyboardEffectOption.blurHeight},` + `FlowLightMode: ${keyboardEffectOption.flowLightMode},` +
          `GradientMode : ${keyboardEffectOption.gradientMode}`);
      SCBKeyboardPanelManager.getInstance().updateKeyboardEffectOption(this.session?.persistentId, keyboardEffectOption);
    });

    this.session?.on('keyboardEffectOptionChange', (keyboardEffectOption: sceneSessionManager.KeyboardEffectOption) => {
      // updateKeyboardEffectOption by imf for phone and pad
      if (keyboardEffectOption === null || keyboardEffectOption === undefined) {
        log.showError('keyboardEffectOption is null');
        return;
      }
      log.showInfo(`keyboardEffectOptionChange, ViewMode: ${keyboardEffectOption.viewMode},` + 
        `blurHeight: ${keyboardEffectOption.blurHeight},` + `FlowLightMode: ${keyboardEffectOption.flowLightMode},` +
          `GradientMode : ${keyboardEffectOption.gradientMode}`);
      SCBKeyboardPanelManager.getInstance().updateKeyboardEffectOption(this.session?.persistentId, keyboardEffectOption);
    });

    this.session?.on('callingWindowIdChange', (callingWindowId: number) => {
      SCBKeyboardManager.getInstance().onCallingSessionIdChange(callingWindowId);
      SCBKeyboardManager.getInstance().notifyVirtualScreenCallingSessionChange(callingWindowId);
    });
    this.callingWindowInfoData = {
      callingWindowState: 0,
      scaleX: 1.0,
      scaleY: 1.0
    };
  }

  public isFloatGravity(): boolean {
    return this.sessionGravity === sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT;
  }

  /**
   * register keyboard height Change Callback
   *
   * @param callback
   */
  public registerKeyboardHeightChangeCallback(callback: Function): void {
    log.showDebug('registerKeyboardHeightChangeCallback');
    this.keyboardHeightChangeCallback = callback;
  }

  /**
   * unregister keyboard height Change Callback
   */
  public unregisterKeyboardHeightChangeCallback(): void {
    log.showDebug('unregisterKeyboardHeightChangeCallback');
    this.keyboardHeightChangeCallback = null;
  }

  /**
   * register Session Custom Animation Playing Callback
   *
   * @param callback
   */
  public registerSessionCustomAnimationPlayingCallback(callback: Function): void {
    // register session rect change callback
    this.customAnimationPlayingCallback = callback;
  }

  /**
   * register Session Force Hide Callback
   *
   * @param callback
   */
  public registerSessionForceHideCallback(callback: Function): void {
    // register session forceHide change callback
    this.sessionForceHideCallback = callback;
  }

  /**
   * register Get ZIndex Callback
   *
   * @param callback
   */
  public registerGetZIndexCallback(callback: Function): void {
    this.getZIndexCallback = callback;
  }

  /**
   * get ZIndex
   *
   * @returns
   */
  public getZIndex(): number {
    let zIndex : number = 0;
    if (this.getZIndexCallback) {
      zIndex = this.getZIndexCallback();
    }
    this.keyboardChangeCallbackMap?.forEach((value, key) => {
      zIndex = value?.getZIndex();
      return;
    });
    return zIndex;
  }

  public isKeyboardShowing() : boolean {
    if (this.sessionState === sceneSessionManager.SessionState.STATE_FOREGROUND ||
      this.sessionState === sceneSessionManager.SessionState.STATE_ACTIVE) {
      return true;
    }
    return false;
  }

  /**
   * get whether keyboard sync transaction is opened
   *
   * @returns isKeyboardSyncTransactionOpen
   */
  public isKeyboardSyncTransactionOpen() : boolean {
    return this.isKeyboardSyncTransactionOpen_;
  }

  /**
   * register Session Touchable Change Callback
   *
   * @param callback
   */
  public registerSessionTouchableChangeCallback(callback: Function): void {
    log.showInfo('registerSessionTouchableChangeCallback');
    this.sessionTouchableChangeCallback = callback;
    if (this.sessionTouchableChangeCallback) {
      this.sessionTouchableChangeCallback(this.isTouchable);
    }
  }

  /**
   * set Touchable
   *
   * @param isTouchable
   */
  public setTouchable(isTouchable: boolean): void {
    log.showDebug(`persistentId: ${this.session?.persistentId} is setTouchable: ${isTouchable}!`);
    this.isTouchable = isTouchable;
  }

  /**
   * set ZOrder
   *
   * @param zOrder
   */
  public setZOrder(zOrder: number): void {
    if (this.session === null || this.session === undefined) {
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

  /**
   * set Special Window Effect Config
   */
  public setSpecialWindowEffectConfig(): void {
    this.setSpecialWindowCornerConfig();
    this.setSpecialWindowShadowConfig();
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
    this.refCount++;
  }

  /**
   * dec Ref Count
   */
  public decRefCount(): void {
    this.refCount--;
  }

  /**
   * get Ref Count
   */
  public getRefCount(): number {
    return this.refCount;
  }

  /**
   * un Register All
   */
  public unRegisterAll(): void {
    if (this.refCount !== 0) {
      return;
    }
    this.sessionTouchableChangeCallback = null;
    this.customAnimationPlayingCallback = null;
    this.sessionForceHideCallback = null;
  }

  /**
   * set Animate Snapshot image
   *
   * @param { image.PixelMap | undefined } snapshot
   */
  public setAnimSnapshot(snapshot: image.PixelMap | undefined): void {
    this.sessionData.animSnapshot = snapshot;
  }

  /**
   * int System Keyboard Scene State
   */
  public initSystemKeyboardState(): void {
    this.setSystemKeyboardScale(1, 1);
    this.setSystemKeyboardTranslate(0, 0);
  }

  /**
   * get System Keyboard Scene ScaleX
   */
  public getSystemKeyboardScaleX(): number {
    return this.systemKeyboardScaleX;
  }

  /**
   * get System Keyboard Scene ScaleY
   */
  public getSystemKeyboardScaleY(): number {
    return this.systemKeyboardScaleY;
  }

  /**
   * set System Keyboard Scene Scale
   *
   * @param { number } scaleX
   * @param { number } scaleY
   */
  public setSystemKeyboardScale(scaleX: number, scaleY: number): void {
    this.systemKeyboardScaleX = scaleX;
    this.systemKeyboardScaleY = scaleY;
  }

  /**
   * get System Keyboard Scene TranslateX
   */
  public getSystemKeyboardTranslateX(): number {
    return this.systemKeyboardTranslateX;
  }

  /**
   * get System Keyboard Scene TranslateY
   */
  public getSystemKeyboardTranslateY(): number {
    return this.systemKeyboardTranslateY;
  }

  /**
   * set System Keyboard Scene Translate
   *
   * @param { number } translateX
   * @param { number } translateY
   */
  public setSystemKeyboardTranslate(translateX: number, translateY: number): void {
    this.systemKeyboardTranslateX = translateX;
    this.systemKeyboardTranslateY = translateY;
  }

  /**
   * get System Keyboard Animate Scene Visible
   */
  public getAnimSceneVisible(): boolean {
    return this.animVisible;
  }

  /**
   * set System Keyboard Animate Scene Visible
   *
   * @param { Boolean } visible
   */
  public setAnimSceneVisible(visible: boolean): void {
    this.animVisible = visible;
  }

  /**
   * update Size Change Reason
   *
   * @param reason
   */
  public updateSizeChangeReason(reason: sceneSessionManager.SessionSizeChangeReason): void {
    try {
      if (this.session == null || this.session === undefined) {
        log.showError('[SCBMain]updateSizeChangeReason null session');
        return;
      }
      this.session?.updateSizeChangeReason(reason);
    } catch (err) {
      log.showError('[SCBMain]updateSizeChangeReason failed, with reason ' + JSON.stringify(err));
    }
    log.showInfo(`id:${this.session?.persistentId} updateSizeChangeReason:${reason}`);
  }

  public openKeyboardSyncTransaction(): void {
    let isOpenSyncSuccess:boolean = true;
    try {
      this.session?.openKeyboardSyncTransaction();
    } catch (err) {
      log.showError('openKeyboardSyncTransaction failed' + JSON.stringify(err));
      isOpenSyncSuccess = false;
    }
    if (isOpenSyncSuccess) {
      this.isKeyboardSyncTransactionOpen_ = true;
    }
    log.showInfo('openKeyboardSyncTransaction id: ' + this.session?.persistentId);
  }

  public closeKeyboardSyncTransaction(isKeyboardShow: boolean, withAnimation: boolean, isGravityChanged: boolean,
    beginPanelRect?: SCBSessionRect, endPanelRect?: SCBSessionRect): void {
    let callingId = this.getCallingSessionId();
    const panelRect = endPanelRect ?? this.getKeyboardPanelRealRect();
    let keyboardPanelRect: sceneSessionManager.SessionRect = panelRect.transfer2SessionRect();
    let beginRect: sceneSessionManager.SessionRect = panelRect.transfer2SessionRect();
    let endRect: sceneSessionManager.SessionRect = panelRect.transfer2SessionRect();
    if (beginPanelRect === undefined) {
      const screenHeight = SCBKeyboardPanelManager.getInstance().getScreenPropertyForKeyboardPanel()?.height ??
        (panelRect.top.getPx() + panelRect.height.getPx());
      if (isKeyboardShow) {
        beginRect.posY_ = screenHeight;
      } else {
        endRect.posY_ = screenHeight;
      }
    } else {
      beginRect = beginPanelRect.transfer2SessionRect();
    }

    let isCloseSyncSuccess:boolean = true;
    try {
      let keyboardBaseInfo = new KeyboardBaseInfo(callingId, isGravityChanged, isKeyboardShow, keyboardPanelRect);
      let keyboardAnimationRectConfig = new KeyboardAnimationRectConfig(beginRect, endRect, withAnimation);
      this.getCallingWindowInfoData();
      this.session?.closeKeyboardSyncTransaction(keyboardBaseInfo, keyboardAnimationRectConfig,
        this.callingWindowInfoData);
    } catch (err) {
      isCloseSyncSuccess = false;
      log.showError('closeKeyboardSyncTransaction failed' + JSON.stringify(err));
    }
    if (!isCloseSyncSuccess && this.isKeyboardSyncTransactionOpen_) {
      transactionManager.closeSyncTransaction(this.screenId);
    }
    this.isKeyboardSyncTransactionOpen_ = false;
    log.showInfo('closeKeyboardSyncTransaction id: ' + this.session?.persistentId);
  }

  public notifyKeyboardAnimationCompleted(callingId: number, isShowAnimation: boolean,
    panelRect: SCBSessionRect, beginPanelRect?: SCBSessionRect): void {
    if (CommonUtils.isInvalid(this.session)) {
      log.showInfo('keyboard session is invalid, notify keyboard animation completion failed');
      return;
    }

    let beginRect: sceneSessionManager.SessionRect = panelRect.transfer2SessionRect();
    let endRect: sceneSessionManager.SessionRect = panelRect.transfer2SessionRect();
    if (beginPanelRect === undefined) {
      const screenHeight = SCBKeyboardPanelManager.getInstance().getScreenPropertyForKeyboardPanel()?.height ??
        (panelRect.top.getPx() + panelRect.height.getPx());
      if (isShowAnimation) {
        beginRect.posY_ = screenHeight;
      } else {
        endRect.posY_ = screenHeight;
      }
    } else {
      beginRect = beginPanelRect.transfer2SessionRect();
    }

    try {
      this.session.notifyKeyboardAnimationCompleted(callingId, isShowAnimation, beginRect, endRect);
    } catch (err) {
      log.showError(`notify keyboard animation completion failed, code: ${err?.code}`);
    }
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
   * update keyboard Rect for screen rotation
   *
   * @param screenProperty
   */
  public updateInputRect(screenProperty: SCBScreenProperty): void {
    const screenWidth: number = screenProperty.width;
    const screenHeight: number = screenProperty.height;
    if (screenProperty.rotation === RotationConstants.ROTATION_0 ||
      screenProperty.rotation === RotationConstants.ROTATION_180) {
      this.keyboardPanelRects.setPortraitKeyboardRect(this.GetKeyboardRectByRatio(screenWidth, 
        screenHeight, PORTRAIT_KEYBOARD_HEIGHT_RATIO));
      this.keyboardPanelRects.setLandscapeKeyboardRect(this.GetKeyboardRectByRatio(screenHeight, 
        screenWidth, LANDSCAPE_KEYBOARD_HEIGHT_RATIO));
    } else {
      this.keyboardPanelRects.setPortraitKeyboardRect(this.GetKeyboardRectByRatio(screenHeight, 
        screenWidth, PORTRAIT_KEYBOARD_HEIGHT_RATIO));
      this.keyboardPanelRects.setLandscapeKeyboardRect(this.GetKeyboardRectByRatio(screenWidth, 
        screenHeight, LANDSCAPE_KEYBOARD_HEIGHT_RATIO));
    }
  }

  /**
   * update Input Rect
   *
   * @param screenProperty
   */
  public updateKeyboardRectForRotation(screenProperty: SCBScreenProperty): void {
    const screenWidth: number = screenProperty.width;
    const screenHeight: number = screenProperty.height;
    let rectForFingerprint: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    if (screenProperty.rotation === RotationConstants.ROTATION_0 ||
        screenProperty.rotation === RotationConstants.ROTATION_180) {
      let newKeyboardRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
      let newPanelRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
      SCBKeyboardPanelManager.getInstance().updateKeyboardAndPanelRect(this.session?.persistentId,
        newKeyboardRect, newPanelRect, rectForFingerprint);
      this.keyboardPanelRects.setPortraitKeyboardRect(newKeyboardRect);
      this.keyboardPanelRects.setPortraitPanelRect(newPanelRect);
    } else {
      let newKeyboardRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
      let newPanelRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
      SCBKeyboardPanelManager.getInstance().updateKeyboardAndPanelRect(this.session?.persistentId,
        newKeyboardRect, newPanelRect, rectForFingerprint);
      this.keyboardPanelRects.setLandscapeKeyboardRect(newKeyboardRect);
      this.keyboardPanelRects.setLandscapePanelRect(newPanelRect);
    }
  }

  public needRaiseKeyboard(): boolean {
    const offset = SCBKeyboardManager.getInstance().getKeyboardPosYOffset();
    const isLocked = this.isLockedForFingerprint();
    return offset !== 0 && isLocked;
  }

  public GetKeyboardBorderRadius(): number {
    const normalKeyboardBorderRadius : number = 24;
    const foldScreenKeyboardBorderRadius : number = 16;
    let borderRadius : number = 0;
    if (DeviceHelper.isPC()) {
      return borderRadius;
    }
    if (this.isFloatGravity()) {
      borderRadius = (display.isFoldable()) ? foldScreenKeyboardBorderRadius : normalKeyboardBorderRadius;
    }
    return borderRadius;
  }

  /**
   * @description: update keyboard offset
   * @param { SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null } callingSession
   */
  public updateKeyboardOffset(callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession |
    null): void {
    this.keyboardOffset = 0;
    if (callingSession instanceof SCBSceneSession) {
      callingSession.updateKeyboardOffset();
    }
  }

  /**
   * is locked for fingerprint
   *
   * @returns boolean
   */
  public isLockedForFingerprint(): boolean {
    const type = this.getCallingSession()?.session?.type;
    let isScreenLocked = SCBSceneSessionManager.getInstance().isScreenLocked();
    return type === sceneSessionManager.SessionType.TYPE_KEYGUARD || isScreenLocked;
  }

  private GetKeyboardRectByRatio(screenWidth: number, screenHeight: number, heightRatio: number): SCBSessionRect {
    let keyboardRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    keyboardRect.width.setNumber(screenWidth);
    const keyboardHeight: number = Math.floor(screenHeight * heightRatio);
    keyboardRect.height.setNumber(keyboardHeight);
    keyboardRect.top.setNumber(screenHeight - keyboardHeight);
    log.showInfo('GetKeyboardRectByRatio, rect:' + keyboardRect?.printPx());
    return keyboardRect;
  }

  private onSessionForceHideChange(hide: boolean): void {
    log.showDebug('onSessionForceHideChange, hide:' + hide);
    if (this.sessionForceHideCallback) {
      this.sessionForceHideCallback(hide);
    }
    this.keyboardChangeCallbackMap?.forEach((value, key) => {
      value?.onForceHide(hide);
    });
  }

  private onSessionStateChange(state: sceneSessionManager.SessionState): void {
    if (typeof state !== 'number') {
      log.showError('invalid state type: ' + typeof state);
      return;
    }
    if (this.session === null || this.session === undefined) {
      log.showError('session is null');
      return;
    }
    if (typeof this.session?.persistentId !== 'number') {
      log.showError('invalid id type: ' + typeof this.session?.persistentId);
      return;
    }
    log.showInfo('onSessionStateChange, id: ' + this.session?.persistentId + ', state: ' + state);
    if ((!this.isKeyboardShowing() && state === sceneSessionManager.SessionState.STATE_BACKGROUND) ||
        (state === sceneSessionManager.SessionState.STATE_ACTIVE ||
         state === sceneSessionManager.SessionState.STATE_INACTIVE)) {
      log.showInfo(`Skip state change, sessionState: ${this.sessionState}, state: ${state}`);
      return;
    }
    this.sessionData.sessionState = state;
    if (this.stateChangeCallback) {
      this.stateChangeCallback(this.session?.parentId, this.session?.persistentId, state);
    }
  };

  private onSessionTouchableChange(isTouchable: boolean): void {
    log.showInfo(`onSessionTouchableChange, state: ${isTouchable}`);
    if (this.sessionTouchableChangeCallback) {
      this.sessionTouchableChangeCallback(isTouchable);
    } 
    this.keyboardChangeCallbackMap?.forEach((value, key) => {
      value?.onSessionTouchableChange(isTouchable);
    });
    this.isTouchable = isTouchable;
  }

  private onCustomAnimationPlaying(isPlaying: boolean): void {
    log.showInfo(`onCustomAnimationPlaying, state: ${isPlaying}`);
    if (this.customAnimationPlayingCallback) {
      this.customAnimationPlayingCallback(isPlaying);
    }
    this.keyboardChangeCallbackMap?.forEach((value, key) => {
      value?.onCustomAnimationPlaying(isPlaying);
    });
  }

  public getWindowShowAnimate(): boolean {
    let screenWidth = SCBScreenSessionManager.getInstance().getMainScreenSession()?.scbScreenProperty?.width;
    let isSystemKeyboardShowAnimate = this.session?.isSystemKeyboard &&
      this.sessionGravity === sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT &&
      this.currRect.width.getPx() === screenWidth;
    return this.isWindowShowAnimate || isSystemKeyboardShowAnimate;
  }

  private onNeedDefaultAnimationFlagChange(isWindowShowAnimate: boolean): void {
    log.showInfo(`onNeedDefaultAnimationFlagChange, state: ${isWindowShowAnimate}`);
    this.isWindowShowAnimate = isWindowShowAnimate;
  }

  private setSpecialWindowCornerConfig(): void {
    let specialBoarderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius;
    log.showDebug('Set special corner radius, radius: ' + specialBoarderRadius);
    if (specialBoarderRadius > 0) {
      this.specialBoarderRadius = specialBoarderRadius;
    }
  }

  private setSpecialWindowShadowConfig(): void {
    const windowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
    let unfocusedRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.unfocusedShadow.radius;
    log.showDebug('Set special window shadow, unfocusedRadius: ' + unfocusedRadius);
    if (unfocusedRadius > 0) {
      this.shadowConfig.radius = unfocusedRadius;
      this.shadowConfig.offsetX = windowSceneConfig.unfocusedShadow.offsetX;
      this.shadowConfig.offsetY = windowSceneConfig.unfocusedShadow.offsetY;
      this.shadowConfig.color = windowSceneConfig.unfocusedShadow.color;
    }
  }

  public handleKeyboardRectChange(reason: sceneSessionManager.SessionSizeChangeReason): void {
    let panelSession = SCBKeyboardManager.getInstance().getPanelSessionById(this.session?.persistentId);
    SCBKeyboardPanelManager.getInstance().updateKeyboardAndPanelRect(this.session?.persistentId,
      this.currRect, panelSession?.currRect, this.rectForFingerprint);

    this.updateSizeChangeReason(reason);
    SCBKeyboardManager.getInstance().notifyKeyboardRectChange(this.session?.persistentId);
  }

  private handleKeyboardGravityChange(gravity: sceneSessionManager.KeyboardGravity): void {
    if (typeof gravity !== 'number') {
      log.showError('invalid gravity type: ' + typeof gravity);
      return;
    }
    this.sessionGravity = gravity;
    SCBKeyboardManager.getInstance().notifyKeyboardGravityChange(gravity);
  }

  private onAdjustKeyboardLayout(params: sceneSessionManager.KeyboardLayoutParams): void {
    if (params === null) {
      log.showInfo('keyboard layout params is null');
      return;
    }
    const lastGravity: sceneSessionManager.KeyboardGravity = this.sessionGravity;
    const beginRect = this.getKeyboardPanelRealRect();
    this.handleKeyboardGravityChange(params.gravity);

    this.keyboardPanelRects.setLandscapeAvoidHeight(params.landscapeAvoidHeight);
    this.keyboardPanelRects.setPortraitAvoidHeight(params.portraitAvoidHeight);

    let newRect :SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    newRect.setRectNum(params.landscapeKeyboardRect.posX_, params.landscapeKeyboardRect.posY_,
      params.landscapeKeyboardRect.width_, params.landscapeKeyboardRect.height_);
    this.keyboardPanelRects.setLandscapeKeyboardRect(newRect);

    newRect.setRectNum(params.portraitKeyboardRect.posX_, params.portraitKeyboardRect.posY_,
      params.portraitKeyboardRect.width_, params.portraitKeyboardRect.height_);
    this.keyboardPanelRects.setPortraitKeyboardRect(newRect);

    newRect.setRectNum(params.landscapePanelRect.posX_, params.landscapePanelRect.posY_,
      params.landscapePanelRect.width_, params.landscapePanelRect.height_);
    this.keyboardPanelRects.setLandscapePanelRect(newRect);

    newRect.setRectNum(params.portraitPanelRect.posX_, params.portraitPanelRect.posY_,
      params.portraitPanelRect.width_, params.portraitPanelRect.height_);
    this.keyboardPanelRects.setPortraitPanelRect(newRect);

    log.showInfo('landscapeKeyboardRect: ' + this.keyboardPanelRects.getLandscapeKeyboardRect().printPx() +
      ', portraitKeyboardRect: ' + this.keyboardPanelRects.getPortraitKeyboardRect().printPx() +
      ', landscapePanelRect: ' + this.keyboardPanelRects.getLandscapePanelRect().printPx() +
      ', portraitPanelRect: ' + this.keyboardPanelRects.getPortraitPanelRect().printPx() +
      ', gravity: ' + this.sessionGravity + ', id: ' + this.session?.persistentId +
      ', screenId: ' + this.screenId + ', displayId: ' + params.displayId);

    if (params.displayId !== undefined && params.displayId !== INVALID_SCREEN_ID && params.displayId !== this.screenId) {
      SCBKeyboardManager.getInstance().notifyKeyboardAcrossDisplay(this.session?.persistentId, params.displayId);
    }

    if (this.isKeyboardShowing()) {
      this.handleKeyboardRectChange(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      if (lastGravity !== this.sessionGravity) {
        const callingId = this.getCallingSessionId();
        const panelRect = this.getKeyboardPanelRealRect();
        const isShowAnimation: boolean = (this.sessionGravity === sceneSessionManager.KeyboardGravity.GRAVITY_BOTTOM);
        this.closeKeyboardSyncTransaction(isShowAnimation, false, true, beginRect);
        this.notifyKeyboardAnimationCompleted(callingId, isShowAnimation, panelRect, beginRect);
      }
    }
  }

  private notifyKeyboardStateChange(state: number): void {
    let callingScreenId = SCBKeyboardManager.getInstance().getCallingSessionScreenId();
    const apsSceneStart: number = 1;
    const apsSceneEnd: number = 0;
    log.showInfo(`notifyKeyboardStateChange, state is: ${state}, callingScreenId is: ${callingScreenId},
      mainScreenId is: ${SCBSceneSessionManager.getInstance().mainScreenId}`);
    if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
      this.handleKeyboardRectChange(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      HiDfxEventUtil.reportKeyboardShowHide(HiSysDataShowHide.SHOW);
    } else if (state === sceneSessionManager.SessionState.STATE_BACKGROUND) {
      HiDfxEventUtil.reportKeyboardShowHide(HiSysDataShowHide.HIDE);
      // input_method scene 结束 必须在输入法隐藏动效触发前下发
      // ApsUtils.setApsScene(apsManager.SceneAnimation.INPUT_METHOD, apsSceneEnd);
    }
    // 针对callingsessionId为0的场景，虚拟屏上无法收到statechange，输入法无法收起的情况，兜底通知所有屏幕。
    if (state === sceneSessionManager.SessionState.STATE_DISCONNECT ||
      state === sceneSessionManager.SessionState.STATE_BACKGROUND) {
      this.onSessionStateChange(state);
      this.onVirtualScreenStateChange(callingScreenId, state);
      return;
    }
    if (callingScreenId === SCBSceneSessionManager.getInstance().mainScreenId) {
      this.onSessionStateChange(state);
    } else {
      this.onVirtualScreenStateChange(callingScreenId, state);
    }

    // input_method scene 开始 必须在输入法显示动效触发后下发
    if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.INPUT_METHOD, apsSceneStart);
    }
  }

  private onVirtualScreenStateChange(srceenId: number, state: sceneSessionManager.SessionState): void {
    this.keyboardChangeListenerList.forEach((keyboardChangeCallback) => {
        keyboardChangeCallback?.onVirtualScreenStateChange?.(srceenId, this.session?.persistentId, state);
    });
  }

  public setKeyboardRotationFlag(isRotating: boolean): void {
    this.sessionData.isRotating = isRotating;
  }

  public IsNeedOpenSyncTransaction(curIsActive: boolean, isActive: boolean): boolean {
    if (this.isRotating) {
      return false;
    }

    if (this.isFloatGravity()) {
      log.showInfo('No need open transaction, keyboard in floating state.');
      return false;
    }

    if (isActive === true && curIsActive === isActive) {
      log.showInfo('No need open transaction, keyboard is not rebuild');
      return false;
    }

    let callingSession = this.getCallingSession();
    if (CommonUtils.isInvalid(callingSession)) {
      log.showInfo('No need open transaction, callingSession is null or undefined');
      return false;
    }
    if (callingSession instanceof SCBSystemSceneSession) {
      log.showInfo('No need open transaction, callingSession is SCBSystemSceneSession');
      return false;
    }
    if (!callingSession?.isSessionForeground()) {
      log.showInfo('No need open transaction, callingSession not foreground, state: ' +
        callingSession?.sessionData?.sessionState);
      return false;
    }

    return true;
  }

  public getParentComponentId(): number {
    return this.sessionData.parentComponentId;
  }

  public setParentComponentId(parentComponentId: number): void {
    this.sessionData.parentComponentId = parentComponentId;
  }

  /**
   * @description: Get callingId of keyboard.
   * @return: number
   */
  public getCallingSessionId(): number {
    return this.sessionData.callingSessionId;
  }

  /**
   * @description: Set callingId of keyboard.
   */
  public setCallingSessionId(callingSessionId: number):void {
    this.sessionData.callingSessionId = callingSessionId;
  }

  /**
   * @description: Get calling session of keyboard
   * @returns: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession
   */
  public getCallingSession(): SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null {
    return this.sessionData.callingSession;
  }

  public setCallingSession(callingSession: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null): void {
    this.sessionData.callingSession = callingSession;
  }

  /**
   * @description: update keyboard Enable Show
   * @param isEnableShow
   */
  public updateKeyboardEnableShow(isEnableShow: boolean): void {
    if (isEnableShow === false) {
      if (this.sessionData.containerSession instanceof SCBSceneContainerSession) {
        log.showInfo('isKeyboardEnableShow old: ' + this.sessionData.containerSession.isKeyboardEnableShow +
          ', new: ' + isEnableShow);
        this.sessionData.containerSession.isKeyboardEnableShow = isEnableShow;
        this.sessionData.containerSession = null;
      }
      return;
    }
    let containerSession = SCBKeyboardManager.getInstance().getSceneContainerSessionForKeyboard(
      this.sessionData.callingSessionId);
    if (!CommonUtils.isInvalid(containerSession)) {
      log.showInfo('callingId: ' + this.sessionData.callingSessionId + ', isKeyboardEnableShow old: ' +
        containerSession.isKeyboardEnableShow + ', new: ' + isEnableShow);
      containerSession.isKeyboardEnableShow = isEnableShow;
      this.sessionData.containerSession = containerSession;
    } else {
      log.showInfo('callingSession not found in all containers, callingId: ' + this.sessionData.callingSessionId);
    }
  }

  public clearContainerSessionRecordInKeyboard(containerId?: number): void {
    if (this.sessionData.containerSession instanceof SCBSceneContainerSession &&
      this.sessionData.containerSession.containerId === containerId) {
      log.showInfo('reset container session in keyboard when destruction');
      this.sessionData.containerSession.isKeyboardEnableShow = false;
      this.sessionData.containerSession = null;
    }
  }

  public getKeyboardPanelTranslateY(): number {
    const panelRect = this.getKeyboardPanelRealRect();
    const screenProperty = SCBScreenSessionManager.getInstance().getMainScreenSession()?.scbScreenProperty;
    let translatePosY: number = panelRect?.height.getPx();
    if (this.needRaiseKeyboard() && screenProperty !== null && screenProperty !== undefined) {
      translatePosY = screenProperty.height - this.rectForFingerprint?.top.getPx();
    }

    return translatePosY;
  }

  public getKeyboardPanelRealRect(): SCBSessionRect {
    let panelRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    const panelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (CommonUtils.isInvalid(panelSession)) {
      log.showWarn('Panel session is null');
      return panelRect;
    }
    const panelRealHeight = panelSession.getPanelRealHeight();
    panelRect.copyFrom(panelSession.currRect);
    if (panelRect.height.getPx() > panelRealHeight) {
      const panelRealRect: SCBSessionRect = new SCBSessionRect(panelRect.left.getPx(),
        panelRect.top.getPx() + panelRect.height.getPx() - panelRealHeight, panelRect.width.getPx(), panelRealHeight);
      return panelRealRect;
    } else {
      return panelRect;
    }
  }

  public isRectAbnormal(isActive:boolean, screenProperty: SCBScreenProperty, panelRect: SCBSessionRect): boolean {
    // When the bottom-attached keyboard is hidden, if the keyboard rect is abnormal, disable the hide animation.
    if (!isActive && !this.isFloatGravity() && screenProperty?.width > panelRect.width.getPx()) {
      log.showInfo(`Disable hide animation, screenWidth: ${screenProperty?.width}, panelRect: ${panelRect.printPx()}`);
      return true;
    }
    return false;
  }
}
interface CallingWindowInfoData {
  callingWindowState: number;
  scaleX: number;
  scaleY: number;
}

// ✅ 添加这两个类定义
class KeyboardBaseInfo {
  callingId: number;
  isGravityChanged: boolean;
  isKeyboardShow: boolean;
  keyboardPanelRect: sceneSessionManager.SessionRect;

  constructor(
    callingId: number,
    isGravityChanged: boolean,
    isKeyboardShow: boolean,
    keyboardPanelRect: sceneSessionManager.SessionRect
  ) {
    this.callingId = callingId;
    this.isGravityChanged = isGravityChanged;
    this.isKeyboardShow = isKeyboardShow;
    this.keyboardPanelRect = keyboardPanelRect;
  }
}

class KeyboardAnimationRectConfig {
  beginRect: sceneSessionManager.SessionRect;
  endRect: sceneSessionManager.SessionRect;
  animated: boolean;

  constructor(
    beginRect: sceneSessionManager.SessionRect,
    endRect: sceneSessionManager.SessionRect,
    animated: boolean
  ) {
    this.beginRect = beginRect;
    this.endRect = endRect;
    this.animated = animated;
  }
}