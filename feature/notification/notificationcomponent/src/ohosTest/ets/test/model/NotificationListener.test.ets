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

import Ntf from '@ohos.notificationSubscribe';
import NtfMgr from '@ohos.notificationManager';
import wantAgent from '@ohos.app.ability.wantAgent';
import Want from '@ohos.app.ability.Want';
import {
  ImmersiveEntryEvent,
  LiveViewEntryEvent,
  notificationCcmConfig,
  AudioUtil,
  BaseNotification,
  NtfEventType,
  crossModuleCallUtil,
  TaskQueue,
  TaskItem,
  LiveApp2CapsuleEvent,
  TaskQueueFrozenReason,
} from '@ohos/systemuicommon';
import {
  ArrayUtils,
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  SingletonHelper,
  TraceUtil,
} from '@ohos/basicutils';
import { SettingsKeyConstants, SettingsConstants } from '@ohos/commonconstants';
import { NotificationEntryEvent } from '../../../main/ets/common/event/NotificationEvent';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NtfMgr as NotificationManager } from '../../../main/ets/model/NotificationManager';
import NotificationListLimiter from '../../../main/ets/model/NotificationListLimiter';
import { audio } from '@kit.AudioKit';
import { systemParameter } from '@kit.BasicServicesKit';
import common from '@ohos.app.ability.common';
import { NotificationReminder } from '../../../main/ets/model/NotificationReminder';
import systemSoundManager from '@ohos.multimedia.systemSoundManager';
import { notificationConfigManager } from '../../../main/ets/manager/NotificationConfigManager';
import { notificationIntelligentManager } from '../../../main/ets/manager/NotificationIntelligentManager';
import notificationManager from '@ohos.notificationManager';
import { SwingTrackVm } from '../../../main/ets/model/SwingTrackVm';
import { SystemUIStateEventReporter } from '@ohos/systemuicommon/src/main/ets/reporter/SystemUIStateReporter';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { ParseNotificationMaintenance } from '../../../main/ets/maintenance/ParseNotificationMaintenance';
import { NotificationRestoreManager } from '../../../main/ets/backup/NotificationRestoreManager';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { InnerEventUtil, NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import { NotificationExceptionCode } from '../../../main/ets/maintenance/NotificationExceptionCode';
import { HaInitManager } from '../../../main/ets/manager/HaInitManager';
import { RingSettingManager } from '../../../main/ets/manager/RingSettingManager';
import { notificationMaintenanceEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationMaintenanceEvent';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationListener } from '../../../main/ets/model/NotificationListener';
export default function NotificationListenerTest() {
  describe('onNotificationBatchCancel_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_cancelData_is_invalid', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      notificationlistener.onNotificationBatchCancel(cancelData);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_process_cancelData_when_cancelData_is_valid', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_send_events_when_cancelData_is_valid', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;
      notificationlistener.postLiveViewEntryEvent(eventType, delLiveList);
      notificationlistener.postImmersiveEvent(eventType, delList);
      notificationlistener.postNtfEntryEvent(eventType, delList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_ntf_num_when_cancelData_is_valid', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;
      notificationlistener.postLiveViewEntryEvent(eventType, delLiveList);
      notificationlistener.postImmersiveEvent(eventType, delList);
      notificationlistener.postNtfEntryEvent(eventType, delList);

      let systemUIStateEventReporter: SystemUIStateEventReporter = SystemUIStateEventReporter.get();
      let mockUpdateNtfNum: Function = mocker.mockFunc(systemUIStateEventReporter, systemUIStateEventReporter.updateNtfNum);
      when(mockUpdateNtfNum)(ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationlistener.onNotificationBatchCancel(cancelData);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(systemUIStateEventReporter, systemUIStateEventReporter.updateNtfNum);
    });

    it('should_return_immediately_when_hasRegistered_is_true', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      notificationlistener.hasRegistered = true;
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
    });

    it('should_return_immediately_when_result_is_true', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(true);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });

    it('should_return_immediately_when_hasStartRegister_is_true', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      notificationlistener.hasStartRegister = true;
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasStartRegister).assertEqual(true);
    });

    it('should_retry_register_notification_when_timeSecond_exceeds_MAX_RETRY_SUBSCRIBE', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(false);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasStartRegister).assertEqual(true);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });

    it('should_stop_retry_register_notification_when_hasRegistered_is_true_after_retry_1', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(false);
      when(mockfunc)().afterReturn(true);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
      expect(notificationlistener.hasStartRegister).assertEqual(false);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });
    it('should_log_info_when_cancelData_is_invalid_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      notificationlistener.onNotificationBatchCancel(cancelData);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_process_cancelData_when_cancelData_is_valid_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_send_events_when_cancelData_is_valid_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;
      notificationlistener.postLiveViewEntryEvent(eventType, delLiveList);
      notificationlistener.postImmersiveEvent(eventType, delList);
      notificationlistener.postNtfEntryEvent(eventType, delList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_ntf_num_when_cancelData_is_valid_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;
      notificationlistener.postLiveViewEntryEvent(eventType, delLiveList);
      notificationlistener.postImmersiveEvent(eventType, delList);
      notificationlistener.postNtfEntryEvent(eventType, delList);

      let systemUIStateEventReporter: SystemUIStateEventReporter = SystemUIStateEventReporter.get();
      let mockUpdateNtfNum: Function = mocker.mockFunc(systemUIStateEventReporter, systemUIStateEventReporter.updateNtfNum);
      when(mockUpdateNtfNum)(ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationlistener.onNotificationBatchCancel(cancelData);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(systemUIStateEventReporter, systemUIStateEventReporter.updateNtfNum);
    });

    it('should_return_immediately_when_hasRegistered_is_true_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      notificationlistener.hasRegistered = true;
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
    });

    it('should_return_immediately_when_result_is_true_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(true);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });

    it('should_return_immediately_when_hasStartRegister_is_true_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      notificationlistener.hasStartRegister = true;
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasStartRegister).assertEqual(true);
    });

    it('should_retry_register_notification_when_timeSecond_exceeds_MAX_RETRY_SUBSCRIBE_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(false);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasStartRegister).assertEqual(true);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });

    it('should_stop_retry_register_notification_when_hasRegistered_is_true_after_retry_2', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(false);
      when(mockfunc)().afterReturn(true);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
      expect(notificationlistener.hasStartRegister).assertEqual(false);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });
    it('should_log_info_when_cancelData_is_invalid_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      notificationlistener.onNotificationBatchCancel(cancelData);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_process_cancelData_when_cancelData_is_vali_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_send_events_when_cancelData_is_valid_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;

      notificationlistener.postLiveViewEntryEvent(eventType, delLiveList);
      notificationlistener.postImmersiveEvent(eventType, delList);
      notificationlistener.postNtfEntryEvent(eventType, delList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_ntf_num_when_cancelData_is_valid_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let cancelData: Array<Ntf.SubscribeCallbackData> = new Array();
      let callbackData: Ntf.SubscribeCallbackData = new Ntf.SubscribeCallbackData();
      callbackData.notification = new NtfMgr.Notification();
      callbackData.notification.id = 1;
      cancelData.push(callbackData);

      let delList: Array<NotificationEntry> = new Array();
      let delLiveList: Array<NotificationEntry> = new Array();
      notificationlistener.cancelData(callbackData, delList, delLiveList);

      let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;
      notificationlistener.postLiveViewEntryEvent(eventType, delLiveList);
      notificationlistener.postImmersiveEvent(eventType, delList);
      notificationlistener.postNtfEntryEvent(eventType, delList);

      let systemUIStateEventReporter: SystemUIStateEventReporter = SystemUIStateEventReporter.get();
      let mockUpdateNtfNum: Function = mocker.mockFunc(systemUIStateEventReporter, systemUIStateEventReporter.updateNtfNum);
      when(mockUpdateNtfNum)(ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationlistener.onNotificationBatchCancel(cancelData);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(systemUIStateEventReporter, systemUIStateEventReporter.updateNtfNum);
    });

    it('should_return_immediately_when_hasRegistered_is_true_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      notificationlistener.hasRegistered = true;
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
    });

    it('should_return_immediately_when_result_is_true_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(true);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });

    it('should_return_immediately_when_hasStartRegister_is_true_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      notificationlistener.hasStartRegister = true;
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasStartRegister).assertEqual(true);
    });

    it('should_retry_register_notification_when_timeSecond_exceeds_MAX_RETRY_SUBSCRIBE_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(false);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasStartRegister).assertEqual(true);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });

    it('should_stop_retry_register_notification_when_hasRegistered_is_true_after_retry_3', 0, async () => {
      let notificationlistener: NotificationListener = new NotificationListener();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationlistener, notificationlistener.subscribeNotification);
      when(mockfunc)().afterReturn(false);
      when(mockfunc)().afterReturn(true);
      await notificationlistener.registerNotification();
      expect(notificationlistener.hasRegistered).assertEqual(true);
      expect(notificationlistener.hasStartRegister).assertEqual(false);
      mocker.ignoreMock(notificationlistener, notificationlistener.subscribeNotification);
    });
  });
}