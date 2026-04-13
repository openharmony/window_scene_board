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

import { FSMEvent, FSMState, FSMTransition } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';

export class SplitIdle extends FSMState {
  private panelManager: SCBScenePanelManager;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_SPLIT_IDLE);
    this.panelManager = manager;
  }

  public init(): void {
    if (!this.panelManager) {
      return;
    }
    this.initGestureUpdateEventTransitions();
    this.initGestureEndEventTransitions();
  }

  private initGestureUpdateEventTransitions(): void {
    // split状态的gesture update事件什么都不做
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
    let transition = FSMTransition.builder(event, this, () => {
      return false;
    });
    this.addTransition(transition);
  }

  private initGestureEndEventTransitions(): void {
    // split状态的gesture end事件什么都不做
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END);
    let transition = FSMTransition.builder(event, this, () => {
      return false;
    });
    this.addTransition(transition);
  }

  onEnter(from: FSMState, fsmEvent: FSMEvent, event: GestureEvent): boolean {
    super.onEnter(from, fsmEvent);
    return true;
  }

  onLeave(to: FSMState, event: FSMEvent): boolean {
    super.onLeave(to, event);
    return true;
  }
}