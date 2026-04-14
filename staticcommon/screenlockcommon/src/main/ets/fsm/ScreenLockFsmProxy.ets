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

import { SoEvent, SoEventType, ScreenOffFsm } from './ScreenOffFsm';
import { BouncerEvent, BouncerEventType, BouncerFsm } from './BouncerFsm';
import { MainPageFsm, MpEvent, MpEventType } from './MainPageFsm';
import { CoreEvent, CoreEventType, CoreStateType, CoreStateTypeUtils, ScreenLockCoreFsm } from './ScreenLockCoreFsm';

/**
 * 事件处理监听，支持监听所有事件处理完成后来进行后置处理
 */
export interface EventCallback<T> {
  onEventFinish: (oldState: T, newState: T) => void;
}

/**
 * 代理所有的状态机
 */
export class ScreenLockFsmProxy {
  private static readonly FSM_PROXY_MAP: Map<number, ScreenLockFsmProxy> = new Map<number, ScreenLockFsmProxy>();

  /**
   * 获取对应的状态机代理
   *
   * @param persistentId 实例化ID
   * @returns 对应的状态机代理
   */
  public static getInstance(persistentId: number): ScreenLockFsmProxy {
    let fsmProxy: ScreenLockFsmProxy | undefined = ScreenLockFsmProxy.FSM_PROXY_MAP.get(persistentId);
    if (fsmProxy) {
      return fsmProxy;
    }
    fsmProxy = new ScreenLockFsmProxy(persistentId);
    ScreenLockFsmProxy.FSM_PROXY_MAP.set(persistentId, fsmProxy);
    return fsmProxy;
  }

  /**
   * 释放状态机代理
   *
   * @param persistentId 实例化ID
   */
  public static releaseInstance(persistentId: number): void {
    if (ScreenLockFsmProxy.FSM_PROXY_MAP.has(persistentId)) {
      ScreenLockFsmProxy.FSM_PROXY_MAP.delete(persistentId);
    }
  }

  private readonly _persistentId: number;
  private readonly _coreFsm: ScreenLockCoreFsm;
  private readonly _mainPageFsm: MainPageFsm;
  private readonly _bouncerFsm: BouncerFsm;
  private readonly _screenOffFsm: ScreenOffFsm;

  private _coreEventCallback: Set<EventCallback<CoreStateType>> = new Set<EventCallback<CoreStateType>>();

  private constructor(persistentId: number) {
    this._persistentId = persistentId;
    this._coreFsm = new ScreenLockCoreFsm(persistentId);
    this._mainPageFsm = new MainPageFsm(persistentId);
    this._bouncerFsm = new BouncerFsm(persistentId);
    this._screenOffFsm = new ScreenOffFsm(persistentId);
  }

  public get persistentId(): number {
    return this._persistentId;
  }

  public get coreFsm(): ScreenLockCoreFsm {
    return this._coreFsm;
  }

  public get mainPageFsm(): MainPageFsm {
    return this._mainPageFsm;
  }

  public get bouncerFsm(): BouncerFsm {
    return this._bouncerFsm;
  }

  public get screenOffFsm(): ScreenOffFsm {
    return this._screenOffFsm;
  }

  /**
   * 提交核心状态机事件
   *
   * @param event 状态机事件
   */
  public submitCoreEvent(event: CoreEvent | CoreEventType): void {
    let preState: CoreStateType = this._coreFsm.currentStateType;
    this._coreFsm.submitEvent(event);
    let newState: CoreStateType = this._coreFsm.currentStateType;
    if (preState !== newState) {
      this._coreEventCallback.forEach((callback) => {
        callback?.onEventFinish(preState, newState);
      });
    }
  }

  /**
   * 监听核心状态机机事件处理完成
   *
   * @param callback 监听回调
   */
  public registerCoreEventCallback(callback: EventCallback<CoreStateType>): void {
    this._coreEventCallback.add(callback);
  }

  /**
   * 取消监听核心状态机机事件处理完成
   *
   * @param callback 监听回调
   */
  public unregisterCoreEventCallback(callback: EventCallback<CoreStateType>): void {
    this._coreEventCallback.delete(callback);
  }

  /**
   * 提交主页状态机事件
   *
   * @param event 状态机事件
   */
  public submitMainPageEvent(event: MpEvent | MpEventType): void {
    this._mainPageFsm.submitEvent(event);
  }

  /**
   * 提交密码页状态机事件
   *
   * @param event 状态机事件
   */
  public submitBouncerEvent(event: BouncerEvent | BouncerEventType): void {
    this._bouncerFsm.submitEvent(event);
  }

  /**
   * 提交熄屏状态机事件
   *
   * @param event 状态机事件
   */
  public submitAodEvent(event: SoEvent | SoEventType): void {
    this._screenOffFsm.submitEvent(event);
  }

  /**
   * 映射主状态机状态变更
   *
   * @param oldState 主状态机原状态
   * @param newState 主状态机新状态
   * @param event 主状态机事件
   */
  public matchCoreFsmChange(oldState: CoreStateType, newState: CoreStateType, event?: CoreEvent): void {
    // 到谁的页面，谁优先处理；从那个页面解锁，谁优先处理，避免验证事件没处理
    if (CoreStateTypeUtils.isInMainPage(newState) ||
      (CoreStateTypeUtils.isInMainPage(oldState) && CoreStateTypeUtils.isInUnlockPage(newState))) {
      this._mainPageFsm.matchCoreFsmChange(oldState, newState, event);
      this._screenOffFsm.matchCoreFsmChange(oldState, newState, event);
      this._bouncerFsm.matchCoreFsmChange(oldState, newState, event);
    } else if (CoreStateTypeUtils.isInBouncePage(newState) ||
      (CoreStateTypeUtils.isInBouncePage(oldState) && CoreStateTypeUtils.isInUnlockPage(newState))) {
      this._bouncerFsm.matchCoreFsmChange(oldState, newState, event);
      this._screenOffFsm.matchCoreFsmChange(oldState, newState, event);
      this._mainPageFsm.matchCoreFsmChange(oldState, newState, event);
    } else {
      this._screenOffFsm.matchCoreFsmChange(oldState, newState, event);
      this._mainPageFsm.matchCoreFsmChange(oldState, newState, event);
      this._bouncerFsm.matchCoreFsmChange(oldState, newState, event);
    }
  }
}