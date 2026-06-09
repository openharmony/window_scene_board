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
  BannerDeformState,
  BannerPanelTypeState,
  BannerStyleState,
  BannerPanelType,
  BannerState,
  capsuleStateMgr,
  APSSceneState,
  LiveUseScene,
  TimeoutPromise,
  AnimDataScene,
  LiveAnimScene
} from '@ohos/systemuicommon';
import { bannerMgr } from '@ohos/systemuicommon';
import { CommonUtils, LogHelper, LogDomain, RectItem } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import {
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  FloatingSceneCommonStyle,
  FloatingSceneExpandStyle,
  FloatingScenePortraitStyle,
  FloatingScenePadLayoutStyle
} from '@ohos/windowscene';
import { NtfItemSwipeController } from '../../../../main/ets/controller/NtfItemSwipeController';
import { HeadsUpSwipeYController } from '../../../../main/ets/controller/phone/HeadsUpSwipeYController';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { HeadsUpCallback,
  HEADS_UP_DURATION,
  HEADS_UP_TRANSITION_EFFECT_CHANGE_DELAY,
  PhoneNtfHeadsUpVm } from '../../../../main/ets/vm/phone/PhoneNtfHeadsUpVM';
import { NotificationHeadsUp } from '../../../../main/ets/pages/phone/NotificationHeadsUp';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import { NotificationType } from '../../../../main/ets/common/NotificationType';
import { NtfMgr } from '../../../../main/ets/model/NotificationManager';
import { NtfSingleItemVM } from '../../../../main/ets/vm/NtfSingleItemVM';
import { DarkModeState, ImmersiveBaseState,
  StateType } from '@ohos/systemuicommon';
