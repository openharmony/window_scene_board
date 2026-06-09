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

export default function LiveDataThreeVmTest() {
  describe('onBatchUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_live_list_and_map_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)("%s, isBatch: %s, live length: %s", ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyNumber).afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1', style: LiveStyle.LIVE_VIEW
        }),
        new LiveNotification({
          hashCode: '2', style: LiveStyle.LIVE_VIEW
        })
      ];

      await livedatavm.onBatchUpdate(liveList);

      expect(livedatavm.liveMap.size).assertEqual(2);
      expect(livedatavm.cardListVm.localUpdateLiveList).assertCalledWith(liveList);
      expect(livedatavm.capsuleListVm.localUpdateLiveList).assertCalledWith(liveList);

      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_update_live_list_and_map_when_liveList_is_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)("%s, isBatch: %s, live length: %s", ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyNumber).afterReturnNothing();

      let liveList: LiveNotification[] = [];

      await livedatavm.onBatchUpdate(liveList);

      expect(livedatavm.liveMap.size).assertEqual(0);
      expect(livedatavm.cardListVm.localUpdateLiveList).assertCalledWith(liveList);
      expect(livedatavm.capsuleListVm.localUpdateLiveList).assertCalledWith(liveList);

      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_live_map_when_live_list_has_existing_hashCode', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)("%s, isBatch: %s, live length: %s", ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyNumber).afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1', style: LiveStyle.LIVE_VIEW
        }),
        new LiveNotification({
          hashCode: '1', style: LiveStyle.LIVE_VIEW
        })
      ];

      await livedatavm.onBatchUpdate(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      expect(livedatavm.cardListVm.localUpdateLiveList).assertCalledWith(liveList);
      expect(livedatavm.capsuleListVm.localUpdateLiveList).assertCalledWith(liveList);

      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_post_live_timeout_event_when_live_is_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)("%s, isBatch: %s, live length: %s", ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyNumber).afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1', style: LiveStyle.LIVE_VIEW, isEnd: true
        })
      ];

      await livedatavm.onBatchUpdate(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      expect(livedatavm.cardListVm.localUpdateLiveList).assertCalledWith(liveList);
      expect(livedatavm.capsuleListVm.localUpdateLiveList).assertCalledWith(liveList);
      expect(InnerEventUtil.post).assertCalledWith(LiveTimeoutEvent, LiveTimeoutEvent.create('1'));

      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_report_live_update_event_when_live_is_not_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)("%s, isBatch: %s, live length: %s", ArgumentMatchers.anyString, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyNumber).afterReturnNothing();

      let liveList: LiveNotification[] = [
        new LiveNotification({
          hashCode: '1', style: LiveStyle.LIVE_VIEW
        })
      ];

      await livedatavm.onBatchUpdate(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      expect(livedatavm.cardListVm.localUpdateLiveList).assertCalledWith(liveList);
      expect(livedatavm.capsuleListVm.localUpdateLiveList).assertCalledWith(liveList);
      expect(LiveHiSysEvent.reportLiveUpdateEvent).assertCalled();

      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });

  describe('onSingleUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_remove_live_list_when_live_is_invalid', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)([ArgumentMatchers.any]).afterReturn(false);

      let mockCardListVmRemoveLiveList: Function =
        mocker.mockFunc(livedatavm.cardListVm, livedatavm.cardListVm.removeLiveList);
      when(mockCardListVmRemoveLiveList)([ArgumentMatchers.any]).afterReturnNothing();

      let mockCapsuleListVmRemoveLiveList: Function =
        mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.removeLiveList);
      when(mockCapsuleListVmRemoveLiveList)([ArgumentMatchers.any]).afterReturnNothing();

      let mockRemoveLive: Function = mocker.mockFunc(livedatavm, livedatavm.removeLive);
      when(mockRemoveLive)([ArgumentMatchers.any]).afterReturnNothing();

      let liveList: LiveNotification[] = [new LiveNotification()];
      await livedatavm.onSingleUpdate(liveList);

      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm.cardListVm, livedatavm.cardListVm.removeLiveList);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.removeLiveList);
      mocker.ignoreMock(livedatavm, livedatavm.removeLive);
    });

    it('should_update_live_when_live_is_valid_and_old_live_exists', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)([ArgumentMatchers.any]).afterReturn(true);

      let mockTimerVmUpdateLiveTimer: Function =
        mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.updateLiveTimer);
      when(mockTimerVmUpdateLiveTimer)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let mockCardListVmRemoteUpdateLive: Function =
        mocker.mockFunc(livedatavm.cardListVm, livedatavm.cardListVm.remoteUpdateLive);
      when(mockCardListVmRemoteUpdateLive)([ArgumentMatchers.any]).afterReturnNothing();

      let mockCapsuleListVmRemoteUpdateLive: Function =
        mocker.mockFunc(livedatavm.capsuleListVm, livedatavm.capsuleListVm.remoteUpdateLive);
      when(mockCapsuleListVmRemoteUpdateLive)([ArgumentMatchers.any]).afterReturnNothing();

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)([ArgumentMatchers.any]).afterReturnNothing();

      let mockTimerVmDeleteLiveTimer: Function =
        mocker.mockFunc(livedatavm.timerVm, livedatavm.timerVm.deleteLiveTimer);
      when(mockTimerVmDeleteLiveTimer)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let mockSetRemindTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setRemindTimeout);
      when(mockSetRemindTimeout)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let liveList: LiveNotification[] = [new LiveNotification()];
      liveList[0].hashCode = '123';
      livedatavm.liveMap.set('123', new LiveNotification());

      await livedatavm.onSingleUpdate(liveList);

      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.updateLiveTimer);
      mocker.ignoreMock(livedatavm.cardListVm, livedatavm.cardListVm.remoteUpdateLive);
      mocker.ignoreMock(livedatavm.capsuleListVm, livedatavm.capsuleListVm.remoteUpdateLive);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm.timerVm, livedatavm.timerVm.deleteLiveTimer);
      mocker.ignoreMock(livedatavm, livedatavm.setRemindTimeout);
    });

    it('should_add_live_when_live_is_valid_and_old_live_does_not_exist', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)([ArgumentMatchers.any]).afterReturn(true);

      let mockOnAdd: Function = mocker.mockFunc(livedatavm, livedatavm.onAdd);
      when(mockOnAdd)([ArgumentMatchers.any]).afterReturn(Promise.resolve());

      let mockSetRemindTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setRemindTimeout);
      when(mockSetRemindTimeout)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let liveList: LiveNotification[] = [new LiveNotification()];
      liveList[0].hashCode = '123';

      await livedatavm.onSingleUpdate(liveList);

      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm, livedatavm.onAdd);
      mocker.ignoreMock(livedatavm, livedatavm.setRemindTimeout);
    });
  });

  describe('onRemove_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_remove_live_list_and_call_removeLive_when_liveList_is_not_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();


      let mockCardListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);
      let mockCapsuleListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);

      when(mockCardListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());
      when(mockCapsuleListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());

      livedatavm.cardListVm = mockCardListVm;
      livedatavm.capsuleListVm = mockCapsuleListVm;

      let liveList: LiveNotification[] = [
        new LiveNotification(),
        new LiveNotification()
      ];
      await livedatavm.onRemove(liveList);

      expect(LogHelper.getMockLog()).assertContain(`Recieve live event: 1, isBatch: true, live length: 2`);

    });

    it('should_do_nothing_when_liveList_is_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();


      let mockCardListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);
      let mockCapsuleListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);

      when(mockCardListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());
      when(mockCapsuleListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());

      livedatavm.cardListVm = mockCardListVm;
      livedatavm.capsuleListVm = mockCapsuleListVm;

      let liveList: LiveNotification[] = [];
      await livedatavm.onRemove(liveList);

      expect(LogHelper.getMockLog()).assertContain(`Recieve live event: 1, isBatch: true, live length: 0`);

    });

    it('should_call_removeLive_when_isClearAllApp_is_true', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      livedatavm.isClearAllApp = true;
      let mocker: MockKit = new MockKit();


      let mockCardListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);
      let mockCapsuleListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);

      when(mockCardListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());
      when(mockCapsuleListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());

      livedatavm.cardListVm = mockCardListVm;
      livedatavm.capsuleListVm = mockCapsuleListVm;

      let liveList: LiveNotification[] = [
        new LiveNotification(),
        new LiveNotification()
      ];
      await livedatavm.onRemove(liveList);

      expect(LogHelper.getMockLog()).assertContain(`Recieve live event: 1, isBatch: true, live length: 2`);

    });

    it('should_call_onOtherCardTimeout_and_onInstantTimeout_when_live_timeout', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();


      let mockCardListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);
      let mockCapsuleListVm: ILiveDataVm = mocker.mockObj(LiveBaseVm.prototype);

      when(mockCardListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());
      when(mockCapsuleListVm.removeLiveList(ArgumentMatchers.anyObj as LiveNotification[]))
        .afterReturn(Promise.resolve());

      livedatavm.cardListVm = mockCardListVm;
      livedatavm.capsuleListVm = mockCapsuleListVm;

      let liveList: LiveNotification[] = [
        new LiveNotification(),
        new LiveNotification()
      ];
      liveList[0].style = LiveStyle.LIVE_CARD;
      liveList[1].style = LiveStyle.LIVE_INSTANT;
      await livedatavm.onRemove(liveList);

      expect(LogHelper.getMockLog()).assertContain(`Recieve live event: 1, isBatch: true, live length: 2`);

    });
  });

  describe('checkLiveValid_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_false_when_live_has_no_capsule', 0, () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.capsule = null;
      const result = livedatavm.checkLiveValid(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });
  });
}
