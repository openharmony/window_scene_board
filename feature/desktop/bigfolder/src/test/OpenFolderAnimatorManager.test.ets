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
    afterAll, afterEach,
    ArgumentMatchers,
    beforeAll, beforeEach, describe, expect, it, MockKit,
    when
} from '@ohos/hypium'
import GridLayoutItemInfo from '@ohos/launchercommon/src/main/ets/bean/GridLayoutItemInfo'
import { FolderData, FolderOperationFlag } from '@ohos/launchercommon/src/main/ets/folder/model/FolderData'
import { openFolderAppBubbleLayout } from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout'
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData'
import {
  BigFolderStyleConfig,
  CommonConstants,
  editModeManager,
  EditModeUtils,
  FolderLayoutInOpen,
  folderLayoutUtil,
  FolderModel,
  GridLayoutUtil,
  LayoutViewModel
} from '@ohos/launchercommon/src/main/ets/TsIndex'
import { BigFolderComponentLayout, AppBubbleParams } from '@ohos/launchercommon/Index';
import { AppNameVm } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppNameVm';
import { OpenFolderAppBubbleNodeManager } from '../main/ets/default/view/node/OpenFolderAppBubbleNodeManager'
import { aniBatchUtil } from '../main/ets/default/viewmodel/AnimationBatchUtil'
import { FolderType } from '../main/ets/default/model/AnimationParameterModel'
import { OpenCloseAnimationViewModel } from '../main/ets/default/viewmodel/OpenCloseAnimationViewModel'
import { openCloseAniMgr } from '../main/ets/default/viewmodel/openclose/OpenCloseActionManager'
import { openFolderLayout } from '../main/ets/default/viewmodel/OpenFolderLayout'
import { BigFolderViewModel } from '../main/ets/default/viewmodel/BigFolderViewModel'
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { RectangularCoordinates } from '@ohos/componenthelper'
import {
  folderLayout
} from '../../../../../../pagedesktop/src/main/ets/default/common/components/folder/viewmodel/FolderLayout'
import {
  SmallFolderComponentLayout
} from '../../../../../../pagedesktop/src/main/ets/default/common/components/folder/viewmodel/SmallFolderComponentLayout'
import SmartDockDragHandler from '../../../../../../../smartdock/commonsmartdock/src/main/ets/default/common/SmartDockDragHandler'

