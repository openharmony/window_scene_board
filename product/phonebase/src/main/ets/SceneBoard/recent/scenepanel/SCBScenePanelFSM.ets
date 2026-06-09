/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { SCBSceneContainerSession } from '@ohos/windowscene';
import { FSM, FSMState } from '@ohos/windowscene';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import type { SCBScenePanelManager } from '@ohos/windowscene';
import { RecentClickReason, ScenePanelStates } from './ScenePanelStates';
import { ScenePanelEvents } from './ScenePanelEvents';
import { HomeIdle } from './homepanel/HomeIdle';
import { QuickSwitchFollowingFromHome } from './homepanel/QuickSwitchFollowingFromHome';
import { AppIdle } from './apppanel/AppIdle';
import { ZoomFollowingFromApp } from './apppanel/ZoomFollowingFromApp';
import { RecentFollowingFromApp } from './apppanel/RecentFollowingFromApp';
import { FarAwayFollowingFromApp } from './apppanel/FarAwayFollowingFromApp';
import { QuickSwitchFollowingFromApp } from './apppanel/QuickSwitchFollowingFromApp';
import { QuickSwitchIdle } from './quickswitchpanel/QuickSwitchIdle';
import { RecentIdle } from './recentpanel/RecentIdle';
import { RecentPanelController } from './recentpanel/RecentPanelController';
import { gestureHelperInstance } from './common/GestureHelper';
import {
  SCBNavigationFromHomeCallback,
} from '@ohos/gesturenavigation/src/main/ets/controllers/SceneNavigationController/interface/SCBNavigationCallback';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { SplitIdle } from './splitpanel/SplitIdle';
import { EmergencyHomeIdle } from './homepanel/EmergencyHomeIdle';
import { GestureCallbackBase } from './common/GestureCallback';
import { RecentDeleteFollowing } from './recentpanel/RecentDeleteFollowing';
import { RecentScrollFling } from './recentpanel/RecentScrollFling';
import { RecentScrollFollowing } from './recentpanel/RecentScrollFollowing';
import { ScreenLockState } from './homepanel/ScreenLockState';
import { OverViewFollowingFromHome } from './homepanel/OverViewFollowingHome';

const TAG = 'SCBScenePanelFSM';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

interface FsmSetCallbackItem {
  name: string;
  func: (callback: GestureCallbackBase) => void;
};

export class SCBScenePanelFSM extends FSM {
  private panelManager: SCBScenePanelManager | null = null;

  constructor() {
    super(TAG);
  }

  public init(): void {
    if (!this.panelManager) {
      log.showError('fsm panel manager is null');
      return;
    }
    this.addState(new HomeIdle(this.panelManager))
      .addState(new OverViewFollowingFromHome(this.panelManager))
      .addState(new RecentIdle(this.panelManager))
      .addState(new RecentDeleteFollowing(this.panelManager))
      .addState(new RecentScrollFling(this.panelManager))
      .addState(new RecentScrollFollowing(this.panelManager))
      .addState(new AppIdle(this.panelManager))
      .addState(new ZoomFollowingFromApp(this.panelManager))
      .addState(new RecentFollowingFromApp(this.panelManager))
      .addState(new FarAwayFollowingFromApp(this.panelManager))
      .addState(new QuickSwitchFollowingFromApp(this.panelManager))
      .addState(new QuickSwitchIdle(this.panelManager))
      .addState(new SplitIdle(this.panelManager))
      .addState(new EmergencyHomeIdle(this.panelManager))
      .addState(new ScreenLockState(this.panelManager));

    this.allStates().forEach((item) => {
      item.init();
    });
    this.currentState = this.getState(ScenePanelStates.STATE_HOME_IDLE) as FSMState;
    this.registerDebugCommand();
  }

  public getRecentController(): RecentPanelController {
    let state = this.getState(ScenePanelStates.STATE_RECENT_IDLE) as RecentIdle;
    return state.controller as RecentPanelController;
  }

