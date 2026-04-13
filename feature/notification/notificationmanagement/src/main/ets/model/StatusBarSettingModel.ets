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

import { HiDfxEventUtil, sSettingsUtil } from '@ohos/managementcomponent';
import { DESCRIPTION_INFO, INTENT_SWITCH, SWITCH_DEFAULT, USER_BEHAVIOR_KEY } from '../common/StatusBarSettingEnum';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';
import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { NotificationSysEventUtil } from '../common/NotificationSysEventUtil';
import { SettingsKeyConstants } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/constants';
import DataShare from '@ohos.data.dataShare';
import { osAccount } from '@kit.BasicServicesKit';

const TAG = 'StatusBarSettingModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Observed
export class StatusBarSettingModel {
  // 设备差异化
  public supportVibration: boolean = true;
  public supportNearLink: boolean = true;
  public supportNFC: boolean = true;
  // 开关状态
  public notification: boolean = this.getDefaultValue(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON);
  public netSpeed: boolean = this.getDefaultValue(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED);
  public vpnIcon: boolean = this.getDefaultValue(SettingsKeyConstants.SHOW_VPN_ICON);
  public ringMode: boolean = this.getDefaultValue(SettingsKeyConstants.SHOW_RING_MODE_ICON);
  public nearlink: boolean = this.getDefaultValue(SettingsKeyConstants.SHOW_NEARLINK_ICON);
  public alarmClock: boolean = this.getDefaultValue(SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON);
  public nfcIcon: boolean = this.getDefaultValue(SettingsKeyConstants.SHOW_NFC_ICON);
  public headPhones: boolean = this.getDefaultValue(SettingsKeyConstants.SHOW_HEAD_PHONES_ICON);

  private dataShareMap: Map<SettingsKeyConstants, IDataShare> = new Map();

  getDefaultValue(settingKey: SettingsKeyConstants): boolean {
    return SWITCH_DEFAULT.get(settingKey) ?? false;
  }

  getDescription(itemType: SettingsKeyConstants): Resource | undefined {
    if (itemType === SettingsKeyConstants.SHOW_RING_MODE_ICON) {
      if (!this.supportVibration) {
        return $r('app.string.enable_switch_ring_mode_silent')
      }
    } else if (itemType === SettingsKeyConstants.SHOW_NEARLINK_ICON) {
      if (!this.supportNearLink) {
        return $r('app.string.enable_switch_bluetooth')
      }
    }
    return DESCRIPTION_INFO.get(itemType);
  }

  public registerListenSettingData(): void {
    try {
      let mUriSecure = this.getSettingsSecureUriSync(SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED);
      DataShare.createDataShareHelper(ContextManager.getContext(), mUriSecure).then(async (dataShare) => {
        INTENT_SWITCH.map(async (key) => {
          let uri = await this.getSettingsSecureUriAsync(key as string);
          dataShare.on('dataChange', uri, this.handleDataShare.bind(this, key));
          this.dataShareMap.set(key, {
            uri: uri,
            dataShare: dataShare
          })
        })
      }).catch((error: Error) => {
        log.showError(`createDataShareHelper error: ${error?.message}`);
      });
    } catch (err) {
      log.showError(`registerListenSettingData error: ${err?.message}`);
    }
  }

  public async unRegisterListenSettingData(): Promise<void> {
    try {
      for (const key of this.dataShareMap.keys()) {
        let value = this.dataShareMap.get(key);
        value?.dataShare.off('dataChange', value.uri, this.handleDataShare.bind(this, key))
      }
    } catch (err) {
      log.showError(`unRegisterListenSettingData error: ${err?.message}`);
    }
  }

  private handleDataShare(key: SettingsKeyConstants): void {
    this.getSettingData(key);
  }

  async getSettingData(settingKey: SettingsKeyConstants): Promise<boolean> {
    const defaultValue = this.getDefaultValue(settingKey);
    let result: string = defaultValue ? 'true' : 'false';
    if (settingKey) {
      try {
        result = sSettingsUtil.getSecureValue(settingKey as string, result, ContextManager.getContext()) ?? '';
        this.setSwitchState(settingKey, result === 'true');
      } catch (e) {
        log.showError(`getSettingData error ${settingKey} ${e}`)
      }
    }
    log.showInfo(`getSettingData defaultValue: ${defaultValue} ${settingKey}`)
    return result == 'true';
  }

