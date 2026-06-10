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

import settings from '@ohos.settings';
import Window from '@ohos.window';

interface AppNotificationTable {
  tableName: string;
  sqlCreate: string;
  columns: string[];
}

export default class Constants {
  static readonly URI_VAR: string = 'datashare:///com.ohos.settingsdata.DataAbility';
  static readonly KEY_BRIGHTNESS_STATUS = settings.display.SCREEN_BRIGHTNESS_STATUS;
  static readonly KEY_TIME_FORMAT = settings.date.TIME_FORMAT;
  static readonly KEY_NAVIGATIONBAR_STATUS = 'settings.display.navigationbar_status';
  static readonly KEY_TOGGLE_DATA = 'settings.control.toggle_data';
  static readonly KEY_TOP_TOGGLE_DATA = 'settings.control.top_toggle_data';
  static readonly KEY_TOGGLE_DATA_CLONE = 'settings.control.toggle_data_clone';
  static readonly KEY_TOP_TOGGLE_DATA_CLONE = 'settings.control.top_toggle_data_clone';
  static readonly KEY_QUICK_TOGGLE_DATA_EDITED = 'settings.control.quick_toggle_data_edited';

  /**
   * 实况日志前缀
   */
  static readonly NTF_LOG_PREFIX: string = '[LiveView]';

  /**
   * 图标缩放宽度
   */
  static readonly APP_ICON_STANDARD_WIDTH: number = 192;
  /**
   * 图标缩放高度
   */
  static readonly APP_ICON_STANDARD_HEIGHT: number = 192;

  /**
   * SystemUI图标缩放宽度
   */
  static readonly APP_ICON_SYSTEMUI_WIDTH: number = 96;

  /**
   * UX 老资源文件，图片规格是288的图标，有效内容只有192宽，需要做1.5倍裁剪
   */
  static readonly APP_ICON_FULL_SIZE: number = 288;

  /**
   * UX 老资源文件，图片规格是288的图标，有效内容只有192宽，需要做1.5倍裁剪, x y的偏移值为 (288-192) /2
   */
  static readonly APP_ICON_FULL_OFFSET: number = (this.APP_ICON_FULL_SIZE - this.APP_ICON_STANDARD_WIDTH) / 2;

  /**
   * 图标缩放宽度vp
   */
  static readonly APP_ICON_STANDARD_SIZE: number = 58;

  /**
   * 图标最大尺寸, 单位:vp
   */
  static readonly APP_ICON_MAX_SIZE: number = 67;

  /**
   * 图标最小尺寸, 单位:vp
   */
  static readonly APP_ICON_MIN_SIZE: number = 52;

  /**
   * Default invalid value.
   */
  static INVALID_VALUE = -1;

  /**
   * 悬浮导航切换开发
   */
  static readonly FLOATING_NAVIGATION_KEY: string = 'floatingNavigation';

  /**
   * 三键导航CCM配置
   */
  static readonly FLOATING_NAVIGATION_CCM_KEY: string = 'floating_navigation_ccm';

  /**
   * 悬浮球CCM配置
   */
  static readonly FLOATING_NAVIGATION_BALL_CCM_KEY: string = 'floating_navigation_ball_ccm';

  /**
   * 手势导航开关默认值
   */
  static readonly SYSTEM_NAVIGATION_GESTURE: string = '1';

  /**
   * 悬浮导航开发开启
   */
  static readonly SYSTEM_NAVIGATION_FLOATING: string = '0';

  // 升级前的导航类型
  static readonly OLD_NAVIGATION_TYPE_KEY = 'secure_gesture_navigation';

  // 设置domainName
  static readonly NAV_SETTING_DOMAIN: string = settings.domainName.DEVICE_SHARED;

  // 初始化导航条默认高度
  static readonly ohos_GESTURE_BOTTOM_HEIGHT: string = 'ohos_gesture_bottom_height';

  /**
   * 获取拼接后的uri，适配settingsdata去常驻
   *
   * @param key settings key
   */
  static getUriSync(key: string): string {
    return 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=' + key;
  }

  /**
   * 获取拼接后的uri，适配settingsdata.secure去常驻
   *
   * @param key settings key
   */
  static getSettingsSecureUriSync(key: string, userId: number): string {
    return `datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_${userId}?Proxy=true&key=${key}`;
  }

