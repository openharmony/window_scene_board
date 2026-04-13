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
import { BaseNotification } from '../model/BaseNotification';
import { MaintenanceRecordType } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { NotificationMaintenance, NotificationMaintenanceExt } from './NotificationMaintenance';
import { notificationManager } from '@kit.NotificationKit';
import { SysTypeCode } from '../liveview/common/LiveConstants';
import { NotificationBase } from '../model/NotificationBase';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'DisplayNotificationMaintenance');

/**
 * 通知显示错误码，3000-3999
 */
export enum DisplayNotificationErrorCode {
  /* 横幅抑制 */
  IGNORE_BANNER = 3000,
  /* OOBE阶段不显示 */
  OOBE_NOT_SHOW = 3001,
  /* 设置了isAlertOnce属性通知, 只弹一次横幅，后续横幅不显示 */
  IS_ALERT_ONCE = 3002,
  /* 下载类型通知进度更新 */
  DOWNLOAD_UPDATE = 3003,
  /* 实况面板场景横幅显示失败 */
  LIVE_VIEW_PANEL_SHOW = 3004,
  /* 其他面板显示，不需要显示横幅 */
  OTHER_PANEL_SHOW = 3005,
  /* 下拉面板显示，不显示横幅 */
  DROPDOWN_PANEL_SHOW = 3006,
  /* 存在常驻横幅 */
  EXIST_PERMANENT_HEADS_UP = 3007,
  /* 横幅通知异常不显示 */
  HEADS_UP_SHOW_FAILED = 3008,
  /* 处于解锁页面，不需要显示横幅 */
  PWD_VISIBLE = 3009,
  /* 处于AOD，需要显示横幅 */
  IN_AOD = 3010,
}

interface DisplayNotificationMaintenanceExt extends NotificationMaintenanceExt {
  /* 通知类型 */
  slotType?: notificationManager.SlotType;
  /* 实况通知业务类型 */
  typeCode?: SysTypeCode;
  /* 通知提醒标志位remindFlags */
  remindFlags?: number;
  /* 通知控制字段 */
  notificationControlFlags?: number;
  /* 是否横幅样式显示 */
  isShowHeadsUp?: boolean;
  /* 是否是常驻横幅 */
  isHeadsUpStick?: boolean;
  /* 是否允许清除 */
  isRemoveAllowed?: boolean;
}

/**
 * 通知显示运维打点
 */
export class DisplayNotificationMaintenance extends NotificationMaintenance<DisplayNotificationMaintenanceExt> {
  constructor() {
    super(MaintenanceRecordType.NOTIFICATION_DISPLAY);
  }

  private reportDisplay(entry: BaseNotification | NotificationBase, errorCode: DisplayNotificationErrorCode): void {
    try {
      this.fillExt(entry);
      this.addErrorCode(errorCode);
      this.report();
      log.showInfo(`Report success, hashCode: ${entry.hashCode}, errorCode =  ${errorCode}`);
    } catch (e) {
      log.showError(`Report error, type: ${this.recordType}, hashCode: ${entry.hashCode}, message: ${e.message}`);
    }
  }

  public static doReport(entry: BaseNotification | NotificationBase, errorCode: DisplayNotificationErrorCode): void {
    new DisplayNotificationMaintenance().reportDisplay(entry, errorCode);
  }

  /**
   * 填充通知打点详细信息的公共字段
   * @param entry
   * @param request
   */
  private fillExt(entry: BaseNotification | NotificationBase): void {
    if (!entry) {
      return;
    }
    super.fillCommonExt(entry);
    this.ext.remindFlags = entry.remindConfig?.flags;
    this.ext.notificationControlFlags = entry.controlConfig?.flags;
    this.ext.slotType = entry.slotType;
    this.ext.typeCode = entry instanceof BaseNotification ? entry.liveViewData?.sysTypeCode :
      entry.isLiveView() ? entry.typeCode : undefined;
    this.ext.isShowHeadsUp = entry instanceof BaseNotification ? entry.isShowHeadsUp : entry.isHeadsUp;
    this.ext.isHeadsUpStick = entry.isHeadsUpStick;
    this.ext.isRemoveAllowed = entry.isRemoveAllowed;
  }
}