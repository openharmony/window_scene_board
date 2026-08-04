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
import { relationalStore } from '@kit.ArkData';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { CompatibilityDataManager } from '../../CompatibilityDataManager';
import { RestoreCompatibilityInfo } from '../model/RestoreCompatibilityInfo';

/**
 * 备份端生成兼容性数据库信息，供恢复端使用
 * 该类供由数据库版本号升级导致的不兼容特性继承使用
 */
export abstract class DbBackupCompInfoAbs {
  private dbVersion: number;

  // 向前兼容最小版本号，默认是0: 例如30版本最多向前兼容到25，则该属性应设置25
  private lowestDbVersion: number = 0;

  constructor(dbVersion: number) {
    this.dbVersion = dbVersion;
  }

  public getDbVersion(): number {
    return this.dbVersion;
  }

  // 当备份端（旧机）数据库版本号大于恢复端（新机）数据库版本号时，需要做数据兼容性处理
  public async isNeedBackUpCompInfo(compInfo: RestoreCompatibilityInfo): Promise<boolean> {
    if (CheckEmptyUtils.isEmpty(compInfo) || CheckEmptyUtils.isEmpty(compInfo.dbVersion)) {
      return false;
    }
    let curDbVersion = await CompatibilityDataManager.getInstance().getCurDbVersion();
    let restoreDbVersion = compInfo.dbVersion;
    return this.dbVersion === curDbVersion && this.dbVersion > restoreDbVersion &&
      restoreDbVersion >= this.lowestDbVersion;
  }

  // 备份端：生成兼容性数据
  public abstract backupCompInfo(backupStore: relationalStore.RdbStore): Promise<void>;
}