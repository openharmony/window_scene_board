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
import { FSMState, FSMTransition, FSMEvent } from '@ohos/windowscene';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { GestureHelper, gestureHelperInstance } from '../common/GestureHelper';
import {
  SCBNavigationFromHomeCallback
} from '@ohos/gesturenavigation/src/main/ets/controllers/SceneNavigationController/interface/SCBNavigationCallback';

export class QuickSwitchFollowingFromHome extends FSMState {
  private panelManager: SCBScenePanelManager;
  private screenHeight: number = 0;
  private screenWidth: number = 0;
  public callback: SCBNavigationFromHomeCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_QUICK_SWITCH_FOLLOWING_FROM_HOME);
    this.panelManager = manager;
  }

  public init(): void {
    this.initGestureUpdateEventTransitions();
    this.initGestureEndEventTransitions();
    this.initGestureCancelEventTransitions();
  }

  private initScreenHeightAndWidth(): void {
    this.screenHeight = px2vp(this.panelManager.getScreenProperty().height);
    this.screenWidth = px2vp(this.panelManager?.getScreenProperty().width);
  }

  private initGestureUpdateEventTransitions(): void {
    this.toSelfFollowingUpdate();
    this.toSelfFollowingDefault();
  }

  private toSelfFollowingUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      this.callback?.onUpdateSwitch(args[0].offsetX, args[0].offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this, (...args: GestureEvent[]) => {
      let gestureEvent = args[0];
      if (GestureHelper.isRightForward(gestureEvent)) {
        return true;
      }
      return false;
    });
    this.addTransition(transition);
  }

  private toSelfFollowingDefault(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initGestureEndEventTransitions(): void {
    // 手势向上松手时，并且满足进入QuickSwitch状态时，转移到QuickSwitch状态
    this.toQuickSwitchIdle();
    // 手势向下滑动松手时，或者不满足进入recent条件时，转移到Home状态
    this.toHomeIdle();
  }

  private initGestureCancelEventTransitions(): void {
    this.cancelToHomeIdle();
  }

  private cancelToHomeIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_CANCEL, () => {
      this.callback?.onExitSwitch();
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE));
    this.addTransition(transition);
  }

  private toQuickSwitchIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, (...args: GestureEvent[]) => {
      this.callback?.onEnterSwitch(false, args[0].offsetX, args[0].offsetY);
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_QUICK_SWITCH_IDLE),
      (...args: GestureEvent[]) => {
        let gestureEvent: GestureEvent = args[0];
        if (!GestureHelper.isRightForward(gestureEvent)) {
          return false;
        }
        // 向右抛划， 并且满足速度要求，直接进入快切
        if (gestureHelperInstance.isSpeedRightForward() && gestureHelperInstance.speedScalar > 0.6) {
          return true;
        }
        let distanceCondition = (gestureEvent.offsetX > this.screenWidth / 3);
        if (!distanceCondition) {
          return false;
        }
        // 达到1/3距离条件之后， 向右抛划， 进入快切
        if (gestureHelperInstance.isSpeedRightForward()) {
          return true;
        }
        // 达到1/3距离条件之后， 向左抛划速度较小时， 进入快切
        if (gestureHelperInstance.isSpeedLeftForward() && gestureHelperInstance.speedScalar < 0.6) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toHomeIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, () => {
      this.callback?.onExitSwitch();
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_HOME_IDLE));
    this.addTransition(transition);
  }

  public onEnter(from: FSMState, event: FSMEvent): boolean {
    super.onEnter(from, event);
    this.initScreenHeightAndWidth();
    return true;
  }

  public onLeave(from: FSMState, event: FSMEvent): boolean {
    super.onLeave(from, event);
    return true;
  }
}