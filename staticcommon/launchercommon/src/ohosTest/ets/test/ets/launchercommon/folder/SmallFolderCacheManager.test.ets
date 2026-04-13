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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { SmallFolderCacheManager } from '../../../../../../main/ets/TsIndex'

export default function SmallFolderCacheManagerTest() {
  describe('SmallFolderCacheManagerTest', () => {

    const smallFolderCacheManager: SmallFolderCacheManager = SmallFolderCacheManager.getInstance();

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

    it('test_getFolderIconCache', 0, () => {
      const folderKey = 'anyFolderKey';
      const folderValue = 'anyValue';
      smallFolderCacheManager.setCache(folderKey, folderValue);
      expect(smallFolderCacheManager.getFolderIconCache(folderKey)).assertEqual(folderValue);
    })

    it('test_getCache', 0, () => {
      const folderKey = 'anyFolderKey';
      const folderValue = 'anyValue';
      smallFolderCacheManager.setCache(folderKey, folderValue);
      expect(smallFolderCacheManager.getCache(folderKey)).assertEqual(folderValue);
    })

    it('test_deleteCache', 0, () => {
      const folderKey = 'anyFolderKey';
      const folderValue = 'anyValue';
      smallFolderCacheManager.setCache(folderKey, folderValue);
      smallFolderCacheManager.deleteCache(folderKey);
      expect(smallFolderCacheManager.getCache(folderKey)).assertNull();
    })

    it('test_setCache', 0, () => {
      const folderKey = 'anyFolderKey';
      const folderValue = 'anyValue';
      smallFolderCacheManager.setCache(folderKey, folderValue);
      expect(smallFolderCacheManager.getCache(folderKey)).assertEqual(folderValue);
      smallFolderCacheManager.deleteCache(folderKey);
      expect(smallFolderCacheManager.getCache(folderKey)).assertNull();
    })

    it('test_clearCache', 0, () => {
      const folderKey = 'anyFolderKey';
      const folderValue = 'anyValue';
      smallFolderCacheManager.setCache(folderKey, folderValue);
      smallFolderCacheManager.clearCache();
      expect(smallFolderCacheManager.getCache(folderKey)).assertNull();
    })

    it('test_getFolderIconCache_01', 0, () => {
      let instance: SmallFolderCacheManager = SmallFolderCacheManager.getInstance();
      let key: string = 'anyKey';
      instance.setCache(key, null);
      let value:string = instance.getFolderIconCache(key);
      expect(value).assertEqual(null);
    });

    it('test_getFolderIconCache_02', 0, () => {
      let instance: SmallFolderCacheManager = SmallFolderCacheManager.getInstance();
      let key: string = 'anyKey';
      let value: string = 'anyValue';
      instance.setCache(key, value);
      expect(instance.getFolderIconCache(key)).assertEqual(value);
    });

    it('test_setCache_01', 0, () => {
      let instance: SmallFolderCacheManager = SmallFolderCacheManager.getInstance();
      for(let i: number = 0; i < 110; i++){
        instance.setCache(i.toString(), i);
        instance.setCache(i.toString(),i+1);
      }
      expect(instance).not().assertNull();
    });
  })
}