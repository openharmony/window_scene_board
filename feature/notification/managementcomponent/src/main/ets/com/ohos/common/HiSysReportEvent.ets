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
import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper, TaskpoolUtil } from './BasicCommon';

const TAG = 'HiSysReportEvent';

/**
 * 当前大桌面所有的事件领域domain
 */
export const enum ReportDomain {
  // SceneBoard应用维测打点domain
  SCENE_BOARD_APP = 'SCENE_BOARD_APP',
  AOD_UE = 'AOD_UE',
  CONTROLCENTER_UE = 'CONTROLCENTER_UE',
  MULTIWINDOW_UE = 'MULTIWINDOW_UE',
  NOTIFICATION_UE = 'NOTIFICATION_UE',
  SCENE_BOARD_UE = 'SCENE_BOARD_UE',
  SCREENLOCK_UE = 'SCREENLOCK_UE',
  SETTINGS_APP_UE = 'SETTINGS_APP_UE',
  STARTUPGUIDE_UE = 'STARTUPGUIDE_UE',
  SYSTEM_NAV_UE = 'SYSTEM_NAV_UE',
  VOLUME_UE = 'VOLUME_UE',
  FORM_UE = 'FORM_UE',
  SYSTEMUI_FAULT = 'SYSTEMUI_FAULT',
  // 智慧多窗
  MULTI_WINDOW_UE_DOMAIN = 'MULTIWINDOW_UE',
  // 应用接续
  APP_CONTINUE = 'APP_CONTINUE',
  TURNONANDOFF_UE = 'TURNONANDOFF_UE',
  // 旋转
  ROTATION_UE = 'ROTATION_UE',
  // 小外屏UE
  OUTER_HOME_UE = 'OUTER_HOME_UE'
}

/**
 * 大数据打点基础类
 */
export class HiSysReportEvent {
  private mDomain: string;
  private static mInstanceMap: Map<string, HiSysReportEvent> = new Map();

  private constructor(domain: string) {
    this.mDomain = domain;
  }

  /**
   * 根据domain获取对应的打点工具类
   *
   * @param domain 事件领域
   * @returns 打点基础类
   */
  public static getHiSysReportEvent(domain: string): HiSysReportEvent | undefined {
    if (!HiSysReportEvent.mInstanceMap.has(domain)) {
      HiSysReportEvent.mInstanceMap.set(domain, new HiSysReportEvent(domain));
    }
    return HiSysReportEvent.mInstanceMap.get(domain);
  }

  /**
   * 监视任务是否超时
   *
   * @param callableTask 任务
   * @param timeout 超时时间
   * @param msg 超时打印信息
   * @returns promise
   */
  public static async watchTaskTimeout(callableTask: () => Promise<void>, timeout: number, msg: string): Promise<void> {
    const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
    log.showInfo('watchTaskTimeout begin');
    const timerId = setTimeout(() => HiSysReportEvent.reportFaultAndExit(msg), timeout);
    await callableTask();
    clearTimeout(timerId);
    log.showInfo('watchTaskTimeout end');
  }

  private static reportFaultAndExit(msg: string): void {
    const reporter: HiSysReportEvent | undefined = HiSysReportEvent.getHiSysReportEvent('FRAMEWORK');
    const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
    log.showInfo(`report SERVICE_WARNING: ${msg}`);
    reporter?.reportExitFault('SERVICE_WARNING', msg);
    const collectInfoDelay = 3000;
    setTimeout(() => {
      log.showInfo(`report SERVICE_BLOCK: ${msg}`);
      reporter?.reportExitFault('SERVICE_BLOCK', msg);
      setTimeout(()=>{
        log.showInfo(`app exit: ${msg}`);
        throw new Error(`js task timeout. app exit: ${msg}`);
      }, collectInfoDelay);
    }, collectInfoDelay);
  }

  /**
   * 错误事件打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  public reportFault(name: string, params?: Object): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: this.mDomain,
      name: name,
      eventType: hiSysEvent.EventType.FAULT,
      params: params
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }

  /**
   * 统计事件打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  public reportStatistic(name: string, params: Object): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: this.mDomain,
      name: name,
      eventType: hiSysEvent.EventType.STATISTIC,
      params: params
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }

  /**
   * 统计事件打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  public batchReportStatistic(name: string, params: Object[]): void {
    const sysEventInfo: hiSysEvent.SysEventInfo[] = params.map((param) => {
      return {
        domain: this.mDomain,
        name: name,
        eventType: hiSysEvent.EventType.STATISTIC,
        params: param
      } as hiSysEvent.SysEventInfo;
    });
    TaskpoolUtil.doTask(batchReportHiSysEvent, sysEventInfo);
  }

  /**
   * 安全事件打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  public reportSecurity(name: string, params: Object): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: this.mDomain,
      name: name,
      eventType: hiSysEvent.EventType.SECURITY,
      params: params
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }

  /**
   * 用户行为事件打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  public reportBehavior(name: string, params?: Object): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: this.mDomain,
      name: name,
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: params
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }

  /**
   * 退出故障事件打点
   * @param name 事件名称
   * @param params 事件参数
   */
  private reportExitFault(name: string, msg: string): void {
    const sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'FRAMEWORK',
      name: name,
      eventType: hiSysEvent.EventType.FAULT,
      params: {
        MSG: msg
      }
    };
    TaskpoolUtil.doTask(reportHiSysEvent, sysEventInfo);
  }
}

async function reportHiSysEvent(sysEventInfo: hiSysEvent.SysEventInfo): Promise<void> {
  'use concurrent';
  const TAG = 'HiSysReportEvent';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  try {
    hiSysEvent.write(sysEventInfo)
      .catch(
        (err: ErrorCode) => {
          log.error('reportHiSysEvent error:' + err.code + ', message:' + err.message );
        }
      )
      .then(
        val => {
          log.showDebug(`reportHiSysEvent ${sysEventInfo.name} success.`);
        });
  } catch (err) {
    log.error('reportHiSysEvent error:' + err);
  }
}

async function batchReportHiSysEvent(sysEventInfos: hiSysEvent.SysEventInfo[]): Promise<void> {
  'use concurrent';
  const TAG = 'HiSysReportEvent';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
  for (const sysEventInfo of sysEventInfos) {
    try {
      hiSysEvent.write(sysEventInfo)
        .catch(
          (err: ErrorCode) => {
            log.error('reportHiSysEvent error:' + err.code + ', message:' + err.message );
          }
        );
    } catch (err) {
      log.error('reportHiSysEvent error:' + err);
    }
  }
}

interface ErrorCode {
  code?: string;
  message?: string;
}