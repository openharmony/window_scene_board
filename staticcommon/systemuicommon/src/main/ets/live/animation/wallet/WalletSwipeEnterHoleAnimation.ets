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
import { SweepStage } from '../../vm/LiveHeadsUpWalletCardVm';

export function getWalletSwipeEnterHoleAnimation(walletVm: ILiveHeadsUpWalletCardVm): AnimateParams[] {
  let animateParams: AnimateParams[] = [];
  let curveArray: ICurve[] = [
    curves.cubicBezierCurve(0.20, 0.00, 0.57, 1.00),
    curves.cubicBezierCurve(0.33, 0.00, 0.33, 1.00)
  ]
  walletVm.overlayBoxInfo.width = 8
  walletVm.overlayBoxInfo.height = 16
  walletVm.overlayBoxInfo.borderRadius = 8
  walletVm.overlayBoxInfo.translateY = -45;
  animateParams.push(
    {
      duration: 50,
      curve: Curve.Linear,
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 12
        walletVm.overlayBoxInfo.translateY = -30
        walletVm.overlayBoxInfo.width = 24
        walletVm.overlayBoxInfo.height = 24
      }
    },
    {
      delay: 50,
      curve: curves.interpolatingSpring(0, 1, 110, 11),
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 16
        walletVm.overlayBoxInfo.translateY = 0
        walletVm.overlayBoxInfo.width = 100
        walletVm.overlayBoxInfo.height = walletVm.largeFontAdaptationHeight;
      }
    },
    {
      duration: 150,
      onFinish: () => {
        walletVm.overlayBoxInfo.backGroundColor = true
      },
      event: () => {
      }
    },
    {
      duration: 400,
      onFinish: () => {
        if (walletVm.sweepingStage === SweepStage.NOT_DO) {
          walletVm.sweepingStage = SweepStage.CAN_DO;
        }
      },
      event: () => {
      }
    },
    {
      delay: 150,
      curve: curves.cubicBezierCurve(0.04, 0.03, 0.67, 1.00),
      duration: 250,
      event: () => {
        walletVm.imageInfo.scalaX = 1.1
        walletVm.imageInfo.scalaY = 1.1
      }
    },
    {
      delay: 150,
      curve: curveArray[0],
      duration: 250,
      event: () => {
        walletVm.imageInfo.translateY = '-6px'
      }
    },
    {
      delay: 150,
      curve: curveArray[0],
      duration: 500,
      event: () => {
        walletVm.imageInfo.angle = 0
      }
    },
    {
      delay: 400,
      curve: curveArray[1],
      duration: 250,
      event: () => {
        walletVm.imageInfo.scalaX = 1
        walletVm.imageInfo.scalaY = 1
      }
    },
    {
      delay: 400,
      curve: curveArray[1],
      duration: 200,
      event: () => {
        walletVm.imageInfo.translateY = 0
      }
    }
  )

  return animateParams;

}