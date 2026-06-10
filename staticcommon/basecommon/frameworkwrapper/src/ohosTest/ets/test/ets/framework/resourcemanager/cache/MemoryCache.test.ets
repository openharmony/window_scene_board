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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { MemoryCache } from '../../../../../../../main/ets/resourcemanager/cache/MemoryCache';
import IconInfo, { IconPicType } from '../../../../../../../main/ets/resourcemanager/IconInfo';
import { memoryCache } from '../../../../../../../main/ets/TsIndex';
import { HashMap } from '@kit.ArkTS';
import { IconExtendParam } from '../../../../../../../main/ets/resourcemanager/IconExtendParam';
import { CheckEmptyUtils } from '@ohos/basicutils';

export function MemoryCacheTest() {
  const bundleName = 'com.dbCacheTest';
  const moduleName = 'dbCacheTest';
  const abilityName = 'MainAbility';
  const appName = 'testAppName';
  const iconInfo = new IconInfo();
  iconInfo.combinePic = 'combinePic';
  iconInfo.adaptivePic = ['backPic', 'forePic'];
  iconInfo.iconType = IconPicType.ADAPTIVE;

  describe('MemoryCacheTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('getCombIcon_return_empty_string', 0, async (done: Function) => {
      let param: IconExtendParam = new IconExtendParam();
      const result = await memoryCache.getCombIcon('bundleName', 'moduleName', 'abilityName', param);
      expect(result).not().assertUndefined();
      done();
    });

    it('getCombIcon_return_icon', 0, () => {
      let param: IconExtendParam = new IconExtendParam();
      memoryCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      const result = memoryCache.getCombIconSync(bundleName, moduleName, abilityName);
      expect(result).assertUndefined();
    });

    it('setIconNameResource_return_string', 0, () => {
      memoryCache.setIconNameResource(bundleName, moduleName, abilityName, appName);
      const result = memoryCache.getIconNameSync(bundleName, moduleName, abilityName);
      expect(result).assertEqual(appName);
    });

    it('MemoryCacheTest_getInstance_001', 0, () => {
      MemoryCache.getInstance();
      const result = MemoryCache.getInstance();
      expect(result).not().assertNull();
    });

    it('MemoryCacheTest_getCacheKey_002', 0, () => {
      let result: string = (memoryCache as object)['getCacheKey'](bundleName,moduleName);
      expect(result.length > 0).assertTrue();
    });

    it('MemoryCacheTest_getCacheKey_003', 0, () => {
      let result: string = (memoryCache as object)['getCacheKey'](bundleName);
      expect(result.length > 0).assertTrue();
    });

    it('MemoryCacheTest_getIconResource_004', 0, () => {
      try {
        memoryCache.getIconResource(bundleName, moduleName, abilityName);
      } catch (e) {
        expect(e).not().assertNull();
      }
    });

    it('MemoryCacheTest_deleteAllCache_005', 0, async (done: Function) => {
      const result = await memoryCache.deleteAllCache();
      expect(result == null).assertTrue();
      done();
    });

    it('MemoryCacheTest_deleteAllNameCache_006', 0, () => {
      let result = memoryCache.deleteAllNameCache();
      expect(result == null).assertTrue();
    });

    it('MemoryCacheTest_deleteCache_007', 0, async (done: Function) => {
      let result = await memoryCache.deleteCache(bundleName);
      expect(result == null).assertTrue();
      done();
    });

    it('MemoryCacheTest_deleteCacheByBundle_008', 0, () => {
      let memoryNameCacheMap: HashMap<string, string> = new HashMap();
      memoryNameCacheMap.set(bundleName, 'test');
      let result: Object = (memoryCache as object)['deleteCacheByBundle'](bundleName, memoryNameCacheMap);
      expect(result == null).assertTrue();
    });

    it('MemoryCacheTest_getCacheIconPicTypeSync_009', 0, () => {
      let result = memoryCache.getCacheIconPicTypeSync(bundleName, moduleName, abilityName);
      expect(result).not().assertNull();
    });

    it('MemoryCacheTest_getCacheIconPicTypeFromMemory_010', 0, () => {
      const cacheKey: string = (memoryCache as object)['getCacheKey'](bundleName, moduleName, abilityName);
      let result = memoryCache.getCacheIconPicTypeFromMemory(cacheKey);
      expect(result).not().assertNull();
    });

    it('MemoryCacheTest_setCacheIconPicTypeToMemory_011', 0, () => {
      let result = memoryCache.setCacheIconPicTypeToMemory(bundleName, moduleName, abilityName, iconInfo);
      expect(result == null).assertTrue();
    });

    it('MemoryCacheTest_setCacheIconPicTypeToMemory_012', 0, () => {
      let result = memoryCache.setCacheIconPicTypeToMemory('', moduleName, abilityName, null);
      expect(result == null).assertTrue();
    });

    it('MemoryCacheTest_setCacheIconPicTypeToMemory_013', 0, () => {
      iconInfo.iconType = IconPicType.NORMAL;
      let result = memoryCache.setCacheIconPicTypeToMemory(bundleName, moduleName, abilityName, iconInfo);
      expect(result == null).assertTrue();
    });

    it('MemoryCacheTest_getIconNameByBundleNameSync_014', 0, () => {
      (memoryCache as object)['memoryNameCacheMap'].set(bundleName, 'test');
      let result = memoryCache.getIconNameByBundleNameSync(bundleName);
      expect(result.length >= 0).assertTrue();
    });

    it('MemoryCacheTest_getIconNameByBundleNameSync_015', 0, () => {
      let result = memoryCache.getIconNameByBundleNameSync('test');
      expect(result.length >= 0).assertTrue();
    });

    it('MemoryCacheTest_isNameCacheEmpty_016', 0, () => {
      let result = memoryCache.isNameCacheEmpty();
      expect(result).assertInstanceOf('Boolean');
    });

    it('MemoryCacheTest_setIconResource_017', 0, async (done: Function) => {
      let iconInfo: IconInfo = new IconInfo();
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = true;
      await memoryCache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
      let img = memoryCache.getCombIconSync(bundleName, moduleName, abilityName);
      expect(CheckEmptyUtils.isEmptyPixelMap(img)).assertTrue();
      done();
    });

    it('MemoryCacheTest_getIconResourceBySize_empty', 0, () => {
      const result = memoryCache.getIconResourceBySize('', '', '', 0);
      expect(result).not().assertUndefined();
    });

    it('MemoryCacheTest_getIconResourceBySize', 0, () => {
      try {
        memoryCache.getIconResourceBySize('', '', '', 48);
      } catch (error) {
      }
      expect(memoryCache).not().assertUndefined();
    });

    it('MemoryCacheTest_setIconResourceBySize_empty', 0, () => {
      let iconInfo = new IconInfo();
      memoryCache.setIconResourceBySize('', '', '', 0, iconInfo);
      expect(memoryCache).not().assertUndefined();
    });

    it('MemoryCacheTest_setIconResourceBySize', 0, () => {
      let iconInfo = new IconInfo();
      try {
        memoryCache.setIconResourceBySize('', '', '', 48, iconInfo);
      } catch (error) {
      }
      expect(memoryCache).not().assertUndefined();
    });

    it('MemoryCacheTest_getIconResourceCacheKey_01', 0, () => {
      let result = memoryCache.getIconResourceCacheKey('', undefined, undefined, 48);
      expect(result).assertContain('#');
    });

    it('MemoryCacheTest_getIconResourceCacheKey_02', 0, () => {
      let result = memoryCache.getIconResourceCacheKey('bundleName', 'moduleName', 'abilityName', 48);
      expect(result).assertContain('#');
    });

    it('MemoryCacheTest_deleteCacheByBundle_last_branch_false', 0, () => {
      const bundleName: string = 'com.ohos.app.dt';
      const key: string = 'com.ohos.app.dt_cached';
      let memoryNameCacheMap: HashMap<string, string> = new HashMap();
      memoryNameCacheMap.set(key, bundleName);
      (memoryCache as object)['deleteCacheByBundle'](bundleName, memoryNameCacheMap);
      expect(memoryNameCacheMap.length === 0).assertFalse();
    });

    it('MemoryCacheTest_deleteCacheByBundle_last_branch_true', 0, () => {
      const bundleName: string = 'com.ohos.app.dt';
      const key: string = 'com.ohos.app.dt#cached';
      let memoryNameCacheMap: HashMap<string, string> = new HashMap();
      memoryNameCacheMap.set(key, bundleName);
      (memoryCache as object)['deleteCacheByBundle'](bundleName, memoryNameCacheMap);
      expect(memoryNameCacheMap.length === 0).assertTrue();
    });

    it('MemoryCacheTest_getAppNameCacheKey', 0, () => {
      let key: string = '1#23';
      let cacheKey: string = memoryCache.getAppNameCacheKey(1, '2', '3');
      expect(key === cacheKey).assertTrue();
    });

    it('MemoryCacheTest_testAppName', 0, () => {
      let appName: string = 'name';
      memoryCache.setAppNameCacheByCacheKey('1234', 'abcd');
      memoryCache.setAppName(1, 'com.ohos.app.dt', 'moduleName', appName);
      let name: string = memoryCache.getAppName(1, 'com.ohos.app.dt', 'moduleName');
      expect(name === appName).assertTrue();
    });
  });
}