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
import { LiveViewRequestExitImmersiveEvent } from '../../../../event/LiveViewEvent';
import { InnerEventUtil } from '../../../../utils/InnerEventUtil';
import { LiveCardListAnimation } from '../../../animation/LiveCardListAnimation';
import { ILiveSwitchVm } from '../../../interface/ILiveSwitchVm';
import { LiveSwitchVm } from '../../../vm/LiveSwitchVm';
import { PocketLiveCardListAnimation } from '../animation/PocketLiveCardListAnimation';
import type { PocketLiveCapsuleListVm } from './PocketLiveCapsuleListVm';
import { DeviceInfoVm } from '../../../../vm/DeviceInfoVm';

export class PocketLiveSwitchVm extends LiveSwitchVm implements ILiveSwitchVm {
  protected async expandCard(): Promise<void> {
    const capsuleListVm = this.vmInjector.getCapsuleListVm() as PocketLiveCapsuleListVm;
    if (capsuleListVm.immersiveHashCode) {
      capsuleListVm.immersiveHashCode = '';
      InnerEventUtil.post(LiveViewRequestExitImmersiveEvent, new LiveViewRequestExitImmersiveEvent());
    }
    await super.expandCard();
  }

  protected getCardListAnimation(): LiveCardListAnimation {
    return super.getCardListAnimation();
  }
}