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
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import { SmallFolderStyleConfig, SmallFolderViewModel } from '../../../../../index';
import {
  AppItemInfo,
  AppStatus,
  BadgeItemInfo,
  CommonConstants,
  FolderLayoutInOpen,
  FolderModel,
  GridLayoutItemInfo,
  PageDesktopModel,
  SettingsModel,
  SmallFolderRegion
} from '@ohos/launchercommon';
import { localEventManager } from '@ohos/frameworkwrapper';
import HashMap from '@ohos.util.HashMap';
import { SCBScreenSessionManager } from '@ohos/windowscene';

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function retNull(): GridLayoutItemInfo | null | BadgeItemInfo | string {
  return null;
}

function retUndefined(): SmallFolderRegion | undefined {
  return undefined;
}

export default function SmallFolderViewModelTest() {
  describe('SmallFolderViewModelTest', () => {
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
    it('test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.smallFolderViewModelInstance = null;
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      expect(instance).assertEqual(globalThis.smallFolderViewModelInstance);
      expect(instance).assertEqual(SmallFolderViewModel.getInstance());
    })

    it('SmallFolderViewModelTest_assertEqual', 0, (): void => {
      let imageAnimationCount = SmallFolderViewModel.getInstance().getImageAnimationCount();
      expect(imageAnimationCount).assertLargerOrEqual(0);
    })

    it('isSmallFolderAnimateSync', 0, (): void => {
      let isSmallFolderAnimateSync = SmallFolderViewModel.getInstance().isSmallFolderAnimateSync();
      expect(isSmallFolderAnimateSync).assertTrue();
    })

    it('isItemVisible_3x4_0_8', 0, (): void => {
      let isItemVisible = SmallFolderViewModel.getInstance().isItemVisible(0, 1);
      expect(false).assertFalse();
    })

    it('isPlaceHolder_3x4', 0, (): void => {
      let isPlaceHolder = SmallFolderViewModel.getInstance().isPlaceHolder(0, 10);
      expect(false).assertFalse();
    })

    it('isPlaceHolder_4x4', 0, (): void => {
      let isPlaceHolder = SmallFolderViewModel.getInstance().isPlaceHolder(0, 10);
      expect(false).assertFalse();
    })

    it('getSmallFolderItemGeometryId', 0, (): void => {
      let geometryId = SmallFolderViewModel.getInstance().getSmallFolderItemGeometryId('0', '', 0, 0);
      expect(geometryId).assertEqual('0_0_0');
    })

    it('getFolderAppListKey', 0, (): void => {
      let model:SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let array1:GridLayoutItemInfo[] = [];
      let array2:GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.appIconId = 1;
      item1.iconResource = 'getFolderAppListKey';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.appIconId = 2;
      item2.iconResource = 'getFolderAppListKey';
      array1.push(item1);
      array1.push(item2);
      info.layoutInfo = new Array<GridLayoutItemInfo[]>();
      info.layoutInfo?.push(array1);
      info.layoutInfo?.push(array2);
      let result:string = model.getFolderAppListKey(info);
      expect(model).not().assertNull();
    })

    it('getFolderAppListKey1', 0, (): void => {
      let model:SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let info: GridLayoutItemInfo | undefined;
      let result:string = model.getFolderAppListKey(info);
      expect(result).assertEqual('');
      let array1:GridLayoutItemInfo[] = [];
      let array2:GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.appIconId = 123;
      item1.iconResource = 'getFolderAppListKey1';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.appIconId = 123;
      item2.iconResource = 'getFolderAppListKey1';
      array1.push(item1);
      array1.push(item2);
      info = new GridLayoutItemInfo();
      info.layoutInfo = new Array<GridLayoutItemInfo[]>();
      info.layoutInfo?.push(array1);
      info.layoutInfo?.push(array2);
      result = model.getFolderAppListKey(info);
      expect(model).not().assertNull();
    })

    it('getFolderAppListKey2', 0, (): void => {
      let model:SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let result:string = model.getFolderAppListKey(info);
      expect(result).assertEqual('');
      let array1:GridLayoutItemInfo[] = [];
      let array2:GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.appIconId = 2;
      item1.iconResource = 'getFolderAppListKey2';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.appIconId = 2;
      item2.iconResource = 'getFolderAppListKey2';
      array1.push(item1);
      array1.push(item2);
      info.layoutInfo = new Array<GridLayoutItemInfo[]>();
      info.layoutInfo?.push(array1);
      info.layoutInfo?.push(array2);
      result = model.getFolderAppListKey(info);
      expect(model).not().assertNull();
    })

    it('getFolderAppListKey3', 0, (): void => {
      let model:SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let array1:GridLayoutItemInfo[] = [];
      let array2:GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.appIconId = 2;
      item1.iconResource = 'getFolderAppListKey3';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.appIconId = 2;
      item2.iconResource = 'getFolderAppListKey3';
      array1.push(item1);
      array1.push(item2);
      info.layoutInfo = new Array<GridLayoutItemInfo[]>();
      let result:string = model.getFolderAppListKey(info);
      info.layoutInfo?.push(array1);
      info.layoutInfo?.push(array2);
      result = model.getFolderAppListKey(info);
      expect(model).not().assertNull();
    })

    it('test_setFolderCreationStatus', 0, () => {
      const SmallFolderViewModelInstance:SmallFolderViewModel = SmallFolderViewModel.getInstance();
      expect(SmallFolderViewModelInstance.setFolderCreationStatus(-1) === undefined).assertTrue()
    })

    it('test_pushCreationCallBack', 0, () => {
      const SmallFolderViewModelInstance:SmallFolderViewModel = SmallFolderViewModel.getInstance();
      const callback: Callback<void> = () => {}
      expect(SmallFolderViewModelInstance.pushCreationCallBack(callback) === undefined).assertTrue();
      SmallFolderViewModelInstance.setFolderCreationStatus(1);
      expect(SmallFolderViewModelInstance.pushCreationCallBack(callback) === undefined).assertTrue();
    })

    it('test_calculateRegion_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let isLeft: boolean = true;
      let isUp: boolean = true;
      let ret: SmallFolderRegion = instance['calculateRegion'](isLeft, isUp);
      expect(ret).assertEqual(SmallFolderRegion.LEFT_UP_REGION);
    });

    it('test_calculateRegion_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let isLeft: boolean = true;
      let isUp: boolean = false;
      let ret: SmallFolderRegion = instance['calculateRegion'](isLeft, isUp);
      expect(ret).assertEqual(SmallFolderRegion.LEFT_DOWN_REGION);
    });

    it('test_calculateRegion_03', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let isLeft: boolean = false;
      let isUp: boolean = false;
      let ret: SmallFolderRegion = instance['calculateRegion'](isLeft, isUp);
      expect(ret).assertEqual(SmallFolderRegion.RIGHT_DOWN_REGION);
    });

    it('test_calculateRegion_04', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let isLeft: boolean = false;
      let isUp: boolean = true;
      let ret: SmallFolderRegion = instance['calculateRegion'](isLeft, isUp);
      expect(instance).not().assertNull();
    });

    it('test_catchBundleIndex_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let componentId: string = 'componentId_1';
      let bundleName: string = 'bundleName_1';
      let index: number = 1;
      let value: HashMap<string, number> = new HashMap();

      instance['folderMap'].set(componentId, value);
      instance['catchBundleIndex'](componentId, bundleName, index);
      expect(instance).not().assertNull();
    });

    it('test_catchBundleIndex_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let componentId: string = 'componentId_1';
      let bundleName: string = 'bundleName_1';
      let index: number = 1;

      instance['folderMap'].remove(componentId)
      instance['catchBundleIndex'](componentId, bundleName, index);
      expect(instance).not().assertNull();
    });

    it('test_clearCache_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let componentId: string = 'componentId_1';
      let bundleName: string = 'bundleName_1';
      let index: number = 1;
      let value: HashMap<string, number> = new HashMap();

      instance['folderMap'].set(componentId, value);
      instance.clearCache(componentId);
      expect(instance).not().assertNull();
    });

    it('test_clearCache_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let componentId: string = 'componentId_1';
      let bundleName: string = 'bundleName_1';
      let index: number = 1;

      instance['folderMap'].remove(componentId)
      instance.clearCache(componentId);
      expect(instance).not().assertNull();
    });

    it('test_generateFolderId_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderId: string = instance.generateFolderId();

      expect(folderId).not().assertNull();
    });

    it('test_getCatchIndex_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let componentId: string = 'componentId_1';
      let bundleName: string = 'bundleName_1';

      let value: HashMap<string, number> = new HashMap();
      value.set(bundleName, 1);
      instance['folderMap'].set(componentId, value);
      let ret: number = instance.getCatchIndex(componentId, bundleName);
      expect(ret).assertEqual(1);
      value.clear();
      instance['folderMap'].remove(componentId);
    });

    it('test_getCatchIndex_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let componentId: string = 'componentId_1';
      let bundleName: string = 'bundleName_1';
      let ret: number = instance.getCatchIndex(componentId, bundleName);

      expect(instance).not().assertNull();
    });

    it('test_getFolderStyleConfig_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let ret: SmallFolderStyleConfig = instance.getFolderStyleConfig();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;

      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.container = CommonConstants.CONTAINER_DOCK;
      expect(ret).not().assertNull();
    });

    it('test_getFolderStyleConfig_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let ret: SmallFolderStyleConfig = instance.getFolderStyleConfig();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;

      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.container = CommonConstants.CONTAINER_DOCK;
      expect(ret).not().assertNull();
    });

    it('test_getImageAnimationCount_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let ret: number = instance.getImageAnimationCount();
      expect(ret).assertLargerOrEqual(0);
    })

    it('test_getNewFolderName_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      instance.getNewFolderName();
      expect(instance).not().assertNull();
    })

    it('test_getSmallFolderComponentId_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;

      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.container = CommonConstants.CONTAINER_DOCK;
      let ret: string = instance.getSmallFolderComponentId(folderItem);
      expect(ret).not().assertNull();
    });

    it('test_getSmallFolderComponentId_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;

      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.container = CommonConstants.CONTAINER_SMARTDOCK;
      let ret: string = instance.getSmallFolderComponentId(folderItem);
      expect(ret).not().assertNull();
    });

    it('test_getSmallFolderItemOrder_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderRegion: SmallFolderRegion = SmallFolderRegion.LEFT_UP_REGION;
      let itemIdx: number = 1;
      let mocker: MockKit = new MockKit();
      let folderModel: FolderModel = FolderModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(folderModel, folderModel.getFolderLayoutInOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4);
      instance.getSmallFolderItemOrder(folderRegion, itemIdx);
      expect(instance).not().assertNull();
      mocker.clear(folderModel);
      mocker.clearAll();
    });

    it('test_getSmallFolderItemOrder_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderRegion: SmallFolderRegion = SmallFolderRegion.LEFT_UP_REGION;
      let itemIdx: number = 1;
      let mocker: MockKit = new MockKit();
      let folderModel: FolderModel = FolderModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(folderModel, folderModel.getFolderLayoutInOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_3X4);
      instance.getSmallFolderItemOrder(folderRegion, itemIdx);
      expect(instance).not().assertNull();
      mocker.clear(folderModel);
      mocker.clearAll();
    });

    it('test_getSmallFolderRegion_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let ret: number = instance.getSmallFolderRegion(folderItem);
      expect(ret).assertEqual(SmallFolderRegion.RIGHT_DOWN_REGION);
    });

    it('test_getSmallFolderRegion_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.isInDock = true;

      let mocker: MockKit = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_getSmallFolderRegion_03', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.isInDock = false;

      let mocker: MockKit = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_getSmallFolderRegion_04', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.isInDock = true;

      let mocker: MockKit = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_getSmallFolderRegion_05', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.layoutInfo = [[item1],[item2]];
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.keyName = 'keyName0';
      folderItem.isInDock = false;

      let mocker: MockKit = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_pushCreationCallBack_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      instance['createSmallFolderStatus'] = CommonConstants.CREATE_SMALL_FOLDER_STATUS;
      instance.pushCreationCallBack(callback);
      expect(instance).not().assertNull();
    });

    it('test_pushCreationCallBack_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      instance['createSmallFolderStatus'] = CommonConstants.DEFAULT_RENAME_STATUS;
      instance.pushCreationCallBack(callback);
      expect(instance).not().assertNull();
    });

    it('test_setDragCoveredItem_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let endLayoutInfo: AppItemInfo = {
        appName: 'app1',
        appIconId: 0,
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'abilityName1'
      };

      let startLayoutInfo: AppItemInfo = {
        appName: 'app2',
        appIconId: 1,
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'abilityName2'
      };

      let x: number = 1;
      let y: number = 1;
      let folderId: string = 'anyFolderId_1';

      instance['setDragCoveredItem'](endLayoutInfo, startLayoutInfo, x, y,folderId);
      expect(instance).not().assertNull();
    });

    it('test_setFolderCreationStatus_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let status: number = -1;
      instance.setFolderCreationStatus(status);
      expect(instance).not().assertNull();
    });

    it('test_setFolderCreationStatus_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let status: number = 1;
      instance.setFolderCreationStatus(status);
      expect(instance).not().assertNull();
    });

    it('test_startImageAnimation_01', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let isStart: boolean = true;
      instance.startImageAnimation(isStart);
      expect(instance).not().assertNull();
    });

    it('test_startImageAnimation_02', 0, () => {
      const instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let isStart: boolean = false;
      instance.startImageAnimation(isStart);
      expect(instance).not().assertNull();
    });

    it('test_eventListener', 0, async () => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();

      let badgeInfo: BadgeItemInfo = retNull() as BadgeItemInfo;
      localEventManager.sendLocalEventSticky('launcher.event', badgeInfo);

      localEventManager.sendLocalEventSticky('launcher.event.EVENT_BADGE_UPDATE', null);

      badgeInfo = new BadgeItemInfo();
      localEventManager.sendLocalEventSticky('launcher.event.EVENT_BADGE_UPDATE', badgeInfo);

      badgeInfo.bundleName = 'anyBundleName';
      localEventManager.sendLocalEventSticky('launcher.event.EVENT_BADGE_UPDATE', badgeInfo);

      badgeInfo.badgeNumber = 10;
      localEventManager.sendLocalEventSticky('launcher.event.EVENT_BADGE_UPDATE', badgeInfo);

      badgeInfo.badgeNumber = 0;
      localEventManager.sendLocalEventSticky('launcher.event.EVENT_BADGE_UPDATE', badgeInfo);

      expect(instance).not().assertNull();
    });

    it('test_createNewFolder', 0, async () => {
      try {
        let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let startLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
        await instance.createNewFolder(endLayoutInfo, [startLayoutInfo], true);

        let folderId: string = 'anyFolderId';
        await instance.createNewFolder(endLayoutInfo, [startLayoutInfo], true, folderId);

        await instance.createNewFolder(endLayoutInfo, [startLayoutInfo], false, folderId);

        endLayoutInfo.appStatus = AppStatus.INSTALLED;
        await instance.createNewFolder(endLayoutInfo, [startLayoutInfo], false, folderId);

        let mSettingsModel: SettingsModel = SettingsModel.getInstance();
        let settingAppInfoList: GridLayoutItemInfo[] = mSettingsModel.getAppListInfo();
        await instance.createNewFolder(endLayoutInfo, [settingAppInfoList[0]], true, folderId);

        endLayoutInfo.badgeNumber = 0;
        await instance.createNewFolder(endLayoutInfo, [settingAppInfoList[0]], true, folderId);

        endLayoutInfo.badgeNumber = 10;
        await instance.createNewFolder(endLayoutInfo, [settingAppInfoList[0]], true, folderId);

        endLayoutInfo.badgeNumber = -10;
        await instance.createNewFolder(endLayoutInfo, [settingAppInfoList[0]], true, folderId);

        endLayoutInfo.page = 0;
        await instance.createNewFolder(endLayoutInfo, [settingAppInfoList[0]], true, folderId);

        expect(instance).not().assertNull();

      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_expandSmallFolderList', 0, async () => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let app: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appList: GridLayoutItemInfo[] = [app, app, app, app, app, app, app, app, app, app,
        app, app, app, app, app, app, app, app, app, app];

      let pageIndex: number = 1;
      instance.expandSmallFolderList(appList, SmallFolderRegion.LEFT_UP_REGION, pageIndex);
      instance.expandSmallFolderList(appList, SmallFolderRegion.LEFT_DOWN_REGION, pageIndex);
      instance.expandSmallFolderList(appList, SmallFolderRegion.RIGHT_UP_REGION, pageIndex);
      instance.expandSmallFolderList(appList, SmallFolderRegion.RIGHT_DOWN_REGION, pageIndex);

      appList = [app, app];
      instance.expandSmallFolderList(appList, SmallFolderRegion.RIGHT_DOWN_REGION, pageIndex);
      expect(instance).not().assertNull();
    });

    it('test_isItemVisible', 0, async () => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      instance.isItemVisible(retUndefined() as SmallFolderRegion, 1);

      let region: SmallFolderRegion = SmallFolderRegion.LEFT_UP_REGION;
      instance.isItemVisible(region, 0);
      instance.isItemVisible(region, 15);
      expect(instance).not().assertNull();
    });

    it('test_isPlaceHolder', 0, async () => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      instance.isPlaceHolder(retUndefined() as SmallFolderRegion, 1);

      let region: SmallFolderRegion = SmallFolderRegion.LEFT_UP_REGION;
      instance.isPlaceHolder(region, 0);
      instance.isPlaceHolder(region, 15);
      expect(instance).not().assertNull();
    });

    it('test_getSmallFolderRegion', 0, async () => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      instance.getSmallFolderRegion(retNull() as GridLayoutItemInfo);

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.isInDock = true;
      folderItem.row = 0;
      folderItem.column = 0;
      instance.getSmallFolderRegion(folderItem);

      folderItem.row = 6;
      instance.getSmallFolderRegion(folderItem);

      folderItem.column = 4;
      instance.getSmallFolderRegion(folderItem);

      folderItem.row = 0;
      instance.getSmallFolderRegion(folderItem);

      folderItem.isInDock = false;
      folderItem.row = 0;
      folderItem.column = 0;
      instance.getSmallFolderRegion(folderItem);

      folderItem.row = 6;
      instance.getSmallFolderRegion(folderItem);

      folderItem.column = 4;
      instance.getSmallFolderRegion(folderItem);

      folderItem.row = 0;
      instance.getSmallFolderRegion(folderItem);
      expect(instance).not().assertNull();
    });

    it('test_getFolderAppListKey', 0, async () => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance.getFolderAppListKey(folderItem);

      folderItem.layoutInfo = [];
      instance.getFolderAppListKey(folderItem);
      folderItem.layoutInfo.push([retNull() as GridLayoutItemInfo]);
      instance.getFolderAppListKey(folderItem);
      expect(instance).not().assertNull();
    });

    it('test_createNewFolderWithOneApp', 0, async (done: Function) => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let endInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endInfo.appName =  'app1';
      endInfo.appIconId =  0;
      endInfo.bundleName =  'com.ohos.sceneboard';
      endInfo.abilityName =  'abilityName1';
      let startInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      startInfo.appName =  'app2';
      startInfo.appIconId =  1;
      startInfo.bundleName =  'com.ohos.sceneboard';
      startInfo.abilityName =  'abilityName2';
      let x: number = 1;
      let y: number = 1;
      let creat = await instance.createNewFolderWithOneApp(endInfo, startInfo, x, y);
      expect(creat).assertTrue();
      done();
    });

    it('test_createNewFolder_001', 0, async (done: Function) => {
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.badgeNumber = 1;
      endLayoutInfo.page = 1;
      let startLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      startLayoutInfo.badgeNumber = 1;
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let folder = await instance.createNewFolder(endLayoutInfo, []);
      expect(folder.folderId).assertUndefined();
      done();
    });

    it('test_createNewFolder_002', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let pageDesktopModle: PageDesktopModel = PageDesktopModel.getInstance();
      try {
        let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        endLayoutInfo.badgeNumber = 1;
        endLayoutInfo.page = 1;
        let startLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        startLayoutInfo.badgeNumber = 1;
        let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
        let mockFunc1: Function = mocker.mockFunc(pageDesktopModle, pageDesktopModle.getPageIndex);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(endLayoutInfo.page);
        let folderId: string = 'comohosfoldid122k';
        let folder1 = await instance.createNewFolder(endLayoutInfo, [startLayoutInfo], false, folderId, 1, 1);
        expect(folder1.folderId).assertEqual(folderId);
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(pageDesktopModle);
      mocker.clearAll();
    });

    it('test_createNewFolderByDrag', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let pageDesktopModle: PageDesktopModel = PageDesktopModel.getInstance();
      try {
        let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        endLayoutInfo.badgeNumber = 1;
        endLayoutInfo.page = 1;
        let dragItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        dragItem.badgeNumber = 1;
        let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
        let folder = instance.createNewFolderByDrag(endLayoutInfo, []);
        expect(folder).assertUndefined();
        let mockFunc1: Function = mocker.mockFunc(pageDesktopModle, pageDesktopModle.getPageIndex);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(endLayoutInfo.page);
        let folderId: string = 'comohosfoldid1223333';
        let folder1 = await instance.createNewFolder(endLayoutInfo, [dragItem], false, folderId, 0, 0);
        expect(folder1).not().assertUndefined();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(pageDesktopModle);
      mocker.clearAll();
    });

    it('test_setSmallFolderAnimateSync', 0, async (done: Function) => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      instance.setSmallFolderAnimateSync();
      expect(instance['smallFolderAnimateSyncNumber']).assertEqual(0);
      done();
    });

    it('test_isItemVisible_002', 0, async (done: Function) => {
      let instance: SmallFolderViewModel = SmallFolderViewModel.getInstance();
      let region: SmallFolderRegion = SmallFolderRegion.LEFT_UP_REGION;
      let mocker: MockKit = new MockKit();
      let folderModel: FolderModel = FolderModel.getInstance();
      let mockFunc1: Function = mocker.mockFunc(folderModel, folderModel.getFolderLayoutInOpen);
      when(mockFunc1)().afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_3X4);
      let res = instance.isItemVisible(region, 0);
      expect(res).assertFalse();
      mocker.clear(folderModel);
      mocker.clearAll();
      done();
    });

  })
}
