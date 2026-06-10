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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationBaseVm, INotificationDataVm, NotificationRefreshType, NotificationRefreshRecord
} from '@ohos/systemuicommon/newIndex';
import {
  InnerEventUtil,
  NormalNotification,
  NormalNotificationGroup,
  NotificationArray,
  NotificationBase,
  NotificationCategory,
  NotificationEvent
} from '@ohos/systemuicommon/newTsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationDataVm } from '../../../main/ets/viewmodel/NotificationDataVm';
export default function NotificationDataVmTest() {
  describe('handleNotificationEvent_testSuite', () => {

  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_init_is_called', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      notificationdatavm.init();
      expect(mockfunc).assertCalledWith("Init: default");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_register_event_listener_when_init_is_called', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let innerEventUtil: InnerEventUtil = InnerEventUtil.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(innerEventUtil, innerEventUtil.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturn(null);
      notificationdatavm.init();
      expect(mockfunc).assertCalledWith(NotificationEvent, notificationdatavm.onNotificationEvent);
      mocker.ignoreMock(innerEventUtil, innerEventUtil.on);
    });
  });

  describe('destroy_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_and_clear_data_when_destroy_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      notificationdatavm.destroy();

      expect(mockfunc).assertCalledWith("Destroy: default");
      expect(notificationdatavm.ntfGroupMap.size).assertEqual(0);
      expect(notificationdatavm.ntfHashMap.size).assertEqual(0);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });

  describe('getNtfByGroupKey_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_notificationList_is_empty_and_eventType_is_not_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, []);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_handle_init_event_when_eventType_is_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleInitEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleInitEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleInitEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_INIT, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleInitEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_ADD', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_UPDATE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_UPDATE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_remove_event_when_eventType_is_REMOVE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleRemoveEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleRemoveEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleRemoveEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleRemoveEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_return_immediately_when_notificationList_is_empty_and_eventType_is_not_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, []);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_handle_init_event_when_eventType_is_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleInitEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleInitEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleInitEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_INIT, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleInitEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_ADD', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_UPDATE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_UPDATE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_remove_event_when_eventType_is_REMOVE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleRemoveEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleRemoveEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleRemoveEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleRemoveEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_return_immediately_when_notificationList_is_empty_and_eventType_is_not_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, []);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_handle_init_event_when_eventType_is_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleInitEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleInitEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleInitEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_INIT, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleInitEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_ADD', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_UPDATE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_UPDATE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_remove_event_when_eventType_is_REMOVE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleRemoveEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleRemoveEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleRemoveEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleRemoveEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });
    it('should_return_immediately_when_notificationList_is_empty_and_eventType_is_not_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, []);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_handle_init_event_when_eventType_is_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleInitEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleInitEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleInitEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_INIT, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleInitEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_ADD', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_add_update_event_when_eventType_is_UPDATE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleAddUpdateEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleAddUpdateEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_UPDATE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });

    it('should_handle_remove_event_when_eventType_is_REMOVE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleRemoveEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleRemoveEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleRemoveEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleRemoveEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    });
    it('should_handle_init_event_when_eventType_is_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockHandleInitEvent: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleInitEvent);
      let mockRecordRefreshType: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.recordRefreshType);
      let mockOnDataChange: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.onDataChange);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockHandleInitEvent)(ArgumentMatchers.any).afterReturnNothing();
      when(mockRecordRefreshType)(ArgumentMatchers.any).afterReturnNothing();
      when(mockOnDataChange)(ArgumentMatchers.any).afterReturnNothing();
      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_INIT, [
        new NormalNotification('1'),
        new NormalNotification('2')
      ]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleInitEvent);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.recordRefreshType);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.onDataChange);
    it('should_return_undefined_when_groupKey_is_not_found', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let result = notificationdatavm.getNtfByGroupKey('non_existing_key');
      expect(result).assertUndefined();
    });

    it('should_return_notification_when_groupKey_is_found', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mockNtfGroup: NotificationBase = new NormalNotification('1', 'group1', NotificationCategory.INFO, 'content1');
      notificationdatavm.ntfGroupMap.set('group1', mockNtfGroup);
      let result = notificationdatavm.getNtfByGroupKey('group1');
      expect(result).assertInstanceOf(NotificationBase);
      expect(result?.getContent()).assertEqual('content1');
    });
  });

  describe('getNtfByHashCode_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_ntfHashMap_does_not_contain_key', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let hashcode: string = 'non_existent_hashcode';
      let result = notificationdatavm.getNtfByHashCode(hashcode);
      expect(result).assertUndefined();
    });

    it('should_return_notification_when_ntfHashMap_contains_key', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let hashcode: string = 'existing_hashcode';
      let mockNtf: NotificationBase = new NormalNotification('existing_title', 'existing_content',
        NotificationCategory.NOTIFICATION_CATEGORY_DEFAULT);
      notificationdatavm.ntfHashMap.set(hashcode, mockNtf);
      let result = notificationdatavm.getNtfByHashCode(hashcode);
      expect(result).assertInstanceOf(NotificationBase);
      expect(result?.title).assertEqual('existing_title');
      expect(result?.content).assertEqual('existing_content');
      expect(result?.category).assertEqual(NotificationCategory.NOTIFICATION_CATEGORY_DEFAULT);
    });
  });

  describe('getGroupNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_ntfGroupMap_does_not_contain_key', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let ntf: NotificationBase = new NormalNotification('1');
      let result = notificationdatavm.getGroupNtf(ntf);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_existNtf_is_not_normal_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let ntf: NotificationBase = new NormalNotification('1');
      notificationdatavm.ntfGroupMap.set('1', new NormalNotificationGroup('1'));
      let result = notificationdatavm.getGroupNtf(ntf);
      expect(result).assertUndefined();
    });

    it('should_return_existNtf_when_existNtf_is_normal_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let ntf: NotificationBase = new NormalNotification('1');
      let existNtf: NormalNotificationGroup = new NormalNotificationGroup('1');
      existNtf.isNormalGroup = () => true;
      notificationdatavm.ntfGroupMap.set('1', existNtf);
      let result = notificationdatavm.getGroupNtf(ntf);
      expect(result).assertDeepEquals(existNtf);
    });
  });

  describe('releaseGroup_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_release_group_when_group_is_not_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let mockSaveNtf: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.saveNtf);
      when(mockSaveNtf)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let group: NormalNotificationGroup = new NormalNotificationGroup(
        new NormalNotification('1'),
        new NormalNotification('2')
      );
      group.groupKey = 'testGroup';

      notificationdatavm.releaseGroup(group);

      mocker.ignoreMock(notificationdatavm, notificationdatavm.saveNtf);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_release_group_when_group_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let mockSaveNtf: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.saveNtf);
      when(mockSaveNtf)(ArgumentMatchers.any).afterReturn(undefined);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let group: NormalNotificationGroup = null;

      notificationdatavm.releaseGroup(group);

      mocker.ignoreMock(notificationdatavm, notificationdatavm.saveNtf);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });

  describe('handleNotificationEvent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_immediately_when_notificationList_is_empty_and_eventType_is_not_EVENT_TYPE_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_UPDATE, []);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_handle_init_event_when_eventType_is_EVENT_TYPE_INIT', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_INIT, [new NormalNotification()]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_handle_add_event_when_eventType_is_EVENT_TYPE_ADD', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_ADD, [new NormalNotification()]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_handle_update_event_when_eventType_is_EVENT_TYPE_UPDATE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_UPDATE, [new NormalNotification()]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_handle_remove_event_when_eventType_is_EVENT_TYPE_REMOVE', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationEvent = new NotificationEvent(NotificationEvent.EVENT_TYPE_REMOVE, [new NormalNotification()]);
      notificationdatavm.handleNotificationEvent(event);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });

  describe('handleInitEvent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_clear_ntfGroupMap_and_ntfHashMap_when_incomingNtfList_is_not_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let incomingNtfList: NotificationBase[] = [new NormalNotification(), new NormalNotification()];
      notificationdatavm.handleInitEvent(incomingNtfList);

      expect(notificationdatavm.ntfGroupMap.size).assertEqual(0);
      expect(notificationdatavm.ntfHashMap.size).assertEqual(0);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
    });

    it('should_not_clear_ntfGroupMap_and_ntfHashMap_when_incomingNtfList_is_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let incomingNtfList: NotificationBase[] = [];
      notificationdatavm.handleInitEvent(incomingNtfList);

      expect(notificationdatavm.ntfGroupMap.size).assertEqual(0);
      expect(notificationdatavm.ntfHashMap.size).assertEqual(0);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.handleAddUpdateEvent);
    });
  });

  describe('handleAddUpdateEvent_testSuite', () => {

    it('should_handle_add_update_event_correctly_when_incomingNtfList_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] | undefined = undefined;
      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
      // No assertions needed as the function should not throw an error
      // and there is no way to verify the internal state of the class
    });

    it('should_handle_add_update_event_correctly_when_incomingNtfList_is_empty', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtfList: NotificationBase[] = [];
      notificationdatavm.handleAddUpdateEvent(incomingNtfList);
      // No assertions needed as the function should not throw an error
      // and there is no way to verify the internal state of the class
    });

    it('should_handle_add_update_event_correctly_when_incomingNtfList_has_elements', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let mockDeleteWrongGroup: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.deleteWrongGroup);
      when(mockDeleteWrongGroup)(ArgumentMatchers.any).afterReturnNothing();

      let mockSaveNtf: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.saveNtf);
      when(mockSaveNtf)(ArgumentMatchers.any).afterReturn(undefined);

      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', '1', '1', NotificationCategory.NOTIFICATION_ category),
      new NormalNotification('2', '2', '2', NotificationCategory.NOTIFICATION_ category)
      ];

      notificationdatavm.handleAddUpdateEvent(incomingNtfList);

      mocker.ignoreMock(notificationdatavm, notificationdatavm.deleteWrongGroup);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.saveNtf);
    });

    it('should_handle_add_update_event_correctly_when_saveNtf_returns_new_data', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let mockDeleteWrongGroup: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.deleteWrongGroup);
      when(mockDeleteWrongGroup)(ArgumentMatchers.any).afterReturnNothing();

      let mockSaveNtf: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.saveNtf);
      when(mockSaveNtf)(ArgumentMatchers.any).afterReturn(new NormalNotification('3', '3', '3', NotificationCategory.NOTIFICATION_ category));

      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', '1', '1', NotificationCategory.NOTIFICATION_ category)
      ];

      notificationdatavm.handleAddUpdateEvent(incomingNtfList);

      mocker.ignoreMock(notificationdatavm, notificationdatavm.deleteWrongGroup);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.saveNtf);
    });

    it('should_handle_add_update_event_correctly_when_saveNtf_returns_undefined', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();

      let mockDeleteWrongGroup: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.deleteWrongGroup);
      when(mockDeleteWrongGroup)(ArgumentMatchers.any).afterReturnNothing();

      let mockSaveNtf: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.saveNtf);
      when(mockSaveNtf)(ArgumentMatchers.any).afterReturn(undefined);

      let incomingNtfList: NotificationBase[] = [
        new NormalNotification('1', '1', '1', NotificationCategory.NOTIFICATION_ category)
      ];

      notificationdatavm.handleAddUpdateEvent(incomingNtfList);

      mocker.ignoreMock(notificationdatavm, notificationdatavm.deleteWrongGroup);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.saveNtf);
    });
  });

  describe('deleteWrongGroup_testSuite', () => {

    it('should_do_nothing_when_incomingNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase | null = null;
      notificationdatavm.deleteWrongGroup(incomingNtf);
    });

    it('should_do_nothing_when_existNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NotificationBase();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.ntfHashMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationdatavm.deleteWrongGroup(incomingNtf);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.ntfHashMap);
    });

    it('should_delete_old_data_when_existNtf_is_not_normal_and_incomingNtf_has_different_groupKey_or_category', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NotificationBase();
      incomingNtf.groupKey = 'group1';
      incomingNtf.category = NotificationCategory.EMERGENCY;
      let existNtf: NotificationBase = new NotificationBase();
      existNtf.groupKey = 'group2';
      existNtf.category = NotificationCategory.URGENT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.ntfHashMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(existNtf);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.ntfGroupMap);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.dataRefreshRecord);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc4: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc4)(ArgumentMatchers.anyString).afterReturn(null);
      notificationdatavm.deleteWrongGroup(incomingNtf);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.ntfHashMap);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.ntfGroupMap);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.dataRefreshRecord);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_do_nothing_when_existNtf_is_normal_and_incomingNtf_has_same_groupKey', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NotificationBase();
      incomingNtf.groupKey = 'group1';
      let existNtf: NotificationBase = new NotificationBase();
      existNtf.groupKey = 'group1';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.ntfHashMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(existNtf);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.ntfGroupMap);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.dataRefreshRecord);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(null);
      notificationdatavm.deleteWrongGroup(incomingNtf);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.ntfHashMap);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.ntfGroupMap);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.dataRefreshRecord);
    });

    it('should_delete_old_data_and_handle_group_when_existNtf_is_normal_and_incomingNtf_has_different_groupKey', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let incomingNtf: NotificationBase = new NotificationBase();
      incomingNtf.groupKey = 'group1';
      let existNtf: NotificationBase = new NotificationBase();
      existNtf.groupKey = 'group2';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.ntfHashMap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(existNtf);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.ntfGroupMap);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.dataRefreshRecord);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(null);
      let mockfunc4: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.removeChild);
      when(mockfunc4)(ArgumentMatchers.anyString).afterReturn(new NormalNotificationGroup());
      let mockfunc5: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc5)(ArgumentMatchers.anyString).afterReturn(null);
      notificationdatavm.deleteWrongGroup(incomingNtf);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.ntfHashMap);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.ntfGroupMap);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.dataRefreshRecord);
      mocker.ignoreMock(notificationdatavm, notificationdatavm.removeChild);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
  })
  });

  describe('saveNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_incomingNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      const result = notificationdatavm.saveNtf(null);
      expect(result).assertEqual(undefined);
    });

    it('should_add_new_ntf_when_existNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let incomingNtf: NotificationBase = new NormalNotification();
      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_add_new_ntf_to_group_when_existNtf_is_normal_and_incomingNtf_is_normal', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let incomingNtf: NotificationBase = new NormalNotification();
      let existNtf: NotificationBase = new NormalNotification();
      notificationdatavm.ntfGroupMap.set(existNtf.groupKey, existNtf);
      notificationdatavm.ntfHashMap.set(existNtf.hashCode, existNtf);

      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_single_ntf_when_existNtf_is_same_hashCode_as_incomingNtf', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let incomingNtf: NotificationBase = new NormalNotification();
      let existNtf: NotificationBase = new NormalNotification();
      notificationdatavm.ntfGroupMap.set(existNtf.groupKey, existNtf);
      notificationdatavm.ntfHashMap.set(existNtf.hashCode, existNtf);

      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_merge_ntfs_when_existNtf_is_normal_and_incomingNtf_is_normal_and_different_hashCode', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let incomingNtf: NotificationBase = new NormalNotification();
      let existNtf: NotificationBase = new NormalNotification();
      notificationdatavm.ntfGroupMap.set(existNtf.groupKey, existNtf);
      notificationdatavm.ntfHashMap.set(existNtf.hashCode, existNtf);

      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_vm_when_saving_ntf', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let incomingNtf: NotificationBase = new NormalNotification();
      const result = notificationdatavm.saveNtf(incomingNtf);
      expect(result).assertInstanceOf(NotificationBase);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

  });

  describe('clearNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_incomingNtf_is_null', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      const result = notificationdatavm.clearNtf(null);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_incomingNtf_is_not_exist_in_groupMap', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.vmInjector.deleteVmByNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let incomingNtf: NotificationBase = new NormalNotification('1');
      const result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(notificationdatavm.vmInjector, notificationdatavm.vmInjector.deleteVmByNtf);
    });

    it('should_return_undefined_when_incomingNtf_is_exist_in_groupMap_and_is_reset_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.isResetGroup);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.releaseGroup);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      let incomingNtf: NotificationBase = new NormalNotification('1');
      notificationdatavm.ntfGroupMap.set(incomingNtf.groupKey, new NormalNotificationGroup('1'));
      const result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(notificationdatavm.isResetGroup);
      mocker.ignoreMock(notificationdatavm.releaseGroup);
    });

    it('should_return_undefined_when_incomingNtf_is_exist_in_groupMap_and_has_more_than_one_child', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.isResetGroup);
      when(mockfunc)().afterReturn(false);
      let incomingNtf: NotificationBase = new NormalNotification('1');
      let group: NormalNotificationGroup = new NormalNotificationGroup('1');
      group.children = ArrayUtils.arrayOf<NotificationBase>(new NormalNotification('2'));
      notificationdatavm.ntfGroupMap.set(incomingNtf.groupKey, group);
      const result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(notificationdatavm.isResetGroup);
    });

    it('should_return_undefined_when_incomingNtf_is_exist_in_groupMap_and_has_more_than_one_child_and_is_not_reset_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.isResetGroup);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.releaseGroup);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      let incomingNtf: NotificationBase = new NormalNotification('1');
      let group: NormalNotificationGroup = new NormalNotificationGroup('1');
      group.children = ArrayUtils.arrayOf<NotificationBase>(new NormalNotification('2'));
      notificationdatavm.ntfGroupMap.set(incomingNtf.groupKey, group);
      const result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(notificationdatavm.isResetGroup);
      mocker.ignoreMock(notificationdatavm.releaseGroup);
    });

    it('should_return_undefined_when_incomingNtf_is_exist_in_groupMap_and_has_more_than_one_child_and_is_reset_group_but_not_release_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.isResetGroup);
      when(mockfunc)().afterReturn(true);
      let incomingNtf: NotificationBase = new NormalNotification('1');
      let group: NormalNotificationGroup = new NormalNotificationGroup('1');
      group.children = ArrayUtils.arrayOf<NotificationBase>(new NormalNotification('2'));
      notificationdatavm.ntfGroupMap.set(incomingNtf.groupKey, group);
      const result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(notificationdatavm.isResetGroup);
    });

    it('should_return_undefined_when_incomingNtf_is_exist_in_groupMap_and_has_more_than_one_child_and_is_reset_group_and_release_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.isResetGroup);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.releaseGroup);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      let incomingNtf: NotificationBase = new NormalNotification('1');
      let group: NormalNotificationGroup = new NormalNotificationGroup('1');
      group.children = ArrayUtils.arrayOf<NotificationBase>(new NormalNotification('2'));
      notificationdatavm.ntfGroupMap.set(incomingNtf.groupKey, group);
      const result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(notificationdatavm.isResetGroup);
      mocker.ignoreMock(notificationdatavm.releaseGroup);
    });

    it('should_return_undefined_when_incomingNtf_is_exist_in_groupMap_and_has_more_than_one_child_and_is_reset_group_and_release_group_and_update_group', 0, () => {
      let notificationdatavm: NotificationDataVm = new NotificationDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.isResetGroup);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.releaseGroup);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc3: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.addMapData);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(notificationdatavm, notificationdatavm.vmInjector.updateVmByNtf);
      when(mockfunc4)(ArgumentMatchers.any).afterReturnNothing();
      let incomingNtf: NotificationBase = new NormalNotification('1');
      let group: NormalNotificationGroup = new NormalNotificationGroup('1');
      group.children = ArrayUtils.arrayOf<NotificationBase>(new NormalNotification('2'));
      notificationdatavm.ntfGroupMap.set(incomingNtf.groupKey, group);
      const result = notificationdatavm.clearNtf(incomingNtf);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(notificationdatavm.isResetGroup);
      mocker.ignoreMock(notificationdatavm.releaseGroup);
      mocker.ignoreMock(notificationdatavm.addMapData);
      mocker.ignoreMock(notificationdatavm.vmInjector, notificationdatavm.vmInjector.updateVmByNtf);
    });
  });
}