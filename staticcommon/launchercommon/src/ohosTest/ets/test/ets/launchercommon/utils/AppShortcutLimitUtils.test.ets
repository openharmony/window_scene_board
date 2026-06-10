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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  AppShortcutLimitUtils,
  AppShortcutLimitSourceType
} from '../../../../../../main/ets/utils/AppShortcutLimitUtils';
import { CommonConstants, GridLayoutItemInfo, } from '../../../../../../main/ets/TsIndex';
import { ShortcutLimitInfo } from '../../../../../../main/ets/launchericon/viewmodel/ShortcutViewModel';

export default function AppShortcutLimitUtilsTest() {
  describe('AppShortcutLimitUtilsTest', () => {
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

    it('isSameAppNoShortcutByBundleName', 0, () => {
      const testItemInfo: GridLayoutItemInfo = {
        typeId: CommonConstants.TYPE_APP,
        bundleName: 'com.example.app',
        appIndex: 0,
      } as GridLayoutItemInfo;
      const result = AppShortcutLimitUtils.isSameAppNoShortcutByBundleName(testItemInfo, 'com.example.app', 0)
      expect(result).assertTrue;
    });

    it('getAllAppListContainFolder', 0, () => {
      const appList: GridLayoutItemInfo[] = [
        {
          typeId: 1, bundleName: 'App1'
        },
        {
          typeId: CommonConstants.TYPE_FOLDER, bundleName: 'Folder1'
        },
        {
          typeId: 2, bundleName: 'App2'
        }
      ] as GridLayoutItemInfo[];
      const expectedOutput: GridLayoutItemInfo[] = [
        {
          typeId: 1, bundleName: 'App1'
        },
        {
          typeId: 3, bundleName: 'AppInFolder'
        },
        {
          typeId: 2, bundleName: 'App2'
        }
      ] as GridLayoutItemInfo[];
      expect(AppShortcutLimitUtils.getAllAppListContainFolder(appList).length).assertEqual(2);
    });

    it('test_getShortCountLimitByBundleName', 0, () => {
      const bundleName = 'com.example.app';
      const sourceLayoutItem: GridLayoutItemInfo[] = [
        {
          bundleName: 'com.example.app'
        },
        {
          bundleName: 'com.example.other'
        }
      ] as GridLayoutItemInfo[];
      const sourceType: AppShortcutLimitSourceType = AppShortcutLimitSourceType.GRID_SOURCE;
      const result: number | undefined =
        AppShortcutLimitUtils.getShortCountLimitByBundleName(bundleName, sourceLayoutItem, sourceType);
      expect(result).assertUndefined;
    });

    it('test_getShortcutLimitUpdateItem_1', 0, () => {

      const itemList: GridLayoutItemInfo[] = [
        {
          bundleName: 'com.example.app1',
          appIndex: 0,
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify({})
        },
        {
          bundleName: 'com.example.app2',
          appIndex: 1,
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify({})
        }
      ] as GridLayoutItemInfo[];
      const shortcutList: ShortcutLimitInfo[] = [
        {
          bundleName: 'com.example.app1', maxNum: 5
        },
        {
          bundleName: 'com.example.app2', maxNum: 3
        }
      ] as ShortcutLimitInfo[];
      const result: GridLayoutItemInfo[] = AppShortcutLimitUtils.getShortcutLimitUpdateItem(itemList, shortcutList,
        AppShortcutLimitSourceType.GRID_SOURCE) as GridLayoutItemInfo[];
      expect(result.length).assertEqual(1);
    });

    it('test_getShortcutLimitUpdateItem_2', 0, () => {
      const itemList: GridLayoutItemInfo[] = [
        {
          bundleName: 'com.example.app1',
          appIndex: 0,
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify({})
        }
      ] as GridLayoutItemInfo[];
      const shortcutList: ShortcutLimitInfo[] = [
        {
          bundleName: 'com.example.app3', maxNum: 4
        }
      ];
      const result: GridLayoutItemInfo[] = AppShortcutLimitUtils.getShortcutLimitUpdateItem(itemList, shortcutList,
        AppShortcutLimitSourceType.GRID_SOURCE);
      expect(result.length).assertEqual(0);
    });
  })
}