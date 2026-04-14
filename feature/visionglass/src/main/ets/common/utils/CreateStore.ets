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

type Listener<T> = (val: T) => void;
type Action<T> = (val: T) => T;

export class CreateStore<T> {
  private state: T;
  private listeners: Set<Listener<T>> = new Set();

  constructor(state: T) {
    this.state = state;
  }

  /*
   * 获取当前状态
   *
   * @return T
   * */
  public getState(): T {
    return this.state;
  }

  /*
   * 注册状态变更监听
   *
   * @param listener
   * */
  public subscribe(listener: Listener<T>): void {
    this.listeners.add(listener);
  }

  /*
   * 注销状态变更监听
   *
   * @param listener
   * */
  public unsubscribe(listener: Listener<T>): void {
    this.listeners.delete(listener);
  }

  /*
   * 同步状态并执行响应操作
   *
   * @param action
   * */
  public dispatch(action: Action<T>): void {
    if (!action) {
      return;
    }
    this.state = action(this.state);
    this.listeners.forEach(listener => {
      listener(this.state);
    });
  }
}