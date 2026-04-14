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
import { FSMState, FSMTransition, FSMEvent, FSMCallbackArgsType, RecentsStyleConstants,
  launcherStatusUtil } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { GestureHelper, gestureHelperInstance } from '../common/GestureHelper';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { RecentFollowingFromAppCallback } from './AppCallbacks';
import { GestureCallbackBase } from '../common/GestureCallback';

const TAG = 'RecentFollowingFromApp';

export class RecentFollowingFromApp extends FSMState {
  private readonly PREPARE_FAR_AWAY_PERCENT = 0.05;
  private readonly ENTER_PREPARE_FAR_AWAY_LIMIT_LANDSCAPE = RecentsStyleConstants.RECENT_LEAVE_LIMIT_LANDSCAPE *
    (1 - this.PREPARE_FAR_AWAY_PERCENT);
  private readonly ENTER_PREPARE_FAR_AWAY_LIMIT = RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MAX *
    (1 - this.PREPARE_FAR_AWAY_PERCENT);
  // after trigger recent view，up 10% more to leave recent view
  private aspectRadio: number = 0;
  private screenHeight: number = 0;
  private screenWidth: number = 0;
  private panelManager: SCBScenePanelManager;
  private callback: RecentFollowingFromAppCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_RECENT_FOLLOWING_FROM_APP);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = (callback as RecentFollowingFromAppCallback);
  }

  public init(): void {
    this.initGestureStartEventTransitions();
    this.initGestureUpdateEventTransitions();
    this.initGestureCancelEventTransitions();
    this.initGestureEndEventTransitions();
  }

  private initGestureStartEventTransitions(): void {
    // gesture start事件只做screen size更新
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_START, () => {
      this.initAspectRadio();
      this.initScreenHeightAndWidth();
      return false;
    })
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initScreenHeightAndWidth(): void {
    this.screenHeight = px2vp(this.panelManager.getScreenProperty().height);
    this.screenWidth = px2vp(this.panelManager.getScreenProperty().width);
  }

  private initAspectRadio(): void {
    this.aspectRadio = GestureHelper.getAspectRadio();
  }

  private initGestureUpdateEventTransitions(): void {
    this.toFarAwayFollowing();
    this.toQuickSwitchFollowing();
    this.toPrepareFarAwayFollowingUpdate();
    this.toSelfFollowingUpdate();
    this.toSelfFollowingDefault();
  }

  private toFarAwayFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterFarAwayFollowing(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_FAR_AWAY_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        if (!GestureHelper.isUpForward(args[0])) {
          return false;
        }
        if (this.toFarAwayDistanceJudge(args[0].offsetY)) {
          return true;
        }
        if (oneStepStateManagerInstance.isEnter()) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toQuickSwitchFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterQuickSwitchFollowing(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_QUICK_SWITCH_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        if (launcherStatusUtil.getShowOutLauncherStatus()) {
          return false;
        }
        let gestureEvent = args[0];
        if (!GestureHelper.isNearlyXForward(gestureEvent)) {
          return false;
        }
        if (Math.abs(gestureEvent.offsetY) / this.screenHeight < RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MIN) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toPrepareFarAwayFollowingUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let enterPrepareFarawayLimit = this.aspectRadio >= RecentsStyleConstants.RECENT_LANDSCAPE_RATIO ?
      this.ENTER_PREPARE_FAR_AWAY_LIMIT_LANDSCAPE : this.ENTER_PREPARE_FAR_AWAY_LIMIT;
      let gestureEvent = args[0];
      // 通过上滑的offsetY来计算预离开动效的比例
      let prepareFarAwayPercent = (Math.abs(gestureEvent.offsetY) / this.screenHeight - enterPrepareFarawayLimit) /
        (this.PREPARE_FAR_AWAY_PERCENT * enterPrepareFarawayLimit);
      this.callback?.prepareToFarAwayUpdate(gestureEvent, prepareFarAwayPercent);
      return true;
    });
    let transition = FSMTransition.builder(event, this, (...args: GestureEvent[]) => {
        if (this.prepareToFarAwayDistanceJudge(args[0].offsetY)) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toSelfFollowingUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.update(gestureEvent);
      return false;
    });
    let transition = FSMTransition.builder(event, this,
      (...args: GestureEvent[]) => {
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

  private initGestureCancelEventTransitions(): void {
    this.cancelToAppIdle();
  }

  private cancelToAppIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_CANCEL, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterAppIdle(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_APP_IDLE), () => {
        return true;
      });
    this.addTransition(transition);
  }

  private initGestureEndEventTransitions(): void {
    this.toHomeIdleByOneStep();
    this.toHomeIdle();
    this.toAppIdle();
    this.toRecentIdle();
  }

  private toHomeIdleByOneStep(): void {
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
      let gestureEvent = args[0];
      this.callback?.enterHomeIdle(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE),
      (...args: GestureEvent[]) => {
        let gestureEvent = args[0];
        if (!GestureHelper.isUpForward(gestureEvent)) {
          return false;
        }
        // 向上抛划
        if (gestureHelperInstance.isSpeedUpForward() && gestureHelperInstance.speedScalar > 0.5) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toAppIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterAppIdle(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_APP_IDLE),
      (...args: GestureEvent[]) => {
        if (!GestureHelper.isNearlyYForward(args[0])) {
          return false;
        }
        // 向下抛划, 速度较大时, 回到应用
        if (gestureHelperInstance.isSpeedDownForward() && gestureHelperInstance.speedScalar > 2) {
          return true;
        }
        // 在屏幕底部10%以下，回到应用
        if (Math.abs(args[0].offsetY) / this.screenHeight <= RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MIN) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toRecentIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterRecentIdle(gestureEvent.offsetX, gestureEvent.offsetY, true);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_IDLE));
    this.addTransition(transition);
  }

  private toFarAwayDistanceJudge(eventY: number): boolean {
    // 屏幕宽高比>=2, 也就是横屏状态
    if (this.aspectRadio >= RecentsStyleConstants.RECENT_LANDSCAPE_RATIO) {
      return (Math.abs(eventY) / this.screenHeight) > RecentsStyleConstants.RECENT_LEAVE_LIMIT_LANDSCAPE;
    }
    return (Math.abs(eventY) / this.screenHeight) > RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MAX;
  }

  private prepareToFarAwayDistanceJudge(eventY: number): boolean {
    // 屏幕宽高比>=2, 也就是横屏状态
    let enterPrepareFarawayLimit = this.aspectRadio >= RecentsStyleConstants.RECENT_LANDSCAPE_RATIO ?
    this.ENTER_PREPARE_FAR_AWAY_LIMIT_LANDSCAPE : this.ENTER_PREPARE_FAR_AWAY_LIMIT;
    return (Math.abs(eventY) / this.screenHeight) >= enterPrepareFarawayLimit;
  }

  public onEnter(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onEnter(from, event);
    this.initScreenHeightAndWidth();
    this.initAspectRadio();
    this.callback?.onEnter?.(...args);
    return true;
  }

  public onLeave(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onLeave(from, event);
    this.callback?.onLeave?.(...args);
    return true;
  }
}