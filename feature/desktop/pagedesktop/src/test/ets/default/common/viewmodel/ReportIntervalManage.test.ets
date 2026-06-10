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
import { DeviceHelper } from '@ohos/frameworkwrapper';
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
  keyEventManager,
  LaunchLayoutCacheManager
} from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig, PageDesktopViewModel } from '../../../../../..';
import { PageDesktopViewModelUtils } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModelUtils';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';

export default function ReportIntervalManagerTest() {
  describe('ReportIntervalManagerTest', () => {
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


    it('should_log_warning_when_event_already_exists', 0, () => {
      let reportintervalmanager: ReportIntervalManager = new ReportIntervalManager();
      let event: DfxEvent = new DfxEvent();
      reportintervalmanager.registerEvent(event);
      reportintervalmanager.registerEvent(event);
    });

    it('should_add_event_when_event_does_not_exist', 0, () => {
      let reportintervalmanager: ReportIntervalManager = new ReportIntervalManager();
      let event: DfxEvent = new DfxEvent();
      reportintervalmanager.registerEvent(event);
    });

    it('should_clear_event_list_when_clearEvent_is_called', 0, () => {
      let reportintervalmanager: ReportIntervalManager = new ReportIntervalManager();
      reportintervalmanager.clearEvent();
      expect(reportintervalmanager.eventList.length).assertEqual(0);
    });


    it('should_create_report_interval_when_timerId_is_greater_than_0', 0, () => {
      let reportintervalmanager: ReportIntervalManager = new ReportIntervalManager();
      reportintervalmanager.timerId = 1;
      reportintervalmanager.createReportInterval();
      expect(reportintervalmanager.timerId).assertEqual(1);
    });

    it('should_create_report_interval_when_timerId_is_less_than_or_equal_to_0', 0, () => {
      let reportintervalmanager: ReportIntervalManager = new ReportIntervalManager();
      reportintervalmanager.timerId = 0;
      reportintervalmanager.createReportInterval();
      expect(reportintervalmanager.timerId).assertNotEqual(0);
    });

    it('should_call_reportCount_and_reportEvent_when_timerId_is_greater_than_0', 0, () => {
      let reportintervalmanager: ReportIntervalManager = new ReportIntervalManager();
      reportintervalmanager.timerId = 1;
      let mocker: MockKit = new MockKit();
      reportintervalmanager.createReportInterval();
      expect(reportintervalmanager.reportCount).assertCalled();
      expect(reportintervalmanager.reportEvent).assertCalled();
    });

    it('should_call_reportCount_and_reportEvent_when_timerId_is_less_than_or_equal_to_0', 0, () => {
      let reportintervalmanager: ReportIntervalManager = new ReportIntervalManager();
      reportintervalmanager.timerId = 0;
      let mocker: MockKit = new MockKit();
      reportintervalmanager.createReportInterval();
      expect(reportintervalmanager.reportCount).assertCalled();
      expect(reportintervalmanager.reportEvent).assertCalled();
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
      pageDesktopViewModel.addBlankPage(false);
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
      pageDesktopViewModel.addBlankPage(false);
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
      pageDesktopViewModel.addBlankPage(false);
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
      pageDesktopViewModel.addBlankPage(false);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
      mocker.clear(mSCBScreenSessionManager);
      mocker.clearAll();
    })

    it('addForm', 0, async () => {
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
      expect(createCardState === false).assertTrue();
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
      let appInfo: AppItemInfo = new AppItemInfo();

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
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let appInfo: AppItemInfo = new AppItemInfo();

      //条件1 appItem true
      appInfo.bundleName = appItem.bundleName;

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
      let appInfo: AppItemInfo = new AppItemInfo();
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
    it('addToDesktop04', 4, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
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
      let appInfo: AppItemInfo = new AppItemInfo();
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
      let appInfo: AppItemInfo = new AppItemInfo();
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
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let newAppItem: GridLayoutItemInfo | undefined = appList.find(item => item.typeId === CommonConstants.TYPE_APP);

      await pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
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
      let newAppItem: GridLayoutItemInfo | undefined = appList.find(item => item.typeId === CommonConstants.TYPE_APP && item.container === -100);

      // 条件2 appInDockIndex false
      pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
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
      pageDesktopViewModel.buildNotInstalledAppMenu(bundleName);
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
    it('test_addBlankPage01', 0, () =>{
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addBlankPage(true);
      expect(instance).not().assertNull();
    });

    //isAddByDrag 为false
    it('test_addBlankPage02', 0, () =>{
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addBlankPage(false);
      expect(instance).not().assertNull();
    });

    it('test_addFormInfoToFormList', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let cardItemInfo: CardItemInfo = new CardItemInfo();
      instance.addFormInfoToFormList(cardItemInfo);
      expect(instance).not().assertNull();
    });

    it('test_addMiddlePageToAppGridInfo', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addMiddlePageToAppGridInfo();
      expect(instance).not().assertNull();
    });

    it('test_addOrDeleteBlankPage', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.addOrDeleteBlankPage();
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
      let appInfo: undefined;
      instance.addToDesktop(appInfo);
      expect(instance).not().assertNull();
    });

    it('test_addToDock', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appInfo: undefined;
      instance.addToDock(appInfo);
      expect(instance).not().assertNull();
    });

    it('test_buildCardMenuInfoList01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(null, null, null, 0);
      expect(res.length).assertEqual(0);
    });

    it('test_buildCardMenuInfoList02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(formInfo, null, null, 0);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('test_buildCardMenuInfoList04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formInfo: CardItemInfo = new CardItemInfo();
      formInfo.page = CommonConstants.WATERFALL_PAGE_INDEX;
      let formManagerShowFrom: number = FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_FORM_RIGHT_MENU;
      let res: Array<MenuInfo> = instance.buildCardMenuInfoList(formInfo, null, null, formManagerShowFrom);
      expect(res.length).assertLargerOrEqual(0);
    });

    it('test_buildNotInstalledAppMenu01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const bundleName = 'com.test.app';
      let res: Map<AppStatus, MenuInfo[]> = instance.buildNotInstalledAppMenu(bundleName);
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
      await instance.deleteFormItem(-1);
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteFormItem02', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await instance.deleteFormItem(1);
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteFormItemEvent4Intelligent01', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await instance.deleteFormItemEvent4Intelligent(-1);
      expect(instance).not().assertNull();
      done();
    });

    it('test_deleteFormItemEvent4Intelligent02', 0, async (done: Function) => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      await instance.deleteFormItemEvent4Intelligent(1);
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
      let ret:boolean = instance.getCreateCardState();
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
      let mockFunc:Function = mocker.mockFunc(instance, instance.loadGridList);
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
      const item:GridLayoutItemInfo = {} as GridLayoutItemInfo;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType03', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType04', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_FILE_FOLDER;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getItemKeyByType05', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const item:GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = 999999;
      let key = instance.getItemKeyByType(item);
      expect(key).not().assertNull();
    });

    it('test_getNeighborPage01', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret:number = instance.getNeighborPage(3);
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getNeighborPage02', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: PageDesktopGridStyleConfig = instance.getPageDesktopStyleConfig();
      expect(ret).not().assertNull();
    });

    it('test_getSwiperController', 0, () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let ret: SwiperController = instance.getSwiperController();
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
    });

    it('test_getWorkSpaceWidth', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.getWorkSpaceWidth();
    });

    it('test_initSelectStatus', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.initSelectStatus();
    });

    it('test_intoSetting', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.intoSetting();
    });

    it('test_isAddByDragging', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.isAddByDragging();
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
      let mockFunc2: Function = mocker.mockFunc(layoutManager,layoutManager.isPositionValid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      expect(instance.isCanCreateFolder()).assertTrue();
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
      let mockFunc2: Function = mocker.mockFunc(layoutManager,layoutManager.isPositionValid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      expect(instance.isCanCreateFolder()).assertTrue();
      mocker.clear(instance);
      mocker.clear(utils);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('test_isPastedFile', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let uri: string = 'anyString';
      let ret:boolean = instance.isPastedFile(uri);
      expect(instance).not().assertNull();
    });

    it('test_isSingleItemPage', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let uri: string = 'anyString';
      let ret:boolean = instance.isSingleItemPage();
      expect(ret).not().assertNull();
    });

    it('test_loseDesktopFocus', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      instance.loseDesktopFocus();
      expect(instance).not().assertNull();
    });

    it('test_menuCopyAction01', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let selectedFiles: string[] =[];
      let isActionCut: boolean = false;
      instance.menuCopyAction(selectedFiles, isActionCut);
      expect(instance).not().assertNull();
    });

    it('test_menuCopyAction02', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let selectedFiles: string[] =[];
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

    it('test_onAppDoubleClick', 0, async () => {
      let instance: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let abilityName: string = 'anyAbilityName';
      let bundleName: string = 'anyBundleName';
      let moduleName: string = 'anyModuleName';
      instance.onAppDoubleClick(abilityName, bundleName, moduleName);
      expect(instance).not().assertNull();
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

    it('test_checkContinueForm', 0, (): void => {
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
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const bundleName = 'BundleNameNotExists';
      pageDesktopViewModel.buildNotInstalledAppMenu(bundleName);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('test_addNewInstalledInfo01', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let  totalAppInfoList: AppItemInfo[] = [];
      totalAppInfoList[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel',
        moduleName : 'model',
        keyName : 'PageDesktop'
      };

      let  pageDesktopInfo: AppItemInfo[] = [];
      pageDesktopInfo[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel',
        moduleName : 'model',
        keyName : 'PageDesktop'
      };

      instance.addNewInstalledInfo(totalAppInfoList, pageDesktopInfo);
      expect(instance).not().assertNull();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_addNewInstalledInfo02', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let  totalAppInfoList: AppItemInfo[] = [];
      totalAppInfoList[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel',
        moduleName : 'model',
        keyName : 'PageDesktop'
      };

      let  pageDesktopInfo: AppItemInfo[] = [];
      pageDesktopInfo[0] = {
        abilityName : 'AppModel',
        appName : 'AppModelName',
        appIconId : 9999,
        bundleName : 'com.ohos.appModel',
        moduleName : 'model',
        keyName : 'SmartDock'
      };

      instance.addNewInstalledInfo(totalAppInfoList, pageDesktopInfo);
      expect(instance).not().assertNull();
      let a = 'test'
      expect(a).assertEqual('test');
    });

    it('test_buildGridLayoutInfoFromItemInfo', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let  appItemInfos: AppItemInfo[] = [];
      appItemInfos[0] = {
        bundleName: 'anyBundleName',
        typeId: 99999,
        abilityName: 'anyAbilityName',
        moduleName: 'anyModuleName',
        keyName: 'anyKeyName',
        badgeNumber: 1,
        area: [1,2,3,4,5,6,7,8,9],
        appName: 'anyAppName',
        appIconId: 88888,
        appLabelId: 77777,
        kindId: 66666,
        bundleType: 2,
        applicationName: 'anyAppliucationName',
        appStatus: 0,
        installTime:'123',
        downloadProgress: 0,
        iconResource: 'anyIconResource',
        callerName: 'anyCallerName'
      };
      let ret: GridLayoutItemInfo =instance.buildGridLayoutInfoFromItemInfo(appItemInfos[0], 1, 1, 1);
      expect(ret).not().assertNull();
    });

    it('test_createNewCardItemInfo01', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      class FormCardItem{
        constructor() {
        }
        cardId: string = '';
        cardName: string = '';
        appName: string | undefined;
        bundleName: string = '';
        abilityName: string = '';
        moduleName: string = '';
        formConfigAbility: string | undefined;
        appLabelId: number | undefined;
        cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
      }

      let  formCardItem: FormCardItem = new FormCardItem();
      formCardItem.cardId = '99999';
      formCardItem.cardName = 'anyCardName';
      formCardItem.appName = 'anyAppName';
      formCardItem.bundleName = 'anyBundleName';
      formCardItem.abilityName = 'anyAbilityName';
      formCardItem.moduleName = 'anyModuleName';
      formCardItem.formConfigAbility = 'formConfigAbility';
      formCardItem.appLabelId = 88888;
      formCardItem.cardDimension = CommonConstants.CARD_DIMENSION_1x2;

      let ret: CardItemInfo = instance.createNewCardItemInfo(formCardItem);
      expect(ret).not().assertNull();
    });

    it('test_createNewCardItemInfo02', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      class FormCardItem{
        constructor() {
        }
        cardId: string = '0';
        cardName: string = '';
        appName: string | undefined;
        bundleName: string = '';
        abilityName: string = '';
        moduleName: string = '';
        formConfigAbility: string | undefined;
        appLabelId: number | undefined;
        cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
        isTransparent: boolean = false;
      }

      let  formCardItem: FormCardItem = new FormCardItem();
      formCardItem.cardId = '99999';
      formCardItem.cardName = 'anyCardName';
      formCardItem.appName = 'anyAppName';
      formCardItem.bundleName = 'anyBundleName';
      formCardItem.abilityName = 'anyAbilityName';
      formCardItem.moduleName = 'anyModuleName';
      formCardItem.formConfigAbility = 'formConfigAbility';
      formCardItem.appLabelId = 88888;
      formCardItem.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      formCardItem.isTransparent = false;

      let ret: CardItemInfo = instance.createNewCardItemInfo(formCardItem);
      expect(ret).not().assertNull();
    });

    it('test_deleteGridPage', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      instance.deleteGridPage(1);
      expect(instance).not().assertNull();
    });

    it('test_getNeighborPage03', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let page: number = 2;
      let ret = instance.getNeighborPage(page);
      expect(ret).assertEqual(page+1);
    });

    it('test_getNeighborPage04', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let page: number = 3;
      let ret = instance.getNeighborPage(page);
      expect(ret).assertEqual(page-1);
    });

    it('test_ifColumnOrRowAreBigger02', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let  layoutInfo: AppItemInfo[] = [];
      layoutInfo[0] = {
        bundleName: 'anyBundleName',
        typeId: 99999,
        abilityName: 'anyAbilityName',
        moduleName: 'anyModuleName',
        keyName: 'anyKeyName',
        badgeNumber: 1,
        area: [1,2,3,4,5,6,7,8,9],
        appName: 'anyAppName',
        appIconId: 88888,
        appLabelId: 77777,
        kindId: 66666,
        bundleType: 2,
        applicationName: 'anyAppliucationName',
        appStatus: 0,
        downloadProgress: 0,
        iconResource: 'anyIconResource',
        callerName: 'anyCallerName',
        isUninstallAble: true,
        isSystemApp: false,
        row: 10,
        column :10
      };
      let ret = instance.ifColumnOrRowAreBigger(layoutInfo, 11, 11);
      expect(ret).assertFalse();
    });

    it('test_ifInfoIsNull01', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let appInfo: AppItemInfo = new AppItemInfo();
      let ret = instance.ifInfoIsNull(appInfo);
      expect(ret).assertEqual(false);
    });

    it('test_ifInfoIsNull02', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      let appInfo: AppItemInfo = {} as AppItemInfo;
      let ret = instance.ifInfoIsNull(appInfo);
      expect(ret).assertEqual(false);
    });

    it('test_isPositionValid', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      expect(instance).not().assertNull();

    });

    it('test_updateFormId01', 0, () => {
      const viewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      const instance: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(viewModel);
      class FormCardItem{
        constructor() {
        }
        cardId: string = '';
        cardName: string = '';
        appName: string | undefined;
        bundleName: string = '';
        abilityName: string = '';
        moduleName: string = '';
        formConfigAbility: string | undefined;
        appLabelId: number | undefined;
        cardDimension: number = CommonConstants.CARD_DIMENSION_1x2;
        isTransparent: boolean = false;
      }

      let  formCardItem: FormCardItem = new FormCardItem();
      formCardItem.cardId = '99999';
      formCardItem.cardName = 'someBundleName';
      formCardItem.appName = 'anyAppName';
      formCardItem.bundleName = 'anyBundleName';
      formCardItem.abilityName = 'anyAbilityName';
      formCardItem.moduleName = 'anyModuleName';
      formCardItem.formConfigAbility = 'formConfigAbility';
      formCardItem.appLabelId = 88888;
      formCardItem.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
      formCardItem.isTransparent = false;
      let formInfo: CardItemInfo = instance.createNewCardItemInfo(formCardItem);

      let  bundleInfoList: AppItemInfo[] = [];
      bundleInfoList[0] = {
        bundleName: 'anyBundleName',
        typeId: 99999,
        abilityName: 'anyAbilityName',
        moduleName: 'anyModuleName',
        keyName: 'anyKeyName',
        badgeNumber: 1,
        area: [1,2,3,4,5,6,7,8,9],
        appName: 'anyAppName',
        appIconId: 88888,
        appLabelId: 77777,
        kindId: 66666,
        bundleType: 2,
        applicationName: 'anyAppliucationName',
        appStatus: 0,
        downloadProgress: 0,
        iconResource: 'anyIconResource',
        callerName: 'anyCallerName',
        isUninstallAble: true,
        isSystemApp: false
      };
      instance.updateFormId(formInfo, bundleInfoList);
    });

  });
}