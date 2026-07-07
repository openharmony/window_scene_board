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
import {
  Log,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  SCBKeyboardSession,
  SCBKeyboardPanelSession,
  SCBKeyboardPanelManager,
  SCBSessionRect,
  windowMgr,
  INVALID_SCREEN_ID,
} from '@ohos/windowscene';
import { WindowAnimationUtils } from '@ohos/windowscene/Index';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { image } from '@kit.ImageKit';
import curves from '@ohos.curves';
import { display } from '@kit.ArkUI';
import { SettingsUtil } from '@ohos/frameworkwrapper';
import { SCBInputMethod } from './SCBInputMethod';

const TAG = 'SCBKeyboardScene';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const TOUCHPAD_KEY_BOARD_TYPE = '1';
const PIXED_KEY_BOARD_TYPE = '2';
const FLOATING_KEY_BOARD_TYPE = '3';
const FLOATING_KEY_BOARD_HEIGHT = 819.40;

@Component
export struct SCBKeyboardScene {
  @ObjectLink keyboardSession: SCBKeyboardSession;
  @ObjectLink rect: SCBSessionRect;
  @ObjectLink keyboardPanelSession: SCBKeyboardPanelSession;
  @State screenId: number = INVALID_SCREEN_ID;

  private windowAnimationUtils: WindowAnimationUtils = WindowAnimationUtils.getInstance();

  buildSCBKeyboardScene(): void {
    log.showDebug('buildSCBKeyboardScene id: ' + this.keyboardSession?.session.persistentId);
  }

  onRectChange(): void {
    this.cacheInputMethodRect(this.rect);
  }

  enableShow(): boolean {
    if (!this.keyboardSession) {
      log.showError('enable show is false, keyboardSession is null');
      return false;
    }

    if (this.keyboardPanelSession == null || this.keyboardPanelSession == undefined) {
      log.showError('enable show is false, keyboardPanelSession is null');
      return false;
    }

    if (this.keyboardSession.screenId !== this.screenId) {
      log.showError(`keyboard sesion screenId: ${this.keyboardSession.screenId}, this screenId: ${this.screenId}`);
      return false;
    }

    if (this.keyboardSession.isCustomAnimationPlaying) {
      log.showDebug('enable show is true, is playing custom animation');
      return true;
    }

    if (this.keyboardSession.isActive) {
      Log.showInfo(TAG, 'enable show is true, is in active state, screenId:' + this.screenId +
        ', id: ' + this.keyboardSession?.session.persistentId + ', type: ' + this.keyboardSession.session.type);
      performanceMonitor.begin('SHOW_INPUT_METHOD_ANIMATION', performanceMonitor.ActionType.LAST_UP);
      Log.showInfo(TAG, 'SHOW_INPUT_METHOD_ANIMATION');
      return true;
    }

    Log.showInfo(TAG, 'enable show is false, is in inactive state, screenId: ' + this.screenId +
      ', id: ' + this.keyboardSession?.session.persistentId + ', type: ' + this.keyboardSession.session.type);
    Log.showInfo(TAG, 'HIDE_INPUT_METHOD_ANIMATION');
    performanceMonitor.begin('HIDE_INPUT_METHOD_ANIMATION', performanceMonitor.ActionType.LAST_UP);

    return false;
  }

  private cacheInputMethodRect(rect: SCBSessionRect): void {
    log.showInfo(`TYPE_INPUT_METHOD: ${this.keyboardSession.session.type}
      ${this.keyboardSession.session.persistentId} ${JSON.stringify(rect)}`);
    windowMgr.setInputMethodRectCache(this.keyboardSession.session.persistentId, rect?.copy());
  }

