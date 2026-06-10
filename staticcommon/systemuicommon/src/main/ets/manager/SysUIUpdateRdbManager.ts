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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import relationalStore from '@ohos.data.relationalStore';

const TAG = 'SystemUIUpdateRdbManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const NOTIFICATION_STATE_LOCK_SCREEN_BIT = 0;
const NOTIFICATION_STATE_HEADS_UP_BIT = 1;
const NOTIFICATION_STATE_RINGTONE_BIT = 2;
const NOTIFICATION_STATE_VIBRATE_BIT = 3;

class SysUIUpdateRdbManager {
  private mNotificationRdbStore: relationalStore.RdbStore = null;

  static getInstance(): SysUIUpdateRdbManager {
    if (globalThis.SysUIUpdateRdbManagerInstance == null) {
      globalThis.SysUIUpdateRdbManagerInstance = new SysUIUpdateRdbManager();
    }
    return globalThis.SysUIUpdateRdbManagerInstance;
  }

  /**
   * set the notificationRdbStore
   *
   * @param notificationRdbStore notificationRdbStore
   */
  public async setNotificationRdbStore(notificationRdbStore: relationalStore.RdbStore): Promise<void> {
    log.showInfo('set the notificationRdbStore');
    this.mNotificationRdbStore = notificationRdbStore;
  }

  public async queryNotificationSetting(): Promise<BackupNotificationSettingsInfo[]> {
    const SETTING_TABLE = 'comhuaweisystemmanagerCommonPrefBackupProviderCommonPreferences_tb';
    log.showInfo('queryNotificationSetting start');
    let backupSettingsInfoList: BackupNotificationSettingsInfo[] = [];
    try {
      let resultSet: relationalStore.ResultSet = await this.mNotificationRdbStore.querySql(`SELECT preference_key, preference_value FROM ${SETTING_TABLE}`);
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let settingsInfo: BackupNotificationSettingsInfo = {
          preferenceKey: resultSet.getString(resultSet.getColumnIndex('preference_key')),
          preferenceValue: resultSet.getString(resultSet.getColumnIndex('preference_value'))
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError('queryNotificationSetting error:' + e);
    }
    log.showInfo(`queryNotificationSetting backupInfoList length = ${backupSettingsInfoList.length}`);
    return backupSettingsInfoList;
  }

  // 查询通知开关
  public async queryNotificationEnable(): Promise<BackupNotificationEnable[]> {
    const SETTING_TABLE = 'comhuaweisystemmanagerNotificationDBProvidernotification_rulepreference_tb';
    log.showInfo('queryNotificationEnable start');
    let backupSettingsInfoList: BackupNotificationEnable[] = [];
    try {
      let resultSet: relationalStore.ResultSet = await this.mNotificationRdbStore.querySql(`SELECT appname, isNofiticationEnable FROM ${SETTING_TABLE}`);
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let settingsInfo: BackupNotificationEnable = {
          appname: resultSet.getString(resultSet.getColumnIndex('appname')),
          isNotificationEnable: resultSet.getString(resultSet.getColumnIndex('isNofiticationEnable'))
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError('queryNotificationEnable error:' + e);
    }
    log.showInfo(`queryNotificationEnable backupInfoList length = ${backupSettingsInfoList.length}`);
    return backupSettingsInfoList;
  }

  // 查询横幅通知，锁屏通知，铃声，震动
  public async queryNotificationEnableSetting(): Promise<BackupNotificationEnableSettingsInfo[]> {
    const SETTING_TABLE = 'comhuaweisystemmanagerNotificationDBProvidernotificationAppCfg_tb';
    log.showInfo('queryNotificationEnableSetting start');
    let backupSettingsInfoList: BackupNotificationEnableSettingsInfo[] = [];
    try {
      let resultSet: relationalStore.ResultSet = await this.mNotificationRdbStore.querySql(`SELECT packageName, state FROM ${SETTING_TABLE}`);
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let state = parseInt(resultSet.getString(resultSet.getColumnIndex('state')));
        let lockNotifyEnableState = (state >> NOTIFICATION_STATE_LOCK_SCREEN_BIT) & 0x01;
        let bannerNotifyEnableState = (state >> NOTIFICATION_STATE_HEADS_UP_BIT) & 0x01;
        let soundEnableState = (state >> NOTIFICATION_STATE_RINGTONE_BIT) & 0x01;
        let vibrationEnableState = (state >> NOTIFICATION_STATE_VIBRATE_BIT) & 0x01;
        let settingsInfo: BackupNotificationEnableSettingsInfo = {
          packageName: resultSet.getString(resultSet.getColumnIndex('packageName')),
          bannerNotifyEnable: bannerNotifyEnableState.toString(),
          lockNotifyEnable: lockNotifyEnableState.toString(),
          soundEnable: soundEnableState.toString(),
          vibrationEnable: vibrationEnableState.toString()
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError('queryNotificationEnableSetting error:' + e);
    }
    log.showInfo(`queryNotificationEnableSetting backupInfoList length = ${backupSettingsInfoList.length}`);
    return backupSettingsInfoList;
  }

  public async queryNotificationAppSetting(): Promise<BackupNotificationAppSettingsInfo[]> {
    const APP_SETTING_TABLE = 'NotificationConfig';
    log.showInfo('queryNotificationAppSetting start');
    let backupSettingsInfoList: BackupNotificationAppSettingsInfo[] = [];
    try {
      let resultSet: relationalStore.ResultSet = await this.mNotificationRdbStore.querySql(`SELECT bundle, uid, pinTop FROM ${APP_SETTING_TABLE}`);
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let settingsInfo: BackupNotificationAppSettingsInfo = {
          appBundle: resultSet.getString(resultSet.getColumnIndex('bundle')),
          uid: resultSet.getString(resultSet.getColumnIndex('uid')),
          key: '',
          pinTopEnable: resultSet.getString(resultSet.getColumnIndex('pinTop')),
          bannerNotifyEnable: '',
          lockNotifyEnable: '',
          soundEnable: '',
          vibrationEnable: ''
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError('queryNotificationAppSetting error:' + e);
    }
    log.showInfo(`queryNotificationAppSetting backupInfoList length = ${backupSettingsInfoList.length}`);
    return backupSettingsInfoList;
  }
}

export { SysUIUpdateRdbManager };

export class BackupSettingsInfo {
  public filename: string;

  public id: number;

  public name: string;

  public type: string;

  public value: string;
}

export class BackupNotificationSettingsInfo {
  public preferenceKey: string;

  public preferenceValue: string;
}

export class BackupNotificationEnable {
  public appname: string;

  public isNotificationEnable: string;
}

export class BackupNotificationEnableSettingsInfo {
  public packageName: string;

  public bannerNotifyEnable: string;

  public lockNotifyEnable: string;

  public soundEnable: string;

  public vibrationEnable: string;
}

export class BackupNotificationAppSettingsInfo {
  public appBundle: string;

  public uid: string;

  public key: string;

  public pinTopEnable: string;

  public bannerNotifyEnable: string;

  public lockNotifyEnable: string;

  public soundEnable: string;

  public vibrationEnable: string;
}