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

const TAG = 'LimitMap';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const DEFAULT_MAX_SIZE = Number.MAX_VALUE;
const DEFAULT_MAP_NAME = 'default_limit_map';

/**
 * 限制大小的Map
 */
export class LimitMap<K, V> {
  // Map名称
  private readonly mapName: string = DEFAULT_MAP_NAME;
  // 最大size限制
  private readonly maxSize: number = DEFAULT_MAX_SIZE;
  // Map
  private readonly innerMap: Map<K, V> = new Map();

  constructor(name?: string, maxSize?: number) {
    if (name) {
      this.mapName = name;
    }
    if (maxSize && maxSize > 0) {
      this.maxSize = maxSize;
    }
  }

  public clear(): void {
    this.innerMap.clear();
  }

  public delete(key: K): boolean {
    return this.innerMap.delete(key);
  }

  public forEach(callback: (value: V, key: K, map: Map<K, V>) => void): void {
    this.innerMap.forEach(callback);
  }

  public get(key: K): V | undefined {
    return this.innerMap.get(key);
  }


  public has(key: K): boolean {
    return this.innerMap.has(key);
  }

  public set(key: K, value: V): LimitMap<K, V> {
    if (this.innerMap.size >= this.maxSize) {
      if (this.innerMap.has(key)) {
        this.innerMap.set(key, value);
        return this;
      }
      log.showWarn(`${this.mapName} limit size, max size ${this.maxSize}`);
      return this;
    }
    this.innerMap.set(key, value);
    return this;
  }

  public size(): number {
    return this.innerMap.size;
  }

  public values(): IterableIterator<V> {
    return this.innerMap.values();
  }

  public isEmpty(): boolean {
    return this.size() <= 0;
  }
}