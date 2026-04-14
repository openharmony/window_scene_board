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
import { AnimationNames } from '@ohos/systemuicommon/src/main/ets/animation/AnimationNames';
import { AnimateParams, AnimationBase } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { ntfViewConfigManager } from '../../../main/ets/vm/config/NtfViewConfigManager';
import { INotificationCardVm, INotificationClearButtonVm } from '@ohos/systemuicommon/newIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/utils/ItemUtils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationClearAllAnimation } from '../../../main/ets/animation/NotificationClearAllAnimation';
export default function NotificationClearAllAnimationTest() {
  describe('afterAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });

    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });
    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });
    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });
    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });
    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });
    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });
    it('should_call_super_afterAnimation', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.afterAnimation);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.afterAnimation);
    });
    it('should_call_clearAnimations', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.clearAnimations);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.clearAnimations);
    });
    it('should_call_reset_forEach_cardVmArray', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearallanimation, notificationclearallanimation.reset);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearallanimation.afterAnimation();
      mocker.ignoreMock(notificationclearallanimation, notificationclearallanimation.reset);
    });
    it('should_set_cardVmArray_to_empty_array', 0, () => {
      let notificationclearallanimation: NotificationClearAllAnimation = new NotificationClearAllAnimation();
      notificationclearallanimation.afterAnimation();
      expect(notificationclearallanimation.cardVmArray.length).assertEqual(0);
    });
  });
}