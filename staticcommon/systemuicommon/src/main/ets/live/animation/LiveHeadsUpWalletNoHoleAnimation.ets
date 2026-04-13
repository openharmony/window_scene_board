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
import { AnimateParams } from '../../animation/AnimationBase'
import { LiveHeadsUpWalletAnimation } from './LiveHeadsUpWalletAnimation'
import { getWalletSwipeEnterNoHoleAnimation } from './wallet/WalletSwipeEnterNoHoleAnimation'
import { getWalletSwipeEnterRefreshImageNoHoleAni } from './wallet/WalletSwipeEnterRefreshImageNoHoleAni'
import { getSwipeEnterRotationNoHoleAni } from './wallet/WalletSwipeEnterRotationNoHoleAni'
import { getWalletSwipeEnterSweepNoHoleAnimation } from './wallet/WalletSwipeEnterSweepNoHoleAnimation'
import { getSwipeExitFailEndNoHoleAni } from './wallet/WalletSwipeExitFailEndNoHoleAni'
import { getSwipeExitFailEndPhaseOneNoHoleAni } from './wallet/WalletSwipeExitFailEndPhaseOneNoHoleAni'
import { getWalletSwipeExitFailStartNoHoleAni } from './wallet/WalletSwipeExitFailStartNoHoleAni'
import { getSwipeExitNoFeedbackEndNoHoleAni } from './wallet/WalletSwipeExitNoFeedbackEndNoHoleAni'
import { getSwipeExitSuccessEndNoHoleAni } from './wallet/WalletSwipeExitSuccessEndNoHoleAni'
import { getSwipeExitSuccessEndPhaseOneNoHoleAni } from './wallet/WalletSwipeExitSuccessEndPhaseOneNoHoleAni'
import { getWalletSwipeExitSuccessStartNoHoleAni } from './wallet/WalletSwipeExitSuccessStartNoHoleAni'

export class LiveHeadsUpWalletNoHoleAnimation extends LiveHeadsUpWalletAnimation {
  swipeSuspendAllAnimations(): boolean {
    if (super.swipeSuspendAllAnimations()) {
      this.walletVm.overlayBoxInfo.borderRadius = 20
      this.walletVm.overlayBoxInfo.width = this.walletVm.bannerWidthConstantFinalState
      this.walletVm.textInfo.textOpacity = 1
    }
    return true;
  }

  public async swipeExitSuccessStartAnimation(): Promise<void> {
    this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutAlignment = true
    await super.swipeExitSuccessStartAnimation();
  }

  public async swipeExitFailStartAnimation(): Promise<void> {
    this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutAlignment = true
    await super.swipeExitFailStartAnimation();
  }

  getSwipeExitNoFeedbackEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
    return getSwipeExitNoFeedbackEndNoHoleAni(this.walletVm, resolve);
  }

  getSwipeExitFailEndPhaseOneData(onFinish: () => Promise<void>): AnimateParams[] {
    return getSwipeExitFailEndPhaseOneNoHoleAni(this.walletVm, onFinish);
  }

  getSwipeExitFailEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
    return getSwipeExitFailEndNoHoleAni(this.walletVm, resolve);
  }

  getSwipeExitFailStartData(): AnimateParams[] {
    return getWalletSwipeExitFailStartNoHoleAni(this.walletVm);
  }

  getSwipeExitSuccessEndPhaseOneData(onFinish: () => Promise<void>): AnimateParams[] {
    return getSwipeExitSuccessEndPhaseOneNoHoleAni(this.walletVm, onFinish);
  }

  getSwipeExitSuccessEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
    return getSwipeExitSuccessEndNoHoleAni(this.walletVm, resolve);
  }

  getSwipeExitSuccessStartData(): AnimateParams[] {
    return getWalletSwipeExitSuccessStartNoHoleAni(this.walletVm);
  }

  getSwipeEnterRefreshImageData(): AnimateParams[] {
    return getWalletSwipeEnterRefreshImageNoHoleAni(this.walletVm);
  }

  getSwipeEnterData(): AnimateParams[] {
    return getWalletSwipeEnterNoHoleAnimation(this.walletVm);
  }

  getSwipeEnterSweepData(delay: number, animateParams: AnimateParams[]): AnimateParams[] {
    return getWalletSwipeEnterSweepNoHoleAnimation(this.walletVm, animateParams, delay);
  }

  getSwipeEnterRotationData(onFinish: () => Promise<void>): AnimateParams[] {
    return getSwipeEnterRotationNoHoleAni(this.walletVm, onFinish);
  }
}