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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { GlobalSearchStoreManager } from '../../../../../../main/ets/globalSearch/GlobalSearchStoreManager';
import { SearchItemInfo } from '../../../../../../main/ets/bean/SearchItemInfo';

export default function GlobalSearchStoreManagerTest() {
  describe('GlobalSearchStoreManagerTest', () => {
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
      let instance = GlobalSearchStoreManager.getInstance();
      expect(instance).not().assertNull();
    })

    it('test_searchApp', 0, async (done: Function) => {
      let ret = await GlobalSearchStoreManager.getInstance().searchApp(null);
      expect(ret.length).assertEqual(0);

      const bundleName = 'com.ohos.clock';
      ret = await GlobalSearchStoreManager.getInstance().searchApp(bundleName);
      expect(ret.length).assertLargerOrEqual(0);
      done();
    })

    it('test_insertSysAppBatch', 0, async (done: Function) => {
      try{
        await GlobalSearchStoreManager.getInstance().insertSysAppBatch(null);
        let item: SearchItemInfo = new SearchItemInfo();
        item.bundleName = 'com.dt.scb_test';
        let list: SearchItemInfo[] = [];
        list.push(item);
        await GlobalSearchStoreManager.getInstance().insertSysAppBatch(list);
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(true).assertTrue();
      done();
    })

    it('test_updateSysAppBatch', 0, async (done: Function) => {
      try{
        await GlobalSearchStoreManager.getInstance().updateSysAppBatch(null);
        let item: SearchItemInfo = new SearchItemInfo();
        item.bundleName = 'com.dt.scb.scb_test';
        item.abilityName = 'com.dt.scb.scb_test.main.ability';
        let list: SearchItemInfo[] = [];
        list.push(item);
        await GlobalSearchStoreManager.getInstance().updateSysAppBatch(list);
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(true).assertTrue();
      done();
    })

    it('test_deleteRecordBatch', 0, async (done: Function) => {
      try{
        await GlobalSearchStoreManager.getInstance().deleteRecordBatch(null);
        let item: SearchItemInfo = new SearchItemInfo();
        item.bundleName = 'com.dt.scb.scb_test';
        item.abilityName = 'com.dt.scb.scb_test.main.ability';
        let list: SearchItemInfo[] = [];
        list.push(item);
        await GlobalSearchStoreManager.getInstance().deleteRecordBatch(list);
      }catch(err){
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(true).assertTrue();
      done();
    })

    it('test_releaseService', 0, async (done: Function) => {
      await GlobalSearchStoreManager.getInstance().releaseService();
      expect(true).assertTrue();
      done();
    })
  })
}
