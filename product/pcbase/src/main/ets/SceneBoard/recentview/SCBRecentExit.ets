/**
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
import { SCBScreenProperty } from '@ohos/windowscene';
import { ApsUtils } from '@ohos/frameworkwrapper';
import { StyleConstants } from '@ohos/launchercommon';
import { recentStateManager, SCBRecentStateEvents, SCBRecentStateCallbackArgsType } from './SCBRecentState';

const TAG = 'SCBRecentExit';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class SCBRecentExit {
  private screenProperty: SCBScreenProperty;
  private groupAnimationRef: number = 0;

  constructor(screenProperty: SCBScreenProperty) {
    this.screenProperty = screenProperty;
    this.registerRecentExitAllAnimateStartEventCallback();
    this.registerRecentExitAllAnimateFinishEventCallback();
  }

  public groupAnimationRefInit(): void {
    this.groupAnimationRef = 0;
    log.showInfo('group animation ref init');
  }

  public groupAnimationRefZero(): boolean {
    return (this.groupAnimationRef === 0);
  }

  public groupAnimationRefAdd(): void {
    this.groupAnimationRef++;
    log.showInfo(`group animation ref add: ${this.groupAnimationRef}`);
  }

  public groupAnimationRefDec(): void {
    this.groupAnimationRef--;
    log.showInfo(`group animation ref decrease: ${this.groupAnimationRef}`);
  }

  private registerRecentExitAllAnimateStartEventCallback(): void {
    let instance = recentStateManager.getRecentStateInstance(this.screenProperty.screenId);
    let event = SCBRecentStateEvents.EVENT_EXIT_RECENT_ALL_ANIMATE_START;
    instance.registerRecentCallback(event,
      {
        name: TAG + event,
        func: (...args: SCBRecentStateCallbackArgsType[]) => {
          this.enableApsForExitRecent();
          return true;
        }
      });
  }

  private registerRecentExitAllAnimateFinishEventCallback(): void {
    let instance = recentStateManager.getRecentStateInstance(this.screenProperty.screenId);
    let event = SCBRecentStateEvents.EVENT_EXIT_RECENT_ALL_ANIMATE_FINISH;
    instance.registerRecentCallback(event,
      {
        name: TAG + event,
        func: (...args: SCBRecentStateCallbackArgsType[]) => {
          this.disableApsForExitRecent();
          return true;
        }
      });
  }

  private isInSplit(): boolean {
    return recentStateManager.getRecentStateInstance(this.screenProperty.screenId).isInSplit;
  }

  private enableApsForExitRecent(): void {
    if (this.isInSplit()) {
      return;
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.EXIT_RECENTVIEW, StyleConstants.DEFAULT_1);
  }

  public disableApsForExitRecent(): void {
    if (this.isInSplit()) {
      return;
    }
    // ApsUtils.setApsScene(apsManager.SceneAnimation.EXIT_RECENTVIEW, StyleConstants.DEFAULT_2);
  }
}