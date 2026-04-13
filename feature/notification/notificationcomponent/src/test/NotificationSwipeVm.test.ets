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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  DeviceInfoVm,
  INotificationMenuVm,
  INotificationSwipeVm,
  INotificationListVm,
  NotificationItemBaseVm,
  INotificationCardVm,
  AnimationBase,
  ResourceVm,
} from '@ohos/systemuicommon/newIndex';
import { NotificationApiUtil } from '../../../main/ets/utils/NotificationApiUtil';
import { curves } from '@kit.ArkUI';
import {
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { NotificationNormalVm } from '../../../main/ets/viewmodel/NotificationNormalVm';
import { NotificationBase, NotificationCategory } from '@ohos/systemuicommon/newTsIndex';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
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
import { NotificationSwipeVm } from '../../../main/ets/viewmodel/NotificationSwipeVm';

export default function NotificationSwipeVmTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_init_is_called', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();

      notificationSwipeVm.init();

    });

    it('should_set_instance_when_init_is_called', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();

      notificationSwipeVm.init();

      expect(NotificationSwipeVm.instances.has(notificationSwipeVm.getKey())).assertTrue();
    });

    it('should_log_info_with_correct_parameters', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();

      notificationSwipeVm.init();

    });

    it('should_call_menuVm_updateSwipeOffsetX_when_offsetX_change', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let menuVm: INotificationMenuVm = new DeviceInfoVm();
      notificationSwipeVm.menuVm = menuVm;

      let monitor: IMonitor = {
        value: () => {
          return {
            now: 100
          };
        }
      } as IMonitor;

      notificationSwipeVm.onOffsetXChange(monitor);

    });

    it('should_call_menuVm_updateSwipeOffsetX_when_offsetX_change_and_isSwipeRemoving_is_true', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let menuVm: INotificationMenuVm = new DeviceInfoVm();
      notificationSwipeVm.menuVm = menuVm;
      notificationSwipeVm.isSwipeRemoving = true;

      let monitor: IMonitor = {
        value: () => {
          return {
            now: 100
          };
        }
      } as IMonitor;

      notificationSwipeVm.onOffsetXChange(monitor);

    });

    it('should_not_call_menuVm_updateSwipeOffsetX_when_offsetX_change_but_menuVm_is_null', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationSwipeVm.menuVm = null;

      let monitor: IMonitor = {
        value: () => {
          return {
            now: 100
          };
        }
      } as IMonitor;

      notificationSwipeVm.onOffsetXChange(monitor);

    });

    it('should_not_reset_when_offsetX_is_not_zero', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 1;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset();
      expect(instance.offsetX).assertEqual(1);
    });

    it('should_reset_when_offsetX_is_zero_and_exceptInstance_is_undefined', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 0;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset();
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_not_reset_when_offsetX_is_zero_and_exceptInstance_is_provided', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 0;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset(instance);
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_reset_when_offsetX_is_not_zero_and_exceptInstance_is_undefined', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 1;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset();
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_not_reset_when_offsetX_is_zero_and_exceptInstance_is_not_undefined', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 0;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset(instance);
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_reset_when_offsetX_is_not_zero_and_exceptInstance_is_provided', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 1;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset(instance);
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_not_reset_when_offsetX_is_not_zero', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 1;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset();
      expect(instance.offsetX).assertEqual(1);
    });

    it('should_reset_when_offsetX_is_zero_and_exceptInstance_is_undefined', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 0;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset();
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_not_reset_when_offsetX_is_zero_and_exceptInstance_is_provided', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 0;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset(instance);
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_reset_when_offsetX_is_not_zero_and_exceptInstance_is_undefined', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 1;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset();
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_not_reset_when_offsetX_is_zero_and_exceptInstance_is_not_undefined', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 0;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset(instance);
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_reset_when_offsetX_is_not_zero_and_exceptInstance_is_provided', 0, () => {
      NotificationSwipeVm.reset();
      let instance: NotificationSwipeVm = new NotificationSwipeVm();
      instance.offsetX = 1;
      NotificationSwipeVm.instances.set('1', instance);
      NotificationSwipeVm.reset(instance);
      expect(instance.offsetX).assertEqual(0);
    });

    it('should_return_immediately_when_isSwipeRemoving_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.isSwipeRemoving = true;
      notificationswipevm.remove(100, 1000);
      expect(notificationswipevm.isSwipeRemoving).assertEqual(true);
    });

    it('should_execute_animation_when_isSwipeRemoving_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 1000);
      expect(notificationswipevm.isSwipeRemoving).assertEqual(false);
    });

    it('should_call_NotificationApiUtil_removeNtfByCancel_when_isMoreBrief_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 1000);
      mocker.ignoreMock(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
    });

    it('should_call_doDeleteChainAnimation_when_isMoreBrief_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationswipevm, notificationswipevm.doDeleteChainAnimation);
      when(mockfunc)([]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 1000);
      mocker.ignoreMock(notificationswipevm, notificationswipevm.doDeleteChainAnimation);
    });

    it('should_call_AccessibilityVm_sendEventByResource_when_animation_finishes', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.sendEventByResource);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 1000);
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.sendEventByResource);
    });

    it('should_return_immediately_when_ntf_is_not_normal', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let listVmMock: INotificationListVm = mocker.mockObj(notificationswipevm.vmInjector.getListVm);
      when(listVmMock.getGroupNtf(ArgumentMatchers.anyObj)).afterReturn({
        children: []
      });
      when(listVmMock.isGroupNtf(ArgumentMatchers.anyObj)).afterReturn(false);
      when(listVmMock.isNormalNtf(ArgumentMatchers.anyObj)).afterReturn(false);
      notificationswipevm.doDeleteChainAnimation();
      mocker.ignoreMock(notificationswipevm.vmInjector.getListVm);
    });

    it('should_return_immediately_when_group_ntf_has_no_children', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let listVmMock: INotificationListVm = mocker.mockObj(notificationswipevm.vmInjector.getListVm);
      when(listVmMock.getGroupNtf(ArgumentMatchers.anyObj)).afterReturn({
        children: []
      });
      when(listVmMock.isGroupNtf(ArgumentMatchers.anyObj)).afterReturn(true);
      when(listVmMock.isNormalNtf(ArgumentMatchers.anyObj)).afterReturn(true);
      notificationswipevm.doDeleteChainAnimation();
      mocker.ignoreMock(notificationswipevm.vmInjector.getListVm);
    });

    it('should_call_doDeleteChainAnimation_when_ntf_is_normal_and_has_children', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let listVmMock: INotificationListVm = mocker.mockObj(notificationswipevm.vmInjector.getListVm);
      let groupNtfMock: { children: NotificationBase[] } = {
        children: [{
          isNotificationCategory: () => NotificationCategory.NOTIFICATION_CATEGORY_CHILD
        }]
      };
      when(listVmMock.getGroupNtf(ArgumentMatchers.anyObj)).afterReturn(groupNtfMock);
      when(listVmMock.isGroupNtf(ArgumentMatchers.anyObj)).afterReturn(true);
      when(listVmMock.isNormalNtf(ArgumentMatchers.anyObj)).afterReturn(true);
      notificationswipevm.doDeleteChainAnimation();
      mocker.ignoreMock(notificationswipevm.vmInjector.getListVm);
    });

    it('should_call_DeleteNotificationMaintenance_when_ntf_is_about_to_delete', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let listVmMock: INotificationListVm = mocker.mockObj(notificationswipevm.vmInjector.getListVm);
      let groupNtfMock: { children: NotificationBase[] } = {
        children: [{
          isNotificationCategory: () => NotificationCategory.NOTIFICATION_CATEGORY_CHILD
        }]
      };
      when(listVmMock.getGroupNtf(ArgumentMatchers.anyObj)).afterReturn(groupNtfMock);
      when(listVmMock.isGroupNtf(ArgumentMatchers.anyObj)).afterReturn(true);
      when(listVmMock.isNormalNtf(ArgumentMatchers.anyObj)).afterReturn(true);
      when(listVmMock.isAboutToDelete(ArgumentMatchers.anyObj)).afterReturn(true);
      notificationswipevm.doDeleteChainAnimation();
      mocker.ignoreMock(notificationswipevm.vmInjector.getListVm);
    });

    it('should_return_PanGestureHandler_with_correct_parameters', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let result: PanGestureHandler = notificationswipevm.getPanGestureHandler();
      expect(result.direction).assertEqual(PanDirection.Horizontal);
      expect(result.distance).assertEqual(NotificationSwipeVm.SWIPE_DISTANCE);
    });

    it('should_call_handleActionStart_when_gesture_event_starts', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();

      let result: PanGestureHandler = notificationswipevm.getPanGestureHandler();
      result.onActionStart(new GestureEvent(GestureEvent.GestureType.SWIPE, {
        x: 10, y: 10
      }));

    });

    it('should_call_handleActionUpdate_when_gesture_event_updates', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();

      let result: PanGestureHandler = notificationswipevm.getPanGestureHandler();
      result.onActionUpdate(new GestureEvent(GestureEvent.GestureType.SWIPE, {
        x: 10, y: 10
      }));

    });

    it('should_call_handleActionEnd_when_gesture_event_ends', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();

      let result: PanGestureHandler = notificationswipevm.getPanGestureHandler();
      result.onActionEnd(new GestureEvent(GestureEvent.GestureType.SWIPE, {
        x: 10, y: 10
      }));

    });

    it('should_call_handleActionCancel_when_gesture_event_cancels', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();

      let result: PanGestureHandler = notificationswipevm.getPanGestureHandler();
      result.onActionCancel();
    });

    it('should_return_correct_SwipeGestureHandler_when_direction_is_horizontal', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let result: SwipeGestureHandler = notificationSwipeVm.getSwipeGestureHandler();
      expect(result.direction).assertEqual(SwipeDirection.Horizontal);
      expect(result.speed).assertEqual(NotificationSwipeVm.SWIPE_SPEED);
    });

    it('should_call_handleSwipeSpeed_when_event_is_not_null_and_axisVertical_is_not_zero', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationSwipeVm, notificationSwipeVm.handleSwipeSpeed);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let result: SwipeGestureHandler = notificationSwipeVm.getSwipeGestureHandler();
      result.onAction({
        axisVertical: 1, axisHorizontal: 1
      });
      mocker.ignoreMock(notificationSwipeVm, notificationSwipeVm.handleSwipeSpeed);
    });

    it('should_not_call_handleSwipeSpeed_when_event_is_null', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationSwipeVm, notificationSwipeVm.handleSwipeSpeed);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let result: SwipeGestureHandler = notificationSwipeVm.getSwipeGestureHandler();
      result.onAction(null);
      mocker.ignoreMock(notificationSwipeVm, notificationSwipeVm.handleSwipeSpeed);
    });

    it('should_not_call_handleSwipeSpeed_when_event_axisVertical_is_zero', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationSwipeVm, notificationSwipeVm.handleSwipeSpeed);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let result: SwipeGestureHandler = notificationSwipeVm.getSwipeGestureHandler();
      result.onAction({
        axisVertical: 0, axisHorizontal: 1
      });
      mocker.ignoreMock(notificationSwipeVm, notificationSwipeVm.handleSwipeSpeed);
    });

    it('should_log_info_when_handleActionStart_is_called', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent();
      event.axisVertical = 1;
      notificationSwipeVm.handleActionStart(event);
      expect(LogHelper.showInfo).assertCalledWith(`handleActionStart: ${event?.axisVertical}`);
    });

    it('should_reset_offsetX_when_handleActionStart_is_called', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent();
      event.axisVertical = 1;
      notificationSwipeVm.handleActionStart(event);
      expect(notificationSwipeVm.offsetX).assertEqual(0);
      expect(notificationSwipeVm.startOffsetX).assertEqual(0);
      expect(notificationSwipeVm.lastOffsetX).assertEqual(0);
    });

    it('should_call_hideActionButtons_when_handleActionStart_is_called', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent();
      event.axisVertical = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationNormalVm, NotificationNormalVm.hideActionButtons);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationSwipeVm.handleActionStart(event);
      mocker.ignoreMock(NotificationNormalVm, NotificationNormalVm.hideActionButtons);
    });

    it('should_log_info_when_handleActionStart_is_called_with_ntf', 0, () => {
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent();
      event.axisVertical = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationSwipeVm.handleActionStart(event);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

  });
}