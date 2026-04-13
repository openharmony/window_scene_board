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
import { FSMState, FSMEvent, FSMTransition, RecentsStyleConstants } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { DockUtils, CommonConstants, } from '@ohos/launchercommon';
import { GestureHelper } from '../common/GestureHelper';
import { GestureCallbackBase } from '../common/GestureCallback';
import { FarAwayFollowingFromAppCallback } from './AppCallbacks';

const TAG = 'FarAwayFollowingFromApp';

export class FarAwayFollowingFromApp extends FSMState {
  private readonly FAR_VIEW_TO_RECENT_LIMIT: number = 0.1;
  private topOffsetY: number = 0;
  private aspectRadio: number = 0;
  private screenHeight: number = 0;
  private panelManager: SCBScenePanelManager;
  public callback: FarAwayFollowingFromAppCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_FAR_AWAY_FOLLOWING_FROM_APP);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = (callback as FarAwayFollowingFromAppCallback);
  }

  public init(): void {
    this.initGestureStartEventTransitions();
    this.initGestureUpdateEventTransitions();
    this.initGestureEndEventTransitions();
    this.initGestureCancelEventTransitions();
  }

  private initGestureStartEventTransitions(): void {
    // gesture start事件只做screen size更新
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_START, () => {
      this.initAspectRadio();
      this.initScreenHeight();
      return false;
    })
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initScreenHeight(): void {
    this.screenHeight = px2vp(this.panelManager.getScreenProperty().height);
  }

  private initAspectRadio(): void {
    this.aspectRadio = GestureHelper.getAspectRadio();
  }

  private initGestureUpdateEventTransitions(): void {
    this.toRecentFollowing();
    this.toSelfFollowingUpdate();
    this.toSelfFollowingDefault();
  }

  private toRecentFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      this.callback?.enterRecentFollowing(args[0].offsetX, args[0].offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        if (args[0].offsetY < this.topOffsetY) {
          this.topOffsetY = args[0].offsetY;
        }
        if (oneStepStateManagerInstance.isEnter()) {
          return false;
        }
        if (this.toRecentDistanceJudge(args[0])) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toRecentDistanceJudge(event: GestureEvent): boolean {
    let ratio = Math.abs(event.offsetY - this.topOffsetY) / this.screenHeight;
    let recentMaxDistance = this.aspectRadio >= RecentsStyleConstants.RECENT_LANDSCAPE_RATIO ?
      RecentsStyleConstants.RECENT_LEAVE_LIMIT_LANDSCAPE : RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MAX;
    return (ratio > this.FAR_VIEW_TO_RECENT_LIMIT) &&
      ((Math.abs(event.offsetY) / this.screenHeight) <= recentMaxDistance);
  }

  private toSelfFollowingUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.update(gestureEvent);
      return false;
    });
    let transition = FSMTransition.builder(event, this, (...args: GestureEvent[]) => {
      if (GestureHelper.isUpForward(args[0])) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private toSelfFollowingDefault(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
    let transition = FSMTransition.builder(event, this, () => {
      return false;
    });
    this.addTransition(transition);
  }

  private initGestureEndEventTransitions(): void {
    this.toHomeIdleIfOneStep();
    this.toHomeIdle();
  }

  private initGestureCancelEventTransitions(): void {
    this.cancelToHomeIdle();
  }

  private cancelToHomeIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_CANCEL, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterHomeIdle(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), () => {
      return true;
    });
    this.addTransition(transition);
  }

  private toHomeIdleIfOneStep(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterHomeIdleByOneStep(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), () => {
      if (oneStepStateManagerInstance.isEnter()) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private toHomeIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, (...args: GestureEvent[]) => {
      // release touch，enter HOME
      let gestureEvent = args[0];
      this.callback?.enterHomeIdle(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE));
    this.addTransition(transition);
  }

  public onEnter(from: FSMState, event: FSMEvent): boolean {
    super.onEnter(from, event);
    this.topOffsetY = 0;
    this.initScreenHeight();
    this.initAspectRadio();
    return true;
  }

  public onLeave(from: FSMState, event: FSMEvent): boolean {
    super.onLeave(from, event);
    return true;
  }
}
