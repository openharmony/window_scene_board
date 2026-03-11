/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import RdbStoreConfig from './RdbStoreConfig';
import { rdbStoreHelper } from './RdbStoreHelper';
import rdb from '@ohos.data.relationalStore';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'RdbStorePersistManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * session持久化的数据库管理类
 */
export class RdbStorePersistManager {
  /**
   * 插入持久化数据
   *
   * @param userId 用户id
   * @param strData 插入的数据
   */
  private static insertPersistData(userId: number, strData: string): void {
    const insertData: rdb.ValuesBucket = {
      'id': userId,
      'data': strData
    };
    rdbStoreHelper.insert(RdbStoreConfig.sessionPersistInfo.tableName, insertData).then((rows: number) => {
      log.showInfo(`insert data successful, row : ${rows}`);
    }).catch((err: BusinessError) => {
      log.showError(`insert data failed, code : ${err.code}, message : ${err.message}`);
    });
  }

  /**
   * 更新持久化数据
   *
   * @param userId 用户id
   * @param strData 更新的数据
   * @returns
   */
  static async upsertPersistData(userId: number, strData: string): Promise<void> {
    const updateData: rdb.ValuesBucket = {
      'data': strData
    };
    let predicates = new rdb.RdbPredicates(RdbStoreConfig.sessionPersistInfo.tableName)
      .equalTo('id', userId);
    rdbStoreHelper.update(predicates, updateData).then((rows: number) => {
      if (rows !== 1) {
        RdbStorePersistManager.insertPersistData(userId, strData);
      }
    }).catch((err: BusinessError) => {
      log.showError(`upsert persist data failed, code : ${err.code}, message : ${err.message}`);
      RdbStorePersistManager.insertPersistData(userId, strData);
    });
  }

  /**
   * 查询持久化数据
   *
   * @param userId 用户id
   * @returns 查询到的数据
   */
  static async queryPersistData(userId: number): Promise<string> {
    let strData: string = '';
    return new Promise((resolve, reject) => {
      let predicates = new rdb.RdbPredicates(RdbStoreConfig.sessionPersistInfo.tableName).equalTo('id', userId);
      rdbStoreHelper.query(predicates).then((resultSet) => {
        let isLast = resultSet.goToFirstRow();
        log.showInfo(`query persist data isLast : ${isLast}`);
        if (isLast) {
          strData = resultSet.getString(resultSet.getColumnIndex('data'));
        }
        resolve(strData);
        resultSet.close();
      }).catch((err: BusinessError) => {
        log.showError(`query persist data failed, code is ${err.code}, message is ${err.message}`);
        reject(err);
      });
    });
  }

  /**
   * 删除持久化数据
   *
   * @returns
   */
  static async deletePersistData(): Promise<void> {
    try {
      const predicates: rdb.RdbPredicates = new rdb.RdbPredicates(RdbStoreConfig.sessionPersistInfo.tableName);
      let resultSet: rdb.ResultSet = await rdbStoreHelper.query(predicates, []);
      let isLast = resultSet.goToFirstRow();
      if (isLast) {
        await rdbStoreHelper.delete(predicates);
      }
      resultSet?.close();
    } catch (err) {
      log.showError(`delete persist data failed, code is ${err.code}, message is ${err.message}`);
    }
  }
}