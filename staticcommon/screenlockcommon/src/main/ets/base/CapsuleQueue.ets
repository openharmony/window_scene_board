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

export class CapsuleQueue<T> {
  private items: T[] = [];

  enqueue(item: T): void {
    this.items.push(item);
  }

  dequeue(): T | undefined {
    return this.items.shift();
  }

  getFirst(): T | undefined {
    if (this.items.length > 0) {
      return this.items[0];
    }
    return undefined;
  }

  remove(item: T): void {
    // 查找元素在队列中的索引
    const index = this.items.findIndex(el => el === item);
    if (index !== -1) {
      // 删除指定索引的元素
      this.items.splice(index, 1);
    }
  }

  hasItem(item: T): boolean {
    return this.items.findIndex(el => el === item) !== -1;
  }

  clear(): void {
    this.items.length = 0;
  }

  length(): number {
    return this.items.length;
  }
}