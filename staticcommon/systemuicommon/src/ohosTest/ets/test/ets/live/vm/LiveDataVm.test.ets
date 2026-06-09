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
import { NotificationEvent } from '../../../../../../main/ets/event/NotificationEvent';
import { TaskQueue, TaskItem } from '../../../../../../main/ets/utils/TaskQueue';
import { InnerEventUtil } from '../../../../../../main/ets/utils/InnerEventUtil';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { ILiveDataVm } from '../../../../../../main/ets/live/interface/ILiveDataVm';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { NotificationDataManager } from '../../../../../../main/ets/manager/NotificationDataManager';
import { NotificationUtil } from '../../../../../../main/ets/utils/NotificationUtil';
import { LiveTimeoutEvent } from '../../../../../../main/ets/event/LiveViewEvent';
import { LiveCapsuleRemindType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { sysTimerMgr } from '@ohos/systemuiutils/src/main/ets/timer/SysTimerManager';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance } from '../../../../../../main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '../../../../../../main/ets/maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../../../../../../main/ets/live/sysEvent/LiveHiSysEvent';
import { BannerVm } from '../../../../../../main/ets/vm/BannerVm';
import { ILiveMetaBallVisibleVm } from '../../../../../../main/ets/live/interface/ILiveMetaBallVisibleVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveDataVm } from '../../../../../../main/ets/live/vm/LiveDataVm';

