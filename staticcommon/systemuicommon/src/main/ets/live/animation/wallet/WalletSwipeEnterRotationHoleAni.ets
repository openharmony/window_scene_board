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

export function getSwipeEnterRotationHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  onFinish: () => Promise<void>): AnimateParams[] {
  let animateParams: AnimateParams[] = [];
  let rotationCurve: ICurve = curves.cubicBezierCurve(0.33, 0.00, 0.67, 1);
  animateParams.push(
    {
      delay: 0,
      curve: rotationCurve,
      duration: 324,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = 90
      }
    },
    {
      delay: 324,
      curve: rotationCurve,
      duration: 1,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = -90
      }
    },
    {
      delay: 325,
      curve: rotationCurve,
      duration: 325,
      onFinish: onFinish,
      event: () => {
        walletVm.imageInfo.X = 0
        walletVm.imageInfo.Y = 1
        walletVm.imageInfo.Z = 0
        walletVm.imageInfo.angle = 0
      }
    }
  )
  return animateParams;
}