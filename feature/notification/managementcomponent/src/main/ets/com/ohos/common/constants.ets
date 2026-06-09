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

export default class Constants {
  public static WH_20_100 = '20%';
  public static WH_45_100 = '45%';
  public static WH_50_100 = '50%';
  public static WH_60_100 = '60%';
  public static WH_70_100 = '70%';
  public static WH_80_100 = '80%';
  public static WH_90_100 = '90%';
  public static WH_100_100 = '100%';
  public static HT_100_100 = '100%';
  public static MAX_LINES_1 = 1;
  public static MAX_LINES_2 = 2;
  public static MAX_LINES_3 = 3;
  public static TIME_EMPTY = '00:00';
  public static DATE_YEAR_IDX = 0;
  public static DATE_MONTH_IDX = 1;
  public static DATE_DAY_IDX = 2;
  public static DATE_HOUR_IDX = 3;
  public static DATE_MINUTE_IDX = 4;
  public static ENABLE_COMP_IMAGE_RATIO = 0.5;
  public static ENABLE_COMP_IMAGE_RATIO_PAD = 1.5;
}

export class PageConstants {
  public static NTF_AND_STATUS_BAR_PATH = 'pages/ntfAndStatusBar';
  public static HOME_NAVIGATION_VIEW_PATH = 'pages/HomeNavigationView';
  public static STATUS_BAR_SETTING_PATH = 'pages/StatusBarSetting';
  public static NTF_MORE_SETTING_PATH = 'pages/NtfMoreSetting';
  public static NTF_MGMT_VIEW_PATH = 'pages/NotificationMgmtView';
  public static NTF_MGMT_VIEW_TV_PATH = 'pages/NotificationMgmtViewTv';
  public static NTF_MGMT_HALF_PATH = 'pages/NotificationMgmtHalfModeView';
  public static NTF_AND_STATUS_BAR_PC_PATH = 'pages/ntfAndStatusBarPC';
  public static NTF_LIVE_VIEW_SWITCH_PAGE_PATH = 'pages/NtfLiveViewSwitchPage';
  public static META_SERVICE_MGMT_VIEW_PATH = 'pages/MetaServiceMgmtView';

  public static NTF_AND_STATUS_BAR_NAME = 'NtfAndStatusBar';
  public static STATUS_BAR_SETTING_NAME = 'StatusBarSetting';
  public static NTF_MORE_SETTING_NAME = 'NtfMoreSetting';
  public static NTF_MGMT_VIEW_NAME = 'NtfMgmtView';
  public static NTF_SEARCH_NAME = 'NtfSearchPage';
  public static NTF_LIVE_VIEW_SWITCH_PAGE_NAME = 'NtfLiveViewSwitchPage';
  public static META_SERVICE_MGMT_VIEW_NAME = 'MetaServiceMgmtView';

  private static VALID_SUB_PAGES = new Set([
    PageConstants.STATUS_BAR_SETTING_NAME,
    PageConstants.NTF_MORE_SETTING_NAME,
    PageConstants.NTF_MGMT_VIEW_NAME,
    PageConstants.NTF_SEARCH_NAME,
    PageConstants.NTF_LIVE_VIEW_SWITCH_PAGE_NAME,
    PageConstants.META_SERVICE_MGMT_VIEW_NAME
  ]);

  static isValidSubPage(subPageName?: string): boolean {
    if (subPageName === undefined) {
      return false;
    }
    return PageConstants.VALID_SUB_PAGES.has(subPageName);
  }
}

/**
 * The type of the Do Not Disturb.
 *
 * @since 8
 * @systemapi Hide this for inner system use.
 */
export enum DoNotDisturbType {
  /**
   * Non do not disturb type notification
   */
  TYPE_NONE = 0,

  /**
   * Execute do not disturb once in the set time period (only watch hours and minutes)
   */
  TYPE_ONCE = 1,

  /**
   * Execute do not disturb every day with a set time period (only watch hours and minutes)
   */
  TYPE_DAILY = 2,

  /**
   * Execute in the set time period (specify the time, month, day and hour)
   */
  TYPE_CLEARLY = 3,
}

export const INDEXER_ARRAY: string[] = [
  '#',
  'A', 'B', 'C', 'D', 'E', 'F', 'G',
  'H', 'I', 'J', 'K', 'L', 'M', 'N',
  'O', 'P', 'Q', 'R', 'S', 'T',
  'U', 'V', 'W', 'X', 'Y', 'Z',
];

export enum NtfManagementTrace {
  TRACE_PROCESS_INIT = 'PROCESS_INIT',
  TRACE_LOAD_APP_LIST = 'LOAD_APP_LIST',
}

/**
 * 指纹传感器类型
 */
export enum FingerprintType {
  NONE,
  UNDER_SCREEN_SENSOR_LOW,
  UNDER_SCREEN_SENSOR_HIGH,
  OUT_OF_SCREEN_SENSOR,
  BOTH_SENSOR
}


/**
 * 显示锁屏通知内容的开关状态
 */
export enum AppNtfConfigShowContentKGStatus {
  /** 始终 */
  ALWAYS = 0,
  /** 仅机主注视时 */
  ONLY_OWNER = 1,
  /** 已解锁时 */
  UNLOCKED = 2,
}

/**
 * 系统设置相关Key常量
 */
