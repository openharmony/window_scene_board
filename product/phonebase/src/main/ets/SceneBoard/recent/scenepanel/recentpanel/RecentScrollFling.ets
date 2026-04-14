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
import { FSMCallbackArgsType, FSMState, FSMEvent, FSMTransition,
  SCBSceneContainerSession } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { RecentClickReason, ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { RecentScrollFlingCallback } from './RecentCallbacks';
import { RecentScrollHelper } from './RecentScrollHelper';
import { GestureCallbackBase } from '../common/GestureCallback';

const recentScrollFlingHelper: RecentScrollHelper = new RecentScrollHelper('RecentScrollFling');

export class RecentScrollFling extends FSMState {
  private readonly panelManager: SCBScenePanelManager;
  private callback: RecentScrollFlingCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_RECENT_SCROLL_FLING);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = callback as RecentScrollFlingCallback;
  }

  public init(): void {
    this.initOnScrollEventTransitions();
    this.initScrollStopEventTransitions();
    this.initTouchDownEventTransitions();
    this.initTouchUpEventTransitions();
    this.initOnClickEventTransitions();
    this.initOnGestureEndTransitions();
  }

  private initOnScrollEventTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_ON_SCROLL, (...args: FSMCallbackArgsType) => {
      let deltaOffset: number = args[1] as number;
      let currentOffset: number = args[2] as number;
      this.callback?.doScroll(deltaOffset, currentOffset);
      return false;
    });
    let transition = FSMTransition.builder(event, this, (...args: FSMCallbackArgsType[]) => {
      let scrollState = args[0] as ScrollState;
      if (scrollState === ScrollState.Fling) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private initScrollStopEventTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_SCROLL_STOP, () => {
      this.callback?.scrollStopToRecentIdle?.();
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_IDLE));
    this.addTransition(transition);
  }

  private initTouchDownEventTransitions(): void {
    this.touchDownToScrollFollowing();
    this.touchDownToRecentIdleByScale();
    this.touchDownToRecentIdle();
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

  private touchDownToScrollFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_TOUCH_DOWN, () => {
      this.callback?.touchDownToScrollFollowing?.();
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_SCROLL_FOLLOWING), () => {
        // if speed is fast, transfer to scroll following state, can not do gesture up/down
        if (Math.abs(recentScrollFlingHelper.deltaOffset) >= 1) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private touchDownToRecentIdleByScale(): void {
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

  private touchDownToRecentIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_TOUCH_DOWN, () => {
      this.callback?.touchDownToRecentIdle?.();
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_IDLE), () => {
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
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_CLICK, (...args: FSMCallbackArgsType[]) => {
      this.callback?.clearAllMission?.();
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), (...args: FSMCallbackArgsType[]) => {
        return args[0] as RecentClickReason === RecentClickReason.CLEAR_ALL_MISSION;
      });
    this.addTransition(transition);
  }

  private initOnGestureEndTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, () => {
      this.callback?.toHomeIdle?.();
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), () => {
        return true;
      });
    this.addTransition(transition);
  }

  private exit(): void {
    recentScrollFlingHelper.reset();
  }

  public static get speed(): number {
    return recentScrollFlingHelper.getSpeed();
  }

  onEnter(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onEnter(from, event);
    recentScrollFlingHelper.reset();
    if (args.length > 2) {
      let deltaOffset: number = args[1] as number;
      let currentOffset: number = args[2] as number;
      recentScrollFlingHelper.invoke(deltaOffset, currentOffset);
    }
    this.callback?.onEnter?.(...args);
    return true;
  }

  onLeave(to: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onLeave(to, event);
    this.callback?.onLeave?.(...args);
    recentScrollFlingHelper.reset();
    return true;
  }
}