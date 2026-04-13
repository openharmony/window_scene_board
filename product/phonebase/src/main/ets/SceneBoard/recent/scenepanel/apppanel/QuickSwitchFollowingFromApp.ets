/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { FSMState, FSMTransition, FSMEvent, FSMCallbackArgsType, RecentsStyleConstants } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { GestureHelper, gestureHelperInstance } from '../common/GestureHelper';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import display from '@ohos.display';
import { QuickSwitchFollowingFromAppCallback } from './AppCallbacks';
import { GestureCallbackBase } from '../common/GestureCallback';
import { desktopUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'QuickSwitchFollowingFromApp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class QuickSwitchFollowingFromApp extends FSMState {
  private readonly RECENT_LANDSCAPE_RATIO = 2;
  private readonly RECENT_LEAVE_LIMIT_LANDSCAPE = 0.5;
  private readonly RECENT_DISTANCE_LIMIT_MAX: number = 0.6;
  private readonly RECOGNIZE_THRESHOLD = -px2vp(20);
  private screenHeight: number = 0;
  private screenWidth = 0;
  private aspectRadio: number = 0;
  private startEvent: GestureEvent | null = null;
  private panelManager: SCBScenePanelManager;
  private callback: QuickSwitchFollowingFromAppCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_QUICK_SWITCH_FOLLOWING_FROM_APP);
    this.panelManager = manager;
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = (callback as QuickSwitchFollowingFromAppCallback);
  }

  public init(): void {
    this.initGestureUpdateEventTransitions();
    this.initGestureEndEventTransitions();
    this.initGestureCancelEventTransitions();
  }

  private initScreenHeightAndWidth(): void {
    this.screenHeight = px2vp(this.panelManager.getScreenProperty().height);
    this.screenWidth = px2vp(this.panelManager.getScreenProperty().width);
  }

  private initAspectRadio(): void {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      if (displayInfo.height !== 0) {
        this.aspectRadio = displayInfo.width / displayInfo.height;
      }
    } catch (e) {
      log.showError(`initAspectRadio error, code: ${e?.code}, msg: ${e?.message}`);
    }
  }

  private initGestureUpdateEventTransitions(): void {
    this.toRecentFollowing();
    this.toFarAwayFollowing();
    this.toSelfFollowingUpdate();
  }

  private toFarAwayFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterFarAwayFollowing(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_FAR_AWAY_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        // direction and distance judge
        if (GestureHelper.isNearlyUpForward(args[0]) && this.toFarAwayDistanceJudge(args[0])) {
          return true;
        }
        // other judge
        if (oneStepStateManagerInstance.isEnter()) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toFarAwayDistanceJudge(event: GestureEvent): boolean {
    if (!this.startEvent) {
      return false;
    }
    // 若当前屏幕宽高比>=2，则进多任务后需offsetY超过屏幕高度的50%才退出，避免难进多任务
    if (this.aspectRadio >= this.RECENT_LANDSCAPE_RATIO && event.offsetY < this.startEvent.offsetY) {
      return (Math.abs(event.offsetY) / this.screenHeight) >= this.RECENT_LEAVE_LIMIT_LANDSCAPE;
    }
    return (Math.abs(event.offsetY) / this.screenHeight) > this.RECENT_DISTANCE_LIMIT_MAX;
  }

  private toRecentFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterRecentFollowing(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event,
      this.myFsm.getState(ScenePanelStates.STATE_RECENT_FOLLOWING_FROM_APP), (...args: GestureEvent[]) => {
        let event = args[0];
        // direction judge
        if (!GestureHelper.isNearlyUpForward(event)) {
          return false;
        }
        // distance judge
        const isDistance = this.toRecentDistanceJudge(event);
        // speed judge
        const isSpeed = this.toRecentSpeedJudge(event);
        if (isDistance && isSpeed && !oneStepStateManagerInstance.isEnter()) {
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
    let transition = FSMTransition.builder(event, this, (...args: GestureEvent[]) => {
      return true;
    });
    this.addTransition(transition);
  }

  public isNearlyXForward(offsetX: number, offsetY: number): boolean {
    return Math.abs(offsetY) <= Math.abs(offsetX);
  }

  private initGestureEndEventTransitions(): void {
    this.toHomeIdleByOneStep();
    this.toHomeIdle();
    this.toQuickSwitchIdle();
    this.toAppIdle();
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

  private toQuickSwitchIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      this.callback?.enterQuickSwitchIdle(gestureEvent.offsetX, gestureEvent.offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_QUICK_SWITCH_IDLE),
      (...args: GestureEvent[]) => {
        // 小屏幕（直板机或者折叠屏的非展开态）显示并且横屏状态下不进入快切
        if (!this.isBigDisplay() && !this.panelManager.getScreenProperty().isScreenVertical()) {
          return false;
        }
        let gestureEvent = args[0];
        if (!GestureHelper.isNearlyXForward(gestureEvent)) {
          return false;
        }
        // 向右滑动后，向右抛划
        if (GestureHelper.isRightForward(gestureEvent) && gestureHelperInstance.speedXVector > 0.6) {
          return true;
        }
        // 向左滑动后，向左抛划
        if (GestureHelper.isLeftForward(gestureEvent) && -gestureHelperInstance.speedXVector > 0.6) {
          return true;
        }
        // 速度小于阈值, 位移大于1/3屏幕宽度
        if ((Math.abs(gestureHelperInstance.speedXVector) <= 0.6) &&
          (Math.abs(gestureEvent.offsetX) >= this.screenWidth / 3)) {
          return true;
        }
        // 向右滑动后向左抛划，向左滑动后向右抛划，滑动距离小于屏幕宽度1/3场景，均不做快切操作
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
        let event = args[0];
        // direction judge
        if (!GestureHelper.isNearlyUpForward(event)) {
          return false;
        }
        // distance and speed
        if (-gestureHelperInstance.speedYVector > 0.1) {
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

  private isBigDisplay(): boolean {
    if (DeviceHelper.isPad()) {
      return true;
    }
    if (desktopUtil.isFoldExpandStatus()) {
      return true;
    }
    return false;
  }

  private toRecentDistanceJudge(event: GestureEvent): boolean {
    let percent = Math.abs(event.offsetY) / this.screenHeight;
    return (percent >= RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MIN) && (percent <= this.RECENT_DISTANCE_LIMIT_MAX);
  }

  private toRecentSpeedJudge(event: GestureEvent): boolean {
    // the unit is vp, not px
    if (gestureHelperInstance.acceleration > px2vp(0.05) &&
      gestureHelperInstance.speedScalar < px2vp(2.0) &&
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
    this.startEvent = args[0] as GestureEvent;
    this.initScreenHeightAndWidth();
    this.initAspectRadio();
    this.callback?.onEnter?.(from, ...args);
    return true;
  }

  public onLeave(from: FSMState, event: FSMEvent, ...args: FSMCallbackArgsType[]): boolean {
    super.onLeave(from, event);
    this.callback?.onLeave?.(...args);
    return true;
  }
}