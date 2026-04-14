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

export function getSwipeExitSuccessEndPhaseOneHoleAni(walletVm: ILiveHeadsUpWalletCardVm,
  onFinish: () => Promise<void>) {
  let animateParams: AnimateParams[] = [];
  animateParams.push(
    {
      duration: 0,
      onFinish: onFinish,
      event: () => {
      }
    }
  );
  return animateParams;
}