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

class GlobalStorage {
  private objectStorage: Map<string, Object> = new Map();
  private stringStorage: Map<string, string> = new Map();
  private booleanStorage: Map<string, boolean> = new Map();
  private numberStorage: Map<string, number> = new Map();

  public getGlobalObjectByKey(keyString : string): Object {
    return this.objectStorage[keyString];
  }

  public setGlobalObjectByKey(keyString : string, valueObject: Object): void {
    this.objectStorage[keyString] = valueObject;
  }

  public removeGlobalObjectByKey(keyString : string): void {
    this.objectStorage[keyString] = undefined;
  }

  public getStringByKey(keyString : string): string {
    return this.stringStorage[keyString];
  }

  public setStringByKey(keyString : string, value: string): void {
    this.stringStorage[keyString] = value;
  }

  public setBooleanByKey(keyString : string, value: boolean): void {
    this.booleanStorage[keyString] = value;
  }

  public getBooleanByKey(keyString : string): boolean {
    return this.booleanStorage[keyString];
  }

  public getNumberByKey(keyString : string): number {
    return this.numberStorage[keyString];
  }

  public setNumberByKey(keyString : string, value: number): void {
    this.numberStorage[keyString] = value;
  }

  public increaseNumberByKey(keyString : string, value = 1): void {
    this.numberStorage[keyString] += value;
  }
}

let globalStorage = new GlobalStorage();
export {globalStorage}