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
import { SpringProperty, SpringModelType, SpringModel } from './SpringModel';

const UNIT_CONVERT: number = 1000.0;
const NEAR_ZERO_RADIUS: number = 0.1;
export class SpringMotion {
  // the threshold close to zero
  nearZero: number = NEAR_ZERO_RADIUS;
  endPosition_: number = 0.0;
  currentPosition_: number = 0.0;
  currentVelocity_: number = 0.0;
  accuracy_: number = this.nearZero;
  model_: SpringModel;

  constructor(start: number, end: number, velocity: number, spring: SpringProperty) {
    this.reset(start, end, velocity, spring);
  }

  move(offsetTime: number): void {
    if (!this.model_) {
      return;
    }
    // change millisecond to second.
    let offsetTimeInSecond = offsetTime / UNIT_CONVERT;
    this.currentPosition_ = this.endPosition_ + this.model_.position(offsetTimeInSecond);
    this.currentVelocity_ = this.model_.velocity(offsetTimeInSecond);
    if (this.isCompleted()) {
      this.currentPosition_ = this.endPosition_;
      this.currentVelocity_ = 0.0;
    }
  }

  getType(): SpringModelType {
    if (!this.model_) {
      return SpringModelType.CRITICAL_DAMPED;
    }
    return this.model_.getType();
  }

  getCurrentPosition(): number {
    return this.currentPosition_;
  }

  getCurrentVelocity(): number {
    return this.currentVelocity_;
  }

  getEndValue(): number {
    return this.endPosition_;
  }

  isCompleted2(value: number, velocity: number): boolean {
    return (Math.abs(value - this.endPosition_) < this.accuracy_) && (Math.abs(velocity) < this.accuracy_);
  }

  isCompleted(): boolean {
    return this.isCompleted2(this.currentPosition_, this.currentVelocity_);
  }

  setAccuracy(accuracy: number): void {
    this.accuracy_ = Math.abs(accuracy);
  }

  reset(start: number, end: number, velocity: number, spring: SpringProperty): void {
    this.currentPosition_ = start;
    this.currentVelocity_ = velocity;
    this.endPosition_ = end;
    this.model_ = SpringModel.build(start - end, velocity, spring);
  }

  onTimestampChanged(timestamp: number, normalizedTime: number, reverse: boolean): void {
    this.move(timestamp);
  }
}
