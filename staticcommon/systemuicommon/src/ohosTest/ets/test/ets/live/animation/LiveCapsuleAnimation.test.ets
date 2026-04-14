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
import { AnimateParams, AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCapsuleAnimation } from '../../../../main/ets/live/animation/LiveCapsuleAnimation';
export default function LiveCapsuleAnimationTest() {
  describe('updateInstantAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_getCapsuleVm_and_getCapsuleMarqueeVm_and_getCapsuleListLayoutVm_and_executeAnimation', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_call_getCapsuleVm_and_getCapsuleMarqueeVm_and_getCapsuleListLayoutVm_and_executeAnimation', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_call_getCapsuleVm_and_getCapsuleMarqueeVm_and_getCapsuleListLayoutVm_and_executeAnimation', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_call_getCapsuleVm_and_getCapsuleMarqueeVm_and_getCapsuleListLayoutVm_and_executeAnimation', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_curve_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(curves.CAPSULE_CURVE).assertEqual(livecapsuleanimation.animationParams.curve);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_duration_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(333).assertEqual(livecapsuleanimation.animationParams.duration);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });

    it('should_handle_event_correctly', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let livecapsuleanimation: LiveCapsuleAnimation = new LiveCapsuleAnimation(live, vmInjector);
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleMarqueeVm);
      let mockGetCapsuleListLayoutVm: Function = mocker.mockFunc(vmInjector, vmInjector.getCapsuleListLayoutVm);
      let mockExecuteAnimation: Function = mocker.mockFunc(AnimationBase, AnimationBase.prototype.executeAnimation);

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0,
        width: 0,
        fixedOffsetX: 0,
        fixedWidth: 0
      });
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn({
        textWidth: 0,
        textSize: 0,
        fixedTextWidth: 0,
        opacity: 0,
        isRunning: false
      });
      when(mockGetCapsuleListLayoutVm)().afterReturn({
        capsuleListWidth: 0,
        capsuleListFixedWidth: 0
      });
      when(mockExecuteAnimation)([ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber]).afterReturn(Promise.resolve());

      await livecapsuleanimation.updateInstantAnimation();

      expect(livecapsuleanimation.animationParams.event).assertInstanceOf(Function);

      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleMarqueeVm);
      mocker.ignoreMock(vmInjector, vmInjector.getCapsuleListLayoutVm);
      mocker.ignoreMock(AnimationBase, AnimationBase.prototype.executeAnimation);
    });
  });
}