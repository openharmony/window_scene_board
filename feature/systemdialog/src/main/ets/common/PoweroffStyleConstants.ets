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

export default class PowerOffStyleConstants {

  public static readonly POWEROFF_PIC_SIZE = 28;

  public static readonly POWEROFF_BUTTON_SIZE = 64;

  public static readonly POWEROFF_BUTTON_TEXT_FONT_HEIGHT = 19;

  public static readonly POWEROFF_BUTTON_TEXT_FONT_WIDTH = 52.5;

  public static readonly POWEROFF_BUTTON_TEXT_FONT_LINE_HEIGHT = 16;

  public static readonly POWEROFF_BUTTON_TEXT_FONT_SIZE = 14;

  public static readonly POWEROFF_TIPS_FONT_SIZE = 12;

  public static readonly POWEROFF_TIPS_PADDING = 15;

  public static readonly POWEROFF_BUTTON_MIN_SPACE = 40;

  public static readonly POWEROFF_FOLD_BUTTON_MIN_SPACE = 120;

  public static readonly POWEROFF_MAX_FONT_SCALE = 2;

  public static readonly POWEROFF_BUTTON_SPACE = '8vp';

  public static readonly POWEROFF_BACKGROUND_RADIUS = 67;

  public static readonly POWEROFF_BACKGROUND_SATURATION = 1;

  public static readonly POWEROFF_BACKGROUND_BRIGHTNESS = 1;

  public static readonly POWEROFF_TIMEOUT = 10;

  public static readonly POWEROFF_TIPS_SECTION_HEIGHT = 30;

  public static readonly POWEROFF_TIPS_SECTION_WIDTH = '75%';

  public static readonly POWEROFF_TIPS_SECTION_WIDTH_FULL = '100%';

  public static readonly POWEROFF_ANIMATION_SCALE = 1.125;

  public static readonly OUTER_HOME_FONT_LIMIT_LEVEL = 1.45;

  public static readonly OUTER_HOME_FOLD_BLANK_TOP_HEIGHT = '20%';

  public static readonly XT_FOLD_LARGE_FONT_SCALE_LIMIT = 3.125;

  public static readonly FOLD_STATUS_FOLDED = 2;
  /**
   * 定时开关机的开/关状态
   */
  public static readonly SCHEDULED_POWER_ON_OFF_SWITCH = 'settings.system.scheduled_power_on_off_switch';
  /**
   * 定时开机时间
   */
  public static readonly SCHEDULED_POWER_ON_TIMER_DATE = 'settings.system.power_on_timer_date';
  /**
   * 设置的bundleName
   */
  public static readonly SETTING_SERVICE_BUNDLE_NAME = 'com.ohos.settings';

  public static readonly SETTING_SERVICE_ABILITY_NAME = 'com.ohos.settings.ScheduledPowerCheckService';

  public static readonly SEND_POWER_OFF_CHECK_REMOTE = 'remote_check';

  public static readonly SEND_POWER_OFF_CHECK_REMOTE_NO_SELECT = '0';

  public static readonly INTERFACE_TOKEN = 'cancelScheduledPowerOn';
  /**
   * 锁屏解锁事件
   */
  public static readonly EVENT_SCREEN_UNLOCK = 'usual.event.SCREEN_UNLOCKED';
  /**
   * 关机验密开关
   */
  public static readonly FIND_DEVICE_TURN_OFF_VERIFY_STATUS = 'find_device_turn_off_verify_status';
  /**
   * 丢失模式开关
   */
  public static readonly FIND_DEVICE_REMOTE_LOCK = 'find_device_remote_lock';
  /**
   * 请求拉起密码认证控件失败最大重试次数
   */
  public static readonly USER_AUTH_MAX_RETRY_TIMES = 3;
  /**
   * 请求拉起密码认证控件超时时长300ms，请求超时则认为请求失败
   */
  public static readonly USER_AUTH_REQUEST_TIMEOUT = 300;
  /**
   * 请求拉起密码认证控件抛出异常后，等待100ms再重试
   */
  public static readonly USER_AUTH_ERROR_TIMEOUT = 100;
}