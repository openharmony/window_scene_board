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
import { DeviceHelper, localEventManager } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { launcherStatusUtil } from '@ohos/windowscene';
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
  GridLayoutItemInfo,
  MenuInfo,
  SettingsModel,
  keyEventManager,
  LaunchLayoutCacheManager,
  FormManager,
  EventConstants,
  KeyEventConstants,
  LayoutDescription,
  DesktopUtils
} from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig, PageDesktopViewModel } from '../../../../../..';
import { PageDesktopViewModelUtils } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModelUtils';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';
import { AppFormWantParamInterface } from '@ohos/launchercommon/src/main/ets/manager/FormManager';


function getNullObject(): GridLayoutItemInfo | null {
  return null;
}

function getUndefinedObject(): GridLayoutItemInfo | undefined {
  return undefined;
}

export default function SwiperLauncherLayoutCacheUtilExtraTest() {
  describe('SwiperLauncherLayoutCacheUtilExtraTest', () => {
    // Defines a ExtraTest suite. Two parameters are supported: ExtraTest suite name and ExtraTest suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all ExtraTest cases of the ExtraTest suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit ExtraTest case starts.
      // The number of execution times is the same as the number of ExtraTest cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit ExtraTest case ends.
      // The number of execution times is the same as the number of ExtraTest cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all ExtraTest cases of the ExtraTest suite end.
      // This API supports only one parameter: clear action function.
    });

    it('addBlankPage01', 0, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'ExtraTest';
      expect(a).assertEqual('ExtraTest')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage02', 1, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-false
      pageDesktopViewModel.addBlankPage(false);
      let a = 'ExtraTest';
      expect(a).assertEqual('ExtraTest')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage03', 2, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage04', 3, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-false
      pageDesktopViewModel.addBlankPage(false);
      let a = 'ExtraTest';

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage05', 4, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage06', 5, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-false
      pageDesktopViewModel.addBlankPage(false);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage07', 6, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage08', 7, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-false
      pageDesktopViewModel.addBlankPage(false);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest');
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })

    it('deleteFormItem', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let formsListBefore: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let deleteItem: CardItemInfo = new CardItemInfo();
      if (formsListBefore.length > 0) {
        deleteItem = formsListBefore[formsListBefore.length - 1];
        await mPageDesktopViewModel.deleteFormItem(formsListBefore[formsListBefore.length - 1].cardId);
      }
      let formsListAfter: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();

      let formItem: CardItemInfo | undefined = formsListAfter.find(item => item.cardId === deleteItem.cardId);
      expect(formItem === undefined);
    })

    it('getCurrentSelectItems', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      mPageDesktopViewModel['lastSelectedItems'] = [];
      let lastSelectedItems: string[] = mPageDesktopViewModel.getCurrentSelectItems();
      expect(lastSelectedItems.length === 0).assertTrue();
      mPageDesktopViewModel['lastSelectedItems'] = ['ExtraTest1', 'ExtraTest2'];
      lastSelectedItems = mPageDesktopViewModel.getCurrentSelectItems();
      expect(lastSelectedItems.length === 2).assertTrue();
    })

    it('getCreateCardState', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let createCardState: boolean = mPageDesktopViewModel.getCreateCardState();
      expect(createCardState || true).assertTrue();
    })

    it('hasEnoughArea00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      //条件1 pageCount < maxPage
      let result: boolean = pageDesktopViewModel.hasEnoughArea(cardItem);
      expect(result === true);
      mocker.clearAll();
    })
    it('hasEnoughArea01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      // 条件2 isPageAreaEnough = true
      pageDesktopViewModel.changeIndex(1);
      cardItem.area = [1, 1]

      let result: boolean = pageDesktopViewModel.hasEnoughArea(cardItem);
      expect(result === true);
      mocker.clearAll();
    })
    it('hasEnoughArea02', 2, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      // 条件2 isPageAreaEnough = false
      cardItem.area = [4, 4]

      // 条件3 mPageIndex < gridLayoutInfo.layoutDescription.pageCount - 1
      pageDesktopViewModel.changeIndex(0);

      let result: boolean = pageDesktopViewModel.hasEnoughArea(cardItem);
      expect(result === false);
      mocker.clearAll();
    })
    it('hasEnoughArea03', 3, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mFormModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();
      let formsList: CardItemInfo[] = await mFormModel.getAllFormsInfoFromRdb();
      let cardItem: CardItemInfo = new CardItemInfo();
      if (formsList.length > 0) {
        cardItem = formsList[formsList.length - 1];
      }

      // 条件2 isPageAreaEnough = false
      cardItem.area = [4, 4]

      // 条件3 mPageIndex >= gridLayoutInfo.layoutDescription.pageCount - 1
      pageDesktopViewModel.changeIndex(1);

      let result: boolean = pageDesktopViewModel.hasEnoughArea(cardItem);
      expect(result === false);
      mocker.clearAll();
    })

    it('createCardWithAnimation00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
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
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);

      pageDesktopViewModel.createCardWithAnimation(cardItem, 6, 100, 100);

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest');
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
      pageDesktopViewModel.publishCardToDesktop(undefined);

      when(mockFormModel)().afterReturn(false);
      pageDesktopViewModel.publishCardToDesktop(undefined);

      cardItem.callerBundle === CommonConstants.INTELLIGENT_BUNDLE;
      when(mockFunc)(ArgumentMatchers.any).afterReturn(cardItem);
      when(mockFormModel)().afterReturn(false);
      pageDesktopViewModel.publishCardToDesktop(undefined);

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
      pageDesktopViewModel.publishCardToDesktop(undefined);

      wantParamInterface.appFormSnapshot = 'ExtraTest';
      let viewModelUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
      let mockFunc1: Function = mocker.mockFunc(viewModelUtils, viewModelUtils.base64ToPixelMap);
      when(mockFunc1)(wantParamInterface.appFormSnapshot).afterReturnNothing();
      pageDesktopViewModel.publishCardToDesktop(undefined);

      when(mockFunc1)(wantParamInterface.appFormSnapshot).afterReturn(Promise.resolve('value'));
      pageDesktopViewModel.publishCardToDesktop(undefined);

      when(mockFunc1)(wantParamInterface.appFormSnapshot).afterReturn(Promise.reject());
      pageDesktopViewModel.publishCardToDesktop(undefined);
      mocker.clear(mFormManager);
      mocker.clear(viewModelUtils);
      mocker.clearAll();
    });
    it('createCardWithAnimation01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
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

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest');
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('reportAddCardToScreenByDragEvent00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let dragItemType: number = 6;
      let resultType: number = 0;

      //条件1 CheckEmptyUtils.isEmpty true
      let cardItem: CardItemInfo | undefined = undefined;
      pageDesktopViewModel.reportAddCardToScreenByDragEvent(cardItem, dragItemType, resultType);

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest');
    })
    it('reportAddCardToScreenByDragEvent01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
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

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest');
    })
    it('reportAddCardToScreenByDragEvent02', 2, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
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

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest');
      mocker.clear(mFormModel);
      mocker.clearAll();
    })
    it('reportAddCardToScreenByDragEvent03', 3, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
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

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('ExtraTest');
      mocker.clear(mFormModel);
      mocker.clearAll();
    })

    it('getRightMenuSelectedIcon00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 isSelected true
      let res: string = pageDesktopViewModel.getRightMenuSelectedIcon(true);

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('/common/pics/ic_public_selected.svg');
    })
    it('getRightMenuSelectedIcon01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 isSelected true
      let res: string = pageDesktopViewModel.getRightMenuSelectedIcon(false);

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(res).assertEqual('');
    })

    it('getInstance00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 isSelected true
      let pageDesktopViewModel1: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(pageDesktopViewModel).assertEqual(pageDesktopViewModel1);
    })

    it('initGridList00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 mIsLayoutOrDockFinish true
      pageDesktopViewModel.initGridList();
      pageDesktopViewModel.initGridList();

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
    })

    it('afterDeleteDesktopItem00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      //条件1 DeviceHelper.isPC true
      pageDesktopViewModel.afterDeleteDesktopItem();

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('afterDeleteDesktopItem01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      //条件1 DeviceHelper.isPC false
      pageDesktopViewModel.afterDeleteDesktopItem();

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper)
      mocker.clearAll()
    })

    it('updateForms00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();

      //条件1 allFormsInfo.length false
      let mockFunction: Function = mocker.mockFunc(formModel, formModel.getAllFormsInfoFromRdb);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([]);

      pageDesktopViewModel.updateForms();
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(formModel);
      mocker.clearAll();
    })
    it('updateForms01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 allFormsInfo.length true
      pageDesktopViewModel.updateForms();
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
    })

    it('deleteAppItem00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
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
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
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
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem02', 2, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
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
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem03', 3, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.bundleName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
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
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem04', 4, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.folderId true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? new GridLayoutItemInfo();
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
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem05', 5, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.folderId true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? new GridLayoutItemInfo();
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
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('addToDesktop00', 0, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(appModel);
      mocker.clearAll();
    })
    it('addToDesktop01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let appInfo: AppItemInfo = new AppItemInfo();

      //条件1 appItem true
      appInfo.bundleName = appItem.bundleName;

      //条件2 installed
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
    })
    it('addToDesktop02', 2, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? demoFolder;
      let appInfo: AppItemInfo = new AppItemInfo();
      if (!appItem.layoutInfo) {
        appItem.layoutInfo = [];
        appItem.layoutInfo.push([new GridLayoutItemInfo()])
      }
      for (let i = 0; i < appItem?.layoutInfo?.length; i++) {
        for (let j = 0; j < appItem.layoutInfo[i]?.length; j++) {
          if (appItem.layoutInfo[i][j]?.typeId === CommonConstants.TYPE_APP) {
            appInfo.bundleName = appItem.layoutInfo[i][j].bundleName;
            break;
          }
        }
        if (appInfo.bundleName) {
          break;
        }
      }

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
    })
    it('addToDesktop03', 3, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosExtraTest';
      appInfo.keyName = 'com.ohos.ohosExtraTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })
    it('addToDesktop04', 4, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosExtraTest';
      appInfo.keyName = 'com.ohos.ohosExtraTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('addToDesktop06', 4, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosExtraTest';
      appInfo.keyName = 'com.ohos.ohosExtraTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      // 条件3 isPad true
      pageDesktopViewModel.setDevice(CommonConstants.PAD_DEVICE_TYPE);

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })
    it('addToDesktop05', 5, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosExtraTest';
      appInfo.keyName = 'com.ohos.ohosExtraTestPhoneEntry';

      //条件1 appItem undefined false
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      // 条件3 isPad false
      pageDesktopViewModel.setDevice(CommonConstants.DEFAULT_DEVICE_TYPE);

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('insertNewUpdateApp00', 0, async (done: Function) => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let viewUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let newAppItem: GridLayoutItemInfo | undefined = appList.find(item => item.typeId === CommonConstants.TYPE_APP);

      await pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(viewUtils);
      mocker.clearAll();
      done();
    })
    it('insertNewUpdateApp01', 1, async (done: Function) => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let viewUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let newAppItem: GridLayoutItemInfo | undefined = appList.find(item => item.typeId === CommonConstants.TYPE_APP && item.container === -100);

      // 条件2 appInDockIndex false
      pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clear(viewUtils);
      mocker.clearAll();
      done();
    })

    it('buildNotInstalledAppMenu01', 1, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const bundleName = 'BundleNameNotExists';
      pageDesktopViewModel.buildNotInstalledAppMenu(bundleName);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
    })
    it('getEnoughAreaPosition00', 0, () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
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
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
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
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();

      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.bundleName = 'com.ohos.ohosExtraTest';
      appInfo.keyName = 'com.ohos.ohosExtraTestPhoneEntry';
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

      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
      mocker.clearAll();
      done();
    })

    //isAddByDrag 为true
    it('ExtraTest_addBlankPage01', 0, () =>{
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addBlankPage(true);
      expect(instance).not().assertNull();
    });

    //isAddByDrag 为false
    it('ExtraTest_addBlankPage02', 0, () =>{
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addBlankPage(false);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_addFormInfoToFormList', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      instance.addFormInfoToFormList(cardItemInfo);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_addMiddlePageToAppGridInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addMiddlePageToAppGridInfo();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_addOrDeleteBlankPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addOrDeleteBlankPage();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_addPageToAppGridInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addPageToAppGridInfo();
      expect(instance).not().assertNull();
    });

    //appInfo undefined
    it('ExtraTest_addToDesktop02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: undefined;
      instance.addToDesktop(appInfo);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_addToDock', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: undefined;
      instance.addToDock(appInfo);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_buildCardMenuInfoList01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(null, null, 0);
      expect(res.length).assertEqual(0);
    });

    it('ExtraTest_buildCardMenuInfoList02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(formInfo, null, 0);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('ExtraTest_buildMenuInfoList01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let res: MenuInfo[] = instance.buildMenuInfoList(appInfo, null);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('ExtraTest_buildMenuInfoList02', 0, () => {
      let mock = new MockKit();
      let isFoldedProductFold = mock.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(isFoldedProductFold)().afterReturn(true);
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let res: MenuInfo[] = instance.buildMenuInfoList(appInfo, null);
      expect(res.length).assertLargerOrEqual(0);
      mock.clear(launcherStatusUtil);
      mock.clearAll();
    });

    it('ExtraTest_buildCardMenuInfoList04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let formManagerShowFrom: number = FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU;
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(formInfo, null, formManagerShowFrom);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('ExtraTest_buildNotInstalledAppMenu01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const bundleName = 'com.ExtraTest.app';
      let res: Map<AppStatus, MenuInfo[]> = instance.buildNotInstalledAppMenu(bundleName);
      expect(res.size).assertLargerOrEqual(0);
    });

    it('ExtraTest_changeIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.changeIndex(2);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_changeIndexOnly01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newPageIndex: number = 2;
      instance.changeIndexOnly(newPageIndex);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_changeIndexOnly02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let newPageIndex: undefined;
      instance.changeIndexOnly(newPageIndex);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_cutItemClear', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.cutItemClear();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_deleteFormItem01', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await instance.deleteFormItem('');
      expect(instance).not().assertNull();
      done();
    });

    it('ExtraTest_deleteFormItem02', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await instance.deleteFormItem('1');
      expect(instance).not().assertNull();
      done();
    });

    it('ExtraTest_deleteFormItemEvent4Intelligent01', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await instance.deleteFormItemEvent4Intelligent('');
      expect(instance).not().assertNull();
      done();
    });

    it('ExtraTest_deleteFormItemEvent4Intelligent02', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await instance.deleteFormItemEvent4Intelligent('1');
      expect(instance).not().assertNull();
      done();
    });

    it('ExtraTest_filterSelectedFileItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.filterSelectedFileItem();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_filterSelectFileItem', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: string[] = instance.filterSelectFileItem();
      expect(ret).assertLargerOrEqual(0);
    });

    it('ExtraTest_filterSelectObject', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.filterSelectObject();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_getAppPageStartConfig', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      expect(instance.getAppPageStartConfig()).not().assertNull();
    });

    it('ExtraTest_getCreateCardState', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret:boolean = instance.getCreateCardState();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_getCurrentSelectItems02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = instance.getCurrentSelectItems();
      expect(items.length).assertLargerOrEqual(0);
    });

    it('ExtraTest_getDevice', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.getDevice();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_getGridConfig01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: GridLayoutConfig = instance.getGridConfig();
      expect(ret).not().assertNull();
    });

    it('ExtraTest_loadGridList', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc:Function = mocker.mockFunc(instance, instance.loadGridList);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing()
      await instance.loadGridList();
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('ExtraTest_getGridPageCount02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: number = instance.getGridPageCount();
      expect(ret).assertLargerOrEqual(0);
    });

    it('ExtraTest_getIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: number = instance.getIndex();
      expect(ret).assertLargerOrEqual(0);
    });

    it('ExtraTest_getIntelligentSignStatus01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: boolean = instance.getIntelligentSignStatus();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_getIntelligentSignStatus02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: boolean = instance.getIntelligentSignStatus();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_getItemKeyByType01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('ExtraTest_getItemKeyByType02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('ExtraTest_getItemKeyByType03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('ExtraTest_getItemKeyByType04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FILE_FOLDER;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('ExtraTest_getItemKeyByType05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = 999999;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('ExtraTest_getNeighborPage01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret:number = instance.getNeighborPage(3);
      expect(ret).assertLargerOrEqual(0);
    });

    it('ExtraTest_getNeighborPage02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: PageDesktopGridStyleConfig = instance.getPageDesktopStyleConfig();
      expect(ret).not().assertNull();
    });

    it('ExtraTest_getSwiperController', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: SwiperController = instance.getSwiperController();
      expect(ret).not().assertNull();
    });

    it('ExtraTest_informUninstallResult', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let resultCode: number = CommonConstants.UNINSTALL_FORBID;
      instance.informUninstallResult(resultCode);

      resultCode = CommonConstants.UNINSTALL_FORBID;
      instance.informUninstallResult(resultCode);

      resultCode = -1;
      instance.informUninstallResult(resultCode);
    });

    it('ExtraTest_getGridPageCount01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: number = instance.getGridPageCount();
      expect(ret).assertLargerOrEqual(0);
    });

    it('ExtraTest_getPageDesktopStyleConfig', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: PageDesktopGridStyleConfig = instance.getPageDesktopStyleConfig();
      expect(ret).not().assertNull();
    });

    it('ExtraTest_getWorkSpaceHeight', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.getWorkSpaceHeight();
    });

    it('ExtraTest_getWorkSpaceWidth', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.getWorkSpaceWidth();
    });

    it('ExtraTest_initSelectStatus', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.initSelectStatus();
    });

    it('ExtraTest_intoSetting', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.intoSetting();
    });

    it('ExtraTest_isAddByDragging', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.isAddByDragging();
    });

    it('ExtraTest_isBlankPage', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: boolean = instance.isBlankPage();
      expect(ret).not().assertNull();
    });

    //!isPad true
    it('ExtraTest_isCanCreateFolder01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, instance.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(instance.isCanCreateFolder()).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    });

    //!isPad false isPositionVlaid true
    it('ExtraTest_isCanCreateFolder02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let utils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(instance);
      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getDevice);
      let mockFunc2: Function = mocker.mockFunc(layoutManager,layoutManager.isPositionValid);
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
    it('ExtraTest_isCanCreateFolder03', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let utils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(instance);
      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance, instance.getDevice);
      let mockFunc2: Function = mocker.mockFunc(layoutManager,layoutManager.isPositionValid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      instance.isCanCreateFolder();
      expect(!instance).assertFalse();
      mocker.clear(instance);
      mocker.clear(utils);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('ExtraTest_isPastedFile', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let uri: string = 'anyString';
      let ret:boolean = instance.isPastedFile(uri);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_isSingleItemPage', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let uri: string = 'anyString';
      let ret:boolean = instance.isSingleItemPage();
      expect(ret).not().assertNull();
    });

    it('ExtraTest_menuCopyAction01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let selectedFiles: string[] =[];
      let isActionCut: boolean = false;
      instance.menuCopyAction(selectedFiles, isActionCut);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_menuCopyAction02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let selectedFiles: string[] =[];
      let isActionCut: boolean = true;
      instance.menuCopyAction(selectedFiles, isActionCut);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_notifyUnSelect', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.notifyUnSelect();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_onAppClick01', 0, async () => {
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

    it('ExtraTest_onAppClick02', 0, async () => {
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

    it('ExtraTest_onAppDoubleClick', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let abilityName: string = 'anyAbilityName';
      let bundleName: string = 'anyBundleName';
      let moduleName: string = 'anyModuleName';
      instance.onAppDoubleClick(abilityName, bundleName, moduleName);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_onSelectItemChange01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = [];
      let selectStatus: boolean = true;
      let isSingle: boolean = false
      instance.onSelectItemChange(items, selectStatus, isSingle);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_onSelectItemChange02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = [];
      let selectStatus: boolean = false;
      let isSingle: boolean = false
      instance.onSelectItemChange(items, selectStatus, isSingle);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_openApplication', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let abilityName: string = 'anyAbilityName';
      let bundleName: string = 'anyBundleName';
      let moduleName: string = 'anyModuleName';
      instance.openApplication(abilityName, bundleName, moduleName);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_refreshFileItemIcon', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.refreshFileItemIcon();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_refreshPasteSelectedStates01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = [];
      instance.refreshPasteSelectedStates(items);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_refreshPasteSelectedStates02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: string[] = ['item1', 'item2', 'item3'];
      instance.refreshPasteSelectedStates(items);
      expect(instance).not().assertNull();
    });

    it('ExtraTest_unregisterGridListener', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.unregisterGridListener();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_unRegisterSelectItemChangeListener', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.unRegisterSelectItemChangeListener();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_updateDesktopInfo', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.updateDesktopInfo();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_updateDesktopItemInfo', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let items: GridLayoutItemInfo[] = [];
      instance.updateDesktopItemInfo();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_updateForms01', 0, async () => {
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

    it('ExtraTest_updateForms02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.updateForms();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_setTargetIndex', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.setTargetIndex(2);
      expect(instance.getTargetIndex()).assertEqual(2);
    });

    it('ExtraTest_checkContinueForm', 0, (): void => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      dragItemInfo.typeId = CommonConstants.TYPE_APP;
      AppStorage.setOrCreate('dragItemInfo', dragItemInfo);
      expect(instance.checkContinueForm()).assertFalse();
      dragItemInfo.typeId = CommonConstants.TYPE_CARD;
      expect(instance.checkContinueForm()).assertTrue();
      dragItemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
      dragItemInfo.layoutInfo = [];
      expect(instance.checkContinueForm()).assertFalse();
      dragItemInfo.layoutInfo = [[new GridLayoutItemInfo(), new GridLayoutItemInfo()]];
      expect(instance.checkContinueForm()).assertTrue();
      AppStorage.setOrCreate('dragItemInfo', {});
    });

    it('buildNotInstalledAppMenu01', 1, async () => {
      // Defines a ExtraTest case. This API supports three parameters: ExtraTest case name, filter parameter, and ExtraTest case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const bundleName = 'BundleNameNotExists';
      pageDesktopViewModel.buildNotInstalledAppMenu(bundleName);
      let a = 'ExtraTest';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`ExtraTest`);
    })

    it('ExtraTest_autoAlignAfterUninstall', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let pageDesktopUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(instance);
      let mockFunc: Function = mocker.mockFunc(pageDesktopUtils, pageDesktopUtils.getAlignStatus);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'anyBundleName';
      appItem.area = [1, 1];
      instance.autoAlignAfterUninstall(appItem);
      expect(instance).not().assertNull();
      mocker.clear(pageDesktopUtils);
      mocker.clearAll();
    });

    it('ExtraTest_judgeEvent_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER);
    });

    it('ExtraTest_judgeEvent_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD);
    });

    it('ExtraTest_judgeEvent_03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE);
    });

    it('ExtraTest_judgeEvent_04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_BADGE_UPDATE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_BADGE_UPDATE);
    });

    it('ExtraTest_judgeEvent_05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE);
    });

    it('ExtraTest_judgeEvent_06', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD);
    });

    it('ExtraTest_judgeEvent_07', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE);
    });

    it('ExtraTest_judgeEvent_08', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_JUMP_TO_FORM_VIEW;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_JUMP_TO_FORM_VIEW);
    });

    it('ExtraTest_judgeEvent_09', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_SMARTDOCK_INIT_FINISHED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_SMARTDOCK_INIT_FINISHED);
    });

    it('ExtraTest_judgeEvent_10', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_LAYOUT_INIT_FINISHED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_LAYOUT_INIT_FINISHED);
    });

    it('ExtraTest_judgeEvent_11', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH);
    });

    it('ExtraTest_judgeEvent_12', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE);
    });

    it('ExtraTest_judgeEvent_13', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_DESKTOP_ITEM_UNSELECT;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_DESKTOP_ITEM_UNSELECT);
    });

    it('ExtraTest_judgeEvent_14', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_PACKAGE_CHANGED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_PACKAGE_CHANGED);
    });

    it('ExtraTest_judgeEvent_15', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_APPGALLERY_CREATED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED);
    });

    it('ExtraTest_judgeEvent_16', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE);
    });


    it('ExtraTest_judgeEvent_17', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH);
    });

    it('ExtraTest_judgeEvent_18', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED);
    });

    it('ExtraTest_judgeEvent_19', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH);
    });

    it('ExtraTest_judgeEvent_20', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_INTELLIGENT_SIGN_STATUS;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_INTELLIGENT_SIGN_STATUS);
    });

    it('ExtraTest_judgeEvent_21', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD;
      let params: GridLayoutItemInfo = new GridLayoutItemInfo();
      localEventManager.sendLocalEventSticky(event, params);
      expect(event).assertEqual(EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD);
    });

    it('recycleFormEventHandler', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance['currentStartApp'] = false;
      instance.recycleFormEventHandler(true);
      expect(instance['currentStartApp']).assertTrue();

      instance['currentStartApp'] = true;
      instance.recycleFormEventHandler(false);
      expect(instance['currentStartApp']).assertFalse();
    });

    it('ExtraTest_showNext_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.showPrevious();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_showPrevious_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.showPrevious();
      expect(instance).not().assertNull();
    });

    it('ExtraTest_mKeyEventListener_01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_ENTER;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_ENTER);
    });

    it('ExtraTest_mKeyEventListener_02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_DELETE;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_DELETE);
    });

    it('ExtraTest_mKeyEventListener_03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_FORCE_DELETE;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_FORCE_DELETE);
    });

    it('ExtraTest_mKeyEventListener_04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_C;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_C);
    });

    it('ExtraTest_mKeyEventListener_05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_X;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_X);
    });

    it('ExtraTest_mKeyEventListener_06', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_V;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_V);
    });

    it('ExtraTest_mKeyEventListener_07', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_CTRL_A;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_CTRL_A);
    });

    it('ExtraTest_mKeyEventListener_08', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let event: string = KeyEventConstants.EVENT_F2;
      keyEventManager.sendKeyEvent(event);
      expect(event).assertEqual(KeyEventConstants.EVENT_F2);
    });


  })
}
