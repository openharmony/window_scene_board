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
import { SCBNavigationFromRecentCallback } from '../interface/SCBNavigationCallback';
import { SCBBaseNavigationState } from './SCBNavigationState';

const TAG = 'SCBNavigationController_RecentState';
const log : LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const RECENT_DISTANCE_LIMIT_MIN: number = 0.10;
const SHOW_HOME_VIEW_LIMIT: number = 0.1;

/* state for gesture starting from recent view */
export class SCBBaseNavigationFromRecentState extends SCBBaseNavigationState {
  public callback?: SCBNavigationFromRecentCallback = undefined;

  setCallback(callback: SCBNavigationFromRecentCallback): void {
    this.callback = callback;
  }

  clone(state: SCBBaseNavigationFromRecentState) {
    super.clone(state);
    this.callback = state.callback;
  }
}

/* idle state */
export class SCBNavigationFromRecentIdleState extends SCBBaseNavigationFromRecentState {
  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    this.calcSpeedAndAcc(event);
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    if (this.isHomeViewShowOfSpeedLimit(this.curSpeed) || this.isHomeViewShowOfDistanceLimit(event.offsetY)) {
      log.showInfo('RecentIdleState consumeEndEvent:onExitRecent');
      this.callback?.onExitRecent();
    }
    return this;
  }

  private isHomeViewShowOfDistanceLimit(eventY: number): boolean {
    return ((Math.abs(eventY)) / this.screenHeight) >= SHOW_HOME_VIEW_LIMIT;
  }

  // unit is vp/ms
  private isHomeViewShowOfSpeedLimit(speed: number): boolean {
    return speed < -0.5;
  }
}
