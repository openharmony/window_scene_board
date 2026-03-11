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

/* 注意！本文件不允许引入非ohos底座以外的模块，否则容易导致SingleManager循环依赖 */
import { SingleBase, SingleBaseType } from './SingleManager';

/**
 * SingleInstance的DFR组件。
 * 可以记录判断类型的一致性
 */
export class SingleManagerDfr {
  private enable: boolean = false;
  constructor(enable: boolean) {
    this.enable = enable;
  }

  /**
   * 开启校验
   * @param enable 开启/关闭
   */
  public setEnable(enable: boolean): void {
    this.enable = enable;
  }

  /**
   * 检查实例是否指定类型或者类型的子类
   * @param className 类型名
   * @param instance 实例
   * @returns 校验结果
   */
  public isInstance<T extends SingleBase>(className: SingleBaseType<T>, instance: T): boolean {
    if (!this.enable) {
      return true;
    }

    if (!(instance instanceof SingleBase)) {
      return false;
    }

    return instance instanceof className;
  }
}