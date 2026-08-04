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

import performanceMonitor from '@ohos.arkui.performanceMonitor';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper, ObjUtil } from '@ohos/basicutils';
import { RotationConstants, SceneConstants } from '@ohos/commonconstants';
import { GlobalSearchStatus, sOutSideWindowMgr } from '@ohos/frameworkwrapper';
import inputMethodUtil from './SCBInputMethodUtil';
import {
  SCBSessionRect,
  SCBKeyboardSession,
  SCBScreenProperty,
  SCBKeyboardManager,
  KeyboardState,
  SCBScreenSessionManager,
  SCBKeyboardPanelSession,
  KEYBOARD_STATE_MAP,
  KeyboardChangeCallback,
  SCBKeyboardPanelManager,
  SCBSpecificSession,
  SCBPropertyChangeReason,
  SCBSystemSceneSession
} from '@ohos/windowscene';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import { SCBSpecificZIndex } from '../scenemanager/SCBSpecificScene';
import { FoldExpandAnimUtils, FoldAnimationConstants } from '@ohos/launchercommon/Index';
import { uiEffect } from '@kit.ArkGraphics2D';

const TAG: string = 'SCBIMFKeyboardPanel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const NO_BORDER_RADIUS: number = 0;
const BLUR_RADIUS: number = 600;
const GRADIENT_RATIO: number = 0.3;

interface PositionOptions {
  x: string;
  y: string;
}

interface SizeOptions {
  width: string;
  height: string;
}

class KeyboardCommon {
  public static getZIndex(keyboardSession: SCBKeyboardSession): number {
    // input method need specific zOrder
    switch (SCBKeyboardManager.getInstance().getKeyboardState()) {
      case KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE: {
        return SCBDefaultZIndex.INPUT_METHOD_BELOW_KEYGUARD;
      }
      case KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE: {
        let callingSession = keyboardSession?.getCallingSession();
        if (callingSession instanceof SCBSpecificSession &&
            callingSession.session?.type === sceneSessionManager.SessionType.TYPE_VOICE_INTERACTION) {
          return SCBDefaultZIndex.INPUT_METHOD_SPECIFIC_VOICE_INTERACTION;
        }
        if (callingSession instanceof SCBSystemSceneSession &&
            callingSession.zIndex >= SCBDefaultZIndex.SCREEN_LOCK &&
            callingSession.zIndex < SCBDefaultZIndex.SPECIFIC_VOICE_INTERACTION) {
          return SCBDefaultZIndex.INPUT_METHOD_SPECIFIC_VOICE_INTERACTION;
        }
        return SCBDefaultZIndex.INPUT_METHOD_ABOVE_KEYGUARD;
      }
      case KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE: {
        return SCBSpecificZIndex.INPUT_METHOD_ABOVE_SPLIT_SCENE;
      }
      default:
        return 0;
    }
  }
}

@Component
export struct SCBKeyboard {
  @Link screenProperty: SCBScreenProperty;
  @State translateX: number = 0;
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @ObjectLink panelRect: SCBSessionRect;
  @ObjectLink keyboardRect: SCBSessionRect;
  private sessionState: sceneSessionManager.SessionState = sceneSessionManager.SessionState.STATE_BACKGROUND;
  name: string = '';

  private hideAnimationInterruption(): void {
    log.showInfo(`Interrupt animation`);
    if (ObjUtil.isValid(this.keyboardSession)) {
      this.keyboardSession.isActive = false;
    }
  }

  showKeyboard(): boolean {
    if (ObjUtil.isInvalid(this.keyboardSession)) {
      log.showWarn('enable show is false, keyboardSession is null');
      return false;
    }

    const keyboardState: KeyboardState = SCBKeyboardManager.getInstance().getKeyboardState();
    if (KEYBOARD_STATE_MAP.get(this.name) === keyboardState && this.keyboardSession.isActive) {
      log.showInfo('ShowKeyboard id: ' + this.keyboardSession.session?.persistentId +
       ', name: ' + this.name + ', rect: ' + this.keyboardRect?.printPx());
      this.sessionState = this.keyboardSession.sessionData?.sessionState;
      return true;
    }
    this.sessionState = this.keyboardSession.sessionData?.sessionState;
    log.showInfo('HideKeyboard id: ' + this.keyboardSession.session?.persistentId + ', name: ' + this.name);
    return false;
  }