  /**
   * App Notificaiton table config.
   */
  static readonly APP_NOTIFICATION_TABLE: AppNotificationTable = {
    tableName: 'appNotificationTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS appNotificationTable(' +
      'id INTEGER AUTO INCREMENT, ' +
      'appBundle TEXT NOT NULL, ' +
      'uid TEXT, ' +
      'key TEXT PRIMARY KEY, ' +
      'bannerNotifyEnable INTEGER, ' +
      'lockNotifyEnable INTEGER, ' +
      'pinTopEnable INTEGER, ' +
      'soundEnable INTEGER, ' +
      'vibrationEnable INTEGER' +
      ')',
    columns: [
      'id',
      'appBundle',
      'uid', 'key',
      'bannerNotifyEnable',
      'lockNotifyEnable',
      'pinTopEnable',
      'soundEnable',
      'vibrationEnable'
    ]
  };
}

/**
 * 窗口常量， 是从 WindowManagerProxy 类中迁移过来的
 */
export class WindowConstants {
  /**
   * 窗口名称 - 状态栏
   */
  static readonly WINDOW_NAME_STATUS_BAR: string = 'SysUI_StatusBar';
  /**
   * 窗口名称 - 顶部热区手势栏
   */
  static readonly WINDOW_NAME_GESTURE_TOP_BAR: string = 'WINDOW_NAME_GESTURE_TOP_BAR';

  /**
   * 窗口名称 - 下拉面板
   */
  static readonly WINDOW_NAME_DROPDOWN: string = 'SysUI_Dropdown';

  /**
   * 窗口名称 - 实况面板
   */
  static readonly WINDOW_NAME_LIVEVIEW: string = 'SysUI_Liveview_Panel';

  /**
   * 窗口名称 - 音量条
   */
  static readonly WINDOW_NAME_VOLUME: string = 'SysUI_Volume';

  /**
   * 窗口名称 - 亮度
   */
  static readonly WINDOW_NAME_BRIGHTNESS: string = 'SysUI_Brightness';

  /**
   * 窗口名称 - 横幅通知
   */
  static readonly WINDOW_NAME_BANNER: string = 'SysUI_Notification_Banner';

  /**
   * 窗口名称 - 鼠标右键设置窗口
   */
  static readonly WINDOW_NAME_PC_NTY_SETTING: string = 'SysUI_Notification_Setting';

  /**
   * 窗口名称 - 分屏条
   */
  static readonly WINDOW_NAME_SPLIT_BAR: string = 'SysUI_Split_Bar';

  /**
   * 窗口名称 - 锁屏窗口
   */
  static readonly WINDOW_NAME_LOCK_SCREEN: string = 'ScreenLockWindow';

  /**
   * 窗口名称 - 隐私指示器窗口
   */
  static readonly WINDOW_NAME_PRIVACY_INDICATOR: string = 'PrivacyIndicator';

  /**
   * 窗口默认背景颜色，透明
   */
  static readonly DEFAULT_BG_COLOR = '#00000000';

  static readonly DEFAULT_BG_SATURATE = 1.7;

  /**
   * 模糊背景颜色
   */
  static readonly BLUR_BG_COLOR = '#99FAFAFA';

  /**
   * 模糊半径
   */
  static readonly BLUR_RADIUS = 60;

  /**
   * PC状态栏二级页面背景饱和度
   */
  static readonly PC_SECONDARY_WINDOW_SATURATE = 1;

  /**
   * 阴影颜色
   */
  static readonly SHADOW_COLOR = '#14000000';

  /**
   * PC状态栏二级页面阴影颜色
   */
  static readonly PC_SECONDARY_WINDOW_SHADOW_COLOR = '#26000000';

  /**
   * 阴影模糊半径
   */
  static readonly SHADOW_RADIUS = 14;

  /**
   * PC二级页面阴影模糊半径
   */
  static readonly PC_SECONDARY_WINDOW_SHADOW_RADIUS = 50;

  /**
   * 阴影X偏移
   */
  static readonly SHADOW_OFFSET_X = 0;

