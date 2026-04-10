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
import { LogHelper, LogDomain, SingletonHelper } from '@ohos/basicutils';
import display from '@ohos.display';

const TAG = 'GestureHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class GestureHelper {
  private readonly NS_COUNT_PER_MS: number = 1000000;
  private readonly STOP_SPEED_LIMIT: number = 0.15;
  public startEvent: GestureEvent | null = null;
  /* duration of stop event */
  public stopDuration: number = 0;
  /* the current speed of gesture event, with direction */
  public curSpeed: number = 0;
  /* speed of x and y of gesture event, sqrt(speedXVector*speedXVector + speedYVector*speedYVector) without direction */
  public speedScalar: number = 0;
  /* the current speed x of gesture event, with direction */
  public speedXVector: number = 0;
  /* the current speed y of gesture event, with direction */
  public speedYVector: number = 0;
  /* acceleration for x and y */
  public acceleration: number = 0;
  /* valid finger index in gestureEvent fingerList*/
  public validFingerIndex: number = 0;
  /* use for calculate curSpeed */
  private preEvent: GestureEvent | null = null;
  /* the last speed of gesture event, use for calculate acceleration */
  private preSpeed: number = 0;
  /* event when speed less than 0.15, for calculate stopDuration */
  private stopEvent: GestureEvent | null = null;

  public reset(): void {
    this.preEvent = null;
    this.startEvent = null;
    this.stopEvent = null;
    this.stopDuration = 0;
    this.preSpeed = 0;
    this.curSpeed = 0;
    this.speedScalar = 0;
    this.speedXVector = 0
    this.speedYVector = 0;
    this.acceleration = 0;
    this.validFingerIndex = -1;
  }

  public static isUpForward(event: GestureEvent): boolean {
    return event.offsetY <= 0;
  }

  public static isDownForward(event: GestureEvent): boolean {
    return event.offsetY > 0;
  }

  public static isNearlyYForward(event: GestureEvent): boolean {
    return Math.abs(event.offsetY) > Math.abs(event.offsetX);
  }

  public static isRightForward(event: GestureEvent): boolean {
    return event.offsetX >= 0;
  }

  public static isLeftForward(event: GestureEvent): boolean {
    return event.offsetX < 0;
  }

  public static isNearlyUpForward(event: GestureEvent): boolean {
    return GestureHelper.isUpForward(event) && GestureHelper.isNearlyYForward(event);
  }

  public static isNearlyDownForward(event: GestureEvent): boolean {
    return (!GestureHelper.isUpForward(event)) && GestureHelper.isNearlyYForward(event);
  }

  public static isNearlyXForward(event: GestureEvent): boolean {
    return Math.abs(event.offsetY) <= Math.abs(event.offsetX);
  }

  public static isNearlyRightForward(event: GestureEvent): boolean {
    return GestureHelper.isRightForward(event) && GestureHelper.isNearlyXForward(event);
  }

  public static isNearlyLeftForward(event: GestureEvent): boolean {
    return (!GestureHelper.isRightForward(event)) && GestureHelper.isNearlyXForward(event);
  }

  public static getAspectRadio(): number {
    try {
      let displayInfo = display.getDefaultDisplaySync();
      if (displayInfo.height !== 0) {
        return displayInfo.width / displayInfo.height;
      }
      return 0;
    } catch (error) {
      log.info(`displayInfo getDefaultDisplaySync error ${error}`)
      return 0;
    }
  }

  private updateStopEvent(event: GestureEvent): void {
    if (this.speedScalar < this.STOP_SPEED_LIMIT) {
      if (this.stopEvent === null) {
        // mark the first stop event
        this.stopEvent = event;
      }
    } else {
      this.stopEvent = null;
    }
  }

  private calcStopDuration(event: GestureEvent): void {
    // calc duration when gesture event is stopped, otherwise duration is 0;
    if (this.stopEvent) {
      this.stopDuration = (event.timestamp - this.stopEvent.timestamp) / this.NS_COUNT_PER_MS;
    } else {
      this.stopDuration = 0;
    }
  }

  private calcSpeed(event: GestureEvent): void {
    if (!this.preEvent) {
      return;
    }
    let diffTime = (event.timestamp - this.preEvent.timestamp) / this.NS_COUNT_PER_MS;
    if (diffTime === 0) {
      return;
    }
    this.speedXVector = (event.offsetX - this.preEvent.offsetX) / diffTime;
    this.speedYVector = (event.offsetY - this.preEvent.offsetY) / diffTime;
    this.speedScalar = Math.sqrt(this.speedXVector * this.speedXVector + this.speedYVector * this.speedYVector);
    this.curSpeed = event.offsetY <= this.preEvent.offsetY ? -this.speedScalar : this.speedScalar;
  }

  private calcAcceleration(event: GestureEvent): void {
    if (!this.preEvent) {
      return;
    }
    let diffTime = (event.timestamp - this.preEvent.timestamp) / this.NS_COUNT_PER_MS;
    if (diffTime === 0) {
      return;
    }
    this.acceleration = (this.curSpeed - this.preSpeed) / diffTime;
  }

  public isSpeedUpForward(): boolean {
    return (this.speedYVector < 0);
  }

  public isSpeedDownForward(): boolean {
    return (this.speedYVector > 0);
  }

  public isSpeedLeftForward(): boolean {
    return (this.speedXVector < 0);
  }

  public isSpeedRightForward(): boolean {
    return (this.speedXVector > 0);
  }

  public invoke(event: GestureEvent): void {
    if (!this.preEvent) {
      this.preEvent = event;
      this.startEvent = event;
      return;
    }
    this.calcSpeed(event);
    this.calcAcceleration(event);
    this.updateStopEvent(event);
    this.calcStopDuration(event);
    log.showInfo('offsetX: %{public}d, speedX: %{public}d, offsetY: %{public}d, speedY: %{public}d',
      event.offsetX, this.speedXVector, event.offsetY, this.speedYVector);
    log.showInfo(`curSpeed: %{public}d, totalSpeed: %{public}d, acceleration: %{public}d, stopDuration: %{public}d`,
      this.curSpeed, this.speedScalar, this.acceleration, this.stopDuration);
    this.preSpeed = this.curSpeed;
    this.preEvent = event;
    this.updateValidFingerIndex(event);
  }

  public updateValidFingerIndex(event: GestureEvent): void {
    let fingerList: FingerInfo[] = event?.fingerList;
    fingerList?.forEach((fingerInfo, index) => {
      if (fingerInfo) {
        this.validFingerIndex = index;
      }
    });
  }

  public getValidFingerPosX(event: GestureEvent): number {
    let fingerList: FingerInfo[] = event?.fingerList;
    if (fingerList && this.validFingerIndex >= 0 && this.validFingerIndex <= fingerList?.length) {
      return fingerList[this.validFingerIndex].globalX;
    }
    return 0;
  }
}

export const gestureHelperInstance: GestureHelper = SingletonHelper.getInstance(GestureHelper, TAG);