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

import { CommonUtils } from '@ohos/basicutils';
import { WBaseProperty } from '@ohos/screenlockcommon';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

export interface PropertyAnimValues {
  type: WBaseProperty; // 属性类型
  start: number; // 起始值
  end: number; // 终止值
}

/**
 * 动效节点
 */
export class ImmersiveAnimNode {
  /**
   * 动效状态
   */
  public state: WidgetAnimState;

  /**
   * 动效属性值集合
   */
  public propValues: Map<WBaseProperty, PropertyAnimValues> = new Map();

  /**
   * 是否开启裁剪
   */
  public isEnableClip?: boolean;

  /**
   * 构造函数
   */
  constructor(state: WidgetAnimState) {
    this.state = state;
  }

  /**
   * 增加动效属性值
   */
  addPropValue(value: PropertyAnimValues): ImmersiveAnimNode {
    this.propValues.set(value.type, value);
    return this;
  }

  /**
   * 设置动效属性值
   */
  setPropValue(value: PropertyAnimValues): ImmersiveAnimNode {
    let propValue = this.propValues.get(value.type);
    if (propValue != null) {
      propValue.start = value.start;
      propValue.end = value.end;
    }
    return this;
  }

  /**
   * 动效过程中是否开启裁剪
   */
  enableClip(clip: boolean): ImmersiveAnimNode {
    this.isEnableClip = clip;
    return this;
  }

  /**
   * 设置状态属性值到起始值
   */
  setStateToStart(): void {
    if (CommonUtils.isInvalid(this.state)) {
      return;
    }
    this.propValues.forEach((value, type) => this.state?.setStateValue(type, value.start));
    if (this.isEnableClip) {
      this.state?.setClip(true);
    }
  }

  /**
   * 设置状态属性值到终止值
   */
  setStateToEnd(): void {
    if (CommonUtils.isInvalid(this.state)) {
      return;
    }
    this.propValues.forEach((value, type) => this.state?.setStateValue(type, value.end));
  }

  /**
   * 清除状态属性值
   */
  clearState(): void {
    if (CommonUtils.isInvalid(this.state)) {
      return;
    }
    this.propValues.forEach((value, type) => this.state?.clearProperty(type));
    if (this.isEnableClip) {
      this.state?.setClip();
    }
  }
}

/**
 * 动效单元
 */
export class ImmersiveAnimUnit {
  /**
   * 节点集合
   */
  public nodes: Map<WidgetAnimState, ImmersiveAnimNode> = new Map();

  /**
   * 动画时长
   */
  public duration?: number;

  /**
   * 动画曲线
   */
  public curve?: Curve | ICurve | string;

  /**
   * 动画延迟播放时间
   */
  public delay?: number;

  /**
   * 动画播放完成回调
   */
  public onFinish?: () => void;

  /**
   * 增加节点
   */
  addAnimNode(node: ImmersiveAnimNode): ImmersiveAnimUnit {
    this.nodes.set(node.state, node);
    return this;
  }

  /**
   * 设置时长
   *
   * @param duration
   * @returns 动画参数本身
   */
  animDuration(duration: number): ImmersiveAnimUnit {
    this.duration = duration;
    return this;
  }

  /**
   * 设置曲线
   *
   * @param curve
   * @returns 动画参数本身
   */
  animCurve(curve: Curve | ICurve | string): ImmersiveAnimUnit {
    this.curve = curve;
    return this;
  }

  /**
   * 设置延时
   *
   * @param delay
   * @returns 动画参数本身
   */
  animDelay(delay: number): ImmersiveAnimUnit {
    this.delay = delay;
    return this;
  }

  /**
   * 设置动画播放完成回调
   *
   * @param 结束回调
   * @returns 动画参数本身
   */
  animFinish(finish: () => void): ImmersiveAnimUnit {
    this.onFinish = finish;
    return this;
  }

  /**
   * 设置状态属性值到起始值
   */
  setStateToStart(): void {
    this.nodes.forEach(node => {
      node.setStateToStart();
    });
  }

  /**
   * 设置状态属性值到终止值
   */
  setStateToEnd(): void {
    this.nodes.forEach(node => {
      node.setStateToEnd();
    });
  }

  /**
   * 清除状态属性值
   */
  clearState(): void {
    this.nodes.forEach(node => {
      node.clearState();
    });
  }

  /**
   * 设置属性值
   */
  setPropertyValue(state: WidgetAnimState, values: PropertyAnimValues) {
    this.nodes.get(state)?.setPropValue(values);
  }
}