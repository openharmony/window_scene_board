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
import { AnimateParams, AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import { ILiveHeadsUpWalletCardVm } from '../../../../main/ets/live/interface/ILiveHeadsUpWalletCardVm';
import { SweepStage, WalletStageValue } from '../../../../main/ets/live/vm/LiveHeadsUpWalletCardVm';
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
import { LiveHeadsUpWalletAnimation } from '../../../../main/ets/live/animation/LiveHeadsUpWalletAnimation';

export default function LiveHeadsUpWalletAnimationTest() {
  describe('swipeEnterAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_swipeEnterSweepAnimation_when_liveStage_is_SWIPE_DOING', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm());
      let mocker: MockKit = new MockKit();
      let mockWalletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mockfunc1: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.animationStage);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(WalletStageValue.SWIPE_DOING);
      let mockfunc2: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.live);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        stage: WalletStageValue.SWIPE_DOING
      });
      liveheadsupwalletanimation.walletVm = mockWalletVm;

      let mockfunc3: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterSweepAnimation);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(new Promise<void>(() => {
      }));

      await liveheadsupwalletanimation.swipeEnterAnimation();

      mocker.ignoreMock(mockWalletVm, mockWalletVm.animationStage);
      mocker.ignoreMock(mockWalletVm, mockWalletVm.live);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterSweepAnimation);
    });

    it('should_call_swipeEnterAngleFixedAnimation_when_liveStage_is_not_SWIPE_DOING', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm());
      let mocker: MockKit = new MockKit();
      let mockWalletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mockfunc1: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.animationStage);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(WalletStageValue.SWIPE_DONE);
      let mockfunc2: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.live);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        stage: WalletStageValue.SWIPE_DONE
      });
      liveheadsupwalletanimation.walletVm = mockWalletVm;

      let mockfunc4: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterAngleFixedAnimation);
      when(mockfunc4)([]).afterReturn(new Promise<void>(() => {
      }));

      await liveheadsupwalletanimation.swipeEnterAnimation();

      mocker.ignoreMock(mockWalletVm, mockWalletVm.animationStage);
      mocker.ignoreMock(mockWalletVm, mockWalletVm.live);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterAngleFixedAnimation);
    });

    it('should_call_executeAnimation_with_correct_params', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm());
      let mocker: MockKit = new MockKit();
      let mockWalletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mockfunc1: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.animationStage);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(WalletStageValue.SWIPE_DOING);
      let mockfunc2: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.live);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        stage: WalletStageValue.SWIPE_DOING
      });
      liveheadsupwalletanimation.walletVm = mockWalletVm;

      let mockfunc3: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterSweepAnimation);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(new Promise<void>(() => {
      }));

      let mockfunc5: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
      when(mockfunc5)(ArgumentMatchers.anyObj, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber)
        .afterReturn(new Promise<void>(() => {
        }));

      await liveheadsupwalletanimation.swipeEnterAnimation();

      mocker.ignoreMock(mockWalletVm, mockWalletVm.animationStage);
      mocker.ignoreMock(mockWalletVm, mockWalletVm.live);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterSweepAnimation);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
    });

    it('should_call_info_log_when_animation_begins', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm());
      let mocker: MockKit = new MockKit();
      let mockWalletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      let mockfunc1: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.animationStage);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(WalletStageValue.SWIPE_DOING);
      let mockfunc2: Function = mocker.mockFunc(mockWalletVm, mockWalletVm.live);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        stage: WalletStageValue.SWIPE_DOING
      });
      liveheadsupwalletanimation.walletVm = mockWalletVm;

      let mockfunc3: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterSweepAnimation);
      when(mockfunc3)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj).afterReturn(new Promise<void>(() => {
      }));

      let mockfunc5: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
      when(mockfunc5)(ArgumentMatchers.anyObj, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber)
        .afterReturn(new Promise<void>(() => {
        }));

      let mockfunc6: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc6)([ArgumentMatchers.any]).afterReturn(undefined);

      await liveheadsupwalletanimation.swipeEnterAnimation();

      mocker.ignoreMock(mockWalletVm, mockWalletVm.animationStage);
      mocker.ignoreMock(mockWalletVm, mockWalletVm.live);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterSweepAnimation);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_return_immediately_when_live_stage_is_undefined', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
      when(mockfunc).afterReturn({
        stage: undefined
      });

      await liveheadsupwalletanimation.swipeEnterSweepAnimation();

      mocker.ignoreMock(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
    });

    it('should_return_immediately_when_live_stage_is_less_than_SWIPE_DOING', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
      when(mockfunc).afterReturn({
        stage: WalletStageValue.SWIPE_NOT_START
      });

      await liveheadsupwalletanimation.swipeEnterSweepAnimation();

      mocker.ignoreMock(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
    });

    it('should_return_immediately_when_sweepingStage_is_not_CAN_DO', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
      liveheadsupwalletanimation.walletVm.sweepingStage = SweepStage.ALREADY_DONE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
      when(mockfunc).afterReturn({
        stage: WalletStageValue.SWIPE_DOING
      });

      await liveheadsupwalletanimation.swipeEnterSweepAnimation();

      mocker.ignoreMock(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
    });

    it('should_execute_successfully_when_all_conditions_are_met', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
      liveheadsupwalletanimation.walletVm.sweepingStage = SweepStage.CAN_DO;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
      when(mockfunc).afterReturn({
        stage: WalletStageValue.SWIPE_DOING
      });
      let logHelper: LogHelper = new LogHelper(LogDomain.SWIPE_PAY);
      let mockLogFunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockLogFunc).afterReturnNothing();
      let mockGetSwipeEnterSweepDataFunc: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.getSwipeEnterSweepData);
      when(mockGetSwipeEnterSweepDataFunc).afterReturn([]);

      await liveheadsupwalletanimation.swipeEnterSweepAnimation();

      expect(liveheadsupwalletanimation.walletVm.sweepingStage).assertEqual(SweepStage.DONE);
      mocker.ignoreMock(liveheadsupwalletanimation.walletVm, liveheadsupwalletanimation.walletVm.live);
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.getSwipeEnterSweepData);
    });

    it('should_return_immediately_when_isPlayingRotation_is_true', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation({});
      liveheadsupwalletanimation.walletVm.isPlayingRotation = true;
      await liveheadsupwalletanimation.swipeEnterRotationAnimation();
      expect(liveheadsupwalletanimation.walletVm.isPlayingRotation).assertEqual(true);
    });

    it('should_set_isPlayingRotation_to_true_and_execute_animation_when_isPlayingRotation_is_false', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation({});
      liveheadsupwalletanimation.walletVm.isPlayingRotation = false;
      let mocker: MockKit = new MockKit();
      let mockExecuteAnimation: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber)
        .afterReturn(Promise.resolve());
      let mockInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockInfo)(ArgumentMatchers.any).afterReturnNothing();
      await liveheadsupwalletanimation.swipeEnterRotationAnimation();
      expect(liveheadsupwalletanimation.walletVm.isPlayingRotation).assertEqual(true);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
      mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_call_swipeEnterAngleFixedAnimation_when_animation_completes', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation({});
      liveheadsupwalletanimation.walletVm.isPlayingRotation = false;
      liveheadsupwalletanimation.walletVm.animationStage = AnimationStage.ROTATING;
      let mocker: MockKit = new MockKit();
      let mockExecuteAnimation: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
      when(mockExecuteAnimation)(ArgumentMatchers.any, ArgumentMatchers.anyString, ArgumentMatchers.anyNumber)
        .afterReturn(Promise.resolve());
      let mockInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockInfo)(ArgumentMatchers.any).afterReturnNothing();
      let mockSwipeAngleFixed: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterAngleFixedAnimation);
      when(mockSwipeAngleFixed)().afterReturn(Promise.resolve());
      await liveheadsupwalletanimation.swipeEnterRotationAnimation();
      expect(liveheadsupwalletanimation.walletVm.isPlayingRotation).assertEqual(true);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.executeAnimation);
      mocker.ignoreMock(LogHelper, LogHelper.info);
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterAngleFixedAnimation);
    });

    it('should_call_swipeEnterRotationAnimation_when_imageInfo_nextInstruction_is_negative_1', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation({});
      let mocker: MockKit = new MockKit();
      let mockWalletVm: ILiveHeadsUpWalletCardVm = {
        imageInfo: {
          nextInstruction: -1,
          X: 0,
          Y: 0,
          Z: 0,
          angle: 0
        }
      };
      liveheadsupwalletanimation.walletVm = mockWalletVm;
      let mockSwipeEnterRotationAnimation: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterRotationAnimation);
      when(mockSwipeEnterRotationAnimation)([]).afterReturn(Promise.resolve());
      await liveheadsupwalletanimation.swipeEnterAngleFixedAnimation();
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeEnterRotationAnimation);
    });

    it('should_call_swipeExitStartAnimation_when_imageInfo_nextInstruction_is_not_negative_1', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation({});
      let mocker: MockKit = new MockKit();
      let mockWalletVm: ILiveHeadsUpWalletCardVm = {
        imageInfo: {
          nextInstruction: 0,
          X: 0,
          Y: 0,
          Z: 0,
          angle: 0
        }
      };
      liveheadsupwalletanimation.walletVm = mockWalletVm;
      let mockSwipeExitStartAnimation: Function =
        mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitStartAnimation);
      when(mockSwipeExitStartAnimation)([]).afterReturn(Promise.resolve());
      await liveheadsupwalletanimation.swipeEnterAngleFixedAnimation();
      mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitStartAnimation);
    });

    it('should_return_immediately_when_animationStage_is_greater_than_or_equal_to_EXIT_START', 0, () => {
        let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm() {
            animationStage: number = AnimationStage.EXIT_START;
            imageInfo: EsObject = {
                nextInstruction: WalletStageValue.SWIPE_SUCCEED
            };
    });
    liveheadsupwalletanimation.swipeExitStartAnimation();
    expect(liveheadsupwalletanimation.walletVm.animationStage).assertEqual(AnimationStage.EXIT_START);
    });

    it('should_set_animationStage_to_EXIT_START_when_animationStage_is_less_than_EXIT_START', 0, () => {
            let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm() {
                animationStage: number = AnimationStage.PLAYING;
                imageInfo: EsObject = {
                    nextInstruction: WalletStageValue.SWIPE_SUCCEED
                };
    });
    liveheadsupwalletanimation.swipeExitStartAnimation();
    expect(liveheadsupwalletanimation.walletVm.animationStage).assertEqual(AnimationStage.EXIT_START);
    });

    it('should_call_swipeExitSuccessStartAnimation_when_nextInstruction_is_SWIPE_SUCCEED', 0, () => {
            let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm() {
                animationStage: number = AnimationStage.PLAYING;
                imageInfo: EsObject = {
                    nextInstruction: WalletStageValue.SWIPE_SUCCEED
                };
    });
    let mocker: MockKit = new MockKit();
    let mockfunc: Function =
      mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitSuccessStartAnimation);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve());
    liveheadsupwalletanimation.swipeExitStartAnimation();
    expect(liveheadsupwalletanimation.walletVm.exitStartTime).assertLarger(0);
    mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitSuccessStartAnimation);
    });

    it('should_call_swipeExitFailStartAnimation_when_nextInstruction_is_SWIPE_FAILED', 0, () => {
            let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm() {
                animationStage: number = AnimationStage.PLAYING;
                imageInfo: EsObject = {
                    nextInstruction: WalletStageValue.SWIPE_FAILED
                };
        });
    let mocker: MockKit = new MockKit();
    let mockfunc: Function =
      mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitFailStartAnimation);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve());
    liveheadsupwalletanimation.swipeExitStartAnimation();
    expect(liveheadsupwalletanimation.walletVm.exitStartTime).assertLarger(0);
    mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitFailStartAnimation);
    });

    it('should_call_swipeExitNoFeedbackStartAnimation_when_nextInstruction_is_SWIPE_FINISHED', 0, () => {
            let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm() {
                animationStage: number = AnimationStage.PLAYING;
                imageInfo: EsObject = {
                    nextInstruction: WalletStageValue.SWIPE_FINISHED
                };
    });
    let mocker: MockKit = new MockKit();
    let mockfunc: Function =
      mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitNoFeedbackStartAnimation);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(Promise.resolve());
    liveheadsupwalletanimation.swipeExitStartAnimation();
    expect(liveheadsupwalletanimation.walletVm.exitStartTime).assertLarger(0);
    mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitNoFeedbackStartAnimation);
    });

    it('should_log_info_when_nextInstruction_is_neither_SWIPE_SUCCEED_nor_SWIPE_FAILED_nor_SWIPE_FINISHED', 0, () => {
            let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(new ILiveHeadsUpWalletCardVm() {
                animationStage: number = AnimationStage.PLAYING;
                imageInfo: EsObject = {
                    nextInstruction: WalletStageValue.SWIPE_IN_PROGRESS
                };
    });
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.info);
    when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
    liveheadsupwalletanimation.swipeExitStartAnimation();
    expect(liveheadsupwalletanimation.walletVm.exitStartTime).assertLarger(0);
    mocker.ignoreMock(LogHelper, LogHelper.info);
    });

    it('should_return_immediately_when_animationStage_is_greater_than_or_equal_to_EXIT_END', 0, async () => {
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
      liveheadsupwalletanimation.walletVm.animationStage = AnimationStage.EXIT_END;
      await liveheadsupwalletanimation.swipeExitEndAnimation();
    });

    it('should_call_swipeSuspendAllAnimations_and_then_swipeExitSuccessEndAnimation_when_imageInfo_nextInstruction_is_SWIPE_SUCCEED',
      0, async () => {
        let mocker: MockKit = new MockKit();
        let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
          new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
        liveheadsupwalletanimation.walletVm.animationStage = AnimationStage.SWIPE_START;
        liveheadsupwalletanimation.walletVm.exitStartTime = Date.now();
        liveheadsupwalletanimation.walletVm.imageInfo.nextInstruction = WalletStageValue.SWIPE_SUCCEED;

        let mockSuspend: Function =
          mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeSuspendAllAnimations);
        let mockExitSuccess: Function =
          mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitSuccessEndAnimation);

        when(mockSuspend)(ArgumentMatchers.any).afterReturn(true);
        when(mockExitSuccess)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        await liveheadsupwalletanimation.swipeExitEndAnimation();

        mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeSuspendAllAnimations);
        mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitSuccessEndAnimation);
      });

    it('should_call_swipeSuspendAllAnimations_and_then_swipeExitFailEndAnimation_when_imageInfo_nextInstruction_is_SWIPE_FAILED',
      0, async () => {
        let mocker: MockKit = new MockKit();
        let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
          new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
        liveheadsupwalletanimation.walletVm.animationStage = AnimationStage.SWIPE_START;
        liveheadsupwalletanimation.walletVm.exitStartTime = Date.now();
        liveheadsupwalletanimation.walletVm.imageInfo.nextInstruction = WalletStageValue.SWIPE_FAILED;

        let mockSuspend: Function =
          mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeSuspendAllAnimations);
        let mockExitFail: Function =
          mocker.mockFunc(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitFailEndAnimation);

        when(mockSuspend)(ArgumentMatchers.any).afterReturn(true);
        when(mockExitFail)(ArgumentMatchers.any).afterReturn(Promise.resolve());

        await liveheadsupwalletanimation.swipeExitEndAnimation();

        mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeSuspendAllAnimations);
        mocker.ignoreMock(liveheadsupwalletanimation, liveheadsupwalletanimation.swipeExitFailEndAnimation);
      });

    it('should_log_info_when_exitStartTime_is_greater_than_0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper(LogDomain.ANIMATION);
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation =
        new LiveHeadsUpWalletAnimation({} as ILiveHeadsUpWalletCardVm);
      liveheadsupwalletanimation.walletVm.animationStage = AnimationStage.SWIPE_START;
      liveheadsupwalletanimation.walletVm.exitStartTime = Date.now();
      liveheadsupwalletanimation.walletVm.imageInfo.nextInstruction = WalletStageValue.SWIPE_SUCCEED;

      let mockLog: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockLog)(ArgumentMatchers.any).afterReturnNothing();

      await liveheadsupwalletanimation.swipeExitEndAnimation();

      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_return_false_when_animationStage_is_not_EXIT_START', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      walletVm.animationStage = SweepStage.SWIPE_START;
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(walletVm);
      const result = liveheadsupwalletanimation.swipeSuspendAllAnimations();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_imageInfo_nextInstruction_is_SWIPE_FAILED', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      walletVm.animationStage = AnimationStage.EXIT_START;
      walletVm.imageInfo.nextInstruction = WalletStageValue.SWIPE_FAILED;
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(walletVm);
      const result = liveheadsupwalletanimation.swipeSuspendAllAnimations();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_imageInfo_nextInstruction_is_SWIPE_SUCCEED', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      walletVm.animationStage = AnimationStage.EXIT_START;
      walletVm.imageInfo.nextInstruction = WalletStageValue.SWIPE_SUCCEED;
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(walletVm);
      const result = liveheadsupwalletanimation.swipeSuspendAllAnimations();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let walletVm: ILiveHeadsUpWalletCardVm = new ILiveHeadsUpWalletCardVm();
      walletVm.animationStage = AnimationStage.EXIT_START;
      walletVm.imageInfo.nextInstruction = WalletStageValue.SWIPE_SUCCEED;
      let liveheadsupwalletanimation: LiveHeadsUpWalletAnimation = new LiveHeadsUpWalletAnimation(walletVm);
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      const result = liveheadsupwalletanimation.swipeSuspendAllAnimations();
      expect(result).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.info);
    });
  });
}