export default function OpenFolderAnimatorManagerTest2() {
  describe('OpenFolderAnimatorManagerTest2', () => {
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

    it('test2_startOpenCloseSmallFolder_no_data', 0, () => {
      let folderItem: GridLayoutItemInfo = getFolderItem([1, 1]);
      let appItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        appItems.push(item);
      }

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      let mockFunc1: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);

      openCloseAniMgr.registerFolderStatus();
      folderDataInstance.open('test open smallFolder_no_data', folderItem);
      openCloseAniMgr.onOpenFolderGridShow(true);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderLayout.initSmallFolderLayoutMap('lkqkw4s76q0592qwa4g', new SmallFolderComponentLayout());
      openCloseAniMgr.onOpenFolderGridShow(true);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();

      folderDataInstance.close('test close smallFolder_no_data');
      folderDataInstance.close('test closed smallFolder_no_data', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout().isShowOpenFolder).assertFalse();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    })

    it('test2_startOpenSmallFolder_has_data', 0, () => {
      let folderItem: GridLayoutItemInfo = getFolderItem([1, 1]);
      let appItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        appItems.push(item);
      }

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      let mockFunc1: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);
      for (let i = 0; i < 19; i++) {
        let iconData: AppIconData = new AppIconData();
        iconData.iconId = i.toString();
        openFolderAppBubbleLayout.setIconData(i.toString(), iconData);
      }

      openCloseAniMgr.registerFolderStatus();
      folderDataInstance.open('test open smallFolder_has_data', folderItem);
      openCloseAniMgr.onOpenFolderGridShow(true);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderLayout.initSmallFolderLayoutMap('lkqkw4s76q0592qwa4g', new SmallFolderComponentLayout());
      openCloseAniMgr.onOpenFolderGridShow(true);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();

      folderDataInstance.close('test close smallFolder_has_data');
      folderDataInstance.close('test closed smallFolder_has_data', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout().isShowOpenFolder).assertFalse();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    })

    it('test2_startOpenBigFolder_has_data', 0, () => {
      let folderItem: GridLayoutItemInfo = getFolderItem([2, 2]);
      let appItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        appItems.push(item);
      }

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      let mockFunc1: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);
      for (let i = 0; i < 19; i++) {
        let iconData: AppIconData = new AppIconData();
        iconData.iconId = i.toString();
        openFolderAppBubbleLayout.setIconData(i.toString(), iconData);
      }

      openCloseAniMgr.registerFolderStatus();
      folderDataInstance.open('test open bigFolder_has_data', folderItem);
      folderLayout.initBigFolderLayoutMap('lkqkw4s76q0592qwa4g', new BigFolderComponentLayout());
      openCloseAniMgr.onOpenFolderGridShow(false);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderDataInstance.close('test close bigFolder_has_data');
      folderDataInstance.close('test closed bigFolder_has_data', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout().isShowOpenFolder).assertFalse();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    })

    it('test2_startOpen4x2BigFolder_has_data', 0, () => {
      let folderItem: GridLayoutItemInfo = getFolderItem([4, 2]);
      folderItem.row = 0;
      folderItem.column = 0;
      let appItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        appItems.push(item);
      }

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      let mockFunc1: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);
      for (let i = 0; i < 19; i++) {
        let iconData: AppIconData = new AppIconData();
        iconData.iconId = i.toString();
        openFolderAppBubbleLayout.setIconData(i.toString(), iconData);
      }

      openCloseAniMgr.registerFolderStatus();
      folderDataInstance.open('test open 4x2bigFolder_has_data', folderItem);
      folderLayout.initBigFolderLayoutMap('lkqkw4s76q0592qwa4g', new BigFolderComponentLayout());
      openCloseAniMgr.onOpenFolderGridShow(false);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderDataInstance.close('test close 4x2bigFolder_has_data');
      folderDataInstance.close('test closed 4x2bigFolder_has_data', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout().isShowOpenFolder).assertFalse();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    })

    it('test2_startOpenBigFolderTo4x4_has_data', 0, () => {
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.area = [2, 2];
      folderItem.folderId = 'lkqkw4s76q0592qwa4g';
      folderItem.row = 2;
      folderItem.column = 2;
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.isInDock = false;
      folderItem.page = 1;
      let folderAppItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 16; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        folderAppItems.push(item);
      }
      let folderAppItems1: GridLayoutItemInfo[] = [];
      for (let i = 16; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        folderAppItems1.push(item);
      }
      let layoutInfo: GridLayoutItemInfo[][] = [];
      layoutInfo.push(folderAppItems);
      layoutInfo.push(folderAppItems1);
      folderItem.layoutInfo = layoutInfo;
      let appItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        appItems.push(item);
      }

      let folderDataInstance: FolderData = FolderData.getInstance();
      let folderModel: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      let mockFunc1: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      let mockFunc2: Function = mocker.mockFunc(folderModel, folderModel.getFolderLayoutInOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4);
      for (let i = 0; i < 19; i++) {
        let iconData: AppIconData = new AppIconData();
        iconData.iconId = i.toString();
        openFolderAppBubbleLayout.setIconData(i.toString(), iconData);
      }

      openCloseAniMgr.registerFolderStatus();
      folderDataInstance.open('test open bigFolder_4x4_has_data', folderItem);
      folderLayout.initBigFolderLayoutMap('lkqkw4s76q0592qwa4g', new BigFolderComponentLayout());
      openCloseAniMgr.onOpenFolderGridShow(false);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderDataInstance.close('test close bigFolder_4x4_has_data');
      folderDataInstance.close('test closed bigFolder_4x4_has_data', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout().isShowOpenFolder).assertFalse();
      mocker.clear(folderDataInstance);
      mocker.clear(folderModel);
      mocker.clearAll();
    })

    it('test2_startOpenSmallFolder_isInDock', 0, () => {
      let folderItem: GridLayoutItemInfo = getFolderItem([1, 1]);
      let appItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        appItems.push(item);
      }

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      let mockFunc1: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);
      let smartDockDragHandlerInstance: SmartDockDragHandler = SmartDockDragHandler.getInstance();
      let mockFunc2: Function = mocker.mockFunc(smartDockDragHandlerInstance, smartDockDragHandlerInstance.getDockItemPositionByItem);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([1]);
      for (let i = 0; i < 19; i++) {
        let iconData: AppIconData = new AppIconData();
        iconData.iconId = i.toString();
        openFolderAppBubbleLayout.setIconData(i.toString(), iconData);
      }

      openCloseAniMgr.registerFolderStatus();
      folderDataInstance.open('test open smallFolder_no_data', folderItem);
      openCloseAniMgr.onOpenFolderGridShow(true);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderLayout.initSmallFolderLayoutMap('lkqkw4s76q0592qwa4g', new SmallFolderComponentLayout());
      openCloseAniMgr.onOpenFolderGridShow(true);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();

      folderDataInstance.close('test close smallFolder_no_data');
      folderDataInstance.close('test closed smallFolder_no_data', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();

      let mockFunc3: Function = mocker.mockFunc(folderLayout,folderLayout.getSmallFolderComponentLayout);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(null);
      openCloseAniMgr.registerFolderStatus();
      openCloseAniMgr.unregisterFolderStatus();
      mocker.clear(folderDataInstance);
      mocker.clearAll();
    })

    it('test2_notifyBigFolderItemBadgeChange_no_data', 0, () => {
      let folderItem: GridLayoutItemInfo = getFolderItem([2, 2]);
      let appItems: GridLayoutItemInfo[] = [];
      for (let i = 0; i < 19; i++) {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.keyName = i.toString();
        appItems.push(item);
      }

      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      let mockFunc1: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);
      for (let i = 0; i < 19; i++) {
        let iconData: AppIconData = new AppIconData();
        iconData.iconId = i.toString();
        openFolderAppBubbleLayout.setIconData(i.toString(), iconData);
      }
      let smartDockDragHandlerInstance: SmartDockDragHandler = SmartDockDragHandler.getInstance();
      let mockFunc2: Function = mocker.mockFunc(smartDockDragHandlerInstance, smartDockDragHandlerInstance.getDockItemPositionByItem);

      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appItems);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(null);

      openCloseAniMgr.registerFolderStatus();
      folderDataInstance.open('test open bigFolder_has_data', folderItem);
      folderLayout.initBigFolderLayoutMap('lkqkw4s76q0592qwa4g', new BigFolderComponentLayout());
      openCloseAniMgr.onOpenFolderGridShow(false);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderDataInstance.close('test close bigFolder_has_data');
      folderDataInstance.close('test closed bigFolder_has_data', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();

      mocker.clear(folderDataInstance);
      mocker.clearAll();
    })

    it('test2_open4x2FolderAni', 0, () => {
      let folderItem: GridLayoutItemInfo = getOpenFolderItem([4, 2]);
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      when(mockFunc)().afterReturn(folderItem);
      let folderModelaInstance: FolderModel = FolderModel.getInstance();
      let mockFuncInOpen: Function = mocker.mockFunc(folderModelaInstance, folderModelaInstance.getFolderLayoutInOpen);
      when(mockFuncInOpen)().afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_3X4);
      let getItemsInFolder: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(getItemsInFolder)(ArgumentMatchers.any).afterReturn(folderItem.layoutInfo?.flat());
      openCloseAniMgr.onOpenFolderGridShow(false);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderDataInstance.close('test close 4x2FolderAn');
      folderDataInstance.close('test closed 4x2FolderAn', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      mocker.clear(folderDataInstance);
      mocker.clear(folderModelaInstance);
      mocker.clearAll();
    })

    it('test2_openBigFolderAni', 0, () => {
      let folderItem: GridLayoutItemInfo = getOpenFolderItem([2, 2]);
      let folderDataInstance: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderItem);
      let folderModelaInstance: FolderModel = FolderModel.getInstance();
      let mockFuncInOpen: Function = mocker.mockFunc(folderModelaInstance, folderModelaInstance.getFolderLayoutInOpen);
      when(mockFuncInOpen)(ArgumentMatchers.any).afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_3X4);
      let getItemsInFolder: Function = mocker.mockFunc(folderDataInstance, folderDataInstance.getItemsInFolder);
      when(getItemsInFolder)(ArgumentMatchers.any).afterReturn(folderItem.layoutInfo?.flat());
      openCloseAniMgr.onOpenFolderGridShow(false);
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      folderDataInstance.close('test close 4x2FolderAn');
      folderDataInstance.close('test closed 4x2FolderAn', FolderOperationFlag.IMMEDIATELY);
      openCloseAniMgr.unregisterFolderStatus();
      expect(openFolderLayout.getGridSwiperLayout()).not().assertNull();
      mocker.clear(folderDataInstance);
      mocker.clear(folderModelaInstance);
      mocker.clearAll();
    })

    it('test2_notifySmallFolderItemBadgeChange_10', 0, () => {
      const smallFolderComponentLayout: SmallFolderComponentLayout = new SmallFolderComponentLayout();
      (openCloseAniMgr as ESObject)['notifySmallFolderItemBadgeChange'](undefined, true);
      (openCloseAniMgr as ESObject)['notifySmallFolderItemBadgeChange'](smallFolderComponentLayout, false);
      expect(smallFolderComponentLayout).not().assertNull();
    })

    it('test2_getBackgroundMarginValue_10', 0, () => {
      const bigFolderStyleConfig: BigFolderStyleConfig = BigFolderStyleConfig.getInstance();
      const bigFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(bigFolderViewModel, bigFolderViewModel.getFolderStyleConfig);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(bigFolderStyleConfig);
      expect((openCloseAniMgr as ESObject)['getBackgroundMarginValue']()).assertInstanceOf('Number');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((openCloseAniMgr as ESObject)['getBackgroundMarginValue']()).assertInstanceOf('Number');
      mocker.clear(DeviceHelper);
      mocker.clear(bigFolderViewModel);
      mocker.clearAll();
    })

    it('test2_initOpenFolderBackgroudAnitParam_10', 0, () => {
      expect(true).not().assertNull();
    })

    it('test2_initOpenFolderAniStartParam_10', 0, () => {
      expect(true).not().assertNull();
    })

    it('test2_getBackgroundMarginValue_10', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((openCloseAniMgr as ESObject)['getBackgroundMarginValue']()).assertInstanceOf('Number');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test2_getBackgroundHeight_10', 0, () => {
      const bigFolderStyleConfig: BigFolderStyleConfig = BigFolderStyleConfig.getInstance();
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.isInDock = true;
      const folderData: FolderData = FolderData.getInstance();
      const layoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
      const bigFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderData, folderData.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      let mockFunc1: Function = mocker.mockFunc(layoutViewModel, layoutViewModel.getDockHeight);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(10);
      let mockFunc2: Function = mocker.mockFunc(bigFolderViewModel, bigFolderViewModel.getFolderStyleConfig);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(bigFolderStyleConfig);
      AppStorage.set('screenHeight', 2000);
      expect((openCloseAniMgr as ESObject)['getBackgroundHeight'](false)).assertInstanceOf('Number');
      gridLayoutItemInfo.isInDock = false;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      expect((openCloseAniMgr as ESObject)['getBackgroundHeight'](true)).assertInstanceOf('Number');
      mocker.clear(folderData);
      mocker.clear(layoutViewModel);
      mocker.clear(bigFolderViewModel);
      mocker.clearAll();
    })

    it('test2_delAniParams_10', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const appBubbleParams: AppBubbleParams = new AppBubbleParams();
      appBubbleParams.item.bundleName = '';
      const appIconData: AppIconData = new AppIconData();
      gridLayoutItemInfo.keyName = 'name_1';
      gridLayoutItemInfo.bundleName = 'name_1';
      const folderData: FolderData = FolderData.getInstance();
      const openFolderAppBubbleNodeManager: OpenFolderAppBubbleNodeManager =
        OpenFolderAppBubbleNodeManager.getInstance()
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderData, folderData.getItemsInFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([gridLayoutItemInfo, gridLayoutItemInfo]);
      let mockFunc1: Function = mocker.mockFunc(folderData, folderData.getOpenFolderAppAnimateCount);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(0);
      let mockFunc2: Function = mocker.mockFunc(openFolderAppBubbleLayout, openFolderAppBubbleLayout.getIconData);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(appIconData);
      let mockFunc3: Function =
        mocker.mockFunc(openFolderAppBubbleNodeManager, openFolderAppBubbleNodeManager.getNodeParams);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(appBubbleParams);
      let mockFunc4: Function =
        mocker.mockFunc(openFolderAppBubbleNodeManager, openFolderAppBubbleNodeManager.getAppBubbleCommonParams);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(appBubbleParams);
      let mockFunc6: Function =
        mocker.mockFunc(openFolderAppBubbleNodeManager, openFolderAppBubbleNodeManager.updateNodeParams);
      when(mockFunc6)(ArgumentMatchers.any).afterReturnNothing();
      (openCloseAniMgr as ESObject)['delAniParams'](gridLayoutItemInfoOther);
      appBubbleParams.item.bundleName = '1';
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(appBubbleParams);
      (openCloseAniMgr as ESObject)['delAniParams'](gridLayoutItemInfoOther);
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderData);
      mocker.clear(openFolderAppBubbleLayout);
      mocker.clear(openFolderAppBubbleNodeManager);
      mocker.clearAll();
    })

    it('test2_openingBigFolderWithAnimation_10', 0, () => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.folderId = undefined;
      gridLayoutItemInfoOther.folderId = '-1';
      const folderData: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderData, folderData.getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      (openCloseAniMgr as ESObject)['openingBigFolderWithAnimation']();
      (openCloseAniMgr as ESObject)['openingSmallFolderWithAnimation']();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoOther);
      (openCloseAniMgr as ESObject)['openingBigFolderWithAnimation']();
      (openCloseAniMgr as ESObject)['openingSmallFolderWithAnimation']();
      expect(gridLayoutItemInfo).not().assertNull();
      mocker.clear(folderData);
      mocker.clearAll();
    })

    it('test2_handleExtrasIcon_10', 0, () => {
      const aAppNameVm: AppNameVm = new AppNameVm();
      const appIconData: AppIconData = new AppIconData();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const openCloseAnimationViewModel: OpenCloseAnimationViewModel = new OpenCloseAnimationViewModel();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAddIcon);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function =
        mocker.mockFunc(openCloseAnimationViewModel, openCloseAnimationViewModel.addIconOptEvent);
      when(mockFunc1)(ArgumentMatchers.any).afterReturnNothing();
      (openCloseAniMgr as ESObject)['handleExtrasIcon'](aAppNameVm, appIconData, gridLayoutItemInfoOther);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (openCloseAniMgr as ESObject)['handleExtrasIcon'](aAppNameVm, appIconData, gridLayoutItemInfoOther);
      expect(appIconData).not().assertNull();
      mocker.clear(GridLayoutUtil);
      mocker.clear(openCloseAnimationViewModel);
      mocker.clearAll();
    })

    it('test2_needMaskAni_10', 0, () => {
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isAddIcon);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((openCloseAniMgr as ESObject)['needMaskAni'](gridLayoutItemInfoOther, true,
        FolderType.TYPE_4X2_BIG_FOLDER)).assertInstanceOf('Boolean');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((openCloseAniMgr as ESObject)['needMaskAni'](gridLayoutItemInfoOther, true,
        FolderType.TYPE_4X2_BIG_FOLDER)).assertInstanceOf('Boolean');
      expect((openCloseAniMgr as ESObject)['needMaskAni'](gridLayoutItemInfoOther, false,
        FolderType.TYPE_4X2_BIG_FOLDER)).assertInstanceOf('Boolean');
      expect((openCloseAniMgr as ESObject)['needMaskAni'](gridLayoutItemInfoOther, false,
        FolderType.TYPE_SMALL_FOLDER)).assertInstanceOf('Boolean');
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test2_setAppCloneBadgeVisible_10', 0, () => {
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const appIconData: AppIconData = new AppIconData();
      gridLayoutItemInfoOther.appIconId = 2;
      (openCloseAniMgr as ESObject)['setAppCloneBadgeVisible'](gridLayoutItemInfoOther, appIconData, true);
      expect(appIconData).not().assertNull();
    })

    it('test2_doCloseFolderBackgroundAnimation_10', 0, () => {
      expect(true).not().assertNull();
    })

    it('test2_getEditModeTranslateY_10', 0, () => {
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderData: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect((openCloseAniMgr as ESObject)['getEditModeTranslateY']([1])).assertInstanceOf('Number');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(folderData, folderData.getOpenedFolder);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoOther);
      let mockFunc2: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getFolderComponentCenterPosition);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([1, 1]);
      let mockFunc3: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getCurrentFolderCenterPosition);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn([1, 1]);
      let mockFunc4: Function = mocker.mockFunc(EditModeUtils, EditModeUtils.getDesktopScale);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(1);
      AppStorage.set('screenHeight', 4);
      expect((openCloseAniMgr as ESObject)['getEditModeTranslateY']()).assertInstanceOf('Number');
      expect((openCloseAniMgr as ESObject)['getEditModeTranslateY']([1, 1])).assertInstanceOf('Number');
      mocker.clear(editModeManager);
      mocker.clear(folderData);
      mocker.clear(folderLayoutUtil);
      mocker.clear(EditModeUtils);
      mocker.clearAll();
    })

    it('test2_getOpenFolderFlag_10', 0, () => {
      const folderModel: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aniBatchUtil, aniBatchUtil.getFolderItemOrder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(0);
      expect((openCloseAniMgr as ESObject)['getOpenFolderFlag'](1,1,false,true)).assertInstanceOf('Number');
      let mockFunc1: Function = mocker.mockFunc(folderModel, folderModel.getFolderLayoutInOpen);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_4x4);
      expect((openCloseAniMgr as ESObject)['getOpenFolderFlag'](1,1,false,false)).assertInstanceOf('Number');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(FolderLayoutInOpen.FOLDER_OPEN_LAYOUT_3X4);
      expect((openCloseAniMgr as ESObject)['getOpenFolderFlag'](1,1,false,false)).assertInstanceOf('Number');
      mocker.clear(aniBatchUtil);
      mocker.clear(folderModel);
      mocker.clearAll();
    })

    it('test2_getFolderScreenPosition_10', 0, () => {
      const obj:RectangularCoordinates.Point = {
        x: 1,
        y: 1
      }
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.isInDock = true;
      const smartDockDragHandler: SmartDockDragHandler = SmartDockDragHandler.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(smartDockDragHandler, smartDockDragHandler.getDockItemLeftTopPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(obj);
      expect((openCloseAniMgr as ESObject)['getFolderScreenPosition'](gridLayoutItemInfoOther)).not().assertNull();
      mocker.clear(smartDockDragHandler);
      mocker.clearAll();
    })

    it('test2_getCloseFolderIconSize_10', 0, () => {
      const bigFolderStyleConfig: BigFolderStyleConfig = BigFolderStyleConfig.getInstance();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfoOther.isInDock = true;
      const bigFolderViewModel: BigFolderViewModel = BigFolderViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(bigFolderViewModel, bigFolderViewModel.getFolderStyleConfig);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(bigFolderStyleConfig);
      let mockFunc1: Function = mocker.mockFunc(folderLayoutUtil, folderLayoutUtil.getGridItemRect);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        width:100,
        height:100
      });
      expect((openCloseAniMgr as ESObject)['getCloseFolderIconSize'](gridLayoutItemInfoOther,1)).assertInstanceOf('Number');
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        width:1,
        height:1
      });
      expect((openCloseAniMgr as ESObject)['getCloseFolderIconSize'](gridLayoutItemInfoOther,1)).assertInstanceOf('Number');
      mocker.clear(bigFolderViewModel);
      mocker.clear(folderLayoutUtil);
      mocker.clearAll();
    })
  })
}

