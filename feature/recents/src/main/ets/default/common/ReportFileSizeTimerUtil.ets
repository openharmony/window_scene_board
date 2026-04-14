/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import systemTimer from '@ohos.systemTimer';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { EventManager, HiSysEventUtil, EvtBus, ScreenLockEvent} from '@ohos/frameworkwrapper';
import FileUtils from '@ohos/basicutils/src/main/ets/utils/FileUtils';

const TAG = 'ReportFileSizeTimerUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const TRIGGER_TIME: number = 1000 * 60 * 5;
const REPORT_DURATION: number = 1000 * 60 * 60 * 24;

export class ReportFileSizeTimerUtil {
  private static timerId: number = -1;
  private static filePath: string[] =
    ['/data/storage/el1/base', '/data/storage/el1/database', '/data/storage/el2/base', '/data/storage/el2/database'];
  private static eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 定时器的初始化
   */
  public static async setTimer(): Promise<void> {
    try {
      if (ReportFileSizeTimerUtil.timerId !== -1) {
        log.showWarn(`timer is exist, triggerTime: ${ReportFileSizeTimerUtil.timerId}`);
        return;
      }
      log.showWarn(`start triggerTime.`);
      let timerName = 'sceneBoardTimer';
      ReportFileSizeTimerUtil.timerId =
        await systemTimer.createTimer(ReportFileSizeTimerUtil.createUpdateTimerOpts(timerName));
      await systemTimer.startTimer(ReportFileSizeTimerUtil.timerId, TRIGGER_TIME);
      log.showInfo(`Set timer success, timerName: ${timerName}`);
    } catch (e) {
      log.error(`Set timer failed, triggerTime, error:`, e);
    }
  }

  /**
   * 定时器配置，时间到时采用报点
   * @param { string } timerName 定时器的名称
   * @returns { systemTimer.TimerOptions } 定时器参数
   */
  private static createUpdateTimerOpts(timerName: string): systemTimer.TimerOptions {
    return {
      // 使用简单定时器；
      type: systemTimer.TIMER_TYPE_REALTIME,
      repeat: true,
      interval: REPORT_DURATION,
      callback: () => {
        ReportFileSizeTimerUtil.eventMgr.on(ScreenLockEvent,
          (event: ScreenLockEvent) => ReportFileSizeTimerUtil.reportFileSize(event));
      },
      name: timerName,
    }
  }

  /**
   * 销毁定时器
   */
  public static async cancelTimer(): Promise<void> {
    if (ReportFileSizeTimerUtil.timerId === -1) {
      log.showError(`timer id -1.`);
      return;
    }
    try {
      // 停止定时器
      await systemTimer.stopTimer(ReportFileSizeTimerUtil.timerId);
      await systemTimer.destroyTimer(ReportFileSizeTimerUtil.timerId);
      clearTimeout(ReportFileSizeTimerUtil.timerId);
      ReportFileSizeTimerUtil.timerId = -1;
      log.showInfo(`Cancel timer success, type: ${ReportFileSizeTimerUtil.timerId}`);
    } catch (e) {
      log.error(`Cancel timer failed, id: ${ReportFileSizeTimerUtil.timerId}, error:`, e);
    }
  }

  /**
   * 获取文件大小并上报，如果手机未解锁，el2的文件无法读取，所以在解锁状态下报点，未解锁状态下顺延到下一个报点
   * @param { ScreenLockEvent } event 监听手机是否解锁
   * @throws { Error } - null context error
   */
  public static async reportFileSize(event: ScreenLockEvent): Promise<void> {
    if (!event || event.isLockScreen) {
      log.showError(`event is null or locked.`);
      return;
    }
    try {
      log.info(`start report size.`);
      let fileSize: number[] = [];
      TraceUtil.startTrace(DomainName.SCB, TraceUtil.GET_FILE_SIZE);
      for (let file of ReportFileSizeTimerUtil.filePath) {
        fileSize.push(await FileUtils.getFileSize(file));
      }
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.GET_FILE_SIZE);
      log.info(`getTotalSizeSync succeed.`);
      HiSysEventUtil.reportFileSize(ReportFileSizeTimerUtil.filePath, fileSize);
    } catch (error) {
      log.info(TAG, 'getTotalSizeSync failed,' + error);
    }
  }
}