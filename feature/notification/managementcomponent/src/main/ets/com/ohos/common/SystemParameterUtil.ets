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

import systemParameterEnhance from '@ohos.systemParameterEnhance';
import osAccount from '@ohos.account.osAccount';
import vibrator from '@ohos.vibrator';
import { BitUtil, LogDomain, LogHelper } from './BasicCommon';

const TAG = 'SysUI_SmartNotificationUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/** 设备支持swing能力参数的key */
const CONFIG_SWING_ENABLE = 'const.config.swing_enabled';
/** 设备屏蔽智能提醒功能参数的key */
const CONFIG_SMART_NTF_DISABLED = 'const.systemui.smart_notification_disabled';

/** 设备定制智能提醒开关开放策略 */
enum SmartNtfPolicy {
  /** 屏蔽智能提醒 */
  DISABLED = 'true',
  /** 开放智能提醒 */
  ENABLED = 'false',
}

/** 当前设备是否支持Swing能力 */
enum DeviceSupportSwing {
  /** 支持Swing */
  SUPPORT = '1',
  /** 不支持Swing */
  NOT_SUPPORT = '0',
}

/**
 * 智能提醒功能 工具类
 */
export class SystemParameterUtil {
  /** 当前设备是否屏蔽智能提醒功能 */
  public static readonly SMART_NTF_DISABLED =
    systemParameterEnhance.getSync(CONFIG_SMART_NTF_DISABLED, SmartNtfPolicy.ENABLED) === SmartNtfPolicy.DISABLED;
  /** 当前设备是否支持SWING */
  public static readonly DEVICE_SUPPORT_SWING =
    systemParameterEnhance.getSync(CONFIG_SWING_ENABLE, DeviceSupportSwing.NOT_SUPPORT) === DeviceSupportSwing.SUPPORT;

  public static readonly IS_SUPPORT_VIBRATE: boolean =
    systemParameterEnhance.getSync('const.vibrator.support_vibrator', 'true') === 'true';

  private static readonly VIBRATE_IDX_IN_REMINDER: number = 4;

  /**
   * 当前 设备#用户 环境下是否开放智能提醒开关
   * @returns true: 当前设备、当前用户 可以开放智能提醒开关
   */
  public static async isSupportSmartNtf(): Promise<boolean> {
    const isMainOsAccount = await osAccount.getAccountManager().isMainOsAccount();
    return isMainOsAccount && !SystemParameterUtil.SMART_NTF_DISABLED && SystemParameterUtil.DEVICE_SUPPORT_SWING;
  }

  /**
   * 当前设备硬件是否支持弱振动功能
   * @returns true: 当前设备支持弱振动
   */
  public static isSupportHdHaptic(): boolean {
    try {
      return vibrator.isHdHapticSupported();
    } catch (err) {
      log.showError(`isHdHapticSupported unexpected error, code: ${err?.code}, message: ${err?.message}`);
      return false;
    }
  }

  /**
   * 根据设备是否支持振动计算remindMode
   *
   * @param baseRemindMode 原始remindMode
   * @returns 计算后的remindMode
   */
  public static calcRemindModeByVibrateSupport(baseRemindMode: number): number {
    if (SystemParameterUtil.IS_SUPPORT_VIBRATE) {
      return baseRemindMode;
    } else {
      return BitUtil.changeByIdx(baseRemindMode, SystemParameterUtil.VIBRATE_IDX_IN_REMINDER, false);
    }
  }
}