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

import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import inputMethod from '@ohos.inputMethod';
import keyboardPanelManager from '@ohos.keyboardPanelManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { display } from '@kit.ArkUI';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBSessionRect } from './SCBSessionRect';
import { SCBSystemSceneSession, SystemSessionInfo } from './SCBSystemSceneSession';
import { SCBSceneSessionManager, INVALID_SCREEN_ID } from './SCBSceneSessionManager';
import { SCBKeyboardManager, KeyboardChangeCallback, KEYBOARD_STATE_MAP } from './SCBKeyboardManager';
import { SCBScreenSessionManager, SCBPropertyChangeReason } from '../../screen/session/SCBScreenSessionManager';
import { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { SCBKeyboardPanelSession } from './SCBKeyboardPanelSession';
import { SCBKeyboardSession } from './SCBKeyboardSession';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

export const TOOLBAR_FLOAT_HEIGHT: number = 48;
export const FOLD_EXPAND_TOOLBAR_HEIGHT: number = 45;
export const PHONE_TOOLBAR_PORTRAIT_WIDTH: number = 88;
export const PHONE_TOOLBAR_PORTRAIT_WIDTH_FLOAT: number = 50;
export const FOLD_EXPAND_TOOLBAR_WIDTH: number = 210;
export const FOLD_EXPAND_TOOLBAR_LAND_WIDTH: number = 232;
export const PHONE_ONE_HANDED_WIDTH: number = 38;
export const PHONE_TOOLBAR_LANDSCAPE_WIDTH: number = 60;
export const PHONE_TOOLBAR_LANDSCAPE_BANGS_WIDTH: number = 100;
export const PHONE_TOOLBAR_LANDSCAPE_HEIGHT: number = 28;
export const PHONE_TOOLBAR_PORTRAIT_HEIGHT: number = 45;
export const PHONE_TOOLBAR_IMAGE_MARGIN: number = 10;
export const FOLD_EXPAND_TOOLBAR_IMAGE_MARGIN: number = 9;
export const PHONE_TOOLBAR_LANDSCAPE_IMAGE_MARGIN: number = 27;
export const TOOLBAR_FLOAT_IMAGE_MARGIN: number = 8;
const SWITCH_IONPUT_METHOD_DELAY: number = 1200;
export const KEYBOARD_CONFIG = 'etc/inputmethod/inputmethod_framework_config.json';
const TAG = 'SCBKeyboardPanelManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export interface KeyboardBarParams {
  unexpand: KeyboardBarOption;
  expand?: KeyboardBarOption;
  float?: KeyboardBarOption;
  leftOneHand?: KeyboardBarOption;
  rightOneHand?: KeyboardBarOption;
}

export interface KeyboardBarOption {
  landscapeLeftElevateDistance: number,
  landscapeRightElevateDistance: number,
  landscapeElevateHeight: number,
  portraitLeftElevateDistance: number,
  portraitRightElevateDistance: number,
  portraitElevateHeight: number,
}

export interface SysPanelAdjustParameter {
  style: Array<string>,
  top: number,
  left: number,
  right: number,
  bottom: number
}

export interface HotArea {
  top: number,
  left: number,
  right: number,
  bottom: number,
}

enum InputType {
  NONE = -1,
  CAMERA_INPUT = 0,
  SECURITY_INPUT = 1,
  VOICE_INPUT = 2
}

const InputTypePostfix = {
  [InputType.NONE]: '_commonKeyboard',
  [InputType.CAMERA_INPUT]: '_previewScanInputKeyboard',
  [InputType.SECURITY_INPUT]: '_inputPwdKeyboard',
  [InputType.VOICE_INPUT]: '_inputVoiceKeyboard',
};

/**
 * Keyboard panel manager
 */
