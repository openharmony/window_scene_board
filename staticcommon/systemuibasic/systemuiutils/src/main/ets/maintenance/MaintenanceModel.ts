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

/**
 * 运维打点类型
 */
export enum MaintenanceRecordType {
  /* 通知创建/更新 */
  NOTIFICATION_RECEIVE = 0,
  /* 通知通用打点 */
  NOTIFICATION_COMMON = 1,
  /* 通知点击 */
  NOTIFICATION_CLICK = 2,
  /* 通知删除 */
  NOTIFICATION_DELETE = 3,
  /* 通知提醒 */
  NOTIFICATION_REMIND = 4,
  /* 通知显示 */
  NOTIFICATION_DISPLAY = 5,
  /* 接口异常 */
  INTERFACE_EXCEPTION = 6,
  /* 音量面板 */
  VOLUME_PANEL = 7,
  /* 通知提醒 */
  ANS_REPORT = 9,
  /* 状态栏 */
  STATUS_BAR = 12
}

/**
 * 扩展类型
 */
export enum MaintenanceExtendType {
  /* 显示 */
  DISPLAY = 5,
  /* 统计 */
  STATISTICS = 6,
  /* 接口异常 */
  INTERFACE = 7,
  /* 汇聚正常打点 */
  MERGE_NORMAL = 8,
}

/**
 * 上报渠道
 */
export enum MaintenanceReportChannel {
  /* 通过push上报 */
  PUSH = 0,
  /* 通过HA上报 */
  HA = 1,
  /* ANS通过HA上报 */
  HA_ANS = 2,
}

/**
 * 运维打点上报云侧的信息
 */
export interface MaintenanceReportInfo {
  /**
   * 运维打点类型
   */
  operationType: MaintenanceRecordType;
  /**
   * 运维打点时间
   */
  eventTime: string;
  /**
   * 运维打点详细内容
   */
  ext: Object;
  /**
   * 运维打点扩展类型
   */
  notificationStatus: string;
}