  /**
   * 阴影Y偏移
   */
  static readonly SHADOW_OFFSET_Y = 7;

  /**
   * PC二级页面阴影Y偏移
   */
  static readonly PC_SECONDARY_WINDOW_SHADOW_OFFSET_Y = 0;

  /**
   * 隐私提示圆点所占窗口高度，单位px
   */
  static readonly PRIVACY_INDICATOR_BAR_HEIGHT = 32;

  /**
   * 横幅窗口背景色
   */
  static readonly BANNER_BG_COLOR = '#00000000';

  /**
   * 横幅窗口模糊材质
   */
  static readonly BANNER_BLUR_STYLE = Window.BlurStyle.REGULAR;

  /**
   * 横幅窗口投影X方向偏移
   */
  static readonly BANNER_SHADOW_OFFSET_X = 0;

  /**
   * 横幅窗口投影Y方向偏移
   */
  static readonly BANNER_SHADOW_OFFSET_Y = 10;

  /**
   * 横幅窗口投影颜色
   */
  static readonly BANNER_SHADOW_COLOR = '#4D000000';

  /**
   * 横幅窗口投影半径，单位VP
   */
  static readonly BANNER_SHADOW_RADIUS = 50;

  /**
   * PC状态栏二级窗口圆角半径
   */
  static readonly WINDOW_CORNER_RADIUS = 20;

  /**
   * PC状态栏二级窗口内边框圆角半径
   */
  static readonly WINDOW_CORNER_INNER_RADIUS = '24px';

  /**
   * pc dock hover 预览窗
   */
  static readonly WINDOW_NAME_DOCK_POPUP_PANEL: string = 'SCBPopupPanel';
  static readonly WINDOW_NAME_DOCK_EXT_POPUP_PANEL: string = 'SCBExtPopupPanel';
  static readonly WINDOW_NAME_LOCK_SCREEN_WIFI_PANEL: string = 'SCBScreenLockWifiPanel';
  /**
   * 默认窗口圆角
   */
  static getDefaultRadius(): number {
    return vp2px(18);
  }

  /**
   * PC状态栏二级页面窗口圆角半径
   */
  static getPcSecondaryWindowRadius(): number {
    return Number(vp2px(WindowConstants.WINDOW_CORNER_RADIUS));
  }
}

// 初始化隐藏app配置文件类型 1.开机时加载系统预装的隐藏配置;2.oobe修改完隐藏配置刷新桌面重新加载
export enum LoadHideAppType {
  // 1.开机时加载系统预装的隐藏配置
  LOAD_BY_REBOOT = 1,
  // 2.oobe修改完隐藏配置刷新桌面重新加载
  LOAD_BY_REFRESH = 2
}

// 隐藏应用后是否自动补齐桌面布局 0:不补齐,1:默认补齐
export enum HideAppAutoAlignStatus {
  // 0:不补齐
  NOT_AUTO_ALIGN = 0,
  // 1:默认补齐
  AUTO_ALIGN = 1
}

// 企业设备配置信息
export enum EnterpriseConfig {
  // 是否为企业设备
  IS_ENTERPRISE_DEVICE = 'const.edm.is_enterprise_device',
  // 企业定制隐藏应用列表
  ENTERPRISE_CUSTOM_HIDE_APP_LIST = 'com.enterprise.custom_hide_app_list'
}

export enum PowerStatus {
  RUNNING,
  SHUTDOWN,
  REBOOT,
  HIBERNATE,
  LOGOUT,
  CHANGE_MODE
};

