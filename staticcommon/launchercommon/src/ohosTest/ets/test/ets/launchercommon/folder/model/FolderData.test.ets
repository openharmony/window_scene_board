/**
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

import { LogDomain, LogHelper } from '@ohos/basicutils'
import { ObjectCopyUtil } from '@ohos/componenthelper';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import { ResidentLayoutCacheMgr } from '../../../../../../../main/ets/dock/cache/ResidentLayoutCacheMgr';
import { FolderData, FolderDataCallback } from '../../../../../../../main/ets/folder/model/FolderData'
import {
  AppItemInfo,
  DockItemInfo,
  FolderLayoutCacheManager,
  FolderLayoutStruct,
  FolderModel,
  GridLayoutItemBuilder,
  GridLayoutItemInfo,
  GridLayoutUtil
} from '../../../../../../../main/ets/TsIndex'

const TAG = 'FolderData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default function FolderDataTest() {
  describe('FolderDataTest', () => {
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
    it('getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let instance = FolderData.getInstance();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(instance).not().assertNull();
    })
    it('generateCallbackModuleName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let instance = FolderData.getInstance();
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      let tag: string = 'generateCallbackModuleName';
      let id: string = '12345678';
      let ex: string = 'ex';
      let res: string = instance.generateCallbackModuleName(tag, id, ex);
      expect(tag + id + ex).assertEqual(res);
    })

    it('open', 0, () => {
      let instance = FolderData.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      instance['open']('', folderItemInLayout, 0);
      instance['opened']('qweqwe');

      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByIndex);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout)

      instance['open']('', folderItemInLayout, 0);
      instance['opened']('qweqwe');
      instance['close']('', 0);
      instance['open']('', folderItemInLayout, 1);
      expect(instance.getOpenedFolder()).not().assertNull();

      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('close', 0, () => {
      let instance = FolderData.getInstance();
      instance['close']('', 0);
      expect(instance.getOpenedFolder()).not().assertNull();

      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByIndex);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout)

      instance['open']('', folderItemInLayout, 0);
      instance['close']('', 0);
      expect(instance.getOpenedFolder()).not().assertNull();

      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('Desc', 0, () => {
      let instance = FolderData.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      let item1 = new GridLayoutItemInfo();
      item1.typeId = 0;
      item1.bundleName = 'bundleName1';
      item1.abilityName = 'a';
      item1.badgeNumber = 1;
      let item2 = new GridLayoutItemInfo();
      item2.typeId = 0;
      item2.bundleName = 'bundleName2';
      item2.abilityName = 'a';
      item2.badgeNumber = 1;
      folderItemInLayout.layoutInfo?.push([item1, item2])
      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByIndex);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout)

      let result = instance.getCallbackDesc();
      expect(result).not().assertNull();
      result = instance.getCallbackDesc();
      expect(result).not().assertNull();
      result = instance.getFolderDataDesc();
      expect(result).not().assertNull();
      result = instance.getFoldersDesc();
      expect(result).not().assertNull();
      result = instance.getFolderItemsDesc('123456');
      expect(result).not().assertNull();

      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('CallBack', 0, () => {
      let instance = FolderData.getInstance();
      let call: FolderDataCallback = {
        moduleName: 'string',
        priority: 100,
        folderId: '123456'
      } as FolderDataCallback;
      instance.registerCallBack(call);

      instance.registerCallBack({
        moduleName: 'string1',
        priority: 100,
        folderId: '1234567'
      } as FolderDataCallback);

      instance.unregisterCallBack(call);
      instance.unregisterCallBackByName('string1');
      expect(instance).not().assertNull();
    })

    it('notify', 0, () => {
      let instance = FolderData.getInstance();
      let call: FolderDataCallback = {
        moduleName: 'string',
        priority: 100,
        folderId: '123456'
      } as FolderDataCallback;
      instance.registerCallBack(call);

      instance.registerCallBack({
        moduleName: 'string1',
        priority: 100,
        folderId: '123456'
      } as FolderDataCallback);
      expect(instance).not().assertNull();
      let mocker: MockKit = new MockKit();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      let mockFunc: Function =
        mocker.mockFunc(instance, instance.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout)

      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByIndex);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItemInLayout)
      instance['opened']('123456');
      instance['open']('123456', folderItemInLayout, 0);
      instance['opened']('123456');
      instance['close']('123456', 0);

      instance['open']('123456', folderItemInLayout, 1);
      instance['closed']('123456');
      instance['open']('123456', folderItemInLayout, 1);
      instance['close']('123456', 1);
      mocker.clear(instance);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('getInfo', 0, () => {
      let instance = FolderData.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      let item1 = new GridLayoutItemInfo();
      item1.keyName = 'item1.keyName';
      item1.bundleName = 'bundleName1';
      let item2 = new GridLayoutItemInfo();
      item2.keyName = 'item2.keyName';
      item2.bundleName = 'bundleName2';
      let item3 = new GridLayoutItemInfo();
      item3.keyName = 'item2.keyName';
      folderItemInLayout.layoutInfo?.push([item1, item2])

      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(instance, instance.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout);

      let folderModel = FolderModel.getInstance();
      let layout = {
        id: 1,
        layout: '4X3',
        name: '4X3',
        row: 4,
        column: 3,
        checked: false
      } as FolderLayoutStruct;
      let mockFunc1: Function =
        mocker.mockFunc(folderModel, folderModel.getFolderOpenLayout);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      instance['getIndex'](item1);
      instance['getPageIndex'](item1);
      instance['getIndex'](item3);
      instance['getPageIndex'](item3);

      layout.column = 0;
      instance['getIndex'](item1);
      instance['getIndex'](item3);

      layout.column = 1;
      layout.row = 1;
      instance['getIndex'](item1);
      instance['getPageIndex'](item3);

      expect(instance).not().assertNull();

      mocker.clear(instance);
      mocker.clear(folderModel);
      mocker.clearAll();
    })

    it('EMPTY_ITEM', 0, () => {
      let instance = FolderData.getInstance();
      let info: GridLayoutItemInfo = instance.getOpenedFolder();
      info.setInfo(new GridLayoutItemBuilder(1));
      info.fillInfoWithAppItem(new AppItemInfo);
      info.toAppItemInfo();
      expect(instance).not().assertNull();
    })

    it('getItemsInFolder', 0, () => {
      let instance = FolderData.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      instance['getItemsInFolder'](folderItemInLayout);

      let item1 = new GridLayoutItemInfo();
      item1.keyName = 'item1.keyName';
      item1.bundleName = 'bundleName1';
      let item2 = new GridLayoutItemInfo();
      item2.keyName = 'item2.keyName';
      item2.bundleName = 'bundleName2';
      let item3 = new GridLayoutItemInfo();
      item3.keyName = 'item2.keyName';
      folderItemInLayout.layoutInfo = [[item1, item2]];
      expect(instance).not().assertNull();

      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItemInLayout)
      instance['getItemsInFolder'](folderItemInLayout);

      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.keyName = '123456';
      dockItem.layoutInfo = [[item1, item2]];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dockItem], false);
      folderItemInLayout.layoutInfo = [];
      instance['getItemsInFolder'](folderItemInLayout);

      dockItem.layoutInfo = [];
      instance['getItemsInFolder'](folderItemInLayout);

      instance['getFolderByItem'](folderItemInLayout);
      instance['getFolderItemByFolderId'](folderItemInLayout.folderId);

      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('getFolderItemByFolderId', 0, () => {
      let instance = FolderData.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      let item1 = new GridLayoutItemInfo();
      item1.keyName = 'item1.keyName';
      item1.bundleName = 'bundleName1';
      let item2 = new GridLayoutItemInfo();
      item2.keyName = 'item2.keyName';
      item2.bundleName = 'bundleName2';
      let item3 = new GridLayoutItemInfo();
      item3.keyName = 'item2.keyName';
      folderItemInLayout.layoutInfo = [[item1, item2]];
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.keyName = '123456';
      dockItem.layoutInfo = [[item1, item2]];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dockItem], false);
      instance['getFolderItemByFolderId'](folderItemInLayout.folderId);
      instance['getFolderByItemInDock'](folderItemInLayout);
      expect(instance).not().assertNull();
    })

    it('test_getItemsInFolder_001', 0, () => {
      let instance = FolderData.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      let item1 = new GridLayoutItemInfo();
      item1.keyName = 'item1.keyName';
      item1.bundleName = 'bundleName1';
      let item2 = new GridLayoutItemInfo();
      item2.keyName = 'item2.keyName';
      item2.bundleName = 'bundleName2';
      folderItemInLayout.layoutInfo = [[item1, item2]];
      let currentOpenedFolder: GridLayoutItemInfo | undefined = ObjectCopyUtil.deepClone(instance['openedFolder']);
      instance['openedFolder'] = folderItemInLayout;
      let gridItems: GridLayoutItemInfo[] = instance.getItemsInFolder(folderItemInLayout);
      expect(gridItems.length >= 2).assertTrue();
      instance['openedFolder'] = currentOpenedFolder;
    })

    it('test_getFolderDataAppListInDock_001_27', 0, () => {
      try {
        let instance = FolderData.getInstance();
        let currentOpenedFolder: GridLayoutItemInfo | undefined = ObjectCopyUtil.deepClone(instance['openedFolder']);
        let folderItemInLayout1: GridLayoutItemInfo = instance.getOpenedFolder();
        folderItemInLayout1.folderId = '123456333999';
        folderItemInLayout1.column = 1;
        folderItemInLayout1.row = 2;
        instance['openedFolder'] = folderItemInLayout1;
        let dockItemInfos: DockItemInfo[] = [];
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItem.keyName = folderItemInLayout1.folderId;
        let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
        item4.keyName = 'item1.keyName';
        item4.bundleName = 'bundleName1';
        dockItem.layoutInfo = [[item4]];
        dockItemInfos.push(dockItem);
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', dockItemInfos, false);
        let gridItems1: GridLayoutItemInfo[] = instance.getItemsInFolder(folderItemInLayout1);
        expect(gridItems1).not().assertUndefined();
        expect(gridItems1.length > 0).assertTrue();
        instance['openedFolder'] = currentOpenedFolder;
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFolderItemByFolderId_001', 0, () => {
      let instance = FolderData.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = instance.getOpenedFolder();
      folderItemInLayout.folderId = '123456';
      folderItemInLayout.column = 2;
      folderItemInLayout.row = 2;
      let item1 = new GridLayoutItemInfo();
      item1.keyName = 'item1.keyName';
      item1.bundleName = 'bundleName1';
      let item2 = new GridLayoutItemInfo();
      item2.keyName = 'item2.keyName';
      item2.bundleName = 'bundleName2';
      let item3 = new GridLayoutItemInfo();
      item3.keyName = 'item2.keyName';
      folderItemInLayout.layoutInfo = [[item1, item2]];
      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc1: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderItemInLayout);
      let folderItem = instance.getFolderItemByFolderId('fasdfads33');
      expect(instance).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('test_close_001', 0, () => {
      let instance = FolderData.getInstance();
      let record: GridLayoutItemInfo | undefined = ObjectCopyUtil.deepClone(instance['closingFolder']);
      let openItem: GridLayoutItemInfo = instance.getOpenedFolder();
      instance['closingFolder'] = openItem;
      instance.closed('testClosed');
      expect(!instance['closingFolder']).assertFalse();
      instance['closingFolder'] = undefined;
      let recordOpen: GridLayoutItemInfo | undefined = ObjectCopyUtil.deepClone(instance['openedFolder']);
      instance['openedFolder'] = undefined;
      instance.closed('testClosed');
      expect(instance['openedFolder']).assertUndefined();
      instance['closingFolder'] = record;
      instance['openedFolder'] = recordOpen;
    })

    it('test_getOpenFolderAppAnimateCount_001', 0, () => {
      let instance = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getOpenedFolder);
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.layoutInfo = [];
      when(mockFunc1)().afterReturn(folderItem);
      let count: number = instance.getOpenFolderAppAnimateCount();
      expect(count).assertEqual(12);
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_getOpenFolderAppAnimateCount_002', 0, () => {
      let instance = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getOpenedFolder);
      let folderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let girdItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let girdItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem1.layoutInfo = [[girdItem1, girdItem2]];
      when(mockFunc1)().afterReturn(folderItem1);
      let mockFunc2: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getCountPerPageFolderOpen);
      when(mockFunc2)().afterReturn(3);
      let count1: number = instance.getOpenFolderAppAnimateCount();
      expect(count1).assertEqual(2);
      mocker.clear(instance);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

  })
}
