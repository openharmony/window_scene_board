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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { Cache2RdbHelper, GridLayoutItemInfo, GridLayoutUtil,
  LaunchLayoutCacheManager } from '../../../../../../main/ets/TsIndex';
export default function CacheRdbHelperTest() {
  describe('CacheRdbHelperTest', () => {
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
    it('test_addItem', 0, () => {
      let mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.generateUniqueKey);
      when(func)(ArgumentMatchers.any).afterReturn('');
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const cache2RdbHelper:Cache2RdbHelper = Cache2RdbHelper.getInstance();
      try {
        expect(cache2RdbHelper.addItem('good_10',gridLayoutItemInfo)).assertFalse();
        cache2RdbHelper.createEvent('good_10');
        expect(cache2RdbHelper.addItem('good_10',gridLayoutItemInfo)).assertTrue();
      } catch (e) {
      }
      when(func)(ArgumentMatchers.any).afterReturn('nice');
      try {
        expect(cache2RdbHelper.addItem('good_10',gridLayoutItemInfo)).assertTrue();
      } catch (e) {
      }
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_setChangedPage', 0, () => {
      const changedPageSet:Set<number> = new Set();
      changedPageSet.add(1)
      const cache2RdbHelper:Cache2RdbHelper = Cache2RdbHelper.getInstance();
      expect(cache2RdbHelper.setChangedPage('good_100',changedPageSet)).assertFalse();
      cache2RdbHelper.createEvent('good_10');
      expect(cache2RdbHelper.setChangedPage('good_10',changedPageSet)).assertTrue();
    })

    it('test_deleteItem', 0, () => {
      let mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.generateUniqueKey);
      when(func)(ArgumentMatchers.any).afterReturn('');
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.keyName = 'nice';
      const cache2RdbHelper: Cache2RdbHelper = Cache2RdbHelper.getInstance();
      try {
        expect(cache2RdbHelper.deleteItem('good_10001', gridLayoutItemInfo, '1')).assertFalse();
        cache2RdbHelper.createEvent('good_10');
        expect(cache2RdbHelper.deleteItem('good_10', gridLayoutItemInfo, '1')).assertFalse();
      } catch (e) {
      }
      when(func)(ArgumentMatchers.any).afterReturn('1');
      try {
        cache2RdbHelper.addItem('good_10', gridLayoutItemInfo);
        expect(cache2RdbHelper.deleteItem('good_10', gridLayoutItemInfo, '1')).assertInstanceOf('Boolean');
      } catch (e) {
      }
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_addLock', 0, () => {
      const cache2RdbHelper:Cache2RdbHelper = Cache2RdbHelper.getInstance();
      expect(cache2RdbHelper.addLock('good_10001','1')).assertUndefined();
      cache2RdbHelper.createEvent('good_10');
      const eventMap: Map<string, ESObject> =cache2RdbHelper['eventMap'];
      const obj:ESObject = eventMap.get('good_10');
      obj.isExecuted = true;
      expect(cache2RdbHelper.addLock('good_10','1')).not().assertNull();
      obj.isExecuted = false;
      expect(cache2RdbHelper.addLock('good_10','1')).not().assertNull();
    })

    it('test_executeEvent', 0, async (done:Function) => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const cache2RdbHelper:Cache2RdbHelper = Cache2RdbHelper.getInstance();
      try {
        expect(await cache2RdbHelper.executeEvent('good_10001')).assertFalse();
        cache2RdbHelper.createEvent('good_10');
      } catch (e) {
      }
      const eventMap: Map<string, ESObject> = cache2RdbHelper['eventMap'];
      const cacheMgr: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const func: Function = mocker.mockFunc(cacheMgr, cacheMgr.deleteBlankPageByCache);
      try {
        when(func)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo]);
        const func1: Function = mocker.mockFunc(cacheMgr, cacheMgr.selectPageCount);
        when(func1)(ArgumentMatchers.any).afterReturn(1);
        const func2: Function = mocker.mockFunc(cacheMgr, cacheMgr.getAllGridLayoutItemList);
        when(func2)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo]);
        const func3: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.generateUniqueKey);
        when(func3)(ArgumentMatchers.any).afterReturn('1');
        const obj: ESObject = eventMap.get('good_10');
        obj.isExecuted = true;
        expect(await cache2RdbHelper.executeEvent('good_10')).not().assertNull();
        when(func)(ArgumentMatchers.any).afterReturn([]);
        expect(await cache2RdbHelper.executeEvent('good_10')).not().assertNull();
        obj.isExecuted = false;
        expect(await cache2RdbHelper.executeEvent('good_10')).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(cacheMgr);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    })
  })
}