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
import { AbstractObserverManager } from '../base/AbstractObserverManager';

const TAG = 'ScreenLockFsm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

type Callback<S> = (oldState: S, newState: S) => void;
type Constructor<T, S> = (stateType: T) => S;

/**
 * 定义事件
 */
export abstract class AbstractEvent<E> {
  private readonly _eventType: E;

  constructor(eventType: E) {
    this._eventType = eventType;
  }

  public get eventType(): E {
    return this._eventType;
  }

  /**
   * 转化为字符串形式
   *
   * @returns 字符串形式
   */
  public abstract toString(): string;
}

/**
 * 定义状态
 */
export abstract class AbstractState<S, E> {
  /**
   * 状态码
   */
  private readonly _stateType: S;

  constructor(stateType: S) {
    this._stateType = stateType;
  }

  public get stateType(): S {
    return this._stateType;
  }

  /**
   * 转化为字符串形式
   *
   * @returns 字符串形式
   */
  public abstract toString(): string;

  /**
   * 处理事件
   *
   * @param event 事件
   * @returns 下一状态
   */
  public abstract handleEvent(event: E, fsm: AbstractFsm<S, E>): AbstractState<S, E> | S;
}

/**
 * 定义状态机匹配规则接口, 主要用于：主状态机状态切换映射到子状态事件
 */
export interface MatchRule<S, E, T> {
  /**
   * 规则匹配
   *
   * @param oldState 主状态原状态
   * @param newState 主状态新状态
   * @param event 主状态机事件
   * @returns 子状态事件
   */
  matched(oldState: S, newState: S, event?: E): T;
}

/**
 * 定义状态机回调
 */
export interface FsmCallback<S, E> {
  /**
   * 状态机状态变更回调
   *
   * @param oldState 原状态
   * @param newState 新状态
   * @param event 事件
   */
  onFsmStateChange: (oldState: S, newState: S, event?: E) => void;
}

/**
 * 定义状态工厂
 */
export abstract class AbstractStateFactory<S, E> {
  private readonly _states: Map<S, AbstractState<S, E>> = new Map<S, AbstractState<S, E>>();
  private readonly _constructors: Map<S, Constructor<S, AbstractState<S, E>>> =
    new Map<S, Constructor<S, AbstractState<S, E>>>();
  private readonly _createState?: (stateType: S) => AbstractState<S, E>; // 生产状态的函数

  constructor(createState?: (stateType: S) => AbstractState<S, E>) {
    this._createState = createState;
  }

  /**
   * 获取状态
   *
   * @param stateType 状态类型
   * @returns 状态值
   */
  public getState(stateType: S): AbstractState<S, E> {
    if (this._states.has(stateType)) {
      return this._states.get(stateType)!;
    }

    let newState: AbstractState<S, E> | undefined = undefined;
    if (this._constructors.has(stateType)) {
      let constructor: Constructor<S, AbstractState<S, E>> | undefined = this._constructors.get(stateType);
        newState = constructor?.(stateType);
    } else {
      newState = this._createState?.(stateType);
    }
    if (!newState) {
      throw new Error(`create state ${stateType} failed.`);
    }
    this._states.set(stateType, newState);
    return newState;
  }

  /**
   * 增加状态构造方法（按需加载）
   *
   * @param stateType 状态类型
   * @param constructor 构造方法
   */
  public addSateConstructor(stateType: S, constructor: Constructor<S, AbstractState<S, E>>): void {
    this._constructors.set(stateType, constructor);
  }

  /**
   * 直接增加状态（优先级最高）
   *
   * @param stateType 状态类型
   * @param state 状态
   */
  public addState(stateType: S, state: AbstractState<S, E>): void {
    this._states.set(stateType, state);
  }
}

/**
 * 定义状态机
 */
export abstract class AbstractFsm<S, E> extends AbstractObserverManager<FsmCallback<S, E>> {
  private readonly _tag: string;
  private readonly _pendingEvents: Array<E> = [];
  private readonly _stateFactory?: AbstractStateFactory<S, E>;
  private readonly _initStateType: S; // 初始状态值
  protected _preCallback?: Callback<S>; // 回调前回调
  protected _postCallback?: Callback<S>; // 回调后回调
  private _currentState: AbstractState<S, E>;
  private _isRunning: boolean = false;

  constructor(tag: string, initState?: AbstractState<S, E> | S, stateFactory?: AbstractStateFactory<S, E>) {
    super();
    this._tag = tag;
    this._stateFactory = stateFactory;
    if (initState instanceof AbstractState) {
      this._currentState = initState as AbstractState<S, E>;
    } else {
      if (!stateFactory) {
        throw new Error(`${this._tag} fsm initial failed, invalid params.`);
      } else {
        this._currentState = stateFactory.getState(initState as S);
      }
    }
    this._initStateType = this._currentState.stateType;
  }

  public registerObserver(observer: FsmCallback<S, E>, isCallbackImmediately: boolean = true,
    highPriory: boolean = true): void {
    super.registerObserver(observer, isCallbackImmediately, highPriory);
    if (isCallbackImmediately) {
      observer.onFsmStateChange(this._initStateType, this._currentState.stateType);
    }
  }

  public get currentState(): AbstractState<S, E> {
    return this._currentState;
  }

  public get currentStateType(): S {
    return this._currentState.stateType;
  }

  /**
   * 处理事件
   *
   * @param event 事件
   */
  public processEvent(event: E): void {
    if (!event) {
      return;
    }
    this._pendingEvents.push(event);
    this.handleEvent();
  }

  private handleEvent(): void {
    if (this._isRunning) {
      log.showInfo(`${this._tag} isRunning, will handle event later.`);
      return;
    }
    log.showInfo(`${this._tag} handle begin: ${this.observerSize}`);
    this._isRunning = true;
    while (this._pendingEvents.length > 0) {
      let oldState = this._currentState;
      let event = this._pendingEvents.pop()!;
      this._currentState = this.getNextState(this._currentState.handleEvent(event, this));
      this.logTransition(event, oldState, this._currentState);
      this.doCallback(oldState.stateType, this._currentState.stateType, event);
    }
    this._isRunning = false;
    log.showInfo(`${this._tag} handle end.`);
  }

  /**
   * 获取下一跳状态（重写此方法，可做定制修改）
   *
   * @param rawNewState 初始下一跳状态
   * @returns 下一跳
   */
  protected getNextState(rawNewState: AbstractState<S, E> | S): AbstractState<S, E> {
    if (rawNewState instanceof AbstractState) {
      return rawNewState as AbstractState<S, E>;
    }
    if (!this._stateFactory) {
      throw new Error(`${this._tag} getNextState failed.`);
    }
    return this._stateFactory.getState(rawNewState as S);
  }

  private logTransition(event: E, oldState: AbstractState<S, E>, newState: AbstractState<S, E>): void {
    if (event instanceof AbstractEvent) {
      log.showWarn(`${this._tag} transition: ${event.toString()} [${oldState.toString()} --> ${newState.toString()}]`);
    } else {
      log.showWarn(`${this._tag} transition: ${event} [${oldState.stateType} --> ${newState.stateType}]`);
    }
  }

  private doCallback(oldState: S, newState: S, event: E): void {
    if (this._preCallback) {
      log.showInfo('preBegin');
      this._preCallback?.(oldState, newState);
      log.showInfo('preEnd');
    }
    if (this.hasObserver()) {
      this.broadcastDataChange(observer => observer.onFsmStateChange(oldState, newState, event));
    }
    if (this._postCallback) {
      log.showInfo('postBegin');
      this._postCallback?.(oldState, newState);
      log.showInfo('postEnd');
    }
  }
}