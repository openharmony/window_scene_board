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
import { curves } from '@kit.ArkUI';
import { ILiveHeadsUpWalletCardVm } from '../../interface/ILiveHeadsUpWalletCardVm';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'getSwipeExitNoFeedbackEndHoleAni')

export function getSwipeExitNoFeedbackEndHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  resolve: (value: void | PromiseLike<void>) => void): AnimateParams[] {
  let animateParams: AnimateParams[] = [];
  animateParams.push(
    {
      duration: 200,
      onFinish: () => {
        walletVm.overlayBoxInfo.backGroundColor = false;
      },
      event: () => {
      }
    },
    {
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.83, 1.00),
      duration: 250,
      event: () => {
        walletVm.imageInfo.scalaX = 0
        walletVm.imageInfo.scalaY = 0
      }
    },
    {
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.67, 1.00),
      duration: 350,
      onFinish: () => {
        log.info(`[swipeExitNoFeedbackEndAnimation()] end`)
        resolve();
      },
      event: () => {
        walletVm.imageInfo.angle = 36
        walletVm.imageInfo.X = 1;
        walletVm.imageInfo.Y = 0;
        walletVm.imageInfo.Z = 0;
      }
    },
    {
      delay: 0,
      duration: 300,
      curve: Curve.FastOutLinearIn,
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 14
        walletVm.overlayBoxInfo.width = 28
        walletVm.overlayBoxInfo.height = 28
        walletVm.overlayBoxInfo.translateY = -26
        walletVm.imageInfo.translateY = -26
      }
    },
    {
      delay: 300,
      duration: 50,
      curve: Curve.FastOutLinearIn,
      event: () => {
        walletVm.overlayBoxInfo.borderRadius = 7
        walletVm.overlayBoxInfo.width = 14
        walletVm.overlayBoxInfo.height = 20
        walletVm.overlayBoxInfo.translateY = -40
      }
    }
  );
  return animateParams;
}