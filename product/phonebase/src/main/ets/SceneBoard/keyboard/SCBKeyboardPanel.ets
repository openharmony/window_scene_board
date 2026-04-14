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
import I18n from '@ohos.i18n';
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
import { SCBKeyboardPanelBar } from './SCBKeyboardPanelBar';
import { SCBKeyboardDialog } from './SCBKeyboardDialog';
import { FoldExpandAnimUtils, FoldAnimationConstants } from '@ohos/launchercommon/Index';
import { uiEffect } from '@kit.ArkGraphics2D';
import lazy { SectorComponent } from './SectorComponent';
import {
  // HdsVisualComponent,
  // HdsSceneController,
  // HdsSceneType,
  // hdsEffect
} from '@kit.UIDesignKit';

const TAG: string = 'SCBIMFKeyboardPanel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const KEYBOARD_PANEL_COLOR: Resource = $r('app.color.keyboard_panel_background_color');
const NO_BORDER_RADIUS: number = 0;
const BLUR_RADIUS: number = 600;
const BLEND_SRC_OVER: number = 1000;
const BLEND_SRC_IN: number = 6;
const DOUBLE_TWO_SIZE : number = 2;
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
  @State isShowDialog: boolean = false;
  @State dialogType: string = 'left';
  @State dialogOffset: number[] = [0, 0];
  @State translateX: number = 0;
  // @State sceneController: HdsSceneController = new HdsSceneController();
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @ObjectLink panelRect: SCBSessionRect;
  @ObjectLink keyboardRect: SCBSessionRect;
  @State isShowSector: boolean = true;
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
      if (this.sessionState !== this.keyboardSession.sessionData?.sessionState) {
        this.isShowSector = this.keyboardPanelSession?.isFlowLightMode;
      }
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
    SCBKeyboardPanelManager.getInstance().registerDialogChangeCallback((isShowDialog: boolean) => {
      log.showInfo('dialog change , isShowDialog = ' + isShowDialog);
      this.isShowDialog = isShowDialog;
    })

    SCBKeyboardPanelManager.getInstance().registerPauseFlowLightCallback(this.pauseFlowLightEffect);
    SCBKeyboardManager.getInstance().registerKeyboardTranslateChangeCallback(this.screenPropertyChangeCallbacks)
    SCBKeyboardManager.getInstance().registerHideAnimationInterruptionCallback(this.hideAnimationInterruption);
  }

  aboutToDisappear() {
    this.keyboardSession?.decRefCount();
    SCBKeyboardManager.getInstance().unRegisterKeyboardTranslateChangeCallback();
    SCBKeyboardPanelManager.getInstance().unRegisterDialogChangeCallback();
    SCBKeyboardManager.getInstance().unregisterHideAnimationInterruptionCallback();
    SCBKeyboardPanelManager.getInstance().unRegisterPauseFlowLightCallback();
    log.showInfo(`Keyboard aboutToDisappear, name: ${this.name}, refCount: ${this.keyboardSession?.getRefCount()}`);
  }


  private pauseFlowLightEffect: Function = (isFlowLightPause: boolean) => {
    if (isFlowLightPause) {
      // this.sceneController.pause();
    } 
    log.showInfo(`Pause keyboard flow light effect, isFlowLightPause: ${isFlowLightPause}`);
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
    return this.keyboardPanelSession.isShowPanel ? KEYBOARD_PANEL_COLOR : $r('app.color.keyboard_transparent_color');
  }

  @Builder
  keyboardFlowLighEffect() {
    Stack() {
      Stack()
      .linearGradient({
        direction: GradientDirection.Bottom,
          colors: [[Color.Transparent, 0], [Color.Black, 0.15], [Color.Black, 1]] })
      .width(this.panelRect.width.getPxStr())
      .height(this.keyboardPanelSession?.getPanelRealHeight() + 'px')
      /*HdsVisualComponent()
      .scene(inputMethodUtil.isDarkImmersive(this.keyboardPanelSession?.keyboardViewMode) ? 
        HdsSceneType.UV_FLOWLIGHT_KEYBOARD_DARK : HdsSceneType.UV_FLOWLIGHT_KEYBOARD_LIGHT,
           this.sceneController, () => { },
             { expected: hdsEffect.FrameRateType.FRAME_RATE_15, min: hdsEffect.FrameRateType.FRAME_RATE_15,
               max: hdsEffect.FrameRateType.FRAME_RATE_15 })
      .blendMode(BLEND_SRC_IN)
      .width((this.panelRect.width.getPx() * DOUBLE_TWO_SIZE) + 'px')
      .height((this.keyboardPanelSession?.getPanelRealHeight() * DOUBLE_TWO_SIZE) + 'px')*/
    }
    .blendMode(BLEND_SRC_OVER, BlendApplyType.OFFSCREEN)
    .width(this.panelRect.width.getPxStr())
    .height(this.keyboardPanelSession?.getPanelRealHeight() + 'px')
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
  flowLighBackground() {
    Stack({ alignContent: Alignment.Top }) {
      this.keyboardFlowLighEffect();
      if (this.isShowSector) {
        SectorComponent({
          isShowSector: $isShowSector,
          sectorHeight: this.keyboardPanelSession?.getPanelRealHeight(),
          panelRect: this.panelRect,
          keyboardPanelSession: this.keyboardPanelSession});
      }
      Stack() {}
      .width(this.panelRect.width.getPxStr())
      .height(this.getGradientHeight() + 'px')
      .compositingFilter(uiEffect.createFilter().radiusGradientBlur(BLUR_RADIUS, { 
        fractionStops: [[0, 0], [1, 0.7], [0, 1]], direction: GradientDirection.Bottom }))
    }
    .width(this.panelRect.width.getPxStr())
    .height(this.keyboardPanelSession?.getPanelRealHeight() + 'px')
  }
 
  @Builder
  keyboardBackgroundBuilder() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.keyboardPanelSession?.isGradientMode && !this.keyboardPanelSession?.isFlowLightMode) {
        this.gradientBackground();
      }
      if (!this.keyboardPanelSession?.isGradientMode) {
        this.immersiveBackground();
      }
    }
    .width('100%')
    .height('100%')
  }

  GetKeyboardBorderRadius(): number {
    if (this.keyboardPanelSession?.isShowPanel) {
      return this.keyboardSession?.GetKeyboardBorderRadius();
    }
    if (inputMethodUtil.isEnableImmersive(this.keyboardPanelSession?.keyboardViewMode)) {
      return SCBKeyboardPanelManager.getInstance().GetPadBorderRadius();
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
      if (this.keyboardPanelSession?.isPanelBarShow && this.keyboardPanelSession?.hotAreaBottom > 0) {
        SCBKeyboardPanelBar({
          keyboardSession: this.keyboardSession,
          keyboardPanelSession: this.keyboardPanelSession,
          panelRect: this.panelRect,
          screenProperty: $screenProperty,
          dialogType: $dialogType,
          dialogOffset: $dialogOffset,
          isShowDialog: $isShowDialog
        })
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
  }

  getDialogOffset(): Padding {
    let isRTL = I18n.isRTL(I18n.System.getSystemLanguage());
    if ((this.dialogType === 'right' && !isRTL) || (this.dialogType === 'left' && isRTL)) {
      return { left: 0, right: this.dialogOffset[0], bottom: this.dialogOffset[1] };
    } else {
      return { left: this.dialogOffset[0], right: 0, bottom: this.dialogOffset[1]}
    }
  }

  @Builder
  dialogBuilder() {
    WindowScene(SCBKeyboardPanelManager.getInstance().getPanelDialogSession()?.session.persistentId) {
      Row() {
        if (this.dialogType === 'right') {
          Blank()
        }
        SCBKeyboardDialog({
          gravity: this.keyboardSession?.sessionGravity,
          dialogType: $dialogType,
          screenProperty: $screenProperty,
          isShowDialog: $isShowDialog,
          keyboardPanelSession: this.keyboardPanelSession
        })
      }
      .alignItems(VerticalAlign.Bottom)
      .size({ width: this.screenProperty?.width + 'px', height: this.screenProperty?.height + 'px' })
      .padding(this.getDialogOffset())
      .accessibilityText(this.dialogType === 'right' ? $r('app.string.keyboard_smart_menu_access_text')
        : $r('app.string.keyboard_switch_menu_access_text'))
      .onClick(() => {
        this.isShowDialog = false;
        SCBKeyboardPanelManager.getInstance().setPanelDialogVisibility(this.isShowDialog);
      })
    }
    .zIndex(KeyboardCommon.getZIndex(this.keyboardSession))
    .size({ width: this.screenProperty?.width + 'px', height: this.screenProperty?.height + 'px' })
    .id(`SCBKeyboardDialog${SCBKeyboardPanelManager.getInstance().getPanelDialogSession()?.session.persistentId}`)
    .visibility(this.isShowDialog ? Visibility.Visible : Visibility.Hidden)
    .transition(TransitionEffect.OPACITY.animation({ duration: 150, curve: '0.4, 0, 0.2, 1' }).
      combine(TransitionEffect.translate({ y: 30 })))
    .focusable(true)
    .hitTestBehavior(HitTestMode.Default)
  }

  showDialog(): boolean {
    log.showInfo('enable show dialog, this.isShowDialog = ' + this.isShowDialog);
    return this.isShowDialog && this.keyboardPanelSession?.visibility;
  }

  build() {
    if (this.showKeyboard()) {
      this.keyboardPanelBuilder();
      if (this.showDialog()) {
        this.dialogBuilder()
      }
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
      this.keyboardState === KeyboardState.SHOW_IN_ABOVE_SPECIFIC_SCENE) {
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