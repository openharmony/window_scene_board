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

export function getWalletSwipeEnterNoHoleAnimation(walletVm: ILiveHeadsUpWalletCardVm): AnimateParams[] {
  walletVm.overlayBoxInfo.backGroundColor = true;
  walletVm.overlayBoxInfo.width = 10
  walletVm.overlayBoxInfo.height = 10
  walletVm.overlayBoxInfo.opacity = 0;
  let animateParams: AnimateParams[] = [];
  animateParams.push(
    {
      delay: 0,
      curve: curves.interpolatingSpring(0, 1, 110, 11),
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 16
        walletVm.overlayBoxInfo.translateY = 0
        walletVm.overlayBoxInfo.width = 100
        walletVm.overlayBoxInfo.height = walletVm.largeFontAdaptationHeight;
      }
    },
    {
      delay: 16,
      duration: 66,
      event: () => {
        walletVm.overlayBoxInfo.opacity = 1
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
      curve: curves.cubicBezierCurve(0.20, 0.00, 0.57, 1.00),
      duration: 250,
      event: () => {
        walletVm.imageInfo.translateY = '-6px'
      }
    },
    {
      delay: 150,
      curve: curves.cubicBezierCurve(0.20, 0.00, 0.57, 1.00),
      duration: 500,
      event: () => {
        walletVm.imageInfo.angle = 0
      }
    },
    {
      delay: 400,
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.33, 1.00),
      duration: 250,
      event: () => {
        walletVm.imageInfo.scalaX = 1
        walletVm.imageInfo.scalaY = 1
        walletVm.imageInfo.translateY = 0
      }
    }
  )
  return animateParams
}