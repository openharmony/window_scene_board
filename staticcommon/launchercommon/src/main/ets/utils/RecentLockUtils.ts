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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import rdb from '@ohos.data.rdb';
import { SCBSceneInfo } from '@ohos/windowscene';;
const TAG = 'RecentLockUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

// 加锁app的信息
export interface LockPreference {
  bundleName: string,
  abilityName: string,
  moduleName: string,
  appIndex: number
}

/**
 * 应用加锁信息类
 */
export class RecentLockUtils {
  public static creatLockInfo(sceneInfo: SCBSceneInfo): LockPreference {
    let lockInfo: LockPreference = {
      bundleName: sceneInfo.bundleName,
      abilityName: sceneInfo.abilityName,
      moduleName: sceneInfo.moduleName,
      appIndex: sceneInfo.appIndex
    };
    return lockInfo;
  }

  /**
   * 将 LockPreference 转化为 ValuesBucket
   */
  public static toValuesBucket(recentLockParam: LockPreference): rdb.ValuesBucket {
    if (recentLockParam === null) {
      log.showError('recentLockParam error, recentLockParam is null');
      return {};
    }
    return {
      ['bundle_name']: recentLockParam.bundleName,
      ['ability_name']: recentLockParam.abilityName,
      ['module_name']: recentLockParam.moduleName,
      ['app_index']: recentLockParam.appIndex
    };
  }

  /**
   * 将 ResultSet 转换为 LockPreference
   */
  public static fromResultSet(resultSet: rdb.ResultSet): LockPreference | undefined {
    if (resultSet !== null) {
      const appCategoryInfo = {
        bundleName: resultSet.getString(resultSet.getColumnIndex('bundle_name')),
        abilityName: resultSet.getString(resultSet.getColumnIndex('ability_name')),
        moduleName: resultSet.getString(resultSet.getColumnIndex('module_name')),
        appIndex: resultSet.getLong(resultSet.getColumnIndex('app_index'))
      } as LockPreference;
      return appCategoryInfo;
    }
    return undefined;
  }
}