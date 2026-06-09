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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { DataShareEvent } from './DataShareEvent';
import { DataShareUtils, GetSettingSwitchParam, SettingsConstant } from './DataShareUtils';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'SysUI_DataShareEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 时间小时制(12/24)
 */
export class TimeFormatEvent extends DataShareEvent<boolean> {
  /**
   * 24小时制
   */
  static readonly TIME_FORMAT_24 = '24';

  /**
   * 12小时制
   */
  static readonly TIME_FORMAT_12 = '12';

  /**
   * 构造
   */
  constructor() {
    super(TimeFormatEvent);
    // 固定uri
    this.dataShareUri = DataShareUtils.getSettingsUriSync(SettingsConstant.KEY_TIME_FORMAT);
  }

  /**
   * 刷新当前小时制
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 24小时制
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    let format24 = TimeFormatEvent.TIME_FORMAT_24;
    const param: GetSettingSwitchParam = {
      uriKey: SettingsConstant.KEY_TIME_FORMAT,
      defaultValue: TimeFormatEvent.TIME_FORMAT_12, // 数据库未设置该字段时，系统默认是12小时制
      isCmpEqual: true,
      cmpValue: format24
    };
    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 当前是否为24小时制
   */
  isTimeFormat24(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(TimeFormatEvent, 'eventTypeName', { value: 'TimeFormatEvent' });

/**
 * 隐藏通知内容开关
 */
export class NtfHideContentEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(NtfHideContentEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT);
    log.showInfo(`ntf hide content event init: ${this.dataShareUri}`);
  }

  /**
   * 刷新当前开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT,
      defaultValue: 'true',
      isCmpEqual: true,
      cmpValue: 'true'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 隐藏通知内容开关是否开启
   *
   * @return true 开启
   */
  isNtfHideContentEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(NtfHideContentEvent, 'eventTypeName', { value: 'NtfHideContentEvent' });

/**
 * 显示锁屏通知内容
 */
export class AppNtfConfigShowContentKGEvent extends DataShareEvent<string> {
  constructor() {
    super(AppNtfConfigShowContentKGEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_CONTENT_KG);
    log.showInfo(`ntf show content kg init: ${this.dataShareUri}`);
  }

  refreshShareValue(isAsync?: boolean): Promise<string> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.APP_NTF_CONFIG_SHOW_CONTENT_KG,
      defaultValue: SettingsConstants.APP_NTF_CONFIG_SHOW_CONTENT_DEFAULT,
      isCmpEqual: false,
      cmpValue: SettingsConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT_DEFAULT
    };
    return DataShareUtils.getSettingSecureValue(param, isAsync);
  }

  /**
   * 隐藏通知内容开关是否开启
   *
   * @return 开关值 0始终 | 1仅机主注视时 | 2已解锁时
   */
  curAppNtfConfigShowContentKgStatus(): string {
    return this.shareValue;
  }
}
Object.defineProperty(AppNtfConfigShowContentKGEvent, 'eventTypeName', { value: 'AppNtfConfigShowContentKGEvent' });

/**
 * 隐藏实况内容开关
 */
export class LiveViewHideContentEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(LiveViewHideContentEvent);
    this.dataShareUri = DataShareUtils.getSettingsSecureUriSync(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT);
    log.showInfo(`live view hide content event init: ${this.dataShareUri}`);
  }

  /**
   * 刷新当前开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT,
      defaultValue: 'false',
      isCmpEqual: true,
      cmpValue: 'true'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 隐藏实况内容开关是否开启
   *
   * @return true 开启
   */
  isLiveViewHideContentEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(LiveViewHideContentEvent, 'eventTypeName', { value: 'LiveViewHideContentEvent' });

/**
 * 收到通知自动亮屏开关
 */
