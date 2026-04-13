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

import { LogDomain, Logger } from '@ohos/basicutils';
import { MaintenanceRecordType } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import {
  FreqLimitMaintenance,
  LimitMaintenanceExt
} from '@ohos/systemuiutils/src/main/ets/maintenance/FreqLimitMaintenance';
const TAG = 'StatusBarMaintenance';
const log = Logger.getLogHelper(LogDomain.SYS_UI);

/** 状态栏打点参数 -- 上报时会映射为云端固定字段 */
interface StatusBarMaintenanceExt extends LimitMaintenanceExt {
  areaStr?: string;
  avoidHeight?: number;
  cutoutInfo?: string;
}

/** 状态栏运维打点类 */
export class StatusBarMaintenance extends FreqLimitMaintenance<StatusBarMaintenanceExt> {
  constructor() {
    super(MaintenanceRecordType.STATUS_BAR);
  }

  /**
   * 默认异常打点
   * @param errorCode 异常Code
   * @param info 打点信息
   */
  public reportStatusBarInfo(errorCode?: number, info?: StatusBarMaintenanceExt): void {
    try {
      this.ext = info ?? {};
      if (errorCode) {
        this.addErrorCode(errorCode);
      }
      this.report();
    } catch (e) {
      log.error(TAG, 'report default error, ' + e);
    }
  }
}