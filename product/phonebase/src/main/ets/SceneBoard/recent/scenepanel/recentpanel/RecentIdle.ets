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

import { FSMCallbackArgsType, FSMEvent, FSMState, FSMTransition, SCBSceneContainerSession } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { RecentClickReason, ScenePanelStates } from '../ScenePanelStates';
import { RecentPanelSession } from './RecentPanelSession';
import { RecentPanelController } from './RecentPanelController';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { gestureHelperInstance } from '../common/GestureHelper';
import { RecentIdleCallback } from './RecentCallbacks';
import { GestureCallbackBase } from '../common/GestureCallback';

export class RecentIdle extends FSMState {
  private readonly SHOW_HOME_VIEW_LIMIT: number = 0.1;
  private screenHeight: number = 0;
  private panelManager: SCBScenePanelManager;
  public callback: RecentIdleCallback | null = null;
  public controller: RecentPanelController | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_RECENT_IDLE);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = callback as RecentIdleCallback;
  }

  public init(): void {
    if (!this.panelManager) {
      return;
    }
    this.initController();
    this.initGestureStartEventTransitions();
    this.initGestureEndEventTransitions();
    this.initRecentGestureStartEventTransitions();
    this.initOnScrollEventTransitions();
    this.initTouchDownEventTransitions();
    this.initTouchUpEventTransitions();
    this.initOnClickEventTransitions();
  }

  private initGestureStartEventTransitions(): void {
    // gesture start事件只做screen size更新
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_START, () => {
      this.initScreenHeight();
      return false;
    })
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initScreenHeight(): void {
    this.screenHeight = px2vp(this.panelManager.getScreenProperty().height);
  }

  private initGestureEndEventTransitions(): void {
    // 手势向上松手时，回到Home状态
    this.toHomeIdle();
    // 其他手势松手时，停留在当前状态，什么都不做
    this.toSelfIdleDefault();
  }

  private initController(): void {
    let scenePanelSession = this.panelManager.getSceneContainerSessionList();
    if (!scenePanelSession) {
      return;
    }
    let recentPanelSession = new RecentPanelSession(scenePanelSession);
    this.controller = new RecentPanelController(recentPanelSession);
  }

  private toHomeIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, () => {
      this.callback?.toHomeIdle();
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), (...args: GestureEvent[]) => {
        if (this.isHomeViewShowOfSpeedLimit() || this.isHomeViewShowOfDistanceLimit(args[0].offsetY)) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toSelfIdleDefault(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END);
    let transition = FSMTransition.builder(event, this, () => {
      return false;
    });
    this.addTransition(transition);
  }

  private isHomeViewShowOfDistanceLimit(offsetY: number): boolean {
    return ((Math.abs(offsetY)) / this.screenHeight) >= this.SHOW_HOME_VIEW_LIMIT;
  }

  // unit is vp/ms
  private isHomeViewShowOfSpeedLimit(): boolean {
    return gestureHelperInstance.curSpeed < -0.5;
  }

  private initRecentGestureStartEventTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_RECENT_GESTURE_START);
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_DELETE_FOLLOWING),
      () => {
        return true;
      });
    this.addTransition(transition);
  }

  private initOnScrollEventTransitions(): void {
    this.toScrollFollowing();
    this.toScrollFling();
  }

  private toScrollFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_ON_SCROLL, (...args: FSMCallbackArgsType[]) => {
      let xOffset = args[1] as number;
      let yOffset = args[2] as number;
      this.callback?.toScrollFollowing?.(xOffset, yOffset);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_SCROLL_FOLLOWING), (...args: FSMCallbackArgsType[]) => {
        let scrollState = args[0] as ScrollState;
        if (scrollState === ScrollState.Scroll) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toScrollFling(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_ON_SCROLL, (...args: FSMCallbackArgsType[]) => {
      let xOffset = args[1] as number;
      let yOffset = args[2] as number;
      this.callback?.toScrollFling?.(xOffset, yOffset);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_SCROLL_FLING), (...args: FSMCallbackArgsType[]) => {
        let scrollState = args[0] as ScrollState;
        if (scrollState === ScrollState.Fling) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private initTouchDownEventTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_TOUCH_DOWN, (...args: FSMCallbackArgsType[]) => {
      let touchEvent = args[0] as TouchEvent;
      this.callback?.doTouchDown(touchEvent);
      return false;
    });
    let transition = FSMTransition.builder(event, this, (...args: FSMCallbackArgsType[]) => {
      let from = args[1] as string;
      if (from === 'RecentEventViewModel') {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private initTouchUpEventTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_TOUCH_UP, (...args: FSMCallbackArgsType[]) => {
      let touchEvent = args[0] as TouchEvent;
      this.callback?.doTouchUp(touchEvent);
      return false;
    });
    let transition = FSMTransition.builder(event, this, () => {
      return true;
    });
    this.addTransition(transition);
  }

  private initOnClickEventTransitions(): void {
    this.clickToAppIdle();
    this.clickToHomeIdle();
    this.clickToClearAllMission();
  }

  private clickToHomeIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_CLICK, () => {
      this.callback?.toHomeIdle?.();
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), (...args: FSMCallbackArgsType[]) => {
        return args[0] as RecentClickReason === RecentClickReason.EXIT_RECENT;
      });
    this.addTransition(transition);
  }

  private clickToAppIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_CLICK, (...args: FSMCallbackArgsType[]) => {
      this.callback?.toAppIdle?.(args[1] as SCBSceneContainerSession);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_APP_IDLE), (...args: FSMCallbackArgsType[]) => {
        return args[0] as RecentClickReason === RecentClickReason.START_APP;
      });
    this.addTransition(transition);
  }

  private clickToClearAllMission(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_CLICK, () => {
      this.callback?.clearAllMission?.();
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), (...args: FSMCallbackArgsType[]) => {
        return args[0] as RecentClickReason === RecentClickReason.CLEAR_ALL_MISSION;
      });
    this.addTransition(transition);
  }

  onEnter(from: FSMState, event: FSMEvent): boolean {
    super.onEnter(from, event);
    this.initScreenHeight();
    this.callback?.onEnter?.(from.toString());
    return true;
  }

  onLeave(to: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onLeave(to, event);
    this.callback?.onLeave?.(...args);
    return true;
  }
}