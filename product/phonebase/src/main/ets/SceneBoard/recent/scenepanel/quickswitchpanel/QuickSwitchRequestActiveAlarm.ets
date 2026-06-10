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

import { SCBSceneContainerSession, SCBSceneContainerSessionArray } from '@ohos/windowscene';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { Alarm } from '@ohos/componenthelper';

const TAG = 'QuickSwitchRequestActiveAlarm';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class QuickSwitchRequestActiveAlarm {
  private readonly DELAY_TIME: number = 700;
  private alarm: Alarm;
  private toContainerSession: SCBSceneContainerSession | null = null;

  constructor() {
    this.alarm = new Alarm();
    this.alarm.setHandler({
      onAlarm: () => {
        this.onAlarm();
      }
    });
  }

  /**
   * 判断是否和toContainerSession为同一个session
   *
   * @param 需要判断的session
   * @returns true表示为同一session
   */
  public isSameContainerSession(containerSession: SCBSceneContainerSession): boolean {
    if (!this.toContainerSession || !containerSession) {
      return false;
    }
    return this.toContainerSession.containerId === containerSession.containerId;
  }

  /**
   * 执行alarm拉起应用
   */
  public onAlarm(): void {
    if (!this.toContainerSession) {
      return;
    }
    this.toContainerSession?.notifyForegroundInteractiveStatus(true);
    this.toContainerSession.requestActivation(false);
    this.toContainerSession.updateSessionIsNewWant(true, TAG);
    log.showInfo('start request onAlarm name: ' + this.toContainerSession?.getName());
    this.alarm.cancelAlarm();
    this.restore();
  }

  /**
   * 获取实例
   * @returns
   */
  public static getInstance(): QuickSwitchRequestActiveAlarm {
    return SingletonHelper.getInstance(QuickSwitchRequestActiveAlarm, TAG);
  }

  /**
   * 启动延时拉起应用的任务
   * @param toContainerSession
   */
  public start(toContainerSession: SCBSceneContainerSession): void {
    if (!toContainerSession) {
      log.showWarn('start quick switch fail reason is null')
      return;
    }
    log.showInfo('start request active alarm name: ' + toContainerSession?.getName());
    this.toContainerSession = toContainerSession;
    this.onAlarm();
  }

  /**
   * 取消拉起应用的任务
   */
  public cancel(needRestore: boolean = true): void {
    log.showInfo(`cancel request active alarm, name:${this.toContainerSession?.getName()} needRestore:${needRestore}`);
    this.alarm.cancelAlarm();
    if (needRestore) {
      this.restore();
    }
  }

  /**
   * 获取待拉起的containerSession
   */
  public getToContainerSession(): SCBSceneContainerSession | null {
    return this.toContainerSession;
  }

  /**
   * Get Top Active Sessions Index
   *
   * @returns { number } Returns the top active session index, or -1 if there is no active session.
   */
  public getCurrentSessionIndex(containerSessionList: SCBSceneContainerSessionArray): number {
    if (!this.toContainerSession) {
      return -1;
    }
    return containerSessionList.findIndexByContainerId(this.toContainerSession?.containerId);
  }

  private restore(): void {
    this.toContainerSession = null;
  }
}

export const quickSwitchRequestActiveAlarm = QuickSwitchRequestActiveAlarm.getInstance();