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

import { DeviceHelper } from '../base/DeviceHelper';
import { ArrayUtils } from '@ohos/basicutils';
import { CommonUtils } from '@ohos/basicutils';

const STATUS_BAR_ICON_SIZE_SMALL = 160;

const STATUS_BAR_ICON_SIZE_COMMON = 300;

const STATUS_BAR_ICON_SIZE_LARGE = 360;

/**
 * plugin common常量
 *
 * @since 2022-10-13
 */
export class PluginConstants {
  /**
   * plugin action，状态栏图标action
   */
  static readonly ACTION_PLUGIN_STATUS_BAR: string = 'action.systemui.plugin.STATUS_BAR';

  /**
   * plugin action，控制中心开关图标action
   */
  static readonly ACTION_PLUGIN_TOGGLE: string = 'action.systemui.plugin.TOGGLE';

  /**
   * 事件类型，查询所有plugin
   */
  static readonly EVENT_TYPE_QUERY_ALL: number = 1;

  /**
   * 事件类型，新增plugin
   */
  static readonly EVENT_TYPE_ADD_PLUGIN: number = 2;

  /**
   * 事件类型， 更新plugin
   */
  static readonly EVENT_TYPE_UPDATE_PLUGIN: number = 3;

  /**
   * 事件类型，删除plugin
   */
  static readonly EVENT_TYPE_DELETE_PLUGIN: number = 4;

  /**
   * LocalStorage键值，AbilityComponent窗口对应的图标slot
   */
  static readonly STORAGE_KEY_PLUGIN_SLOT: string = 'key_plugin_slot';

  /**
   * LocalStorage键值，AbilityComponent组件应用包名
   */
  static readonly STORAGE_KEY_BUNDLE_NAME: string = 'key_bundle_name';

  /**
   * LocalStorage键值，AbilityComponent组件slot值
   */
  static readonly STORAGE_KEY_ABILITY_NAME: string = 'key_ability_name';
}

/**
 * 组件点击类型，常量
 */
export class PluginClickType {
  /**
   * 窗口类型，弹出小窗口
   */
  static readonly TYPE_WINDOW: string = 'window';

  /**
   * ability类型，直接拉起ability
   */
  static readonly TYPE_ABILITY: string = 'ability';

  /**
   * 切换类型，切换开关、图标状态
   */
  static readonly TYPE_TOGGLE: string = 'toggle';

  /**
   * 自定义
   */
  static readonly TYPE_CUSTOM: string = 'custom';
}

/**
 * 组件窗口弹窗类型，常量
 */
export class PluginWindowType {
  /**
   * 小窗口，宽度160vp
   */
  static readonly TYPE_SMALL: string = 'small';

  /**
   * 普通窗口，宽度300vp
   */
  static readonly TYPE_COMMON: string = 'common';

  /**
   * 最大窗口， 宽度360vp
   */
  static readonly TYPE_LARGE: string = 'large';

  /**
   * 获取对应窗口宽度
   *
   * @param windowType 窗口类型
   */
  static getWindowWidth(windowType: string): number {
    switch (windowType) {
      case PluginWindowType.TYPE_SMALL:
        return vp2px(STATUS_BAR_ICON_SIZE_SMALL) as number;
      case PluginWindowType.TYPE_COMMON:
        return vp2px(STATUS_BAR_ICON_SIZE_COMMON) as number;
      case PluginWindowType.TYPE_LARGE:
        return vp2px(STATUS_BAR_ICON_SIZE_LARGE) as number;
      default:
        return 0;
    }
  }
}

/**
 * 组件启动ability类型，常量
 */
export class PluginAbilityType {
  /**
   * 启动类型，startAbility
   */
  static readonly TYPE_ABILITY = 'ability';

  /**
   * 启动类型，startServiceExtensionAbility
   */
  static readonly TYPE_EXTENSION = 'service_extension';

  /**
   * 判断启动类型是否为extension类型
   *
   * @param abilityType 类型
   * @return true extension类型
   */
  static isTypeExtension(abilityType: string): boolean {
    return abilityType === PluginAbilityType.TYPE_EXTENSION;
  }
}

