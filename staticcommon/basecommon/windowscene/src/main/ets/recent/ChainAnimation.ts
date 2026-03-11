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
import { SpringProperty } from './SpringModel';
import { SpringMotion } from './SpringMotion';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const DEFAULT_CHAIN_VALUE_ACCURACY: number = 0.1;
const MAX_SPACE: number = 1000;
const MIN_SPACE: number = -1000;
const STIFFNESS_RADIUS = 130;
const DAMPING_RADIUS = 20;
const DEFAULT_CONDUCTIVITY: number = 0.95;
const DEFAULT_DELTA_RATIO: number = 0.3;
const DEFAULT_INTENSITY: number = 1;
const DEFAULT_EDGE_EFFECT_INTENSITY: number = 0.3;
const ONE_FRAME_MAX_TIME: number = 10;
const ONE_FRAME_DEFAULT_TIME: number = 8.2;
const ONE_FRAME_MIN_TIME: number = 6;
const DEFAULT_RATE: number = 120;

export class ChainAnimationNode {
  spring_: SpringMotion;
  springProperty_: SpringProperty;
  index_: number;
  space_: number;
  maxSpace_: number;
  minSpace_: number;
  curPosition_: number;
  curVelocity_: number;

  constructor(
    index: number,
    space: number,
    maxSpace: number,
    minSpace: number,
    springProperty: SpringProperty
  ) {
    this.springProperty_ = springProperty;
    this.index_ = index;
    this.space_ = space;
    this.maxSpace_ = maxSpace;
    this.minSpace_ = minSpace;
    this.curPosition_ = 0;
    this.curVelocity_ = 0;
    this.spring_ = new SpringMotion(space, space, 0.0, this.springProperty_);
    this.spring_.setAccuracy(DEFAULT_CHAIN_VALUE_ACCURACY);
  }

  // 拖拽作用力
  setDelta(delta: number, duration: number): void {
    this.spring_.onTimestampChanged(duration, 0.0, false);
    this.curPosition_ = this.spring_.getCurrentPosition();
    this.curPosition_ = Math.min(Math.max(this.curPosition_ + delta, this.minSpace_), this.maxSpace_);
    this.spring_.reset(this.curPosition_, this.space_, this.curVelocity_, this.springProperty_);
  }

  reset(value: number): void {
    this.curPosition_ = value;
    this.spring_.reset(this.curPosition_, this.space_, this.curVelocity_, this.springProperty_);
  }

  getDelta(): number {
    return this.curPosition_ - this.space_;
  }

  tickAnimation(duration: number): boolean {
    this.spring_.onTimestampChanged(duration, 0.0, false);
    this.curPosition_ = this.spring_.getCurrentPosition();
    this.curVelocity_ = this.spring_.getCurrentVelocity();
    return this.spring_.isCompleted();
  }

  setIndex(index: number): void {
    this.index_ = index;
  }

  setSpace(space: number, maxSpace: number, minSpace: number): void {
    this.space_ = space;
    this.maxSpace_ = maxSpace;
    this.minSpace_ = minSpace;
  }
}

const TAG = 'ChainAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
export class ChainAnimation {
  nodes_: Map<number, ChainAnimationNode>;
  springProperty_: SpringProperty;
  springProperty2_: SpringProperty;
  timestamp_: number = 0;
  timestamp2_: number = 0;
  mainNodeAnimateTimestamp_: number = 0;
  space_: number;
  maxSpace_: number;
  minSpace_: number;
  controlIndex_: number = -1;
  maxIndex_: number = 0;
  conductivity_: number = DEFAULT_CONDUCTIVITY;
  intensity_: number = DEFAULT_INTENSITY;
  deltaRatio_: number = DEFAULT_DELTA_RATIO;
  edgeEffectIntensity_: number = DEFAULT_EDGE_EFFECT_INTENSITY;
  mainNode_: ChainAnimationNode;
  // 计算index周围需要联动的数量
  chainNodeNumber_: number;
  refreshRate_: number = DEFAULT_RATE;
  oneFrameMaxTime_: number = ONE_FRAME_MAX_TIME;
  oneFrameTime_: number = ONE_FRAME_DEFAULT_TIME;
  oneFrameMinTime_: number = ONE_FRAME_MIN_TIME;