export class NtfAutoScreenOnEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(NtfAutoScreenOnEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON);
    log.showInfo(`ntf auto screen on event init: ${this.dataShareUri}`);
  }

  /**
   * 刷新当前开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON,
      defaultValue: 'false',
      isCmpEqual: true,
      cmpValue: 'true'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 收到通知自动亮屏开关是否开启
   *
   * @return true 开启
   */
  isNtfAutoScreenOnEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(NtfAutoScreenOnEvent, 'eventTypeName', { value: 'NtfAutoScreenOnEvent' });

/**
 * 显示桌面角标开关
 */
export class NtfShowDesktopBadgesEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(NtfShowDesktopBadgesEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES);
    log.showInfo(`ntf show desktop badges event init: ${this.dataShareUri}`);
  }

  /**
   * 刷新当前开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES,
      defaultValue: SettingsConstants.NTF_SHOW_DESKTOP_BADGES_DEFAULT ? 'true' : 'false',
      isCmpEqual: true,
      cmpValue: 'true'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 收到显示桌面角标是否开启
   *
   * @return true 开启
   */
  isNtfShowDesktopBadgesOnEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(NtfShowDesktopBadgesEvent, 'eventTypeName', { value: 'NtfShowDesktopBadgesEvent' });


/**
 * 状态栏纯净显示开关事件
 */
export class PureShowEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(PureShowEvent);
  }

  async init(): Promise<void> {
    log.showInfo('pure show event init');
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.STATUS_BAR_PURE_SHOW);
  }

  /**
   * 刷新状态栏纯净显示开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.STATUS_BAR_PURE_SHOW,
      defaultValue: SettingsConstants.STATUS_BAR_PURE_SHOW_DEFAULT ? 'true' : 'false',
      isCmpEqual: true,
      cmpValue: 'true',
      needRetry: true,
    };

    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 状态栏纯净显示是否开启
   *
   * @return true 开启
   */
  isPureShowEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(PureShowEvent, 'eventTypeName', { value: 'PureShowEvent' });

/**
 * 状态栏显示通知图标开关事件
 */
export class NotificationIconEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(NotificationIconEvent);
  }

  async init(): Promise<void> {
    log.showInfo('notification icon event init');
    this.dataShareUri =
      await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON);
  }

  /**
   * 刷新状态栏显示通知图标开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON,
      defaultValue: SettingsConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON_DEFAULT ? 'true' : 'false',
      isCmpEqual: true,
      cmpValue: 'true',
      needRetry: true,
    };

    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 状态栏显示通知图标开关是否开启
   *
   * @return true 开启
   */
  isNotificationIconEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(NotificationIconEvent, 'eventTypeName', { value: 'NotificationIconEvent' });

/**
 * 状态栏显示实时网速开关事件
 */
export class RealTimeNetworkSpeedEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(RealTimeNetworkSpeedEvent);
  }

  async init(): Promise<void> {
    log.showInfo('real time network speed event init');
    this.dataShareUri =
      await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED);
  }

  /**
   * 刷新状态栏显示实时网速开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED,
      defaultValue: SettingsConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED_DEFAULT ? 'true' : 'false',
      isCmpEqual: true,
      cmpValue: 'true',
      needRetry: true,
    };
    // 实况2.0下实时网速开关功能调整，需要常开 由使能开关控制
    try {
      if (systemParameterEnhance.getSync('persist.systemui.live2', 'false') === 'true') {
        return true;
      };
    } catch (error) {
      log.showError(`Init systemui.live2 check false ${error}`);
    }
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 状态栏显示实时网速开关是否开启
   *
   * @return true 开启
   */
  isRealTimeNetworkSpeedEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(RealTimeNetworkSpeedEvent, 'eventTypeName', { value: 'RealTimeNetworkSpeedEvent' });

/**
 * 状态栏电池显示电量百分比开关事件
 */