/**
 * 组件位置，常量
 */
export class PluginPosition {
  /**
   * 组件位置，左侧
   */
  static readonly POSITION_LEFT: string = 'left';

  /**
   * 组件位置，系统图标右侧区域
   */
  static readonly POSITION_RIGHT: string = 'right';

  /**
   * 组件位置，系统图标左侧区域（跨孔场景）
   */
  static readonly POSITION_SYSTEM_LEFT: string = 'system_left';

  /**
   * 组件位置，不涉及(主要用于Toggle)
   */
  static readonly POSITION_NONE: string = 'none';
}

/**
 * plugin组件模板对应的业务图标slot
 */
export class PluginSlot {
  /**
   * 状态栏slot - 托盘(PC)
   */
  static readonly SLOT_STATUS_TRAY_PANEL = 'status_bar_tray';

  /**
   * 状态栏slot - 个人面板(PC)
   */
  static readonly SLOT_STATUS_PERSONAL = 'status_bar_personal';

  /**
   * 状态栏slot - 全局搜索(PC)
   */
  static readonly SLOT_STATUS_SEARCH = 'status_bar_search';

  /**
   * status bar capsule slot - OpenHarmony环(PC)
   */
  static readonly SLOT_STATUS_HOS_KEY = 'status_bar_pc_hoskey';

  /**
   * status bar capsule slot - 超级隐私拨片(PC)
   */
  static readonly SLOT_STATUS_SUPER_PRIVACY_PADDLE = 'status_bar_super_privacy_scene_board_paddle';

  /**
   * status bar capsule slot - 超级隐私软方案(PC)
   */
  static readonly SLOT_STATUS_SUPER_PRIVACY_PC_SOFT = 'status_bar_super_privacy_scene_board_soft';

  /**
   * status bar capsule slot - 免打扰拨片(PC)
   */
  static readonly SLOT_STATUS_FOCUS_MODE_PADDLE = 'status_bar_focus_mode_paddle';

  /**
   * status bar capsule slot - 企业空间切换(PC)
   */
  static readonly SLOT_STATUS_ENTERPRISE_SPACE = 'status_bar_enterprise_space';

  /**
   * 状态栏slot - 控制中心面板(PC)
   */
  static readonly SLOT_STATUS_CONTROL_CENTER = 'status_bar_control_center';

  /**
   * 状态栏slot - 控制中心编辑页面面板(PC)
   */
  static readonly SLOT_STATUS_EDIT_MODE_PANEL = 'status_bar_edit_mode_panel';

  /**
   * 状态栏slot - 省电模式面板(PC)
   */
  static readonly SLOT_STATUS_POWER_SAVING = 'status_bar_power_saving';

  /**
   * 状态栏slot - 通知中心面板(PC)
   */
  static readonly SLOT_STATUS_NOTIFICATION_PANEL = 'status_bar_notification_panel';

  /**
   * 状态栏slot - 服务卡片中心(PC)
   */
  static readonly SLOT_STATUS_FA_CENTER = 'status_bar_fa_center';

  /**
   * 状态栏slot - 分割线(PC)
   */
  static readonly SLOT_STATUS_SEPARATOR = 'status_bar_separator';

  /**
   * 状态栏slot - 时钟面板(PC)
   */
  static readonly SLOT_STATUS_CLOCK_PANEL = 'status_bar_clock_panel';

  /**
   * 状态栏slot - 电池面板(PC)
   */
  static readonly SLOT_STATUS_BATTERY_PANEL = 'status_bar_battery_panel';

  /**
   * 状态栏slot - 声音面板(PC)
   */
  static readonly SLOT_STATUS_SOUND_PANEL = 'status_bar_sound_panel';

  /**
   * 状态栏slot - 麦克风面板(PC)
   */
  static readonly SLOT_STATUS_MICROPHONE_PANEL = 'status_bar_microphone_panel';

  /**
   * 状态栏slot - 位置面板(PC)
   */
  static readonly SLOT_STATUS_LOCATION_PANEL = 'status_bar_location_panel';

  /**
   * 状态栏slot - wifi面板(PC)
   */
  static readonly SLOT_STATUS_WIFI_PANEL = 'status_bar_wifi_panel';

