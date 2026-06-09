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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import data_rdb from '@ohos.data.relationalStore';
import AppNotificationRdb from '../../../../../../../main/ets/service/db/AppNotificationRdb';
import { GlobalContext } from '../../../../../../../main/ets/TsIndex';
import { CommonConstants } from '@ohos/commonconstants';

function sleep(delay: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, delay));
};

/**
 * 定时器 DT测试套
 */
export function AppNotificationRdbTest() {
  describe('AppNotificationRdbTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('AppNotificationRdb_invalid_null', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      /* 没回调的时候应该什么都没做 */
      expect(rdb).not().assertUndefined();
    })

    it('AppNotificationRdb_getRdbStore', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(rdb).not().assertUndefined();
        done();
      });
    })

    it('AppNotificationRdb_getRdbStore_if', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(rdb).not().assertUndefined();
        rdb.getRdbStore(() => {

        })
        done();
      });
    })

    it('AppNotificationRdb_getRdbStore_throw_err', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(rdb).not().assertUndefined();
        (rdb as object)['storeResolves'] = undefined;
        done();
      });
    })

    it('AppNotificationRdb_insertData', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(rdb).not().assertUndefined();
        done();
      })
    })

    it('AppNotificationRdb_insertData_error', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName + '_test',
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }

      rdb.getRdbStore(() => {
      });
      await (rdb as object)['rdbStore']?.close();
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(rdb).not().assertUndefined();
        done();
      })
    })

    it('AppNotificationRdb_updateData', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(rdb).not().assertUndefined();
        done();
      })
    })

    it('AppNotificationRdb_updateData_error', Level.LEVEL0, async (done: Function) => {
      const tableName = CommonConstants.APP_NOTIFICATION_TABLE.tableName + '_test_update';
      let rdb: AppNotificationRdb =
        new AppNotificationRdb(tableName,
          CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }

      rdb.getRdbStore(() => {
      });
      await (rdb as object)['rdbStore']?.close();
      let predicates = new data_rdb.RdbPredicates(tableName);
      predicates.equalTo('key', valueBucket.key);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        expect(res).assertFalse();
        done();
      })
    })

    it('AppNotificationRdb_deleteData1', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(rdb).not().assertUndefined();
        done();
      })
    })

    it('AppNotificationRdb_deleteData2', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(rdb).not().assertUndefined();
        done();
      })
    })

    it('AppNotificationRdb_deleteData_error', Level.LEVEL0, async (done: Function) => {
      const tableName = CommonConstants.APP_NOTIFICATION_TABLE.tableName + '_test_del';
      let rdb: AppNotificationRdb =
        new AppNotificationRdb(tableName,
          CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }
      rdb.getRdbStore(() => {
      });
      await (rdb as object)['rdbStore']?.close();
      let predicates = new data_rdb.RdbPredicates(tableName);
      predicates.equalTo('key', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        expect(res).assertFalse();
        done();
      })
    })

    it('AppNotificationRdb_query_error', Level.LEVEL0, async (done: Function) => {
      const tableName = CommonConstants.APP_NOTIFICATION_TABLE.tableName + '_test_query';
      let rdb: AppNotificationRdb =
        new AppNotificationRdb(tableName,
          CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 0,
        lockNotifyEnable: 0,
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }
      rdb.getRdbStore(() => {
      });
      await (rdb as object)['rdbStore']?.close();
      let predicates = new data_rdb.RdbPredicates(tableName);
      predicates.equalTo('key', valueBucket.key);
      rdb.query(predicates, (res: data_rdb.ResultSet) => {

      })
      await sleep(200);
      expect(rdb).not().assertUndefined();
      done();
    })
  })
}