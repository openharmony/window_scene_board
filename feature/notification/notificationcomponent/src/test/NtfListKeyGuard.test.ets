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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenLockEvent, ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { SCBOobeManager } from '@ohos/windowscene';
import { NtfAutoScreenOnEvent, NtfHideContentEvent, LiveViewHideContentEvent } from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { LiveTimeoutEvent } from '@ohos/systemuicommon';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NtfListCallback, NtfListVm } from '../../../main/ets/model/NtfListVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfListKeyGuard } from '../../../main/ets/model/NtfListKeyGuard';
export default function NtfListKeyGuardTest() {
  describe('checkShouldHideLiveViewContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_hide_live_view_content_when_isLiveViewHideContent_and_isSecureAndLocked_are_true', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_not_hide_live_view_content_when_isLiveViewHideContent_is_false', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = false;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(false);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_not_hide_live_view_content_when_isSecureAndLocked_is_false', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = false;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(false);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_hide_live_view_content_when_isLiveViewHideContent_is_true_and_isSecureAndLocked_is_false', 0,
      async () => {
        let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
        let mocker: MockKit = new MockKit();

        let mockSetEntryHideContent: Function =
          mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
        when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

        let mockIsLiveType: Function =
          mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
        when(mockIsLiveType)([]).afterReturn(true);

        let mockNotifyDataChanged: Function =
          mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
        when(mockNotifyDataChanged)([]).afterReturnNothing();

        ntflistkeyguard.isLiveViewHideContent = true;
        ntflistkeyguard.isSecureAndLocked = false;
        ntflistkeyguard.checkShouldHideLiveViewContent();

        expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
        expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

        mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
        mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
        mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      });

    it('should_call_setEntryHideContent_and_notifyDataChanged_when_isLiveType_is_true', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_hide_live_view_content_when_isLiveViewHideContent_and_isSecureAndLocked_are_true', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_not_hide_live_view_content_when_isLiveViewHideContent_is_false', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = false;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(false);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_not_hide_live_view_content_when_isSecureAndLocked_is_false', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = false;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(false);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_hide_live_view_content_when_isLiveViewHideContent_is_true_and_isSecureAndLocked_is_false', 0,
      async () => {
        let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
        let mocker: MockKit = new MockKit();

        let mockSetEntryHideContent: Function =
          mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
        when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

        let mockIsLiveType: Function =
          mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
        when(mockIsLiveType)([]).afterReturn(true);

        let mockNotifyDataChanged: Function =
          mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
        when(mockNotifyDataChanged)([]).afterReturnNothing();

        ntflistkeyguard.isLiveViewHideContent = true;
        ntflistkeyguard.isSecureAndLocked = false;
        ntflistkeyguard.checkShouldHideLiveViewContent();

        expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
        expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

        mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
        mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
        mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      });

    it('should_call_setEntryHideContent_and_notifyDataChanged_when_isLiveType_is_true', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });
    it('should_hide_live_view_content_when_isLiveViewHideContent_and_isSecureAndLocked_are_true', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_not_hide_live_view_content_when_isLiveViewHideContent_is_false', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = false;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(false);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_not_hide_live_view_content_when_isSecureAndLocked_is_false', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = false;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(false);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });

    it('should_hide_live_view_content_when_isLiveViewHideContent_is_true_and_isSecureAndLocked_is_false', 0,
      async () => {
        let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
        let mocker: MockKit = new MockKit();

        let mockSetEntryHideContent: Function =
          mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
        when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

        let mockIsLiveType: Function =
          mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
        when(mockIsLiveType)([]).afterReturn(true);

        let mockNotifyDataChanged: Function =
          mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
        when(mockNotifyDataChanged)([]).afterReturnNothing();

        ntflistkeyguard.isLiveViewHideContent = true;
        ntflistkeyguard.isSecureAndLocked = false;
        ntflistkeyguard.checkShouldHideLiveViewContent();

        expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
        expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

        mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
        mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
        mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      });
    it('should_call_setEntryHideContent_and_notifyDataChanged_when_isLiveType_is_true', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });
    it('should_hide_live_view_content_when_isLiveViewHideContent_and_isSecureAndLocked_are_true', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = true;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(true);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });
    it('should_not_hide_live_view_content_when_isLiveViewHideContent_is_false', 0, async () => {
      let ntflistkeyguard: NtfListKeyGuard = new NtfListKeyGuard();
      let mocker: MockKit = new MockKit();

      let mockSetEntryHideContent: Function =
        mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      when(mockSetEntryHideContent)([ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean]).afterReturnNothing();

      let mockIsLiveType: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      when(mockIsLiveType)([]).afterReturn(true);

      let mockNotifyDataChanged: Function =
        mocker.mockFunc(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
      when(mockNotifyDataChanged)([]).afterReturnNothing();

      ntflistkeyguard.isLiveViewHideContent = false;
      ntflistkeyguard.isSecureAndLocked = true;
      ntflistkeyguard.checkShouldHideLiveViewContent();

      expect(ntflistkeyguard.shouldHideLiveViewContent).assertEqual(false);
      expect(ntflistkeyguard.hasAppLocked).assertEqual(false);

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.setEntryHideContent);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.isLiveType);
      mocker.ignoreMock(NotificationEntry.prototype, NotificationEntry.prototype.notifyDataChanged);
    });
  });
}