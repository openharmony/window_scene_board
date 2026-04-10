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

import { LogDomain, Logger } from '@ohos/basicutils';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { EditModeBarIface, EditModeVisitor } from '../interfaces/EditModeIface';
import { EditModeBarViewData } from '../viewData/EditModeBarViewData';

const TAG = 'EditModeBarVm';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);
const CONTROL_PANEL = PluginSlot.SLOT_STATUS_CONTROL_CENTER;


export class EditModeBarVm implements EditModeBarIface {
  private viewData: EditModeBarViewData = new EditModeBarViewData();
  private visitor?: EditModeVisitor;

  constructor(viewData: EditModeBarViewData) {
    this.viewData = viewData;
  }

  public acceptModeVisitor(visitor: EditModeVisitor): void {
    this.visitor = visitor;
  }

  public jumpBack(): void {
    log.showInfo(TAG, 'jumpBack');
    this.visitor?.onTryRollback();
    windowMgr.showWindowWithAnim(CONTROL_PANEL, true);
  }

  public confirm(): void {
    log.showInfo(TAG, 'confirm');
    this.visitor?.onConfirmCb();
    windowMgr.showWindowWithAnim(CONTROL_PANEL, true);
  }

  public onGetViewData(): EditModeBarViewData {
    return this.viewData;
  }
}


