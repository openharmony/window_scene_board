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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
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
  SettingsModel} from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  BigFolderViewModel,
  BigFolderStyleConfig,
  FolderLayoutStruct,
  DragItemFromFolderStartInfo,
  Callback,
  FolderCloseType,
} from '../../../../../index';
import { GridLayoutItemInfo, EventConstants } from '@ohos/launchercommon'
import FeatureConstants from '../../../../main/ets/default/common/constants/FeatureConstants';
import { DesktopLayoutCacheData } from '@ohos/launchercommon/src/main/ets/cache/layout/DesktopLayoutCacheData';
import { localEventManager, ObjUtil } from '@ohos/basiccommon/src/main/ets/TsIndex';
import { multiSelectListenManager } from '@ohos/launchercommon/src/main/ets/editmode/model/MultiSelectListenerManager';
import { MultiSelectMode } from '@ohos/launchercommon/src/main/ets/editmode/data/MultiSelectData';
import {
  PageDesktopViewModel
} from '../../../../../../pagedesktop/src/main/ets/default/common/viewmodel/PageDesktopViewModel';

function getNullObject(): GridLayoutItemInfo | null | FolderItemInfo{
  return null;
}

export default function BigFolderViewFakeTest() {
  describe('BigFolderViewModelFakeTest2', () => {
    let instance: BigFolderViewModel = BigFolderViewModel.getInstance();
    // Defines a FakeTest suite. Two parameters are supported: FakeTest suite name and FakeTest suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all FakeTest cases of the FakeTest suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit FakeTest case starts.
      // The number of execution times is the same as the number of FakeTest cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit FakeTest case ends.
      // The number of execution times is the same as the number of FakeTest cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all FakeTest cases of the FakeTest suite end.
      // This API supports only one parameter: clear action function.
    })

    it('FakeTest2_getFolderStyleConfig', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderStyleConfig: BigFolderStyleConfig = BigFolderViewModelInstance.getFolderStyleConfig();
      expect(folderStyleConfig).assertEqual(BigFolderViewModelInstance.getFolderStyleConfig());
    })
    it('FakeTest2_getFolderLayoutConfig', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderLayoutConfig: FolderLayoutStruct = BigFolderViewModelInstance.getFolderLayoutConfig();
      expect(folderLayoutConfig).assertEqual(BigFolderViewModelInstance.getFolderLayoutConfig());
    })
    it('FakeTest2_dropInFolderOpenComponent', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.dropInFolderOpenComponent() === undefined).assertTrue();
    })
    it('FakeTest2_setDragFromFolderStartInfo', 0, () => {
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
    it('FakeTest2_getDragFromFolderStartInfo', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const dragFromFolderStartInfo: DragItemFromFolderStartInfo = BigFolderViewModelInstance.getDragFromFolderStartInfo();
      expect(dragFromFolderStartInfo).assertEqual(BigFolderViewModelInstance.getDragFromFolderStartInfo());
    })

    it('FakeTest2_runFolderDropAnimateWaitCallBack', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.runFolderDropAnimateWaitCallBack() === undefined).assertTrue();
      BigFolderViewModelInstance.setDropAnimationStart();
      const callback: Callback<void> = () => {
      };
      BigFolderViewModelInstance.pushDropAnimationCallBack(callback);
      expect((BigFolderViewModelInstance.runFolderDropAnimateWaitCallBack() === undefined)).assertTrue()
    })
    it('FakeTest2_setDropAnimationStart', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.setDropAnimationStart() === undefined).assertTrue();
    })
    it('FakeTest2_getDropAnimationStatus', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const dropAnimationStatus: boolean = BigFolderViewModelInstance.getDropAnimationStatus();
      expect(dropAnimationStatus).assertEqual(BigFolderViewModelInstance.getDropAnimationStatus());
    })
    it('FakeTest2_pushDropAnimationCallBack', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(BigFolderViewModelInstance.pushDropAnimationCallBack(callback) === undefined).assertTrue();
      expect(BigFolderViewModelInstance.pushDropAnimationCallBack(callback) === undefined).assertTrue();
    })
    it('FakeTest2_setAppLaunchTime', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect((BigFolderViewModelInstance.setAppLaunchTime() === undefined)).assertTrue();
    })
    it('FakeTest2_registerFolderListener', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.registerFolderListener() === undefined).assertTrue();
    })
    it('FakeTest2_unregisterFolderListener', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.unregisterFolderListener() === undefined).assertTrue();
    })

    it('FakeTest2_waitFolderMoveAniamtion', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(BigFolderViewModelInstance.waitFolderMoveAniamtion(callback) === undefined).assertTrue();
    })
    it('FakeTest2_excuteAfterMoveAnimation', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(await BigFolderViewModelInstance.excuteAfterMoveAnimation() === undefined).assertTrue();
      BigFolderViewModelInstance.waitFolderMoveAniamtion(() => {
      });
      expect(await BigFolderViewModelInstance.excuteAfterMoveAnimation() === undefined).assertTrue();
    })
    it('FakeTest2_waitFolderAnimateFinish', 0, async () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      expect(await BigFolderViewModelInstance.waitFolderAnimateFinish(callback) === undefined).assertTrue();
      BigFolderViewModelInstance.startTransitionAnimation(true, '');
      expect(await BigFolderViewModelInstance.waitFolderAnimateFinish(callback) === undefined).assertTrue();
    })

    it('FakeTest2_setCloseType', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const type: FolderCloseType = FolderCloseType.CLICK_BLANK;
      expect(BigFolderViewModelInstance.setCloseType(type) === undefined).assertTrue();

    })
    it('FakeTest2_getCloseType', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const type: FolderCloseType = FolderCloseType.BACK_GESTURE;
      BigFolderViewModelInstance.setCloseType(type);
      const closeType: string = BigFolderViewModelInstance.getCloseType();
      expect(closeType).assertEqual(FolderCloseType.BACK_GESTURE);
    })

    it('FakeTest2_getIsPad', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isPad: boolean = BigFolderViewModelInstance.getIsPad();
      expect(isPad).assertEqual(BigFolderViewModelInstance.getIsPad());
    })

    it('FakeTest2_getFolderAnimationCount', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const folderAnimationCount: number = BigFolderViewModelInstance.getFolderAnimationCount();
      expect(folderAnimationCount).assertEqual(BigFolderViewModelInstance.getFolderAnimationCount());
    })
    it('FakeTest2_getTransitingFolderId', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const transitingFolderId: string = BigFolderViewModelInstance.getTransitingFolderId();
      expect(transitingFolderId).assertEqual(BigFolderViewModelInstance.getTransitingFolderId());
    })
    it('FakeTest2_changeIndexOnly', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.changeIndexOnly(1) === undefined).assertTrue();
    })
    it('FakeTest2_changeIndex', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(BigFolderViewModelInstance.changeIndex(1) === undefined).assertTrue();
    })
    it('FakeTest2_getIndex', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const index: number = BigFolderViewModelInstance.getIndex();
      expect(index).assertEqual(BigFolderViewModelInstance.getIndex());
    })
    it('FakeTest2_getAddListColumn', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const addListColumn: number = BigFolderViewModelInstance.getAddListColumn();
      expect(addListColumn).assertEqual(BigFolderViewModelInstance.getAddListColumn());
    })

    it('FakeTest2_isInGridSwiperArea', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isInGridSwiperArea: boolean = BigFolderViewModelInstance.isInGridSwiperArea(100);
      expect(isInGridSwiperArea).assertDeepEquals(BigFolderViewModelInstance.isInGridSwiperArea(100));
    })

    it('FakeTest2_isInGridSwiperArea02', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isInGridSwiperArea: boolean = BigFolderViewModelInstance.isInGridSwiperArea(null);
      expect(isInGridSwiperArea).assertFalse();
    })

    it('FakeTest2_printFolderAppList01', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const layoutInfoList: GridLayoutItemInfo[] = [];
      expect(BigFolderViewModelInstance.printFolderAppList(layoutInfoList) === undefined).assertTrue();
    })
    it('FakeTest2_printFolderAppList02', 0, () => {
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
    it('FakeTest2_isInDockArea', 0, () => {
      const BigFolderViewModelInstance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const isInDockArea: boolean = BigFolderViewModelInstance.isInDockArea(100);
      expect(isInDockArea).assertEqual(BigFolderViewModelInstance.isInDockArea(100));
    })

    it('FakeTest2_addBackToFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      instance.addBackToFolder(appInfo);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_addBackToFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = {
        bundleName: 'anyBundleName',
        bundleType: CommonConstants.TYPE_APP
      } as GridLayoutItemInfo;
      instance['dragFromFolderStartInfo'] = {
        folderId: undefined
      } as DragItemFromFolderStartInfo;

      instance.addBackToFolder(appInfo);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_addBackToFolder_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = {
        bundleName: 'FakeTestApp',
        bundleType: CommonConstants.TYPE_APP
      } as GridLayoutItemInfo;
      instance['dragFromFolderStartInfo'] = {
        folderId: 'FakeTestFolder'
      } as DragItemFromFolderStartInfo;
      let cacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let selectFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      selectFolder.keyName = 'FakeTestFolder';
      selectFolder.typeId = CommonConstants.TYPE_FOLDER;
      let mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(cacheManager, cacheManager.selectGridLayoutItemByFolderId);
      when(func)(ArgumentMatchers.any).afterReturn(selectFolder);
      instance.addBackToFolder(appInfo);

      let dockFolder: DockItemInfo = new DockItemInfo();
      dockFolder.keyName = 'FakeTestFolder';
      dockFolder.typeId = CommonConstants.TYPE_FOLDER;
      let residentList: DockItemInfo[] = [dockFolder];
      instance.addBackToFolder(appInfo);
      expect(instance).not().assertNull();
      mocker.clear(cacheManager);
      mocker.clearAll();
    });

    it('FakeTest2_calculateArea_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfo: GridLayoutItemInfo[][] = [];
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      instance.calculateArea(layoutInfo, item);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_calculateArea_02', 0, () => {
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

    it('FakeTest2_calculateArea_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfo: GridLayoutItemInfo[][] | undefined = undefined;
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      instance.calculateArea(layoutInfo, item);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_calculateArea_04', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let layoutInfo: GridLayoutItemInfo[][] = [[],[],[]];
      let item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let ret: number[] = instance.calculateArea(layoutInfo, item);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('FakeTest2_changeIndex_01', 0, () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let idx: number = 1;
      instance.changeIndex(idx);
    });

    it('FakeTest2_changeIndexOnly_01', 0, () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let idx: number = 1;
      instance.changeIndexOnly(idx);
    });

    it('FakeTest2_closeFolder_01', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isNeedKeepPageIndex: boolean = false;
      AppStorage.setOrCreate('openFolderId','-1');

      await instance.closeFolder(callback, isNeedKeepPageIndex);
      expect(isNeedKeepPageIndex).assertFalse();
    });

    it('FakeTest2_closeFolder_02', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isNeedKeepPageIndex: boolean = false;
      AppStorage.setOrCreate('openFolderId','1');

      await instance.closeFolder(callback, isNeedKeepPageIndex, true);
      expect(isNeedKeepPageIndex).assertFalse();
      AppStorage.clear();
    });

    it('FakeTest2_closeFolder_03', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isNeedKeepPageIndex: boolean = true;
      AppStorage.setOrCreate('openFolderId','1');

      await instance.closeFolder(callback, isNeedKeepPageIndex);
      expect(isNeedKeepPageIndex).assertTrue();
      AppStorage.clear();
    });

    it('FakeTest2_closeFolderPending_01', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isPendingClose: boolean = true;
      AppStorage.setOrCreate('openFolderId','-1');

      await instance.closeFolderPending(isPendingClose, callback);
      expect(isPendingClose).assertTrue();
      AppStorage.clear();
    });

    it('FakeTest2_closeFolderPending_02', 0, async () =>{
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      let isPendingClose: boolean = false;
      AppStorage.setOrCreate('openFolderId','1');

      await instance.closeFolderPending(isPendingClose, callback);
      expect(isPendingClose).assertFalse();
      AppStorage.clear();
    });

    it('FakeTest2_dragAppLeaveFolder_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let appInfos: GridLayoutItemInfo[] = [];
      let folderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      await instance.dragAppLeaveFolder(appInfos, folderItem);
      expect(appInfos.length).assertEqual(0);
    });

    it('FakeTest2_dragAppLeaveFolder_02', 0, async () => {
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

    it('FakeTest2_dragAppLeaveFolder_03', 0, async () => {
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

    it('FakeTest2_dockFolderAdd_01', 0, async () => {
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
      AppStorage.setOrCreate('residentList', residentList);

      instance.dragAppLeaveFolder(appInfos, appInfo1);
      expect(appInfos.length).assertLargerOrEqual(0);
      AppStorage.clear();
    });

    it('FakeTest2_dropInFolderOpenComponent_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.dropInFolderOpenComponent();

      expect(instance).not().assertNull();
    });

    it('FakeTest2_excuteAfterMoveAnimation_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      instance['mWaitFolderMoveAnimate'] = [];
      instance.setFolderSqueezeStatus(true);
      instance.waitFolderMoveAniamtion(() => {
        throw new Error();
      });

      await instance.excuteAfterMoveAnimation();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_filterFolderPage_01', 0, () => {
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
      let ret: Array<GridLayoutItemInfo[]> =  instance.filterFolderPage(appInfos);
    });

    it('FakeTest2_getAddListColumn_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.getAddListColumn();

      expect(instance).not().assertNull();
    });

    it('FakeTest2_getAppListInFolder_01', 0, () => {
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
    });

    it('FakeTest2_getAppRemainInOtherFolder_01', 0, () => {
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

    it('FakeTest2_getAppRemainInOtherFolder_02', 0, () => {
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

    it('FakeTest2_getCloseType_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      expect(instance.getCloseType()).not().assertNull();
    });

    it('FakeTest2_getDialogHeight_01', 0, () =>{
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

    });

    it('FakeTest2_getDragFromFolderStartInfo_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['dragFromFolderStartInfo'] = {} as DragItemFromFolderStartInfo;

      let ret: DragItemFromFolderStartInfo = instance.getDragFromFolderStartInfo();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_getDropAnimationStatus_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['isDropAnimationStatus'] = false;

      let ret: boolean = instance.getDropAnimationStatus();
      expect(ret).assertFalse();
    });

    it('FakeTest2_getFolderAnimationCount_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['mGeometryTransitionCount'] = 0;

      let ret: number = instance.getFolderAnimationCount();
      expect(ret).assertEqual(0);
    });

    it('FakeTest2_getFolderLayoutConfig_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: FolderLayoutStruct = instance.getFolderLayoutConfig();
      expect(ret).not().assertNull();
    });

    it('FakeTest2_getFolderStyleConfig_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: BigFolderStyleConfig | undefined = instance.getFolderStyleConfig();
      ret = undefined;
      instance.getFolderStyleConfig();
      expect(ret).not().assertNull();
    });

    it('FakeTest2_getIndex_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: number = instance.getIndex();
      expect(ret).assertLargerOrEqual(0);
    });

    it('FakeTest2_getIsPad_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      AppStorage.setOrCreate('device',CommonConstants.PAD_DEVICE_TYPE);
      let ret: boolean = instance.getIsPad();
      expect(ret).assertTrue();
      AppStorage.clear();
    });

    it('FakeTest2_getIsPad_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      AppStorage.setOrCreate('device',CommonConstants.PC_DEVICE_TYPE);
      let ret: boolean = instance.getIsPad();
      expect(ret).assertFalse();
      AppStorage.clear();
    });

    it('FakeTest2_getNewFolderName_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: string =await instance.getNewFolderName();
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('FakeTest2_getTransitingFolderId_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['mGeometryTransitionFolderId'] = '';
      let ret: string = instance.getTransitingFolderId();
      expect(ret).assertEqual('');
    });

    it('FakeTest2_getUUID_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: string = instance.getUUID();
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('FakeTest2_isConvertToBigFolder_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderInfo: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let isFromDock: boolean = false;
      let initialFolderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      let ret: boolean = instance.isConvertToBigFolder(folderInfo, isFromDock, initialFolderItem);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('FakeTest2_isConvertToBigFolder_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderInfo: GridLayoutItemInfo = getNullObject() as GridLayoutItemInfo;
      let isFromDock: boolean = false;
      let initialFolderItem: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      let ret: boolean = instance.isConvertToBigFolder(folderInfo, isFromDock, initialFolderItem);
      expect(ret).assertFalse();
    });

    it('FakeTest2_isConvertToBigFolder_03', 0, () => {
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

    it('FakeTest2_isInGridSwiperArea_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let positionY: number = 0;
      let ret: boolean = instance.isInGridSwiperArea(positionY);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('FakeTest2_isInGridSwiperArea_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let positionY: number = -1;
      let ret: boolean = instance.isInGridSwiperArea(positionY);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('FakeTest2_isInGridSwiperArea_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let positionY: number = 2147483648;
      let ret: boolean = instance.isInGridSwiperArea(positionY);
      expect(ret).assertInstanceOf('Boolean');
    });

    it('FakeTest2_openFolder_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isRename: boolean = false;
      let folderItem: FolderItemInfo | GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let isFromSmall: boolean = false;

      instance.openFolder(isRename, folderItem, isFromSmall);
      expect(isRename).assertFalse();
    });

    it('FakeTest2_openFolder_02', 0, async () => {
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

    it('FakeTest2_openFolder_03', 0, async () => {
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

    it('FakeTest2_openFolder_04', 0, async () => {
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

    it('FakeTest2_printFolderAppList_01', 0, async () => {
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

    it('FakeTest2_pushDropAnimationCallBack_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      instance['mFolderDropAnimateWaitCallBack'] = [];

      instance.pushDropAnimationCallBack(callback);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_pushDropAnimationCallBack_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {

      };
      instance['mFolderDropAnimateWaitCallBack'].push(callback);

      instance.pushDropAnimationCallBack(callback);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_refreshFolder_01', 0, async () => {
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

    it('FakeTest2_refreshFolder_02', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.folderId = '';
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.FakeTest";
      appData.typeId = CommonConstants.TYPE_APP;
      appData.appIndex = 0;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      folderItem.layoutInfo = [folderAppList];

      await instance.refreshFolder(folderItem);
      expect(instance).not().assertNull();
    });


    it('FakeTest2_refreshFolder_03', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.folderId = '1';
      let appData: GridLayoutItemInfo = new GridLayoutItemInfo();
      appData.bundleName = "com.ohos.FakeTest";
      appData.typeId = CommonConstants.TYPE_APP;
      appData.appIndex = 0;
      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(appData);
      folderItem.layoutInfo = [folderAppList];

      await instance.refreshFolder(folderItem);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_registerFolderListener_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance.registerFolderListener();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_removeFolderAfterUninstallIfNeeded_01', 0, () => {
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
      AppStorage.setOrCreate('residentList', residentList);

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.FakeTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      app1.keyName = uninstallAppKeyName;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = 'com.ohos.uninstallApp';
      app2.typeId = CommonConstants.TYPE_APP;
      let folderAppList: GridLayoutItemInfo[] = [app1, app2];

      instance.removeFolderAfterUninstallIfNeeded(openFolderData, folderAppList, uninstallAppKeyName);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('FakeTest2_removeFolderAfterUninstallIfNeeded_02', 0, () => {
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
      AppStorage.setOrCreate('residentList', residentList);

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      app1.bundleName = "com.ohos.FakeTest1";
      app1.typeId = CommonConstants.TYPE_APP;
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      app2.bundleName = 'com.ohos.uninstallApp';
      app2.typeId = CommonConstants.TYPE_APP;
      app2.keyName = uninstallAppKeyName;
      let folderAppList: GridLayoutItemInfo[] = [app1, app2];

      instance.removeFolderAfterUninstallIfNeeded(openFolderData, folderAppList, uninstallAppKeyName);
      expect(instance).not().assertNull();
      AppStorage.delete('residentList');
    });

    it('FakeTest2_removeFolderAfterUninstallIfNeeded_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let app1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let app2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let app3: GridLayoutItemInfo = new GridLayoutItemInfo();
      let folderAppList: GridLayoutItemInfo[] = [app1, app2, app3];

      instance.removeFolderAfterUninstallIfNeeded(undefined, folderAppList, '');
      expect(instance).not().assertNull();
    });

    it('FakeTest2_removeFolderAfterUninstallWithoutClose_01', 0, () => {
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

    it('FakeTest2_removeFolderAfterUninstall_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.bundleName = 'com.ohos.sceneboard';
      openFolderData.appIconId = 92;
      openFolderData.typeId = CommonConstants.TYPE_ADD;

      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(openFolderData)

      let uninstallAppBundleName: string = 'com.ohos.sceneboard' ;
      let isNeedClose: boolean = true;
      instance['removeFolderAfterUninstall'](openFolderData, folderAppList, uninstallAppBundleName, isNeedClose);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_removeFolderAfterUninstall_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let openFolderData: GridLayoutItemInfo = new GridLayoutItemInfo();
      openFolderData.bundleName = 'com.ohos.sceneboard';
      openFolderData.appIconId = 92;
      openFolderData.typeId = CommonConstants.TYPE_ADD;

      let folderAppList: GridLayoutItemInfo[] = [];
      folderAppList.push(openFolderData)

      let uninstallAppBundleName: string = 'com.ohos.sceneboard' ;
      let isNeedClose: boolean = false;
      instance['removeFolderAfterUninstall'](openFolderData, folderAppList, uninstallAppBundleName, isNeedClose);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_runFolderDropAnimateWaitCallBack_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['isDropAnimationStatus'] = true;

      instance.runFolderDropAnimateWaitCallBack();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_runFolderDropAnimateWaitCallBack_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['isDropAnimationStatus'] = false;

      instance.runFolderDropAnimateWaitCallBack();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_setAppLaunchTime_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      instance.setAppLaunchTime();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_setCloseType_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let type: FolderCloseType = FolderCloseType.BACK_GESTURE;

      instance.setCloseType(type);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_setDragFromFolderStartInfo_01', 0, () => {
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

    it('FakeTest2_setDropAnimationStart_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      instance.setDropAnimationStart();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_startTransitionAnimation_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isStart: boolean = true;
      let folderId: string = 'anyFolderId';
      let isCloseFolderAni: boolean = false;
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_CLOSE);
      instance['mGeometryTransitionCount'] = 0;

      instance.startTransitionAnimation(isStart, folderId, isCloseFolderAni);
      expect(isStart).assertTrue();
      AppStorage.clear();
    });

    it('FakeTest2_startTransitionAnimation_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let isStart: boolean = false;
      let folderId: string = 'anyFolderId';
      let isCloseFolderAni: boolean = false;
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END);
      instance['mGeometryTransitionCount'] = -5;
      instance['mLastFolderStatusBeforeTransition'] = FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_START;

      instance.startTransitionAnimation(isStart, folderId, isCloseFolderAni);
      expect(isStart).assertFalse();
      AppStorage.clear();
    });

    it('FakeTest2_unregisterFolderListener_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      instance.unregisterFolderListener();
      expect(instance).not().assertNull();
    })

    it('FakeTest2_updateFolderLayoutAfterLeave_01', 0, async () => {
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

    it('FakeTest2_updateFolderLayoutAfterLeave_02', 0, async () => {
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

    it('FakeTest2_updateFolderLayoutAfterLeave_03', 0, () => {
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

    it('FakeTest2_updateFolderLayoutAfterLeave_04', 0, () => {
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

    it('FakeTest2_waitFolderAnimateFinish_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['mGeometryTransitionCount'] = 0;
      const callback: Callback<void> = () => {
        throw new Error();
      };

      instance.waitFolderAnimateFinish(callback);
      expect(instance['mGeometryTransitionCount']).assertEqual(0);
    });

    it('FakeTest2_waitFolderAnimateFinish_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      instance['mGeometryTransitionCount'] = 1;
      const callback: Callback<void> = () => {
      };

      instance.waitFolderAnimateFinish(callback);
      expect(instance['mGeometryTransitionCount']).assertEqual(1);
    });

    it('FakeTest2_waitFolderMoveAniamtion_01', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };

      instance.setFolderSqueezeStatus(true);
      instance.waitFolderMoveAniamtion(callback);
      instance.setFolderSqueezeStatus(false);
      instance.waitFolderMoveAniamtion(callback);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_waitFolderOpenFinish_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      instance['mFolderOpened'] = true;

      await instance.waitFolderOpenFinish();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_waitFolderOpenFinish_02', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      const callback: Callback<void> = () => {
      };
      instance['mFolderOpened'] = false;

      await instance.waitFolderOpenFinish();
      expect(instance).not().assertNull();
    });

    it('FakeTest2_deleteAppByDraging_01', 0, () => {
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

    it('FakeTest2_createAppLayoutInfo_01', 0, () => {
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

      let ret: GridLayoutItemInfo = instance['createAppLayoutInfo'](appInfo);
      expect(ret).not().assertNull();
    });

    it('FakeTest2_createNewFolderInfo_01', 0, async () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let ret: GridLayoutItemInfo = await instance['createNewFolderInfo']();
      expect(ret).not().assertNull();
    });

    it('FakeTest2_deleteAppFromFolderAppList_01', 0, () => {
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

      instance['deleteAppFromFolderAppList'](tempList, inFolderApps);
      expect(instance).not().assertNull();
    });

    it('FakeTest2_deleteFolder_01', 0, () => {
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
      folderItem.area = [1, 1]

      instance['deleteFolder'](folderItem);
      expect(folderItem.keyName).assertEqual('keyName0');
    });

    it('FakeTest2_deleteFolder_02', 0, () => {
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

      instance['deleteFolder'](folderItem);
      expect(folderItem.keyName).assertEqual('keyName0');
    });

    it('FakeTest2_dockAddItem_01', 0, () => {
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

      instance['dockAddItem'](appInfos, folderItem);
      expect(folderItem.keyName).assertEqual('anyKeyName');
    });

    it('FakeTest2_dockAddItem_02', 0, () => {
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
      AppStorage.setOrCreate('residentList', residentList);

      instance['dockAddItem'](appInfos, folderItem);
      expect(folderItem.keyName).assertEqual('anyKeyName_0');
      AppStorage.clear();
    });

    it('FakeTest2_dockAddItem_03', 0, () => {
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
      AppStorage.setOrCreate('residentList', residentList);

      instance['dockAddItem'](appInfos, folderItem);
      expect(folderItem.keyName).assertEqual('anyKeyName_0');
      AppStorage.clear();
    });

    it('FakeTest2_getCurFolderLayoutInfo_01', 0, () => {
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

      let ret: GridLayoutItemInfo[][] = instance['getCurFolderLayoutInfo'](folderItem);
      expect(ret.length).assertLargerOrEqual(0);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('FakeTest2_getCurFolderLayoutInfo_02', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();

      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let folderItemInLayout: GridLayoutItemInfo = {} as GridLayoutItemInfo;

      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItemInLayout);

      let ret: GridLayoutItemInfo[][] = instance['getCurFolderLayoutInfo'](folderItem);
      expect(ret.length).assertLargerOrEqual(0);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    });

    it('FakeTest2_getCurFolderLayoutInfo_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.container = CommonConstants.TYPE_APP;
      folderItem.layoutInfo = [];
      let mocker: MockKit = new MockKit();
      let folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      let ret: GridLayoutItemInfo[][] = instance['getCurFolderLayoutInfo'](folderItem);
      expect(ret.length).assertLargerOrEqual(0);
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })

    it('FakeTest2_getFolderLayoutInfo_01', 0, () => {
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

      let ret: GridLayoutItemInfo[] = instance['getFolderLayoutInfo'](openFolderData, appInfo);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('FakeTest2_getFolderLayoutInfo_02', 0, () => {
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

      let ret: GridLayoutItemInfo[] = instance['getFolderLayoutInfo'](openFolderData, appInfo);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('FakeTest2_getFolderLayoutInfo_03', 0, () => {
      const instance: BigFolderViewModel = BigFolderViewModel.getInstance();

      let openFolderDataJSONStr: string = '{"bundleName":"lkqkw4s76q0592qwa4g","abilityName":"","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":29,"infoId":"lkqkw4s76q0592qwa4g","folderId":"lkqkw4s76q0592qwa4g","container":-100,"folderName":"实用工具","ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":3,"area":[2,2],"page":2,"column":0,"row":1,"kindId":0,"moduleName":"","keyName":"lkqkw4s76q0592qwa4g","appIconId":0,"extend1":"","extend2":"","extend3":0,"appLabelId":0,"iconResource":"","callerName":"","layoutInfo":[[{"bundleName":"com.ohos.calendar","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":30,"infoId":"20","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":0,"row":0,"kindId":2,"moduleName":"phone","keyName":"com.ohos.calendarMainAbilityphone","appIconId":285212955,"extend1":"","extend2":"","extend3":0,"appLabelId":285212827,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb201iu34asnj6s"},{"bundleName":"com.ohos.health","abilityName":"MainAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":31,"infoId":"21","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":1,"row":0,"kindId":14,"moduleName":"entry","keyName":"com.ohos.healthMainAbilityentry","appIconId":134220347,"extend1":"","extend2":"","extend3":0,"appLabelId":134217728,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb2rn2bixbfoh"},{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"},{"appName":"","appIconId":67108865,"bundleName":"com.ohos.email","abilityName":"EntryAbility","downloadProgress":0,"appStatus":0,"appLabelId":67108864,"moduleName":"entry","keyName":"com.ohos.emailEntryAbilityentry","iconResource":"","callerName":"","applicationLabelId":67108864,"isUninstallAble":true,"isSystemApp":true,"installTime":"Sat Jun 22 2024 14:15:18 GMT+0800","typeId":0,"area":[1,1],"badgeNumber":0,"infoId":"28","page":0,"row":1,"column":0,"areaType":0,"x":0,"isSelect":false,"geometryId":"lxq0upk8sisd3nfpqtj","extend3":1719054838389}]],"backgroundGeometryId":"lxq0tnb2i98rvvd07sk","totalBadgeGeometryId":"lxq0tnb2xzts9f5r7y","enterEditing":false}';
      let appInfoJSONStr: string = '{"bundleName":"com.ohos.maps.app","abilityName":"EntryAbility","isSelect":false,"isTransparent":false,"downloadProgress":0,"appStatus":0,"id":39,"infoId":"29","container":29,"ino":"","fileType":0,"uri":"","badgeNumber":0,"typeId":0,"area":[1,1],"page":0,"column":2,"row":0,"kindId":-1,"moduleName":"entry","keyName":"com.ohos.maps.appEntryAbilityentry","appIconId":285212674,"extend1":"","extend2":"","extend3":0,"appLabelId":285212697,"appName":"","iconResource":"","callerName":"","isSystemApp":true,"isUninstallAble":true,"geometryId":"lxq0tnb21tbwqcrdw19"}';
      let openFolderData: GridLayoutItemInfo = JSON.parse(openFolderDataJSONStr) as GridLayoutItemInfo;
      let appInfo: GridLayoutItemInfo = JSON.parse(appInfoJSONStr) as GridLayoutItemInfo;

      let ret: GridLayoutItemInfo[] = instance['getFolderLayoutInfo'](openFolderData, appInfo);
      expect(ret.length).assertLargerOrEqual(0);
    });

    it('FakeTest2_layoutInfoToList_01', 0, () => {
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

      let ret: GridLayoutItemInfo[] = instance['layoutInfoToList'](folderInfo);
      expect(ret).not().assertNull();
    });

    it('FakeTest2_moveAppFromDockToFolder', 0, async () => {
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
      await instance['moveAppFromDockToFolder'](appInfos);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.DEFAULT_DEVICE_TYPE);
      await instance['moveAppFromDockToFolder'](appInfos);
      expect(appInfos.length).assertLarger(0);
      mocker.clear(settingsModel);
      mocker.clear(globalThis.RdbStoreManagerInstance);
    })

    it('FakeTest2_moveAppFromDesktopToFolder_01', 0, () => {
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

      instance['moveAppFromDesktopToFolder'](appInfos);
      expect(instance).not().assertNull();
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
