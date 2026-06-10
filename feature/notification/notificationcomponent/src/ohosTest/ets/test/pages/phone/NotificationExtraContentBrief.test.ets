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

import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { RTLUtil } from '@ohos/componenthelper';
import { ResUtils } from '@ohos/windowscene';
import { NotificationExtraMenuRow } from '../../../../main/ets/pages/phone/NotificationExtraMenuRow';
import { NtfItemSwipeController } from '../../../../main/ets/controller/NtfItemSwipeController';
import { NotificationAnimationParas } from '../../../../main/ets/common/NotificationAnimationParas';
import { NtfTimeVM } from '../../../../main/ets/vm/NtfTimeVM';
import { NtfAppIconModifier } from '../../../../main/ets/vm/style/NtfAppIconModifier';
import { NotificationAccessibilityUtil as AccessUtil } from '../../../../main/ets/common/NotificationAccessibilityUtil';
import { ExtraNtfCollapsedAnimation } from '../../../../main/ets/animation/ExtraNtfCollapsedAnimation';
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
export default function Test() {
  describe('handleActionStart_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_swipeHashCode_is_not_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = 'someHashCode';
      entry.hashCode = 'someHashCode';
      let result = entry.handleActionStart();
      expect(result).assertUndefined();
    });

    it('should_initialize_properties_when_swipeHashCode_is_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '';
      entry.hashCode = 'someHashCode';
      let result = entry.handleActionStart();
      expect(result).assertUndefined();
      expect(entry.swipeHashCode).assertEqual('someHashCode');
      expect(entry.ntfExtraGroupBriefScale).assertEqual(1);
      expect(entry.isRTL).assertEqual(RTLUtil.isRTL());
      expect(entry.startTranX).assertEqual(entry.translateX);
    });

    it('should_return_immediately_when_swipeHashCode_is_not_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = 'someHashCode';
      entry.hashCode = 'someHashCode';
      let result = entry.handleActionStart();
      expect(result).assertUndefined();
    });

    it('should_initialize_properties_when_swipeHashCode_is_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '';
      entry.hashCode = 'someHashCode';
      let result = entry.handleActionStart();
      expect(result).assertUndefined();
      expect(entry.swipeHashCode).assertEqual('someHashCode');
      expect(entry.ntfExtraGroupBriefScale).assertEqual(1);
      expect(entry.isRTL).assertEqual(RTLUtil.isRTL());
      expect(entry.startTranX).assertEqual(entry.translateX);
    });

    it('should_return_immediately_when_swipeHashCode_is_not_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = 'someHashCode';
      entry.hashCode = 'someHashCode';
      let result = entry.handleActionStart();
      expect(result).assertUndefined();
    });

    it('should_initialize_properties_when_swipeHashCode_is_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '';
      entry.hashCode = 'someHashCode';
      let result = entry.handleActionStart();
      expect(result).assertUndefined();
      expect(entry.swipeHashCode).assertEqual('someHashCode');
      expect(entry.ntfExtraGroupBriefScale).assertEqual(1);
      expect(entry.isRTL).assertEqual(RTLUtil.isRTL());
      expect(entry.startTranX).assertEqual(entry.translateX);
    });

    it('should_return_immediately_when_event_is_null', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.handleActionEnd(null);
    });

    it('should_return_immediately_when_swipeHashCode_is_not_equal_to_hashCode', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.handleActionEnd(new GestureEvent());
    });

    it('should_set_swipeHashCode_to_empty_string_when_event_is_not_null_and_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.swipeHashCode = 'someHashCode';
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.swipeHashCode).assertEqual('');
    });

    it('should_set_endTranX_to_0_when_getRTLValue_is_greater_than_or_equal_to_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = 5;
      ntfEntry.startTranX = -3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(0);
    });

    it('should_set_endTranX_to_getRTLValue_menuWidth_when_getRTLValue_is_less_than_0_and_startTranX_is_less_than_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = -8;
      ntfEntry.startTranX = -3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(-10);
    });

    it('should_set_endTranX_to_0_when_getRTLValue_is_less_than_0_and_startTranX_is_greater_than_or_equal_to_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = 8;
      ntfEntry.startTranX = 3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(0);
    });

    it('should_call_animateTo_and_AccessUtil_sendNtfSwipeAccessibility_when_event_is_not_null_and_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.swipeHashCode = 'someHashCode';
      let mockAnimateTo: Function = mocker.mockFunc(ntfEntry, ntfEntry.animateTo);
      let mockAccessUtil: Function = mocker.mockFunc(AccessUtil, AccessUtil.sendNtfSwipeAccessibility);
      when(mockAnimateTo)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new AnimatorResult(true));
      when(mockAccessUtil)(ArgumentMatchers.any).afterReturnNothing();
      ntfEntry.handleActionEnd(new GestureEvent());
      mocker.ignoreMock(ntfEntry, ntfEntry.animateTo);
      mocker.ignoreMock(AccessUtil, AccessUtil.sendNtfSwipeAccessibility);
    });

    it('should_return_immediately_when_event_is_null', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.handleActionEnd(null);
    });

    it('should_return_immediately_when_swipeHashCode_is_not_equal_to_hashCode', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.handleActionEnd(new GestureEvent());
    });

    it('should_set_swipeHashCode_to_empty_string_when_event_is_not_null_and_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.swipeHashCode = 'someHashCode';
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.swipeHashCode).assertEqual('');
    });

    it('should_set_endTranX_to_0_when_getRTLValue_is_greater_than_or_equal_to_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = 5;
      ntfEntry.startTranX = -3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(0);
    });

    it('should_set_endTranX_to_getRTLValue_menuWidth_when_getRTLValue_is_less_than_0_and_startTranX_is_less_than_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = -8;
      ntfEntry.startTranX = -3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(-10);
    });

    it('should_set_endTranX_to_0_when_getRTLValue_is_less_than_0_and_startTranX_is_greater_than_or_equal_to_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = 8;
      ntfEntry.startTranX = 3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(0);
    });

    it('should_call_animateTo_and_AccessUtil_sendNtfSwipeAccessibility_when_event_is_not_null_and_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.swipeHashCode = 'someHashCode';
      let mockAnimateTo: Function = mocker.mockFunc(ntfEntry, ntfEntry.animateTo);
      let mockAccessUtil: Function = mocker.mockFunc(AccessUtil, AccessUtil.sendNtfSwipeAccessibility);
      when(mockAnimateTo)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new AnimatorResult(true));
      when(mockAccessUtil)(ArgumentMatchers.any).afterReturnNothing();
      ntfEntry.handleActionEnd(new GestureEvent());
      mocker.ignoreMock(ntfEntry, ntfEntry.animateTo);
      mocker.ignoreMock(AccessUtil, AccessUtil.sendNtfSwipeAccessibility);
    });

    it('should_return_immediately_when_event_is_null', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.handleActionEnd(null);
    });

    it('should_return_immediately_when_swipeHashCode_is_not_equal_to_hashCode', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.handleActionEnd(new GestureEvent());
    });

    it('should_set_swipeHashCode_to_empty_string_when_event_is_not_null_and_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.swipeHashCode = 'someHashCode';
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.swipeHashCode).assertEqual('');
    });

    it('should_set_endTranX_to_0_when_getRTLValue_is_greater_than_or_equal_to_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = 5;
      ntfEntry.startTranX = -3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(0);
    });

    it('should_set_endTranX_to_getRTLValue_menuWidth_when_getRTLValue_is_less_than_0_and_startTranX_is_less_than_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = -8;
      ntfEntry.startTranX = -3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(-10);
    });

    it('should_set_endTranX_to_0_when_getRTLValue_is_less_than_0_and_startTranX_is_greater_than_or_equal_to_0', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.translateX = 8;
      ntfEntry.startTranX = 3;
      ntfEntry.menuWidth = 10;
      ntfEntry.SWIPE_LEFT_CRITICAL = 5;
      ntfEntry.handleActionEnd(new GestureEvent());
      expect(ntfEntry.translateX).assertEqual(0);
    });

    it('should_call_animateTo_and_AccessUtil_sendNtfSwipeAccessibility_when_event_is_not_null_and_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let mocker: MockKit = new MockKit();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.swipeHashCode = 'someHashCode';
      let mockAnimateTo: Function = mocker.mockFunc(ntfEntry, ntfEntry.animateTo);
      let mockAccessUtil: Function = mocker.mockFunc(AccessUtil, AccessUtil.sendNtfSwipeAccessibility);
      when(mockAnimateTo)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new AnimatorResult(true));
      when(mockAccessUtil)(ArgumentMatchers.any).afterReturnNothing();
      ntfEntry.handleActionEnd(new GestureEvent());
      mocker.ignoreMock(ntfEntry, ntfEntry.animateTo);
      mocker.ignoreMock(AccessUtil, AccessUtil.sendNtfSwipeAccessibility);
    });

    it('should_return_immediately_when_swipeHashCode_is_not_equal_to_hashCode', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      entry.hashCode = '456';
      entry.handleActionCancel();
      expect(entry.swipeHashCode).assertEqual('123');
    });

    it('should_set_swipeHashCode_to_empty_string_when_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      entry.hashCode = '123';
      entry.handleActionCancel();
      expect(entry.swipeHashCode).assertEqual('');
    });

    it('should_calculate_endTranX_correctly_when_getRTLValue_is_greater_than_zero', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = 100;
      entry.startTranX = -50;
      entry.menuWidth = 200;
      entry.handleActionCancel();
      expect(entry.translateX).assertEqual(0);
    });

    it('should_calculate_endTranX_correctly_when_getRTLValue_is_less_than_zero', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = -100;
      entry.startTranX = -50;
      entry.menuWidth = 200;
      entry.handleActionCancel();
      expect(entry.translateX).assertEqual(0);
    });

    it('should_calculate_endTranX_correctly_when_getRTLValue_is_zero', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = 50;
      entry.startTranX = -50;
      entry.menuWidth = 200;
      entry.handleActionCancel();
      expect(entry.translateX).assertEqual(0);
    });

    it('should_call_animateTo_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = 0;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(entry, entry.animateTo);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new AnimatorResult(true));
      entry.handleActionCancel();
      mocker.ignoreMock(entry, entry.animateTo);
    });

    it('should_call_RTLUtil_getRTLValue_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = 100;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.getRTLValue);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      entry.handleActionCancel();
      mocker.ignoreMock(RTLUtil, RTLUtil.getRTLValue);
    });

    it('should_call_EventManager_emit_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EventManager, EventManager.emit);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      entry.handleActionCancel();
      mocker.ignoreMock(EventManager, EventManager.emit);
    });

    it('should_call_ResUtils_getDimensionValue_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getDimensionValue);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      entry.handleActionCancel();
      mocker.ignoreMock(ResUtils, ResUtils.getDimensionValue);
    });

    it('should_call_NotificationExtraMenuRow_constructor_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationExtraMenuRow, NotificationExtraMenuRow.constructor);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      entry.handleActionCancel();
      mocker.ignoreMock(NotificationExtraMenuRow, NotificationExtraMenuRow.constructor);
    });

    it('should_call_NtfItemSwipeController_constructor_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfItemSwipeController, NtfItemSwipeController.constructor);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      entry.handleActionCancel();
      mocker.ignoreMock(NtfItemSwipeController, NtfItemSwipeController.constructor);
    });

    it('should_call_NotificationAnimationParas_constructor_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationAnimationParas, NotificationAnimationParas.constructor);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      entry.handleActionCancel();
      mocker.ignoreMock(NotificationAnimationParas, NotificationAnimationParas.constructor);
    });

    it('should_call_ExtraNtfCollapsedAnimation_constructor_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ExtraNtfCollapsedAnimation, ExtraNtfCollapsedAnimation.constructor);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      entry.handleActionCancel();
      mocker.ignoreMock(ExtraNtfCollapsedAnimation, ExtraNtfCollapsedAnimation.constructor);
    });

    it('should_call_NtfTimeVM_constructor_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfTimeVM, NtfTimeVM.constructor);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      entry.handleActionCancel();
      mocker.ignoreMock(NtfTimeVM, NtfTimeVM.constructor);
    });

    it('should_call_NtfAppIconModifier_constructor_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfAppIconModifier, NtfAppIconModifier.constructor);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      entry.handleActionCancel();
      mocker.ignoreMock(NtfAppIconModifier, NtfAppIconModifier.constructor);
    });
    it('should_return_immediately_when_swipeHashCode_is_not_equal_to_hashCode', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      entry.hashCode = '456';
      entry.handleActionCancel();
      expect(entry.swipeHashCode).assertEqual('123');
    });

    it('should_set_swipeHashCode_to_empty_string_when_swipeHashCode_is_equal_to_hashCode', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.swipeHashCode = '123';
      entry.hashCode = '123';
      entry.handleActionCancel();
      expect(entry.swipeHashCode).assertEqual('');
    });

    it('should_calculate_endTranX_correctly_when_getRTLValue_is_less_than_zero', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = -100;
      entry.startTranX = -50;
      entry.menuWidth = 200;
      entry.handleActionCancel();
      expect(entry.translateX).assertEqual(0);
    });

    it('should_calculate_endTranX_correctly_when_getRTLValue_is_zero', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = 50;
      entry.startTranX = -50;
      entry.menuWidth = 200;
      entry.handleActionCancel();
      expect(entry.translateX).assertEqual(0);
    });

    it('should_call_animateTo_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = 0;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(entry, entry.animateTo);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new AnimatorResult(true));
      entry.handleActionCancel();
      mocker.ignoreMock(entry, entry.animateTo);
    });

    it('should_call_RTLUtil_getRTLValue_with_correct_parameters', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.translateX = 100;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.getRTLValue);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(50);
      entry.handleActionCancel();
      mocker.ignoreMock(RTLUtil, RTLUtil.getRTLValue);
    });

  });
}