  /**
   * 控制中心slot - 隐私指示器面板
   */
  static readonly SLOT_CONTROL_PRIVACY_PANEL = 'SLOT_CONTROL_PRIVACY_PANEL';

  /**
   * 控制中心slot - 播控中心面板
   */
  static readonly SLOT_CONTROL_MEDIA_PLAY_PANEL = 'SLOT_CONTROL_MEDIA_PLAY_PANEL';

  /**
   * 状态栏slot - 蓝牙面板(PC)
   */
  static readonly SLOT_STATUS_BLUETOOTH_PANEL = 'status_bar_bluetooth_panel';

  /**
   * 状态栏slot - 输入法子类型(PC)
   */
  static readonly SLOT_STATUS_INPUT_PANEL = 'status_bar_input_panel';

  /**
   * 状态栏slot - 输入法(PC)
   */
  static readonly SLOT_STATUS_INPUT_METHOD = 'status_bar_input_method';

  /**
   * 状态栏slot - 多屏协同(PC)
   */
  static readonly SLOT_STATUS_BAR_COLLABORATION = 'status_bar_collaboration';

  /**
   * status bar capsule slot - camera(PC)
   */
  static readonly SLOT_STATUS_CAMERA = 'status_bar_pc_camera';

  /**
   * 状态栏slot - 运营商名称(Phone)
   */
  static readonly SLOT_STATUS_OPERATOR = 'status_bar_operator';

  /**
   * 状态栏slot - 星闪图标(Phone)
   */
  static readonly SLOT_STATUS_STAR_FLASH = 'status_bar_star_flash';

  /**
   * 状态栏slot - VPN图标(Phone)
   */
  static readonly SLOT_STATUS_VPN = 'status_bar_vpn';

  /**
   * 状态栏slot - 时钟(Phone)
   */
  static readonly SLOT_STATUS_CLOCK = 'status_bar_clock';

  /**
   * 状态栏slot - 通知图标(Phone)
   */
  static readonly SLOT_STATUS_NOTIFICATION = 'status_bar_notification_icon';

  /**
   * 状态栏slot - 横幅
   */
  static readonly NOTIFICATION_HEAD = 'notification_head';

  /**
   * 状态栏slot - 胶囊图标(Phone)
   */
  static readonly LIVE_VIEW_CAPSULE = 'live_view_capsule';

  /**
   * 状态栏slot - 电池图标(Phone)
   */
  static readonly SLOT_STATUS_BATTERY = 'status_bar_battery';

  /**
   * 状态栏slot - 信号强度图标(Phone)
   */
  static readonly SLOT_STATUS_SIGNAL = 'status_bar_signal';

  /**
   * 状态栏slot - 热点图标(Phone)
   */
  static readonly SLOT_STATUS_HOT_SPOT = 'status_bar_hot_spot';

  /**
   * 状态栏slot - 网速图标(Phone)
   */
  static readonly SLOT_STATUS_NET_SPEED = 'status_bar_net_speed';

  /**
   * 状态栏slot - link+图标(Phone)
   */
  static readonly SLOT_STATUS_LINK_PLUS = 'status_bar_link_plus';

  /**
   * 状态栏slot - NFC(Phone)
   */
  static readonly SLOT_STATUS_NFC = 'status_bar_nfc';

  /**
   * 状态栏slot - earPhone(Phone)
   */
  static readonly SLOT_STATUS_EARPHONE = 'status_bar_earphone';

  /**
   * 状态栏slot - Wifi(Phone)
   */
  static readonly SLOT_STATUS_WIFI = 'status_bar_wifi';

  /**
   * 状态栏slot - 蓝牙(Phone)
   */
  static readonly SLOT_STATUS_BLE = 'status_bar_bluetooth';

  /**
   * 状态栏slot - 飞行模式(Phone)
   */
  static readonly SLOT_STATUS_AIRPLANE = 'status_bar_airplane';

  /**
   * 状态栏slot - 响铃模式(振动/静音)(Phone)
   */
  static readonly SLOT_STATUS_RING = 'status_bar_ring_mode';

