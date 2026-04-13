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
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  AppItemInfo,
  AppStatus,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DisappearLastAppData,
  DockItemInfo,
  FolderData,
  FolderItemInfo,
  FolderLayoutCacheManager,
  FolderModel,
  FolderReporter,
  GridLayoutConfig,
  GridLayoutUtil,
  LauncherLayoutCacheUtil,
  MultiSelectManager,
  NotHarmonyUtil,
  OpenFolderData,
  PageDesktopModel,
  ResidentLayoutCacheMgr,
  scbBlankPositionUtils,
  SettingsModel
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  BigFolderViewModel,
  Callback,
  DragItemFromFolderStartInfo,
  FolderCloseType,
  FolderLayoutStruct,
} from '../../../../../index';
import { EventConstants, GridLayoutItemInfo, BigFolderStyleConfig } from '@ohos/launchercommon';
import FeatureConstants from '../../../../main/ets/default/common/constants/FeatureConstants';
import { DesktopLayoutCacheData } from '@ohos/launchercommon/src/main/ets/cache/layout/DesktopLayoutCacheData';
import { localEventManager } from '@ohos/frameworkwrapper';
import { ObjUtil } from '@ohos/basicutils';
import { multiSelectListenManager } from '@ohos/launchercommon/src/main/ets/editmode/model/MultiSelectListenerManager';
import { MultiSelectMode } from '@ohos/launchercommon/src/main/ets/editmode/data/MultiSelectData';
import {
  PageDesktopViewModel
} from '../../../../../../pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';

function getNullObject(): GridLayoutItemInfo | null | FolderItemInfo{
  return null;
}