export class BatterySocEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(BatterySocEvent);
  }

  async init(): Promise<void> {
    log.showInfo('battery soc event init');
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.STATUS_BAR_SHOW_BATTERY_SOC);
  }

  /**
   * 刷新状态栏电池显示电量百分比开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const showDefault = String(
      SettingsConstants[`STATUS_BAR_SHOW_BATTERY_SOC_${(DeviceHelper.isPhone() || DeviceHelper.isPad()) ? 'PHONE' : 'PC'}_DEFAULT`]
    );
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.STATUS_BAR_SHOW_BATTERY_SOC,
      defaultValue: showDefault,
      isCmpEqual: true,
      cmpValue: 'true',
      needRetry: true,
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 状态栏显示电量百分比开关是否开启
   *
   * @return true 开启
   */
  isBatterySocEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(BatterySocEvent, 'eventTypeName', { value: 'BatterySocEvent' });

/**
 * 状态栏胶囊显示开关事件
 */
export class CapsuleShowEvent {
  /**
   * 是否显示胶囊
   */
  isCapsuleShow: boolean;

  /**
   * 创建事件
   *
   * @param capsuleShow 是否显示胶囊
   */
  static create(capsuleShow: boolean): CapsuleShowEvent {
    let event = new CapsuleShowEvent();
    event.isCapsuleShow = capsuleShow;
    return event;
  }
}

Object.defineProperty(CapsuleShowEvent, 'eventTypeName', { value: 'CapsuleShowEvent' });

/**
 * 移动数据开关事件
 */
export class CellularDataEnableEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(CellularDataEnableEvent);
    this.dataShareUri = DataShareUtils.getSettingsUriSync(SettingsKeyConstants.CELLULAR_DATA_ENABLE);
  }

  /**
   * 刷新显示移动数据开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.CELLULAR_DATA_ENABLE,
      defaultValue: SettingsConstants.CELLULAR_DATA_ENABLE_DEFAULT,
      isCmpEqual: true,
      cmpValue: SettingsConstants.CELLULAR_DATA_ENABLE_DEFAULT
    };

    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 显示移动数据开关是否开启
   *
   * @return true 开启
   */
  isCellularDataEnabled(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(CellularDataEnableEvent, 'eventTypeName', { value: 'CellularDataEnableEvent' });

/**
 * 专注模式开关
 */
export class FocusModeSwitchDataEvent extends DataShareEvent<boolean> {
  async init() : Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.FOCUS_MODE_ENABLE) as string;
    log.showInfo(`focusMode Multi-user: ${this.dataShareUri}`);
  }

  /**
   * 构造
   */
  constructor() {
    super(FocusModeSwitchDataEvent);
    this.dataShareUri = DataShareUtils.getSettingsSecureUriSync(SettingsKeyConstants.FOCUS_MODE_ENABLE);
  }

  /**
   * 刷新显示专注模式开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.FOCUS_MODE_ENABLE,
      defaultValue: SettingsConstants.FOCUS_MODE_ENABLE_DEFAULT,
      isCmpEqual: false,
      cmpValue: SettingsConstants.FOCUS_MODE_ENABLE_DEFAULT
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 专注模式开关是否开启
   *
   * @return true 开启
   */
  isFocusModeSwitchEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(FocusModeSwitchDataEvent, 'eventTypeName', { value: 'FocusModeSwitchDataEvent' });

/**
 * 闪烁提醒开关
 */
export class FlashReminderSwitchEvent extends DataShareEvent<boolean> {
  public static readonly eventTypeName = 'FlashReminderSwitchEvent';

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(
        SettingsKeyConstants.ACCESSIBILITY_FLASH_REMINDER_SWITCH) as string;
  }

  /**
   * 构造
   */
  constructor() {
    super(FlashReminderSwitchEvent);
    this.dataShareUri =
      DataShareUtils.getSettingsSecureUriSync(SettingsKeyConstants.ACCESSIBILITY_FLASH_REMINDER_SWITCH);
  }

  /**
   * 闪烁提醒开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.ACCESSIBILITY_FLASH_REMINDER_SWITCH,
      defaultValue: SettingsConstants.ACCESSIBILITY_FLASH_REMINDER_SWITCH_DEFAULT,
      isCmpEqual: false,
      cmpValue: SettingsConstants.ACCESSIBILITY_FLASH_REMINDER_SWITCH_DEFAULT,
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 闪烁提醒开关是否开启
   *
   * @return true 开启
   */
  isFlashReminderSwitchEnable(): boolean {
    return this.shareValue as boolean;
  }
}