  aboutToAppear(): void {
    this.keyboardSession?.addRefCount();
    log.showInfo('Keyboard aboutToAppear, id: ' + this.keyboardSession?.session.persistentId + ', name: ' +
      this.name + ', currRect: ' + this.keyboardSession?.currRect?.printPx() + ', rectForFingerprint: ' +
      this.keyboardSession?.rectForFingerprint?.printPx() + ', refCount: ' + this.keyboardSession?.getRefCount());

    SCBKeyboardManager.getInstance().registerKeyboardTranslateChangeCallback(this.screenPropertyChangeCallbacks)
    SCBKeyboardManager.getInstance().registerHideAnimationInterruptionCallback(this.hideAnimationInterruption);
  }

  aboutToDisappear() {
    this.keyboardSession?.decRefCount();
    SCBKeyboardManager.getInstance().unRegisterKeyboardTranslateChangeCallback();
    SCBKeyboardManager.getInstance().unregisterHideAnimationInterruptionCallback();
    log.showInfo(`Keyboard aboutToDisappear, name: ${this.name}, refCount: ${this.keyboardSession?.getRefCount()}`);
  }

  private screenPropertyChangeCallbacks: Function =
    (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
      if ((sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.SHOW ||
        sOutSideWindowMgr.getGlobalSearchStatus() === GlobalSearchStatus.FOCUSED) &&
        (reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason == SCBPropertyChangeReason.EXPAND_TO_FOLD)) {
        let keyboardStatus = this.showKeyboard();
        log.showInfo(TAG, 'screenPropertyChangeCallbacks', 'keyboard status', keyboardStatus);
        const IS_SUPPORT_FOLD_EFFECT: boolean = FoldExpandAnimUtils.isSupportProduct;
        if (keyboardStatus) {
          this.translateX =
            IS_SUPPORT_FOLD_EFFECT ? 0 : FoldAnimationConstants.FOLD_FACTOR * px2vp(screenProperty?.width || 0);
          animateTo({
            curve: FoldAnimationConstants.TRANSLATE_CURVES,
          }, () => {
            this.translateX = 0;
          })
        }
      }
    }

  @Builder
  keyboardBuilder() {
    WindowScene(this.keyboardSession?.session.persistentId)
      .id(`keyboard${this.keyboardSession?.session.persistentId}`)
      .position({
        x: String(this.keyboardRect?.left.getPx() - this.panelRect?.left.getPx()) + 'px',
        y: this.keyboardSession?.needRaiseKeyboard() ? '0px' :
          String(this.keyboardRect?.top.getPx() - this.panelRect?.top.getPx()) + 'px'
      })
      .size({
        width: this.keyboardRect?.width.getPxSizeStr(),
        height: this.keyboardRect?.height.getPxSizeStr()
      })
      .zIndex(1)
  }

  @Styles
  keyboardLayoutParams() {
    .position({
      x: this.panelRect?.left.getPxStr(),
      y: (this.keyboardSession?.needRaiseKeyboard() ? this.keyboardSession?.rectForFingerprint?.top.getPx() :
          this.panelRect?.top.getPx()) + this.keyboardSession?.keyboardOffset + 'px'
    })
    .size({
      width: this.panelRect?.width.getPxStr(),
      height: this.panelRect?.height.getPxStr()
    })
    .translate({ y: this.keyboardSession?.translatePosY + 'px', x: this.translateX })
  }

  getKeyboardBackgroundColor(): Resource {
    if (inputMethodUtil.isEnableImmersive(this.keyboardPanelSession?.keyboardViewMode)) {
      return $r('app.color.keyboard_immersive_color');
    }  
    return $r('app.color.keyboard_transparent_color');
  }

  private getGradientHeight(): number {
    let gradientHeight = this.keyboardPanelSession?.getPanelRealHeight() * GRADIENT_RATIO;
    return gradientHeight;
  }

