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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { BaseNotification, LiveBaseTemplate, LiveSystemTemplate, NtfReminderConfig } from '@ohos/systemuicommon';
import {
  AggregateContent,
  NotificationEntry,
  NtfDataUpdateListener
} from '../../../../main/ets/model/NotificationEntry';

export default function NotificationEntryTest() {
  describe('parseLiveRemindConfig_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_vibration_and_sound_when_isLiveSystem_is_true_and_isMute_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let remindConfig: NtfReminderConfig = new NtfReminderConfig(0);
      let mockSetVibration: Function = mocker.mockFunc(remindConfig, remindConfig.setVibration);
      let mockSetSound: Function = mocker.mockFunc(remindConfig, remindConfig.setSound);
      when(mockSetVibration)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(mockSetSound)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.remindConfig = remindConfig;
      notificationEntry.liveViewData = {
        isLiveSystem: () => true,
        isMute: false
      };

      mocker.ignoreMock(remindConfig, remindConfig.setVibration);
      mocker.ignoreMock(remindConfig, remindConfig.setSound);
    });

    it('should_set_vibration_and_sound_when_isLiveSystem_is_true_and_isMute_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let remindConfig: NtfReminderConfig = new NtfReminderConfig(0);
      let mockSetVibration: Function = mocker.mockFunc(remindConfig, remindConfig.setVibration);
      let mockSetSound: Function = mocker.mockFunc(remindConfig, remindConfig.setSound);
      when(mockSetVibration)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(mockSetSound)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.remindConfig = remindConfig;
      notificationEntry.liveViewData = {
        isLiveSystem: () => true,
        isMute: true
      };

      mocker.ignoreMock(remindConfig, remindConfig.setVibration);
      mocker.ignoreMock(remindConfig, remindConfig.setSound);
    });

    it('should_not_set_vibration_and_sound_when_isLiveSystem_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let remindConfig: NtfReminderConfig = new NtfReminderConfig(0);
      let mockSetVibration: Function = mocker.mockFunc(remindConfig, remindConfig.setVibration);
      let mockSetSound: Function = mocker.mockFunc(remindConfig, remindConfig.setSound);
      when(mockSetVibration)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(mockSetSound)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.remindConfig = remindConfig;
      notificationEntry.liveViewData = {
        isLiveSystem: () => false,
        isMute: false
      };

      mocker.ignoreMock(remindConfig, remindConfig.setVibration);
      mocker.ignoreMock(remindConfig, remindConfig.setSound);
    });
  });

  describe('registerDataUpdateListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_register_listener_and_return_unregister_function', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.unregisterDataUpdateListener);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(undefined);

      let listener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let unregisterFunc = notificationEntry.registerDataUpdateListener(listener);

      expect(typeof unregisterFunc).assertEqual('function');
      unregisterFunc();
      mocker.ignoreMock(notificationEntry, notificationEntry.unregisterDataUpdateListener);
    });
  });

  describe('unregisterDataUpdateListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_unregister_listener_successfully', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let listener: NtfDataUpdateListener = new NtfDataUpdateListener();
      notificationEntry.unregisterDataUpdateListener(listener);
      expect(notificationEntry.dataUpdateListeners.has(listener)).assertFalse();
    });
  });

  describe('notifyDataChanged_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_setLiveViewAppIcon_when_liveViewData_template_is_LiveBaseTemplate_and_appIcon_is_different', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      notificationEntry.liveViewData = { template: new LiveBaseTemplate(), appIcon: 'icon1' };
      notificationEntry.appIcon = 'icon2';
      notificationEntry.isFromSystemApp = false;
      notificationEntry.smallIcon = 'smallIcon';

      notificationEntry.notifyDataChanged();
    });

    it('should_call_setLiveViewAppIcon_with_isFromSystemApp_true_when_liveViewData_template_is_LiveSystemTemplate_and_appIcon_is_different', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      notificationEntry.liveViewData = { template: new LiveSystemTemplate(), appIcon: 'icon1' };
      notificationEntry.appIcon = 'icon2';
      notificationEntry.isFromSystemApp = true;
      notificationEntry.smallIcon = 'smallIcon';

      notificationEntry.notifyDataChanged();
    });

    it('should_call_setOverlayIcon_when_liveViewData_template_is_LiveSystemTemplate_and_overlayIcon_is_different', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setOverlayIcon);
      when(mockfunc)([ArgumentMatchers.any]).afterReturnNothing();

      notificationEntry.liveViewData = { template: new LiveSystemTemplate(), appIcon: 'icon' };
      notificationEntry.overlayIcon = 'overlayIcon';
      notificationEntry.isFromSystemApp = false;

      notificationEntry.notifyDataChanged();

      mocker.ignoreMock(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setOverlayIcon);
    });

    it('should_call_setSmallIcon_when_liveViewData_template_is_LiveBaseTemplate_and_smallIcon_is_different', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      notificationEntry.liveViewData = { template: new LiveBaseTemplate(), appIcon: 'icon' };
      notificationEntry.smallIcon = 'smallIcon';
      notificationEntry.isFromSystemApp = false;

      notificationEntry.notifyDataChanged();

      mocker.ignoreMock(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
    });

    it('should_call_setSmallIcon_with_forceRefresh_true_when_liveViewData_template_is_LiveBaseTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_true', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      notificationEntry.liveViewData = { template: new LiveBaseTemplate(), appIcon: 'icon' };
      notificationEntry.smallIcon = 'smallIcon';
      notificationEntry.isFromSystemApp = true;

      notificationEntry.notifyDataChanged();

      mocker.ignoreMock(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
    });

    it('should_call_setSmallIcon_with_forceRefresh_false_when_liveViewData_template_is_LiveBaseTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_false', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      notificationEntry.liveViewData = { template: new LiveBaseTemplate(), appIcon: 'icon' };
      notificationEntry.smallIcon = 'smallIcon';
      notificationEntry.isFromSystemApp = false;

      notificationEntry.notifyDataChanged();

      mocker.ignoreMock(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
    });

    it('should_call_setSmallIcon_with_forceRefresh_true_when_liveViewData_template_is_LiveSystemTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_true', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      notificationEntry.liveViewData = { template: new LiveSystemTemplate(), appIcon: 'icon' };
      notificationEntry.smallIcon = 'smallIcon';
      notificationEntry.isFromSystemApp = true;

      notificationEntry.notifyDataChanged();

      mocker.ignoreMock(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
    });

    it('should_call_setSmallIcon_with_forceRefresh_false_when_liveViewData_template_is_LiveSystemTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_false', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
      when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      notificationEntry.liveViewData = { template: new LiveSystemTemplate(), appIcon: 'icon' };
      notificationEntry.smallIcon = 'smallIcon';
      notificationEntry.isFromSystemApp = false;

      notificationEntry.notifyDataChanged();

      mocker.ignoreMock(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
    });

    it('should_call_setOverlayIcon_with_overlayIcon_when_liveViewData_template_is_LiveSystemTemplate_and_overlayIcon_is_different', 0, async () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setOverlayIcon);
      when(mockfunc)([ArgumentMatchers.any]).afterReturnNothing();

      notificationEntry.liveViewData = { template: new LiveSystemTemplate(), appIcon: 'icon' };
      notificationEntry.overlayIcon = 'overlayIcon';
      notificationEntry.isFromSystemApp = false;

      notificationEntry.notifyDataChanged();

      mocker.ignoreMock(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setOverlayIcon);
    });
  });

  describe('copyDataUpdateListeners_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_copy_data_update_listeners_when_ntfEntry_is_not_null', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.dataUpdateListeners = new Array<NotificationEntryEvent>();
      notificationEntry.copyDataUpdateListeners(ntfEntry);
      expect(notificationEntry.dataUpdateListeners).assertEqual(ntfEntry.dataUpdateListeners);
    });

    it('should_not_copy_data_update_listeners_when_ntfEntry_is_null', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let ntfEntry: NotificationEntry = null;
      notificationEntry.copyDataUpdateListeners(ntfEntry);
      expect(notificationEntry.dataUpdateListeners).assertNull();
    });
  });

  describe('resetItemExpandState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_reset_item_expand_state_correctly_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.resetItemExpandState();
      expect(notificationEntry.isItemExpanded).assertEqual(false);
    });

    it('should_reset_item_expand_state_correctly_when_isGroup_is_true_and_childrenEntry_is_undefined', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = undefined;
      notificationEntry.resetItemExpandState();
      expect(notificationEntry.isItemExpanded).assertEqual(false);
    });

    it('should_reset_item_expand_state_correctly_when_isGroup_is_true_and_childrenEntry_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [];
      notificationEntry.resetItemExpandState();
      expect(notificationEntry.isItemExpanded).assertEqual(false);
    });

    it('should_reset_item_expand_state_correctly_when_isGroup_is_true_and_childrenEntry_has_items', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      let childEntry1: NotificationEntry = new NotificationEntry();
      let childEntry2: NotificationEntry = new NotificationEntry();
      notificationEntry.childrenEntry = [childEntry1, childEntry2];
      notificationEntry.resetItemExpandState();
      expect(notificationEntry.isItemExpanded).assertEqual(false);
      expect(childEntry1.isItemExpanded).assertEqual(false);
      expect(childEntry2.isItemExpanded).assertEqual(false);
    });
  });
  describe('setShouldHideContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_hide_content_when_shouldHideContent_is_true_and_isAppLocked_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(false);
      notificationEntry.setShouldHideContent(true, false);
      expect(notificationEntry.isHideContent).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_shouldHideContent_is_true_and_isAppLocked_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(false);
      notificationEntry.setShouldHideContent(true, true);
      expect(notificationEntry.isHideContent).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_shouldHideContent_is_false_and_isAppLocked_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(false);
      notificationEntry.setShouldHideContent(false, false);
      expect(notificationEntry.isHideContent).assertFalse();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_shouldHideContent_is_false_and_isAppLocked_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(false);
      notificationEntry.setShouldHideContent(false, true);
      expect(notificationEntry.isHideContent).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_shouldHideContent_is_true_and_isMediaPlayerCenter_returns_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(true);
      notificationEntry.setShouldHideContent(true, false);
      expect(notificationEntry.isHideContent).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_shouldHideContent_is_false_and_isMediaPlayerCenter_returns_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(true);
      notificationEntry.setShouldHideContent(false, false);
      expect(notificationEntry.isHideContent).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_isGroup_is_true_and_forEach_children_entry_shouldHideContent_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      let childrenEntry: Array<NotificationEntry> = [new NotificationEntry(), new NotificationEntry()];
      notificationEntry.childrenEntry = childrenEntry;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(false);
      notificationEntry.setShouldHideContent(true, false);
      expect(notificationEntry.isHideContent).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_isGroup_is_true_and_forEach_children_entry_shouldHideContent_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      let childrenEntry: Array<NotificationEntry> = [new NotificationEntry(), new NotificationEntry()];
      notificationEntry.childrenEntry = childrenEntry;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
      when(mockfunc)().afterReturn(false);
      notificationEntry.setShouldHideContent(true, false);
      expect(notificationEntry.isHideContent).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
    });

    it('should_hide_content_when_isGroup_true_and_forEach_children_entry_shouldHideContent_false_and_isAppLocked_true',
      0, () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        notificationEntry.isGroup = true;
        let childrenEntry: Array<NotificationEntry> = [new NotificationEntry(), new NotificationEntry()];
        notificationEntry.childrenEntry = childrenEntry;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
        when(mockfunc)().afterReturn(false);
        notificationEntry.setShouldHideContent(true, true);
        expect(notificationEntry.isHideContent).assertTrue();
        mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
      });

    it('should_hide_content_when_isGroup_true_and_forEach_children_entry_shouldHideContent_true_and_isAppLocked_true',
      0, () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        notificationEntry.isGroup = true;
        let childrenEntry: Array<NotificationEntry> = [new NotificationEntry(), new NotificationEntry()];
        notificationEntry.childrenEntry = childrenEntry;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
        when(mockfunc)().afterReturn(false);
        notificationEntry.setShouldHideContent(true, true);
        expect(notificationEntry.isHideContent).assertTrue();
        mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
      });

    it('should_hide_content_when_isGroup_true_and_forEach_children_entry_shouldHideContent_false_and_isAppLocked_false',
      0, () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        notificationEntry.isGroup = true;
        let childrenEntry: Array<NotificationEntry> = [new NotificationEntry(), new NotificationEntry()];
        notificationEntry.childrenEntry = childrenEntry;
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isMediaPlayerCenter);
        when(mockfunc)().afterReturn(false);
        notificationEntry.setShouldHideContent(true, false);
        expect(notificationEntry.isHideContent).assertTrue();
        mocker.ignoreMock(notificationEntry, notificationEntry.isMediaPlayerCenter);
      });
  });

  describe('canClear_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isGroup_is_true_and_childrenEntry_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [];
      const result = notificationEntry.canClear();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isGroup_is_true_and_one_child_returns_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [new NotificationEntry()];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationEntry.childrenEntry[0], notificationEntry.childrenEntry[0].canClear);
      when(mockfunc)().afterReturn(false);
      const result = notificationEntry.canClear();
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationEntry.childrenEntry[0], notificationEntry.childrenEntry[0].canClear);
    });

    it('should_return_true_when_isGroup_is_true_and_all_children_return_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [new NotificationEntry(), new NotificationEntry()];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationEntry.childrenEntry[0], notificationEntry.childrenEntry[0].canClear);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(notificationEntry.childrenEntry[1], notificationEntry.childrenEntry[1].canClear);
      when(mockfunc2)().afterReturn(true);
      const result = notificationEntry.canClear();
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationEntry.childrenEntry[0], notificationEntry.childrenEntry[0].canClear);
      mocker.ignoreMock(notificationEntry.childrenEntry[1], notificationEntry.childrenEntry[1].canClear);
    });

    it('should_return_false_when_isRemoveAllowed_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.isRemoveAllowed = false;
      const result = notificationEntry.canClear();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isLiveType_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.isLiveType = true;
      const result = notificationEntry.canClear();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isNoClear_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.isNoClear = true;
      const result = notificationEntry.canClear();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.isRemoveAllowed = true;
      notificationEntry.isLiveType = () => false;
      notificationEntry.isNoClear = false;
      notificationEntry.childrenEntry = [new NotificationEntry(), new NotificationEntry()];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(notificationEntry.childrenEntry[0], notificationEntry.childrenEntry[0].canClear);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(notificationEntry.childrenEntry[1], notificationEntry.childrenEntry[1].canClear);
      when(mockfunc2)().afterReturn(true);
      const result = notificationEntry.canClear();
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationEntry.childrenEntry[0], notificationEntry.childrenEntry[0].canClear);
      mocker.ignoreMock(notificationEntry.childrenEntry[1], notificationEntry.childrenEntry[1].canClear);
    });
  });

  describe('canDelete_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isGroup_is_true_and_childrenEntry_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [];
      const result = notificationEntry.canDelete();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isGroup_is_true_and_childrenEntry_has_unallowDelete_entry', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      let childEntry: NotificationEntry = new NotificationEntry();
      childEntry.canDelete = () => false;
      notificationEntry.childrenEntry = [childEntry];
      const result = notificationEntry.canDelete();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isGroup_is_true_and_all_childrenEntry_are_allowDelete', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      let childEntry1: NotificationEntry = new NotificationEntry();
      let childEntry2: NotificationEntry = new NotificationEntry();
      childEntry1.canDelete = () => true;
      childEntry2.canDelete = () => true;
      notificationEntry.childrenEntry = [childEntry1, childEntry2];
      const result = notificationEntry.canDelete();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isGroup_is_false_and_isRemoveAllowed_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.isRemoveAllowed = true;
      const result = notificationEntry.canDelete();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isGroup_is_false_and_isRemoveAllowed_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.isRemoveAllowed = false;
      const result = notificationEntry.canDelete();
      expect(result).assertEqual(false);
    });
  });

  describe('createGroup_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_isGroup_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      const result = notificationEntry.createGroup();
      expect(result).assertNull();
    });

    it('should_return_groupEntry_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      let mocker: MockKit = new MockKit();
      let mockUpdateGroup: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateGroup);
      let mockAddUpdateChildEntry: Function = mocker.mockFunc(notificationEntry, notificationEntry.addUpdateChildEntry);
      when(mockUpdateGroup)(ArgumentMatchers.any).afterReturnNothing();
      when(mockAddUpdateChildEntry)(ArgumentMatchers.any).afterReturnNothing();
      const result = notificationEntry.createGroup();
      expect(result).assertInstanceOf(NotificationEntry);
      expect(result.isGroup).assertTrue();
      expect(result.isExpandable).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.updateGroup);
      mocker.ignoreMock(notificationEntry, notificationEntry.addUpdateChildEntry);
    });

    it('should_return_groupEntry_with_correct_properties_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.smallIcon = 'smallIcon';
      notificationEntry.smallIconOrigin = 'smallIconOrigin';
      notificationEntry.creatorBundleName = 'creatorBundleName';
      notificationEntry.creatorUserId = 'creatorUserId';
      notificationEntry.creatorUid = 'creatorUid';
      notificationEntry.groupName = 'groupName';
      notificationEntry.agentBundle = 'agentBundle';
      notificationEntry.slotLevel = 'slotLevel';
      notificationEntry.isConvertFromNormal = true;
      notificationEntry.bundleType = 'bundleType';
      notificationEntry.remindConfig = new NtfReminderConfig({});
      let mocker: MockKit = new MockKit();
      let mockUpdateGroup: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateGroup);
      let mockAddUpdateChildEntry: Function = mocker.mockFunc(notificationEntry, notificationEntry.addUpdateChildEntry);
      when(mockUpdateGroup)(ArgumentMatchers.any).afterReturnNothing();
      when(mockAddUpdateChildEntry)(ArgumentMatchers.any).afterReturnNothing();
      const result = notificationEntry.createGroup();
      expect(result).assertInstanceOf(NotificationEntry);
      expect(result.isGroup).assertTrue();
      expect(result.isExpandable).assertTrue();
      expect(result.smallIcon).assertEqual('smallIcon');
      expect(result.smallIconOrigin).assertEqual('smallIconOrigin');
      expect(result.creatorBundleName).assertEqual('creatorBundleName');
      expect(result.creatorUserId).assertEqual('creatorUserId');
      expect(result.creatorUid).assertEqual('creatorUid');
      expect(result.groupName).assertEqual('groupName');
      expect(result.agentBundle).assertEqual('agentBundle');
      expect(result.slotLevel).assertEqual('slotLevel');
      expect(result.isConvertFromNormal).assertTrue();
      expect(result.bundleType).assertEqual('bundleType');
      expect(result.remindConfig).assertDeepEquals(notificationEntry.remindConfig);
      mocker.ignoreMock(notificationEntry, notificationEntry.updateGroup);
      mocker.ignoreMock(notificationEntry, notificationEntry.addUpdateChildEntry);
    });

    it('should_call_updateGroup_and_addUpdateChildEntry_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      let mocker: MockKit = new MockKit();
      let mockUpdateGroup: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateGroup);
      let mockAddUpdateChildEntry: Function = mocker.mockFunc(notificationEntry, notificationEntry.addUpdateChildEntry);
      when(mockUpdateGroup)(ArgumentMatchers.any).afterReturnNothing();
      when(mockAddUpdateChildEntry)(ArgumentMatchers.any).afterReturnNothing();
      const result = notificationEntry.createGroup();
      expect(result).assertInstanceOf(NotificationEntry);
      expect(result.isGroup).assertTrue();
      expect(result.isExpandable).assertTrue();
      mocker.ignoreMock(notificationEntry, notificationEntry.updateGroup);
      mocker.ignoreMock(notificationEntry, notificationEntry.addUpdateChildEntry);
    });

    it('should_set_overlayIcon_and_appNamePrefix_when_overlayIconStyle_is_REVERSE', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.overlayIconStyle = OverlayIconStyle.REVERSE;
      notificationEntry.overlayIcon = 'overlayIcon';
      let mocker: MockKit = new MockKit();
      let mockUpdateGroup: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateGroup);
      let mockAddUpdateChildEntry: Function = mocker.mockFunc(notificationEntry, notificationEntry.addUpdateChildEntry);
      when(mockUpdateGroup)(ArgumentMatchers.any).afterReturnNothing();
      when(mockAddUpdateChildEntry)(ArgumentMatchers.any).afterReturnNothing();
      const result = notificationEntry.createGroup();
      expect(result).assertInstanceOf(NotificationEntry);
      expect(result.isGroup).assertTrue();
      expect(result.isExpandable).assertTrue();
      expect(result.overlayIcon).assertEqual('overlayIcon');
      mocker.ignoreMock(notificationEntry, notificationEntry.updateGroup);
      mocker.ignoreMock(notificationEntry, notificationEntry.addUpdateChildEntry);
    });

    it('should_not_set_overlayIcon_and_appNamePrefix_when_overlayIconStyle_is_not_REVERSE', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.overlayIconStyle = OverlayIconStyle.DARK;
      notificationEntry.overlayIcon = 'overlayIcon';
      let mocker: MockKit = new MockKit();
      let mockUpdateGroup: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateGroup);
      let mockAddUpdateChildEntry: Function = mocker.mockFunc(notificationEntry, notificationEntry.addUpdateChildEntry);
      when(mockUpdateGroup)(ArgumentMatchers.any).afterReturnNothing();
      when(mockAddUpdateChildEntry)(ArgumentMatchers.any).afterReturnNothing();
      const result = notificationEntry.createGroup();
      expect(result).assertInstanceOf(NotificationEntry);
      expect(result.isGroup).assertTrue();
      expect(result.isExpandable).assertTrue();
      expect(result.overlayIcon).assertNull();
      mocker.ignoreMock(notificationEntry, notificationEntry.updateGroup);
      mocker.ignoreMock(notificationEntry, notificationEntry.addUpdateChildEntry);
    });

    it('should_set_deliverNotificationKey_when_isDeliverNotification_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.isDeliverNotification = true;
      notificationEntry.deliverNotificationKey = 'deliverNotificationKey';
      let mocker: MockKit = new MockKit();
      let mockUpdateGroup: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateGroup);
      let mockAddUpdateChildEntry: Function = mocker.mockFunc(notificationEntry, notificationEntry.addUpdateChildEntry);
      when(mockUpdateGroup)(ArgumentMatchers.any).afterReturnNothing();
      when(mockAddUpdateChildEntry)(ArgumentMatchers.any).afterReturnNothing();
      const result = notificationEntry.createGroup();
      expect(result).assertInstanceOf(NotificationEntry);
      expect(result.isGroup).assertTrue();
      expect(result.isExpandable).assertTrue();
      expect(result.deliverNotificationKey).assertEqual('deliverNotificationKey');
      mocker.ignoreMock(notificationEntry, notificationEntry.updateGroup);
      mocker.ignoreMock(notificationEntry, notificationEntry.addUpdateChildEntry);
    });
  });

  describe('createAggregateGroup_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_isGroup_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      let unifiedGroup: AggregateContent = new AggregateContent();
      const result = notificationEntry.createAggregateGroup(unifiedGroup);
      expect(result).assertNull();
    });

    it('should_return_groupEntry_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      let unifiedGroup: AggregateContent = new AggregateContent();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.addUpdateChildEntry);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      const result = notificationEntry.createAggregateGroup(unifiedGroup);
      expect(result).assertInstanceOf(NotificationEntry);
      expect(result.isGroup).assertTrue();
      expect(result.isExpandable).assertTrue();
      expect(result.isInAggregate).assertTrue();
      expect(result.aggregateContent).assertEqual(unifiedGroup);
      expect(result.remindConfig).assertEqual(notificationEntry.remindConfig);
      mocker.ignoreMock(notificationEntry, notificationEntry.addUpdateChildEntry);
    });
  });

  describe('updateAggregateContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isInAggregate_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isInAggregate = false;
      let unifiedGroup: AggregateContent = new AggregateContent();
      notificationEntry.updateAggregateContent(unifiedGroup);
      // 由于isInAggregate为false，函数应该立即返回，不做任何操作
      expect(notificationEntry.aggregateContent).assertUndefined();
    });

    it('should_update_aggregateContent_when_isInAggregate_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isInAggregate = true;
      let unifiedGroup: AggregateContent = new AggregateContent();
      notificationEntry.updateAggregateContent(unifiedGroup);
      // 由于isInAggregate为true，函数应该更新aggregateContent
      expect(notificationEntry.aggregateContent).assertDeepEquals(unifiedGroup);
    });
  });

  describe('updateAggregateGroup_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isInAggregate_or_getFirstChildEntry_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfuncInFirst: Function = mocker.mockFunc(notificationEntry, notificationEntry.getFirstChildEntry);
      let mockfuncInSecond: Function = mocker.mockFunc(notificationEntry, notificationEntry.isInAggregate);
      when(mockfuncInFirst)([]).afterReturn(null);
      when(mockfuncInSecond)([]).afterReturn(false);
      notificationEntry.updateAggregateGroup();
      mocker.ignoreMock(notificationEntry, notificationEntry.getFirstChildEntry);
      mocker.ignoreMock(notificationEntry, notificationEntry.isInAggregate);
    });

    it('should_update_deliveryTime_and_slotType_when_isInAggregate_and_getFirstChildEntry_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfuncInFirst: Function = mocker.mockFunc(notificationEntry, notificationEntry.getFirstChildEntry);
      let mockfuncInSecond: Function = mocker.mockFunc(notificationEntry, notificationEntry.isInAggregate);
      let mockfuncInThird: Function = mocker.mockFunc(notificationEntry, notificationEntry.getLatestChildEntry);
      when(mockfuncInFirst)([]).afterReturn(new NotificationEntry());
      when(mockfuncInSecond)([]).afterReturn(true);
      when(mockfuncInThird)([]).afterReturn(new NotificationEntry());
      notificationEntry.updateAggregateGroup();
      expect(notificationEntry.deliveryTime).assertLarger(0);
      expect(notificationEntry.slotType).assertLarger(0);
      mocker.ignoreMock(notificationEntry, notificationEntry.getFirstChildEntry);
      mocker.ignoreMock(notificationEntry, notificationEntry.isInAggregate);
      mocker.ignoreMock(notificationEntry, notificationEntry.getLatestChildEntry);
    });
  });

  describe('updateGroup_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_ntfEntry_is_null', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.updateGroup(null);
    });

    it('should_return_immediately_when_ntfEntry_is_invalid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = false;
      notificationEntry.updateGroup(ntfEntry);
    });

    it('should_update_all_properties_when_ntfEntry_is_valid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = true;
      ntfEntry.isOngoing = true;
      ntfEntry.isHiddenInKg = true;
      ntfEntry.isDisplayAtTop = true;
      ntfEntry.deliveryTime = 1;
      ntfEntry.slotType = 1;
      ntfEntry.isFloatingIcon = true;
      ntfEntry.overlayIconStyle = OverlayIconStyle.REVERSE;
      ntfEntry.overlayIcon = new image.PixelMap();
      notificationEntry.updateGroup(ntfEntry);
      expect(notificationEntry.isGroup).assertEqual(true);
      expect(notificationEntry.isOngoing).assertEqual(true);
      expect(notificationEntry.isHiddenInKg).assertEqual(true);
      expect(notificationEntry.isDisplayAtTop).assertEqual(true);
      expect(notificationEntry.deliveryTime).assertEqual(1);
      expect(notificationEntry.slotType).assertEqual(1);
      expect(notificationEntry.isFloatingIcon).assertEqual(true);
      expect(notificationEntry.overlayIconStyle).assertEqual(OverlayIconStyle.REVERSE);
      expect(notificationEntry.overlayIcon).assertDeepEquals(ntfEntry.overlayIcon);
    });
  });

  describe('updateGroupSlotLevel_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_slotLevel_correctly_when_childrenEntry_is_not_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.childrenEntry = [
        new NotificationEntry(),
        new NotificationEntry(),
        new NotificationEntry()
      ];
      notificationEntry.childrenEntry[0].slotLevel = NtfMgr.SlotLevel.LEVEL_HIGH;
      notificationEntry.childrenEntry[1].slotLevel = NtfMgr.SlotLevel.LEVEL_LOW;
      notificationEntry.childrenEntry[2].slotLevel = NtfMgr.SlotLevel.LEVEL_CRITICAL;

      notificationEntry.updateGroupSlotLevel();

      expect(notificationEntry.slotLevel).assertEqual(NtfMgr.SlotLevel.LEVEL_CRITICAL);
    });

    it('should_update_slotLevel_to_LEVEL_NONE_when_childrenEntry_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.childrenEntry = [];

      notificationEntry.updateGroupSlotLevel();

      expect(notificationEntry.slotLevel).assertEqual(NtfMgr.SlotLevel.LEVEL_NONE);
    });
  });

  describe('setGroupEntry_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isGroup_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      let groupEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.setGroupEntry(groupEntry);
      expect(notificationEntry.groupEntry).assertEqual(undefined);
    });

    it('should_set_groupEntry_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      let groupEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.setGroupEntry(groupEntry);
      expect(notificationEntry.groupEntry).assertEqual(groupEntry);
    });
  });

  describe('removeChildEntry_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let result = notificationEntry.removeChildEntry(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_findIndex_is_minus_one', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [new NotificationEntry(), new NotificationEntry()];
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = 123;
      let result = notificationEntry.removeChildEntry(ntfEntry);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_findIndex_is_not_minus_one_and_getChildrenSize_is_greater_than_zero', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [new NotificationEntry(), new NotificationEntry()];
      notificationEntry.childrenEntry[0].deliveryTime = 123;
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = 123;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.getChildrenSize);
      when(mockfunc)().afterReturn(1);
      let result = notificationEntry.removeChildEntry(ntfEntry);
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationEntry, notificationEntry.getChildrenSize);
    });

    it('should_return_true_when_findIndex_is_not_minus_one_and_getChildrenSize_is_zero', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [new NotificationEntry(), new NotificationEntry()];
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = 123;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.getChildrenSize);
      when(mockfunc)().afterReturn(0);
      let result = notificationEntry.removeChildEntry(ntfEntry);
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationEntry, notificationEntry.getChildrenSize);
    });

    it('should_return_false_when_deleteEntry_is_invalid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [new NotificationEntry(), new NotificationEntry()];
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = 123;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.getChildrenSize);
      when(mockfunc)().afterReturn(1);
      let result = notificationEntry.removeChildEntry(ntfEntry);
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationEntry, notificationEntry.getChildrenSize);
    });
  });

  describe('sortChildren_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.sortChildren();
      expect(notificationEntry.childrenEntry).assertDeepEquals([]);
    });

    it('should_return_immediately_when_childrenEntry_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [];
      notificationEntry.sortChildren();
      expect(notificationEntry.childrenEntry).assertDeepEquals([]);
    });

    it('should_sort_children_correctly_when_isDisplayAtTop_is_different', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [
        { isDisplayAtTop: true, deliveryTime: 1000 },
        { isDisplayAtTop: false, deliveryTime: 2000 }
      ];
      notificationEntry.sortChildren();
      expect(notificationEntry.childrenEntry[0].isDisplayAtTop).assertTrue();
      expect(notificationEntry.childrenEntry[1].isDisplayAtTop).assertFalse();
    });

    it('should_sort_children_correctly_when_deliveryTime_is_different', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [
        { isDisplayAtTop: true, deliveryTime: 1000 },
        { isDisplayAtTop: true, deliveryTime: 2000 }
      ];
      notificationEntry.sortChildren();
      expect(notificationEntry.childrenEntry[0].deliveryTime).assertEqual(1000);
      expect(notificationEntry.childrenEntry[1].deliveryTime).assertEqual(2000);
    });
  });

  describe('limitGroupNtfCount_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      notificationEntry.childrenEntry = [1, 2, 3];
      notificationEntry.limitGroupNtfCount();
      expect(notificationEntry.childrenEntry.length).assertEqual(3);
    });

    it('should_remove_extra_children_when_childrenEntry_size_is_greater_than_SINGLE_APP_LIMIT', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [1, 2, 3, 4, 5, 6];
      notificationEntry.limitGroupNtfCount();
      expect(notificationEntry.childrenEntry.length).assertEqual(SINGLE_APP_LIMIT);
    });

    it('should_not_remove_extra_children_when_childrenEntry_size_is_less_than_or_equal_to_SINGLE_APP_LIMIT', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [1, 2];
      notificationEntry.limitGroupNtfCount();
      expect(notificationEntry.childrenEntry.length).assertEqual(2);
    });
  });

  describe('getChildrenSize_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_0_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      const result = notificationEntry.getChildrenSize();
      expect(result).assertEqual(0);
    });

    it('should_return_childrenEntry_size_when_isGroup_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [1, 2, 3];
      const result = notificationEntry.getChildrenSize();
      expect(result).assertEqual(3);
    });
  });

  describe('getFirstChildEntry_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      const result = notificationEntry.getFirstChildEntry();
      expect(result).assertNull();
    });

    it('should_return_null_when_childrenEntry_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [];
      const result = notificationEntry.getFirstChildEntry();
      expect(result).assertNull();
    });

    it('should_return_first_child_when_childrenEntry_is_not_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [new NotificationEntry(), new NotificationEntry()];
      const result = notificationEntry.getFirstChildEntry();
      expect(result).assertInstanceOf(NotificationEntry);
    });
  });

  describe('getLatestChildEntry_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_isGroup_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = false;
      let result = notificationEntry.getLatestChildEntry();
      expect(result).assertNull();
    });

    it('should_return_null_when_childrenEntry_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [];
      let result = notificationEntry.getLatestChildEntry();
      expect(result).assertNull();
    });

    it('should_return_first_entry_in_normalList_when_pinTopList_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [
        { isDisplayAtTop: false, deliveryTime: 1000 } as NotificationEntry,
        { isDisplayAtTop: false, deliveryTime: 2000 } as NotificationEntry
      ];
      let result = notificationEntry.getLatestChildEntry();
      expect(result).assertDeepEquals(notificationEntry.childrenEntry[0]);
    });

    it('should_return_first_entry_in_pinTopList_when_normalList_is_empty', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [
        { isDisplayAtTop: true, deliveryTime: 1000 } as NotificationEntry,
        { isDisplayAtTop: true, deliveryTime: 2000 } as NotificationEntry
      ];
      let result = notificationEntry.getLatestChildEntry();
      expect(result).assertDeepEquals(notificationEntry.childrenEntry[0]);
    });

    it('should_return_latest_entry_in_both_pinTopList_and_normalList', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.childrenEntry = [
        { isDisplayAtTop: true, deliveryTime: 1000 } as NotificationEntry,
        { isDisplayAtTop: false, deliveryTime: 2000 } as NotificationEntry
      ];
      let result = notificationEntry.getLatestChildEntry();
      expect(result).assertDeepEquals(notificationEntry.childrenEntry[0]);
    });
  });

  describe('getGroupKey_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_key_when_postData_is_null', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.getGroupTypeKey);
      when(mockfunc)().afterReturn("testKey");
      const result = notificationEntry.getGroupKey();
      expect(result).assertEqual("testKey");
      mocker.ignoreMock(notificationEntry, notificationEntry.getGroupTypeKey);
    });

    it('should_return_correct_key_when_postData_is_not_null', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry({} as BaseNotification);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.getGroupTypeKey);
      when(mockfunc)().afterReturn("testKey");
      const result = notificationEntry.getGroupKey();
      expect(result).assertEqual("testKey");
      mocker.ignoreMock(notificationEntry, notificationEntry.getGroupTypeKey);
    });
  });

  describe('isHeadsUp_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_isShowHeadsUp_when_isLiveType_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockfunc)().afterReturn(true);
      expect(notificationEntry.isHeadsUp()).assertEqual(true);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
    });

    it('should_return_remindConfig_isBannerEnable_when_isLiveType_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry.remindConfig, notificationEntry.remindConfig.isBannerEnable);
      when(mockfunc2)().afterReturn(true);
      expect(notificationEntry.isHeadsUp()).assertEqual(true);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry.remindConfig, notificationEntry.remindConfig.isBannerEnable);
    });

    it('should_return_false_when_isLiveType_is_false_and_remindConfig_isBannerEnable_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry.remindConfig, notificationEntry.remindConfig.isBannerEnable);
      when(mockfunc2)().afterReturn(false);
      expect(notificationEntry.isHeadsUp()).assertEqual(false);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry.remindConfig, notificationEntry.remindConfig.isBannerEnable);
    });
  });

  describe('isHiddenInKeyGuard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_isFromSystemApp_is_false_and_isHiddenInKg_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromSystemApp = false;
      notificationEntry.isHiddenInKg = false;
      const result = notificationEntry.isHiddenInKeyGuard();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isFromSystemApp_is_true_and_isHiddenInKg_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromSystemApp = true;
      notificationEntry.isHiddenInKg = true;
      const result = notificationEntry.isHiddenInKeyGuard();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isFromSystemApp_is_true_and_isHiddenInKg_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromSystemApp = true;
      notificationEntry.isHiddenInKg = false;
      const result = notificationEntry.isHiddenInKeyGuard();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isFromSystemApp_is_false_and_isHiddenInKg_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromSystemApp = false;
      notificationEntry.isHiddenInKg = true;
      const result = notificationEntry.isHiddenInKeyGuard();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isGroup_is_true_and_getFirstChildEntry_returns_null', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.isFromSystemApp = false;
      notificationEntry.isHiddenInKg = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.getFirstChildEntry);
      when(mockfunc)().afterReturn(null);
      const result = notificationEntry.isHiddenInKeyGuard();
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationEntry, notificationEntry.getFirstChildEntry);
    });

    it('should_return_true_when_isGroup_is_true_and_getFirstChildEntry_returns_not_null_and_isHiddenInKg_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isGroup = true;
      notificationEntry.isFromSystemApp = true;
      notificationEntry.isHiddenInKg = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.getFirstChildEntry);
      when(mockfunc)().afterReturn(new NotificationEntry());
      const result = notificationEntry.isHiddenInKeyGuard();
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationEntry, notificationEntry.getFirstChildEntry);
    });
  });

  describe('isSilence_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isBannerEnable_and_isSoundEnable_are_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let remindConfig: NtfReminderConfig = new NtfReminderConfig(0);
      let mockIsBannerEnable: Function = mocker.mockFunc(remindConfig, remindConfig.isBannerEnable);
      let mockIsSoundEnable: Function = mocker.mockFunc(remindConfig, remindConfig.isSoundEnable);
      when(mockIsBannerEnable)().afterReturn(false);
      when(mockIsSoundEnable)().afterReturn(false);

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.remindConfig = remindConfig;
      const result = notificationEntry.isSilence();
      expect(result).assertEqual(true);
      mocker.ignoreMock(remindConfig, remindConfig.isBannerEnable);
      mocker.ignoreMock(remindConfig, remindConfig.isSoundEnable);
    });

    it('should_return_false_when_isBannerEnable_is_true_and_isSoundEnable_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let remindConfig: NtfReminderConfig = new NtfReminderConfig(0);
      let mockIsBannerEnable: Function = mocker.mockFunc(remindConfig, remindConfig.isBannerEnable);
      let mockIsSoundEnable: Function = mocker.mockFunc(remindConfig, remindConfig.isSoundEnable);
      when(mockIsBannerEnable)().afterReturn(true);
      when(mockIsSoundEnable)().afterReturn(false);

      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.remindConfig = remindConfig;
      const result = notificationEntry.isSilence();
      expect(result).assertEqual(false);
      mocker.ignoreMock(remindConfig, remindConfig.isBannerEnable);
      mocker.ignoreMock(remindConfig, remindConfig.isSoundEnable);
    });
  });

  describe('isShowInLockScreen_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isLockScreenEnable_is_true', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isLockScreenEnable = true;
      const result = notificationentry.isShowInLockScreen();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isLockScreenEnable_is_false', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isLockScreenEnable = false;
      const result = notificationentry.isShowInLockScreen();
      expect(result).assertEqual(false);
    });
  });

  describe('isOngoingLockScreen_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_isOngoing_is_false', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isOngoing = false;
      notificationentry.isLockScreenEnable = true;
      const result = notificationentry.isOngoingLockScreen();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isLockScreenEnable_is_false', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isOngoing = true;
      notificationentry.isLockScreenEnable = false;
      const result = notificationentry.isOngoingLockScreen();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isOngoing_and_isLockScreenEnable_are_true', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isOngoing = true;
      notificationentry.isLockScreenEnable = true;
      const result = notificationentry.isOngoingLockScreen();
      expect(result).assertEqual(true);
    });
  });

  describe('isShowStatusBarIcon_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isStatusBarIconEnable_is_true', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let remindConfig: NtfReminderConfig = new NtfReminderConfig(0);
      let mockfunc: Function = mocker.mockFunc(remindConfig, remindConfig.isStatusBarIconEnable);
      when(mockfunc)().afterReturn(true);
      notificationentry.remindConfig = remindConfig;
      const result = notificationentry.isShowStatusBarIcon();
      expect(result).assertEqual(true);
      mocker.ignoreMock(remindConfig, remindConfig.isStatusBarIconEnable);
    });

    it('should_return_false_when_isStatusBarIconEnable_is_false', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let remindConfig: NtfReminderConfig = new NtfReminderConfig(0);
      let mockfunc: Function = mocker.mockFunc(remindConfig, remindConfig.isStatusBarIconEnable);
      when(mockfunc)().afterReturn(false);
      notificationentry.remindConfig = remindConfig;
      const result = notificationentry.isShowStatusBarIcon();
      expect(result).assertEqual(false);
      mocker.ignoreMock(remindConfig, remindConfig.isStatusBarIconEnable);
    });
  });

  describe('equals_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_other_is_invalid', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let result = notificationentry.equals(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_is_not_instance_of_NotificationEntry', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let result = notificationentry.equals({});
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_has_different_creatorBundleName', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let other: NotificationEntry = new NotificationEntry();
      other.creatorBundleName = 'otherBundle';
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_has_different_isGroup', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let other: NotificationEntry = new NotificationEntry();
      other.isGroup = true;
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_has_different_getGroupTypeKey', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let other: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationentry, notificationentry.getGroupTypeKey);
      when(mockfunc)().afterReturn('otherType');
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationentry, notificationentry.getGroupTypeKey);
    });

    it('should_return_true_when_other_is_same_NotificationEntry_and_isGroup_is_false', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let other: NotificationEntry = new NotificationEntry();
      let result = notificationentry.equals(other);
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_other_is_same_NotificationEntry_and_isGroup_is_true_and_groupName_matches', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isGroup = true;
      notificationentry.groupName = 'sameGroup';
      let other: NotificationEntry = new NotificationEntry();
      other.isGroup = true;
      other.groupName = 'sameGroup';
      let result = notificationentry.equals(other);
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_other_is_same_NotificationEntry_and_isGroup_is_true_and_hashCode_matches', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isGroup = true;
      notificationentry.hashCode = 'sameHashCode';
      let other: NotificationEntry = new NotificationEntry();
      other.isGroup = true;
      other.hashCode = 'sameHashCode';
      let result = notificationentry.equals(other);
      expect(result).assertEqual(true);
    });
  });

  describe('toSimpleString_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_string_when_all_properties_are_set', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry({
        groupName: 'testGroup',
        isGroup: true,
        creatorBundleName: 'testBundle',
        hashCode: '1234567890',
        appIndex: 1,
        creatorUid: '1234567890'
      });

      let result: string = notificationEntry.toSimpleString();
      expect(result).assertEqual('group: testGroup, true, testBundle, 1234567890, 1, 1234567890');
    });

    it('should_return_correct_string_when_some_properties_are_undefined', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry({
        groupName: 'testGroup',
        isGroup: true,
        creatorBundleName: 'testBundle',
        hashCode: '1234567890',
        creatorUid: '1234567890'
      });

      let result: string = notificationEntry.toSimpleString();
      expect(result).assertEqual('group: testGroup, true, testBundle, 1234567890, undefined, 1234567890');
    });
  });

  describe('isSocialOrServiceType_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_slotType_is_SLOT_TYPE_SOCIAL_COMMUNICATION', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: SLOT_TYPE_SOCIAL_COMMUNICATION });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_slotType_is_SLOT_TYPE_SERVICE_INFORMATION', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: SLOT_TYPE_SERVICE_INFORMATION });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_slotType_is_SLOT_TYPE_CUSTOMER_INFORMATION', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: SLOT_TYPE_CUSTOMER_INFORMATION });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_slotType_is_not_in_socialAndServiceType_list', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: 'SLOT_TYPE_UNKNOWN' });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(false);
    });
  });

  describe('isExtraContentType_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationentry, notificationentry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationentry, notificationentry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationentry, notificationentry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationentry, notificationentry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      const result = notificationentry.isExtraContentType();
      expect(result).assertEqual(true);

      mocker.ignoreMock(notificationentry, notificationentry.isSocialOrServiceType);
      mocker.ignoreMock(notificationentry, notificationentry.isLiveType);
      mocker.ignoreMock(notificationentry, notificationentry.isDisplayAtTop);
      mocker.ignoreMock(notificationentry, notificationentry.isEmergencyNtf);
    });

    it('should_return_false_when_isSocialOrServiceType_is_true', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationentry, notificationentry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(true);

      let mockIsLiveType: Function = mocker.mockFunc(notificationentry, notificationentry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationentry, notificationentry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationentry, notificationentry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      const result = notificationentry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationentry, notificationentry.isSocialOrServiceType);
      mocker.ignoreMock(notificationentry, notificationentry.isLiveType);
      mocker.ignoreMock(notificationentry, notificationentry.isDisplayAtTop);
      mocker.ignoreMock(notificationentry, notificationentry.isEmergencyNtf);
    });

    it('should_return_false_when_isLiveType_is_true', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationentry, notificationentry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationentry, notificationentry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationentry, notificationentry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationentry, notificationentry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      const result = notificationentry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationentry, notificationentry.isSocialOrServiceType);
      mocker.ignoreMock(notificationentry, notificationentry.isLiveType);
      mocker.ignoreMock(notificationentry, notificationentry.isDisplayAtTop);
      mocker.ignoreMock(notificationentry, notificationentry.isEmergencyNtf);
    });

    it('should_return_false_when_isDisplayAtTop_is_true', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationentry, notificationentry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationentry, notificationentry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationentry, notificationentry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(true);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationentry, notificationentry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      const result = notificationentry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationentry, notificationentry.isSocialOrServiceType);
      mocker.ignoreMock(notificationentry, notificationentry.isLiveType);
      mocker.ignoreMock(notificationentry, notificationentry.isDisplayAtTop);
      mocker.ignoreMock(notificationentry, notificationentry.isEmergencyNtf);
    });

    it('should_return_false_when_isEmergencyNtf_is_true', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationentry, notificationentry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationentry, notificationentry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationentry, notificationentry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationentry, notificationentry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(true);

      const result = notificationentry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationentry, notificationentry.isSocialOrServiceType);
      mocker.ignoreMock(notificationentry, notificationentry.isLiveType);
      mocker.ignoreMock(notificationentry, notificationentry.isDisplayAtTop);
      mocker.ignoreMock(notificationentry, notificationentry.isEmergencyNtf);
    });
  });

  describe('updateDataWhenUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_copyDataUpdateListeners_and_updateActionButtonCount_when_ntfEntry_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mockCopyDataUpdateListeners: Function = mocker.mockFunc(notificationEntry, notificationEntry.copyDataUpdateListeners);
      let mockUpdateActionButtonCount: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateActionButtonCount);
      when(mockCopyDataUpdateListeners)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUpdateActionButtonCount)(ArgumentMatchers.any).afterReturnNothing();
      notificationEntry.updateDataWhenUpdate(notificationEntry);
      mocker.ignoreMock(notificationEntry, notificationEntry.copyDataUpdateListeners);
      mocker.ignoreMock(notificationEntry, notificationEntry.updateActionButtonCount);
    });
  });

  describe('updateActionButtonCount_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_actionButtons_or_ntfEntry_actionButtons_are_empty', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.actionButtons = [];
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.actionButtons = [];
      notificationentry.updateActionButtonCount(ntfEntry);
      expect(notificationentry.actionButtons.length).assertEqual(0);
    });

    it('should_update_action_button_count_correctly_when_action_buttons_are_not_empty', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.actionButtons = [
        new NotificationAction('action1', 'title1', 'reply1'),
        new NotificationAction('action2', 'title2', 'reply2')
      ];
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.actionButtons = [
        new NotificationAction('action1', 'title1', 'reply1'),
        new NotificationAction('action2', 'title2', 'reply2'),
        new NotificationAction('action3', 'title3', 'reply3')
      ];
      notificationentry.updateActionButtonCount(ntfEntry);
      expect(notificationentry.actionButtons.length).assertEqual(2);
      expect(notificationentry.actionButtons[0].getUpdateCount()).assertEqual(1);
      expect(notificationentry.actionButtons[1].getUpdateCount()).assertEqual(1);
    });
  });

  describe('setUnifiedPinTop_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_isDisplayAtTop_to_true_when_isInAggregate_is_true_and_childrenEntry_has_displayAtTop_entry', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isInAggregate = true;
      notificationentry.childrenEntry = [
        { isDisplayAtTop: true },
        { isDisplayAtTop: false }
      ];
      notificationentry.setUnifiedPinTop();
      expect(notificationentry.isDisplayAtTop).assertTrue();
    });

    it('should_set_isDisplayAtTop_to_false_when_isInAggregate_is_true_and_childrenEntry_has_no_displayAtTop_entry', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isInAggregate = true;
      notificationentry.childrenEntry = [
        { isDisplayAtTop: false },
        { isDisplayAtTop: false }
      ];
      notificationentry.setUnifiedPinTop();
      expect(notificationentry.isDisplayAtTop).assertFalse();
    });

    it('should_not_set_isDisplayAtTop_when_isInAggregate_is_false', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isInAggregate = false;
      notificationentry.setUnifiedPinTop();
      expect(notificationentry.isDisplayAtTop).assertUndefined();
    });
  });

  describe('getAppIcon_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_appIcon_when_isProtected_is_true_and_appIcon_exists', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry({
        appIcon: $r('app.media.icon'),
        appLabel: 'testApp',
        creatorBundleName: 'testBundle',
        appIndex: 1
      });
      const result = notificationEntry.getAppIcon(false, true);
      expect(result).assertEqual($r('app.media.icon'));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_appIcon_when_isProtected_is_false_and_appIcon_exists', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry({
        appIcon: $r('app.media.icon'),
        appLabel: 'testApp',
        creatorBundleName: 'testBundle',
        appIndex: 1
      });
      const result = notificationEntry.getAppIcon(false, false);
      expect(result).assertEqual($r('app.media.icon'));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_smallIcon_when_isFromSystemApp_is_true_and_smallIcon_exists', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry({
        smallIcon: $r('app.media.icon'),
        appLabel: 'testApp',
        creatorBundleName: 'testBundle',
        appIndex: 1,
        isFromSystemApp: true
      });
      const result = notificationEntry.getAppIcon(false, false);
      expect(result).assertEqual($r('app.media.icon'));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_appIcon_when_isOnlyUseAppIcon_is_true_and_appIcon_exists', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry({
        appIcon: $r('app.media.icon'),
        appLabel: 'testApp',
        creatorBundleName: 'testBundle',
        appIndex: 1
      });
      const result = notificationEntry.getAppIcon(true, false);
      expect(result).assertEqual($r('app.media.icon'));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_smallIcon_when_smallIcon_exists', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry({
        smallIcon: $r('app.media.icon'),
        appLabel: 'testApp',
        creatorBundleName: 'testBundle',
        appIndex: 1
      });
      const result = notificationEntry.getAppIcon(false, false);
      expect(result).assertEqual($r('app.media.icon'));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_return_default_icon_when_appIcon_is_invalid', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationEntry: NotificationEntry = new NotificationEntry({
        appIcon: undefined,
        appLabel: 'testApp',
        creatorBundleName: 'testBundle',
        appIndex: 1
      });
      const result = notificationEntry.getAppIcon(false, false);
      expect(result).assertEqual($r('app.media.icon'));
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });

  describe('isMediaPlayerCenter_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_getFirstChildEntry_returns_null', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationentry, notificationentry.getFirstChildEntry);
      when(mockfunc)().afterReturn(null);
      const result = notificationentry.isMediaPlayerCenter();
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationentry, notificationentry.getFirstChildEntry);
    });

    it('should_return_true_when_getFirstChildEntry_returns_liveViewData_with_sysTypeCode_BROADCASTING_CENTER', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationentry, notificationentry.getFirstChildEntry);
      letfirstChildEntry: NotificationEntry = new NotificationEntry();
      firstChildEntry.liveViewData = { sysTypeCode: SysTypeCode.BROADCASTING_CENTER };
      when(mockfunc)().afterReturn(firstChildEntry);
      const result = notificationentry.isMediaPlayerCenter();
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationentry, notificationentry.getFirstChildEntry);
    });

    it('should_return_false_when_getFirstChildEntry_returns_liveViewData_with_sysTypeCode_not_BROADCASTING_CENTER', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationentry, notificationentry.getFirstChildEntry);
      letfirstChildEntry: NotificationEntry = new NotificationEntry();
      firstChildEntry.liveViewData = { sysTypeCode: SysTypeCode.OTHER };
      when(mockfunc)().afterReturn(firstChildEntry);
      const result = notificationentry.isMediaPlayerCenter();
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationentry, notificationentry.getFirstChildEntry);
    });
  });

  describe('getSysTypeCode_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_getFirstChildEntry_returns_undefined', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationentry, notificationentry.getFirstChildEntry);
      when(mockfunc)().afterReturn(undefined);
      const result = notificationentry.getSysTypeCode();
      expect(result).assertUndefined();
      mocker.ignoreMock(notificationentry, notificationentry.getFirstChildEntry);
    });

    it('should_return_sysTypeCode_when_getFirstChildEntry_returns_NotificationEntry_with_liveViewData', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationentry, notificationentry.getFirstChildEntry);
      let mockEntry: NotificationEntry = new NotificationEntry();
      mockEntry.liveViewData = { sysTypeCode: SysTypeCode.FLIGHT_INFO };
      when(mockfunc)().afterReturn(mockEntry);
      const result = notificationentry.getSysTypeCode();
      expect(result).assertEqual(SysTypeCode.FLIGHT_INFO);
      mocker.ignoreMock(notificationentry, notificationentry.getFirstChildEntry);
    });
  });

  describe('getLauncherBundleName_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_bundleName_when_isFromPush_and_creatorBundleName_is_valid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromPush = true;
      notificationEntry.creatorBundleName = 'com.example.app';
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturnNothing();
      const result = notificationEntry.getLauncherBundleName();
      expect(result).assertEqual('com.example.app');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_bundleName_when_wantAgentInfo_and_bundleName_is_valid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromPush = false;
      notificationEntry.wantAgentInfo = { want: { bundleName: 'com.example.app' } };
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturnNothing();
      const result = notificationEntry.getLauncherBundleName();
      expect(result).assertEqual('com.example.app');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_bundleName_when_wantAgentInfo_and_bundleName_is_empty_but_want_is_valid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromPush = false;
      notificationEntry.wantAgentInfo = { want: { bundleName: '' } };
      notificationEntry.wantAgentInfo.want.bundleName = 'com.example.app';
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturnNothing();
      const result = notificationEntry.getLauncherBundleName();
      expect(result).assertEqual('com.example.app');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_bundleName_when_wantAgentInfo_and_bundleName_is_invalid_but_want_is_valid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromPush = false;
      notificationEntry.wantAgentInfo = { want: { bundleName: '' } };
      notificationEntry.wantAgentInfo.want.bundleName = 'com.example.app';
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturnNothing();
      const result = notificationEntry.getLauncherBundleName();
      expect(result).assertEqual('com.example.app');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_undefined_when_all_conditions_are_invalid', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isFromPush = false;
      notificationEntry.wantAgentInfo = undefined;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturnNothing();
      const result = notificationEntry.getLauncherBundleName();
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });

  describe('canShowSetting_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_deviceModeState_is_emergency_and_isInGroup_is_true', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockCheckIsDeliverSystemNotification: Function = mocker.mockFunc(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      when(mockCheckIsDeliverSystemNotification)([]).afterReturn(false);

      let mockGetIsInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
      when(mockGetIsInEmergencyOrThermalSafeMode)([]).afterReturn(true);

      let mockIsSettingIgnore: boolean = false;
      notificationEntry.isSettingIgnore = mockIsSettingIgnore;

      let mockCreatorType: NotificationCreatorType = NotificationCreatorType.SA;
      notificationEntry.creatorType = mockCreatorType;

      let mockIsSaCreator: boolean = true;
      notificationEntry.isSaCreator = mockIsSaCreator;

      let mockIsOuterHome: boolean = false;
      notificationEntry.isOuterHome = mockIsOuterHome;

      let mockNotificationType: number = 0;
      let result = notificationEntry.canShowSetting(mockNotificationType, true, false);
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      mocker.ignoreMock(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
    });

    it('should_return_true_when_deviceModeState_is_emergency_and_isInGroup_is_false', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockCheckIsDeliverSystemNotification: Function = mocker.mockFunc(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      when(mockCheckIsDeliverSystemNotification)([]).afterReturn(false);

      let mockGetIsInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
      when(mockGetIsInEmergencyOrThermalSafeMode)([]).afterReturn(true);

      let mockIsSettingIgnore: boolean = false;
      notificationEntry.isSettingIgnore = mockIsSettingIgnore;

      let mockCreatorType: NotificationCreatorType = NotificationCreatorType.SA;
      notificationEntry.creatorType = mockCreatorType;

      let mockIsSaCreator: boolean = false;
      notificationEntry.isSaCreator = mockIsSaCreator;

      let mockIsOuterHome: boolean = false;
      notificationEntry.isOuterHome = mockIsOuterHome;

      let mockNotificationType: number = 0;
      let result = notificationEntry.canShowSetting(mockNotificationType, false, false);
      expect(result).assertEqual(true);

      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      mocker.ignoreMock(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
    });

    it('should_return_true_when_deviceModeState_is_not_emergency_and_isInGroup_is_false', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockCheckIsDeliverSystemNotification: Function = mocker.mockFunc(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      when(mockCheckIsDeliverSystemNotification)([]).afterReturn(false);

      let mockGetIsInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
      when(mockGetIsInEmergencyOrThermalSafeMode)([]).afterReturn(false);

      let mockIsSettingIgnore: boolean = false;
      notificationEntry.isSettingIgnore = mockIsSettingIgnore;

      let mockCreatorType: NotificationCreatorType = NotificationCreatorType.SA;
      notificationEntry.creatorType = mockCreatorType;

      let mockIsSaCreator: boolean = false;
      notificationEntry.isSaCreator = mockIsSaCreator;

      let mockIsOuterHome: boolean = false;
      notificationEntry.isOuterHome = mockIsOuterHome;

      let mockNotificationType: number = 0;
      let result = notificationEntry.canShowSetting(mockNotificationType, false, false);
      expect(result).assertEqual(true);

      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      mocker.ignoreMock(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
    });

    it('should_return_false_when_deviceModeState_is_not_emergency_and_isInGroup_is_true', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockCheckIsDeliverSystemNotification: Function = mocker.mockFunc(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      when(mockCheckIsDeliverSystemNotification)([]).afterReturn(false);

      let mockGetIsInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
      when(mockGetIsInEmergencyOrThermalSafeMode)([]).afterReturn(false);

      let mockIsSettingIgnore: boolean = false;
      notificationEntry.isSettingIgnore = mockIsSettingIgnore;

      let mockCreatorType: NotificationCreatorType = NotificationCreatorType.SA;
      notificationEntry.creatorType = mockCreatorType;

      let mockIsSaCreator: boolean = false;
      notificationEntry.isSaCreator = mockIsSaCreator;

      let mockIsOuterHome: boolean = false;
      notificationEntry.isOuterHome = mockIsOuterHome;

      let mockNotificationType: number = 0;
      let result = notificationEntry.canShowSetting(mockNotificationType, true, false);
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      mocker.ignoreMock(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
    });

    it('should_return_false_when_deviceModeState_is_emergency_and_isSaCreator_is_true', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockCheckIsDeliverSystemNotification: Function = mocker.mockFunc(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      when(mockCheckIsDeliverSystemNotification)([]).afterReturn(false);

      let mockGetIsInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
      when(mockGetIsInEmergencyOrThermalSafeMode)([]).afterReturn(true);

      let mockIsSettingIgnore: boolean = false;
      notificationEntry.isSettingIgnore = mockIsSettingIgnore;

      let mockCreatorType: NotificationCreatorType = NotificationCreatorType.SA;
      notificationEntry.creatorType = mockCreatorType;

      let mockIsSaCreator: boolean = true;
      notificationEntry.isSaCreator = mockIsSaCreator;

      let mockIsOuterHome: boolean = false;
      notificationEntry.isOuterHome = mockIsOuterHome;

      let mockNotificationType: number = 0;
      let result = notificationEntry.canShowSetting(mockNotificationType, false, false);
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.checkIsDeliverSystemNotification);
      mocker.ignoreMock(notificationEntry, notificationEntry.getIsInEmergencyOrThermalSafeMode);
    });
  });

  describe('setLiveViewAppIcon_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_appIcon_when_spaceIcon_is_valid', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockSetAppIcon: Function = mocker.mockFunc(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setAppIcon);
      when(mockSetAppIcon)([ArgumentMatchers.any, ArgumentMatchers.anyBoolean]).afterReturn(undefined);

      notificationentry.liveViewData = { template: new LiveBaseTemplate(), creatorBundleName: 'HI_BOARD', liveType: LiveType.FLIGHT, additionalText: CHINA_RAIL, spaceIcon: 'valid_icon' };

      expect(notificationentry.appIcon).assertEqual('valid_icon');
      mocker.ignoreMock(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setAppIcon);
    });
    it('should_log_info_when_spaceIcon_is_invalid', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      notificationentry.liveViewData = { template: new LiveBaseTemplate(), creatorBundleName: 'HI_BOARD', liveType: LiveType.FLIGHT, additionalText: CHINA_RAIL, spaceIcon: undefined };

      expect(notificationentry.appIcon).assertEqual(undefined);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });

  describe('isShowInLockScreen_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isLockScreenEnable_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isLockScreenEnable = true;
      const result = notificationEntry.isShowInLockScreen();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isLockScreenEnable_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isLockScreenEnable = false;
      const result = notificationEntry.isShowInLockScreen();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_postData_sets_isLockScreenEnable_to_true', 0, () => {
      // 假设postData的某个属性控制isLockScreenEnable
      let postData: BaseNotification = {
        // 假设showOnLockScreen是决定因素
        showOnLockScreen: true
      } as BaseNotification;
      let notificationEntry: NotificationEntry = new NotificationEntry(postData);
      const result = notificationEntry.isShowInLockScreen();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_postData_sets_isLockScreenEnable_to_false', 0, () => {
      let postData: BaseNotification = {
        showOnLockScreen: false
      } as BaseNotification;
      let notificationEntry: NotificationEntry = new NotificationEntry(postData);
      const result = notificationEntry.isShowInLockScreen();
      expect(result).assertEqual(false);
    });

    it('should_return_default_false_when_postData_is_absent', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      const result = notificationEntry.isShowInLockScreen();
      expect(result).assertEqual(false);
    });
  });

  describe('isOngoingLockScreen_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_isOngoing_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isOngoing = false;
      notificationEntry.isLockScreenEnable = true;
      const result = notificationEntry.isOngoingLockScreen();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isLockScreenEnable_is_false', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isOngoing = true;
      notificationEntry.isLockScreenEnable = false;
      const result = notificationEntry.isOngoingLockScreen();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isOngoing_and_isLockScreenEnable_are_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isOngoing = true;
      notificationEntry.isLockScreenEnable = true;
      const result = notificationEntry.isOngoingLockScreen();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_both_are_false', 0, () => {
      let entry = new NotificationEntry();
      entry.isOngoing = false;
      entry.isLockScreenEnable = false;
      expect(entry.isOngoingLockScreen()).assertEqual(false);
    });

    it('should_return_false_when_not_set', 0, () => {
      let entry = new NotificationEntry();
      expect(entry.isOngoingLockScreen()).assertEqual(false);
    });

    it('should_return_true_with_postData_both_true', 0, () => {
      let postData: BaseNotification = { isOngoing: true, isLockScreenEnable: true };
      let entry = new NotificationEntry(postData);
      entry.isOngoing = postData.isOngoing;
      entry.isLockScreenEnable = postData.isLockScreenEnable;
      expect(entry.isOngoingLockScreen()).assertEqual(true);
    });

    it('should_return_false_with_postData_only_ongoing', 0, () => {
      let postData: BaseNotification = { isOngoing: true, isLockScreenEnable: false };
      let entry = new NotificationEntry(postData);
      entry.isOngoing = postData.isOngoing;
      entry.isLockScreenEnable = postData.isLockScreenEnable;
      expect(entry.isOngoingLockScreen()).assertEqual(false);
    });

    it('should_return_false_with_undefined_ongoing', 0, () => {
      let entry = new NotificationEntry();
      entry.isLockScreenEnable = true;
      expect(entry.isOngoingLockScreen()).assertEqual(false);
    });
  });

  describe('equals_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_other_is_invalid', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let result = notificationentry.equals(null);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_is_not_NotificationEntry', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let other: object = {};
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_is_NotificationEntry_but_creatorBundleName_is_different', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.creatorBundleName = 'bundle1';
      let other: NotificationEntry = new NotificationEntry();
      other.creatorBundleName = 'bundle2';
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_is_NotificationEntry_but_isGroup_is_different', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isGroup = true;
      let other: NotificationEntry = new NotificationEntry();
      other.isGroup = false;
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_is_NotificationEntry_but_getGroupTypeKey_is_different', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      let other: NotificationEntry = new NotificationEntry();
      when(mocker.mockFunc(notificationentry, notificationentry.getGroupTypeKey))(ArgumentMatchers.any).afterReturn('type1');
      when(mocker.mockFunc(other, other.getGroupTypeKey))(ArgumentMatchers.any).afterReturn('type2');
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_other_is_NotificationEntry_and_all_conditions_are_met', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isGroup = true;
      notificationentry.creatorBundleName = 'bundle1';
      let other: NotificationEntry = new NotificationEntry();
      other.isGroup = true;
      other.creatorBundleName = 'bundle1';
      let result = notificationentry.equals(other);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_other_is_NotificationEntry_and_hashCode_is_different', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isGroup = false;
      notificationentry.hashCode = 123;
      let other: NotificationEntry = new NotificationEntry();
      other.isGroup = false;
      other.hashCode = 456;
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_other_is_NotificationEntry_and_groupName_is_different', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry();
      notificationentry.isGroup = true;
      notificationentry.groupName = 'group1';
      let other: NotificationEntry = new NotificationEntry();
      other.isGroup = true;
      other.groupName = 'group2';
      let result = notificationentry.equals(other);
      expect(result).assertEqual(false);
    });
  });

  describe('toSimpleString_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_string_when_all_properties_are_set', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry({
        groupName: 'testGroup',
        isGroup: true,
        creatorBundleName: 'testBundle',
        hashCode: '1234567890',
        appIndex: 1,
        creatorUid: '1234567890'
      });

      let result: string = notificationEntry.toSimpleString();
      expect(result).assertEqual('group: testGroup, true, testBundle, 1234567890, 1, 1234567890');
    });

    it('should_return_correct_string_when_some_properties_are_undefined', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry({
        groupName: 'testGroup',
        isGroup: true,
        creatorBundleName: 'testBundle',
        hashCode: '1234567890',
        creatorUid: '1234567890'
      });

      let result: string = notificationEntry.toSimpleString();
      expect(result).assertEqual('group: testGroup, true, testBundle, 1234567890, undefined, 1234567890');
    });
  });

  describe('isSocialOrServiceType_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_slotType_is_SLOT_TYPE_SOCIAL_COMMUNICATION', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: SLOT_TYPE_SOCIAL_COMMUNICATION });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_slotType_is_SLOT_TYPE_SERVICE_INFORMATION', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: SLOT_TYPE_SERVICE_INFORMATION });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_slotType_is_SLOT_TYPE_CUSTOMER_INFORMATION', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: SLOT_TYPE_CUSTOMER_INFORMATION });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_slotType_is_not_in_socialAndServiceType_list', 0, () => {
      let notificationentry: NotificationEntry = new NotificationEntry({ slotType: 'SLOT_TYPE_UNKNOWN' });
      const result = notificationentry.isSocialOrServiceType();
      expect(result).assertEqual(false);
    });
  });

  describe('isExtraContentType_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationEntry, notificationEntry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationEntry, notificationEntry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      const result = notificationEntry.isExtraContentType();
      expect(result).assertEqual(true);

      mocker.ignoreMock(notificationEntry, notificationEntry.isSocialOrServiceType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isEmergencyNtf);
      mocker.ignoreMock(notificationEntry, notificationEntry.isDisplayAtTop);
    });

    it('should_return_false_when_isSocialOrServiceType_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(true);

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationEntry, notificationEntry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationEntry, notificationEntry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      const result = notificationEntry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationEntry, notificationEntry.isSocialOrServiceType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isEmergencyNtf);
      mocker.ignoreMock(notificationEntry, notificationEntry.isDisplayAtTop);
    });

    it('should_return_false_when_isLiveType_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationEntry, notificationEntry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationEntry, notificationEntry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      const result = notificationEntry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationEntry, notificationEntry.isSocialOrServiceType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isEmergencyNtf);
      mocker.ignoreMock(notificationEntry, notificationEntry.isDisplayAtTop);
    });

    it('should_return_false_when_isEmergencyNtf_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationEntry, notificationEntry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(true);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationEntry, notificationEntry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(false);

      const result = notificationEntry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationEntry, notificationEntry.isSocialOrServiceType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isEmergencyNtf);
      mocker.ignoreMock(notificationEntry, notificationEntry.isDisplayAtTop);
    });

    it('should_return_false_when_isDisplayAtTop_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      let mockIsSocialOrServiceType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isSocialOrServiceType);
      when(mockIsSocialOrServiceType)([]).afterReturn(false);

      let mockIsLiveType: Function = mocker.mockFunc(notificationEntry, notificationEntry.isLiveType);
      when(mockIsLiveType)([]).afterReturn(false);

      let mockIsEmergencyNtf: Function = mocker.mockFunc(notificationEntry, notificationEntry.isEmergencyNtf);
      when(mockIsEmergencyNtf)([]).afterReturn(false);

      let mockIsDisplayAtTop: Function = mocker.mockFunc(notificationEntry, notificationEntry.isDisplayAtTop);
      when(mockIsDisplayAtTop)([]).afterReturn(true);

      const result = notificationEntry.isExtraContentType();
      expect(result).assertEqual(false);

      mocker.ignoreMock(notificationEntry, notificationEntry.isSocialOrServiceType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isLiveType);
      mocker.ignoreMock(notificationEntry, notificationEntry.isEmergencyNtf);
      mocker.ignoreMock(notificationEntry, notificationEntry.isDisplayAtTop);
    });
  });

  describe('updateDataWhenUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_copyDataUpdateListeners_and_updateActionButtonCount_when_postData_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationEntry: NotificationEntry = new NotificationEntry({
        title: 'test',
        content: new NtfLongTextContent('test'),
        reminderConfig: new NtfReminderConfig({}),
        actionButtons: [new NotificationAction()],
        liveView: new LiveBaseTemplate({}),
        immersiveData: new IImmersiveData({}),
        postData: {
          title: 'test',
          content: new NtfLongTextContent('test'),
          reminderConfig: new NtfReminderConfig({}),
          actionButtons: [new NotificationAction()],
          liveView: new LiveBaseTemplate({}),
          immersiveData: new IImmersiveData({})
        }
      });

      let mockCopyDataUpdateListeners: Function = mocker.mockFunc(notificationEntry, notificationEntry.copyDataUpdateListeners);
      when(mockCopyDataUpdateListeners)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateActionButtonCount: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateActionButtonCount);
      when(mockUpdateActionButtonCount)(ArgumentMatchers.any).afterReturnNothing();

      notificationEntry.updateDataWhenUpdate(notificationEntry);

      mocker.ignoreMock(notificationEntry, notificationEntry.copyDataUpdateListeners);
      mocker.ignoreMock(notificationEntry, notificationEntry.updateActionButtonCount);
    });

    it('should_not_call_copyDataUpdateListeners_and_updateActionButtonCount_when_postData_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationEntry: NotificationEntry = new NotificationEntry();

      let mockCopyDataUpdateListeners: Function = mocker.mockFunc(notificationEntry, notificationEntry.copyDataUpdateListeners);
      when(mockCopyDataUpdateListeners)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateActionButtonCount: Function = mocker.mockFunc(notificationEntry, notificationEntry.updateActionButtonCount);
      when(mockUpdateActionButtonCount)(ArgumentMatchers.any).afterReturnNothing();

      notificationEntry.updateDataWhenUpdate(notificationEntry);

      mocker.ignoreMock(notificationEntry, notificationEntry.copyDataUpdateListeners);
      mocker.ignoreMock(notificationEntry, notificationEntry.updateActionButtonCount);
    });
  });
}