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

export function getSwipeExitFailEndPhaseOneNoHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  onFinish: () => Promise<void>): AnimateParams[] {
  let animateParams: AnimateParams[] = [];
  let commonCurve: ICurve = curves.cubicBezierCurve(0.33, 0.00, 0.67, 1);
  animateParams.push(
    {
      duration: 200,
      curve: commonCurve,
      event: () => {
        walletVm.radioInfo.radioOpacity = 0;
        walletVm.radioInfo.radioscalaX = 0.5;
        walletVm.radioInfo.radioscalaY = 0.5;
      }
    },
    {
      curve: commonCurve,
      delay: 250,
      duration: 150,
      event: () => {
        walletVm.textInfo.textOpacity = 0;
      }
    },
    {
      delay: 150,
      duration: 300,
      curve: Curve.Linear,
      onFinish: onFinish,
      event: () => {
        walletVm.overlayBoxInfo.width = 100;
      }
    },
    {
      delay: 370,
      duration: 150,
      curve: Curve.Linear,
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 26;
        walletVm.overlayBoxInfo.height = 62;
      }
    },
    {
      delay: 470,
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
      delay: 220,
      curve: curves.cubicBezierCurve(0.16, 0.00, 0.59, 0.14),
      duration: 300,
      event: () => {
        walletVm.imageInfo.scalaX = 0.7;
        walletVm.imageInfo.scalaY = 0.7;
      }
    }
  );
  return animateParams;
}