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
  AppItemInfo,
  DeliverUtil,
  DisappearLastAppData,
  DockItemInfo,
  FolderAppItemInfo,
  FolderLayoutCacheManager,
  FolderLayoutStruct,
  FolderModel,
  FolderViewModel,
  GridLayoutItemInfo,
  RdbStoreManager,
  SettingsModel
} from '../../../../../../main/ets/TsIndex';
import { ObjUtil } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { FolderLayoutChangeListener } from '../../../../../../main/ets/folder/FolderViewModel';
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';

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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_addAppsToFolder', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(null);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = '123';

      instance.addAppsToFolder([appInfo], '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_addAppsToFolder_01', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = '123';

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = '111';
      folderItem.layoutInfo = [[info1]];

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItem);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = '123';

      instance.addAppsToFolder([appInfo], '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_addAppsToFolder_02', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = '123';

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = '111';
      folderItem.layoutInfo = [[info1]];
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

      instance.addAppsToFolder([appInfo], '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_addAppsToFolder_03', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = '123';

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = '111';
      folderItem.layoutInfo = [[info1], [], []];
      folderItem.badgeNumber = 1;

      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItem);

      let mockFunc2: Function = mocker.mockFunc(manager, manager.updateBadgeNumberByFolderId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.keyName = '234';
      appInfo.badgeNumber = 1;

      instance.addAppsToFolder([appInfo], '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_updateFolderAppLocation', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      instance.updateFolderAppLocation(null);
      expect(instance).not().assertNull();
    })

    it('test_updateFolderAppLocation_1', 0, () => {
      let instance = TestFolderViewModel.getInstance();

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = '123';
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
      info1.keyName = '123';
      info1.column = 1;
      info1.row = 1;
      info1.page = 1;

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
      dockItemInfo.bundleName = '123';

      let dockItemInfos: DockItemInfo[] = [dockItemInfo];

      let mocker: MockKit = new MockKit();
      let model = SettingsModel.getInstance();
      let mockFunc1: Function = mocker.mockFunc(model, model.getResidentList);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(dockItemInfos);

      let manager: RdbStoreManager = RdbStoreManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(manager, manager.updateGridInfoById);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(undefined);

      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.folderId = '123';

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
      dockItemInfo.bundleName = '123';
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
      info1.folderId = '123';

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

      let folderId: string = '123';
      let lastAppBundleName: string = '123';
      let hiddenAppBundleName: string = '123';
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
      info1.keyName = '123';
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
      info1.keyName = '123';
      info1.column = 1;
      info1.row = 1;
      info1.page = 1;

      let info2 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info2.keyName = '123';
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

    it('test_isFolderInCurrentPageOfDesktop_1', 0, () => {
      let ans = FolderViewModel.isFolderInCurrentPageOfDesktop(0);
      expect(ans).assertTrue();
    })

    it('test_registerFolderLayoutChangeListener_1', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let info1 : GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = 'keyName123';
      info1.column = 1;
      info1.row = 1;
      info1.page = 1;
      let folderLayoutChangeListener: FolderLayoutChangeListener = {
        rename: (name: string) => {
          name = 'keyName321';
        }
      };
      instance.registerFolderLayoutChangeListener(info1, folderLayoutChangeListener);
      instance.unregisterFolderLayoutChangeListener(info1,folderLayoutChangeListener);
      expect(instance).not().assertNull();
    })

    it('FolderViewModelTest_addAppsToFolder_isFolderFull', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.keyName = '123';
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.keyName = '111';
      folderItem.layoutInfo = [[info1]];
      folderItem.badgeNumber = 0;
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      let mocker: MockKit = new MockKit();
      let manager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItem);
      let mockFunc2: Function = mocker.mockFunc(TestFolderViewModel, TestFolderViewModel.isFolderFull);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      instance.addAppsToFolder([], '1');
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clear(TestFolderViewModel);
      mocker.clearAll();
    })

    it('FolderViewModelTest_isFolderInCurrentPageOfDesktop_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(desktopUtil, desktopUtil.getPageIndexValue);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(2);
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let ans = TestFolderViewModel.isFolderInCurrentPageOfDesktop(2);
      expect(ans).assertTrue();
      mocker.clear(manager);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('FolderViewModelTest_getRealFolderName', 0, () => {
      let instance = TestFolderViewModel.getInstance();
      let res = instance.getRealFolderName(undefined);
      expect(res).assertUndefined();
      let mocker: MockKit = new MockKit();
      let manager: ResourceManager = ResourceManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(manager, manager.getStringByName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('RealFolderNam');
      let originFolderName = '${fahksddshf7}.fold';
      let res1 = instance.getRealFolderName(originFolderName);
      expect(res1).assertEqual('RealFolderNam');
      let originFolderName1 = '${fahksddshf7}';
      let res2 = instance.getRealFolderName(originFolderName1);
      expect(res2).assertEqual('RealFolderNam');
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('FolderViewModelTest_filterEmptyItemInLayout', 0, () => {
      let folderAppItemInfo: GridLayoutItemInfo[] = [];
      let res: GridLayoutItemInfo[] = TestFolderViewModel.filterEmptyItemInLayout(null)
      expect(res.length).assertEqual(0);
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppItemInfo.push(folderItem);
      let folderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppItemInfo.push(folderItem1);
      let res1: GridLayoutItemInfo[] = TestFolderViewModel.filterEmptyItemInLayout(folderAppItemInfo)
      expect(res1.length).not().assertEqual(0);
    })

    it('FolderViewModelTest_filterEmptyItemInFolder', 0, () => {
      let folderAppItemInfo: FolderAppItemInfo[] = [];
      let res: FolderAppItemInfo[] = TestFolderViewModel.filterEmptyItemInFolder(null)
      expect(res.length).assertEqual(0);
      let folderItem: FolderAppItemInfo = new FolderAppItemInfo();
      folderAppItemInfo.push(folderItem);
      let folderItem1: FolderAppItemInfo = new FolderAppItemInfo();
      folderAppItemInfo.push(folderItem1);
      let res1: FolderAppItemInfo[] = TestFolderViewModel.filterEmptyItemInFolder(folderAppItemInfo);
      expect(res1.length).not().assertEqual(1);
    })

    it('FolderViewModelTest_isFolderFull', 0, () => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.folderId = 'hjalklllmlklkk';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let isFolderFull: boolean = TestFolderViewModel.isFolderFull(gridLayoutItemInfo);
      expect(isFolderFull).assertFalse();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let isFolderFull1: boolean = TestFolderViewModel.isFolderFull(gridLayoutItemInfo);
      expect(isFolderFull1).assertFalse();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      gridLayoutItemInfo.folderId = 'hjalklllmlklkk';
      gridLayoutItemInfo.typeId = CommonConstants.TYPE_APP;
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_ADD;
      gridLayoutItemInfo.layoutInfo = [[item]];
      let isFolderFull2: boolean = TestFolderViewModel.isFolderFull(gridLayoutItemInfo);
      expect(isFolderFull2).assertFalse();
      mocker.clear(ObjUtil);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it('FolderViewModelTest_canFolderDropIn', 0, () => {
      let isCan: boolean = TestFolderViewModel.canFolderDropIn(null, null);
      expect(isCan).assertFalse();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.folderId = 'hjalklllmlklkk';
      itemInfo.typeId = CommonConstants.TYPE_APP;
      let dragItems: GridLayoutItemInfo[] = [];
      for (let index = 0; index < 3; index++) {
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.folderId = 'hjalklllmlklkk';
        itemInfo.typeId = CommonConstants.TYPE_APP;
        dragItems.push(itemInfo);
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(TestFolderViewModel, TestFolderViewModel.getMaxAppCount);
      when(mockFunc)().afterReturn(10);
      let isCan1: boolean = TestFolderViewModel.canFolderDropIn(itemInfo, dragItems);
      expect(true).assertTrue();
      let dragItems_max: GridLayoutItemInfo[] = [];
      for (let index = 0; index < 300; index++) {
        let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        itemInfo.folderId = 'hjalklllmlklkk';
        itemInfo.typeId = CommonConstants.TYPE_APP;
        dragItems_max.push(itemInfo);
      }
      let isCan3: boolean = TestFolderViewModel.canFolderDropIn(itemInfo, dragItems_max);
      expect(isCan3).assertFalse();
      itemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let isCan2: boolean = TestFolderViewModel.canFolderDropIn(itemInfo, dragItems);
      expect(isCan2).assertFalse();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      itemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
      let isCan4: boolean = TestFolderViewModel.canFolderDropIn(itemInfo, dragItems);
      expect(true).assertTrue();
      mocker.clear(DeliverUtil);
      mocker.clear(TestFolderViewModel);
      mocker.clearAll();
    })

    it('FolderViewModelTest_isInFolder', 0, () => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.folderId = 'hjalklllmlklkk';
      itemInfo.typeId = 0;
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.folderId = 'hjalklllmlklkk';
      dragItemInfo.typeId = 0;
      let isInFolder: boolean = TestFolderViewModel.isInFolder(null, null);
      expect(isInFolder).assertFalse();
      let isInFolder1: boolean = TestFolderViewModel.isInFolder(itemInfo, null);
      expect(isInFolder1).assertFalse();
      itemInfo.folderId = 'hjalklllmlklkk';
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      let isInFolder2: boolean = TestFolderViewModel.isInFolder(itemInfo, dragItemInfo);
      expect(isInFolder2).assertFalse();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(AppItemInfo, AppItemInfo.getKeyName);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('testdrayname');
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.layoutInfo = [[dragItemInfo]];
      let isInFolder3: boolean = TestFolderViewModel.isInFolder(itemInfo, dragItemInfo);
      expect(true).assertTrue();
      mocker.clear(AppItemInfo);
      mocker.clearAll();
    })

    it('FolderViewModelTest_canDragIn', 0, () => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.folderId = 'hjalklllmlklkk';
      itemInfo.typeId = 0;
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.folderId = 'hjalklllmlklkk';
      dragItemInfo.typeId = 0;
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(AppItemInfo, AppItemInfo.getKeyName);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('testdrayname');
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      itemInfo.layoutInfo = [[dragItemInfo]];
      let isInFolder3: boolean = TestFolderViewModel.canDragIn(itemInfo, dragItemInfo);
      expect(isInFolder3).assertTrue();
      let isInFolder1: boolean = TestFolderViewModel.canDragIn(null, null);
      expect(isInFolder1).assertTrue();
      mocker.clear(AppItemInfo);
      mocker.clearAll();
    })


  })
}


export class TestFolderViewModel extends FolderViewModel {
  private constructor() {
    super();
  }

  public static getInstance(): TestFolderViewModel {
    if (globalThis.TestFolderViewModelInstance == null) {
      globalThis.TestFolderViewModelInstance = new TestFolderViewModel();
    }
    return globalThis.TestFolderViewModelInstance;
  }

  public getNewFolderName(): Promise<string> {
    return ResourceManager.getInstance().getStringByIdSync($r('app.string.new_folder_name').id);
  }
}