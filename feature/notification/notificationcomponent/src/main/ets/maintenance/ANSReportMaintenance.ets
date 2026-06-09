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
import { Singleton } from '@ohos/systemuicommon/src/main/ets/utils/Singleton';
import {
  MaintenanceRecordType,
  MaintenanceReportChannel } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { MaintenanceRecord } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceRecord';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ANSReportMaintenance');

/**
 * ANS通知运维打点
 */
export class ANSReportMaintenance extends MaintenanceRecord<Object> {
  @Singleton.decorate()
  public static get instance(): ANSReportMaintenance { return new ANSReportMaintenance(); }

  constructor() {
    super(MaintenanceRecordType.ANS_REPORT, [MaintenanceReportChannel.HA_ANS]);
  }

  protected isNeedReport(): boolean {
    log.showInfo('report ans, do not limit');
    return true;
  }

  protected isNeedQueue(): boolean {
    log.showInfo('report ans, not need queue');
    return false;
  }

  public doReport(info?: string): void {
    if (!info) {
      log.showWarn('info is empty, not doReport');
      return;
    }

    try {
      this.ext = JSON.parse(info);
      this.report();
    } catch (e) {
      log.error('info Error parsing JSON:', e);
    }
  }
}