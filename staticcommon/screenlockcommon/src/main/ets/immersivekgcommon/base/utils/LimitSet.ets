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
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'LimitSet';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DEFAULT_MAX_SIZE = Number.MAX_VALUE;
const DEFAULT_SET_NAME = 'default_limit_set';

/**
 * 限制大小的Set
 */
export class LimitSet<T> {
  // Set名称
  private readonly setName: string = DEFAULT_SET_NAME;
  // 最大size限制
  private readonly maxSize: number = DEFAULT_MAX_SIZE;
  // Set
  private readonly innerSet: Set<T> = new Set();

  constructor(name?: string, maxSize?: number) {
    if (name) {
      this.setName = name;
    }
    if (maxSize && maxSize > 0) {
      this.maxSize = maxSize;
    }
  }

  public add(value: T): LimitSet<T> {
    if (this.innerSet.size >= this.maxSize) {
      log.showWarn(`${this.setName} limit size, max size ${this.maxSize}`);
      return this;
    }
    this.innerSet.add(value);
    return this;
  }

  public clear(): void {
    this.innerSet.clear();
  }

  public delete(value: T): boolean {
    return this.innerSet.delete(value);
  }

  public forEach(callback: (value: T, value2: T, set: Set<T>) => void): void {
    this.innerSet.forEach(callback);
  }

  public has(value: T): boolean {
    return this.innerSet.has(value);
  }

  public size(): number {
    return this.innerSet.size;
  }

  public isEmpty(): boolean {
    return this.size() <= 0;
  }

  public castArray(): Array<T> {
    return Array.from(this.innerSet);
  }
}