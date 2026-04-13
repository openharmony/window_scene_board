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

/**
 * 初始化接口
 */
export interface InitialAble {
  /**
   * 初始化
   */
  init(params?: object): void;

  /**
   * 释放
   */
  release(): void;
}

/**
 * 抽象可初始化基类
 */
export abstract class AbstractInitialAble implements InitialAble {
  private _hasInit: boolean = false;

  /**
   * 初始化
   */
  public init(params?: object | number): void {
    if (this.isSupport()) {
      this.doInit(params);
      this._hasInit = true;
    }
  }

  /**
   * 释放
   */
  public release(): void {
    if (this._hasInit) {
      this.doRelease();
      this._hasInit = false;
    }
  }

  public hasInit(): boolean {
    return this._hasInit;
  }

  /**
   * 是否支持初始化
   *
   * @returns true支持/false不支持
   */
  protected isSupport(): boolean {
    return true;
  }

  /**
   * 执行初始化
   */
  protected abstract doInit(params?: object | number): void;

  /**
   * 执行释放
   */
  protected abstract doRelease(): void;
}