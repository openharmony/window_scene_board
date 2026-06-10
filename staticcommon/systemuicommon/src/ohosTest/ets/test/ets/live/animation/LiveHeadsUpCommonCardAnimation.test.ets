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
import { AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
import { StatusBarCapsulePosition } from '../../../../../../main/ets/statusbar/model/StatusBarCapsulePosition';
import { SystemUICommonUtil } from '../../../../../../main/ets/utils/SystemUICommonUtil';
import { ILiveHeadsUpCommonCardVm } from '../../../../../../main/ets/live/interface/ILiveHeadsUpCommonCardVm';
import { curves, display } from '@kit.ArkUI';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import { ResourceVm } from '../../../../../../main/ets/vm/ResourceVm';
import { DeviceInfoVm } from '../../../../../../main/ets/vm/DeviceInfoVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveHeadsUpCommonCardAnimation } from '../../../../../../main/ets/live/animation/LiveHeadsUpCommonCardAnimation';
export default function LiveHeadsUpCommonCardAnimationTest() {
  describe('expandCard_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_clearAnimations_and_startAnimation_when_expandCard_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)([]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_correct_parameters', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard']).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', 2000]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_zero', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', 0]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_negative', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', -1]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_positive', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', 1000]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_large', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', 3000]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_very_large', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', 5000]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_very_very_large', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', 10000]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_infinite', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', Infinity]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_nan', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', NaN]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_undefined', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', undefined]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_null', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', null]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_object', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_array', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', []]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_function', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', () => {
        }]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_date', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Date()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_regex', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', /test/]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_map', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Map()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_set', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Set()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakmap', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakMap()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakset', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakSet()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is-proxy', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
        new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Proxy({}, {})]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', (function* test() {
          yield 1;
        })()]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator_function', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let animationBase: AnimationBase =
          new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
        let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation =
          new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
        let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
        let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

        when(mockClearAnimations)([]).afterReturnNothing();
        when(mockStartAnimation)(['ExpandCard', (function* test() {
          yield 1;
        })]).afterReturn(Promise.resolve());

        await liveheadsupcommoncardanimation.expandCard();

        mocker.ignoreMock(animationBase, animationBase.clearAnimations);
        mocker.ignoreMock(animationBase, animationBase.startAnimation);
      });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_infinite2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', Infinity]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_nan2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', NaN]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_undefined2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', undefined]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_null2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', null]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_object2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_array2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', []]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_function2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_date2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Date()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_regex2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', /test/]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_map2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Map()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_set2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Set()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakmap2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakMap()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakset2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakSet()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is-proxy2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Proxy({}, {})]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (function* test() { yield 1; })()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator_function2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (function* test() { yield 1; })]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_async_function', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', async () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_class', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', class Test {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_parameters', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => a + b]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => 1]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => a + b]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays_and_functions', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays_and_functions_and_classes', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_infinite3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', Infinity]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_nan3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', NaN]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_undefined3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', undefined]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_null3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', null]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_object3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_array3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', []]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_function3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_date3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Date()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_regex3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', /test/]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_map3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Map()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_set3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Set()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakmap3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakMap()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakset3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakSet()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is-proxy3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Proxy({}, {})]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (function* test() { yield 1; })()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator_function3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (function* test() { yield 1; })]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_async_function3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', async () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_class3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', class Test {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_parameters3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => a + b]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => 1]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => a + b]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays_and_functions3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays_and_functions_and_classes3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_infinite4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', Infinity]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_nan4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', NaN]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_undefined4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', undefined]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_null4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', null]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_object4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_array4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', []]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_function4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_date4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Date()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_regex4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', /test/]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_map4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Map()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_set4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Set()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakmap4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakMap()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_weakset4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new WeakSet()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is-proxy4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', new Proxy({}, {})]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (function* test() { yield 1; })()]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_generator_function4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (function* test() { yield 1; })]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_async_function4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', async () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_class4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', class Test {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => {}]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_parameters4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => a + b]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', () => 1]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => a + b]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays_and_functions4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });

    it('should_call_clearAnimations_and_startAnimation_with_timeout_parameter_when_timeout_is_arrow_function_with_return_value_and_parameters_and_body_and_comments_and_strings_and_numbers_and_booleans_and_objects_and_arrays_and_functions_and_classes4', 0, async () => {
      let mocker: MockKit = new MockKit();
      let animationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
      let liveheadsupcommoncardanimation: LiveHeadsUpCommonCardAnimation = new LiveHeadsUpCommonCardAnimation(animationBase, new StatusBarCapsulePosition(0, 0));
      let mockClearAnimations: Function = mocker.mockFunc(animationBase, animationBase.clearAnimations);
      let mockStartAnimation: Function = mocker.mockFunc(animationBase, animationBase.startAnimation);

      when(mockClearAnimations)([]).afterReturnNothing();
      when(mockStartAnimation)(['ExpandCard', (a: number, b: number) => { /* comment */ return a + b; }]).afterReturn(Promise.resolve());

      await liveheadsupcommoncardanimation.expandCard();

      mocker.ignoreMock(animationBase, animationBase.clearAnimations);
      mocker.ignoreMock(animationBase, animationBase.startAnimation);
    });
  });
}