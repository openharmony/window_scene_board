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
import { CloneParam, BackupBaseProcessor as BackupBaseProcessor, NtfHwRemindFlagIdxEnum } from './BackupBaseProcessor';
import { Context } from '@kit.AbilityKit';
import { NotificationBackupNtfMgrStore } from './database/NotificationBackupNtfMgrStore';
import { NotificationBackupAppCfgEntity } from './model/NotificationBackupAppCfgEntity';
import { NotificationBackupManager } from './NotificationBackupManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { BitUtil } from '@ohos/systemuicommon';
import { statusbarBackupManager } from './StatusbarBackupManager';
import { NotificationBackupEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationBackupEntity';

const TAG = 'NtfOhosMigrateBackupProcessor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


const NTF_MGR_PATH = 'restore/';
const NTF_MGR_FILE = 'notificationmgr.db';
const NTF_MGR_SHM_FILE = 'notificationmgr.db-shm';
const NTF_MGR_WAL_FILE = 'notificationmgr.db-wal';
const PIN_TOP_SETTING_KEY = 'top_notifications_database';

/**
 * 系统迁移场景processor
 * 涉及开关：置顶开关、提醒方式、响铃震动开关
 */
export class OhosMigrateBackupProcessor extends BackupBaseProcessor {
  private ntfMgrData: NotificationBackupAppCfgEntity[] = [];

  public saveFunc: () => Promise<void> = (async () => {
    await this.init();
    this.save();
  });

  constructor(context: Context) {
    super(context);
  }

  public backupPathList(): CloneParam[] {
    return [{
      sourcePath: this.baseBackupPath + NTF_MGR_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_MGR_FILE,
      targetFile: NTF_MGR_FILE
    }, {
      sourcePath: this.baseBackupPath + NTF_MGR_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_MGR_SHM_FILE,
      targetFile: NTF_MGR_SHM_FILE
    }, {
      sourcePath: this.baseBackupPath + NTF_MGR_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_MGR_WAL_FILE,
      targetFile: NTF_MGR_WAL_FILE
    }];
  }

  public resetData(): void {
    this.ntfMgrData = [];
  }

  private async init(): Promise<void> {
    await NotificationBackupNtfMgrStore.get().init(this.context);
    this.ntfMgrData = await NotificationBackupAppCfgEntity.queryListByProps({});
    log.showInfo(`init data, ntfMgrData size : ${this.ntfMgrData.length}`);
  }

  private save(): void {
    this.saveRemindData();
    this.savePinTopData();
    statusbarBackupManager.saveSysSettingFromDouble(this.context);
  }

  private saveRemindData(): void {
    log.showInfo(`saveRemindData, size: ${this.ntfMgrData?.length}`);
    for (const entity of this.ntfMgrData) {
      if (!entity?.packageName || entity?.state === undefined) {
        log.showWarn(`invalid data, ${entity?.packageName}`);
        continue;
      }
      NotificationBackupManager.get().setBackup(entity.packageName, {
        lockNotifyEnable: String(BitUtil.getStateByIdx(entity.state, NtfHwRemindFlagIdxEnum.LOCK_SCREEN) ? 1 : 0),
        bannerNotifyEnable: String(BitUtil.getStateByIdx(entity.state, NtfHwRemindFlagIdxEnum.BANNER) ? 1 : 0),
        soundEnable: String(BitUtil.getStateByIdx(entity.state, NtfHwRemindFlagIdxEnum.SOUND) ? 1 : 0),
        vibrationEnable: String(BitUtil.getStateByIdx(entity.state, NtfHwRemindFlagIdxEnum.VIBRATION) ? 1 : 0),
        isPkgName: true
      } as NotificationBackupEntity);
    }
  }

  private savePinTopData(): void {
    // 通过设置恢复置顶设备数据到设备，通知恢复时读取解析入库
    let pinTop = sSettingsUtil.getSecureValue(PIN_TOP_SETTING_KEY, '', this.context);
    this.writeToPinTopBackupDbWithPkgName(pinTop);
  }

  private writeToPinTopBackupDbWithPkgName(topNotificationsDatabase: string): void {
    log.showInfo(`writeToPinTopBackupDb, ${topNotificationsDatabase}`);
    if (!topNotificationsDatabase) {
      return;
    }
    let dbEntries = topNotificationsDatabase.split(';');
    for (const dbEntry of dbEntries) {
      let keys = dbEntry.split(':');
      log.showInfo(`keys : ${dbEntry}`);
      if (keys && keys.length > 1) {
        NotificationBackupManager.get().setBackup(keys[0], {
          isPinTop: keys[1] === '0',
          isPkgName: true
        } as NotificationBackupEntity);
      }
    }
  }
}