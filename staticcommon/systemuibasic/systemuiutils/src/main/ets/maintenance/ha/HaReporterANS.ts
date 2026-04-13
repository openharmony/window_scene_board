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
import { HaReportBase, REPORT_TYPE } from './HaReportBase';
import { MaintenanceReportInfo } from '../MaintenanceModel';
import { HaReporter } from './HaReporter';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ANSHaReporter');

const EVENT_NAME = 'ANS_NOTIFICATION_REPORT';

/**
 * HA打点上报处理（信息源：ANS）
 */
export class HaReporterANS extends HaReporter {
  public async report(reportInfo: MaintenanceReportInfo[]): Promise<void> {
    reportInfo.forEach((info) => this.addHaInfo(info.operationType, this.convertInfo(info)));
    this.reportInfoMap.forEach((infos, type) => {
      if (!infos.length) {
        return;
      }
      log.showInfo(`start report event (${type}), size ${infos.length}`);

      infos.forEach((info) =>
        HaReportBase.get().reportHa(EVENT_NAME, [REPORT_TYPE.MAINTENANCE], info)
      );
    });
  }

  /**
   * 转换到HA上报字段
   * @param reportInfo 上报信息
   * @returns
   */
  convertInfo(reportInfo: MaintenanceReportInfo): Record<string, string> {
    const haInfo: Record<string, string> = {};
    if (!reportInfo.ext) {
      return haInfo;
    }
    for (const key of Object.keys(reportInfo.ext)) {
      Reflect.set(haInfo, key, this.convertToString(Reflect.get(reportInfo.ext, key)));
    }
    return haInfo;
  }
}