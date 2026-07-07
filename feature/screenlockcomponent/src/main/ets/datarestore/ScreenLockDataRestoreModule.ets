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

import { CommonUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import relationalStore from '@ohos.data.relationalStore';
import commonEventManager from '@ohos.commonEventManager';
import { sSettingsUtil, AccountMgr, ContextModifyUtils } from '@ohos/frameworkwrapper';
import { ScreenLockOwnerInfo } from './ScreenLockOwnerInfoConfig';
import BackupExtensionContext from '@ohos.file.BackupExtensionContext';
import { contextConstant } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import Constants from '../common/Constants';

const TAG = 'ScreenLockDataRestoreModule';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const SCREENLOCKDB = 'locksettings.db';
const SCREENLOCKDB_BACK = 'locksettings_back.db';
const BACK_DATABASE_PATH = 'restore/com.openharmony.systemui';
const ACTIVITE_THEME_EVENT = 'com.ohos.ActivateTheme';
const ACTIVATE_FLAG: number = 1;
const SUB_USER_CONVERTS = 91 // 系统迁移子用户转换规则: 双的userId + 91
const DEFAULT_USER = 100;
const INVALID_USER_ID: number = -1;

export const KEY_OWNER_INFO_SWITCH: string = 'lock_screen_owner_info_enabled';
export const KEY_OWNER_INFO: string = 'lock_screen_owner_info';
export const OWNER_INFO_SWITCH: string = '1';

/**
 * screenlock restore data for Upgrade.
 */
export class ScreenLockDataRestoreModule {
  private context: BackupExtensionContext;
  private backupDatabaseDir: string = '';
  private backupDir: string = '';
  private mScreenLockRdbStore: relationalStore.RdbStore | undefined;
  private databaseDir: string = '';

  constructor(context: Context) {
    this.context = context as BackupExtensionContext;
    let callback = (contextCallback: Context) => {
      this.backupDir = (contextCallback as BackupExtensionContext).backupDir;
    };
    ContextModifyUtils.modifyTargetContext(context, contextConstant.AreaMode.EL2, callback, `${TAG}-constructor`,
      false);
  }

  public async startDataRestore(): Promise<void> {
    await this.startSignatureDataRestore().then(async () => {
      log.warn('startSignatureDataRestore data restore end.');
    }).catch((error: BusinessError) => {
      log.error(`startSignatureDataRestore message ${error?.message}`);
    });
  }

  protected async startSignatureDataRestore(): Promise<void> {
    this.databaseDir = this.context.databaseDir;
    this.backupDatabaseDir = this.backupDir + BACK_DATABASE_PATH;
    this.mScreenLockRdbStore = await this.copyScreenLockDb();
    await this.restoreOldScreenLockData();
    try {
      let publishData: commonEventManager.CommonEventPublishData = {
        parameters: {
          unlock: ACTIVATE_FLAG
        }
      };
      commonEventManager.publish(ACTIVITE_THEME_EVENT, publishData, (err) => {
        if (err) {
          log.showError('publish event failed');
        } else {
          log.showInfo('publish event success');
        }
      })
    } catch (e) {
      log.showError(`publish error:${e}`);
    }
  }

  protected async restoreOldScreenLockData(): Promise<void> {
    await this.saveDataToSettings();
    relationalStore.deleteRdbStore(this.context, SCREENLOCKDB, (err) => {
      if (err) {
        log.showError(`Delete SCREENLOCKDB RdbStore failed, code is ${err.code},message is ${err.message}`);
        return;
      }
      log.showInfo(`Delete SCREENLOCKDB RdbStore successfully.`);
    });
    relationalStore.deleteRdbStore(this.context, SCREENLOCKDB_BACK, (err) => {
      if (err) {
        log.showError(`Delete SCREENLOCKDB_BACK RdbStore failed, code is ${err.code},message is ${err.message}`);
        return;
      }
      log.showInfo(`Delete SCREENLOCKDB_BACK RdbStore successfully.`);
    });
  }

  protected async getUserId(): Promise<number> {
    try {
      let userId = await AccountMgr.getCurrentAccountId();
      if (!CommonUtils.isNumber(userId) || userId === INVALID_USER_ID) {
        log.showWarn('userId is invaild, use DEFAULT_USER instead');
        userId = DEFAULT_USER;
      }
      return userId;
    } catch (e) {
      log.showError('getCurrentAccountId failed');
    }
    return DEFAULT_USER;
  }

  protected async saveDataToSettings() {
    let screenLockOwnerInfo: ScreenLockOwnerInfo[] = await this.queryScreenLockSetting();
    let currentUserId = await this.getUserId();
    for (let i = 0; i <= screenLockOwnerInfo.length - 1; i++) {
      if (screenLockOwnerInfo[i].ownerInfoKey === KEY_OWNER_INFO_SWITCH) {
        let userId = this.getUserIdForOta(screenLockOwnerInfo[i].userId);
        if (userId === currentUserId) {
          let screenLockSignatureVisable = screenLockOwnerInfo[i].ownerInfoValue;
          sSettingsUtil.setSecureValue(KEY_OWNER_INFO_SWITCH,
            screenLockSignatureVisable === OWNER_INFO_SWITCH ? 'true' : 'false');
        }
      } else if (screenLockOwnerInfo[i].ownerInfoKey === KEY_OWNER_INFO) {
        let userId = this.getUserIdForOta(screenLockOwnerInfo[i].userId);
        if (userId === currentUserId) {
          let screenLockSignatureText: string =
            screenLockOwnerInfo[i].ownerInfoValue?.replace(Constants.EMOJI_REGEX, '');
          sSettingsUtil.setSecureValue(KEY_OWNER_INFO, screenLockSignatureText);
        }
      }
    }
  }

  protected getUserIdForOta(userId: string): number {
    let userIdNew: number = DEFAULT_USER;
    if (Number.parseInt(userId) < 0) {
      log.showInfo('invalid user id');
      return userIdNew;
    }
    if (userId !== '0') {
      userIdNew = Number.parseInt(userId) + SUB_USER_CONVERTS;
    }
    return userIdNew
  }

  public async queryScreenLockSetting(): Promise<ScreenLockOwnerInfo[]> {
    const SETTING_TABLE = 'locksettings';
    log.showInfo('queryScreenLockSettingByKey start');
    let backupSettingsInfoList: ScreenLockOwnerInfo[] = [];
    try {
      if (!this.mScreenLockRdbStore) {
        return backupSettingsInfoList;
      }
      let resultSet: relationalStore.ResultSet =
        await this.mScreenLockRdbStore.querySql(`SELECT name,user,value FROM ${SETTING_TABLE}`);
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let settingsInfo: ScreenLockOwnerInfo = {
          ownerInfoKey: resultSet.getString(resultSet.getColumnIndex('name')),
          userId: resultSet.getString(resultSet.getColumnIndex('user')),
          ownerInfoValue: resultSet.getString(resultSet.getColumnIndex('value'))
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError(`queryScreenLockSettingByKey error:${e}`);
    }
    return backupSettingsInfoList;
  }

  protected async copyScreenLockDb(): Promise<relationalStore.RdbStore | undefined> {
    if (FileUtils.isExist(this.backupDatabaseDir + '/' + SCREENLOCKDB)) {
      FileUtils.createFolder(this.databaseDir + '/rdb/');
      FileUtils.copyFile(this.backupDatabaseDir + '/' + SCREENLOCKDB, this.databaseDir + '/rdb/' + SCREENLOCKDB_BACK);
      const screenLockStoreConfig: relationalStore.StoreConfig = {
        name: SCREENLOCKDB_BACK,
        securityLevel: relationalStore.SecurityLevel.S1
      };
      log.showInfo('copyScreenLockDb finish');
      return relationalStore.getRdbStore(this.context, screenLockStoreConfig);
    }
    return undefined;
  }
}