  private isNeedOneStep(state: ScenePanelStates): boolean {
    return (state === ScenePanelStates.STATE_APP_IDLE) ||
      (state === ScenePanelStates.STATE_RECENT_FOLLOWING_FROM_APP) ||
      (state === ScenePanelStates.STATE_ZOOM_FOLLOWING_FROM_APP) ||
      (state === ScenePanelStates.STATE_FAR_AWAY_FOLLOWING_FROM_APP) ||
      (state === ScenePanelStates.STATE_QUICK_SWITCH_FOLLOWING_FROM_APP) ||
      (state === ScenePanelStates.STATE_SCREEN_LOCK);
  }

  public consumeStartEvent(event: GestureEvent): void {
    gestureHelperInstance.reset();
    gestureHelperInstance.invoke(event);
    if (this.isNeedOneStep(this.currentState.toString() as ScenePanelStates)) {
      oneStepStateManagerInstance.reset();
    }
    this.transfer(ScenePanelEvents.EVENT_GESTURE_START, event);
  }

  public consumeUpdateEvent(event: GestureEvent): void {
    gestureHelperInstance.invoke(event);
    this.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
  }

  public consumeRecentStartEvent(containerId: number, event: GestureEvent): void {
    this.transfer(ScenePanelEvents.EVENT_RECENT_GESTURE_START, containerId, event);
  }

  public consumeRecentUpdateEvent(containerId: number, event: GestureEvent): void {
    this.transfer(ScenePanelEvents.EVENT_RECENT_GESTURE_UPDATE, containerId, event);
  }

  public consumeRecentEndEvent(containerId: number, event: GestureEvent): void {
    this.transfer(ScenePanelEvents.EVENT_RECENT_GESTURE_END, containerId, event);
  }

  public consumeRecentCancelEvent(containerId: number, event: GestureEvent): void {
    this.transfer(ScenePanelEvents.EVENT_RECENT_GESTURE_CANCEL, containerId, event);
  }

  public onScroll(scrollState: ScrollState, deltaOffset:number, currentOffset: number): void {
    this.transfer(ScenePanelEvents.EVENT_ON_SCROLL, scrollState, deltaOffset, currentOffset);
  }

  public onScrollStop(): void {
    this.transfer(ScenePanelEvents.EVENT_SCROLL_STOP);
  }

  public onTouchDown(event: TouchEvent, from: string): void {
    this.transfer(ScenePanelEvents.EVENT_TOUCH_DOWN, event, from);
  }

  public onTouchUp(event: TouchEvent, from: string): void {
    this.transfer(ScenePanelEvents.EVENT_TOUCH_UP, event, from);
  }

  public onClick(reason: RecentClickReason, sceneContainerSession?: SCBSceneContainerSession): void {
    this.transfer(ScenePanelEvents.EVENT_CLICK, reason, sceneContainerSession);
  }

  /**
   * consume gesture end event
   * */
  public consumeEndEvent(event: GestureEvent): void {
    this.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
  }

  /**
   * consume gesture cancel event
   * */
  public consumeCancelEvent(event: GestureEvent): void {
    this.transfer(ScenePanelEvents.EVENT_GESTURE_CANCEL, event);
  }

  public setCurrentStateToHome(): void {
    this.currentState = this.getState(ScenePanelStates.STATE_HOME_IDLE) as FSMState;
  }

  public isFollowingState(): boolean {
    // 桌面跟手 app跟手 上划删除
    if (this.currentState.equalTo(ScenePanelStates.STATE_OVER_VIEW_FROM_HOME) ||
      this.currentState.toString().search('Following') !== -1) {
      log.showInfo(`isFollowingState ${this.currentState}`);
      return true;
    }
    return false;
  }

  public setCurrentStateToApp(): void {
    log.showWarn('setCurrentStateToApp.');
    this.currentState = this.getState(ScenePanelStates.STATE_APP_IDLE) as FSMState;
  }

  public setCurrentStateToRecent(): void {
    log.showWarn('setCurrentStateToRecent.');
    this.currentState = this.getState(ScenePanelStates.STATE_RECENT_IDLE) as FSMState;
  }

  public setCurrentStateToSplit(): void {
    log.showWarn('setCurrentStateToSplit.');
    this.currentState = this.getState(ScenePanelStates.STATE_SPLIT_IDLE) as FSMState;
  }

