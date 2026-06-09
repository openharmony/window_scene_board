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
import { INotificationActionButtonVm, INotificationCardVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import {
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { NotificationAction } from '@ohos/systemuicommon/src/main/ets/model/NotificationContent';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationActionButtonVm } from '../../../main/ets/viewmodel/NotificationActionButtonVm';
export default function NotificationActionButtonVmTest() {
  describe('onClickActionButton_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_replyAction_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      notificationactionbuttonvm.onClickActionButton(action);
      expect(notificationactionbuttonvm.replyAction).assertDeepEquals(action);
    });

    it('should_not_set_replyAction_when_action_has_no_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = '';
      notificationactionbuttonvm.onClickActionButton(action);
      expect(notificationactionbuttonvm.replyAction).assertNull();
    });

    it('should_call_saveInfo_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      let mocker: MockKit = new MockKit();

      notificationactionbuttonvm.onClickActionButton(action);

    });

    it('should_call_startWantAgent_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      let mocker: MockKit = new MockKit();
      let mockGetCardVm: Function = mocker.mockFunc(notificationactionbuttonvm, notificationactionbuttonvm.getCardVm);
      when(mockGetCardVm)(ArgumentMatchers.any).afterReturn(new NotificationItemBaseVm());

      notificationactionbuttonvm.onClickActionButton(action);

      mocker.ignoreMock(notificationactionbuttonvm, notificationactionbuttonvm.getCardVm);
    });

    it('should_set_replyAction_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      notificationactionbuttonvm.onClickActionButton(action);
      expect(notificationactionbuttonvm.replyAction).assertDeepEquals(action);
    });

    it('should_not_set_replyAction_when_action_has_no_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = '';
      notificationactionbuttonvm.onClickActionButton(action);
      expect(notificationactionbuttonvm.replyAction).assertNull();
    });

    it('should_call_saveInfo_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      let mocker: MockKit = new MockKit();

      notificationactionbuttonvm.onClickActionButton(action);

    });

    it('should_call_startWantAgent_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      let mocker: MockKit = new MockKit();
      let mockGetCardVm: Function = mocker.mockFunc(notificationactionbuttonvm, notificationactionbuttonvm.getCardVm);
      when(mockGetCardVm)(ArgumentMatchers.any).afterReturn(new NotificationItemBaseVm());

      notificationactionbuttonvm.onClickActionButton(action);

      mocker.ignoreMock(notificationactionbuttonvm, notificationactionbuttonvm.getCardVm);
    });

    it('should_set_replyAction_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      notificationactionbuttonvm.onClickActionButton(action);
      expect(notificationactionbuttonvm.replyAction).assertDeepEquals(action);
    });

    it('should_not_set_replyAction_when_action_has_no_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = '';
      notificationactionbuttonvm.onClickActionButton(action);
      expect(notificationactionbuttonvm.replyAction).assertNull();
    });

    it('should_call_saveInfo_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      let mocker: MockKit = new MockKit();

      notificationactionbuttonvm.onClickActionButton(action);

    });

    it('should_call_startWantAgent_when_action_has_userInputKey', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let action: NotificationAction = new NotificationAction();
      action.userInputKey = 'testKey';
      let mocker: MockKit = new MockKit();
      let mockGetCardVm: Function = mocker.mockFunc(notificationactionbuttonvm, notificationactionbuttonvm.getCardVm);
      when(mockGetCardVm)(ArgumentMatchers.any).afterReturn(new NotificationItemBaseVm());

      notificationactionbuttonvm.onClickActionButton(action);

      mocker.ignoreMock(notificationactionbuttonvm, notificationactionbuttonvm.getCardVm);
    });

    it('should_set_isTouched_to_true_when_event_type_is_Down', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Down;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(true);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Move_and_touch_position_is_out_of_bounds', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation();
      event.touches[0].x = -1;
      event.target.area.width = 100;
      event.target.area.height = 100;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Move_and_touch_position_is_in_bounds', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation();
      event.touches[0].x = 50;
      event.target.area.width = 100;
      event.target.area.height = 100;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      event.stopPropagation();
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_call_HiDfxEventUtil_reportNotificationReplyInputContent_when_event_type_is_Down', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Down;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplyInputContent);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplyInputContent);
    });

    it('should_call_HiDfxEventUtil_reportNotificationReplySend_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplySend);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplySend);
    });

    it('should_call_ClickNotificationMaintenance_saveInfo_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo);
    });

    it('should_call_vmInjector_getStarterVm_startWantAgent_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationactionbuttonvm.vmInjector.getStarterVm(), notificationactionbuttonvm.vmInjector.getStarterVm().startWantAgent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(notificationactionbuttonvm.vmInjector.getStarterVm(), notificationactionbuttonvm.vmInjector.getStarterVm().startWantAgent);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_false', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = false;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_true_and_replyAction_is_undefined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      notificationactionbuttonvm.replyAction = undefined;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_true_and_replyAction_is_defined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      notificationactionbuttonvm.replyAction = new NotificationAction();
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_false_and_replyAction_is_defined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = false;
      notificationactionbuttonvm.replyAction = new NotificationAction();
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_false_and_replyAction_is_undefined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = false;
      notificationactionbuttonvm.replyAction = undefined;
      notificationactionbuttonvm.onTouchEvent(event);
    });

    it('should_set_isTouched_to_true_when_event_type_is_Down', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Down;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(true);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Move_and_touch_position_is_out_of_bounds', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation();
      event.touches[0].x = -1;
      event.target.area.width = 100;
      event.target.area.height = 100;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Move_and_touch_position_is_in_bounds', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation();
      event.touches[0].x = 50;
      event.target.area.width = 100;
      event.target.area.height = 100;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_call_HiDfxEventUtil_reportNotificationReplyInputContent_when_event_type_is_Down', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Down;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplyInputContent);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplyInputContent);
    });

    it('should_call_HiDfxEventUtil_reportNotificationReplySend_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplySend);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplySend);
    });

    it('should_call_ClickNotificationMaintenance_saveInfo_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo);
    });

    it('should_call_vmInjector_getStarterVm_startWantAgent_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationactionbuttonvm.vmInjector.getStarterVm(), notificationactionbuttonvm.vmInjector.getStarterVm().startWantAgent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(notificationactionbuttonvm.vmInjector.getStarterVm(), notificationactionbuttonvm.vmInjector.getStarterVm().startWantAgent);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_false', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = false;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_true_and_replyAction_is_undefined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      notificationactionbuttonvm.replyAction = undefined;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_true_and_replyAction_is_defined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      notificationactionbuttonvm.replyAction = new NotificationAction();
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_false_and_replyAction_is_defined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = false;
      notificationactionbuttonvm.replyAction = new NotificationAction();
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Move_and_touch_position_is_out_of_bounds', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation();
      event.touches[0].x = -1;
      event.target.area.width = 100;
      event.target.area.height = 100;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Move_and_touch_position_is_in_bounds', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Move;
      event.stopPropagation();
      event.touches[0].x = 50;
      event.target.area.width = 100;
      event.target.area.height = 100;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      event.stopPropagation();
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_call_HiDfxEventUtil_reportNotificationReplyInputContent_when_event_type_is_Down', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Down;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplyInputContent);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplyInputContent);
    });

    it('should_call_HiDfxEventUtil_reportNotificationReplySend_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplySend);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNotificationReplySend);
    });

    it('should_call_ClickNotificationMaintenance_saveInfo_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo);
    });

    it('should_call_vmInjector_getStarterVm_startWantAgent_when_event_type_is_Up_and_isReplying_is_true', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationactionbuttonvm.vmInjector.getStarterVm(), notificationactionbuttonvm.vmInjector.getStarterVm().startWantAgent);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(undefined);
      notificationactionbuttonvm.onTouchEvent(event);
      mocker.ignoreMock(notificationactionbuttonvm.vmInjector.getStarterVm(), notificationactionbuttonvm.vmInjector.getStarterVm().startWantAgent);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_true_and_replyAction_is_undefined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = true;
      notificationactionbuttonvm.replyAction = undefined;
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

    it('should_set_isTouched_to_false_when_event_type_is_Up_and_isReplying_is_false_and_replyAction_is_defined', 0, () => {
      let notificationactionbuttonvm: NotificationActionButtonVm = new NotificationActionButtonVm();
      let event: TouchEvent = new TouchEvent();
      event.type = TouchType.Up;
      notificationactionbuttonvm.isReplying = false;
      notificationactionbuttonvm.replyAction = new NotificationAction();
      notificationactionbuttonvm.onTouchEvent(event);
      expect(notificationactionbuttonvm.isTouched).assertEqual(false);
    });

  });
}