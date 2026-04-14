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

import { LogDomain, LogHelper, SingletonHelper, } from '@ohos/basicutils';
import { commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'SysUI_NotificationUnifiedReportManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const UNIFIED_REPORT_EVENT = 'sceneboard.event.PUSH_AGENT';
const UNIFIED_REPORT_PERMISSION = 'ohos.permission.NOTIFICATION_AGENT_CONTROLLER';

class NotificationUnifiedReportManager {
  private reportUnified(type: ReportType, data: object): void {
    let option: commonEventManager.CommonEventPublishData = {
      code: 0,
      subscriberPermissions: [UNIFIED_REPORT_PERMISSION],
      parameters: data
    };
    try {
      commonEventManager.publish(UNIFIED_REPORT_EVENT, option, () => {
        log.showInfo(`publish success, type : ${type}`);
      });
    } catch (error) {
      log.error(`commonEventManager.publish fail error: ${error}`);
    }
  }

  reportShowUnified(key: string, infos: ReportExt[]): void {
    log.showInfo(`reportShowUnified, ${key}`);
    let data: ReportInfo = {
      operationType: ReportType.SHOW_UNIFIED,
      groupKey: key,
      ext: JSON.stringify(infos)
    };
    this.reportUnified(ReportType.SHOW_UNIFIED, data);
  }

  reportExpandUnified(key: string): void {
    log.showInfo(`reportExpandUnified, ${key}`);
    let data: ReportInfo = {
      operationType: ReportType.EXPAND_UNIFIED,
      groupKey: key
    };
    this.reportUnified(ReportType.EXPAND_UNIFIED, data);
  }

  reportCollapseUnified(key: string): void {
    log.showInfo(`reportCollapseUnified, ${key}`);
    let data: ReportInfo = {
      operationType: ReportType.COLLAPSE_UNIFIED,
      groupKey: key
    };
    this.reportUnified(ReportType.COLLAPSE_UNIFIED, data);
  }

  reportManualDeleteUnified(key: string): void {
    log.showInfo(`reportManualDeleteUnified, ${key}`);
    let data: ReportInfo = {
      operationType: ReportType.MANUAL_DELETE_UNIFIED,
      groupKey: key
    };
    this.reportUnified(ReportType.MANUAL_DELETE_UNIFIED, data);
  }

  reportAllClearUnified(key: string): void {
    log.showInfo(`reportAllClearUnified, ${key}`);
    let data: ReportInfo = {
      operationType: ReportType.ALL_CLEAR_UNIFIED,
      groupKey: key
    };
    this.reportUnified(ReportType.ALL_CLEAR_UNIFIED, data);
  }

  reportClickInUnified(key: string, infos: ReportExt[]): void {
    log.showInfo(`reportClickInUnified, ${key}`);
    let data: ReportInfo = {
      operationType: ReportType.CLICK_NTF_IN_UNIFIED,
      groupKey: key,
      ext: JSON.stringify(infos)
    };
    this.reportUnified(ReportType.CLICK_NTF_IN_UNIFIED, data);
  }

  reportDeleteInUnified(key: string, infos: ReportExt[]): void {
    log.showInfo(`reportDeleteInUnified, ${key}`);
    let data: ReportInfo = {
      operationType: ReportType.DELETE_NTF_IN_UNIFIED,
      groupKey: key,
      ext: JSON.stringify(infos)
    };
    this.reportUnified(ReportType.DELETE_NTF_IN_UNIFIED, data);
  }
}

export enum ReportType {
  SHOW_UNIFIED = 0,
  EXPAND_UNIFIED = 1,
  COLLAPSE_UNIFIED = 2,
  MANUAL_DELETE_UNIFIED = 3,
  ALL_CLEAR_UNIFIED = 4,
  CLICK_NTF_IN_UNIFIED = 5,
  DELETE_NTF_IN_UNIFIED = 6
}

export class ReportExt {
  public hashcode: string = '';
  public bundleName: string = '';
}

export class ReportInfo {
  public operationType: number = -1;
  public groupKey: string = '';
  public ext?: string;
}

export let ntfUnifiedReportMgr: NotificationUnifiedReportManager =
  SingletonHelper.getInstance(NotificationUnifiedReportManager, TAG);