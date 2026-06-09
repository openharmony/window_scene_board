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
import { AnimateParams } from '../../../animation/AnimationBase';
import { curves } from '@kit.ArkUI';
import { ILiveHeadsUpWalletCardVm } from '../../interface/ILiveHeadsUpWalletCardVm';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'getSwipeExitNoFeedbackEndNoHoleAni')

export function getSwipeExitNoFeedbackEndNoHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
  let animateParams: AnimateParams[] = [];
  animateParams.push(
    {
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.83, 1.00),
      duration: 300,
      event: () => {
        walletVm.imageInfo.scalaX = 0
        walletVm.imageInfo.scalaY = 0
      }
    },
    {
      delay: 365.67,
      duration: 66,
      event: () => {
        walletVm.overlayBoxInfo.opacity = 0
      }
    },
    {
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.67, 1.00),
      duration: 300,
      onFinish: () => {
        log.info(`[swipeExitNoFeedbackEndAnimation()] 2`)
      },
      event: () => {
        walletVm.imageInfo.angle = 36
        walletVm.imageInfo.X = 1;
        walletVm.imageInfo.Y = 0;
        walletVm.imageInfo.Z = 0;
      }
    },
    {
      delay: 66.67,
      curve: Curve.FastOutLinearIn,
      duration: 365,
      onFinish: () => {
        log.info(`[swipeExitNoFeedbackEndAnimation()] end`)
        resolve();
      },
      event: () => {
        walletVm.overlayBoxInfo.width = 10
        walletVm.overlayBoxInfo.height = 10
        walletVm.overlayBoxInfo.borderRadius = 16
        walletVm.overlayBoxInfo.translateY = -45
        walletVm.imageInfo.translateY = -45
      }
    }
  );
  return animateParams;
}