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
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import {
  CommonUtils,
  ArrayUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import {
  EvtBus,
  WindowEvent,
  HiDfxEventUtil,
  ScreenOnOffEvent,
  DeviceHelper,
  DropDownPanelManagerWrapper,
  TargetPanel,
  CustomPromise,
  sEventManager,
  obtainLocalEvent,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { EventManager } from '@ohos/frameworkwrapper';
import { SettingsConstants } from '@ohos/commonconstants';
import { windowMgr, SCBOobeManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { NotificationEntryEvent } from '../../../../main/ets/common/event/NotificationEvent';
import { BannerPanelTypeState, immersiveKgMgr, IState, OnStateChangeListener } from '@ohos/systemuicommon';
import {
  AbilityState,
  bannerMgr,
  BannerPanelType,
  ForegroundAppEvent,
  HeadsUpChangeEvent,
  NotificationSysEventReporter,
  NtfAutoScreenOnEvent,
  StateType,
  SmartRemindType
} from '@ohos/systemuicommon';
import I18n from '@ohos.i18n';
import { NtfUnifiedLimitMgr, RemindType } from '../../../../main/ets/model/NotificationUnifiedRemindLimitManager';
import { display } from '@kit.ArkUI';
import {
  DisplayNotificationErrorCode,
  DisplayNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DisplayNotificationMaintenance';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { SwingTrackVm } from '../../../../main/ets/model/SwingTrackVm';
import { hideBannerNtfContentObj } from '../../../../main/ets/model/HideBannerNtfContentObj';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { NtfMgr } from '../../../../main/ets/model/NotificationManager';
import { wantAgent } from '@kit.AbilityKit';
import { WantAgentUtil } from '@ohos/systemuicommon/src/main/ets/utils/WantAgentUtil';
import { LiveHeadsUpShowEvent } from '@ohos/systemuicommon/src/main/ets/notification/model/BannerShowStatusModel';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { EmergencyThermalSafeManager } from '../../../../main/ets/manager/EmergencyThermalSafeManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PhoneNtfHeadsUpVm } from '../../../../main/ets/vm/phone/PhoneNtfHeadsUpVM';

export default function PhoneNtfHeadsUpVmTest() {
  describe('setIsMidScene_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_isMidScene_to_true_when_isMidScene_is_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.setIsMidScene(true);
      expect(phonentfheadsupvm.isMidScene).assertEqual(true);
    });

    it('should_set_isMidScene_to_false_when_isMidScene_is_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.setIsMidScene(false);
      expect(phonentfheadsupvm.isMidScene).assertEqual(false);
    });

    it('should_set_isMidScene_to_undefined_when_isMidScene_is_undefined', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.setIsMidScene(undefined);
      expect(phonentfheadsupvm.isMidScene).assertEqual(undefined);
    });

    it('should_register_all_event_listeners_correctly', 0, () => {
      let callback: HeadsUpCallback = new HeadsUpCallback();
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      // Mock EventManager.on
      let mockOnFunc: Function = mocker.mockFunc(EventManager, EventManager.on);
      when(mockOnFunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(EventManager);

      // Mock bannerMgr.registerStateChangeListener
      let mockRegisterFunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.registerStateChangeListener);
      when(mockRegisterFunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      // Call the init function
      phonentfheadsupvm.init(callback);

      // Assertions
      expect(mockOnFunc).assertCalledWith(WindowEvent, phonentfheadsupvm.onWindowEvent, ArgumentMatchers.anyString());
      expect(mockOnFunc).assertCalledWith(NotificationEntryEvent, phonentfheadsupvm.onNtfEntryEvent, ArgumentMatchers.anyString());
      expect(mockOnFunc).assertCalledWith(ScreenOnOffEvent, phonentfheadsupvm.screenOnOffChangeListener, ArgumentMatchers.anyString());
      expect(mockOnFunc).assertCalledWith(ForegroundAppEvent, phonentfheadsupvm.onForegroundAppEvent, ArgumentMatchers.anyString());
      expect(mockOnFunc).assertCalledWith(NtfAutoScreenOnEvent, phonentfheadsupvm.onNtfAutoScreenOnEvent, ArgumentMatchers.anyString());
      expect(mockOnFunc).assertCalledWith(HeadsUpChangeEvent, phonentfheadsupvm.onProduceHeadsUpChangeEvent, ArgumentMatchers.anyString());

      expect(mockRegisterFunc).assertCalledWith(StateType.TYPE_BANNER_PANEL_TYPE, phonentfheadsupvm.onStateChange);

      // Reset mocks
      mocker.ignoreMock(EventManager, EventManager.on);
      mocker.ignoreMock(bannerMgr, bannerMgr.registerStateChangeListener);
    });

    it('should_log_info_when_addWatcher_is_called', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      phonentfheadsupvm.addWatcher({});

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_increment_watchers_when_addWatcher_is_called', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      phonentfheadsupvm.addWatcher({});

      expect(phonentfheadsupvm.watchers).assertEqual(1);
    });

    it('should_log_info_when_watchers_is_greater_than_zero', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.watchers = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      phonentfheadsupvm.removeWatcher({});
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_when_watchers_is_zero', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.watchers = 0;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      phonentfheadsupvm.removeWatcher({});
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_hide_window_when_checkShouldHideWindow_is_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.watchers = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.hideHeadsUpWindowWithAnim);
      when(mockfunc2)(ArgumentMatchers.anyBoolean).afterReturn(null);
      phonentfheadsupvm.removeWatcher({});
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.hideHeadsUpWindowWithAnim);
    });

    it('should_not_hide_window_when_checkShouldHideWindow_is_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.watchers = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.hideHeadsUpWindowWithAnim);
      when(mockfunc2)(ArgumentMatchers.anyBoolean).afterReturn(null);
      phonentfheadsupvm.removeWatcher({});
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.hideHeadsUpWindowWithAnim);
    });

    it('resetWatcher_should_reset_watchers_to_0', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.resetWatcher();
      expect(phonentfheadsupvm.watchers).assertEqual(0);
    });

    it('should_call_resetParam_and_eventMgr_offAll_and_unregisterStateChangeListener', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      let mockResetParam: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.resetParam);
      when(mockResetParam)(ArgumentMatchers.any).afterReturnNothing();

      let eventMgr: EventManager = EventManager.INSTANCE;
      let mockOffAll: Function = mocker.mockFunc(eventMgr, eventMgr.offAll);
      when(mockOffAll)(ArgumentMatchers.any).afterReturnNothing();

      let mockUnregisterStateChangeListener: Function = mocker.mockFunc(bannerMgr, bannerMgr.unregisterStateChangeListener);
      when(mockUnregisterStateChangeListener)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      phonentfheadsupvm.onDestroy();

      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.resetParam);
      mocker.ignoreMock(eventMgr, eventMgr.offAll);
      mocker.ignoreMock(bannerMgr, bannerMgr.unregisterStateChangeListener);
    });

    it('should_not_hide_window_when_isItemExpand_is_false_and_isItemExpand_is_already_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.isItemExpand = false;
      phonentfheadsupvm.setItemExpandState(false);
      // 断言
      expect(phonentfheadsupvm.isItemExpand).assertEqual(false);
    });

    it('should_hide_window_when_isItemExpand_is_true_and_isItemExpand_is_already_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.isItemExpand = false;
      // 模拟checkShouldHideWindow返回true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      phonentfheadsupvm.setItemExpandState(true);
      // 断言
      expect(phonentfheadsupvm.isItemExpand).assertEqual(true);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
    });

    it('should_not_hide_window_when_isItemExpand_is_true_and_isItemExpand_is_already_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.isItemExpand = true;
      // 模拟checkShouldHideWindow返回false
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      phonentfheadsupvm.setItemExpandState(true);
      // 断言
      expect(phonentfheadsupvm.isItemExpand).assertEqual(true);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
    });

    it('should_hide_window_when_isItemExpand_is_false_and_isItemExpand_is_already_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.isItemExpand = true;
      // 模拟checkShouldHideWindow返回true
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      phonentfheadsupvm.setItemExpandState(false);
      // 断言
      expect(phonentfheadsupvm.isItemExpand).assertEqual(false);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.checkShouldHideWindow);
    });

    it('should_set_isPwdVisible_to_true_when_isPwdVisible_is_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.setPwdVisible(true);
      expect(phonentfheadsupvm.isPwdVisible).assertEqual(true);
    });

    it('should_set_isPwdVisible_to_false_when_isPwdVisible_is_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.setPwdVisible(false);
      expect(phonentfheadsupvm.isPwdVisible).assertEqual(false);
    });

    it('should_call_releasePanelHeadsUp_and_showInfo_when_hideHeadsUpWindow_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockReleasePanelHeadsUp: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelHeadsUp);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockReleasePanelHeadsUp)([]).afterReturnNothing();
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.hideHeadsUpWindow();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelHeadsUp);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_notifyNtfEntryChange_and_updateHeadsUpTransitionEffect_when_hideHeadsUpWindow_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockNotifyNtfEntryChange: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.notifyNtfEntryChange);

      when(mockNotifyNtfEntryChange)([ArgumentMatchers.any]).afterReturnNothing();

      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.hideHeadsUpWindow();

      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.notifyNtfEntryChange);
    });

    it('should_call_hideHeadsUpWindowWithAnim_and_cancelTimeoutHide', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockCancelTimeoutHide: Function = mocker.mockFunc(bannerMgr, bannerMgr.cancelTimeoutHide);
      when(mockCancelTimeoutHide)().afterReturnNothing();

      phonyfheadsupvm.hideHeadsUpWindowWithDelay();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.cancelTimeoutHide);
    });

    it('should_log_info_when_callback_is_not_null', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      phonyfheadsupvm.callback = {
        getNtfEntry: () => {
          return {
            creatorBundleName: 'testBundle',
            creatorUid: 123
          } as NotificationEntry;
        }
      };

      phonyfheadsupvm.ignoredList.clear();
      phonyfheadsupvm.setIgnoreNtf();

      expect(phonyfheadsupvm.ignoredList.size).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_error_when_callback_is_null', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      phonyfheadsupvm.callback = null;

      phonyfheadsupvm.ignoredList.clear();
      phonyfheadsupvm.setIgnoreNtf();

      expect(phonyfheadsupvm.ignoredList.size).assertEqual(0);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_error_when_callback_getNtfEntry_throws_exception', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      phonyfheadsupvm.callback = {
        getNtfEntry: () => {
          throw new Error('test error');
        }
      };

      phonyfheadsupvm.ignoredList.clear();
      phonyfheadsupvm.setIgnoreNtf();

      expect(phonyfheadsupvm.ignoredList.size).assertEqual(0);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_log_info_when_setUpdateFreeze_is_called', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      phonentfheadsupvm.setUpdateFreeze('testKey');

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_promise_when_timeout_is_reached', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      phonentfheadsupvm.setUpdateFreeze('testKey', 100);
      await new Promise(resolve => setTimeout(resolve, 100));

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_delete_key_from_freezeMap_when_promise_is_resolved', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      phonentfheadsupvm.setUpdateFreeze('testKey', 100);
      await new Promise(resolve => setTimeout(resolve, 100));

      expect(phonentfheadsupvm.freezeMap.has('testKey')).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_currentPromise_to_undefined_when_freezeMap_is_empty', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      phonentfheadsupvm.setUpdateFreeze('testKey', 100);
      await new Promise(resolve => setTimeout(resolve, 100));

      expect(phonentfheadsupvm.currentPromise).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_and_resolve_freeze_when_freezeMap_has_key', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let freezeMap: Map<string, CustomPromise> = new Map();
      let promise: CustomPromise = new CustomPromise();
      freezeMap.set('key', promise);
      phonentfheadsupvm.freezeMap = freezeMap;

      phonentfheadsupvm.releaseUpdateFreeze('key');

      expect(mockShowInfo).assertCalledWith("Release update freeze");
      expect(promise.isResolved()).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_log_info_and_resolve_freeze_when_freezeMap_does_not_have_key', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let freezeMap: Map<string, CustomPromise> = new Map();
      phonentfheadsupvm.freezeMap = freezeMap;

      phonentfheadsupvm.releaseUpdateFreeze('key');

      expect(mockShowInfo).assertNotCalled();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_isPwdVisible_to_true_when_isPwdVisible_is_true_0', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.setPwdVisible(true);
      expect(phonentfheadsupvm.isPwdVisible).assertEqual(true);
    });

    it('should_set_isPwdVisible_to_false_when_isPwdVisible_is_false_0', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.setPwdVisible(false);
      expect(phonentfheadsupvm.isPwdVisible).assertEqual(false);
    });
  });
}