/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { FSMCallbackArgsType, FSMEvent, FSMState, FSMTransition } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { RecentDeleteFollowingCallback } from './RecentCallbacks';
import { GestureCallbackBase } from '../common/GestureCallback';
import { GestureHelper } from '../common/GestureHelper';
import { RecentLayoutManager } from '../../common/RecentLayoutManager';
import { RecentDelete } from './RecentDelete';

export class RecentDeleteFollowing extends FSMState {
  private panelManager: SCBScenePanelManager;
  public gestureHelperInstance: GestureHelper = new GestureHelper();
  private recentDelete: RecentDelete | null = null;
  public callback: RecentDeleteFollowingCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_RECENT_DELETE_FOLLOWING);
    this.panelManager = manager;
    this.recentDelete = new RecentDelete(manager);
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = callback as RecentDeleteFollowingCallback;
  }

  public init(): void {
    if (!this.panelManager) {
      return;
    }
    this.initRecentGestureUpdateEventTransitions();
    this.initRecentGestureEndEventTransitions();
    this.initRecentGestureCancelEventTransitions();
  }

  private initRecentGestureUpdateEventTransitions(): void {
    this.toSelfUpdate();
    this.toSelfDefault();
  }

  private toSelfUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_RECENT_GESTURE_UPDATE, (...args: FSMCallbackArgsType[]) => {
      let containerId = args[0] as number;
      let gestureEvent = args[1] as GestureEvent;
      this.callback?.update(containerId, gestureEvent);
      return false;
    });
    let transition = FSMTransition.builder(event, this, (...args: FSMCallbackArgsType[]) => {
      let gestureEvent = args[1] as GestureEvent;
      this.gestureHelperInstance.invoke(gestureEvent);
      let screenProperty = this.panelManager.getScreenProperty();
      let offsetWidth = RecentLayoutManager.getCardWidth(screenProperty) / 2;
      if (Math.abs(gestureEvent.offsetX) <= offsetWidth) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private toSelfDefault(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_RECENT_GESTURE_UPDATE, () => {
      return false;
    });
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initRecentGestureEndEventTransitions(): void {
    this.toRecentIdle();
    this.restoreToRecentIdle();
  }

  private toRecentIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_RECENT_GESTURE_END, (...args: FSMCallbackArgsType[]) => {
      let containerId = args[0] as number;
      let gestureEvent = args[1] as GestureEvent;
      this.callback?.delete(containerId, gestureEvent);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_IDLE),
      (...args: FSMCallbackArgsType[]) => {
        let containerId = args[0] as number;
        let gestureEvent = args[1] as GestureEvent;
        let screenProperty = this.panelManager.getScreenProperty();
        let offsetWidth = RecentLayoutManager.getCardWidth(screenProperty) / 2;
        if (!GestureHelper.isUpForward(gestureEvent) || (Math.abs(gestureEvent.offsetX) >= offsetWidth)) {
          return false;
        }
        if (this.isUnclearable(containerId)) {
          return false;
        }
        if (this.gestureHelperInstance.isSpeedUpForward() &&
          (Math.abs(this.gestureHelperInstance.speedYVector) > 0.7) ||
          (Math.abs(gestureEvent.offsetY) > px2vp(screenProperty.height) / 4)) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private isUnclearable(containerId: number): boolean {
    let sceneContainerSession = this.panelManager.getSceneContainerSessionListForView().find((item) => {
      return (item.containerId === containerId && !item.pendingRemove);
    });
    if (!sceneContainerSession) {
      sceneContainerSession = this.panelManager.getFloatingSessionListForView().find((item) => {
        return (item.containerId === containerId && !item.pendingRemove);
      });
    }
    if (!sceneContainerSession) {
      return false;
    }
    if (this.recentDelete?.isUnclearAbleWhenMoveClear(sceneContainerSession)) {
      return true;
    }
    return false;
  }

  private restoreToRecentIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_RECENT_GESTURE_END, (...args: FSMCallbackArgsType[]) => {
      let containerId = args[0] as number;
      let gestureEvent = args[1] as GestureEvent;
      this.callback?.restore(containerId, gestureEvent);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_IDLE));
    this.addTransition(transition);
  }

  private initRecentGestureCancelEventTransitions(): void {
    this.cancelToRecentIdle();
  }

  private cancelToRecentIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_RECENT_GESTURE_CANCEL, (...args: FSMCallbackArgsType[]) => {
      let containerId = args[0] as number;
      let gestureEvent = args[1] as GestureEvent;
      this.callback?.cancel(containerId, gestureEvent);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_IDLE));
    this.addTransition(transition);
  }

  onEnter(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    let gestureEvent = args[1] as GestureEvent;
    this.gestureHelperInstance.invoke(gestureEvent);
    super.onEnter(from, event);
    this.callback?.onEnter?.(...args);
    return true;
  }

  onLeave(to: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onLeave(to, event);
    this.callback?.onLeave?.(...args);
    this.gestureHelperInstance.reset();
    return true;
  }
}