export class SCBKeyboardPanelManager {
  private screenProperty: SCBScreenProperty;
  private panelDialogSession: SCBSystemSceneSession;
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
  private dialogInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_FLOAT,
    sceneName: 'SCBKeyboardDialog',
    sceneZIndex: -1,
    isFocusable: false,
    isTouchable: true,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
    isRotatable: true,
    isOverlayScene: true
  };
  private dialogChangeCallback: Function;
  private pauseFlowLightCallback: Function | undefined;
  private hotAreaMap: Map<string, HotArea> = new Map();
  private hotAreaInfo: HotArea;
  private isKeyboardFlowLight: boolean = false;
  public keyboardBarParams: KeyboardBarParams;
  /**
    * get default display Sync
    * 
    * @returns {display.Display}
    */
  public getDefaultDisplaySync( ): display.Display {
    try {
      let defaultDisplay: display.Display = display.getDefaultDisplaySync();
      return defaultDisplay;
    } catch (error) {
      log.showError(`getDefaultDisplaySync failed, message: ${error.message}`);
      return null;
    }
  }

  /**
   * set smart menu list selected status
   * @param smartType
   * @param isSelected
   * @returns 
   */
  public setSmartMode(smarKey: string, isSelected: boolean): void {
    let smartSelected = AppStorage.get('smartSelected') as Map<string, boolean>;
    if (smartSelected?.has(smarKey)) {
      smartSelected.set(smarKey, isSelected);
      AppStorage.setOrCreate('smartSelected', smartSelected);
    }
  }

  /**
  * reset smart menu list selected status
  * @param smartType
  * @param isSelected
  * @returns 
  */
  public resetSmartMode(keys: string[]): void {
    let smartSelected: Map<string, boolean> = new Map();
    for (let i = 0; i < keys.length; i++) {
      smartSelected.set(keys[i], false);
    }
    AppStorage.setOrCreate('smartSelected', smartSelected);
  }

  /**
  * send smart menu mode to input method
  * @param smartType
  * @param smarKey
  * @param isNeedSwitch
  * @returns 
  */
  public async sendSmartType(smarKey: string, isNeedSwitch: boolean): Promise<void> {
    if (isNeedSwitch) {
      try {
        let defaultInputMethod = inputMethod.getDefaultInputMethod();
        await inputMethod.switchInputMethod(defaultInputMethod);
      } catch (err) {
        let error: BusinessError = err as BusinessError;
        log.showError(`sendSmartType, switchInputMethod error =  ${error.code}, message = ${error.message}`);
      }
      setTimeout(()=>{
        this.setSmartType(smarKey);
      }, SWITCH_IONPUT_METHOD_DELAY);
    } else {
      this.setSmartType( smarKey);
    }
  }

  private setSmartType(smarKey: string): void {
    log.showInfo(`setSmartType smarKey: ${smarKey}`);
    let privateCommand: Record<string, keyboardPanelManager.CommandDataType> = {
      'sys_cmd': 1
    };
    privateCommand[smarKey] = 'open';
    try {
      keyboardPanelManager.sendPrivateCommand(privateCommand);
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      log.showError(`sendSmartType error =  ${error.code}, message = ${error.message}`);
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
    this.updateFlowLightMode(keyboardPanelSession, keyboardEffectOption);
    log.showInfo(`ViewMode: ${keyboardPanelSession.keyboardViewMode},` + `blurHeight: ${keyboardEffectOption.blurHeight},` +
      `FlowLightMode: ${this.isKeyboardFlowLight},` + `GradientMode : ${keyboardPanelSession.isGradientMode}`);
  }

  private updateIsGradientMode(keyboardPanelSession: SCBKeyboardPanelSession,
    keyboardEffectOption: sceneSessionManager.KeyboardEffectOption): void {
      if (keyboardEffectOption.gradientMode === sceneSessionManager.KeyboardGradientMode.LINEAR_GRADIENT) {
        keyboardPanelSession.isGradientMode = true;
      } else {
        keyboardPanelSession.isGradientMode = false;
      }
  }

  private updateFlowLightMode(keyboardPanelSession: SCBKeyboardPanelSession,
    keyboardEffectOption: sceneSessionManager.KeyboardEffectOption): void {
    if (keyboardEffectOption.flowLightMode === sceneSessionManager.KeyboardFlowLightMode.BACKGROUND_FLOW_LIGHT) {
      keyboardPanelSession.isFlowLightMode = true;
    } else {
      keyboardPanelSession.isFlowLightMode = false;
    }
    this.isKeyboardFlowLight = keyboardPanelSession.isFlowLightMode;
  }

  /**
    * is flow light mode
    * 
    * @returns {boolean}
    */
  public isFlowLightMode(): boolean {
    return this.isKeyboardFlowLight;
  }

  /**
    * get pad border radius
    * 
    * @returns {number}
    */
  public GetPadBorderRadius(): number {
    const padKeyboardBorderRadius : number = 24;
    let borderRadius : number = 0;
    let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (!(keyboardSession instanceof SCBKeyboardSession )) {
      log.showError('keyboardSession is null');
      return borderRadius;
    }
    if (DeviceHelper.isPad() && keyboardSession?.isFloatGravity()) {
      log.showInfo(`GetPadBorderRadius: ${padKeyboardBorderRadius}`);
      return padKeyboardBorderRadius;
    }
    return borderRadius;
  }
  
  private async loadKeyboardConfigFile(): Promise<void> {
    try {
      let filePathArray: Array<string> = await configPolicy.getCfgFiles(KEYBOARD_CONFIG);
      filePathArray?.forEach((filePath: string)=>{
        let configStr: string = fs.readTextSync(filePath);
        this.ParsingConfigFile(configStr);
      });
    } catch (error) {
      log.showError(`loadKeyboardConfigFile exception: ${error.message}`);
    }
    log.showInfo('loadKeyboardConfigFile end');
  }

  private ParsingConfigFile(configStr: string): void {
    if (configStr) {
      let jsonArray = JSON.parse(configStr);
      if (jsonArray === null || jsonArray === undefined) {
        return;
      }
      if (jsonArray.keyboardBarParams) {
        this.keyboardBarParams = jsonArray.keyboardBarParams;
      }
      log.showInfo(`portraitLeftDistance: ${this.keyboardBarParams.unexpand.portraitLeftElevateDistance},` +
        `portraitRightDistance: ${this.keyboardBarParams.unexpand.portraitRightElevateDistance},` +
        `portraitElevateHeight: ${this.keyboardBarParams.unexpand.portraitElevateHeight}`);
      jsonArray.sysPanelAdjust?.forEach((item: SysPanelAdjustParameter)=>{
        let hotArea: HotArea = {top: item.top, left: item.left, right: item.right, bottom: item.bottom};
        let hotAreaKey = '';
        item.style?.forEach((it: string)=>{
          hotAreaKey = hotAreaKey + it;
        });
        this.hotAreaMap.set(hotAreaKey, hotArea);
      });
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
    await this.loadKeyboardConfigFile();
  }

  public getLandImageColumnWidth(): number {
    if (this.bangsHeight > 0) {
      return PHONE_TOOLBAR_LANDSCAPE_BANGS_WIDTH;
    }
    return PHONE_TOOLBAR_LANDSCAPE_WIDTH;
  }

  public getBangsHeight(): number {
    return px2vp(this.bangsHeight);
  }

  public isShowThumbAndFloatKeyboard(): boolean {
    return SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  }

  registerDialogChangeCallback(callback: Function): void {
    this.dialogChangeCallback = callback;
  }

  unRegisterDialogChangeCallback(): void {
    this.dialogChangeCallback = null;
  }

  /**
   * register pause flow light callback for keyboardScene
   *
   * @param callback
   */
  public registerPauseFlowLightCallback(callback: Function): void {
    this.pauseFlowLightCallback = callback;
  }

  /**
   * unregister pause flow light callback for keyboardScene
   */  
  public unRegisterPauseFlowLightCallback(): void {
    this.pauseFlowLightCallback = undefined;
  }

  /**
   * set softkeyboard window skip self when on virtual screen
   *
   *  @param isFlowLightPause
   */
  public pauseFlowLight(isFlowLightPause: boolean): void {
    if (this.pauseFlowLightCallback) {
      this.pauseFlowLightCallback(isFlowLightPause);
    } 
  }

  public setPanelDialogShow(isShowDialog: boolean): void {
    if (this.dialogChangeCallback) {
      this.dialogChangeCallback(isShowDialog);
    }
    this.setPanelDialogVisibility(isShowDialog);
  }
  
  public setPanelDialogVisibility(visibility: boolean): void {
    if (CommonUtils.isInvalid(this.panelDialogSession)) {
      let screenId = SCBSceneSessionManager.getInstance().mainScreenId !== INVALID_SCREEN_ID ? 
        SCBSceneSessionManager.getInstance().mainScreenId : 0;
      this.panelDialogSession = SCBSceneSessionManager.getInstance().requestSystemSceneSession(
      this.dialogInfo, null, false, screenId) as SCBSystemSceneSession;
      this.panelDialogSession.setSkipSelfWhenShowOnVirtualScreen(true);
    }
    if (this.panelDialogSession?.session !== undefined && this.panelDialogSession?.session !== null) {
      if (this.panelDialogSession?.visibility !== visibility) {
        this.panelDialogSession?.setVisibility(visibility);
        this.publishDialogCommond(visibility);
      }
    }
  }

  private publishDialogCommond(visibility: boolean): void {
    let privateCommand: Record<string, keyboardPanelManager.CommandDataType> = {
      'sys_cmd': 1,
      'keyboardPanelDialog': visibility ? 'show' : 'hide'
    };
    try {
      keyboardPanelManager.sendPrivateCommand(privateCommand);
    } catch (err) {
      log.showError('sendPrivateCommand error = ' + JSON.stringify(err));
    }
  }

  public getPanelDialogSession(): SCBSystemSceneSession {
    return this.panelDialogSession;
  }
  
  /**
    * is default input method
    * 
    * @returns {boolean}
    */
  private isDefaultInputMethod(): boolean {
    try {
      let currentInputMethod = inputMethod.getCurrentInputMethod();
      let defaultInputMethodName: string = keyboardPanelManager.getDefaultInputMethod()?.name;
      if (currentInputMethod?.name !== defaultInputMethodName) {
        return false;
      }
      return true;
    } catch (error) {
      log.showError(`isDefaultInputMethod failed, message: ${error.message}`);
      return false;
    }
  }
  
  public onKeyboardStateChange(state: sceneSessionManager.SessionState): void {
    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();
    if (keyboardPanelSession?.session !== undefined && keyboardPanelSession?.session !== null) {
      if (state === sceneSessionManager.SessionState.STATE_FOREGROUND) {
        if (!this.isDefaultInputMethod()) {
          keyboardPanelSession?.resetPanelBar();
        }
        keyboardPanelSession?.setVisibility(true);
        this.updateLanscapeState(keyboardPanelSession);
        keyboardPanelSession?.connectSystemCmd();
      } else {
        keyboardPanelSession?.setVisibility(false);
        keyboardPanelSession?.resetPanelBar();
      }
      if (state === sceneSessionManager.SessionState.STATE_DISCONNECT) {
        keyboardPanelSession?.resetFunctionKeyColor();
      }
    }
  }

  public getHotAreaInfo(): HotArea {
    return this.hotAreaInfo;
  }

  private updateHotAreaInfo(keyboardSession: SCBKeyboardSession, keyboardPanelSession: SCBKeyboardPanelSession): void {
    let hotAreaKey = this.generateHotAreaKey(keyboardPanelSession?.isLandscape, keyboardSession?.isFloatGravity());
    log.showInfo(`hotAreaKey: ${hotAreaKey}`);
    if (this.hotAreaMap?.has(hotAreaKey)) {
      this.hotAreaInfo = this.hotAreaMap?.get(hotAreaKey) as HotArea;
    } else {
      this.hotAreaInfo = {top: 0, left: 0, right: 0, bottom: 0};  
      log.showWarn(`Could not find hotAreaKey: ${hotAreaKey}`);
    }
    keyboardPanelSession.hotAreaBottom = this.hotAreaInfo.bottom;
    log.showInfo(`this.hotAreaInfo.left: ${this.hotAreaInfo?.left},` + `this.hotAreaInfo.right: ${this.hotAreaInfo?.right},` +
      `this.hotAreaInfo.bottom: ${this.hotAreaInfo?.bottom},` + `panelRealHeight: ${keyboardPanelSession.getPanelRealHeight()}`);
  }

  private generateHotAreaKey(isLandscape: boolean, isFloatGravity: boolean): string {
    let key = '';
    if (isFloatGravity) {
      key = key + 'floating';
    } else {
      key = key + 'fix';
    }
    
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      key = key + 'foldable';
    } else {
      key = key + 'default';
    }
  
    if (isLandscape) {
      key = key + 'landscape';
    } else {
      key = key + 'portrait';
    }
    return key;
  }

  private onScreenPropertyChange(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    if (screenProperty === undefined || screenProperty === null) {
      log.showError(`onScreenPropertyChange, screenProperty is null`);
      return;
    }
    log.showInfo('panelManager, onScreenPropertyChange, screenProperty ' + screenProperty + ', reason: ' + reason);
    this.notifyTargetScreenRotation(screenProperty);
    if (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason === SCBPropertyChangeReason.EXPAND_TO_FOLD ||
      reason === SCBPropertyChangeReason.ROTATION || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
      reason === SCBPropertyChangeReason.PAGE_ROTATION) {
      this.setPanelDialogShow(false);
    }
    let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
    let keyboardPanelSession = SCBKeyboardManager.getInstance().getPanelSession();  
    if (!(keyboardSession instanceof SCBKeyboardSession && keyboardPanelSession instanceof SCBKeyboardPanelSession)) {
      log.showError('onScreenPropertyChange, keyboardSession or keyboardPanelSession is null');
      return;
    }
    this.updateHotAreaInfo(keyboardSession, keyboardPanelSession);
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
      this.updateHotAreaInfo(keyboardSession, keyboardPanelSession);
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