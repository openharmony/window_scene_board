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
import { FSMCallbackArgsType, FSMEvent, FSMState, FSMTransition } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { RecentScrollFollowingCallback } from './RecentCallbacks';
import { RecentScrollHelper } from './RecentScrollHelper';
import { GestureCallbackBase } from '../common/GestureCallback';


const recentScrollFollowingHelper: RecentScrollHelper = new RecentScrollHelper('RecentScrollFollowing');

export class RecentScrollFollowing extends FSMState {
  private readonly panelManager: SCBScenePanelManager;
  private callback: RecentScrollFollowingCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_RECENT_SCROLL_FOLLOWING);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = callback as RecentScrollFollowingCallback;
  }

  public init(): void {
    this.initOnScrollEventTransitions();
    this.initOnScrollStopEventTransitions();
    this.initTouchUpEventTransitions();
  }

  private initOnScrollEventTransitions(): void {
    this.toSelfOnScroll();
    this.toScrollingFling();
  }

  private toSelfOnScroll(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_ON_SCROLL, (...args: FSMCallbackArgsType[]) => {
      let deltaOffset: number = args[1] as number;
      let currentOffset: number = args[2] as number;
      recentScrollFollowingHelper.invoke(deltaOffset, currentOffset);
      this.callback?.doScroll(deltaOffset, currentOffset);
      return false;
    });
    let transition = FSMTransition.builder(event, this, (...args: FSMCallbackArgsType[]) => {
      let scrollState = args[0] as ScrollState;
      if (scrollState === ScrollState.Scroll) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private toScrollingFling(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_ON_SCROLL, (...args: FSMCallbackArgsType[]) => {
      let deltaOffset: number = args[1] as number;
      let currentOffset: number = args[2] as number;
      this.callback?.toScrollFling?.(deltaOffset, currentOffset);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_SCROLL_FLING),
      (...args: FSMCallbackArgsType[]) => {
        let scrollState = args[0] as ScrollState;
        if (scrollState === ScrollState.Fling) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private initOnScrollStopEventTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_SCROLL_STOP, () => {
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_IDLE));
    this.addTransition(transition);
  }

  private initTouchUpEventTransitions(): void {
    this.touchUpToFling();
  }

  private touchUpToFling(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_TOUCH_UP, (...args: FSMCallbackArgsType[]) => {
      let touchEvent = args[0] as TouchEvent;
      this.callback?.doTouchUp(touchEvent);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_RECENT_SCROLL_FLING),
      () => {
        return true;
      });
    this.addTransition(transition);
  }

  private exit(): void {
    recentScrollFollowingHelper.reset();
  }

  public static get speed(): number {
    return recentScrollFollowingHelper.getSpeed();
  }

  public static get isScrollRightForward(): boolean {
    return recentScrollFollowingHelper.isScrollRightForward();
  }

  onEnter(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onEnter(from, event);
    recentScrollFollowingHelper.reset();
    if (from.equalTo(ScenePanelStates.STATE_RECENT_IDLE)) {
      let deltaOffset: number = args[1] as number;
      let currentOffset: number = args[2] as number;
      recentScrollFollowingHelper.invoke(deltaOffset, currentOffset);
    }
    this.callback?.onEnter?.(...args);
    return true;
  }

  public static updateOneFrameTime(reFreshRate: number): void {
    recentScrollFollowingHelper.updateOneFrameTime(reFreshRate);
  }

  onLeave(to: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onLeave(to, event);
    this.callback?.onLeave?.(...args);
    recentScrollFollowingHelper.reset();
    return true;
  }
}