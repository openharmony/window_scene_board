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
import { CustomPromise } from '@ohos/frameworkwrapper';
import { ILiveMetaBallVisibleVm } from '../interface/ILiveMetaBallVisibleVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveBaseVm } from './LiveBaseVm';

const TAG = 'LiveMetaBallVisibleVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveMetaBallVisibleVm extends LiveBaseVm implements ILiveMetaBallVisibleVm {
  public appearPromise?: CustomPromise<void>;

  /**
   * 融球显示状态，true：显示  false：不显示
   */
  private metaBallShowState: boolean = false;

  constructor(vmInjector: LiveVmInjector) {
    super(vmInjector);
  }

  public isMetaBallShow(): boolean {
    log.showInfo(`ismetaBallShowState: ${this.metaBallShowState}`);
    return this.metaBallShowState;
  }

  setMetaBallShowState(state: boolean[]): void {
    this.metaBallShowState = state.length > 0;
    log.showInfo(`metaBallShowState change to: ${this.metaBallShowState}`);
  }
}