export enum FASlotName {
  AUTO_ROTATE = 'auto_rotate',
  AIR_PLANE = 'air_plane',
  BLUETOOTH = 'bluetooth',
  LOCATION = 'location',
  RING_MODE = 'ring_mode',
  CAMERA = 'camera',
  MIC = 'mic',
  WIFI = 'wifi',
  NFC = 'nfc',
  DARK_MODE = 'dark_mode',
  HOTSPOT = 'hotspot',
  HOTSPOT_TAGGED = 'hotspot_tagged',
  MOBILE_DATA = 'mobile_data',
  MOBILE_DATA_TAGGED = 'mobile_data_tagged',
  FLASHLIGHT = 'flashlight',
  CAST = 'HuaweiCastToggle',
  SUPER_PRIVACY = 'super_privacy',
  SHARE = 'share',
  WIFI_UI_EXTENSION = 'wifi_ui_extension',
  BLUETOOTH_UI_EXTENSION = 'bluetooth_ui_extension',
  BRIGHTNESS = 'brightness',
  EYE_COMFORT = 'eye_comfort',
  SUPER_HUB = 'super_hub',
  MULTI_WINDOW = 'multi_window',
  POWER_SAVE = 'power_save',
  NEAR_LINK = 'near_link',
  SOUND = 'sound',
  COMBINED_SLIDER = 'combined_slider',
  MUSIC_SERVICE = 'music_service',
  FOCUS_MODE = 'focus_mode',
  SCENARIO_MODE = 'scenario_mode',
  YOUTH_MODE = 'youth_mode',
  SUPER_DEVICE = 'super_device',
  DPIN = 'dpin',
  MEETING = 'meeting',
  EBOOK = 'ebook',
  SOUND_RECORDER = 'sound_recorder',
  CALCULATOR = 'calculator',
  CLOCK_TIMER = 'clock_timer',
  REMOTE_CONTROL = 'remote_control',
  KEY_MOUSE_SHARE = 'key_mouse_share',
  CAMERA_OPEN = 'camera_open',
  WLTX = 'wltx',
  ANTI_PEEPING = 'anti_peeping',
  QUICK_REMIND = 'quick_remind',
  SCREEN_RECORDER = 'toggle_screen_recorder',
  SCREENSHOT = 'toggle_screenshot',
  MEDIA_ITEM_NAME = 'mediaCard',
  COMPUTER_MODE = 'computer_mode',
  QUICK_NOTE = 'quick_note',
}

export enum CallToState {
  UNKNOWN = 0,
  FOREGROUND,
  BACKGROUND
}

/**
 * 面板状态变化常量
 */
export class SystemUIPanelConstants {
  /**
   * 面板下拉状态变化公共事件
   */
  static readonly SYSTEMUI_PANEL_STATUS: string = 'COMMON_EVENT_SYSTEMUI_PANEL_STATUS_CHANGED';

  /**
   * 面板显示
   */
  static readonly SYSTEMUI_PANEL_SHOW: string = 'true';

  /**
   * 面板隐藏
   */
  static readonly SYSTEMUI_PANEL_HIDE: string = 'false';
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
  /* 智能提醒侧的业务开关 */
  static readonly ADVISOR_SWITCH_ENABLE: string = 'advisor_switch_enable';
  /* 用户阅读通知消息或推荐次数达到阈值 */
  static readonly IS_DESK_FOLDER_REMIND: string = 'is_desk_folder_remind';
  /* 用户是否使用过尺寸调节 */
  static readonly IS_DESK_FOLDER_SIZECHANGED: string = 'is_desk_folder_sizechanged';
  /* 屏幕指纹动画样式的key */
  static readonly SCREEN_FINGER_ANIMATE_STYLE: string = 'screen_finger_animate_style';
  /* 锁定时显示通知预览 (原锁屏隐藏通知内容)  */
  static readonly APP_NTF_CONFIG_HIDE_CONTENT: string = 'app_ntf_config_hide_content';
  /* 锁定时显示实况窗预览  */
  static readonly APP_LIVE_VIEW_CONFIG_HIDE_CONTENT: string = 'app_live_view_config_hide_content';
  /* 熄屏收到通知亮屏设置的key */
  static readonly APP_NTF_CONFIG_SCREEN_ON: string = 'app_ntf_config_screen_on';
  /* 锁屏通知显示样式设置的key */
  static readonly NTF_SCREEN_LOCK_STYLE: string = 'ntf_screen_lock_style';
  /* 智能提醒 */
  static readonly APP_NTF_CONFIG_HIDE_BANNER_CONTENT: string = 'app_ntf_config_hide_banner_content';
  /* 显示锁屏通知内容 */
  static readonly APP_NTF_CONFIG_SHOW_CONTENT_KG: string = 'app_ntf_config_show_content_kg';
  /* 显示桌面角标设置的key */
  static readonly APP_NTF_CONFIG_SHOW_DESKTOP_BADGES: string = 'ntf_config_show_desktop_badges';
  /* 状态栏纯净显示 */
  static readonly STATUS_BAR_PURE_SHOW: string = 'status_bar_pure_show';
  /* 状态栏显示通知图标 */
  static readonly STATUS_BAR_SHOW_NOTIFICATION_ICON: string = 'status_bar_show_notification_icon';
  /* 状态栏显示实时网速 */
  static readonly STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED: string = 'status_bar_show_real_time_network_speed';
  /* 状态栏电池显示电量百分比 */
  static readonly STATUS_BAR_SHOW_BATTERY_SOC: string = 'status_bar_show_battery_soc';
  /* 关怀模式下纯净显示 */
  static readonly STATUS_BAR_PURE_ELDER_CARE_SET: string = 'status_bar_pure_elder_care_set';
  /* 状态栏通知图标最近一次用户手动设置的状态 */
  static readonly NOTIFICATION_ICON_LAST_SWITCH_STATE: string = 'notification_icon_last_switch_state';
  /* 状态栏实时网速最近一次用户手动设置的状态 */
  static readonly REAL_TIME_NETWORK_SPEED_LAST_SWITCH_STATE: string = 'real_time_network_speed_last_switch_state';
  /* 闪烁提醒开关 */
  static readonly ACCESSIBILITY_FLASH_REMINDER_SWITCH: string = 'accessibility_flash_reminder_switch';
  /* 通知闪烁开关 */
  static readonly ACCESSIBILITY_REMINDER_FUNCTION_ENABLED: string = 'accessibility_reminder_function_enabled';

