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

import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Trace } from '@ohos/basicutils';
import {
  MaintenanceExtendType,
  MaintenanceRecordType,
  MaintenanceReportInfo,
  MaintenanceReportChannel,
} from './MaintenanceModel';
import { commonEventManager, systemDateTime } from '@kit.BasicServicesKit';
import { taskpool } from '@kit.ArkTS';
import { HaReporter } from './ha/HaReporter';
import { HaReportBase } from './ha/HaReportBase';
import { HaReporterANS } from './ha/HaReporterANS';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'MaintenanceRecord');

/**
 * 广播打点事件给PUSH的事件名称
 */
const MAINTAIN_REPORT_EVENT_NAME = 'sceneboard.event.PUSH_AGENT';
/**
 * 广播打点事件给PUSH的事件权限
 */
const MAINTAIN_REPORT_EVENT_PERMISSION = 'ohos.permission.NOTIFICATION_AGENT_CONTROLLER';

/**
 * 运维打点上报
 */
class MaintenanceReporter {
  public static get = SingletonHelper.createFactory(() => new MaintenanceReporter());

  /**
   * 上报队列最大长度
   */
  protected report_list_max_len = 500;

  /**
   * 上报间隔
   */
  protected report_duration = 30000;

  /**
   * 每次上报条数
   */
  protected report_num_once = 1;

  /**
   * 需要上报的打点队列
   */
  protected reportInfoList: MaintenanceReportInfo[] = [];
  /**
   * 记录上一次上报打点的时间，用来控制上报频率。将初始值赋值为负一次的间隔时间，这样首次上报时无需等待间隔
   */
  protected lastReportTime: number = -this.report_duration;
  /**
   * 当前是否正在上报中
   */
  private isReporting: boolean = false;

  /**
   * 超过队列长度而丢弃上报的数量
   */
  private dropNum: number = 0;

  /**
   * 上报打点
   * @param reportInfo
   */
  public report(reportInfo: MaintenanceReportInfo): void {
    if (this.reportInfoList.length > this.report_list_max_len) {
      log.showWarn('report list is too long, do not report');
      this.dropNum++;
      return;
    }
    this.reportInfoList.push(reportInfo);
    log.showInfo(`add info in queue, cur len ${this.reportInfoList.length}, max len ${this.report_list_max_len}`);
    this.reportInQueue();
  }

  public reportImmediately(reportInfo: MaintenanceReportInfo): void {
    this.doReport([reportInfo]);
  }

  public getQueueLength(): number {
    return this.reportInfoList.length;
  }

  public getDropNum(): number {
    const dropNum = this.dropNum;
    this.dropNum = 0;
    return dropNum;
  }

  /**
   * 递归将打点队列上报到Push
   * @returns
   */
  private async reportInQueue(): Promise<void> {
    if (this.isReporting || !this.reportInfoList.length) {
      return;
    }

    this.isReporting = true;
    try {
      let reportTime = this.getNow();
      const lastReportDuration = reportTime - this.lastReportTime;
      // 控制上报频率
      if (lastReportDuration < this.report_duration) {
        await new Promise<void>((resolve) => setTimeout(resolve, this.report_duration - lastReportDuration));
        reportTime = this.lastReportTime + this.report_duration;
      }
      this.lastReportTime = reportTime;
      this.doReport();
    } catch (e) {
      log.showError(`Report maintenance error: ${e.message}`);
    }

    this.isReporting = false;
    this.reportInQueue();
  }

  protected getReportInfo(): MaintenanceReportInfo[] {
    return this.reportInfoList.splice(0, this.report_num_once);
  }

  protected async doReport(reportInfo?: MaintenanceReportInfo[]): Promise<void> {
    try {
      const info = (reportInfo ?? this.getReportInfo())[0];
      const param: Record<string, string> = {};
      param.operationType = String(info.operationType);
      param.eventTime = info.eventTime;
      param.ext = JSON.stringify([info.ext]);
      param.notificationStatus = info.notificationStatus;
      const option: commonEventManager.CommonEventPublishData = {
        code: 0,
        subscriberPermissions: [MAINTAIN_REPORT_EVENT_PERMISSION],
        parameters: param
      };
      log.showInfo(`Send maintenance event(${info?.operationType}), extendType(${info?.notificationStatus}), ext: ${param?.ext}`);
      commonEventManager.publish(MAINTAIN_REPORT_EVENT_NAME, option, (err) => {
        if (err?.message) {
          log.showError(`Send maintenance event(${info?.operationType}) to push error: ${err.message}`);
        } else {
          log.showInfo(`Send maintenance event(${info?.operationType}) to push success`);
        }
      });
    } catch (e) {
      log.showError(`Report maintenance error: ${e.message}`);
    }
  }

  protected getNow(): number {
    return systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
  }
}

/**
 * 运维打点上报Ha
 */
class HaMaintenanceReporter extends MaintenanceReporter {
  public static get = SingletonHelper.createFactory(() => new HaMaintenanceReporter());

  protected report_list_max_len = 4000;

  protected report_duration = 60000;

  protected report_num_once = 20;

  protected lastReportTime: number = -this.report_duration;

