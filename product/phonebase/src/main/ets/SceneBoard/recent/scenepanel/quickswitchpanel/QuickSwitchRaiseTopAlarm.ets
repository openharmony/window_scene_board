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

import {
  SCBSceneContainerSession,
  SCBScenePanelManager,
} from '@ohos/windowscene';
import {
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { Alarm } from '@ohos/componenthelper';
const TAG = 'QuickSwitchRaiseTopAlarm';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class QuickSwitchRaiseTopAlarm {
  private readonly DELAY_TIME: number = 5000;
  private readonly panelManager: SCBScenePanelManager;
  private alarm: Alarm;
  private containerSessionToTop: SCBSceneContainerSession | null;

  constructor() {
    this.panelManager = SCBScenePanelManager.getInstance();
    this.containerSessionToTop = this.panelManager.getSceneContainerSessionList().getTopSession();
    this.alarm = new Alarm();
    this.alarm.setHandler({
      onAlarm: () => {
        this.onAlarm();
      }
    });
  }

  private onAlarm(): void {
    if (!this.containerSessionToTop) {
      return;
    }
    log.showInfo('do onAlarm container session name : ' + this.containerSessionToTop?.getName());
    let topSession = this.panelManager.getSceneContainerSessionList().getTopSession();
    if (topSession?.containerId === this.containerSessionToTop?.containerId) {
      log.showInfo('this container session is top already, do not need raise to top.');
      this.containerSessionToTop = null;
      return;
    }
    this.panelManager.raiseSceneToTop(this.containerSessionToTop);
    this.containerSessionToTop = null;
  }

  public static getInstance(): QuickSwitchRaiseTopAlarm {
    return SingletonHelper.getInstance(QuickSwitchRaiseTopAlarm, TAG);
  }

  public start(containerSessionToTop: SCBSceneContainerSession | null, reason?: string): void {
    log.showInfo(`start alarm from ${reason} container session name : ${containerSessionToTop?.getName()}`);
    this.containerSessionToTop = containerSessionToTop;
    this.alarm.setAlarm(this.DELAY_TIME);
    this.alarm.run();
  }

  public cancel(reason?: string): void {
    log.showInfo('cancel alarm, reason: ' + reason);
    this.containerSessionToTop = null;
    this.alarm.cancelAlarm();
  }

  public startImmediately(containerSessionToTop: SCBSceneContainerSession | null, reason?: string): void {
    log.showInfo(`do onAlarm immediately ${reason}, container session name: ${containerSessionToTop?.getName()}.`);
    this.containerSessionToTop = containerSessionToTop;
    this.alarm.cancelAlarm();
    this.onAlarm();
  }
}
