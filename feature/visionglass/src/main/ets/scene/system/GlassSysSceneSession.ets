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
import { FocusChangeReason } from '@ohos/windowscene';
import { GlassSceneManager, Rect } from '../common/GlassSceneManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { VisionGlassResourceManager } from '../../IdlVisionGlassExtService/VisionGlassResourceManager';
import Want from '@ohos.app.ability.Want';

const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassSysSceneSession');
const DEFAULT_Z_ORDER = 0;

export interface SystemSessionInfo {
  systemType: sceneSessionManager.SessionType;
  sceneName: string;
  isSystemInput?: boolean;
}

export interface SceneSessionCallback {
  setZIndex: ((zIndex: number) => void);
  setOpacity: ((opacity: number) => void);
  setSceneRect: ((rect: Rect) => void);
  setVisibility: ((visible: boolean) => void);
  setFocusable: ((isFocusable: boolean) => void);
  setTouchable: ((isTouchable: boolean) => void);
  setHitTestMode: ((hitTestMode: HitTestMode) => void);
  setRectAnimate: ((animateParam: AnimateParam, rect: Rect, onFinishCallback?: () => void) => void);
}

export class GlassSysSceneSession {
  public readonly session?: sceneSessionManager.SceneSession;
  private zOrder: number = 0;
  private sceneName: string = '';
  private visibility: boolean = false;
  private sceneSessionCallback?: SceneSessionCallback;

  public registerCallback(callback: SceneSessionCallback): void {
    this.sceneSessionCallback = callback;
  }

  public setFocusable(isFocusable: boolean): void {
    this.sceneSessionCallback?.setFocusable(isFocusable);
    this.session?.setFocusable(isFocusable);
  }

  public setVisibility(visible: boolean): void {
    this.visibility = visible;
    this.sceneSessionCallback?.setVisibility(visible);
    this.session?.updateNativeVisibility(visible);
    log.showDebug(`setVisibility visible ${visible}`);
    if (this.session === undefined) {
      log.showError(`in setVisibility session is invalid.`);
      return;
    }
    if (visible) {
      GlassSceneManager.getInstance().requestFocus(this.session.persistentId, undefined, FocusChangeReason.FOREGROUND);
      let want: Want = {
        parameters: {
          persistentId: this.session.persistentId
        }
      };
      VisionGlassResourceManager.getInstance().sendActiveWant(JSON.stringify(want));
      log.showDebug(`setVisibility sendActiveWant: ${JSON.stringify(want)}`);
    } else {
      GlassSceneManager.getInstance()
        .requestUnFocus(this.session.persistentId, undefined, FocusChangeReason.BACKGROUND);
    }
  }

  public getVisibility(): boolean {
    return this.visibility;
  }

  public setTouchable(isTouchable: boolean): void {
    this.sceneSessionCallback?.setTouchable(isTouchable);
  }

  public setHitTestMode(hitTestMode: HitTestMode): void {
    this.sceneSessionCallback?.setHitTestMode(hitTestMode);
  }

  public updateRect(rect: Rect): void {
    this.sceneSessionCallback?.setSceneRect(rect);
  }

  public setOpacity(opacity: number): void {
    this.sceneSessionCallback?.setOpacity(opacity);
  }

  public setZIndex(zIndex: number): void {
    this.sceneSessionCallback?.setZIndex(zIndex);
  }

  public setRectAnimate(animateParam: AnimateParam, rect: Rect, onFinishCallback?: () => void): void {
    this.sceneSessionCallback?.setRectAnimate(animateParam, rect, onFinishCallback);
  }

  public setPrivacyMode(isPrivacyMode: boolean): void {
    this.session?.setPrivacyMode(isPrivacyMode);
  }

  public setZOrder(zOrder: number): void {
    log.info(`${this.sceneName} setZOrder: (old ${this.zOrder}: new ${zOrder})`);
    if (this.zOrder !== zOrder) {
      this.zOrder = zOrder;
      this.session?.setZOrder(zOrder);
    }
  }

  public requestSceneSessionDestruction(): void {
    this.sceneSessionCallback = undefined;
    try {
      sceneSessionManager.requestSceneSessionDestruction(this.session, true);
    } catch (err) {
      log.showError(`${this.sceneName} requestSceneSessionDestruction failed with err: ${err?.code}`);
    }
  }

  public constructor(systemSessionInfo: SystemSessionInfo, screenId: number) {
    const sceneName = systemSessionInfo.sceneName;
    const systemType = systemSessionInfo.systemType;
    const isSystemInput = systemSessionInfo.isSystemInput;
    log.info(`constructor ${sceneName}`);
    this.sceneName = sceneName;
    try {
      this.session = sceneSessionManager.requestSceneSession({
        bundleName: this.sceneName,
        moduleName: this.sceneName,
        abilityName: this.sceneName,
        appIndex: 0,
        isSystem: true,
        sessionType: systemType,
        screenId: screenId,
        isSystemInput: isSystemInput ?? false
      });
    } catch (err) {
      log.showError(`${sceneName} create failed with err: ${err?.code}`);
    }
  }

  public getSceneName(): string {
    return this.sceneName;
  }

  public isShow(): boolean {
    return this.visibility;
  }
}
