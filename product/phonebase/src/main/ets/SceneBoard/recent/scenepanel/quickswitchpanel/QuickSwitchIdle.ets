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
import { FSMState, FSMTransition, FSMEvent, FSMCallbackArgsType } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { QuickSwitchIdleCallback } from './QuickSwitchCallbacks';
import { GestureCallbackBase } from '../common/GestureCallback';

export class QuickSwitchIdle extends FSMState {
  private panelManager: SCBScenePanelManager;
  private callback: QuickSwitchIdleCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_QUICK_SWITCH_IDLE);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = (callback as QuickSwitchIdleCallback)
  }

  public init(): void {
    if (!this.panelManager) {
      return;
    }

    // 无条件转移到APP_IDLE状态
    let transition = FSMTransition.builder(FSMEvent.builder(FSMEvent.NULL),
      this.myFsm.getState(ScenePanelStates.STATE_APP_IDLE));
    this.addTransition(transition);
  }

  public onEnter(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onEnter(from, event);
    this.callback?.onEnter?.(...args);
    return true;
  }

  public onLeave(from: FSMState, event: FSMEvent, ...args: GestureEvent[]): boolean {
    super.onLeave(from, event);
    this.callback?.onLeave?.(...args);
    return true;
  }
}