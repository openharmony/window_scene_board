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

/**
 * 外部应用相关常量，页面跳转建议统一采用action
 */
export class ExtAppConstants {
  /**
   * 设置包名
   */
  static readonly PKG_SETTINGS: string = 'com.ohos.settings';

  /**
   * pc设置包名
   */
  static readonly PKG_PC_SETTINGS: string = 'com.ohos.settings';

  /**
   * 日历包名
   */
  static readonly PKG_CALENDAR: string = 'com.ohos.calendar';

  /**
   * 日历首页Ability
   */
  static readonly ABILITY_CALENDAR: string = 'MainAbility';

  /**
   * 日历首页Module
   */
  static readonly MODULE_CALENDAR: string = 'phone';

  /**
   * 时钟包名
   */
  static readonly PKG_CLOCK: string = 'com.ohos.clock';

  /**
   * 时钟首页Ability
   */
  static readonly ABILITY_CLOCK: string = 'com.example.ohosclock.phone';

  /**
   * 时钟首页Module
   */
  static readonly MODULE_CLOCK: string = 'phone';

  /**
   * 应用首页action
   */
  static readonly ACTION_ANY_MAIN: string = 'action.system.home';

  /**
   * 设置首页Ability
   */
  static readonly ABILITY_SETTINGS_MAIN: string = 'com.ohos.settings.MainAbility';

  /**
   * 设置关于页面action
   */
  static readonly ACTION_SETTINGS_ABOUT: string = 'action.settings.about_device';

  /**
   * 设置关于页面Ability
   */
  static readonly ABILITY_SETTINGS_ABOUT: string = 'com.ohos.settings.AboutDeviceAbility';

  /**
   * 设置音量面板ability
   */
  static readonly ABILITY_SETTINGS_SOUND: string = 'com.ohos.settings.SoundSettingsAbility';

  /**
   * 手机设置音量面板Mudule
   */
  // static readonly MODULE_PHONE_SETTINGS_SOUND: string = 'phone_settings';
  static readonly MODULE_PHONE_SETTINGS_SOUND: string = 'phone';

  /**
   * PC设置音量面板Mudule
   */
  static readonly MODULE_PC_SETTINGS_SOUND: string = 'pcsettings';

  /**
   * 设置网路设置action
   */
  static readonly ABILITY_SETTINGS_MOBILE_NETWORK: string = 'com.ohos.settings.MobileNetworkAbility';

  /**
   * 设置音量面板action
   */
  static readonly ACTION_SETTINGS_SOUND: string = 'action.settings.sound_settings';

  /**
   * 设置日期时间页面action
   */
  static readonly ACTION_SETTINGS_DATE: string = 'action.settings.date_time';

  /**
   * PC设置音频页面Ability
   */
  static readonly ABILITY_PC_SETTINGS_AUDIO: string = 'com.ohos.settings.MainAbility';

  /**
   * 设置蓝牙页面Ability
   */
  static readonly ABILITY_SETTINGS_BLUETOOTH: string = 'com.ohos.settings.BluetoothSettingsAbility';

  /**
   * 设置跳转Ability
   */
  static readonly ABILITY_SETTINGS_BUNDLENAME: string = 'com.ohos.settings';
  static readonly ABILITY_SETTINGS_ABILITYNAME: string = 'com.ohos.settings.MainAbility';

  /**
   * 数据网络跳转Ability
   */
  static readonly ABILITY_MOBILEDATA_BUNDLENAME: string = 'com.ohos.callui';
  static readonly ABILITY_MOBILEDATA_ABILITYNAME: string = 'com.ohos.mobiledatasettings.MainAbility';

  /**
   * 设置蓝牙页面action
   */
  static readonly ACTION_SETTINGS_BLUETOOTH: string = 'action.settings.bluetooth';

  /**
   * 设置WiFi面板Ability
   */
  static readonly ABILITY_SETTINGS_WIFI: string = 'com.ohos.settings.WifiSettingsAbility';

  /**
   * 设置WiFi面板action
   */
  static readonly ACTION_SETTINGS_WIFI: string = 'action.settings.wifi';

  /**
   * 通知管理列表页面
   */
  static readonly ACTION_SYSTEMUI_NTF_MANAGEMENT: string = 'action.systemui.notification.MANAGEMENT';

  /**
   * 用户设置页面Ability
   */
  static readonly ABILITY_SETTINGS_ACCOUNT: string = 'com.ohos.settings.UserSettingsAbility';

  /**
   * WIFI设置二级页面小窗
   */
  static readonly ABILITY_WIFI_WINDOW_SETTINGS: string = 'WifiWindowSettingsAbility';

  /**
   * OOBE package name 首次开箱引导
   */
  static readonly PKG_OOBE: string = 'com.ohos.startupguide';

  /**
   * OOBE ability
   */
  static readonly ABILITY_OOBE: string = 'com.ohos.startupguide.MainAbility';

  /**
   * OOBE pc modlue
   */
  static readonly MODULE_OOBE_PC: string = 'pc_startupguide';

  /**
   * OOBE phone module
   */
  static readonly MODULE_OOBE_PHONE: string = 'phone_startupguide';

  /**
   * OOBE watch module
   */
  static readonly MODULE_OOBE_WATCH: string = 'watch_startupguide';

  /**
   * BetaClub包名
   */
  static readonly PKG_BETACLUB: string = 'com.ohos.betaclub';

  /**
   * 音频管家包名
   */
  static readonly PKG_AUDIO_ACCESSORY_MANAGER: string = 'com.ohos.audioaccessorymanager';

  /**
   * 音频管家ui ability
   */
  static readonly ABILITY_AUDIO_ACCESSORY_MANAGER: string = 'DeviceDetailAbility';

  /**
   * OpenHarmony键 ability
   */
  static readonly ohosKEY_ABILITYNAME: string = 'HosKeyServiceAbility';
  static readonly ohosKEY_BUNDLENAME: string = 'com.ohos.harmonykey';
  static readonly ohosKEY_MODULENAME: string = 'pc';
}