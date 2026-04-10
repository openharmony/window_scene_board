/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { SCBRecentSessionState } from '@ohos/windowscene/src/main/ets/scene/session/SCBRecentSessionInfo';

export enum SCBRecentStateEvents {
  EVENT_ENTER_RECENT_START = 'EnterRecentStartEvent',
  EVENT_ENTER_RECENT_ALL_ANIMATE_START = 'EnterRecentAllAnimateStartEvent',
  EVENT_ENTER_RECENT_ANIMATE_START = 'EnterRecentAnimateStartEvent',
  EVENT_ENTER_RECENT_ANIMATE_STARTED = 'EnterRecentAnimateStartedEvent',
  EVENT_ENTER_RECENT_ALL_ANIMATE_STARTED = 'EnterRecentAllAnimateStartedEvent',
  EVENT_ENTER_RECENT_ALL_ANIMATE_FINISH = 'EnterRecentAllAnimateFinishEvent',
  EVENT_ENTER_RECENT_END = 'EnterRecentEndEvent',
  EVENT_EXIT_RECENT_START = 'ExitRecentStartEvent',
  EVENT_EXIT_RECENT_ALL_ANIMATE_START = 'ExitRecentAllAnimateStartEvent',
  EVENT_EXIT_RECENT_ANIMATE_START = 'ExitRecentAnimateStartEvent',
  EVENT_EXIT_RECENT_ANIMATE_STARTED = 'ExitRecentAnimateStartedEvent',
  EVENT_EXIT_RECENT_ALL_ANIMATE_STARTED = 'ExitRecentAllAnimateStartedEvent',
  EVENT_EXIT_RECENT_ALL_ANIMATE_FINISH = 'ExitRecentAllAnimateFinishEvent',
  EVENT_EXIT_RECENT_END = 'ExitRecentEndEvent',
}

export type SCBRecentStateCallbackArgsType = boolean | number | string | object;

export type SCBRecentStateCallbackType = ((...args: SCBRecentStateCallbackArgsType[]) => boolean);

export interface SCBRecentStateCallback {
  name: string;
  func: SCBRecentStateCallbackType;
};

const TAG = 'SCBRecentState';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

@Observed
export class SCBRecentState {
  private normalState_: SCBRecentSessionState = SCBRecentSessionState.OUT_OF_RECENT;
  private isInSplit_: boolean = false;
  private screenId_: number = 0;
  private onRecentCallbacks: Map<SCBRecentStateEvents, SCBRecentStateCallback[]> = new Map();
  // when view state changed, view will update. view state is the subset of normal state.
  @Track private viewState_: SCBRecentSessionState = SCBRecentSessionState.OUT_OF_RECENT;

  constructor(screenId: number) {
    this.screenId_ = screenId;
    this.registerDebugCommand();
  }

  public get screenId(): number {
    return this.screenId_;
  }

  public get viewState(): SCBRecentSessionState {
    return this.viewState_;
  }

  public get isInSplit(): boolean {
    return this.isInSplit_;
  }

  public isViewInRecent(): boolean {
    return this.viewState_ > SCBRecentSessionState.INIT &&
      this.viewState_ < SCBRecentSessionState.EXIT_RECENT_ALL_ANIMATE_FINISH;
  }

  public setIsInSplit(isInSplit: boolean): void {
    this.isInSplit_ = isInSplit;
  }

  public isInRecent(): boolean {
    if (this.isInSplit_) {
      return false;
    }
    return this.normalState_ > SCBRecentSessionState.INIT &&
      this.normalState_ < SCBRecentSessionState.EXIT_RECENT_ALL_ANIMATE_FINISH;
  }

  public isStable(): boolean {
    return this.normalState_ === SCBRecentSessionState.STABLE;
  }

  public get state(): SCBRecentSessionState {
    return this.normalState_;
  }

  private set state(newState: SCBRecentSessionState) {
    switch (newState) {
    // when exit recent finish, or start enter recent
      case SCBRecentSessionState.ENTER_RECENT_START:
      case SCBRecentSessionState.EXIT_RECENT_ALL_ANIMATE_FINISH:
      case SCBRecentSessionState.OUT_OF_RECENT:
        this.viewState_ = newState;
        break;
    }
    this.normalState_ = newState;
  }

  private doEventCallbacks(event: SCBRecentStateEvents, ...args: SCBRecentStateCallbackArgsType[]): void {
    let callbackList = this.onRecentCallbacks.get(event);
    if (!callbackList) {
      return;
    }
    callbackList.forEach((item) => {
      log.showInfo(`do recent event ${event}, callback ${item.name}, ${this.screenId}`);
      item.func(...args);
    });
  }

  private transferState(event: SCBRecentStateEvents, nextState: SCBRecentSessionState,
    ...args: SCBRecentStateCallbackArgsType[]): boolean {
    if (this.state === nextState) {
      return false;
    }
    log.showInfo(`recent state transfer from ${this.state} to ${nextState}, ${this.screenId}`);
    this.state = nextState;
    this.doEventCallbacks(event, ...args);
    return true;
  }