  constructor(space: number, maxSpace: number, minSpace: number, springProperty: SpringProperty, chainNodeNumber: number) {
    this.springProperty_ = springProperty;
    this.springProperty2_ = new SpringProperty(1, STIFFNESS_RADIUS, DAMPING_RADIUS);
    this.space_ = space;
    this.maxSpace_ = maxSpace;
    this.minSpace_ = minSpace;
    this.nodes_ = new Map<number, ChainAnimationNode>();
    this.chainNodeNumber_ = chainNodeNumber;
    for (let i = 1; i < chainNodeNumber; i++) {
      this.nodes_.set(i, new ChainAnimationNode(i, space, maxSpace, minSpace, springProperty));
      this.nodes_.set(-i, new ChainAnimationNode(-i, space, maxSpace, minSpace, springProperty));
    }
    this.mainNode_ = new ChainAnimationNode(0, 0, MAX_SPACE, MIN_SPACE, this.springProperty2_);
  }

  setDelta(delta: number, timestamp: number): void {
    let duration = (timestamp - this.timestamp_);
    let factor = this.deltaRatio_ * this.intensity_;

    for (let i = 1; i < this.chainNodeNumber_; i++) {
      let nextDelta = delta * factor;
      this.nodes_.get(i).setDelta(nextDelta, duration);
      this.nodes_.get(-i).setDelta(-nextDelta, duration);
      factor *= this.conductivity_;
    }
    this.timestamp_ = timestamp;
  }

  getValue(index: number): number {
    let value = this.mainNode_.getDelta();
    // this.controlIndex_ = -1时是进多任务滑动的第一帧，此时只需要累加一个节点偏移量
    let right =
      this.controlIndex_ === -1 ? 1 : Math.min(Math.abs(index - this.controlIndex_), this.chainNodeNumber_ - 1);
    if (index > this.controlIndex_) {
      for (let i = 1; i <= right; i++) {
        value += this.nodes_.get(i).getDelta();
      }
    } else if (index < this.controlIndex_) {
      for (let i = 1; i <= right; i++) {
        value -= this.nodes_.get(-i).getDelta();
      }
    }
    if (isNaN(value)) {
      return 0;
    }
    return value;
  }

  setControlIndex(index: number, timestamp: number): number {
    if (index === this.controlIndex_) {
      return 0.0;
    }
    let delta = this.getValue(index);
    if (this.controlIndex_ !== -1) {
      this.changeNodes(index);
    }
    this.controlIndex_ = index;
    this.mainNode_.reset(delta);
    this.timestamp2_ = timestamp;
    return delta;
  }

  changeNodes(index: number): void {
    let tmpNodes: Map<number, ChainAnimationNode> = new Map<number, ChainAnimationNode>();
    let dt = index - this.controlIndex_;
    for (let i = 1; i < this.chainNodeNumber_; i++) {
      let next = i + dt <= 0 ? i + dt - 1 : i + dt;
      if (next > -this.chainNodeNumber_ && next < this.chainNodeNumber_) {
        let nextNode = this.nodes_.get(next);
        nextNode.setIndex(i);
        tmpNodes.set(i, nextNode);
      } else {
        tmpNodes.set(i, new ChainAnimationNode(i, this.space_, this.maxSpace_, this.minSpace_, this.springProperty_));
      }

      let prev = dt - i >= 0 ? dt - i + 1 : dt - i;
      if (prev > -this.chainNodeNumber_ && prev < this.chainNodeNumber_) {
        let preNode = this.nodes_.get(prev);
        preNode.setIndex(-i);
        tmpNodes.set(-i, preNode);
      } else {
        tmpNodes.set(-i, new ChainAnimationNode(-i, this.space_, this.maxSpace_, this.minSpace_, this.springProperty_));
      }
    }
    this.nodes_ = tmpNodes;
  }