  /**
   * 状态栏slot - 免打扰(Phone)
   */
  static readonly SLOT_STATUS_DO_NOT_DISTURB = 'status_bar_do_not_disturb';

  /**
   * 状态栏slot - 位置信息(Phone)
   * 底层通知显示才显示
   */
  static readonly SLOT_STATUS_LOCATION = 'status_bar_location';

  /**
   * 状态栏slot - 超级隐私(Phone)
   * 底层通知显示才显示
   */
  static readonly SLOT_STATUS_SUPER_PRIVACY = 'status_bar_super_privacy';

  /**
   * 状态栏slot - 闹钟(Phone)
   */
  static readonly SLOT_STATUS_ALARM_CLOCK = 'status_bar_alarm_clock';

  /**
   * 状态栏slot - 有线网络(Phone)
   */
  static readonly SLOT_STATUS_ETHERNET = 'status_bar_ethernet';

  /**
   * 控制中心slot - 截屏开关
   */
  static readonly SLOT_CONTROL_SCREENSHOT = 'toggle_screenshot';

  /**
   * 控制中心slot - 录屏开关
   */
  static readonly SLOT_CONTROL_SCREEN_RECORDER = 'toggle_screen_recorder';

  /**
   * 控制中心slot - 扫一扫开关
   */
  static readonly SLOT_CONTROL_SCANNER = 'toggle_scanner';

  /**
   * 控制中心slot - demo开关
   */
  static readonly SLOT_CONTROL_DEMO = 'toggle_Demo';

  /**
   * 控制中心slot - wifi开关
   */
  static readonly SLOT_CONTROL_WIFI = 'wifi';

  /**
   * 控制中心slot - 分享开关
   */
  static readonly SLOT_CONTROL_SHARE = 'toggle_HuaweiShare';

  /**
   * 控制中心slot - 无线投屏开关
   */
  static readonly SLOT_CONTROL_CAST = 'toggle_HuaweiCast';

  /**
   * 控制中心slot - 多屏协同开关
   */
  static readonly SLOT_CONTROL_DEVICE_COLLABORATION = 'toggle_DeviceCollaboration';

  /**
   * 控制中心slot - PC模式开关
   */
  static readonly SLOT_CONTROL_MULTI_WINDOW = 'multi_window';

  /**
   * 控制中心slot - 电脑模式开关
   */
  static readonly SLOT_CONTROL_COMPUTER_MODE = 'computer_mode';

  /**
   * 状态栏胶囊slot - 截屏(PC)
   */
  static readonly SLOT_STATUS_CAPSULE_SCREENSHOT = 'status_bar_pc_normalshot';

  /**
   * 状态栏胶囊slot - 智能截屏(PC)
   */
  static readonly SLOT_STATUS_SMART_SCREENSHOT = 'status_bar_pc_smartshot';

  /**
   * 状态栏胶囊slot - 录屏(PC)
   */
  static readonly SLOT_STATUS_SCREEN_RECORDER = 'status_bar_pc_screenrecorder';

  /**
   * 状态栏胶囊slot - vpn(PC)
   */
  static readonly SLOT_STATUS_vpn = 'status_bar_vpn_security';

  /**
   * 状态栏胶囊slot - 备忘录(PC)
   */
  static readonly SLOT_STATUS_QUICK_NOTE = 'status_bar_quick_note';

  /**
   * 状态栏胶囊slot - 打印(PC)
   */
  static readonly SLOT_STATUS_PRINT = 'status_bar_pc_spooler';

  /**
   * 锁屏 slot - Wifi (PC)
   */
  static readonly SLOT_SCREEN_LOCK_WIFI = 'screen_lock_wifi';

  /**
   * status bar slot - 键鼠穿越
   */
  static readonly SLOT_CAPSULE_KEY_MOUSE = 'status_bar_capsule_key_mouse';

  /**
   * status bar slot - USB
   */
  static readonly SLOT_STATUS_USB = 'status_bar_pc_usb';

  /**
   * status bar slot - IDesk(PC)
   */
  static readonly SLOT_STATUS_IDESK = 'status_bar_idesk';

