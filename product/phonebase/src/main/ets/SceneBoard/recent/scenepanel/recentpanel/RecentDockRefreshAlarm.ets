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

import { SCBSceneContainerSession, ScenePanelState } from '@ohos/windowscene';
import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { Alarm } from '@ohos/componenthelper';
import RecentDockModel from '@ohos/smartdock/src/main/ets/default/model/RecentDockModel';

const TAG = 'RecentDockRefreshAlarm';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentDockRefreshAlarm {
  private readonly DELAY_TIME_IN_RECENT: number = 600;
  private readonly DELAY_TIME_NOT_IN_RECENT: number = 100;
  private alarm: Alarm;
  private containerSession: SCBSceneContainerSession | null = null;

  constructor() {
    this.alarm = new Alarm();
    this.alarm.setHandler({
      onAlarm: () => {
        this.onAlarm();
      }
    });
  }

  /**
   * 刷新最近任务区
   * @param containerSession
   */
  public start(containerSession: SCBSceneContainerSession, scenePanelState: ScenePanelState): void {
    if (!containerSession) {
      log.showWarn('fail reason is null')
      return;
    }
    if (CommonUtils.equals(this.containerSession?.containerId, containerSession?.containerId)) {
      log.showWarn('fail reason is same')
      return;
    }
    this.containerSession = containerSession;
    log.showInfo('start alarm recent dock: ' + this.containerSession?.getName());
    if (scenePanelState === ScenePanelState.RECENT) {
      this.alarm.setAlarm(this.DELAY_TIME_IN_RECENT);
    } else {
      this.alarm.setAlarm(this.DELAY_TIME_NOT_IN_RECENT);
    }
    this.alarm.run();
  }

  /**
   * 执行刷新最近任务区
   */
  public onAlarm(): void {
    if (!this.containerSession) {
      return;
    }
    try {
      this.notifyRecentAndGestureDock(this.containerSession);
    } catch (e) {
      log.showError(`refresh recent dock error, code: ${e?.code}, msg: ${e?.message}`);
    }
    log.showInfo('refresh recent dock: ' + this.containerSession?.getName());
    this.alarm.cancelAlarm();
    this.containerSession = null;
  }

  /**
   * 获取实例
   * @returns
   */
  public static getInstance(): RecentDockRefreshAlarm {
    return SingletonHelper.getInstance(RecentDockRefreshAlarm, TAG);
  }

  private notifyRecentAndGestureDock(containerSession: SCBSceneContainerSession): void {
    if (!containerSession) {
      log.showInfo('container is invalid, no need to add to recentDockList');
      return;
    }
    if (containerSession.isSplit || containerSession.isMidScene) {
      log.showInfo('container is split or midScene, no need to add to recentDockList');
      return;
    }
    RecentDockModel.getInstance().addToRecentDockList(containerSession.primarySession?.sceneInfo.bundleName,
      containerSession.primarySession?.sceneInfo.appIndex);
  }
}