  /* Oobe settings */
  static readonly DEVICE_PROVISIONED: string = 'device_provisioned';
  /* 移动数据开关 */
  static readonly CELLULAR_DATA_ENABLE: string = 'cellular_data_enable';
  /* 护眼模式开关 */
  static readonly EYE_SHIELD_ENABLE: string = 'settings.eyeshield.enable';
  /* 护眼模式MODE:0-全天关闭 1-全天开启 2-定时开启 3-日落到日出开启 4-智能护眼*/
  static readonly EYE_COMFORT_MODE: string = 'settings.display.eye_comfort_mode';
  /* 上一次护眼模式开启的模式 */
  static readonly LAST_EYE_COMFORT_MODE: string = 'settings.display.eye_comfort_last_mode';
  /* 上一次护眼模式定时开启的模式 */
  static readonly LAST_EYE_COMFORT_SCHEDULED_MODE: string = 'settings.display.eye_comfort_mode_old';
  /* 护眼模式自定义定时起始时间 */
  static readonly EYE_COMFORT_START_TIME: string = 'settings.display.eye_comfort_starttime';
  /* 护眼模式自定义定时结束时间 */
  static readonly EYE_COMFORT_END_TIME: string = 'settings.display.eye_comfort_endtime';
  /* 电子书模式开关 */
  static readonly EBOOK_SWITCH: string = 'settings.display.ebook_switch';
  /* 电子书模式状态 */
  static readonly EBOOK_MODE: string = 'settings.display.ebook_mode';
  /* ota升級前版本 */
  static readonly OTA_OLD_VERSION: string = 'settings.control.ota_old_version';
  /* 克隆旧机SCB版本 */
  static readonly RESTORE_OLD_SCB_VERSION: string = 'settings.control.restore_old_scb_version';
  /* 专注模式开关 */
  static readonly FOCUS_MODE_ENABLE: string = 'focus_mode_enable';
  /* 情景模式ID 0-关闭 1-免打扰开启 2-睡眠模式开启 3-学习模式开启 */
  static readonly FOCUS_MODE_PROFILE_URI: string = 'focus_mode_profile';
  /* 中转站控制中心开关 */
  static readonly SUPERHUB_TOGGLE_ENABLE: string = 'controlcenter_toggle_superhub';
  /* 互联互通服务开关 */
  static readonly MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH: string = 'settings.collaboration.multi_device_collaboration_service_switch';
  /* 通知铃声开关 */
  static readonly NOTIFICATION_TONE_ENABLE: string = 'settings.notificationTone.enable';
  /* 听歌识曲开关 */
  static readonly MUSIC_SERVICE_TOGGLE_STATE_KEY: string = 'humsearch_state';
  /* 听歌识曲隐私签署 */
  static readonly MUSIC_SERVICE_TOGGLE_PRIVACY_AGREEMENT: string = 'humsearch_privacyagreement';
  /* whether oobe is finished in ota scene */
  static readonly IS_OTA_FINISHED: string = 'is_ota_finished';
  /* old version for ota scene */
  static readonly BUILD_VERSION_RELEASE: string = 'buildversionrelease';
  /* whether user setup complete for ota scene */
  static readonly USER_SETUP_COMPLETE: string = 'user_setup_complete';
  /* 同意OOBE的协议与声明 */
  static readonly BASIC_STATEMENT_AGREED: string = 'basic_statement_agreed';
  /* 健康使用手机开关 */
  static readonly PARENT_CONTROL_SWITCH: string = 'parent_control_switch';
  /* 通知修改桌面图标大小 */
  static readonly DESKTOP_ICON_CHANGESIZE: string = 'desktopIconChangeSize';
  /* 桌面图标是否显示名称 */
  static readonly IS_DESKTOP_ICON_SHOWNAME: string = 'isDesktopIconShowName';
  /* 通知和状态栏搜索历史列表 */
  static readonly NTF_SEARCH_HISTORY_LIST: string = 'ntf_search_history_list';
  /* 仙人掌开关 */
  static readonly SATELLITE_MODE_SWITCH: string = 'satellite_mode_switch';
  /* 自由窗口开关 */
  static readonly WINDOW_PCMODE_SWITCH_STATUS: string = 'window_pcmode_switch_status';
  /* UIExtension拉起标识 */
  static readonly SCREENLOCK_ARTSIGN_AIGC_STATUS: string = 'screenlock_artsign_aigc_status';
  /* 自由窗口模式持久化DPI */
  static readonly PC_MODE_PERSISTENT_DPI: string = 'window_pc_mode_persistent_dpi';
  /* pad模式持久化DPI */
  static readonly PAD_MODE_PERSISTENT_DPI: string = 'window_pad_mode_persistent_dpi';
  /* sample */
  static readonly IS_SAMPLEMANAGER_CHECKED: string = 'is_samplemanager_checked';
   /* 通信共享开关 */
  static readonly DISTRIBUTED_MODEM_STATE: string = 'distributed_modem_state';
  /* 是否在线主题*/
  static readonly IS_ONLINE_THEME: string = 'is_online_theme';
  /* 主题ID */
  static readonly THEME_ID: string = 'theme_id';
  /* 主题切换状态 */
  static readonly THEME_CHANGE_STATUS: string = 'theme_change_status';
  /* 无线防盗值守状态 */
  static readonly ANTI_THEFT_STATE: string = 'wireless_anti-theft_duty_state';
  /* 无线防盗主机MAC */
  static readonly ANTI_THEFT_HOST: string = 'wireless_anti-theft_host_address';
  /* 横幅免打扰的存储value名称 */
  static readonly BANNER_NO_DISTURB: string = 'banner_not_disturb';
  /* 设备类型 */
  static readonly DEVICE_TYPE: string = 'device_type';
  /* 手写笔防误触开关 */
  static readonly FORBIDDEN_GESTURE_SWITCH_STATE: string = 'forbidden_gesture_switch_state';
  /* 响铃时振动开关 */
  static readonly VIBRATE_SWITCH: string = 'ohos_vibrate_when_ringing';
  /* 折叠屏扣合警示音开关 */
  static readonly SCREEN_CLOSED_WARNING_TONE_SWITCH: string = 'screen_closed_warning_tone_switch';
  /* 防窥MODE:0-开启 */
  static readonly ANTI_PEEPING_STATUS: string = 'ANTI_PEEPING_STATUS';
  /* 实时网速 */
  static readonly SHOW_REAL_TIME_NETWORK_SPEED: string = 'show_real_time_network_speed'
  /* VPN显示开关 */
  static readonly SHOW_VPN_ICON: string = 'show_vpn_icon'
  /* 响铃 */
  static readonly SHOW_RING_MODE_ICON: string = 'show_ring_mode_icon'
  /* 星闪和蓝牙 */
  static readonly SHOW_NEARLINK_ICON: string = 'show_nearlink_icon'
  /* 闹钟 */
  static readonly SHOW_ALARM_CLOCK_ICON: string = 'show_alarm_clock_icon'
  /* nfc */
  static readonly SHOW_NFC_ICON: string = 'show_nfc_icon'
  /* 有线耳机 */
  static readonly SHOW_HEAD_PHONES_ICON: string = 'show_head_phones_icon'
}

