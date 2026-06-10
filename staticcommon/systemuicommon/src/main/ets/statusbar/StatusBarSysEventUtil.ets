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
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  HiSysReportEvent,
  ReportDomain,
  ReportParams,
  sSettingsUtil,
  HiDfxEventUtil,
  GlobalContext,
  EventManager,
  EvtBus,
  TimeChangeEvent
} from '@ohos/frameworkwrapper';
import { SettingsKeyConstants, SettingsConstants } from '@ohos/commonconstants';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';

const TAG = 'StatusBarSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

// 一天的毫秒数
const ONE_DAY_MILL: number = 86400000;
// 一个小时的毫秒数
const ONE_HOUR_MILL: number = 3600000;
// 一分钟的毫秒数
const ONE_MINUTE_MILL: number = 60000;
// 一秒的毫秒数
const ONE_SECOND_MILL: number = 1000;
// 每周编号0~6
const ONE_WEEK_DAYS: number = 6;


/**
 * 设置-->通知和状态栏-->状态栏打点上报工具类
 */
export class StatusBarSysEventUtil {
  private reportTimerId: number = -1;
  private static instance: StatusBarSysEventUtil;

  private static readonly NOTIFICATION_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.NOTIFICATION_UE);

  // 设置_通知和状态栏_设置状态
  public static readonly SYS_UI_SETTING_STATUS: string = 'SYS_UI_SETTING_STATUS';

  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * get StatusBarSysEventUtil instance
   *
   * @return StatusBarSysEventUtil instance
   */
  static getInstance(): StatusBarSysEventUtil {
    if (StatusBarSysEventUtil.instance == null) {
      StatusBarSysEventUtil.instance = new StatusBarSysEventUtil();
    }
    return StatusBarSysEventUtil.instance;
  }

  static reportSysUiSettingStatus(name: string, value: number): void {
    let params: SysUiSettingReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      NAME: name,
      VALUE: value
    };
    StatusBarSysEventUtil.NOTIFICATION_UE.reportBehavior(StatusBarSysEventUtil.SYS_UI_SETTING_STATUS, params);
  }

  public startReportAlarm(): void {
    this.eventMgr.offAll();
    this.eventMgr.on(TimeChangeEvent, (event: TimeChangeEvent): void => {
      log.showInfo(`onTimeChangeEvent`);
      if (event.event === TimeChangeEvent.EVENT_TIME_CHANGE) {
        this.initReport();
      }
    });
    this.initReport();
  }


  /**
   * 开始计时
   */
  initReport(): void {
    log.showInfo('startReportAlarmPure');
    let date = new Date();
    // 1、计算当天剩余的毫秒数
    let todayRestMs = ONE_DAY_MILL - ((date.getHours() * ONE_HOUR_MILL) + (date.getMinutes() * ONE_MINUTE_MILL) +
      (date.getSeconds() * ONE_SECOND_MILL) + date.getMilliseconds());

    // 2、计算距离周日还有多少天，
    let restDay = ONE_WEEK_DAYS - date.getDay();

    // 3、计算距离周日还有多少毫秒
    let totalRestMs = todayRestMs + restDay * ONE_DAY_MILL;
    if (this.reportTimerId) {
      clearTimeout(this.reportTimerId);
      this.reportTimerId = -1;
    }
    log.showInfo('set alarm time:' + totalRestMs);
    // 4、设置定时器，当倒计时结束，说明已经到周日了
    if (totalRestMs > 0) {
      this.reportTimerId = setTimeout(() => {
        log.showInfo('reportWeeklyState');
        this.reportWeeklyState();
      }, totalRestMs)
    }
  }

  /**
   * 设置_通知和状态栏_设置状态点周报（周日0点上报）
   *
   * @returns void
   */
  async reportWeeklyState(): Promise<void> {
    log.showInfo('start reportWeeklyState');
    this.reportSettingStatusItem(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON, SettingsConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON_DEFAULT, 'NTF');
    if (!SystemUICcmConfig.instance.isEnabledLive2) {
      this.reportSettingStatusItem(SettingsKeyConstants.STATUS_BAR_PURE_SHOW, SettingsConstants.STATUS_BAR_PURE_SHOW_DEFAULT, 'PURE');
      this.reportSettingStatusItem(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED, SettingsConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED_DEFAULT, 'NET_SPEED');
    } else {
      this.reportSettingStatusItem(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED, false, 'NET_SPEED_ENABLE');
      this.reportSettingStatusItem(SettingsKeyConstants.SHOW_VPN_ICON, true, 'VPN_ENABLE');
      this.reportSettingStatusItem(SettingsKeyConstants.SHOW_RING_MODE_ICON, true, 'RING_MODE_ENABLE');
      this.reportSettingStatusItem(SettingsKeyConstants.SHOW_NEARLINK_ICON, true, 'NEARLINK_BLE_ENABLE');
      this.reportSettingStatusItem(SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON, true, 'ALARM_CLOCK_ENABLE');
      this.reportSettingStatusItem(SettingsKeyConstants.SHOW_NFC_ICON, false, 'NFC_ENABLE');
      this.reportSettingStatusItem(SettingsKeyConstants.SHOW_HEAD_PHONES_ICON, false, 'HEAD_PHONES_ENABLE');
    }
    this.initReport();
  }

  async reportSettingStatusItem(settingsKey: string, defaultValue: boolean, name: string): Promise<void> {
    try {
      let context = GlobalContext.getContext();
      let on = sSettingsUtil.getSecureValue(settingsKey,
        defaultValue ? 'true' : 'false', context);
      StatusBarSysEventUtil.reportSysUiSettingStatus(name, on === 'true' ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE);
    } catch (error) {
      log.error(`reportWeeklyState error ${settingsKey}`, error);
    }
  }
}

export class SysUiSettingReportParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public NAME?: string;
  public VALUE?: number;
}