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
import { HiSysReportEvent, ReportDomain } from './HiSysReportEvent';
import type {
  ApplicationParams,
  ClickLiveViewSwitchParams,
  DelayReportParams,
  InManageAllParams,
  ManageAllParams,
  NotificationParams,
  NtfSettingModuleClickEventParams,
  SystemMenuClickParams,
  WakeScreenParams,
} from './ReportParams';
import { ReportParams } from './ReportParams';

/**
 * 大数据维测相关打点工具类
 */
export class HiDfxEventUtil {
  public static STATE_OPEN: number = 1;
  public static STATE_CLOSE: number = 0;
  public static ENTER_PAGE: number = 1;
  public static LEAVE_PAGE: number = 2;
  public static NTF_MANAGE_PAGE: string = 'NTF_MANAGE_PAGE';
  public static SHOT_FULL_SCREEN: number = 0;
  public static TOGGLE_TYPE_CLICK: number = 0;
  public static TOGGLE_TYPE_LONG_CLICK: number = 1;
  public static TOGGLE_TYPE_INTENT: number = 2;

  /**
   * 通知管理点位
   */
  // 通知管理状态栏入口
  private static readonly NTF_MANAGEMENT_STATUS_BAR: string = 'NTF_MANAGEMENT_STATUS_BAR';
  // 通知和状态栏设置页面Title点击事件打点
  private static readonly NTF_SETTING_MODULE_CLICK_EVENT: string = 'NTF_SETTING_MODULE_CLICK_EVENT';
  // 实况窗开关切换打点
  public static readonly CLICK_LIVE_VIEW_SWITCH = 'CLICK_LIVE_VIEW_SWITCH';
  // 通知管理状态栏中纯净显示开关打点
  private static readonly SIMPLE_DISPLAY: string = 'SIMPLE_DISPLAY';
  // 通知管理状态栏中显示通知图标开关打点
  private static readonly SHOW_APP_NOTIFICATION_ICONS: string = 'SHOW_APP_NOTIFICATION_ICONS';
  // 通知管理状态栏中显示实时网速开关打点
  private static readonly SHOW_NETWORK_SPEED: string = 'SHOW_NETWORK_SPEED';
  // 隐藏通知内容开关
  private static readonly HIDE_NOTIFICATION_CONTENT: string = 'HIDE_NOTIFICATION_CONTENT';
  // 通知亮屏提示
  private static readonly WAKE_SCREEN: string = 'WAKE_SCREEN';
  // 显示桌面角标
  private static readonly SHOW_DESKTOP_BADGES: string = 'SHOW_DESKTOP_BADGES';
  // 进入批量管理
  private static readonly MANAGE_ALL: string = 'MANAGE_ALL';
  // 批量管理中操作开关
  private static readonly SWITCH_IN_MANAGE_ALL: string = 'SWITCH_IN_MANAGE_ALL';
  // 应用通知管理页面
  private static readonly APPLICATION_NOTIFICATION_MANAGEMENT: string = 'APPLICATION_NTF_MANAGEMENT';
  // 应用通知管理页面，总开关
  private static readonly NOTIFICATION_MANAGEMENT_ALLOW_NOTIFICATION: string = 'NOTIFICATION_MANAGEMENT_ALLOW';
  // 应用通知管理页面，提醒方式中锁屏通知设置
  private static readonly NOTIFICATION_STYLE_LOCK_SCREEN: string = 'NOTIFICATION_STYLE_LOCK_SCREEN';
  // 应用通知管理页面，提醒方式中横幅通知设置
  private static readonly NOTIFICATION_STYLE_BANNERS: string = 'NOTIFICATION_STYLE_BANNERS';
  // 进入、退出通知和状态栏管理页面 打点
  private static readonly NTF_MANAGEMENT: string = 'NTF_MANAGEMENT';

