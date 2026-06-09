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
import { ILiveHeadsUpWalletCardVm } from '../../interface/ILiveHeadsUpWalletCardVm';
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'getSwipeExitSuccessEndNoHoleAni');

export function getSwipeExitSuccessEndNoHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
  walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutAlignment = false
  let animateParams: AnimateParams[] = [];
  animateParams.push(
    {
      curve: Curve.FastOutLinearIn,
      duration: 365,
      event: () => {
        walletVm.overlayBoxInfo.translateY = -45
        walletVm.imageInfo.translateY = -45
        walletVm.overlayBoxInfo.width = 10
        walletVm.overlayBoxInfo.height = 10
        walletVm.overlayBoxInfo.borderRadius = 16
      }
    },
    {
      curve: curves.cubicBezierCurve(0.69, 0.70, 1.00, 1.00),
      duration: 250,
      event: () => {
        walletVm.imageInfo.scalaX = 0
        walletVm.imageInfo.scalaY = 0
      }
    },
    {
      delay: 299,
      duration: 66,
      event: () => {
        walletVm.overlayBoxInfo.opacity = 0
      }
    },
    {
      duration: 365,
      onFinish: () => {
        log.info(`[swipeExitSuccessEndAnimation()] end`)
        resolve();
      },
      event: () => {
      }
    }
  )
  return animateParams;
}