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
      mocker.verify('registerSystemBarPropertyCallbacks', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('on', []).once();
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
      mocker.verify('warn', []).once();
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
      mocker.verify('warn', []).once();
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
      mocker.verify('warn', []).once();
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
      mocker.verify('warn', []).once();
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
      mocker.verify('warn', []).once();
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
      mocker.verify('showInfo', []).once();
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
      mocker.verify('removeEntry', []).once();
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
      mocker.verify('removeEntry', []).once();
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
      mocker.verify('removeEntry', []).once();
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
    });

    it('should_return_empty_array_when_getNtfEntries_is_called', 0, () => {
      let emptycallback: EmptyCallback = new EmptyCallback();
      let result: NotificationEntry[] = emptycallback.getNtfEntries();
      expect(result).assertEqual([]);
    });

    it('should_log_warning_when_notifyNtfEntryChange_is_called', 0, () => {
      let emptycallback: EmptyCallback = new EmptyCallback();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      emptycallback.notifyNtfEntryChange([]);

      mocker.ignoreMock(logHelper, logHelper.warn);
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

      // 断言
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

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_isInTint_to_false_when_property_enable_is_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let property: SCBSystemBarProperty = new SCBSystemBarProperty(
        SCBConstants.ECB_SCENE_TYPE_STATUS_BAR, false, '#00FFFFFF', '#FF000000', false, false
      );
      ntfheadsupvm.systemBarPropertyCB(property);
      expect(ntfheadsupvm.isInTint).assertEqual(false);
    });

    it('should_set_isInTint_to_true_when_property_enable_is_true', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let property: SCBSystemBarProperty = new SCBSystemBarProperty(
        SCBConstants.ECB_SCENE_TYPE_STATUS_BAR, true, '#00FFFFFF', '#FF000000', false, false
      );
      ntfheadsupvm.systemBarPropertyCB(property);
      expect(ntfheadsupvm.isInTint).assertEqual(true);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_false_and_window_is_not_showing_and_ignored_list_is_not_empty_0', 0, () => {
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

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_false_and_window_is_not_showing_and_ignored_list_is_not_empty_1', 0, () => {
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

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ignored_list_when_isLockScreen_is_false_and_window_is_not_showing_and_ignored_list_is_not_empty_2', 0, () => {
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

      // 断言
      expect(ntfheadsupvm.isLockScreen).assertEqual(true);
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_isHover_and_call_removeEntry_when_hasCancelTimer_is_false_and_checkShouldDeleteEntry_is_true_0', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let isHover: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockRemoveEntry: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.removeEntry);
      when(mockRemoveEntry)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setItemHoverState(entry, isHover);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
    });

    it('should_set_isHover_and_not_call_removeEntry_when_hasCancelTimer_is_true_0', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let isHover: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockRemoveEntry: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.removeEntry);
      when(mockRemoveEntry)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setItemHoverState(entry, isHover);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
    });

    it('should_set_isHover_and_not_call_removeEntry_when_checkShouldDeleteEntry_is_false_0', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let isHover: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockRemoveEntry: Function = mocker.mockFunc(ntfheadsupvm, ntfheadsupvm.removeEntry);
      when(mockRemoveEntry)(ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.setItemHoverState(entry, isHover);
      mocker.ignoreMock(ntfheadsupvm, ntfheadsupvm.removeEntry);
    });

    it('should_not_remove_entry_when_entry_does_not_exist_0', 0, async () => {
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

    it('should_remove_entry_successfully_when_entry_exists_and_viewinfo_exists_0', 0, async () => {
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

    it('should_register_system_bar_property_callbacks_0', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.registerSystemBarPropertyCallbacks);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      mocker.ignoreMock(scbSceneSessionManager, scbSceneSessionManager.registerSystemBarPropertyCallbacks);
    });

    it('should_register_event_listeners_0', 0, () => {
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

    it('should_handle_window_event_0', 0, () => {
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

    it('should_register_event_listeners_1', 0, () => {
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

    it('should_register_event_listeners_2', 0, () => {
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

    it('should_handle_window_event_1', 0, () => {
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

    it('should_not_hide_window_when_isLockScreen_is_false_and_window_is_not_showing_0', 0, () => {
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

    it('should_not_hide_window_when_isLockScreen_is_false_and_window_is_not_showing_0', 0, () => {
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

    it('should_handle_window_event_2', 0, () => {
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

    it('should_handle_window_event_3', 0, () => {
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

    it('should_register_system_bar_property_callbacks_0', 0, () => {
      let event: ScreenLockEvent = new ScreenLockEvent();
      event.isLockScreen = false;
      ntfheadsupvm.isLockScreen = true;
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EvtBus.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.on);
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.registerSystemBarPropertyCallbacks);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      ntfheadsupvm.init(EMPTY_CALLBACK);
      mocker.ignoreMock(scbSceneSessionManager, scbSceneSessionManager.registerSystemBarPropertyCallbacks);
    });


    it('should_report_notification_correctly_when_newEntry_is_valid', 0, async () => {
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

    it('should_report_notification_with_isHeadsUp_false', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.isFromPush = false;
      newEntry.isOngoing = true;
      newEntry.isLiveType = () => true;
      newEntry.isHeadsUp = () => false;
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

    it('should_report_notification_with_isBannerEnable_false', 0, () => {
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
        isBannerEnable: () => false
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

    it('should_report_notification_with_isRemoveAllowed_true', 0, () => {
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
      newEntry.isRemoveAllowed = true;
      newEntry.isFromSystemApp = true;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();
    });

    it('should_report_notification_with_isFromSystemApp_false', 0, () => {
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
      newEntry.isFromSystemApp = false;
      newEntry.isHeadsUpStick = true;

      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();
    });

    it('should_report_notification_with_isHeadsUpStick_false', 0, () => {
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
      newEntry.isHeadsUpStick = false;

      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(NotificationSysEventReporter, NotificationSysEventReporter.notificationReceived))(ArgumentMatchers.anyObj).afterReturnNothing();

      ntfheadsupvm.report(newEntry);

      expect(true).assertTrue();
    });

    it('should_return_false_when_bannerNotDisturb_is_true', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSystemValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn('true');

      let entry: NotificationEntry = new NotificationEntry();
      let result = ntfheadsupvm.isAllowShowHeadsUp(entry, false);
      expect(result).assertEqual(false);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSystemValue);
    });

    it('should_return_false_when_entry_is_not_headsUp', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSystemValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn('false');

      let entry: NotificationEntry = new NotificationEntry();
      let result = ntfheadsupvm.isAllowShowHeadsUp(entry, false);
      expect(result).assertEqual(false);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSystemValue);
    });

    it('should_return_false_when_isUpdate_is_true_and_entry_is_liveType_and_isConvertFromNormal', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSystemValue);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn('false');

      let entry: NotificationEntry = new NotificationEntry();
      entry.isLiveType = () => true;
      entry.isConvertFromNormal = true;
      let result = ntfheadsupvm.isAllowShowHeadsUp(entry, true);
      expect(result).assertEqual(false);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSystemValue);
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

    it('should_log_info_when_window_is_not_showing', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowManagerProxy: Window.WindowManagerProxy = windowMgr;
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(false);

      let logHelper: LogHelper = LogHelper.INSTANCE;
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
      let windowManagerProxy: Window.WindowManagerProxy = windowMgr;
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.creatorUid = 1;
      notificationEntry.bannerHideContentMode = 0;

      let notificationEntryArray: NotificationEntry[] = [notificationEntry];

      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;

      await ntfheadsupvm.onNotificationConfigChange(event);

      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_not_update_hide_content_mode_when_hideContentChangedEntries_is_empty', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowManagerProxy: Window.WindowManagerProxy = windowMgr;
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.creatorUid = 1;
      notificationEntry.bannerHideContentMode = 0;

      let notificationEntryArray: NotificationEntry[] = [notificationEntry];

      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 0;

      await ntfheadsupvm.onNotificationConfigChange(event);

      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_update_hide_content_mode_when_hideContentChangedEntries_is_not_empty', 0, async () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowManagerProxy: Window.WindowManagerProxy = windowMgr;
      let mockfunc: Function = mocker.mockFunc(windowManagerProxy, windowManagerProxy.isShowing);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc2: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.creatorUid = 1;
      notificationEntry.bannerHideContentMode = 0;

      let notificationEntryArray: NotificationEntry[] = [notificationEntry];

      let event: NotificationConfigEvent = new NotificationConfigEvent();
      event.type = NotificationConfigEventType.HIDE_BANNER_CONTENT;
      event.uid = 1;
      event.index = 1;

      await ntfheadsupvm.onNotificationConfigChange(event);

      mocker.ignoreMock(windowManagerProxy, windowManagerProxy.isShowing);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_return_false_when_isHeadsUpStick_is_true', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHeadsUpStick = true;
      const result = ntfheadsupvm.checkShouldDeleteEntry(entry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_viewInfoMap_is_null_and_isHeadsUpStick_is_false', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHeadsUpStick = false;
      const result = ntfheadsupvm.checkShouldDeleteEntry(entry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isHover_is_true', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHeadsUpStick = false;
      ntfheadsupvm.viewInfoMap.set(entry.hashCode, {
        isHover: true, isGestureActioning: false
      });
      const result = ntfheadsupvm.checkShouldDeleteEntry(entry);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isGestureActioning_is_true', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHeadsUpStick = false;
      ntfheadsupvm.viewInfoMap.set(entry.hashCode, {
        isHover: false, isGestureActioning: true
      });
      const result = ntfheadsupvm.checkShouldDeleteEntry(entry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isHover_and_isGestureActioning_are_false', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHeadsUpStick = false;
      ntfheadsupvm.viewInfoMap.set(entry.hashCode, {
        isHover: false, isGestureActioning: false
      });
      const result = ntfheadsupvm.checkShouldDeleteEntry(entry);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_viewInfo_is_null', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      const result = ntfheadsupvm.hasCancelTimer(entry);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.warn);
    });

    it('should_return_true_when_cancelTimerId_is_undefined', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      ntfheadsupvm.viewInfoMap.set(entry.hashCode, { cancelTimerId: undefined });
      const result = ntfheadsupvm.hasCancelTimer(entry);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.warn);
    });

    it('should_return_false_when_cancelTimerId_is_defined', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let entry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      ntfheadsupvm.viewInfoMap.set(entry.hashCode, { cancelTimerId: 1 });
      const result = ntfheadsupvm.hasCancelTimer(entry);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.warn);
    });

    it('should_return_false_when_ignoredList_does_not_contain_creatorUid', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.creatorUid = 123;
      let result = ntfheadsupvm.isIgnoredNtf(newEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_ignoredList_contains_creatorUid_but_time_has_not_reached_ignore_threshold', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.creatorUid = 123;
      let now: Date = new Date();
      ntfheadsupvm.ignoredList.set(newEntry.creatorUid, now);
      let result = ntfheadsupvm.isIgnoredNtf(newEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_ignoredList_contains_creatorUid_and_time_has_reached_ignore_threshold', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let newEntry: NotificationEntry = new NotificationEntry();
      newEntry.creatorUid = 123;
      let now: Date = new Date();
      let ignoredTime: Date = new Date(now.getTime() - SettingsConstants.IGNORE_NTF_INTERVAL - 1000);
      ntfheadsupvm.ignoredList.set(newEntry.creatorUid, ignoredTime);
      let result = ntfheadsupvm.isIgnoredNtf(newEntry);
      expect(result).assertEqual(true);
      expect(ntfheadsupvm.ignoredList.has(newEntry.creatorUid)).assertEqual(false);
    });

    it('should_hide_heads_up_window_when_window_start_show_and_window_name_in_exclude_list', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowEvent: WindowEvent = new WindowEvent();
      let mockIsWindowStartShow: Function = mocker.mockFunc(windowEvent, windowEvent.isWindowStartShow);
      let mockIsWindowEndHide: Function = mocker.mockFunc(windowEvent, windowEvent.isWindowEndHide);
      let mockIsMatchName: Function = mocker.mockFunc(windowEvent, windowEvent.isMatchName);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockIsWindowStartShow)().afterReturn(true);
      when(mockIsWindowEndHide)().afterReturn(false);
      when(mockIsMatchName)(ArgumentMatchers.anyString).afterReturn(true);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.onWindowEvent(windowEvent);

      mocker.ignoreMock(windowEvent, windowEvent.isWindowStartShow);
      mocker.ignoreMock(windowEvent, windowEvent.isWindowEndHide);
      mocker.ignoreMock(windowEvent, windowEvent.isMatchName);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ntf_entry_change_when_window_end_hide_and_default_z_index_is_valid', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      ntfheadsupvm.defaultZIndex = 1;
      let mocker: MockKit = new MockKit();
      let windowEvent: WindowEvent = new WindowEvent();
      let mockIsWindowEndHide: Function = mocker.mockFunc(windowEvent, windowEvent.isWindowEndHide);
      let mockIsMatchName: Function = mocker.mockFunc(windowEvent, windowEvent.isMatchName);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockIsWindowEndHide)().afterReturn(true);
      when(mockIsMatchName)(ArgumentMatchers.anyString).afterReturn(true);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.onWindowEvent(windowEvent);

      mocker.ignoreMock(windowEvent, windowEvent.isWindowEndHide);
      mocker.ignoreMock(windowEvent, windowEvent.isMatchName);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_z_index_to_default_when_window_start_show', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowEvent: WindowEvent = new WindowEvent();
      let mockIsWindowStartShow: Function = mocker.mockFunc(windowEvent, windowEvent.isWindowStartShow);
      let mockIsMatchName: Function = mocker.mockFunc(windowEvent, windowEvent.isMatchName);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockSetZIndex: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.setZIndex);

      when(mockIsWindowStartShow)().afterReturn(true);
      when(mockIsMatchName)(ArgumentMatchers.anyString).afterReturn(true);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);
      when(mockSetZIndex)(ArgumentMatchers.any, ArgumentMatchers.anyNumber).afterReturn(undefined);

      ntfheadsupvm.onWindowEvent(windowEvent);

      mocker.ignoreMock(windowEvent, windowEvent.isWindowStartShow);
      mocker.ignoreMock(windowEvent, windowEvent.isMatchName);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.setZIndex);
    });

    it('should_notify_ntf_entry_change_when_window_start_show_and_ignored_list_is_not_empty', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      ntfheadsupvm.ignoredList.set(1, new Date());
      let mocker: MockKit = new MockKit();
      let windowEvent: WindowEvent = new WindowEvent();
      let mockIsWindowStartShow: Function = mocker.mockFunc(windowEvent, windowEvent.isWindowStartShow);
      let mockIsMatchName: Function = mocker.mockFunc(windowEvent, windowEvent.isMatchName);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockIsWindowStartShow)().afterReturn(true);
      when(mockIsMatchName)(ArgumentMatchers.anyString).afterReturn(true);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);

      ntfheadsupvm.onWindowEvent(windowEvent);

      mocker.ignoreMock(windowEvent, windowEvent.isWindowStartShow);
      mocker.ignoreMock(windowEvent, windowEvent.isMatchName);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_notify_ntf_entry_change_when_notification_config_event_is_hide_banner_content', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();
      let windowEvent: WindowEvent = new WindowEvent();
      let mockIsWindowStartShow: Function = mocker.mockFunc(windowEvent, windowEvent.isWindowStartShow);
      let mockIsMatchName: Function = mocker.mockFunc(windowEvent, windowEvent.isMatchName);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockGetNotificationConfig: Function = mocker.mockFunc(notificationConfigManager, notificationConfigManager.getNotificationConfig);

      when(mockIsWindowStartShow)().afterReturn(true);
      when(mockIsMatchName)(ArgumentMatchers.anyString).afterReturn(true);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(undefined);
      when(mockGetNotificationConfig)().afterReturn({
        type: NotificationConfigEventType.HIDE_BANNER_CONTENT,
        uid: 1,
        index: 0
      });

      ntfheadsupvm.onWindowEvent(windowEvent);

      mocker.ignoreMock(windowEvent, windowEvent.isWindowStartShow);
      mocker.ignoreMock(windowEvent, windowEvent.isMatchName);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationConfigManager, notificationConfigManager.getNotificationConfig);
    });

    it('should_not_change_zIndex_when_no_intersectAndActiveInputStatusBar', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();

      let mockGetWindowPosition: Function = mocker.mockFunc(windowMgr, windowMgr.getWindowPosition);
      when(mockGetWindowPosition)(ArgumentMatchers.anyString).afterReturn({ left: 0, top: 0, right: 0, bottom: 0 });

      let mockGetZIndex: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.getZIndex);
      when(mockGetZIndex)(ArgumentMatchers.any).afterReturn(100);

      let mockSetZIndex: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.setZIndex);

      ntfheadsupvm.keepZIndexAboveInputStatusBar();

      mocker.ignoreMock(windowMgr, windowMgr.getWindowPosition);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.getZIndex);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.setZIndex);
    });

    it('should_change_zIndex_when_intersectAndActiveInputStatusBar', 0, () => {
      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let mocker: MockKit = new MockKit();

      let mockGetWindowPosition: Function = mocker.mockFunc(windowMgr, windowMgr.getWindowPosition);
      when(mockGetWindowPosition)(ArgumentMatchers.anyString).afterReturn({ left: 0, top: 0, right: 0, bottom: 0 });

      let mockGetZIndex: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.getZIndex);
      when(mockGetZIndex)(ArgumentMatchers.any).afterReturn(100);

      let mockSetZIndex: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.setZIndex);

      let mockGetSpecificContainerSessionList: Function = mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getSpecificContainerSessionList);
      let sessionList: SCBSpecificSceneSessionList = [
        { isActive: true, session: { type: sceneSessionManager.SessionType.TYPE_INPUT_METHOD_STATUS_BAR, windowId: 1 } }
      ];
      when(mockGetSpecificContainerSessionList)(ArgumentMatchers.anyNumber).afterReturn(sessionList);

      ntfheadsupvm.keepZIndexAboveInputStatusBar();

      mocker.ignoreMock(windowMgr, windowMgr.getWindowPosition);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.getZIndex);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.setZIndex);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getSpecificContainerSessionList);
    });

    it('should_return_false_when_rect1_is_completely_to_the_left_of_rect2', 0, () => {
      let rect1: Window.Rect = new Window.Rect();
      rect1.left = 0;
      rect1.width = 100;
      rect1.top = 0;
      rect1.height = 100;

      let rect2: SCBSessionRect = new SCBSessionRect();
      rect2.left = 100;
      rect2.width = 100;
      rect2.top = 0;
      rect2.height = 100;

      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let result = ntfheadsupvm.intersect(rect1, rect2);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_rect1_is_completely_to_the_right_of_rect2', 0, () => {
      let rect1: Window.Rect = new Window.Rect();
      rect1.left = 200;
      rect1.width = 100;
      rect1.top = 0;
      rect1.height = 100;

      let rect2: SCBSessionRect = new SCBSessionRect();
      rect2.left = 0;
      rect2.width = 100;
      rect2.top = 0;
      rect2.height = 100;

      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let result = ntfheadsupvm.intersect(rect1, rect2);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_rect1_is_completely_below_rect2', 0, () => {
      let rect1: Window.Rect = new Window.Rect();
      rect1.left = 0;
      rect1.width = 100;
      rect1.top = 200;
      rect1.height = 100;

      let rect2: SCBSessionRect = new SCBSessionRect();
      rect2.left = 0;
      rect2.width = 100;
      rect2.top = 0;
      rect2.height = 100;

      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let result = ntfheadsupvm.intersect(rect1, rect2);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_rect1_is_completely_above_rect2', 0, () => {
      let rect1: Window.Rect = new Window.Rect();
      rect1.left = 0;
      rect1.width = 100;
      rect1.top = 0;
      rect1.height = 100;

      let rect2: SCBSessionRect = new SCBSessionRect();
      rect2.left = 0;
      rect2.width = 100;
      rect2.top = 200;
      rect2.height = 100;

      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let result = ntfheadsupvm.intersect(rect1, rect2);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_rect1_and_rect2_have_some_intersection', 0, () => {
      let rect1: Window.Rect = new Window.Rect();
      rect1.left = 0;
      rect1.width = 100;
      rect1.top = 0;
      rect1.height = 100;

      let rect2: SCBSessionRect = new SCBSessionRect();
      rect2.left = 50;
      rect2.width = 100;
      rect2.top = 50;

      let ntfheadsupvm: NtfHeadsUpVM = new NtfHeadsUpVM();
      let result = ntfheadsupvm.intersect(rect1, rect2);
      expect(result).assertEqual(true);
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

    it('should_return_empty_array_when_getNtfEntries_is_called', 0, () => {
      let emptycallback: EmptyCallback = new EmptyCallback();
      let result: NotificationEntry[] = emptycallback.getNtfEntries();
      expect(result).assertEqual([]);
    });

    it('should_log_warning_when_notifyNtfEntryChange_is_called', 0, () => {
      let emptycallback: EmptyCallback = new EmptyCallback();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      emptycallback.notifyNtfEntryChange([]);

      mocker.ignoreMock(logHelper, logHelper.warn);
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
  })
}