/**
 * 闪烁提醒方式改变
 */
export class FlashReminderSlotChangeEvent extends DataShareEvent<string> {
  public static readonly eventTypeName = 'FlashReminderSlotChangeEvent';

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(
        SettingsKeyConstants.ACCESSIBILITY_REMINDER_FUNCTION_ENABLED) as string;
  }

  /**
   * 构造
   */
  constructor() {
    super(FlashReminderSlotChangeEvent);
    this.dataShareUri =
      DataShareUtils.getSettingsSecureUriSync(SettingsKeyConstants.ACCESSIBILITY_REMINDER_FUNCTION_ENABLED);
  }

  /**
   * 闪烁提醒开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<string> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.ACCESSIBILITY_REMINDER_FUNCTION_ENABLED,
      defaultValue: SettingsConstants.ACCESSIBILITY_REMINDER_FUNCTION_ENABLED_DEFAULT,
      isCmpEqual: false,
      cmpValue: SettingsConstants.ACCESSIBILITY_REMINDER_FUNCTION_ENABLED_DEFAULT
    };
    return DataShareUtils.getSettingSecureValue(param, isAsync);
  }

  /**
   * 闪烁提醒方式
   *
   * @return true 开启
   */
  getFlashReminderSlot(): string {
    return this.shareValue as string;
  }
}

/**
 * 中转站开关
 */
export class SuperHubSwitchDataEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(SuperHubSwitchDataEvent);
    this.dataShareUri = DataShareUtils.getSettingsUriSync(SettingsKeyConstants.SUPERHUB_TOGGLE_ENABLE);
  }

  /**
   * 刷新显示中转站开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.SUPERHUB_TOGGLE_ENABLE,
      defaultValue: SettingsConstants.SUPERHUB_ENABLE_DEFAULT,
      isCmpEqual: false,
      cmpValue: SettingsConstants.SUPERHUB_ENABLE_DEFAULT
    };
    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 中转站开关是否开启
   *
   * @return true 开启
   */
  isSuperHubSwitchEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(SuperHubSwitchDataEvent, 'eventTypeName', { value: 'SuperHubSwitchDataEvent' });

export class FaceSwitchEnableEvent extends DataShareEvent<boolean> {
  static readonly KEY_FACE_BIND_WITH_LOCK_ENABLE = 'face_bind_with_lock';

  static readonly DEFAULT_KEY_FACE_BIND_WITH_LOCK_VALUE = '1';

  /**
   * 构造
   */
  constructor() {
    super(FaceSwitchEnableEvent);
    this.dataShareUri = DataShareUtils.getSettingsSecureUriSync(FaceSwitchEnableEvent.KEY_FACE_BIND_WITH_LOCK_ENABLE);
  }

  /**
   * 刷新显示移动数据开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: FaceSwitchEnableEvent.KEY_FACE_BIND_WITH_LOCK_ENABLE,
      defaultValue: FaceSwitchEnableEvent.DEFAULT_KEY_FACE_BIND_WITH_LOCK_VALUE,
      isCmpEqual: true,
      cmpValue: FaceSwitchEnableEvent.DEFAULT_KEY_FACE_BIND_WITH_LOCK_VALUE
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 状态栏纯净显示是否开启
   *
   * @return true 开启
   */
  isFaceSwitchEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(FaceSwitchEnableEvent, 'eventTypeName', { value: 'FaceSwitchEnableEvent' });

export class FingerprintUnlockSwitchEnableEvent extends DataShareEvent<boolean> {
  static readonly FP_KEYGUARD_ENABLE = 'fp_keyguard_enable';

