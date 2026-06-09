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

import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'Drag-StateMachine';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 状态的事件切换结果
 */
export enum StateTransitionResult {
  /* 跳转下一个状态 */
  TRANSITION = 'TRANSITION',

  /* 维持当前状态 */
  CONTINUE = 'CONTINUE',

  /* 异常 */
  ERROR = 'INTERNAL_ERROR',
}

/**
 * 状态事件切换的抽象类
 */
export class StateTransition {
  private nextStateName: string;

  private event: (ctx: object) => StateTransitionResult;

  constructor(nextStateName: string = 'unknown-transition', event: (ctx: object) => StateTransitionResult) {
    this.nextStateName = nextStateName;
    this.event = event;
  }

  /**
   * 获取当前事件切换的描述字符串
   *
   * @returns 描述字符串
   */
  public getDesc(): string {
    return 'TRANS-(NEXT: ' + this.nextStateName + ')';
  }

  /**
   * 获取当前事件的下一条状态
   *
   * @returns 下一条状态
   */
  public getNextStateName(): string {
    return this.nextStateName;
  }

  /**
   * 执行业务注册的事件切换
   *
   * @param ctx 业务传入的上下文
   * @returns 切换结果
   */
  public doTransition(ctx: object): StateTransitionResult {
    return this.event(ctx);
  }

  /**
   * 根据下一条的状态判断是否当前的事件
   *
   * @param nextStateName 希望的下一条状态
   * @returns 判断结果，true表示是当前的事件
   */
  public isStateTransition(nextStateName: string): boolean {
    return this.nextStateName === nextStateName;
  }
}

/**
 * 抽象状态类
 */
export class State {
  private name: string;
  private transitions: StateTransition[] = new Array<StateTransition>();

  constructor(name: string = 'unknown-state') {
    this.name = name;
  }

  private findTransitionByName(nextStateName: string): StateTransition {
    return this.transitions.find((item) => item.isStateTransition(nextStateName));
  }

  /**
   * 获取当前状态的描述字符串
   *
   * @returns
   */
  public getDesc(): string {
    return 'STATE-(' + this.name + ')';
  }

  /**
   * 获取当前状态的名称
   *
   * @returns
   */
  public getName(): string {
    return this.name;
  }

  /**
   * 根据状态名称判断当前是否是指定的状态实例
   *
   * @param name
   * @returns
   */
  public isState(name: string) : boolean {
    return this.name === name;
  }

  /**
   * 切换状态前的执行函数，需要子类重写
   *
   * @param ctx 实例业务传入的上下文
   */
  public beforeTransition(ctx: object): void {
  }

  /**
   * 切换状态后的执行函数，需要子类重写
   *
   * @param ctx 实例业务传入的上下文
   * @param stateName 切换到的状态名
   */
  public afterTransition(ctx: object, stateName: string): void {
  }

  /**
   * 切换到此状态时的执行函数，需要子类重写
   *
   * @param ctx
   */
  public onTransitionTo(ctx: object): void {
  }

  /**
   * 切换状态
   *
   * @param ctx 实例业务传入的上下文
   */
  public transition(ctx: object): string {
    let shouldContinue: boolean = true;

    /* 依次执行当前状态的事件 */
    for (let i = 0; i < this.transitions.length; i++) {
      const res = this.transitions[i].doTransition(ctx);
      log.showDebug('%{public}s : trying transfer to %{public}s %{public}s', this.getDesc(),
        this.transitions[i].getDesc(), res);
      if (res === StateTransitionResult.TRANSITION) {
        log.showInfo('%{public}s : transfer to %{public}s', this.getDesc(), this.transitions[i].getDesc());
        return this.transitions[i].getNextStateName();
      } else if (res !== StateTransitionResult.CONTINUE) {
        shouldContinue = false;
      }
    }

    if (shouldContinue) {
      log.showDebug('%{public}s : continue now state', this.getDesc());
      return this.name;
    } else {
      log.showError('%{public}s : cannot find next state', this.getDesc());
      return null;
    }
  }

  /**
   * 为当前状态添加新的事件切换
   *
   * @param transition 待添加的新事件
   * @returns 当前状态
   */
  public addTransition(transition: StateTransition): this {
    if (!transition) {
      return this;
    }

    const exist = this.findTransitionByName(transition.getNextStateName());
    if (exist) {
      log.showWarn('transition (%{public}s) is exist in state (${public}s)',
        transition.getNextStateName(), this.getName());
      return this;
    }
    this.transitions.push(transition);
    return this;
  }
}

/*
 * 抽象状态机类
 */
export abstract class Machine {
  private name: string;
  private states: State[] = [];
  private current?: State;

  constructor(name: string = 'unknown') {
    log.showInfo(`create state machine (%{public}s)`, name);
    this.name = name;
  }

  private findStateByName(name: string): State {
    return this.states.find((state) => state.isState(name));
  }

  /**
   * 获取当前状态机的描述字符串
   *
   * @returns 当前状态机的描述字符串
   */
  public getDesc(): string {
    return 'MACHINE-(' + this.name + ')';
  }

  /**
   * 获取当前状态机所处的状态
   *
   * @returns 当前状态机所处的状态
   */
  public getCurrentState(): State {
    return this.current;
  }

  /**
   * 为状态机添加新的状态
   *
   * @param state 待添加的新状态
   * @returns 新的状态
   */
  public addState(state: State): State {
    if (!state) {
      return null;
    }

    const exist = this.findStateByName(state.getName());
    if (exist) {
      log.showWarn('%{public}s : %{public}s is exist', this.getDesc(), state.getDesc());
      return exist;
    }
    log.showInfo('%{public}s : add new %{public}s', this.getDesc(), state.getDesc());
    this.states.push(state);

    return state;
  }

  /**
   * 设置状态机的当前状态
   *
   * @param state 开始的状态
   */
  public setStart(state: State): void {
    if (!state) {
      return;
    }

    const exist = this.findStateByName(state.getName());
    if (!exist) {
      return;
    }

    /* 设置内部的状态，避免外部状态同名导致逻辑错误 */
    this.current = exist;
    log.showInfo('%{public}s : set start state as %{public}s', this.getDesc(), exist.getDesc());
  }

  /**
   * 状态机单步运行
   *
   * @param ctx 业务传入的上下文
   */
  public stepRun(ctx: object) : void {
    if (!this.current) {
      log.showError('%{public}s : current state is null ', this.getDesc());
    }
    const former = this.current;
    this.current.beforeTransition(ctx);
    const nextStateName = this.current.transition(ctx);
    this.current.afterTransition(ctx, nextStateName);
    const nextState = this.findStateByName(nextStateName);
    if (!nextState) {
      log.showError('%{public}s : next state %{public}s is not exist', this.getDesc(), nextStateName);
      return;
    }
    if (this.current !== nextState) {
      this.current = nextState;
      this.current.onTransitionTo(ctx);
    }
    log.showDebug('%{public}s : state change from %{public}s to %{public}s', this.getDesc(), former.getDesc(),
      nextState.getDesc());
  }
}