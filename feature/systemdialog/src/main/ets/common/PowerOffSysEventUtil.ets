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
import { HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper';
import { ReportParams } from '../common/Constants';

const TAG = 'PowerOffSysEventUtil';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

/**
 * 关机界面打点上报工具类
 */
export class PowerOffSysEventUtil {
  private static readonly TURNONANDOFF_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.TURNONANDOFF_UE);

  // 开关机_关机界面_进入关机界面_确认关机_确认重启_退出关机界面
  public static readonly SHUTDOWN_PANEL: string = 'SHUTDOWN_PANEL';
  private static reportOnceMap: Map<string, boolean> = new Map();

  static reportPowerOffEvent(eventName: string, state: number): void {
    log.showInfo(TAG, `report power off ${eventName} ${state}`);
    try {
      PowerOffSysEventUtil.reportOnce(eventName, state);
    } catch (err) {
      log.error(TAG, `report power off err ${eventName}`, err);
    }
  }

  static reportOnce(eventName: string, state: number): void {
    let key = `${eventName}_${state}`;
    if (PowerOffSysEventUtil.reportOnceMap.has(key)) {
      return;
    }
    let params: PowerOffReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      STATE: state
    };
    PowerOffSysEventUtil.TURNONANDOFF_UE.reportBehavior(eventName, params);
    PowerOffSysEventUtil.reportOnceMap.set(key, true);
  }

}

export interface PowerOffReportParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  STATE?: number;
}

export enum ShutdownPanelState {
  ENTER_SHUTDOWN_PANEL = 0,
  SHUTDOWN_CONFIRM = 1,
  SHUTDOWN_REBOOT_CONFIRM = 2,
  SHUTDOWN_CANCEL = 3,
  SHUTDOWN_CLOSE_OFF_FIND = 4,
  SHUTDOWN_USER_AUTH = 5,
}