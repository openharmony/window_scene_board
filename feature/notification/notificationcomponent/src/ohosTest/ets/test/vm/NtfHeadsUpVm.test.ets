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
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { CommonUtils, ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsConstants } from '@ohos/commonconstants';
import { WindowConstants, SettingsKeyConstants, SCBConstants } from '@ohos/commonconstants';
import {
  EvtBus,
  EventManager,
  PluginSlot,
  WindowEvent,
  HiDfxEventUtil,
  sSettingsUtil,
  SCBWindowSceneConfig,
  ScreenLockEvent,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { windowMgr, SCBSystemBarProperty, SCBSceneSessionManager,
  SCBSpecificSceneSessionList,
  SpecificPanelZOrder,
  SCBSessionRect} from '@ohos/windowscene';
import { NotificationEntryEvent } from '../../../main/ets/common/event/NotificationEvent';
import { hideBannerNtfContentObj } from '../../../main/ets/model/HideBannerNtfContentObj';
import { notificationConfigManager } from '../../../main/ets/manager/NotificationConfigManager';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEvent';
import { HideBannerContentType } from '@ohos/systemuicommon/src/main/ets/constants/HideBannerContentType';
import sceneSessionManager from '@ohos.sceneSessionManager';
import Window from '@ohos.window';
import { NotificationSysEventReporter } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import I18n from '@ohos.i18n';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfHeadsUpVM } from '../../../main/ets/vm/NtfHeadsUpVM';
export default function NtfHeadsUpVMTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_register_system_bar_property_callbacks', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.registerSystemBarPropertyCallbacks);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      mocker.ignoreMock(scbSceneSessionManager, scbSceneSessionManager.registerSystemBarPropertyCallbacks);
    });
    it('should_register_event_listeners', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc1: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc1)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockfunc2: Function =
        mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc3: Function =
        mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });
    it('should_handle_window_event', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let windowEvent: WindowEvent =
        new WindowEvent(WindowConstants.WINDOW_NAME, Window.WindowEventType.WINDOW_START_SHOW);
      EvtBus.emit(windowEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });
    it('should_handle_notification_entry_event', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let notificationEntryEvent: NotificationEntryEvent =
        new NotificationEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_ADD, [new NotificationEntry()]);
      EvtBus.emit(notificationEntryEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });
    it('should_handle_screen_lock_event', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let screenLockEvent: ScreenLockEvent = new ScreenLockEvent(true);
      EvtBus.emit(screenLockEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });
    it('should_handle_notification_config_change_event', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let notificationConfigEvent: NotificationConfigEvent =
        new NotificationConfigEvent(NotificationConfigEventType.HIDE_BANNER_CONTENT, 1, true);
      EvtBus.emit(notificationConfigEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });
    it('should_handle_global_hidden_content_change_event', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let notificationConfigEvent: NotificationConfigEvent =
        new NotificationConfigEvent(NotificationConfigEventType.HIDE_BANNER_CONTENT, 1, true);
      EvtBus.emit(notificationConfigEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });
    it('should_handle_window_event_hide_heads_up_window_with_anim', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let windowEvent: WindowEvent =
        new WindowEvent(WindowConstants.WINDOW_NAME, Window.WindowEventType.WINDOW_START_SHOW);
      EvtBus.emit(windowEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });
    it('should_handle_notification_entry_event_update_notification', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let notificationEntryEvent: NotificationEntryEvent =
        new NotificationEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_UPDATE, [new NotificationEntry()]);
      EvtBus.emit(notificationEntryEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });
    it('should_handle_notification_entry_event_cancel_notification', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      let notificationEntryEvent: NotificationEntryEvent =
        new NotificationEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_CANCEL, [new NotificationEntry()]);
      EvtBus.emit(notificationEntryEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
    });

    it('should_not_report_notification_when_newEntry_is_invalid', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => false;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = PluginSlot.TYPE_SYSTEM;
      newEntry.remindConfig = {
        isBannerEnable: () => false
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();


      when(mocker.mockFunc(windowMgr, windowMgr.isShowing))(ArgumentMatchers.anyString).afterReturn(true);

      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();

    });

    it('should_report_notification_correctly_when_newEntry_is_ignored', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = PluginSlot.TYPE_SYSTEM;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();


      when(mocker.mockFunc(windowMgr, windowMgr.isShowing))(ArgumentMatchers.anyString).afterReturn(true);

      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.ignoredList.set(newEntry.hashCode, new Date());
      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();

    });

    it('should_report_notification_correctly_when_newEntry_is_sticky', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = PluginSlot.TYPE_SYSTEM;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = false;

      let mocker: MockKit = new MockKit();


      when(mocker.mockFunc(windowMgr, windowMgr.isShowing))(ArgumentMatchers.anyString).afterReturn(true);

      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();

    });

    it('should_report_notification_correctly_when_newEntry_is_not_sticky', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = PluginSlot.TYPE_SYSTEM;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();


      when(mocker.mockFunc(windowMgr, windowMgr.isShowing))(ArgumentMatchers.anyString).afterReturn(true);

      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();

    });

    it('should_report_notification_correctly_when_newEntry_is_ongoing_false', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = false;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = PluginSlot.TYPE_SYSTEM;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();


      when(mocker.mockFunc(windowMgr, windowMgr.isShowing))(ArgumentMatchers.anyString).afterReturn(true);

      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();

    });

    it('should_report_notification_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = 0;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();
    });

    it('should_report_notification_with_isFromPush_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = true;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = 0;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();
    });

    it('should_report_notification_with_isOngoing_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = false;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = 0;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();
    });

    it('should_report_notification_with_isLiveType_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => false;
      newEntry.isHeadsUp = () => true;
      newEntry.creatorBundleName = 'com.example.app';
      newEntry.id = 1;
      newEntry.slotType = 0;
      newEntry.remindConfig = {
        isBannerEnable: () => true
      };
      newEntry.style = {};
      newEntry.isRemoveAllowed = false;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();
    });

    it('should_return_true_when_all_conditions_are_met', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSystemValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn('false');

      let entry: NotificationEntry = new NotificationEntry();
      entry.isHeadsUp = () => true;
      let result = ntfheadsupvm.isAllowShowHeadsUp(entry, false);
      expect(result).assertEqual(true);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSystemValue);
    });

    it('should_log_warn_when_oldEntries_is_null', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowManagerProxy: WindowConstants = WindowConstants.getInstance();
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.creatorUid = 1;
      notificationEntry.bannerHideContentMode = 0;
      let notificationEntryArray: Array<NotificationEntry> = [notificationEntry];
      ntfheadsupvm['callback'] = { getNtfEntries: () => notificationEntryArray };
      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;
      await ntfheadsupvm.onNotificationConfigChange(event);
      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_info_when_event_type_is_hide_banner_content', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;

      await ntfheadsupvm.onNotificationConfigChange(event);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  })
}