/**
 * 系统设置相关常量
 */
export class SettingsConstants {
  /* 锁屏是否隐藏通知内容 默认设置 开关为关 */
  static readonly APP_NTF_HIDE_CONTENT_DEFAULT: boolean = true;
  /* 显示锁屏通知内容 默认设置 选项为 已解锁时 ; 0始终 / 1仅机主注视时 / 2已解锁时 */
  static readonly APP_NTF_CONFIG_SHOW_CONTENT_DEFAULT: string = '2';
  /* 锁屏是否隐藏实况窗内容 默认设置 */
  static readonly APP_LIVE_VIEW_HIDE_CONTENT_DEFAULT: boolean = false;
  /* 熄屏状态下收到通知是否亮屏 默认设置 */
  static readonly APP_NTF_SCREEN_ON_DEFAULT: boolean = false;
  /* 锁定时显示预览 默认设置 */
  static readonly APP_NTF_DISPLAY_PREVIEW_DEFAULT: boolean = false;
  /* 锁屏通知显示样式 默认高位展示 */
  static readonly NTF_LOCK_SCREEN_STYLE_UPPER: boolean = false;
  /* 智能提醒开关 默认为关 */
  static readonly APP_NTF_CONFIG_HIDE_BANNER_CONTENT_DEFAULT: string = '0';
  /* 显示桌面角标 默认为开 */
  static readonly NTF_SHOW_DESKTOP_BADGES_DEFAULT: boolean = true;