export default function LiveDataVmTest() {
  describe('onInit_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_add_new_live_when_no_old_live', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockSetLiveTimer: Function = mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      when(mockSetLiveTimer)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLiveList: Function = mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
      when(mockInitLiveList)(ArgumentMatchers.any).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          style: LiveStyle.LIVE_HI_SCHOOL,
          components: []
        }
      ];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
    });

    it('should_update_existing_live_when_live_is_different', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockSetLiveTimer: Function = mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      when(mockSetLiveTimer)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLiveList: Function = mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
      when(mockInitLiveList)(ArgumentMatchers.any).afterReturnNothing();

      livedatavm.liveMap.set('1', {
        hashCode: '1',
        style: LiveStyle.LIVE_HI_SCHOOL,
        components: []
      });

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          style: LiveStyle.LIVE_HI_SCHOOL,
          components: [1]
        }
      ];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      expect(livedatavm.liveMap.get('1').components).assertDeepEquals([1]);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
    });

    it('should_remove_old_live_when_live_is_not_in_new_list', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockSetLiveTimer: Function = mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      when(mockSetLiveTimer)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLiveList: Function = mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
      when(mockInitLiveList)(ArgumentMatchers.any).afterReturnNothing();

      livedatavm.liveMap.set('1', {
        hashCode: '1',
        style: LiveStyle.LIVE_HI_SCHOOL,
        components: []
      });

      let liveList: LiveNotification[] = [];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(0);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
    });

    it('should_return_immediately_when_live_is_invalid', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let live: LiveNotification = new LiveNotification();
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_add_live_to_liveMap_and_set_live_timer', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      await livedatavm.onAdd(live);
      expect(livedatavm.liveMap.has(live.hashCode)).assertTrue();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_other_timeout_when_live_is_instant', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(true);
      when(live.isPersistent()).afterReturn(false);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_other_timeout_when_live_is_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(true);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_remind_timeout_when_live_is_not_instant_and_not_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(false);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_heads_up_timeout_when_live_is_heads_up', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(false);
      when(live.isHeadsUp).afterReturn(true);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_call_setRemindTimeout_when_live_is_not_instant_and_not_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(livedatavm, livedatavm.setRemindTimeout);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm, livedatavm.setRemindTimeout);
    });

    it('should_call_setOtherTimeout_when_live_is_instant', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(true);
      when(live.isPersistent()).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
    });

    it('should_call_setOtherTimeout_when_live_is_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
    });

    it('should_post_live_timeout_event_when_live_is_instant_or_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(true);
      when(live.isPersistent()).afterReturn(true);
      when(live.hashCode).afterReturn('123');
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_log_info_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_update_liveMap_when_liveList_is_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let liveList: LiveNotification[] = [];
      await livedatavm.onBatchUpdate(liveList);
      expect(livedatavm.liveMap.size).assertEqual(0);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_liveMap_and_call_updateVmByLive_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      expect(livedatavm.liveMap.size).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_localUpdateLiveList_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let liveBaseVm: LiveBaseVm = new LiveBaseVm();
      let mockfunc1: Function = mocker.mockFunc(liveBaseVm, liveBaseVm.localUpdateLiveList);
      when(mockfunc1)(ArgumentMatchers.any).afterReturnNothing();
      livedatavm.cardListVm = liveBaseVm;
      livedatavm.capsuleListVm = liveBaseVm;
      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('localUpdateLiveList', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(liveBaseVm, liveBaseVm.localUpdateLiveList);
    });

    it('should_call_updateVmByLive_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc2: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.updateVmByLive);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      livedatavm.vmInjector = liveVmInjector;

      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('updateVmByLive', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(liveVmInjector, liveVmInjector.updateVmByLive);
    });

    it('should_call_LiveHiSysEvent_reportLiveUpdateEvent_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveUpdateEvent);
      when(mockfunc)().afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('reportLiveUpdateEvent', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportLiveUpdateEvent);
    });

    it('should_call_onInit_task_when_event_type_is_init', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let taskQueue: TaskQueue = new TaskQueue('TAG', 1);
      livedatavm.taskQueue = taskQueue;

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isLiveView: () => true,
          eventType: NotificationEvent.EVENT_TYPE_INIT
        })
      ];
      await livedatavm.onBatchUpdate(liveList);

      expect(taskQueue.tasks.length).assertEqual(1);
      expect(taskQueue.tasks[0].taskName).assertEqual('onInit');
    });

    it('should_call_onAdd_task_when_event_type_is_add', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let taskQueue: TaskQueue = new TaskQueue('TAG', 1);
      livedatavm.taskQueue = taskQueue;

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isLiveView: () => true,
          eventType: NotificationEvent.EVENT_TYPE_ADD
        })
      ];
      await livedatavm.onBatchUpdate(liveList);

      expect(taskQueue.tasks.length).assertEqual(1);
      expect(taskQueue.tasks[0].taskName).assertEqual('onAdd');
    });

    it('should_call_onSingleUpdate_task_when_event_type_is_update_and_not_batch', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let taskQueue: TaskQueue = new TaskQueue('TAG', 1);
      livedatavm.taskQueue = taskQueue;

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isLiveView: () => true,
          eventType: NotificationEvent.EVENT_TYPE_UPDATE,
          isBatch: false
        })
      ];
      await livedatavm.onBatchUpdate(liveList);
      expect(taskQueue.tasks.length).assertEqual(1);
      expect(taskQueue.tasks[0].taskName).assertEqual('onSingleUpdate');
    });

    it('should_remove_live_list_and_call_removeLive_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.LIVE_VIEW;
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_do_nothing_when_liveList_is_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      await livedatavm.onRemove([]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_handle_live_timeout_event_when_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.LIVE_VIEW;
      mockLiveNotification.isEnd = false;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.isEnd).assertTrue();
    });

    it('should_handle_instant_timeout_event_when_instant_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.INSTANT_LIVE;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_handle_persistent_timeout_event_when_persistent_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.PERSISTENT_LIVE;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_handle_flip_timeout_event_when_flip_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.FLIP_LIVE;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_call_destroyTimer_when_clearTimeout_is_called', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("testKey");

      let mockDestroyTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.destroyTimer);
      when(mockDestroyTimer)(ArgumentMatchers.anyString).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      livedatavm.clearTimeout(live);

      mocker.verify('destroyTimer', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.destroyTimer);
    });

    it('should_call_onNotificationEvent_with_EVENT_TYPE_INIT', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockTaskQueue: TaskQueue = new TaskQueue("TAG", 1);
      livedatavm.taskQueue = mockTaskQueue;

      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.style = LiveStyle.LIVE_INIT;
      mockLiveNotification.eventType = NotificationEvent.EVENT_TYPE_INIT;

      livedatavm.onNotificationEvent({
        notificationList: [mockLiveNotification],
        eventType: NotificationEvent.EVENT_TYPE_INIT,
        isBatch: false
      });

      expect(livedatavm.taskQueue.tasks.length).assertEqual(1);
      expect(livedatavm.taskQueue.tasks[0].taskName).assertEqual("onInit");

    });

    it('should_call_onNotificationEvent_with_EVENT_TYPE_ADD', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockTaskQueue: TaskQueue = new TaskQueue("TAG", 1);
      livedatavm.taskQueue = mockTaskQueue;

      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.style = LiveStyle.LIVE_INIT;
      mockLiveNotification.eventType = NotificationEvent.EVENT_TYPE_ADD;

      livedatavm.onNotificationEvent({
        notificationList: [mockLiveNotification],
        eventType: NotificationEvent.EVENT_TYPE_ADD,
        isBatch: false
      });

      expect(livedatavm.taskQueue.tasks.length).assertEqual(1);
      expect(livedatavm.taskQueue.tasks[0].taskName).assertEqual("onAdd");

    });

    it('should_call_onNotificationEvent_with_EVENT_TYPE_UPDATE_and_isBatch_false', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockTaskQueue: TaskQueue = new TaskQueue("TAG", 1);
      livedatavm.taskQueue = mockTaskQueue;

      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.style = LiveStyle.LIVE_INIT;
      mockLiveNotification.eventType = NotificationEvent.EVENT_TYPE_UPDATE;

      livedatavm.onNotificationEvent({
        notificationList: [mockLiveNotification],
        eventType: NotificationEvent.EVENT_TYPE_UPDATE,
        isBatch: false
      });

      expect(livedatavm.taskQueue.tasks.length).assertEqual(1);
      expect(livedatavm.taskQueue.tasks[0].taskName).assertEqual("onSingleUpdate");

    });

    it('should_call_onNotificationEvent_with_EVENT_TYPE_UPDATE_and_isBatch_true', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockTaskQueue: TaskQueue = new TaskQueue("TAG", 1);
      livedatavm.taskQueue = mockTaskQueue;

      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.style = LiveStyle.LIVE_INIT;
      mockLiveNotification.eventType = NotificationEvent.EVENT_TYPE_UPDATE;

      livedatavm.onNotificationEvent({
        notificationList: [mockLiveNotification],
        eventType: NotificationEvent.EVENT_TYPE_UPDATE,
        isBatch: true
      });

      expect(livedatavm.taskQueue.tasks.length).assertEqual(1);
      expect(livedatavm.taskQueue.tasks[0].taskName).assertEqual("onBatchUpdate");

    });

    it('should_call_onNotificationEvent_with_EVENT_TYPE_REMOVE', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockTaskQueue: TaskQueue = new TaskQueue("TAG", 1);
      livedatavm.taskQueue = mockTaskQueue;

      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.style = LiveStyle.LIVE_INIT;
      mockLiveNotification.eventType = NotificationEvent.EVENT_TYPE_REMOVE;

      livedatavm.onNotificationEvent({
        notificationList: [mockLiveNotification],
        eventType: NotificationEvent.EVENT_TYPE_REMOVE,
        isBatch: false
      });

      expect(livedatavm.taskQueue.tasks.length).assertEqual(1);
      expect(livedatavm.taskQueue.tasks[0].taskName).assertEqual("onRemove");

    });

    it('should_call_onOtherCardTimeout_when_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.style = LiveStyle.LIVE_INIT;
      mockLiveNotification.eventType = NotificationEvent.EVENT_TYPE_ADD;
      mockLiveNotification.hashCode = "123";
      mockLiveNotification.isEnd = false;
      mockLiveNotification.isInstant = false;
      mockLiveNotification.isFlip = false;
      mockLiveNotification.isMetaBall = false;
      mockLiveNotification.isParcel = false;
      mockLiveNotification.isParcelFlip = false;

      livedatavm.liveMap.set("123", mockLiveNotification);

      livedatavm.onOtherCardTimeout = async (key: string): Promise<void> => {
        const hashCode = key.substring(TAG.length);
        const live = livedatavm.liveMap.get(hashCode);
        if (live) {
          log.showInfo(`Other live ${hashCode} is timeout, update status to end`);
          live.isEnd = true;
          NotificationDataManager.instance.updateExistNtf([live], false);
          // 兼容老的实况数据超时逻辑，锁屏使用
          setTimeout(() => {
            InnerEventUtil.post(LiveTimeoutEvent, LiveTimeoutEvent.create(hashCode));
          });
          DeleteNotificationMaintenance.manualDelete([live], {
            deleteType: DeleteNotificationType.LIVE_DATA_EXPIRE_HIDE,
            isInGroup: false,
          }, DeleteNotificationErrorCode.CAPSULE_UPDATE_TIMEOUT);
        }
      };

      livedatavm.onOtherCardTimeout("TAG123");

      expect(mockLiveNotification.isEnd).assertEqual(true);
    });

    it('should_return_correct_key_when_live_is_not_null', 0, () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '123456';
      let result = livedatavm.getKey(live);
      expect(result).assertEqual(TAG + live.hashCode);
    });

    it('should_return_key_with_correct_length', 0, () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '1234567890';
      let result = livedatavm.getKey(live);
      expect(result.length).assertEqual(TAG.length + live.hashCode.length);
    });

    it('should_return_key_with_correct_prefix', 0, () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '123456';
      let result = livedatavm.getKey(live);
      expect(result.substring(0, TAG.length)).assertEqual(TAG);
    });

    it('should_return_key_with_correct_hashCode', 0, () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = '123456';
      let result = livedatavm.getKey(live);
      expect(result.substring(TAG.length)).assertEqual(live.hashCode);
    });

    it('should_start_and_end_clearAllApp_correctly', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase, NotificationBase.isLiveView);
      when(mockIsLiveView)(ArgumentMatchers.any).afterReturn(true);

      let mockOnInit: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.onInit);
      when(mockOnInit)([ArgumentMatchers.any]).afterReturn(Promise.resolve());

      let mockIsInstantBanner: Function = mocker.mockFunc(LiveNotification, LiveNotification.isInstantBanner);
      when(mockIsInstantBanner)([ArgumentMatchers.any]).afterReturn(false);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();

      await livedatavm.onClearAllApp();

      expect(livedatavm.isClearAllApp).assertTrue();

      livedatavm.taskQueue.execute('onInit', livedatavm.onInit);

      expect(livedatavm.isClearAllApp).assertFalse();

      mocker.ignoreMock(NotificationBase, NotificationBase.isLiveView);
      mocker.ignoreMock(LiveBaseVm, LiveBaseVm.onInit);
      mocker.ignoreMock(LiveNotification, LiveNotification.isInstantBanner);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_handle_live_timeout_correctly', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase, NotificationBase.isLiveView);
      when(mockIsLiveView)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();


      let mockOnInstantTimeout: Function = mocker.mockFunc(LiveDataVm.prototype, LiveDataVm.prototype.onInstantTimeout);
      when(mockOnInstantTimeout)([ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      livedatavm.liveMap.set('1', new LiveNotification());
      livedatavm.liveMap.get('1').liveStyle = LiveStyle.INSTANT;
      livedatavm.liveMap.get('1').isEnd = false;

      await livedatavm.onClearAllApp();
      livedatavm.taskQueue.execute('onInstantTimeout', livedatavm.onInstantTimeout, '1');

      expect(livedatavm.liveMap.get('1').isEnd).assertTrue();

      mocker.ignoreMock(NotificationBase, NotificationBase.isLiveView);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveDataVm.prototype, LiveDataVm.prototype.onInstantTimeout);
    });

    it('should_handle_persistent_timeout_correctly', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase, NotificationBase.isLiveView);
      when(mockIsLiveView)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();


      let mockOnPersistentTimeout: Function = mocker.mockFunc(LiveDataVm.prototype, LiveDataVm.prototype.onPersistentTimeout);
      when(mockOnPersistentTimeout)([ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      livedatavm.liveMap.set('1', new LiveNotification());
      livedatavm.liveMap.get('1').liveStyle = LiveStyle.PERSISTENT;

      await livedatavm.onClearAllApp();
      livedatavm.taskQueue.execute('onPersistentTimeout', livedatavm.onPersistentTimeout, '1');

      expect(livedatavm.liveMap.get('1').liveStyle).assertEqual(LiveStyle.PERSISTENT);

      mocker.ignoreMock(NotificationBase, NotificationBase.isLiveView);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveDataVm.prototype, LiveDataVm.prototype.onPersistentTimeout);
    });

    it('should_handle_flip_timeout_correctly', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockIsLiveView: Function = mocker.mockFunc(NotificationBase, NotificationBase.isLiveView);
      when(mockIsLiveView)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString, ArgumentMatchers.any]).afterReturnNothing();


      let mockOnFlipTimeout: Function = mocker.mockFunc(LiveDataVm.prototype, LiveDataVm.prototype.onFlipTimeout);
      when(mockOnFlipTimeout)([ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

      livedatavm.liveMap.set('1', new LiveNotification());
      livedatavm.liveMap.get('1').liveStyle = LiveStyle.FLIP;

      await livedatavm.onClearAllApp();
      livedatavm.taskQueue.execute('onFlipTimeout', livedatavm.onFlipTimeout, '1');

      expect(livedatavm.liveMap.get('1').liveStyle).assertEqual(LiveStyle.FLIP);

      mocker.ignoreMock(NotificationBase, NotificationBase.isLiveView);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveDataVm.prototype, LiveDataVm.prototype.onFlipTimeout);
    });

    it('should_log_info_and_start_timer_when_live_is_instant', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      let mockIsInstant: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);

      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartTimer)(ArgumentMatchers.any).afterReturnNothing();
      when(mockIsInstant)().afterReturn(true);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.hashCode = '123';
      live.duration = 1000;

      livedatavm.setRemindTimeout(live, false);

      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isInstant);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
    });

    it('should_log_info_and_start_timer_when_live_is_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      let mockIsPersistent: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isPersistent);
      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);

      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartTimer)(ArgumentMatchers.any).afterReturnNothing();
      when(mockIsPersistent)().afterReturn(true);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.hashCode = '123';
      live.duration = 1000;

      livedatavm.setRemindTimeout(live, false);

      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isPersistent);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
    });

    it('should_log_info_and_start_timer_when_live_is_flip_and_isUpdate_is_true', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);

      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartTimer)(ArgumentMatchers.any).afterReturnNothing();
      when(mockIsFlip)().afterReturn(true);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.hashCode = '123';
      live.duration = LiveStyle.INSTANT_LIVE_TIMEOUT;

      livedatavm.setRemindTimeout(live, true);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
    });

    it('should_set_other_live_timeout_when_live_is_other_card', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("mockedKey");

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      when(mockStartTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = { isOtherCard: () => true };
      live.deliveryTime = Date.now();
      live.hashCode = "123";
      live.style = LiveStyle.LIVE_CARD;
      livedatavm.setOtherTimeout(live);

      expect(mockStartTimer).assertCalled();
      expect(mockGetKey).assertCalled();
      expect(mockShowInfo).assertCalled();
      expect(mockClearTimeout).assertCalled();

      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
    });

    it('should_not_set_other_live_timeout_when_live_is_not_other_card', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("mockedKey");

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      when(mockStartTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = { isOtherCard: () => false };
      live.deliveryTime = Date.now();
      live.hashCode = "123";
      live.style = LiveStyle.LIVE_CARD;
      livedatavm.setOtherTimeout(live);

      expect(mockStartTimer).assertNotCalled();
      expect(mockGetKey).assertNotCalled();
      expect(mockShowInfo).assertNotCalled();
      expect(mockClearTimeout).assertNotCalled();

      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
    });

    it('should_not_set_other_live_timeout_when_live_is_clear_all_app', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      livedatavm.isClearAllApp = true;
      let mocker: MockKit = new MockKit();

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockGetKey: Function = mocker.mockFunc(livedatavm, livedatavm.getKey);
      when(mockGetKey)(ArgumentMatchers.any).afterReturn("mockedKey");

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockStartTimer: Function = mocker.mockFunc(sysTimerMgr, sysTimerMgr.startTimer);
      when(mockStartTimer)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.card = { isOtherCard: () => true };
      live.deliveryTime = Date.now();
      live.hashCode = "123";
      live.style = LiveStyle.LIVE_CARD;
      livedatavm.setOtherTimeout(live);

      expect(mockStartTimer).assertNotCalled();
      expect(mockGetKey).assertNotCalled();
      expect(mockShowInfo).assertNotCalled();
      expect(mockClearTimeout).assertNotCalled();

      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(livedatavm, livedatavm.getKey);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(sysTimerMgr, sysTimerMgr.startTimer);
    });

    it('should_add_new_live_when_no_old_live', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockSetLiveTimer: Function = mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      when(mockSetLiveTimer)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLiveList: Function = mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
      when(mockInitLiveList)(ArgumentMatchers.any).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          style: LiveStyle.LIVE_HI_SCHOOL,
          components: []
        }
      ];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
    });

    it('should_update_existing_live_when_live_is_different', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockSetLiveTimer: Function = mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      when(mockSetLiveTimer)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLiveList: Function = mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
      when(mockInitLiveList)(ArgumentMatchers.any).afterReturnNothing();

      livedatavm.liveMap.set('1', {
        hashCode: '1',
        style: LiveStyle.LIVE_HI_SCHOOL,
        components: []
      });

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          style: LiveStyle.LIVE_HI_SCHOOL,
          components: [1]
        }
      ];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      expect(livedatavm.liveMap.get('1').components).assertDeepEquals([1]);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
    });

    it('should_remove_old_live_when_live_is_not_in_new_list', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockSetLiveTimer: Function = mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      when(mockSetLiveTimer)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockInitLiveList: Function = mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
      when(mockInitLiveList)(ArgumentMatchers.any).afterReturnNothing();

      livedatavm.liveMap.set('1', {
        hashCode: '1',
        style: LiveStyle.LIVE_HI_SCHOOL,
        components: []
      });

      let liveList: LiveNotification[] = [];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(0);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.setLiveTimer);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.initLiveList);
    });

    it('should_return_immediately_when_live_is_invalid', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let live: LiveNotification = new LiveNotification();
      await livedatavm.onAdd(live);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_add_live_to_liveMap_and_set_live_timer', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      await livedatavm.onAdd(live);
      expect(livedatavm.liveMap.has(live.hashCode)).assertTrue();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_other_timeout_when_live_is_instant', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(true);
      when(live.isPersistent()).afterReturn(false);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_other_timeout_when_live_is_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(true);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_remind_timeout_when_live_is_not_instant_and_not_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(false);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_set_heads_up_timeout_when_live_is_heads_up', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(false);
      when(live.isHeadsUp).afterReturn(true);
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_call_setRemindTimeout_when_live_is_not_instant_and_not_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(livedatavm, livedatavm.setRemindTimeout);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm, livedatavm.setRemindTimeout);
    });

    it('should_call_setOtherTimeout_when_live_is_instant', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(true);
      when(live.isPersistent()).afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
    });

    it('should_call_setOtherTimeout_when_live_is_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(false);
      when(live.isPersistent()).afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
    });

    it('should_post_live_timeout_event_when_live_is_instant_or_persistent', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let live: LiveNotification = new LiveNotification();
      when(live.isInstant()).afterReturn(true);
      when(live.isPersistent()).afterReturn(true);
      when(live.hashCode).afterReturn('123');
      await livedatavm.onAdd(live);
      mocker.verify('checkLiveValid', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_log_info_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_update_liveMap_when_liveList_is_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let liveList: LiveNotification[] = [];
      await livedatavm.onBatchUpdate(liveList);
      expect(livedatavm.liveMap.size).assertEqual(0);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_liveMap_and_call_updateVmByLive_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      expect(livedatavm.liveMap.size).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_localUpdateLiveList_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let liveBaseVm: LiveBaseVm = new LiveBaseVm();
      let mockfunc1: Function = mocker.mockFunc(liveBaseVm, liveBaseVm.localUpdateLiveList);
      when(mockfunc1)(ArgumentMatchers.any).afterReturnNothing();
      livedatavm.cardListVm = liveBaseVm;
      livedatavm.capsuleListVm = liveBaseVm;
      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('localUpdateLiveList', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(liveBaseVm, liveBaseVm.localUpdateLiveList);
    });

    it('should_call_updateVmByLive_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let liveVmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc2: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.updateVmByLive);
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      livedatavm.vmInjector = liveVmInjector;

      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('updateVmByLive', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(liveVmInjector, liveVmInjector.updateVmByLive);
    });

    it('should_call_LiveHiSysEvent_reportLiveUpdateEvent_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveUpdateEvent);
      when(mockfunc)().afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification({ hashCode: '1', style: LiveStyle.LIVE_VIEW, isLiveView: () => true })
      ];
      await livedatavm.onBatchUpdate(liveList);
      mocker.verify('reportLiveUpdateEvent', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportLiveUpdateEvent);
    });

    it('should_call_onInit_task_when_event_type_is_init', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let taskQueue: TaskQueue = new TaskQueue('TAG', 1);
      livedatavm.taskQueue = taskQueue;

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isLiveView: () => true,
          eventType: NotificationEvent.EVENT_TYPE_INIT
        })
      ];
      await livedatavm.onBatchUpdate(liveList);

      expect(taskQueue.tasks.length).assertEqual(1);
      expect(taskQueue.tasks[0].taskName).assertEqual('onInit');
    });

    it('should_call_onAdd_task_when_event_type_is_add', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let taskQueue: TaskQueue = new TaskQueue('TAG', 1);
      livedatavm.taskQueue = taskQueue;

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isLiveView: () => true,
          eventType: NotificationEvent.EVENT_TYPE_ADD
        })
      ];
      await livedatavm.onBatchUpdate(liveList);

      expect(taskQueue.tasks.length).assertEqual(1);
      expect(taskQueue.tasks[0].taskName).assertEqual('onAdd');
    });

    it('should_call_onSingleUpdate_task_when_event_type_is_update_and_not_batch', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let taskQueue: TaskQueue = new TaskQueue('TAG', 1);
      livedatavm.taskQueue = taskQueue;

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isLiveView: () => true,
          eventType: NotificationEvent.EVENT_TYPE_UPDATE,
          isBatch: false
        })
      ];
      await livedatavm.onBatchUpdate(liveList);
      expect(taskQueue.tasks.length).assertEqual(1);
      expect(taskQueue.tasks[0].taskName).assertEqual('onSingleUpdate');
    });

    it('should_remove_live_list_and_call_removeLive_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.LIVE_VIEW;
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_do_nothing_when_liveList_is_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      await livedatavm.onRemove([]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_handle_live_timeout_event_when_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.LIVE_VIEW;
      mockLiveNotification.isEnd = false;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.isEnd).assertTrue();
    });

    it('should_handle_instant_timeout_event_when_instant_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.INSTANT_LIVE;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_handle_persistent_timeout_event_when_persistent_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.PERSISTENT_LIVE;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });

    it('should_handle_flip_timeout_event_when_flip_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockLiveNotification: LiveNotification = new LiveNotification();
      mockLiveNotification.liveStyle = LiveStyle.FLIP_LIVE;
      mockLiveNotification.hashCode = '123';
      livedatavm.liveMap.set('123', mockLiveNotification);
      await livedatavm.onRemove([mockLiveNotification]);
      expect(mockLiveNotification.liveStyle).assertEqual(LiveStyle.LIVE_VIEW);
    });
  });
}
