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
import { GlobalContext, ResourceManager } from '../../../../../../main/ets/TsIndex';

export function ResourceManager2Test() {
  let accountSAReady: boolean | undefined;
  describe('ResourceManager2Test', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {
      accountSAReady = AppStorage.get<boolean>('accountSAReady');
      AppStorage.setOrCreate('accountSAReady', true);
    })
    afterAll((): void => {

    })
    afterEach((): void => {
      AppStorage.setOrCreate('accountSAReady', accountSAReady);
    })

    it('test_ResourceManager2Test_getBundleLabelWithCache_01', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getBundleLabelWithCache';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertLargerOrEqual(0);

      result = 0;
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertLargerOrEqual(0);

      result = 0;
      let tmp = GlobalContext.getInstance().getObject('desktopContext')
      GlobalContext.getInstance().setObject('desktopContext', null);
      ResourceManager.getInstance().getBundleLabelWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      GlobalContext.getInstance().setObject('desktopContext', tmp);
      expect(result).assertLargerOrEqual(0);

      result = 0;
      let cacheKey: string = `${labelId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', value);
      ResourceManager.getInstance().getBundleLabelWithCache(0, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      })
      expect(result).assertLargerOrEqual(0);
    })

    it('test_ResourceManager2Test_getAccountSAState1', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      ResourceManager.getInstance().getAccountSAState().then((success: boolean) => {
        result = 1;
        expect(result).assertEqual(1);
        done();
      })
    })

    it('test_ResourceManager2Test_getAppIconWithCache', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, null, value);
      ResourceManager.getInstance().getAppIconWithCache(0, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      expect(result).assertEqual(1);

      result = 0;
      /* 设置测试的数据，模拟可以获取缓存 */
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', 'icon_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'imageDescriptor', 'imageDescriptor_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'adaptiveicon', 'adaptiveicon_value');

      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === 'icon_value') {
          result = 1;
        }
      }, value);
      /* 清理模拟数据 */
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'icon');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'imageDescriptor');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'adaptiveicon');

      expect(result).assertEqual(1);
    })

    it('test_ResourceManager2Test_getAppIconWithCache2', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCache2';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let result = 0;
      let temp = GlobalContext.getInstance().getObject('desktopContext');

      GlobalContext.getInstance().setObject('desktopContext', null);
      ResourceManager.getInstance().getAppIconWithCache(labelId, bundleName, moduleName, (defaultValue: string) => {
        if (defaultValue === value) {
          result = 1;
        }
      }, value);
      GlobalContext.getInstance().setObject('desktopContext', temp);
      expect(result).assertEqual(1);
    })

    it('test_ResourceManager2Test_getAppIconWithCacheAsync', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppIconWithCacheAsync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'

      let ret1 = await ResourceManager.getInstance().getAppIconWithCacheAsync(0, bundleName, moduleName, value);
      expect(ret1).assertEqual(value);

      let ret2 = await ResourceManager.getInstance().getAppIconWithCacheAsync(labelId, bundleName, moduleName, value);
      expect(ret2).assertEqual(value);

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', 'icon_value');
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'adaptiveicon', 'adaptiveicon_value');
      let ret3 = await ResourceManager.getInstance().getAppIconWithCacheAsync(labelId, bundleName, moduleName, value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'icon');
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'adaptiveicon');
      expect(ret3).assertEqual('icon_value');

      done();
    })

    it('test_ResourceManager2Test_updateAppNameSync', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_updateAppNameSync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = await ResourceManager.getInstance().updateAppNameSync(labelId, bundleName, moduleName, value);
      expect(result).assertEqual(value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');

      done();
    })

    it('test_ResourceManager2Test_getAppNameSync', Level.LEVEL0, async (done: Function) => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppNameSync';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      let result1 = await ResourceManager.getInstance().getAppNameSync(0, bundleName, moduleName, value);
      expect(result1).assertEqual(value);

      let result2 = await ResourceManager.getInstance().getAppNameSync(labelId, bundleName, moduleName, value);
      expect(result2).assertEqual(value);

      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      let result3 = await ResourceManager.getInstance().getAppNameSync(labelId, bundleName, moduleName, value);
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      expect(result3).assertEqual('name_value');

      done();
    })

    it('test_ResourceManager2Test_getAppNameWithCache', Level.LEVEL0, (): void => {
      let labelId: number = 1;
      let bundleName: string = 'bundleTest_getAppNameWithCache';
      let moduleName: string = 'moduleTest';
      let cacheKey = `${labelId}${bundleName}${moduleName}`;
      let value = 'valueTest'
      let result = 0;

      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      ResourceManager.getInstance().getAppNameWithCache(null, bundleName, moduleName, value, (name: string) => {
        if (name === value) {
          result = 1;
        }
      });
      expect(result).assertEqual(1);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, null);
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
          result = 1;
      });
      expect(result).assertEqual(0);

      result = 0;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'name', 'name_value');
      ResourceManager.getInstance().getAppNameWithCache(labelId, bundleName, moduleName, value, (name: string) => {
        if (name === 'name_value') {
          result = 1;
        }
      });
      ResourceManager.getInstance().deleteAppResourceCache(cacheKey, 'name');
      expect(result).assertEqual(1);
    })
  })
}