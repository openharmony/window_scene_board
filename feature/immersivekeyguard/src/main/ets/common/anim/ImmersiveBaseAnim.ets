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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { ImmersiveTraceHelper } from '../helper/ImmersiveTraceHelper';
import { ImmersiveAnimScene } from './ImmersiveAnimConstants';
import { ImmersiveAnimUnit, PropertyAnimValues } from './ImmersiveAnimUnit';

const TAG = 'ImmersiveBaseAnim';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 基础动效
 */
export class ImmersiveBaseAnim {
  /**
   * 动效场景
   */
  protected scene: ImmersiveAnimScene;

  /**
   * 动效状态集合
   */
  protected states: Set<WidgetAnimState> = new Set();

  /**
   * 是否在运行中
   */
  protected isRun: boolean = false;

  /**
   * 动效单元集合
   */
  private units: ImmersiveAnimUnit[] = [];

  /**
   * 下一动效
   */
  private nextAnim?: ImmersiveBaseAnim;

  /**
   * 动效开启前初始化是否生效
   */
  private isEnableStartInit: boolean = true;

  /**
   * 动效结束后初始化是否生效
   */
  private isEnableEndUninit: boolean = true;

  /**
   * 结束回调
   */
  private endCallback?: () => void;

  /**
   * 构造函数
   *
   * @param scene 动效场景
   */
  constructor(scene: ImmersiveAnimScene) {
    this.scene = scene;
  }

  /**
   * 设置是否在动效中
   *
   * @param isAnimating 是否在动效中
   */
  protected setAnimating(isAnimating: boolean): void {
    this.states.forEach(state => {
      state?.setAnimScene({ isAnimating: isAnimating, animScene: this.scene });
    });
  }

  /**
   * 动效trace
   */
  protected animTrace(isStart: boolean): void {
    if (isStart) {
      ImmersiveTraceHelper.startAnimTrace(this.scene);
    } else {
      ImmersiveTraceHelper.endAnimTrace(this.scene);
    }
  }

  /**
   * 增加动效单元, 最后一个为动效执行时间最长单元
   *
   * @param unit 动效单元
   */
  addAnimUnit(unit: ImmersiveAnimUnit): ImmersiveBaseAnim {
    this.units.push(unit);
    unit.nodes.forEach(node => {
      this.states.add(node?.state);
    });
    return this;
  }

  /**
   * 增加动效状态, 用于设置不实际参与动效的组件的是否处于动效中状态值
   *
   * @param state 动效状态
   */
  addAnimState(state: WidgetAnimState): ImmersiveBaseAnim {
    this.states.add(state);
    return this;
 }

  /**
   * 动效是否在运行中
   *
   * @returns 动效是否在运行中
   */
  isRunning(): boolean {
    return this.isRun;
  }

  /**
   * 启动动效
   *
   * @param onStart 起始回调函数
   * @param onEnd 结束回调函数
   */
  start(onStart?:() => void, onEnd?: () => void): void {
    let len = this.units.length;
    if (len <= 0 || this.isRun) {
      return;
    }
    onStart?.();
    this.beforeSetStateToStart();
    this.units.forEach(unit => {
      unit?.setStateToStart();
    });
    this.endCallback = onEnd;
    this.units[len - 1].onFinish = () => {
      if (!this.isRun) {
        return;
      }
      this.setStateAfterAnimEnd();
      this.processEndCallback();
    };

    this.units.forEach(unit => {
      animateTo({
        duration: unit.duration,
        curve: unit.curve,
        delay: unit.delay,
        onFinish: unit.onFinish
      }, () => {
        unit?.setStateToEnd();
      });
    });
  }

  /**
   * 获取组件动效状态集
   *
   * @returns 组件动效状态集
   */
  getComponentAnimStates(): Set<WidgetAnimState> {
    return this.states;
  }

  /**
   * 设置下一动效, 用于连续动效场景
   *
   * @param nextAnim 下一动效
   */
  setNextAnim(nextAnim: ImmersiveBaseAnim) {
    this.nextAnim = nextAnim;
  }

  /**
   * 清除状态
   */
  clearState(): void {
    this.units.forEach(unit => {
      unit?.clearState();
    });
  }

  /**
   * 在初始化状态到起始状态前的操作
   */
  beforeSetStateToStart() {
    this.isRun = true;
    if (this.isEnableStartInit) {
      this.setAnimating(true);
      this.animTrace(true);
      log.showInfo(`${this.scene} start`);
    }
  }

  /**
   * 在动效结束后的操作
   */
  setStateAfterAnimEnd() {
    this.isRun = false;
    if (this.isEnableEndUninit) {
      this.animTrace(false);
      this.setAnimating(false);
      this.clearState();
      log.showInfo(`${this.scene} end`);
    }
  }

  /**
   * 设置状态的属性值
   *
   * @param unitIndex 单元索引
   * @param state 状态值
   * @param value 属性值
   */
  setStateValue(unitIndex: number, state: WidgetAnimState, value: PropertyAnimValues) {
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    this.units[unitIndex]?.setPropertyValue(state, value);
  }

  /**
   * 设置初始化标记位
   *
   * @param isEnableStartInit 是否开启动效前初始化
   * @param isEnableEndUninit 是否开启动效后初始化
   */
  setInitFlag(isEnableStartInit: boolean, isEnableEndUninit: boolean) {
    this.isEnableStartInit = isEnableStartInit;
    this.isEnableEndUninit = isEnableEndUninit;
  }

  /**
   * 停止动效
   */
  exit(): void {
    log.showInfo(`exit ${this.scene}`)
    this.setStateAfterAnimEnd();
    this.endCallback?.();
    this.endCallback = undefined;
  }

  /**
   * 动效处理结束回调
   */
  private processEndCallback(): void {
    if (CommonUtils.isInvalid(this.nextAnim)) {
      this.endCallback?.();
    } else {
      this.nextAnim?.start(undefined, this.endCallback);
    }
    this.endCallback = undefined;
  }
}