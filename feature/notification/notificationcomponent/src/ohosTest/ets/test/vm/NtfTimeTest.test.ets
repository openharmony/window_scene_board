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

    it('should_remove_entry_successfully_when_entry_exists', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();

      let mockLogHelperWarn: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockLogHelperWarn)(ArgumentMatchers.any).afterReturnNothing();

      let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 12345;
      ntfheadsupvm.removeEntry(entry);

      mocker.ignoreMock(LogHelper, LogHelper.warn);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_not_remove_entry_when_entry_does_not_exist', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();

      let mockLogHelperWarn: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockLogHelperWarn)(ArgumentMatchers.any).afterReturnNothing();

      let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 12345;
      ntfheadsupvm.removeEntry(entry);

      mocker.ignoreMock(LogHelper, LogHelper.warn);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_remove_entry_successfully_when_entry_exists_and_viewinfo_exists', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();

      let mockLogHelperWarn: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockLogHelperWarn)(ArgumentMatchers.any).afterReturnNothing();

      let mockLogHelperInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogHelperInfo)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 12345;
      ntfheadsupvm.viewInfoMap.set(entry.hashCode, new EntryViewInfo());
      ntfheadsupvm.removeEntry(entry);

      mocker.ignoreMock(LogHelper, LogHelper.warn);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_log_warn_when_entry_not_exist', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      ntfheadsupvm.removeAndPushEntry(entry);
      expect(LogHelper.warn).assertCalledWith("removeEntry failed, entry not exist");
    });

    it('should_remove_and_push_entry_successfully', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let entries = ntfheadsupvm.callback.getNtfEntries();
      entries.push(entry);
      ntfheadsupvm.removeAndPushEntry(entry);
      expect(entries[0]).assertEqual(entry);
    });

    it('should_replace_entry_successfully_when_entry_exists', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockLogHelper: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockLogHelper)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 123;
      ntfheadsupvm.replaceEntry(entry);

      mocker.ignoreMock(LogHelper, LogHelper.warn);
    });

    it('should_log_warning_when_entry_does_not_exist', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockLogHelper: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockLogHelper)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 123;
      ntfheadsupvm.replaceEntry(entry);

      mocker.ignoreMock(LogHelper, LogHelper.warn);
    });

    it('should_set_hide_content_to_true_when_bannerHideContentMode_is_ALWAYS', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.bannerHideContentMode = HideBannerContentType.ALWAYS;
      ntfheadsupvm.setHideContent(newEntry);
      expect(newEntry.shouldHideContent).assertTrue();
    });
    it('should_set_hide_content_to_false_when_bannerHideContentMode_is_FOLLOW_SYSTEM', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.bannerHideContentMode = HideBannerContentType.FOLLOW_SYSTEM;
      ntfheadsupvm.setHideContent(newEntry);
      expect(newEntry.shouldHideContent).assertFalse();
    });
    it('should_set_hide_content_to_true_when_bannerHideContentMode_is_NEVER', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.bannerHideContentMode = HideBannerContentType.NEVER;
      ntfheadsupvm.setHideContent(newEntry);
      expect(newEntry.shouldHideContent).assertTrue();
    });
    it('should_set_hide_content_to_true_when_getIsHiddenContent_returns_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.bannerHideContentMode = HideBannerContentType.FOLLOW_SYSTEM;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.getIsHiddenContent);
      when(mockfunc)().afterReturn(true);
      ntfheadsupvm.setHideContent(newEntry);
      expect(newEntry.shouldHideContent).assertTrue();
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.getIsHiddenContent);
    });
    it('should_set_hide_content_to_false_when_getIsHiddenContent_returns_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.bannerHideContentMode = HideBannerContentType.FOLLOW_SYSTEM;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.getIsHiddenContent);
      when(mockfunc)().afterReturn(false);
      ntfheadsupvm.setHideContent(newEntry);
      expect(newEntry.shouldHideContent).assertFalse();
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.getIsHiddenContent);
    });

    it('should_set_hide_content_to_false_when_getIsHiddenContent_returns_false_1', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.bannerHideContentMode = HideBannerContentType.FOLLOW_SYSTEM;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.getIsHiddenContent);
      when(mockfunc)().afterReturn(false);
      ntfheadsupvm.setHideContent(newEntry);
      expect(newEntry.shouldHideContent).assertFalse();
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.getIsHiddenContent);
    });

    it('should_set_isGestureActioning_correctly', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(isGestureActioning);
    });

    it('should_remove_entry_when_hasNo_cancelTimer_and_checkShouldDeleteEntry_is_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockRemoveEntry: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.removeEntry);
      when(mockRemoveEntry)(ArgumentMatchers.any).afterReturnNothing();
      let mockDebug: Function = mocker.mockFunc(LogHelper, LogHelper.debug);
      when(mockDebug)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(isGestureActioning);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
      mocker.ignoreMock(LogHelper, LogHelper.debug);
    });

    it('should_not_remove_entry_when_has_cancelTimer', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      ntfheadsupvm.hasCancelTimer = (entry: NotificationEntry) => {return true;};
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(isGestureActioning);
    });

    it('should_not_remove_entry_when_checkShouldDeleteEntry_is_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      ntfheadsupvm.checkShouldDeleteEntry = (entry: NotificationEntry) => {return false;};
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(isGestureActioning);
    });

    it('should_log_debug_when_viewInfoMap_has_entry', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockDebug: Function = mocker.mockFunc(LogHelper, LogHelper.debug);
      when(mockDebug)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(isGestureActioning);
      mocker.ignoreMock(LogHelper, LogHelper.debug);
    });

    it('should_log_warn_when_viewInfoMap_has_no_entry', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockDebug: Function = mocker.mockFunc(LogHelper, LogHelper.debug);
      let mockWarn: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockDebug)(ArgumentMatchers.any).afterReturnNothing();
      when(mockWarn)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(isGestureActioning);
      mocker.ignoreMock(LogHelper, LogHelper.debug);
      mocker.ignoreMock(LogHelper, LogHelper.warn);
    });

    it('should_set_isGestureActioning_to_false_when_entry_is_ignored', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      ntfheadsupvm.ignoredList.set(entry.hashCode, new Date());
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(false);
    });

    it('should_set_isGestureActioning_to_false_when_entry_is_not_ignored_but_is_ignored_after_update', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      ntfheadsupvm.ignoredList.set(entry.hashCode, new Date());
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      ntfheadsupvm.ignoredList.delete(entry.hashCode);
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(false);
    });

    it('should_set_isGestureActioning_to_false_when_entry_is_ignored_and_isGestureActioning_is_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = true;
      ntfheadsupvm.ignoredList.set(entry.hashCode, new Date());
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(false);
    });

    it('should_set_isGestureActioning_to_true_when_entry_is_ignored_but_isGestureActioning_is_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      entry.hashCode = 1;
      let isGestureActioning: boolean = false;
      ntfheadsupvm.ignoredList.set(entry.hashCode, new Date());
      ntfheadsupvm.setIsGestureActioning(entry, isGestureActioning);
      let result = ntfheadsupvm.viewInfoMap.get(entry.hashCode);
      expect(result.isGestureActioning).assertEqual(true);
    });

    it('should_log_info_and_set_viewInfo_when_viewInfo_is_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let isHover: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setItemHoverState(entry, isHover);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_set_isHover_and_call_removeEntry_when_hasCancelTimer_is_false_and_checkShouldDeleteEntry_is_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let isHover: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockRemoveEntry: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.removeEntry);
      when(mockRemoveEntry)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setItemHoverState(entry, isHover);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
    });
    it('should_set_isHover_and_not_call_removeEntry_when_hasCancelTimer_is_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let isHover: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockRemoveEntry: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.removeEntry);
      when(mockRemoveEntry)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setItemHoverState(entry, isHover);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
    });
    it('should_set_isHover_and_not_call_removeEntry_when_checkShouldDeleteEntry_is_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let isHover: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockRemoveEntry: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.removeEntry);
      when(mockRemoveEntry)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setItemHoverState(entry, isHover);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
    });
  })
}