  /* 单个app横幅通知 默认设置 */
  static readonly BANNER_NTF_DEFAULT: number = 1;
  /* 单个app锁屏通知 默认设置 */
  static readonly LOCK_NTF_DEFAULT: number = 1;

  /* 开关打开 */
  static readonly SWITCH_OPEN: number = 1;

  /* 开关关闭 */
  static readonly SWITCH_CLOSE: number = 0;

  /* false字符串 */
  static readonly FALSE_STRING: string = 'false';
  /* true字符串 */
  static readonly TRUE_STRING: string = 'true';

  /* 状态栏纯净显示 默认设置 */
  static readonly STATUS_BAR_PURE_SHOW_DEFAULT: boolean = false;
  /* 状态栏显示通知图标 默认设置 */
  static readonly STATUS_BAR_SHOW_NOTIFICATION_ICON_DEFAULT: boolean = true;
  /* 状态栏显示实时网速 默认设置 */
  static readonly STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED_DEFAULT: boolean = false;
  /* 状态栏电池显示电量百分比 phone默认开启*/
  static readonly STATUS_BAR_SHOW_BATTERY_SOC_PHONE_DEFAULT: boolean = true;
  /* 状态栏电池显示电量百分比 pc默认关闭*/
  static readonly STATUS_BAR_SHOW_BATTERY_SOC_PC_DEFAULT: boolean = false;
  /* 关怀模式下纯净显示 默认设置 */
  static readonly STATUS_BAR_PURE_ELDER_CARE_SET_DEFAULT: string = 'false';
  /* 状态栏通知图标最近一次用户手动设置的状态 默认设置 */
  static readonly NOTIFICATION_ICON_LAST_SWITCH_STATE_DEFAULT: string = 'true';
  /* 状态栏实时网速最近一次用户手动设置的状态 默认设置 */
  static readonly REAL_TIME_NETWORK_SPEED_LAST_SWITCH_STATE_DEFAULT: string = 'false';

  /* status on, device provisioned */
  static readonly OOBE_STATUS_ON: string = '1';

  /* status off, device not provisioned */
  static readonly OOBE_STATUS_OFF: string = '0';

  /* 自动旋转打开 */
  static readonly AUTO_ROTATE_ON: string = '1';
  /* 自动旋转关闭 */
  static readonly AUTO_ROTATE_OFF: string = '0';