  @Builder 
  immersiveBackground() {
    if (inputMethodUtil.isEnableImmersive(this.keyboardPanelSession?.keyboardViewMode)) {
      Stack() {}
      .width(this.panelRect.width.getPxStr())
      .height(this.keyboardPanelSession?.getPanelRealHeight() + 'px')
      .backgroundEffect({ policy: 1, radius: 60 }, { disableSystemAdaptation: true })
    }
    Stack() {}
    .width(this.panelRect.width.getPxStr())
    .height(this.keyboardPanelSession?.getPanelRealHeight() + 'px')
    .backgroundColor(this.getKeyboardBackgroundColor())
    .advancedBlendMode(inputMethodUtil.getPanelImmersiveMode(this.keyboardPanelSession?.keyboardViewMode))
  }

  @Builder 
  gradientBackground() {
    Stack({ alignContent: Alignment.Bottom }) {}
    .width(this.panelRect.width.getPxStr())
    .height(this.keyboardPanelSession?.getPanelRealHeight() + 'px')
    .compositingFilter(uiEffect.createFilter().radiusGradientBlur(BLUR_RADIUS, { 
      fractionStops: [[0, 0], [1, 0.25], [1, 1]], direction: GradientDirection.Bottom }))
    Stack() {}
    .width(this.panelRect.width.getPxStr())
    .height(this.keyboardPanelSession?.getPanelRealHeight() + 'px')
    .linearGradient({
      direction: GradientDirection.Bottom,
        colors: [[Color.Transparent, 0], [Color.Black, 0.25], [Color.Black, 1]] })
    .advancedBlendMode(inputMethodUtil.getPanelImmersiveMode(this.keyboardPanelSession?.keyboardViewMode))
  }
 
  @Builder
  keyboardBackgroundBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.keyboardPanelSession?.isGradientMode) {
        this.gradientBackground();
      } else {
        this.immersiveBackground();
      }
    }
    .width('100%')
    .height('100%')
  }

  GetKeyboardBorderRadius(): number {
    if (inputMethodUtil.isEnableImmersive(this.keyboardPanelSession?.keyboardViewMode)) {
      return this.keyboardSession?.GetKeyboardBorderRadius();
    }
    return NO_BORDER_RADIUS;
  }    

  @Builder
  keyboardPanelBuilder() {
    WindowScene(this.keyboardPanelSession?.session.persistentId) {
      this.keyboardBackgroundBuilder();
      if (this.keyboardRect?.height.getPx() > 0) {
        this.keyboardBuilder();
      }
    }
    .zIndex(KeyboardCommon.getZIndex(this.keyboardSession))
    .keyboardLayoutParams()
    .id(`keyboardPanel${this.keyboardPanelSession?.session.persistentId}`)
    .visibility(this.keyboardSession?.visibility ? Visibility.Visible : Visibility.Hidden)
    .focusable(this.keyboardPanelSession?.isFocusable)
    .hitTestBehavior(this.keyboardPanelSession?.isTouchable ? HitTestMode.Default : HitTestMode.None)
    .borderRadius(this.GetKeyboardBorderRadius())
    .clip(this.keyboardSession?.isFloatGravity() ? true : false)
    .transition(TransitionEffect.IDENTITY)
    .shadow(this.keyboardPanelSession?.panelShadow?.radius > 0 ?
      {
        radius: this.keyboardPanelSession?.panelShadow?.radius,
        color: this.keyboardPanelSession?.panelShadow?.color,
        offsetX: this.keyboardPanelSession?.panelShadow?.offsetX,
        offsetY: this.keyboardPanelSession?.panelShadow?.offsetY
      }: { radius: 0 })
  }

  build() {
    if (this.showKeyboard()) {
      this.keyboardPanelBuilder();
    }
  }
}

@Component
export struct SCBKeyboardPanel {
  @Link screenProperty: SCBScreenProperty;
  @Link keyboardState: KeyboardState;
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @ObjectLink panelRect: SCBSessionRect;
  @ObjectLink keyboardRect: SCBSessionRect;
  private rectChangeTag: boolean = false;
  private name: string = '';

