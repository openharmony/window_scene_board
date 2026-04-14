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
import {
  DockUtils,
  CommonConstants,
} from '@ohos/launchercommon';

import { EvtBus, RotateChangeEvent } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper} from '@ohos/basicutils';

import { OneStepState } from '../../../constants/CommonConstants';
import { SCBNavigationFromFullSceneCallback } from '../interface/SCBNavigationCallback';
import { SCBBaseNavigationState } from './SCBNavigationState';
import display from '@ohos.display';

const TAG = 'SCBNavigationController_FullScene';
const log : LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const NS_COUNT_PER_MS: number = 1000000;
const RECENT_DISTANCE_LIMIT_MIN: number = 0.1;
const RECENT_DISTANCE_LIMIT_MAX: number = 0.6;
const RECENT_STOP_SPEED: number = 0.15; // 触发多任务动效停顿条件的速度上限
const FAR_VIEW_TO_RECENT_LIMIT: number = 0.1;
// after trigger recent view，up 10% more to leave recent view
const RECENT_LEAVE_LIMIT: number = 0.1;

const RECENT_LANDSCAPE_RATIO = 2;
const RECENT_LEAVE_LIMIT_LANDSCAPE = 0.5;

// gesture recognize threshold 20px to avoid click recognized as pan
const RECOGNIZE_THRESHOLD = -px2vp(20);

/* state from full scene */
export class SCBBaseNavigationFromFullSceneState extends SCBBaseNavigationState {
  public callback?: SCBNavigationFromFullSceneCallback = undefined;
  public curOneStepState: OneStepState = OneStepState.DEFAULT;
  public aspectRadio: number = 1;
  public rawScreenHeight: number = 0;

  constructor(screenHeight: number) {
    super(screenHeight);
    try {
      const displayInfo = display.getDefaultDisplaySync();
      if (displayInfo.height !== 0) {
        this.aspectRadio = displayInfo.width / displayInfo.height;
      }
    } catch (err) {
      log.showError('getDefaultDisplaySync failed,Code is ${err.code}, message is ${err.message}');
    }
    this.rawScreenHeight = screenHeight;
    if (DockUtils.isSupportFullDock() && AppStorage.get('appDockVisibility') !== Visibility.Visible) {
      this.screenHeight = screenHeight - CommonConstants.DOCK_THRESHOLD_THREE;
    }
  }

  setCallback(callback: SCBNavigationFromFullSceneCallback): void {
    this.callback = callback;
  }

  setCurOneStepState(curOneStepState: OneStepState): void {
    this.curOneStepState = curOneStepState;
  }

  isOneStepState(): boolean {
    return this.curOneStepState === OneStepState.ENTER_SPLIT || this.curOneStepState === OneStepState.ENTER_FLOATING;
  }

  clone(state: SCBBaseNavigationFromFullSceneState): void {
    super.clone(state);
    this.callback = state.callback;
    this.curOneStepState = state.curOneStepState;
  }

  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    if (event.offsetY > 0) {
      log.showInfo('event.offsetY > 0, ignore');
      return this;
    }
    const fingerList = event.fingerList;
    // When the swiping gesture speed reaches a threshold, the one-step view is not visible.
    if (fingerList.length === 1) {
      let fingerInfo = fingerList[0];
      let pointX = fingerInfo.globalX;
      let pointY = fingerInfo.globalY;
      this.callback?.onGestureEventUpdate(pointX, pointY, this.curSpeed);
    }
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    if (DockUtils.isSupportFullDock()) {
      event.offsetY -= CommonConstants.DOCK_THRESHOLD_THREE;
    }
    if (event.offsetY > 0) {
      log.showInfo(`consumeEndEvent, event.offsetY: ${event.offsetY}, state: ${this.curOneStepState}`);
    }
    const fingerList = event.fingerList;
    if (fingerList.length >= 1 && fingerList[0]) {
      let fingerInfo = fingerList[0];
      let pointX = fingerInfo.globalX;
      let pointY = fingerInfo.globalY;
      this.callback?.onGestureEventEnd(pointX, pointY);
    } else {
      this.callback?.onGestureEventCancel(-1, -1);
    }
    return this;
  }
}

export class SCBNavigationFromFullSceneIdleState extends SCBBaseNavigationFromFullSceneState {

  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    super.consumeUpdateEvent(event);
    if (event.offsetY < 0) {
      // 当上滑手势时会打断当前旋转过程
      let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_CANCEL);
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);

      this.callback?.onEnterSceneZoom();
      let state = new SCBNavigationFromFullSceneZoomState(this.rawScreenHeight);
      this.preEvent = event;
      state.clone(this);
      return state;
    }
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    super.consumeEndEvent(event);
    log.showInfo(`SCBNavigationFromFullSceneIdleState consumeEndEvent, offsetX=${event.offsetX}`);
    return this;
  }
}

