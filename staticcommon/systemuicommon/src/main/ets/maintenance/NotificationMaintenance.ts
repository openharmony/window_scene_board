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
import { FreqLimitMaintenance,
  LimitMaintenanceExt } from '@ohos/systemuiutils/src/main/ets/maintenance/FreqLimitMaintenance';
import { HaReportLimitCode } from '@ohos/systemuiutils/src/main/ets/maintenance/ha/HaReportLimitCode';
import { NotificationCreatorType } from '../model/NotificationContent';
import { CompatibleNotification, MaintenanceCompatibleUtils } from './MaintenanceCompatibleUtils';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'NotificationMaintenanceRecord');

export enum NotificationMaintenanceNtfType {
  /* 普通通知 */
  NORMAL = 0,
  /* 实况通知 */
  LIVE_VIEW = 1,
  /* 普通通知转实况 */
  NORMAL_TO_LIVE_VIEW = 2,
}

export interface NotificationMaintenanceExt extends LimitMaintenanceExt {
  /* 通知类型 */
  ntfType?: NotificationMaintenanceNtfType;
  /* 通知的hashcode */
  hashCode?: string;
  /* Push消息携带的数据，区分是否本地或云推 */
  pushData?: Record<string, Object>;
  /* 更多信息 */
  moreInfo?: string;
}

/**
 * 通知运维打点基类
 */
export class NotificationMaintenance<T extends NotificationMaintenanceExt> extends FreqLimitMaintenance<T> {
  /**
   * 本地消息限制，1000条
   */
  private static readonly BASE_LIMIT_NUM_LOCAL: number = 1000;
  /**
   * 云推消息限制，4000条
   */
  private static readonly BASE_LIMIT_NUM_PUSH: number = 4000;

  /**
   * 填充通知打点详细信息的公共字段
   * @param entry
   * @param request
   */
  protected fillCommonExt(entry: CompatibleNotification): void {
    this.ext.hashCode = entry.hashCode;
    this.ext.bundleName = (entry.creatorType === NotificationCreatorType.SA && !entry.creatorBundleName) ?
    entry.hashCode : entry.creatorBundleName;
    this.ext.pushData = entry.pushData;
    if (MaintenanceCompatibleUtils.isLiveView(entry)) {
      this.ext.ntfType = entry.isConvertFromNormal ? NotificationMaintenanceNtfType.NORMAL_TO_LIVE_VIEW :
      NotificationMaintenanceNtfType.LIVE_VIEW;
      return;
    }
    this.ext.ntfType = NotificationMaintenanceNtfType.NORMAL;
    this.fillExtMoreInfo(entry);
  }

  protected fillExtMoreInfo(entry: CompatibleNotification): void {
    const moreInfo: Record<string, Object> = {};
    moreInfo.traceId = entry.traceId;
    this.ext.moreInfo = JSON.stringify(moreInfo);
  }

  protected getHaChannelLimit(): [number[], number] {
    // push云推通知修改限频
    if (this.ext.pushData) {
      return [[HaReportLimitCode.BASE_LIMIT_ERRCODE_PUSH], NotificationMaintenance.BASE_LIMIT_NUM_PUSH];
    }
    return [[HaReportLimitCode.BASE_LIMIT_ERRCODE_LOCAL], NotificationMaintenance.BASE_LIMIT_NUM_LOCAL];
  }
}