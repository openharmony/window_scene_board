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
import { NtfAnimationConsts } from '../../../main/ets/common/NtfAnimationConsts';
import { curves } from '@kit.ArkUI';
import { NotificationUtils } from '../../../main/ets/common/NotificationUtils';
import { AnimateParams, AnimationBase } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import { AnimationNames } from '@ohos/systemuicommon/src/main/ets/animation/AnimationNames';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { MoreNotificationCollapsedAnimation } from '../../../main/ets/animation/MoreNotificationCollapsedAnimation';
export default function MoreNotificationCollapsedAnimationTest() {
  describe('getExtraNtfAnimationArray_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });

    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });
    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });
    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });
    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });
    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });
    it('should_return_empty_array_when_moreNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 0;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(0);
    });

    it('should_return_array_with_correct_length_when_mainNtfLength_is_zero', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 0;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });
    it('should_return_correct_transition_array_when_input_is_valid', 0, () => {
      let morenotificationcollapsedanimation: MoreNotificationCollapsedAnimation = new MoreNotificationCollapsedAnimation();
      let endIndex: number = 10;
      let mainNtfLength: number = 5;
      let moreNtfLength: number = 3;

      let result: TransitionEffect[] = morenotificationcollapsedanimation.getExtraNtfAnimationArray(endIndex, mainNtfLength, moreNtfLength);

      expect(result.length).assertEqual(moreNtfLength);
      for (let i = 0; i < result.length; i++) {
        expect(result[i]).assertInstanceOf(TransitionEffect);
      }
    });
  });
}