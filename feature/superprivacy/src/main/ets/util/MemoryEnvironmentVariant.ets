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
import { SingletonHelper, LogDomain, Logger } from '@ohos/basicutils';
import { HashMap } from '@kit.ArkTS';

const TAG = 'MemoryEnvironmentVariant';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export class MemoryEnvironmentVariant {
  private cacheMap: HashMap<string, string> = new HashMap();

  constructor() {
  }

  getValue(name: string, defValue?: string): string {
    let value = this.cacheMap.get(name);
    if (!value) {
      return defValue || '';
    }
    return value;
  }


  setValue(name: string, value: string, context?: Context): void {
    this.cacheMap.set(name, value);
  }
}

let sMemoryEnvironmentVariant = SingletonHelper.getInstance(MemoryEnvironmentVariant, TAG);

export default sMemoryEnvironmentVariant as MemoryEnvironmentVariant;