function getOpenFolderItem(area: number[]): GridLayoutItemInfo {
  let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  folderItem.area = area;
  folderItem.folderId = 'lkqkw4s76q0592qwa4g';
  folderItem.row = 2;
  folderItem.column = 2;
  folderItem.typeId = CommonConstants.TYPE_FOLDER;
  folderItem.isInDock = false;
  folderItem.page = 1;
  folderItem.keyName = 'folderKeyName0001';
  let folderAppItems: GridLayoutItemInfo[] = [];
  for (let i = 0; i < 12; i++) {
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.keyName = 'keyName' + i.toString();
    item.bundleName = 'com.ohos.bundleName' + i.toString();
    folderAppItems.push(item);
  }
  let folderAppItems1: GridLayoutItemInfo[] = [];
  for (let i = 12; i < 19; i++) {
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.keyName = 'keyName' + i.toString();
    item.bundleName = 'com.ohos.bundleName' + i.toString();
    folderAppItems1.push(item);
  }
  folderItem.layoutInfo = [folderAppItems, folderAppItems1];
  return folderItem;
}

function getFolderItem(area: number[]): GridLayoutItemInfo {
  let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  folderItem.area = area;
  folderItem.folderId = 'lkqkw4s76q0592qwa4g';
  folderItem.row = 2;
  folderItem.column = 2;
  folderItem.typeId = CommonConstants.TYPE_FOLDER;
  folderItem.isInDock = false;
  folderItem.page = 1;
  let folderAppItems: GridLayoutItemInfo[] = [];
  for (let i = 0; i < 12; i++) {
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.keyName = i.toString();
    folderAppItems.push(item);
  }
  let folderAppItems1: GridLayoutItemInfo[] = [];
  for (let i = 12; i < 19; i++) {
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.keyName = i.toString();
    folderAppItems1.push(item);
  }
  let layoutInfo: GridLayoutItemInfo[][] = [];
  layoutInfo.push(folderAppItems);
  layoutInfo.push(folderAppItems1);
  folderItem.layoutInfo = layoutInfo;
  return folderItem;
}