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
import { CommonUtils, ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
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

export default function Test() {
  describe('onStateChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_reset_param_when_state_is_banner_panel_type_and_panel_is_live_list', 0, () => {
      let state: IState = new BannerPanelTypeState();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(state, state.getStateType))(ArgumentMatchers.any)
        .afterReturn(StateType.TYPE_BANNER_PANEL_TYPE);
      when(mocker.mockFunc(state, state.isPanelLiveList))(ArgumentMatchers.any).afterReturn(true);

      onStateChange(state);

      expect(this.resetParam).toHaveBeenCalled();

    });

    it('should_not_reset_param_when_state_is_banner_panel_type_and_panel_is_not_live_list', 0, () => {
      let state: IState = new BannerPanelTypeState();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(state, state.getStateType))(ArgumentMatchers.any)
        .afterReturn(StateType.TYPE_BANNER_PANEL_TYPE);
      when(mocker.mockFunc(state, state.isPanelLiveList))(ArgumentMatchers.any).afterReturn(false);

      onStateChange(state);

      expect(this.resetParam).not.toHaveBeenCalled();

    });

    it('should_set_timeout_when_state_is_banner_panel_type_and_panel_is_not_heads_up', 0, () => {
      let state: IState = new BannerPanelTypeState();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(state, state.getStateType))(ArgumentMatchers.any)
        .afterReturn(StateType.TYPE_BANNER_PANEL_TYPE);
      when(mocker.mockFunc(state, state.isPanelLiveList))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(state, state.isPanelHeadsUp))(ArgumentMatchers.any).afterReturn(false);

      onStateChange(state);

      expect(setTimeout).toHaveBeenCalled();

    });

    it('should_not_set_timeout_when_state_is_banner_panel_type_and_panel_is_heads_up', 0, () => {
      let state: IState = new BannerPanelTypeState();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(state, state.getStateType))(ArgumentMatchers.any)
        .afterReturn(StateType.TYPE_BANNER_PANEL_TYPE);
      when(mocker.mockFunc(state, state.isPanelLiveList))(ArgumentMatchers.any).afterReturn(false);
      when(mocker.mockFunc(state, state.isPanelHeadsUp))(ArgumentMatchers.any).afterReturn(true);

      onStateChange(state);

      expect(setTimeout).not.toHaveBeenCalled();

    });

    it('should_return_immediately_when_isOuterHome_is_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
      when(mockfunc)().afterReturn(false);
      phonentfheadsupvm.isOuterHome = false;
      phonentfheadsupvm.isScreenOff = false;
      phonentfheadsupvm.hasHeadsUpToShow = true;
      phonentfheadsupvm.showHeadsUpWindowScreenOn();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
    });

    it('should_return_immediately_when_isFoldExpandedOrHalf_is_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
      when(mockfunc)().afterReturn(true);
      phonentfheadsupvm.isOuterHome = true;
      phonentfheadsupvm.isScreenOff = false;
      phonentfheadsupvm.hasHeadsUpToShow = true;
      phonentfheadsupvm.showHeadsUpWindowScreenOn();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
    });

    it('should_return_immediately_when_isScreenOff_is_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
      when(mockfunc)().afterReturn(false);
      phonentfheadsupvm.isOuterHome = true;
      phonentfheadsupvm.isScreenOff = true;
      phonentfheadsupvm.hasHeadsUpToShow = true;
      phonentfheadsupvm.showHeadsUpWindowScreenOn();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
    });

    it('should_return_immediately_when_hasHeadsUpToShow_is_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
      when(mockfunc)().afterReturn(false);
      phonentfheadsupvm.isOuterHome = true;
      phonentfheadsupvm.isScreenOff = false;
      phonentfheadsupvm.hasHeadsUpToShow = false;
      phonentfheadsupvm.showHeadsUpWindowScreenOn();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
    });

    it('should_log_info_when_all_conditions_are_met', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc2)('show headsUp on screenOn').afterReturnNothing();
      phonentfheadsupvm.isOuterHome = true;
      phonentfheadsupvm.isScreenOff = false;
      phonentfheadsupvm.hasHeadsUpToShow = true;
      phonentfheadsupvm.showHeadsUpWindowScreenOn();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpandedOrHalf);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_and_call_hideHeadsUpWindowWithAnim_when_app_is_foreground', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockState: ForegroundAppEvent = {
        bundleNames: ['com.example.app'],
        switchAbilityState: AbilityState.ABILITY_STATE_FOREGROUND
      };

      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();

      when(mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType))(ArgumentMatchers.any).afterReturn(true);

      when(mocker.mockFunc(bannerMgr, bannerMgr.cancelTimeoutHide))(ArgumentMatchers.any).afterReturnNothing();

      await phonentfheadsupvm.onForegroundAppEvent(mockState);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
      mocker.ignoreMock(bannerMgr, bannerMgr.cancelTimeoutHide);
    });

    it('should_not_call_hideHeadsUpWindowWithAnim_when_app_is_not_foreground', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockState: ForegroundAppEvent = {
        bundleNames: ['com.example.app'],
        switchAbilityState: AbilityState.ABILITY_STATE_BACKGROUND
      };

      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();

      when(mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType))(ArgumentMatchers.any).afterReturn(false);

      await phonentfheadsupvm.onForegroundAppEvent(mockState);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    });

    it('should_not_call_hideHeadsUpWindowWithAnim_when_bundleNames_is_empty', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockState: ForegroundAppEvent = {
        bundleNames: [],
        switchAbilityState: AbilityState.ABILITY_STATE_FOREGROUND
      };

      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();

      when(mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType))(ArgumentMatchers.any).afterReturn(true);

      await phonentfheadsupvm.onForegroundAppEvent(mockState);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
    });

    it('should_not_call_hideHeadsUpWindowWithAnim_when_bundleNames_does_not_include_headsUpEvent_bundleName', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        let mockState: ForegroundAppEvent = {
          bundleNames: ['com.example.app2'],
          switchAbilityState: AbilityState.ABILITY_STATE_FOREGROUND
        };

        let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
        when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();

        when(mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType))(ArgumentMatchers.any).afterReturn(true);

        await phonentfheadsupvm.onForegroundAppEvent(mockState);

        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
      });

    it('should_call_hideHeadsUpWindowWithAnim_when_app_is_foreground_and_checkIsStartingFloatingWindow_returns_true', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let logHelperMock: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        let mockState: ForegroundAppEvent = {
          bundleNames: ['com.example.app'],
          switchAbilityState: AbilityState.ABILITY_STATE_FOREGROUND
        };

        let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
        when(logHelperMock)(ArgumentMatchers.anyString).afterReturnNothing();

        when(mocker.mockFunc(bannerMgr, bannerMgr.isBannerPanelType))(ArgumentMatchers.any).afterReturn(true);

        when(mocker.mockFunc(bannerMgr, bannerMgr.cancelTimeoutHide))(ArgumentMatchers.any).afterReturnNothing();

        when(mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.checkIsStartingFloatingWindow))(ArgumentMatchers.any)
          .afterReturn(true);

        await phonentfheadsupvm.onForegroundAppEvent(mockState);

        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        mocker.ignoreMock(bannerMgr, bannerMgr.isBannerPanelType);
        mocker.ignoreMock(bannerMgr, bannerMgr.cancelTimeoutHide);
        mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.checkIsStartingFloatingWindow);
      });

    it('should_return_false_when_callback_is_null', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.callback = null;
      const result = phonentfheadsupvm.checkIsStartingFloatingWindow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_callback_is_not_null_but_returns_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.callback = {
        isStartingFloatingWindow: () => false
      };
      const result = phonentfheadsupvm.checkIsStartingFloatingWindow();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_callback_is_not_null_and_returns_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.callback = {
        isStartingFloatingWindow: () => true
      };
      const result = phonentfheadsupvm.checkIsStartingFloatingWindow();
      expect(result).assertEqual(true);
    });

    it('should_log_info_and_call_updateHeadsUpTransitionEffect_when_hideHeadsUpWindow_is_called', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockUpdateHeadsUpTransitionEffect: Function =
        mocker.mockFunc(phonyfheadsupvm, phonyfheadsupvm.callback?.updateHeadsUpTransitionEffect);
      when(mockUpdateHeadsUpTransitionEffect)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      phonyfheadsupvm.hideHeadsUpWindow();

      expect(mockShowInfo).assertCalledWith('hide banner without anim');
      expect(mockUpdateHeadsUpTransitionEffect).assertCalledWith(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(phonyfheadsupvm, phonyfheadsupvm.callback?.updateHeadsUpTransitionEffect);
    });

    it('should_call_notifyNtfEntryChange_and_updateHeadsUpTransitionEffect_when_hideHeadsUpWindow_is_called', 0,
      async () => {
        let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
        let mocker: MockKit = new MockKit();
        let mockNotifyNtfEntryChange: Function = mocker.mockFunc(phonyfheadsupvm, phonyfheadsupvm.notifyNtfEntryChange);
        when(mockNotifyNtfEntryChange)(ArgumentMatchers.any).afterReturnNothing();

        let mockUpdateHeadsUpTransitionEffect: Function =
          mocker.mockFunc(phonyfheadsupvm, phonyfheadsupvm.callback?.updateHeadsUpTransitionEffect);
        when(mockUpdateHeadsUpTransitionEffect)().afterReturnNothing();

        phonyfheadsupvm.hideHeadsUpWindow();

        expect(mockNotifyNtfEntryChange).assertCalled();
        expect(mockUpdateHeadsUpTransitionEffect).assertCalled();

        mocker.ignoreMock(phonyfheadsupvm, phonyfheadsupvm.notifyNtfEntryChange);
        mocker.ignoreMock(phonyfheadsupvm, phonyfheadsupvm.callback?.updateHeadsUpTransitionEffect);
      });

    it('should_call_releasePanelHeadsUp_when_hideHeadsUpWindow_is_called', 0, async () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();
      let mockReleasePanelHeadsUp: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelHeadsUp);
      when(mockReleasePanelHeadsUp)().afterReturnNothing();

      phonyfheadsupvm.hideHeadsUpWindow();

      expect(mockReleasePanelHeadsUp).assertCalled();

      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelHeadsUp);
    });

    it('should_return_headsUpEvent_when_headsUpEvent_is_not_null', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isNotificationEnabled);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(undefined);


      let result = phonentfheadsupvm.onProduceHeadsUpChangeEvent();
      expect(result).assertNotNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.isNotificationEnabled);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_return_immediately_when_hashCode_equals', 0, () => {
      let entry: NotificationEntry = new NotificationEntry({});
      entry.hashCode = 123;
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.headsUpEvent.hashCode = 123;
      phonentfheadsupvm.postHeadsUpChangeEvent(entry);
      // 对比横幅hash变化，则发送事件
      expect(phonentfheadsupvm.headsUpEvent.hashCode).assertEqual(123);
      expect(phonentfheadsupvm.headsUpEvent.bundleName).assertUndefined();
    });

    it('should_update_headsUpEvent_when_hashCode_not_equals', 0, () => {
      let entry: NotificationEntry = new NotificationEntry({});
      entry.hashCode = 456;
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phonentfheadsupvm.headsUpEvent.hashCode = 123;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EvtBus, EvtBus.post);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      phonentfheadsupvm.postHeadsUpChangeEvent(entry);
      // 对比横幅hash变化，则发送事件
      expect(phonentfheadsupvm.headsUpEvent.hashCode).assertEqual(456);
      expect(phonentfheadsupvm.headsUpEvent.bundleName).assertUndefined();
      mocker.ignoreMock(EvtBus, EvtBus.post);
    });

    it('should_return_false_when_isItemExpanded_is_true', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
      when(mockfunc)().afterReturn(true);

      let result = phonentfheadsupvm.checkShouldHideWindowTimeout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
    });

    it('should_return_false_when_isAutoCancel_is_false', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
      when(mockfunc)().afterReturn(false);

      let mockfunc2: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.needCancelHeadsUp);
      when(mockfunc2)().afterReturn(false);

      let result = phonentfheadsupvm.checkShouldHideWindowTimeout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.needCancelHeadsUp);
    });

    it('should_return_false_when_watchers_is_greater_than_0', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
      when(mockfunc)().afterReturn(false);

      let mockfunc2: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.needCancelHeadsUp);
      when(mockfunc2)().afterReturn(true);

      phonentfheadsupvm.watchers = 1;

      let result = phonentfheadsupvm.checkShouldHideWindowTimeout();
      expect(result).assertEqual(false);

      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.needCancelHeadsUp);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let phonentfheadsupvm: PhoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
      when(mockfunc)().afterReturn(false);

      let mockfunc2: Function = mocker.mockFunc(phonentfheadsupvm, phonentfheadsupvm.needCancelHeadsUp);
      when(mockfunc2)().afterReturn(true);

      phonentfheadsupvm.watchers = 0;

      let result = phonentfheadsupvm.checkShouldHideWindowTimeout();
      expect(result).assertEqual(true);

      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.isItemExpanded);
      mocker.ignoreMock(phonentfheadsupvm, phonentfheadsupvm.needCancelHeadsUp);
    });
  });
}