/**
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

/**
 * 懒加载单例Holder
 */
export class LazySingletonHolder<T> {
  private builder: () => T;
  private instance?: T;
  private before?: () => void;
  private after?: () => void;

  /**
   * 构造方法
   *
   * @param builder 实例构造方法
   * @param before 初始化前执行的方法
   * @param after 初化后执行的方法
   */
  constructor(builder: () => T, before?: () => void, after?: () => void) {
    this.builder = builder;
    this.before = before;
    this.after = after;
  }

  /**
   * 获取单例像
   *
   * @returns
   */
  public getInstance(): T {
    if (this.instance != null) {
      return this.instance;
    }

    return this.initInstance();
  }

  private initInstance(): T {
    this.execIfExists(this.before);
    this.instance = this.builder();
    this.execIfExists(this.after);

    return this.instance;
  }

  private execIfExists(method?: () => void) {
    if (method) {
      method();
    }
  }
}