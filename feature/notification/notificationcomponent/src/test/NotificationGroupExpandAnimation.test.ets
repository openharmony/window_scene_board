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
import { RTLUtil } from '@ohos/componenthelper';
import { curves } from '@kit.ArkUI';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationGroupExpandAnimation } from '../../../main/ets/animation/NotificationGroupExpandAnimation';
export default function NotificationGroupExpandAnimationTest() {
  describe('getOverlayIconAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_zero', 0, () => {
      const index = 0;
      const lastIndex = 1;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(0);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_is_not_zero', 0, () => {
      const index = 1;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(100);
      expect(result.delay).assertEqual(32);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });

    it('should_return_correct_animation_when_index_equals_lastIndex', 0, () => {
      const index = 2;
      const lastIndex = 2;
      const result = NotificationGroupExpandAnimation.getOverlayIconAnimation(index, lastIndex);

      expect(result.duration).assertEqual(75);
      expect(result.delay).assertEqual(64);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
    });
  });
}