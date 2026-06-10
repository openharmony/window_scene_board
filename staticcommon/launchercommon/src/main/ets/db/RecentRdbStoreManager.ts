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

import {
  LogDomain,
  Logger,
  CheckEmptyUtils,
  SingletonHelper
} from '@ohos/basicutils';
import { RdbStoreConfig } from '@ohos/frameworkwrapper';
import { LockPreference, RecentLockUtils } from '../utils/RecentLockUtils';
import rdb from '@ohos.data.relationalStore';
import { rdbTaskPool } from './RdbTaskPool';
import RecentLockInfoColumns from './column/recentLockInfoColumns';

const TAG = 'RecentRdbStoreManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * Wrapper class for rdb interfaces.
 */
export class RecentRdbStoreManager {
  /**
   * 批量插入加锁container的信息
   * @param { LockPreference[]} recentParamList - 加锁卡片信息list.
   * @returns 插入数据库的数据个数
   */
  public async batchInsertRecentLock(recentParamList: LockPreference[]): Promise<number> {
    log.showInfo(TAG, `batchInsertOrUpdateRecentLock recentParamList.length: ${recentParamList?.length}`);
    if (CheckEmptyUtils.isEmptyArr(recentParamList)) {
      return -1;
    }
    try {
      let valueBucket : rdb.ValuesBucket[] = [];
      for (let param of recentParamList) {
        valueBucket.push(RecentLockUtils.toValuesBucket(param));
      }
      return await rdbTaskPool.batchInsert(RdbStoreConfig.recentLockInfo.tableName, valueBucket);
    } catch (err) {
      log.showError(TAG, `batchInsertOrUpdateRecentLock failed, code: ${err?.code}, message: ${err?.message}`);
    }
    return -1;
  }

  /**
   * 获取所有加锁应用的信息
   */
  public async getRecentLockList(): Promise<LockPreference[]> {
    log.showInfo(TAG, 'getRecentLockList start');
    let conditions: Map<string, rdb.ValueType> = new Map();
    return await rdbTaskPool.queryRecentLock(RdbStoreConfig.recentLockInfo.tableName, conditions);
  }

  /**
   * app卸载，从数据库中删除
   * @param { string } bundleName - 卡片的bundleName.
   * @param { number } appIndex - 卡片的appIndex.
   */
  public async deleteRecentLockForContainer(lockPreference: LockPreference): Promise<boolean> {
    log.showInfo(TAG, 'deleteRecentLock start');
    if (CheckEmptyUtils.isEmpty(lockPreference)) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(RecentLockInfoColumns.BUNDLE_NAME, lockPreference.bundleName);
    conditions.set(RecentLockInfoColumns.ABILITY_NAME, lockPreference.abilityName);
    conditions.set(RecentLockInfoColumns.MODULE_NAME, lockPreference.moduleName);
    conditions.set(RecentLockInfoColumns.APP_INDEX, lockPreference.appIndex);
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.recentLockInfo.tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(TAG, `deleteRecentLock delete ok:${changeRows}`);
      return true;
    }
    return false;
  }

  /**
   * app卸载，从数据库中删除
   * @param { string } bundleName - 卡片的bundleName.
   * @param { number } appIndex - 卡片的appIndex.
   */
  public async deleteRecentLock(bundleName: string, appIndex?: number): Promise<boolean> {
    log.showInfo(TAG, 'deleteRecentLock start');
    if (CheckEmptyUtils.isEmpty(bundleName) || (appIndex ?? 0) < 0) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(RecentLockInfoColumns.BUNDLE_NAME, bundleName);
    if (appIndex) {
      conditions.set(RecentLockInfoColumns.APP_INDEX, appIndex);
    }
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.recentLockInfo.tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(TAG, `deleteRecentLock delete ok:${changeRows}`);
      return true;
    }
    return false;
  }
}
export const recentRdbStoreManager: RecentRdbStoreManager = SingletonHelper.getInstance(RecentRdbStoreManager, TAG);