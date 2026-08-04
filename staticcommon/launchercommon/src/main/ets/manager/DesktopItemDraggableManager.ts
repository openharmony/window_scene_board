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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { HashSet } from '@kit.ArkTS';
import { GridLayoutItemInfo } from '../TsIndex';
import { LightOutdoorConfig } from '@ohos/frameworkwrapper';

const TAG = 'DesktopItemDraggableManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class DesktopItemDraggableManager {
  //存放禁止拖拽的原因，做条件互斥
  private _disableDragReasonSet: HashSet<string> = new HashSet();
  private enableDrag: boolean = true;

  /**
   * Get enableDrag
   *
   * @return enableDrag
   */
  public getEnableDrag(): boolean {
    return this.enableDrag;
  }
  
  /**
   * Set is enable drag through a voting mechanism
   *
   * @param { Boolean } enableDrag. For the same caller, enableDrag false and true should be used in pairs.
   * @param { string } reasonType. Description of caller.It should be the same whether enableDrag is true or false.
   */
  public setEnableDrag(enableDrag: boolean, reasonType: string): void {
    if (!enableDrag) {
      this._disableDragReasonSet.add(reasonType);
      this.enableDrag = false;
      log.showInfo(`disable drag successful, disable reason:${reasonType}`);
      return;
    }
    // 取消禁用拖拽时，如果有其他禁用条件，需要等所有禁用条件都满足了，才能放开拖拽
    this._disableDragReasonSet.remove(reasonType);
    if (this._disableDragReasonSet.isEmpty()) {
      this.enableDrag = true;
      log.showInfo(`enable drag successful, enable reason:${reasonType}`);
      return;
    }
    let allReason = '';
    this._disableDragReasonSet.forEach((reason) => {
      allReason += reason + ',';
    });
    log.showInfo(`enable drag fail, enable reason:${reasonType}, Drag is disabled by other reason:${allReason}`);
  }

  /**
   * 云端2 元素是否可以拖拽,只有添加元素允许拖拽，长按
   * 只在云端2下使用
   *
   * @param item 当前拖拽item
   * @returns true/false
   */
  public isItemDraggable(item: GridLayoutItemInfo): boolean {
    try {
      let intentStr: string = item?.intent ?? '';
      if (!intentStr || intentStr === '') {
        return false;
      }
      let isAddItem: AddItemIntent = JSON.parse(intentStr);
      if(isAddItem && isAddItem?.comeFrom === 'userAdd') {
        // 云端2下 添加元素允许拖拽，长按
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log.showError(`isItemDraggable error :${e?.message}`);
      return false;
    }
  }
}

class AddItemIntent {
  public comeFrom?: string;
}
// 单例
export let desktopItemDraggableManager: DesktopItemDraggableManager = SingletonHelper.getInstance(DesktopItemDraggableManager, TAG);