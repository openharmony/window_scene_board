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
import { FSMState, FSMEvent, FSMTransition, FSMCallbackArgsType, RecentsStyleConstants,
  launcherStatusUtil } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { GestureHelper, gestureHelperInstance } from '../common/GestureHelper';
import { DockUtils, CommonConstants, } from '@ohos/launchercommon';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { ZoomFollowingFromAppCallback } from './AppCallbacks';
import { GestureCallbackBase } from '../common/GestureCallback';
import display from '@ohos.display';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ZoomFollowingFromApp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class ZoomFollowingFromApp extends FSMState {
  private readonly RECENT_LANDSCAPE_RATIO = 2;
  private readonly RECENT_LEAVE_LIMIT_LANDSCAPE = 0.5;
  private readonly RECENT_DISTANCE_LIMIT_MAX: number = 0.6;
  private screenHeight: number = 0;
  private aspectRadio: number = 0;
  private screenWidth: number = 0;
  private panelManager: SCBScenePanelManager;
  public callback: ZoomFollowingFromAppCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_ZOOM_FOLLOWING_FROM_APP);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = (callback as ZoomFollowingFromAppCallback);
  }

  public init(): void {
    this.initGestureUpdateEventTransitions();
    this.initGestureEndEventTransitions();
    this.initGestureCancelEventTransitions();
  }

  private initScreenHeightAndWidth(): void {
    this.screenHeight = px2vp(this.panelManager.getScreenProperty().height);
  }

  private initAspectRadio(): void {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      if (displayInfo && displayInfo.height !== 0) {
        this.aspectRadio = displayInfo.width / displayInfo.height;
      }
    } catch (e) {
      log.showError(`initAspectRadio error, code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  private initGestureUpdateEventTransitions(): void {
    this.toRecentFollowing();
    this.toQuickSwitchFollowing();
    this.toFarAwayFollowing();
    this.toSelfFollowingUpdate();
    this.toSelfFollowingDefault();
  }

  private toRecentFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterRecentFollowing(gestureEvent);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        let event = args[0];
        if (!GestureHelper.isNearlyUpForward(event)) {
          return false;
        }
        const isDistance = this.toRecentDistanceJudge(event);
        const isSpeed = this.toRecentSpeedJudge(event);
        if (isDistance && isSpeed && !oneStepStateManagerInstance.isEnter()) {
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
        // 向左或者向右滑动
        if (GestureHelper.isNearlyXForward(args[0])) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toFarAwayFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterFarAwayFollowing(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_FAR_AWAY_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        let gestureEvent = args[0];
        // 向上滑动
        if (!GestureHelper.isNearlyUpForward(gestureEvent)) {
          return true;
        }
        if (this.toFarAwayDistanceJudge(gestureEvent)) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toFarAwayDistanceJudge(event: GestureEvent): boolean {
    // 屏幕宽高比>=2
    if (this.aspectRadio >= this.RECENT_LANDSCAPE_RATIO) {
      return (Math.abs(event.offsetY) / this.screenHeight) >= this.RECENT_LEAVE_LIMIT_LANDSCAPE;
    }
    return (Math.abs(event.offsetY) / this.screenHeight) > this.RECENT_DISTANCE_LIMIT_MAX;
  }

  private toSelfFollowingUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.update(gestureEvent);
      return false;
    });
    let transition = FSMTransition.builder(event, this, (...args: GestureEvent[]) => {
      if (GestureHelper.isNearlyUpForward(args[0])) {
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
    this.toHomeIdleByOneStep();
    this.toHomeIdle();
    this.toAppIdle();
  }

  private initGestureCancelEventTransitions(): void {
    this.cancelToHomeIdle();
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

  private cancelToHomeIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_CANCEL, (...args: GestureEvent[]) => {
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), () => {
      // 侧滑的回调还未调用，但是已经开始上划的时候，切换状态机到
      if (!this.panelManager.getSceneContainerSessionList().getTopActiveSession()) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
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
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE), () => {
      if (gestureHelperInstance.isSpeedUpForward() && gestureHelperInstance.speedScalar > 0.1) {
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
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_APP_IDLE));
    this.addTransition(transition);
  }

  private toRecentDistanceJudge(event: GestureEvent): boolean {
    let percent = Math.abs(event.offsetY) / this.screenHeight;
    return (percent >= RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MIN) && (percent <= this.RECENT_DISTANCE_LIMIT_MAX);
  }

  private toRecentSpeedJudge(event: GestureEvent): boolean {
    // the unit is vp, not px
    if (gestureHelperInstance.acceleration > px2vp(0.05) &&
      gestureHelperInstance.curSpeed > px2vp(-2.0) &&
      gestureHelperInstance.curSpeed <= 0) {
      return true;
    }
    if (gestureHelperInstance.stopDuration > 80) {
      return true;
    }
    return false;
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
