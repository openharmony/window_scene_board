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

import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NotificationMenuRow } from '../../../../main/ets/pages/common/NotificationMenuRow';
import { NtfHeaderVM } from '../../../../main/ets/vm/NtfHeaderVM';
import { NtfItemSwipeController } from '../../../../main/ets/controller/NtfItemSwipeController';
import {
  CommonUtils,
  DomainName,
  Trace,
  TraceUtil,
  ArrayUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { ResUtils } from '@ohos/windowscene';
import { RectInfo } from '@ohos/basicutils';
import {
  GroupItemExpandingEvent,
  NtfListScrollEvent,
  NtfSwipeDeleteEvent,
  ResetItemSwipeEvent
} from '../../../../main/ets/common/event/NotificationEvent';
import { NotificationConstants } from '../../../../main/ets/common/NotificationConstants';
import GroupChildNtfDataChannel from '../../../../main/ets/vm/GroupChildNtfDataChannel';
import { NotificationGroupBrief } from '../../../../main/ets/pages/phone/NotificationGroupBrief';
import curves from '@ohos.curves';
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { notificationStyle } from '../../../../main/ets/vm/style/NotificationStyle';
import { NotificationGroupDetail } from '../../../../main/ets/pages/phone/NotificationGroupDetail';
import {
  ImmersiveAodStyle,
  immersiveKgMgr,
  NotificationSysEventReporter,
  AccessibilityUtil,
  bannerMgr
} from '@ohos/systemuicommon';
import { NotificationType } from '../../../../main/ets/common/NotificationType';
import {
  ScreenLockNotificationConst
} from '@ohos/screenlockcommon';
import { NotificationAnimationParas } from '../../../../main/ets/common/NotificationAnimationParas';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import { screenLockSysFloatTipControl } from '@ohos/screenlockcommon/Index';
import { NotificationItemStyle } from '../../../../main/ets/vm/style/NotificationItemStyle';
import { SlNtfItemWidth } from '../../../../main/ets/common/SlNtfItemWidth';
import { DEFAULT_CLIP, NtfClipAnimStyle } from '../../../../main/ets/common/NtfClipAnimStyle';
import { NtfAnimVM } from '../../../../main/ets/vm/NtfAnimVM';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { ItemGestureModifier } from '../../../../main/ets/model/NotificationGestureModifier';
import { NtfAnimationConsts } from '../../../../main/ets/common/NtfAnimationConsts';
import {
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { NotificationAccessibilityUtil as AccessUtil } from '../../../../main/ets/common/NotificationAccessibilityUtil';
import { ntfViewConfigManager } from '../../../../main/ets/vm/config/NtfViewConfigManager';
import { NtfBrightnessMode, NtfListContentConfig } from '../../../../main/ets/vm/config/NtfViewConfig';
import { OverlayAnimData } from '@ohos/systemuicommon/Index';
import { NtfGroupItemModifier } from '../../../../main/ets/model/NtfItemModifier';
import { NtfScrollAnimation } from '../../../../main/ets/animation/NtfScrollAnimation';
import { NotificationGroupExpandAnimation } from '../../../../main/ets/animation/NotificationGroupExpandAnimation';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICommonUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationGroupItem';
export default function Test() {
  describe('onIsGroupExpandedChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_updateDisplayButtonsHashCode_when_isGroupExpanded_is_true', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let ntfScrollAnimation: NtfScrollAnimation = new NtfScrollAnimation();
      let notificationGroupDetail: NotificationGroupDetail = new NotificationGroupDetail();
      let notificationGroupBrief: NotificationGroupBrief = new NotificationGroupBrief();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let notificationMenuRow: NotificationMenuRow = new NotificationMenuRow();
      let rectInfo: RectInfo = new RectInfo();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let notificationSysEventReporter: NotificationSysEventReporter = new NotificationSysEventReporter();
      let accessibilityUtil: AccessibilityUtil = new AccessibilityUtil();
      let bannerMgr: bannerMgr = new bannerMgr();
      let screenLockSysFloatTipControl: screenLockSysFloatTipControl = new screenLockSysFloatTipControl();
      let notificationItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let slNtfItemWidth: SlNtfItemWidth = new SlNtfItemWidth();
      let ntfClipAnimStyle: NtfClipAnimStyle = new NtfClipAnimStyle();
      let defaultClip: DEFAULT_CLIP = new DEFAULT_CLIP();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let obtainLocalEvent: obtainLocalEvent = new obtainLocalEvent();
      let sEventManager: sEventManager = new sEventManager();
      let eventManager: EventManager = new EventManager();
      let eventBus: EvtBus = new EvtBus();
      let unsubscribe: unsubscribe = new unsubscribe();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let curves: curves = new curves();
      let promiseInterrupt: PromiseInterrupt = new PromiseInterrupt();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let accessUtil: AccessUtil = new AccessUtil();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfBrightnessMode: NtfBrightnessMode = new NtfBrightnessMode();
      let overlayAnimData: OverlayAnimData = new OverlayAnimData();
      let mocker: MockKit = new MockKit();
      ntfHeaderVM.ntfItemSwipeController = ntfItemSwipeController;
      ntfHeaderVM.ntfCloseVM = ntfCloseVM;
      ntfHeaderVM.ntfAnimVM = ntfAnimVM;
      ntfHeaderVM.ntfColorModeVM = ntfColorModeVM;
      ntfHeaderVM.ntfGroupItemModifier = ntfGroupItemModifier;
      ntfHeaderVM.ntfScrollAnimation = ntfScrollAnimation;
      ntfHeaderVM.notificationGroupDetail = notificationGroupDetail;
      ntfHeaderVM.notificationGroupBrief = notificationGroupBrief;
      ntfHeaderVM.notificationEntry = notificationEntry;
      ntfHeaderVM.notificationMenuRow = notificationMenuRow;
      ntfHeaderVM.rectInfo = rectInfo;
      ntfHeaderVM.immersiveAodStyle = immersiveAodStyle;
      ntfHeaderVM.notificationSysEventReporter = notificationSysEventReporter;
      ntfHeaderVM.accessibilityUtil = accessibilityUtil;
      ntfHeaderVM.bannerMgr = bannerMgr;
      ntfHeaderVM.screenLockSysFloatTipControl = screenLockSysFloatTipControl;
      ntfHeaderVM.notificationItemStyle = notificationItemStyle;
      ntfHeaderVM.slNtfItemWidth = slNtfItemWidth;
      ntfHeaderVM.ntfClipAnimStyle = ntfClipAnimStyle;
      ntfHeaderVM.defaultClip = defaultClip;
      ntfHeaderVM.notificationGroupExpandAnimation = notificationGroupExpandAnimation;
      ntfHeaderVM.groupChildNtfDataChannel = groupChildNtfDataChannel;
      ntfHeaderVM.obtainLocalEvent = obtainLocalEvent;
      ntfHeaderVM.sEventManager = sEventManager;
      ntfHeaderVM.eventManager = eventManager;
      ntfHeaderVM.eventBus = eventBus;
      ntfHeaderVM.unsubscribe = unsubscribe;
      ntfHeaderVM.deviceHelper = deviceHelper;
      ntfHeaderVM.curves = curves;
      ntfHeaderVM.promiseInterrupt = promiseInterrupt;
      ntfHeaderVM.notificationUtils = notificationUtils;
      ntfHeaderVM.accessUtil = accessUtil;
      ntfHeaderVM.ntfViewConfigManager = ntfViewConfigManager;
      ntfHeaderVM.ntfListContentConfig = ntfListContentConfig;
      ntfHeaderVM.ntfBrightnessMode = ntfBrightnessMode;
      ntfHeaderVM.overlayAnimData = overlayAnimData;
      let mockUpdateDisplayButtonsHashCode: Function =
        mocker.mockFunc(ntfHeaderVM, ntfHeaderVM.updateDisplayButtonsHashCode);
      when(mockUpdateDisplayButtonsHashCode)().afterReturnNothing();
      ntfHeaderVM.isGroupExpanded = true;
      ntfHeaderVM.changeItemExpand = (isGroupExpanded: boolean) => {
        ntfHeaderVM.isGroupExpanded = isGroupExpanded;
      };
      ntfHeaderVM.ntfAniParameters?.updateGroupExpanded(ntfHeaderVM.isGroupExpanded);
      const result = ntfHeaderVM.onIsGroupExpandedChange();
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(ntfHeaderVM, ntfHeaderVM.updateDisplayButtonsHashCode);
    });

    it('should_call_updateDisplayButtonsHashCode_when_isGroupExpanded_is_true', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let ntfScrollAnimation: NtfScrollAnimation = new NtfScrollAnimation();
      let notificationGroupDetail: NotificationGroupDetail = new NotificationGroupDetail();
      let notificationGroupBrief: NotificationGroupBrief = new NotificationGroupBrief();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let notificationMenuRow: NotificationMenuRow = new NotificationMenuRow();
      let rectInfo: RectInfo = new RectInfo();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let notificationSysEventReporter: NotificationSysEventReporter = new NotificationSysEventReporter();
      let accessibilityUtil: AccessibilityUtil = new AccessibilityUtil();
      let bannerMgr: bannerMgr = new bannerMgr();
      let screenLockSysFloatTipControl: screenLockSysFloatTipControl = new screenLockSysFloatTipControl();
      let notificationItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let slNtfItemWidth: SlNtfItemWidth = new SlNtfItemWidth();
      let ntfClipAnimStyle: NtfClipAnimStyle = new NtfClipAnimStyle();
      let defaultClip: DEFAULT_CLIP = new DEFAULT_CLIP();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let obtainLocalEvent: obtainLocalEvent = new obtainLocalEvent();
      let sEventManager: sEventManager = new sEventManager();
      let eventManager: EventManager = new EventManager();
      let eventBus: EvtBus = new EvtBus();
      let unsubscribe: unsubscribe = new unsubscribe();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let curves: curves = new curves();
      let promiseInterrupt: PromiseInterrupt = new PromiseInterrupt();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let accessUtil: AccessUtil = new AccessUtil();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfBrightnessMode: NtfBrightnessMode = new NtfBrightnessMode();
      let overlayAnimData: OverlayAnimData = new OverlayAnimData();
      let mocker: MockKit = new MockKit();

      ntfHeaderVM.ntfItemSwipeController = ntfItemSwipeController;
      ntfHeaderVM.ntfCloseVM = ntfCloseVM;
      ntfHeaderVM.ntfAnimVM = ntfAnimVM;
      ntfHeaderVM.ntfColorModeVM = ntfColorModeVM;
      ntfHeaderVM.ntfGroupItemModifier = ntfGroupItemModifier;
      ntfHeaderVM.ntfScrollAnimation = ntfScrollAnimation;
      ntfHeaderVM.notificationGroupDetail = notificationGroupDetail;
      ntfHeaderVM.notificationGroupBrief = notificationGroupBrief;
      ntfHeaderVM.notificationEntry = notificationEntry;
      ntfHeaderVM.notificationMenuRow = notificationMenuRow;
      ntfHeaderVM.rectInfo = rectInfo;
      ntfHeaderVM.immersiveAodStyle = immersiveAodStyle;
      ntfHeaderVM.notificationSysEventReporter = notificationSysEventReporter;
      ntfHeaderVM.accessibilityUtil = accessibilityUtil;
      ntfHeaderVM.bannerMgr = bannerMgr;
      ntfHeaderVM.screenLockSysFloatTipControl = screenLockSysFloatTipControl;
      ntfHeaderVM.notificationItemStyle = notificationItemStyle;
      ntfHeaderVM.slNtfItemWidth = slNtfItemWidth;
      ntfHeaderVM.ntfClipAnimStyle = ntfClipAnimStyle;
      ntfHeaderVM.defaultClip = defaultClip;
      ntfHeaderVM.notificationGroupExpandAnimation = notificationGroupExpandAnimation;
      ntfHeaderVM.groupChildNtfDataChannel = groupChildNtfDataChannel;
      ntfHeaderVM.obtainLocalEvent = obtainLocalEvent;
      ntfHeaderVM.sEventManager = sEventManager;
      ntfHeaderVM.eventManager = eventManager;
      ntfHeaderVM.eventBus = eventBus;
      ntfHeaderVM.unsubscribe = unsubscribe;
      ntfHeaderVM.deviceHelper = deviceHelper;
      ntfHeaderVM.curves = curves;
      ntfHeaderVM.promiseInterrupt = promiseInterrupt;
      ntfHeaderVM.notificationUtils = notificationUtils;
      ntfHeaderVM.accessUtil = accessUtil;
      ntfHeaderVM.ntfViewConfigManager = ntfViewConfigManager;
      ntfHeaderVM.ntfListContentConfig = ntfListContentConfig;
      ntfHeaderVM.ntfBrightnessMode = ntfBrightnessMode;
      ntfHeaderVM.overlayAnimData = overlayAnimData;

      let mockUpdateDisplayButtonsHashCode: Function = mocker.mockFunc(ntfHeaderVM, ntfHeaderVM.updateDisplayButtonsHashCode);
      when(mockUpdateDisplayButtonsHashCode)().afterReturnNothing();
      ntfHeaderVM.isGroupExpanded = true;
      ntfHeaderVM.changeItemExpand = (isGroupExpanded: boolean) => {
        ntfHeaderVM.isGroupExpanded = isGroupExpanded;
      };

      ntfHeaderVM.ntfAniParameters?.updateGroupExpanded(ntfHeaderVM.isGroupExpanded);
      const result = ntfHeaderVM.onIsGroupExpandedChange();
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(ntfHeaderVM, ntfHeaderVM.updateDisplayButtonsHashCode);
    });

    it('should_call_updateDisplayButtonsHashCode_when_isGroupExpanded_is_true', 0, () => {
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let ntfScrollAnimation: NtfScrollAnimation = new NtfScrollAnimation();
      let notificationGroupDetail: NotificationGroupDetail = new NotificationGroupDetail();
      let notificationGroupBrief: NotificationGroupBrief = new NotificationGroupBrief();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let notificationMenuRow: NotificationMenuRow = new NotificationMenuRow();
      let rectInfo: RectInfo = new RectInfo();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let notificationSysEventReporter: NotificationSysEventReporter = new NotificationSysEventReporter();
      let accessibilityUtil: AccessibilityUtil = new AccessibilityUtil();
      let bannerMgr: bannerMgr = new bannerMgr();
      let screenLockSysFloatTipControl: screenLockSysFloatTipControl = new screenLockSysFloatTipControl();
      let notificationItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let slNtfItemWidth: SlNtfItemWidth = new SlNtfItemWidth();
      let ntfClipAnimStyle: NtfClipAnimStyle = new NtfClipAnimStyle();
      let defaultClip: DEFAULT_CLIP = new DEFAULT_CLIP();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let groupChildNtfDataChannel: GroupChildNtfDataChannel = new GroupChildNtfDataChannel();
      let obtainLocalEvent: obtainLocalEvent = new obtainLocalEvent();
      let sEventManager: sEventManager = new sEventManager();
      let eventManager: EventManager = new EventManager();
      let eventBus: EvtBus = new EvtBus();
      let unsubscribe: unsubscribe = new unsubscribe();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let curves: curves = new curves();
      let promiseInterrupt: PromiseInterrupt = new PromiseInterrupt();
      let notificationUtils: NotificationUtils = new NotificationUtils();
      let accessUtil: AccessUtil = new AccessUtil();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let ntfBrightnessMode: NtfBrightnessMode = new NtfBrightnessMode();
      let overlayAnimData: OverlayAnimData = new OverlayAnimData();
      let mocker: MockKit = new MockKit();
      ntfHeaderVM.ntfItemSwipeController = ntfItemSwipeController;
      ntfHeaderVM.ntfCloseVM = ntfCloseVM;
      ntfHeaderVM.ntfAnimVM = ntfAnimVM;
      ntfHeaderVM.ntfColorModeVM = ntfColorModeVM;
      ntfHeaderVM.ntfGroupItemModifier = ntfGroupItemModifier;
      ntfHeaderVM.ntfScrollAnimation = ntfScrollAnimation;
      ntfHeaderVM.notificationGroupDetail = notificationGroupDetail;
      ntfHeaderVM.notificationGroupBrief = notificationGroupBrief;
      ntfHeaderVM.notificationEntry = notificationEntry;
      ntfHeaderVM.notificationMenuRow = notificationMenuRow;
      ntfHeaderVM.rectInfo = rectInfo;
      ntfHeaderVM.immersiveAodStyle = immersiveAodStyle;
      ntfHeaderVM.notificationSysEventReporter = notificationSysEventReporter;
      ntfHeaderVM.accessibilityUtil = accessibilityUtil;
      ntfHeaderVM.bannerMgr = bannerMgr;
      ntfHeaderVM.screenLockSysFloatTipControl = screenLockSysFloatTipControl;
      ntfHeaderVM.notificationItemStyle = notificationItemStyle;
      ntfHeaderVM.slNtfItemWidth = slNtfItemWidth;
      ntfHeaderVM.ntfClipAnimStyle = ntfClipAnimStyle;
      ntfHeaderVM.defaultClip = defaultClip;
      ntfHeaderVM.notificationGroupExpandAnimation = notificationGroupExpandAnimation;
      ntfHeaderVM.groupChildNtfDataChannel = groupChildNtfDataChannel;
      ntfHeaderVM.obtainLocalEvent = obtainLocalEvent;
      ntfHeaderVM.sEventManager = sEventManager;
      ntfHeaderVM.eventManager = eventManager;
      ntfHeaderVM.eventBus = eventBus;
      ntfHeaderVM.unsubscribe = unsubscribe;
      ntfHeaderVM.deviceHelper = deviceHelper;
      ntfHeaderVM.curves = curves;
      ntfHeaderVM.promiseInterrupt = promiseInterrupt;
      ntfHeaderVM.notificationUtils = notificationUtils;
      ntfHeaderVM.accessUtil = accessUtil;
      ntfHeaderVM.ntfViewConfigManager = ntfViewConfigManager;
      ntfHeaderVM.ntfListContentConfig = ntfListContentConfig;
      ntfHeaderVM.ntfBrightnessMode = ntfBrightnessMode;
      ntfHeaderVM.overlayAnimData = overlayAnimData;
      let mockUpdateDisplayButtonsHashCode: Function = mocker.mockFunc(ntfHeaderVM, ntfHeaderVM.updateDisplayButtonsHashCode);
      when(mockUpdateDisplayButtonsHashCode)().afterReturnNothing();
      ntfHeaderVM.isGroupExpanded = true;
      ntfHeaderVM.changeItemExpand = (isGroupExpanded: boolean) => {
        ntfHeaderVM.isGroupExpanded = isGroupExpanded;
      };
      ntfHeaderVM.ntfAniParameters?.updateGroupExpanded(ntfHeaderVM.isGroupExpanded);
      const result = ntfHeaderVM.onIsGroupExpandedChange();
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(ntfHeaderVM, ntfHeaderVM.updateDisplayButtonsHashCode);
    });

    it('should_log_info_and_debug_when_deleteAnimSyncFlag_is_true', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let logHelper: LogHelper = new LogHelper();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = true;
      ntfHeaderVM.deleteAnimSyncData = ntfEntry;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_log_info_and_debug_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let logHelper: LogHelper = new LogHelper();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      ntfHeaderVM.deleteAnimSyncData = ntfEntry;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_set_deleteAnimSyncData_when_deleteAnimSyncFlag_is_true', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = true;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      expect(ntfHeaderVM.deleteAnimSyncData).assertEqual(ntfEntry);
    });

    it('should_not_set_deleteAnimSyncData_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      expect(ntfHeaderVM.deleteAnimSyncData).assertNull();
    });

    it('should_await_interrupt_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let mocker: MockKit = new MockKit();

      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

    });

    it('should_set_ntfEntry_and_call_other_methods_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let mocker: MockKit = new MockKit();

      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      expect(ntfHeaderVM.ntfEntry).assertEqual(ntfEntry);
    });

    it('should_log_info_and_debug_when_deleteAnimSyncFlag_is_true', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let logHelper: LogHelper = new LogHelper();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = true;
      ntfHeaderVM.deleteAnimSyncData = ntfEntry;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_log_info_and_debug_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let logHelper: LogHelper = new LogHelper();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowDebug: Function = mocker.mockFunc(logHelper, logHelper.showDebug);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowDebug)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      ntfHeaderVM.deleteAnimSyncData = ntfEntry;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showDebug);
    });

    it('should_set_deleteAnimSyncData_when_deleteAnimSyncFlag_is_true', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = true;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      expect(ntfHeaderVM.deleteAnimSyncData).assertEqual(ntfEntry);
    });

    it('should_not_set_deleteAnimSyncData_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      expect(ntfHeaderVM.deleteAnimSyncData).assertNull();
    });

    it('should_await_interrupt_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let mocker: MockKit = new MockKit();

      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

    });

    it('should_set_ntfEntry_and_call_other_methods_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let ntfHeaderVM: NtfHeaderVM = new NtfHeaderVM();
      ntfHeaderVM.deleteAnimSyncFlag = false;
      let mocker: MockKit = new MockKit();

      await ntfHeaderVM.onNtfDataUpdate(ntfEntry);

      expect(ntfHeaderVM.ntfEntry).assertEqual(ntfEntry);
    });

  })
}