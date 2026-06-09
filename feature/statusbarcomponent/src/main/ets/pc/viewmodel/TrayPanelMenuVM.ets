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
import { HashSet } from '@kit.ArkTS'
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'TrayPanelMenuVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

class TrayPanelMenuVM {
  public static instance?: TrayPanelMenuVM = undefined;

  public static getInstance(): TrayPanelMenuVM {
    TrayPanelMenuVM.instance = TrayPanelMenuVM.instance ?? new TrayPanelMenuVM();
    return TrayPanelMenuVM.instance;
  }

  private _isNeedCloseTrayPanel: boolean = true;
  private menuOpenStatus: HashSet<string> = new HashSet();

  updateSlotOfOpenMenu(isSelfMenuOpen: boolean, slot: string) {
    if (isSelfMenuOpen) {
      this.menuOpenStatus.clear();
      this.menuOpenStatus.add(slot);
    } else {
      this.menuOpenStatus.remove(slot);
    }
    log.showInfo(`slot:${slot}, isSelfMenuOpen:${isSelfMenuOpen}, this.menuOpenStatus isEmpty:${this.menuOpenStatus.isEmpty()}`);
  }

  setNeedCloseTrayPanelThisTime(isNeed: boolean) {
    log.showInfo('setNeedCloseTrayPanelThisTime: ' + isNeed);
    this._isNeedCloseTrayPanel = isNeed;
  }

  isNeedCloseTrayPanel(): boolean {
    log.showInfo('isNeedCloseTrayPanel: ' + this._isNeedCloseTrayPanel + ',set is empty :' + this.menuOpenStatus.isEmpty());
    let result = this._isNeedCloseTrayPanel && this.menuOpenStatus.isEmpty();
    this._isNeedCloseTrayPanel = true;
    return result;
  }

  isHaveMenuOpen(): boolean {
    return !this.menuOpenStatus.isEmpty();
  }
}

export const trayPanelMenuVM: TrayPanelMenuVM = TrayPanelMenuVM.getInstance();