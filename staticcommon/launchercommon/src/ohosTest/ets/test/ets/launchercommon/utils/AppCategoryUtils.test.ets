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

import { CommonConstants, DockItemInfo, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium';
import { AppCategoryUtils } from '../../../../../../main/ets/TsIndex';
import { appInfoManager } from '@kit.StoreKit';
import { LaunchLayoutCacheManager } from '../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';


/**
 * AppCategoryUtils DT测试套
 */
export default function AppCategoryUtilsTest() {
  let mocker: MockKit;
  describe('AppCategoryUtilsTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    it('test_AppCategoryUtils_getBundleNameList_when_items_contains_valid_items_with_folder_type', 0, () => {
      let gridLayoutItemInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo1.bundleName = 'com.example.app1';
      gridLayoutItemInfo1.typeId = CommonConstants.TYPE_APP;

      let gridLayoutItemInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo2.bundleName = 'com.example.app2';
      gridLayoutItemInfo2.typeId = CommonConstants.TYPE_CARD;

      let gridLayoutItemInfo3: GridLayoutItemInfo | undefined = undefined;

      let gridLayoutItemInfo4: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo4.bundleName = 'com.example.app4';
      gridLayoutItemInfo4.typeId = CommonConstants.TYPE_APP;

      let gridLayoutItemInfo5: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo5.bundleName = 'com.example.app5';
      gridLayoutItemInfo5.typeId = CommonConstants.TYPE_FOLDER;
      gridLayoutItemInfo5.layoutInfo = [[gridLayoutItemInfo4]];

      let items: (GridLayoutItemInfo | undefined)[] =
        [gridLayoutItemInfo1, gridLayoutItemInfo2, gridLayoutItemInfo3, gridLayoutItemInfo5];

      let result = AppCategoryUtils.getBundleNameList(items);
      expect(result).assertDeepEquals(['com.example.app1', 'com.example.app4']);
    });

    it('test_AppCategoryUtils_getBundleNameList_when_items_is_null', 0, () => {
      const result = AppCategoryUtils.getBundleNameList(null);
      expect(result).assertDeepEquals([]);
    });

    it('test_AppCategoryUtils_getBundleNameList_when_items_is_empty', 0, () => {
      const result = AppCategoryUtils.getBundleNameList([]);
      expect(result).assertDeepEquals([]);
    });

    it('test_AppCategoryUtils_getAllAppBundleNames_when_both_grid_and_dock_items_are_not_empty', 0, () => {
      let mockGetGridItems: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
      let gridItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem1.bundleName = 'com.example.app1';
      gridItem1.typeId = CommonConstants.TYPE_APP;
      let gridItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem2.bundleName = 'com.example.app2';
      gridItem2.typeId = CommonConstants.TYPE_APP;
      when(mockGetGridItems)(ArgumentMatchers.anyString).afterReturn([gridItem1, gridItem2]);

      let mockGetDockItems: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let dockItem1: DockItemInfo = new DockItemInfo();
      dockItem1.bundleName = 'com.example.app3';
      dockItem1.typeId = CommonConstants.TYPE_APP;
      let dockItem2: DockItemInfo = new DockItemInfo();
      dockItem2.bundleName = 'com.example.app4';
      dockItem2.typeId = CommonConstants.TYPE_APP;
      when(mockGetDockItems)(ArgumentMatchers.anyString).afterReturn([dockItem1, dockItem2]);

      const result = AppCategoryUtils.getAllAppBundleNames();
      expect(result).assertDeepEquals(['com.example.app1', 'com.example.app2', 'com.example.app3', 'com.example.app4']);

      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.ignoreMock(AppStorage, AppStorage.get);
    });

    it('test_AppCategoryUtils_getAllAppBundleNames_when_dock_items_are_empty', 0, async () => {
      let mockGetGridItems: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
      let gridItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem1.bundleName = 'com.example.app1';
      gridItem1.typeId = CommonConstants.TYPE_APP;
      let gridItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridItem2.bundleName = 'com.example.app2';
      gridItem2.typeId = CommonConstants.TYPE_APP;
      when(mockGetGridItems)(ArgumentMatchers.anyString).afterReturn([gridItem1, gridItem2]);

      let mockGetDockItems: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockGetDockItems)(ArgumentMatchers.anyString).afterReturn([]);

      const result = AppCategoryUtils.getAllAppBundleNames();
      expect(result).assertDeepEquals(['com.example.app1', 'com.example.app2']);

      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.ignoreMock(AppStorage, AppStorage.get);
    });

    it('test_AppCategoryUtils_getAllAppBundleNames_when_grid_items_are_empty', 0, async () => {
      let mockGetGridItems: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
      when(mockGetGridItems)(ArgumentMatchers.anyString).afterReturn([]);

      let mockGetDockItems: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      let dockItem1: DockItemInfo = new DockItemInfo();
      dockItem1.bundleName = 'com.example.app1';
      dockItem1.typeId = CommonConstants.TYPE_APP;
      let dockItem2: DockItemInfo = new DockItemInfo();
      dockItem2.bundleName = 'com.example.app2';
      dockItem2.typeId = CommonConstants.TYPE_APP;
      when(mockGetDockItems)(ArgumentMatchers.anyString).afterReturn([dockItem1, dockItem2]);

      const result = AppCategoryUtils.getAllAppBundleNames();
      expect(result).assertDeepEquals(['com.example.app1', 'com.example.app2']);

      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.ignoreMock(AppStorage, AppStorage.get);
    });


    it('test_AppCategoryUtils_getAllAppBundleNames_when_gridItems_and_dockItems_are_empty', 0, () => {
      let mockGetGridItems: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
        LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
      when(mockGetGridItems)(ArgumentMatchers.anyString).afterReturn([]);

      let mockGetDockItems: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockGetDockItems)(ArgumentMatchers.anyString).afterReturn([]);

      const result = AppCategoryUtils.getAllAppBundleNames();
      expect(result).assertDeepEquals([]);

      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.ignoreMock(AppStorage, AppStorage.get);
    });

    it('test_AppCategoryUtils_getIntelFolderName_when_length_is_less_than_2', 0, () => {
      const result = AppCategoryUtils.getIntelFolderName('test');
      expect(result).assertEqual('');
    });

    it('test_AppCategoryUtils_getIntelFolderName_when_length_is_2_and_tempNameArr1_is_null', 0, () => {
      const result = AppCategoryUtils.getIntelFolderName('test#');
      expect(result).assertEqual('');
    });

    it('test_AppCategoryUtils_getIntelFolderName_when_length_is_2_and_tempNameArr1_is_not_null', 0, () => {
      let mockfunc1: Function = mocker.mockFunc(ResourceManager.getInstance(),
        ResourceManager.getInstance().getStringByName);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturn('test');

      const result = AppCategoryUtils.getIntelFolderName('#test');
      expect(result).assertEqual('test');
      mocker.clear(ResourceManager.getInstance());
    });

    it('test_AppCategoryUtils_getIntelFolderName_when_length_is_3_and_tempNameArr1_or_tempNameArr2_is_null', 0, () => {
      const result = AppCategoryUtils.getIntelFolderName('#test#');
      expect(result).assertEqual('');
    });

    it('test_AppCategoryUtils_getIntelFolderName_when_length_is_3_and_appCatName1_or_appCatName2_is_null', 0, () => {
      let mockfunc: Function = mocker.mockFunc(ResourceManager.getInstance(),
        ResourceManager.getInstance().getStringByName);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn('');
      const result = AppCategoryUtils.getIntelFolderName('#test1#test2');
      expect(result).assertEqual('');
      mocker.clear(ResourceManager.getInstance());
    });

    it('test_AppCategoryUtils_getIntelFolderName_when_length_is_3_tempNameArr1_tempNameArr2_are_not_null', 0, () => {
      let mockfunc1: Function = mocker.mockFunc(ResourceManager.getInstance(),
        ResourceManager.getInstance().getStringByName);
      when(mockfunc1)(ArgumentMatchers.anyString).afterReturn('test');
      let mockfunc2: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerStringNumS);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn('test1&test2');

      const result = AppCategoryUtils.getIntelFolderName('#test1#test2');
      expect(result).assertEqual('test1&test2');

      mocker.clear(ResourceManager.getInstance());
      mocker.ignoreMock(ResUtils, ResUtils.getInnerStringNumS);
    });


    it('test_AppCategoryUtils_valuesBucket_when_appCatInfo_is_null', 0, () => {
      const result = AppCategoryUtils.toValuesBucket(null);
      expect(result).assertDeepEquals({});

    });

    it('test_AppCategoryUtils_valuesBucket_when_appCatInfo_is_not_null', 0, () => {
      const appCatInfo: appInfoManager.AppCategoryInfo = {
        bundleName: 'com.example.app',
        primaryCategoryId: 0,
        secondaryCategoryId: 123,
        appQueryCode: 0,
      };
      const result = AppCategoryUtils.toValuesBucket(appCatInfo);
      expect(result).not().assertNull();
    });

    it('test_AppCategoryUtils_fromResultSet_when_resultSet_is_null', 0, () => {
      const result = AppCategoryUtils.fromResultSet(null);
      expect(result).assertNull();
    });
  });
}