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

const TAG = 'SCBNavigationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const NS_COUNT_PER_MS: number = 1000000;

export class SCBBaseNavigationState {
  /* the last speed of gesture event */
  public preSpeed: number = 0;
  /* the current speed of gesture event */
  public curSpeed: number = 0;
  public screenHeight: number;
  public preEvent?: GestureEvent = undefined;
  public preOffY: number = 0;

  constructor(screenHeight: number) {
    this.screenHeight = screenHeight;
  }

  clone(state: SCBBaseNavigationState): void {
    this.preSpeed = state.preSpeed;
    this.curSpeed = state.curSpeed;
    this.preEvent = state.preEvent;
  }

  setPreEvent(event: GestureEvent) {
    this.preEvent = event;
  }

  consumeUpdateEvent(event: GestureEvent): SCBBaseNavigationState {
    return this;
  }

  consumeEndEvent(event: GestureEvent): SCBBaseNavigationState {
    return this;
  }

  /* calculate speed and acceleration */
  calcSpeedAndAcc(event: GestureEvent): number {
    if (!this.preEvent) {
      log.showInfo('GestureEvent is undefined or null');
      this.preEvent = event;
      this.preOffY = event.offsetY;
      return 0;
    }

    const speedX = (event.offsetX - this.preEvent.offsetX) / ((event.timestamp - this.preEvent.timestamp) /
      NS_COUNT_PER_MS);
    const speedY = (event.offsetY - this.preEvent.offsetY) / ((event.timestamp - this.preEvent.timestamp) /
      NS_COUNT_PER_MS);
    const sqrt = Math.sqrt(speedX * speedX + speedY * speedY);
    this.curSpeed = event.offsetY <= this.preEvent.offsetY ? -sqrt : sqrt;
    let acceleration = (this.curSpeed - this.preSpeed) / ((event.timestamp - this.preEvent.timestamp) /
      NS_COUNT_PER_MS);
    log.showInfo(`curSpeed=${this.curSpeed}, acceleration=${acceleration}`);
    this.preSpeed = this.curSpeed;
    this.preEvent = event;
    return acceleration;
  }
}

