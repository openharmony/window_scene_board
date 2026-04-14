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
import lottie from '@ohos/lottie';
import { AnimateParams } from '../../../animation/AnimationBase';
import { ILiveHeadsUpWalletCardVm } from '../../interface/ILiveHeadsUpWalletCardVm';
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const SUCCESS_ANIMATION_END_TIME: number = 818.3;
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'getSwipeExitSuccessEndHoleAni');

export function getSwipeExitSuccessEndHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
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
      duration: 693.3,
      onFinish: () => {
        walletVm.overlayBoxInfo.backGroundColor = false
      },
      event: () => {
      }
    },
    {
      curve: commonCurve,
      duration: 250,
      event: () => {
        walletVm.radioInfo.radioOpacity = 0;
        walletVm.radioInfo.radioscalaX = 0.5;
        walletVm.radioInfo.radioscalaY = 0.5;
      }
    },
    {
      delay: 153.3,
      curve: Curve.Linear,
      duration: 300,
      event: () => {
        walletVm.overlayBoxInfo.width = 100;
      }
    },
    {
      delay: 153.3,
      curve: Curve.Linear,
      duration: 200,
      event: () => {
        walletVm.textInfo.textTranslateX = 0;
        walletVm.imageInfo.translateX = 0;
      }
    },
    {
      delay: 353.3,
      curve: Curve.Linear,
      duration: 100,
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 24
        walletVm.overlayBoxInfo.height = 52
      }
    },
    {
      delay: 153.3,
      curve: commonCurve,
      duration: 150,
      event: () => {
        walletVm.textInfo.textOpacity = 0;
      }
    },
    {
      delay: 250,
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
      delay: 153.3,
      curve: curves.cubicBezierCurve(0.16, 0.00, 0.59, 0.14),
      duration: 200,
      event: () => {
        walletVm.imageInfo.scalaX = 0.7;
        walletVm.imageInfo.scalaY = 0.7;
      }
    },
    {
      delay: 453.3,
      duration: 315,
      curve: Curve.FastOutLinearIn,
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 14
        walletVm.overlayBoxInfo.width = 28
        walletVm.overlayBoxInfo.height = 28
        walletVm.overlayBoxInfo.translateY = -28;
        walletVm.imageInfo.translateY = -28;
      }
    },
    {
      delay: 768.3,
      duration: 50,
      curve: Curve.FastOutLinearIn,
      event: () => {
        walletVm.overlayBoxInfo.translateY = -40;
        walletVm.overlayBoxInfo.width = 14
        walletVm.overlayBoxInfo.height = 20
        walletVm.overlayBoxInfo.borderRadius = 7
      }
    },
    {
      delay: 353.3,
      curve: curves.cubicBezierCurve(0.69, 0.70, 1.00, 1.00),
      duration: 350,
      event: () => {
        walletVm.imageInfo.scalaX = 0;
        walletVm.imageInfo.scalaY = 0;
      }
    },
    {
      duration: SUCCESS_ANIMATION_END_TIME,
      onFinish: () => {
        log.info(`[getSwipeExitSuccessEndData()] end`)
        resolve();
      },
      event: () => {
      }
    }
  )
  return animateParams;

}