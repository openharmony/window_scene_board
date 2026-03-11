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

import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { CoreEventType, FsmName, StateType } from './SceneBoardStateConfig';

const TAG = 'StateFsm';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const INVALID_INDEX = -1;
/**
 * 状态机可管理状态的最大值
 */
const MAX_STATES_NUM = 128;
/**
 * 默认优先级
 */
const DEFAULT_PRIORITY = 100;

/**
 * 状态机
 */
export abstract class StateFsm {
  /**
   * 状态机的标识
   */
  private readonly _name: FsmName;

  /**
   * 当前状态
   */
  private _currentState: AbstractState;

  /**
   * 管理的状态数组
   */
  private states: AbstractState[] = [];

  /**
   * 注册该状态机的监听器数组
   */
  private fsmListener: FsmListener[] = [];

  constructor(name: FsmName, initState: AbstractState) {
    this._name = name;
    this._currentState = initState;
  }

  public set currentState(state: AbstractState) {
    if (!this.getState(state.stateType)) {
      log.error(`set currentState to ${state.toString()} error, fsm does not has this state`);
      return;
    }
    this._currentState = state;
  }

  public get currentState(): AbstractState {
    return this._currentState;
  };

  public get name(): FsmName {
    return this._name;
  };

  /**
   * 初始化
   */
  public abstract init(): void;

  /**
   * 添加该状态机管理的state
   *
   * @param state 被管理的state
   * @returns 状态机
   */
  public addState(state: AbstractState): StateFsm {
    if (this.states.length > MAX_STATES_NUM) {
      log.error(`add state ${state.toString()} to fsm failed, capability is out of count`);
      return this;
    }
    if (!this.getState(state.stateType)) {
      this.states.push(state);
    }
    return this;
  }

  /**
   * 根据type类型获取state
   *
   * @param stateType type类型
   * @returns 该状态机中type类型对应的state
   */
  public getState(stateType: StateType): AbstractState | undefined {
    let found: AbstractState | undefined = this.states.find((item) => {
      return item.stateType === stateType;
    });
    return found;
  }

  /**
   * 分发事件给currentState处理
   *
   * @param event 事件类型
   * @param args 额外参数
   */
  public transfer(event: CoreEventType, ...args: Object[]): void {
    let nextStateType: StateType = this.currentState.handleEvent(event, ...args);
    let nextState: AbstractState | undefined = this.getState(nextStateType);
    if (!nextState) {
      log.showWarn(`nextStateType ${nextStateType} is invalid in ${this.name}`);
      return;
    }
    if (this.currentState.equalTo(nextState)) {
      log.showDebug(`nextState is same as ${this.currentState.toString()} in ${this.name}`);
      return;
    }
    let oldStateType: StateType = this.currentState.stateType;
    log.showInfo(`set currentState ${this.currentState.toString()} to ${nextState.toString()} in ${this.name}`);
    this.currentState = nextState;
    this.stateChange(oldStateType, this.currentState.stateType, event);
  }

  private stateChange(oldType: StateType, newType: StateType, event: CoreEventType): void {
    this.fsmListener.forEach((listener) => {
      let logStr = `${listener.getName()} onFsmStateChange called`;
      log.showInfo(logStr + ' start');
      TraceUtil.startTrace(DomainName.SCB, logStr);
      listener.onFsmStateChange(oldType, newType, event);
      log.showInfo(logStr + ' end');
      TraceUtil.endTrace(DomainName.SCB, logStr);
    });
  }

  /**
   * 注册监听器
   *
   * @param listener 监听器
   */
  public registerListener(listener: FsmListener): void {
    let index: number = this.getListenerIndex(listener);
    if (index !== INVALID_INDEX) {
      return;
    }
    log.showInfo(`register listener: ${listener.getName()}`);
    this.fsmListener.push(listener);
    // 按照优先级进行排序
    this.fsmListener.sort((a: FsmListener, b: FsmListener) => {
      return a.getPriority() - b.getPriority();
    });
  }

  /**
   * 取消注册监听器
   *
   * @param listener 监听器
   */
  public unRegisterListener(listener: FsmListener): void {
    let index: number = this.getListenerIndex(listener);
    if (index === INVALID_INDEX) {
      return;
    }
    log.showInfo(`unRegister listener: ${listener.getName()}`);
    this.fsmListener.splice(index, 1);
  }

  private getListenerIndex(listener: FsmListener): number {
    let index: number = this.fsmListener.findIndex((item) => {
      return item.getName() === listener.getName();
    });
    return index;
  }

  /**
   * 清空监听器
   */
  public clearListener(): void {
    this.fsmListener.length = 0
  }

  /**
   * 用于对比是否相同
   *
   * @param fsm 用来对比的状态机
   * @returns true表示相同，false则不同
   */
  public equalTo(fsm: StateFsm): boolean {
    return this.name === fsm.name;
  }
}

/**
 * 定义状态
 */
export abstract class AbstractState {
  /**
   * 状态码
   */
  private readonly _stateType: StateType;

  constructor(stateType: StateType) {
    this._stateType = stateType;
  }

  public get stateType(): StateType {
    return this._stateType;
  }

  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public abstract handleEvent(event: CoreEventType, ...args: Object[]): StateType;

  /**
   * 转化为字符串形式
   *
   * @returns 字符串形式
   */
  public abstract toString(): string;

  /**
   * 用于对比是否相同
   *
   * @param state 用来对比的state
   * @returns true表示相同，false则不同
   */
  public equalTo(state: AbstractState): boolean {
    return this.stateType === state.stateType;
  }
}

/**
 * 状态变化监听器
 */
export abstract class FsmListener {
  abstract onFsmStateChange(oldState: StateType, newState: StateType, event: CoreEventType): void;

  abstract getName(): string;

  /**
   * 获取当前监听器的优先级，该值越低则优先级越高
   *
   * @returns 监听器的优先级
   */
  getPriority(): number {
    return DEFAULT_PRIORITY;
  }
}