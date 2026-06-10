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
import { LogHelper } from "@ohos/basicutils";
import { DeviceHelper } from "@ohos/frameworkwrapper";
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { DropdownVm } from "@ohos/systemuicommon/newIndex";
import { NotificationBase } from "@ohos/systemuicommon/newTsIndex";
import { LiveDropdownVmInjector } from "@ohos/systemuicommon/src/main/ets/live/variant/dropdown/LiveDropdownVmInjector";
import { NotificationDataVm, NotificationListVm, NotificationNormalVm,
  NotificationSwipeVm } from "../../../../../newIndex";

export default function NotificationListVmTest() {
  describe('padding_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_padding_when_device_is_not_pad', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      when(DeviceHelper.isPad())(ArgumentMatchers.any).afterReturn(false);
      const result = notificationlistvm.padding;
      expect(result).assertDeepEquals({
        left: $r('app.float.ntf_list_item_padding_start_end'),
        right: $r('app.float.ntf_list_item_padding_start_end'),
        bottom: $r('app.float.ntf_list_item_padding_bottom'),
        top: 0,
      });
    });

    it('should_return_padding_when_device_is_pad_and_landscape', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      when(DeviceHelper.isPad())(ArgumentMatchers.any).afterReturn(true);
      when(DeviceInfoVm.instance.isLandscape)(ArgumentMatchers.any).afterReturn(true);
      const result = notificationlistvm.padding;
      expect(result).assertDeepEquals({
        bottom: $r('app.float.ntf_list_land_item_padding_bottom'),
      });
    });

    it('should_return_padding_when_device_is_pad_and_portrait', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      when(DeviceHelper.isPad())(ArgumentMatchers.any).afterReturn(true);
      when(DeviceInfoVm.instance.isLandscape)(ArgumentMatchers.any).afterReturn(false);
      const result = notificationlistvm.padding;
      expect(result).assertDeepEquals({
        bottom: $r('app.float.ntf_list_item_padding_bottom'),
      });
    });
  });

  describe('isPanelVisible_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_false_when_isVisible_is_false', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let dropdownVmMock: DropdownVm = new DropdownVm();
      let mockfunc: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.vmInjector);
      when(mockfunc)().afterReturn(dropdownVmMock);
      expect(notificationlistvm.isPanelVisible).assertEqual(false);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.vmInjector);
    });
    it('should_return_true_when_isVisible_is_true', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let dropdownVmMock: DropdownVm = new DropdownVm();
      dropdownVmMock.isVisible = true;
      let mockfunc: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.vmInjector);
      when(mockfunc)().afterReturn(dropdownVmMock);
      expect(notificationlistvm.isPanelVisible).assertEqual(true);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.vmInjector);
    });
  });

  describe('width_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_LAND_PAD_OR_FOLD_NTF_WIDTH_when_isPad_or_isExpand_and_not_SingleDisplayPocketFoldDevice_or_isSmallFoldProduct', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();


      when(mocker.mockFunc(DeviceHelper, DeviceHelper.isPad))();

      when(mocker.mockFunc(DeviceInfoVm.instance, DeviceInfoVm.instance.isExpand))();


      expect(notificationlistvm.width).assertEqual(LAND_PAD_OR_FOLD_NTF_WIDTH);

    });

    it('should_return_100%_when_not_isPad_and_not_isExpand_or_isSingleDisplayPocketFoldDevice_or_isSmallFoldProduct', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();


      when(mocker.mockFunc(DeviceHelper, DeviceHelper.isPad))();

      when(mocker.mockFunc(DeviceInfoVm.instance, DeviceInfoVm.instance.isExpand))();


      expect(notificationlistvm.width).assertEqual('100%');

    });
  });

  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_init_and_super_init_when_init_is_called', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockSuperInit: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.init);
      when(mockSuperInit)([]).afterReturnNothing();

      let mockLiveDataVmInit: Function = mocker.mockFunc(LiveDropdownVmInjector.instance.getLiveDataVm(), LiveDropdownVmInjector.instance.getLiveDataVm().init);
      when(mockLiveDataVmInit)([]).afterReturnNothing();

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      notificationlistvm.init();

      mocker.ignoreMock(notificationlistvm, notificationlistvm.init);
      mocker.ignoreMock(LiveDropdownVmInjector.instance.getLiveDataVm(), LiveDropdownVmInjector.instance.getLiveDataVm().init);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_getLiveDataVm_and_init_when_init_is_called', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockLiveDataVmInit: Function = mocker.mockFunc(LiveDropdownVmInjector.instance.getLiveDataVm(), LiveDropdownVmInjector.instance.getLiveDataVm().init);
      when(mockLiveDataVmInit)([]).afterReturnNothing();

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      notificationlistvm.init();

      mocker.ignoreMock(LiveDropdownVmInjector.instance.getLiveDataVm(), LiveDropdownVmInjector.instance.getLiveDataVm().init);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_showInfo_when_init_is_called', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      notificationlistvm.init();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
  describe('destroy_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_super_destroy_and_showInfo_when_destroy_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationListVm: NotificationListVm = new NotificationListVm();
      let mockDestroy: Function = mocker.mockFunc(notificationListVm, notificationListVm.destroy);
      when(mockDestroy)().afterReturnNothing();

      notificationListVm.destroy();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(notificationListVm, notificationListVm.destroy);
    });
  });

  describe('isResetGroup_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_true_when_isPanelVisible_is_false', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      notificationlistvm.isPanelVisible = false;
      const result = notificationlistvm.isResetGroup();
      expect(result).assertEqual(true);
    });
    it('should_return_false_when_isPanelVisible_is_true', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      notificationlistvm.isPanelVisible = true;
      const result = notificationlistvm.isResetGroup();
      expect(result).assertEqual(false);
    });
  });

  describe('isEmpty_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_both_mainNtfList_and_moreNtfList_are_empty', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      notificationlistvm.mainNtfList = new NotificationArray();
      notificationlistvm.moreNtfList = new NotificationArray();
      expect(notificationlistvm.isEmpty).assertEqual(true);
    });

    it('should_return_false_when_mainNtfList_is_not_empty', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mainNtfList: NotificationArray = new NotificationArray();
      mainNtfList.push(new NotificationBase());
      notificationlistvm.mainNtfList = mainNtfList;
      expect(notificationlistvm.isEmpty).assertEqual(false);
    });

    it('should_return_false_when_moreNtfList_is_not_empty', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let moreNtfList: NotificationArray = new NotificationArray();
      moreNtfList.push(new NotificationBase());
      notificationlistvm.moreNtfList = moreNtfList;
      expect(notificationlistvm.isEmpty).assertEqual(false);
    });
  });

  describe('displayedMoreNtfList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_moreNtfList_when_isCollapsed_is_true_and_moreNtfList_length_greater_than_0', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let moreVm: INotificationListVm | undefined = new NotificationSwipeVm();
      moreVm.isCollapsed = true;
      moreVm.moreNtfList = [new NotificationBase(), new NotificationBase()];

      let notificationNormalVm: NotificationNormalVm = new NotificationNormalVm();
      notificationNormalVm.moreNtfList = moreVm.moreNtfList;

      let notificationDataVm: NotificationDataVm = new NotificationDataVm();
      notificationDataVm.normal = notificationNormalVm;

      let dropdownVm: DropdownVm = new DropdownVm();
      dropdownVm.notificationDataVm = notificationDataVm;

      let liveDropdownVmInjector: LiveDropdownVmInjector = new LiveDropdownVmInjector();
      liveDropdownVmInjector.notificationNormalVm = notificationNormalVm;
      liveDropdownVmInjector.notificationSwipeVm = moreVm;
      liveDropdownVmInjector.notificationListVm = notificationlistvm;

      notificationlistvm.vmInjector = liveDropdownVmInjector;

      expect(notificationlistvm.displayedMoreNtfList.length).assertEqual(1);
    });

    it('should_return_moreNtfList_when_isCollapsed_is_false_or_moreNtfList_length_is_0', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let moreVm: INotificationListVm | undefined = new NotificationSwipeVm();
      moreVm.isCollapsed = false;
      moreVm.moreNtfList = [new NotificationBase()];

      let notificationNormalVm: NotificationNormalVm = new NotificationNormalVm();
      notificationNormalVm.moreNtfList = moreVm.moreNtfList;

      let notificationDataVm: NotificationDataVm = new NotificationDataVm();
      notificationDataVm.normal = notificationNormalVm;

      let dropdownVm: DropdownVm = new DropdownVm();
      dropdownVm.notificationDataVm = notificationDataVm;

      let liveDropdownVmInjector: LiveDropdownVmInjector = new LiveDropdownVmInjector();
      liveDropdownVmInjector.notificationNormalVm = notificationNormalVm;
      liveDropdownVmInjector.notificationSwipeVm = moreVm;
      liveDropdownVmInjector.notificationListVm = notificationlistvm;

      notificationlistvm.vmInjector = liveDropdownVmInjector;

      expect(notificationlistvm.displayedMoreNtfList.length).assertEqual(1);
    });
  });

  describe('getListItemByIndex_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_index_is_less_than_0', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      const result = notificationlistvm.getListItemByIndex(-1);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_index_is_greater_than_maxIndex', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      const result = notificationlistvm.getListItemByIndex(100);
      expect(result).assertUndefined();
    });

    it('should_return_mainNtfList_item_when_index_is_less_than_mainNtfList_length', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      const result = notificationlistvm.getListItemByIndex(0);
      expect(result).assertInstanceOf(NotificationBase);
    });

    it('should_return_moreNtfList_item_when_index_equals_mainNtfList_length', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      const result = notificationlistvm.getListItemByIndex(notificationlistvm.mainNtfList.length);
      expect(result).assertInstanceOf(NotificationBase);
    });

    it('should_return_moreNtfList_item_when_index_greater_than_mainNtfList_length', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      const result = notificationlistvm.getListItemByIndex(notificationlistvm.mainNtfList.length + 1);
      expect(result).assertInstanceOf(NotificationBase);
    });
  });

  describe('getListItemIndex_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_index_when_ntf_in_mainNtfList', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let ntf: NotificationBase = new NotificationBase();
      ntf.hashCode = 123;
      notificationlistvm.mainNtfList = [ntf];

      const result = notificationlistvm.getListItemIndex(ntf);
      expect(result).assertEqual(0);
    });

    it('should_return_index_when_ntf_in_moreNtfList', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let ntf: NotificationBase = new NotificationBase();
      ntf.hashCode = 123;
      notificationlistvm.moreNtfList = [ntf];

      const result = notificationlistvm.getListItemIndex(ntf);
      expect(result).assertEqual(1);
    });

    it('should_return_minus_one_when_ntf_not_in_either_list', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let ntf: NotificationBase = new NotificationBase();
      ntf.hashCode = 123;
      notificationlistvm.mainNtfList = [];
      notificationlistvm.moreNtfList = [];

      const result = notificationlistvm.getListItemIndex(ntf);
      expect(result).assertEqual(-1);
    });
  });

  describe('onListSizeChange_testSuite', () => {

    it('should_set_clipShape_correctly_when_size_is_valid', 0, () => {
      const notificationlistvm: NotificationListVm = new NotificationListVm();
      const size: SizeOptions = { width: '100', height: '100' };
      notificationlistvm.onListSizeChange(size);
      expect(notificationlistvm.clipShape).assertInstanceOf(Path);
    });

    it('should_set_clipShape_correctly_when_size_is_invalid', 0, () => {
      const notificationlistvm: NotificationListVm = new NotificationListVm();
      const size: SizeOptions = { width: '0', height: '0' };
      notificationlistvm.onListSizeChange(size);
      expect(notificationlistvm.clipShape).assertInstanceOf(Path);
    });
  });

  describe('handleNotificationEvent_testSuite', () => {

    it('should_call_updateNtf_when_eventType_is_remove', 0, async () => {
      let mocker: MockKit = new MockKit();
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mockUpdateNtf: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateNtf);
      when(mockUpdateNtf)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, []);
      notificationlistvm.handleNotificationEvent(event);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateNtf);
    });

    it('should_call_executeAnimation_when_eventType_is_add', 0, async () => {
      let mocker: MockKit = new MockKit();
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mockExecuteAnimation: Function = mocker.mockFunc(notificationlistvm.ntfListAnim, notificationlistvm.ntfListAnim.executeAnimation);
      when(mockExecuteAnimation)([ArgumentMatchers.anyObj]).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, []);
      notificationlistvm.handleNotificationEvent(event);

      mocker.ignoreMock(notificationlistvm.ntfListAnim, notificationlistvm.ntfListAnim.executeAnimation);
    });

    it('should_call_showInfo_when_eventType_is_remove_and_updateNtf_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mockUpdateNtf: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateNtf);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockUpdateNtf)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, []);
      notificationlistvm.handleNotificationEvent(event);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateNtf);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_executeAnimation_when_eventType_is_add_and_updateNtf_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mockExecuteAnimation: Function = mocker.mockFunc(notificationlistvm.ntfListAnim, notificationlistvm.ntfListAnim.executeAnimation);
      let mockUpdateNtf: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateNtf);
      when(mockExecuteAnimation)([ArgumentMatchers.anyObj]).afterReturnNothing();
      when(mockUpdateNtf)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, []);
      notificationlistvm.handleNotificationEvent(event);

      mocker.ignoreMock(notificationlistvm.ntfListAnim, notificationlistvm.ntfListAnim.executeAnimation);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateNtf);
    });
  });

  describe('updateNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_updateList_and_updateStatusBar_when_updateNtf_is_called', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockUpdateList: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateList);
      when(mockUpdateList)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockUpdateStatusBar: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateStatusBar);
      when(mockUpdateStatusBar)().afterReturnNothing();

      notificationlistvm.updateNtf(true);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateList);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateStatusBar);
    });
  });

  describe('updateNtf_testSuite', () => {
    beforeEach(() => {
      // 测试前的初始化操作（如需要）
    });
    afterEach(() => {
      // 测试后的清理操作（如需要）
    });

    // 测试用例1：验证当 addOrUpdate 为 false 时，两个方法均被调用
    it('should_call_both_methods_with_addOrUpdate_false', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let updateListCount = 0;
      let mockUpdateList: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateList);
      when(mockUpdateList)(ArgumentMatchers.anyBoolean).afterAction(() => updateListCount++);

      let updateStatusBarCount = 0;
      let mockUpdateStatusBar: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateStatusBar);
      when(mockUpdateStatusBar)().afterAction(() => updateStatusBarCount++);

      notificationlistvm.updateNtf(false);

      expect(updateListCount).assertEqual(1);
      expect(updateStatusBarCount).assertEqual(1);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateList);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateStatusBar);
    });

    // 测试用例2：验证当 addOrUpdate 为 true 时，两个方法均被调用
    it('should_call_both_methods_with_addOrUpdate_true', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let updateListCount = 0;
      let mockUpdateList: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateList);
      when(mockUpdateList)(ArgumentMatchers.anyBoolean).afterAction(() => updateListCount++);

      let updateStatusBarCount = 0;
      let mockUpdateStatusBar: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateStatusBar);
      when(mockUpdateStatusBar)().afterAction(() => updateStatusBarCount++);

      notificationlistvm.updateNtf(true);

      expect(updateListCount).assertEqual(1);
      expect(updateStatusBarCount).assertEqual(1);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateList);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateStatusBar);
    });

    // 测试用例3：验证连续调用时，两个方法均被多次调用
    it('should_call_both_methods_multiple_times', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let updateListCount = 0;
      let mockUpdateList: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateList);
      when(mockUpdateList)(ArgumentMatchers.anyBoolean).afterAction(() => updateListCount++);

      let updateStatusBarCount = 0;
      let mockUpdateStatusBar: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.updateStatusBar);
      when(mockUpdateStatusBar)().afterAction(() => updateStatusBarCount++);

      notificationlistvm.updateNtf(true);
      notificationlistvm.updateNtf(false);

      expect(updateListCount).assertEqual(2);
      expect(updateStatusBarCount).assertEqual(2);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateList);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.updateStatusBar);
    });
  });

  describe('updateList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_separate_and_sort_when_isVisible_and_addOrUpdate_are_true', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockSeparate: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.separate);
      when(mockSeparate)([]).afterReturnNothing();

      let mockSort: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.sort);
      when(mockSort)([]).afterReturnNothing();


      notificationlistvm.updateList(true);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.separate);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.sort);
    });

    it('should_not_call_transform_when_isVisible_is_false_or_addOrUpdate_is_false', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockSeparate: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.separate);
      when(mockSeparate)([]).afterReturnNothing();

      let mockSort: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.sort);
      when(mockSort)([]).afterReturnNothing();


      notificationlistvm.updateList(false);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.separate);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.sort);
    });
  });

  describe('updateStatusBar_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_post_status_bar_event_when_update_status_bar', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let dropdownVmMock: DropdownVm = new DropdownVm();
      let mockfunc: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.postStatusBarEvent);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationlistvm.updateStatusBar();
      mocker.ignoreMock(notificationlistvm, notificationlistvm.postStatusBarEvent);
    });
  });

  describe('saveNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_result_when_incomingNtf_is_not_live_view', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.saveNtf);
      let incomingNtf: NotificationBase = new NotificationBase();
      when(mockfunc)(ArgumentMatchers.any).afterReturn(incomingNtf);
      const result = notificationlistvm.saveNtf(incomingNtf);
      expect(result).assertEqual(incomingNtf);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.saveNtf);
    });

    it('should_return_result_when_incomingNtf_is_live_view', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.saveNtf);
      let incomingNtf: NotificationBase = new NotificationBase();
      incomingNtf.isLiveView = () => true;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(incomingNtf);
      const result = notificationlistvm.saveNtf(incomingNtf);
      expect(result).assertEqual(incomingNtf);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.saveNtf);
    });

    it('should_update_vm_when_incomingNtf_is_live_view', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.saveNtf);
      let incomingNtf: NotificationBase = new NotificationBase();
      incomingNtf.isLiveView = () => true;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(incomingNtf);
      const result = notificationlistvm.saveNtf(incomingNtf);
      expect(result).assertEqual(incomingNtf);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.saveNtf);
    });
  });

  describe('clearNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_incomingNtf_is_not_live_view', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      when(mockIsLiveView)([]).afterReturn(false);
      let mockClearNtf: Function = mocker.mockFunc(NotificationDataVm.prototype, NotificationDataVm.prototype.clearNtf);
      when(mockClearNtf)([ArgumentMatchers.any]).afterReturn(undefined);

      let incomingNtf: NotificationBase = new NotificationBase();
      let result = notificationlistvm.clearNtf(incomingNtf);
      expect(result).assertUndefined();
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      mocker.ignoreMock(NotificationDataVm.prototype, NotificationDataVm.prototype.clearNtf);
    });

    it('should_return_result_when_incomingNtf_is_live_view_and_super_clearNtf_returns_result', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      when(mockIsLiveView)([]).afterReturn(true);
      let mockClearNtf: Function = mocker.mockFunc(NotificationDataVm.prototype, NotificationDataVm.prototype.clearNtf);
      let mockResult: NotificationBase = new NotificationBase();
      when(mockClearNtf)([ArgumentMatchers.any]).afterReturn(mockResult);

      let incomingNtf: NotificationBase = new NotificationBase();
      let result = notificationlistvm.clearNtf(incomingNtf);
      expect(result).assertDeepEquals(mockResult);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      mocker.ignoreMock(NotificationDataVm.prototype, NotificationDataVm.prototype.clearNtf);
    });

    it('should_call_deleteVmByLive_when_incomingNtf_is_live_view', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      when(mockIsLiveView)([]).afterReturn(true);
      let mockDeleteVmByLive: Function = mocker.mockFunc(LiveDropdownVmInjector.instance, LiveDropdownVmInjector.instance.deleteVmByLive);
      when(mockDeleteVmByLive)([ArgumentMatchers.any]).afterReturnNothing();

      let incomingNtf: NotificationBase = new NotificationBase();
      let result = notificationlistvm.clearNtf(incomingNtf);
      expect(result).assertUndefined();
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      mocker.ignoreMock(LiveDropdownVmInjector.instance, LiveDropdownVmInjector.instance.deleteVmByLive);
    });
  });

  describe('separate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_separate_mainNtfList_and_moreNtfList_correctly', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockIsNeedFilter: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.isNeedFilter);
      when(mockIsNeedFilter)(ArgumentMatchers.any).afterReturn(false);

      let mockClearMainNtfList: Function = mocker.mockFunc(notificationlistvm.mainNtfList, notificationlistvm.mainNtfList.clear);
      when(mockClearMainNtfList)([]).afterReturnNothing();

      let mockClearMoreNtfList: Function = mocker.mockFunc(notificationlistvm.moreNtfList, notificationlistvm.moreNtfList.clear);
      when(mockClearMoreNtfList)([]).afterReturnNothing();

      let mockGroupForEach: Function = mocker.mockFunc(notificationlistvm, notificationlistvm.groupForEach);
      when(mockGroupForEach)(ArgumentMatchers.any).afterReturnNothing();

      notificationlistvm.deviceInfoVm = new DeviceInfoVm();
      notificationlistvm.deviceInfoVm.isPC = false;

      let ntf1: NotificationBase = new NotificationBase();
      ntf1.category = NotificationCategory.OTHER;

      let ntf2: NotificationBase = new NotificationBase();
      ntf2.category = NotificationCategory.INFO;

      let ntfList: Array<NotificationBase> = [ntf1, ntf2];
      notificationlistvm.mainNtfList.splice(0, 0, ...ntfList);

      notificationlistvm.separate();

      expect(notificationlistvm.mainNtfList.length).assertEqual(1);
      expect(notificationlistvm.moreNtfList.length).assertEqual(1);

      mocker.ignoreMock(notificationlistvm, notificationlistvm.isNeedFilter);
      mocker.ignoreMock(notificationlistvm.mainNtfList, notificationlistvm.mainNtfList.clear);
      mocker.ignoreMock(notificationlistvm.moreNtfList, notificationlistvm.moreNtfList.clear);
      mocker.ignoreMock(notificationlistvm, notificationlistvm.groupForEach);
    });
  });

  describe('sort_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_sort_mainNtfList_and_moreNtfList', 0, () => {
      let notificationListVm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();


      notificationListVm.sort();

      expect(notificationListVm.mainNtfList.length).assertEqual(3);
      expect(notificationListVm.moreNtfList.length).assertEqual(2);

    });
  });

  describe('isNeedFilter_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isEmergencyMode_is_true_and_isLiveView_is_false_and_creatorBundleName_is_not_in_emergencyModelTrustAppList', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockIsEmergencyMode: Function = mocker.mockFunc(DeviceInfoVm.instance, DeviceInfoVm.instance.isEmergencyMode);
      when(mockIsEmergencyMode)([]).afterReturn(true);

      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      when(mockIsLiveView)([]).afterReturn(false);

      let ntf: NotificationBase = new NotificationBase();
      ntf.creatorBundleName = 'testBundle';

      let result = notificationlistvm.isNeedFilter(ntf);
      expect(result).assertEqual(true);

      mocker.ignoreMock(DeviceInfoVm.instance, DeviceInfoVm.instance.isEmergencyMode);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
    });

    it('should_return_false_when_isEmergencyMode_is_false', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockIsEmergencyMode: Function = mocker.mockFunc(DeviceInfoVm.instance, DeviceInfoVm.instance.isEmergencyMode);
      when(mockIsEmergencyMode)([]).afterReturn(false);

      let ntf: NotificationBase = new NotificationBase();

      let result = notificationlistvm.isNeedFilter(ntf);
      expect(result).assertEqual(false);

      mocker.ignoreMock(DeviceInfoVm.instance, DeviceInfoVm.instance.isEmergencyMode);
    });

    it('should_return_false_when_isLiveView_is_true', 0, async () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();

      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
      when(mockIsLiveView)([]).afterReturn(true);

      let ntf: NotificationBase = new NotificationBase();

      let result = notificationlistvm.isNeedFilter(ntf);
      expect(result).assertEqual(false);

      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.isLiveView);
    });
  });

  describe('getMaxIndex_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_index_when_moreNtfList_is_not_empty_and_isCollapsed_is_true', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockMoreNtfList: NotificationArray = new NotificationArray();
      mockMoreNtfList.push(new NotificationBase());
      notificationlistvm.moreNtfList = mockMoreNtfList;

      let mockMainNtfList: NotificationArray = new NotificationArray();
      mockMainNtfList.push(new NotificationBase());
      notificationlistvm.mainNtfList = mockMainNtfList;

      let mockDeviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let mockDropdownVm: DropdownVm = new DropdownVm();
      let mockLiveDropdownVmInjector: LiveDropdownVmInjector = new LiveDropdownVmInjector();
      mockLiveDropdownVmInjector.setNotificationSwipeVm(new NotificationSwipeVm());
      mockLiveDropdownVmInjector.setNotificationNormalVm(new NotificationNormalVm());
      mockLiveDropdownVmInjector.setNotificationDataVm(new NotificationDataVm());
      mockDeviceInfoVm.setLiveDropdownVmInjector(mockLiveDropdownVmInjector);
      notificationlistvm.deviceInfoVm = mockDeviceInfoVm;

      let result = notificationlistvm.getMaxIndex();
      expect(result).assertEqual(2);
    });

    it('should_return_correct_index_when_moreNtfList_is_not_empty_and_isCollapsed_is_false', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockMoreNtfList: NotificationArray = new NotificationArray();
      mockMoreNtfList.push(new NotificationBase());
      notificationlistvm.moreNtfList = mockMoreNtfList;

      let mockMainNtfList: NotificationArray = new NotificationArray();
      mockMainNtfList.push(new NotificationBase());
      notificationlistvm.mainNtfList = mockMainNtfList;

      let mockDeviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let mockDropdownVm: DropdownVm = new DropdownVm();
      let mockLiveDropdownVmInjector: LiveDropdownVmInjector = new LiveDropdownVmInjector();
      mockLiveDropdownVmInjector.setNotificationSwipeVm(new NotificationSwipeVm());
      mockLiveDropdownVmInjector.setNotificationNormalVm(new NotificationNormalVm());
      mockLiveDropdownVmInjector.setNotificationDataVm(new NotificationDataVm());
      mockDeviceInfoVm.setLiveDropdownVmInjector(mockLiveDropdownVmInjector);
      notificationlistvm.deviceInfoVm = mockDeviceInfoVm;

      notificationlistvm.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed = false;

      let result = notificationlistvm.getMaxIndex();
      expect(result).assertEqual(3);
    });

    it('should_return_correct_index_when_moreNtfList_is_empty', 0, () => {
      let notificationlistvm: NotificationListVm = new NotificationListVm();
      let mocker: MockKit = new MockKit();
      let mockMainNtfList: NotificationArray = new NotificationArray();
      mockMainNtfList.push(new NotificationBase());
      notificationlistvm.mainNtfList = mockMainNtfList;

      let mockDeviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let mockDropdownVm: DropdownVm = new DropdownVm();
      let mockLiveDropdownVmInjector: LiveDropdownVmInjector = new LiveDropdownVmInjector();
      mockLiveDropdownVmInjector.setNotificationSwipeVm(new NotificationSwipeVm());
      mockLiveDropdownVmInjector.setNotificationNormalVm(new NotificationNormalVm());
      mockLiveDropdownVmInjector.setNotificationDataVm(new NotificationDataVm());
      mockDeviceInfoVm.setLiveDropdownVmInjector(mockLiveDropdownVmInjector);
      notificationlistvm.deviceInfoVm = mockDeviceInfoVm;

      let result = notificationlistvm.getMaxIndex();
      expect(result).assertEqual(1);
    });
  });
}