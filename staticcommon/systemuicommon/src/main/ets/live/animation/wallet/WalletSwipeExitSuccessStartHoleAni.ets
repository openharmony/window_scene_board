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
import { SUCCESS_START_DELAY_TIME } from '../LiveHeadsUpWalletAnimation';

export function getWalletSwipeExitSuccessStartHoleAni(walletVm: ILiveHeadsUpWalletCardVm) {
  let animateParams: AnimateParams[] = [];
  let curveArray: ICurve[] = [
    curves.cubicBezierCurve(0.33, 0.00, 0.67, 1),
    curves.cubicBezierCurve(0, 0, 1, 1)
  ]
  let lottieData: Object | null = null;
  walletVm.radioInfo.geLottieData('appear.json', (value) => {
    lottieData = value;
  })
  animateParams.push(
    {
      curve: curveArray[0],
      duration: SUCCESS_START_DELAY_TIME - 1,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = 90
      }
    },
    {
      delay: SUCCESS_START_DELAY_TIME - 1,
      curve: curveArray[0],
      duration: 1,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = -90
      }
    },
    {
      delay: SUCCESS_START_DELAY_TIME,
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
      // 框的长度变化
      delay: SUCCESS_START_DELAY_TIME,
      curve: curves.interpolatingSpring(0, 1, 60, 11),
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 20
        walletVm.overlayBoxInfo.width = walletVm.bannerWidthConstantFinalState
      }
    },
    {
      delay: SUCCESS_START_DELAY_TIME,
      curve: curves.interpolatingSpring(0, 1, 70, 11),
      event: () => {
        walletVm.imageInfo.translateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
        walletVm.textInfo.textTranslateX = -((walletVm.bannerWidthConstantFinalState / 2) - 38 - 12)
      }
    },
    {
      delay: 415,
      curve: curveArray[0],
      duration: 300,
      event: () => {
        walletVm.textInfo.textOpacity = 1
      }
    },
    {
      delay: 528.33,
      curve: curveArray[1],
      duration: 300,
      event: () => {
        walletVm.radioInfo.radioOpacity = 1;
        walletVm.radioInfo.radioscalaX = 1
        walletVm.radioInfo.radioscalaY = 1
      }
    },
    {
      duration: 608.33,
      onFinish: () => {
        if (walletVm.radioInfo.animateItemAppear != null) {
          walletVm.radioInfo.animateItemAppear.destroy()
          walletVm.radioInfo.animateItemAppear = null
        }
        walletVm.radioInfo.animateItemAppear = lottie.loadAnimation({
          container: walletVm.radioInfo.controller,
          renderer: 'canvas',
          loop: false,
          autoplay: true,
          name: walletVm.radioInfo.animateNameAppear,
          animationData: lottieData,
        })
      },
      event: () => {
      }
    }
  );
  return animateParams;

}