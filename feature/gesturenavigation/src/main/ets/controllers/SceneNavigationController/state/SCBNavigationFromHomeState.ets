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
import { SCBTransitionManager } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBNavigationFromHomeCallback } from '../interface/SCBNavigationCallback';
import { SCBBaseNavigationState } from './SCBNavigationState';

const TAG = 'SCBNavigationController_HomeState';
const log : LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const RECENT_DISTANCE_LIMIT_MIN: number = 0.07;
const SHOW_FIRST_PAGE_LIMIT: number = 0.05;
let isFromRecentState = false;

/* the state for gesture start from home */
export class SCBBaseNavigationFromHomeState extends SCBBaseNavigationState {
  public callback?: SCBNavigationFromHomeCallback = undefined;

  setCallback(callback: SCBNavigationFromHomeCallback): void {
    this.callback = callback;
  }

  clone(state: SCBBaseNavigationFromHomeState) {
    super.clone(state);
    this.callback = state.callback;
  }
}

/* idle state */
export class SCBNavigationFromHomeIdleState extends SCBBaseNavigationFromHomeState {
  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    this.calcSpeedAndAcc(event);

    if (event.offsetY < 0) {
      let blur: number = -event.offsetY / (this.screenHeight * RECENT_DISTANCE_LIMIT_MIN);

      this.callback?.onUpdateScaleDesktop(event.offsetY);
      if (blur > 1.0) { // 手势上滑进入多任务时，若有应用退出动效，第一时间打断该动效
        SCBTransitionManager.getInstance().cancelCloseAppAnimate();
      }
      if (blur > 1.0 && this.curSpeed > -0.5) {
        log.showInfo('HomeIdleState consumeUpdateEvent:onEnterRecent');
        this.callback?.onEnterRecent(true, event.offsetX, event.offsetY);
        let state = new NavigationFromHomeRecentState(this.screenHeight);
        this.preEvent = event;
        state.clone(this);
        return state;
      }
    }
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    if (event.offsetY >= 0) {
      return this;
    }
    if (isFromRecentState) {
      log.showInfo('HomeIdleState consumeEndEvent:onEnterHome');
      this.callback?.onEnterHome();
      isFromRecentState = false;
    } else {
      log.showInfo('HomeIdleState consumeEndEvent:onEnterFirstHomePage');
      this.callback?.onEnterFirstHomePage();
    }
    return this;
  }

  private isHomeFirstPageShowOfDistanceLimit(eventY: number): boolean {
    return ((Math.abs(eventY)) / this.screenHeight) >= SHOW_FIRST_PAGE_LIMIT;
  }

  // unit is vp/ms
  private isHomeFirstPageShowOfSpeedLimit(speed: number): boolean {
    return speed < -0.5;
  }
}

/* 手势导航进入任务列表状态 */
export class NavigationFromHomeRecentState extends SCBBaseNavigationFromHomeState {
  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    if (event.offsetY > 0) {
      log.showInfo('event.offsetY > 0, ignore');
      return this;
    }
    this.calcSpeedAndAcc(event);
    if (this.isRecentViewHideOfDistanceLimit(event.offsetY)) {
      log.showInfo('HomeRecentState consumeUpdateEvent:onExitRecent');
      this.callback?.onExitRecent();
      let state = new SCBNavigationFromHomeIdleState(this.screenHeight);
      isFromRecentState = true; // enter home idle state
      this.preEvent = event;
      state.clone(this);
      return state;
    }
    this.callback?.onUpdateRecent(event.offsetX, event.offsetY);
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    // 任务列表的时候松手，进入任务列表
    if ((this.preOffY - event.offsetY > this.screenHeight * 0.1) && Math.abs(this.curSpeed) <= 0.5) {
      log.showInfo('HomeRecentState consumeEndEvent:onEnterRecent');
      this.callback?.onEnterRecent(false, event.offsetX, event.offsetY);
      // 返回idle状态
      let state = new SCBNavigationFromHomeIdleState(this.screenHeight);
      this.preEvent = event;
      state.clone(this);
      return state;
    }
    log.showInfo('HomeRecentState consumeEndEvent:onExitRecent');
    this.callback?.onExitRecent();
    return this;
  }

  private isRecentViewHideOfDistanceLimit(eventY: number): boolean {
    return ((Math.abs(eventY)) / this.screenHeight) <= RECENT_DISTANCE_LIMIT_MIN;
  }
}
