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
import apsManager from '@hms.graphic.apsManager';
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

    it('should_reset_values_when_ntfEntry_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = null;
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let headsUpSwipeYController: HeadsUpSwipeYController = new HeadsUpSwipeYController();
      let phoneNtfHeadsUpVm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mock setIsMidScene: Function = mocker.mockFunc(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      let mock updateFloatingWindowStatus: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      let mock updateMidScene: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);

      when(setIsMidScene)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(updateFloatingWindowStatus)([ArgumentMatchers.any]).afterReturnNothing();
      when(updateMidScene)([ArgumentMatchers.anyNumber]).afterReturnNothing();

      await ntfItemSwipeController.onNtfEntryChanged(ntfEntry, headsUpSwipeYController, phoneNtfHeadsUpVm);

      expect(phoneNtfHeadsUpVm.isDeformFlag).assertEqual(false);
      expect(phoneNtfHeadsUpVm.isInitParam).assertEqual(false);
      expect(phoneNtfHeadsUpVm.headsUpItemTranX).assertEqual(0);
      expect(phoneNtfHeadsUpVm.headsUpStyle.containerWidth).assertEqual(phoneNtfHeadsUpVm.headsUpStyle.itemWidth);
      expect(headsUpSwipeYController.isMidScene).assertEqual(false);

      mocker.ignoreMock(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);
    });

    it('should_update_values_when_ntfEntry_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let headsUpSwipeYController: HeadsUpSwipeYController = new HeadsUpSwipeYController();
      let phoneNtfHeadsUpVm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mock setIsMidScene: Function = mocker.mockFunc(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      let mock updateFloatingWindowStatus: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      let mock updateMidScene: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);

      when(setIsMidScene)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(updateFloatingWindowStatus)([ArgumentMatchers.any]).afterReturnNothing();
      when(updateMidScene)([ArgumentMatchers.anyNumber]).afterReturnNothing();

      await ntfItemSwipeController.onNtfEntryChanged(ntfEntry, headsUpSwipeYController, phoneNtfHeadsUpVm);

      expect(phoneNtfHeadsUpVm.touchOperLock).assertEqual(false);
      expect(headsUpSwipeYController.isMidScene).assertEqual(true);

      mocker.ignoreMock(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);
    });

    it('should_reset_values_when_ntfEntry_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = null;
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let headsUpSwipeYController: HeadsUpSwipeYController = new HeadsUpSwipeYController();
      let phoneNtfHeadsUpVm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mock setIsMidScene: Function = mocker.mockFunc(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      let mock updateFloatingWindowStatus: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      let mock updateMidScene: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);

      when(setIsMidScene)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(updateFloatingWindowStatus)([ArgumentMatchers.any]).afterReturnNothing();
      when(updateMidScene)([ArgumentMatchers.anyNumber]).afterReturnNothing();

      await ntfItemSwipeController.onNtfEntryChanged(ntfEntry, headsUpSwipeYController, phoneNtfHeadsUpVm);

      expect(phoneNtfHeadsUpVm.isDeformFlag).assertEqual(false);
      expect(phoneNtfHeadsUpVm.isInitParam).assertEqual(false);
      expect(phoneNtfHeadsUpVm.headsUpItemTranX).assertEqual(0);
      expect(phoneNtfHeadsUpVm.headsUpStyle.containerWidth).assertEqual(phoneNtfHeadsUpVm.headsUpStyle.itemWidth);
      expect(headsUpSwipeYController.isMidScene).assertEqual(false);

      mocker.ignoreMock(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);
    });

    it('should_update_values_when_ntfEntry_is_not_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let headsUpSwipeYController: HeadsUpSwipeYController = new HeadsUpSwipeYController();
      let phoneNtfHeadsUpVm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mock setIsMidScene: Function = mocker.mockFunc(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      let mock updateFloatingWindowStatus: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      let mock updateMidScene: Function = mocker.mockFunc(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);

      when(setIsMidScene)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(updateFloatingWindowStatus)([ArgumentMatchers.any]).afterReturnNothing();
      when(updateMidScene)([ArgumentMatchers.anyNumber]).afterReturnNothing();

      await ntfItemSwipeController.onNtfEntryChanged(ntfEntry, headsUpSwipeYController, phoneNtfHeadsUpVm);

      expect(phoneNtfHeadsUpVm.touchOperLock).assertEqual(false);
      expect(headsUpSwipeYController.isMidScene).assertEqual(true);

      mocker.ignoreMock(phoneNtfHeadsUpVm, phoneNtfHeadsUpVm.setIsMidScene);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateFloatingWindowStatus);
      mocker.ignoreMock(headsUpSwipeYController, headsUpSwipeYController.updateMidScene);
    });

    it('should_calculate_default_floating_rect_when_is_pad_layout', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockIsPadLayout: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isPadLayout);
      when(mockIsPadLayout)().afterReturn(true);
      let mockGetDsHelper: Function = mocker.mockFunc(DBUtils, DBUtils.INSTANCE.getDsHelper);
      when(mockGetDsHelper)().afterReturn({ getDisplayWidth: () => 1080, getDisplayHeight: () => 1920 });

      let mockGetImmersiveState: Function = mocker.mockFunc(baseStateMgr, baseStateMgr.getBaseState);
      when(mockGetImmersiveState)(ArgumentMatchers.any).afterReturn({ isImmersive: false });

      let mockIsWidestScreen: Function = mocker.mockFunc(DisplaySizeState, DisplaySizeState.isWidestScreen);
      when(mockIsWidestScreen)().afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockSCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let mockSCBScreenSessionManager: SCBScreenSessionManager = new SCBScreenSessionManager();
      let mockTimeoutPromise: TimeoutPromise = new TimeoutPromise();
      let mockAnimDataScene: AnimDataScene = new AnimDataScene();
      let mockLiveAnimScene: LiveAnimScene = new LiveAnimScene();
      let mockAPSSceneState: APSSceneState = new APSSceneState();
      let mockLiveUseScene: LiveUseScene = new LiveUseScene();

      let mockBannerDeformState: BannerDeformState = new BannerDeformState();
      let mockBannerStyleState: BannerStyleState = new BannerStyleState();
      let mockBannerPanelTypeState: BannerPanelTypeState = new BannerPanelTypeState();
      let mockBannerState: BannerState = new BannerState();
      let mockNtfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mockHeadsUpSwipeYController: HeadsUpSwipeYController = new HeadsUpSwipeYController();
      let mockNotificationEntry: NotificationEntry = new NotificationEntry();
      let mockPhoneNtfHeadsUpVm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mockNotificationConfig: NotificationConfig = new NotificationConfig();
      let mockNtfMgr: NtfMgr = new NtfMgr();
      let mockNtfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let mockColorModeViewData: ColorModeViewData = new ColorModeViewData();
      let mockColorModeViewModel: ColorModeViewModel = new ColorModeViewModel();
      let mockEventBroadcast: EventBroadcast = new EventBroadcast();
      let mockOhterCardExtendAnimVm: OhterCardExtendAnimVm = new OhterCardExtendAnimVm();
      let mockProgressCardAnimVm: ProgressCardAnimVm = new ProgressCardAnimVm();
      let mockNtfCloseVM: NtfCloseVM = new NtfCloseVM();
      let mockNotificationSysEventReporter: NotificationSysEventReporter = new NotificationSysEventReporter();
      let mockNtfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let mockNtfViewConfigManager: NtfViewConfigManager = new NtfViewConfigManager();
      let mockItemGestureModifier: ItemGestureModifier = new ItemGestureModifier();
      let mockAccessibilityUtil: AccessibilityUtil = new AccessibilityUtil();
      let mockSystemUICcmConfig: SystemUICcmConfig = new SystemUICcmConfig();
      let mockColorModeLiveViewData: ColorModeLiveViewData = new ColorModeLiveViewData();
      let mockColorModeNCViewData: ColorModeNCViewData = new ColorModeNCViewData();
      let mockNtfThemeActiveMgr: NtfThemeActiveMgr = new NtfThemeActiveMgr();

      let mockBannerHeadsUpContent: BannerHeadsUpContent = new BannerHeadsUpContent();
      mockBannerHeadsUpContent.initDeformParam(100);

      mocker.ignoreMock(LayoutUtils, LayoutUtils.isPadLayout);
      mocker.ignoreMock(DBUtils, DBUtils.INSTANCE.getDsHelper);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.getBaseState);
      mocker.ignoreMock(DisplaySizeState, DisplaySizeState.isWidestScreen);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    
    it('should_calculate_default_floating_rect_when_is_pad_layout', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockIsPadLayout: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isPadLayout);
      when(mockIsPadLayout)().afterReturn(true);
      let mockGetDsHelper: Function = mocker.mockFunc(DBUtils, DBUtils.INSTANCE.getDsHelper);
      when(mockGetDsHelper)().afterReturn({ getDisplayWidth: () => 1080, getDisplayHeight: () => 1920 });

      let mockGetImmersiveState: Function = mocker.mockFunc(baseStateMgr, baseStateMgr.getBaseState);
      when(mockGetImmersiveState)(ArgumentMatchers.any).afterReturn({ isImmersive: false });

      let mockIsWidestScreen: Function = mocker.mockFunc(DisplaySizeState, DisplaySizeState.isWidestScreen);
      when(mockIsWidestScreen)().afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockSCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let mockSCBScreenSessionManager: SCBScreenSessionManager = new SCBScreenSessionManager();
      let mockTimeoutPromise: TimeoutPromise = new TimeoutPromise();
      let mockAnimDataScene: AnimDataScene = new AnimDataScene();
      let mockLiveAnimScene: LiveAnimScene = new LiveAnimScene();
      let mockAPSSceneState: APSSceneState = new APSSceneState();
      let mockLiveUseScene: LiveUseScene = new LiveUseScene();

      let mockBannerDeformState: BannerDeformState = new BannerDeformState();
      let mockBannerStyleState: BannerStyleState = new BannerStyleState();
      let mockBannerPanelTypeState: BannerPanelTypeState = new BannerPanelTypeState();
      let mockBannerState: BannerState = new BannerState();
      let mockNtfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mockHeadsUpSwipeYController: HeadsUpSwipeYController = new HeadsUpSwipeYController();
      let mockNotificationEntry: NotificationEntry = new NotificationEntry();
      let mockPhoneNtfHeadsUpVm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mockNotificationConfig: NotificationConfig = new NotificationConfig();
      let mockNtfMgr: NtfMgr = new NtfMgr();
      let mockNtfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let mockColorModeViewData: ColorModeViewData = new ColorModeViewData();
      let mockColorModeViewModel: ColorModeViewModel = new ColorModeViewModel();
      let mockEventBroadcast: EventBroadcast = new EventBroadcast();
      let mockOhterCardExtendAnimVm: OhterCardExtendAnimVm = new OhterCardExtendAnimVm();
      let mockProgressCardAnimVm: ProgressCardAnimVm = new ProgressCardAnimVm();
      let mockNtfCloseVM: NtfCloseVM = new NtfCloseVM();
      let mockNotificationSysEventReporter: NotificationSysEventReporter = new NotificationSysEventReporter();
      let mockNtfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let mockNtfViewConfigManager: NtfViewConfigManager = new NtfViewConfigManager();
      let mockItemGestureModifier: ItemGestureModifier = new ItemGestureModifier();
      let mockAccessibilityUtil: AccessibilityUtil = new AccessibilityUtil();
      let mockSystemUICcmConfig: SystemUICcmConfig = new SystemUICcmConfig();
      let mockColorModeLiveViewData: ColorModeLiveViewData = new ColorModeLiveViewData();
      let mockColorModeNCViewData: ColorModeNCViewData = new ColorModeNCViewData();
      let mockNtfThemeActiveMgr: NtfThemeActiveMgr = new NtfThemeActiveMgr();

      let mockBannerHeadsUpContent: BannerHeadsUpContent = new BannerHeadsUpContent();
      mockBannerHeadsUpContent.initDeformParam(100);

      mocker.ignoreMock(LayoutUtils, LayoutUtils.isPadLayout);
      mocker.ignoreMock(DBUtils, DBUtils.INSTANCE.getDsHelper);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.getBaseState);
      mocker.ignoreMock(DisplaySizeState, DisplaySizeState.isWidestScreen);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_calculate_default_floating_rect_when_is_pad_layout', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockIsPadLayout: Function = mocker.mockFunc(LayoutUtils, LayoutUtils.isPadLayout);
      when(mockIsPadLayout)().afterReturn(true);
      let mockGetDsHelper: Function = mocker.mockFunc(DBUtils, DBUtils.INSTANCE.getDsHelper);
      when(mockGetDsHelper)().afterReturn({ getDisplayWidth: () => 1080, getDisplayHeight: () => 1920 });

      let mockGetImmersiveState: Function = mocker.mockFunc(baseStateMgr, baseStateMgr.getBaseState);
      when(mockGetImmersiveState)(ArgumentMatchers.any).afterReturn({ isImmersive: false });

      let mockIsWidestScreen: Function = mocker.mockFunc(DisplaySizeState, DisplaySizeState.isWidestScreen);
      when(mockIsWidestScreen)().afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.any).afterReturnNothing();

      let mockSCBSceneSessionManager: SCBSceneSessionManager = new SCBSceneSessionManager();
      let mockSCBScreenSessionManager: SCBScreenSessionManager = new SCBScreenSessionManager();
      let mockTimeoutPromise: TimeoutPromise = new TimeoutPromise();
      let mockAnimDataScene: AnimDataScene = new AnimDataScene();
      let mockLiveAnimScene: LiveAnimScene = new LiveAnimScene();
      let mockAPSSceneState: APSSceneState = new APSSceneState();
      let mockLiveUseScene: LiveUseScene = new LiveUseScene();

      let mockBannerDeformState: BannerDeformState = new BannerDeformState();
      let mockBannerStyleState: BannerStyleState = new BannerStyleState();
      let mockBannerPanelTypeState: BannerPanelTypeState = new BannerPanelTypeState();
      let mockBannerState: BannerState = new BannerState();
      let mockNtfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mockHeadsUpSwipeYController: HeadsUpSwipeYController = new HeadsUpSwipeYController();
      let mockNotificationEntry: NotificationEntry = new NotificationEntry();
      let mockPhoneNtfHeadsUpVm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mockNotificationConfig: NotificationConfig = new NotificationConfig();
      let mockNtfMgr: NtfMgr = new NtfMgr();
      let mockNtfSingleItemVM: NtfSingleItemVM = new NtfSingleItemVM();
      let mockColorModeViewData: ColorModeViewData = new ColorModeViewData();
      let mockColorModeViewModel: ColorModeViewModel = new ColorModeViewModel();
      let mockEventBroadcast: EventBroadcast = new EventBroadcast();
      let mockOhterCardExtendAnimVm: OhterCardExtendAnimVm = new OhterCardExtendAnimVm();
      let mockProgressCardAnimVm: ProgressCardAnimVm = new ProgressCardAnimVm();
      let mockNtfCloseVM: NtfCloseVM = new NtfCloseVM();
      let mockNotificationSysEventReporter: NotificationSysEventReporter = new NotificationSysEventReporter();
      let mockNtfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let mockNtfViewConfigManager: NtfViewConfigManager = new NtfViewConfigManager();
      let mockItemGestureModifier: ItemGestureModifier = new ItemGestureModifier();
      let mockAccessibilityUtil: AccessibilityUtil = new AccessibilityUtil();
      let mockSystemUICcmConfig: SystemUICcmConfig = new SystemUICcmConfig();
      let mockColorModeLiveViewData: ColorModeLiveViewData = new ColorModeLiveViewData();
      let mockColorModeNCViewData: ColorModeNCViewData = new ColorModeNCViewData();
      let mockNtfThemeActiveMgr: NtfThemeActiveMgr = new NtfThemeActiveMgr();

      let mockBannerHeadsUpContent: BannerHeadsUpContent = new BannerHeadsUpContent();
      mockBannerHeadsUpContent.initDeformParam(100);

      mocker.ignoreMock(LayoutUtils, LayoutUtils.isPadLayout);
      mocker.ignoreMock(DBUtils, DBUtils.INSTANCE.getDsHelper);
      mocker.ignoreMock(baseStateMgr, baseStateMgr.getBaseState);
      mocker.ignoreMock(DisplaySizeState, DisplaySizeState.isWidestScreen);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

  });

}