  /**
   * status bar slot - ICPM(PC)
   */
  static readonly SLOT_STATUS_ICPM = 'status_bar_epc';

  /**
   * status bar slot - virtual keyBoard
   */
  static readonly SLOT_STATUS_VIRTUAL_KEYBOARD = 'status_bar_virtual_keyboard';

  /**
   * status bar slot - com.ohos.cast
   */
  static readonly SLOT_PLUGIN_STATUS_BAR_CAST = 'plugin_status_bar_cast';

  /**
   * status bar slot - com.ohos.powerdialog
   */
  static readonly SLOT_STATUS_BAR_PC_MYINJECT = 'status_bar_pc_myinject';

  /**
   * 状态栏slot(PC)
   * position => slot称集
   */
  static readonly STATUS_BAR_PC: Map<string, Array<string>> = new Map([
  // 左侧图标排序
    [
      PluginPosition.POSITION_LEFT, [
        PluginSlot.SLOT_STATUS_HOS_KEY,
        PluginSlot.SLOT_STATUS_SEARCH,
        PluginSlot.SLOT_STATUS_CLOCK_PANEL
      ]
    ],
    // 右侧图标排序
    [
      PluginPosition.POSITION_RIGHT, [
        PluginSlot.SLOT_STATUS_USB,
        PluginSlot.SLOT_STATUS_LOCATION,
        PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD,
        PluginSlot.SLOT_STATUS_MICROPHONE_PANEL,
        PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
        PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
        PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE,
        PluginSlot.SLOT_STATUS_INPUT_PANEL,
        PluginSlot.SLOT_STATUS_INPUT_METHOD,
        PluginSlot.SLOT_STATUS_SOUND_PANEL,
        PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL,
        PluginSlot.SLOT_STATUS_WIFI_PANEL,
        PluginSlot.SLOT_STATUS_BATTERY_PANEL,
        PluginSlot.SLOT_STATUS_FA_CENTER,
        PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
        PluginSlot.SLOT_STATUS_CONTROL_CENTER,
      ]
    ],
  ]);

  /**
   * 状态栏图标默认自带动效集
   */
  static readonly defaultAnimSet: Set<string> = new Set([
    PluginSlot.SLOT_STATUS_PERSONAL,
    PluginSlot.SLOT_STATUS_CLOCK_PANEL,
    PluginSlot.SLOT_STATUS_BATTERY_PANEL,
    PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL,
    PluginSlot.SLOT_STATUS_vpn,
    PluginSlot.SLOT_STATUS_CONTROL_CENTER,
    PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
    PluginSlot.SLOT_STATUS_SOUND_PANEL,
    PluginSlot.SLOT_STATUS_QUICK_NOTE,
    PluginSlot.SLOT_STATUS_IDESK,
    PluginSlot.SLOT_STATUS_ICPM,
    PluginSlot.SLOT_STATUS_INPUT_PANEL,
    PluginSlot.SLOT_STATUS_INPUT_METHOD,
    PluginSlot.SLOT_STATUS_MICROPHONE_PANEL,
    PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
    PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
    PluginSlot.SLOT_STATUS_PRINT]
  );

  /**
   * 状态栏胶囊图标默认排序(pc)
   */
  static readonly STATUS_BAR_PC_CAPSULE_DEFAULT_ORDER: Array<string> = [
    PluginSlot.SLOT_STATUS_SMART_SCREENSHOT,
    PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT,
    PluginSlot.SLOT_STATUS_SCREEN_RECORDER,
    PluginSlot.SLOT_STATUS_QUICK_NOTE,
  ];

