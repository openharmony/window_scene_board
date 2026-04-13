/*
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  FolderAddItemInfo,
  OpenFolderAddViewModel
} from '../../../../main/ets/default/viewmodel/OpenFolderAddViewModel';
import {
  CommonConstants,
  FolderData,
  FolderLayoutCacheManager,
  GridLayoutUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GridLayoutItemInfo } from '@ohos/launchercommon'
import { DeviceHelper, ResourceManager } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';

export default function OpenFolderAddViewModelTest() {
  describe('OpenFolderAddViewModelTest', () => {
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
    it('test_getContainsItemList_10', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = undefined;
      const openFolderAddViewModel: OpenFolderAddViewModel = OpenFolderAddViewModel.getInstance();
      const folderData: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderData, folderData.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      expect(openFolderAddViewModel.getContainsItemList()).not().assertNull();
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAddIcon);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      expect(openFolderAddViewModel.getContainsItemList()).not().assertNull();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(openFolderAddViewModel.getContainsItemList()).not().assertNull();
      mocker.clear(folderData);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    });

    it('test_addOtherApp_10', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderAddItemInfo: FolderAddItemInfo = new FolderAddItemInfo();
      const openFolderAddViewModel: OpenFolderAddViewModel = OpenFolderAddViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(openFolderAddViewModel, (openFolderAddViewModel as object)['getOthersData']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      (openFolderAddViewModel as object)['addOtherApp']([folderAddItemInfo]);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo]);
      (openFolderAddViewModel as object)['addOtherApp']([folderAddItemInfo]);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(openFolderAddViewModel);
      mocker.clearAll();
    });

    it('test_getOthersData_10', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_APP;
      gridLayoutItemInfo.appStatus = 0;
      gridLayoutItemInfo.container = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
      gridLayoutItemInfo.appLabelId = 1;
      gridLayoutItemInfo.bundleName = 'good_1';
      gridLayoutItemInfo.moduleName = 'good_2';
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance()
      const openFolderAddViewModel: OpenFolderAddViewModel = OpenFolderAddViewModel.getInstance();
      const resourceManager: ResourceManager = ResourceManager.getInstance()
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo]);
      let mockFunc1: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('');
      let mockFunc2: Function = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('');
      expect((openFolderAddViewModel as object)['getOthersData']()).not().assertNull();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);
      expect((openFolderAddViewModel as object)['getOthersData']()).not().assertNull();
      gridLayoutItemInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo]);
      expect((openFolderAddViewModel as object)['getOthersData']()).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(resourceManager);
      mocker.clearAll();
    });

    it('test_getOthersData_10', 0, () => {
      const openFolderAddViewModel: OpenFolderAddViewModel = OpenFolderAddViewModel.getInstance();
      AppStorage.set('screenHeight', 10);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      expect((openFolderAddViewModel as object)['getDialogMaxHeight']()).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((openFolderAddViewModel as object)['getDialogMaxHeight']()).not().assertNull();
      AppStorage.delete('screenHeight');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((openFolderAddViewModel as object)['getDialogMaxHeight']()).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clear(ResUtils);
      mocker.clearAll();
    });
  })
}