  static readonly DEFAULT_FP_KEYGUARD_ENABLE = '1';

  /**
   * 构造
   */
  constructor() {
    super(FingerprintUnlockSwitchEnableEvent);
  }

  async init(): Promise<void> {
    log.showInfo('finger print unlock switch enable event init');
    this.dataShareUri =
      await DataShareUtils.getSettingsSecureUriAsync(FingerprintUnlockSwitchEnableEvent.FP_KEYGUARD_ENABLE);
  }

  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: FingerprintUnlockSwitchEnableEvent.FP_KEYGUARD_ENABLE,
      defaultValue: '0',
      isCmpEqual: true,
      cmpValue: FingerprintUnlockSwitchEnableEvent.DEFAULT_FP_KEYGUARD_ENABLE
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  isFingerprintUnlockSwitchEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(FingerprintUnlockSwitchEnableEvent, 'eventTypeName',
  { value: 'FingerprintUnlockSwitchEnableEvent' });

export class HiddenBannerNtfEnableEvent extends DataShareEvent<boolean> {
  static readonly KEY_HIDE_BANNER_ENABLE = 'app_ntf_config_hide_banner_content';

  static readonly DEFAULT_KEY_HIDE_BANNER_VALUE = '0';

  /**
   * 构造
   */
  constructor() {
    super(HiddenBannerNtfEnableEvent);
    this.dataShareUri = DataShareUtils.getSettingsSecureUriSync(HiddenBannerNtfEnableEvent.KEY_HIDE_BANNER_ENABLE);
  }

  /**
   * 刷新智能提醒开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: HiddenBannerNtfEnableEvent.KEY_HIDE_BANNER_ENABLE,
      defaultValue: HiddenBannerNtfEnableEvent.DEFAULT_KEY_HIDE_BANNER_VALUE,
      isCmpEqual: true,
      cmpValue: '1'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 状态栏纯净显示是否开启
   *
   * @return true 开启
   */
  isHiddenBannerNtfEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(HiddenBannerNtfEnableEvent, 'eventTypeName', { value: 'HiddenBannerNtfEnableEvent' });

/**
 * 仙人掌开关事件
 */
export class SatelliteModeSwitchEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(SatelliteModeSwitchEvent);
    this.dataShareUri = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true';
  }

