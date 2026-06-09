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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationEvent } from '../../../../main/ets/event/NotificationEvent';
import { TaskQueue, TaskItem } from '../../../../main/ets/utils/TaskQueue';
import { InnerEventUtil } from '../../../../main/ets/utils/InnerEventUtil';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import { ILiveDataVm } from '../../../../main/ets/live/interface/ILiveDataVm';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { LiveBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { NotificationDataManager } from '../../../../main/ets/manager/NotificationDataManager';
import { NotificationUtil } from '../../../../main/ets/utils/NotificationUtil';
import { LiveTimeoutEvent } from '../../../../main/ets/event/LiveViewEvent';
import { LiveCapsuleRemindType } from '../../../../main/ets/live/model/LiveCommonModel';
import { sysTimerMgr } from '@ohos/systemuiutils/src/main/ets/timer/SysTimerManager';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance
} from '../../../../main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '../../../../main/ets/maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../../../../main/ets/live/sysEvent/LiveHiSysEvent';
import { ILiveMetaBallVisibleVm } from '../../../../main/ets/live/interface/ILiveMetaBallVisibleVm';
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
import { LiveDataVm } from '../../../../main/ets/live/vm/LiveDataVm';

export default function LiveDataFourVmTest() {
  describe('setOtherTimeout_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_timeout_when_live_is_other_card', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("mockedKey");

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();

      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      when(mockStartTimer)([ArgumentMatchers.any]).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = {
        isOtherCard: () => true
      };
      live.deliveryTime = Date.now();
      live.hashCode = "123";
      livedatavm.setOtherTimeout(live);

      expect(mockGetKey).assertCalledWith(live);
      expect(mockClearTimeout).assertCalledWith(live);
      expect(mockShowInfo).assertCalledWith("Set other live timeout for 123, time: 10000");
      expect(mockStartTimer).assertCalledWith({
        key: "mockedKey",
        triggerTime: 10000,
        onTimer: livedatavm.onOtherCardTimeout,
        ignoreTriggerTimeCheck: true
      });

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
    });

    it('should_not_set_timeout_when_live_is_not_other_card', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("mockedKey");

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();

      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      when(mockStartTimer)([ArgumentMatchers.any]).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = {
        isOtherCard: () => false
      };
      live.deliveryTime = Date.now();
      live.hashCode = "123";
      livedatavm.setOtherTimeout(live);

      expect(mockGetKey).assertNotCalled();
      expect(mockClearTimeout).assertNotCalled();
      expect(mockShowInfo).assertNotCalled();
      expect(mockStartTimer).assertNotCalled();

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
    });

    it('should_not_set_timeout_when_live_is_clear_all_app', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      livedatavm.isClearAllApp = true;
      let mocker: MockKit = new MockKit();

      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("mockedKey");

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();

      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      when(mockStartTimer)([ArgumentMatchers.any]).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = {
        isOtherCard: () => true
      };
      live.deliveryTime = Date.now();
      live.hashCode = "123";
      livedatavm.setOtherTimeout(live);

      expect(mockGetKey).assertNotCalled();
      expect(mockClearTimeout).assertNotCalled();
      expect(mockShowInfo).assertNotCalled();
      expect(mockStartTimer).assertNotCalled();

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
    });

    it('should_handle_instant_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("mockedKey");

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();

      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      when(mockStartTimer)([ArgumentMatchers.any]).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = {
        isOtherCard: () => true
      };
      live.deliveryTime = Date.now();
      live.hashCode = "123";
      live.style = LiveStyle.INSTANT;
      livedatavm.setOtherTimeout(live);

      expect(mockGetKey).assertCalledWith(live);
      expect(mockClearTimeout).assertCalledWith(live);
      expect(mockShowInfo).assertCalledWith("Set other live timeout for 123, time: 10000");
      expect(mockStartTimer).assertCalledWith({
        key: "mockedKey",
        triggerTime: 10000,
        onTimer: livedatavm.onInstantTimeout,
        ignoreTriggerTimeCheck: true
      });

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
    });
  });

  describe('setRemindTimeout', () => {
    it('should_return_when_live_is_instant_and_key_is_valid', 0, async () => {
      letlivedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockfuncGetKey)(ArgumentMatchers.any).afterReturn('testKey');
      let mockfuncIsInstant: Function =
        mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      when(mockfuncIsInstant)().afterReturn(true);
      let mockfuncShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfuncShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfuncIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      when(mockfuncIsFlip)().afterReturn(false);
      let mockfuncRemindTimerMapGet: Function =
        mocker.mockFunc(livedatavm.remindTimerMap, livedatavm.remindTimerMap.get);
      when(mockfuncRemindTimerMapGet)(ArgumentMatchers.any).afterReturn(undefined);
      let mockfuncRemindTimerMapSet: Function =
        mocker.mockFunc(livedatavm.remindTimerMap, livedatavm.remindTimerMap.set);
      when(mockfuncRemindTimerMapSet)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockfuncRemindTimerMapDelete: Function =
        mocker.mockFunc(livedatavm.remindTimerMap, livedatavm.remindTimerMap.delete);
      when(mockfuncRemindTimerMapDelete)(ArgumentMatchers.any).afterReturnNothing();
      let mockfuncTimeout: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.setTimeout);
      when(mockfuncTimeout)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyNumber).afterReturn(12345);

      let live: LiveNotification = new LiveNotification();
      livedatavm.setRemindTimeout(live, false);

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(livedatavm.remindTimerMap, livedatavm.remindTimerMap.get);
      mocker.ignoreMock(livedatavm.remindTimerMap, livedatavm.remindTimerMap.set);
      mocker.ignoreMock(livedatavm.remindTimerMap, livedatavm.remindTimerMap.delete);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.setTimeout);
    });

    it('should_return_when_live_is_not_instant_and_isUpdate_is_true_and_key_is_valid', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockfuncGetKey)(ArgumentMatchers.any).afterReturn('testKey');
      let mockfuncIsInstant: Function =
        mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      when(mockfuncIsInstant)().afterReturn(false);
      let mockfuncIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      when(mockfuncIsFlip)().afterReturn(true);
      let mockfuncShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfuncShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockfuncRemindTimerMapGet: Function =
        mocker.mockFunc(livedatavm.remindTimerMap, livedatavm.remindTimerMap.get);
      when(mockfuncRemindTimerMapGet)(ArgumentMatchers.any).afterReturn(undefined);
      let mockfuncRemindTimerMapSet: Function =
        mocker.mockFunc(livedatavm.remindTimerMap, livedatavm.remindTimerMap.set);
      when(mockfuncRemindTimerMapSet)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockfuncRemindTimerMapDelete: Function =
        mocker.mockFunc(livedatavm.remindTimerMap, livedatavm.remindTimerMap.delete);
      when(mockfuncRemindTimerMapDelete)(ArgumentMatchers.any).afterReturnNothing();
      let mockfuncTimeout: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.setTimeout);
      when(mockfuncTimeout)(ArgumentMatchers.anyFunction, ArgumentMatchers.anyNumber).afterReturn(12345);

      let live: LiveNotification = new LiveNotification();
      livedatavm.setRemindTimeout(live, true);

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm.remindTimerMap, livedatavm.remindTimerMap.get);
      mocker.ignoreMock(livedatavm.remindTimerMap, livedatavm.remindTimerMap.set);
      mocker.ignoreMock(livedatavm.remindTimerMap, livedatavm.remindTimerMap.delete);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.setTimeout);
    });

    it('should_return_when_key_is_invalid', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockfuncGetKey)(ArgumentMatchers.any).afterReturn(null);
      let mockfuncIsInstant: Function =
        mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      when(mockfuncIsInstant)().afterReturn(false);
      let mockfuncIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      when(mockfuncIsFlip)().afterReturn(false);
      let mockfuncShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfuncShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      livedatavm.setRemindTimeout(live, false);

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });

  describe('clearTimeout_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_destroyTimer_when_clearTimeout_is_called', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("testKey");

      let mockDestroyTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.destroyTimer);
      when(mockDestroyTimer)(ArgumentMatchers.anyString).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.LIVE_VIEW;
      livedatavm.clearTimeout(live);

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.destroyTimer);
    });

    it('should_not_call_destroyTimer_when_live_is_null', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("testKey");

      let mockDestroyTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.destroyTimer);
      when(mockDestroyTimer)(ArgumentMatchers.anyString).afterReturnNothing();

      let live: LiveNotification = null;
      livedatavm.clearTimeout(live);

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.destroyTimer);
    });

    it('should_not_call_destroyTimer_when_key_is_null', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn(null);

      let mockDestroyTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.destroyTimer);
      when(mockDestroyTimer)(ArgumentMatchers.anyString).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.style = LiveStyle.LIVE_VIEW;
      livedatavm.clearTimeout(live);

      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.destroyTimer);
    });
  });

  describe('onClearAllApp_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_start_and_end_clearAllApp_process_correctly', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockOnInit: Function = mocker.mockFunc(livedatavm, livedatavm.onInit);
      when(mockOnInit)(ArgumentMatchers.any).afterReturn(Promise.resolve());

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockIsLiveView: Function =
        mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isLiveView);
      when(mockIsLiveView)().afterReturn(true);

      let mockIsInstantBanner: Function =
        mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isInstantBanner);
      when(mockIsInstantBanner)().afterReturn(false);

      let mockIsConvertFromNormal: Function =
        mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isConvertFromNormal);
      when(mockIsConvertFromNormal)().afterReturn(false);


      await livedatavm.onClearAllApp();

      expect(livedatavm.isClearAllApp).assertTrue();

      livedatavm.taskQueue.executeNext();

      expect(livedatavm.isClearAllApp).assertFalse();

      mocker.ignoreMock(livedatavm, livedatavm.onInit);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isLiveView);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isInstantBanner);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isConvertFromNormal);
    });
  });
}
