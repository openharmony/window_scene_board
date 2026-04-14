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

import { HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper';
import { LogDomain, Logger } from '@ohos/basicutils';
import { ISystemDialogData } from './DialogDataEvent';
import { ReportParams } from '../common/Constants';

const TAG = 'DialogSysEventUtil';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

/**
 * 弹窗打点上报工具类
 */
export class SystemDialogEventUtil {
  private static readonly NOTIFICATION_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.NOTIFICATION_UE);

  public static readonly EVENT_NAME: string = 'SYSTEMDIALOG_CALL_RECORD';

  static reportSystemDialogEvent(name: string, item: ISystemDialogData, state: number): void {
    const connectId = item.connectId;
    const want = item.want;
    log.showInfo(TAG, `report systemDdialog ${name} ${connectId}`);
    try {
      let params: SystemDialogReportParams = {
        PNAMEID: ReportParams.PACKAGE_NAME,
        PVERSIONID: ReportParams.PROCESS_NAME,
        CONNECT_ID: connectId,
        BUNDLE_NAME: want?.bundleName ?? '',
        ABILITY_NAME: want?.abilityName ?? '',
        STATE: state,
      };
      SystemDialogEventUtil.NOTIFICATION_UE.reportBehavior(name, params);
    } catch (err) {
      log.error(TAG, `report systemDdialog err ${name}`, err);
    }
  }
}

interface SystemDialogReportParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  CONNECT_ID?: string;
  BUNDLE_NAME?: string;
  ABILITY_NAME?: string;
  STATE?: number;
}

export enum SystemDialogState {
  OPEN = 0,
  CLOSE = 1,
  CLOSE_TIMEOUT = 2,
  ERROR = 3,
  GESTURE = 4,
  DISABLE_UP_GESTURE = 5,
  DISABLE_FOCUS = 6,
  ENABLE_FOCUS = 7,
}