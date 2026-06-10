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

import { AbstractInitialAble } from './AbstractInitialAble';

/**
 * 定义可观察
 */
export interface ObserverAble {
}

/**
 * 观察者管理器接口
 */
export interface ObserverManager<ObserverAble> {
  /**
   * 注册观察者
   *
   * @param observer 观察者
   */
  registerObserver(observer: ObserverAble): void;

  /**
   * 注销观察者
   *
   * @param observer 观察者
   */
  unRegisterObserver(observer: ObserverAble): void;
}

/**
 * 观察者代理
 */
export class ObserverProxy<T> extends AbstractInitialAble {
  private _observer: T;
  private _observerManager: ObserverManager<T>;
  private _callback: Function | T;

  constructor(observer: T, observerManager: ObserverManager<T>, callback: Function | T) {
    super();
    this._observer = observer;
    this._observerManager = observerManager;
    this._callback = callback;
  }

  public get callback(): Function | T {
    return this._callback;
  }

  protected doInit(): void {
    this._observerManager.registerObserver(this._observer);
  }

  protected doRelease(): void {
    this._observerManager.unRegisterObserver(this._observer);
  }
}

/**
 * 抽象观察者管理类
 */
export abstract class AbstractObserverManager<E extends ObserverAble>
  extends AbstractInitialAble implements ObserverManager<E> {
  private readonly _highPrioryObservers: Set<E> = new Set<E>();
  private readonly _lowPrioryObservers: Set<E> = new Set<E>();

  /**
   * 注册观察者
   *
   * @param observer 观察者
   * @param isCallbackImmediately 是否注册时立即回调
   */
  public registerObserver(observer: E, isCallbackImmediately: boolean = false, highPriory: boolean = true): void {
    if (highPriory) {
      this._highPrioryObservers.add(observer);
    } else {
      this._lowPrioryObservers.add(observer);
    }
  }

  /**
   * 注销观察者
   *
   * @param observer 观察者
   */
  public unRegisterObserver(observer: E): void {
    this._highPrioryObservers.delete(observer);
    this._lowPrioryObservers.delete(observer);
  }

  /**
   * 初始化动作
   */
  protected doInit(): void {
  }


  /**
   * 释放时清空观察者
   */
  protected doRelease(): void {
    this._highPrioryObservers.clear();
    this._lowPrioryObservers.clear();
  }

  /**
   * 判断是否有观察者
   *
   * @returns true是/false否
   */
  protected hasObserver(): boolean {
    return this._highPrioryObservers.size > 0 || this._lowPrioryObservers.size > 0;
  }

  /**
   * 获取观察者数目
   *
   * @returns 观察者数目
   */
  protected get observerSize(): number {
    return this._highPrioryObservers.size + this._lowPrioryObservers.size;
  }

  /**
   * 广播数据变化
   *
   * @param callback 广播回调
   */
  protected broadcastDataChange(callback: (observer: E) => void): void {
    this._highPrioryObservers.forEach(observer => callback(observer));
    this._lowPrioryObservers.forEach(observer => callback(observer));
  }
}