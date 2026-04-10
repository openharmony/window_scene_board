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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import Constants, { FoldStateChangeListener } from '../common/Constants'
import { SCBCtrlAltDelLayoutViewData } from './SCBCtrlAltDelLayoutViewData';
const TAG = 'SCBCtrlAltDelLayoutViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class SCBCtrlAltDelLayoutViewModel {
  private layoutViewData: SCBCtrlAltDelLayoutViewData;
  private foldStateListeners = new Set<FoldStateChangeListener>();

  constructor() {
    this.layoutViewData = new SCBCtrlAltDelLayoutViewData();
  }

  public registerFoldStateListener(listener: FoldStateChangeListener): void {
    let res = this.foldStateListeners.add(listener);
    log.showInfo(`register FoldStateChangeListener res: ${res}, size: ${this.foldStateListeners.size}`);
  }

  public unregisterFoldStateListener(listener: FoldStateChangeListener): void {
    let res = this.foldStateListeners.delete(listener);
    log.showInfo(`unregister FoldStateChangeListener res: ${res}, size: ${this.foldStateListeners.size}`);
  }

  public initLayoutData(): SCBCtrlAltDelLayoutViewData {
    return this.layoutViewData;
  }
}