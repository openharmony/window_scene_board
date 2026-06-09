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
import { FSMState, FSMTransition, FSMEvent, SCBTransitionManager, RecentsStyleConstants } from '@ohos/windowscene';
import { ScenePanelStates } from '../ScenePanelStates';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { HomePanelController } from './HomePanelController';
import { ScenePanelEvents } from '../ScenePanelEvents';
import { GestureHelper } from '../common/GestureHelper';
import { GestureCallbackBase } from '../common/GestureCallback';
import { HomeIdleCallback } from './HomeCallbacks';

export class HomeIdle extends FSMState {
  private screenHeight: number = 0;
  private isFromHomeState = true;
  private panelManager: SCBScenePanelManager;
  public controller: HomePanelController | null = null;
  public callback: HomeIdleCallback | null = null;

  constructor(manager: SCBScenePanelManager) {
    super(ScenePanelStates.STATE_HOME_IDLE);
    this.panelManager = manager;
  }

  public init(): void {
    if (!this.panelManager) {
      return;
    }
    this.initController();
    this.initGestureStartEventTransitions();
    this.initGestureUpdateEventTransitions();
    this.initGestureEndEventTransitions();
    this.initGestureCancelEventTransitions();
  }

  public setCallback(callback: GestureCallbackBase): void {
    this.callback = (callback as HomeIdleCallback);
  }

  private initGestureStartEventTransitions(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_START, () => {
      this.initScreenHeight();
      this.callback?.gestureStart();
      return false;
    })
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initScreenHeight(): void {
    this.screenHeight = px2vp(this.panelManager.getScreenProperty().height);
  }

  private initGestureUpdateEventTransitions(): void {
    // 手势阈值满足快切或多任务时，进入OverViewFollowing状态
    this.toOverViewFollowing();
    this.toSelfUpdate();
  }

  private toOverViewFollowing(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      this.callback?.onEnterOverView();
      return true;
    });
    let transition = FSMTransition.builder(event, this.myFsm.getState(ScenePanelStates.STATE_OVER_VIEW_FROM_HOME),
      (...args: GestureEvent[]) => {
        if (GestureHelper.shouldEnterOverViewFromHome(args[0], this.screenHeight)) {
          return true;
        }
        return false;
      });
    this.addTransition(transition);
  }

  private toSelfUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE, (...args: GestureEvent[]) => {
      this.callback?.update(args[0].offsetX, args[0].offsetY);
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

  private initGestureEndEventTransitions(): void {
    // 手势向上松手时，停留在当前状态, 同时进入到桌面首页
    this.toSelfIdleUpdate();
    // 手势向下状态等松手时，停留在当前状态，什么都不做
    this.toSelfIdleDefault();
  }

  private toSelfIdleUpdate(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, () => {
      if (this.isFromHomeState) {
        this.controller?.enterFirstHomePage(this.panelManager.getScreenProperty().screenId);
      } else {
        this.callback?.enterHomeIdle();
        this.isFromHomeState = true;
      }
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

  private toSelfIdleDefault(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END, () => {
      SCBTransitionManager.getInstance().swipeUpBackHomeFromHome(RecentsStyleConstants.DESKTOP_SCALE_MAX);
      return false;
    });
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initGestureCancelEventTransitions(): void {
    this.cancelToSelfIdle();
  }

  private cancelToSelfIdle(): void {
    let event = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_CANCEL, () => {
      SCBTransitionManager.getInstance().swipeUpBackHomeFromHome(RecentsStyleConstants.DESKTOP_SCALE_MAX);
      return false;
    });
    let transition = FSMTransition.builder(event, this);
    this.addTransition(transition);
  }

  private initController(): void {
    this.controller = new HomePanelController();
  }

  public onEnter(from: FSMState, event: FSMEvent): boolean {
    super.onEnter(from, event);
    this.initScreenHeight();
    return true;
  }

  public onLeave(to: FSMState, event: FSMEvent): boolean {
    super.onLeave(to, event);
    this.isFromHomeState = false;
    return true;
  }
}
