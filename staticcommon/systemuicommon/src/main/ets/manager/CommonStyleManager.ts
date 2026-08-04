/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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
const TAG = 'Common-StyleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class CommonStyleManager {
  mAbilityPageName = '';

  setAbilityPageName(name: string): void {
    log.showInfo(TAG, `setAbilityPageName, name: ${name}`);
    this.mAbilityPageName = name;
  }

  getStyle<T>(key: string, defaultStyle: { new(): T }): T {
    let newKey = this.mAbilityPageName + '-' + key;
    if (!AppStorage.Has(newKey)) {
      AppStorage.setOrCreate(newKey, new defaultStyle());
      log.showInfo(TAG, `Create storageKey of ${newKey}`);
    }
    return AppStorage.get(newKey) as T;
  }
}

let commonStyleManager = new CommonStyleManager();

export default commonStyleManager;