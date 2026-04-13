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
import { AnimateParams } from '../../animation/AnimationBase';
import { LiveHeadsUpWalletAnimation } from './LiveHeadsUpWalletAnimation';
import { getWalletSwipeEnterHoleAnimation } from './wallet/WalletSwipeEnterHoleAnimation';
import { getWalletSwipeEnterRefreshImageHoleAni } from './wallet/WalletSwipeEnterRefreshImageHoleAni';
import { getSwipeEnterRotationHoleAni } from './wallet/WalletSwipeEnterRotationHoleAni';
import { getWalletSwipeEnterSweepHoleAnimation } from './wallet/WalletSwipeEnterSweepHoleAnimation';
import { getSwipeExitFailEndHoleAni } from './wallet/WalletSwipeExitFailEndHoleAni';
import { getSwipeExitFailEndPhaseOneHoleAni } from './wallet/WalletSwipeExitFailEndPhaseOneHoleAni';
import { getWalletSwipeExitFailStartHoleAni } from './wallet/WalletSwipeExitFailStartHoleAni';
import { getSwipeExitNoFeedbackEndHoleAni } from './wallet/WalletSwipeExitNoFeedbackEndHoleAni';
import { getSwipeExitSuccessEndHoleAni } from './wallet/WalletSwipeExitSuccessEndHoleAni';
import { getSwipeExitSuccessEndPhaseOneHoleAni } from './wallet/WalletSwipeExitSuccessEndPhaseOneHoleAni';
import { getWalletSwipeExitSuccessStartHoleAni } from './wallet/WalletSwipeExitSuccessStartHoleAni';

export class LiveHeadsUpWalletHoleAnimation extends LiveHeadsUpWalletAnimation {
  swipeSuspendAllAnimations(): boolean {
    if (super.swipeSuspendAllAnimations()) {
      this.walletVm.overlayBoxInfo.borderRadius = 20
      this.walletVm.overlayBoxInfo.width = this.walletVm.bannerWidthConstantFinalState
      this.walletVm.imageInfo.translateX = -((this.walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
      this.walletVm.textInfo.textTranslateX = -((this.walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
      this.walletVm.textInfo.textOpacity = 1
    }
    return true;
  }

  getSwipeExitNoFeedbackEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
    return getSwipeExitNoFeedbackEndHoleAni(this.walletVm, resolve);
  }

  getSwipeExitFailEndPhaseOneData(onFinish: () => Promise<void>): AnimateParams[] {
    return getSwipeExitFailEndPhaseOneHoleAni(onFinish);
  }

  getSwipeExitFailEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
    return getSwipeExitFailEndHoleAni(this.walletVm, resolve);
  }

  getSwipeExitFailStartData(): AnimateParams[] {
    return getWalletSwipeExitFailStartHoleAni(this.walletVm);
  }

  getSwipeExitSuccessEndPhaseOneData(onFinish: () => Promise<void>): AnimateParams[] {
    return getSwipeExitSuccessEndPhaseOneHoleAni(this.walletVm, onFinish);
  }

  getSwipeExitSuccessEndData(resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
    return getSwipeExitSuccessEndHoleAni(this.walletVm, resolve);
  }

  getSwipeExitSuccessStartData(): AnimateParams[] {
    return getWalletSwipeExitSuccessStartHoleAni(this.walletVm);
  }

  getSwipeEnterRefreshImageData(): AnimateParams[] {
    return getWalletSwipeEnterRefreshImageHoleAni(this.walletVm);
  }

  getSwipeEnterData(): AnimateParams[] {
    return getWalletSwipeEnterHoleAnimation(this.walletVm);
  }

  getSwipeEnterSweepData(delay: number, animateParams: AnimateParams[]): AnimateParams[] {
    return getWalletSwipeEnterSweepHoleAnimation(this.walletVm, animateParams, delay);
  }

  getSwipeEnterRotationData(onFinish: () => Promise<void>): AnimateParams[] {
    return getSwipeEnterRotationHoleAni(this.walletVm, onFinish);
  }
}