  /**
   * 状态栏slot(Phone)
   * position => slot名称集
   */
  static readonly STATUS_BAR_PHONE: Map<string, Array<string>> = new Map([
  // 左侧图标排序
    [
      PluginPosition.POSITION_LEFT, [
        PluginSlot.LIVE_VIEW_CAPSULE,
        PluginSlot.SLOT_STATUS_OPERATOR,
        PluginSlot.SLOT_STATUS_CLOCK,
        PluginSlot.SLOT_STATUS_NOTIFICATION

      ]
    ],
    // 右侧图标排序
    [
      PluginPosition.POSITION_RIGHT, [
        PluginSlot.SLOT_STATUS_EARPHONE,
        PluginSlot.SLOT_STATUS_NFC,
        PluginSlot.SLOT_STATUS_ALARM_CLOCK,
        PluginSlot.SLOT_STATUS_BLE,
        PluginSlot.SLOT_STATUS_STAR_FLASH,
        PluginSlot.SLOT_STATUS_SUPER_PRIVACY,
        PluginSlot.SLOT_STATUS_LOCATION,
        PluginSlot.SLOT_STATUS_RING,
        PluginSlot.SLOT_STATUS_LINK_PLUS,
        PluginSlot.SLOT_STATUS_DO_NOT_DISTURB,
        PluginSlot.SLOT_STATUS_VPN,
        PluginSlot.SLOT_STATUS_NET_SPEED,
        PluginSlot.SLOT_STATUS_AIRPLANE,
        PluginSlot.SLOT_STATUS_HOT_SPOT,
        PluginSlot.SLOT_STATUS_ETHERNET,
        PluginSlot.SLOT_STATUS_WIFI,
        PluginSlot.SLOT_STATUS_SIGNAL,
        PluginSlot.SLOT_STATUS_BATTERY
      ]
    ],
  ]);


  /**
   * 控制中心toggle图标slot(不区分PC Phone)
   * position => slot名称集
   */
  static readonly TOGGLE: Map<string, Array<string>> = new Map([
  // 控制中心不涉及左右
    [
      PluginPosition.POSITION_NONE, [
        PluginSlot.SLOT_CONTROL_SCREENSHOT,
        PluginSlot.SLOT_CONTROL_SCREEN_RECORDER,
        PluginSlot.SLOT_CONTROL_SHARE,
        PluginSlot.SLOT_CONTROL_CAST,
        PluginSlot.SLOT_CONTROL_DEVICE_COLLABORATION,
        PluginSlot.SLOT_CONTROL_DEMO,
      ]
    ]
  ]);

  /**
   * 获取图标默认所在设备类型
   *
   * @param action plugin action
   * @param slot 图标唯一标示
   */
  static getDefaultDeviceType(action: string, slot: string): string {
    // 控制中心不区分PC、Phone，只要是默认的就允许
    if (action === PluginConstants.ACTION_PLUGIN_TOGGLE) {
      let slots = PluginSlot.TOGGLE.get(PluginPosition.POSITION_NONE);
      if (ArrayUtils.contains(slots, slot)) {
        return DeviceHelper.getDeviceType();
      }
      return null;
    }
    // 状态栏区分PC、Phone
    let position = PluginSlot.getStatusBarPosition(PluginSlot.STATUS_BAR_PC, slot);
    if (!CommonUtils.isEmpty(position)) {
      return DeviceHelper.TYPE_2IN1;
    }

    // phone和tablet共用一套slot
    position = PluginSlot.getStatusBarPosition(PluginSlot.STATUS_BAR_PHONE, slot);
    if (!CommonUtils.isEmpty(position)) {
      return DeviceHelper.TYPE_PHONE;
    }
    return null;
  }

  /**
   * 获取默认slot集
   *
   * @param action plugin action
   */
  static getDefaultSlot(action: string): Map<string, Array<string>> {
    // 控制中心
    if (action === PluginConstants.ACTION_PLUGIN_TOGGLE) {
      return PluginSlot.TOGGLE;
    }
    // 状态栏区分PC Phone
    if (DeviceHelper.isPC()) {
      return PluginSlot.STATUS_BAR_PC;
    }
    return PluginSlot.STATUS_BAR_PHONE;
  }

