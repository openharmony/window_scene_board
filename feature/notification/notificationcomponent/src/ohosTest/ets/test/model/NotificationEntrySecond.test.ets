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
import { LiveBaseTemplate, LiveSystemTemplate, NtfReminderConfig } from '@ohos/systemuicommon';
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

    it('should_call_setLiveViewAppIcon_when_liveViewData_template_is_LiveBaseTemplate_and_appIcon_is_different', 0,
      async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();

        notificationEntry.liveViewData = {
          template: new LiveBaseTemplate(), appIcon: 'icon1'
        };
        notificationEntry.appIcon = 'icon2';
        notificationEntry.isFromSystemApp = false;
        notificationEntry.smallIcon = 'smallIcon';

        notificationEntry.notifyDataChanged();
      });

    it('should_call_setLiveViewAppIcon_with_isFromSystemApp_true_when_liveViewData_template_is_LiveSystemTemplate_and_appIcon_is_different',
      0, async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();

        notificationEntry.liveViewData = {
          template: new LiveSystemTemplate(), appIcon: 'icon1'
        };
        notificationEntry.appIcon = 'icon2';
        notificationEntry.isFromSystemApp = true;
        notificationEntry.smallIcon = 'smallIcon';

        notificationEntry.notifyDataChanged();
      });

    it('should_call_setOverlayIcon_when_liveViewData_template_is_LiveSystemTemplate_and_overlayIcon_is_different', 0,
      async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function =
          mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setOverlayIcon);
        when(mockfunc)([ArgumentMatchers.any]).afterReturnNothing();

        notificationEntry.liveViewData = {
          template: new LiveSystemTemplate(), appIcon: 'icon'
        };
        notificationEntry.overlayIcon = 'overlayIcon';
        notificationEntry.isFromSystemApp = false;

        notificationEntry.notifyDataChanged();

        mocker.ignoreMock(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setOverlayIcon);
      });

    it('should_call_setSmallIcon_when_liveViewData_template_is_LiveBaseTemplate_and_smallIcon_is_different', 0,
      async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
        when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

        notificationEntry.liveViewData = {
          template: new LiveBaseTemplate(), appIcon: 'icon'
        };
        notificationEntry.smallIcon = 'smallIcon';
        notificationEntry.isFromSystemApp = false;

        notificationEntry.notifyDataChanged();

        mocker.ignoreMock(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
      });

    it('should_call_setSmallIcon_with_forceRefresh_true_when_liveViewData_template_is_LiveBaseTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_true',
      0, async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
        when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

        notificationEntry.liveViewData = {
          template: new LiveBaseTemplate(), appIcon: 'icon'
        };
        notificationEntry.smallIcon = 'smallIcon';
        notificationEntry.isFromSystemApp = true;

        notificationEntry.notifyDataChanged();

        mocker.ignoreMock(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
      });

    it('should_call_setSmallIcon_with_forceRefresh_false_when_liveViewData_template_is_LiveBaseTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_false',
      0, async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
        when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

        notificationEntry.liveViewData = {
          template: new LiveBaseTemplate(), appIcon: 'icon'
        };
        notificationEntry.smallIcon = 'smallIcon';
        notificationEntry.isFromSystemApp = false;

        notificationEntry.notifyDataChanged();

        mocker.ignoreMock(LiveBaseTemplate.prototype, LiveBaseTemplate.prototype.setSmallIcon);
      });

    it('should_call_setSmallIcon_with_forceRefresh_true_when_liveViewData_template_is_LiveSystemTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_true',
      0, async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function =
          mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
        when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

        notificationEntry.liveViewData = {
          template: new LiveSystemTemplate(), appIcon: 'icon'
        };
        notificationEntry.smallIcon = 'smallIcon';
        notificationEntry.isFromSystemApp = true;

        notificationEntry.notifyDataChanged();

        mocker.ignoreMock(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
      });

    it('should_call_setSmallIcon_with_forceRefresh_false_when_liveViewData_template_is_LiveSystemTemplate_and_smallIcon_is_different_and_isFromSystemApp_is_false',
      0, async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function =
          mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
        when(mockfunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

        notificationEntry.liveViewData = {
          template: new LiveSystemTemplate(), appIcon: 'icon'
        };
        notificationEntry.smallIcon = 'smallIcon';
        notificationEntry.isFromSystemApp = false;

        notificationEntry.notifyDataChanged();

        mocker.ignoreMock(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setSmallIcon);
      });

    it('should_call_setOverlayIcon_with_overlayIcon_when_liveViewData_template_is_LiveSystemTemplate_and_overlayIcon_is_different',
      0, async () => {
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function =
          mocker.mockFunc(LiveSystemTemplate.prototype, LiveSystemTemplate.prototype.setOverlayIcon);
        when(mockfunc)([ArgumentMatchers.any]).afterReturnNothing();

        notificationEntry.liveViewData = {
          template: new LiveSystemTemplate(), appIcon: 'icon'
        };
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
      expect(notificationEntry.aggregateContent).assertUndefined();
    });

    it('should_update_aggregateContent_when_isInAggregate_is_true', 0, () => {
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.isInAggregate = true;
      let unifiedGroup: AggregateContent = new AggregateContent();
      notificationEntry.updateAggregateContent(unifiedGroup);
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
  });

}