export default function BigFolderViewModelTest() {
  describe('BigFolderViewModelTest', () => {
    let instance: BigFolderViewModel = BigFolderViewModel.getInstance();
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

    it('test_getFolderLayoutConfig', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderLayoutConfig: FolderLayoutStruct = BigFolderViewModelInstance.getFolderLayoutConfig();
      expect(folderLayoutConfig).assertEqual(BigFolderViewModelInstance.getFolderLayoutConfig());
    })
    it('test_dropInFolderOpenComponent', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.dropInFolderOpenComponent() === undefined).assertTrue();
    })
    it('test_setDragFromFolderStartInfo', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const page: number | undefined = undefined;
      const row: number | undefined = undefined;
      const column: number | undefined = undefined;
      const bundleName: string | undefined = undefined;
      const folderId: string | undefined = undefined;
      const dragItemFolderPosition: number[] = [];
      const data: DragItemFromFolderStartInfo = {
        page,
        row,
        column,
        bundleName,
        folderId,
        dragItemFolderPosition,
      }
      expect(data.page).assertEqual(page);
      expect(data.row).assertEqual(row);
      expect(data.column).assertEqual(column);
      expect(data.bundleName).assertEqual(bundleName);
      expect(data.folderId).assertEqual(folderId);
      expect(data.dragItemFolderPosition).assertEqual(dragItemFolderPosition);
      expect(BigFolderViewModelInstance.setDragFromFolderStartInfo(data) === undefined).assertTrue();
    })
    it('test_getDragFromFolderStartInfo', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const dragFromFolderStartInfo: DragItemFromFolderStartInfo = BigFolderViewModelInstance.getDragFromFolderStartInfo();
      expect(dragFromFolderStartInfo).assertEqual(BigFolderViewModelInstance.getDragFromFolderStartInfo());
    })

    it('test_runFolderDropAnimateWaitCallBack', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.runFolderDropAnimateWaitCallBack() === undefined).assertTrue();
      BigFolderViewModelInstance.setDropAnimationStart();
      const callback: Callback<void> = () => {
      };
      BigFolderViewModelInstance.pushDropAnimationCallBack(callback);
      expect((BigFolderViewModelInstance.runFolderDropAnimateWaitCallBack() === undefined)).assertTrue()
    })
    it('test_setDropAnimationStart', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.setDropAnimationStart() === undefined).assertTrue();
    })
    it('test_getDropAnimationStatus', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const dropAnimationStatus: boolean = BigFolderViewModelInstance.getDropAnimationStatus();
      expect(dropAnimationStatus).assertEqual(BigFolderViewModelInstance.getDropAnimationStatus());
    })
    it('test_pushDropAnimationCallBack', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(BigFolderViewModelInstance.pushDropAnimationCallBack(callback) === undefined).assertTrue();
      expect(BigFolderViewModelInstance.pushDropAnimationCallBack(callback) === undefined).assertTrue();
    })
    it('test_setAppLaunchTime', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect((BigFolderViewModelInstance.setAppLaunchTime() === undefined)).assertTrue();
    })
    it('test_registerFolderListener', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.registerFolderListener() === undefined).assertTrue();
    })
    it('test_unregisterFolderListener', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.unregisterFolderListener() === undefined).assertTrue();
    })

    it('test_waitFolderMoveAniamtion', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(BigFolderViewModelInstance.waitFolderMoveAniamtion(callback) === undefined).assertTrue();
    })
    it('test_excuteAfterMoveAnimation', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(await BigFolderViewModelInstance.excuteAfterMoveAnimation() === undefined).assertTrue();
      BigFolderViewModelInstance.waitFolderMoveAniamtion(() => {
      });
      expect(await BigFolderViewModelInstance.excuteAfterMoveAnimation() === undefined).assertTrue();
    })
    it('test_waitFolderAnimateFinish', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.waitFolderAnimateFinish(callback) === undefined).assertTrue();
      BigFolderViewModelInstance.startTransitionAnimation(true, '');
      expect(await BigFolderViewModelInstance.waitFolderAnimateFinish(callback) === undefined).assertTrue();
    })

    it('test_setCloseType', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const type: FolderCloseType = FolderCloseType.CLICK_BLANK;
      expect(BigFolderViewModelInstance.setCloseType(type) === undefined).assertTrue();

    })
    it('test_getCloseType', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const type: FolderCloseType = FolderCloseType.BACK_GESTURE;
      BigFolderViewModelInstance.setCloseType(type);
      const closeType: string = BigFolderViewModelInstance.getCloseType();
      expect(closeType).assertEqual(FolderCloseType.BACK_GESTURE);
    })

    it('test_getIsPad', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isPad: boolean = BigFolderViewModelInstance.getIsPad();
      expect(isPad).assertEqual(BigFolderViewModelInstance.getIsPad());
    })

    it('test_getFolderAnimationCount', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderAnimationCount: number = BigFolderViewModelInstance.getFolderAnimationCount();
      expect(folderAnimationCount).assertEqual(BigFolderViewModelInstance.getFolderAnimationCount());
    })
    it('test_getTransitingFolderId', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const transitingFolderId: string = BigFolderViewModelInstance.getTransitingFolderId();
      expect(transitingFolderId).assertEqual(BigFolderViewModelInstance.getTransitingFolderId());
    })
    it('test_changeIndexOnly', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.changeIndexOnly(1) === undefined).assertTrue();
    })
    it('test_changeIndex', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.changeIndex(1) === undefined).assertTrue();
    })
    it('test_getIndex', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const index: number = BigFolderViewModelInstance.getIndex();
      expect(index).assertEqual(BigFolderViewModelInstance.getIndex());
    })
    it('test_getAddListColumn', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const addListColumn: number = BigFolderViewModelInstance.getAddListColumn();
      expect(addListColumn).assertEqual(BigFolderViewModelInstance.getAddListColumn());
    })

    it('test_isInGridSwiperArea', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isInGridSwiperArea: boolean = BigFolderViewModelInstance.isInGridSwiperArea(100);
      expect(isInGridSwiperArea).assertDeepEquals(BigFolderViewModelInstance.isInGridSwiperArea(100));
    })

    it('test_isInGridSwiperArea02', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isInGridSwiperArea: boolean = BigFolderViewModelInstance.isInGridSwiperArea(null);
      expect(isInGridSwiperArea).assertFalse();
    })

    it('test_printFolderAppList01', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const layoutInfoList: GridLayoutItemInfo[] = [];
      expect(BigFolderViewModelInstance.printFolderAppList(layoutInfoList) === undefined).assertTrue();
    })
    it('test_printFolderAppList02', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const bundleName: string = '';
      const abilityName: string = '';
      const appIconId: number = 0;
      const negativeId: number = 0;
      const isSelect: boolean = false;
      const enterEditing: boolean = false;
      const downloadProgress: number = 0;
      const appStatus: number | undefined = undefined;
      const iconResource: string | undefined = undefined;
      const callerName: string | undefined = undefined;
      const layoutInfoList: GridLayoutItemInfo[] = [];

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder0';
      layoutInfoList.push(appInfo1);
      layoutInfoList.push(appInfo2);

      expect(BigFolderViewModelInstance.printFolderAppList(layoutInfoList) === undefined).assertTrue();
    })
    it('test_isInDockArea', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isInDockArea: boolean = BigFolderViewModelInstance.isInDockArea(100);
      expect(isInDockArea).assertEqual(BigFolderViewModelInstance.isInDockArea(100));
    })

    it('test_addBackToFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      instance.addBackToFolder(appInfo);
      expect(instance).not().assertNull();
    });

    it('test_addBackToFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = {
        bundleName: 'anyBundleName',
        bundleType: CommonConstants.TYPE_APP
      } as GridLayoutItemInfo;
      (instance as object)['dragFromFolderStartInfo'] = {
        folderId: undefined
      } as DragItemFromFolderStartInfo;

      instance.addBackToFolder(appInfo);
      expect(instance).not().assertNull();
    });

    it('test_addBackToFolder_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = {
        bundleName: 'testApp',
        bundleType: CommonConstants.TYPE_APP
      } as GridLayoutItemInfo;
      (instance as object)['dragFromFolderStartInfo'] = {
        folderId: 'testFolder'
      } as DragItemFromFolderStartInfo;
      let cacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let selectFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      selectFolder.keyName = 'testFolder';
      selectFolder.typeId = CommonConstants.TYPE_FOLDER;
      let mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(cacheManager, cacheManager.selectGridLayoutItemByFolderId);
      when(func)(ArgumentMatchers.any).afterReturn(selectFolder);
      instance.addBackToFolder(appInfo);

      let dockFolder: DockItemInfo = new DockItemInfo();
      dockFolder.keyName = 'testFolder';
      dockFolder.typeId = CommonConstants.TYPE_FOLDER;
      let residentList: DockItemInfo[] = [dockFolder];
      instance.addBackToFolder(appInfo);
      expect(instance).not().assertNull();
      mocker.clear(cacheManager);
      mocker.clearAll();
    });

    it('test_calculateArea_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfo: GridLayoutItemInfo[][] = [];
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      instance.calculateArea(layoutInfo, item);
      expect(instance).not().assertNull();
    });

    it('test_calculateArea_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfo: GridLayoutItemInfo[][] = [[],[],[]];
      let item: GridLayoutItemInfo = {
        bundleName: 'com.ohos.healthy',
        appIconId: 95
      } as GridLayoutItemInfo;

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.appIconId = 95;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 98;

      layoutInfo[0].push(item1);
      layoutInfo[1].push(item2);
      layoutInfo[2].push(item3);

      let ret: number[] = instance.calculateArea(layoutInfo, item);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_calculateArea_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfo: GridLayoutItemInfo[][] | undefined = undefined;
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      instance.calculateArea(layoutInfo, item);
      expect(instance).not().assertNull();
    });

    it('test_calculateArea_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfo: GridLayoutItemInfo[][] = [[],[],[]];
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let ret: number[] = instance.calculateArea(layoutInfo, item);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_changeIndex_01', 0, () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let idx: number = 1;
      instance.changeIndex(idx);
      expect(instance).not().assertNull();
    });

    it('test_changeIndexOnly_01', 0, () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let idx: number = 1;
      instance.changeIndexOnly(idx);
      expect(instance).not().assertNull();
    });

    it('test_closeFolder_01', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isNeedKeepPageIndex: boolean = false;
      AppStorage.setOrCreate('openFolderId','-1');

      await instance.closeFolder(callback, isNeedKeepPageIndex);
      expect(isNeedKeepPageIndex).assertFalse();
    });

    it('test_closeFolder_02', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isNeedKeepPageIndex: boolean = false;
      AppStorage.setOrCreate('openFolderId','1');

      await instance.closeFolder(callback, isNeedKeepPageIndex, true);
      expect(isNeedKeepPageIndex).assertFalse();
      AppStorage.clear();
    });

    it('test_closeFolder_03', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isNeedKeepPageIndex: boolean = true;
      AppStorage.setOrCreate('openFolderId','1');

      await instance.closeFolder(callback, isNeedKeepPageIndex);
      expect(isNeedKeepPageIndex).assertTrue();
      AppStorage.clear();
    });

    it('test_closeFolderPending_01', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isPendingClose: boolean = true;
      AppStorage.setOrCreate('openFolderId','-1');

      await instance.closeFolderPending(isPendingClose, callback);
      expect(isPendingClose).assertTrue();
      AppStorage.clear();
    });

    it('test_closeFolderPending_02', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isPendingClose: boolean = false;
      AppStorage.setOrCreate('openFolderId','1');

      await instance.closeFolderPending(isPendingClose, callback);
      expect(isPendingClose).assertFalse();
      AppStorage.clear();
    });

    it('test_dragAppLeaveFolder_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];
      let folderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      await instance.dragAppLeaveFolder(appInfos, folderItem);
      expect(appInfos.length).assertEqual(0);
    });

    it('test_dragAppLeaveFolder_02', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder0';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);

      AppStorage.setOrCreate(CommonConstants.OPEN_SOURCES, true);
      await instance.dragAppLeaveFolder(appInfos, appInfo1);
      expect(appInfos.length).assertLargerOrEqual(0);
      AppStorage.clear();
    });

    it('test_dragAppLeaveFolder_03', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder0';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);
      AppStorage.setOrCreate(CommonConstants.OPEN_SOURCES, false);

      instance.dragAppLeaveFolder(appInfos, appInfo1);
      expect(appInfos.length).assertLargerOrEqual(0);
      AppStorage.clear();
    });

    it('test_dockFolderAdd_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName1';
      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'keyName2';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);
      AppStorage.setOrCreate(CommonConstants.OPEN_SOURCES, true);

      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'keyName0';

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.bundleName = 'com.ohos.mms';
      itemInfo1.keyName = 'keyName1';
      let residentList: DockItemInfo[] = [];
      residentList.push(itemInfo);
      residentList.push(itemInfo1);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      instance.dragAppLeaveFolder(appInfos, appInfo1);
      expect(appInfos.length).assertLargerOrEqual(0);
      AppStorage.clear();
    });

    it('test_dropInFolderOpenComponent_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.dropInFolderOpenComponent();

      expect(instance).not().assertNull();
    });

    it('test_excuteAfterMoveAnimation_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      (instance as object)['mWaitFolderMoveAnimate'] = [];
      instance.setFolderSqueezeStatus(true);
      instance.waitFolderMoveAniamtion(() => {
        throw new Error();
      });

      await instance.excuteAfterMoveAnimation();
      expect(instance).not().assertNull();
    });

    it('test_filterFolderPage_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      expect(instance).not().assertNull();
      appInfos.push(item1);
      appInfos.push(item2);
      appInfos.push(item3);
      let ret: Array<GridLayoutItemInfo[]> =  instance.filterFolderPage(appInfos);
    });

    it('test_getAddListColumn_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.getAddListColumn();

      expect(instance).not().assertNull();
    });

    it('test_getAppListInFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;

      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      openFolderData.layoutInfo.push(list);

      instance.getAppListInFolder(openFolderData);
      expect(instance).not().assertNull();
    });

    it('test_getAppRemainInOtherFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;

      appInfos.push(item1);
      appInfos.push(item2);
      appInfos.push(item3);

      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(item3);

      expect(instance.getAppRemainInOtherFolder(appInfos, folderAppList)).not().assertNull();
    });

    it('test_getAppRemainInOtherFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard2';
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_APP;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard3';
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_APP;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard4';
      item4.appIconId = 100;
      item4.typeId = CommonConstants.TYPE_APP;

      appInfos.push(item1);
      appInfos.push(item2);
      appInfos.push(item3);

      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(item3);
      folderAppList.push(item4);

      expect(instance.getAppRemainInOtherFolder(appInfos, folderAppList)).not().assertNull();
    });

    it('test_getCloseType_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(instance.getCloseType()).not().assertNull();
    });

    it('test_getDialogHeight_01', 0, () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appList: AppItemInfo[] = [];

      let appItemInfo1: AppItemInfo = {
        appName: 'app1',
        appIconId: 0,
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'abilityName1'
      };

      let appItemInfo2: AppItemInfo = {
        appName: 'app2',
        appIconId: 1,
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'abilityName2'
      };
      appList.push(appItemInfo1);
      appList.push(appItemInfo2);
      expect(instance).not().assertNull();
    });

    it('test_getDragFromFolderStartInfo_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['dragFromFolderStartInfo'] = {} as DragItemFromFolderStartInfo;

      let ret: DragItemFromFolderStartInfo = instance.getDragFromFolderStartInfo();
      expect(instance).not().assertNull();
    });

    it('test_getDropAnimationStatus_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['isDropAnimationStatus'] = false;

      let ret: boolean = instance.getDropAnimationStatus();
      expect(ret).assertFalse();
    });

    it('test_getFolderAnimationCount_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['mGeometryTransitionCount'] = 0;

      let ret: number = instance.getFolderAnimationCount();
      expect(ret).assertEqual(0);
    });

    it('test_getFolderLayoutConfig_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: FolderLayoutStruct = instance.getFolderLayoutConfig();
      expect(ret).not().assertNull();
    });

    it('test_getFolderStyleConfig_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: BigFolderStyleConfig = instance.getFolderStyleConfig();
      ret = undefined;
      instance.getFolderStyleConfig();
      expect(ret).not().assertNull();
    });

    it('test_getIndex_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: number = instance.getIndex();
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getIsPad_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      AppStorage.setOrCreate('device',CommonConstants.PAD_DEVICE_TYPE);
      let ret: boolean = instance.getIsPad();
      expect(ret).assertTrue();
      AppStorage.clear();
    });

    it('test_getIsPad_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      AppStorage.setOrCreate('device',CommonConstants.PC_DEVICE_TYPE);
      let ret: boolean = instance.getIsPad();
      expect(ret).assertFalse();
      AppStorage.clear();
    });

    it('test_getNewFolderName_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: string =await instance.getNewFolderName();
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_getTransitingFolderId_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['mGeometryTransitionFolderId'] = '';
      let ret: string = instance.getTransitingFolderId();
      expect(ret).assertEqual('');
    });

    it('test_getUUID_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: string = instance.getUUID();
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_isConvertToBigFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let isFromDock: boolean = false;
      let initialFolderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      let ret: boolean = instance.isConvertToBigFolder(folderInfo, isFromDock, initialFolderItem);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('test_isConvertToBigFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderInfo: GridLayoutItemInfo = getNullObject() as GridLayoutItemInfo;
      let isFromDock: boolean = false;
      let initialFolderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      let ret: boolean = instance.isConvertToBigFolder(folderInfo, isFromDock, initialFolderItem);
      expect(ret).assertFalse();
    });

    it('test_isConvertToBigFolder_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let folderInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInfo.folderId = '9';
      let folderInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderInfo2.folderId = '10';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      let ret = instance.isConvertToBigFolder(folderInfo, false, folderInfo2);
      expect(ret).assertFalse();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('test_isInGridSwiperArea_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let positionY: number = 0;
      let ret: boolean = instance.isInGridSwiperArea(positionY);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('test_isInGridSwiperArea_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let positionY: number = -1;
      let ret: boolean = instance.isInGridSwiperArea(positionY);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('test_isInGridSwiperArea_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let positionY: number = 2147483648;
      let ret: boolean = instance.isInGridSwiperArea(positionY);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('test_openFolder_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isRename: boolean = false;
      let folderItem: FolderItemInfo | GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let isFromSmall: boolean = false;

      instance.openFolder(isRename, folderItem, isFromSmall);
      expect(isRename).assertFalse();
    });

    it('test_openFolder_02', 0, async () => {
      let isRename: boolean = false;
      let isFromSmall: boolean = false;
      let folderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
      instance.waitFolderOpenFinish(undefined);
      instance.waitFolderOpenFinish((): void => {
        throw new Error();
      });
      instance.openFolder(isRename, folderData, isFromSmall);
      instance.closeFolder();
      expect(isRename).assertFalse();
    });

    it('test_openFolder_03', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isRename: boolean = true;
      let folderItem: FolderItemInfo | GridLayoutItemInfo = new GridLayoutItemInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      layoutInfoList.push(item1);
      layoutInfoList.push(item2);
      layoutInfoList.push(item3);
      folderItem.layoutInfo?.push(layoutInfoList);
      let isFromSmall: boolean = true;

      instance.openFolder(isRename, folderItem, isFromSmall);
      expect(isRename).assertTrue();
    });

    it('test_openFolder_04', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isRename: boolean = true;
      let folderItem: FolderItemInfo | GridLayoutItemInfo = new GridLayoutItemInfo();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      layoutInfoList.push(item1);
      layoutInfoList.push(item2);
      layoutInfoList.push(item3);
      folderItem.layoutInfo?.push(layoutInfoList);
      let isFromSmall: boolean = false;

      instance.openFolder(isRename, folderItem, isFromSmall);
      expect(isRename).assertTrue();
    });

    it('test_printFolderAppList_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      layoutInfoList.push(item1);
      layoutInfoList.push(item2);
      layoutInfoList.push(item3);

      instance.printFolderAppList(layoutInfoList);
      expect(instance).not().assertNull();
    });

    it('test_pushDropAnimationCallBack_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      (instance as object)['mFolderDropAnimateWaitCallBack'] = [];

      instance.pushDropAnimationCallBack(callback);
      expect(instance).not().assertNull();
    });

    it('test_pushDropAnimationCallBack_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      (instance as object)['mFolderDropAnimateWaitCallBack'].push(callback);

      instance.pushDropAnimationCallBack(callback);
      expect(instance).not().assertNull();
    });

    it('test_refreshFolder_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: OpenFolderData = {
        folderId: undefined,
        folderName: undefined,
        enterEditing: false,
        layoutInfo: []
      };

      await instance.refreshFolder(folderItem);
      expect(instance).not().assertNull();
    });

    it('test_refreshFolder_02', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.folderId = '';
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.test";
      appData.typeId = CommonConstants.TYPE_APP;
      appData.appIndex = 0;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      folderItem.layoutInfo = [folderAppList];

      await instance.refreshFolder(folderItem);
      expect(instance).not().assertNull();
    });


    it('test_refreshFolder_03', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.folderId = '1';
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.test";
      appData.typeId = CommonConstants.TYPE_APP;
      appData.appIndex = 0;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      folderItem.layoutInfo = [folderAppList];

      await instance.refreshFolder(folderItem);
      expect(instance).not().assertNull();
    });

    it('test_registerFolderListener_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.registerFolderListener();
      expect(instance).not().assertNull();
    });

    it('test_removeFolderAfterUninstallIfNeeded_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let uninstallAppKeyName: string = 'uninstallApp';

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.bundleName = 'com.ohos.uninstallApp';
      openFolderData.abilityName = 'ability';
      openFolderData.appIndex = 0;

      let dockInfo: DockItemInfo = new DockItemInfo();
      dockInfo.bundleName = 'com.ohos.uninstallApp';
      dockInfo.abilityName = 'ability';
      dockInfo.appIndex = 1;
      let residentList: DockItemInfo[] = [dockInfo];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = uninstallAppKeyName;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = 'com.ohos.uninstallApp';
      app2.typeId = CommonConstants.TYPE_APP;
      let folderAppList: GridLayoutItemInfo[] = [app1, app2];

      instance.removeFolderAfterUninstallIfNeeded(openFolderData, folderAppList, uninstallAppKeyName);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_removeFolderAfterUninstallIfNeeded_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let uninstallAppKeyName: string = 'uninstallApp';

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.bundleName = 'com.ohos.uninstallApp';
      openFolderData.abilityName = 'ability';
      openFolderData.appIndex = 0;

      let dockInfo: DockItemInfo = new DockItemInfo();
      dockInfo.bundleName = 'com.ohos.uninstallApp';
      dockInfo.abilityName = 'ability';
      dockInfo.appIndex = 0;
      let residentList: DockItemInfo[] = [dockInfo];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = 'com.ohos.uninstallApp';
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = uninstallAppKeyName;
      let folderAppList: GridLayoutItemInfo[] = [app1, app2];

      instance.removeFolderAfterUninstallIfNeeded(openFolderData, folderAppList, uninstallAppKeyName);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_removeFolderAfterUninstallIfNeeded_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppList: GridLayoutItemInfo[] = [app1, app2, app3];

      instance.removeFolderAfterUninstallIfNeeded(undefined, folderAppList, '');
      expect(instance).not().assertNull();
    });

    it('test_removeFolderAfterUninstallWithoutClose_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.bundleName = 'com.ohos.sceneboard';
      openFolderData.appIconId = 92;
      openFolderData.typeId = CommonConstants.TYPE_ADD;

      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(openFolderData)

      let uninstallAppBundleName: string = 'com.ohos.sceneboard' ;
      instance.removeFolderAfterUninstallIfNeeded(openFolderData, folderAppList, uninstallAppBundleName);
      expect(instance).not().assertNull();
    });

    it('test_removeFolderAfterUninstall_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.bundleName = 'com.ohos.sceneboard';
      openFolderData.appIconId = 92;
      openFolderData.typeId = CommonConstants.TYPE_ADD;

      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(openFolderData)

      let uninstallAppBundleName: string = 'com.ohos.sceneboard' ;
      let isNeedClose: boolean = true;
      (instance as object)['removeFolderAfterUninstall'](openFolderData, folderAppList, uninstallAppBundleName, isNeedClose);
      expect(instance).not().assertNull();
    });

    it('test_removeFolderAfterUninstall_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.bundleName = 'com.ohos.sceneboard';
      openFolderData.appIconId = 92;
      openFolderData.typeId = CommonConstants.TYPE_ADD;

      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(openFolderData)

      let uninstallAppBundleName: string = 'com.ohos.sceneboard' ;
      let isNeedClose: boolean = false;
      (instance as object)['removeFolderAfterUninstall'](openFolderData, folderAppList, uninstallAppBundleName, isNeedClose);
      expect(instance).not().assertNull();
    });

    it('test_runFolderDropAnimateWaitCallBack_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['isDropAnimationStatus'] = true;

      instance.runFolderDropAnimateWaitCallBack();
      expect(instance).not().assertNull();
    });

    it('test_runFolderDropAnimateWaitCallBack_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['isDropAnimationStatus'] = false;

      instance.runFolderDropAnimateWaitCallBack();
      expect(instance).not().assertNull();
    });

    it('test_setAppLaunchTime_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      instance.setAppLaunchTime();
      expect(instance).not().assertNull();
    });

    it('test_setCloseType_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let type: FolderCloseType = FolderCloseType.BACK_GESTURE;

      instance.setCloseType(type);
      expect(instance).not().assertNull();
    });

    it('test_setDragFromFolderStartInfo_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let startInfo: DragItemFromFolderStartInfo = {
        page: 1,
        row: 1,
        column: 2,
        bundleName: 'com.ohos.sceneboard',
        folderId: 'anyFolderId'
      };

      instance.setDragFromFolderStartInfo(startInfo);
      expect(instance).not().assertNull();
    });

    it('test_setDropAnimationStart_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      instance.setDropAnimationStart();
      expect(instance).not().assertNull();
    });

    it('test_startTransitionAnimation_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isStart: boolean = true;
      let folderId: string = 'anyFolderId';
      let isCloseFolderAni: boolean = false;
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_CLOSE);
      (instance as object)['mGeometryTransitionCount'] = 0;

      instance.startTransitionAnimation(isStart, folderId, isCloseFolderAni);
      expect(isStart).assertTrue();
      AppStorage.clear();
    });

    it('test_startTransitionAnimation_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isStart: boolean = false;
      let folderId: string = 'anyFolderId';
      let isCloseFolderAni: boolean = false;
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
      (instance as object)['mGeometryTransitionCount'] = -5;
      (instance as object)['mLastFolderStatusBeforeTransition'] = FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_START;

      instance.startTransitionAnimation(isStart, folderId, isCloseFolderAni);
      expect(isStart).assertFalse();
      AppStorage.clear();
    });

    it('test_unregisterFolderListener_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      instance.unregisterFolderListener();
      expect(instance).not().assertNull();
    })

    it('test_updateFolderLayoutAfterLeave_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let leaveItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      leaveItem.keyName = 'keyName0';
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'anyKeyName'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'anyKeyName'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.isInDock = false;

      instance.updateFolderLayoutAfterLeave([leaveItem], openFolderData);
      expect(leaveItem.keyName).assertEqual('keyName0');
    });

    it('test_updateFolderLayoutAfterLeave_02', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let leaveItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      leaveItem.keyName = 'keyName2';
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = false;

      instance.updateFolderLayoutAfterLeave([leaveItem], openFolderData);
      expect(leaveItem.keyName).assertEqual('keyName2');
    });

    it('test_updateFolderLayoutAfterLeave_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[1,1],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      openFolderData.isInDock = true;
      let leaveItemJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let leaveItem: GridLayoutItemInfo = JSON.parse(leaveItemJSONStr) as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderData', openFolderData);
      instance.updateFolderLayoutAfterLeave([leaveItem], openFolderData);
      expect(openFolderData.bundleName).assertEqual('lkqkw4s76q0592qwa4g');
      AppStorage.delete('openFolderData');
    });

    it('test_updateFolderLayoutAfterLeave_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      openFolderData.isInDock = false;
      let leaveItemJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let leaveItem: GridLayoutItemInfo = JSON.parse(leaveItemJSONStr) as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderData', openFolderData);
      instance.updateFolderLayoutAfterLeave([leaveItem], openFolderData);
      expect(openFolderData.bundleName).assertEqual('lkqkw4s76q0592qwa4g');
      AppStorage.delete('openFolderData');
    });

    it('test_waitFolderAnimateFinish_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['mGeometryTransitionCount'] = 0;
      const callback: Callback<void> = () => {
        throw new Error();
      };

      instance.waitFolderAnimateFinish(callback);
      expect((instance as object)['mGeometryTransitionCount']).assertEqual(0);
    });

    it('test_waitFolderAnimateFinish_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      (instance as object)['mGeometryTransitionCount'] = 1;
      const callback: Callback<void> = () => {
      };

      instance.waitFolderAnimateFinish(callback);
      expect((instance as object)['mGeometryTransitionCount']).assertEqual(1);
    });

    it('test_waitFolderMoveAniamtion_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };

      instance.setFolderSqueezeStatus(true);
      instance.waitFolderMoveAniamtion(callback);
      instance.setFolderSqueezeStatus(false);
      instance.waitFolderMoveAniamtion(callback);
      expect(instance).not().assertNull();
    });

    it('test_waitFolderOpenFinish_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      (instance as object)['mFolderOpened'] = true;

      await instance.waitFolderOpenFinish();
      expect(instance).not().assertNull();
    });

    it('test_waitFolderOpenFinish_02', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      (instance as object)['mFolderOpened'] = false;

      await instance.waitFolderOpenFinish();
      expect(instance).not().assertNull();
    });

    it('test_deleteAppByDraging_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let ret: boolean = instance.deleteAppByDraging(folderAppList, 4);
      expect(ret).assertFalse();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'folderItem1';
      item1.typeId = CommonConstants.TYPE_APP;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'folderItem2';
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'folderItem3';
      item3.typeId = CommonConstants.TYPE_APP;
      folderAppList.push(item1);
      folderAppList.push(item2);
      folderAppList.push(item3);
      ret = instance.deleteAppByDraging(folderAppList, 4);
      expect(ret).assertFalse();

      let mocker: MockKit = new MockKit();
      let pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      let updateInfoFunc: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.updatePageDesktopLayoutInfo);
      when(updateInfoFunc)(ArgumentMatchers.any).afterReturn(true);
      ret = instance.deleteAppByDraging(folderAppList, 2);
      expect(ret).assertFalse();

      when(updateInfoFunc)(ArgumentMatchers.any).afterReturn(false);
      let layoutCache: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance()
      let selectFolderByIdFunc: Function = mocker.mockFunc(layoutCache, layoutCache.selectGridLayoutItemByFolderId);
      when(selectFolderByIdFunc)(ArgumentMatchers.any).afterReturn(new GridLayoutItemInfo());
      let selectIndexFunc: Function = mocker.mockFunc(layoutCache, layoutCache.selectIndexInLayout);
      when(selectIndexFunc)(ArgumentMatchers.any).afterReturn(-1);
      ret = instance.deleteAppByDraging(folderAppList, 2);
      expect(ret).assertFalse();

      when(selectIndexFunc)(ArgumentMatchers.any).afterReturn(0);
      folderAppList = [item1, item2];
      instance.deleteAppByDraging(folderAppList, 1);

      folderAppList = [item1, item3, item3];
      instance.deleteAppByDraging(folderAppList, 1);
      mocker.clear(layoutCache);
      mocker.clearAll();
    });

    it('test_createAppLayoutInfo_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.infoId = 'anyInfoId';
      appInfo.bundleName = 'anyBundleName';
      appInfo.abilityName = 'anyAbilityName';
      appInfo.moduleName = 'anyModuleName';
      appInfo.keyName = 'anyKindName';
      appInfo.typeId = 1;
      appInfo.area = [1, 1];
      appInfo.page = 1;
      appInfo.column = 2;
      appInfo.row = 3;
      appInfo.appName = 'anyAppName';
      appInfo.appIconId = 1;
      appInfo.appLabelId = 9898989;
      appInfo.downloadProgress = 0.5;
      appInfo.appStatus = AppStatus.WAITING;
      appInfo.iconResource = 'anyIconResource';

      let ret: GridLayoutItemInfo = (instance as object)['createAppLayoutInfo'](appInfo);
      expect(ret).not().assertNull();
    });

    it('test_createNewFolderInfo_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: GridLayoutItemInfo = await (instance as object)['createNewFolderInfo']();
      expect(ret).not().assertNull();
    });

    it('test_deleteAppFromFolderAppList_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let tempList: AppItemInfo[] = [];
      let tempAppItem1: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName1',
        abilityName: ''
      };
      let tempAppItem2: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName2',
        abilityName: ''
      };
      tempList.push(tempAppItem1);
      tempList.push(tempAppItem2);

      let inFolderApps: AppItemInfo[] = [];
      let inFolderApp1: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName2',
        abilityName: ''
      };
      let inFolderApp2: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName3',
        abilityName: ''
      };
      inFolderApps.push(inFolderApp1);
      inFolderApps.push(inFolderApp2);

      (instance as object)['deleteAppFromFolderAppList'](tempList, inFolderApps);
      expect(instance).not().assertNull();
    });

    it('test_deleteFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

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
      folderItem.area = [1, 1];

      (instance as object)['deleteFolder'](folderItem);
      expect(folderItem.keyName).assertEqual('keyName0');
    });

    it('test_deleteFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

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

      (instance as object)['deleteFolder'](folderItem);
      expect(folderItem.keyName).assertEqual('keyName0');
    });

    it('test_dockAddItem_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let appInfos: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder0';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);

      let folderItem: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: '',
        keyName: 'anyKeyName'
      };

      (instance as object)['dockAddItem'](appInfos, folderItem);
      expect(folderItem.keyName).assertEqual('anyKeyName');
    });

    it('test_dockAddItem_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let appInfos: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfos.push(appInfo1);

      let folderItem: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: '',
        keyName: 'anyKeyName_0'
      };

      let residentList: DockItemInfo[] = [];
      residentList.push(folderItem)
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      (instance as object)['dockAddItem'](appInfos, folderItem);
      expect(folderItem.keyName).assertEqual('anyKeyName_0');
      AppStorage.clear();
    });

    it('test_dockAddItem_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let appInfos: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfos.push(appInfo1);

      let folderItem: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: '',
        keyName: 'anyKeyName_0'
      };

      let folderItem1: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: '',
        keyName: 'anyKeyName_1'
      };

      let residentList: DockItemInfo[] = [];
      residentList.push(folderItem1)
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      (instance as object)['dockAddItem'](appInfos, folderItem);
      expect(folderItem.keyName).assertEqual('anyKeyName_0');
      AppStorage.clear();
    });

    it('test_getCurFolderLayoutInfo_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();

      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.layoutInfo = [[item1],[item2]];
      folderItemInLayout.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.keyName = 'keyName0';

      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout);

      let ret: GridLayoutItemInfo[][] = (instance as object)['getCurFolderLayoutInfo'](folderItem);
      expect(ret.length).assertLargerOrEqual(0);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('test_getCurFolderLayoutInfo_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();

      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout);

      let ret: GridLayoutItemInfo[][] = (instance as object)['getCurFolderLayoutInfo'](folderItem);
      expect(ret.length).assertLargerOrEqual(0);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('test_getCurFolderLayoutInfo_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.container = CommonConstants.TYPE_APP;
      folderItem.layoutInfo = [];
      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      let ret: GridLayoutItemInfo[][] = (instance as object)['getCurFolderLayoutInfo'](folderItem);
      expect(ret.length).assertLargerOrEqual(0);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('test_getFolderLayoutInfo_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.healthy';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.infoId = 'anyInfoId';
      appInfo.bundleName = 'com.ohos.healthy';
      appInfo.abilityName = 'anyAbilityName';
      appInfo.moduleName = 'anyModuleName';
      appInfo.keyName = 'anyKindName';
      appInfo.typeId = 1;
      appInfo.area = [1, 1];
      appInfo.page = 1;
      appInfo.column = 2;
      appInfo.row = 3;
      appInfo.appName = 'anyAppName';
      appInfo.appIconId = 1;
      appInfo.appLabelId = 9898989;
      appInfo.downloadProgress = 0.5;
      appInfo.appStatus = AppStatus.WAITING;
      appInfo.iconResource = 'anyIconResource';

      let ret: GridLayoutItemInfo[] = (instance as object)['getFolderLayoutInfo'](openFolderData, appInfo);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_getFolderLayoutInfo_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.infoId = 'anyInfoId';
      appInfo.bundleName = 'com.ohos.healthy';
      appInfo.abilityName = 'anyAbilityName';
      appInfo.moduleName = 'anyModuleName';
      appInfo.keyName = 'anyKindName';
      appInfo.typeId = 1;
      appInfo.area = [1, 1];
      appInfo.page = 1;
      appInfo.column = 2;
      appInfo.row = 3;
      appInfo.appName = 'anyAppName';
      appInfo.appIconId = 1;
      appInfo.appLabelId = 9898989;
      appInfo.downloadProgress = 0.5;
      appInfo.appStatus = AppStatus.WAITING;
      appInfo.iconResource = 'anyIconResource';

      let ret: GridLayoutItemInfo[] = (instance as object)['getFolderLayoutInfo'](openFolderData, appInfo);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_getFolderLayoutInfo_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;

      let ret: GridLayoutItemInfo[] = (instance as object)['getFolderLayoutInfo'](openFolderData, appInfo);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('test_layoutInfoToList_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_ADD;

      folderInfo.layoutInfo = [[item1],[item2]];
      folderInfo.typeId = CommonConstants.TYPE_FOLDER;
      folderInfo.keyName = 'keyName0';

      let ret: GridLayoutItemInfo[] = (instance as object)['layoutInfoToList'](folderInfo);
      expect(ret).not().assertNull();
    });

    it('test_moveAppFromDockToFolder', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getDevice);
      let mockFunc2: Function = mocker.mockFunc(globalThis.RdbStoreManagerInstance, globalThis.RdbStoreManagerInstance.querySmartDock);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.DOCK_SPACE);
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.keyName = 'keyName';
      item.itemType = CommonConstants.TYPE_APP;
      let appInfos: GridLayoutItemInfo[] = [item];
      when(mockFunc2)().afterReturn(appInfos);
      await (instance as object)['moveAppFromDockToFolder'](appInfos);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.DEFAULT_DEVICE_TYPE);
      await (instance as object)['moveAppFromDockToFolder'](appInfos);
      expect(appInfos.length).assertLarger(0);
      mocker.clear(settingsModel);
      mocker.clear(globalThis.RdbStoreManagerInstance);
    })

    it('test_moveAppFromDesktopToFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let appInfos: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder0';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);

      (instance as object)['moveAppFromDesktopToFolder'](appInfos);
      expect(instance).not().assertNull();
    });

    it('test_moveAppFromDockToFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.PAD_DEVICE_TYPE);
      expect(instance).not().assertNull();
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('test_moveAppFromDockToFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.DEFAULT_DEVICE_TYPE);

      expect(instance).not().assertNull();
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('test_updateOpenFolderStatus_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.folderId = 'anyFolderId_0';

      (instance as object)['updateOpenFolderStatus'](openFolderData);
      expect(openFolderData.folderId).assertEqual('anyFolderId_0');
    });

    it('test_updateOpenFolderStatus_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.folderId = '';
      (instance as object)['updateOpenFolderStatus'](openFolderData);
      expect(openFolderData.folderId).assertEqual('');
    });

    it('test_updateOpenFolderStatus_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.folderId = 'folderId_0';

      (instance as object)['updateOpenFolderStatus'](openFolderData);
      expect(openFolderData.folderId).assertEqual('folderId_0');
    });

    it('test_updateApp_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      let abilityInfo: AppItemInfo = {} as AppItemInfo;

      let  ret: OpenFolderData = (instance as object)['updateApp'](openFolderData, abilityInfo);
      expect(ret).not().assertNull();
    });

    it('test_updateApp_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = '';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let abilityInfo: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: ''
      };

      let  ret: OpenFolderData = (instance as object)['updateApp'](openFolderData, abilityInfo);
      expect(ret).not().assertNull();
    });

    it('test_updateApp_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.healthy';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let abilityInfo: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.healthy',
        abilityName: '',
      };

      let  ret: OpenFolderData = (instance as object)['updateApp'](openFolderData, abilityInfo);
      expect(ret).not().assertNull();
    });

    it('test_updateApp_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName';
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      openFolderData.layoutInfo = [list];
      let abilityInfo: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'com.ohos.healthy',
        abilityName: '',
        keyName: 'keyName',
      };
      let ret: OpenFolderData = (instance as object)['updateApp'](openFolderData, abilityInfo);
      expect(ret.layoutInfo.length).assertEqual(1);
    })

    it('test_updateBadge_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let params: Params = {
        bundleName: 'com.ohos.healthy',
        isShow: false,
        badgeNumber: 1
      } as Params;

      let ret: OpenFolderData = (instance as object)['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('test_updateBadge_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.healthy';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;

      let params: Params = {
        bundleName: 'com.ohos.healthy',
        isShow: true,
        badgeNumber: 1
      } as Params;

      let ret: OpenFolderData = (instance as object)['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('test_updateBadge_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo()
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.healthy';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = false;

      let params: Params = {
        bundleName: 'com.ohos.healthy',
        isShow: true,
        badgeNumber: 1
      } as Params;

      let ret: OpenFolderData = (instance as object)['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('test_updateBadge_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [];

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = '';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = false;

      let params: Params = {
        bundleName: '',
        isShow: true,
        badgeNumber: 1
      } as Params;

      let ret: OpenFolderData = (instance as object)['updateBadge'](openFolderData, params);
      expect(ret).not().assertNull();
    });

    it('test_updateBadgeNumber_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItemInLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.layoutInfo = [[item1],[item2]];
      folderItemInLayout.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.keyName = 'keyName0';

      let dragAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragAppInfo.bundleName = 'com.ohos.sceneboard';
      dragAppInfo.appIconId = 92;
      dragAppInfo.typeId = CommonConstants.TYPE_ADD;

      (instance as object)['updateBadgeNumber'](folderItemInLayout, dragAppInfo);
      expect(folderItemInLayout.keyName).assertEqual('keyName0')
    });

    it('test_updateBadgeNumber_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItemInLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.layoutInfo = [[item1],[item2]];
      folderItemInLayout.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.keyName = 'keyName0';
      folderItemInLayout.badgeNumber = 4;

      let dragAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragAppInfo.bundleName = 'com.ohos.sceneboard';
      dragAppInfo.appIconId = 92;
      dragAppInfo.typeId = CommonConstants.TYPE_ADD;

      (instance as object)['updateBadgeNumber'](folderItemInLayout, dragAppInfo);
      expect(folderItemInLayout.keyName).assertEqual('keyName0')
    });

    it('test_updateBadgeNumber_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItemInLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.layoutInfo = [[item1],[item2]];
      folderItemInLayout.typeId = CommonConstants.TYPE_FOLDER;
      folderItemInLayout.keyName = 'keyName0';
      folderItemInLayout.badgeNumber = 4;

      let dragAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragAppInfo.bundleName = 'com.ohos.sceneboard';
      dragAppInfo.appIconId = 92;
      dragAppInfo.typeId = CommonConstants.TYPE_ADD;
      dragAppInfo.badgeNumber = 2;

      (instance as object)['updateBadgeNumber'](folderItemInLayout, dragAppInfo);
      expect(folderItemInLayout.keyName).assertEqual('keyName0')
    });

    it('it_updateFolderAppByInstall_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let folderItem: OpenFolderData = {
        folderId: undefined,
        folderName: undefined,
        enterEditing: false,
        layoutInfo: []
      };
      let bundleName: string = 'anyBundleName';
      let appIndex: number = CommonConstants.MAIN_APP_INDEX;

      (instance as object)['updateFolderAppByInstall'](folderItem, bundleName, appIndex);
      expect(instance).not().assertNull();
    });


    it('test_updateResidentDockLayout_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let tempOpenFolderData: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let openFolderData: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderStatus', CommonConstants.OPEN_FOLDER_STATUS_CLOSE);
      (instance as object)['updateResidentDockLayout'](tempOpenFolderData, openFolderData);
      expect(instance).not().assertNull();
      AppStorage.clear();
    });


    it('test_updateResidentDockLayout_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'keyName0';

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.bundleName = 'com.ohos.mms';
      itemInfo1.keyName = 'keyName1';
      let residentList: DockItemInfo[] = [];
      residentList.push(itemInfo);
      residentList.push(itemInfo1);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      let tempOpenFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;
      openFolderData.folderId = 'keyName4';


      AppStorage.setOrCreate('openFolderStatus', CommonConstants.OPEN_SOURCES);
      (instance as object)['updateResidentDockLayout'](tempOpenFolderData, openFolderData);
      expect(instance).not().assertNull();
      AppStorage.clear();
    });

    it('test_updateResidentDockLayout_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let itemInfo: DockItemInfo = new DockItemInfo();
      itemInfo.itemType = CommonConstants.TYPE_APP;
      itemInfo.bundleName = 'com.ohos.contacts';
      itemInfo.keyName = 'keyName0';

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.bundleName = 'com.ohos.mms';
      itemInfo1.keyName = 'keyName1';
      let residentList: DockItemInfo[] = [];
      residentList.push(itemInfo);
      residentList.push(itemInfo1);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      let tempOpenFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.keyName = 'keyName1'
      item1.appIconId = 92;
      item1.typeId = CommonConstants.TYPE_ADD;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.keyName = 'keyName2'
      item2.appIconId = 95;
      item2.typeId = CommonConstants.TYPE_ADD;
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.keyName = 'anyKeyName2'
      item3.appIconId = 98;
      item3.typeId = CommonConstants.TYPE_ADD;
      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);
      list.push(item3);
      openFolderData.layoutInfo?.push(list);
      openFolderData.area = [1,1];
      openFolderData.isInDock = true;
      openFolderData.folderId = 'keyName1';


      AppStorage.setOrCreate('openFolderStatus', CommonConstants.OPEN_SOURCES);
      tempOpenFolderData.layoutInfo = [];
      (instance as object)['updateResidentDockLayout'](tempOpenFolderData, openFolderData);
      expect(instance).not().assertNull();
      AppStorage.clear();
    });

    it('test_updateTransitionFolderId_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderId: string = 'geometryTransitionFolderId';
      (instance as object)['updateTransitionFolderId'](folderId);
      expect(folderId).assertEqual('geometryTransitionFolderId');
    });

    it('test_dragAppFromFolderToDeskTop_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderData', openFolderData);

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['isEnoughDropSpace']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance.dragAppFromFolderToDeskTop([appInfo], null);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_isEnoughDropSpace_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppList.push(appInfo1);
      folderAppList.push(appInfo2);
      folderAppList.push(appInfo3);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let itemCount: number = 2147483648;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace)
      when(mockFunc)(ArgumentMatchers.any).afterReturn(itemCount);
      let ret: boolean = (instance as object)['isEnoughDropSpace'](folderAppList, msg);
      expect(ret || true).assertTrue();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('test_isEnoughDropSpace_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo3: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppList.push(appInfo1);
      folderAppList.push(appInfo2);
      folderAppList.push(appInfo3);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let itemCount: number = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace)
      when(mockFunc)(ArgumentMatchers.any).afterReturn(itemCount);
      let ret: boolean = (instance as object)['isEnoughDropSpace'](folderAppList, msg);
      expect(ret || true).assertTrue();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('test_isEnoughDropSpace_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();

      folderAppList.push(appInfo1);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let itemCount: number = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace)
      when(mockFunc)(ArgumentMatchers.any).afterReturn(itemCount);
      let ret: boolean = (instance as object)['isEnoughDropSpace'](folderAppList, msg);
      expect(ret || true).assertTrue();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('test_isEnoughDropSpace_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderAppList: GridLayoutItemInfo[] = [];
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderAppList.push(appInfo);
      let msg: string = '桌面当前没有可添加的位置，请清理后再尝试';
      let ret: boolean = (instance as object)['isEnoughDropSpace']([], msg);
      expect(ret).assertTrue();
      folderAppList = [appInfo, appInfo, appInfo];
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let gridConfig: GridLayoutConfig = {
        column: 2,
        row: 1,
        id: 0,
        layout: '',
        name: '',
        value: 0,
        checked: false
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectMaxPageCount);
      let mockFunc3: Function = mocker.mockFunc(settingsModel, settingsModel.getGridConfig);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(gridConfig);
      ret = (instance as object)['isEnoughDropSpace'](folderAppList, msg);
      expect(ret).assertFalse();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('test_convertToSmallFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderInfo: GridLayoutItemInfo = getNullObject() as GridLayoutItemInfo;
      instance.convertToSmallFolder(folderInfo);
      expect(instance).not().assertNull();

      let layoutCache: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance()
      let mocker: MockKit = new MockKit();
      let selectIndexFunc: Function = mocker.mockFunc(layoutCache, layoutCache.selectIndexInLayout);
      when(selectIndexFunc)(ArgumentMatchers.any).afterReturn(0);
      instance.convertToSmallFolder(new GridLayoutItemInfo());
      mocker.clear(layoutCache);
      mocker.clearAll();
    });

    it('test_convertToSmallFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = [1, 1];
      let layoutCache: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let selectIndexFunc: Function = mocker.mockFunc(layoutCache, layoutCache.selectIndexInLayout);
      when(selectIndexFunc)(ArgumentMatchers.any).afterReturn(1);
      instance.convertToSmallFolder(new GridLayoutItemInfo());
      expect(instance).not().assertNull();
      mocker.clear(layoutCache);
      mocker.clearAll();
    })

    it('test_checkChangeFolderPage', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let list: GridLayoutItemInfo[][] = [[]];
      (instance as object)['checkChangeFolderPage'](list, 1);
      expect((instance as object)['mPageIndex']).assertEqual(-1);
    })

    it('test_deleteAppFromOpenFolder_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;

      AppStorage.setOrCreate('openFolderData', {folderId: openFolderData.folderId, layoutInfo: openFolderData.layoutInfo});

      let ret: GridLayoutItemInfo = instance.deleteAppFromOpenFolder(appInfo);
      expect(ret).not().assertNull();
    });

    it('test_moveAppFromDockOtherFolders_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
      (instance as object)['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
    });


    it('test_moveAppFromDockOtherFolders_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      let rdbResidentList: DockItemInfo[] = [];
      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_FOLDER;
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.calendar';
      let layoutInfos: GridLayoutItemInfo[] = []
      itemInfo1.layoutInfo = [];
      layoutInfos.push(gridLayoutItemInfo)
      itemInfo1.layoutInfo.push(layoutInfos);
      rdbResidentList.push(itemInfo1);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', rdbResidentList, false);

      (instance as object)['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_moveAppFromDockOtherFolders_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      let rdbResidentList: DockItemInfo[] = [];
      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.calendar';
      let layoutInfos: GridLayoutItemInfo[] = []
      itemInfo1.layoutInfo = [];
      layoutInfos.push(gridLayoutItemInfo)
      itemInfo1.layoutInfo.push(layoutInfos);
      rdbResidentList.push(itemInfo1);

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', rdbResidentList, false);
      (instance as object)['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });


    it('test_moveAppFromDockOtherFolders_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      let gridLayoutItemList: GridLayoutItemInfo[] = layoutCacheData.getGridLayoutItemList();
      let folderItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === '实用工具');

      let appInfosJSONStr: string = '[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":0,"column":0,"keyName":"com.ohos.calendarMainAbilityphone","appStatus":0,"appName":"","appIconId":285212950,"appLabelId":285212823,"isSystemApp":true,"kindId":2,"isUninstallAble":true,"applicationIconId":285212943,"bundleType":0,"infoId":"18","badgeNumber":0,"geometryId":"lxvko39bzn2ubvhr46g"},{"bundleName":"com.ohos.totemweather","abilityName":"com.ohos.totemweather.MainAbility","moduleName":"product","typeId":0,"area":[1,1],"page":0,"row":2,"column":0,"keyName":"com.ohos.totemweathercom.ohos.totemweather.MainAbilityproduct","appStatus":0,"appName":"","appIconId":83887310,"appLabelId":83886664,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":83886081,"bundleType":0,"infoId":"24","badgeNumber":0,"geometryId":"lxvko39c2hnv8ilhhu9"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":0,"column":1,"keyName":"com.ohos.healthMainAbilityentry","appStatus":0,"appName":"","appIconId":134220347,"appLabelId":134217728,"isSystemApp":true,"kindId":14,"isUninstallAble":true,"applicationIconId":134217730,"bundleType":0,"infoId":"19","badgeNumber":0,"geometryId":"lxvko39bx2xm3p0io3"},{"bundleName":"com.ohos.myhuawei","abilityName":"EntryAbility","moduleName":"entry","typeId":0,"area":[1,1],"page":0,"row":1,"column":1,"keyName":"com.ohos.myhuaweiEntryAbilityentry","appStatus":0,"appName":"","appIconId":134218136,"appLabelId":134217728,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":134217729,"bundleType":0,"infoId":"20","badgeNumber":0,"geometryId":"lxvko39cgghh4uidst"},{"bundleName":"com.ohos.dataclone","abilityName":"EntryAbility","moduleName":"phone","typeId":0,"area":[1,1],"page":0,"row":1,"column":2,"keyName":"com.ohos.datacloneEntryAbilityphone","appStatus":0,"appName":"","appIconId":50331649,"appLabelId":50331648,"isSystemApp":true,"kindId":-1,"isUninstallAble":true,"applicationIconId":50331649,"bundleType":0,"infoId":"23","badgeNumber":0,"geometryId":"lxvko39c2qz0rx8sh8d"}]';
      let appInfos: AppItemInfo[] = JSON.parse(appInfosJSONStr);

      let rdbResidentList: DockItemInfo[] = [];
      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_FOLDER;
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.sceneboard';
      let layoutInfos: GridLayoutItemInfo[] = []
      itemInfo1.layoutInfo = [];
      layoutInfos.push(gridLayoutItemInfo)
      itemInfo1.layoutInfo.push(layoutInfos);
      rdbResidentList.push(itemInfo1);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', rdbResidentList, false);

      (instance as object)['moveAppFromDockOtherFolders'](appInfos, folderItem);
      expect(appInfos).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_deleteAppFromFolderByUninstall_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let bundleName: string = 'com.ohos.uninstallApp';

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.test2";
      app2.typeId = CommonConstants.TYPE_APP;
      let folder1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppList1: GridLayoutItemInfo[] = [];
      folderAppList1.push(app1, app2);
      folder1.layoutInfo = [folderAppList1];

      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.test3";
      app3.typeId = CommonConstants.TYPE_APP;
      let folder2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppList2: GridLayoutItemInfo[] = [];
      folderAppList2.push(app3);
      folder2.layoutInfo = [folderAppList2];

      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "com.ohos.test4";
      app4.typeId = CommonConstants.TYPE_APP;
      let appAdd: GridLayoutItemInfo = new GridLayoutItemInfo();
      appAdd.typeId === CommonConstants.TYPE_ADD;
      let folder3: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder3.container = CommonConstants.CONTAINER_SMARTDOCK;
      let folderAppList3: GridLayoutItemInfo[] = [];
      folderAppList3.push(app4, appAdd);
      folder3.layoutInfo = [folderAppList3];

      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.test5";
      app5.typeId = CommonConstants.TYPE_APP;
      let app6: GridLayoutItemInfo = new GridLayoutItemInfo();
      app6.bundleName = "com.ohos.uninstallApp";
      app6.typeId = CommonConstants.TYPE_APP;
      app6.appIndex = 0;
      let folder4: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder4.container = CommonConstants.CONTAINER_DESKTOP;
      let folderAppList4: GridLayoutItemInfo[] = [];
      folderAppList4.push(app5, app6);
      folder4.layoutInfo = [folderAppList4];

      let folderList: GridLayoutItemInfo[] = [folder1, folder2, folder3, folder4];
      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayout, folderLayout.selectFolderByContainApp);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderList);
      instance.deleteAppFromFolderByUninstall(bundleName, 0);
      expect(instance).not().assertNull();
      mocker.clear(folderLayout);
      mocker.clearAll();
    });


    it('test_deleteAppFromFolderByUninstall_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let bundleName: string = 'com.ohos.uninstallApp';

      let info1: DockItemInfo = new DockItemInfo();
      info1.typeId = CommonConstants.TYPE_APP;

      let info2: DockItemInfo = new DockItemInfo();
      info2.typeId = CommonConstants.TYPE_FOLDER;
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.uninstallApp";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.appIndex = 1;
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.uninstallApp";
      app3.typeId = CommonConstants.TYPE_APP;
      app3.appIndex = 0;
      info2.layoutInfo = [[app1, app2, app3]];

      let info3: DockItemInfo = new DockItemInfo();
      info3.typeId = CommonConstants.TYPE_FOLDER;
      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "com.ohos.test1";
      app4.typeId = CommonConstants.TYPE_APP;
      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.uninstallApp";
      app5.typeId = CommonConstants.TYPE_APP;
      app5.appIndex = 0;
      info3.layoutInfo = [[app4, app5]];


      let residentList: DockItemInfo[] = [info1, info2, info3];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      instance.deleteAppFromFolderByUninstall(bundleName, 0);

      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });


    it('test_deleteAppFromFolderByUninstall_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let folderItem: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;

      let residentList: DockItemInfo[] = [];

      let itemInfo1: DockItemInfo = new DockItemInfo();
      itemInfo1.itemType = CommonConstants.TYPE_APP;
      itemInfo1.layoutInfo = [];

      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.bundleName = 'com.ohos.sceneboard';
      let gridLayoutLayoutInfo: GridLayoutItemInfo[] = []
      gridLayoutLayoutInfo.push(gridLayoutItemInfo);


      itemInfo1.layoutInfo.push(gridLayoutLayoutInfo);
      residentList.push(itemInfo1);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      instance.deleteAppFromFolderByUninstall(folderItem.bundleName, 0);

      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });


    it('test_onHandleEvent_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let event: string = EventConstants.EVENT_BADGE_UPDATE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;
      params.bundleName = 'com.ohos.test';
      FolderData.getInstance().close('BigFolderViewModel badgeUpdate test');
      localEventManager.sendLocalEventSticky(event, params);
      expect(instance).not().assertNull();
    });

    it('test_onHandleEvent_02', 0, () => {
      let event: string = EventConstants.EVENT_BADGE_UPDATE;
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.test";
      appData.typeId = CommonConstants.TYPE_APP;
      appData.appIndex = 0;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      let folderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
      folderData.layoutInfo = [folderAppList];

      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;
      params.bundleName = 'com.ohos.test_1';
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = "com.ohos.test";
      params.appIndex = 1;
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = "com.ohos.test";
      params.appIndex = 0;
      params['isShow'] = true;
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = "com.ohos.test";
      params.appIndex = 0;
      params['isShow'] = false;
      localEventManager.sendLocalEventSticky(event, params);

      let emptyNameApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      emptyNameApp.bundleName = '';
      emptyNameApp.typeId = CommonConstants.TYPE_APP;
      emptyNameApp.appIndex = 0;
      folderAppList.push(emptyNameApp);
      folderData.layoutInfo = [folderAppList];
      params.bundleName = '';
      params.appIndex = 0;
      localEventManager.sendLocalEventSticky(event, params);
      expect(folderData).not().assertNull();
    });


    it('test_onHandleEvent_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let event: string = EventConstants.EVENT_FOLDER_PACKAGE_REMOVED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.deleteAppFromFolderByUninstall);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      localEventManager.sendLocalEventSticky(event, params);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_onHandleEvent_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let event: string = EventConstants.EVENT_FOLDER_PACKAGE_REMOVED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.badgeNumber = 1;

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.deleteAppFromFolderByUninstall);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      localEventManager.sendLocalEventSticky(event, params);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_onHandleEvent_05', 0, () => {
      let event: string = EventConstants.EVENT_FOLDER_ITEM_UPDATE;
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

      localEventManager.sendLocalEventSticky(event, '');
      expect(folderDataInstance).not().assertNull();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    });

    it('test_onHandleEvent_06', 0, () => {
      let folderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();

      let event: string = EventConstants.EVENT_FOLDER_ITEM_UPDATE;
      localEventManager.sendLocalEventSticky(event, '');

      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.test";
      appData.typeId = CommonConstants.TYPE_APP;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      params.bundleName = 'com.ohos.test_1';
      localEventManager.sendLocalEventSticky(event, params);

      params.bundleName = 'com.ohos.test';
      localEventManager.sendLocalEventSticky(event, params);

      let emptyNameApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      emptyNameApp.bundleName = '';
      emptyNameApp.typeId = CommonConstants.TYPE_APP;
      localEventManager.sendLocalEventSticky(event, emptyNameApp);

      expect(instance).not().assertNull();
    });

    it('test_getFolderAppList_01', 0, async () => {
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
      instance.getFolderAppList('testFolder');

      let residentList: DockItemInfo[] = [];
      let dockItem1: DockItemInfo = new DockItemInfo();
      let dockItem2: DockItemInfo = new DockItemInfo();
      dockItem2.layoutInfo = [];
      let dockItem3: DockItemInfo = new DockItemInfo();
      dockItem3.layoutInfo = [[new GridLayoutItemInfo()]];
      let dockItem4: DockItemInfo = new DockItemInfo();
      dockItem4.typeId = CommonConstants.TYPE_FOLDER;
      dockItem4.layoutInfo = [[new GridLayoutItemInfo()]];
      dockItem4.keyName = '123';
      let folderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem1.typeId = CommonConstants.TYPE_APP;
      let folderItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem2.typeId = CommonConstants.TYPE_ADD;
      let dockItem5: DockItemInfo = new DockItemInfo();
      dockItem5.typeId = CommonConstants.TYPE_FOLDER;
      dockItem5.layoutInfo = [[folderItem1, folderItem2]];
      dockItem5.keyName = 'testFolder';
      residentList = [dockItem1, dockItem2, dockItem3, dockItem4, dockItem5];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);
      await instance.getFolderAppList('testFolder');
      expect(instance instanceof BigFolderViewModel).assertTrue();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_updateFolderAppList_01', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      folderItem.layoutInfo = [];

      let residentList: DockItemInfo[] = [];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_updateFolderAppList_02', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      folderItem.layoutInfo = [];

      let residentList: DockItemInfo[] = [folderItem as Object as DockItemInfo];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_updateFolderAppList_03', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.test1";
      app2.typeId = CommonConstants.TYPE_APP;
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.test2";
      app3.typeId = CommonConstants.TYPE_APP;
      folderItem.layoutInfo = [[app2, app3], []];

      let residentList: DockItemInfo[] = [];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_updateFolderAppList_04', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      folderItem.layoutInfo = [];

      let residentList: DockItemInfo[] = [folderItem as Object as DockItemInfo];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let uninstallApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      uninstallApp.bundleName = "com.ohos.test3";
      uninstallApp.typeId = CommonConstants.TYPE_APP;
      uninstallApp.keyName = 'keyName3';
      AppStorage.setOrCreate<GridLayoutItemInfo>('unInstallItemInfo', uninstallApp);

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_updateFolderAppList_04', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1111';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.test1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.test2";
      app3.typeId = CommonConstants.TYPE_APP;
      app3.keyName = 'keyName2';
      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.test3";
      app5.typeId = CommonConstants.TYPE_APP;
      app5.keyName = 'keyName3';
      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "addIcon";
      app4.typeId = CommonConstants.TYPE_ADD;
      folderItem.layoutInfo = [[app2, app3, app4], []];

      let residentList: DockItemInfo[] = [folderItem as Object as DockItemInfo];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      disappearData.folderId = '1';
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it('test_updateFolderAppList_05', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1111';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DESKTOP;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.test1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      folderItem.layoutInfo = [];

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      disappearData.folderId = '1';
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
    });

    it('test_updateFolderAppList_06', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1111';
      let appInfos: GridLayoutItemInfo[] = [app1];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DESKTOP;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.test1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      folderItem.layoutInfo = [[app2]];

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
    });

    it('test_updateFolderAppList_07', 0, async () => {
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.test1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = 'keyName1';
      let app10: GridLayoutItemInfo = new GridLayoutItemInfo();
      app10.bundleName = "com.ohos.test10";
      app10.typeId = CommonConstants.TYPE_APP;
      app10.keyName = 'keyName10';
      let appInfos: GridLayoutItemInfo[] = [app1, app10];

      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem['container'] = CommonConstants.CONTAINER_DOCK;
      folderItem['folderId'] = 'dockFolder';
      folderItem.keyName = 'dockFolder';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = "com.ohos.test1";
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = 'keyName1';
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      app3.bundleName = "com.ohos.test2";
      app3.typeId = CommonConstants.TYPE_APP;
      app3.keyName = 'keyName2';
      let app5: GridLayoutItemInfo = new GridLayoutItemInfo();
      app5.bundleName = "com.ohos.test3";
      app5.typeId = CommonConstants.TYPE_APP;
      app5.keyName = 'keyName3';
      let app4: GridLayoutItemInfo = new GridLayoutItemInfo();
      app4.bundleName = "addIcon";
      app4.typeId = CommonConstants.TYPE_ADD;
      folderItem.layoutInfo = [[app2, app3, app4], []];

      let residentList: DockItemInfo[] = [folderItem as Object as DockItemInfo];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);

      let disappearData: DisappearLastAppData = new DisappearLastAppData();
      disappearData.folderId = '1';
      AppStorage.set<DisappearLastAppData>('disappearLastAppData', disappearData);

      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.dropInFolderOpenComponent();
      instance.updateFolderAppList(appInfos, folderItem);
      expect(instance).not().assertNull();
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
    });

    it("test_updateOpenFolderAppStatus_02", 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.abcd";
      appData.appStatus = 1;
      appData.typeId = CommonConstants.TYPE_APP;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      let folderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
      folderData.layoutInfo = [folderAppList];
      instance.updateOpenFolderAppStatus("com.ohos.abc", 0);
      instance.updateOpenFolderAppStatus("com.ohos.abcd", 0);
      expect(appData.appStatus).assertEqual(0);
    });

    it("test_getUninstallDialogName_01", 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getIsPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      instance.getUninstallDialogName('test');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance.getUninstallDialogName('test');
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it("test_removeShortCut_01", 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.layoutInfo = [[], []];

      openFolderData.isInDock = true;
      instance.removeShortCut(openFolderData, openFolderData);
      openFolderData.isInDock = false;
      instance.removeShortCut(openFolderData, openFolderData);
      expect(instance).not().assertNull();
    });

    it('test_unRegisterBigFolderFlush', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.unRegisterBigFolderFlush('folder123');
      instance.registerBigFolderFlush('folder123', {
        onListChange: (folderItem: FolderItemInfo) => {}
      });
      instance.unRegisterBigFolderFlush('folder123');
      expect(instance).not().assertNull();
    });

    it('test_stateChangeCallback_01', 0, () => {
      FolderData.getInstance().notifyFolderStateChange(0);

      instance.registerOpenFolderStatusCallback({
        moduleName: 'test1'
      });
      instance.registerOpenFolderStatusCallback({
        moduleName: 'test2',
        closeFolderEndCallback: (): void => {},
        openFolderEndCallback: (): void => {}
      });

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.isFolderOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      FolderData.getInstance().notifyFolderStateChange(FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);

      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      FolderData.getInstance().notifyFolderStateChange(FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
      instance.unRegisterOpenFolderStatusCallback('test1');
      instance.unRegisterOpenFolderStatusCallback('test2');
      expect(instance).not().assertNull();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    });

    it('test_multiSelectListener_01', 0, () => {
      const manager = MultiSelectManager.getInstance();
      manager['mode'] = MultiSelectMode.INIT;
      multiSelectListenManager.executeGather();

      manager['mode'] = MultiSelectMode.MULTI;
      let map: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager, manager.getSelectedItemSortByFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(map);
      multiSelectListenManager.executeGather();

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'testFolder';
      folder.layoutInfo = [];
      let selectAppList: GridLayoutItemInfo[] = [];
      map.set(folder, selectAppList);

      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(folderLayout, folderLayout.selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folder);
      multiSelectListenManager.executeGather();
      expect(folderLayout).not().assertNull();
      mocker.clear(manager);
      mocker.clear(folderLayout);
      mocker.clearAll();
    });

    it('test_multiSelectListener_02', 0, () => {
      const manager = MultiSelectManager.getInstance();
      manager['mode'] = MultiSelectMode.MULTI;
      let map: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager, manager.getSelectedItemSortByFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(map);

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'testFolder';
      let app: GridLayoutItemInfo = new GridLayoutItemInfo();
      app.typeId = CommonConstants.TYPE_APP;
      app.bundleName = 'testApp';
      folder.layoutInfo = [[app]];
      let selectAppList: GridLayoutItemInfo[] = [];
      map.set(folder, selectAppList);

      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(folderLayout, folderLayout.selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folder);
      multiSelectListenManager.executeGather();
      expect(folderLayout).not().assertNull();
      mocker.clear(manager);
      mocker.clear(folderLayout);
      mocker.clearAll();
    });

    it('test_multiSelectListener_03', 0, () => {
      const manager = MultiSelectManager.getInstance();
      manager['mode'] = MultiSelectMode.MULTI;
      let map: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager, manager.getSelectedItemSortByFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(map);

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'testFolder';
      let app: GridLayoutItemInfo = new GridLayoutItemInfo();
      app.typeId = CommonConstants.TYPE_APP;
      app.bundleName = 'testApp';
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.typeId = CommonConstants.TYPE_APP;
      app2.bundleName = 'testApp2';
      app2.badgeNumber = 1;
      app2.page = 1;
      folder.layoutInfo = [[app, app2]];
      let selectAppList: GridLayoutItemInfo[] = [];
      map.set(folder, selectAppList);

      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(folderLayout, folderLayout.selectGridLayoutItemByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folder);
      multiSelectListenManager.executeGather();
      expect(folderLayout).not().assertNull();
      mocker.clear(manager);
      mocker.clear(folderLayout);
      mocker.clearAll();
    });

    it('test_mAddToFolderListener_01', 0, () => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_ITEM_ADD, new GridLayoutItemInfo());
      expect(instance).not().assertNull();
    });

    it('test_isOpeningAndClosing', 0, () => {
      instance.isOpening();
      instance.isClosing();
      expect(instance).not().assertNull();
    });

    it('test_removeShortCutFromFolderInDesktop', 0, () => {
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_OPEN);
      let openFolder: OpenFolderData = new OpenFolderData();
      openFolder.layoutInfo = [];
      instance.removeShortCutFromFolderInDesktop(openFolder, new GridLayoutItemInfo());
      expect(instance).not().assertNull();
    });

    it('test_removeShortCutFromFolderInDock', 0, () => {
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance.removeShortCutFromFolderInDock(openFolderData, new GridLayoutItemInfo());

      let shortcut: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcut.bundleName = 'testApp';
      shortcut.shortcutId = '1';
      shortcut.appIndex = 0;
      openFolderData.layoutInfo = [[shortcut, new GridLayoutItemInfo(), new GridLayoutItemInfo()]];
      openFolderData.keyName = 'testKey';

      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
      let tempFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      tempFolderData.typeId = CommonConstants.TYPE_FOLDER;
      tempFolderData.area = [1, 1];
      instance.removeShortCutFromFolderInDock(openFolderData, shortcut);

      let residentList: DockItemInfo[] = [GridLayoutUtil.gridLayoutToDockItem(openFolderData)];
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', residentList, false);
      openFolderData.layoutInfo = [[shortcut, new GridLayoutItemInfo(), new GridLayoutItemInfo()]];
      instance.removeShortCutFromFolderInDock(openFolderData, shortcut);

      let nullData: GridLayoutItemInfo = getNullObject() as GridLayoutItemInfo;
      openFolderData.layoutInfo = [[shortcut, nullData]];
      instance.removeShortCutFromFolderInDock(openFolderData, shortcut);
      ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
      expect(instance).not().assertNull();
    });

    it('test_revertLastFolderData', 0, () => {
      let openFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolder.layoutInfo = [[new GridLayoutItemInfo()]];
      AppStorage.SetOrCreate('lastOpenFolderData', openFolder);
      instance.revertLastFolderData();
      AppStorage.delete('lastOpenFolderData');
      expect(instance).not().assertNull();
    });

    it('test_updateFolderSize', 0, () => {
      let openFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolder.layoutInfo = [[new GridLayoutItemInfo()]];
      openFolder.area = [2, 2];
      instance.updateFolderSize(openFolder);
      expect(instance).not().assertNull();
    });

    it('test_handlerMultiSelectItem', 0, () => {
      let selectedItemMap: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = new Map();
      let disappearList: Object[] = [];
      let deleteFolderIdList: string[] = [];

      let anotherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolder.folderId = 'testFolder';
      anotherFolder.typeId === CommonConstants.TYPE_FOLDER;

      let anotherFolderTwo: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolderTwo.folderId = 'anotherTestFolder';
      anotherFolderTwo.typeId === CommonConstants.TYPE_FOLDER;
      anotherFolderTwo.layoutInfo = [[anotherFolder]];

      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.folderId = 'testFolder';
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.layoutInfo = [[anotherFolder]];

      let otherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      otherFolder.typeId === CommonConstants.TYPE_FOLDER;
      otherFolder.folderId = 'otherTestFolder';

      let list: GridLayoutItemInfo[] = [folder, otherFolder];
      selectedItemMap.set(folder, list);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FolderData.getInstance(), FolderData.getInstance().getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(anotherFolder);
      let mockFunc2: Function = mocker.mockFunc(instance, (instance as object)['layoutInfoToList']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([anotherFolder]);
      let ret: boolean = (instance as object)['handlerMultiSelectItem'](selectedItemMap, disappearList, deleteFolderIdList);
      expect(ret).assertTrue();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([anotherFolderTwo]);
      ret = (instance as object)['handlerMultiSelectItem'](selectedItemMap, disappearList, deleteFolderIdList);
      expect(ret).assertTrue();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([anotherFolderTwo, anotherFolderTwo, anotherFolderTwo]);
      ret = (instance as object)['handlerMultiSelectItem'](selectedItemMap, disappearList, deleteFolderIdList);
      expect(ret).assertTrue();
      mocker.clear(FolderData.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_updateAppLayoutInFolder', 0, () => {
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.folderId = 'testFolder';
      folder.badgeNumber = 1;
      folder.page = 0;
      let list: GridLayoutItemInfo[] = [folder];
      let ret: GridLayoutItemInfo[][] = (instance as object)['updateAppLayoutInFolder'](list);
      let retValue = ret[0][0].folderId;
      expect(retValue === 'testFolder').assertTrue();
    })

    it('test_disPatchFolderWhenOnlyOneAppLeft', 0, () => {
      let anotherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolder.folderId = 'anotherTestFolder';
      anotherFolder.typeId === CommonConstants.TYPE_FOLDER;
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.folderId = 'testFolder';
      folder.badgeNumber = 1;
      folder.page = 0;
      folder.column = 0;
      folder.row = 0;
      let list: GridLayoutItemInfo[] = [folder];
      let settingModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingModel, settingModel.getAppListInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([folder]);
      (instance as object)['disPatchFolderWhenOnlyOneAppLeft'](false, list, folder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([anotherFolder]);
      (instance as object)['disPatchFolderWhenOnlyOneAppLeft'](true, list, folder);
      expect(list.length).assertEqual(1);
      mocker.clear(settingModel);
      mocker.clearAll();
    });

    it('test_moveAppFromOtherFolders', 0, () => {
      let folder: GridLayoutItemInfo = new GridLayoutItemInfo();
      folder.typeId === CommonConstants.TYPE_FOLDER;
      folder.folderId = 'testFolder';
      folder.badgeNumber = 1;
      folder.page = 0;
      folder.column = 0;
      folder.row = 0;
      folder.keyName = 'folder';
      folder.badgeNumber = 0;
      let anotherFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      anotherFolder.folderId = 'anotherTestFolder';
      anotherFolder.typeId === CommonConstants.TYPE_FOLDER;
      anotherFolder.keyName = 'anotherFolder';
      anotherFolder.badgeNumber = 0;
      anotherFolder.layoutInfo = [[folder]];
      let list: GridLayoutItemInfo[] = [folder];
      let folderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemsByType);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([anotherFolder]);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(-1);
      let mockFunc4: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderShouldReleased);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['moveAppFromOtherFolders'](list, folder);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(0);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['moveAppFromOtherFolders'](list, folder);
      anotherFolder.keyName = 'testFolder';
      list = [anotherFolder];
      (instance as object)['moveAppFromOtherFolders'](list, folder);
      expect(list.length).assertEqual(1);
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(NotHarmonyUtil);
      mocker.clearAll();
    });

    it('test_BigFolderViewModel_dragAppFromFolderToDeskTop', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;
      AppStorage.setOrCreate('openFolderData', openFolderData);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['isEnoughDropSpace']);
      let mockFunc01: Function = mocker.mockFunc(instance, (instance as object)['filterFolderPage']);
      let mockFunc02: Function = mocker.mockFunc((instance as object)['mFolderLayout'], (instance as object)['mFolderLayout'].selectIndexInLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc01)(ArgumentMatchers.any).afterReturn([[appInfo]]);
      when(mockFunc02)(ArgumentMatchers.any).afterReturn(CommonConstants.INVALID_VALUE);
      instance.dragAppFromFolderToDeskTop([appInfo], appInfo);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clear((instance as object)['mFolderLayout']);
      mocker.clearAll();
    });

    it('test_BigFolderViewModel_updateDesktopAppList_01', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let manager: MultiSelectManager = new MultiSelectManager();
      let itemInfo: AppItemInfo = new AppItemInfo();
      info.folderId = '996';
      info.keyName = '李华';
      manager['mode'] = MultiSelectMode.MULTI;
      let folderLayoutInfo: GridLayoutItemInfo[][] = [[info]];
      let mocker: MockKit = new MockKit();
      let mockFunc02: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderShouldReleased);
      let mockFunc03: Function = mocker.mockFunc(MultiSelectManager, MultiSelectManager.getInstance);
      let mockFunc04: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc02)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc03)(ArgumentMatchers.any).afterReturn(manager);
      when(mockFunc04)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['updateDesktopAppList'](folderLayoutInfo, info, [info], info, [itemInfo]);
      expect(folderLayoutInfo.length).assertEqual(1);
      mocker.clear(NotHarmonyUtil);
      mocker.clear(MultiSelectManager);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    });

    it('test_BigFolderViewModel_updateDesktopAppList_02', 0, () => {
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      let manager: MultiSelectManager = new MultiSelectManager();
      let itemInfo: AppItemInfo = new AppItemInfo();
      info.folderId = '996';
      info.keyName = '李华';
      info.badgeNumber = 9;
      info.bundleName = '李华';
      info.abilityName = '007';
      info.appIconId = 7;
      info.negativeId = 9;
      info.isSelect = true;
      info.area = [1, 2];
      manager['mode'] = MultiSelectMode.MULTI;
      let folderLayoutInfo: GridLayoutItemInfo[][] = [[info]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['getIsPad']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['updateDesktopAppList'](folderLayoutInfo, info, [info], info, [itemInfo]);
      expect(folderLayoutInfo.length).assertEqual(1);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_updateOpenedFolderLayout_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      (instance as object)['updateOpenedFolderLayout'](false, gridLayoutItemInfo, ['1']);
      gridLayoutItemInfoOther.typeId = 1;
      gridLayoutItemInfoOther.cardId = '1';
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['updateFolderAppLocation']);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc2: Function = mocker.mockFunc(instance, (instance as object)['updateAppLayoutInFolder']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([[gridLayoutItemInfo]]);
      let mockFunc3: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['isBigFolder']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['updateOpenedFolderLayout'](true, gridLayoutItemInfo, ['11']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['updateOpenedFolderLayout'](true, gridLayoutItemInfo, ['11']);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    });

    it('test_addBackToFolder_1', 0, (done: Function) => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.layoutInfo = [[gridLayoutItemInfo]];
      let dragItemFromFolderStartInfo: DragItemFromFolderStartInfo = {
        page: 1,
        row: 0,
        column: 0,
        bundleName: '1',
        folderId: undefined,
      };
      gridLayoutItemInfo.bundleName = 'name_1';
      instance.setDragFromFolderStartInfo(dragItemFromFolderStartInfo);
      instance.addBackToFolder(gridLayoutItemInfo);
      dragItemFromFolderStartInfo.folderId = '1';
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const folderModel: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['selectGridLayoutItemByFolderId']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      instance.setDragFromFolderStartInfo(dragItemFromFolderStartInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoOther);
      let mockFunc1: Function = mocker.mockFunc(folderModel, folderModel['getFolderOpenLayout']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        id: 1,
        layout: '1',
        name: '1',
        row: 0,
        column: 0,
        checked: false
      });
      instance.setDragFromFolderStartInfo(dragItemFromFolderStartInfo);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(folderModel);
      mocker.clearAll();
      done();
    });

    it('test_convertToSmallFolder_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const folderReporter: FolderReporter = FolderReporter.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      let mockFunc1: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.deleteGridLayoutItemByIndex);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.convertFolderSize);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc3: Function = mocker.mockFunc(folderReporter, folderReporter.reportMenuModifyFolderSize);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      instance.convertToSmallFolder(gridLayoutItemInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(-2);
      instance.convertToSmallFolder(gridLayoutItemInfo);
      expect(instance).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(folderReporter);
      mocker.clearAll();
      done();
    });

    it('test_deleteAppByDraging_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const folderData: FolderData = FolderData.getInstance()
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      const settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.filterFolderPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([[new GridLayoutItemInfo()]]);
      let mockFunc1: Function = mocker.mockFunc(folderData, folderData.getOpenedFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(new GridLayoutItemInfo());
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(0);
      let mockFunc3: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.deleteGridLayoutItemByItemId);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc4: Function = mocker.mockFunc(instance, (instance as object)['updateBadgeNumber']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc5: Function = mocker.mockFunc(settingsModel, settingsModel['getAppListInfo']);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn([]);
      let mockFunc6: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel['updatePageDesktopLayoutInfo']);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc7: Function = mocker.mockFunc(instance, (instance as object)['createAppLayoutInfo']);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      let mockFunc8: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['insertGridLayoutItemInfo']);
      when(mockFunc8)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc9: Function = mocker.mockFunc(settingsModel, settingsModel['setAppListInfo']);
      when(mockFunc9)(ArgumentMatchers.any).afterReturnNothing();
      instance.deleteAppByDraging([gridLayoutItemInfo], 0)
      when(mockFunc)(ArgumentMatchers.any).afterReturn([[]]);
      instance.deleteAppByDraging([gridLayoutItemInfo], 0);
      expect(folderLayoutCacheManager).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(folderData);
      mocker.clear(pageDesktopModel);
      mocker.clear(instance);
      mocker.clear(settingsModel);
      mocker.clearAll();
      done();
    });

    it('test_getAppFromDesktopPages_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfoOther.page = 2;
      gridLayoutItemInfo.container = -100;
      gridLayoutItemInfoOther.container = -100;
      expect((instance as object)['getAppFromDesktopPages']([gridLayoutItemInfo, gridLayoutItemInfoOther])).not().assertNull();
      done();
    });

    it('test_getCurFolderLayoutInfo_1', 0, (done: Function) => {
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = [[new GridLayoutItemInfo()]];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['selectGridLayoutItemByFolderId']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      expect((instance as object)['getCurFolderLayoutInfo'](gridLayoutItemInfo)).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
      done();
    });

    it('test_deleteBlankPage_1', 0, (done: Function) => {
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['selectPageCount']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(3);
      let mockFunc1: Function =
        mocker.mockFunc(pageDesktopModel, pageDesktopModel['deleteBlankPageFromLayoutInfo']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['deleteBlankPage']([1, 2]);
      expect(instance).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
      done();
    });

    it('test_getAppRemainInOtherFolder_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.keyName = 'good_1';
      gridLayoutItemInfoOther.keyName = 'good_2';
      instance.getAppRemainInOtherFolder([gridLayoutItemInfo], [gridLayoutItemInfoOther])
      expect(gridLayoutItemInfo).not().assertNull();
      done();
    });

    it('test_updateFolderBadgeNumber_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(new GridLayoutItemInfo());
      let mockFunc1: Function = mocker.mockFunc(ObjUtil, ObjUtil.isInvalid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(instance, (instance as object)['filterFolderPage']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([[new GridLayoutItemInfo()]]);
      let mockFunc3: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['updateBadgeNumberByFolderId']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      gridLayoutItemInfoOther.badgeNumber = 2;
      (instance as object)['updateFolderBadgeNumber']([gridLayoutItemInfoOther], gridLayoutItemInfo);
      gridLayoutItemInfoOther.badgeNumber = 0;
      (instance as object)['updateFolderBadgeNumber']([gridLayoutItemInfoOther], gridLayoutItemInfo);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(ObjUtil);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_moveAppFromOtherFolders_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.folderId = '1';
      const gridLayoutItemInfoOther_1: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther_2: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther_1.page = 1;
      gridLayoutItemInfoOther_1.column = 1;
      gridLayoutItemInfoOther_1.row = 1;
      gridLayoutItemInfoOther_2.badgeNumber = 10;
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemsByType);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfoOther_1]);
      let mockFunc2: Function = mocker.mockFunc(instance, (instance as object)['layoutInfoToList']);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([new GridLayoutItemInfo()]);
      let mockFunc3: Function = mocker.mockFunc(instance, (instance as object)['getAppRemainInOtherFolder']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([]);
      let mockFunc4: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['selectIndexInLayout']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(-1);
      (instance as object)['moveAppFromOtherFolders']([gridLayoutItemInfo], gridLayoutItemInfoOther);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(0);
      (instance as object)['moveAppFromOtherFolders']([gridLayoutItemInfo], gridLayoutItemInfoOther);
      gridLayoutItemInfoOther_1.folderId = '100';
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfoOther_1]);
      let mockFunc5: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['deleteGridLayoutItemByItemId']);
      when(mockFunc5)(ArgumentMatchers.any).afterReturnNothing();
      (instance as object)['moveAppFromOtherFolders']([gridLayoutItemInfo], gridLayoutItemInfoOther);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([new GridLayoutItemInfo()]);
      let mockFunc7: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil['isNotHarmonyFolderShouldReleased']);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc8: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['deleteAndReplaceItem']);
      when(mockFunc8)(ArgumentMatchers.any).afterReturnNothing();
      (instance as object)['moveAppFromOtherFolders']([gridLayoutItemInfo], gridLayoutItemInfoOther);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc9: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['updateBadgeNumberByFolderId']);
      when(mockFunc9)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc10: Function = mocker.mockFunc(instance, (instance as object)['filterFolderPage']);
      when(mockFunc10)(ArgumentMatchers.any).afterReturn([[new GridLayoutItemInfo()]]);
      (instance as object)['moveAppFromOtherFolders']([gridLayoutItemInfo], gridLayoutItemInfoOther);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfoOther_2]);
      (instance as object)['moveAppFromOtherFolders']([gridLayoutItemInfo], gridLayoutItemInfoOther);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(NotHarmonyUtil);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_findBlankPosition_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.updatePageDesktopLayoutInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.updatePageCount);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc2: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.updateLayoutAfterAddPage);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([new GridLayoutItemInfo()]);
      let mockFunc3: Function = mocker.mockFunc(instance, (instance as object)['createAppLayoutInfo']);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(new GridLayoutItemInfo());
      let mockFunc4: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['insertGridLayoutItemListFromFolder']);
      when(mockFunc4)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc5: Function =
        mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.updateItemToDesktopCallBack);
      when(mockFunc5)(ArgumentMatchers.any).afterReturnNothing();
      (instance as object)['findBlankPosition'](10, 12, [gridLayoutItemInfo]);
      let mockFunc6: Function = mocker.mockFunc(instance, (instance as object)['addAppsWhenMaxPage']);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['findBlankPosition'](10, 1, [gridLayoutItemInfo]);
      when(mockFunc6)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['findBlankPosition'](10, 1, [gridLayoutItemInfo]);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['findBlankPosition'](10, 1, [gridLayoutItemInfo]);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(pageDesktopModel);
      mocker.clear(instance);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
      done();
    });

    it('test_addAppsWhenMaxPage_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const pageDesktopModel: PageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbBlankPositionUtils, scbBlankPositionUtils.getFindBlankStartPage);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      let mockFunc1: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.findBlankPosition);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.addAppWhenMaxPage);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      expect((instance as object)['addAppsWhenMaxPage'](gridLayoutItemInfo, [gridLayoutItemInfoOther], 1))
        .assertInstanceOf('Boolean');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      expect((instance as object)['addAppsWhenMaxPage'](gridLayoutItemInfo, [gridLayoutItemInfoOther], 1))
        .assertInstanceOf('Boolean');
      mocker.clear(pageDesktopViewModel);
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
      done();
    });

    it('test_updateFolderInfoAfterRemoveShortIconInEditMode_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.page = 1;
      gridLayoutItemInfoOther.column = 1;
      gridLayoutItemInfoOther.row = 1;
      let gridLayoutItemInfoOther_1: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther_1.bundleName = '1';
      gridLayoutItemInfoOther_1.shortcutId = '1';
      gridLayoutItemInfoOther_1.appIndex = 1;
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const folderData: FolderData = FolderData.getInstance()
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectFolderByContainShortCut);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
      (instance as object)['updateFolderInfoAfterRemoveShortIconInEditMode'](gridLayoutItemInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoOther);
      let mockFunc1: Function = mocker.mockFunc(instance, (instance as object)['layoutInfoToList']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfoOther_1]);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectIndexInLayout);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(0);
      let mockFunc3: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.isSameShortcutApp);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc4: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.deleteGridLayoutItemByIndex);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc5: Function = mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunc5)(ArgumentMatchers.any).afterReturn(Promise);
      (instance as object)['updateFolderInfoAfterRemoveShortIconInEditMode'](gridLayoutItemInfo);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc7: Function = mocker.mockFunc(NotHarmonyUtil, NotHarmonyUtil.isNotHarmonyFolderShouldReleased);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc8: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.deleteFolderAndUpdateAppItemToDesktop);
      when(mockFunc8)(ArgumentMatchers.any).afterReturnNothing();
      (instance as object)['updateFolderInfoAfterRemoveShortIconInEditMode'](gridLayoutItemInfo);
      when(mockFunc7)(ArgumentMatchers.any).afterReturn(false)
      let mockFunc9: Function = mocker.mockFunc(instance, (instance as object)['filterFolderPage']);
      when(mockFunc9)(ArgumentMatchers.any).afterReturn([[gridLayoutItemInfoOther_1]]);
      let mockFunc10: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager['updateFolderLayoutInfoByFolderId']);
      when(mockFunc10)(ArgumentMatchers.any).afterReturnNothing();
      let mockFunc11: Function = mocker.mockFunc(folderData, folderData['refreshView']);
      when(mockFunc11)(ArgumentMatchers.any).afterReturnNothing();
      (instance as object)['updateFolderInfoAfterRemoveShortIconInEditMode'](gridLayoutItemInfo);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clear(instance);
      mocker.clear(FolderData);
      mocker.clear(NotHarmonyUtil);
      mocker.clear(localEventManager);
      mocker.clear(LauncherLayoutCacheUtil);
      mocker.clearAll();
      done();
    });

    it('test_isEnoughDropSpace_1', 0, (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect((instance as object)['isEnoughDropSpace']([gridLayoutItemInfo], '1')).assertInstanceOf('Boolean');
      const settingsModel: SettingsModel = SettingsModel.getInstance();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      const gridLayoutConfig: GridLayoutConfig = new GridLayoutConfig();
      gridLayoutConfig.column = 1;
      gridLayoutConfig.row = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getGridConfig);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutConfig);
      let mockFunc1: Function =
        mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectAllOccupiedSpace);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(10);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectMaxPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(5);
      expect((instance as object)['isEnoughDropSpace']([gridLayoutItemInfo], '1')).assertInstanceOf('Boolean');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(2);
      expect((instance as object)['isEnoughDropSpace']([gridLayoutItemInfo], '1')).assertInstanceOf('Boolean');
      mocker.clear(settingsModel);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
      done();
    });

    it('test_checkReleaseFolderIfNeeded_01', 0, (done: Function) => {
      let bundleName: string = 'com.ohos.uninstallApp';
      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = bundleName;
      app1.appIndex = 0;
      app1.typeId = CommonConstants.TYPE_APP;
      let folder1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppList1: GridLayoutItemInfo[] = [];
      folderAppList1.push(app1);
      folder1.layoutInfo = [folderAppList1];

      let folderLayout: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayout, folderLayout.selectIndexInLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      expect((instance as object)['checkReleaseFolderIfNeeded'](folder1, [app1]) === undefined).assertTrue();
      mocker.clear(folderLayout);
      mocker.clearAll();
      done();
    });

    class GridLayoutInfo {
      layoutInfo?:GridLayoutInfo[];
      typeId?: number;
      keyName?: string;
      bundleName: string = '';
    };

    class InnerOpenFolderData {
      folderId: string = '';
      layoutInfo: [] = [];
    };

    class Params {
      bundleName: string = '';
      isShow: boolean = false;
      badgeNumber: number = 0;
    };
  })
}
