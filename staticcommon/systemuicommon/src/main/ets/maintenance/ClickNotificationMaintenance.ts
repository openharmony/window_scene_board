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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { notificationManager } from '@kit.NotificationKit';
import { StatisticsMaintenance } from './StatisticsMaintenance';
import { NotificationMaintenance, NotificationMaintenanceExt } from './NotificationMaintenance';
import { MaintenanceRecordType, MaintenanceReportChannel } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { SystemuiConstants } from '../constants/SystemuiConstants';
import { BaseNotification } from '../model/BaseNotification';
import { LiveViewData } from '../liveview/data/LiveViewData';
import { ClickRegion } from './StatisticsConstants';
import { CompatibleNotification } from './MaintenanceCompatibleUtils';
import { NotificationBase } from '../model/NotificationBase';
import { NormalNotification } from '../model/NormalNotification';
import { LiveNotification } from '../live/model/LiveNotification';
import { SysTypeCode } from '../liveview/common/LiveConstants';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ClickNotificationMaintenance');

/**
 * 通知点击错误码，2000-3000
 */
export enum ClickNotificationErrorCode {
  /* entry无效 */
  NO_ENTRY = 2000,
  /* 无wantAgent */
  NO_WANTAGENT = 2001,
  /* 无效wantAgent */
  INVALID_WANTAGENT = 2002,
  /* 触发wantAgent失败 */
  TRIGGER_WANTAGENT_FAIL = 2003,
  /* 获取wantAgent operationType错误 */
  WANT_AGENT_GET_TYPE_ERROR = 2004,
  /* 重载业务 */
  DELIVER_EXCLUDE = 2005,
  /* 设置通知开关失败 */
  SET_NTF_ENABLE_FAIL = 2006,
  /* 设置实况开关失败 */
  SET_LIVE_VIEW_FAIL = 2007,
  /* 设置置顶开关失败 */
  SET_PIN_TOP_FAIL = 2008,
  /* 设置通知开关成功 */
  SET_NTF_ENABLE_SUCC = 2009,
  /* 设置智能提醒开关成功 */
  SET_SMART_REMINDER_SUCC = 2010,
  /* 设置置顶开关成功 */
  SET_PIN_TOP_SUCC = 2011,
  /* 设置静默通知开关成功 */
  SET_SILENT_NOTIFICATION_SUCC = 2012,
  /* 设置静默通知开关失败 */
  SET_SILENT_NOTIFICATION_FAIL = 2013,
  /* 授权失败 */
  AUTH_FAIL = 2500,
  /* 授权成功 */
  AUTH_FINISH = 2501,
  /* 辅助区Click */
  SUB_AREA_CLICK = 2502,
  /* 实况按钮CLICK */
  LIVE_BUTTON_CLICK = 2503,
  /* 无模板 */
  NO_TEMPLATE = 2504,
  /* 无基础模板 */
  NO_BASE_TEMPLATE = 2505,
  /* 实况按钮无效 */
  LIVE_BUTTON_INVALID = 2506,
  /* 实况按钮点击失败 */
  CLICK_LIVE_BUTTON_FAIL = 2507,
  /* 关闭实况 */
  LIVE_VIEW_DISABLE = 2508,
  /* 无点击响应 */
  NO_CLICK_ACTION = 2509,
  /* 无辅助区数据 */
  NO_EXTEND_DATA = 2510,
  /* DELIVER点击失败 */
  DELIVER_FAIL = 2511,
  /* DELIVER未同意克隆应用隐私协议 */
  DELIVER_PRIVACY_DISABLE = 2512,
  /* 合一桌面公共事件_开启FULL模式 */
  FULL_MODE = 2515,
  /* 合一桌面公共事件_开启LITE模式 */
  LITE_MODE = 2516,
  /* DELIVER本地通知环境未启动拉起失败 */
  DELIVER_ENHANCE_FAIL = 2513,
  /* DELIVER本地通知环境未启动拉起成功 */
  DELIVER_ENHANCE_SUCCESS = 2514,
}

interface ClickNotificationMaintenanceExt extends NotificationMaintenanceExt {
  /* 点击区域 */
  clickRegion?: ClickRegion;
  /* 点击类型 */
  clickType?: number;
  /* 按钮名称 */
  buttonName?: string;
  /* 点击场景 */
  scene?: string;
  /* 点击是否删除通知 */
  isAutoDelete?: boolean;
  /* APP安装来源 */
  source?: number;
  /* 描述信息 */
  desc?: string;
}

export class BaseInfo {
  hashCode?: string;
  creatorBundleName?: string;
  agentBundle?: notificationManager.BundleOption;
}

export interface ClickMaintenanceInfo {
  data?: CompatibleNotification | LiveViewData | BaseInfo;
  clickRegion?: ClickRegion;
  scene?: string;
  buttonName?: string;
  errorCodes?: ClickNotificationErrorCode[];
  isAutoDelete?: boolean;
  source?: number;
  desc?: string;
  isCollaNtf?: boolean;
}

/**
 * 通知点击运维打点
 */
export class ClickNotificationMaintenance extends NotificationMaintenance<ClickNotificationMaintenanceExt> {
  private static info?: ClickMaintenanceInfo;
  private static pathErrorCode: ClickNotificationErrorCode[] = [];

  private constructor() {
    super(MaintenanceRecordType.NOTIFICATION_CLICK, [MaintenanceReportChannel.PUSH, MaintenanceReportChannel.HA]);
  }

