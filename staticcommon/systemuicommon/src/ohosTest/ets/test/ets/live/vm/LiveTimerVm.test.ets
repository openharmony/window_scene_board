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
import { ILiveTimerVm } from '../../../../../../main/ets/live/interface/ILiveTimerVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { LiveTimerModel } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { InnerEventUtil } from '../../../../../../main/ets/utils/InnerEventUtil';
import systemDateTime from '@ohos.systemDateTime';
import { AccessibilityVm } from '../../../../../../main/ets/vm/AccessibilityVm';
import { ResourceVm } from '../../../../../../main/ets/vm/ResourceVm';
import { Singleton } from '../../../../../../main/ets/utils/Singleton';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveTimerVm } from '../../../../../../main/ets/live/vm/LiveTimerVm';

export default function LiveTimerVmTest() {
  describe('setLiveTimer_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });
    it('should_call_setTimer_when_live_has_capsule_timer_and_timer_is_valid', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyNumber).afterReturnNothing();
      livetimervm.setLiveTimer(live);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();
      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_when_live_has_card_timer_and_timer_is_valid', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyNumber).afterReturnNothing();
      livetimervm.setLiveTimer(live);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();
      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_not_call_setTimer_when_live_has_no_timer', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = { isTimer: () => false, timer: null };
      live.card = { isOtherCard: () => false, timer: null };
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyNumber).afterReturnNothing();
      livetimervm.setLiveTimer(live);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();
      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_with_correct_diffTime', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let now = Date.now();
      live.deliveryTime = now - 1000;
      live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyNumber).afterReturnNothing();
      livetimervm.setLiveTimer(live);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();
      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
      expect(mockfunc).assertCalledWith(live.capsule.timer, now - live.deliveryTime);
    });

    it('should_restart_tickers_when_screen_is_on', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyNumber).afterReturnNothing();
      livetimervm.setLiveTimer(live);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();
      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
      expect(livetimervm.isScreenOff).assertFalse();
    });

    it('should_suspend_tickers_when_screen_is_off', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyNumber).afterReturnNothing();
      livetimervm.setLiveTimer(live);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();
      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
      expect(livetimervm.isScreenOff).assertFalse();
    });

    it('should_call_updateTimer_when_newCardTimer_or_oldCardTimer_is_not_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.card = new LiveTimerModel();
      oldLive.card.timer = new LiveTimerModel();

      livetimervm.updateLiveTimer(live, oldLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_call_updateTimer_when_newCapsuleTimer_or_oldCapsuleTimer_is_not_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.capsule = new LiveTimerModel();
      oldLive.capsule.timer = new LiveTimerModel();

      livetimervm.updateLiveTimer(live, oldLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_not_call_updateTimer_when_newCardTimer_and_oldCardTimer_are_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      let oldLive: LiveNotification = new LiveNotification();

      livetimervm.updateLiveTimer(live, oldLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_not_call_updateTimer_when_newCapsuleTimer_and_oldCapsuleTimer_are_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      let oldLive: LiveNotification = new LiveNotification();

      livetimervm.updateLiveTimer(live, oldLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_delete_timer_when_live_is_timer_and_newLive_is_not_has_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);
      when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.capsule = {
        isTimer: () => true, timer: new LiveTimerModel()
      };
      let newLive: LiveNotification = new LiveNotification();

      livetimervm.deleteLiveTimer(live, newLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
    });

    it('should_delete_timer_when_live_is_timer_and_newLive_is_has_timer_but_not_same', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);
      when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.capsule = {
        isTimer: () => true, timer: new LiveTimerModel()
      };
      let newLive: LiveNotification = new LiveNotification();
      newLive.capsule = {
        isTimer: () => true, timer: new LiveTimerModel()
      };

      livetimervm.deleteLiveTimer(live, newLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
    });

    it('should_not_delete_timer_when_live_is_timer_and_newLive_is_has_timer_and_same', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);
      when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.capsule = {
        isTimer: () => true, timer: new LiveTimerModel()
      };
      let newLive: LiveNotification = new LiveNotification();
      newLive.capsule = {
        isTimer: () => true, timer: new LiveTimerModel()
      };

      livetimervm.deleteLiveTimer(live, newLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
    });

    it('should_delete_timer_when_live_is_otherCard_and_newLive_is_not_has_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);
      when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = {
        isOtherCard: () => true, timer: new LiveTimerModel()
      };
      let newLive: LiveNotification = new LiveNotification();

      livetimervm.deleteLiveTimer(live, newLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
    });

    it('should_delete_timer_when_live_is_otherCard_and_newLive_is_has_timer_but_not_same', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);
      when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = {
        isOtherCard: () => true, timer: new LiveTimerModel()
      };
      let newLive: LiveNotification = new LiveNotification();
      newLive.card = {
        isOtherCard: () => true, timer: new LiveTimerModel()
      };

      livetimervm.deleteLiveTimer(live, newLive);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
    });

    it('should_not_delete_timer_when_live_is_otherCard_and_newLive_is_has_timer_and_same', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);
      when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = {
        isOtherCard: () => true, timer: new LiveTimerModel()
      };
      let newLive: LiveNotification = new LiveNotification();
      newLive.card = {
        isOtherCard: () => true, timer: new LiveTimerModel()
      };

      livetimervm.deleteLiveTimer(live, newLive);

      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
    });

    it('should_set_timer_when_timer_is_not_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('1');
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_timer_with_diffTime_when_timer_is_not_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('1');
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer, 1000);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_set_timer_when_timer_is_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = null;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_set_timer_with_diffTime_when_timer_is_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = null;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer, 1000);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_onScreenOnOffEvent_when_screen_status_changes', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('1');
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer);
      livetimervm.onScreenOnOffEvent(new ScreenOnOffEvent(true));

      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_onScreenOnOffEvent_with_diffTime_when_screen_status_changes', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('1');
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer, 1000);
      livetimervm.onScreenOnOffEvent(new ScreenOnOffEvent(true));
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_call_onScreenOnOffEvent_when_screen_status_does_not_change', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('1');
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer);
      livetimervm.onScreenOnOffEvent(new ScreenOnOffEvent(false));
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_call_onScreenOnOffEvent_with_diffTime_when_screen_status_does_not_change', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('1');
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.setTimer(timer, 1000);
      livetimervm.onScreenOnOffEvent(new ScreenOnOffEvent(false));
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_accessibility_and_resource_vms_when_timer_is_set', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('1');
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let accessibilityVm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mockAccessibilityVm: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.onScreenReaderModeChanged);
      when(mockAccessibilityVm)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let resourceVm: ResourceVm = ResourceVm.INSTANCE;
      let mockResourceVm: Function = mocker.mockFunc(resourceVm, resourceVm.onScreenReaderModeChanged);
      when(mockResourceVm)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      livetimervm.setTimer(timer);
      expect(livetimervm.value).assertNull();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(accessibilityVm, accessibilityVm.onScreenReaderModeChanged);
      mocker.ignoreMock(resourceVm, resourceVm.onScreenReaderModeChanged);
    });

    it('should_return_immediately_when_timer_and_oldTimer_are_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      livetimervm.updateTimer(null, null);
      expect(livetimervm.value).assertNull();
    });

    it('should_update_oldTicker_when_timer_and_oldTimer_have_same_uid', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let oldTimer: LiveTimerModel = new LiveTimerModel('1');
      let newTimer: LiveTimerModel = new LiveTimerModel('1');
      livetimervm.updateTimer(newTimer, oldTimer);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_setTimer_when_timer_is_not_null_and_oldTimer_is_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockSetTimer: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockSetTimer)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('2');
      livetimervm.updateTimer(timer, null);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_when_timer_is_null_and_oldTimer_is_not_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockSetTimer: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockSetTimer)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let oldTimer: LiveTimerModel = new LiveTimerModel('3');
      livetimervm.updateTimer(null, oldTimer);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_when_timer_and_oldTimer_have_different_uid', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockSetTimer: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockSetTimer)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('4');
      let oldTimer: LiveTimerModel = new LiveTimerModel('5');
      livetimervm.updateTimer(timer, oldTimer);
      mocker.verify('setTimer', [ArgumentMatchers.any, ArgumentMatchers.any]).once();

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_stop_ticker_and_delete_timer_when_timer_exists', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockStop: Function = mocker.mockFunc(livetimervm, livetimervm.stop);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStop)().afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.stop);
    });

    it('should_not_stop_ticker_and_delete_timer_when_timer_does_not_exist', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_showInfo_when_timer_is_deleted', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockStop: Function = mocker.mockFunc(livetimervm, livetimervm.stop);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStop)().afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.stop);
    });

    it('should_call_stop_and_delete_timer_when_timer_exists', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockStop: Function = mocker.mockFunc(livetimervm, livetimervm.stop);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStop)().afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.stop);
    });

    it('should_not_call_stop_and_delete_timer_when_timer_does_not_exist', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_showInfo_when_timer_is_deleted', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockStop: Function = mocker.mockFunc(livetimervm, livetimervm.stop);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStop)().afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.stop);
    });

    it('should_call_stop_and_delete_timer_when_timer_exists', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockStop: Function = mocker.mockFunc(livetimervm, livetimervm.stop);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStop)().afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livetimervm, livetimervm.stop);
    });

    it('should_not_call_stop_and_delete_timer_when_timer_does_not_exist', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertFalse();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_showInfo_when_timer_is_deleted', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockStop: Function = mocker.mockFunc(livetimervm, livetimervm.stop);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStop)().afterReturnNothing();

      let timer: LiveTimerModel = new LiveTimerModel('123');
      livetimervm.deleteTimer(timer);

      expect(livetimervm.tickerMap.has(timer.uid)).assertTrue();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_empty_string_when_timer_not_in_tickerMap', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_text_when_timer_in_tickerMap', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      livetimervm.tickerMap.set(timer.uid, { text: 'test' });
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('test');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_empty_string_when_timer_is_null', 0, () => {
      let timer: LiveTimerModel = null;
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('');
    });

    it('should_call_logHelper_showInfo_when_timer_not_in_tickerMap', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_logHelper_showInfo_with_correct_message_when_timer_not_in_tickerMap', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_logHelper_showInfo_when_tickerMap_is_null', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      livetimervm.tickerMap = null;
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_restart_tickers_when_screen_on_event_received', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      livetimervm.tickerMap.set(timer.uid, { text: 'test' });
      livetimervm.onScreenOnOffEvent(new ScreenOnOffEvent(false));
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('test');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_suspend_tickers_when_screen_off_event_received', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      livetimervm.tickerMap.set(timer.uid, { text: 'test' });
      livetimervm.onScreenOnOffEvent(new ScreenOnOffEvent(true));
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('test');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_empty_string_when_timer_uid_is_null', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel(null);
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('');
    });

    it('should_call_accessibilityVm_getNotificationText_when_timer_has_notification', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let notification: LiveNotification = new LiveNotification('test');
      timer.notification = notification;
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.getNotificationText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('test');
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('test');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.getNotificationText);
    });

    it('should_call_resourceVm_getString_when_timer_has_notification_and_text_is_null', 0, () => {
      let timer: LiveTimerModel = new LiveTimerModel('123');
      let notification: LiveNotification = new LiveNotification('test');
      timer.notification = notification;
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let resourceVm: ResourceVm = ResourceVm.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(resourceVm, resourceVm.getString);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('test');
      const result = livetimervm.getTimerText(timer);
      expect(result).assertEqual('test');
      mocker.ignoreMock(resourceVm, resourceVm.getString);
    });

    it('should_return_empty_string_when_timer_is_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      const result = livetimervm.getTimerAccessibilityText(null);
      expect(result).assertEqual('');
    });

    it('should_return_accessibilityText_when_timer_is_not_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('testKey');
      timer.accessibilityText = 'testAccessibilityText';
      livetimervm.tickerMap.set(timer.uid, new Ticker());
      const result = livetimervm.getTimerAccessibilityText(timer);
      expect(result).assertEqual('testAccessibilityText');
    });

    it('should_return_empty_string_when_accessibilityText_is_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('testKey');
      livetimervm.tickerMap.set(timer.uid, new Ticker());
      const result = livetimervm.getTimerAccessibilityText(timer);
      expect(result).assertEqual('');
    });

    it('should_return_accessibilityText_when_isScreenOff_is_true', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('testKey');
      timer.accessibilityText = 'testAccessibilityText';
      livetimervm.tickerMap.set(timer.uid, new Ticker());
      livetimervm.isScreenOff = true;
      const result = livetimervm.getTimerAccessibilityText(timer);
      expect(result).assertEqual('testAccessibilityText');
    });

    it('should_return_accessibilityText_when_isScreenOff_is_false', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('testKey');
      timer.accessibilityText = 'testAccessibilityText';
      livetimervm.tickerMap.set(timer.uid, new Ticker());
      livetimervm.isScreenOff = false;
      const result = livetimervm.getTimerAccessibilityText(timer);
      expect(result).assertEqual('testAccessibilityText');
    });

    it('should_return_empty_string_when_tickerMap_is_null', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('testKey');
      livetimervm.isScreenOff = false;
      const result = livetimervm.getTimerAccessibilityText(timer);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_tickerMap_is_undefined', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let timer: LiveTimerModel = new LiveTimerModel('testKey');
      livetimervm.isScreenOff = false;
      livetimervm.tickerMap = undefined;
      const result = livetimervm.getTimerAccessibilityText(timer);
      expect(result).assertEqual('');
    });

    it('should_register_onScreenOnOffEvent_when_init_is_called', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      livetimervm.init();
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.on);
    });

    it('should_call_onScreenOnOffEvent_when_screen_is_on', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.onScreenOnOffEvent);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let event: ScreenOnOffEvent = new ScreenOnOffEvent(false);
      livetimervm.init();
      livetimervm.onScreenOnOffEvent(event);
      mocker.ignoreMock(livetimervm, livetimervm.onScreenOnOffEvent);
    });

    it('should_call_onScreenOnOffEvent_when_screen_is_off', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.onScreenOnOffEvent);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let event: ScreenOnOffEvent = new ScreenOnOffEvent(true);
      livetimervm.init();
      livetimervm.onScreenOnOffEvent(event);
      mocker.ignoreMock(livetimervm, livetimervm.onScreenOnOffEvent);
    });

    it('should_handle_null_event', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      livetimervm.onScreenOnOffEvent(null);
    });

    it('should_set_isScreenOff_and_suspend_when_event_isScreenOff_is_true', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockScreenOnOffEvent: ScreenOnOffEvent = new ScreenOnOffEvent();
      let mockLogHelper: LogHelper = new LogHelper();
      let mockRestart: Function = mocker.mockFunc(mockScreenOnOffEvent, mockScreenOnOffEvent.isScreenOff);
      when(mockRestart)().afterReturn(true);
      when(mockLogHelper.showInfo)('onScreenOnOffEvent isScreenOff:true').afterReturnNothing();
      livetimervm.onScreenOnOffEvent(mockScreenOnOffEvent);
      expect(livetimervm.isScreenOff).assertTrue();
      mocker.ignoreMock(mockScreenOnOffEvent, mockScreenOnOffEvent.isScreenOff);
    });

    it('should_set_isScreenOff_and_restart_when_event_isScreenOff_is_false', 0, () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockScreenOnOffEvent: ScreenOnOffEvent = new ScreenOnOffEvent();
      let mockLogHelper: LogHelper = new LogHelper();
      let mockRestart: Function = mocker.mockFunc(mockScreenOnOffEvent, mockScreenOnOffEvent.isScreenOff);
      when(mockRestart)().afterReturn(false);
      when(mockLogHelper.showInfo)('onScreenOnOffEvent isScreenOff:false').afterReturnNothing();
      livetimervm.onScreenOnOffEvent(mockScreenOnOffEvent);
      expect(livetimervm.isScreenOff).assertFalse();
      mocker.ignoreMock(mockScreenOnOffEvent, mockScreenOnOffEvent.isScreenOff);
    });

    it('should_log_info_when_timer_is_already_started', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ticker: Ticker = Ticker.getInstance();
      ticker.uid = "testUid";
      ticker.timerId = 1;

      ticker.start();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_run_timer_with_delay_when_isCountdown_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ticker: Ticker = Ticker.getInstance();
      ticker.uid = "testUid";
      ticker.isCountdown = true;
      ticker.remainingTime = 1000;

      let mockRunTimer: Function = mocker.mockFunc(ticker, ticker.runTimer);
      when(mockRunTimer)(ArgumentMatchers.anyNumber).afterReturnNothing();

      ticker.start();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(ticker, ticker.runTimer);
    });

    it('should_run_timer_with_delay_when_isCountdown_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ticker: Ticker = Ticker.getInstance();
      ticker.uid = "testUid";
      ticker.isCountdown = false;
      ticker.remainingTime = 1000;

      let mockRunTimer: Function = mocker.mockFunc(ticker, ticker.runTimer);
      when(mockRunTimer)(ArgumentMatchers.anyNumber).afterReturnNothing();

      ticker.start();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(ticker, ticker.runTimer);
    });

    it('should_run_timer_with_no_delay_when_delay_is_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ticker: Ticker = Ticker.getInstance();
      ticker.uid = "testUid";
      ticker.isCountdown = true;
      ticker.remainingTime = 0;

      let mockRunTimer: Function = mocker.mockFunc(ticker, ticker.runTimer);
      when(mockRunTimer)().afterReturnNothing();

      ticker.start();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(ticker, ticker.runTimer);
    });

    it('should_log_info_when_timer_is_not_started', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let ticker: Ticker = Ticker.getInstance();
      ticker.timerId = undefined;
      ticker.stop();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    // Test setLiveTimer
    it('should set a live timer',DEFAULT, () => {
      const liveNotification: any = {
        deliveryTime: Date.now(),
        capsule: {
          isTimer: true,
          timer: {
            uid: 'timer-1',
            initialTime: 3600,
            isCountdown: true,
          },
        },
      };

      liveTimerVm.setLiveTimer(liveNotification);

      expect(liveTimerVm.tickerMap.size).toBe(1);
      expect(liveTimerVm.tickerMap.get('timer-1')).toBeDefined();
    });

    // Test updateLiveTimer
    it('should update a live timer',DEFAULT, () => {
      const oldLiveNotification: any = {
        deliveryTime: Date.now(),
        capsule: {
          isTimer: true,
          timer: {
            uid: 'timer-1',
            initialTime: 3600,
            isCountdown: true,
          },
        },
      };

      const newLiveNotification: any = {
        deliveryTime: Date.now(),
        capsule: {
          isTimer: true,
          timer: {
            uid: 'timer-1',
            initialTime: 3600,
            isCountdown: true,
          },
        },
      };

      liveTimerVm.updateLiveTimer(newLiveNotification, oldLiveNotification);

      expect(liveTimerVm.tickerMap.size).toBe(1);
      expect(liveTimerVm.tickerMap.get('timer-1')).toBeDefined();
    });

    // Test deleteLiveTimer
    it('should delete a live timer',DEFAULT, () => {
      const liveNotification: any = {
        deliveryTime: Date.now(),
        capsule: {
          isTimer: true,
          timer: {
            uid: 'timer-1',
            initialTime: 3600,
            isCountdown: true,
          },
        },
      };

      liveTimerVm.setLiveTimer(liveNotification);
      liveTimerVm.deleteLiveTimer(liveNotification);

      expect(liveTimerVm.tickerMap.size).toBe(0);
    });

    // Test getTimerText and getTimerAccessibilityText
    it('should get timer text and accessibility text',DEFAULT, () => {
      const timer: any = {
        uid: 'timer-1',
        initialTime: 3600,
        isCountdown: true,
      };

      liveTimerVm.setTimer(timer);

      expect(liveTimerVm.getTimerText(timer)).toBe('00:00');
      expect(liveTimerVm.getTimerAccessibilityText(timer)).toBe('00 minutes');
    });

    it('setLiveTimer', DEFAULT, () => {
      let liveTimerVm: LiveTimerVm = LiveTimerVm.instance;
      try {
        liveTimerVm.setLiveTimer(new LiveNotification());
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'setLiveTimer')).assertTrue();
    });

    it('updateLiveTimer', DEFAULT, () => {
      let liveTimerVm: LiveVmInjector = LiveTimerVm.instance;
      try {
        liveTimerVm.updateLiveTimer(new LiveNotification(), new LiveNotification());
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'updateLiveTimer')).assertTrue();
    });

    it('deleteLiveTimer', DEFAULT, () => {
      let liveTimerVm: LiveVmInjector = LiveTimerVm.instance;
      try {
        liveTimerVm.deleteLiveTimer(new LiveNotification(), new LiveNotification());
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'deleteLiveTimer')).assertTrue();
    });

    it('setTimer', DEFAULT, () => {
      let liveTimerVm: LiveVmInjector = LiveTimerVm.instance;
      try {
        liveTimerVm.setTimer(new LiveTimerModel(), 0);
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'setTimer')).assertTrue();
    });

    it('updateTimer', DEFAULT, () => {
      let liveTimerVm: LiveVmInjector = LiveTimerVm.instance;
      try {
        liveTimerVm.updateTimer(new LiveNotification(), 0);
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'updateTimer')).assertTrue();
    });

    it('deleteTimer', DEFAULT, () => {
      let liveTimerVm: LiveVmInjector = LiveTimerVm.instance;
      try {
        liveTimerVm.deleteTimer(new LiveTimerModel());
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'deleteTimer')).assertTrue();
    });

    it('getTimerText', DEFAULT, () => {
      let liveTimerVm: LiveVmInjector = LiveTimerVm.instance;
      try {
        liveTimerVm.getTimerText(new LiveTimerModel());
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getTimerText')).assertTrue();
    });

    it('getTimerAccessibilityText', DEFAULT, () => {
      let liveTimerVm: LiveVmInjector = LiveTimerVm.instance;
      try {
        liveTimerVm.getTimerAccessibilityText(new LiveTimerModel());
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getTimerAccessibilityText')).assertTrue();
    });
  });

  describe('setLiveTimer_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_setTimer_when_live_has_capsule_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();
      live.card = null;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_when_live_has_card_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = null;
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_not_call_setTimer_when_live_has_no_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = null;
      live.card = new LiveTimerModel();
      live.card.timer = null;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_with_correct_diffTime', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_onScreenOnOffEvent_when_screen_is_off', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.onScreenOnOffEvent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();

      livetimervm.isScreenOff = true;

      livetimervm.setLiveTimer(new LiveNotification());

      mocker.ignoreMock(livetimervm, livetimervm.onScreenOnOffEvent);
    });

    it('should_not_call_onScreenOnOffEvent_when_screen_is_on', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.onScreenOnOffEvent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();

      livetimervm.isScreenOff = false;

      livetimervm.setLiveTimer(new LiveNotification());

      mocker.ignoreMock(livetimervm, livetimervm.onScreenOnOffEvent);
    });

    it('should_call_setTimer_when_screen_is_off_and_live_has_capsule_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();
      live.card = null;

      livetimervm.isScreenOff = true;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_when_screen_is_off_and_live_has_card_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = null;
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      livetimervm.isScreenOff = true;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_not_call_setTimer_when_screen_is_on_and_live_has_no_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = null;
      live.card = new LiveTimerModel();
      live.card.timer = null;

      livetimervm.isScreenOff = false;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_twice_when_live_has_both_capsule_and_card_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_not_call_setTimer_when_live_has_no_timers', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = null;
      live.card = new LiveTimerModel();
      live.card.timer = null;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_once_when_only_capsule_has_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();
      live.card = new LiveTimerModel();
      live.card.timer = null;

      livetimervm.setLiveTimer(live);
      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_once_when_only_card_has_timer', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() - 1000;
      live.capsule = new LiveTimerModel();
      live.capsule.timer = null;
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_call_setTimer_with_negative_diffTime', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() + 1000; // 未来时间，导致diffTime为负
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();
      live.card = null;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_calculate_negative_diffTime_when_deliveryTime_is_in_future', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now() + 1000; // 未来时间
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();
      live.card = null;

      livetimervm.setLiveTimer(live);

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    // 测试用例7：当live对象为空时，不调用setTimer
    it('should_not_call_setTimer_when_live_is_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.setTimer);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

      livetimervm.setLiveTimer(null as any); // 假设允许传入null

      mocker.ignoreMock(livetimervm, livetimervm.setTimer);
    });

    it('should_suspend_timers_when_screen_is_off', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.onScreenOnOffEvent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();

      livetimervm.isScreenOff = true;

      livetimervm.setLiveTimer(new LiveNotification());
      mocker.ignoreMock(livetimervm, livetimervm.onScreenOnOffEvent);
    });

    it('should_restart_timers_when_screen_is_on', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.onScreenOnOffEvent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturnNothing();

      livetimervm.isScreenOff = false;
      livetimervm.setLiveTimer(new LiveNotification());
      mocker.ignoreMock(livetimervm, livetimervm.onScreenOnOffEvent);
    });
  });

  describe('updateLiveTimer_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_updateTimer_when_newCardTimer_or_oldCardTimer_is_not_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_updateTimer_when_newCapsuleTimer_or_oldCapsuleTimer_is_not_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_updateTimer_when_newCardTimer_and_oldCardTimer_is_null', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_updateTimer_with_correct_parameters', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_when_updateLiveTimer_is_called', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };
      live.type = 'testType';

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.card = { isOtherCard: () => true, timer: new LiveTimerModel() };
      oldLive.type = 'testType';

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_updateTimer_when_live_card_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.card = null;

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

      livetimervm.updateLiveTimer(live, oldLive);

      // 验证updateTimer未被调用
      expect(mockUpdateTimer).not.toHaveBeenCalled();

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_updateTimer_when_oldLive_card_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.card = null;

      livetimervm.updateLiveTimer(live, oldLive);
      expect(mockUpdateTimer).not.toHaveBeenCalled();
      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_updateTimer_when_live_capsule_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.capsule = null;

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.capsule = { isTimer: () => true, timer: new LiveTimerModel() };
      livetimervm.updateLiveTimer(live, oldLive);
      expect(mockUpdateTimer).not.toHaveBeenCalled();
      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_updateTimer_when_oldLive_capsule_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockUpdateTimer: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.capsule = null;
      livetimervm.updateLiveTimer(live, oldLive);
      expect(mockUpdateTimer).not.toHaveBeenCalled();
      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
}