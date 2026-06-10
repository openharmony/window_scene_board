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
import { ThreeFingerSwipeEvent } from './ThreeFingerSwipeEvent';
import { ThreeFingerSwipeConstants, ThreeFingerSwipeDirection } from './ThreeFingerSwipeConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ThreeFingerSwipeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class ThreeFingerSwipeController {
  private readonly NS_COUNT_PER_MS: number = 1000000;
  public direction: ThreeFingerSwipeDirection = ThreeFingerSwipeDirection.NONE;
  public preSpeed: number = 0;
  public curSpeed: number = 0;
  public curXSpeed: number = 0;
  public curYSpeed: number = 0;
  public angle: number = 0;
  public acc: number = 0;
  public swipeDownStartTime: number = 0;
  public speedScalar: number = 0;

  public startEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
  public preEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
  public curEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
  public stopEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();

  calcSpeedAndAcc(): void {
    if (!this.preEvent) {
      return;
    }
    if (this.curEvent.timestamp === this.preEvent.timestamp) {
      return;
    }
    let diffTime = (this.curEvent.timestamp - this.preEvent.timestamp) / this.NS_COUNT_PER_MS;
    this.curXSpeed = (this.curEvent.x - this.preEvent.x) / diffTime;
    this.curYSpeed = (this.curEvent.y - this.preEvent.y) / diffTime;
    this.speedScalar = Math.sqrt(this.curXSpeed * this.curXSpeed + this.curYSpeed * this.curYSpeed);
    this.curSpeed = this.curEvent.y <= this.preEvent.y ? -this.speedScalar : this.speedScalar;
    this.acc = Math.abs((this.curSpeed - this.preSpeed) / diffTime);
    this.preSpeed = this.curSpeed;
  }

  reachRecentLimit(): boolean {
    log.showDebug(`curSpeed=${this.curSpeed}, acc=${this.acc}, distance=${this.getSwipeVerticalDistance()}`);
    return (this.curSpeed <= 0 && (this.acc > px2vp(ThreeFingerSwipeConstants.CRITICAL_ACC) ||
      this.curSpeed < px2vp(ThreeFingerSwipeConstants.CRITICAL_SPEED)));
  }

  getSwipeVerticalDistance(): number {
    return this.curEvent.y - this.startEvent.y;
  }

  getSwipeHorizontalDistance(): number {
    return this.curEvent.x - this.startEvent.x;
  }

  calcSwipeAngle(): void {
    if (this.curEvent.timestamp === this.preEvent.timestamp) {
      return;
    }
    let deltaX: number = this.curEvent.x - this.startEvent.x;
    let deltaY: number = this.curEvent.y - this.startEvent.y;
    this.angle = -Math.atan2(deltaY, deltaX) / Math.PI * ThreeFingerSwipeConstants.ANGLE_180;
    log.showDebug(`angle=${this.angle}`);
    this.getSwipeDirection();
    log.showDebug(`direction=${this.direction}`);
  }

  getSwipeDirection(): void {
    if (this.angle < ThreeFingerSwipeConstants.ANGLE_105 && this.angle >= ThreeFingerSwipeConstants.ANGLE_75) {
      this.direction = ThreeFingerSwipeDirection.UP;
      return;
    }
    if (this.angle < ThreeFingerSwipeConstants.ANGLE_165 && this.angle >= ThreeFingerSwipeConstants.ANGLE_105) {
      this.direction = ThreeFingerSwipeDirection.LEFT_UP;
      return;
    }
    if (this.angle < ThreeFingerSwipeConstants.ANGLE_75 && this.angle >= ThreeFingerSwipeConstants.ANGLE_15) {
      this.direction = ThreeFingerSwipeDirection.RIGHT_UP;
      return;
    }
    if (this.angle <= -ThreeFingerSwipeConstants.ANGLE_75 && this.angle > -ThreeFingerSwipeConstants.ANGLE_105) {
      this.direction = ThreeFingerSwipeDirection.DOWN;
      return;
    }
    if (this.angle < ThreeFingerSwipeConstants.ANGLE_15 && this.angle >= -ThreeFingerSwipeConstants.ANGLE_15) {
      this.direction = ThreeFingerSwipeDirection.RIGHT;
      return;
    }
    if (this.angle >= ThreeFingerSwipeConstants.ANGLE_165 || this.angle <= -ThreeFingerSwipeConstants.ANGLE_165) {
      this.direction = ThreeFingerSwipeDirection.LEFT;
      return;
    }
  }

  getSmin(): number {
    return ThreeFingerSwipeConstants.REBOUND_DISTANCE; // rebound distance
  }

  getSmax(): number {
    return ThreeFingerSwipeConstants.FOLLOW_UP_DISTANCE; // follow up distance
  }

  getCriticalSpeed(): number {
    return ThreeFingerSwipeConstants.CRITICAL_SPEED;
  }

  createGestureEvent(startPositionX: number, startPositionY: number): GestureEvent {
    let event: GestureEvent = {
      repeat: false,
      fingerList: [{
        id: 0,
        localX: 0,
        localY: 0,
        globalX: 0,
        globalY: 0,
        displayX: 0,
        displayY: 0
      }],
      offsetX: this.getSwipeHorizontalDistance(),
      offsetY: this.getSwipeVerticalDistance(),
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0,
      target: {
        area: {
          width: 0,
          height: 0,
          position: { x: 0, y: 0 },
          globalPosition: { x: 0, y: 0 }
        }
      },
      timestamp: this.curEvent.timestamp * this.NS_COUNT_PER_MS,
      source: SourceType.Unknown,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: SourceTool.Unknown
    };
    event.offsetY = Math.min(Math.max(event.offsetY, -startPositionY), 0);
    event.fingerList[0].globalX = startPositionX + event.offsetX;
    event.fingerList[0].globalY = startPositionY + event.offsetY;
    return event;
  }

  reset(): void {
    this.direction = ThreeFingerSwipeDirection.NONE;
    this.curSpeed = 0;
    this.curXSpeed = 0;
    this.curYSpeed = 0;
    this.speedScalar = 0;
    this.preSpeed = 0;
    this.acc = 0;
    this.swipeDownStartTime = 0;
    this.angle = 0;

    this.startEvent.reset();
    this.preEvent.reset();
    this.curEvent.reset();
    this.stopEvent.reset();
  }
}