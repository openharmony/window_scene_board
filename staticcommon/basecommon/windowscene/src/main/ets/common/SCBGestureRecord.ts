/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { GestureNavigationState } from '../gesturenavigation/SCBGestureManager';

const TAG = 'SCBGestureRecord';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * SCBGestureRecord
 */
export class SCBGestureRecord {

  /**
   * current state
   */
  private curState: GestureNavigationState = GestureNavigationState.END;

  /**
   * current gesture event
   */
  private curGestureEvent: GestureEvent | null = null;

  /**
   * start gesture event
   */
  private startGestureEvent: GestureEvent | null = null;

  private preGlobalOffsetX: number = 0;
  private preGlobalOffsetY: number = 0;

  /**
   * used to promise gesture is complete
   */
  private cancelEvent: ((event: GestureEvent) => void) | null = null;

  public constructor(cancelEvent: ((event: GestureEvent) => void) | null = null) {
    this.cancelEvent = cancelEvent;
  }

  public getCurAction(): GestureNavigationState {
    return this.curState;
  }

  public recordCurGesture(state: GestureNavigationState, event: GestureEvent | null = null): void {
    if (state === GestureNavigationState.UPDATE && this.curState === GestureNavigationState.CANCEL) {
      return;
    }
    this.curState = state;
    this.curGestureEvent = event;
    if (state === GestureNavigationState.START) {
      this.startGestureEvent = event;
      this.preGlobalOffsetX = 0;
      this.preGlobalOffsetY = 0;
    }
  }

  public processCancel(): void {
    log.showInfo(`processCancel ${this.curState}`);
    if (this.curState === GestureNavigationState.END || this.curState === GestureNavigationState.CANCEL) {
      return;
    }
    if (!this.cancelEvent || !this.curGestureEvent) {
      return;
    }
    this.cancelEvent(this.curGestureEvent);
    this.curState = GestureNavigationState.CANCEL;
  }

  public get startEvent(): GestureEvent | null {
    return this.startGestureEvent;
  }

  public set preOffsetX(x: number) {
    this.preGlobalOffsetX = x;
  }

  public get preOffsetX(): number {
    return this.preGlobalOffsetX;
  }

  public set preOffsetY(y: number) {
    this.preGlobalOffsetY = y;
  }

  public get preOffsetY(): number {
    return this.preGlobalOffsetY;
  }
}