  async setSettingData(settingKey: SettingsKeyConstants, value: boolean): Promise<void> {
    log.showInfo(`setSettingData value: ${value}`)
    let result = true;
    if (settingKey) {
      try {
        result =
          sSettingsUtil.setSecureValue(settingKey as string, value ? 'true' : 'false', ContextManager.getContext());
        if (!result) {
          log.showError(`setSettingData error result ${result} ${settingKey}`)
          return Promise.resolve();
        }
        if (USER_BEHAVIOR_KEY.has(settingKey)) {
          // 用户行为打点，使能开关调整
          log.showInfo(`BEHAVIOR: ${settingKey} ${value}`)
          NotificationSysEventUtil.reportSysUiSettingModify(
            USER_BEHAVIOR_KEY.get(settingKey) ?? '', value ? HiDfxEventUtil.STATE_OPEN : HiDfxEventUtil.STATE_CLOSE
          );
        }
        this.setSwitchState(settingKey, value);
      } catch (e) {
        log.showError(`setSettingData error ${settingKey} ${e}`)
      }
    }
    return Promise.resolve();
  }

  private static instance?: StatusBarSettingModel = undefined;

  static getInstance(): StatusBarSettingModel {
    if (StatusBarSettingModel.instance === undefined) {
      StatusBarSettingModel.instance = new StatusBarSettingModel();
    }
    return StatusBarSettingModel.instance;
  }

  setSwitchState(settingKey: SettingsKeyConstants, newValue: boolean) {
    log.showInfo(`setSwitchState settingKey: ${settingKey}, newValue: ${newValue}`)
    switch (settingKey) {
      case SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON:
        this.notification = newValue
        break
      case SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED:
        this.netSpeed = newValue;
        break
      case SettingsKeyConstants.SHOW_VPN_ICON:
        this.vpnIcon = newValue;
        break
      case SettingsKeyConstants.SHOW_RING_MODE_ICON:
        this.ringMode = newValue;
        break
      case SettingsKeyConstants.SHOW_NEARLINK_ICON:
        this.nearlink = newValue;
        break
      case SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON:
        this.alarmClock = newValue;
        break
      case SettingsKeyConstants.SHOW_NFC_ICON:
        this.nfcIcon = newValue;
        break
      case SettingsKeyConstants.SHOW_HEAD_PHONES_ICON:
        this.headPhones = newValue;
        break
    }
  }

  getSwitchState(itemType: SettingsKeyConstants): boolean {
    switch (itemType) {
      case SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON:
        return this.notification;
      case SettingsKeyConstants.SHOW_REAL_TIME_NETWORK_SPEED:
        return this.netSpeed;
      case SettingsKeyConstants.SHOW_VPN_ICON:
        return this.vpnIcon;
      case SettingsKeyConstants.SHOW_RING_MODE_ICON:
        return this.ringMode;
      case SettingsKeyConstants.SHOW_NEARLINK_ICON:
        return this.nearlink;
      case SettingsKeyConstants.SHOW_ALARM_CLOCK_ICON:
        return this.alarmClock;
      case SettingsKeyConstants.SHOW_NFC_ICON:
        return this.nfcIcon;
      case SettingsKeyConstants.SHOW_HEAD_PHONES_ICON:
        return this.headPhones;
    }
    return false;
  }

  getSettingsSecureUriSync(uriKey: string): string {
    const SETTINGS_SECURE_URI_KEY = 'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_100?Proxy=true&key=';
    return SETTINGS_SECURE_URI_KEY + uriKey;
  }

  async getSettingsSecureUriAsync(uriKey: string): Promise<string> {
    const SETTINGS_SECURE_URI_PREFIX = 'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_';
    const currentUserId = await osAccount.getAccountManager().getOsAccountLocalId();
    return SETTINGS_SECURE_URI_PREFIX + currentUserId + '?Proxy=true&key=' + uriKey;
  }
}

interface IDataShare {
  uri: string;
  dataShare: DataShare.DataShareHelper;
}