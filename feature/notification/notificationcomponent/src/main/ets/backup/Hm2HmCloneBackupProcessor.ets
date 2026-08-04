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
import { CloneParam, BackupBaseProcessor } from './BackupBaseProcessor';
import { Context } from '@kit.AbilityKit';
import { NotificationBackupManager } from './NotificationBackupManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BitUtil, NotificationConfigEntity, notificationStore } from '@ohos/systemuicommon';
import { NotificationBackupAppSettingStore } from './database/NotificationBackupAppSettingStore';
import { NotificationBackupConfigEntity } from './model/NotificationBackupConfigEntity';
import { statusbarBackupManager } from './StatusbarBackupManager';
import { NotificationBackupEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationBackupEntity';

const TAG = 'NtfHm2HmCloneBackupProcessor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


const NTF_SETTING_PATH = 'restore/data/storage/el1/database/rdb/';
const NTF_SETTING_FILE = 'AppNotificationSetting.db';
const NTF_SETTING_SHM_FILE = 'AppNotificationSetting.db-shm';
const NTF_SETTING_WAL_FILE = 'AppNotificationSetting.db-wal';
const NTF_SETTING_BACK_UP_FILE = 'AppNotificationSetting_backup.db';
const NTF_SETTING_BACK_UP_SHM_FILE = 'AppNotificationSetting_backup.db-shm';
const NTF_SETTING_BACK_UP_WAL_FILE = 'AppNotificationSetting_backup.db-wal';


/**
 * 单窗口单屏场景processor
 * 涉及开关：置顶开关
 */
export class Hm2HmCloneBackupProcessor extends BackupBaseProcessor {
  private ntfConfigData: NotificationBackupConfigEntity[] = [];

  public saveFunc: () => Promise<void> = (async () => {
    await this.init();
    this.save();
  });

  constructor(context: Context) {
    super(context);
  }

  public backupPathList(): CloneParam[] {
    return [{
      sourcePath: this.baseBackupPath + NTF_SETTING_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_SETTING_FILE,
      targetFile: NTF_SETTING_BACK_UP_FILE
    }, {
      sourcePath: this.baseBackupPath + NTF_SETTING_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_SETTING_SHM_FILE,
      targetFile: NTF_SETTING_BACK_UP_SHM_FILE
    }, {
      sourcePath: this.baseBackupPath + NTF_SETTING_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_SETTING_WAL_FILE,
      targetFile: NTF_SETTING_BACK_UP_WAL_FILE
    }];
  }

  public resetData(): void {
    this.ntfConfigData = [];
  }

  private async init(): Promise<void> {
    await NotificationBackupAppSettingStore.get().init(this.context);
    this.ntfConfigData = await NotificationBackupConfigEntity.queryListByProps({}, {
      columns:['bundle', 'pinTop']
    });
    log.showInfo(`init data, ntfMgrCommonData size : ${this.ntfConfigData.length}`);
  }

  private save(): void {
    this.savePinTopData();
    statusbarBackupManager.saveSysSettingFromSingle(this.context);
  }

  private savePinTopData(): void {
    log.showInfo(`writeToPinTopBackupDb, ${this.ntfConfigData.length}`);
    for (const setting of this.ntfConfigData.filter((setting) => setting?.bundle)) {
      NotificationBackupManager.get().setBackup(setting.bundle!, {
        isPinTop: setting?.pinTop,
        isPkgName: false
      } as NotificationBackupEntity);
    }
  }
}