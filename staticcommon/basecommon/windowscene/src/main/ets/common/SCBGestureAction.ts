/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export enum SCBGestureActionId {
  NONE,
  EXIT_SPLIT,
  RECENT_GESTURE_BEGIN,
  RECENT_GESTURE_UPDATE,
  RECENT_GESTURE_END,
  RECENT_GESTURE_CANCEL,
  ONE_STEP_ENTER_SPLIT,
  ONE_STEP_ENTER_MID_SCENE,
  ONE_STEP_ENTER_FLOATING,
  SPLIT_GESTURE_BEGIN,
  SPLIT_GESTURE_UPDATE,
  SPLIT_GESTURE_END,
  FLOAT_GESTURE_BEGIN,
  FLOAT_GESTURE_UPDATE,
  FLOAT_GESTURE_END,
}

export interface SCBGestureActionOption {
  id: number;
  screenId?: number;
  sessionId?: number;
  containerId?: number;
  gestureEvent?: GestureEvent;
}

/**
 * Manage info of gesture
 */
@Observed
export class SCBGestureAction {
  readonly actionId: number = SCBGestureActionId.NONE;
  readonly screenId: number;
  readonly sessionId: number = -1;
  readonly containerId: number = -1;
  readonly gestureEvent: GestureEvent = undefined;

  constructor(options: SCBGestureActionOption) {
    this.actionId = options.id;
    if (options.screenId) {
      this.screenId = options.screenId;
    }
    if (options.sessionId) {
      this.sessionId = options.sessionId;
    }
    if (options.containerId) {
      this.containerId = options.containerId;
    }
    if (options.gestureEvent) {
      this.gestureEvent = options.gestureEvent;
    }
  }
}

export class SCBRecentGestureModel {
  // the max speed 0.7vp/s
  private readonly maxGestureSpeed: number = 0.7;
  static readonly GESTURE_SPEED_NORMAL = 1;
  static readonly GESTURE_SPEED_FAST = 2;
  beginOffset: number = 0;
  beginTime: number = 0;
  endOffset: number = 0;
  endTime: number = 0;
  gestureSpeed: number = 1;

  private calRecentGestureSpeed(): number {
    let duration = (this.endTime - this.beginTime) / 1000;
    let distance = Math.abs(this.endOffset - this.beginOffset);
    this.gestureSpeed = (distance / (0.5 + duration)) * 1000;
    return this.gestureSpeed;
  }

  public getRecentGestureType(): number {
    let speed = this.calRecentGestureSpeed();
    if (speed > this.maxGestureSpeed) {
      return SCBRecentGestureModel.GESTURE_SPEED_FAST;
    }
    return SCBRecentGestureModel.GESTURE_SPEED_NORMAL;
  }

  public reset(): void {
    this.beginOffset = 0;
    this.endOffset = 0;
    this.beginTime = 0;
    this.endTime = 0;
    this.gestureSpeed = 0;
  }
}