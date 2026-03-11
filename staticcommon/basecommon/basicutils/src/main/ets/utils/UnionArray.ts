/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
type AnyType = boolean | number | string | object;

export class UnionArray<T> {
  private _agent: Array<Array<T>> = [];

  public union(arr: T[]): boolean {
    if (this._agent.includes(arr)) {
      return false;
    }
    this._agent.push(arr);
    return true;
  }

  public unUnion(arr: T[]): boolean {
    let index = this._agent.indexOf(arr);
    if (index !== -1) {
      this._agent.splice(index, 1);
      return true;
    }
    return false;
  }

  /**
   * get the length of the union array. This is a number one higher than the highest index in the union array.
   */
  public get length(): number {
    let totalLength: number = 0;
    this._agent.forEach((item) => {
      totalLength += item.length;
    });
    return totalLength;
  }

  public get(index: number): T | undefined {
    if (index < 0) {
      return undefined;
    }
    for (let i = 0; i < this._agent.length; i++) {
      if (index >= this._agent[i].length) {
        index -= this._agent[i].length;
        continue;
      }
      return this._agent[i][index];
    }
    return undefined;
  }

  private getLastBaseIndex(): number {
    let baseIndex: number = 0;
    for (let i = 0; i < this._agent.length - 1; i++) {
      baseIndex += this._agent[i].length;
    }
    return baseIndex;
  }

  /**
   * Returns the value of the first element in the union array where predicate is true, and undefined
   * otherwise.
   * @param predicate find calls predicate once for each element of the array, in ascending
   * order, until it finds one where predicate returns true. If such an element is found, find
   * immediately returns that element value. Otherwise, find returns undefined.
   * @param thisArg If provided, it will be used as the this value for each invocation of
   * predicate. If it is not provided, undefined is used instead.
   */
  public find(predicate: (value: T, index: number, obj: T[]) => boolean, thisArg?: AnyType): T | undefined {
    for (let i = 0; i < this._agent.length; i++) {
      let item = this._agent[i].find(predicate, thisArg);
      if (item !== undefined) {
        return item;
      }
    }
    return undefined;
  }

  private findIndexInner(predicate: (value: T, index: number, obj: T[]) => boolean, thisArg?: AnyType): number[] {
    let baseIndex: number = 0;
    for (let i = 0; i < this._agent.length; i++) {
      if (i > 0) {
        baseIndex += this._agent[i - 1].length;
      }
      let ownerIndex = this._agent[i].findIndex(predicate, thisArg);
      if (ownerIndex !== -1) {
        return [baseIndex, ownerIndex];
      }
    }
    return [0, -1];
  }

  /**
   * Returns the index of the first element in the union array where predicate is true, and -1
   * otherwise.
   * @param predicate find calls predicate once for each element of the array, in ascending
   * order, until it finds one where predicate returns true. If such an element is found,
   * findIndex immediately returns that element index. Otherwise, findIndex returns -1.
   * @param thisArg If provided, it will be used as the this value for each invocation of
   * predicate. If it is not provided, undefined is used instead.
   */
  public findIndex(predicate: (value: T, index: number, obj: T[]) => boolean, thisArg?: AnyType): number {
    let ret: number[] = this.findIndexInner(predicate, thisArg);
    const baseIndex = ret[0];
    const ownerIndex = ret[1];
    return baseIndex + ownerIndex;
  }

  /**
   * Returns the index of the first element in the array where predicate is true, and -1
   * otherwise.
   * @param predicate find calls predicate once for each element of the array, in ascending
   * order, until it finds one where predicate returns true. If such an element is found,
   * findIndex immediately returns that element index. Otherwise, findIndex returns -1.
   * @param thisArg If provided, it will be used as the this value for each invocation of
   * predicate. If it is not provided, undefined is used instead.
   */
  public findIndexInOwner(predicate: (value: T, index: number, obj: T[]) => boolean, thisArg?: AnyType): number {
    let ret: number[] = this.findIndexInner(predicate, thisArg);
    const ownerIndex = ret[1];
    return ownerIndex;
  }

  /**
   * Returns the index of the first occurrence of a value in the union array, or -1 if it is not present.
   * @param searchElement The value to locate in the array.
   * @param fromIndex The array index at which to begin the search. If fromIndex is omitted, the search starts at index 0.
   */
  public indexOf(searchElement: T, fromIndex?: number): number {
    let baseIndex: number = 0;
    for (let i = 0; i < this._agent.length; i++) {
      if (i > 0) {
        baseIndex += this._agent[i - 1].length;
      }
      let newFromIndex: number = 0;
      if (fromIndex !== undefined) {
        newFromIndex = fromIndex - baseIndex;
        newFromIndex = Math.max(0, newFromIndex);
      }
      let ownerIndex = this._agent[i].indexOf(searchElement, newFromIndex);
      if (ownerIndex !== -1) {
        return baseIndex + ownerIndex;
      }
    }
    return -1;
  }

