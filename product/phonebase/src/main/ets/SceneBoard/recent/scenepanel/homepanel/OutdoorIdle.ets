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

import { FSMState, FSMTransition, FSMEvent } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { OutdoorIdleCallback } from './HomeCallbacks';
import { GestureHelper, gestureHelperInstance } from '../common/GestureHelper';
import { GestureCallbackBase } from '../common/GestureCallback';

export class OutdoorIdle extends FSMState {
  public callback: OutdoorIdleCallback | null = null;
  private panelManager: SCBScenePanelManager;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_OUTDOOR_IDLE);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = callback as OutdoorIdleCallback;
  }

  public init(): void {
    if (!this.panelManager) {
      return;
    }
    this.initGestureEndEventTransitions();
  }

  private initGestureEndEventTransitions(): void {
    this.toSelfIdleUpdate();
    this.toSelfIdleDefault();
  }

  private toSelfIdleUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterHomeIdle(gestureEvent.offsetX, gestureEvent.offsetY);
      return false;
    });
    let transition = FSMTransition.builder(event, this, (...args: GestureEvent[]) => {
      let event = args[0];
      // direction judge
      if (!GestureHelper.isNearlyUpForward(event)) {
        return false;
      }
      // distance and speed
      if (gestureHelperInstance.speedScalar > 0.1) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private toSelfIdleDefault(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END)
    let transition = FSMTransition.builder(event, this, () => {
      return false;
    });
    this.addTransition(transition);
  }

  public onEnter(from: FSMState, event: FSMEvent, ...args: GestureEvent[]): boolean {
    super.onEnter(from, event);
    let gestureEvent = args[0];
    this.callback?.onEnter?.(gestureEvent.offsetX, gestureEvent.offsetY);
    return true;
  }

  public onLeave(from: FSMState, event: FSMEvent, ...args: GestureEvent[]): boolean {
    super.onLeave(from, event);
    let gestureEvent = args[0];
    this.callback?.onLeave?.(gestureEvent.offsetX, gestureEvent.offsetY);
    return true;
  }
}