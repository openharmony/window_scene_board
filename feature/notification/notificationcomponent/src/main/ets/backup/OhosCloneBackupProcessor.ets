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
import { CloneParam, BackupBaseProcessor, NtfHwRemindFlagIdxEnum } from './BackupBaseProcessor';
import { Context } from '@kit.AbilityKit';
import { NotificationBackupManager } from './NotificationBackupManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsKeyConstants } from '@ohos/commonconstants';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { BitUtil } from '@ohos/systemuicommon';
import { NotificationBackupPhoneMgrStore } from './database/NotificationBackupPhoneMgrStore';
import {
  NotificationBackupPhoneMgrCommonEntity
} from './model/NotificationBackupPhoneMgrCommonEntity';
import {
  NotificationBackupPhoneMgrNtfCfgEntity
} from './model/NotificationBackupPhoneMgrNtfCfgEntity';
import {
  NotificationBackupPhoneMgrNtfEntity
} from './model/NotificationBackupPhoneMgrNtfEntity';
import { statusbarBackupManager } from './StatusbarBackupManager';
import { NotificationBackupEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationBackupEntity';

const TAG = 'NtfOhosCloneBackupProcessor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


const NTF_MGR_PATH = 'restore/';
const NTF_MGR_FILE = 'phoneManager.db';
const NTF_MGR_SHM_FILE = 'phoneManager.db-shm';
const NTF_MGR_WAL_FILE = 'phoneManager.db-wal';
const NTF_MGR_BACK_UP_FILE = 'phoneManager_back.db';
const NTF_MGR_BACK_UP_SHM_FILE = 'phoneManager_back.db-shm';
const NTF_MGR_BACK_UP_WAL_FILE = 'phoneManager_back.db-wal';

const PIN_TOP_DB_KEY = 'topNotificationsDatabase';
const WAKE_UP_SCREEN_ON_DB_KEY = 'wakeup_when_receive_notification';

/**
 * 系统迁移场景processor
 * 涉及开关：通知亮屏显示开关、允许通知开关、置顶开关、提醒方式、响铃震动开关
 */
export class OhosCloneBackupProcessor extends BackupBaseProcessor {
  private ntfMgrCommonData: NotificationBackupPhoneMgrCommonEntity[] = [];
  private ntfMgrData: NotificationBackupPhoneMgrNtfEntity[] = [];
  private ntfMgrCfgData: NotificationBackupPhoneMgrNtfCfgEntity[] = [];

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
      targetFile: NTF_MGR_BACK_UP_FILE
    }, {
      sourcePath: this.baseBackupPath + NTF_MGR_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_MGR_SHM_FILE,
      targetFile: NTF_MGR_BACK_UP_SHM_FILE
    }, {
      sourcePath: this.baseBackupPath + NTF_MGR_PATH,
      targetPath: this.baseRestorePath,
      sourceFile: NTF_MGR_WAL_FILE,
      targetFile: NTF_MGR_BACK_UP_WAL_FILE
    }];
  }

  public resetData(): void {
    this.ntfMgrCommonData = [];
    this.ntfMgrData = [];
    this.ntfMgrCfgData = [];
  }

  private async init(): Promise<void> {
    await NotificationBackupPhoneMgrStore.get().init(this.context);
    this.ntfMgrCommonData = await NotificationBackupPhoneMgrCommonEntity.queryListByProps({});
    this.ntfMgrData = await NotificationBackupPhoneMgrNtfEntity.queryListByProps({});
    this.ntfMgrCfgData = await NotificationBackupPhoneMgrNtfCfgEntity.queryListByProps({});
    log.showInfo(`init data, ntfMgrCommonData size : ${this.ntfMgrCommonData.length}, ntfMgrData size : ${this
      .ntfMgrData.length}, ntfMgrCfgData size : ${this.ntfMgrCfgData}`);
  }

  private save(): void {
    this.saveSysSetting();
    this.saveNotificationEnable();
    this.saveRemindData();
    this.savePinTopData();
    statusbarBackupManager.saveSysSettingFromDouble(this.context);
  }

  private saveNotificationEnable(): void {
    log.showInfo(`saveNotificationEnable, size: ${this.ntfMgrData.length}`);
    for (const enable of this.ntfMgrData) {
      log.showInfo(`saveNotificationEnable, ${enable.appName}, ${enable.isNotificationEnable}`);
      NotificationBackupManager.get().setBackup(enable.appName, {
        notificationEnable: enable?.isNotificationEnable === 'true',
        isPkgName: true
      } as NotificationBackupEntity);
    }
  }

  private saveSysSetting(): void {
    let wakeUpNotificationSetting =
      this.ntfMgrCommonData.find((value) => value.preferenceKey === WAKE_UP_SCREEN_ON_DB_KEY)?.preferenceValue;
    if (wakeUpNotificationSetting) {
      log.showInfo(`saveSysSetting, wakeUpNotificationSetting: ${wakeUpNotificationSetting}`);
      sSettingsUtil.setSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON,
        wakeUpNotificationSetting === '1' ? 'true' : 'false', this.context);
    }
  }

  private async saveRemindData(): Promise<void> {
    log.showInfo(`saveRemindData, size: ${this.ntfMgrCfgData?.length}`);
    for (const entity of this.ntfMgrCfgData) {
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
    let pinTop = this.ntfMgrCommonData.find((value) => value.preferenceKey === PIN_TOP_DB_KEY)?.preferenceValue;
    log.showInfo(`writeToPinTopBackupDb, ${pinTop}`);
    if (!pinTop) {
      return;
    }
    let dbEntries = pinTop.split(';');
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