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
import { BaseObj, StateType } from '../constants/BaseType';
import { IBaseState } from '../interface/IBaseState';
import { IBaseStateChangeListener } from '../interface/IBaseStateChangeListener';
import { LimitSet } from '../utils/LimitSet';
import { MethodMap } from '../utils/MethodMap';
import { BaseState } from './BaseState';

const TAG = 'StaticBaseState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 普通静态状态基类
 */
export abstract class StaticBaseState extends BaseState {
  /**
   * 状态切换监听器集
   */
  private readonly stateListeners: LimitSet<IBaseStateChangeListener> = new LimitSet();

  /**
   * 赋值/取值函数集
   */
  private methods?: MethodMap<StaticBaseState>;

  /**
   * 内部初始化
   */
  protected init(): void {
    this.methods = new MethodMap(this);
    this.initSetMethods();
    this.initGetMethods();
  }

  /**
   * 日志打印拼接
   *
   * @param ori 原日志文本
   * @returns 拼接后文本
   */
  protected splicePrint(ori?: string): string {
    if (ori) {
      return `${ori} ${this.getStateType()} ${this.getStateId()}`;
    }
    return `${this.getStateType()} ${this.getStateId()}`;
  }

  /**
   * 添加赋值函数
   *
   * @param property 函数标识
   * @param method 函数
   * @returns 链式
   */
  protected addSetMethod(property: string, method: Function): StaticBaseState {
    this.methods?.addSetMethod(property, method);
    return this;
  }

  /**
   * 添加取值函数
   *
   * @param property 函数标识
   * @param method 函数
   * @returns 链式
   */
  protected addGetMethod(property: string, method: Function): StaticBaseState {
    this.methods?.addGetMethod(property, method);
    return this;
  }

  /**
   * 状态切换回调
   *
   * @param property 状态属性
   */
  protected notifyStateChange(property: string): void {
    this.stateListeners.forEach((listener) => {
      listener?.onStateChange(this.getStateType(), this.getStateId(), property);
    });
  }

  /**
   * 初始化赋值函数集
   */
  protected abstract initSetMethods(): void;

  /**
   * 初始化取值函数集
   */
  protected abstract initGetMethods(): void;

  /**
   * 复写IBaseState，注册状态切换监听器
   *
   * @param listener 监听器
   */
  public registerStateChangeListener?(listener: IBaseStateChangeListener): void {
    this.stateListeners.add(listener);
    if (listener?.listenerName) { // 记录监听器注册
      log.showInfo(`registerStateChangeListener add ${this.splicePrint(listener.listenerName)}`);
    }
  }

  /**
   * 复写IBaseState，注销状态切换监听器
   *
   * @param listener 监听器
   */
  public unregisterStateChangeListener?(listener: IBaseStateChangeListener): void {
    let result = this.stateListeners.delete(listener);
    if (result && listener?.listenerName) { // 记录监听器取消
      log.showInfo(`unregisterStateChangeListener delete ${this.splicePrint(listener.listenerName)}`);
    }
  }

  /**
   * 复写IBaseState，状态类型
   *
   * @returns 状态类型
   */
  public getStateType(): StateType {
    return StateType.STATIC;
  }

  /**
   * 复写IBaseState，状态赋值
   *
   * @param property 状态属性标示
   * @param value 赋值
   * @returns 链式
   */
  public setStateValue(property: string, value?: BaseObj | undefined): IBaseState {
    this.methods?.callSetMethod(property, value);
    return this;
  }

  /**
   * 复写IBaseState，状态取值
   *
   * @param property 状态属性标示
   * @param scene 取值场景
   * @returns 状态值
   */
  public getStateValue(property: string, scene?: BaseObj | undefined): BaseObj | undefined {
    return this.methods?.callGetMethod(property, scene);
  }
}