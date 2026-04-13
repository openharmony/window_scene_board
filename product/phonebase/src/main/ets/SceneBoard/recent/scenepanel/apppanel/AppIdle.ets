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
import { FSMState, FSMEvent, FSMTransition, FSMCallbackArgsType } from '@ohos/windowscene';
import { desktopUtil } from '@ohos/componenthelper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { EvtBus, RotateChangeEvent } from '@ohos/frameworkwrapper';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { GestureHelper } from '../common/GestureHelper';
import { AppIdleCallback } from './AppCallbacks';
import { GestureCallbackBase } from '../common/GestureCallback';

const TAG = 'AppIdle';

export class AppIdle extends FSMState {
  private panelManager: SCBScenePanelManager;
  private callback: AppIdleCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_APP_IDLE);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = (callback as AppIdleCallback);
  }

  public init(): void {
    this.initGestureStartEventTransitions();
    this.initGestureUpdateEventTransitions();
    this.initGestureEndEventTransitions();
  }

  private initGestureStartEventTransitions(): void {
    this.gestureStartToSelf();
  }

  private gestureStartToSelf(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_START, () => {
      // 当上滑手势时会打断当前旋转过程
      let rotateEvent: RotateChangeEvent = RotateChangeEvent.create(RotateChangeEvent.ROTATE_STATUS_CANCEL);
      EvtBus.post<RotateChangeEvent>(RotateChangeEvent, rotateEvent);
      return false;
    });

    let transition = FSMTransition.builder(event, this, () => {
      return true;
    });
    this.addTransition(transition);
  }

  private initGestureUpdateEventTransitions(): void {
    this.toQuickSwitchFollowing();
    this.toZoomFollowing();
    this.toSelfDefault();
  }

  private toQuickSwitchFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, () => {
      this.callback?.enterQuickSwitchFollowing(-1 /* no need */, -1 /* no need */);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_QUICK_SWITCH_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        if (launcherStatusUtil.getShowOutLauncherStatus()) {
          return false;
        }
        if (GestureHelper.isNearlyXForward(args[0])) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toZoomFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, () => {
      this.callback?.enterZoomFollowing(-1 /* no need */, -1 /* no need */);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_ZOOM_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        if (GestureHelper.isNearlyUpForward(args[0])) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toSelfDefault(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
    let transition = FSMTransition.builder(event, this, () => {
      return false;
    });
    this.addTransition(transition);
  }

  private initGestureEndEventTransitions(): void {
    // 松手时，就停留在当前状态， 什么都不做
    let transition = FSMTransition.builder(FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END), this, () => {
      return false;
    });
    this.addTransition(transition);
  }

  public onEnter(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onEnter(from, event);
    this.callback?.onEnter?.(...args);
    return true;
  }

  public onLeave(to: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onLeave(to, event);
    this.callback?.onLeave?.(...args);
    return true;
  }
}