  /* 移动数据开关 默认设置 */
  static readonly CELLULAR_DATA_ENABLE_DEFAULT: string = '1';
  /* 护眼模式开关 默认设置 */
  static readonly EYE_SHIELD_MODE_DEFAULT: string = '0';
  static readonly EYE_SHIELD_ENABLE_OPEN_VALUE: string[] = ['1', '2', '3', '4'];
  /* 护眼模式MODE :0-全天关闭 1-全天开启 2-定时开启 3-日落到日出开启 4-智能护眼 默认设置 */
  static readonly EYE_SHIELD_MODE_CLOSE: string = '0';
  static readonly EYE_SHIELD_MODE_OPEN_ALL_DAY: string = '1';
  static readonly EYE_SHIELD_MODE_SCHEDULE_CUSTOM: string = '2';
  static readonly EYE_SHIELD_MODE_SCHEDULE_SUNSET: string = '3';
  static readonly EYE_SHIELD_MODE_SCHEDULE_SWING: string = '4';
  /* 电子书模式开关 默认设置 */
  static readonly EBOOK_MODE_ENABLE_DEFAULT: string = '0';
  static readonly EBOOK_MODE_STATUS_ON: string = '1';
  static readonly EBOOK_MODE_BLACK_WHITE: string = '1';
  static readonly EBOOK_MODE_COLORFUL: string = '2';
  static readonly EBOOK_MODE_NULL: string = '-1';
  /* 专注模式开关 默认设置 */
  static readonly FOCUS_MODE_ENABLE_DEFAULT: string = '0';
  /* 中转站开关 默认设置 */
  static readonly SUPERHUB_ENABLE_DEFAULT: string = '0';
  /* 互联互通服务开关 默认设置 */
  static readonly MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH_DEFAULT: string = '1';

  /* oobe is not finished in ota scene */
  static readonly OTA_NOT_FINISHED: string = '0';
  /* user_setup_complete has set for ota scene */
  static readonly USER_HAS_SETUP_COMPLETE: string = '1';

  static readonly ringModeIsJustRing: number = 0;
  static readonly ringModeIsJustVibration: number = 2;
  static readonly ringModeIsRingAndVibration: number = 3;
  /* 仙人掌开关默认  */
  static readonly SATELLITE_MODE_SWITCH_DEFAULT: string = '0.0';
  static readonly SAMPLE_MANAGER_CHECKED: string = '1';
  /* 通信共享开关默认 */
  static readonly DISTRIBUTED_MODEM_STATE_DEFAULT: string = '0_sink';
  /* 无线防盗值守状态开启 */
  static readonly ANTI_THEFT_ENABLE: string = '1';
  /* 无线防盗值守状态关闭 */
  static readonly ANTI_THEFT_DISABLE: string = '0';
  /* 手写笔防误触关 */
  static readonly FORBIDDEN_GESTURE_DISABLE: string = '0';
  /* 手写笔防误触开 */
  static readonly FORBIDDEN_GESTURE_ENABLE: string = '1';
  /**
   * 锁屏通知默认显示样式，用户设置默认显示列表时为true，默认显示为胶囊时为false
   */
  static readonly NTF_SCREEN_LOCK_STYLE_LIST: string = 'true';

  /**
   * 锁屏通知默认显示样式，用户设置默认显示列表时为true，默认显示为胶囊时为false
   */
  static readonly NTF_SCREEN_LOCK_STYLE_CAPSULE: string = 'false';
  /* 闪烁提醒开关 */
  static readonly ACCESSIBILITY_FLASH_REMINDER_SWITCH_DEFAULT: string = '0';
  /* 通知闪烁开关 */
  static readonly ACCESSIBILITY_REMINDER_FUNCTION_ENABLED_DEFAULT: string = 'DEFAULT';

  /* 主题切换状态-切换中 */
  static readonly THEME_CHANGE_STATUS_RUNNING: string = 'running';
  /* 主题切换状态-中断 */
  static readonly THEME_CHANGE_STATUS_STOP: string = 'stop';
  /* 主题切换状态-切换完成 */
  static readonly THEME_CHANGE_STATUS_FINISH: string = 'finish';
}