  private needRotation(): boolean {
    // only input method not in panel need rotate
    if (this.keyboardState === KeyboardState.SHOW_IN_BELOW_SPECIFIC_SCENE ||
      this.keyboardState === KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE ||
      this.keyboardState === KeyboardState.SHOW_IN_ABOVE_SPLIT_SCENE) {
      log.showInfo('Rotate the input method in BelowSpecificScene or AboveSpecificScene.');
      return true;
    }
    return false;
  }

  private getKeyboardPanelPositionOptions(): PositionOptions {
    let option: PositionOptions = {
      x: this.screenProperty?.left + this.screenProperty?.getTranslateX() + 'px',
      y: this.screenProperty?.top + this.screenProperty?.getTranslateY() + 'px'
    };
    let callingSession = this.keyboardSession?.getCallingSession();
    if (callingSession instanceof SCBSystemSceneSession) {
      option.x = callingSession.transformRect.left.getPxStr();
      option.y = callingSession.transformRect.top.getPxStr();
    }
    log.showDebug('getKeyboardPanelPositionOptions: ' + JSON.stringify(option));
    return option;
  }

  private getKeyboardPanelSizeOptions(): SizeOptions {
    let option: SizeOptions = {
      width: this.screenProperty?.width + 'px',
      height: this.screenProperty?.height + 'px'
    };
    let callingSession = this.keyboardSession?.getCallingSession();
    if (callingSession instanceof SCBSystemSceneSession) {
      option.width = callingSession.transformRect.width.getPxSizeStr();
      option.height = callingSession.transformRect.height.getPxSizeStr();
    }
    log.showDebug('getKeyboardPanelSizeOptions: ' + JSON.stringify(option));
    return option;
  }

  private getKeyboardPanelRotateOptions(): RotateOptions {
    let option: RotateOptions = {
      x: 0,
      y: 0,
      z: 1,
      angle: -this.screenProperty?.rotation,
      centerX: '50%',
      centerY: '50%'
    };
    let callingSession = this.keyboardSession?.getCallingSession();
    if (callingSession instanceof SCBSystemSceneSession) {
      option.angle = -callingSession.rotation;
    }
    log.showDebug('getKeyboardPanelRotateOptions: ' + JSON.stringify(option));
    return option;
  }

  private onKeyboardRectChange(): void {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      log.showError('[SCBKeyboardPanel] Input session is null');
      this.rectChangeTag = true;
      return;
    }

    if (KEYBOARD_STATE_MAP.get(this.name) !== this.keyboardState) {
      log.showInfo('No need to response rect change, name: ' + this.name +
        ' currKeyboardState: ' + this.keyboardState);
      return;
    }

    log.showInfo('onKeyboardRectChange, id: ' + this.keyboardSession?.session.persistentId +
      ', currRect: ' + this.keyboardSession?.currRect.printPx());
    this.calculateKeyboardAndPanelRect();