  async onSessionRectChange(reason: sceneSessionManager.SessionSizeChangeReason) {
    if (!this.keyboardSession) {
      log.showError('keyboardSession is null');
      return;
    }
    log.showInfo(`onSessionRectChange start, id: ${this.keyboardSession?.session.persistentId}, reason: ${reason}, ` +
      `currRect: ${this.keyboardSession?.currRect?.printPx()}, isSystemKeyboard: ` +
      `${this.keyboardSession?.session.isSystemKeyboard}`);

    const newRect = this.keyboardSession.currRect.copy();
    let rectForFingerprint: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
    SCBKeyboardPanelManager.getInstance().calculateKeyboardAndPanelRect(this.keyboardSession?.session.persistentId,
      newRect, this.keyboardPanelSession?.currRect, rectForFingerprint);

    // 系统键盘执行尺寸切换/拖拽动效
    if (this.keyboardSession.session?.isSystemKeyboard && this.keyboardSession.isActive) {
      const isRectResize = this.keyboardSession.currRect.width.getPx() !== newRect.width.getPx() ||
        this.keyboardSession.currRect.height.getPx() !== newRect.height.getPx();
      log.showInfo(`system keyboard window is on resize: ${isRectResize}`);
      if (isRectResize) {
        await this.getAnimSnapshot(this.keyboardSession.session.persistentId);
        this.initAnimateParam(this.keyboardSession.currRect, newRect);
        this.windowAnimationUtils.setSystemKeyboardSnapshotAnimate(this.keyboardSession);
        this.windowAnimationUtils.setSystemKeyboardCommonAnimate(this.keyboardSession);
      }
    } else {
      this.updateRect(newRect);
    }
    log.showInfo(`onSessionRectChange end, id: ${this.keyboardSession?.session.persistentId}, reason: ${reason}, ` +
      `currRect: ${this.keyboardSession?.currRect?.printPx()}`);
  }

  private updateRect(newRect: SCBSessionRect): void {
    this.rect && this.rect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
    this.keyboardPanelSession?.currRect.setRect(newRect.left, newRect.top, newRect.width, newRect.height);
  }

  private async getAnimSnapshot(sessionId: number): Promise<void> {
    if (!this.keyboardSession.session.isSystemKeyboard) {
      return;
    }
    try {
      let pixelMap: image.PixelMap = await sceneSessionManager.getSessionSnapshotPixelMap(sessionId, 1);
      this.keyboardSession.setAnimSnapshot(pixelMap);
    } catch (err) {
      log.showError(`get system keyboard animate snapshot failed, cause: ${JSON.stringify(err)}`);
    }
  }

  private initAnimateParam(currRect: SCBSessionRect, newRect: SCBSessionRect): void {
    if (!this.keyboardSession.session.isSystemKeyboard) {
      return;
    }
    const currentLeft = currRect.left.getPx();
    const currentTop = currRect.top.getPx();
    const currentWidth = currRect.width.getPx();
    const currentHeight = currRect.height.getPx();
    const posX = newRect.left.getPx();
    const posY = newRect.top.getPx();
    const width = newRect.width.getPx();
    const height = newRect.height.getPx();
    const newScaleX = width !== 0 ? currentWidth / width : 1;
    const newScaleY = height !== 0 ? currentHeight / height : 1;
    const newTranslateX = px2vp(currentLeft + currentWidth * 0.5 - posX - width * 0.5);
    const newTranslateY = px2vp(currentTop + currentHeight * 0.5 - posY - height * 0.5);
    this.keyboardSession.setSystemKeyboardScale(newScaleX, newScaleY);
    this.keyboardSession.setSystemKeyboardTranslate(newTranslateX, newTranslateY);
    this.updateRect(newRect);
    log.showInfo(`init params end, scaleX: ${this.keyboardSession.getSystemKeyboardScaleX()},
     scaleY: ${this.keyboardSession.getSystemKeyboardScaleY()},
     translateX: ${this.keyboardSession.getSystemKeyboardTranslateX()},
     translateY: ${this.keyboardSession.getSystemKeyboardTranslateY()}`);
  }

  onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.keyboardSession?.setTouchable(isTouchable);
  }

  initSpecialWindowEffectConfig() {
    this.keyboardSession.setSpecialWindowEffectConfig();
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, id: ${this.keyboardSession?.session.persistentId}, ` +
      `currRect: ${this.keyboardSession?.currRect?.printPx()}`);
    this.keyboardSession?.addRefCount();
    SCBKeyboardPanelManager.getInstance().registerRectChangeCallbackOfKeyboardScene(
      this.keyboardSession?.session.persistentId, (reason: sceneSessionManager.SessionSizeChangeReason) => {
      this.onSessionRectChange(reason);
    })
    this.keyboardSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    })
    this.keyboardSession?.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      this.keyboardSession.isCustomAnimationPlaying = isPlaying;
    })
    this.keyboardSession?.registerSessionForceHideCallback((hide: boolean) => {
      this.keyboardSession.visibility = !hide;
    })
  }

  aboutToDisappear(): void {
    this.keyboardSession?.decRefCount();
    this.keyboardSession?.unRegisterAll();
    SCBKeyboardPanelManager.getInstance().unregisterRectChangeCallbackOfKeyboardScene(
      this.keyboardSession?.session.persistentId);
  }

  @Styles
  keyboardLayoutParams() {
    .position({
      x: this.rect?.left.getPxStr(),
      y: this.rect?.top.getPxStr()
    })
    .size({
      width: this.rect?.width.getPxSizeStr(),
      height: this.rect?.height.getPxSizeStr()
    })
  }

  @Builder
  keyboardPanelBuilder() {
    WindowScene(this.keyboardPanelSession?.session?.persistentId) {
      WindowScene(this.keyboardSession?.session?.persistentId)
        .size({
          width: this.rect?.width.getPxSizeStr(),
          height: this.rect?.height.getPxSizeStr()
        })
        .id(`session${this.keyboardSession.session.persistentId}`)
    }
    .id(`session${this.keyboardPanelSession?.session?.persistentId}`)
    .keyboardLayoutParams()
    .visibility(this.keyboardSession.visibility ? Visibility.Visible : Visibility.Hidden)
    .focusable(this.keyboardPanelSession?.isFocusable)
    .hitTestBehavior(this.keyboardSession.isTouchable ? HitTestMode.Block : HitTestMode.None)
    .borderRadius(this.keyboardSession?.GetKeyboardBorderRadius())
    .clip(this.keyboardSession?.isFloatGravity() ? true : false)
    .translate({ x: 0 + 'px', y: this.keyboardSession?.translatePosY + 'px' })
    .shadow(this.keyboardPanelSession?.panelShadow?.radius > 0 ?
      {
        radius: this.keyboardPanelSession?.panelShadow?.radius,
        color: this.keyboardPanelSession?.panelShadow?.color,
        offsetX: this.keyboardPanelSession?.panelShadow?.offsetX,
        offsetY: this.keyboardPanelSession?.panelShadow?.offsetY
      }: { radius: 0 })
  }

  @Builder
  systemKeyboardPanelBuilder() {
    WindowScene(this.keyboardPanelSession?.session?.persistentId) {
      WindowScene(this.keyboardSession?.session?.persistentId)
        .size({
          width: this.rect?.width.getPxSizeStr(),
          height: this.rect?.height.getPxSizeStr()
        })
        .borderRadius(this.keyboardSession?.GetKeyboardBorderRadius())
        .id(`systemKeyboardsession${this.keyboardSession.session.persistentId}`)
    }
    .id(`systemKeyboardsession${this.keyboardPanelSession?.session?.persistentId}`)
    .keyboardLayoutParams()
    .visibility(this.keyboardSession.visibility ? Visibility.Visible : Visibility.Hidden)
    .focusable(this.keyboardPanelSession?.isFocusable)
    .hitTestBehavior(this.keyboardSession.isTouchable ? HitTestMode.Block : HitTestMode.None)
    .borderRadius(this.keyboardSession?.GetKeyboardBorderRadius())
    .clip(this.keyboardSession?.isFloatGravity() ? true : false)
    .transition(this.windowAnimationUtils.getSystemKeyboardTransitionEffect(this.rect))
    .translate({
      x: this.keyboardSession.getSystemKeyboardTranslateX(),
      y: this.keyboardSession.getSystemKeyboardTranslateY()
    })
    .scale({
      x: this.keyboardSession.getSystemKeyboardScaleX(),
      y: this.keyboardSession.getSystemKeyboardScaleY(),
      centerX: '50%',
      centerY: '50%',
    })
    .shadow(this.keyboardPanelSession?.panelShadow?.radius > 0 ?
      {
        radius: this.keyboardPanelSession?.panelShadow?.radius,
        color: this.keyboardPanelSession?.panelShadow?.color,
        offsetX: this.keyboardPanelSession?.panelShadow?.offsetX,
        offsetY: this.keyboardPanelSession?.panelShadow?.offsetY
      }: { radius: 0 })

    if (this.keyboardSession.animSnapshot !== undefined) {
      Image(this.keyboardSession.animSnapshot)
        .draggable(false)
        .syncLoad(true)
        .visibility(this.keyboardSession.getAnimSceneVisible() ? Visibility.Visible : Visibility.Hidden)
        .objectFit(ImageFit.Fill)
        .keyboardLayoutParams()
        .translate({
          x: this.keyboardSession.getSystemKeyboardTranslateX(),
          y: this.keyboardSession.getSystemKeyboardTranslateY()
        })
        .scale({
          x: this.keyboardSession.getSystemKeyboardScaleX(),
          y: this.keyboardSession.getSystemKeyboardScaleY(),
          centerX: '50%',
          centerY: '50%',
        })
        .hitTestBehavior(HitTestMode.None)
    }
  }

  build() {
    if (this.enableShow()) {
      if (this.keyboardSession.session.isSystemKeyboard) {
        this.systemKeyboardPanelBuilder();
      } else {
        this.keyboardPanelBuilder();
      }
    }
  }
}