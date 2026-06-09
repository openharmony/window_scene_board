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
import { AnimationBase, AnimationNames } from '@ohos/systemuicommon/newIndex';
import { curves } from '@kit.ArkUI';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationGroupExpandedAnimation } from '../../../main/ets/animation/NotificationGroupExpandedAnimation';
export default function NotificationGroupExpandedAnimationTest() {
  describe('getContentTextAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });

    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);
      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };
      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      const result = await notificationgroupexpandedanimation.getContentTextAnimation();
      expect(result).assertInstanceOf(TransitionEffect);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });
    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);
      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };
      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });
    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };

      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));

      const result = await notificationgroupexpandedanimation.getContentTextAnimation();

      expect(result).assertInstanceOf(TransitionEffect);

      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });
    it('should_return_correct_transition_effect_when_getContentTextAnimation_is_called', 0, async () => {
      let notificationgroupexpandedanimation: NotificationGroupExpandedAnimation =
        new NotificationGroupExpandedAnimation();
      let mocker: MockKit = new MockKit();

      let mockfunc1: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.animation);
      let mockfunc2: Function = mocker.mockFunc(TransitionEffect, TransitionEffect.combine);

      let animateParam: AnimateParam = {
        duration: NotificationGroupExpandedAnimation.duration,
        curve: NotificationGroupExpandedAnimation.curve
      };
      when(mockfunc1)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      when(mockfunc2)(ArgumentMatchers.any)
        .afterReturn(new TransitionEffect(AnimationNames.NTF_GROUP_EXPANDED_ANIMATION));
      const result = await notificationgroupexpandedanimation.getContentTextAnimation();
      expect(result).assertInstanceOf(TransitionEffect);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.animation);
      mocker.ignoreMock(TransitionEffect, TransitionEffect.combine);
    });
  });
}