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

import { vibrator } from '@kit.SensorServiceKit';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { LogWithHa, SystemUICommonUtil } from '@ohos/systemuicommon';
import { Singleton } from '@ohos/systemuicommon/newTsIndex';
import { taskpool } from '@kit.ArkTS';

const TAG = 'NotificationVibratorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export default class NotificationVibratorManager {
  @Singleton.decorate()
  public static get instance(): NotificationVibratorManager {
    return new NotificationVibratorManager();
  }

  // 是否正在振动
  private isVibrating: boolean = false;
  // 是否高优先级的在振动
  private isHighPriorityVibrating: boolean = false;
  // 振动文件
  private vibrateFile: string | undefined = undefined;

  private vibrateTask: taskpool.LongTask | undefined = undefined;

  private vibrateTimeOutId: number | undefined = undefined;

  public async startVibration(isWeak: boolean, highPriority: boolean): Promise<void> {
    // 触发马达振动
    const fileName = isWeak ? 'weakCustomVibration.json' : 'normalCustomVibration.json';
    log.showInfo(`start vibration, isWeak ${isWeak}, highPriority ${highPriority}`);
    try {
      // 高优先级正在振动时，低优先级不振动
      if (this.isVibrating && this.isHighPriorityVibrating && !highPriority) {
        log.showWarn(`current high priority vibrating, can not vibrate`);
        return;
      }
      await this.stop();
      // 获取文件资源描述符
      const rawFd: resourceManager.RawFileDescriptor =
        await GlobalContext.getContext()?.resourceManager?.getRawFd(fileName);
      this.vibrateFile = fileName;
      this.isHighPriorityVibrating = highPriority;
      this.vibrateTask = new taskpool.LongTask('longVibration', vibrate, highPriority, rawFd);
      // taskpool执行超时打点
      this.vibrateTimeOutId = setTimeout(() => {
        LogWithHa.error(log, `vibrate taskpool timeout`);
      }, 1000);
      const sendTaskTime = Date.now();
      this.vibrateTask.onStartExecution(() => {
        log.showInfo(`vibrate task start, cost ${Date.now() - sendTaskTime}`);
        if (this.vibrateTimeOutId !== undefined) {
          clearTimeout(this.vibrateTimeOutId);
        }
      });
      this.isVibrating = true;
      taskpool.execute(this.vibrateTask, taskpool.Priority.HIGH);
    } catch (e) {
      log.showError(`An unexpected  error occurred. Code: ${e.code}, message: ${e.message}`);
    }
  }

  private async closeFd(): Promise<void> {
    try {
      if (this.vibrateFile) {
        log.showInfo(`close fd ${this.vibrateFile}`);
        // 关闭文件资源描述符
        await GlobalContext.getContext()?.resourceManager?.closeRawFd(this.vibrateFile);
        this.vibrateFile = undefined;
      }
    } catch (e) {
      log.error('close vibrator raw fd error, ' + e);
    }
  }

  public async stopVibration(highPriority: boolean): Promise<void> {
    // 外部调用停止仅能停止同优先级的振动
    if (this.isHighPriorityVibrating !== highPriority) {
      log.showInfo(`can not stop other priority vibration, ${highPriority}`);
      return;
    }
    await this.stop();
  }

  private async stop(): Promise<void> {
    log.showWarn(`start stop vibrate, file ${this.vibrateFile}, isVibrating ${this.isVibrating}`);
    try {
      this.cancelVibrateTask();
      await this.closeFd();
      if (this.isVibrating) {
        // 停止所有模式的马达振动
        await vibrator.stopVibration();
        log.showInfo('Succeed in stopping vibration');
      }
    } catch (error) {
      const e: BusinessError = error as BusinessError;
      log.showError(`An unexpected error occurred. Code: ${e.code}, message: ${e.message}`);
    } finally {
      this.isVibrating = false;
    }
  }

  private cancelVibrateTask(): void {
    try {
      if (!this.vibrateTask) {
        return;
      }
      log.showInfo(`cancel and terminate vibrate task`);
      taskpool.cancel(this.vibrateTask);
      taskpool.terminateTask(this.vibrateTask);
      this.vibrateTask = undefined;
    } catch (e) {
      log.showError(`Cancel task exception. Code: ${e.code}, message: ${e.message}`);
    }
  }
}

async function vibrate(highPriority: boolean, rawFd: resourceManager.RawFileDescriptor): Promise<void> {
  'use concurrent';
  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'NotificationVibratorManagerTask');
  // 起振间隔时间
  const interval = 800;
  // 最长振动时间
  const maxTime = 60000;
  log.showInfo(`start vibrate, priority ${highPriority}`);
  const startTime = Date.now();
  while (Date.now() - startTime < maxTime) {
    if (taskpool.LongTask.isCanceled()) {
      log.showInfo(`vibrate is canceled`);
      break;
    }
    try {
      await vibrator.startVibration({
        type: 'file',
        hapticFd: {
          fd: rawFd.fd,
          offset: rawFd.offset,
          length: rawFd.length
        }
      }, {
        id: 0,
        usage: highPriority ? 'ring' : 'notification',
      });
      log.showInfo('Succeed in starting vibration');
    } catch (err) {
      const e: BusinessError = err as BusinessError;
      log.showError(`An unexpected  error occurred. Code: ${e.code}, message: ${e.message}`);
    }
    await SystemUICommonUtil.sleep(interval);
  }
  log.showInfo(`vibrate finish, time ${Date.now() - startTime}`);
}
