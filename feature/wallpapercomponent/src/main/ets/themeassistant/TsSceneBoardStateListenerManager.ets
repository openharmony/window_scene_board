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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  CoreEventType,
  FsmName,
  SceneBoardStateManager,
  StateType,
  FsmListener
} from '@ohos/frameworkwrapper/Index';

const TAG: string = 'TsSceneBoardStateListenerManager';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

type ListenerCallbackFunction = (oldState: StateType, newState: StateType, event: CoreEventType) => void;

/**
 * 壁纸监听合一状态工具类
 */
export class TsSceneBoardStateListenerManager {
  private static instance: TsSceneBoardStateListenerManager | undefined = undefined;
  private listeners: Map<FsmName, CommonFsmListener[] | undefined> = new Map();

  private constructor() {

  }

  public static getInstance(): TsSceneBoardStateListenerManager {
    if (!TsSceneBoardStateListenerManager.instance) {
      TsSceneBoardStateListenerManager.instance = new TsSceneBoardStateListenerManager();
    }
    return TsSceneBoardStateListenerManager.instance;
  }

  /**
   * 注册桌面监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public registerDesktopFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.registerFsmListener(FsmName.DESKTOP_FSM, listener, source);
  }

  /**
   * 注册锁屏监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public registerScreenLockFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.registerFsmListener(FsmName.SCREEN_LOCK_FSM, listener, source);
  }

  /**
   * 注册aod监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public registerAodFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.registerFsmListener(FsmName.AOD_FSM, listener, source);
  }

  /**
   * 注册基础状态监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public registerCoreFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.registerFsmListener(FsmName.CORE_FSM, listener, source);
  }

  private registerFsmListener(name: FsmName, listener: ListenerCallbackFunction, source: string): void {
    if (!this.listeners.has(name)) {
      this.listeners.set(name, []);
    }
    if (this.listeners.get(name)?.some((value) => value.callback === listener)) {
      return;
    }
    LOG.info(TAG, `${source} register ${name} listener`);
    let commonListener: CommonFsmListener = new CommonFsmListener(name, listener);
    this.listeners.get(name)?.push(commonListener);
    SceneBoardStateManager.getInstance().registerStateChange(name, commonListener);
  }

  /**
   * 注销桌面监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public unRegisterDesktopFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.unRegisterFsmListener(FsmName.DESKTOP_FSM, listener, source);
  }

  /**
   * 注销锁屏监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public unRegisterScreenLockFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.unRegisterFsmListener(FsmName.SCREEN_LOCK_FSM, listener, source);
  }

  /**
   * 注销aod监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public unRegisterAodFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.unRegisterFsmListener(FsmName.AOD_FSM, listener, source);
  }

  /**
   * 注销基础状态监听
   *
   * @param listener 监听回调函数
   * @param source 注册来源、注册方的标签
   */
  public unRegisterCoreFsmListener(listener: ListenerCallbackFunction, source: string): void {
    this.unRegisterFsmListener(FsmName.CORE_FSM, listener, source);
  }

  private unRegisterFsmListener(name: FsmName, listener: ListenerCallbackFunction, source: string): void {
    LOG.info(TAG, `${source} unregister ${name} listener`);
    const listenerArray: CommonFsmListener[] | undefined = this.listeners.get(name);
    if (!listenerArray) {
      LOG.warn(TAG, `${source} unregister ${name} listener failed, no corresponding listener found.`);
      return;
    }

    const index: number = listenerArray.findIndex((value) => value.callback === listener);
    if (index === -1) {
      LOG.warn(TAG, `${source} unregister ${name} listener failed, no corresponding listener found.`);
      return;
    }

    SceneBoardStateManager.getInstance().unRegisterStateChange(name, listenerArray[index]);
    listenerArray.splice(index);
  }
}

class CommonFsmListener extends FsmListener {
  public name: FsmName;
  public callback: ListenerCallbackFunction;

  public constructor(name: FsmName, callback: ListenerCallbackFunction) {
    super();
    this.name = name;
    this.callback = callback;
  }

  public onFsmStateChange(oldState: StateType, newState: StateType, event: CoreEventType): void {
    LOG.info(TAG, `listen state change ${oldState} -> ${newState}, event: ${event}`);
    this.callback(oldState, newState, event);
  }

  public getName(): string {
    return this.name;
  }
}