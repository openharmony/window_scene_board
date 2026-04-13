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

const TAG: string = 'TsLruCache';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * LRU data structure to manage animation finish callback tasks to ensure execution timing
 *
 * @since 2024-09-24
 */
export class TsLruCache {
  private values: Map<number, (() => void) | undefined> = new Map<number, (() => void) | undefined>();

  private maxEntries: number = 0;

  public constructor(maxEntries: number) {
    this.maxEntries = maxEntries;
  }

  /**
   * Get the task by the task id
   *
   * @param key Task id that assigned to each callback task
   * @returns Corresponding callback task, will return undefined if no tasks were found
   */
  public get(key: number): (() => void) | undefined {
    const hasKey: boolean = this.values.has(key);
    if (!hasKey) {
      LOG.warn(TAG, `Task ${key} doesn't exist in current taskpool.`);
      return undefined;
    }

    // Put the key to the end of the map
    // Basically mark it as 'recent used'
    let entry: (() => void) | undefined = this.values.get(key);
    this.values.delete(key);
    this.values.set(key, entry);

    return entry;
  }

  /**
   * Put the task into the cache. If the size is about to exceed the limit, the least used one will be removed
   *
   * @param key Task id of the callback task
   * @param value Callback definition
   */
  public put(key: number, value: (() => void) | undefined): void {
    if (!value) {
      LOG.warn(TAG, `Refuse to put empty value, id ${key}`);
      return;
    }
    if (this.values.size >= this.maxEntries) {
      // Least used key would be in the start of the maps key list
      const leastUsedKey: number = this.values.keys().next().value;
      this.values.delete(leastUsedKey);
      LOG.warn(TAG, `Least used key ${leastUsedKey} get purged.`);
    }

    this.values.set(key, value);
  }

  /**
   * Delete the task from the cache
   *
   * @param key Task id that to be deleted
   */
  public delete(key: number): void {
    if (!this.values.has(key)) {
      LOG.warn(TAG, `${key} cannot be deleted as it doesn't exist anyway.`);
      return;
    }

    LOG.info(TAG, `Delete ${key} from current LRU taskpool.`);
    this.values.delete(key);
  }
}