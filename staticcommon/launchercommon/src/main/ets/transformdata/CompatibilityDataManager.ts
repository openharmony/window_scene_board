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

import { CheckEmptyUtils, FileUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { RestoreCompatibilityInfo } from './datacompatibility/model/RestoreCompatibilityInfo';
import { RestoreCompInfoProxy } from './datacompatibility/RestoreCompInfoProxy';
import { DbRestoreCompInfo } from './datacompatibility/restore/DbRestoreCompInfo';
import { ContextModifyUtils, GlobalContext, rdbStoreHelper } from '@ohos/frameworkwrapper';
import { common, contextConstant } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import { relationalStore } from '@kit.ArkData';
import { DbBackupCompInfoAbs } from './datacompatibility/backup/DbBackupCompInfoAbs';
import { CustomBackupCompInfoAbs } from './datacompatibility/backup/CustomBackupCompInfoAbs';
import { BackupConstants } from '../constants/BackupConstants';

const TAG = 'CompatibilityDataMananger';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

/**
 * 克隆备份兼容数据管理
 */
export class CompatibilityDataManager {
  private static sInstance: CompatibilityDataManager = null;
  // 所有需要处理克隆兼容的业务，可在此扩展兼容数据处理类
  private restoreCompInfoProxys: RestoreCompInfoProxy[] = [
    new DbRestoreCompInfo()
  ];
  // 所有数据库版本升级的特性，在此扩展兼容数据生成类
  private dbBackupCompInfoProcessors: DbBackupCompInfoAbs[] = [];
  // 所有业务自定义特性导致的不兼容，在次此扩展兼容数据生成类
  private customBackupCompInfoProcessors: CustomBackupCompInfoAbs[] = [];
  // 当前版本中数据库版本号
  private currentDbVersion: number = -1;

  private constructor() {
  }

  public static getInstance(): CompatibilityDataManager {
    if (CompatibilityDataManager.sInstance === null) {
      CompatibilityDataManager.sInstance = new CompatibilityDataManager();
    }
    return CompatibilityDataManager.sInstance;
  }

  /**
   * 恢复端返回自定义兼容校验信息
   *
   * @returns 自定义兼容校验信息
   */
  public async getRestoreCompatibilityInfo(): Promise<RestoreCompatibilityInfo> {
    try {
      let compatibilityInfo = new RestoreCompatibilityInfo();
      // 获取所有业务需要返回的兼容性校验数据
      for (let i = 0; i < this.restoreCompInfoProxys.length; i++) {
        await this.restoreCompInfoProxys[i].getRestoreCompInfo(compatibilityInfo);
      }
      log.showInfo(TAG, `getRestoreCompatibilityInfo success.`);
      return compatibilityInfo;
    } catch (e) {
      log.showError(TAG, 'getRestoreCompatibilityInfo error ' + e?.message);
    }
    return new RestoreCompatibilityInfo();
  }

  /**
   * 备份兼容性数据梳理：根据恢复端（新机）信息，在备份端（旧机）生成兼容性数据
   * 当前主要分为两大类：1、数据库版本号导致的不兼容处理 2、业务自定义的不兼容处理
   *
   * @param restoreCompInfo 恢复端返回的兼容校验信息
   */
  public async backUpCompInfo(restoreExtInfoInfo: string): Promise<void> {
    try {
      this.removeCompDbFile();
      let restoreCompInfo: RestoreCompatibilityInfo;
      if (CheckEmptyUtils.isEmpty(restoreExtInfoInfo)) {
        // 若恢复端无信息返回，则默认恢复端为基准数据库版本号
        restoreCompInfo = new RestoreCompatibilityInfo();
        restoreCompInfo.setDbVersion(BackupConstants.BASE_DB_VERSION);
      } else {
        let extObj = JSON.parse(restoreExtInfoInfo);
        let comStr: string = extObj.compatibilityInfo;
        restoreCompInfo = JSON.parse(comStr) as RestoreCompatibilityInfo;
        log.showInfo(TAG, `backUpCompInfo dbVersion ${restoreCompInfo.dbVersion}`);
      }

      let dbIndex: number = -1;
      let customIndex: number = -1;
      for (let index: number = 0; index < this.dbBackupCompInfoProcessors.length; ++index) {
        if (await this.dbBackupCompInfoProcessors[index].isNeedBackUpCompInfo(restoreCompInfo)) {
          dbIndex = index;
          break;
        }
      }
      for (let index: number = 0; index < this.customBackupCompInfoProcessors.length; ++index) {
        if (await this.customBackupCompInfoProcessors[index].isNeedBackUpCompInfo(restoreCompInfo)) {
          customIndex = index;
          break;
        }
      }
      // 如果数据库和自定义兼容处理都不需要，则直接返回
      if (dbIndex < 0 && customIndex < 0) {
        log.showInfo(TAG, 'do not need backup compatibility info.');
        return;
      }
      // 复制当前桌面数据库信息，作为兼容性数据的落盘库
      let rdbStore: relationalStore.RdbStore = await this.copyCompDataBase();
      if (CheckEmptyUtils.isEmpty(rdbStore)) {
        log.showError(TAG, 'backUpCompInfo copy data base fail.');
        return;
      }
      await this.createDbCompInfo(restoreCompInfo, rdbStore);
      await this.createCustomCompInfo(restoreCompInfo, rdbStore);
      rdbStore.close();
      log.showInfo(TAG, 'backUpCompInfo success.');
    } catch (e) {
      log.showError(TAG, 'backUpCompInfo error ' + e?.message)
    }
  }

  /**
   * 根据当前版本数据库升级文件，获取当前数据库版本号
   *
   * @returns 当前数据库版本号
   */
  public async getCurDbVersion(): Promise<number> {
    if (this.currentDbVersion !== -1) {
      return this.currentDbVersion;
    }
    this.currentDbVersion = await rdbStoreHelper.getDbVersionByUpgradeFile();
    // 数据库版本号最低基准版本为22
    if (this.currentDbVersion < BackupConstants.BASE_DB_VERSION) {
      this.currentDbVersion = BackupConstants.BASE_DB_VERSION;
    }
    return this.currentDbVersion;
  }

  /**
   * 备份前，先删除备份端本地残留的兼容数据文件
   */
  private removeCompDbFile(): void {
    let dataBaseDir = this.getDataBaseDir();
    let compDbFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_COMP_DB;
    FileUtils.deleteConfigFile(compDbFileDir);
    let compDbShmFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_COMP_SHM;
    FileUtils.deleteConfigFile(compDbShmFileDir);
    let compDbWalFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_COMP_WAL;
    FileUtils.deleteConfigFile(compDbWalFileDir);
  }

  /**
   * 备份端生成兼容性数据
   *
   * @param restoreCompInfo 恢复端传入的兼容信息
   * @param rdbStore 待处理的兼容性数据库
   */
  private async createDbCompInfo(restoreCompInfo: RestoreCompatibilityInfo,
    rdbStore: relationalStore.RdbStore): Promise<void> {
    let curDbVersion = await this.getCurDbVersion();
    let targetDbVersion = restoreCompInfo.dbVersion;
    // 按dbVersion倒序排列
    this.dbBackupCompInfoProcessors.sort((a, b) => {
      return b.getDbVersion() - a.getDbVersion();
    });
    let curDbIndex = this.dbBackupCompInfoProcessors.findIndex((item: DbBackupCompInfoAbs) => {
      return item.getDbVersion() === curDbVersion;
    });
    let targetDbIndex = this.dbBackupCompInfoProcessors.findIndex((item: DbBackupCompInfoAbs) => {
      return item.getDbVersion() === targetDbVersion + 1;
    });
    log.showInfo(TAG, `createDbCompInfo curDbIndex ${curDbIndex} targetDbIndex ${targetDbIndex}`);
    if (curDbIndex < 0 || targetDbIndex < 0 || targetDbIndex < curDbIndex) {
      return;
    }
    // 截取需要做兼容数据部分
    for (let index = curDbIndex; index <= targetDbIndex; index++) {
      await this.dbBackupCompInfoProcessors[index].backupCompInfo(rdbStore);
      rdbStore.version = this.dbBackupCompInfoProcessors[index].getDbVersion() - 1;
    }
  }

  private async createCustomCompInfo(restoreCompInfo: RestoreCompatibilityInfo,
    rdbStore: relationalStore.RdbStore): Promise<void> {
    for (let index = 0; index < this.customBackupCompInfoProcessors.length; index++) {
      if (this.customBackupCompInfoProcessors[index].isNeedBackUpCompInfo(restoreCompInfo)) {
        await this.customBackupCompInfoProcessors[index].backupCompInfo(restoreCompInfo, rdbStore);
      }
    }
  }

  private async copyCompDataBase(): Promise<relationalStore.RdbStore> {
    let dataBaseDir = this.getDataBaseDir();
    let curDbFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_DB;
    let compDbFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_COMP_DB;

    let curDbShmFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_SHM;
    let compDbShmFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_COMP_SHM;

    let curDbWalFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_WAL;
    let compDbWalFileDir: string = dataBaseDir + '/rdb/' + BackupConstants.HM_LAUNCHER_COMP_WAL;

    let launcherCompRdbStore: relationalStore.RdbStore = null;
    try {
      fs.copyFileSync(curDbFileDir, compDbFileDir);
      fs.copyFileSync(curDbShmFileDir, compDbShmFileDir);
      fs.copyFileSync(curDbWalFileDir, compDbWalFileDir);
      const launcherStoreConfig: relationalStore.StoreConfig = {
        name: BackupConstants.HM_LAUNCHER_COMP_DB,
        securityLevel: relationalStore.SecurityLevel.S1
      };
      launcherCompRdbStore = await relationalStore.getRdbStore((GlobalContext.getInstance()
        .getObject('desktopContext') as common.ServiceExtensionContext), launcherStoreConfig);
      log.showInfo(TAG, 'copyCompDataBase success.');
    } catch (err) {
      log.showError(TAG, `copyCompDataBase err : ${err.message}`);
    }
    return launcherCompRdbStore;
  }

  private getDataBaseDir(): string {
    let backContext: common.Context =
      GlobalContext.getInstance().getObject('desktopContext') as common.Context;
    let databaseDir = '';
    let callback: (callbackContext: common.Context) => void = (callbackContext: common.Context) => {
      databaseDir = callbackContext.databaseDir;
    };
    ContextModifyUtils.modifyTargetContext(backContext, contextConstant.AreaMode.EL1, callback,
      TAG, false);
    return databaseDir;
  }
}