  /**
   * Returns the index of the first occurrence of a value in the array of the searchElement belongs to, or -1 if it is not present.
   * @param searchElement The value to locate in the array.
   * @param fromIndex The array index at which to begin the search. If fromIndex is omitted, the search starts at index 0.
   */
  public indexOfOwner(searchElement: T, fromIndex?: number): number {
    for (let i = 0; i < this._agent.length; i++) {
      let newFromIndex: number = 0;
      if (fromIndex !== undefined) {
        newFromIndex = fromIndex;
      }
      let ownerIndex = this._agent[i].indexOf(searchElement, newFromIndex);
      if (ownerIndex !== -1) {
        return ownerIndex;
      }
    }
    return -1;
  }

  /**
   * Returns the index of the last occurrence of a specified value in a union array, or -1 if it is not present.
   * @param searchElement The value to locate in the array.
   * @param fromIndex The array index at which to begin searching backward. If fromIndex is omitted, the search starts at the last index in the array.
   */
  public lastIndexOf(searchElement: T, fromIndex?: number): number {
    let baseIndex: number = this.getLastBaseIndex();
    let ownerIndex: number = -1;
    for (let i = this._agent.length - 1; i >= 0; i--) {
      let newFromIndex: number = Math.max(0, this._agent[i].length - 1);
      if (fromIndex !== undefined) {
        newFromIndex = fromIndex - baseIndex;
      }
      if (newFromIndex >= 0) {
        newFromIndex = Math.min(this._agent[i].length - 1, newFromIndex);
        ownerIndex = this._agent[i].lastIndexOf(searchElement, newFromIndex);
      }
      if (ownerIndex !== -1) {
        return baseIndex + ownerIndex;
      }
      if (i > 0) {
        baseIndex -= this._agent[i - 1].length;
      }
    }
    return -1;
  }

  /**
   * Returns the index of the last occurrence of a specified value in the array  , or -1 if it is not present.
   * @param searchElement The value to locate in the array.
   * @param fromIndex The array index at which to begin searching backward. If fromIndex is omitted, the search starts at the last index in the array.
   */
  public lastIndexOfOwner(searchElement: T, fromIndex?: number): number {
    for (let i = this._agent.length - 1; i >= 0; i--) {
      let newFromIndex: number = Math.max(0, this._agent[i].length - 1);
      if (fromIndex !== undefined) {
        newFromIndex = Math.min(newFromIndex, fromIndex);
      }
      let ownerIndex = this._agent[i].lastIndexOf(searchElement, newFromIndex);
      if (ownerIndex !== -1) {
        return ownerIndex;
      }
    }
    return -1;
  }

  /**
   * Performs the specified action for each element in a union array.
   * @param callback  A function that accepts up to three arguments. forEach calls the callback function one time for each element in the array.
   * @param thisArg  An object to which the this keyword can refer in the callback function. If thisArg is omitted, undefined is used as the this value.
   */
  public forEach(callback: (value: T, index: number, obj: T[]) => void, thisArg?: AnyType): void {
    this._agent.forEach((item) => {
      item.forEach(callback, thisArg);
    });
  }

  /**
   * Removes elements from a union array and, if necessary, inserts new elements in their place, returning the deleted elements.
   * @param start The zero-based location in the array from which to start removing elements.
   * @param deleteCount The number of elements to remove, default 1.
   * @returns An array containing the elements that were deleted.
   */
  public splice(start: number, deleteCount: number = 1): T[] {
    let baseIndex: number = this.getLastBaseIndex();
    for (let i = this._agent.length - 1; i >= 0; i--) {
      if (start >= baseIndex) {
        return this._agent[i].splice(start - baseIndex, deleteCount);
      }
      if (i > 0) {
        baseIndex -= this._agent[i - 1].length;
      }
    }
    return [];
  }

  /**
   * Removes elements from a union array, returning true if success.
   * @param element: the element for remove.
   * @returns true if the element that were deleted successfully.
   */
  public remove(element: T): boolean {
    for (let i = 0; i < this._agent.length; i++) {
      let index = this._agent[i].indexOf(element);
      if (index !== -1) {
        this._agent[i].splice(index, 1);
        return true;
      }
    }
    return false;
  }

  /**
   * Removes all elements from a union array, returning true if success.
   * @param element: the element for remove.
   * @returns true if the element that were deleted successfully.
   */
  public removeAll(element: T): boolean {
    for (let i = 0; i < this._agent.length; i++) {
      let index = this._agent[i].indexOf(element);
      while (index !== -1) {
        this._agent[i].splice(index, 1);
        index = this._agent[i].indexOf(element);
      }
    }
    return true;
  }

  /**
   * Returns the elements of the union array that meet the condition specified in a callback function.
   * @param predicate A function that accepts up to three arguments. The filter method calls the predicate function one time for each element in the array.
   * @param thisArg An object to which the this keyword can refer in the predicate function. If thisArg is omitted, undefined is used as the this value.
   */
  public filter(predicate: (value: T, index: number, obj: T[]) => boolean, thisArg?: AnyType): T[] {
    let ret: T[] = [];
    this._agent.forEach((item) => {
      item.filter(predicate, thisArg)?.forEach((filterItem) => {
        ret.push(filterItem);
      });
    });
    return ret;
  }
}