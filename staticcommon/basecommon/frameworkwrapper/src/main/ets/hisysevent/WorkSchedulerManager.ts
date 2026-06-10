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

import workScheduler from '@ohos.resourceschedule.workScheduler';
import type { BusinessError } from '@ohos.base';
import ArrayList from '@ohos.util.ArrayList';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';

const TAG = 'WorkSchedulerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面工作调度管理
 */
export class WorkSchedulerManager {
  private static instance: WorkSchedulerManager | undefined = undefined;

  private reportList: ArrayList<()=> void> = new ArrayList();

  private constructor() {
    log.showInfo('constructor');
  }

  public async registerReport(report: ()=> void): Promise<void> {
    if (CheckEmptyUtils.isEmpty(report)) {
      return;
    }
    if (!this.reportList.has(report)) {
      this.reportList.add(report);
    }
  }

  public async unRegisterReport(report: ()=> void): Promise<void> {
    if (CheckEmptyUtils.isEmpty(report)) {
      return;
    }
    if (this.reportList.has(report)) {
      this.reportList.remove(report);
    }
  }

  public executeReport(): void {
    this.reportList.forEach((report) => {
      if (!CheckEmptyUtils.isEmpty(report)) {
        report();
      }
    });
  }

  public static async registerDelayTask(workInfo: workScheduler.WorkInfo): Promise<void> {
    try {
      workScheduler.startWork(workInfo);
      log.info(' startWork success ');
    } catch (error) {
      log.error(`startWork failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  public static async unRegisterDelayTask(workInfo: workScheduler.WorkInfo): Promise<void> {
    try {
      workScheduler.stopWork(workInfo);
      log.info(' stop success ');
    } catch (error) {
      log.error(`stop failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  static getInstance(): WorkSchedulerManager {
    if (!WorkSchedulerManager.instance) {
      WorkSchedulerManager.instance = new WorkSchedulerManager();
    }
    return WorkSchedulerManager.instance;
  }
}