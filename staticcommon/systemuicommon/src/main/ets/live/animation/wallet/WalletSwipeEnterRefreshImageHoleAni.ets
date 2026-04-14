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
import { curves } from '@kit.ArkUI';
import { AnimateParams } from '../../../animation/AnimationBase';
import { ILiveHeadsUpWalletCardVm } from '../../interface/ILiveHeadsUpWalletCardVm';

export function getWalletSwipeEnterRefreshImageHoleAni(walletVm: ILiveHeadsUpWalletCardVm): AnimateParams[] {
  let animateParams: AnimateParams[] = [];
  animateParams.push(
    {
      curve: curves.cubicBezierCurve(0.33, 0.00, 0.67, 1),
      duration: 300,
      event: () => {
        walletVm.imageInfo.defaultCardOpacity = 0;
        walletVm.imageInfo.imageUpdateCardOpacity = 1
      }
    }
  );
  return animateParams;

}