export class SettingsKeyConstants {
  /* 锁定时显示通知预览 (原锁屏隐藏通知内容)  */
  public static readonly APP_NTF_CONFIG_HIDE_CONTENT: string = 'app_ntf_config_hide_content';
  /* 显示锁屏通知内容 */
  public static readonly APP_NTF_CONFIG_SHOW_CONTENT_KG: string = 'app_ntf_config_show_content_kg';
  /* 锁定时显示实况窗预览  */
  public static readonly APP_LIVE_VIEW_CONFIG_HIDE_CONTENT: string = 'app_live_view_config_hide_content';
  /* 熄屏收到通知亮屏设置的key */
  public static readonly APP_NTF_CONFIG_SCREEN_ON: string = 'app_ntf_config_screen_on';
  /* 锁屏通知显示样式设置的key */
  public static readonly NTF_SCREEN_LOCK_STYLE: string = 'ntf_screen_lock_style';
  /* 智能提醒 */
  public static readonly APP_NTF_CONFIG_HIDE_BANNER_CONTENT: string = 'app_ntf_config_hide_banner_content';
  /* 显示桌面角标设置的key */
  public static readonly APP_NTF_CONFIG_SHOW_DESKTOP_BADGES: string = 'ntf_config_show_desktop_badges';
  /* 状态栏纯净显示 */
  public static readonly STATUS_BAR_PURE_SHOW: string = 'status_bar_pure_show';
  /* 状态栏显示通知图标 */
  public static readonly STATUS_BAR_SHOW_NOTIFICATION_ICON: string = 'status_bar_show_notification_icon';
  /* 状态栏显示实时网速 */
  public static readonly STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED: string = 'status_bar_show_real_time_network_speed';
  /* 状态栏通知图标最近一次用户手动设置的状态 */
  public static readonly NOTIFICATION_ICON_LAST_SWITCH_STATE: string = 'notification_icon_last_switch_state';
  /* 状态栏实时网速最近一次用户手动设置的状态 */
  public static readonly REAL_TIME_NETWORK_SPEED_LAST_SWITCH_STATE: string = 'real_time_network_speed_last_switch_state';
  /* 通知和状态栏搜索历史列表 */
  public static readonly NTF_SEARCH_HISTORY_LIST: string = 'ntf_search_history_list';
  /* 横幅免打扰的存储value名称 */
  public static readonly BANNER_NO_DISTURB: string = 'banner_not_disturb';
  /* 指纹类型 */
  public static readonly FINGERPRINT_TYPE_KEY: string = 'fingerprint_type';
  /* 实时网速 */
  public static readonly SHOW_REAL_TIME_NETWORK_SPEED: string = 'show_real_time_network_speed';
  /* VPN显示开关 */
  public static readonly SHOW_VPN_ICON: string = 'show_vpn_icon';
  /* 响铃 */
  public static readonly SHOW_RING_MODE_ICON: string = 'show_ring_mode_icon';
  /* 星闪和蓝牙 */
  public static readonly SHOW_NEARLINK_ICON: string = 'show_nearlink_icon';
  /* 闹钟 */
  public static readonly SHOW_ALARM_CLOCK_ICON: string = 'show_alarm_clock_icon';
  /* nfc */
  public static readonly SHOW_NFC_ICON: string = 'show_nfc_icon';
  /* 有线耳机 */
  public static readonly SHOW_HEAD_PHONES_ICON: string = 'show_head_phones_icon';
}
/**
 * 系统设置相关常量
 */
export class SettingsConstants {
  /* 锁屏是否隐藏通知内容 默认设置 开关为关 */
  public static readonly APP_NTF_HIDE_CONTENT_DEFAULT: boolean = true;
  /* 显示锁屏通知内容 默认设置 选项为 已解锁时 ; 0始终 | 1仅机主注视时 | 2已解锁时 */
  public static readonly APP_NTF_CONFIG_SHOW_CONTENT_DEFAULT: string = '2';
  /* 锁屏是否隐藏实况窗内容 默认设置 */
  public static readonly APP_LIVE_VIEW_HIDE_CONTENT_DEFAULT: boolean = false;
  /* 熄屏状态下收到通知是否亮屏 默认设置 */
  public static readonly APP_NTF_SCREEN_ON_DEFAULT: boolean = false;
  /* 锁屏通知显示样式 默认高位展示 */
  public static readonly NTF_LOCK_SCREEN_STYLE_UPPER: boolean = false;
  /* 智能提醒开关 默认为关 */
  public static readonly APP_NTF_CONFIG_HIDE_BANNER_CONTENT_DEFAULT: string = '0';
  /* 显示桌面角标 默认为开 */
  public static readonly NTF_SHOW_DESKTOP_BADGES_DEFAULT: boolean = true;
  /* 状态栏纯净显示 默认设置 */
  public static readonly STATUS_BAR_PURE_SHOW_DEFAULT: boolean = false;
  /* 状态栏显示通知图标 默认设置 */
  public static readonly STATUS_BAR_SHOW_NOTIFICATION_ICON_DEFAULT: boolean = true;
  /* 状态栏显示实时网速 默认设置 */
  public static readonly STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED_DEFAULT: boolean = false;
  /* 状态栏通知图标最近一次用户手动设置的状态 默认设置 */
  public static readonly NOTIFICATION_ICON_LAST_SWITCH_STATE_DEFAULT: string = 'true';
  /* 状态栏实时网速最近一次用户手动设置的状态 默认设置 */
  public static readonly REAL_TIME_NETWORK_SPEED_LAST_SWITCH_STATE_DEFAULT: string = 'false';
}

/**
 * 通知中心和状态栏标签页选中页面
 */
export enum SegmentSelectedIndex {
  /* 应用 */
  APP = 0,
  /* 元服务 */
  MEAT_SERVICE = 1,
}