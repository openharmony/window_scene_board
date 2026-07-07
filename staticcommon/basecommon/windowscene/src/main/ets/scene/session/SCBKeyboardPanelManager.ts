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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { display } from '@kit.ArkUI';
import { SCBSessionRect } from './SCBSessionRect';
import { SCBSystemSceneSession, SystemSessionInfo } from './SCBSystemSceneSession';
import { SCBKeyboardManager, KeyboardChangeCallback, KEYBOARD_STATE_MAP } from './SCBKeyboardManager';
import { SCBScreenSessionManager, SCBPropertyChangeReason } from '../../screen/session/SCBScreenSessionManager';
import { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { SCBKeyboardPanelSession } from './SCBKeyboardPanelSession';
import { SCBKeyboardSession } from './SCBKeyboardSession';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBKeyboardPanelManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Keyboard panel manager
 */
export class SCBKeyboardPanelManager {
  private screenProperty: SCBScreenProperty;
  private bangsHeight: number = 0; // hole screen height
  private panelInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_KEYBOARD_PANEL,
    sceneName: 'SCBKeyboardPanel',
    sceneZIndex: -1,
    isFocusable: false,
    isTouchable: true,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
    isRotatable: true,
    isOverlayScene: true, // need to delete
  };

  /**
   * get default display Sync
   *
   * @returns {display.Display}
   */
  public getDefaultDisplaySync(): display.Display | undefined {
    try {
      let defaultDisplay: display.Display = display.getDefaultDisplaySync();
      return defaultDisplay;
    } catch (error) {
      log.showError(`getDefaultDisplaySync failed, message: ${error.message}`);
      return undefined;
    }
  }

  /*
   * callback of session rect change, used for keyboardScene
   */
  private rectChangeCallbackOfKeyboardSceneMap: Map<number, Function> = new Map<number, Function>();
  /**
   * register rect change callback for keyboardScene
   *
   * @param callback
   */
  public registerRectChangeCallbackOfKeyboardScene(sessionId: number, callback: Function): void {
    // register keyboard rect change callback
    this.rectChangeCallbackOfKeyboardSceneMap.set(sessionId, callback);
  }
  
  /**
    * unregister rect change callback for keyboardScene
    */
  public unregisterRectChangeCallbackOfKeyboardScene(sessionId: number): void {
    // unregister keyboard rect change callback
    if (this.rectChangeCallbackOfKeyboardSceneMap.has(sessionId)) {
      this.rectChangeCallbackOfKeyboardSceneMap.delete(sessionId);
    }
  }

  /**
  * set softkeyboard window skip self when on virtual screen
  * @param keyboardSession
  * @param keyboardPanelSession
  * @returns Promise<void>
  */
  public async setSkipSelfWhenShowOnVirtualScreen(keyboardSession: SCBKeyboardSession,
    keyboardPanelSession: SCBKeyboardPanelSession): Promise<void> {
    if (!DeviceHelper.isPad() && !DeviceHelper.isPhone() && !DeviceHelper.isPC()) {
      log.showWarn(`setSkipSelfWhenShowOnVirtualScreen not phone, pad or pc`);
      return;
    }
    if (!(keyboardSession instanceof SCBKeyboardSession)) {
      log.showError(`setSkipSelfWhenShowOnVirtualScreen keyboardSession is null`);
      return;
    }
    if (!(keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
      log.showError(`setSkipSelfWhenShowOnVirtualScreen keyboardPanelSession is null`);
      return;
    }
    try {
      if (keyboardSession.session !== undefined || keyboardSession.session !== null) {
        keyboardSession.session.setSkipSelfWhenShowOnVirtualScreen(true);
        log.showInfo('keyboardSession setSkipSelfWhenShowOnVirtualScreen finish');
      }
      keyboardPanelSession.setSkipSelfWhenShowOnVirtualScreen(true);
    } catch (err) {
      log.showError('setSkipSelfWhenShowOnVirtualScreen failed.');
    }
  }

  /**
  * set softkeyboard window skip event on cast plus
  * @param keyboardSession
  * @param keyboardPanelSession
  * @returns Promise<void>
  */
  public async setSkipEventOnCastPlus(keyboardSession: SCBKeyboardSession,
    keyboardPanelSession: SCBKeyboardPanelSession): Promise<void> {
    if (!DeviceHelper.isPad() && !DeviceHelper.isPhone()) {
      log.showWarn(`setSkipEventOnCastPlus not phone or pad`);
      return;
    }
    if (!(keyboardSession instanceof SCBKeyboardSession)) {
      log.showError(`setSkipEventOnCastPlus keyboardSession is null`);
      return;
    }
    if (!(keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
      log.showError(`setSkipEventOnCastPlus keyboardPanelSession is null`);
      return;
    }
    try {
      if (keyboardSession.session !== undefined || keyboardSession.session !== null) {
        keyboardSession.session.setSkipEventOnCastPlus(true);
        log.showInfo('keyboardSession setSkipEventOnCastPlus finish');
      }
      keyboardPanelSession.setSkipEventOnCastPlus(true);
    } catch (err) {
      log.showError('setSkipEventOnCastPlus failed.');
    }
  }

  /**
    * @description: Update Keyboard view model
    *
    */
  public updateKeyboardEffectOption(keyboardSessionId: number,
    keyboardEffectOption: sceneSessionManager.KeyboardEffectOption): void {
    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSessionById(keyboardSessionId);
    if (!(keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
      log.showError('keyboardPanelSession is null');
      return;
    }
    if (keyboardEffectOption === null || keyboardEffectOption === undefined) {
      log.showError('keyboardEffectOption is null');
      return;
    }
    keyboardPanelSession.keyboardViewMode = keyboardEffectOption.viewMode;
    this.updateIsGradientMode(keyboardPanelSession, keyboardEffectOption);
    log.showInfo(`ViewMode: ${keyboardPanelSession.keyboardViewMode}, blurHeight: ${keyboardEffectOption.blurHeight},` +
      `GradientMode : ${keyboardPanelSession.isGradientMode}`);
  }

  private updateIsGradientMode(keyboardPanelSession: SCBKeyboardPanelSession,
    keyboardEffectOption: sceneSessionManager.KeyboardEffectOption): void {
      if (keyboardEffectOption.gradientMode === sceneSessionManager.KeyboardGradientMode.LINEAR_GRADIENT) {
        keyboardPanelSession.isGradientMode = true;
      } else {
        keyboardPanelSession.isGradientMode = false;
      }
  }

  public getPanelSessionInfo(): SystemSessionInfo {
    return this.panelInfo;
  }

  constructor() {
    this.initScreenInfo();
  }

  /**
   * @description: Get the singleton of the keyboard manager.
   */
  static getInstance(): SCBKeyboardPanelManager {
    if (!globalThis.SCBKeyboardPanelManagerInstance) {
      globalThis.SCBKeyboardPanelManagerInstance = new SCBKeyboardPanelManager();
    }
    return globalThis.SCBKeyboardPanelManagerInstance;
  }

  public onMainScreenConnected(screenProperty: SCBScreenProperty): void {
    if (screenProperty === undefined || screenProperty === null) {
      log.showError(`onMainScreenConnected, screenProperty is null`);
      return;
    }
    this.screenProperty = screenProperty;
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty,
      reason: SCBPropertyChangeReason) => {
      this.onScreenPropertyChange(screenProperty, reason);
    });
  }

  public updateScreenPropertyForKeyboardPanel(screenProperty: SCBScreenProperty): void {
    if (screenProperty === undefined || screenProperty === null) {
      log.showError(`updateScreenPropertyForKeyboardPanel, screenProperty is null`);
      return;
    }
    this.screenProperty = screenProperty;
  }

  public getScreenPropertyForKeyboardPanel(): SCBScreenProperty {
    return this.screenProperty;
  }

  private async initScreenInfo(): Promise<void> {
    let defaultDisplay = this.getDefaultDisplaySync();
    if (defaultDisplay === undefined || defaultDisplay == null) {
      log.showWarn('defaultDisplay is null');
      return;
  }
    let cutInfo = await defaultDisplay.getCutoutInfo();
    log.showInfo(`initBangsScreen,cutInfo ${JSON.stringify(cutInfo)}}`);
    let bHeight = Number.parseInt(cutInfo?.boundingRects[0]?.height?.toString()) || 0;
    let bTop = Number.parseInt(cutInfo?.boundingRects[0]?.top?.toString()) || 0;
    this.bangsHeight = bHeight + bTop;
  }

  public getBangsHeight(): number {
    return px2vp(this.bangsHeight);
  }

  public isShowThumbAndFloatKeyboard(): boolean {
    return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  public onKeyboardStateChange(state: sceneSessionManager.SessionState): void {
    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (keyboardPanelSession?.session !== undefined && keyboardPanelSession?.session !== null) {
      if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
        keyboardPanelSession?.setVisibility(true);
        this.updateLanscapeState(keyboardPanelSession);
      } else {
        keyboardPanelSession?.setVisibility(false);
      }
    }
  }

  private onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    if (screenProperty === undefined || screenProperty === null) {
      log.showError(`onScreenPropertyChange, screenProperty is null`);
      return;
    }
    log.showInfo('panelManager, onScreenPropertyChange, screenProperty ' + screenProperty + ', reason: ' + reason);
    this.notifyTargetScreenRotation(screenProperty);
  }

  /**
   * @description: Get is phone landscape status
   *
   * @returns {boolean}
   */
  public isPhoneLand(): boolean {
    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    return keyboardPanelSession?.isLandscape && !keyboardPanelSession?.isExpandStatus;
  }

  private updateLanscapeState(keyboardPanelSession: SCBKeyboardPanelSession): void {
    let deviceIsLandscape = DeviceHelper.isLandscape();
    if (keyboardPanelSession.isLandscape !== deviceIsLandscape) {
      log.showWarn(`KeyboardPanelSession.isLandscape: ${keyboardPanelSession.isLandscape},` + 
        `DeviceHelper.isLandscape: ${deviceIsLandscape}`);
      keyboardPanelSession.isLandscape = deviceIsLandscape;
    }
  }
  
  public notifyTargetScreenRotation(screenProperty: SCBScreenProperty, keyboardSessionId?: number): void {
    let keyboardPanelSession: SCBKeyboardPanelSession | undefined = undefined;
    if (keyboardSessionId) {
      keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSessionById(keyboardSessionId);
    } else {
      keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    }
    if (!CommonUtils.isInvalid(keyboardPanelSession)) {
      if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
        keyboardPanelSession.isExpandStatus = true;
      } else {
        keyboardPanelSession.isExpandStatus = false;
      }
      keyboardPanelSession.isLandscape = DeviceHelper.isLandscape();
      log.showInfo(`screenProperty.rotation: ${screenProperty?.rotation},` +
        `keyboardPanelSession.isLandscape: ${keyboardPanelSession.isLandscape}`);
    }
  }

  private isValidParam(keyboardSession: SCBKeyboardSession, keyboardPanelSession: SCBKeyboardPanelSession,
    keyboardRect: SCBSessionRect, panelRect: SCBSessionRect, rectForFingerprint: SCBSessionRect): boolean {
    if (!(keyboardSession instanceof SCBKeyboardSession && keyboardPanelSession instanceof SCBKeyboardPanelSession &&
      keyboardRect instanceof SCBSessionRect && panelRect instanceof SCBSessionRect &&
      rectForFingerprint instanceof SCBSessionRect)) {
      log.showWarn('updateRectForFingerPrint, rect is null');
      return false;
    }
    return true;
  }

  /**
    * @description: Update the PC keyboard and do not include the virtual keyboard of the hopper device.
    */
  private updatePcKeyboardRect(keyboardSession: SCBKeyboardSession, keyboardRect: SCBSessionRect, panelRect: SCBSessionRect): void {
    let defaultDisplay = this.getDefaultDisplaySync();
    if (defaultDisplay === undefined || defaultDisplay == null) {
        log.showWarn('defaultDisplay is null');
        return;
    }
    log.showInfo(`updatePcKeyboardRect, width = ${defaultDisplay.width},` + `height = ${defaultDisplay.height}`);
    if (defaultDisplay.width < defaultDisplay.height) {
      keyboardRect?.copyFrom(keyboardSession?.keyboardPanelRects.getPortraitKeyboardRect());
      panelRect?.copyFrom(keyboardSession?.keyboardPanelRects.getPortraitPanelRect());
    } else {
      keyboardRect?.copyFrom(keyboardSession?.keyboardPanelRects.getLandscapeKeyboardRect());
      panelRect?.copyFrom(keyboardSession?.keyboardPanelRects.getLandscapePanelRect());
    }
  }

  /**
    * @description: Is hopper device virtual keyboard.
    * 
    * @returns {boolean}
    */
  private isSystemVirtualKeyboard(keyboardSession: SCBKeyboardSession): boolean {
    let systemKeyboardSession = SCBKeyboardManager.getInstance().getSystemKeyboardSession();
    if (systemKeyboardSession === undefined || systemKeyboardSession === null) {
      log.showInfo(`systemKeyboardSession is undefined, not hopper device virtual keyboard.`);
      return false;
    }
    if (systemKeyboardSession.session?.persistentId === keyboardSession.session?.persistentId) {
      log.showInfo(`is hopper device virtual keyboard.`);
      return true;
    }
    return false;
  }

  private updateKeyboardInfoFromAjustParams(keyboardSession: SCBKeyboardSession, keyboardPanelSession: SCBKeyboardPanelSession,
    keyboardRect: SCBSessionRect, panelRect: SCBSessionRect): void {
    log.showInfo(`updateKeyboardInfoFromAjustParams, state = ${keyboardSession.sessionData.sessionState}, ` +
      `isLandScape: ${keyboardPanelSession?.isLandscape}`);
    // Deleted after the DMS provides a unified interface for determining landscape and portrait mode.
    if (DeviceHelper.isPC() && !this.isSystemVirtualKeyboard(keyboardSession)) {
      this.updatePcKeyboardRect(keyboardSession, keyboardRect, panelRect);
      return;
    } 
    let panelHeight = 0;
    let panelAdjustHeight = 0;
    if (keyboardPanelSession?.isLandscape) {
      keyboardRect?.copyFrom(keyboardSession?.keyboardPanelRects.getLandscapeKeyboardRect());
      panelRect?.copyFrom(keyboardSession?.keyboardPanelRects.getLandscapePanelRect());
      panelHeight = keyboardSession?.keyboardPanelRects.getLandscapeAvoidHeight();
      panelAdjustHeight = keyboardSession?.keyboardPanelRects.getLandscapePanelRect().height.getPx();
    } else {
      keyboardRect?.copyFrom(keyboardSession?.keyboardPanelRects.getPortraitKeyboardRect());
      panelRect?.copyFrom(keyboardSession?.keyboardPanelRects.getPortraitPanelRect());
      panelHeight = keyboardSession?.keyboardPanelRects.getPortraitAvoidHeight();
      panelAdjustHeight = keyboardSession?.keyboardPanelRects.getPortraitPanelRect().height.getPx();
    }
    keyboardPanelSession?.setPanelRealHeight(panelHeight);
    keyboardPanelSession?.setPanelAdjustHeight(panelAdjustHeight);
  }

  /**
   * Calculate soft keyboard and panel rect
   * @param keyboardSessionId 
   * @param keyboardRect 
   * @param panelRect 
   * @param rectForFingerprint 
   * @returns 
   */
  public calculateKeyboardAndPanelRect(keyboardSessionId: number, keyboardRect: SCBSessionRect,
    panelRect: SCBSessionRect, rectForFingerprint: SCBSessionRect): void {
      let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSessionById(keyboardSessionId);
      let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSessionById(keyboardSessionId);
      if (!this.isValidParam(keyboardSession, keyboardPanelSession, keyboardRect, panelRect, rectForFingerprint)) {
        log.showError('caculateKeyboardAndPanelRect, param is invalid');
        return;
      }
      if (this.screenProperty === undefined || this.screenProperty === null ) {
        log.showInfo('screenProperty is nullptr, get from main screen session.');
        this.screenProperty = SCBScreenSessionManager.getInstance().getMainScreenSession()?.scbScreenProperty;
      }
      this.notifyTargetScreenRotation(this.screenProperty, keyboardSessionId);
      this.updateKeyboardInfoFromAjustParams(keyboardSession, keyboardPanelSession, keyboardRect, panelRect);
      SCBKeyboardManager.getInstance().updateRectForFingerPrint(SCBKeyboardManager.getInstance().getKeyboardPosYOffset(),
        panelRect, rectForFingerprint);
        log.showInfo(`updateKeyboardAndPanel,keyboardRect: ${keyboardRect?.printPx()}, panelRect: ` +
        `${panelRect?.printPx()}, rectForFingerprint: ${rectForFingerprint?.printPx()}, isFloat: ` + 
        `${keyboardSession?.isFloatGravity()}`);
  }

  /**
   * Trigger keyboard and panel rect refresh
   * @param keyboardSessionId 
   * @param keyboardRect 
   * @param panelRect 
   * @param rectForFingerprint 
   * @returns 
   */
  public updateKeyboardAndPanelRect(sessionId: number, keyboardRect: SCBSessionRect, panelRect: SCBSessionRect,
    rectForFingerprint: SCBSessionRect): void {
    if (DeviceHelper.isPC()) {
      let rectChangeCallbackOfKeyboardScene = this.rectChangeCallbackOfKeyboardSceneMap.get(sessionId);
      if (rectChangeCallbackOfKeyboardScene) {
        WinLog.showInfo(WinLogDomain.WMS_LAYOUT, 'rectChangeCallback is exists');
        rectChangeCallbackOfKeyboardScene(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
      } else {
        SCBKeyboardPanelManager.getInstance().calculateKeyboardAndPanelRect(sessionId, keyboardRect, panelRect, rectForFingerprint);
      }
    } else {
      let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSessionById(sessionId);
      if (CommonUtils.isInvalid(keyboardSession)) {
        log.showWarn('keyboardSession is undeifned');
        return;
      }
      let keyboardChangeCallbackMap = SCBKeyboardManager.getInstance().getKeyboardChangeCallbackMap();
      let currCallback: KeyboardChangeCallback | null = null;
      const curKeyboardState = SCBKeyboardManager.getInstance().getKeyboardState();
      keyboardChangeCallbackMap?.forEach((value, key) => {
        if (KEYBOARD_STATE_MAP.get(key) === curKeyboardState) {
          currCallback = value;
          return;
        }
      });
      if (currCallback !== null && (keyboardSession?.sessionState === sceneSessionManager.SessionState.STATE_FOREGROUND)) {
        currCallback?.onRectChangeChange({ posX_: 0, posY_: 0, width_: 0, height_: 0 }, sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
        log.showInfo(`RectChangeCallback exists, id: ${keyboardSession?.session.persistentId}` + 
          `, currRect: ${keyboardSession?.currRect.printPx()}, callbackSize: ${keyboardChangeCallbackMap?.size}`);
        let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSessionById(sessionId);
        if (CommonUtils.isInvalid(keyboardPanelSession)) {
          log.showError('keyboardPanelSession is undeifned');
          return;
        }
        this.updateKeyboardInfoFromAjustParams(keyboardSession, keyboardPanelSession, keyboardRect, panelRect);  
      } else {
        SCBKeyboardPanelManager.getInstance().calculateKeyboardAndPanelRect(sessionId, keyboardRect, panelRect, rectForFingerprint);
      }
    }
  }
}