  /**
   * 刷新仙人掌开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return 1.0 开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.SATELLITE_MODE_SWITCH,
      defaultValue: SettingsConstants.SATELLITE_MODE_SWITCH_DEFAULT,
      isCmpEqual: true,
      cmpValue: '1.0'
    };
    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 显示仙人掌开关是否开启
   * @return 1.0 开启
   */
  satelliteModeSwitch(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(SatelliteModeSwitchEvent, 'eventTypeName', { value: 'SatelliteModeSwitchEvent' });

/**
 * 通信共享开关事件
 */
export class DistributedModemSwitchEvent extends DataShareEvent<boolean> {

  constructor() {
    super(DistributedModemSwitchEvent);
    this.dataShareUri = DataShareUtils.getSettingsUriSync(SettingsKeyConstants.DISTRIBUTED_MODEM_STATE);
  }

  /**
   * 刷新通信共享开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return 1_sink 开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.DISTRIBUTED_MODEM_STATE,
      defaultValue: SettingsConstants.DISTRIBUTED_MODEM_STATE_DEFAULT,
      isCmpEqual: true,
      cmpValue: '1_sink',
    };
    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 通信共享开关是否开启
   *
   * @return true 开启
   */
  isDistributedModemStateEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(DistributedModemSwitchEvent, 'eventTypeName', { value: 'DistributedModemSwitchEvent' });

/**
 * 聚合数据开关事件
 */
export class UnifiedGroupEnableEvent extends DataShareEvent<boolean> {
  static readonly UNIFIED_GROUP_ENABLE = 'unified_group_enable';

  /**
   * 构造
   */
  constructor() {
    super(UnifiedGroupEnableEvent);
    this.dataShareUri = DataShareUtils.getSettingsSecureUriSync(UnifiedGroupEnableEvent.UNIFIED_GROUP_ENABLE);
  }

  /**
   * 刷新显示移动数据开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    let defaultValue = 'false';
    const param: GetSettingSwitchParam = {
      uriKey: UnifiedGroupEnableEvent.UNIFIED_GROUP_ENABLE,
      defaultValue: defaultValue,
      isCmpEqual: true,
      cmpValue: defaultValue
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 显示移动数据开关是否开启
   *
   * @return true 开启
   */
  isUnifiedGroupEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(UnifiedGroupEnableEvent, 'eventTypeName', { value: 'UnifiedGroupEnableEvent' });

/**
 * 隔空滑动开关
 */
export class SpaceSlidingSwitchEvent extends DataShareEvent<boolean> {
  static readonly URI = 'item_space_sliding_switch';

  /**
   * 构造
   */
  constructor() {
    super(SpaceSlidingSwitchEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SpaceSlidingSwitchEvent.URI);
    log.showInfo(`The dataShareUri of SpaceSlidingSwitchEvent is ${this.dataShareUri}`);
  }

  /**
   * 刷新显示移动数据开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const defaultValue = '0';
    const param: GetSettingSwitchParam = {
      uriKey: SpaceSlidingSwitchEvent.URI,
      defaultValue: defaultValue,
      isCmpEqual: true,
      cmpValue: '1'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }
}

Object.defineProperty(SpaceSlidingSwitchEvent, 'eventTypeName', { value: 'SpaceSlidingSwitchEvent' });

/**
 * 隔空截屏开关
 */
export class GrabScreenCaptureSwitchEvent extends DataShareEvent<boolean> {
  static readonly URI = 'item_grab_screen_capture_switch';

  /**
   * 构造
   */
  constructor() {
    super(GrabScreenCaptureSwitchEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(GrabScreenCaptureSwitchEvent.URI);
    log.showInfo(`The dataShareUri of GrabScreenCaptureSwitchEvent is ${this.dataShareUri}`);
  }

  /**
   * 刷新显示移动数据开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const defaultValue = '0';
    const param: GetSettingSwitchParam = {
      uriKey: GrabScreenCaptureSwitchEvent.URI,
      defaultValue: defaultValue,
      isCmpEqual: true,
      cmpValue: '1'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }
}
Object.defineProperty(GrabScreenCaptureSwitchEvent, 'eventTypeName', { value: 'GrabScreenCaptureSwitchEvent' });

/**
 * 隔空分享开关
 */
export class SpaceShareSwitchEvent extends DataShareEvent<boolean> {
  static readonly URI = 'item_air_share_switch';

  /**
   * 构造
   */
  constructor() {
    super(SpaceShareSwitchEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SpaceShareSwitchEvent.URI);
    log.showInfo(`The dataShareUri of SpaceShareSwitchEvent is ${this.dataShareUri}`);
  }
  /**
   * 刷新隔空分享开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const defaultValue = '0';
    const param: GetSettingSwitchParam = {
      uriKey: SpaceShareSwitchEvent.URI,
      defaultValue: defaultValue,
      isCmpEqual: true,
      cmpValue: '1'
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }
}
Object.defineProperty(SpaceShareSwitchEvent, 'eventTypeName', { value: 'SpaceShareSwitchEvent' });

/**
 * 互联互通服务开关事件
 */
export class MultiDeviceCollaborationServiceEnableEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(MultiDeviceCollaborationServiceEnableEvent);
    this.dataShareUri = DataShareUtils.getSettingsUriSync(SettingsKeyConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH);
  }

  /**
   * 刷新显示互联互通服务开关是否开启
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH,
      defaultValue: SettingsConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH_DEFAULT,
      isCmpEqual: true,
      cmpValue: SettingsConstants.CELLULAR_DATA_ENABLE_DEFAULT
    };
    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 显示互联互通服务开关是否开启
   *
   * @return true 开启
   */
  isMultiDeviceCollaborationServiceEnable(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(MultiDeviceCollaborationServiceEnableEvent, 'eventTypeName', { value: 'MultiDeviceCollaborationServiceEnableEvent' });

/**
 * oobe阶段协议与声明同意事件
 */
export class BasicStatementAgreedEvent extends DataShareEvent<boolean> {
  public static get = SingletonHelper.createFactory(() => new BasicStatementAgreedEvent());
  /**
   * 构造
   */
  constructor() {
    super(BasicStatementAgreedEvent);
    this.dataShareUri = DataShareUtils.getSettingsUriSync(SettingsKeyConstants.BASIC_STATEMENT_AGREED);
  }

  /**
   * 刷新协议与声明同意开关
   */
  async refreshShareValue(isAsync?: boolean | undefined): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.BASIC_STATEMENT_AGREED,
      defaultValue: SettingsConstants.OOBE_STATUS_OFF,
      isCmpEqual: true,
      cmpValue: SettingsConstants.OOBE_STATUS_ON
    };
    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 返回协议与声明同意开关是否开启
   */
  isBasicStatementAgreedEnable(): boolean {
    return this.shareValue;
  }
}
Object.defineProperty(BasicStatementAgreedEvent, 'eventTypeName', { value: 'BasicStatementAgreedEvent' });

/**
 * 手写笔防误触开关
 */
export class ForbiddenGestureSwitchEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(ForbiddenGestureSwitchEvent);
    this.dataShareUri = DataShareUtils.getSettingsUriSync(SettingsKeyConstants.FORBIDDEN_GESTURE_SWITCH_STATE);
  }

  /**
   * 刷新协议与声明同意开关
   */
  async refreshShareValue(isAsync?: boolean | undefined): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.FORBIDDEN_GESTURE_SWITCH_STATE,
      defaultValue: SettingsConstants.FORBIDDEN_GESTURE_DISABLE,
      isCmpEqual: true,
      cmpValue: SettingsConstants.FORBIDDEN_GESTURE_ENABLE,
      needRetry: true,
    };
    return DataShareUtils.getSettingEnableValue(param, isAsync);
  }

  /**
   * 返回协议与声明同意开关是否开启
   */
  isForbiddenGestureSwitchEnable(): boolean {
    return this.shareValue;
  }
}
Object.defineProperty(ForbiddenGestureSwitchEvent, 'eventTypeName', { value: 'ForbiddenGestureSwitchEvent' });

/**
 * oobe阶段协议与声明同意事件Secure库
 */
export class BasicStatementAgreedSecureEvent extends DataShareEvent<boolean> {
  /**
   * 构造
   */
  constructor() {
    super(BasicStatementAgreedSecureEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SettingsKeyConstants.BASIC_STATEMENT_AGREED);
    log.showInfo(`basic statement agreed secure event init: ${this.dataShareUri}`);
  }

  /**
   * 刷新协议与声明同意开关Secure库
   */
  async refreshShareValue(isAsync?: boolean | undefined): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.BASIC_STATEMENT_AGREED,
      defaultValue: SettingsConstants.OOBE_STATUS_OFF,
      isCmpEqual: true,
      cmpValue: SettingsConstants.OOBE_STATUS_ON
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }

  /**
   * 返回协议与声明同意开关是否开启
   */
  isBasicStatementAgreedEnable(): boolean {
    return this.shareValue;
  }
}
Object.defineProperty(BasicStatementAgreedSecureEvent, 'eventTypeName', { value: 'BasicStatementAgreedSecureEvent' });

/**
 * 锁屏通知显示样式更新事件
 *
 */
export class SlNtfStyleChangeEvent extends DataShareEvent<boolean> {
  static readonly URI_KEY = SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE;

  /**
   * 构造
   */
  constructor() {
    super(SlNtfStyleChangeEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(SlNtfStyleChangeEvent.URI_KEY);
    log.showInfo(`The dataShareUri of SlNtfStyleChangeEvent is ${this.dataShareUri}`);
  }

  /**
   * 刷新锁屏通知显示样式
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 用户设置默认显示列表时为true，默认显示为胶囊时为false
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SlNtfStyleChangeEvent.URI_KEY,
      defaultValue: SettingsConstants.NTF_SCREEN_LOCK_STYLE_CAPSULE,
      isCmpEqual: true,
      cmpValue: SettingsConstants.NTF_SCREEN_LOCK_STYLE_LIST
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }
}

Object.defineProperty(SlNtfStyleChangeEvent, 'eventTypeName', { value: 'SlNtfStyleChangeEvent' });

/**
 * 声音与振动-响铃时振动开关事件
 *
 */
export class VibrateSwitchEvent extends DataShareEvent<boolean> {
  constructor() {
    super(VibrateSwitchEvent);
  }

  async init(): Promise<void> {
    this.dataShareUri = await DataShareUtils.getSettingsUserUriAsync(SettingsKeyConstants.VIBRATE_SWITCH);
    log.showInfo(`vibrate swtich init : ${this.dataShareUri}`);
  }

  /**
   * 刷新当前开关状态
   *
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: SettingsKeyConstants.VIBRATE_SWITCH,
      defaultValue: '1',
      isCmpEqual: true,
      cmpValue: '1'
    };
    return DataShareUtils.getSettingUserEnableValue(param, isAsync);
  }

  /**
   * 返回响铃时是否振动
   */
  isVibrateWhenRing(): boolean {
    return this.shareValue;
  }
}

Object.defineProperty(VibrateSwitchEvent, 'eventTypeName', { value: 'VibrateSwitchEvent' });

/**
 * 状态栏图标使能开关事件
 */
export class EnableSwitchEvent extends DataShareEvent<boolean> {
  public static readonly defaultFalse = new Set(
    [
      SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED,
      SettingsKeyConstants.SHOW_NFC_ICON,
      SettingsKeyConstants.SHOW_HEAD_PHONES_ICON,
    ]
  )

  public static readonly defaultTrue = new Set(
    [
      SettingsKeyConstants.SHOW_VPN_ICON,
      SettingsKeyConstants.SHOW_RING_MODE_ICON,
      SettingsKeyConstants.SHOW_NEARLINK_ICON,
      SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON,
    ]
  )

  public subEventType: string = ''
  /**
   * 构造
   */
  constructor(subType: string) {
    super(EnableSwitchEvent);
    log.showInfo(`enable switch event constructor ${subType}`);
    this.subEventType = subType;
  }

  async init(): Promise<void> {
    log.showInfo('enable switch event init');
    this.dataShareUri = await DataShareUtils.getSettingsSecureUriAsync(this.subEventType);
  }

  private static getSwitchDefaultValue(subType: string): string {
    if (EnableSwitchEvent.defaultFalse.has(subType)) {
      return 'false';
    } else if(EnableSwitchEvent.defaultTrue.has(subType)) {
      return 'true';
    }
    return 'false';
  }

  /**
   * 刷新状态栏使能开关状态
   * @param isAsync 是否同步获取刷新数据
   * @return true 开关开启
   */
  async refreshShareValue(isAsync?: boolean): Promise<boolean> {
    const param: GetSettingSwitchParam = {
      uriKey: this.subEventType,
      defaultValue: EnableSwitchEvent.getSwitchDefaultValue(this.subEventType),
      isCmpEqual: true,
      cmpValue: 'true',
      needRetry: true,
    };
    return DataShareUtils.getSettingSecureEnableValue(param, isAsync);
  }
}

Object.defineProperty(EnableSwitchEvent, 'eventTypeName', { value: 'EnableSwitchEvent' });