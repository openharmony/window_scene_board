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

import { SingletonHelper } from '@ohos/basicutils';
import { PluginSlot } from '@ohos/frameworkwrapper';

const TAG = 'PluginSortManager';

class PluginSortManager {
  private dynamicSortPlugins: string[] = [];

  constructor() {
    this.dynamicSortPlugins.push(...PluginSlot.STATUS_BAR_PC_CAPSULE_DEFAULT_ORDER);
  }

  /**
   * get sorted plugin array
   *
   * @returns Array<string>: sorted plugins
   */
  getDynamicSortPlugins(): Array<string> {
    return new Array<string>(...this.dynamicSortPlugins);
  }

  /**
   * delete plugin in sorted plugin array by slot
   *
   * @param slot plugin slot
   */
  deleteDynamicSortPlugin(slot: string): void {
    const index:number = this.dynamicSortPlugins.indexOf(slot);
    if (index >= 0) {
      this.dynamicSortPlugins.splice(index, 1);
    }
  }

  /**
   * put plugin in the last of the sorted plugin array
   *
   * @param slot
   */
  pushDynamicSortPlugin(slot: string): void {
    this.deleteDynamicSortPlugin(slot);
    this.dynamicSortPlugins.push(slot);
  }
}

let pluginSortManager = SingletonHelper.getInstance(PluginSortManager, TAG);
export default pluginSortManager as PluginSortManager;