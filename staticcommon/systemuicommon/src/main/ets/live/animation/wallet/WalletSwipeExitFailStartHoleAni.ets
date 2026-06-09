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

export function getWalletSwipeExitFailStartHoleAni(walletVm: ILiveHeadsUpWalletCardVm) {
  let animateParams: AnimateParams[] = [];
  let commonCurves: ICurve[] = [
    curves.cubicBezierCurve(0.33, 0.00, 0.67, 1),
    curves.cubicBezierCurve(0, 0, 1, 1)
  ]
  walletVm.radioInfo.radioscalaX = 1
  walletVm.radioInfo.radioscalaY = 1
  animateParams.push(
    {
      curve: commonCurves[0],
      duration: 314,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = 90
      }
    },
    {
      delay: 314,
      curve: commonCurves[0],
      duration: 1,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = -90
      }
    },
    {
      delay: 315,
      curve: curves.cubicBezierCurve(0.43, 0.00, 0.00, 1.00),
      duration: 785,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = 0
      }
    },
    {
      delay: 315,
      curve: curves.interpolatingSpring(0, 1, 81, 11),
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 20
        walletVm.overlayBoxInfo.width = walletVm.bannerWidthConstantFinalState
        walletVm.imageInfo.translateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
        walletVm.textInfo.textTranslateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
        walletVm.radioInfo.radioTranslateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
      }
    },
    {
      delay: 415,
      curve: commonCurves[1],
      duration: 300,
      event: () => {
        walletVm.textInfo.textOpacity = 1
      }
    },
    {
      delay: 578.33,
      curve: commonCurves[1],
      duration: 300,
      event: () => {
        walletVm.radioInfo.radioOpacity = 1;
      }
    },
    {
      delay: 900,
      curve: commonCurves[0],
      duration: 150,
      event: () => {
        // （屏幕宽度 - 16 *2)/2 - 38 -12 + 6
        walletVm.imageInfo.translateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12) + 4
      }
    },
    {
      delay: 1050,
      curve: commonCurves[0],
      duration: 150,
      event: () => {
        walletVm.imageInfo.translateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12) - 4
      }
    },

    {
      delay: 1200,
      curve: commonCurves[0],
      duration: 150,
      event: () => {
        walletVm.imageInfo.translateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12) + 2
      }
    },
    {
      delay: 1350,
      curve: commonCurves[0],
      duration: 200,
      event: () => {
        walletVm.imageInfo.translateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
      }
    }
    , {
    delay: 2000,
    curve: commonCurves[1],
    duration: 1,
    event: () => {
      walletVm.imageInfo.X = 1
      walletVm.imageInfo.Y = 0
      walletVm.imageInfo.Z = 0
      walletVm.imageInfo.angle = 0
    }
  });
  return animateParams;
}