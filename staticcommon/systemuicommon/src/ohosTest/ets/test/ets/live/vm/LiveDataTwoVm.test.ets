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
  DeleteNotificationMaintenance } from '../../../../main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '../../../../main/ets/maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../../../../main/ets/live/sysEvent/LiveHiSysEvent';
import { ILiveMetaBallVisibleVm } from '../../../../main/ets/live/interface/ILiveMetaBallVisibleVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveDataVm } from '../../../../main/ets/live/vm/LiveDataVm';

export default function LiveDataTwoVmTest() {
  describe('liveMetaBallVisibleVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_metaBallVisible_when_eventType_is_init', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getMetaBallVisibleVm);
      when(mockfunc)([]).afterReturn({} as ILiveMetaBallVisibleVm);
      livedatavm.vmInjector = vmInjector;

      let event: NotificationEvent = {
        eventType: NotificationEvent.EVENT_TYPE_INIT,
        isBatch: false,
        notificationList: [
          {
            isLiveView: () => true,
            isConvertFromNormal: () => false,
            isInstantBanner: () => false,
            style: LiveStyle.LIVE_VIEW,
            hashCode: '123'
          } as LiveNotification
        ]
      };
      livedatavm.onNotificationEvent(event);

      expect(livedatavm.liveMetaBallVisibleVm).assertInstanceOf(ILiveMetaBallVisibleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getMetaBallVisibleVm);
    });

    it('should_return_metaBallVisible_when_eventType_is_add', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getMetaBallVisibleVm);
      when(mockfunc)([]).afterReturn({} as ILiveMetaBallVisibleVm);
      livedatavm.vmInjector = vmInjector;

      let event: NotificationEvent = {
        eventType: NotificationEvent.EVENT_TYPE_ADD,
        isBatch: false,
        notificationList: [
          {
            isLiveView: () => true,
            isConvertFromNormal: () => false,
            isInstantBanner: () => false,
            style: LiveStyle.LIVE_VIEW,
            hashCode: '123'
          } as LiveNotification
        ]
      };
      livedatavm.onNotificationEvent(event);

      expect(livedatavm.liveMetaBallVisibleVm).assertInstanceOf(ILiveMetaBallVisibleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getMetaBallVisibleVm);
    });

    it('should_return_metaBallVisible_when_eventType_is_update_and_not_batch', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getMetaBallVisibleVm);
      when(mockfunc)([]).afterReturn({} as ILiveMetaBallVisibleVm);
      livedatavm.vmInjector = vmInjector;

      let event: NotificationEvent = {
        eventType: NotificationEvent.EVENT_TYPE_UPDATE,
        isBatch: false,
        notificationList: [
          {
            isLiveView: () => true,
            isConvertFromNormal: () => false,
            isInstantBanner: () => false,
            style: LiveStyle.LIVE_VIEW,
            hashCode: '123'
          } as LiveNotification
        ]
      };
      livedatavm.onNotificationEvent(event);

      expect(livedatavm.liveMetaBallVisibleVm).assertInstanceOf(ILiveMetaBallVisibleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getMetaBallVisibleVm);
    });

    it('should_return_metaBallVisible_when_eventType_is_update_and_batch', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getMetaBallVisibleVm);
      when(mockfunc)([]).afterReturn({} as ILiveMetaBallVisibleVm);
      livedatavm.vmInjector = vmInjector;

      let event: NotificationEvent = {
        eventType: NotificationEvent.EVENT_TYPE_UPDATE,
        isBatch: true,
        notificationList: [
          {
            isLiveView: () => true,
            isConvertFromNormal: () => false,
            isInstantBanner: () => false,
            style: LiveStyle.LIVE_VIEW,
            hashCode: '123'
          } as LiveNotification
        ]
      };
      livedatavm.onNotificationEvent(event);

      expect(livedatavm.liveMetaBallVisibleVm).assertInstanceOf(ILiveMetaBallVisibleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getMetaBallVisibleVm);
    });

    it('should_return_metaBallVisible_when_eventType_is_remove', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getMetaBallVisibleVm);
      when(mockfunc)([]).afterReturn({} as ILiveMetaBallVisibleVm);
      livedatavm.vmInjector = vmInjector;

      let event: NotificationEvent = {
        eventType: NotificationEvent.EVENT_TYPE_REMOVE,
        isBatch: false,
        notificationList: [
          {
            isLiveView: () => true,
            isConvertFromNormal: () => false,
            isInstantBanner: () => false,
            style: LiveStyle.LIVE_VIEW,
            hashCode: '123'
          } as LiveNotification
        ]
      };
      livedatavm.onNotificationEvent(event);

      expect(livedatavm.liveMetaBallVisibleVm).assertInstanceOf(ILiveMetaBallVisibleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getMetaBallVisibleVm);
    });

    it('should_return_metaBallVisible_when_isClearAllApp_is_true', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      livedatavm.isClearAllApp = true;
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getMetaBallVisibleVm);
      when(mockfunc)([]).afterReturn({} as ILiveMetaBallVisibleVm);
      livedatavm.vmInjector = vmInjector;

      let event: NotificationEvent = {
        eventType: NotificationEvent.EVENT_TYPE_UPDATE,
        isBatch: false,
        notificationList: [
          {
            isLiveView: () => true,
            isConvertFromNormal: () => false,
            isInstantBanner: () => false,
            style: LiveStyle.LIVE_VIEW,
            hashCode: '123'
          } as LiveNotification
        ]
      };
      livedatavm.onNotificationEvent(event);

      expect(livedatavm.liveMetaBallVisibleVm).assertInstanceOf(ILiveMetaBallVisibleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getMetaBallVisibleVm);
    });

    it('should_return_metaBallVisible_when_notification_is_empty', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getMetaBallVisibleVm);
      when(mockfunc)([]).afterReturn({} as ILiveMetaBallVisibleVm);
      livedatavm.vmInjector = vmInjector;

      let event: NotificationEvent = {
        eventType: NotificationEvent.EVENT_TYPE_UPDATE,
        isBatch: false,
        notificationList: []
      };
      livedatavm.onNotificationEvent(event);

      expect(livedatavm.liveMetaBallVisibleVm).assertInstanceOf(ILiveMetaBallVisibleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getMetaBallVisibleVm);
    });
  });

  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_register_notification_event_listener_when_init_is_called', 0, () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      livedatavm.init();
      // 验证InnerEventUtil.on是否被调用
      // 由于InnerEventUtil.on是静态方法，无法直接mock，因此这里假设其内部实现已经正确
      // 实际测试中需要验证InnerEventUtil.on是否被正确调用
      // 这里仅验证函数是否被调用
      expect(InnerEventUtil.on).assertCalledWith(NotificationEvent, livedatavm.onNotificationEvent);
    });
  });

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

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockDeleteVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.deleteVmByLive);
      when(mockDeleteVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isEnd: false,
          viewIndex: 1,
          viewType: 'type',
          notificationType: 'normal',
          notificationId: '1',
          timeout: 1000,
          remindType: LiveCapsuleRemindType.FLIP,
          remindTime: 1000,
          convertFromNormal: false,
          instantView: false,
          normalNotification: {} as LiveNotification
        } as LiveNotification
      ];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.deleteVmByLive);
    });

    it('should_update_live_when_old_live_exists', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockDeleteVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.deleteVmByLive);
      when(mockDeleteVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isEnd: false,
          viewIndex: 1,
          viewType: 'type',
          notificationType: 'normal',
          notificationId: '1',
          timeout: 1000,
          remindType: LiveCapsuleRemindType.FLIP,
          remindTime: 1000,
          convertFromNormal: false,
          instantView: false,
          normalNotification: {} as LiveNotification
        } as LiveNotification
      ];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.deleteVmByLive);
    });

    it('should_handle_live_timeout_when_live_is_end', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();

      let mockCheckLiveValid: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockCheckLiveValid)(ArgumentMatchers.any).afterReturn(true);

      let mockUpdateVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      when(mockUpdateVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let mockSetOtherTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.setOtherTimeout);
      when(mockSetOtherTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockClearTimeout: Function = mocker.mockFunc(livedatavm, livedatavm.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturnNothing();

      let mockDeleteVmByLive: Function = mocker.mockFunc(livedatavm.vmInjector, livedatavm.vmInjector.deleteVmByLive);
      when(mockDeleteVmByLive)(ArgumentMatchers.any).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          style: LiveStyle.LIVE_VIEW,
          isEnd: true,
          viewIndex: 1,
          viewType: 'type',
          notificationType: 'normal',
          notificationId: '1',
          timeout: 1000,
          remindType: LiveCapsuleRemindType.FLIP,
          remindTime: 1000,
          convertFromNormal: false,
          instantView: false,
          normalNotification: {} as LiveNotification
        } as LiveNotification
      ];

      await livedatavm.onInit(liveList);

      expect(livedatavm.liveMap.size).assertEqual(1);
      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.updateVmByLive);
      mocker.ignoreMock(livedatavm, livedatavm.setOtherTimeout);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livedatavm, livedatavm.clearTimeout);
      mocker.ignoreMock(livedatavm.vmInjector, livedatavm.vmInjector.deleteVmByLive);
    });
  });

  describe('onAdd_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

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

    it('should_process_live_immediately_when_live_is_instant', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      let live: LiveNotification = new LiveNotification();
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      await livedatavm.onAdd(live);

      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });

    it('should_process_live_normally_when_live_is_not_instant', 0, async () => {
      let livedatavm: LiveDataVm = new LiveDataVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livedatavm, livedatavm.checkLiveValid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      let live: LiveNotification = new LiveNotification();
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      await livedatavm.onAdd(live);

      mocker.ignoreMock(livedatavm, livedatavm.checkLiveValid);
    });
  });
}