import { baseStateMgr } from '@ohos/systemuicommon';
import curves from '@ohos.curves';
import {
  CommonData,
  ScreenLockNotificationConst,
  screenLockSysFloatTipControl
} from '@ohos/screenlockcommon';
import { SysFloatTipDialog } from '@ohos/screenlockcommon/Index';
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import {
  ColorModeViewData,
  ColorModeViewModel,
  EventBroadcast,
  OhterCardExtendAnimVm,
  ProgressCardAnimVm,
  SysUiWindowType
} from '@ohos/systemuicommon/Index';
import { fingerPrintTapListener } from '../../../../main/ets/model/FingerPrintTapListener';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { liveCapsuleVm } from '';
import { NtfListContentConfig } from '../../../../main/ets/vm/config/NtfViewConfig';
import { ntfViewConfigManager } from '../../../../main/ets/vm/config/NtfViewConfigManager';
import { LiveListAnimStatus } from '';
import { ItemGestureModifier } from '../../../../main/ets/model/NotificationGestureModifier';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AccessibilityUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { getAvgColor } from '@ohos/systemuicommon/src/main/ets/utils/ColorInvertTool';
import { effectKit } from '@kit.ArkGraphics2D';
import { ColorModeLiveViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeLiveViewData';
import { ColorModeNCViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeNCViewData';
import { NtfThemeActiveMgr } from '../../../../main/ets/common/NotificationThemeActiveManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/BannerHeadsUpContent';
export default function Test() {
  describe('removeEntry_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_removeNotificationByCancel_when_ntfEntry_has_hashCode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = '123';
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.ntfEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
    });

    it('should_call_removeNotificationByCancel_and_showInfo_when_needDeleteFloatingEntry_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.needDeleteFloatingEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_resetWatcher_when_headsUpVM_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.headsUpVM = new PhoneNtfHeadsUpVm();
      testObj.removeEntry();

    });

    it('should_call_removeNotificationByCancel_when_ntfEntry_has_hashCode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = '123';
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.ntfEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
    });

    it('should_call_removeNotificationByCancel_and_showInfo_when_needDeleteFloatingEntry_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.needDeleteFloatingEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_resetWatcher_when_headsUpVM_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.headsUpVM = new PhoneNtfHeadsUpVm();
      testObj.removeEntry();

    });

    it('should_call_removeNotificationByCancel_when_ntfEntry_has_hashCode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = '123';
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.ntfEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
    });

    it('should_call_removeNotificationByCancel_and_showInfo_when_needDeleteFloatingEntry_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.needDeleteFloatingEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_resetWatcher_when_headsUpVM_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.headsUpVM = new PhoneNtfHeadsUpVm();
      testObj.removeEntry();

    });

    it('should_call_removeNotificationByCancel_when_ntfEntry_has_hashCode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.hashCode = '123';
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.ntfEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
    });

    it('should_call_removeNotificationByCancel_and_showInfo_when_needDeleteFloatingEntry_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockRemoveNotificationByCancel: Function = mocker.mockFunc(NtfMgr, NtfMgr.removeNotificationByCancel);
      when(mockRemoveNotificationByCancel)(ArgumentMatchers.any).afterReturn(null);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturn(null);

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.needDeleteFloatingEntry = ntfEntry;
      testObj.removeEntry();

      mocker.ignoreMock(NtfMgr, NtfMgr.removeNotificationByCancel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_resetWatcher_when_headsUpVM_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();

      let testObj: NotificationHeadsUp = new NotificationHeadsUp();
      testObj.headsUpVM = new PhoneNtfHeadsUpVm();
      testObj.removeEntry();

    });

    it('should_return_appName_when_isProtectedInScreenLocked_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);
      const result = vm.getNtfTitle();
      expect(result).assertEqual('testApp');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_appName_when_isHiddenBannerContent_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('testApp');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_expandedTitle_when_ntfEntryIsExpandable_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(vm, vm.getExpandedTitle))(ArgumentMatchers.any).afterReturn('expandedTitle');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('expandedTitle');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getExpandedTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_contentTitle_when_ntfEntryIsExpandable_is_false', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.getContentTitle))(ArgumentMatchers.any).afterReturn('contentTitle');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('contentTitle');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getContentTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_appName_when_title_is_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.getContentTitle))(ArgumentMatchers.any).afterReturn('');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(true);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('testApp');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getContentTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_space_when_title_is_empty_and_appName_is_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: '' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.getContentTitle))(ArgumentMatchers.any).afterReturn('');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(true);

      const result = vm.getNtfTitle();
      expect(result).assertEqual(' ');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getContentTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_appName_when_isProtectedInScreenLocked_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('testApp');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_appName_when_isHiddenBannerContent_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('testApp');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_expandedTitle_when_ntfEntryIsExpandable_is_true', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(true);
      when(mocker.mockFunc(vm, vm.getExpandedTitle))(ArgumentMatchers.any).afterReturn('expandedTitle');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('expandedTitle');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getExpandedTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_contentTitle_when_ntfEntryIsExpandable_is_false', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.getContentTitle))(ArgumentMatchers.any).afterReturn('contentTitle');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(false);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('contentTitle');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getContentTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_appName_when_title_is_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.getContentTitle))(ArgumentMatchers.any).afterReturn('');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(true);

      const result = vm.getNtfTitle();
      expect(result).assertEqual('testApp');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getContentTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_space_when_title_is_empty_and_appName_is_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: '' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.getContentTitle))(ArgumentMatchers.any).afterReturn('');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(true);

      const result = vm.getNtfTitle();
      expect(result).assertEqual(' ');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getContentTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });

    it('should_return_appName_when_title_is_empty', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.appName = { value: 'testApp' };
      let vm: NotificationSingleItemVM = new NotificationSingleItemVM(ntfEntry);
      let mocker: MockKit = new MockKit();
      when(mocker.mockFunc(vm, vm.isProtectedInScreenLocked))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.isHiddenBannerContent))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.ntfEntryIsExpandable))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(vm, vm.getContentTitle))(ArgumentMatchers.any).afterReturn('');
      when(mocker.mockFunc(CommonUtils, CommonUtils.isEmpty))(ArgumentMatchers.any).afterReturn(true);
      const result = vm.getNtfTitle();
      expect(result).assertEqual('testApp');
      mocker.ignoreMock(vm, vm.isProtectedInScreenLocked);
      mocker.ignoreMock(vm, vm.isHiddenBannerContent);
      mocker.ignoreMock(vm, vm.ntfEntryIsExpandable);
      mocker.ignoreMock(vm, vm.getContentTitle);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
    });
  });
}