  /* 延迟上报的事件容器 */
  private static delayReportEventMap: Map<string, DelayReportParams> = new Map();
  private static mHiDfxEventUtil?: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCENE_BOARD_APP);

  /**
   * 进入、退出通知管理状态栏 打点
   *
   * @param state 进入状态栏：1， 退出状态栏：2
   */
  public static reportNotificationManagementStatusBar(status: number): void {
    let params: NotificationParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STATUS: status
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.NTF_MANAGEMENT_STATUS_BAR, params);
  }

  /**
   * 通知和状态栏设置页面Title点击事件打点
   *
   * @param module 通知和状态栏管理入口类型：1-实况窗 2-状态栏 3-更多通知设置
   */
  public static reportNtfSettingModuleClickEvent(module: number): void {
    let params: NtfSettingModuleClickEventParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      MODULE: module
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.NTF_SETTING_MODULE_CLICK_EVENT, params);
  }

  /**
   * 实况开关点击切换打点
   *
   * @param packageName 实况窗应用包名
   * @param status 实况窗开关状态
   * @param source 操作入口
   */
  public static reportClickLiveViewSwitch(packageName: string, status: boolean, source: string): void {
    let params : ClickLiveViewSwitchParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGE: packageName,
      STATUS: status ? 'on' : 'off',
      SOURCE: source,
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.CLICK_LIVE_VIEW_SWITCH, params);
  }

  /**
   * 纯净显示开关状态 打点
   *
   * @param switchStatus 隐藏通知内容开关状态 开关打开：1 开关关闭：0
   */
  public static reportSimpleDisplay(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.SIMPLE_DISPLAY, params);
  }

  /**
   * 显示通知图标开关状态 打点
   *
   * @param switchStatus 显示通知图标开关状态 开关打开：1 开关关闭：0
   */
  public static reportShowAppNotificationIcons(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.SHOW_APP_NOTIFICATION_ICONS, params);
  }

  /**
   * 显示实时网速开关状态 打点
   *
   * @param switchStatus 显示实时网速开关状态 开关打开：1 开关关闭：0
   */
  public static reportShowNetworkSpeed(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.SHOW_NETWORK_SPEED, params);
  }

  /**
   * 隐藏通知开关内容 打点
   *
   * @param switchStatus 隐藏通知内容开关状态 开关打开：1 开关关闭：0
   */
  public static reportHideNotificationContent(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.HIDE_NOTIFICATION_CONTENT, params);
  }

  /**
   * 通知亮屏提示 打点
   *
   * @param switchStatus 通知亮屏提示开关 开关打开：1 开关关闭：0
   */
  public static reportWakeScreen(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.WAKE_SCREEN, params);
  }
  /**
   * 显示桌面角标开关 打点
   *
   * @param switchStatus 显示桌面角标开关 开关打开：1 开关关闭：0
   */
  public static reportShowDesktopBadges(switchStatus: number): void {
    let params: WakeScreenParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.SHOW_DESKTOP_BADGES, params);
  }
  /**
   * 进入、退出批量管理 打点
   *
   * @param state 进入批量管理：1， 退出批量管理：2
   */
  public static reportManageAll(state: number): void {
    let params: ManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      STATE: state
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.MANAGE_ALL, params);
  }

  /**
   * 批量管理中操作开关 打点 记录应用包名、开启后状态
   *
   * @param bundleName 应用包名
   * @param switchStatus 开关打开：1 开关关闭：0
   */
  public static reportSwitchInManageAll(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus,
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.SWITCH_IN_MANAGE_ALL, params);
  }

  /**
   * 进入、退出 应用通知管理页面 打点，记录包名信息
   *
   * @param bundleName 应用包名
   * @param state 进入应用通知管理：1， 退出应用通知管理：2
   */
  public static reportApplicationNotificationManagement(bundleName: string, state: number): void {
    let params: ApplicationParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      STATE: state
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.APPLICATION_NOTIFICATION_MANAGEMENT, params);
  }

  /**
   * 应用通知管理页面总开关 打点，记录包名信息，操作后状态
   *
   * @param bundleName 应用包名信息
   * @param switchStatus 开关状态 开关打开：1 开关关闭：0
   */
  public static reportNotificationManagementAllowNotification(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.NOTIFICATION_MANAGEMENT_ALLOW_NOTIFICATION, params);
  }

  /**
   * 应用通知管理页面，提醒方式中锁屏通知设置 打点，记录包名信息，操作后状态
   *
   * @param bundleName 应用包名
   * @param switchStatus 开关状态 开关打开：1 开关关闭：0
   */
  public static reportNotificationStyleLockScreen(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.NOTIFICATION_STYLE_LOCK_SCREEN, params);
  }

  /**
   * 应用通知管理页面，提醒方式中横幅通知开关设置 打点，记录包名信息，操作后状态
   *
   * @param bundleName 应用包名
   * @param switchStatus 开关状态 开关打开：1 开关关闭：0
   */
  public static reportNotifyStyleBanners(bundleName: string, switchStatus: number): void {
    let params: InManageAllParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      BUNDLE_NAME: bundleName,
      SWITCH_STATUS: switchStatus
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.NOTIFICATION_STYLE_BANNERS, params);
  }

  /**
   * 进入、退出通知和状态栏管理页面 打点
   *
   * @param name 进入页面：1， 退出页面：2
   * @param eventType 页面名字
   */
  public static reportNotificationManagement(name: number, eventType: string): void {
    let params: SystemMenuClickParams = {
      PACKAGE_NAME: ReportParams.PACKAGE_NAME,
      PROCESS_NAME: ReportParams.PROCESS_NAME,
      NAME: name,
      EVENT_TYPE: eventType
    };
    HiDfxEventUtil.mHiDfxEventUtil?.reportBehavior(HiDfxEventUtil.NTF_MANAGEMENT, params);
  }
}