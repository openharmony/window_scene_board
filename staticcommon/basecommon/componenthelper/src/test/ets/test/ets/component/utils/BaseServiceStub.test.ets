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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { rdbStoreHelper, RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import { ResourceManager } from '@ohos/frameworkwrapper';
import type Context from '@ohos.app.ability.common';
import rdb from '@ohos.data.relationalStore';

export function BaseServiceStubTest() {

  describe('BaseServiceStubTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('RdbStoreHelper_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = ResourceManager.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = ResourceManager.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    /* createRdbStore的基本功能在initRdb里测试 */
    it('RdbStoreHelper_createRdbStore_null', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      rdbStoreHelper.createRdbStore(null).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_createRdbStore_invalid_context', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let invalid = new Object();
      let rdb: RdbStoreHelper = new RdbStoreHelper();
      rdb.createRdbStore(invalid as Context.BaseContext).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_initRdb', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert_invalid', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_queryAll_invalid', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query_invalid', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates('');
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql_invalid', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update_invalid', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_delete_invalid', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_createRdbStore_null01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      rdbStoreHelper.createRdbStore(null).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_createRdbStore_invalid_context01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let invalid = new Object();
      let rdb: RdbStoreHelper = new RdbStoreHelper();
      rdb.createRdbStore(invalid as Context.BaseContext).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_initRdb01', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore01', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable01', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert01', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert01', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll01', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query01', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql01', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update01', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete01', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable01', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid01', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert_invalid01', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_queryAll_invalid01', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query_invalid01', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates('');
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql_invalid01', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update_invalid01', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_delete_invalid01', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll01', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query01', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_createRdbStore_null02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      rdbStoreHelper.createRdbStore(null).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_createRdbStore_invalid_context02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let invalid = new Object();
      let rdb: RdbStoreHelper = new RdbStoreHelper();
      rdb.createRdbStore(invalid as Context.BaseContext).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_initRdb02', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore02', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable02', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert02', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert02', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll02', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query02', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql02', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update02', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete02', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable02', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid02', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert_invalid02', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_queryAll_invalid02', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query_invalid02', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates('');
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql_invalid02', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update_invalid02', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_delete_invalid02', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll02', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query02', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_createRdbStore_null03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      rdbStoreHelper.createRdbStore(null).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_createRdbStore_invalid_context03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let invalid = new Object();
      let rdb: RdbStoreHelper = new RdbStoreHelper();
      rdb.createRdbStore(invalid as Context.BaseContext).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_initRdb03', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore03', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable03', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert03', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert03', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll03', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query03', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql03', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update03', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete03', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable03', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid03', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert_invalid03', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_queryAll_invalid03', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query_invalid03', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates('');
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql_invalid03', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update_invalid03', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_delete_invalid03', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll03', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query03', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_createRdbStore_null04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      rdbStoreHelper.createRdbStore(null).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_createRdbStore_invalid_context04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let invalid = new Object();
      let rdb: RdbStoreHelper = new RdbStoreHelper();
      rdb.createRdbStore(invalid as Context.BaseContext).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_initRdb04', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore04', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable04', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert04', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert04', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll04', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query04', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql04', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update04', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete04', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable04', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid04', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert_invalid04', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_queryAll_invalid04', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query_invalid04', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates('');
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql_invalid04', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update_invalid04', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_delete_invalid04', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll04', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query04', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_createRdbStore_null05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      rdbStoreHelper.createRdbStore(null).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_createRdbStore_invalid_context05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let invalid = new Object();
      let rdb: RdbStoreHelper = new RdbStoreHelper();
      rdb.createRdbStore(invalid as Context.BaseContext).then((res) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_initRdb05', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore05', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable05', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert05', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert05', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll05', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query05', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql05', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update05', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete05', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable05', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid05', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert_invalid05', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_queryAll_invalid05', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query_invalid05', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates('');
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql_invalid05', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update_invalid05', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_delete_invalid05', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll05', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query05', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_initRdb06', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore06', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable06', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert06', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert06', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll06', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query06', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql06', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update06', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete06', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable06', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid06', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert_invalid06', Level.LEVEL0, async (done: Function) => {
      let buckets: Array<rdb.ValuesBucket> = [];
      let data1: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9998",
      }
      let data2: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_queryAll_invalid06', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query_invalid06', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates('');
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql_invalid06', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update_invalid06', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
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

    it('RdbStoreHelper_executeSql_delete_invalid06', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll06', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query06', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_initRdb07', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.initRdb(() => {}).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_getRdbStore07', Level.LEVEL0, (): void => {
      expect(rdbStoreHelper.getRdbStore()).not().assertNull();
    })

    it('RdbStoreHelper_executeSql_createTable07', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      await rdbStoreHelper.executeSql(null);
      rdbStoreHelper.executeSql(rbdInfo.createTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert07', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: 9999,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_batchInsert07', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_queryAll07', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_query07', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
      done();
    })

    it('RdbStoreHelper_executeSql_querySql07', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.querySql('SELECT * FROM test_for_dt');
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_executeSql_update07', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_delete07', Level.LEVEL0, async (done: Function) => {
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

    it('RdbStoreHelper_executeSql_dropTable07', Level.LEVEL0, async (done: Function) => {
      let result: number = 0;
      rdbStoreHelper.executeSql(rbdInfo.dropTable).then(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('RdbStoreHelper_executeSql_insert_invalid07', Level.LEVEL0, async (done: Function) => {
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999",
      }
      let result = await rdbStoreHelper.insert(rbdInfo.tableName, data);
      expect(result).assertLarger(-1);
      result = await rdbStoreHelper.insert(null, data);
      expect(result).assertEqual(-1);
      result = await rdbStoreHelper.insert(rbdInfo.tableName, null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_executeSql_delete_invalid07', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      let data: rdb.ValuesBucket = {
        id: -1,
        data: "testing_for_dt_9999_update",
      }
      predicates.equalTo('id', data.id);
      let result = await rdbStoreHelper.delete(predicates);
      expect(result).assertEqual(1);

      result = await rdbStoreHelper.delete(null);
      expect(result).assertEqual(-1);

      done();
    })

    it('RdbStoreHelper_queryAll07', Level.LEVEL0, async (done: Function) => {
      let result = await rdbStoreHelper.queryAll(rbdInfo.tableName);
      expect(result.rowCount).assertEqual(3);
      done();
    })

    it('RdbStoreHelper_query07', Level.LEVEL0, async (done: Function) => {
      const predicates = new rdb.RdbPredicates(rbdInfo.tableName);
      predicates.equalTo('id', 9999);

      let result = await rdbStoreHelper.query(predicates, []);
      expect(result.rowCount).assertEqual(1);
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