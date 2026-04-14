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

import WorkSchedulerExtensionAbility from '@ohos.WorkSchedulerExtensionAbility';
import workScheduler from '@ohos.resourceschedule.workScheduler';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { WorkSchedulerManager, CUSTOM_EVENT_WEEK_SCHEDULER_REPORTER } from '@ohos/frameworkwrapper';
import commonEventManager from '@ohos.commonEventManager';
import Base from '@ohos.base';

const TAG = 'ReportWorkSchedulerExtensionAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 *
 * 桌面日报的周期上报
 *
 * @since 2023-12-27
 */
export default class ReportWorkSchedulerExtensionAbility extends WorkSchedulerExtensionAbility {
  private static readonly DAY_OF_WEEK: number = 7;
  private static readonly HOUR_OF_DAY: number = 24;
  private static readonly MINUTE_OF_HOUR: number = 60;
  private static readonly SECOND_OF_MINUTE: number = 60;
  private static readonly MILL_OF_SECOND: number = 100;
  private static readonly MILL_OF_WEEK: number = 604800000;
  private static readonly BUNDLE_NAME: string = 'com.ohos.sceneboard';
  private static readonly WORK_ID: number = 100001;


  constructor() {
    log.showInfo(` constructor `);
    super();
  }
  // 延迟任务开始回调
  onWorkStart(workInfo: workScheduler.WorkInfo) {
    console.info(` onWorkStart `);
    try {
      // 发布公共事件
      commonEventManager.publish(CUSTOM_EVENT_WEEK_SCHEDULER_REPORTER, (err: Base.BusinessError) => {
        if (err) {
          log.error(`CUSTOM_EVENT_WEEK_SCHEDULER_REPORTER PublishCallBack  code is ${err.code} message is ${err.message}`);
        } else {
          log.info(`CUSTOM_EVENT_WEEK_SCHEDULER_REPORTER Publish success`);
        }
      });
    } catch (error) {
      log.error('commonEventManager publish error %{public}s', error?.message);
    }

  }

  // 延迟任务结束回调
  onWorkStop(workInfo: workScheduler.WorkInfo) {
    log.info(` onWorkStop workid ${workInfo.workId}`);
  }

  public static getWorkInfo(): workScheduler.WorkInfo {
    let cycleDuration: number = ReportWorkSchedulerExtensionAbility.MILL_OF_WEEK;
    const workInfo: workScheduler.WorkInfo = {
      workId: ReportWorkSchedulerExtensionAbility.WORK_ID,
      isPersisted: true,
      isRepeat: true,
      repeatCycleTime: cycleDuration,
      bundleName: ReportWorkSchedulerExtensionAbility.BUNDLE_NAME,
      abilityName: TAG,
      isDeepIdle: true
    }
    return workInfo;
  }
}