  /**
   * 获取本应用默认slot集，用于填充本地plugin数据
   *
   * @param action plugin action
   */
  static getLocalSlot(action: string): Array<string> {
    // TODO 控制中心
    if (action === PluginConstants.ACTION_PLUGIN_TOGGLE) {
      return [];
    }
    // 状态栏区分PC Phone
    if (DeviceHelper.isPC()) {
      return [
        PluginSlot.SLOT_STATUS_CONTROL_CENTER,
        PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
        PluginSlot.SLOT_STATUS_SEPARATOR,
        PluginSlot.SLOT_STATUS_PERSONAL,
        PluginSlot.SLOT_STATUS_BATTERY_PANEL,
        PluginSlot.SLOT_STATUS_SOUND_PANEL,
        PluginSlot.SLOT_STATUS_CLOCK_PANEL,
        PluginSlot.SLOT_STATUS_INPUT_PANEL,
        PluginSlot.SLOT_STATUS_INPUT_METHOD,
        PluginSlot.SLOT_STATUS_MICROPHONE_PANEL,
        PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE,
        PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
        PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
        PluginSlot.SLOT_STATUS_LOCATION,
        PluginSlot.SLOT_STATUS_USB,
      ];
    }
    // phone
    return [
      PluginSlot.LIVE_VIEW_CAPSULE,
      PluginSlot.SLOT_STATUS_OPERATOR,
      PluginSlot.SLOT_STATUS_CLOCK,
      PluginSlot.SLOT_STATUS_NOTIFICATION,
      PluginSlot.SLOT_STATUS_BATTERY,
      PluginSlot.SLOT_STATUS_SIGNAL,
      PluginSlot.SLOT_STATUS_ETHERNET,
      PluginSlot.SLOT_STATUS_WIFI,
      PluginSlot.SLOT_STATUS_HOT_SPOT,
      PluginSlot.SLOT_STATUS_RING,
      PluginSlot.SLOT_STATUS_DO_NOT_DISTURB,
      PluginSlot.SLOT_STATUS_LOCATION,
      PluginSlot.SLOT_STATUS_SUPER_PRIVACY,
      PluginSlot.SLOT_STATUS_BLE,
      PluginSlot.SLOT_STATUS_NFC,
      PluginSlot.SLOT_STATUS_EARPHONE,
      PluginSlot.SLOT_STATUS_NET_SPEED,
      PluginSlot.SLOT_STATUS_STAR_FLASH,
      PluginSlot.SLOT_STATUS_VPN,
      PluginSlot.SLOT_STATUS_ALARM_CLOCK
    ];
  }

  /**
   * 根据slot名获取默认位置
   *
   * @param action plugin action
   * @param slot slot名
   * @return 位置
   */
  static getDefaultPosition(action: string, slot: string): string {
    // 控制中心无位置
    if (action === PluginConstants.ACTION_PLUGIN_TOGGLE) {
      return PluginPosition.POSITION_NONE;
    }
    // 区分PC Phone
    let positionMap = DeviceHelper.isPC() ? PluginSlot.STATUS_BAR_PC : PluginSlot.STATUS_BAR_PHONE;
    return PluginSlot.getStatusBarPosition(positionMap, slot);
  }

  /**
   * 获取状态栏slot位置
   *
   * @param positionMap 位置slot集
   * @param slot 目标slot
   * @return 位置
   */
  private static getStatusBarPosition(positionMap: Map<string, Array<string>>, slot: string): string {
    return [PluginPosition.POSITION_LEFT, PluginPosition.POSITION_RIGHT].find((position) => {
      return ArrayUtils.contains(positionMap.get(position), slot);
    });
  }
}

/**
 * 组件图标类型，常量
 */
export class PluginIconType {
  /**
   * 图标类型，小图标，36*36
   * 主要用于PC状态栏
   */
  static readonly TYPE_SMALL_ICON = 'small';

  /**
   * 图标类型，普通图标，44*44
   * 主要用于PC状态栏
   */
  static readonly TYPE_COMMON_ICON = 'common';

  /**
   * 图标类型，自适应
   * PC状态栏：高度固定40，宽度自适应
   * Phone状态栏：宽度自适应
   */
  static readonly TYPE_AUTO_ICON = 'auto';

  /**
   * 图标类型，内部使用，分割线
   * 主要用于PC状态栏
   */
  static readonly TYPE_SEPARATOR_ICON = 'separator';

  /**
   * 图标类型，内部使用
   */
  static readonly TYPE_TOGGLE_ICON = 'toggle';

