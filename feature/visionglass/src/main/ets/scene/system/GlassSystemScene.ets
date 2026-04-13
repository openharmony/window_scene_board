/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { GlassSysSceneSession } from './GlassSysSceneSession';
import { Rect } from '../common/GlassSceneManager';
import { GlassStatusManager } from '../../common/manager/GlassStatusManager';
import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import { GlassSystemSceneManager } from '../common/GlassSystemSceneManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassSystemScene');

const INVALID_ID: number = -1;
const DEFAULT_POSITION = 0;
const DEFAULT_OPACITY = 1;
const DEFAULT_Z_INDEX = 0;

@Component
export struct GlassSystemScene {
  sysSceneSession?: GlassSysSceneSession;
  transitionCallBack: undefined | (() => TransitionEffect);
  @BuilderParam contextBuilder?: (() => void);
  @State visible: boolean = false;
  @State isFocusable: boolean = false;
  @State isTouchable: boolean = true;
  @State hitTestMode: HitTestMode = HitTestMode.Default;
  @State persistentId: number = INVALID_ID;
  @State sceneWidth: number = GlassLayoutManager.getInstance().getScreenWidthPx();
  @State sceneHeight: number = GlassLayoutManager.getInstance().getScreenHeightPx();
  @State positionX: number = DEFAULT_POSITION;
  @State positionY: number = DEFAULT_POSITION;
  @State sceneOpacity: number = DEFAULT_OPACITY;
  @State sceneZIndex: number = DEFAULT_Z_INDEX;
  //手机触摸板窗口已失焦，让部分系统窗口不抢焦，以防侧滑失效
  getFocusable: boolean = true;
  sceneType: number = INVALID_ID;
  private setFocusable = (isFocusable: boolean): void => {
    this.isFocusable = isFocusable;
  };
  private setVisibility = (visible: boolean): void => {
    this.visible = visible;
    GlassStatusManager.getInstance().activeSystemScene?.dispatch((map) => {
      map.set(this.sceneType, this.visible);
      return map;
    });
  };
  private setTouchable = (isTouchable: boolean): void => {
    this.isTouchable = isTouchable;
  };
  private setHitTestMode = (hitTestMode: HitTestMode): void => {
    this.hitTestMode = hitTestMode;
  };
  private setSceneRect = (rect: Rect): void => {
    this.sceneWidth = rect.width ?? this.sceneWidth;
    this.sceneHeight = rect.height ?? this.sceneHeight;
    this.positionX = rect.left ?? this.positionX;
    this.positionY = rect.top ?? this.positionY;
  };
  private setOpacity = (opacity: number): void => {
    this.sceneOpacity = opacity;
  };
  private setZIndex = (zIndex: number): void => {
    this.sceneZIndex = zIndex;
  };
  private setRectAnimate = (animateParam: AnimateParam, rect: Rect, onFinishCallback?: () => void): void => {
    animateTo({
      duration: animateParam.duration,
      curve: animateParam.curve,
      onFinish: () => {
        log.showInfo('onFinish');
        onFinishCallback?.();
      }
    }, () => {
      this.sceneWidth = rect.width ?? this.sceneWidth;
      this.sceneHeight = rect.height ?? this.sceneHeight;
      this.positionX = rect.left ?? this.positionX;
      this.positionY = rect.top ?? this.positionY;
      log.showInfo(`this.positionX: ${this.positionX}, this.positionY: ${this.positionY}`);
    });
  };

  private calcPx(val: string | number): string {
    if (typeof val === 'number') {
      return `${val}px`;
    }
    return val;
  }

  private init(): void {
    if (!this.sysSceneSession) {
      return;
    }
    this.sysSceneSession.registerCallback({
      setZIndex: this.setZIndex,
      setOpacity: this.setOpacity,
      setSceneRect: this.setSceneRect,
      setVisibility: this.setVisibility,
      setFocusable: this.setFocusable,
      setTouchable: this.setTouchable,
      setHitTestMode: this.setHitTestMode,
      setRectAnimate: this.setRectAnimate
    });
    this.sysSceneSession.setZOrder(this.sceneZIndex);
    if (this.sysSceneSession.session !== undefined) {
      this.persistentId = this.sysSceneSession.session.persistentId;
    }
    this.sysSceneSession.setFocusable(this.getFocusable);
    SCBSceneSessionManager.getInstance().requestSceneSessionActivation(this.sysSceneSession.session, true);
    GlassSystemSceneManager.getInstance().registerSystemSceneSession(this.sceneType, this.sysSceneSession);
  }

  aboutToAppear(): void {
    log.showInfo(`${this.sysSceneSession?.getSceneName()} aboutToAppear!`);
    this.init();
  }

  aboutToDisappear(): void {
    this.sysSceneSession?.requestSceneSessionDestruction();
    log.showInfo(`${this.sceneType} aboutToDisappear!`);
  }

  build() {
    if (this.persistentId !== INVALID_ID) {
      WindowScene(this.persistentId) {
        if (this.contextBuilder !== undefined) {
          this.contextBuilder()
        }
      }
      .id(`session_${this.persistentId}`)
      .position({ x: px2vp(this.positionX), y: px2vp(this.positionY) })
      .size({ width: px2vp(this.sceneWidth), height: px2vp(this.sceneHeight) })
      .visibility(this.visible ? Visibility.Visible : Visibility.Hidden)
      .focusable(this.isFocusable)
      .hitTestBehavior(this.hitTestMode)
      .enabled(true)
      .opacity(this.sceneOpacity)
      .clip(true)
      .backgroundColor(Color.Transparent)
      .zIndex(this.sceneZIndex)
      .transition(this.transitionCallBack?.())
    }
  }
}