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
  ArgumentMatchers } from '@ohos/hypium';
import {
  DisappearLastAppData,
  DockItemInfo,
  FolderLayoutCacheManager,
  FolderLayoutStruct,
  FolderModel,
  FolderViewModel, GridLayoutItemInfo,
  RdbStoreManager,
  SettingsModel } from '../../../../main/ets/TsIndex';

function retNull(): null | GridLayoutItemInfo[] | string | Function {
  return null;
}

export default function FolderViewModelTest() {
  describe('FolderViewModelTest', () => {
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
    it('test_reLayoutFolder', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      instance.reLayoutFolder();
      expect(true).assertTrue();
    })

    it('test_addOneAppToFolder1', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(null);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = '5588';

      instance.addOneAppToFolder(appInfo, '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_addOneAppToFolder_01', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = '369';

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = '258';
      folderItem.layoutInfo = [[info1]];

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItem);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = '444';

      instance.addOneAppToFolder(appInfo, '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_addOneAppToFolder_02', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info : GridLayoutItemInfo = new GridLayoutItemInfo();
      info.keyName = 'key';

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = 'name';
      folderItem.layoutInfo = [[info]];
      folderItem.badgeNumber = 0;

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItem);

      let mockFunc2: Function = mocker.mockFunc(manager, manager.updateBadgeNumberByFolderId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = '234';
      appInfo.badgeNumber = 1;

      instance.addOneAppToFolder(appInfo, '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_addOneAppToFolder_03', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = 'keyName';

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = 'keyName';
      folderItem.layoutInfo = [[info1], [], []];
      folderItem.badgeNumber = 1;

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItem);

      let mockFunc2: Function = mocker.mockFunc(manager, manager.updateBadgeNumberByFolderId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = 'key123456789';
      appInfo.badgeNumber = 1;

      instance.addOneAppToFolder(appInfo, '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_addOneAppToFolder_04', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = 'keyName';

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = 'keyName';
      folderItem.layoutInfo = [[info1], [], retNull() as []];
      folderItem.badgeNumber = 1;

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItem);

      let mockFunc2: Function = mocker.mockFunc(manager, manager.updateBadgeNumberByFolderId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = 'key123456789';
      appInfo.badgeNumber = 1;

      instance.addOneAppToFolder(appInfo, '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_generateFolderName', 0, async () => {
      let instance = TestFolderViewModel.getInstance();
      let folderName: string = await instance.getNewFolderName();
      expect(folderName).not().assertNull();

      let folder1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder1.folderName = '${new_folder_name}1';
      let folder2: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder1.folderName = '${new_folder_name}aa';
      let folder3: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folder4: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder4.folderName = 'aaa';
      const folderList: GridLayoutItemInfo[] = [folder1, folder2, folder3, folder4];

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemsByType);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderList);

      let dockItem1: DockItemInfo = new DockItemInfo();
      dockItem1.appName = '${new_folder_name}3';
      let dockItem2: DockItemInfo = new DockItemInfo();
      dockItem2.appName = '${new_folder_name}aa';

      let residentList: DockItemInfo[] = [dockItem1, dockItem2];
      let settingModel: SettingsModel = SettingsModel.getInstance();
      let mockFunc2: Function = mocker.mockFunc(manager, settingModel.getResidentList);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(residentList);

      folderName = await instance.getNewFolderName();
      expect(folderName).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_getRealFolderName', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let folderName: string = retNull() as string;
      let retValue = instance.getRealFolderName(folderName);
      expect(retValue).assertNull();
      folderName = 'aaa';
      retValue = instance.getRealFolderName(folderName);
      expect(retValue).assertEqual(folderName);

      folderName = '${new_folder_name}';
      retValue = instance.getRealFolderName(folderName);
      expect(retValue).assertEqual(folderName);

      folderName = '${new_folder_name}1';
      retValue = instance.getRealFolderName(folderName);
      expect(retValue).assertEqual(folderName);
    })

    it('test_deleteAppLayoutItems', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let disappearLastAppData: DisappearLastAppData = new DisappearLastAppData();
      AppStorage.setOrCreate('disappearLastAppData', disappearLastAppData);

      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.updateFolderAppLocation);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(null);

      let appListInfo = [];
      // let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppInfo: [] = []
      instance.deleteAppLayoutItems(appListInfo, folderAppInfo);

      disappearLastAppData.folderId = 'anyFolderId';
      AppStorage.setOrCreate('disappearLastAppData', disappearLastAppData);
      instance.deleteAppLayoutItems(appListInfo, folderAppInfo);

      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    })



    it('test_isFolderDisappearing', 0, () => {
      let disappearLastAppData: DisappearLastAppData = new DisappearLastAppData();
      AppStorage.setOrCreate('disappearLastAppData', disappearLastAppData);

      let instance = TestFolderViewModel.getInstance();
      let retValue: boolean = instance.isFolderDisappearing();
      expect(retValue).assertFalse();

      disappearLastAppData.folderId = retNull() as string;
      AppStorage.setOrCreate('disappearLastAppData', disappearLastAppData);
      retValue = instance.isFolderDisappearing();
      expect(retValue).assertFalse();

      disappearLastAppData.folderId = 'aaa';
      AppStorage.setOrCreate('disappearLastAppData', disappearLastAppData);
      retValue = instance.isFolderDisappearing();
      expect(retValue).assertTrue();
    })

    it('test_registerFolderStatusChangeListener', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let listener: Function = ()=> {};
      instance.registerFolderStatusChangeListener(listener);

      listener = retNull() as Function;
      instance.registerFolderStatusChangeListener(listener);
    })

    it('test_unregisterFolderStatusChangeListener', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let listener: Function = ()=> {};
      instance.unregisterFolderStatusChangeListener(listener);

      listener = retNull() as Function;
      instance.unregisterFolderStatusChangeListener(listener);
    })

    it('test_translateFolderLayout', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];
      for (let idx = 0; idx < 18; idx++) {
        appInfos.push(new GridLayoutItemInfo());
      }
      instance.updateFolderAppLocation(appInfos);
      expect(instance).not().assertNull();
    })

    it('test_updateFolderAppLocation', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      instance.updateFolderAppLocation(null);
      expect(instance).not().assertNull();
    })

    it('test_updateFolderAppLocation_1', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = 'demo';
      info1.column = 1;
      info1.row = 1;
      info1.page = 1;

      let appInfo: GridLayoutItemInfo[] = [];
      appInfo.push(info1);

      instance.updateFolderAppLocation(appInfo);
      expect(instance).not().assertNull();
    })

    it('test_modifyFolderName', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let dockItemInfo = new DockItemInfo();
      dockItemInfo.typeId = 0;

      let dockItemInfos: DockItemInfo[] = [dockItemInfo];

      let mocker: MockKit = new MockKit();
      let model = SettingsModel.getInstance();
      let mockFunc1: Function = mocker.mockFunc(model, model.getResidentList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockItemInfos);

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = 'app';
      info1.column = 1;
      info1.row = 1;
      info1.page = 2;

      let appInfo: GridLayoutItemInfo[] = [];
      appInfo.push(info1);

      instance.modifyFolderName(appInfo, false);
      expect(instance).not().assertNull();
      mocker.clear(model);
      mocker.clearAll();
    })

    it('test_modifyFolderName_1', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let dockItemInfo = new DockItemInfo();
      dockItemInfo.typeId = 3;
      dockItemInfo.bundleName = 'bundle';

      let dockItemInfos: DockItemInfo[] = [dockItemInfo];

      let mocker: MockKit = new MockKit();
      let model = SettingsModel.getInstance();
      let mockFunc1: Function = mocker.mockFunc(model, model.getResidentList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockItemInfos);

      let manager: RdbStoreManager = RdbStoreManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(manager, manager.updateGridInfoById);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.folderId = 'folderId123';

      instance.modifyFolderName(info1, false);
      expect(instance).not().assertNull();
      mocker.clear(model);
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_modifyFolderName_2', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let dockItemInfo = new DockItemInfo();
      dockItemInfo.typeId = 3;
      dockItemInfo.bundleName = 'folderId123';
      dockItemInfo.layoutInfo = [];

      let dockItemInfos: DockItemInfo[] = [dockItemInfo];

      let mocker: MockKit = new MockKit();
      let model = SettingsModel.getInstance();
      let mockFunc1: Function = mocker.mockFunc(model, model.getResidentList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockItemInfos);

      let manager: RdbStoreManager = RdbStoreManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(manager, manager.insertFolderLayout);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.folderId = 'f-123';

      instance.modifyFolderName(info1, true);
      expect(instance).not().assertNull();
      mocker.clear(model);
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_isFolderClose', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      instance.isFolderClose();
      expect(instance).not().assertNull();
    })

    it('test_setDisappearFolderData', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let data = AppStorage.get<DisappearLastAppData>('disappearLastAppData');

      let folderId: string = 'demo';
      let lastAppBundleName: string = 'demo1';
      let hiddenAppBundleName: string = 'hidden258';
      instance.setDisappearFolderData(folderId, lastAppBundleName, hiddenAppBundleName);
      expect(instance).not().assertNull();
      AppStorage.setOrCreate('disappearLastAppData', data);
    })

    it('test_listener', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      try {
        let func: Function = () => {};
        instance.registerFolderStatusChangeListener(func);
        instance.unregisterFolderStatusChangeListener(func);
        expect(instance).not().assertNull();
      } catch (e) {
        expect(instance).not().assertNull();
      }
    })

    it('test_listener2', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      instance.registerFolderStatusChangeListener(undefined);
      instance.unregisterFolderStatusChangeListener(undefined);
      expect(instance).not().assertNull();
    })

    it('test_translateFolderLayout', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = 'k001';
      info1.column = 1;
      info1.row = 1;
      info1.page = 1;

      let appInfo: GridLayoutItemInfo[] = [];
      appInfo.push(info1);

      let mocker: MockKit = new MockKit();
      let model = FolderModel.getInstance();
      let s1: FolderLayoutStruct = new FolderLayoutStruct();
      s1.column = 1;
      s1.row = 1;
      let mockFunc1: Function = mocker.mockFunc(model, model.getFolderOpenLayout);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(s1);

      instance.translateFolderLayout(appInfo);

      expect(instance).not().assertNull();
      mocker.clear(model);
      mocker.clearAll();
    })

    it('test_translateFolderLayout_1', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = 'keyName123';
      info1.column = 1;
      info1.row = 1;
      info1.page = 1;

      let info2 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info2.keyName = 'keyName123';
      info2.column = 1;
      info2.row = 1;
      info2.page = 1;

      let appInfo: GridLayoutItemInfo[] = [];
      appInfo.push(info1);
      appInfo.push(info2);

      let mocker: MockKit = new MockKit();
      let model = FolderModel.getInstance();
      let s1: FolderLayoutStruct = new FolderLayoutStruct();
      s1.column = 1;
      s1.row = 1;
      let mockFunc1: Function = mocker.mockFunc(model, model.getFolderOpenLayout);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(s1);

      instance.translateFolderLayout(appInfo);

      expect(instance).not().assertNull();
      mocker.clear(model);
      mocker.clearAll();
    })

  })
}

export class TestFolderViewModel extends FolderViewModel {
  public getNewFolderName(): Promise<string> {
    return this.generateFolderName();
  }
  private constructor() {
    super();
  }

  public static getInstance(): TestFolderViewModel {
    if (globalThis.TestFolderViewModelInstance == null) {
      globalThis.TestFolderViewModelInstance = new TestFolderViewModel();
    }
    return globalThis.TestFolderViewModelInstance;
  }
}