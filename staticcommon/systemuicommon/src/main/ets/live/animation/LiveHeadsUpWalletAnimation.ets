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
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { ILiveHeadsUpWalletCardVm } from '../interface/ILiveHeadsUpWalletCardVm';
import { SweepStage, WalletStageValue } from '../vm/LiveHeadsUpWalletCardVm';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveHeadsUpWalletAnimation');

export enum AnimationStage {
  INIT = 0,
  ENTER = 1,
  ROTATING = 2,
  EXIT_START = 3,
  EXIT_END = 4,
}

export const SUCCESS_START_DELAY_TIME = 315;

export abstract class LiveHeadsUpWalletAnimation extends AnimationBase {
  protected walletVm: ILiveHeadsUpWalletCardVm;

  constructor(walletVm: ILiveHeadsUpWalletCardVm) {
    super(AnimationBase.NAMES.LIVE_HEADS_UP_WALLET_ANIMATION, true);
    this.walletVm = walletVm;
  }

  // 实况框弹出动画，涉及到智选卡弹出和默认卡弹出
  public async swipeEnterAnimation(): Promise<void> {
    log.info(`[swipeEnterAnimation()] begins`)
    this.walletVm.animationStage = AnimationStage.ENTER;
    let animateParams: AnimateParams[] = this.getSwipeEnterData();

    if (this.walletVm.live?.stage === WalletStageValue.SWIPE_DOING) {
      this.swipeEnterSweepAnimation(650, animateParams);
    }
    animateParams.push({
      duration: 800,
      onFinish: () => {
        this.walletVm.isPlayingRotation = false;
        this.swipeEnterAngleFixedAnimation();
      },
      event: () => {
      }
    })
    const swipeEnterAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_ENTER_ANIMATION);
    await swipeEnterAnimation.executeAnimation(animateParams);
  }

  public async swipeEnterSweepAnimation(delay: number = 0, animateParams: AnimateParams[]): Promise<void> {
    if (this.walletVm.live?.stage === undefined || this.walletVm.live.stage < WalletStageValue.SWIPE_DOING) {
      return;
    }
    if (this.walletVm.sweepingStage !== SweepStage.CAN_DO) {
      return;
    }
    this.walletVm.sweepingStage = SweepStage.DONE;
    log.info(`[swipeEnterSweepAnimation()] begins`)
    this.getSwipeEnterSweepData(delay, animateParams);
  }

  public async swipeEnterRotationAnimation(): Promise<void> {
    log.info(`[swipeEnterRotationAnimation()] begins isPlayingRotation ${this.walletVm.isPlayingRotation}`);
    if (this.walletVm.isPlayingRotation) {
      return;
    }
    this.walletVm.isPlayingRotation = true;
    this.walletVm.animationStage = AnimationStage.ROTATING;
    const swipeEnterRotationAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_ENTER_ROTATION_ANIMATION);
    await swipeEnterRotationAnimation.executeAnimation(this.getSwipeEnterRotationData(
      async () => {
        log.info(`this.imaheInfo.nextInsttuction is ${this.walletVm.imageInfo.nextInstruction}`);
        this.walletVm.isPlayingRotation = false;
        this.swipeEnterAngleFixedAnimation();
      }))
  }

  public async swipeEnterAngleFixedAnimation(): Promise<void> {
    if (this.walletVm.imageInfo.nextInstruction >= WalletStageValue.SWIPE_FINISHED) {
      return;
    }
    log.info(`[swipeEnterAngleFixedAnimation()] begins`);
    let animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        duration: 250,
        onFinish: () => {
          log.info(`[swipeEnterAngleFixedAnimation()] onFinish`)
          if (this.walletVm.imageInfo.nextInstruction === -1) {
            this.swipeEnterRotationAnimation();
          } else {
            this.swipeExitStartAnimation();
          }
        },
        event: () => {
          this.walletVm.imageInfo.X = 0
          this.walletVm.imageInfo.Y = 1
          this.walletVm.imageInfo.Z = 0
          this.walletVm.imageInfo.angle = 0
        }
      }
    )
    const swipeEnterAngleFixedAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_ENTER_ANGLE_FIXED_ANIMATION);
    await swipeEnterAngleFixedAnimation.executeAnimation(animateParams);
  }

  public async swipeEnterRefreshImageAnimation(): Promise<void> {
    log.info(`[swipeEnterRefreshImageAnimation()] begins`);
    // 解决V2动画处在微任务队列不执行问题
    setTimeout(async () => {
      let animateParams: AnimateParams[] = this.getSwipeEnterRefreshImageData();
      this.swipeEnterSweepAnimation(0, animateParams);
      const swipeEnterRefreshImageAnimation: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_ENTER_REFRESH_IMAGE_ANIMATION);
      await swipeEnterRefreshImageAnimation.executeAnimation(animateParams);
    }, 0)
  }

  public swipeExitStartAnimation() {
    log.info(`[swipeExitStartAnimation()] starts`)
    if (this.walletVm.animationStage >= AnimationStage.EXIT_START) {
      return;
    }
    this.walletVm.animationStage = AnimationStage.EXIT_START;
    if (this.walletVm.imageInfo.nextInstruction === WalletStageValue.SWIPE_SUCCEED) {
      this.walletVm.exitStartTime = Date.now()
      this.swipeExitSuccessStartAnimation();
    } else if (this.walletVm.imageInfo.nextInstruction === WalletStageValue.SWIPE_FAILED) {
      this.walletVm.exitStartTime = Date.now()
      this.swipeExitFailStartAnimation();
    } else if (this.walletVm.imageInfo.nextInstruction === WalletStageValue.SWIPE_FINISHED) {
      this.swipeExitNoFeedbackStartAnimation();
    }
  }

  public async swipeExitEndAnimation() {
    if (this.walletVm.animationStage >= AnimationStage.EXIT_END) {
      return;
    }
    log.info(`[swipeExitEndAnimation()] begin`);
    await new Promise<void>((resolve1) => {
      let exitStartExtra = Date.now() - this.walletVm.exitStartTime;
      log.info(`exitStartExtra is ${exitStartExtra}}, this.walletVm.exitStartTime is ${this.walletVm.exitStartTime}`);
      setTimeout(async () => {
        this.swipeSuspendAllAnimations();
        await new Promise<void>((resolve) => {
          setTimeout(() => resolve(), 3000);
          this.walletVm.animationStage = AnimationStage.EXIT_END;
          if (this.walletVm.imageInfo.nextInstruction === WalletStageValue.SWIPE_SUCCEED) {
            this.swipeExitSuccessEndAnimation(resolve);
          } else if (this.walletVm.imageInfo.nextInstruction === WalletStageValue.SWIPE_FAILED) {
            this.swipeExitFailEndAnimation(resolve);
          } else if (this.walletVm.imageInfo.nextInstruction === WalletStageValue.SWIPE_FINISHED) {
            this.swipeExitNoFeedbackEndAnimation(resolve)
          }
        });
        resolve1();
      }, SUCCESS_START_DELAY_TIME + 10 - exitStartExtra > 0 ? SUCCESS_START_DELAY_TIME + 10 - exitStartExtra : 0)
    })
  }

  swipeSuspendAllAnimations(): boolean {
    this.walletVm.imageInfo.X = 0
    this.walletVm.imageInfo.Y = 1
    this.walletVm.imageInfo.Z = 0
    this.walletVm.imageInfo.angle = 0
    if (this.walletVm.animationStage !== AnimationStage.EXIT_START) {
      return false;
    }
    if (this.walletVm.imageInfo.nextInstruction !== WalletStageValue.SWIPE_SUCCEED &&
      this.walletVm.imageInfo.nextInstruction !== WalletStageValue.SWIPE_FAILED) {
      return false;
    }
    log.info(`[swipeSuspendAllAnimations()] begin`);
    return true;
  }

  public async swipeExitSuccessStartAnimation(): Promise<void> {
    log.info(`[swipeExitSuccessStartAnimation()] begins`);
    const swipeExitSuccessStartAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_EXIT_SUCCESS_START_ANIMATION);
    await swipeExitSuccessStartAnimation.executeAnimation(this.getSwipeExitSuccessStartData());
  }

  public async swipeExitSuccessEndAnimation(resolve: (value: void | PromiseLike<void>) => void): Promise<void> {
    log.info(`[swipeExitSuccessEndAnimation()] PhaseOne begins`)
    const swipeExitSuccessEndAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_EXIT_SUCCESS_END_ANIMATION);
    const swipeExitSuccessEndPhaseOneData: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_EXIT_SUCCESS_END_PHASE_ANIMATION);
    await swipeExitSuccessEndPhaseOneData.executeAnimation(this.getSwipeExitSuccessEndPhaseOneData(async () => {
      log.info(`[swipeExitSuccessEndAnimation()] begins`)
      await swipeExitSuccessEndAnimation.executeAnimation(this.getSwipeExitSuccessEndData(resolve));
    }));
  }

  public async swipeExitFailStartAnimation(): Promise<void> {
    log.info(`[swipeExitFailStartAnimation()] begins`)
    const swipeExitFailStartAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_EXIT_FAIL_START_ANIMATION);
    await swipeExitFailStartAnimation.executeAnimation(this.getSwipeExitFailStartData());
  }

  public async swipeExitFailEndAnimation(resolve: (value: void | PromiseLike<void>) => void): Promise<void> {
    const swipeExitFailEndAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_EXIT_FAIL_END_ANIMATION);
    const getSwipeExitFailEndPhaseOneData: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_EXIT_FAIL_END_PHASE_ANIMATION);
    log.info(`[swipeExitFailEndAnimation()] PhaseOne begins`)
    await getSwipeExitFailEndPhaseOneData.executeAnimation(this.getSwipeExitFailEndPhaseOneData((async () => {
      log.info(`[swipeExitFailEndAnimation()] begins`)
      await swipeExitFailEndAnimation.executeAnimation(this.getSwipeExitFailEndData(resolve));
    })));
  }

  public async swipeExitNoFeedbackStartAnimation() {
  }

  public async swipeExitNoFeedbackEndAnimation(resolve: (value: void | PromiseLike<void>) => void): Promise<void> {
    log.info(`[swipeExitNoFeedbackEndAnimation()] begins`)
    const swipeExitNoFeedbackEndAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.WALLET_SWIPE_EXIT_NO_FEEDBACK_END_ANIMATION);
    await swipeExitNoFeedbackEndAnimation.executeAnimation(this.getSwipeExitNoFeedbackEndData(resolve));
  }

  abstract getSwipeExitNoFeedbackEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[];

  abstract getSwipeExitFailEndPhaseOneData(onFinish: () => Promise<void>): AnimateParams[];

  abstract getSwipeExitFailEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[];

  abstract getSwipeExitFailStartData(): AnimateParams[];

  abstract getSwipeExitSuccessEndPhaseOneData(onFinish: () => Promise<void>): AnimateParams[];

  abstract getSwipeExitSuccessEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[];

  abstract getSwipeExitSuccessStartData(): AnimateParams[];

  abstract getSwipeEnterRefreshImageData(): AnimateParams[];

  abstract getSwipeEnterData(): AnimateParams[];

  abstract getSwipeEnterSweepData(delay: number, animateParams: AnimateParams[]): AnimateParams[];

  abstract getSwipeEnterRotationData(onFinish: () => Promise<void>): AnimateParams[];
}
