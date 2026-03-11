/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import data_rdb from '@ohos.data.relationalStore';
import type context from '@ohos.app.ability.common';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import contextConstant from '@ohos.app.ability.contextConstant';

type Context = context.Context;

const STORE_CONFIG: data_rdb.StoreConfig = {
  name: 'AppNotificationSetting.db',
  securityLevel: data_rdb.SecurityLevel.S1
};
const VERSION: number = 1;
const TAG = 'Common-AppNotificationRdb';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 数据库store等待
 */
type StoreResolve = (val: data_rdb.RdbStore | PromiseLike<data_rdb.RdbStore>) => void;

export default class AppNotificationRdb {
  private rdbStore: data_rdb.RdbStore | undefined = undefined;
  private tableName: string;
  private sqlCreateTable: string;
  private columns: Array<string>;
  private context: Context | undefined;

  /**
   * 缓存等待
   */
  private storeResolves: Set<StoreResolve>;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
    this.storeResolves = new Set();
  }

  setContext(context: Context): void {
    if (!this.context) {
      this.context = context;
    }
  }

  getRdbStore(callback: () => void): void {
    if (CommonUtils.isInvalid(callback)) {
      log.showDebug('getRdbStore() has no callback!');
      return;
    }
    if (this.rdbStore != null) {
      log.showDebug('The rdbStore exists.');
      callback();
      return;
    }
    let contextForRdbStore: Context | undefined = this.context;
    if (!contextForRdbStore) {
      let context = (getContext(this) as context.AbilityStageContext);
      contextForRdbStore = context?.createModuleContext(context?.currentHapModuleInfo?.name);
      contextForRdbStore.area = contextConstant.AreaMode.EL1;
    }
    try {
      data_rdb.getRdbStore(contextForRdbStore, STORE_CONFIG, async (err, rdb) => {
        if (err) {
          log.showError(`gerRdbStore() failed error code: ${err?.code}, message: ${err?.message}`);
          return;
        }
        this.rdbStore = rdb;
        await this.rdbStore.executeSql(this.sqlCreateTable);
        log.showInfo('getRdbStore() finished. ' + this.storeResolves?.size);
        callback();
        // 等待回调
        this.storeResolves.forEach((resolve) => {
          resolve(rdb);
        });
        this.storeResolves.clear();
      });
    } catch (error) {
      log.showError(`getRdbStore failed error code: ${error?.code}, message: ${error?.message}`);
    }
  }

  insertData(data: data_rdb.ValuesBucket, callback: (val: boolean) => void): void {
    if (CommonUtils.isInvalid(callback)) {
      log.showWarn('insertData() has no callback!');
      return;
    }
    this.getStore()?.then((store: data_rdb.RdbStore | undefined) => {
      store?.insert(this.tableName, data, (err, ret) => {
        if (err) {
          log.showError(`insertData() failed error code: ${err?.code}, message: ${err?.message}`);
          callback(false);
          return;
        }
        log.showDebug('insertData() finished: ' + ret);
        callback(true);
      });
    });
  }

  deleteData(predicates: data_rdb.RdbPredicates, callback: (val: boolean) => void): void {
    if (CommonUtils.isInvalid(callback)) {
      log.showDebug('deleteData() has no callback!');
      return;
    }
    this.getStore()?.then((store: data_rdb.RdbStore | undefined) => {
      store?.delete(predicates, (err, ret) => {
        if (err) {
          log.showError(`deleteData() failed error code: ${err?.code}, message: ${err?.message}`);
          callback(false);
          return;
        }
        log.showDebug('deleteData() finished: ' + ret);
        callback(true);
      });
    });
  }

  updateData(predicates: data_rdb.RdbPredicates, data: data_rdb.ValuesBucket, callback: (val: boolean) => void): void {
    if (!callback || typeof callback === 'undefined' || callback === undefined) {
      log.showWarn('updateDate() has no callback!');
      return;
    }
    this.getStore()?.then((store: data_rdb.RdbStore | undefined) => {
      store?.update(data, predicates, (err, ret) => {
        if (err) {
          log.showError(`updateData() failed error code: ${err?.code}, message: ${err?.message}`);
          callback(false);
          return;
        }
        log.showDebug('updateData() finished: ' + ret);
        callback(true);
      });
    });
  }

  query(predicates: data_rdb.RdbPredicates, callback: (val: data_rdb.ResultSet) => void): void {
    if (CommonUtils.isInvalid(callback)) {
      log.showWarn('query() has no callback!');
      return;
    }
    this.getStore()?.then((store: data_rdb.RdbStore | undefined) => {
      store?.query(predicates, this.columns, (err, resultSet) => {
        if (err) {
          log.showError(`query() failed error code: ${err?.code}, message: ${err?.message}`);
          return;
        }
        log.showDebug('query() finished.');
        callback(resultSet);
        resultSet.close();
      });
    });
  }

  /**
   * 获取数据库
   *
   * @return 数据库
   */
  private async getStore(): Promise<data_rdb.RdbStore | undefined> {
    if (!CommonUtils.isInvalid(this.rdbStore)) {
      return this.rdbStore;
    }
    return new Promise((resolve) => {
      this.storeResolves.add(resolve);
    });
  }
}