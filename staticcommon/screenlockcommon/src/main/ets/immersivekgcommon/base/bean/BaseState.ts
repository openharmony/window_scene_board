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
import { BaseObj, StateType } from '../constants/BaseType';
import { IBaseState } from '../interface/IBaseState';

const DEFAULT_STATE = 'default_state';

/**
 * 状态管理基类
 */
export abstract class BaseState implements IBaseState {
  /**
   * 状态实例唯一标识
   */
  private readonly stateName: string = DEFAULT_STATE;

  /**
   * 私有构造，统一管理
   *
   * @param name 标识
   */
  protected constructor(name: string) {
    this.stateName = name;
  }

  /**
   * 内部初始化
   */
  protected abstract init(): void;

  /**
   * 复写IBaseState
   *
   * @returns 状态标识
   */
  public getStateId(): string {
    return this.stateName;
  }

  /**
   * 复写IBaseState
   *
   * @returns 状态类型
   */
  public abstract getStateType(): StateType;

  /**
   * 复写IBaseState
   *
   * @param property 属性
   * @param value 属性值
   * @returns 链式
   */
  public abstract setStateValue(property: string, value?: BaseObj): IBaseState;

  /**
   * 复写IBaseState
   *
   * @param property 属性
   * @param scene 场景
   * @returns 属性值
   */
  public abstract getStateValue(property: string, scene?: BaseObj): BaseObj | undefined;

   /**
   * 统一构造入口
   *
   * @param clazz 目标状态类
   * @param name 标识
   * @returns 状态实例
   */
  public static wrap<T extends BaseState>(clazz: Function, name: string = DEFAULT_STATE): T {
    let state: T = Reflect.construct(clazz, [name]);
    state.init();
    return state;
  }
}