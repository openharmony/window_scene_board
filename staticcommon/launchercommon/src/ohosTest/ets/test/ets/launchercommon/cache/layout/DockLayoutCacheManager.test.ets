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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import  DockLayoutCacheManager from '../../../../../../../main/ets/cache/layout/DockLayoutCacheManager';
import { CommonConstants, DefaultDesktopLayoutInfo, GridLayoutItemInfo,DockItemInfo } from '../../../../../../../main/ets/TsIndex';
import { ResultCode, ShortcutLimitInfo } from '../../../../../../../main/ets/launchericon/viewmodel/ShortcutViewModel';

export default function DockLayoutCacheManagerTest() {
  describe('DockLayoutCacheManagerTest', () => {
    let dockLayoutCacheManager: DockLayoutCacheManager;
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      dockLayoutCacheManager = new DockLayoutCacheManager();
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
    it('test_updateShortcutLimitInfoByShortcutList_1', 0,async () => {

      const testShortcutList: Array<ShortcutLimitInfo> = [
        { bundleName: 'com.example.app', maxNum: 5 },
        { bundleName: 'com.example.game', maxNum: 3 }
      ];

      const result:ResultCode = await dockLayoutCacheManager.updateShortcutLimitInfoByShortcutList(testShortcutList);
      expect(result).assertEqual(ResultCode.SUCCESS);
    });

    it('test_updateShortcutLimitInfoByShortcutList_2',0, async () => {
      const testShortcutList: Array<ShortcutLimitInfo> = [
        { bundleName: 'null', maxNum: -1 },
        { bundleName: '', maxNum: 0 }
      ];
      const result:ResultCode  = await  dockLayoutCacheManager.updateShortcutLimitInfoByShortcutList(testShortcutList);
      expect(result).assertEqual(ResultCode.FAILED_OTHER);
    });

    it('test_getDockShortcutLimitInfoByList', 0,async () => {

      const testShortcutLimitList:ShortcutLimitInfo[] = [
        { bundleName: 'com.example.app', maxNum: 5 },
        { bundleName: 'com.example.game', maxNum: 3 }
      ];

      const result:GridLayoutItemInfo[] = dockLayoutCacheManager.getDockShortcutLimitInfoByList(testShortcutLimitList);
      expect(result.length).assertEqual(0);
    });

      it('test_getShortCountLimitByBundleName', 0,async () => {
        const testBundleName = 'com.example.unknown';
        const result: number | undefined = dockLayoutCacheManager.getShortCountLimitByBundleName(testBundleName);
        expect(result).assertUndefined;
      });
  })
}