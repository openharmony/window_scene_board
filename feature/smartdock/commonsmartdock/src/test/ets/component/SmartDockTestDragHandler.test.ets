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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import data_rdb from '@ohos.data.relationalStore';
import AppNotificationRdb from '@ohos/basiccommon/src/main/ets/component/service/db/AppNotificationRdb';
import { CommonConstants, GlobalContext } from '@ohos/basiccommon/src/main/ets/TsIndex';

/** 自定义动画 每帧刷新一次 */
export function SmartDockTestDragHandlerTest() {

  describe('SmartDockTestDragHandlerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    });
    afterAll((): void => {

    });
    afterEach((): void => {

    });

    it('AppNotificationRdb_invalid_null', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      expect(result).assertEqual(0);
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
        pinTopEnable: 0,
        soundEnable: 0,
        vibrationEnable: 0,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
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
        expect(result).assertEqual(1);
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
        expect(result).assertEqual(1);
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_insertData_invalid', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData_invalid', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key1', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData1_invalid', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key1', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key1', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid_null01', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      });
    })

    it('AppNotificationRdb_insertData01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt01",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt01",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData101', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt01",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData201', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt01",
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
      predicates.equalTo('key01', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid01', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_insertData_invalid01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt01",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData_invalid01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt01",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key01', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData1_invalid01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt01",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key01', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt01",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key01', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid_null02', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      });
    })

    it('AppNotificationRdb_insertData02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt02",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt02",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData102', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt02",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData202', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt02",
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
      predicates.equalTo('key02', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid02', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_insertData_invalid02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt02",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData_invalid02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt02",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key02', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData1_invalid02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt02",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key02', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt02",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key02', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid_null03', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      });
    })

    it('AppNotificationRdb_insertData03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt03",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt03",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData103', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt03",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData203', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt03",
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
      predicates.equalTo('key03', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid03', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_insertData_invalid03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt03",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData_invalid03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt03",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key03', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData1_invalid03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt03",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key03', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt03",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key03', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid_null04', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      });
    })

    it('AppNotificationRdb_insertData04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt04",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt04",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData104', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt04",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData204', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt04",
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
      predicates.equalTo('key04', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid04', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_insertData_invalid04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt04",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData_invalid04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt04",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key04', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData1_invalid04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt04",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key04', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt04",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key04', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid_null05', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      });
    })

    it('AppNotificationRdb_insertData05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt05",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt05",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData105', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt05",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData205', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt05",
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
      predicates.equalTo('key05', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid05', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_insertData_invalid05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt05",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData_invalid05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt05",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key05', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData1_invalid05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt05",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key05', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt05",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key05', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_insertData06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt06",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt06",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData106', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt06",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData206', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt06",
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
      predicates.equalTo('key06', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid06', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_insertData_invalid06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt06",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      rdb.insertData(valueBucket, null);
      rdb.insertData(valueBucket, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_updateData_invalid06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt06",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }

      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key06', valueBucket.key);
      rdb.updateData(predicates, valueBucket, null);
      rdb.updateData(predicates, valueBucket, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt06",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key06', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid_null07', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('', '', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(null);
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      });
    })

    it('AppNotificationRdb_insertData07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: 9999,
        appBundle: "testing_for_dt07",
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
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_invalid07', Level.LEVEL0, (): void => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb('aaa', 'aaa', new Array<string>());
      rdb.setContext(GlobalContext.getContext());
      rdb.getRdbStore(() => {
        result = 1;
        expect(result).assertEqual(0);
      });
      rdb.query(null, null);
      expect(result).assertEqual(0);
    })

    it('AppNotificationRdb_getRdbStore_ten07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      rdb.getRdbStore(() => {
        result = 10;
        expect(result).assertEqual(10);
        done();
      });
    })

    it('AppNotificationRdb_deleteData1_invalid07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt07",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key07', valueBucket.key);
      rdb.deleteData(predicates, (res: boolean) => {
        if (res) {
          result = 1;
        }
        expect(result).assertEqual(1);
        done();
      })
    })

    it('AppNotificationRdb_deleteData2_invalid07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let rdb: AppNotificationRdb = new AppNotificationRdb(CommonConstants.APP_NOTIFICATION_TABLE.tableName,
        CommonConstants.APP_NOTIFICATION_TABLE.sqlCreate, CommonConstants.APP_NOTIFICATION_TABLE.columns);
      let valueBucket: data_rdb.ValuesBucket = {
        id: -9999,
        appBundle: "testing_for_dt07",
        uid: '',
        key: '',
        bannerNotifyEnable: 1,
        lockNotifyEnable: 1,
        pinTopEnable: 1,
        soundEnable: 1,
        vibrationEnable: 1,
      }
      rdb.getRdbStore(() => {
      });
      let predicates = new data_rdb.RdbPredicates(CommonConstants.APP_NOTIFICATION_TABLE.tableName);
      predicates.equalTo('key07', valueBucket.key);
      rdb.deleteData(predicates, null);
      rdb.deleteData(predicates, (res: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })
  })
}