  getControlIndex(): number {
    return this.controlIndex_;
  }

  initControlIndex(): void {
    this.controlIndex_ = -1;
  }

  setMaxIndex(index: number): void {
    this.maxIndex_ = index;
  }

  setConductivity(value: number): void {
    this.conductivity_ = value;
  }

  setIntensity(value: number): void {
    this.intensity_ = value;
  }

  setEdgeEffectIntensity(value: number): void {
    this.edgeEffectIntensity_ = value;
  }

  setSpace(space: number, maxSpace: number, minSpace: number): void {
    this.space_ = space;
    this.maxSpace_ = maxSpace;
    this.minSpace_ = minSpace;
    for (let i = 1; i < this.chainNodeNumber_; i++) {
      this.nodes_.get(i).setSpace(space, maxSpace, minSpace);
      this.nodes_.get(-i).setSpace(space, maxSpace, minSpace);
    }
  }

  updateOneFrameTime(reFreshRate: number): void {
    if (reFreshRate === this.refreshRate_) {
      return;
    }
    log.showInfo(`update reFreshRate from ${this.refreshRate_} to ${reFreshRate}`);
    this.refreshRate_ = reFreshRate;
    let ratio = DEFAULT_RATE / reFreshRate;
    this.oneFrameMaxTime_ = ONE_FRAME_MAX_TIME * ratio;
    this.oneFrameTime_ = ONE_FRAME_DEFAULT_TIME * ratio;
    this.oneFrameMinTime_ = ONE_FRAME_MIN_TIME * ratio;
  }

  // 弹簧作用力
  tickAnimation(timestamp: number): void {
    this.updateChainAnimationTimestamp(timestamp);
    let duration = timestamp - this.timestamp_;
    let finish = true;
    for (let i = 1; i < this.chainNodeNumber_; i++) {
      finish = this.nodes_.get(i).tickAnimation(duration) && finish;
      finish = this.nodes_.get(-i).tickAnimation(duration) && finish;
    }
    this.mainNode_.tickAnimation(timestamp - this.timestamp2_);
    this.mainNodeAnimateTimestamp_ = timestamp - this.timestamp2_;
  }

  /**
   *  当链式动效回调的时间间隔不对时，对链式动效的时间进行修复，保证动效平滑
   */
  private updateChainAnimationTimestamp(timestamp: number): void {
    // 距离上一次回调的间隔时间
    let diffTimeStamp = (timestamp - this.timestamp2_) - this.mainNodeAnimateTimestamp_;
    // 针对插帧方案或者其他丢帧情况，导致间隔时间大于一帧最大的时间
    // 或者小于一帧最小的时间，mainNode的弹簧动效异常，此时调整时间使弹簧接续
    // 修改后使得此次duration值为this.oneFrameTime_
    let largerThanOneFrameMaxTime = diffTimeStamp > this.oneFrameMaxTime_;
    let lessThanOneFrameMinTime = diffTimeStamp < this.oneFrameMinTime_ && diffTimeStamp >= 0;
    if (largerThanOneFrameMaxTime || lessThanOneFrameMinTime) {
      this.timestamp2_ = timestamp - this.mainNodeAnimateTimestamp_ - this.oneFrameTime_;
      this.timestamp_ = timestamp - this.oneFrameTime_;
    }
  }

  getMaxSpaceRange(): number {
    return Math.max(this.maxSpace_ - this.space_, this.space_ - this.minSpace_);
  }

  reset(): void {
    for (let i = 1; i < this.chainNodeNumber_; i++) {
      this.nodes_.get(i).curVelocity_ = 0;
      this.nodes_.get(i)?.reset(this.nodes_.get(i).space_);
      this.nodes_.get(-i).curVelocity_ = 0;
      this.nodes_.get(-i)?.reset(this.nodes_.get(-i).space_);
    }
    this.mainNode_.curVelocity_ = 0;
    this.mainNode_.reset(this.mainNode_.space_);
  }
}