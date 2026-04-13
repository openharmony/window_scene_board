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
import { MaintenanceRecord } from './MaintenanceRecord';
import { MaintenanceReportChannel } from './MaintenanceModel';
import { HaReportLimitCode } from './ha/HaReportLimitCode';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'FreqLimitMaintenance');

export interface LimitMaintenanceExt {
  /* 打点包名，作为限频key */
  bundleName?: string;
  /* 错误码集合 */
  errorCodes?: number[];
}

/**
 * 带限频运维打点基类
 */
export class FreqLimitMaintenance<T extends LimitMaintenanceExt> extends MaintenanceRecord<T> {
  /**
   * 已经上报的错误码统计信息，格式为bundleName -> errorCode -> count
   */
  private static reportedErrorCodeStatistics: Map<string, Map<number, number>> = new Map();
  /**
   * 上次统计错误码的时间，每天需要清空
   */
  private static lastStatisticDay = -1;
  /**
   * 每天每个包名每个错误码PUSH渠道允许上报的最大次数
   */
  private static readonly PUSH_CHANNEL_LIMIT_NUM = 3;
  /**
   * 每天每个包名HA渠道允许上报的最大次数
   */
  private static readonly HA_CHANNEL_LIMIT_NUM: number = 200;

  /**
   * 检查错误码是否已经超过上限
   * @param channel 上报渠道
   * @returns 超过上限则返回true
   */
  protected isNeedReport(channel: MaintenanceReportChannel): boolean {
    /* push渠道仅上报异常打点 */
    if (channel === MaintenanceReportChannel.PUSH && !this.ext.errorCodes?.length) {
      return false;
    }
    const bundleName = this.ext.bundleName ?? 'default_bundle_name';
    const day = new Date().getDay();

    // 校验统计错误码时间是否为同一天，不在同一天则表示统计信息需要重置
    if (FreqLimitMaintenance.lastStatisticDay !== day) {
      FreqLimitMaintenance.lastStatisticDay = day;
      FreqLimitMaintenance.reportedErrorCodeStatistics.clear();
    }

    const statistics: Map<number, number> = FreqLimitMaintenance.reportedErrorCodeStatistics.get(bundleName) ?? new Map();
    FreqLimitMaintenance.reportedErrorCodeStatistics.set(bundleName, statistics);

    const thresholdParam: [number[], number] = this.getDimensionAndThreshold(channel);
    const errorCodes = thresholdParam[0];
    const threshold = thresholdParam[1];
    let isErrorCodeAllowed = false;
    for (const errorCode of errorCodes) {
      const count = statistics.get(errorCode) ?? 0;
      statistics.set(errorCode, count + 1);
      // 如果有一个错误码没有超过上限则允许上报
      isErrorCodeAllowed = isErrorCodeAllowed || count < threshold;
    }
    if (!isErrorCodeAllowed) {
      log.showWarn(`(${channel})No report event(${this.recordType}) because errorCode [${errorCodes}] exceeded limit`);
    }
    return isErrorCodeAllowed;
  }

  /**
   * 获取限频的指标和阈值
   * @param channel 上报渠道
   * @returns [[指标], 阈值]
   */
  protected getDimensionAndThreshold(channel: MaintenanceReportChannel) : [number[], number] {
    if (channel === MaintenanceReportChannel.HA) {
      return this.getHaChannelLimit();
    }
    return [this.ext.errorCodes ?? [], FreqLimitMaintenance.PUSH_CHANNEL_LIMIT_NUM];
  }

  /**
   * 获取HA渠道限频指标和阈值
   * @returns
   */
  protected getHaChannelLimit(): [number[], number] {
    return [[HaReportLimitCode.HA_CHANNEL_ERRCODE], FreqLimitMaintenance.HA_CHANNEL_LIMIT_NUM];
  }

  /**
   * 添加错误码
   * @param errorCode
   */
  protected addErrorCode(errorCode: number): void {
    if (!this.ext.errorCodes) {
      this.ext.errorCodes = [];
    }
    if (errorCode === undefined) {
      return;
    }
    if (!this.ext.errorCodes.includes(errorCode)) {
      this.ext.errorCodes.push(errorCode);
    }
  }
}