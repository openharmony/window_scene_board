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
import { LogDomain, SingletonHelper, LogHelper } from '@ohos/basicutils';

export enum RecentStates {
  STATE_INIT = 'Init',
  STATE_ENTER_FOLLOWING = 'EnterFollowing',
  STATE_ENTER_ANIMATING = 'EnterAnimating',
  STATE_STABLE = 'Stable',
  STATE_SCROLLING = 'Scrolling',
  STATE_DELETE_FOLLOWING = 'DeleteFollowing',
  STATE_DELETE_ANIMATING = 'DeleteAnimating',
  STATE_DELETE_ALL_ANIMATING = 'DeleteAllAnimating',
  STATE_EXIT_ANIMATING = 'ExitAnimating',
  STATE_START_SCENE_ANIMATING = 'StartSceneAnimating'
}

const TAG = 'RecentStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

@Observed
export class RecentStateManager {
  private currentState_: RecentStates = RecentStates.STATE_INIT;

  public static getInstance(): RecentStateManager {
    return SingletonHelper.getInstance(RecentStateManager, TAG);
  }

  public get currentState(): RecentStates {
    return this.currentState_;
  }

  public set currentState(state: RecentStates) {
    this.currentState_ = state;
  }

  public onInit(): void {
    if (this.currentState_ === RecentStates.STATE_INIT) {
      return;
    }
    log.showInfo('onInit');
    this.currentState_ = RecentStates.STATE_INIT;
  }

  public onEnterFollowing(): void {
    if (this.currentState_ === RecentStates.STATE_ENTER_FOLLOWING) {
      return;
    }
    log.showInfo('onEnterFollowing');
    this.currentState_ = RecentStates.STATE_ENTER_FOLLOWING;
  }

  public onEnterAnimating(): void {
    if (this.currentState_ === RecentStates.STATE_ENTER_ANIMATING) {
      return;
    }
    log.showInfo('onEnterAnimating');
    this.currentState_ = RecentStates.STATE_ENTER_ANIMATING;
  }

  public onStable(): void {
    if (this.currentState_ === RecentStates.STATE_STABLE) {
      return;
    }
    log.showInfo('onStable');
    this.currentState_ = RecentStates.STATE_STABLE;
  }

  public onExitAnimating(): void {
    if (this.currentState_ === RecentStates.STATE_EXIT_ANIMATING) {
      return;
    }
    log.showInfo('onExitAnimating');
    this.currentState_ = RecentStates.STATE_EXIT_ANIMATING;
  }

  public onStartSceneAnimating(): void {
    if (this.currentState_ === RecentStates.STATE_START_SCENE_ANIMATING) {
      return;
    }
    log.showInfo('onStartSceneAnimating');
    this.currentState_ = RecentStates.STATE_START_SCENE_ANIMATING;
  }

  public isInitState(): boolean {
    return this.currentState_ === RecentStates.STATE_INIT;
  }

  public isEnterFollowingState(): boolean {
    return this.currentState_ === RecentStates.STATE_ENTER_FOLLOWING;
  }

  public isEnterAnimatingState(): boolean {
    return this.currentState_ === RecentStates.STATE_ENTER_ANIMATING;
  }

  public isStableState(): boolean {
    return this.currentState_ === RecentStates.STATE_STABLE;
  }

  public isExitAnimatingState(): boolean {
    return this.currentState_ === RecentStates.STATE_EXIT_ANIMATING;
  }

  public isStartSceneAnimatingState(): boolean {
    return this.currentState_ === RecentStates.STATE_START_SCENE_ANIMATING;
  }

  public isInRecentView(): boolean {
    return this.isEnterAnimatingState() || this.isStableState();
  }

  public isRecentState(): boolean {
    return this.isEnterFollowingState() || this.isEnterAnimatingState() || this.isStableState();
  }
}
export const recentStateManagerInstance = RecentStateManager.getInstance();