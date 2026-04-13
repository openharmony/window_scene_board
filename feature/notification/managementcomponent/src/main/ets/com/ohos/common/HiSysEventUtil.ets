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

import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper, TaskpoolUtil } from './BasicCommon';
import { ReportParams, } from './ReportParams';

const TAG = 'HiSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const BI_KEY_LENGTH_MAX: number = 32;

/**
 * 大数据用户行为相关打点工具类
 */
export class HiSysEventUtil {
  public static TOUCH_EVENT = 'touch';
  public static MOUSE_EVENT = 'mouse';
  public static SHORTCUT_EVENT = 'shortcut';
  public static CLICK_MORE: number = -1;
  public static CHANGE_VOLUME: number = -2;
  private static instance: HiSysEventUtil;
  // User behavior events use this domain
  private static SCENE_BOARD_UE_DOMAIN: string = 'SCENE_BOARD_UE';

  public static systemUIName: string = 'STACK';
  public static OPERATE_TYPE_DEFAULT = 1;
  public static OPERATE_TYPE_CLICK = 2;

  protected constructor() {
  }

  /**
   * Get single instance.
   */
  static getInstance(): HiSysEventUtil {
    if (HiSysEventUtil.instance == null) {
      HiSysEventUtil.instance = new HiSysEventUtil();
    }
    return HiSysEventUtil.instance;
  }

  static reportEvent(name: string, msg?: Object, type?: hiSysEvent.EventType, domain?: string): void {
    if (msg === undefined || msg === null) {
      msg = {
        PACKAGE_NAME: ReportParams.PACKAGE_NAME,
        PROCESS_NAME: ReportParams.PROCESS_NAME
      } as ReportMsg;
    }
    if (!name || name.length > BI_KEY_LENGTH_MAX) {
      // 打点key长度不能超过32
      log.error(`name =  ${name} is error`);
      return;
    }
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: domain === undefined ? HiSysEventUtil.SCENE_BOARD_UE_DOMAIN : domain,
      name: name,
      eventType: type === undefined ? hiSysEvent.EventType.BEHAVIOR : type,
      params: msg
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);

  }

  /**
   * 打点基础接口
   *
   * @deprecated
   * @useinstead HiSysReportEvent#reportFault/reportStatistic/reportSecurity/reportBehavior
   * @param domain 事件领域
   * @param name 事件名称
   * @param eventType 事件类型
   * @param params 事件参数
   */
  static report(domain: string, name: string, eventType: hiSysEvent.EventType, params: Object): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: domain,
      name: name,
      eventType: eventType,
      params: params
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }

  /**
   * 批量打点基础接口
   *
   * @deprecated
   * @useinstead HiSysReportEvent#reportFault/reportStatistic/reportSecurity/reportBehavior
   * @param domain 事件领域
   * @param name 事件名称
   * @param eventType 事件类型
   * @param params 事件参数
   */
  static batchReport(domain: string, name: string, eventType: hiSysEvent.EventType, params: Object[]): void {
    const sysEventInfos: hiSysEvent.SysEventInfo[] = params.map(param => {
      return {
        domain: domain,
        name: name,
        eventType: eventType,
        params: param
      } as hiSysEvent.SysEventInfo;
    });
    TaskpoolUtil.doTask(batchReportHiSysEvent, sysEventInfos);
  }

  public static getRotationMode(): number {
    let rotationMode: number;
    let isPortrait: boolean | undefined = AppStorage.get<boolean>('isPortrait');
    // rotationMode: 屏幕旋转类型 0-竖屏 1-横屏
    if (isPortrait === false) {
      rotationMode = 1;
    } else {
      rotationMode = 0;
    }
    return rotationMode;
  }
}

async function reportHiSysEvent(sysEventInfo: hiSysEvent.SysEventInfo): Promise<void> {
  'use concurrent';
  const TAG = 'HiSysEventUtil';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  try {
    hiSysEvent.write(sysEventInfo)
      .catch(
        (err: ErrorCode) => {
          log.error('HiSysEventUtil reportHiSysEvent error:' + err.code + ', message:' + err.message );
        }
      )
      .then(
        val => {
          log.showDebug(`HiSysEventUtil reportHiSysEvent ${sysEventInfo.name} success.`);
        });
  } catch (err) {
    log.error('reportHiSysEvent error:' + err);
  }
}

async function batchReportHiSysEvent(sysEventInfos: hiSysEvent.SysEventInfo[]): Promise<void> {
  'use concurrent';
  const TAG = 'HiSysEventUtil';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  for (const sysEventInfo of sysEventInfos) {
    try {
      hiSysEvent.write(sysEventInfo)
        .catch(
          (err: ErrorCode) => {
            log.error('HiSysEventUtil reportHiSysEvent error:' + err.code + ', message:' + err.message );
          }
        );
    } catch (err) {
      log.error('reportHiSysEvent error:' + err);
    }
  }
}

interface ReportMsg {
  PACKAGE_NAME?: string;
  PROCESS_NAME?: string;
}

interface ErrorCode {
  code?: string;
  message?: string;
}
