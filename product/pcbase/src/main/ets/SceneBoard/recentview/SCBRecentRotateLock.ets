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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { recentStateManager, SCBRecentStateCallback, SCBRecentStateEvents } from './SCBRecentState';
import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';

const TAG = 'SCBRecentRotateLock';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentRotateLock {
  private screenID: number;

  private lockRotateCallback: SCBRecentStateCallback = {
    name: 'lockScreenRotate',
    func: () => {
      this.lockScreenRotate();
      return true;
    }
  }

  private unlockRotateCallback: SCBRecentStateCallback = {
    name: 'unlockScreenRotate',
    func: () => {
      this.unlockScreenRotate();
      return true;
    }
  }

  constructor(screenID: number) {
    this.screenID = screenID;
  }

  public enableRotateLock(reason: string): void {
    log.showInfo(`enableRotateLock, reason:${reason}`);
    this.registerEnterRecentStartEvent();
    this.registerExitRecentAnimationFinishEvent();
    const recentState = recentStateManager.getRecentStateInstance(this.screenID);
    if (recentState.isInRecent()) {
      this.lockScreenRotate();
    }
  }

  public disableRotateLock(reason: string): void {
    log.showInfo(`disableRotateLock, reason:${reason}`);
    this.unregisterEnterRecentStartEvent();
    this.unregisterExitRecentAnimationFinishEvent();
    this.unlockScreenRotate();
  }

  private lockScreenRotate(): void {
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenID);
    if (!screenSession) {
      log.showWarn('lockScreenRotate, screenSession is null');
      return;
    }
    screenSession.setEnableRotate(false, SCBRecentStyleConstants.RECENT_LOCK_SCREEN_ROTATE);
  }

  private unlockScreenRotate(): void {
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenID);
    if (!screenSession) {
      log.showWarn('unlockScreenRotate, screenSession is null');
      return;
    }
    screenSession.setEnableRotate(true, SCBRecentStyleConstants.RECENT_LOCK_SCREEN_ROTATE);
    screenSession.rotationChangeEntry(screenSession.sensorScreenProperty.rotation,
      SCBRecentStyleConstants.RECENT_LOCK_SCREEN_ROTATE);
  }

  private registerEnterRecentStartEvent(): void {
    const recentState = recentStateManager.getRecentStateInstance(this.screenID);
    recentState.registerRecentCallback(SCBRecentStateEvents.EVENT_ENTER_RECENT_START, this.lockRotateCallback);
  }

  private unregisterEnterRecentStartEvent(): void {
    const recentState = recentStateManager.getRecentStateInstance(this.screenID);
    recentState.unregisterRecentCallback(SCBRecentStateEvents.EVENT_ENTER_RECENT_START, this.lockRotateCallback);
  }

  private registerExitRecentAnimationFinishEvent(): void {
    const recentState = recentStateManager.getRecentStateInstance(this.screenID);
    recentState.registerRecentCallback(SCBRecentStateEvents.EVENT_EXIT_RECENT_ALL_ANIMATE_FINISH,
      this.unlockRotateCallback);
  }

  private unregisterExitRecentAnimationFinishEvent(): void {
    const recentState = recentStateManager.getRecentStateInstance(this.screenID);
    recentState.unregisterRecentCallback(SCBRecentStateEvents.EVENT_EXIT_RECENT_ALL_ANIMATE_FINISH,
      this.unlockRotateCallback);
  }
}