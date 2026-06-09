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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSpecificSession } from '@ohos/windowscene';
import { SceneRect } from '../../common/manager/GlassLayoutManager';

const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassSpecificScene');

@Component
export struct GlassSpecificScene {
  @ObjectLink specificSession: SCBSpecificSession;
  @State rect: SceneRect = new SceneRect();

  private isEnableShow(): boolean {
    if (this.specificSession === undefined) {
      log.showWarn('enable show is false, specificSession is undefined');
      return false;
    }
    log.showInfo(`enable show, id: ${this.specificSession.session.persistentId},` +
      `type: ${this.specificSession?.session?.type}`);

    if (this.specificSession.isCustomAnimationPlaying || this.specificSession.isActive) {
      log.showWarn('enable show is true');
      return true;
    }

    log.showInfo('enable show is false');
    return false;
  }

  private onSessionTouchableChange(isTouchable: boolean): void {
    log.showDebug(`onSessionTouchableChange, touchable: ${isTouchable}`);
    this.specificSession?.setTouchable(isTouchable);
  }

  private initSpecialWindowEffectConfig(): void {
    this.specificSession?.setSpecialWindowEffectConfig();
  }

  private calcSceneRect(): void {
    this.rect.width = this.specificSession.currRect.width.getPx();
    this.rect.height = this.specificSession.currRect.height.getPx();
    this.rect.left = this.specificSession.currRect.left.getPx();
    this.rect.top = this.specificSession.currRect.top.getPx();
    log.showInfo(`calcSceneRect this.rect is: ${this.rect.stringify()}`);
  }

  private sceneRectChange = (rect: sceneSessionManager.SessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason): void => {
    if (reason === sceneSessionManager.SessionSizeChangeReason.RESIZE) {
      this.specificSession.currRect.setSizeNum(rect.width_, rect.height_);
    }
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      this.specificSession.currRect.setPosNum(rect.posX_, rect.posY_);
    }
    this.calcSceneRect();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.calcSceneRect();

    this.specificSession.registerSessionRectChangeCallback(this.sceneRectChange);
    this.specificSession?.addRefCount();
    this.specificSession?.registerSessionTouchableChangeCallback((isTouchable: boolean) => {
      this.onSessionTouchableChange(isTouchable);
    })
    this.specificSession?.registerSessionCustomAnimationPlayingCallback((isPlaying: boolean) => {
      this.specificSession.isCustomAnimationPlaying = isPlaying;
    })
    this.specificSession?.registerSessionForceHideCallback((hide: boolean) => {
      this.specificSession.visibility = !hide;
    })
    this.initSpecialWindowEffectConfig();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.specificSession?.decRefCount();
    this.specificSession?.unRegisterAll();
  }

  build() {
    if (this.isEnableShow()) {
      WindowScene(this.specificSession.session.persistentId)
        .enabled(this.specificSession.isTouchable)
        .position({ x: `${this.rect.left}px`, y: `${this.rect.top}px` })
        .width(this.rect.width === 0 ? '100%' : `${this.rect.width}px`)
        .height(this.rect.height === 0 ? '100%' : `${this.rect.height}px`)
        .id(`session${this.specificSession?.session.persistentId}`)
        .focusable(this.specificSession?.isFocusable)
        .borderRadius(this.specificSession?.specialBoarderRadius)
        .clip(true)
        .opacity(this.specificSession.opacity)
    }
  }
}
