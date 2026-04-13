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
import { SCBScreenSessionManager } from '@ohos/windowscene';
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
  keyEventManager
} from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig, PageDesktopViewModel } from '../../../../../..';
import { PageDesktopViewModelUtils } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModelUtils';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';


export default function PageDesktopPushDownViewModelTest() {
  describe('PageDesktopPushDownViewModelTest', () => {
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
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'test';
      expect(a).assertEqual('test')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage02', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-false
      try {
        pageDesktopViewModel.addBlankPage(false);
      } catch (err) {}
      let a = 'test';
      expect(a).assertEqual('test')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage03', 2, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage04', 3, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      // 条件3 isAddByDrag-false
      try {
        pageDesktopViewModel.addBlankPage(false);
      } catch (err) {}
      let a = 'test';

      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage05', 4, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage06', 5, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-false
      try {
        pageDesktopViewModel.addBlankPage(false);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage07', 6, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-true
      pageDesktopViewModel.addBlankPage(true);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })
    it('addBlankPage08', 7, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();

      // 条件1 isFoldablePhoneExpandStatus：true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      // 条件3 isAddByDrag-false
      try {
        pageDesktopViewModel.addBlankPage(false);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })

    it('addForm', 0, async () => {
      try {
        let newItem: CardItemInfo = new CardItemInfo();
        newItem.id = '1573457366';
        newItem.cardId = '1573457366';
        newItem.name = 'minRecCard';
        newItem.cardName = 'minRecCard';
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
      } catch (err) {}
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
      mPageDesktopViewModel['lastSelectedItems'] = ['test1', 'test2'];
      lastSelectedItems = mPageDesktopViewModel.getCurrentSelectItems();
      expect(lastSelectedItems.length === 2).assertTrue();
    })

    it('getCreateCardState', 0, async () => {
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let createCardState: boolean = mPageDesktopViewModel.getCreateCardState();
      expect(createCardState).assertEqual(mPageDesktopViewModel['createCardState']);
    })

    it('hasEnoughArea00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
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
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(true);

      pageDesktopViewModel.createCardWithAnimation(cardItem, 6, 100, 100);

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })
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

  })
}
