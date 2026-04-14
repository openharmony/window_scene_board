/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { FSMEvent, FSMState } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ScenePanelStates } from '../ScenePanelStates';
import type { SCBScenePanelManager } from '@ohos/windowscene';

const TAG = 'ScreenLockState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
export class ScreenLockState extends FSMState {
  private panelManager: SCBScenePanelManager;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_SCREEN_LOCK);
    this.panelManager = manager;
  }

  public init(): void {
    if (!this.panelManager) {
      return;
    }
  }

  public onEnter(from: FSMState, event: FSMEvent): boolean {
    super.onEnter(from, event);
    return true;
  }

  public onLeave(to: FSMState, event: FSMEvent): boolean {
    super.onLeave(to, event);
    return true;
  }
}