/* scene zoom state for gesture from bottom to up */
export class SCBNavigationFromFullSceneZoomState extends SCBBaseNavigationFromFullSceneState {
  // the first event for finger stop slide
  public stopMoveEvent: GestureEvent | null = null;
  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    if (event.offsetY > 0) {
      log.showInfo('event.offsetY > 0, ignore');
      return this;
    }

    let acceleration: number = this.calcSpeedAndAcc(event);
    super.consumeUpdateEvent(event);
    // 速度小于RECENT_STOP_SPEED时，判断用户操作为停顿，开始停顿时长的判断
    if (Math.abs(this.curSpeed) < RECENT_STOP_SPEED && this.curSpeed <= 0) {
      if (this.stopMoveEvent === null) {
        // mark the first stop event
        this.stopMoveEvent = event;
      }
    } else {
      this.stopMoveEvent = null;
    }

    const isDistance = this.isRecentsViewShowOfDistanceLimit(event.offsetY);
    const isSpeed = this.isRecentsViewShowOfSpeedLimit(event.timestamp, acceleration, this.curSpeed);
    log.showInfo('isDistance=%{public}s, isSpeed=%{public}s, offsetY=%{public}i, acc=%{public}i, speed=%{public}i',
      isDistance, isSpeed, event.offsetY, acceleration, this.curSpeed);

    // when consumeUpdateEvent and is one step split state, can not enter recent to avoid app in one step split but
    // show recent
    if (isDistance && isSpeed && !this.isOneStepState()) {
      log.showInfo('zoom to recent');
      this.callback?.onEnterRecent(true, event.offsetX, event.offsetY - RECOGNIZE_THRESHOLD);
      let state = new SCBNavigationFromFullSceneRecentState(this.rawScreenHeight);
      this.preEvent = event;
      state.clone(this);
      state.startEvent = event;
      return state;
    }

    this.callback?.onUpdateSceneZoom(event.offsetX, event.offsetY - RECOGNIZE_THRESHOLD);
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    super.consumeEndEvent(event);
    if (!this.isOneStepState()) {
      if (this.isShouldEnterHomeView(event.offsetY)) {
        log.showInfo('SceneZoomState consumeEndEvent:onEnterHome');
        this.callback?.onEnterHome();
      } else {
        log.showInfo('SceneZoomState consumeEndEvent:onEnterAppFullScreen');
        this.callback?.onEnterAppFullScreen();
      }
    }

    // return to idle state
    let state = new SCBNavigationFromFullSceneIdleState(this.rawScreenHeight);
    this.preEvent = event;
    state.clone(this);
    return state;
  }

  private isHomeViewShowOfSpeedLimit(speed: number): boolean {
    return speed < -0.1;
  }

  private isShouldEnterHomeView(eventY: number): boolean {
    // judge distance and speed
    if (this.isHomeViewShowOfSpeedLimit(this.curSpeed)) {
      return true;
    }
    // if over distance, should enter home
    return Math.abs(eventY) / this.screenHeight > RECENT_DISTANCE_LIMIT_MAX;
  }

  private isRecentsViewShowOfDistanceLimit(eventY: number): boolean {
    let percent = Math.abs(eventY) / this.screenHeight;
    return (percent >= RECENT_DISTANCE_LIMIT_MIN) && (percent <= RECENT_DISTANCE_LIMIT_MAX);
  }

  private isRecentsViewShowOfSpeedLimit(curTime: number, acceleration: number, curSpeed: number): boolean {
    // the unit is vp, not px
    if (acceleration > px2vp(0.05) && curSpeed > px2vp(-2.0) && curSpeed <= 0) {
      return true;
    } else if (this.stopMoveEvent && ((curTime - this.stopMoveEvent.timestamp) / NS_COUNT_PER_MS) > 80) {
      return true;
    }
    return false;
  }
}