  /**
   * 默认图标类型，PC
   */
  private static readonly SLOT_ICON_TYPE_PC: Map<string, string> = new Map([
    [PluginSlot.SLOT_STATUS_PERSONAL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_HOS_KEY, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_SEARCH, PluginIconType.TYPE_AUTO_ICON],
    [PluginSlot.SLOT_STATUS_CONTROL_CENTER, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_FA_CENTER, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_SEPARATOR, PluginIconType.TYPE_SEPARATOR_ICON],
    [PluginSlot.SLOT_STATUS_CLOCK_PANEL, PluginIconType.TYPE_AUTO_ICON],
    [PluginSlot.SLOT_STATUS_BATTERY_PANEL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_SOUND_PANEL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_WIFI_PANEL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_INPUT_PANEL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_INPUT_METHOD, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_MICROPHONE_PANEL, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_LOCATION, PluginIconType.TYPE_SMALL_ICON],
    [PluginSlot.SLOT_STATUS_USB, PluginIconType.TYPE_SMALL_ICON],
  ]);

  /**
   * 获取默认图标类型
   *
   * @param action plugin action
   * @param pluginSlot plugin唯一标示
   */
  static getDefaultType(action: string, pluginSlot: string): string {
    // 控制中心固定图标类型
    if (action === PluginConstants.ACTION_PLUGIN_TOGGLE) {
      return PluginIconType.TYPE_TOGGLE_ICON;
    }
    // 状态栏区分PC、Phone
    if (DeviceHelper.isPhone() || DeviceHelper.isPad()) {
      // Phone固定自适应
      return PluginIconType.TYPE_AUTO_ICON;
    }
    return PluginIconType.SLOT_ICON_TYPE_PC.get(pluginSlot);
  }
}

/**
 * plugin弹窗窗口位置
 */
export class PluginWindowPosition {
  /**
   * 弹窗位置，固定屏幕右侧（镜像则左侧）
   */
  static readonly POSITION_SCREEN_RIGHT = 1;

  /**
   * 弹窗位置，自动对齐，优先与图标左侧对齐，其次右侧对齐
   */
  static readonly POSITION_AUTO_ALIGN = 2;

  /**
   * 默认窗口位置
   */
  private static readonly DEFAULT_POSITION: Map<string, number> = new Map([
  // 控制中心面板，屏幕右侧
    [PluginSlot.SLOT_STATUS_CONTROL_CENTER, PluginWindowPosition.POSITION_SCREEN_RIGHT],
    // 通知中心面板，屏幕右侧
    [PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, PluginWindowPosition.POSITION_SCREEN_RIGHT],
    // FA卡片中心面板，屏幕右侧
    [PluginSlot.SLOT_STATUS_FA_CENTER, PluginWindowPosition.POSITION_SCREEN_RIGHT]
  ]);

  /**
   * 获取弹窗窗口位置
   *
   * @param pluginSlot plugin唯一标示
   */
  static getWindowPosition(pluginSlot: string): number {
    let position = PluginWindowPosition.DEFAULT_POSITION.get(pluginSlot);
    // 默认自动对齐
    if (CommonUtils.isInvalid(position)) {
      return PluginWindowPosition.POSITION_AUTO_ALIGN;
    }
    return position;
  }
}

/**
 * 组件接入方式
 */
export class PluginType {
  /**
   * 直接接入
   */
  static readonly PLUGIN_TYPE_IMMEDIATELY: string = 'immediately';

  /**
   * 随应用启动接入
   */
  static readonly PLUGIN_TYPE_DYNAMIC: string = 'dynamic';

  /**
   * 只通过接收应用visible为true显示
   */
  static readonly PLUGIN_TYPE_MESSAGE: string = 'message';

  /**
   * 拖动接入
   */
  static readonly PLUGIN_TYPE_DRAG: string = 'drag';

  /**
   * 三方生态接入
   */
  static readonly PLUGIN_TYPE_ACCESS: string = 'access';

  static isPluginType(str: string | PluginType): boolean {
    return str === this.PLUGIN_TYPE_IMMEDIATELY || str === this.PLUGIN_TYPE_DYNAMIC || str === this.PLUGIN_TYPE_DRAG ||
      str === this.PLUGIN_TYPE_MESSAGE;
  }
}