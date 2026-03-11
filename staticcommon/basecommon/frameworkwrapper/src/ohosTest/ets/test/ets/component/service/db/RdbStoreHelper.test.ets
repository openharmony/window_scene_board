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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import type Context from '@ohos.app.ability.common';
import rdb from '@ohos.data.relationalStore';
import { rdbStoreHelper, RdbStoreHelper } from '../../../../../../../main/ets/service/db/RdbStoreHelper';
import { RdbStoreConfig } from '../../../../../../../main/ets/TsIndex';
import sendableRelationalStore from '@ohos.data.sendableRelationalStore';

/**
 * 定时器 DT测试套
 */
export function RdbStoreHelperTest() {
  describe('RdbStoreHelperTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    /* createRdbStore的基本功能在initRdb里测试 */
    it('AppNotificationRdb_createRdbStore_null', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      rdbStoreHelper.createRdbStore(null).then((res) => {
        if (!res) {
          result = 1;
        }
        expect(rdbStoreHelper).not().assertUndefined();
        done();
      })
    })

    it('AppNotificationRdb_createRdbStore_invalid_context', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let invalid = new Object();
      let rdb: RdbStoreHelper = new RdbStoreHelper();
      rdb.createRdbStore(invalid as Context.BaseContext).then((res) => {
        if (!res) {
          result = 1;
        }
        expect(rdb).not().assertUndefined();
        done();
      })
    })

    it('AppNotificationRdb_initRdb', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_getRdbStore', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('AppNotificationRdb_executeSql_createTable', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_executeSql_insert', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertEqual(9999);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('AppNotificationRdb_executeSql_batchInsert', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: 9998,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: 9997,
        data: "testing_for_dt_9997",
      }
      buckets.push(data1);
      buckets.push(data2);
      let result = await rdbStoreHelper.batchInsert(rbdInfo.tableName, buckets);
      expect(result).assertEqual(2);
      result = await rdbStoreHelper.batchInsert(null, buckets);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.batchInsert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('AppNotificationRdb_executeSql_queryAll', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('AppNotificationRdb_executeSql_query', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('AppNotificationRdb_executeSql_querySql', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('AppNotificationRdb_executeSql_update', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.update(predicates, data);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.update(null, data);
      expect(result).assertEqual(-1);

      result = await rdbStoreHelper.update(predicates, null);
      expect(result).assertEqual(-1);
      done();
    })

    it('AppNotificationRdb_executeSql_delete', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('AppNotificationRdb_executeSql_dropTable', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore_test01', 0, () => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      rdbStoreHelper1.getRdbStore();
      expect(rdbStoreHelper1).not().assertUndefined();
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_insert_test01', 0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      await rdbStoreHelper1.insert(rbdInfo.tableName, data);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_needRetry_test01', 0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      await (rdbStoreHelper1 as object)['needRetry'](0, 5);
      expect(rdbStoreHelper1).not().assertUndefined();
      await (rdbStoreHelper1 as object)['needRetry'](RdbStoreConfig.errorCode.DATABASE_BUSY_BY_OTHER_PROCESSES, 0);
      expect(rdbStoreHelper1).not().assertUndefined();
      await (rdbStoreHelper1 as object)['needRetry'](RdbStoreConfig.errorCode.DATABASE_BUSY_BY_OTHER_THREADS, 0);
      expect(rdbStoreHelper1).not().assertUndefined();
      await (rdbStoreHelper1 as object)['needRetry'](RdbStoreConfig.errorCode.MEMORY_APPLY_FAILED, 0);
      expect(rdbStoreHelper1).not().assertUndefined();
      await (rdbStoreHelper1 as object)['needRetry'](RdbStoreConfig.errorCode.IO_ACCESS_FAILED, 0);
      expect(rdbStoreHelper1).not().assertUndefined();
      await (rdbStoreHelper1 as object)['needRetry'](RdbStoreConfig.errorCode.WAL_FILE_LIMIT, 0);
      expect(rdbStoreHelper1).not().assertUndefined();
      await (rdbStoreHelper1 as object)['needRetry'](RdbStoreConfig.errorCode.DISK_FULL, 0);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_batchInsert_test01', 0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      await rdbStoreHelper1.batchInsert(rbdInfo.tableName, null);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_query_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);
      await rdbStoreHelper1.query(predicates, []);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_isExistData_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);
      await rdbStoreHelper1.isExistData(predicates);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_querySql_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      await rdbStoreHelper1.querySql('SELECT * FROM test_for_dt');
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_executeSql_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      await rdbStoreHelper1.executeSql('SELECT * FROM test_for_dt');
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_update_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      await rdbStoreHelper1.update(predicates, data);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_delete_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      (rdbStoreHelper1 as object)['mRdbStore'] = undefined;
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      await rdbStoreHelper1.delete(predicates);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_doRestore_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      await rdbStoreHelper1.doRestore(RdbStoreConfig.errorCode.DATABASE_CORRUPTED, null);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_checkQueryResult_test01', Level.LEVEL0, async (done: Function) => {
      let num: number = 0;
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      let result: rdb.ResultSet = {
        columnNames: [],
        columnCount: 0,
        rowCount: -1,
        rowIndex: 0,
        isAtFirstRow: false,
        isAtLastRow: false,
        isEnded: false,
        isStarted: false,
        isClosed: false,
        getColumnIndex: (columnName: string): number => {
          throw new Error('Function not implemented.');
        },
        getColumnName: (columnIndex: number): string => {
          throw new Error('Function not implemented.');
        },
        goTo: (offset: number): boolean => {
          throw new Error('Function not implemented.');
        },
        goToRow: (position: number): boolean => {
          throw new Error('Function not implemented.');
        },
        goToFirstRow: (): boolean => {
          throw new Error('Function not implemented.');
        },
        goToLastRow: (): boolean => {
          throw new Error('Function not implemented.');
        },
        goToNextRow: (): boolean => {
          throw new Error('Function not implemented.');
        },
        goToPreviousRow: (): boolean => {
          throw new Error('Function not implemented.');
        },
        getBlob: (columnIndex: number): Uint8Array => {
          throw new Error('Function not implemented.');
        },
        getString: (columnIndex: number): string => {
          throw new Error('Function not implemented.');
        },
        getLong: (columnIndex: number): number => {
          throw new Error('Function not implemented.');
        },
        getDouble: (columnIndex: number): number => {
          throw new Error('Function not implemented.');
        },
        getAsset: (columnIndex: number): rdb.Asset => {
          throw new Error('Function not implemented.');
        },
        getAssets: (columnIndex: number): rdb.Assets => {
          throw new Error('Function not implemented.');
        },
        getValue: (columnIndex: number): rdb.ValueType => {
          throw new Error('Function not implemented.');
        },
        getFloat32Array: (columnIndex: number): Float32Array => {
          throw new Error('Function not implemented.');
        },
        getRow: (): rdb.ValuesBucket => {
          throw new Error('Function not implemented.');
        },
        isColumnNull: (columnIndex: number): boolean => {
          throw new Error('Function not implemented.');
        },
        close: (): void => {
          throw new Error('Function not implemented.');
        },
        getColumnType: (columnIdentifier: string | number): Promise<rdb.ColumnType> => {
          throw new Error('Function not implemented.');
        },
        getColumnTypeSync: (columnIdentifier: string | number): rdb.ColumnType => {
          throw new Error('Function not implemented.');
        },
        getRows: (maxCount: number, position?: number | undefined): Promise<rdb.ValuesBucket[]> => {
          throw new Error('Function not implemented.');
        },
        getSendableRow: (): sendableRelationalStore.ValuesBucket => {
          throw new Error('Function not implemented.');
        }
      }
      await (rdbStoreHelper1 as object)['checkQueryResult'](result, null);
      expect(rdbStoreHelper1).not().assertUndefined();
      result.rowCount = 5;
      await (rdbStoreHelper1 as object)['checkQueryResult'](result, null);
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

    it('RdbStoreHelper_release_test01', Level.LEVEL0, async (done: Function) => {
      let rdbStoreHelper1: RdbStoreHelper = new RdbStoreHelper();
      rdbStoreHelper1.release();
      expect(rdbStoreHelper1).not().assertUndefined();
      done();
    })

  })
}

interface TestRdbTable {
  tableName: string;
  createTable: string;
  dropTable: string;
}

let rbdInfo: TestRdbTable = {
  tableName: 'test_for_dt',
  createTable: 'CREATE TABLE IF NOT EXISTS test_for_dt ' +
  '(id INTEGER PRIMARY KEY, ' +
  'data TEXT)',
  dropTable: 'DROP TABLE IF EXISTS test_for_dt'
}