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
import { Context } from '@kit.AbilityKit';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SingletonHelper } from '@ohos/basicutils';

const TAG = 'StatusbarBackupManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

// 纯净显示映射系统开关默认值
export const SWITCH_DEFAULT_FALSE_FROM_PURE: string[] = [
  SettingsKeyConstants.SHOW_VPN_ICON,
  SettingsKeyConstants.SHOW_RING_MODE_ICON,
  SettingsKeyConstants.SHOW_NEARLINK_ICON,
  SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON,
  SettingsKeyConstants.SHOW_NFC_ICON,
  SettingsKeyConstants.SHOW_HEAD_PHONES_ICON,
]

export class StatusbarBackupManager {

  /**
   * 系统迁移、系统迁移 纯净显示、网速映射
   */
  saveSysSettingFromDouble(context: Context): void {
    try {
      this.setPureSetting(context, true);
      this.setSpeedSetting(context, true);
    } catch (e) {
      log.showInfo(`set double sys err, ${e?.message}`);
    }
  }

  /**
   * 单升单、单窗口单屏 纯净显示、网速映射
   */
  saveSysSettingFromSingle(context: Context): void {
    try {
      this.setPureSetting(context);
      this.setSpeedSetting(context);
    } catch (e) {
      log.showInfo(`set single sys err, ${e?.message}`);
    }
  }

  /**
   * 纯净显示映射
   */
  setPureSetting(context: Context, isOldVersion: boolean = false): void {
    let pureValue = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW);
    let isUpdated: boolean = false;
    if (pureValue === 'true' || pureValue === '1') {
      SWITCH_DEFAULT_FALSE_FROM_PURE.map((sysSetting) => {
        sSettingsUtil.setSecureValue(sysSetting, 'false', context);
      });
      isUpdated = true;
    }
    if (pureValue === 'false' || pureValue === '0') {
      SWITCH_DEFAULT_FALSE_FROM_PURE.map((sysSetting) => {
        sSettingsUtil.setSecureValue(sysSetting, 'true', context);
      });
      isUpdated = true;
    }
    // 双已升单|已克到单 纯净显示的值需置为无效
    if (isOldVersion || isUpdated) {
      sSettingsUtil.setSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW, '-1', context);
    }
    log.showInfo(`old pure: ${pureValue}, isOldVersion: ${isOldVersion}, isUpdated: ${isUpdated}`);
  }

  /**
   * 网速开关映射
   */
  setSpeedSetting(context: Context, isOldVersion: boolean = false): void {
    let oldValue = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED);
    let isUpdated: boolean = false;
    // 网速值存在且有效
    if (oldValue === 'true' || oldValue === 'false') {
      sSettingsUtil.setSecureValue(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED, oldValue, context);
      isUpdated = true;
    }
    // 双已升单|已克到单 网速的值需置为无效
    if (isOldVersion || isUpdated) {
      sSettingsUtil.setSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED, '-1', context);
    }
    log.showInfo(`old speed: ${oldValue}, isOldVersion: ${isOldVersion}, isUpdated: ${isUpdated}`);
  }

}

export const statusbarBackupManager: StatusbarBackupManager = SingletonHelper.getInstance(StatusbarBackupManager, TAG);