  protected async doReport(): Promise<void> {
    if (!HaReportBase.get().isInit()) {
      log.showWarn('Ha is not prepared, init first: ' + this.reportInfoList.length);
      await HaReportBase.get().init();
    }
    taskpool.execute(reportHA, this.getReportInfo());
  }
}

async function reportHA(reportInfo: MaintenanceReportInfo[]): Promise<void> {
  'use concurrent';
  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'MaintenanceRecord');
  try {
    new HaReporter().report(reportInfo);
  } catch (e) {
    log.error('report ha failed, ' + e?.message);
  }
}

/**
 * ANS运维打点上报Ha
 */
class HaMaintenanceReporterANS extends MaintenanceReporter {
  public static get = SingletonHelper.createFactory(() => new HaMaintenanceReporterANS());

  protected async doReport(reportInfo?: MaintenanceReportInfo[]): Promise<void> {
    const info = reportInfo ?? this.getReportInfo();
    const reportTime = this.getNow();
    const lastReportDuration = reportTime - this.lastReportTime;
    // 控制上报频率
    if (lastReportDuration < this.report_duration) {
      log.showWarn(`lastReportDuration(${lastReportDuration}) is not over report_duration(${this.report_duration})`);
    }
    this.lastReportTime = reportTime;
    if (!HaReportBase.get().isInit()) {
      log.showWarn('Ha is not prepared, init first: ' + this.reportInfoList.length);
      await HaReportBase.get().init();
    }
    taskpool.execute(reportHaANS, info);
  }
}

async function reportHaANS(reportInfo: MaintenanceReportInfo[]): Promise<void> {
  'use concurrent';
  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'MaintenanceRecord');
  try {
    new HaReporterANS().report(reportInfo);
  } catch (e) {
    log.error('report ha ans failed, ' + e?.message);
  }
}

/**
 * 运维打点基类
 */
export abstract class MaintenanceRecord<T extends Object> {
  /**
   * 打点详细信息
   */
  protected ext: T = new Object() as T;

  /**
   * 构造运维打点类
   * @param recordType 打点类型
   * @param channel 上报渠道：0：push，1：HA
   * @param extendType 扩展类型
   */
  protected recordType: MaintenanceRecordType;
  protected channel: MaintenanceReportChannel[];
  protected extendType?: MaintenanceExtendType;

  constructor(recordType: MaintenanceRecordType,
  channel: MaintenanceReportChannel[] = [MaintenanceReportChannel.HA],
  extendType?: MaintenanceExtendType) {
  this.recordType = recordType;
  this.channel = channel;
  this.extendType = extendType;
  Trace.start('MaintenanceRecord');
}

  /**
   * 本次打点是否需要上报
   * @param channel 上报渠道
   * @returns 返回true则表示需要上报
   */
  protected abstract isNeedReport(channel: MaintenanceReportChannel): boolean;

  /**
   * 本次打点是否需要排队
   * @returns 返回true则表示需要排队
   */
  protected isNeedQueue(): boolean {
    return true;
  }

  /**
   * 获取当前上报队列数量
   * @returns
   */
  protected getQueueLength(): number {
    return MaintenanceReporter.get().getQueueLength();
  }

  /**
   * 获取超过队列长度而丢弃的数量
   * @returns
   */
  protected getDropNum(): number[] {
    return [MaintenanceReporter.get().getDropNum(), HaMaintenanceReporter.get().getDropNum()];
  }

  /**
   * 上报打点
   */
  public report(): void {
    try {
      const reportInfo: MaintenanceReportInfo = {
        operationType: this.recordType,
        eventTime: String(Date.now()),
        ext: this.ext,
        notificationStatus: this.extendType?.toString() as string,
      };
      this.channel.forEach((channel) => this.reportDifferentChannel(reportInfo, channel));
    } catch (e) {
      log.error(`Report maintenance record error:`, e.message);
    }
    Trace.end('MaintenanceRecord');
  }

  private reportDifferentChannel(reportInfo: MaintenanceReportInfo, channel: MaintenanceReportChannel): void {
    if (!this.isNeedReport(channel)) {
      return;
    }
    switch (channel) {
      case MaintenanceReportChannel.PUSH:
        this.reportPush(reportInfo);
        break;
      case MaintenanceReportChannel.HA:
        this.reportHa(reportInfo);
        break;
      case MaintenanceReportChannel.HA_ANS:
        this.reportHaANS(reportInfo);
        break;
      default:
        log.showWarn(`invalid type ${this.channel}`);
    }
  }

  private reportPush(reportInfo: MaintenanceReportInfo): void {
    if (this.isNeedQueue()) {
      MaintenanceReporter.get().report(reportInfo);
    } else {
      MaintenanceReporter.get().reportImmediately(reportInfo);
    }
  }

  private reportHa(reportInfo: MaintenanceReportInfo): void {
    HaMaintenanceReporter.get().report(reportInfo);
  }

  private reportHaANS(reportInfo: MaintenanceReportInfo): void {
    if (this.isNeedQueue()) {
      HaMaintenanceReporterANS.get().report(reportInfo);
    } else {
      HaMaintenanceReporterANS.get().reportImmediately(reportInfo);
    }
  }
}