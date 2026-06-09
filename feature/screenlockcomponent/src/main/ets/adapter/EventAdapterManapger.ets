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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AbstractInitialAble } from '@ohos/screenlockcommon';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { AbstractEventAdapter } from './AbstractEventAdapter';
import { PowerEventAdapter } from './PowerEventAdapter';
import { SlServiceEventAdapter } from './SlServiceEventAdapter';
import { UserSwitchEventAdapter } from './UserSwitchEventAdapter';

const TAG = 'EventAdapterManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏事件适配器管理
 */
export class EventAdapterManager extends AbstractInitialAble {
  private readonly _adapters: AbstractEventAdapter[] = [];

  constructor(fsmProxy: ScreenLockFsmProxy) {
    super();
    this.initAdapters(fsmProxy);
  }

  protected doInit(): void {
    log.showInfo('doInit');
    this._adapters.forEach(adapter => adapter.init());
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    this._adapters.forEach(adapter => adapter.release());
  }

  private initAdapters(fsmProxy: ScreenLockFsmProxy): void {
    this._adapters.push(new PowerEventAdapter(fsmProxy));
    this._adapters.push(new SlServiceEventAdapter(fsmProxy));
    this._adapters.push(new UserSwitchEventAdapter(fsmProxy));
  }
}