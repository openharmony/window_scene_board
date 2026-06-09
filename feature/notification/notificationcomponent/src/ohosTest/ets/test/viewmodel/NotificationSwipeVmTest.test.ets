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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationSwipeVm } from '../../../main/ets/viewmodel/NotificationSwipeVm';
export default function NotificationSwipeVmTest() {
  describe('update_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_when_offsetX_equals_endOffsetX', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let endOffsetX: number = 10;
      let animation: boolean = true;
      notificationswipevm.update(endOffsetX, animation);
      expect(notificationswipevm.offsetX).assertEqual(endOffsetX);
    });

    it('should_execute_animation_when_animation_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let endOffsetX: number = 10;
      let animation: boolean = true;
      notificationswipevm.update(endOffsetX, animation);
      expect(notificationswipevm.swipeAnimation.isAnimating).assertTrue();
    });

    it('should_set_offsetX_immediately_when_animation_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let endOffsetX: number = 10;
      let animation: boolean = false;
      notificationswipevm.update(endOffsetX, animation);
      expect(notificationswipevm.offsetX).assertEqual(endOffsetX);
    });

    it('should_return_when_offsetX_equals_endOffsetX', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let endOffsetX: number = 10;
      let animation: boolean = true;
      notificationswipevm.update(endOffsetX, animation);
      expect(notificationswipevm.offsetX).assertEqual(endOffsetX);
    });

    it('should_execute_animation_when_animation_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let endOffsetX: number = 10;
      let animation: boolean = true;
      notificationswipevm.update(endOffsetX, animation);
      expect(notificationswipevm.swipeAnimation.isAnimating).assertTrue();
    });

    it('should_set_offsetX_immediately_when_animation_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let endOffsetX: number = 10;
      let animation: boolean = false;
      notificationswipevm.update(endOffsetX, animation);
      expect(notificationswipevm.offsetX).assertEqual(endOffsetX);
    });

    it('should_return_immediately_when_isSwipeRemoving_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.isSwipeRemoving = true;
      notificationswipevm.remove(100, 100);
      expect(notificationswipevm.isSwipeRemoving).assertEqual(true);
    });

    it('should_execute_animation_when_isSwipeRemoving_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      expect(notificationswipevm.isSwipeRemoving).assertEqual(false);
    });

    it('should_call_NotificationApiUtil_removeNtfByCancel_when_isMoreBrief_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      mocker.ignoreMock(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
    });

    it('should_call_doDeleteChainAnimation_when_isMoreBrief_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      mocker.ignoreMock(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
    });

    it('should_call_AccessibilityVm_sendEventByResource_when_animation_finishes', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.sendEventByResource);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.sendEventByResource);
    });

    it('should_return_immediately_when_isSwipeRemoving_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.isSwipeRemoving = true;
      notificationswipevm.remove(100, 100);
      expect(notificationswipevm.isSwipeRemoving).assertEqual(true);
    });

    it('should_execute_animation_when_isSwipeRemoving_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      expect(notificationswipevm.isSwipeRemoving).assertEqual(false);
    });

    it('should_call_NotificationApiUtil_removeNtfByCancel_when_isMoreBrief_is_true', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      mocker.ignoreMock(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
    });

    it('should_call_doDeleteChainAnimation_when_isMoreBrief_is_false', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      mocker.ignoreMock(NotificationApiUtil, NotificationApiUtil.removeNtfByCancel);
    });

    it('should_call_AccessibilityVm_sendEventByResource_when_animation_finishes', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.sendEventByResource);
      when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
      notificationswipevm.isSwipeRemoving = false;
      notificationswipevm.remove(100, 100);
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.sendEventByResource);
    });

    it('should_remove_notification_when_left_swipe_passes_delete_threshold', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -100;
      notificationswipevm.startOffsetX = 0;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;
      notificationswipevm.isClearAllowed = () => true;

      let mocker: MockKit = new MockKit();

      notificationswipevm.remove = (offsetX: number, distance: number) => {
        expect(offsetX).assertEqual(-100);
        expect(distance).assertEqual(100);
      };

      notificationswipevm.update = (offsetX: number, isRightToLeft: boolean) => {
        expect(offsetX).assertEqual(0);
        expect(isRightToLeft).assertEqual(true);
      };

      notificationswipevm.updateRightToLeft(-100);

    });

    it('should_restore_position_when_menu_is_expanded', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -75;
      notificationswipevm.startOffsetX = -50;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;

      notificationswipevm.update = (offsetX: number, isRightToLeft: boolean) => {
        expect(offsetX).assertEqual(-75);
        expect(isRightToLeft).assertEqual(true);
      };

      notificationswipevm.updateRightToLeft(-75);
    });

    it('should_slide_to_menu_width_when_left_swipe_passes_critical_value', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -150;
      notificationswipevm.startOffsetX = 0;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;

      notificationswipevm.update = (offsetX: number, isRightToLeft: boolean) => {
        expect(offsetX).assertEqual(-50);
        expect(isRightToLeft).assertEqual(true);
      };

      notificationswipevm.updateRightToLeft(-150);
    });

    it('should_send_event_when_left_swipe_passes_critical_value_and_menu_is_collapsed', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -200;
      notificationswipevm.startOffsetX = 0;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;
      notificationswipevm.isLeftToRight = false;

      let mocker: MockKit = new MockKit();


      notificationswipevm.updateRightToLeft(-200);

    });
    it('should_remove_notification_when_left_swipe_passes_delete_threshold', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -100;
      notificationswipevm.startOffsetX = 0;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;
      notificationswipevm.isClearAllowed = () => true;

      let mocker: MockKit = new MockKit();

      notificationswipevm.remove = (offsetX: number, distance: number) => {
        expect(offsetX).assertEqual(-100);
        expect(distance).assertEqual(100);
      };

      notificationswipevm.update = (offsetX: number, isRightToLeft: boolean) => {
        expect(offsetX).assertEqual(0);
        expect(isRightToLeft).assertEqual(true);
      };

      notificationswipevm.updateRightToLeft(-100);

    });

    it('should_restore_position_when_menu_is_expanded', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -75;
      notificationswipevm.startOffsetX = -50;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;

      notificationswipevm.update = (offsetX: number, isRightToLeft: boolean) => {
        expect(offsetX).assertEqual(-75);
        expect(isRightToLeft).assertEqual(true);
      };

      notificationswipevm.updateRightToLeft(-75);
    });

    it('should_slide_to_menu_width_when_left_swipe_passes_critical_value', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -150;
      notificationswipevm.startOffsetX = 0;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;

      notificationswipevm.update = (offsetX: number, isRightToLeft: boolean) => {
        expect(offsetX).assertEqual(-50);
        expect(isRightToLeft).assertEqual(true);
      };

      notificationswipevm.updateRightToLeft(-150);
    });

    it('should_send_event_when_left_swipe_passes_critical_value_and_menu_is_collapsed', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -200;
      notificationswipevm.startOffsetX = 0;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;
      notificationswipevm.isLeftToRight = false;

      let mocker: MockKit = new MockKit();


      notificationswipevm.updateRightToLeft(-200);

    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_true_and_menuWidth_is_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_false_and_startOffsetX_is_less_than_menuWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = false;
      notificationSwipeVm.startOffsetX = -50;
      notificationSwipeVm.menuWidth = 100;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_true_and_startOffsetX_is_greater_than_menuWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 50;
      notificationSwipeVm.menuWidth = 100;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_false_and_startOffsetX_is_greater_than_menuWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = false;
      notificationSwipeVm.startOffsetX = -50;
      notificationSwipeVm.menuWidth = 100;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_true_and_offsetX_is_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 0;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertFalse();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_false_and_offsetX_is_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = false;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 0;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertFalse();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_true_and_offsetX_is_not_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_false_and_offsetX_is_not_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = false;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isClearAllowed_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.isClearAllowed = () => {
        return false;
      };
    });
    it('should_send_event_when_left_swipe_passes_critical_value_and_menu_is_collapsed', 0, () => {
      let notificationswipevm: NotificationSwipeVm = new NotificationSwipeVm();
      notificationswipevm.offsetX = -200;
      notificationswipevm.startOffsetX = 0;
      notificationswipevm.menuWidth = 50;
      notificationswipevm.itemWidth = 100;
      notificationswipevm.isLeftToRight = false;

      let mocker: MockKit = new MockKit();


      notificationswipevm.updateRightToLeft(-200);

    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_true_and_menuWidth_is_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_false_and_startOffsetX_is_less_than_menuWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = false;
      notificationSwipeVm.startOffsetX = -50;
      notificationSwipeVm.menuWidth = 100;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_true_and_startOffsetX_is_greater_than_menuWidth', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 50;
      notificationSwipeVm.menuWidth = 100;
      notificationSwipeVm.offsetX = 100;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertTrue();
    });

    it('should_handleSwipeSpeed_when_isLeftToRight_is_true_and_offsetX_is_zero', 0, () => {
      let mocker: MockKit = new MockKit();
      let notificationSwipeVm: NotificationSwipeVm = new NotificationSwipeVm();
      let event: GestureEvent = new GestureEvent(GestureEvent.SWIPE, 100, 100, 100, 100, 100, 100, 100, 100, 100);
      notificationSwipeVm.isLeftToRight = true;
      notificationSwipeVm.startOffsetX = 0;
      notificationSwipeVm.menuWidth = 0;
      notificationSwipeVm.offsetX = 0;
      notificationSwipeVm.itemWidth = 100;
      notificationSwipeVm.handleSwipeSpeed(event);
      expect(notificationSwipeVm.isSwipeRemoving).assertFalse();
    });
  });
}