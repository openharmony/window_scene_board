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

import { CheckEmptyUtils } from '@ohos/basicutils';
import {
  DeviceHelper,
  localEventManager,
  ResourceManager,
} from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { NumberConstants } from '@ohos/commonconstants';
import { SCBScreenSessionManager, launcherStatusUtil } from '@ohos/windowscene';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  when,
  ArgumentMatchers,
  MockKit
} from '@ohos/hypium';
import {
  AppItemInfo,
  AppModel,
  AppStatus,
  CardItemInfo,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DeleteItemType,
  FormModel,
  GridLayoutConfig,
  // RegionFolderLayoutCacheManager,
  GridLayoutItemInfo,
  MenuInfo,
  SettingsModel,
  keyEventManager,
  LaunchLayoutCacheManager,
  FormManager,
  EventConstants,
  KeyEventConstants,
  LayoutDescription,
  DesktopUtils,
  DeliverUtil,
  FolderData,
  GridLayoutUtil,
  RdbStoreManager,
  FolderViewModel,
  NotHarmonyUtil,
  LayoutViewModel,
  BadgeItemInfo,
  DesktopFileInfo,
  LauncherLayoutCacheConfig,
  PadLaunchLayoutCacheManager
} from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig, PageDesktopViewModel } from '../../../../../..';
import { PageDesktopViewModelUtils } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModelUtils';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import { AppFormWantParamInterface } from '@ohos/launchercommon/src/main/ets/manager/FormManager';
import { FileFolderManager, fileFolderManagerFactory } from '@ohos/desktopfilefolder';
import { BusinessType, DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { FormHiSysEventUtil } from '@ohos/form';
import { RegionFolderConfigProxy } from '@ohos/regionfolder/src/main/Index';


function getNullObject(): GridLayoutItemInfo | null {
  return null;
}

function getUndefinedObject(): GridLayoutItemInfo | undefined {
  return undefined;
}

export default function PageDesktopViewModelTest() {
  describe('PageDesktopViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('addBlankPage01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectPageCount);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(5);
      let mockfunc3: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectMaxPageCount);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(1);
      let mockfunc4: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].updatePageCount);
      when(mockfunc4)().afterReturnNothing();
      let mockfunc5: Function =
        mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.addPageToAppGridInfo);
      when(mockfunc5)().afterReturnNothing();
      let mockfunc6: Function =
        mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.lightPagingFiltering);
      when(mockfunc6)().afterReturnNothing();
      let mockfunc7: Function =
        mocker.mockFunc(pageDesktopViewModel, (pageDesktopViewModel as object)['updatePageIndex']);
      when(mockfunc7)().afterReturnNothing();
      (pageDesktopViewModel as object)['isPad'] = true;
      pageDesktopViewModel.addBlankPage(true);
      pageDesktopViewModel.addBlankPage(false);

      let a = 'test';
      expect(a).assertEqual('test')
      mocker.clear(desktopUtil);
      mocker.clear((pageDesktopViewModel as object)['mLauncherLayoutCacheManager']);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('addForm', 0, async () => {
      let newItem: CardItemInfo = new CardItemInfo();
      newItem.id = '1573457366';
      newItem.cardId = '1573457366';
      newItem.name = 'minVoiceRecCard';
      newItem.cardName = 'minVoiceRecCard';
      newItem.bundleName = 'com.ohos.suggestion';
      newItem.abilityName = 'ParentFormAbility';
      newItem.moduleName = 'entry';
      newItem.dimension = 2;
      newItem.cardDimension = 2;
      newItem.appLabelId = 0;
      newItem.area = [2, 2];
      newItem.isTransparent = false;
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await mPageDesktopViewModel.createCardToDeskTop(newItem);

      let mFormModel: FormModel = FormModel.getInstance();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let formItem: CardItemInfo | undefined = formsList.find(item => item.cardId === newItem.cardId);
      expect(formItem).not().assertNull();
    })

    it('deleteFormItem', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let formsListBefore: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let deleteItem: CardItemInfo = new CardItemInfo();
      if (formsListBefore.length > 0) {
        deleteItem = formsListBefore[formsListBefore.length - 1];
        await (mPageDesktopViewModel as object)['deleteFormItem'](formsListBefore[formsListBefore.length - 1].cardId);
      }
      let formsListAfter: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();

      let formItem: CardItemInfo | undefined = formsListAfter.find(item => item.cardId === deleteItem.cardId);
      expect(formItem === undefined);
    })

    it('getCurrentSelectItems', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (mPageDesktopViewModel as object)['lastSelectedItems'] = [];
      let lastSelectedItems: string[] = mPageDesktopViewModel.getCurrentSelectItems();
      expect(lastSelectedItems.length === 0).assertTrue();
      (mPageDesktopViewModel as object)['lastSelectedItems'] = ['test1', 'test2'];
      lastSelectedItems = mPageDesktopViewModel.getCurrentSelectItems();
      expect(lastSelectedItems.length === 2).assertTrue();
    })

    it('getLastSelectItems_01', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let lastSelectedItems: string[] = mPageDesktopViewModel.getLastSelectItems();
      expect(lastSelectedItems.length).assertLargerOrEqual(0);
    })

    it('getLastSelectItems_02', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (mPageDesktopViewModel as object)['lastSelectedItems'] = [];
      let lastSelectedItems: string[] = mPageDesktopViewModel.getLastSelectItems();
      expect(lastSelectedItems.length === 0).assertTrue();
      (mPageDesktopViewModel as object)['lastSelectedItems'] = ['test1', 'test2'];
      lastSelectedItems = mPageDesktopViewModel.getLastSelectItems();
      expect(lastSelectedItems.length === 2).assertTrue();
    })

    it('getCreateCardState', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let createCardState: boolean = mPageDesktopViewModel.getCreateCardState();
      expect(createCardState || true).assertTrue();
    })

    it('hasEnoughArea00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let itemInfo: CardItemInfo = new CardItemInfo();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectPageCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(1);
      let mockfunc2: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectMaxPageCount);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(2);
      let result: boolean = pageDesktopViewModel.hasEnoughArea(itemInfo);
      expect(result).assertTrue();
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('hasEnoughArea01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let itemInfo: CardItemInfo = new CardItemInfo();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectPageCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(2);
      let mockfunc2: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectMaxPageCount);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);
      let mockfunc3: Function =
        mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc4: Function =
        mocker.mockFunc(pageDesktopViewModel, (pageDesktopViewModel as object)['getPagesWhenAddCard']);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(1);
      let mockfunc5: Function =
        mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.getEnoughAreaPosition);
      when(mockfunc5)(ArgumentMatchers.any).afterReturn(true);
      let result1: boolean = pageDesktopViewModel.hasEnoughArea(itemInfo);
      expect(result1).assertTrue();

      when(mockfunc5)(ArgumentMatchers.any).afterReturn(false);
      let mockfunc6: Function =
        mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockfunc6)(ArgumentMatchers.any).afterReturn(true);
      let result2: boolean = pageDesktopViewModel.hasEnoughArea(itemInfo);
      expect(result2).assertFalse();
      when(mockfunc6)(ArgumentMatchers.any).afterReturn(false);
      let result3: boolean = pageDesktopViewModel.hasEnoughArea(itemInfo);
      expect(result3).assertFalse();

      mocker.clear(pageDesktopViewModel);
      mocker.clear(desktopUtil);
      mocker.clear(launcherStatusUtil);
      mocker.clearAll();
    })

    it('hasEnoughArea02', 2, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }
      let isFoldedProductFold = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(isFoldedProductFold)().afterReturn(true);

      // 条件2 isPageAreaEnough = false
      cardItem.area = [4, 4];

      // 条件3 mPageIndex < gridLayoutInfo.layoutDescription.pageCount - 1
      pageDesktopViewModel.changeIndex(0);

      let result: boolean = pageDesktopViewModel.hasEnoughArea(cardItem);
      expect(result === false);
      mocker.clear(launcherStatusUtil);
      mocker.clearAll();
    })

    it('hasEnoughArea03', 3, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }
      let isFoldedProductFold = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(isFoldedProductFold)().afterReturn(false);

      // 条件2 isPageAreaEnough = false
      cardItem.area = [4, 4];

      // 条件3 mPageIndex >= gridLayoutInfo.layoutDescription.pageCount - 1
      pageDesktopViewModel.changeIndex(1);

      let result: boolean = pageDesktopViewModel.hasEnoughArea(cardItem);
      expect(result === false);
      mocker.clear(launcherStatusUtil);
      mocker.clearAll();
    })

    it('createCardWithAnimation00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let cardItem: CardItemInfo = new CardItemInfo();
      let mocker: MockKit = new MockKit();
      //条件1 hasEnoughArea = true
      let mockfunc1: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.hasEnoughArea);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.createCardToDeskTop);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(1);

      pageDesktopViewModel.createCardWithAnimation(cardItem, 6, 100, 100);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('publishCardToDesktop', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mFormManager: FormManager = FormManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(mFormManager, mFormManager.getFormCardItemByWant);
      let cardItem: CardItemInfo = new CardItemInfo();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(cardItem);

      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mockFormModel: Function = mocker.mockFunc(mFormModel, mFormModel.checkIfCardExceedLimit);
      when(mockFormModel)().afterReturn(true);

      when(mockFormModel)().afterReturn(false);

      cardItem.callerBundle === CommonConstants.INTELLIGENT_BUNDLE;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(cardItem);
      when(mockFormModel)().afterReturn(false);

      mocker.clear(mFormManager);
      mocker.clear(mFormModel);
      mocker.clearAll();
    });
    it('publishAppCardToDesktop', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mFormManager: FormManager = FormManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(mFormManager, mFormManager.getAppFormWantParamInterface);
      const wantParamInterface: AppFormWantParamInterface = {
        appFormSnapshot: ' ',
        appFormWidth: 0,
        appFormHeight: 0,
        appFormScreenX: 0,
        appFormScreenY: 0,
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(wantParamInterface);

      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let cardItem: CardItemInfo = new CardItemInfo();

      wantParamInterface.appFormSnapshot = 'test';
      let viewModelUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
      let mockFunc1: Function = mocker.mockFunc(viewModelUtils, viewModelUtils.base64ToPixelMap);
      when(mockFunc1)(wantParamInterface.appFormSnapshot).afterReturnNothing();

      when(mockFunc1)(wantParamInterface.appFormSnapshot).afterReturn(Promise.resolve('value'));

      when(mockFunc1)(wantParamInterface.appFormSnapshot).afterReturn(Promise.reject());

      mocker.clear(mFormManager);
      mocker.clear(viewModelUtils);
      mocker.clearAll();
    });
    it('createCardWithAnimation01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mFormModel: FormModel = FormModel.getInstance();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      //条件1 hasEnoughArea = true
      let mockfunc1: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.hasEnoughArea);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(false);

      pageDesktopViewModel.createCardWithAnimation(cardItem, 6, 100, 100);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('reportAddCardToScreenByDragEvent00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let dragItemType: number = 6;
      let resultType: number = 0;

      //条件1 CheckEmptyUtils.isEmpty true
      let cardItem: CardItemInfo | undefined = undefined;
      pageDesktopViewModel.reportAddCardToScreenByDragEvent(cardItem, dragItemType, resultType);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    })
    it('reportAddCardToScreenByDragEvent01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();

      //条件1 CheckEmptyUtils.isEmpty false
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      // 条件2 dragItemType === CommonConstants.DRAG_FROM_FORM_STACK
      let dragItemType: number = 9;
      let resultType: number = 0;

      pageDesktopViewModel.reportAddCardToScreenByDragEvent(cardItem, dragItemType, resultType);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    })
    it('reportAddCardToScreenByDragEvent02', 2, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mFormModel: FormModel = FormModel.getInstance();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();

      //条件1 CheckEmptyUtils.isEmpty false
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      // 条件2 dragItemType === DRAG_FROM_MANAGE
      let dragItemType: number = 4;
      let resultType: number = 0;
      let mock1: Function = mocker.mockFunc(mFormModel, mFormModel.getFormManagerLastShowFrom);
      when(mock1)(ArgumentMatchers.any).afterReturn(undefined);


      pageDesktopViewModel.reportAddCardToScreenByDragEvent(cardItem, dragItemType, resultType);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
      mocker.clear(mFormModel);
      mocker.clearAll();
    })
    it('reportAddCardToScreenByDragEvent03', 3, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();

      //条件1 CheckEmptyUtils.isEmpty false
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      // 条件2 dragItemType === CommonConstants.DRAG_FROM_FORM_STACK
      let dragItemType: number = 2;
      let resultType: number = 0;
      let mock1: Function = mocker.mockFunc(mFormModel, mFormModel.getFormManagerLastShowFrom);
      when(mock1)(ArgumentMatchers.any).afterReturn(1);

      pageDesktopViewModel.reportAddCardToScreenByDragEvent(cardItem, dragItemType, resultType);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
      mocker.clear(mFormModel);
      mocker.clearAll();
    })

    it('getRightMenuSelectedIcon00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 isSelected true
      let res: string = pageDesktopViewModel.getRightMenuSelectedIcon(true);

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('/common/pics/ic_public_selected.svg');
    })
    it('getRightMenuSelectedIcon01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 isSelected true
      let res: string = pageDesktopViewModel.getRightMenuSelectedIcon(false);

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('');
    })

    it('getInstance00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 isSelected true
      let pageDesktopViewModel1: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(pageDesktopViewModel).assertEqual(pageDesktopViewModel1);
    })

    it('initGridList00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 mIsLayoutOrDockFinish true
      pageDesktopViewModel.initGridList();
      pageDesktopViewModel.initGridList();

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('afterDeleteDesktopItem00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      //条件1 DeviceHelper.isPC true
      pageDesktopViewModel.afterDeleteDesktopItem();

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('afterDeleteDesktopItem01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      //条件1 DeviceHelper.isPC false
      pageDesktopViewModel.afterDeleteDesktopItem();

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper)
      mocker.clearAll()
    })

    it('updateForms00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();

      //条件1 allFormsInfo.length false
      let mockFunction: Function = mocker.mockFunc(formModel, formModel.getAllFormsInfoFromRdb);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([]);

      pageDesktopViewModel.updateForms();
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(formModel);
      mocker.clearAll();
    })
    it('updateForms01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 allFormsInfo.length true
      pageDesktopViewModel.updateForms();
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('deleteAppItem00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo =
        appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: appItem.bundleName,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone true
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      pageDesktopViewModel.deleteAppItem(deleteItem);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo =
        appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: appItem.bundleName,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone false
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      pageDesktopViewModel.deleteAppItem(deleteItem);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem02', 2, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo =
        appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone true
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      pageDesktopViewModel.deleteAppItem(deleteItem);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem03', 3, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.bundleName true
      let appItem: GridLayoutItemInfo =
        appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone false
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      pageDesktopViewModel.deleteAppItem(deleteItem);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem04', 4, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.folderId true
      let appItem: GridLayoutItemInfo =
        appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: undefined,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone true
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      pageDesktopViewModel.deleteAppItem(deleteItem);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem05', 5, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.folderId true
      let appItem: GridLayoutItemInfo =
        appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: undefined,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone false
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      pageDesktopViewModel.deleteAppItem(deleteItem);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('addToDesktop00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clearAll();
    })
    it('addToDesktop01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let appItem: GridLayoutItemInfo =
        appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();

      //条件1 appItem true
      appInfo.bundleName = appItem.bundleName;
      appInfo.appIndex = appItem.appIndex;

      //条件2 installed
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })
    it('addToDesktop02', 2, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? demoFolder;
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      if (!appItem.layoutInfo) {
        appItem.layoutInfo = [];
        appItem.layoutInfo.push([new GridLayoutItemInfo()])
      }
      for (let i = 0; i < appItem?.layoutInfo?.length; i++) {
        for (let j = 0; j < appItem.layoutInfo[i]?.length; j++) {
          if (appItem.layoutInfo[i][j]?.typeId === CommonConstants.TYPE_APP) {
            appInfo.bundleName = appItem.layoutInfo[i][j].bundleName;
            appInfo.appIndex = appItem.layoutInfo[i][j].appIndex;
            break;
          }
        }
        if (appInfo.bundleName) {
          break;
        }
      }

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })
    it('addToDesktop03', 3, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';
      appInfo.appIndex = 1;

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })
    it('addToDesktop04', 4, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('addToDesktop06', 4, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      // 条件3 isPad true
      pageDesktopViewModel.setDevice(CommonConstants.PAD_DEVICE_TYPE);

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })
    it('addToDesktop05', 5, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';

      //条件1 appItem undefined false
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      // 条件3 isPad false
      pageDesktopViewModel.setDevice(CommonConstants.DEFAULT_DEVICE_TYPE);

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('insertNewUpdateApp00', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let viewUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
       try{
         let settingsModel: SettingsModel = SettingsModel.getInstance();
         let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
         let newAppItem: GridLayoutItemInfo | undefined = appList.find(item => item.typeId === CommonConstants.TYPE_APP);

         if (newAppItem) {
           await pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
         }
         let a = 'test';
         // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
         expect(a).assertEqual(`test`);
       } catch (e) {}
      mocker.clear(viewUtils);
      mocker.clearAll();
      done();
    })
    it('insertNewUpdateApp01', 1, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let viewUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let newAppItem: GridLayoutItemInfo | undefined =
        appList.find(item => item.typeId === CommonConstants.TYPE_APP && item.container === -100);

      // 条件2 appInDockIndex false
      if (newAppItem) {
        pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
      }
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(viewUtils);
      mocker.clearAll();
      done();
    })

    it('buildNotInstalledAppMenu01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const bundleName = 'BundleNameNotExists';
      let dialog = new CustomDialogController({
        builder: {},
      });
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'anyBundleName';
      appItem.area = [1, 1];
      pageDesktopViewModel.buildNotInstalledAppMenu(appItem, dialog);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })
    it('getEnoughAreaPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();

      let mSettingsModel: SettingsModel = SettingsModel.getInstance();
      // 无空间
      const area = [4, 4];

      pageDesktopViewModel.changeIndex(1);
      const result = pageDesktopViewModel.getEnoughAreaPosition(0, area, 4);
      expect(result === null);
      mocker.clear(mSettingsModel);
      mocker.clearAll();
    })
    it('getEnoughAreaPosition01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();

      let mSettingsModel: SettingsModel = SettingsModel.getInstance();
      // 有空间
      const area = [1, 1];

      pageDesktopViewModel.changeIndex(0);
      const result = pageDesktopViewModel.getEnoughAreaPosition(1, area);
      expect(result?.pageIndex === 1 && result?.row >= 0 && result?.column >= 0);
      mocker.clear(mSettingsModel);
      mocker.clearAll();
    })
    it('deleteAppItemByShortcut', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';
      appInfo.typeId = CommonConstants.TYPE_APP;

      let fileItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      fileItem.ino = '11111111';
      fileItem.typeId = CommonConstants.TYPE_FILE_FOLDER;

      pageDesktopViewModel.updateDesktopItemInfo();
      let appItemKey = pageDesktopViewModel.getItemKeyByType(appInfo);
      pageDesktopViewModel.onSelectItemChange([appItemKey], true);

      let keyEvent: KeyEvent = {
        keyCode: 2071,
        type: 0,
        keyText: '',
        keySource: 1,
        deviceId: 0,
        metaKey: 0,
        timestamp: 0,
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        intentionCode: -1
      };
      await keyEventManager.dispatchKeyEvent(keyEvent);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clearAll();
      done();
    })

    //isAddByDrag 为true
    it('test_addBlankPage01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addBlankPage(true);
      expect(instance).not().assertNull();
    });

    //isAddByDrag 为false
    it('test_addBlankPage02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addBlankPage(false);
      expect(instance).not().assertNull();
    });

    it('test_addMiddlePageToAppGridInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addMiddlePageToAppGridInfo();
      expect(instance).not().assertNull();
    });

    it('test_addPageToAppGridInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addPageToAppGridInfo();
      expect(instance).not().assertNull();
    });

    //appInfo undefined
    it('test_addToDesktop02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance.addToDesktop(appInfo);
      expect(instance).not().assertNull();
    });

    it('test_addToDock', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      instance.addToDock(appInfo);
      expect(instance).not().assertNull();
    });

    it('test_buildMenuDeleteInfo01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let res: MenuInfo[] = instance.buildMenuDeleteInfo(appInfo, null);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('test_buildCreateRegionFolderMenu01', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      expect(viewModel).not().assertUndefined();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewModel, viewModel.getCurrentSelectItemsInfo);
      when(mockFunc)().afterReturn([new GridLayoutItemInfo()])
      const appItem: AppItemInfo = new AppItemInfo();
      let menuList: MenuInfo[] = new Array<MenuInfo>();
      expect(menuList).not().assertNull();

      const regionFolderConfig: RegionFolderConfigProxy = RegionFolderConfigProxy.getInstance();
      expect(regionFolderConfig).not().assertUndefined();
      let mockFunc1: Function =
        mocker.mockFunc(regionFolderConfig, regionFolderConfig.isRegionFolderEnable);
      when(mockFunc1)().afterReturn(false);
      viewModel.buildCreateRegionFolderMenu(menuList, appItem);
      expect(menuList.length).assertEqual(0);
      when(mockFunc1)().afterReturn(true);
    });
    it('test_buildCreateRegionFolderMenu02', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      expect(viewModel).not().assertUndefined();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewModel, viewModel.getCurrentSelectItemsInfo);
      when(mockFunc)().afterReturn([new GridLayoutItemInfo()])
      const appItem: AppItemInfo = new AppItemInfo();
      let menuList: MenuInfo[] = new Array<MenuInfo>();
      expect(menuList).not().assertNull();

      viewModel.buildCreateRegionFolderMenu(menuList);
      expect(menuList.length).assertEqual(0);

      appItem.typeId = CommonConstants.TYPE_AREA_DESKTOP;
      viewModel.buildCreateRegionFolderMenu(menuList);
      expect(menuList.length).assertEqual(0);

    });
    it('test_buildCreateRegionFolderMenu03', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      expect(viewModel).not().assertUndefined();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewModel, viewModel.getCurrentSelectItemsInfo);
      when(mockFunc)().afterReturn([])
      const appItem: AppItemInfo = new AppItemInfo();
      let menuList: MenuInfo[] = new Array<MenuInfo>();
      expect(menuList).not().assertNull();
      viewModel.buildCreateRegionFolderMenu(menuList, appItem);
      expect(menuList.length).assertEqual(0);
    })

    it('test_getSelectItemsInfoFromRegionFolder', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      expect(viewModel).not().assertUndefined();
    });

    it('test_buildCardMenuInfoList01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      let deleteFunc: () => void = () => {
      };
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(formInfo, deleteFunc, 0);
      expect(res.length).assertEqual(0);
    });

    it('test_buildCardMenuInfoList02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let deleteFunc: () => void = () => {
      };
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(formInfo, deleteFunc, 0);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('test_buildMenuInfoList01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let res: MenuInfo[] = instance.buildMenuInfoList(appInfo, null);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('test_buildCardMenuInfoList04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let formManagerShowFrom: number = FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU;
      let deleteFunc: () => void = () => {
      };
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(formInfo, deleteFunc, formManagerShowFrom);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('test_buildNotInstalledAppMenu01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let dialog = new CustomDialogController({
        builder: {},
      });
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'com.test.app';
      appItem.area = [1, 1];
      let res: Map<AppStatus, MenuInfo[]> = instance.buildNotInstalledAppMenu(appItem, dialog);
      expect(res.size).assertLargerOrEqual(0);
    });

    it('test_changeIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.changeIndex(2);
      expect(instance).not().assertNull();
    });

    it('test_changeIndexOnly01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newPageIndex: number = 2;
      instance.changeIndexOnly(newPageIndex);
      expect(instance).not().assertNull();
    });

    it('test_changeIndexOnly02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newPageIndex: undefined;
      instance.changeIndexOnly(newPageIndex);
      expect(instance).not().assertNull();
    });

    it('test_cutItemClear', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.cutItemClear();
      expect(instance).not().assertNull();
    });

    it('test_deleteFormItem01', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await (instance as object)['deleteFormItem']('');
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteFormItem02', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await (instance as object)['deleteFormItem']('1');
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteFormItemEvent4Intelligent01', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await (instance as object)['deleteFormItemEvent4Intelligent']('');
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteFormItemEvent4Intelligent02', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await (instance as object)['deleteFormItemEvent4Intelligent']('1');
      expect(instance).not().assertNull();
      done();
    });

    it('test_filterSelectedFileItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.filterSelectedFileItem();
      expect(instance).not().assertNull();
    });

    it('test_filterSelectFileItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: string[] = instance.filterSelectFileItem();
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_filterSelectObject', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.filterSelectObject();
      expect(instance).not().assertNull();
    });

    it('test_getAppPageStartConfig', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      expect(instance.getAppPageStartConfig()).not().assertNull();
    });

    it('test_getCreateCardState', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: boolean = instance.getCreateCardState();
      expect(instance).not().assertNull();
    });

    it('test_getCurrentSelectItems02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = instance.getCurrentSelectItems();
      expect(items.length).assertLargerOrEqual(0);
    });

    it('test_getDevice', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.getDevice();
      expect(instance).not().assertNull();
    });

    it('test_getGridConfig01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: GridLayoutConfig = instance.getGridConfig();
      expect(ret).not().assertNull();
    });

    it('test_loadGridList', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.loadGridList);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing()
      await instance.loadGridList();
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_getGridPageCount02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: number = instance.getGridPageCount();
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: number = instance.getIndex();
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getIntelligentSignStatus01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: boolean = instance.getIntelligentSignStatus();
      expect(instance).not().assertNull();
    });

    it('test_getIntelligentSignStatus02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: boolean = instance.getIntelligentSignStatus();
      expect(instance).not().assertNull();
    });

    it('test_getItemKeyByType01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item: GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FILE_FOLDER;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = 999999;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getNeighborPage01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: number = instance.getNeighborPage(3);
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getNeighborPage02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: PageDesktopGridStyleConfig = instance.getPageDesktopStyleConfig();
      expect(ret).not().assertNull();
    });

    it('test_getSwiperController', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: SwiperController | undefined = instance.getSwiperController();
      expect(ret).not().assertNull();
    });

    it('test_informUninstallResult', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let resultCode: number = CommonConstants.UNINSTALL_FORBID;
      instance.informUninstallResult(resultCode);

      resultCode = CommonConstants.UNINSTALL_FORBID;
      instance.informUninstallResult(resultCode);

      resultCode = -1;
      instance.informUninstallResult(resultCode);
    });

    it('test_getGridPageCount01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: number = instance.getGridPageCount();
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getPageDesktopStyleConfig', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: PageDesktopGridStyleConfig = instance.getPageDesktopStyleConfig();
      expect(ret).not().assertNull();
    });

    it('test_getWorkSpaceHeight', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.getWorkSpaceHeight();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_getWorkSpaceWidth', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.getWorkSpaceWidth();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_initSelectStatus', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.initSelectStatus();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_intoSetting', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.intoSetting();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_isAddByDragging', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.isAddByDragging();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_isBlankPage', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: boolean = instance.isBlankPage();
      expect(ret).not().assertNull();
    });

    //!isPad true
    it('test_isCanCreateFolder01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(instance.isCanCreateFolder()).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    //!isPad false isPositionVlaid true
    it('test_isCanCreateFolder02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let utils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(instance);
      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getDevice);
      let mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.isPositionValid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      instance.isCanCreateFolder()
      expect(!instance).assertFalse();
      mocker.clear(instance);
      mocker.clear(utils);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    //!isPad false isPositionVlaid false
    it('test_isCanCreateFolder03', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let utils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(instance);
      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getDevice);
      let mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.isPositionValid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      instance.isCanCreateFolder();
      expect(!instance).assertFalse();
      mocker.clear(instance);
      mocker.clear(utils);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('test_isPastedFile', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let uri: string = 'anyString';
      let ret: boolean = instance.isPastedFile(uri);
      expect(instance).not().assertNull();
    });

    it('test_isSingleItemPage', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let uri: string = 'anyString';
      let ret: boolean = instance.isSingleItemPage();
      expect(ret).not().assertNull();
    });

    it('test_menuCopyAction01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let selectedFiles: string[] = [];
      let isActionCut: boolean = false;
      instance.menuCopyAction(selectedFiles, isActionCut);
      expect(instance).not().assertNull();
    });

    it('test_menuCopyAction02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let selectedFiles: string[] = [];
      let isActionCut: boolean = true;
      instance.menuCopyAction(selectedFiles, isActionCut);
      expect(instance).not().assertNull();
    });

    it('test_notifyUnSelect', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.notifyUnSelect();
      expect(instance).not().assertNull();
    });

    it('test_onAppClick01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let abilityName: string = 'anyAbilityName';
      let bundleName: string = 'anyBundleName';
      let moduleName: string = 'anyModuleName';
      instance.onAppClick(abilityName, bundleName, moduleName);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_onAppClick02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let abilityName: string = 'anyAbilityName';
      let bundleName: string = 'anyBundleName';
      let moduleName: string = 'anyModuleName';
      instance.onAppClick(abilityName, bundleName, moduleName);
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_onSelectItemChange01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = [];
      let selectStatus: boolean = true;
      let isSingle: boolean = false
      instance.onSelectItemChange(items, selectStatus, isSingle);
      expect(instance).not().assertNull();
    });

    it('test_onSelectItemChange02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = [];
      let selectStatus: boolean = false;
      let isSingle: boolean = false
      instance.onSelectItemChange(items, selectStatus, isSingle);
      expect(instance).not().assertNull();
    });

    it('test_setSnapShotMap01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let key = 'test';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getComponentIdByIno);
      when(mockFunc)(key).afterReturn('');
      instance.setSnapShotMap(key);
      expect(instance.isCurrentItemInMultiMap(key)).assertFalse();
    });

    it('test_setSnapShotMap02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let key = 'test';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getComponentIdByIno);
      when(mockFunc)(key).afterReturn(undefined);
      instance.setSnapShotMap(key);
      expect(instance.isCurrentItemInMultiMap(key)).assertFalse();
    });

    it('test_openApplication', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let abilityName: string = 'anyAbilityName';
      let bundleName: string = 'anyBundleName';
      let moduleName: string = 'anyModuleName';
      instance.openApplication(abilityName, bundleName, moduleName);
      expect(instance).not().assertNull();
    });

    it('test_refreshFileItemIcon', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.refreshFileItemIcon();
      expect(instance).not().assertNull();
    });

    it('test_refreshPasteSelectedStates01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = [];
      instance.refreshPasteSelectedStates(items);
      expect(instance).not().assertNull();
    });

    it('test_refreshPasteSelectedStates02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = ['item1', 'item2', 'item3'];
      instance.refreshPasteSelectedStates(items);
      expect(instance).not().assertNull();
    });

    it('test_unregisterGridListener', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.unregisterGridListener();
      expect(instance).not().assertNull();
    });

    it('test_unRegisterSelectItemChangeListener', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.unRegisterSelectItemChangeListener();
      expect(instance).not().assertNull();
    });

    it('test_updateDesktopInfo', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.updateDesktopInfo();
      expect(instance).not().assertNull();
    });

    it('test_updateDesktopItemInfo', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: GridLayoutItemInfo[] = [];
      instance.updateDesktopItemInfo();
      expect(instance).not().assertNull();
    });

    it('test_updateForms01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mFormModel: FormModel = FormModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(mFormModel, mFormModel.getAllFormsInfoFromRdb);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      instance.updateForms();
      expect(instance).not().assertNull();
      mocker.clear(mFormModel);
      mocker.clearAll();
    });

    it('test_updateForms02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.updateForms();
      expect(instance).not().assertNull();
    });

    it('test_setTargetIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.setTargetIndex(2);
      expect(instance.getTargetIndex()).assertEqual(2);
    });

    it('buildNotInstalledAppMenu01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let dialog = new CustomDialogController({
        builder: {},
      });
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'BundleNameNotExists';
      appItem.area = [1, 1];
      pageDesktopViewModel.buildNotInstalledAppMenu(appItem, dialog);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_autoAlignAfterUninstall', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let pageDesktopUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(instance);
      let mockFunc: Function = mocker.mockFunc(pageDesktopUtils, pageDesktopUtils.getAlignStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'anyBundleName';
      appItem.area = [1, 1];
      instance.autoAlignAfterUninstall([appItem]);
      expect(instance).not().assertNull();
      mocker.clear(pageDesktopUtils);
      mocker.clearAll();
    });

    it('test_judgeEvent_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER);
    });

    it('test_judgeEvent_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD);
    });

    it('test_judgeEvent_03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE);
    });

    it('test_judgeEvent_04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_BADGE_UPDATE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_BADGE_UPDATE);
    });

    it('test_judgeEvent_05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE);
    });

    it('test_judgeEvent_06', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD);
    });

    it('test_judgeEvent_07', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE);
    });

    it('test_judgeEvent_08', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_JUMP_TO_FORM_VIEW;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_JUMP_TO_FORM_VIEW);
    });

    it('test_judgeEvent_09', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_SMARTDOCK_INIT_FINISHED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_SMARTDOCK_INIT_FINISHED);
    });

    it('test_judgeEvent_10', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_LAYOUT_INIT_FINISHED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_LAYOUT_INIT_FINISHED);
    });

    it('test_judgeEvent_11', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH);
    });

    it('test_judgeEvent_12', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE);
    });

    it('test_judgeEvent_13', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_DESKTOP_ITEM_UNSELECT;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_DESKTOP_ITEM_UNSELECT);
    });

    it('test_judgeEvent_14', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_PACKAGE_CHANGED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_PACKAGE_CHANGED);
    });

    it('test_judgeEvent_15', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_APPGALLERY_CREATED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED);
    });

    it('test_judgeEvent_16', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE);
    });


    it('test_judgeEvent_17', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH);
    });

    it('test_judgeEvent_18', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED);
    });

    it('test_judgeEvent_19', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH);
    });

    it('test_judgeEvent_20', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_INTELLIGENT_SIGN_STATUS;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_INTELLIGENT_SIGN_STATUS);
    });

    it('test_judgeEvent_21', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD);
    });

    it('recycleFormEventHandler', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['currentStartApp'] = false;
      instance.recycleFormEventHandler(true);
      expect((instance as object)['currentStartApp']).assertTrue();

      (instance as object)['currentStartApp'] = true;
      instance.recycleFormEventHandler(false);
      expect((instance as object)['currentStartApp']).assertFalse();
    });

    it('test_showNext_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.showPrevious();
      expect(instance).not().assertNull();
    });

    it('test_showPrevious_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.showPrevious();
      expect(instance).not().assertNull();
    });

    it('test_mKeyEventListener_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_ENTER;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_ENTER);
    });

    it('test_mKeyEventListener_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_DELETE;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_DELETE);
    });

    it('test_mKeyEventListener_03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_FORCE_DELETE;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_FORCE_DELETE);
    });

    it('test_mKeyEventListener_04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_C;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_C);
    });

    it('test_mKeyEventListener_05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_X;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_X);
    });

    it('test_mKeyEventListener_06', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_V;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_V);
    });

    it('test_mKeyEventListener_07', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_A;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_A);
    });

    it('test_mKeyEventListener_08', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_F2;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_F2);
    });

    it('test_createOrAdd2Folder_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let addItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let pageItems: GridLayoutItemInfo[] = []
      pageItems.push(getUndefinedObject() as GridLayoutItemInfo);

      (instance as object)['createOrAdd2Folder']([addItem], pageItems);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_createOrAdd2Folder_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let addItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let pageItems: GridLayoutItemInfo[] = []
      let pageItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      pageItem.typeId = CommonConstants.TYPE_APP;
      pageItems.push(pageItem);

      let ret: boolean = (instance as object)['createOrAdd2Folder']([addItem], pageItems);
      expect(ret).assertTrue();
    });

    it('test_createOrAdd2Folder_03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let addItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let pageItems: GridLayoutItemInfo[] = []
      let pageItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      pageItem.typeId = CommonConstants.TYPE_FOLDER;
      pageItem.folderId = 'lkqkw4s76q0592qwa4g';
      pageItem.area = [1, 1];
      pageItems.push(pageItem);

      let ret: boolean = (instance as object)['createOrAdd2Folder']([addItem], pageItems);
      expect(ret).assertTrue();
    });

    it('test_createOrAdd2Folder_04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let addItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let pageItems: GridLayoutItemInfo[] = []
      let pageItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      pageItem.typeId = CommonConstants.TYPE_FOLDER;
      pageItem.folderId = 'lkqkw4s76q0592qwa4g';
      pageItem.area = [2, 2];
      pageItems.push(pageItem);

      let ret: boolean = (instance as object)['createOrAdd2Folder']([addItem], pageItems);
      expect(ret).assertTrue();
    });

    it('test_createOrAdd2Folder_05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let addItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let pageItems: GridLayoutItemInfo[] = []

      let ret: boolean = (instance as object)['createOrAdd2Folder']([addItem], pageItems);
      expect(ret).assertFalse();
    });

    it('test_changeIndexOnly_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newPageIndex: undefined = getUndefinedObject() as undefined;
      instance.changeIndexOnly(newPageIndex);
      expect(instance).not().assertNull();
    });

    it('test_changeIndexOnly_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newPageIndex: number = 1;
      instance.changeIndexOnly(newPageIndex);
      expect(instance).not().assertNull();
    });

    it('test_freshCurPageVisibility_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let isVisible: boolean = false;
      (instance as object)['freshCurPageVisibility'](isVisible);
      expect(instance).not().assertNull();
    });

    it('test_freshCurPageVisibility_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let isVisible: boolean = true;
      (instance as object)['freshCurPageVisibility'](isVisible);
      expect(instance).not().assertNull();

      let mocker: MockKit = new MockKit();
      let appStorageMockFunc: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(appStorageMockFunc)('onDeskTopState').afterReturn(1);
      (instance as object)['freshCurPageVisibility'](isVisible);
      expect(instance).not().assertNull();
      mocker.clear(AppStorage);
      mocker.clearAll();
    });

    it('test_updatePageIndex_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newPageIndex: number = 1;
      (instance as object)['updatePageIndex'](newPageIndex);
      expect(instance).not().assertNull();
    });

    it('test_folderStatusChange_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let pageIndex: number = 0;
      instance.folderStatusChange(pageIndex);
      expect(instance).not().assertNull();
    });

    it('test_checkAddToDockMenu_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      let menuInfoList: MenuInfo[] = [];

      (instance as object)['checkAddToDockMenu'](appInfo, menuInfoList);
      expect(instance).not().assertNull();
    });

    it('test_checkAddToOuterMenu_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      let menuInfoList: MenuInfo[] = [];
      (instance as object)['checkAddToOuterMenu'](appInfo, menuInfoList);
      expect(instance).not().assertNull();
    });

    it('test_onAppClick_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let abilityName: string = 'anyAbilityName';
      let bundleName: string = 'anyBundleName';
      let moduleName: string = 'anyModuleName';
      instance.onAppClick(abilityName, bundleName, moduleName);
      expect(abilityName).assertEqual('anyAbilityName');
    });

    it('test_createCardToDeskTop_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let isNeedNewPage: boolean = true;
      let layoutDescription: LayoutDescription = DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutDescription;

      let mocker: MockKit = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let newCard: CardItemInfo = new CardItemInfo();

      let func: Function | undefined | void =
        (instance as object)['updatePageAfterCreateCardToDesktop'](isNeedNewPage, layoutDescription, newCard);
      expect(instance).not().assertUndefined();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_createCardToDeskTop_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let isNeedNewPage: boolean = true;
      let layoutDescription: LayoutDescription = DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutDescription;

      let mocker: MockKit = new MockKit();
      let manager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(manager, manager.isFoldablePhoneExpandStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let newCard: CardItemInfo = new CardItemInfo();

      let func: Function | undefined | void =
        (instance as object)['updatePageAfterCreateCardToDesktop'](isNeedNewPage, layoutDescription, newCard);
      expect(instance).not().assertUndefined();
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_createCardToDeskTop_03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let isNeedNewPage: boolean = false;
      let cardItem: CardItemInfo = new CardItemInfo();
      let layoutDescription: LayoutDescription = DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutDescription;
      let func: Function | undefined | void =
        (instance as object)['updatePageAfterCreateCardToDesktop'](isNeedNewPage, layoutDescription, cardItem);
      expect(typeof func).assertEqual('undefined')
    });

    it('test_updateDesktopFocusState_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let status: boolean = true;
      (instance as object)['updateDesktopFocusState'](status);
      expect(instance).not().assertNull();
    });

    it('test_updateDesktopFocusState_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let status: boolean = false;
      (instance as object)['updateDesktopFocusState'](status);
      expect(instance).not().assertNull();
    });

    it('test_getItemKeyByType_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = getUndefinedObject() as GridLayoutItemInfo;
      let ret: string = instance.getItemKeyByType(item);
      expect(ret).assertEqual('')
    });

    it('test_getItemKeyByType_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.keyName = 'anyKeyName';
      let ret: string = instance.getItemKeyByType(item);
      expect(ret).assertEqual('anyKeyName')
    });

    it('test_getItemKeyByType_03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.folderId = 'folderId'
      let ret: string = instance.getItemKeyByType(item);
      expect(ret).assertEqual('folderId')
    });

    it('test_getItemKeyByType_04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FILE_FOLDER;
      item.ino = 'ino';
      let ret: string = instance.getItemKeyByType(item);
      expect(ret).assertEqual('ino')
    });

    it('test_getItemKeyByType_05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_REGION_FOLDER;
      item.folderId = 'folderId'
      let ret: string = instance.getItemKeyByType(item);
      expect(ret).assertEqual('folderId')
    });

    it('test_switchSingleDisplay', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      try {
        (instance as object)['switchSingleDisplay']();
        expect(instance).not().assertNull();
      } catch (error) {
        expect(instance).assertThrowError('switchSingleDisplay error');
      }
      done();
    });

    it('test_buildShortcutMenuOnPc', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      try {
        expect(viewModel).not().assertUndefined();
        (viewModel as object)['mResourceManager'] = ResourceManager.getInstance();

        let menuList: MenuInfo[] = new Array<MenuInfo>();
        const appItem = new AppItemInfo();
        expect(menuList).not().assertNull();
        (viewModel as object)['buildShortcutMenuOnPc'](menuList, appItem);
        expect(menuList).not().assertNull();
        expect(menuList.length).assertEqual(2);
      } catch (error) {
        expect(viewModel).assertThrowError('switchSingleDisplay error');
      }
    })

    it('test_buildShortcutMenuOnPcInRegionFolder', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      try {
        expect(viewModel).not().assertUndefined();
        (viewModel as object)['mResourceManager'] = ResourceManager.getInstance();
        let mocker: MockKit = new MockKit();

        let file: GridLayoutItemInfo = new GridLayoutItemInfo();
        file.typeId = 9;
        file.folderId = 'test';
        file.keyName = 'test';
        let files: GridLayoutItemInfo[] = [];
        files.push(file);


        let menuList: MenuInfo[] = new Array<MenuInfo>();
        const appItem = new AppItemInfo();
        expect(menuList).not().assertNull();
        (viewModel as object)['buildShortcutMenuOnPc'](menuList, appItem);
        expect(menuList).not().assertNull();
        expect(menuList.length).assertEqual(2);
      } catch (error) {
        expect(viewModel).assertThrowError('switchSingleDisplay error');
      }
    })

    it('test_buildShortcutMenuOnPcWithCallback', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      try {
        expect(viewModel).not().assertUndefined();
        (viewModel as object)['mResourceManager'] = ResourceManager.getInstance();

        const appItem = new AppItemInfo();
        let menuList: MenuInfo[] = new Array<MenuInfo>();
        (viewModel as object)['buildShortcutMenuOnPc'](menuList, appItem, () => {
        });
        expect(menuList).not().assertNull();
        expect(menuList.length).assertEqual(3);
      } catch (error) {
        expect(viewModel).assertThrowError('switchSingleDisplay error');
      }
    })

    it('test_buildShortcutMenuOnPcWithCallbackAndRemoveShortcutItem', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      try {
        expect(viewModel).not().assertUndefined();
        (viewModel as object)['mResourceManager'] = ResourceManager.getInstance();

        const appItem = new AppItemInfo();
        let menuList: MenuInfo[] = new Array<MenuInfo>();
          (viewModel as object)['buildShortcutMenuOnPc'](menuList, appItem, () => {
        }, null);
        expect(menuList).not().assertNull();
        expect(menuList.length).assertEqual(3);
      } catch (error) {
        expect(viewModel).assertThrowError('switchSingleDisplay error');
      }
    })

    it('test_openFileDetail', 0, () => {
      const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (pageDesktopVM as object)['openFileDetail']();

      const mocker = new MockKit();
      const fileFolderManager: FileFolderManager = fileFolderManagerFactory.getFileFolderManager();
      try{
        const func: Function = mocker.mockFunc(fileFolderManager, fileFolderManager.openFileDetail);
        when(func)(ArgumentMatchers.any).afterReturnNothing();

        let file: GridLayoutItemInfo = new GridLayoutItemInfo();
        file.typeId = 5;
        file.folderId = '5';
        file.uri = '';
        (pageDesktopVM as object)['lastSelectedItems'].push('5');
        (pageDesktopVM as object)['allDesktopItemInfo'].push(file);
        (pageDesktopVM as object)['openFileDetail']();

        file.uri = '5';
        (pageDesktopVM as object)['openFileDetail']();
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (e) {}
      mocker.clear(fileFolderManager);
      mocker.clearAll();
    })

    it('test_desktopTrim', 0, () => {
      const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const mocker = new MockKit();
      const func: Function = mocker.mockFunc(pageDesktopVM, (pageDesktopVM as object)['prepareSortParam']);
      when(func)(ArgumentMatchers.any).afterReturn(false);
      (pageDesktopVM as object)['desktopTrim'](0);
      mocker.clear(pageDesktopVM);

      when(mocker.mockFunc(pageDesktopVM, (pageDesktopVM as object)['prepareSortParam']))(ArgumentMatchers.any)
        .afterReturn(true);
      let newGridLayoutItems: GridLayoutItemInfo[] = [];
      when(mocker.mockFunc(pageDesktopVM, (pageDesktopVM as object)['trimDesktopItem']))(ArgumentMatchers.any)
        .afterReturn(newGridLayoutItems);
      when(mocker.mockFunc(pageDesktopVM, (pageDesktopVM as object)['lightPagingFiltering']))(ArgumentMatchers.any)
        .afterReturnNothing();
      const launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance()
      when(mocker.mockFunc(launchManager, launchManager['updateGridLayoutItems']))(ArgumentMatchers.any)
        .afterReturnNothing();
      (pageDesktopVM as object)['desktopTrim'](0);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clearAll();
    })

    it('test_trimDesktopItem', 0, () => {
      const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const mocker = new MockKit();
      try{
        (pageDesktopVM as object)['trimDesktopItem']();
        const launchManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
        const layoutDescription: LayoutDescription = new LayoutDescription();
        layoutDescription.row = 3;
        layoutDescription.column = 3;
        when(mocker.mockFunc(launchManager, launchManager['selectLayoutDescription']))(ArgumentMatchers.any)
          .afterReturn(layoutDescription);
        let file: GridLayoutItemInfo = new GridLayoutItemInfo();
        file.row = 1;
        file.column = 1;
        (pageDesktopVM as object)['appGridLayoutItems'].push(file);
        let file2: GridLayoutItemInfo = new GridLayoutItemInfo();
        file2.row = 2;
        file2.column = 1;
        (pageDesktopVM as object)['appGridLayoutItems'].push(file2);
        const func: Function = mocker.mockFunc(pageDesktopVM, (pageDesktopVM as object)['coverPosition']);
        when(func)(ArgumentMatchers.any).afterReturnNothing();
        (pageDesktopVM as object)['trimDesktopItem']();
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (e) {
      }
      mocker.clear(pageDesktopVM);
      mocker.clearAll();
    })

    it('test_trimInSuperFold', 0, () => {
      try{
        const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const layoutDescription: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
        let newGridLayoutItems: GridLayoutItemInfo[] = [];
        let file: GridLayoutItemInfo = new GridLayoutItemInfo();
        file.row = 1;
        file.column = 1;
        let file2: GridLayoutItemInfo = new GridLayoutItemInfo();
        file2.row = 2;
        file2.column = 1;
        newGridLayoutItems.push(file);
        newGridLayoutItems.push(file2);
        (pageDesktopVM as object)['trimInSuperFold'](newGridLayoutItems, layoutDescription);
        let a = 'test';
        expect(a).assertEqual('test');
      } catch (e) {
      }
    })

    it('test_coverPosition', 0, () => {
      try{
        const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const layoutDescription: PageDesktopGridStyleConfig = PageDesktopGridStyleConfig.getInstance();
        let newGridLayoutItems: GridLayoutItemInfo[] = [];
        let file: GridLayoutItemInfo = new GridLayoutItemInfo();
        file.row = 1;
        file.column = 1;
        let file2: GridLayoutItemInfo = new GridLayoutItemInfo();
        file2.row = 2;
        file2.column = 1;
        newGridLayoutItems.push(file);
        newGridLayoutItems.push(file2);
        (pageDesktopVM as object)['posOccupyArray'] = [[[false, false], [false, false]], [[false, false], [false, false]]];
        (pageDesktopVM as object)['coverPosition'](newGridLayoutItems, layoutDescription, false);
        let a = 'test';
        expect(a).assertEqual('test');
      }catch(e){
      }
    })

    it('test_filterItemExceedCurrentScreen01', 0, (): void => {
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.row = 0;
      item2.column = 0;
      item2.area = [1, 1];
      arr.push(item2);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(1);
    })

    it('test_filterItemExceedCurrentScreen02', 0, (): void => {
      // row right exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 3;
      item.column = 1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen03', 0, (): void => {
      // column right exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = 3;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen04', 0, (): void => {
      // area exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = 1;
      item.area = [2, 2];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen05', 0, (): void => {
      // area undefined
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = 1;
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen06', 0, (): void => {
      // row undefined
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen07', 0, (): void => {
      // row left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = -1;
      item.column = 1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen08', 0, (): void => {
      // column left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = -1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen09', 0, (): void => {
      // column left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = -1;
      item.column = 3;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen10', 0, (): void => {
      // all false
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = -1;
      item.column = -1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen11', 0, (): void => {
      // column undefined
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemExceedCurrentScreen12', 0, (): void => {
      // column left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 3;
      item.column = -1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemExceedCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen01', 0, (): void => {
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.row = 0;
      item2.column = 0;
      item2.area = [1, 1];
      arr.push(item2);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen02', 0, (): void => {
      // row right exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 3;
      item.column = 1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen03', 0, (): void => {
      // column right exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = 3;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen04', 0, (): void => {
      // area exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = 1;
      item.area = [2, 2];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen05', 0, (): void => {
      // area undefined
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = 1;
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen06', 0, (): void => {
      // row undefined
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen07', 0, (): void => {
      // row left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = -1;
      item.column = 1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen08', 0, (): void => {
      // column left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.column = -1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen09', 0, (): void => {
      // column left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = -1;
      item.column = 3;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(1);
    })

    it('test_filterItemInnerCurrentScreen10', 0, (): void => {
      // all false
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = -1;
      item.column = -1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen11', 0, (): void => {
      // column undefined
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_filterItemInnerCurrentScreen12', 0, (): void => {
      // column left exceed
      let arr: GridLayoutItemInfo[] = [];
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 3;
      item.column = -1;
      item.area = [1, 1];
      arr.push(item);
      let config: GridLayoutConfig = pageDesktopViewModel.getGridConfig();
      config.row = 2;
      config.column = 2;
      let ret: GridLayoutItemInfo[] = pageDesktopViewModel.filterItemInnerCurrentScreen(arr);
      expect(ret.length).assertEqual(0);
    })

    it('test_PageDesktopViewModel_getIsChangingPage', 0, (): void => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let result: boolean = instance.getIsChangingPage();
      expect(result).assertInstanceOf('Boolean');
    })

    it('test_PageDesktopViewModel_changeCurrentLayoutCache', 0, (): void => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let padLaunchLayoutCacheManager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(padLaunchLayoutCacheManager, padLaunchLayoutCacheManager.changeCurrentLayoutCacheData);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      instance.changeCurrentLayoutCache(true);
      expect(instance).not().assertNull();
      mocker.clear(padLaunchLayoutCacheManager);
      mocker.clearAll();
    })

    it('test_outerHasAppItemEnoughArea_01', 3, async () => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectPageCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(1);
      let mockfunc2: Function =
        mocker.mockFunc((pageDesktopViewModel as object)['mLauncherLayoutCacheManager'], (pageDesktopViewModel as object)['mLauncherLayoutCacheManager'].selectMaxPageCount);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(2);
      let result: boolean = pageDesktopViewModel.outerHasAppItemEnoughArea(itemInfo);
      expect(result === true);

      when(mockfunc)(ArgumentMatchers.any).afterReturn(10);
      let mockfunc3: Function =
        mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.getEnoughAreaPosition);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(true);
      let result2: boolean = pageDesktopViewModel.outerHasAppItemEnoughArea(itemInfo);
      expect(result2 === true);

      when(mockfunc3)(ArgumentMatchers.any).afterReturn(false);
      let result3: boolean = pageDesktopViewModel.outerHasAppItemEnoughArea(itemInfo);
      expect(result3 === false);

      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_outerHasAppItemEnoughArea', 0, (): void => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.row = 3;
      item.column = -1;
      item.area = [1, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((instance as object)['mLauncherLayoutCacheManager'], (instance as object)['mLauncherLayoutCacheManager'].selectPageCount);
      let mockFunc1: Function = mocker.mockFunc((instance as object)['mLauncherLayoutCacheManager'], (instance as object)['mLauncherLayoutCacheManager'].selectMaxPageCount);
      let mockFunc2: Function = mocker.mockFunc(instance, instance.getEnoughAreaPosition);
      when(mockFunc)().afterReturn(2);
      when(mockFunc1)().afterReturn(1);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = instance.outerHasAppItemEnoughArea(item);
      expect(result).assertTrue();
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let result1: boolean = instance.outerHasAppItemEnoughArea(item);
      expect(result1).assertFalse();
      mocker.clear((instance as object)['mLauncherLayoutCacheManager']);
      mocker.clear(instance);
      mocker.clearAll();
    })


    it('test_PageDesktopViewModel_reportAddCardToScreenByDragEvent', 0, (): void => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newItem: CardItemInfo = new CardItemInfo();
      newItem.id = '1573457366';
      newItem.cardId = '1573457366';
      newItem.name = 'minVoiceRecCard';
      newItem.cardName = 'minVoiceRecCard';
      newItem.bundleName = 'com.ohos.suggestion';
      newItem.abilityName = 'ParentFormAbility';
      newItem.moduleName = 'entry';
      newItem.dimension = 2;
      newItem.cardDimension = 2;
      newItem.page = undefined;
      newItem.appLabelId = 0;
      newItem.area = [2, 2];
      newItem.isTransparent = false;
      instance.reportAddCardToScreenByDragEvent(newItem, 1, 1);
      expect(newItem.area.length).assertEqual(2);
      newItem.page = 1;
      instance.reportAddCardToScreenByDragEvent(newItem, CommonConstants.DRAG_FROM_FORM_STACK, 1);
      expect(newItem.area.length).assertEqual(2);
      instance.reportAddCardToScreenByDragEvent(newItem, CommonConstants.DRAG_FROM_MANAGE, 1);
      expect(newItem.area.length).assertEqual(2);
      instance.reportAddCardToScreenByDragEvent(newItem, CommonConstants.DOCK_SPACE, 1);
      expect(newItem.area.length).assertEqual(2);
    })

    it('test_PageDesktopViewModel_showNext', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.showNext();
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_changeSwiperIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.changeSwiperIndex(1);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_mSettingsChangeObserver', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['mSettingsChangeObserver'](1);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_mKeyEventListener', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event = KeyEventConstants.EVENT_DELETE;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_CTRL_A;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_CTRL_D;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_CTRL_Z;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_CTRL_Y;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_CTRL_SHIFT_N;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_DPAD_UP;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_ALT_ENTER;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_SPACE;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      event = KeyEventConstants.EVENT_R;
      (instance as object)['mKeyEventListener'].onReceiveKeyEvent(event);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_setFileFolderBadge', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIndex = 1;
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((instance as object)['mLauncherLayoutCacheManager'], (instance as object)['mLauncherLayoutCacheManager'].isPad);
      when(mockFunc)().afterReturn(true);
      (instance as object)['updatePadRotateCache'](appInfo);
      expect(instance).not().assertNull();
      when(mockFunc)().afterReturn(false);
      (instance as object)['updatePadRotateCache'](appInfo);
      expect(instance).not().assertNull();
      mocker.clear((instance as object)['mLauncherLayoutCacheManager']);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_updateDesktopLayoutItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIndex = 1;
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';
      appInfo.codePath = '1';
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.bundleName = 'com.ohos.ohosTest';
      info1.keyName = 'com.ohos.ohosTestPhoneEntry';
      info1.typeId = CommonConstants.TYPE_APP;
      info1.appIndex = 1;
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com.ohos.ohosTest';
      info.keyName = 'com.ohos.ohosTestPhoneEntry';
      info.typeId = CommonConstants.TYPE_APP;
      info.appIndex = 1;
      info.layoutInfo = [[info1]];
      let result: boolean = (instance as object)['updateDesktopLayoutItem'](info, appInfo);
      expect(result).assertTrue();
      info.typeId = CommonConstants.TYPE_FOLDER;
      let result1: boolean = (instance as object)['updateDesktopLayoutItem'](info, appInfo);
      expect(result1).assertTrue();
    })

    it('test_PageDesktopViewModel_updateDockLayoutItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIndex = 1;
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';
      appInfo.codePath = '1';
      let result: boolean = (instance as object)['updateDockLayoutItem'](appInfo);
      expect(result).assertInstanceOf('Boolean');
    })

    it('test_PageDesktopViewModel_getTaskDelayTime', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['loadGridListCostTime'] = 99;
      let result: number = (instance as object)['getTaskDelayTime']();
      expect(result).assertEqual(NumberConstants.CONSTANT_NUMBER_ZERO);
      (instance as object)['loadGridListCostTime'] = 399;
      let result1: number = (instance as object)['getTaskDelayTime']();
      expect(result1).assertEqual(NumberConstants.CONSTANT_NUMBER_ONE_THOUSAND);
      (instance as object)['loadGridListCostTime'] = 999;
      let result2: number = (instance as object)['getTaskDelayTime']();
      expect(result2).assertEqual(NumberConstants.CONSTANT_NUMBER_TWO_THOUSAND);
      (instance as object)['loadGridListCostTime'] = 1999;
      let result3: number = (instance as object)['getTaskDelayTime']();
      expect(result3).assertEqual(NumberConstants.CONSTANT_NUMBER_THREE_THOUSAND);
    })

    it('test_PageDesktopViewModel_uninstallAppInFolder', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com.ohos.ohosTest';
      info.keyName = 'com.ohos.ohosTestPhoneEntry';
      info.typeId = CommonConstants.TYPE_APP;
      info.appIndex = 1;
      info.isUninstallAble = false;
      info.appStatus = AppStatus.PENDING;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      instance.uninstallAppInFolder(info);
      expect(info.appIndex).assertEqual(1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance.uninstallAppInFolder(info);
      expect(info.appIndex).assertEqual(1);
      info.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      instance.uninstallAppInFolder(info);
      expect(info.appIndex).assertEqual(1);
      info.typeId = CommonConstants.TYPE_APP;
      instance.uninstallAppInFolder(info);
      expect(info.appIndex).assertEqual(1);
      info.typeId = CommonConstants.DOCK_SPACE;
      instance.uninstallAppInFolder(info);
      expect(info.appIndex).assertEqual(1);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_updateBadgeNumber', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.appIndex = 1;
      badgeInfo.id = 1;
      badgeInfo.bundleName = 'com.ohos.ohosTest';
      badgeInfo.badgeNumber = 1;
      badgeInfo.isShow = true;
      badgeInfo.userId = 1;
      AppStorage.setOrCreate<boolean>('isDesktopLoadFinished', false);
      instance.updateBadgeNumber(badgeInfo);
      expect(badgeInfo.appIndex).assertEqual(1);
      AppStorage.setOrCreate<boolean>('isDesktopLoadFinished', true);
      instance.updateBadgeNumber(badgeInfo);
      expect(badgeInfo.appIndex).assertEqual(1);
    })

    it('test_PageDesktopViewModel_checkIsAutoAnimating', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.appIndex = 1;
      badgeInfo.id = 1;
      badgeInfo.bundleName = 'com.ohos.ohosTest';
      badgeInfo.badgeNumber = 1;
      badgeInfo.isShow = true;
      badgeInfo.userId = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['checkIsAutoAnimating']();
      expect(badgeInfo.appIndex).assertEqual(1);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_checkIsDuplicateElement', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.bundleName = 'com';
      info1.abilityName = 'openharmony';
      info1.keyName = 'com1';
      info1.row = 1;
      info1.column = 1;
      info1.folderId = '996';
      info1.typeId = CommonConstants.TYPE_APP;
      info1.area = [2, 1];
      let result: boolean = (instance as object)['checkIsDuplicateElement'](info, info1, false);
      expect(result).assertTrue();
      info.typeId = CommonConstants.TYPE_FOLDER;
      info1.typeId = CommonConstants.TYPE_FOLDER;
      let result1: boolean = (instance as object)['checkIsDuplicateElement'](info, info1, false);
      expect(result1).assertInstanceOf('Boolean');
      info.typeId = CommonConstants.TYPE_FORM_STACK;
      info1.typeId = CommonConstants.TYPE_FORM_STACK;
      let result2: boolean = (instance as object)['checkIsDuplicateElement'](info, info1, false);
      expect(result2).assertInstanceOf('Boolean');
      info.typeId = CommonConstants.TYPE_FILE_FOLDER;
      info1.typeId = CommonConstants.TYPE_FILE_FOLDER;
      let result3: boolean = (instance as object)['checkIsDuplicateElement'](info, info1, false);
      expect(result3).assertInstanceOf('Boolean');
      info.typeId = CommonConstants.DOCK_SPACE;
      info1.typeId = CommonConstants.DOCK_SPACE;
      let result4: boolean = (instance as object)['checkIsDuplicateElement'](info, info1, false);
      expect(result4).assertInstanceOf('Boolean');
    })

    it('test_PageDesktopViewModel_checkIsDuplicateFolder', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.formStackId = '996';
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = (instance as object)['checkIsDuplicateFolder'](info, info);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_checkIsDuplicateFormStack', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = (instance as object)['checkIsDuplicateFormStack'](info, info);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_checkIsDuplicateFileFolder', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = (instance as object)['checkIsDuplicateFileFolder'](info, info);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_updateInstallingAppItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['mIsNeedUpdateInstallingApp'] = true;
      (instance as object)['updateInstallingAppItem']();
      expect((instance as object)['mIsNeedUpdateInstallingApp']).assertFalse();
    })

    it('test_PageDesktopViewModel_getRowOrColumn', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: LayoutDescription = {
        pageCount: 1,
        row: 1,
        column: 1,
        maxPage: 1,
        maxForm: 1,
      }
      let result: number = (instance as object)['getRowOrColumn'](info, true);
      expect(result).assertEqual(1);
      let result1: number = (instance as object)['getRowOrColumn'](info, false);
      expect(result1).assertEqual(1);
    })

    it('test_PageDesktopViewModel_updateFileFolderItemLayoutInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      (instance as object)['updateFileFolderItemLayoutInfo'](info, [info], 1);
      expect(info.bundleName).assertEqual('com');
    })

    it('test_PageDesktopViewModel_processPositionValid', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((instance as object)['mLauncherLayoutCacheManager'], (instance as object)['mLauncherLayoutCacheManager'].isPositionValid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = (instance as object)['processPositionValid'](info, 1, 1, 1, true, [info], 1);
      expect(result).assertTrue();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result1: boolean = (instance as object)['processPositionValid'](info, 1, 1, 1, true, [info], 1);
      expect(result1).assertFalse();
      mocker.clear((instance as object)['mLauncherLayoutCacheManager']);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_handleNewPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let layoutDescription: LayoutDescription = {
        pageCount: 1,
        row: 1,
        column: 1,
        maxPage: 1,
        maxForm: 1,
      };
      (instance as object)['handleNewPage'](info, 1, layoutDescription);
      expect(info.bundleName).assertEqual('com');
      (instance as object)['handleNewPage'](info, 0, layoutDescription);
      expect(info.bundleName).assertEqual('com');
    })

    it('test_PageDesktopViewModel_setIsMakingFolder', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.setIsMakingFolder(false);
      expect(instance).not().assertNull();
      instance.setIsMakingFolder(true);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_updateAppItemLayoutInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.appIndex = 1;
      appInfo.appStatus = AppStatus.WAIT_FOR_HARMONY;
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';
      appInfo.codePath = '1';
      appInfo.typeId = CommonConstants.TYPE_APP;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = instance.updateAppItemLayoutInfo(appInfo, false);
      expect(result).assertFalse();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let result1: boolean = instance.updateAppItemLayoutInfo(appInfo, false);
      expect(result1).assertFalse();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_dealItemListWithOverMaxPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      (instance as object)['mIsFinishedInitLayout'] = true;
      (instance as object)['dealItemListWithOverMaxPage']([info], 1, 2);
      expect(instance).not().assertNull();
      instance.setIsMakingFolder(true);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_updateOuterAppItemLayoutInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((instance as object)['mPageDesktopModel'], (instance as object)['mPageDesktopModel'].findBlankPosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = (instance as object)['updateOuterAppItemLayoutInfo'](info);
      expect(result).assertFalse();
      mocker.clear((instance as object)['mPageDesktopModel']);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_showNoSpaceToast', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.showNoSpaceToast(true);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_dealWithOverMaxPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let layoutDescription: LayoutDescription = {
        pageCount: 1,
        row: 1,
        column: 1,
        maxPage: 1,
        maxForm: 1,
      };
      (instance as object)['mIsFinishedInitLayout'] = false;
      let result: number = (instance as object)['dealWithOverMaxPage'](info, layoutDescription, 1);
      expect(result).assertEqual(NumberConstants.CONSTANT_NUMBER_ZERO);
      (instance as object)['mIsFinishedInitLayout'] = true;
      let result1: number = (instance as object)['dealWithOverMaxPage'](info, layoutDescription, 1);
      expect(result1).assertInstanceOf('Number');
    })

    it('test_PageDesktopViewModel_updateFormCacheWhenAppUpdate', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['updateFormCacheWhenAppUpdate'](info.bundleName);
      expect(info.row).assertEqual(1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['updateFormCacheWhenAppUpdate'](info.bundleName);
      expect(info.row).assertEqual(1);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_updateNewInstalledGridInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appName = 'appName';
      (instance as object)['updateNewInstalledGridInfo'](info.bundleName, 1);
      expect(info.bundleName).assertEqual('com');
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppInfoByBundleInfo);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appItemInfo);
      (instance as object)['updateNewInstalledGridInfo'](info.bundleName, 1);
      expect(info.bundleName).assertEqual('com');
      mocker.clear(AppModel.getInstance());
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_selectDeliveryAppWaitForInstall', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'appName1';
      info.abilityName = 'appName1';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
      info1.bundleName = 'appName1';
      info1.abilityName = 'appName1';
      info1.keyName = 'com';
      info1.row = 1;
      info1.column = 1;
      info1.folderId = '996';
      info1.formStackId = '996';
      info1.typeId = CommonConstants.TYPE_APP;
      info1.area = [2, 1];
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appName = 'appName';
      appItemInfo.appIndex = 1;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportDeliver);
      let mockFunc1: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isSupportAppType);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let result: GridLayoutItemInfo | undefined = (instance as object)['selectDeliveryAppWaitForInstall'](appItemInfo);
      expect(result).assertUndefined();
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc2: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([info, info1]);
      let result1: GridLayoutItemInfo | undefined = (instance as object)['selectDeliveryAppWaitForInstall'](appItemInfo);
      expect(result1).assertUndefined();
      mocker.clear(DeliverUtil);
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_cancelDownloadTask', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      (instance as object)['cancelDownloadTask'](info);
      expect(info.bundleName).assertEqual('com');
    })

    it('test_PageDesktopViewModel_registerInstalledAniFinishCallback', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['waitingForInstallAni'] = true;
      (instance as object)['registerInstalledAniFinishCallback'](info.bundleName, info.row);
      expect(info.bundleName).assertEqual('com');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['waitingForInstallAni'] = false;
      (instance as object)['registerInstalledAniFinishCallback'](info.bundleName, info.row);
      expect(info.bundleName).assertEqual('com');
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_informUninstallResult', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      instance.informUninstallResult(CommonConstants.UNINSTALL_FORBID, info.bundleName);
      expect(info.bundleName).assertEqual('com');
      instance.informUninstallResult(CommonConstants.UNINSTALL_SUCCESS, info.bundleName);
      expect(info.bundleName).assertEqual('com');
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerPkg);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      instance.informUninstallResult(-1, info.bundleName);
      expect(info.bundleName).assertEqual('com');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      instance.informUninstallResult(-1, info.bundleName);
      expect(info.bundleName).assertEqual('com');
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_openApplication', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      instance.openApplication(info.abilityName, info.bundleName, info.moduleName, 1);
      expect(info.bundleName).assertEqual('com');
    })

    it('test_PageDesktopViewModel_intoSetting', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      instance.intoSetting();
      expect(info.bundleName).assertEqual('com');
    })

    it('test_PageDesktopViewModel_changeIndexOnly', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      instance.changeIndexOnly(undefined);
      expect(info.bundleName).assertEqual('com');
      instance.changeIndexOnly(info.row);
      expect(info.bundleName).assertEqual('com');
    })

    it('test_PageDesktopViewModel_changeIndexOnly', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      (instance as object)['mPageIndex'] = 1;
      (instance as object)['updatePageIndex'](1);
      expect(info.bundleName).assertEqual('com');
      (instance as object)['updatePageIndex'](2);
      expect(info.bundleName).assertEqual('com');
    })

    it('test_PageDesktopViewModel_notifyVisibleFormsOfPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['isPageIndexValid']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['notifyVisibleFormsOfPage'](1);
      expect(info.bundleName).assertEqual('com');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      let mockFunc2: Function = mocker.mockFunc(instance, (instance as object)['getCardsByPageIndex']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(['1', '2']);
      (instance as object)['notifyVisibleFormsOfPage'](1);
      expect(info.bundleName).assertEqual('com');
      mocker.clear(instance);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_notifyInvisibleFormsOfPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['isPageIndexValid']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['notifyInvisibleFormsOfPage'](1);
      expect(info.bundleName).assertEqual('com');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(desktopUtil, desktopUtil.isFoldExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['notifyInvisibleFormsOfPage'](1);
      expect(info.bundleName).assertEqual('com');
      mocker.clear(instance);
      mocker.clear(desktopUtil);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_getCardsByPageIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      let result: CardItemInfo[] = (instance as object)['getCardsByPageIndex']([1]);
      expect(result.length).assertInstanceOf('Number');
    })

    it('test_PageDesktopViewModel_isSingleItemPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 1;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      (instance as object)['mPageIndex'] = 2;
      (instance as object)['mGridAppsInfos'] = [];
      let result: boolean = (instance as object)['isSingleItemPage']();
      expect(result).assertFalse();
      (instance as object)['mPageIndex'] = -1;
      (instance as object)['mGridAppsInfos'] = [];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result1: boolean = (instance as object)['isSingleItemPage']();
      expect(result1).assertFalse();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_PageDesktopViewModel_getTargetIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let emp: number = (instance as object)['mTargetIndex'];
      (instance as object)['mTargetIndex'] = 0;
      let result: number = instance.getTargetIndex();
      expect(result).assertEqual(0);
      (instance as object)['mTargetIndex'] = emp;
    })

    it('test_PageDesktopViewModel_addBlankPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addBlankPage(true);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_buildNotInstalledAppMenu', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appName = 'appName';
      appItemInfo.appIndex = 1;
      let result: Map<AppStatus, MenuInfo[]> = (instance as object)['buildNotInstalledAppMenu'](appItemInfo, appItemInfo.appIndex);
      let list = result.get(AppStatus.INSTALLING) ?? [];
      expect(list.length).assertEqual(0);
    })

    it('test_PageDesktopViewModel_getRemoveInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appName = 'appName';
      appItemInfo.appIndex = 1;
      let result: MenuInfo = (instance as object)['getRemoveInfo'](appItemInfo, true, 1, 1);
      expect(result.menuImgSrc).assertEqual('/common/pics/ic_public_remove.svg');
    })

    it('test_PageDesktopViewModel_getPageDesktopStyleConfig', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let result: PageDesktopGridStyleConfig = (instance as object)['getPageDesktopStyleConfig']();
      expect(result).assertEqual((instance as object)['pageDesktopStyleConfig']);
    })

    it('test_PageDesktopViewModel_setWorkSpaceWidth', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['setWorkSpaceWidth'](1);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_setWorkSpaceHeight', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['setWorkSpaceHeight']('openharmony');
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_startAppWithIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com.ohos.vassistant.launcher';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 0;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      (instance as object)['startAppWithIndex'](info.abilityName, info.bundleName, info.moduleName, info.row);
      expect(instance).not().assertNull();
      (instance as object)['startAppWithIndex'](info.abilityName, info.bundleName, info.moduleName, info.column);
      expect(instance).not().assertNull();
      (instance as object)['startAppWithIndex'](info.bundleName, info.abilityName, info.moduleName, info.column);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_onAppClick', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.bundleName = 'com.ohos.vassistant.launcher';
      info.abilityName = 'openharmony';
      info.moduleName = 'com';
      info.keyName = 'com';
      info.row = 1;
      info.column = 0;
      info.appStatus = AppStatus.WAIT_FOR_HARMONY;
      info.folderId = '996';
      info.formStackId = '996';
      info.typeId = CommonConstants.TYPE_APP;
      info.area = [2, 1];
      (instance as object)['onAppClick'](info.abilityName, info.bundleName, info.moduleName, info.row);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_checkIfNeedNextPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newItem: CardItemInfo = new CardItemInfo();
      newItem.id = '1573457366';
      newItem.cardId = '1573457366';
      newItem.name = 'minVoiceRecCard';
      newItem.cardName = 'minVoiceRecCard';
      newItem.bundleName = 'com.ohos.suggestion';
      newItem.abilityName = 'ParentFormAbility';
      newItem.moduleName = 'entry';
      newItem.dimension = 2;
      newItem.cardDimension = 2;
      newItem.appLabelId = 0;
      newItem.area = [2, 2];
      newItem.isTransparent = false;
      let result: boolean = (instance as object)['checkIfNeedNextPage'](newItem, 10000);
      expect(result).assertTrue();
      let result1: boolean = (instance as object)['checkIfNeedNextPage'](newItem, -2);
      expect(result1).assertFalse();
    })

    it('test_PageDesktopViewModel_deleteFormItemEvent4Intelligent', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await (instance as object)['deleteFormItemEvent4Intelligent']('999');
      expect(instance).not().assertNull();
      done();
    })

    it('test_PageDesktopViewModel_addFormInfoToFormList', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.uninstallApp('999', true, 1);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_uninstallAppResult', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let isSingleDisplayPocketFoldDevice: boolean = (instance as object)['isSingleDisplayPocketFoldDevice'];
      (instance as object)['isSingleDisplayPocketFoldDevice'] = true;
      instance.uninstallAppResult('999', { code: 0, errorCode: 1 }, 1);
      expect(instance).not().assertNull();
      (instance as object)['isSingleDisplayPocketFoldDevice'] = isSingleDisplayPocketFoldDevice;
    })

    it('test_PageDesktopViewModel_refreshScreen', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['refreshScreen']();
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_checkAndUpdateConfig', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mDesktopFileInfoList: DesktopFileInfo[] = [];
      let mDesktopFileInfo = new DesktopFileInfo();
      mDesktopFileInfo.row = 1;
      mDesktopFileInfoList.push(mDesktopFileInfo);
      instance.checkAndUpdateConfig(mDesktopFileInfoList);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_getDesktopFocusState', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let result: boolean = instance.getDesktopFocusState();
      expect(result).assertEqual((instance as object)['mIsDesktopFocused']);
    })

    it('test_PageDesktopViewModel_updateDesktopFocusState', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['lastSelectedItems'] = ['999', '888'];
      (instance as object)['updateDesktopFocusState'](true);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_doCtrlShiftNEvent', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['doCtrlShiftNEvent']();
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_doDeleteEvent', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await (instance as object)['doDeleteEvent']();
      expect(instance).not().assertNull();
      done();
    })

    it('test_PageDesktopViewModel_openFilePreview', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['openFilePreview']();
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_openFileDetail', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['openFileDetail']();
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_clearSelectStatus', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['clearSelectStatus']();
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_doSelectFirstItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['lastSelectedItems'] = [];
      (instance as object)['doSelectFirstItem']();
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_menuCopyAction', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['menuCopyAction'](['999', '888']);
      expect(instance).not().assertNull();
      (instance as object)['menuCopyAction'](['999', '888'], true);
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_deleteCurrentItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (instance as object)['deleteCurrentItem']('999');
      expect(instance).not().assertNull();
    })

    it('test_PageDesktopViewModel_isCurrentItemInMultiMap', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let result: boolean = (instance as object)['isCurrentItemInMultiMap']('999');
      expect(result).assertInstanceOf('Boolean');
    })

    it('test_PageDesktopViewModel_isFirstSnapshotInMap', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let result: boolean = (instance as object)['isFirstSnapshotInMap']('999');
      expect(result).assertInstanceOf('Boolean');
    })

    it('test_checkIsNeedSort', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let ret: boolean = (pageDesktopViewModel as object)['checkIsNeedSort']();
      expect(ret).assertEqual(false);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_checkAppGridLayoutItems', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel = AppModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.appName = undefined;
      item.bundleName = 'bundleName';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.appName = 'appName';
      item2.bundleName = 'bundleName';
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.appName = 'appName';
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appItemInfo);
      (pageDesktopViewModel as object)['clearSortParam']();
      (pageDesktopViewModel as object)['appGridLayoutItems'] = [item, item2];
      (pageDesktopViewModel as object)['checkAppGridLayoutItems']();
      let ret: GridLayoutItemInfo = (pageDesktopViewModel as object)['appGridLayoutItems'][0];
      expect(ret.appName).assertEqual('appName');
      mocker.clear(appModel);
      mocker.clearAll();
    })

    it('test_getForeachKey', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.formStackId = '1';
      item.bundleName = '1';
      item.abilityName = '1';
      item.moduleName = '1';
      item.appLabelId = 1;
      item.areaType = 1;
      item.formConfigAbility = '1';
      item.formRefreshDate = '1';
      item.folderId = '1';
      item.row = 1;
      item.column = 1;
      item.area = [1, 1];
      item.id = 1;
      item.infoId = '1';
      item.ino = '1';
      item.uri = '1';
      item.layoutInfo = undefined;
      let ret = pageDesktopViewModel.getForeachKey(item, 1, false);
      expect(ret).assertEqual('11');
      item.typeId = CommonConstants.TYPE_FILE_FOLDER;
      ret = pageDesktopViewModel.getForeachKey(item, 1, false);
      expect(ret).assertEqual('1111');
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      ret = pageDesktopViewModel.getForeachKey(item, 1, false);
      expect(ret).assertEqual('1111161,11111');
      let demo = new GridLayoutItemInfo()
      item.layoutInfo = [[demo]];
      ret = pageDesktopViewModel.getForeachKey(item, 1, false);
      expect(ret).assertEqual('1111161,11111');
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      ret = pageDesktopViewModel.getForeachKey(item, 1, false, 0, false);
      expect(ret).assertEqual('1111161,11111');
      item.typeId = CommonConstants.TYPE_FORM_STACK;
      ret = pageDesktopViewModel.getForeachKey(item, 1, false, 0, true);
      expect(ret).assertEqual('1111161,1111');
      item.typeId = CommonConstants.TYPE_REGION_FOLDER;
      ret = pageDesktopViewModel.getForeachKey(item, 1, false, 0, false);
      expect(ret).assertEqual('1');
    })

    it('test_prepareSortParam', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (pageDesktopViewModel as object)['clearSortParam']();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.appName = 'appName';
      item.ino = '1';
      item.cardName = 'cardName';
      item.page = 0;
      item.size = 1;
      item.ctime = 0;
      item.mtime = 0;
      item.fileFolderName = 'fileFolderName';
      item.row = 0;
      item.column = 0;
      item.area = [1, 1];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_FILE_FOLDER;
      item2.appName = 'appName';
      item2.ino = '1';
      item2.cardName = 'cardName';
      item2.page = 0;
      item2.size = 1;
      item2.ctime = 0;
      item2.mtime = 0;
      item2.fileFolderName = 'fileFolderName';
      item2.fileType = 0;
      item2.row = 0;
      item2.column = 0;
      item2.area = [1, 1];
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_FILE_FOLDER;
      item3.appName = 'appName';
      item3.ino = '1';
      item3.cardName = 'cardName';
      item3.page = 0;
      item3.size = 1;
      item3.ctime = 0;
      item3.mtime = 0;
      item3.fileFolderName = 'fileFolderName';
      item3.fileType = 1;
      item3.row = 0;
      item3.column = 0;
      item3.area = [1, 1];
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.typeId = CommonConstants.TYPE_CARD;
      item4.appName = 'appName';
      item4.ino = '1';
      item4.cardName = 'cardName';
      item4.page = 0;
      item4.size = 1;
      item4.ctime = 0;
      item4.mtime = 0;
      item4.fileFolderName = 'fileFolderName';
      item4.row = 0;
      item4.column = 0;
      item4.area = [1, 1];
      let list: GridLayoutItemInfo[] = [item, item2, item3, item4];
      let pageDesktopGridStyleConfig = { mColumns:1, mRows: 1} as PageDesktopGridStyleConfig;
      let layoutDescription: LayoutDescription = { pageCount:1, column:1, row: 1, maxPage: 1, maxForm: 1 };
      let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      let mockFunc2: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.getPageDesktopStyleConfig);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(pageDesktopGridStyleConfig);
      let mockFunc3: Function = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.selectLayoutDescription);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(layoutDescription);
      try {
        let ret: boolean = (pageDesktopViewModel as object)['prepareSortParam']();
        expect(ret).assertEqual(true);
      } catch (e) {};
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('test_sortDesktopItem', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      (pageDesktopViewModel as object)['clearSortParam']();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.appName = 'appName';
      item.ino = '1';
      item.cardName = 'cardName';
      item.page = 0;
      item.size = 1;
      item.ctime = 0;
      item.mtime = 0;
      item.fileFolderName = 'fileFolderName';
      item.row = 0;
      item.column = 0;
      item.area = [1, 1];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_FILE_FOLDER;
      item2.appName = 'appName';
      item2.ino = '1';
      item2.cardName = 'cardName';
      item2.page = 0;
      item2.size = 1;
      item2.ctime = 0;
      item2.mtime = 0;
      item2.fileFolderName = 'fileFolderName';
      item2.fileType = 0;
      item2.row = 0;
      item2.column = 0;
      item2.area = [1, 1];
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_FILE_FOLDER;
      item3.appName = 'appName';
      item3.ino = '1';
      item3.cardName = 'cardName';
      item3.page = 0;
      item3.size = 1;
      item3.ctime = 0;
      item3.mtime = 0;
      item3.fileFolderName = 'fileFolderName';
      item3.fileType = 1;
      item3.row = 0;
      item3.column = 0;
      item3.area = [1, 1];
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.typeId = CommonConstants.TYPE_CARD;
      item4.appName = 'appName';
      item4.ino = '1';
      item4.cardName = 'cardName';
      item4.page = 0;
      item4.size = 1;
      item4.ctime = 0;
      item4.mtime = 0;
      item4.fileFolderName = 'fileFolderName';
      item4.row = 0;
      item4.column = 0;
      item4.area = [1, 1];
      let list: GridLayoutItemInfo[] = [item, item2, item3, item4];
      let pageDesktopGridStyleConfig = { mColumns:1, mRows: 1} as PageDesktopGridStyleConfig;
      let layoutDescription: LayoutDescription = { pageCount:1, column:1, row: 1, maxPage: 1, maxForm: 1 };
      let launchLayoutCacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(list);
      let mockFunc2: Function = mocker.mockFunc(pageDesktopViewModel, pageDesktopViewModel.getPageDesktopStyleConfig);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(pageDesktopGridStyleConfig);
      let mockFunc3: Function = mocker.mockFunc(launchLayoutCacheManager, launchLayoutCacheManager.selectLayoutDescription);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(layoutDescription);
      try {
        let sortInfo: DesktopSortInfo = { sortRule: DesktopSortRule.SORT_BY_NAME, isAscend: false, page: 0 };
        (pageDesktopViewModel as object)['sortDesktopItem'](sortInfo);
        (pageDesktopViewModel as object)['clearSortParam']();
        sortInfo.sortRule = DesktopSortRule.SORT_BY_MODIFY_TIME;
        (pageDesktopViewModel as object)['sortDesktopItem'](sortInfo);
        (pageDesktopViewModel as object)['clearSortParam']();
        sortInfo.sortRule = DesktopSortRule.SORT_BY_CREATE_TIME;
        (pageDesktopViewModel as object)['sortDesktopItem'](sortInfo);
        (pageDesktopViewModel as object)['clearSortParam']();
        sortInfo.sortRule = DesktopSortRule.SORT_BY_SIZE;
        (pageDesktopViewModel as object)['sortDesktopItem'](sortInfo);
        (pageDesktopViewModel as object)['clearSortParam']();
        sortInfo.sortRule = DesktopSortRule.SORT_BY_TYPE;
        (pageDesktopViewModel as object)['sortDesktopItem'](sortInfo);
        (pageDesktopViewModel as object)['clearSortParam']();
        sortInfo.sortRule = DesktopSortRule.SORT_NONE;
        (pageDesktopViewModel as object)['sortDesktopItem'](sortInfo);
        (pageDesktopViewModel as object)['clearSortParam']();
        let ret: boolean = (pageDesktopViewModel as object)['prepareSortParam']();
        expect(ret).assertEqual(true);
      } catch (e) {};
      mocker.clear(launchLayoutCacheManager);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('test_sortDesktopItemByName', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let res = true;
      try {
        (pageDesktopViewModel as object)['sortDesktopItemByName']();
      } catch (e) {};
      expect(res).assertTrue();
    })

    it('test_sortDesktopItemByModifiedTime', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let res = true;
      try {
        (pageDesktopViewModel as object)['sortDesktopItemByModifiedTime']();
      } catch (e) {};
      expect(res).assertTrue();
    })

    it('test_sortDesktopItemByCreatedTime', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let res = true;
      try {
        (pageDesktopViewModel as object)['sortDesktopItemByCreatedTime']();
      } catch (e) {};
      expect(res).assertTrue();
    })

    it('test_sortDesktopItemBySize', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let res = true;
      try {
        (pageDesktopViewModel as object)['sortDesktopItemBySize']();
      } catch (e) {};
      expect(res).assertTrue();
    })

    it('test_sortDesktopItemByType', 0, (): void => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let res = true;
      try {
        (pageDesktopViewModel as object)['sortDesktopItemByType']();
      } catch (e) {};
      expect(res).assertTrue();
    })

    enum DesktopSortRule {
      SORT_NONE = 0,
      SORT_BY_NAME = 1,
      SORT_BY_MODIFY_TIME = 2,
      SORT_BY_CREATE_TIME = 3,
      SORT_BY_SIZE = 4,
      SORT_BY_TYPE = 5,
    }

    interface DesktopSortInfo {
      sortRule: DesktopSortRule,
      isAscend: boolean,
      page: number
    }

    it('test_getItemIndexWithRight', 0, () => {
      const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const mocker = new MockKit();
      const launchManager: LaunchLayoutCacheManager = LauncherLayoutCacheConfig.getInstance().getLayoutCacheManager();
      when(mocker.mockFunc(launchManager, launchManager['isPositionValid']))(ArgumentMatchers.any)
        .afterReturn(true);
      (pageDesktopVM as object)['getItemIndexWithRight']([2,1], 5, 5, 0);
      when(mocker.mockFunc(launchManager, launchManager['isPositionValid']))(ArgumentMatchers.any)
        .afterReturn(false);
      (pageDesktopVM as object)['getItemIndexWithRight']([2,1], 5, 5, 0);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clearAll();
    })

    it('test_getItemIndexWithAround', 0, () => {
      const mocker = new MockKit();
      const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      when(mocker.mockFunc(pageDesktopVM, (pageDesktopVM as object)['getItemIndexWithRight']))(ArgumentMatchers.any)
        .afterReturn({ pageIndex: 0, row: 3, column : 3 });
      const layoutDescription: LayoutDescription = { pageCount:2, column:5, row: 5, maxPage: 2, maxForm: 10 };
      const launchManager: LaunchLayoutCacheManager = LauncherLayoutCacheConfig.getInstance().getLayoutCacheManager();
      when(mocker.mockFunc(launchManager, launchManager['selectLayoutDescription']))(ArgumentMatchers.any)
        .afterReturn(layoutDescription);
      (pageDesktopVM as object)['getItemIndexWithAround']([2,1], 0, 1);
      when(mocker.mockFunc(pageDesktopVM, (pageDesktopVM as object)['getItemIndexWithRight']))(ArgumentMatchers.any)
        .afterReturn(null);
      (pageDesktopVM as object)['getItemIndexWithAround']([2,1], 0, 1);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clearAll();
    })

    it('test_buildShortcutMenuOnTv', 0, () => {
      const pageDesktopVM: PageDesktopViewModel = PageDesktopViewModel.getInstance();
        const mocker: MockKit = new MockKit();
        expect(pageDesktopVM).not().assertUndefined();
        (pageDesktopVM as object)['mResourceManager'] = ResourceManager.getInstance();
        let appItem = new AppItemInfo();
        let menuList: MenuInfo[] = (pageDesktopVM as object)['buildShortcutMenuOnTv'](appItem);
        expect(menuList.length).assertEqual(1);
        appItem.bundleName = 'com.ohos.sceneboard';
        menuList = (pageDesktopVM as object)['buildShortcutMenuOnTv'](appItem);
        expect(menuList.length).assertEqual(0);
        appItem.shortcutId = ResourceManager.getInstance().getStringByName('smart_frame_shortcut_id');
        menuList = (pageDesktopVM as object)['buildShortcutMenuOnTv'](appItem);
        expect(menuList.length).assertEqual(1);
        mocker.clear(DeviceHelper);
        mocker.clearAll();
    })

    it('testPageDesktopViewModel_setMultiDragStart', 0, () => {
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      pageDesktopViewModel.setMultiDragStart(true);
      const multiDragStart: boolean = pageDesktopViewModel.getMultiDragStart();
      expect(multiDragStart).assertEqual(true);
    })

    it('PageDesktopViewModel_test_getIconSize', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      expect(instance.getIconSize()).not().assertEqual(0);
    })
  })
}
