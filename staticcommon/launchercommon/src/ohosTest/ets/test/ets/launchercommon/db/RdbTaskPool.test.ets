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
import { CheckEmptyUtils } from '@ohos/basicutils'
import { RdbStoreConfig } from '@ohos/frameworkwrapper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { AppStatus, DownloadInfoItem, GridLayoutItemInfo, RdbTaskPool } from '../../../../../../main/ets/TsIndex'
import rdb from '@ohos.data.relationalStore';
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';
import { AppGridItemInfo } from '../../../../../../main/ets/bean/AppGridItemInfo';

export default function RdbTaskPoolTest () {
  describe('RdbTaskPoolTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.RdbTaskPoolInstance = undefined;
      const instance: RdbTaskPool = RdbTaskPool.getInstance();
      expect(globalThis.RdbTaskPoolInstance).assertEqual(instance);
      expect(instance).assertEqual(RdbTaskPool.getInstance());
    })

    it('test_deleteRelationFormInfoOfDb', 0, async () => {
      const pool: RdbTaskPool = RdbTaskPool.getInstance();
      const infoId = 'InfoIdNotExists';
      const result: boolean = await pool.deleteRelationFormInfoOfDb(RdbStoreConfig.gridLayoutInfo.tableName, [infoId]);
      expect(result).assertTrue();
    })

    it('test_deleteItemsByInfoIdAndContainer', 0, async () => {
      const pool: RdbTaskPool = RdbTaskPool.getInstance();
      let deleteItem = new GridLayoutItemInfo();
      deleteItem.infoId = 'InfoIdNotExists';
      deleteItem.container = 100;
      const result: boolean = await pool.deleteItemsByInfoIdAndContainer(RdbStoreConfig.gridLayoutInfo.tableName, [deleteItem]);
      expect(result).assertTrue();
    })

    it('test_insert', 0, async (done: Function) => {
      const bundleName: string = 'bundleName_' + new Date().getTime();
      const insertBucket: rdb.ValuesBucket = {
        'bundle_name': bundleName,
        'badge_number': 4,
        'is_show': 1,
        'user_id': 0
      };
      let ret = await RdbTaskPool.getInstance().insert('table_name', insertBucket);
      expect(ret).assertInstanceOf('Number');
      done();
    })

    it('test_batchInsert', 0, async (done: Function) => {
      const bundleName: string = 'bundleName_' + new Date().getTime();
      const insertBucket: rdb.ValuesBucket = {
        'bundle_name': bundleName,
        'badge_number': 4,
        'is_show': 1,
        'user_id': 0
      };
      let insertBucketList: Array<rdb.ValuesBucket> = [];
      insertBucketList.push(insertBucket);
      let ret = await RdbTaskPool.getInstance().batchInsert('table_name', insertBucketList);
      expect(ret).assertInstanceOf('Number');
      done();
    })

    it('test_queryNotInstalledApplication', 0, async (done: Function) => {
      await RdbTaskPool.getInstance().queryNotInstalledApplication('table_name');
      expect(true).assertTrue();
      done();
    })

    it('test_updateDownload', 0, async (done: Function) => {
      const bundleName: string = 'bundleName_' + new Date().getTime();
      const appInfo: DownloadInfoItem = {
        bundleName: bundleName,
        appStatus: AppStatus.WAITING,
        oldBundleName: bundleName,
        updateTwinApp: true
      };
      let ret = await RdbTaskPool.getInstance().updateDownload('table_name', appInfo);
      expect(ret).assertInstanceOf('Number');
      done();
    })

    it('test_updateDownload', 0, async (done: Function) => {
      const bundleName: string = 'bundleName_' + new Date().getTime();
      const appInfo: DownloadInfoItem = {
        bundleName: bundleName,
        appStatus: AppStatus.WAITING,
        oldBundleName: bundleName,
        updateTwinApp: false
      };
      let ret = await RdbTaskPool.getInstance().updateDownload('table_name', appInfo);
      expect(ret).assertInstanceOf('Number');
      done();
    })

    it('test_updateDownload', 0, async (done: Function) => {
      const bundleName: string = 'bundleName_' + new Date().getTime();
      const appInfo: DownloadInfoItem = {
        bundleName: bundleName,
        appStatus: AppStatus.WAITING,
        oldBundleName: bundleName,
        updateTwinApp: true
      };
      let ret = await RdbTaskPool.getInstance().updateDownload('table_name', appInfo);
      expect(ret).assertInstanceOf('Number');
      done();
    })

    it('test_updateDownload', 0, async (done: Function) => {
      const bundleName: string = 'bundleName_' + new Date().getTime();
      const appInfo: DownloadInfoItem = {
        bundleName: bundleName,
        appStatus: AppStatus.WAITING,
        oldBundleName: bundleName,
        updateTwinApp: false
      };
      let ret = await RdbTaskPool.getInstance().updateDownload('table_name', appInfo);
      expect(ret).assertInstanceOf('Number');
      done();
    })

    it('test_RdbTaskPool_updateNewInstalledApp', 0, async (done: Function) => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.row = 1;
      info.column = 1;
      info.abilityName = 'openharmony';
      info.area = [1, 2];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: number = await RdbTaskPool.getInstance().updateNewInstalledApp('table_name', info);
      expect(result).assertEqual(CommonConstants.INVALID_VALUE);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_RdbTaskPool_update', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: number = await RdbTaskPool.getInstance().update('table_name', new Map(), null);
      expect(result).assertEqual(CommonConstants.INVALID_VALUE);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_RdbTaskPool_updatePredicates', 0, async (done: Function) => {
      let result: number = await RdbTaskPool.getInstance().updatePredicates(null, null);
      expect(result).assertInstanceOf('Number');
      done();
    })

    it('test_RdbTaskPool_delete', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: number = await RdbTaskPool.getInstance().delete('table_name', new Map());
      expect(result).assertEqual(CommonConstants.INVALID_VALUE);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_RdbTaskPool_updateAppCenterItemPositions', 0, async (done: Function) => {
      let result: boolean = await RdbTaskPool.getInstance().updateAppCenterItemPositions('table_name', []);
      expect(result).assertInstanceOf('Boolean');
      done();
    })

    it('test_RdbTaskPool_updateAppCenterItemSys', 0, async (done: Function) => {
      let result: boolean = await RdbTaskPool.getInstance().updateAppCenterItemSys('table_name', []);
      expect(result).assertInstanceOf('Boolean');
      done();
    })

    it('test_RdbTaskPool_queryFirstPageAndDockApplication', 0, async (done: Function) => {
      let result: GridLayoutItemInfo[] = await RdbTaskPool.getInstance().queryFirstPageAndDockApplication('table_name');
      expect(result.length).assertEqual(0);
      done();
    })

    it('test_RdbTaskPool_queryAppCenter', 0, async (done: Function) => {
      let result: AppGridItemInfo[] = await RdbTaskPool.getInstance().queryAppCenter('table_name');
      expect(result.length).assertEqual(0);
      done();
    })

    it('test_RdbTaskPool_queryGridLayoutInfoByPage', 0, async (done: Function) => {
      let result: GridLayoutItemInfo[] = await RdbTaskPool.getInstance().queryGridLayoutInfoByPage('table_name', new Map());
      expect(result.length).assertEqual(0);
      done();
    })
  })
}
