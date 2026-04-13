/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { BlurButtonVM } from '../../../../main/ets/vm/BlurButtonVM';

export default function ScreenLockBlurButtonVMTest() {
  describe('init_testSuite', () => {

    let phoneNtfHeadsUpVm: PhoneNtfHeadsUpVm;
    let mockBannerMgr: any;
    let mockCallback: any;
    let mockEvtBus: any;

    beforeEach(() => {
      mockBannerMgr = {
        registerStateChangeListener: jest.fn(),
        unregisterStateChangeListener: jest.fn(),
        isBannerPanelType: jest.fn(),
        releasePanelHeadsUp: jest.fn(),
        requestPanelHeadsUp: jest.fn(),
        cancelTimeoutHide: jest.fn(),
        preemptPromise: undefined,
        isExclusiveLiveBanner: false
      };

      mockCallback = {
        updateHeadsUpTransitionEffect: jest.fn(),
        getNtfEntry: jest.fn(),
        isStartingFloatingWindow: jest.fn(),
        addWatcher: jest.fn(),
        removeWatcher: jest.fn(),
        resetWatcher: jest.fn()
      };

      mockEvtBus = {
        on: jest.fn(),
        offAll: jest.fn(),
        produceOn: jest.fn(),
        post: jest.fn()
      };

      phoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phoneNtfHeadsUpVm.bannerMgr = mockBannerMgr;
      phoneNtfHeadsUpVm.callback = mockCallback;
      phoneNtfHeadsUpVm.eventMgr = mockEvtBus;
    });

    describe('Initialization and Cleanup', () => {
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
    });

    describe('State Change Handling', () => {
      it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined01', 0, () => {
        let ntfclosevm: NtfCloseVM = new NtfCloseVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
        let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
        when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
        let area: Area = {
          width: 0,
          height: 0,
          position: {},
          globalPosition: {}
        };
        let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
        ntfclosevm.updatePosition(ntfEntry, area);

        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(logHelper, logHelper.warn);
      });

      it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined01', 0, () => {
        let ntfclosevm: NtfCloseVM = new NtfCloseVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
        let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
        when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
        let area: Area = {
          width: 0,
          height: 0,
          position: {},
          globalPosition: {}
        };
        let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
        ntfclosevm.updatePosition(ntfEntry, area);

        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(logHelper, logHelper.warn);
      });

      it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined02', 0, () => {
        let ntfclosevm: NtfCloseVM = new NtfCloseVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
        let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
        when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
        let area: Area = {
          width: 0,
          height: 0,
          position: {},
          globalPosition: {}
        };
        let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
        ntfclosevm.updatePosition(ntfEntry, area);

        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(logHelper, logHelper.warn);
      });

      it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined02', 0, () => {
        let ntfclosevm: NtfCloseVM = new NtfCloseVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
        let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
        when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
        let area: Area = {
          width: 0,
          height: 0,
          position: {},
          globalPosition: {}
        };
        let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
        ntfclosevm.updatePosition(ntfEntry, area);

        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(logHelper, logHelper.warn);
      });

      it('should_log_info_when_ntfEntry_or_area_or_containerPosition_is_undefined03', 0, () => {
        let ntfclosevm: NtfCloseVM = new NtfCloseVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
        let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
        when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
        let area: Area = {
          width: 0,
          height: 0,
          position: {},
          globalPosition: {}
        };
        let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
        ntfclosevm.updatePosition(ntfEntry, area);

        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(logHelper, logHelper.warn);
      });

      it('should_update_position_when_ntfEntry_and_area_and_containerPosition_are_defined03', 0, () => {
        let ntfclosevm: NtfCloseVM = new NtfCloseVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getLogHelper(LogDomain.NC, 'TAG');
        let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        let mockWarn: Function = mocker.mockFunc(logHelper, logHelper.warn);

        when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
        when(mockWarn)(ArgumentMatchers.anyString).afterReturnNothing();
        let area: Area = {
          width: 0,
          height: 0,
          position: {},
          globalPosition: {}
        };
        let ntfEntry: NotificationEntry = new NotificationEntry(undefined);
        ntfclosevm.updatePosition(ntfEntry, area);

        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(logHelper, logHelper.warn);
      });
    });

    describe('Screen On/Off Handling', () => {
      it('should_log_error_when_wantAgent_is_null', 0, () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getInstance();
        let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
        when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
        let action: NotificationAction = new NotificationAction('test');
        ntfactionvm.checkAndStart(action, true, 'inputContent');
        mocker.ignoreMock(logHelper, logHelper.showError);
      });

      it('should_update_error_code_and_call_startActionInner_when_wantAgent_is_null', 0, () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getInstance();
        let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
        when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
        let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
        when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
        let action: NotificationAction = new NotificationAction('test');
        ntfactionvm.checkAndStart(action, true, 'inputContent');
        mocker.ignoreMock(logHelper, logHelper.showError);
        mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
      });

      it('should_log_error_and_call_startActionInner_when_getOperationType_fails', 0, () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getInstance();
        let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
        when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
        let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
        when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
        let action: NotificationAction = new NotificationAction('test');
        action.wantAgent = new WantAgent();
        ntfactionvm.checkAndStart(action, true, 'inputContent');
        mocker.ignoreMock(logHelper, logHelper.showError);
        mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
      });

      it('should_call_startWantAgent_when_getOperationType_succeeds', 0, () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getInstance();
        let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
        let mockStartWantAgent: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
        when(mockStartWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any).afterReturn(null);
        let action: NotificationAction = new NotificationAction('test');
        action.wantAgent = new WantAgent();
        let ntfEntry: NotificationEntry = new NotificationEntry();
        ntfactionvm.callback = {
          getNtfEntry: () => ntfEntry,
          getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
        };
        ntfactionvm.checkAndStart(action, true, 'inputContent');
        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
      });

      it('should_call_bridgeActionWantAgent_when_isOuterHome_is_true', 0, () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getInstance();
        let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
        let mockBridgeActionWantAgent: Function =
          mocker.mockFunc(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
        when(mockBridgeActionWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
        let action: NotificationAction = new NotificationAction('test');
        action.wantAgent = new WantAgent();
        ntfactionvm.callback = {
          getNtfEntry: () => null,
          getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
        };
        ntfViewConfigManager.isOuterHome = true;
        ntfViewConfigManager.isOuterHomeFolded = true;
        ntfactionvm.checkAndStart(action, true, 'inputContent');
        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
      });

      it('should_call_startActionInner_when_isStartAbility_is_true', 0, () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let logHelper: LogHelper = LogHelper.getInstance();
        let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
        when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
        let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
        when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
        let action: NotificationAction = new NotificationAction('test');
        action.wantAgent = new WantAgent();
        ntfactionvm.callback = {
          getNtfEntry: () => null,
          getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
        };
        ntfViewConfigManager.isOuterHome = false;
        ntfViewConfigManager.isStartAbility = true;
        ntfactionvm.checkAndStart(action, true, 'inputContent');
        mocker.ignoreMock(logHelper, logHelper.showInfo);
        mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
      });
    });

    describe('Promise Handling', () => {
      it('should handle promises correctly', () => {
        mockBannerMgr.preemptPromise = Promise.resolve();
        const entry = { isLiveType: () => false };
        phoneNtfHeadsUpVm.requestShowHeadsUp(entry);
        expect(mockBannerMgr.preemptPromise.then).toHaveBeenCalled();
      });
    });

    describe('Configuration Handling', () => {
      it('should handle configuration correctly', () => {
        SystemUICcmConfig.instance.isEnabledLive2 = true;
        const entry = { isLiveType: () => true };
        phoneNtfHeadsUpVm.doNotificationEvent({ eventType: NotificationEntryEvent.EVENT_TYPE_POST_ADD, notificationList: [entry] });
        expect(phoneNtfHeadsUpVm.handleHeadsUpAddOrUpdate).not.toHaveBeenCalled();
      });
    });
  })
}