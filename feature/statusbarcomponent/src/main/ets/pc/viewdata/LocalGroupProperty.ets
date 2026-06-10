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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginAccessInfo } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { PluginProperty } from './PluginProperty';

const INVALID_INDEX: number = -1;
const TAG = 'LocalGroupProperty';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Observed
export class LocalGroupProperty extends Array<PluginProperty> {
  constructor() {
    super()
  }

  addPlugin(newProperty: PluginProperty, insertIndex: number = INVALID_INDEX): boolean {
    const index = this.findIndex((property) => {
      return property?.getSlot() === newProperty?.getSlot();
    })
    if (index !== INVALID_INDEX) {
      return false;
    }
    if (insertIndex === INVALID_INDEX) {
      this.push(newProperty);
    } else {
      this.splice(insertIndex, 0, newProperty);
    }
    return true;
  }

  deletePlugin(slot: string): boolean {
    const index = this.findIndex((property) => {
      return property?.getSlot() === slot;
    })
    if (index === INVALID_INDEX) {
      return false;
    }
    this.splice(index, 1);
    return true;
  }

  getPlugin(slot?: string, tokenId?: number): PluginProperty | null {
    const index = this.findIndex((property) => {
      if (slot && property?.getSlot() === slot) {
        return true;
      }
      let info = property?.pluginInfo as PluginAccessInfo;
      if (info && tokenId && info.accessTokenId === tokenId) {
        return true;
      }
      return false;
    });
    if (index === INVALID_INDEX) {
      return null;
    }
    return this[index];
  }

  getPluginIndex(slot?: string, tokenId?: number): number {
    const index = this.findIndex((property) => {
      if (slot && property?.getSlot() === slot) {
        return true;
      }
      let info = property?.pluginInfo as PluginAccessInfo;
      if (info && tokenId && info.accessTokenId === tokenId) {
        return true;
      }
      return false;
    });
    return index;
  }

  swapPluginElements(indexA: number, indexB: number): void {
    const plugB: PluginProperty = this[indexB];
    log.showInfo('swapPluginElements indexA: ' + indexA + ' plugA: ' + this[indexA]?.getSlot() +
      ' indexB: ' + indexB + ' plugB: ' + plugB?.getSlot());
    this.splice(indexB, 1, this[indexA]);
    this.splice(indexA, 1, plugB);
  }
}