export class SCBNavigationFromFullSceneRecentState extends SCBBaseNavigationFromFullSceneState {
  public startEvent?: GestureEvent = undefined;

  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    if (event.offsetY > 0) {
      log.showInfo('event.offsetY > 0, ignore');
      return this;
    }
    this.calcSpeedAndAcc(event);
    super.consumeUpdateEvent(event);
    if (this.isRecentsViewOutOfDistanceLimit(event.offsetY) || this.isOneStepState()) {
      log.showInfo('recent to faraway');
      this.callback?.onEnterAppFarView();
      let state = new SCBNavigationFromFullSceneFarAwayState(this.screenHeight);
      this.preEvent = event;
      state.clone(this);
      return state;
    } else if (this.isAppZoomViewShowOfDistanceLimit(event.offsetY)) {
      log.showInfo('recent to zoom');
      this.callback?.onExitSceneZoom();
      let state = new SCBNavigationFromFullSceneZoomState(this.rawScreenHeight);
      this.preEvent = event;
      state.clone(this);
      return state;
    }
    this.callback?.onUpdateRecent(event.offsetX, event.offsetY - RECOGNIZE_THRESHOLD);
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    super.consumeEndEvent(event);
    if (!this.isOneStepState()) {
      if (this.curSpeed < -0.5) {
        log.showInfo('RecentState consumeEndEvent:onEnterHome');
        this.callback?.onEnterHome();
      } else {
        log.showInfo(`RecentState consumeEndEvent:offsetX=${event.offsetX}, offsetY=${event.offsetY}`);
        this.callback?.onEnterRecent(false, event.offsetX, event.offsetY);
      }
    }

    let state = new SCBNavigationFromFullSceneIdleState(this.rawScreenHeight);
    this.preEvent = event;
    state.clone(this);
    return state;
  }

  private isRecentsViewOutOfDistanceLimit(eventY: number): boolean {
    log.showInfo(`eventY=${eventY}, screenHeight=${this.screenHeight}, offsetY=${this.startEvent?.offsetY}`);
    if (!this.startEvent) {
      return false;
    }

    // 若当前屏幕宽高比>=2，则进多任务后需offsetY超过屏幕高度的50%才退出，避免难进多任务
    if (this.aspectRadio >= RECENT_LANDSCAPE_RATIO && eventY < this.startEvent.offsetY) {
      return (Math.abs(eventY) / this.screenHeight) >= RECENT_LEAVE_LIMIT_LANDSCAPE;
    }
    return (-(eventY - this.startEvent.offsetY) / this.screenHeight) >= RECENT_LEAVE_LIMIT ||
      (Math.abs(eventY) / this.screenHeight) > RECENT_DISTANCE_LIMIT_MAX;
  }

  private isAppZoomViewShowOfDistanceLimit(eventY: number): boolean {
    return ((Math.abs(eventY)) / this.screenHeight) < RECENT_DISTANCE_LIMIT_MIN;
  }
}

/* when finger keep move up, after exit recent view, enter scene far away state */
export class SCBNavigationFromFullSceneFarAwayState extends SCBBaseNavigationFromFullSceneState {
  /* the top Y position of finger move up */
  public topOffsetY: number = 0;

  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    super.consumeUpdateEvent(event);
    if (event.offsetY > 0) {
      log.showInfo('event.offsetY > 0, ignore');
      return this;
    }
    this.calcSpeedAndAcc(event);
    if (event.offsetY < this.topOffsetY) {
      this.topOffsetY = event.offsetY;
    }
    if (this.isFarAwayNeedEnterRecentsView(event)) {
      log.showInfo(`faraway to recent, this.topOffsetY=${this.topOffsetY}, event.offsetY=${event.offsetY}`);
      this.callback?.onEnterRecent(true, event.offsetX, event.offsetY - RECOGNIZE_THRESHOLD);
      let state = new SCBNavigationFromFullSceneRecentState(this.rawScreenHeight);
      this.preEvent = event;
      state.clone(this);
      state.startEvent = event;
      return state;
    }

    this.callback?.onUpdateAppFarView(event.offsetX, event.offsetY - RECOGNIZE_THRESHOLD, event.speed);
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    super.consumeEndEvent(event);
    if (!this.isOneStepState()) {
      log.showInfo('FarAwayState consumeEndEvent:onEnterHome');
      // release touch，enter HOME
      this.callback?.onEnterHome();
    }
    // return to idle state
    let state = new SCBNavigationFromFullSceneIdleState(this.rawScreenHeight);
    this.preEvent = event;
    state.clone(this);
    return state;
  }

  private isFarAwayNeedEnterRecentsView(event: GestureEvent): boolean {
    if (this.isOneStepState()) {
      return false;
    }
    return ((Math.abs(event.offsetY - this.topOffsetY) / this.screenHeight) > FAR_VIEW_TO_RECENT_LIMIT) &&
    ((Math.abs(event.offsetY) / this.screenHeight) <= RECENT_DISTANCE_LIMIT_MAX);
  }
}
