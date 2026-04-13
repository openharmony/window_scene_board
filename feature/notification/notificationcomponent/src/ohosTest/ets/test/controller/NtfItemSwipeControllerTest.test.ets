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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfItemSwipeController } from '../../../main/ets/controller/NtfItemSwipeController';
export default function NtfItemSwipeControllerTest() {
  describe('registerSwipeCallback_testSuite', () => {

    it('should_add_callback_to_swipeCallbacks_when_registerSwipeCallback_is_called', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let swipeCallback: SwipeCallback = new SwipeCallback();
      ntfitemswipecontroller.registerSwipeCallback(swipeCallback);
      expect(ntfitemswipecontroller.swipeCallbacks.has(swipeCallback)).assertTrue();
    });

    it('should_unregister_swipe_callback_successfully', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let swipeCallback: SwipeCallback = new SwipeCallback();
      ntfitemswipecontroller.unregisterSwipeCallback(swipeCallback);
      expect(ntfitemswipecontroller.swipeCallbacks.has(swipeCallback)).assertFalse();
    });

    it('should_set_groupEntryCB_correctly', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let groupEntryCB: () => NotificationEntry | undefined = () => undefined;
      ntfitemswipecontroller.setGroupEntryCB(groupEntryCB);
      expect(ntfitemswipecontroller.groupEntryCB).assertEqual(groupEntryCB);
    });

    it('should_set_ntfEntry_and_call_getItemCanClear_when_entry_is_not_null', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry(1, 1, 1, NotificationType.NOTIFICATION_TYPE_DEFAULT);
      ntfitemswipecontroller.setNtfEntry(entry);

      expect(ntfitemswipecontroller.ntfEntry).assertEqual(entry);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
    });

    it('should_set_ntfEntry_and_call_getItemCanClear_when_entry_is_null', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry | null = null;
      ntfitemswipecontroller.setNtfEntry(entry);

      expect(ntfitemswipecontroller.ntfEntry).assertEqual(entry);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
    });

    it('should_return_CONTINUE_when_type_is_not_keyguard', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.CONTINUE);
    });

    it('should_return_REJECT_when_item_is_disable_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      notificationStyle.item.isDisableSwipe = true;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.REJECT);
    });

    it('should_return_CONTINUE_when_gesture_is_not_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.TAP_GESTURE;
      notificationStyle.item.isDisableSwipe = false;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.CONTINUE);
    });

    it('should_return_REJECT_when_gesture_is_swipe_and_item_is_disable_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      notificationStyle.item.isDisableSwipe = true;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.REJECT);
    });

    it('should_return_CONTINUE_when_gesture_is_swipe_and_item_is_enable_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      notificationStyle.item.isDisableSwipe = false;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.CONTINUE);
    });

    it('should_return_REJECT_when_gesture_is_swipe_and_item_is_enable_swipe_2', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      notificationStyle.item.isDisableSwipe = false;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.REJECT);
    });

    it('should_handle_vertical_swipe_when_isVertical_is_true', 0, async () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockIsSwipeExpand: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      let mockSwipe2Collapse: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
      when(mockIsSwipeExpand)().afterReturn(true);
      when(mockSwipe2Collapse)().afterReturnNothing();

      let event: GestureEvent = new GestureEvent();
      event.offsetX = 100;
      event.offsetY = 100;
      ntfitemswipecontroller.onStartSwipe(event);

      expect(ntfitemswipecontroller.isVertical).assertEqual(true);
      expect(ntfitemswipecontroller.isRTL).assertEqual(false);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
    });

    it('should_handle_horizontal_swipe_when_isVertical_is_false', 0, async () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockIsSwipeExpand: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      let mockSwipe2Collapse: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
      when(mockIsSwipeExpand)().afterReturn(false);
      when(mockSwipe2Collapse)().afterReturnNothing();

      let event: GestureEvent = new GestureEvent();
      event.offsetX = 100;
      event.offsetY = 100;
      ntfitemswipecontroller.onStartSwipe(event);

      expect(ntfitemswipecontroller.isVertical).assertEqual(false);
      expect(ntfitemswipecontroller.isRTL).assertEqual(false);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
    });

    it('should_call_updateGestureSlow_when_device_is_PC', 0, async () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockIsSwipeExpand: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      let mockSwipe2Collapse: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
      when(mockIsSwipeExpand)().afterReturn(false);
      when(mockSwipe2Collapse)().afterReturnNothing();

      let event: GestureEvent = new GestureEvent();
      event.offsetX = 100;
      event.offsetY = 100;
      ntfitemswipecontroller.onStartSwipe(event);

      expect(ntfitemswipecontroller.isVertical).assertEqual(false);
      expect(ntfitemswipecontroller.isRTL).assertEqual(false);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
    });

    it('should_call_notifyTranAnimChange_and_notifyTranXChange_when_device_is_not_PC', 0, async () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockIsSwipeExpand: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      let mockSwipe2Collapse: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
      when(mockIsSwipeExpand)().afterReturn(false);
      when(mockSwipe2Collapse)().afterReturnNothing();

      let event: GestureEvent = new GestureEvent();
      event.offsetX = 100;
      event.offsetY = 100;
      ntfitemswipecontroller.onStartSwipe(event);

      expect(ntfitemswipecontroller.isVertical).assertEqual(false);
      expect(ntfitemswipecontroller.isRTL).assertEqual(false);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.isSwipeExpand);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.swipe2Collapse);
    });

    it('should_set_ntfEntry_and_call_getItemCanClear_when_entry_is_null', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry | null = null;
      ntfitemswipecontroller.setNtfEntry(entry);

      expect(ntfitemswipecontroller.ntfEntry).assertEqual(entry);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
    });

    it('should_return_CONTINUE_when_type_is_not_keyguard', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.CONTINUE);
    });

    it('should_return_REJECT_when_item_is_disable_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      notificationStyle.item.isDisableSwipe = true;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.REJECT);
    });

    it('should_return_CONTINUE_when_gesture_is_not_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.TAP_GESTURE;
      notificationStyle.item.isDisableSwipe = false;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.CONTINUE);
    });

    it('should_return_REJECT_when_gesture_is_swipe_and_item_is_disable_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      notificationStyle.item.isDisableSwipe = true;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.REJECT);
    });

    it('should_return_CONTINUE_when_gesture_is_swipe_and_item_is_enable_swipe', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let info: GestureInfo = new GestureInfo();
      info.type = GestureControl.GestureType.SWIPE_GESTURE;
      notificationStyle.item.isDisableSwipe = false;
      let result: ESObject = ntfitemswipecontroller.onGestureJudgeBegin(0, info);
      expect(result).assertEqual(GestureJudgeResult.CONTINUE);
    });

    it('should_update_isShowExtraNtfs_and_isOuterHomeFolded_correctly_when_isOuterHome_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: false,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [new NotificationListItem()];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      expect(testee.isShowExtraNtfs).assertEqual(true);
      expect(testee.isOuterHomeFolded).assertEqual(false);

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_isShowExtraNtfs_and_isOuterHomeFolded_correctly_when_isOuterHome_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: false,
        isRefreshNftListByFoldState: false,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let testee: OuterHomeVm = new OuterHomeVm();

      testee.onFoldFullDisplayChange();

      expect(testee.isShowExtraNtfs).assertEqual(false);
      expect(testee.isOuterHomeFolded).assertEqual(false);

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [new NotificationListItem()];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_false_and_ntfListVM_has_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: false,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [new NotificationListItem()];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
}