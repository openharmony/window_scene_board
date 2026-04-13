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

export class LazyDataSource<T> implements IDataSource {
  private elements: T[]
  private listeners: Set<DataChangeListener>

  constructor(elements: T[] = []) {
    this.elements = elements;
    this.listeners = new Set();
  }

  public totalCount(): number {
    return this.elements.length;
  }

  public getData(index: number): T {
    return this.elements[index];
  }

  public indexOf(item: T): number {
    return this.elements.indexOf(item);
  }

  public insertItem(item: T, index: number) {
    this.elements.splice(index, 0, item);
    this.listeners.forEach(listener => listener.onDataAdd(index));
  }

  public pushItem(item: T) {
    const index = this.elements.length;
    this.elements.push(item);
    this.listeners.forEach(listener => listener.onDataAdd(index - 1));
  }

  public concatItem(item: T) {
    const index = this.elements.length;
    this.elements.concat(item);
    this.listeners.forEach(listener => listener.onDataAdd(index - 1));
  }

  public deleteItemByIndex(index: number): void {
    this.elements.splice(index, 1);
    this.listeners.forEach(listener => listener.onDataDelete(index));
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    this.listeners.add(listener);
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listeners.delete(listener);
  }

  public clear(): void {
    while (this.elements.length > 0) {
      const lastIndex: number = this.elements.length - 1;
      this.deleteItemByIndex(lastIndex);
    }
  }

  public notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  public getAllData(): T[] {
    return this.elements;
  }
}