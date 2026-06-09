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

import { CapsulePositionType, CardAnimType } from '../ImmersiveConstants';
import { ImmersiveAnimKey } from './ImmersiveAnimConstants';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WBaseProperty } from '@ohos/screenlockcommon';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

/**
 * 沉浸锁屏属性动画参数
 */
export class ImmersiveAnimParam implements AnimateParam {
  /**
   * 属性类型集合
   */
  public properties: WBaseProperty[] = [];

  /**
   * 起始值集合
   */
  public startValues: number[] = [];

  /**
   * 结束值集合
   */
  public endValues: number[] = [];

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
   * 动画属性值
   */
  animPros(properties: WBaseProperty[]): ImmersiveAnimParam {
    this.properties = properties;
    return this;
  }

  /**
   * 动画起始属性值
   */
  animStartValue(startValue: number[]): ImmersiveAnimParam {
    this.startValues = startValue;
    return this;
  }

  /**
   * 动画结束属性值
   */
  animEndValue(endValue: number[]): ImmersiveAnimParam {
    this.endValues = endValue;
    return this;
  }

  /**
   * 设置时长
   */
  animDuration(duration: number): ImmersiveAnimParam {
    this.duration = duration;
    return this;
  }

  /**
   * 设置曲线
   */
  animCurve(curve: Curve | ICurve | string): ImmersiveAnimParam {
    this.curve = curve;
    return this;
  }

  /**
   * 设置延时
   */
  animDelay(delay: number): ImmersiveAnimParam {
    this.delay = delay;
    return this;
  }

  /**
   * 设置动画播放完成回调
   */
  animFinish(finish: () => void): ImmersiveAnimParam {
    this.onFinish = finish;
    return this;
  }

  /**
   * 设置状态属性为起始值
   *
   * @param state 动效状态
   * @returns 是否设置成功
   */
  setStateToStart(state: WidgetAnimState) : boolean {
    return this.setStateProperties(state, this.properties, this.startValues);
  }

  /**
   * 设置状态属性为结束值
   *
   * @param state 动效状态
   * @returns 是否设置成功
   */
  setStateToEnd(state: WidgetAnimState): boolean {
    return this.setStateProperties(state, this.properties, this.endValues);
  }

  /**
   * 清除状态参数
   */
  clearStatePro(state: WidgetAnimState): void {
    this.properties?.forEach(type => this.clearStateProperty(state, type));
  }

  public clone(): ImmersiveAnimParam {
    let cloneEntry = new ImmersiveAnimParam();
    cloneEntry.properties = this.properties;
    cloneEntry.startValues = this.startValues;
    cloneEntry.endValues = this.endValues;
    cloneEntry.duration = this.duration;
    cloneEntry.curve = this.curve;
    cloneEntry.delay = this.delay;
    cloneEntry.onFinish = this.onFinish;
    return cloneEntry;
  }

  /**
   * 设置状态的多参数值
   *
   * @param state 状态
   * @param type 属性类型
   * @param value 属性值
   * @returns 是否设置成功
   */
  private setStateProperties(state: WidgetAnimState, properties: WBaseProperty[], values: number[]): boolean {
    let len = properties?.length ?? 0;
    if (len !== values?.length) {
      return false;
    }
    for (let i = 0; i < len; i++) {
      this.setStateProperty(state, properties[i], values[i]);
    }
    return true;
  }

  /**
   * 设置状态的参数值
   *
   * @param state 状态
   * @param type 参数类型
   * @param value 参数值
   */
  private setStateProperty(state: WidgetAnimState, type: WBaseProperty, value: number): void {
    state?.setStateValue(type, value);
  }

  /**
   * 清除状态的参数值
   *
   * @param state 状态
   * @param type 参数类型
   */
  private clearStateProperty(state: WidgetAnimState, type: WBaseProperty): void {
    state?.clearProperty(type);
  }
}

/**
 * 动效状态合集
 *
 *  string 动效场景值
 * WidgetAnimState 动效
 */
export const ANIM_STATE_MAP: Map<string, WidgetAnimState> = new Map([
  /**
   * 沉浸胶囊根布局动效状态
   */
  [ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT.valueOf(),
    BaseState.wrap(WidgetAnimState, ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT)],
  /**
   * 沉浸胶囊内容胶囊动效状态
   */
  [CapsulePositionType.TYPE_CONTENT.valueOf(), BaseState.wrap(WidgetAnimState, CapsulePositionType.TYPE_CONTENT)],
  /**
   * 沉浸胶囊阴影胶囊动效状态
   */
  [CapsulePositionType.TYPE_SHADOW.valueOf(), BaseState.wrap(WidgetAnimState, CapsulePositionType.TYPE_SHADOW)],
  /**
   * 沉浸卡片内容根布局动效状态
   */
  [ImmersiveAnimKey.IMMERSIVE_CARD_ROOT.valueOf(),
    BaseState.wrap(WidgetAnimState, ImmersiveAnimKey.IMMERSIVE_CARD_ROOT)],
  /**
   * 沉浸卡片更新场景卡片动效状态
   */
  [CardAnimType.CARD_UPDATE_TYPE.valueOf(), BaseState.wrap(WidgetAnimState, CardAnimType.CARD_UPDATE_TYPE)],
  /**
   * 沉浸卡片切换场景卡片动效状态
   */
  [CardAnimType.CARD_TOGGLE_TYPE.valueOf(), BaseState.wrap(WidgetAnimState, CardAnimType.CARD_TOGGLE_TYPE)],
  /**
   * 锁屏通知列表根布局动效状态
   */
  [ImmersiveAnimKey.IMMERSIVE_LIST_ROOT.valueOf(),
    BaseState.wrap(WidgetAnimState, ImmersiveAnimKey.IMMERSIVE_LIST_ROOT)],

]);