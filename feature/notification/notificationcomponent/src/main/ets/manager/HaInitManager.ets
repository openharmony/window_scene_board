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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  CommonEventListener,
  CommonEventSubscribeManager } from '@ohos/systemuicommon/src/main/ets/manager/CommonEventSubscribeManager';
import { Singleton } from '@ohos/systemuicommon/src/main/ets/utils/Singleton';
import CommonEventManager from '@ohos.commonEventManager';
import { HaReportBase } from '@ohos/systemuiutils/src/main/ets/maintenance/ha/HaReportBase';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { CommonExceptionMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { MainExceptionReporter } from '@ohos/systemuicommon/src/main/ets/maintenance/MainExceptionReporter';

const TAG = 'HaInitManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * HA初始化
 */
export class HaInitManager {
  @Singleton.decorate()
  public static get instance(): HaInitManager { return new HaInitManager(); }

  public async init(): Promise<void> {
    CommonExceptionMaintenance.get().init(new MainExceptionReporter());
    await HaReportBase.get().init(true);
    CommonEventSubscribeManager.getInstance().subscribe(CommonEventSubscribeManager.PUSH_AGENT_EVENT,
      this.updateHaConfig);
    StatisticsMaintenance.get().setVersion(SystemUICcmConfig.instance.isEnabledLive2);
  }

  private updateHaConfig: CommonEventListener = async (data: CommonEventManager.CommonEventData): Promise<void> => {
    await HaReportBase.get().urlUpdateProcess(data);
  };
}