  public setCurrentStateToEmergencyHome(): void {
    log.showWarn('setCurrentStateToEmergencyHome.');
    this.currentState = this.getState(ScenePanelStates.STATE_EMERGENCY_HOME_IDLE) as FSMState;
  }

  public setCurrentStateToScreenLock(): void {
    log.showWarn('setCurrentStateToScreenLock.');
    this.currentState = this.getState(ScenePanelStates.STATE_SCREEN_LOCK) as FSMState;
  }

  private setCallbacks: FsmSetCallbackItem[] = [
    {
      name: 'HomeIdleCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_HOME_IDLE) as HomeIdle;
        stat.setCallback(callback);
      }
    },
    {
      name: 'OverViewFollowingFromHomeCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_OVER_VIEW_FROM_HOME) as OverViewFollowingFromHome;
        stat.setCallback(callback);
      }
    },
    {
      name: 'AppIdleCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_APP_IDLE) as AppIdle;
        stat.setCallback(callback);
      }
    },
    {
      name: 'ZoomFollowingFromAppCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_ZOOM_FOLLOWING_FROM_APP) as ZoomFollowingFromApp;
        stat.setCallback(callback);
      }
    },
    {
      name: 'RecentFollowingFromAppCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_RECENT_FOLLOWING_FROM_APP) as RecentFollowingFromApp;
        stat.setCallback(callback);
      }
    },
    {
      name: 'FarAwayFollowingFromAppCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_FAR_AWAY_FOLLOWING_FROM_APP) as FarAwayFollowingFromApp;
        stat.setCallback(callback);
      }
    },
    {
      name: 'QuickSwitchFollowingFromAppCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_QUICK_SWITCH_FOLLOWING_FROM_APP) as QuickSwitchFollowingFromApp;
        stat.setCallback(callback);
      }
    },
    {
      name: 'RecentIdleCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_RECENT_IDLE) as RecentIdle;
        stat.setCallback(callback);
      }
    },
    {
      name: 'EmergencyHomeIdleCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_EMERGENCY_HOME_IDLE) as RecentIdle;
        stat.setCallback(callback);
      }
    },
    {
      name: 'RecentDeleteFollowingCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_RECENT_DELETE_FOLLOWING) as RecentDeleteFollowing;
        stat.setCallback(callback);
      }
    },
    {
      name: 'RecentScrollFollowingCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_RECENT_SCROLL_FOLLOWING) as RecentScrollFollowing;
        stat.setCallback(callback);
      }
    },
    {
      name: 'RecentScrollFlingCallback',
      func: (callback: GestureCallbackBase) => {
        let stat = this.getState(ScenePanelStates.STATE_RECENT_SCROLL_FLING) as RecentScrollFling;
        stat.setCallback(callback);
      }
    },
  ];

  public setCallback(callback: GestureCallbackBase): void {
    let item = this.setCallbacks.find((item) => item.name === callback.name);
    if (item) {
      item.func(callback);
    }
  }

  public static getInstance(panelManager?: SCBScenePanelManager): SCBScenePanelFSM {
    let fsm = SingletonHelper.getInstance(SCBScenePanelFSM, TAG);
    if (panelManager) {
      fsm.panelManager = panelManager;
    }
    return fsm;
  }

  private debugCurrentState(): string {
    return this.currentState.toString();
  }

  private debugAllState(): string {
    let responseText = '';
    this.allStates().forEach((item) => {
      responseText += item.toString();
      responseText += ' | ';
    })
    return responseText;
  }

  private debugPrintTransitions(args: string[]): string {
    if (args.length !== 0) {
      let state = this.getState(args[0]);
      if (state) {
        return state.printTransitions();
      }
      return 'invalid state: ' + args[0];
    }
    return this.printDetails();
  }

  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'currentState',
        callback: () => {
          return this.debugCurrentState();
        }
      },
      {
        cmdName: 'allStates',
        callback: () => {
          return this.debugAllState();
        }
      },
      {
        cmdName: 'transitions',
        callback: (args: string[]) => {
          return this.debugPrintTransitions(args);
        }
      },
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }
}