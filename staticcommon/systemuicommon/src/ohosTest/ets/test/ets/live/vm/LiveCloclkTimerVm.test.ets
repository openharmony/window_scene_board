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
import { ILiveTimerVm } from '../../../../main/ets/live/interface/ILiveTimerVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { LiveTimerModel } from '../../../../main/ets/live/model/LiveCommonModel';
import { InnerEventUtil } from '../../../../main/ets/utils/InnerEventUtil';
import systemDateTime from '@ohos.systemDateTime';
import { AccessibilityVm } from '../../../../main/ets/vm/AccessibilityVm';
import { ResourceVm } from '../../../../main/ets/vm/ResourceVm';
import { Singleton } from '../../../../main/ets/utils/Singleton';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';
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
import { LiveTimerVm } from '../../../../main/ets/live/vm/LiveTimerVm';

export default function LiveClockTimerVmTest() {
  describe('updateLiveTimer_testSuite', () => {

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

    it('should_call_updateTimer_when_newCardTimer_or_oldCardTimer_is_not_undefined', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.card = new LiveTimerModel();
      oldLive.card.timer = new LiveTimerModel();

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_call_updateTimer_when_newCapsuleTimer_or_oldCapsuleTimer_is_not_undefined', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.capsule = new LiveTimerModel();
      oldLive.capsule.timer = new LiveTimerModel();

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_not_call_updateTimer_when_newCardTimer_and_oldCardTimer_are_undefined', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_call_updateTimer_with_correct_parameters', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.card = new LiveTimerModel();
      live.card.timer = new LiveTimerModel();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.card = new LiveTimerModel();
      oldLive.card.timer = new LiveTimerModel();

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });

    it('should_call_updateTimer_when_newCapsuleTimer_and_oldCapsuleTimer_are_undefined', 0, async () => {
      let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livetimervm, livetimervm.updateTimer);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.deliveryTime = Date.now();
      live.capsule = new LiveTimerModel();
      live.capsule.timer = new LiveTimerModel();

      let oldLive: LiveNotification = new LiveNotification();
      oldLive.deliveryTime = Date.now();
      oldLive.capsule = new LiveTimerModel();
      oldLive.capsule.timer = new LiveTimerModel();

      livetimervm.updateLiveTimer(live, oldLive);

      mocker.ignoreMock(livetimervm, livetimervm.updateTimer);
    });
  });

  it('should_delete_timer_when_live_is_timer_and_newLive_is_not_has_timer', 0, async () => {
    let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);

    let live: LiveNotification = new LiveNotification();
    live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
    when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

    livetimervm.deleteLiveTimer(live);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
  });

  it('should_delete_timer_when_live_is_timer_and_newLive_timerId_is_not_same', 0, async () => {
    let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);

    let live: LiveNotification = new LiveNotification();
    live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

    let newLive: LiveNotification = new LiveNotification();
    newLive.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
    when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

    livetimervm.deleteLiveTimer(live, newLive);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
  });

  it('should_delete_timer_when_live_is_otherCard_and_newLive_is_not_has_timer', 0, async () => {
    let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);

    let live: LiveNotification = new LiveNotification();
    live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
    when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

    livetimervm.deleteLiveTimer(live);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
  });

  it('should_delete_timer_when_live_is_otherCard_and_newLive_timerId_is_not_same', 0, async () => {
    let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);

    let live: LiveNotification = new LiveNotification();
    live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

    let newLive: LiveNotification = new LiveNotification();
    newLive.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
    when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

    livetimervm.deleteLiveTimer(live, newLive);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
  });

  it('should_not_delete_timer_when_live_is_timer_and_newLive_is_has_timer_and_timerId_is_same', 0, async () => {
    let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);

    let live: LiveNotification = new LiveNotification();
    live.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

    let newLive: LiveNotification = new LiveNotification();
    newLive.capsule = { isTimer: () => true, timer: new LiveTimerModel() };

    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
    when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

    livetimervm.deleteLiveTimer(live, newLive);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
  });

  it('should_not_delete_timer_when_live_is_otherCard_and_newLive_is_has_timer_and_timerId_is_same', 0, async () => {
    let livetimervm: ILiveTimerVm = LiveTimerVm.INSTANCE;
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    let mockDeleteTimer: Function = mocker.mockFunc(livetimervm, livetimervm.deleteTimer);

    let live: LiveNotification = new LiveNotification();
    live.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

    let newLive: LiveNotification = new LiveNotification();
    newLive.card = { isOtherCard: () => true, timer: new LiveTimerModel() };

    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
    when(mockDeleteTimer)(ArgumentMatchers.any).afterReturnNothing();

    livetimervm.deleteLiveTimer(live, newLive);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(livetimervm, livetimervm.deleteTimer);
  });
}