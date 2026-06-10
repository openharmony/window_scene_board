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

    it('should_register_all_listeners_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_window_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      let windowEvent: WindowEvent = new WindowEvent(WindowConstants.WINDOW_NAME, WindowConstants.WINDOW_SHOW);
      ntfheadsupvm.onWindowEvent(windowEvent);

      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_notification_entry_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      let notificationEntryEvent: NotificationEntryEvent = new NotificationEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_ADD, [new NotificationEntry()]);
      ntfheadsupvm.onNtfEntryEvent(notificationEntryEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_screen_lock_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      let screenLockEvent: ScreenLockEvent = new ScreenLockEvent(true);
      ntfheadsupvm.onScreenLockEvent(screenLockEvent);

      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_global_hidden_content_change_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function =
        mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function =
        mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      hideBannerNtfContentObj.registerHiddenContentChangedEvent((data: boolean) => {
        ntfheadsupvm.onGlobalHiddenContentChange(data);
      });
      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_return_immediately_when_isLockScreen_is_same', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = false;
      ntfheadsupvm.onScreenLockEvent(event);
      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(false);
    });

    it('should_hide_window_when_isLockScreen_is_true_and_window_is_showing', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = true;
      ntfheadsupvm.isLockScreen = false;

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(true);

      let mockHideWindow: Function = mocker.mockFunc(windowMgr, windowMgr.hideWindowImmediately);
      when(mockHideWindow)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', true).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(windowMgr, windowMgr.hideWindowImmediately);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_hide_window_when_isLockScreen_is_false_and_window_is_not_showing', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = true;

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', false).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(false);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_true_and_window_is_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = true;
      ntfheadsupvm.isLockScreen = false;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(true);

      let mockHideWindow: Function = mocker.mockFunc(windowMgr, windowMgr.hideWindowImmediately);
      when(mockHideWindow)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', true).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(windowMgr, windowMgr.hideWindowImmediately);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_false_and_window_is_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = true;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(true);

      let mockHideWindow: Function = mocker.mockFunc(windowMgr, windowMgr.hideWindowImmediately);
      when(mockHideWindow)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', false).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(false);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(windowMgr, windowMgr.hideWindowImmediately);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_true_and_window_is_not_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = true;
      ntfheadsupvm.isLockScreen = false;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', true).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_false_and_window_is_not_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = true;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(false);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', false).afterReturnNothing();
      ntfheadsupvm.onScreenLockEvent(event);
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_is_not_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(true, '#00FFFFFF', '#FF000000', false, false));
      expect(ntfheadsupvm.isInTint).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_is_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(null);
      expect(ntfheadsupvm.isInTint).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_property_is_not_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(true, '#00FFFFFF', '#FF000000', false, false));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_property_is_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(null);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_enable_is_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(true, '#00FFFFFF', '#FF000000', false, false));
      expect(ntfheadsupvm.isInTint).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_enable_is_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(false, '#00FFFFFF', '#FF000000', false, false));
      expect(ntfheadsupvm.isInTint).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_window_not_showing', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(false);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.onGlobalHiddenContentChange(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_log_warn_when_oldEntry_is_null', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);
      let mockGetNtfEntries: Function = mocker.mockFunc(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      when(mockGetNtfEntries)().afterReturn(null);
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.onGlobalHiddenContentChange(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });
    it('should_set_hide_content_and_notify_when_entries_exist', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);
      let mockGetNtfEntries: Function = mocker.mockFunc(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      let mockEntry: NotificationEntry = new NotificationEntry();
      mockEntry.hashCode = 1;
      mockEntry.isHeadsUpStick = false;
      when(mockGetNtfEntries)().afterReturn([mockEntry]);
      let mockSetHideContent: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.setHideContent);
      when(mockSetHideContent)(ArgumentMatchers.anyObj).afterReturnNothing();
      let mockNotifyNtfEntryChange: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.notifyNtfEntryChange);
      when(mockNotifyNtfEntryChange)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturnNothing();
      ntfheadsupvm.onGlobalHiddenContentChange(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.setHideContent);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.notifyNtfEntryChange);
    });

    it('should_log_info_when_event_type_is_hide_banner_content', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;
      await ntfheadsupvm.onNotificationConfigChange(event);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_window_is_not_showing', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowManagerProxy: WindowConstants = WindowConstants.getInstance();
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(false);

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;
      await ntfheadsupvm.onNotificationConfigChange(event);
      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
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

    it('should_register_all_listeners_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_window_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      let windowEvent: WindowEvent = new WindowEvent(WindowConstants.WINDOW_NAME, WindowConstants.WINDOW_SHOW);
      ntfheadsupvm.onWindowEvent(windowEvent);

      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_notification_entry_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      let notificationEntryEvent: NotificationEntryEvent = new NotificationEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_ADD, [new NotificationEntry()]);
      ntfheadsupvm.onNtfEntryEvent(notificationEntryEvent);
      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_screen_lock_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      let screenLockEvent: ScreenLockEvent = new ScreenLockEvent(true);
      ntfheadsupvm.onScreenLockEvent(screenLockEvent);

      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_handle_global_hidden_content_change_event_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockOnFunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(eventMgr);

      let mockRegisterHiddenContentChangedFunc: Function =
        mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      when(mockRegisterHiddenContentChangedFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockRegisterSystemBarPropertyCallbacksFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      when(mockRegisterSystemBarPropertyCallbacksFunc)(ArgumentMatchers.any).afterReturn(undefined);

      let mockSubscribeChangeEventFunc: Function =
        mocker.mockFunc(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
      when(mockSubscribeChangeEventFunc)(ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.init(EMPTY_CALLBACK);

      hideBannerNtfContentObj.registerHiddenContentChangedEvent((data: boolean) => {
        ntfheadsupvm.onGlobalHiddenContentChange(data);
      });
      mocker.ignoreMock(eventMgr, eventMgr.on);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.registerHiddenContentChangedEvent);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.subscribeChangeEvent);
    });

    it('should_return_immediately_when_isLockScreen_is_same', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = false;
      ntfheadsupvm.onScreenLockEvent(event);
      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(false);
    });

    it('should_hide_window_when_isLockScreen_is_true_and_window_is_showing', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = true;
      ntfheadsupvm.isLockScreen = false;

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(true);

      let mockHideWindow: Function = mocker.mockFunc(windowMgr, windowMgr.hideWindowImmediately);
      when(mockHideWindow)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', true).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(windowMgr, windowMgr.hideWindowImmediately);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_hide_window_when_isLockScreen_is_false_and_window_is_not_showing', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = true;

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', false).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(false);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_true_and_window_is_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = true;
      ntfheadsupvm.isLockScreen = false;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(true);

      let mockHideWindow: Function = mocker.mockFunc(windowMgr, windowMgr.hideWindowImmediately);
      when(mockHideWindow)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', true).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(windowMgr, windowMgr.hideWindowImmediately);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_false_and_window_is_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = true;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(true);

      let mockHideWindow: Function = mocker.mockFunc(windowMgr, windowMgr.hideWindowImmediately);
      when(mockHideWindow)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', false).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(false);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(windowMgr, windowMgr.hideWindowImmediately);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_true_and_window_is_not_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = true;
      ntfheadsupvm.isLockScreen = false;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', true).afterReturnNothing();

      ntfheadsupvm.onScreenLockEvent(event);
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_false_and_window_is_not_showing_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = true;
      ntfheadsupvm.ignoredList.set(1, new Date());

      let mocker: MockKit = new MockKit();
      let mockIsShowing: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockIsShowing)(ArgumentMatchers.anyString).afterReturn(false);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)('isLockScreen:%b', false).afterReturnNothing();
      ntfheadsupvm.onScreenLockEvent(event);
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_is_not_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(true, '#00FFFFFF', '#FF000000', false, false));
      expect(ntfheadsupvm.isInTint).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_is_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(null);
      expect(ntfheadsupvm.isInTint).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_property_is_not_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(true, '#00FFFFFF', '#FF000000', false, false));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_property_is_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(null);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_enable_is_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(true, '#00FFFFFF', '#FF000000', false, false));
      expect(ntfheadsupvm.isInTint).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_isInTint_correctly_when_property_enable_is_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      ntfheadsupvm.systemBarPropertyCB(new SCBSystemBarProperty(false, '#00FFFFFF', '#FF000000', false, false));
      expect(ntfheadsupvm.isInTint).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_window_not_showing', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(false);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.onGlobalHiddenContentChange(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_log_warn_when_oldEntry_is_null', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);
      let mockGetNtfEntries: Function = mocker.mockFunc(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      when(mockGetNtfEntries)().afterReturn(null);
      let mockShowWarn: Function = mocker.mockFunc(LogHelper, LogHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.onGlobalHiddenContentChange(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      mocker.ignoreMock(LogHelper, LogHelper.showWarn);
    });
    it('should_set_hide_content_and_notify_when_entries_exist', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);
      let mockGetNtfEntries: Function = mocker.mockFunc(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      let mockEntry: NotificationEntry = new NotificationEntry();
      mockEntry.hashCode = 1;
      mockEntry.isHeadsUpStick = false;
      when(mockGetNtfEntries)().afterReturn([mockEntry]);
      let mockSetHideContent: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.setHideContent);
      when(mockSetHideContent)(ArgumentMatchers.anyObj).afterReturnNothing();
      let mockNotifyNtfEntryChange: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.notifyNtfEntryChange);
      when(mockNotifyNtfEntryChange)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturnNothing();
      ntfheadsupvm.onGlobalHiddenContentChange(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(ntfheadsupvm.callback, ntfheadsupvm.callback.getNtfEntries);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.setHideContent);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.notifyNtfEntryChange);
    });

    it('should_log_info_when_event_type_is_hide_banner_content', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;
      await ntfheadsupvm.onNotificationConfigChange(event);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_window_is_not_showing', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowManagerProxy: WindowConstants = WindowConstants.getInstance();
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(false);

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;
      await ntfheadsupvm.onNotificationConfigChange(event);
      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
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

    it('should_log_info_when_window_is_not_showing', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowManagerProxy: WindowConstants = WindowConstants.getInstance();
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(false);

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();

      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;
      await ntfheadsupvm.onNotificationConfigChange(event);
      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
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

    it('should_log_warn_when_oldEntries_is_null', 0, async () => {
      event.uid = 1;
      event.index = 0;
      await ntfheadsupvm.onNotificationConfigChange(event);
      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });
  })
}