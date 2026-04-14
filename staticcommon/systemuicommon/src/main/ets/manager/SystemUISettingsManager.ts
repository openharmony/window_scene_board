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
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EnableSwitchEvent } from '../datasharemanager/SysUIDataShareEvent';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'SysUISettingsManager');

const NEW_STATUS_BAR_KEY = [
  SettingsKeyConstants.SHOW_VPN_ICON,
  SettingsKeyConstants.SHOW_RING_MODE_ICON,
  SettingsKeyConstants.SHOW_NEARLINK_ICON,
  SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON,
  SettingsKeyConstants.SHOW_NFC_ICON,
  SettingsKeyConstants.SHOW_HEAD_PHONES_ICON
]

/**
 * 通知和状态栏公共设置管理类
 */
export class SystemUISettingsManager {
  public static get = SingletonHelper.createFactory(() => new SystemUISettingsManager());
  /**
   * 设置->通知中心和状态栏开关默认设置
   */
  private systemUISwitchDefaultValue: Map<string, string | boolean> = new Map();

  public init(): void {
    this.setSecureSwitch();
  }

  /**
   * 通知和状态栏->状态栏/更多通知设置7个开关数据库为空时,将默认值写入数据库
   */
  private setSecureSwitch(): void {
    log.showInfo('set notification and statusbar secure switch');
    this.setSecureValue2();
    this.initSystemUISwitchDefaultValue();
    this.systemUISwitchDefaultValue.forEach((defaultVal, key) => {
      sSettingsUtil.getSecureValueAsync(key, '').then(value => {
        if (!value) {
          sSettingsUtil.setSecureValue(key, defaultVal.toString());
        }
      });
    });
  }

  private getDefaultValue(key): boolean {
    if (EnableSwitchEvent.defaultFalse.has(key)) {
      return false;
    } else if (EnableSwitchEvent.defaultTrue.has(key)) {
      return true;
    }
    return false;
  }

  private setSecureValue2(): void {
    try {
      let isPureUpdate: boolean = false;
      let pureValue = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW);
      // 一个开关为undefined说明其他都是undefined
      let nfcValue = sSettingsUtil.getSecureValue(SettingsKeyConstants.SHOW_NFC_ICON);
      log.showInfo(`get pure: ${pureValue}, typeof pure: ${typeof pureValue},` +
        `nfc: ${nfcValue}, typeof nfc: ${typeof nfcValue}`);
      // nfc没获取到值且老纯净显示值为true
      if (!nfcValue && (pureValue === 'true' || pureValue === '1')) {
        NEW_STATUS_BAR_KEY.map((key) => {
          sSettingsUtil.setSecureValue(key, 'false');
        })
        isPureUpdate = true;
        log.showInfo(`close nfc switch success`);
      } else if (!nfcValue && (pureValue === 'false' || pureValue === '0')) {
        NEW_STATUS_BAR_KEY.map((key) => {
          sSettingsUtil.setSecureValue(key, 'true');
        })
        isPureUpdate = true;
        log.showInfo(`open nfc switch success`);
      }
      // 纯净显示映射完成将旧纯净显示值设为不可用
      if (isPureUpdate === true) {
        sSettingsUtil.setSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW, '-1');
      }

      let oldSpeedValue = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED);
      let newSpeedValue = sSettingsUtil.getSecureValue(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED);
      log.showInfo(`get oldSpped: ${oldSpeedValue}, typeof oldSpeed: ${typeof oldSpeedValue},` +
        `newSpeed: ${newSpeedValue}, typeof newSpeed: ${typeof newSpeedValue}`);
      if (!newSpeedValue && (oldSpeedValue === 'true' || oldSpeedValue === 'false')) {
        sSettingsUtil.setSecureValue(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED, oldSpeedValue);
        // 网速映射完成将旧网速值设为不可用
        sSettingsUtil.setSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED, '-1');
        log.showInfo(`set new speed switch success`);
      }
    } catch (e) {
      log.showInfo(`init statusbar switch error: ${e?.message}`);
    }
  }

  private initSystemUISwitchDefaultValue(): void {
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON,
      SettingsConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON_DEFAULT);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.NTF_SCREEN_LOCK_STYLE,
      SettingsConstants.NTF_LOCK_SCREEN_STYLE_UPPER);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT,
      SettingsConstants.APP_NTF_HIDE_CONTENT_DEFAULT);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT,
      SettingsConstants.APP_LIVE_VIEW_HIDE_CONTENT_DEFAULT);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON,
      SettingsConstants.APP_NTF_SCREEN_ON_DEFAULT);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT,
      SettingsConstants.APP_NTF_CONFIG_HIDE_BANNER_CONTENT_DEFAULT);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES,
      SettingsConstants.NTF_SHOW_DESKTOP_BADGES_DEFAULT);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_CONTENT_KG,
      SettingsConstants.APP_NTF_CONFIG_SHOW_CONTENT_DEFAULT);
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED,
      this.getDefaultValue(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED));
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.SHOW_VPN_ICON,
      this.getDefaultValue(SettingsKeyConstants.SHOW_VPN_ICON));
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.SHOW_RING_MODE_ICON,
      this.getDefaultValue(SettingsKeyConstants.SHOW_RING_MODE_ICON));
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.SHOW_NEARLINK_ICON,
      this.getDefaultValue(SettingsKeyConstants.SHOW_NEARLINK_ICON));
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON,
      this.getDefaultValue(SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON));
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.SHOW_NFC_ICON,
      this.getDefaultValue(SettingsKeyConstants.SHOW_NFC_ICON));
    this.systemUISwitchDefaultValue.set(SettingsKeyConstants.SHOW_HEAD_PHONES_ICON,
      this.getDefaultValue(SettingsKeyConstants.SHOW_HEAD_PHONES_ICON));
  }
}
