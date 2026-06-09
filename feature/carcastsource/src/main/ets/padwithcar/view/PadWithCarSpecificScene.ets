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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenProperty, SCBSpecificSession } from '@ohos/windowscene';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import sceneSessionManager from '@ohos.sceneSessionManager';

const log = LogHelper.getLogHelper(LogDomain.HICAR, 'PadWithCarSpecificScene');
const SCENE_INDEX = 2100;

@Component
export struct PadWithCarSpecificScene {
  appZOrder: number = 0;
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink specificSession: SCBSpecificSession;
  @State specificProperty: SCBScreenProperty = new SCBScreenProperty();

  enableShow(): boolean {
    if (this.specificSession === undefined || this.specificSession.session === undefined) {
      log.showWarn('enable show is false, specificSession is undefined');
      return false;
    }
    log.showInfo(`enable show, id: ${this.specificSession.session.persistentId},` +
      `type: ${this.specificSession.session.type}`);
    if (this.specificSession.isCustomAnimationPlaying || this.specificSession.isActive) {
      if (this.specificSession.isActive &&
        this.specificSession.session.type === sceneSessionManager.SessionType.TYPE_INPUT_METHOD) {
        performanceMonitor.begin('SHOW_INPUT_METHOD_ANIMATION', performanceMonitor.ActionType.LAST_UP);
        log.showDebug('SHOW_INPUT_METHOD_ANIMATION');
      }
      log.showInfo('enable show is true');
      return true;
    }
    if (this.specificSession.session.type === sceneSessionManager.SessionType.TYPE_INPUT_METHOD) {
      log.showDebug('HIDE_INPUT_METHOD_ANIMATION');
      performanceMonitor.begin('HIDE_INPUT_METHOD_ANIMATION', performanceMonitor.ActionType.LAST_UP);
    }
    return false;
  }

  onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.specificSession?.setTouchable(isTouchable);
  }

  initSpecialWindowEffectConfig(): void {
    this.specificSession?.setSpecialWindowEffectConfig();
  }

  private specificSceneChange = (property: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason): void => {
    if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
      this.specificSession?.currRect.setSizeNum(property.width_, property.height_);
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      this.specificSession?.currRect.setPosNum(property.posX_, property.posY_);
    }
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear, id: ${this.specificSession?.session?.persistentId}`);
    this.specificSession?.addRefCount();
    this.specificSession?.registerSessionRectChangeCallback(this.specificSceneChange);
    this.specificSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      log.showInfo(`onSessionTouchableChange isTouchable ${isTouchable}`);
      this.onSessionTouchableChange(isTouchable);
    })
    this.specificSession?.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      log.showInfo(`isCustomAnimationPlaying isPlaying ${isPlaying}`);
      this.specificSession.isCustomAnimationPlaying = isPlaying;
    })
    this.specificSession?.registerSessionForceHideCallback((hide: boolean) => {
      log.showInfo(`visibility ${hide}`);
      this.specificSession.visibility = !hide;
    })
    this.initSpecialWindowEffectConfig();
    this.specificSession?.setZOrder(SCENE_INDEX + this.appZOrder);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear, id: ${this.specificSession?.session?.persistentId}`);
    this.specificSession?.decRefCount();
    this.specificSession?.unRegisterAll();
  }

  build() {
    if (this.enableShow()) {
      WindowScene(this.specificSession.session.persistentId)
        .zIndex(SCENE_INDEX)
        .position({
          x: this.specificSession.currRect.left.getPx() + 'px',
          y: this.specificSession.currRect.top.getPx() + 'px'
        })
        .size({
          width: this.specificSession.currRect.width.getPx() + 'px',
          height: this.specificSession.currRect.height.getPx() + 'px'
        })
        .id(`session${this.specificSession.session.persistentId}`)
        .focusable(this.specificSession.isFocusable)
        .hitTestBehavior(this.specificSession.isTouchable ? HitTestMode.Default : HitTestMode.None)
        .borderRadius(this.specificSession.specialBoarderRadius)
        .clip(true)
        .opacity(this.specificSession.opacity)
    }
  }
}