  public onEnterRecentStart(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_START;
    let nextState = SCBRecentSessionState.ENTER_RECENT_START;
    return this.transferState(event, nextState, ...args);
  }

  public onEnterRecentAllAnimateStart(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_ALL_ANIMATE_START;
    let nextState = SCBRecentSessionState.ENTER_RECENT_ALL_ANIMATE_START;
    return this.transferState(event, nextState, ...args);
  }

  public onEnterRecentAllAnimateStarted(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_ALL_ANIMATE_STARTED;
    let nextState = SCBRecentSessionState.ENTER_RECENT_ALL_ANIMATE_STARTED;
    return this.transferState(event, nextState, ...args);
  }

  public onEnterRecentAllAnimateFinish(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_ALL_ANIMATE_FINISH;
    let nextState = SCBRecentSessionState.ENTER_RECENT_ALL_ANIMATE_FINISH | SCBRecentSessionState.STABLE;
    return this.transferState(event, nextState, ...args);
  }

  public onEnterRecentEnd(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_ENTER_RECENT_END;
    let nextState = SCBRecentSessionState.ENTER_RECENT_END;
    return this.transferState(event, nextState, ...args);
  }

  public onExitRecentStart(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_EXIT_RECENT_START;
    let nextState = SCBRecentSessionState.EXIT_RECENT_START;
    return this.transferState(event, nextState, ...args);
  }

  public onExitRecentAllAnimateStart(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_EXIT_RECENT_ALL_ANIMATE_START;
    let nextState = SCBRecentSessionState.EXIT_RECENT_ALL_ANIMATE_START;
    return this.transferState(event, nextState, ...args);
  }

  public onExitRecentAllAnimateStarted(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_EXIT_RECENT_ALL_ANIMATE_STARTED;
    let nextState = SCBRecentSessionState.EXIT_RECENT_ALL_ANIMATE_STARTED;
    return this.transferState(event, nextState, ...args);
  }

  public onExitRecentAllAnimateFinish(...args: SCBRecentStateCallbackArgsType[]): boolean {
    let event = SCBRecentStateEvents.EVENT_EXIT_RECENT_ALL_ANIMATE_FINISH;
    let nextState = SCBRecentSessionState.EXIT_RECENT_ALL_ANIMATE_FINISH | SCBRecentSessionState.OUT_OF_RECENT;
    return this.transferState(event, nextState, ...args);
  }

  private registerRecentCallbackIfNotExit(callbackList: SCBRecentStateCallback[],
    callback: SCBRecentStateCallback): boolean {
    let found = callbackList.find((item) => {
      return (item.name === callback.name);
    });
    if (found) {
      return false;
    }
    callbackList.push(callback);
    return true;
  }

  public registerRecentCallback(event: SCBRecentStateEvents, callback: SCBRecentStateCallback): boolean {
    let callbackList = this.onRecentCallbacks.get(event);
    if (!callbackList) {
      callbackList = [];
      this.onRecentCallbacks.set(event, callbackList);
    }
    let ret = this.registerRecentCallbackIfNotExit(callbackList, callback);
    if (!ret) {
      log.showInfo(`event: ${event}, callback ${callback.name} is already exist, do not register it again.`);
    }
    return ret;
  }

  public unregisterRecentCallback(event: SCBRecentStateEvents, callback?: SCBRecentStateCallback): void {
    if (!callback) {
      this.onRecentCallbacks.delete(event);
      log.showInfo(`unregisterRecentCallback:${this.screenId}, ${event}`);
      return;
    }
    const callbackList = this.onRecentCallbacks.get(event);
    const index = callbackList?.indexOf(callback);
    if (index !== undefined && index !== -1) {
      callbackList?.splice(index, 1);
      log.showInfo(`unregisterRecentCallback:${this.screenId}, ${callback.name}`);
    }
  }

  private debugGetRecentState(args: string[]): string {
    return this.normalState_.toString();
  }

  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'info',
        callback: (args: string[]): string => {
          return this.debugGetRecentState(args);
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG + this.screenId_.toString(), cmds);
  }
}

class SCBRecentStateManager {
  private static instance: SCBRecentStateManager = new SCBRecentStateManager();
  private recentStateInstances: SCBRecentState[] = [];

  public static getInstance(): SCBRecentStateManager {
    return SCBRecentStateManager.instance;
  }

  public getRecentStateInstance(screenId: number): SCBRecentState {
    let found = this.recentStateInstances.find((item) => {
      return (item.screenId === screenId);
    });
    if (found) {
      return found;
    }
    let newRecentStateInstance = new SCBRecentState(screenId);
    this.recentStateInstances.push(newRecentStateInstance);
    return newRecentStateInstance;
  }
}

export const recentStateManager: SCBRecentStateManager = SCBRecentStateManager.getInstance();
