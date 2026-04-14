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

import { BaseObj } from '../constants/BaseType';
import { IBaseState } from '../interface/IBaseState';
import { LimitMap } from './LimitMap';

/**
 * 实例函数转换Map集
 */
export class MethodMap<T extends IBaseState> {
  /**
   * 目标实例
   */
  private tarObj?: T;

  /**
   * set函数集，静态复用
   */
  private static setMethods: LimitMap<string, Function> = new LimitMap();

  /**
   * get函数集，静态复用
   */
  private static getMethods: LimitMap<string, Function> = new LimitMap();

  constructor(tarObj: T) {
    this.tarObj = tarObj;
  }

  /**
   * 添加目标实例的set函数
   *
   * @param key 函数标识
   * @param method 函数
   * @returns 链式
   */
  public addSetMethod(key: string, method: Function): MethodMap<T> {
    MethodMap.setMethods.set(key, method);
    return this;
  }

  /**
   * 添加目标实例的get函数
   *
   * @param key 函数标识
   * @param method 函数
   * @returns 链式
   */
  public addGetMethod(key: string, method: Function): MethodMap<T> {
    MethodMap.getMethods.set(key, method);
    return this;
  }

  /**
   * 调用目标实例set函数
   *
   * @param key 函数标识
   * @param value 函数入参
   * @returns 函数调用结果
   */
  public callSetMethod(key: string, value?: BaseObj): BaseObj | undefined {
    if (!this.tarObj) {
      return undefined;
    }
    return MethodMap.setMethods.get(key)?.call(this.tarObj, value);
  }

  /**
   * 调用目标实例get函数
   *
   * @param key 函数标识
   * @param value 函数入参
   * @returns 函数调用结果
   */
  public callGetMethod(key: string, value?: BaseObj): BaseObj | undefined {
    if (!this.tarObj) {
      return undefined;
    }
    return MethodMap.getMethods.get(key)?.call(this.tarObj, value);
  }
}