  /**
   * 保存本次上报的信息，上报之前需要先保存信息
   * @param info
   */
  public static saveInfo(info: ClickMaintenanceInfo): void {
    ClickNotificationMaintenance.info = info;
    if (info.data instanceof NotificationBase || info.data instanceof BaseNotification) {
      ClickNotificationMaintenance.info.isAutoDelete = info.data?.isAutoDelete;
      ClickNotificationMaintenance.info.source = info.data?.deliverInstallSource;
      ClickNotificationMaintenance.info.isCollaNtf = info.data instanceof NotificationBase ?
        info.data?.isCollaNotification : false;
    }
  }

  protected fillExtMoreInfo(entry: CompatibleNotification): void {
  }

  /**
   * 增加路径上错误，可能有多个错误码
   * @param errorCode
   */
  public static updateErrorCode(errorCode: ClickNotificationErrorCode): void {
    // 没有保存过上报信息，不处理
    if (!ClickNotificationMaintenance.info) {
      return;
    }
    ClickNotificationMaintenance.pathErrorCode.push(errorCode);
  }

  /**
   * 获取本次上报的信息
   * @returns
   */
  public static getInfo(): ClickMaintenanceInfo | undefined {
    if (!ClickNotificationMaintenance.info) {
      return undefined;
    }
    const info = ClickNotificationMaintenance.info;
    ClickNotificationMaintenance.info = undefined;
    // 添加路径上的errorCode
    info.errorCodes = ClickNotificationMaintenance.pathErrorCode;
    ClickNotificationMaintenance.pathErrorCode = [];
    return info;
  }

  public static reportClickWithResult(isSuccess: boolean, finalErrorCode?: ClickNotificationErrorCode,
    info?: ClickMaintenanceInfo): void {
    ClickNotificationMaintenance.reportClick(isSuccess ? undefined : finalErrorCode, info);
  }

  /**
   * 上报本次上报的信息
   * @param errorCode
   */
  public static reportClick(finalErrorCode?: ClickNotificationErrorCode, info?: ClickMaintenanceInfo,
    error?: Error): void {
    try {
      let reportInfo: ClickMaintenanceInfo | undefined = undefined;
      if (info) {
        info.desc = error?.message;
        reportInfo = info;
      } else {
        // 入参info为空，尝试从保存的信息中取
        reportInfo = ClickNotificationMaintenance.getInfo();
      }
      if (!reportInfo || reportInfo.clickRegion === undefined) {
        log.showInfo(`info is invalid, do not report`);
        return;
      }
      if (!reportInfo.errorCodes) {
        reportInfo.errorCodes = [];
      }
      if (finalErrorCode) {
        reportInfo.errorCodes.push(finalErrorCode);
      }
      new ClickNotificationMaintenance().doReport(reportInfo);
    } catch (e) {
      log.error('report click failed, ' + e);
    }
  }

  /**
   * 上报
   * @param info
   * @returns
   */
  private doReport(info: ClickMaintenanceInfo): void {
    log.showInfo(`start doReport, region ${info.clickRegion}, errorCode ${info.errorCodes}`);
    try {
      let ntf = new NotificationBase();
      if (info.data) {
        ntf = this.convertInfo(info.data);
        this.fillCommonExt(ntf);
        this.ext.clickType = ntf.wantAgentInfo?.operationType;
      }
      this.ext.clickRegion = info.clickRegion;
      this.ext.buttonName = info.buttonName;
      this.ext.scene = info.scene;
      this.ext.isAutoDelete = info.isAutoDelete;
      this.ext.source = info.source;
      this.ext.desc = info.desc;
      const moreInfo: Record<string, Object> = {};
      moreInfo.traceId = ntf.traceId;
      moreInfo.isCollaNtf = info.isCollaNtf;
      this.ext.moreInfo = JSON.stringify(moreInfo);
      if (info.errorCodes?.length) {
        info.errorCodes.forEach(code => this.addErrorCode(code));
        StatisticsMaintenance.get().clickNtf(false, ntf, info.clickRegion, info.data, info.buttonName);
      } else {
        StatisticsMaintenance.get().clickNtf(true, ntf, info.clickRegion, info.data, info.buttonName);
      }
      this.report();
    } catch (e) {
      log.showError(`report error, type: ${this.recordType}, hashCode: ${info.data?.hashCode}, message: ${e.message}`);
    }
  }

  private convertInfo(data: CompatibleNotification | LiveViewData | BaseInfo): NotificationBase {
    if (data instanceof NotificationBase) {
      return data;
    }
    let convertNtf: NormalNotification | LiveNotification | undefined = undefined;
    if (data instanceof BaseInfo) {
      convertNtf = new NormalNotification();
    } else if (data instanceof LiveViewData || data.isLiveType()) { // 实况
      convertNtf = new LiveNotification();
      convertNtf.contentType = this.getLiveContent(data);
    } else {
      convertNtf = new NormalNotification();
      convertNtf.pushData = data.pushData;
      convertNtf.traceId = data.traceId;
    }
    convertNtf.creatorBundleName = data.creatorBundleName;
    convertNtf.hashCode = data.hashCode;
    convertNtf.isFromPush = data?.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME;
    return convertNtf;
  }

  private getLiveContent(data: BaseNotification | LiveViewData): notificationManager.ContentType {
    if (data instanceof BaseNotification) {
      return data.contentType;
    }
    return data.sysTypeCode === SysTypeCode.OTHER ? notificationManager.ContentType.NOTIFICATION_CONTENT_LIVE_VIEW :
    notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW;
  }
}