    log.showInfo('recalculate panel, keyboardRect: ' + this.keyboardRect?.printPx());
  }

  private keyboardChangeCallback: KeyboardChangeCallback = {
    onRectChangeChange: (rect: sceneSessionManager.SessionRect,
      reason: sceneSessionManager.SessionSizeChangeReason) => {
      this.onKeyboardRectChange();
    },
   
    onSessionTouchableChange: (isTouchable: boolean) => {
      log.showInfo('onSessionTouchableChange, isTouchable: ' + isTouchable);
      this.keyboardSession?.setTouchable(isTouchable);
    },
   
    onCustomAnimationPlaying: (isPlaying: boolean) => {
      log.showInfo('IsCustomAnimationPlaying, isPlaying: ' + isPlaying);
      this.keyboardSession.isCustomAnimationPlaying = isPlaying;
    },
   
    onForceHide: (hide: boolean) => {
      log.showInfo('onForceHide ' + hide);
      this.keyboardSession.visibility = !hide;
    },
   
    getZIndex: (): number => {
      return KeyboardCommon.getZIndex(this.keyboardSession);
    },

    onKeyboardGravityChange: (sessionGravity: sceneSessionManager.KeyboardGravity): void => {
      log.showDebug('onKeyboardGravityChange function not implemented.');
    },

    onVirtualScreenStateChange: (
      screenId: number, persistentId: number, state: sceneSessionManager.SessionState): void => {
      log.showDebug('onVirtualScreenStateChange function not implemented.');
    },

    onCallingSessionChange: (callingSessionId: number): void => {
      log.showDebug('onCallingSessionChange function not implemented.');
    }
  }

  private calculateKeyboardAndPanelRect() : void {
    let newKeyboardRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let newPanelRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    let rectForFingerprint: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    SCBKeyboardPanelManager.getInstance().calculateKeyboardAndPanelRect(this.keyboardSession?.session.persistentId,
      newKeyboardRect, newPanelRect, rectForFingerprint);
    this.keyboardRect?.copyFrom(newKeyboardRect);
    this.panelRect?.copyFrom(newPanelRect);
    this.keyboardSession?.rectForFingerprint?.copyFrom(rectForFingerprint);
    log.showInfo('HandleKeyboardRectChange, keyboardRect: ' + this.keyboardRect?.printPx() +
      ', panelRect: ' + this.panelRect?.printPx() + 
      ', rectForFingerprint: ' + this.keyboardSession?.rectForFingerprint?.printPx());
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear, name:' + this.name + ', keyboardRect:' +
      this.keyboardSession?.currRect.printPx() + ', panelRect:' + this.panelRect?.printPx());
    SCBKeyboardManager.getInstance().registerKeyboardChangeCallback(this.name, this.keyboardChangeCallback);
    this.keyboardSession?.setSpecialWindowEffectConfig();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear, name:' + this.name);
    SCBKeyboardManager.getInstance().unRegisterRectChangeCallbackOfKeyboardPanel(this.name);
  }

  updateKeyboardRect() {
    if (!(this.keyboardSession instanceof SCBKeyboardSession)) {
      log.showError('[SCBKeyboardPanel] Input session is null');
      return;
    }
    if (this.rectChangeTag) {
      this.onKeyboardRectChange();
      this.rectChangeTag = false;
    }
  }

  enableShow(): Boolean {
    this.updateKeyboardRect();
    if (ObjUtil.isInvalid(this.keyboardSession)) {
      log.showWarn('enable show is false, keyboardSession is null');
      return false;
    }

    if (KEYBOARD_STATE_MAP.get(this.name) == this.keyboardState && this.keyboardSession.isActive) {
      log.showInfo('enableShow, newState: ' + this.keyboardState + ', name: ' + this.name +
        ', isActive: ' + this.keyboardSession.isActive);
      return true;
    } else {
      log.showInfo('disableShow, newState: ' + this.keyboardState + ', curState: ' +
        KEYBOARD_STATE_MAP.get(this.name) + ', name: ' + this.name + ', isActive: ' + this.keyboardSession.isActive);
      return false;
    }
  }

  @Builder
  systemKeyboardStackBuilder() {
    WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
      SCBKeyboard({
        screenProperty: $screenProperty,
        keyboardSession: this.keyboardSession,
        keyboardPanelSession: this.keyboardPanelSession,
        keyboardRect: this.keyboardSession?.currRect,
        panelRect: this.keyboardPanelSession?.currRect,
        name: this.name
      })
    }
    .id(`SCBSystemKeyBoardTransScene${this.keyboardSession?.session.persistentId}`)
    .zIndex(KeyboardCommon.getZIndex(this.keyboardSession))
    .position(this.getKeyboardPanelPositionOptions())
    .size(this.getKeyboardPanelSizeOptions())
    .rotate(this.getKeyboardPanelRotateOptions())
    .hitTestBehavior(HitTestMode.None)
  }

  build() {
    if (this.enableShow()) {
      if (this.needRotation()) {
        this.systemKeyboardStackBuilder();
      } else {
        SCBKeyboard({
          screenProperty: $screenProperty,
          keyboardSession: this.keyboardSession,
          keyboardPanelSession: this.keyboardPanelSession,
          keyboardRect: this.keyboardSession?.currRect,
          panelRect: this.keyboardPanelSession?.currRect,
          name: this.name
        })
      }
    }
  }
}