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
import { AnimateParams } from '../../../animation/AnimationBase';
import { ILiveHeadsUpWalletCardVm } from '../../interface/ILiveHeadsUpWalletCardVm';
import { curves } from '@kit.ArkUI';
import lottie from '@ohos/lottie';

export function getSwipeExitSuccessEndPhaseOneNoHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  onFinish: () => Promise<void>) {
  lottie.destroy(walletVm.radioInfo.animateNameAppear);
  walletVm.radioInfo.animateItemAppear = null;
  if (walletVm.radioInfo.animateItemAppearDisAppear != null) {
    walletVm.radioInfo.animateItemAppearDisAppear.destroy();
    walletVm.radioInfo.animateItemAppearDisAppear = null;
  }
  let lottieData: Object | null = null;
  walletVm.radioInfo.geLottieData('disappear.json', (value) => {
    lottieData = value;
  })
  walletVm.radioInfo.animateItemAppear = lottie.loadAnimation({
    container: walletVm.radioInfo.controller,
    renderer: 'canvas',
    loop: false,
    autoplay: true,
    name: walletVm.radioInfo.animateNameDisAppear,
    animationData: lottieData,
  });
  let animateParams: AnimateParams[] = [];
  let commonCurve: ICurve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
  animateParams.push(
    {
      duration: 200,
      onFinish: () => {
        if (walletVm.radioInfo.animateItemAppearDisAppear != null) {
          walletVm.radioInfo.animateItemAppearDisAppear.destroy()
          walletVm.radioInfo.animateItemAppearDisAppear = null
        }
      },
      event: () => {
      }
    },
    {
      delay: 100,
      curve: commonCurve,
      duration: 250,
      event: () => {
        walletVm.radioInfo.radioOpacity = 0;
        walletVm.radioInfo.radioscalaX = 0.5;
        walletVm.radioInfo.radioscalaY = 0.5;
      }
    },
    {
      delay: 300,
      curve: Curve.Linear,
      duration: 300,
      onFinish: onFinish,
      event: () => {
        walletVm.overlayBoxInfo.width = 100;
      }
    },
    {
      delay: 450,
      curve: Curve.Linear,
      duration: 150,
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 26;
        walletVm.overlayBoxInfo.height = 62;
      }
    },
    {
      delay: 550,
      curve: commonCurve,
      duration: 350,
      event: () => {
        walletVm.imageInfo.angle = 36
        walletVm.imageInfo.X = 1;
        walletVm.imageInfo.Y = 0;
        walletVm.imageInfo.Z = 0;
      }
    },
    {
      delay: 300,
      curve: commonCurve,
      duration: 150,
      event: () => {
        walletVm.textInfo.textOpacity = 0;
      }
    },

    {
      delay: 300,
      curve: curves.cubicBezierCurve(0.16, 0.00, 0.59, 0.14),
      duration: 300,
      event: () => {
        walletVm.imageInfo.scalaX = 0.7;
        walletVm.imageInfo.scalaY = 0.7;
      }
    }
  )
  return animateParams;

}