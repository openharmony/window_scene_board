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

import { LiveCapsuleListWithoutHoleAnimVm } from '../../../vm/LiveCapsuleListWithoutHoleAnimVm';
import { ILiveCapsuleVm } from '../../../interface/ILiveCapsuleVm';
import { LiveStyle } from '../../../constants/LiveStyle';
import { EnvVm } from '../../../../vm/EnvVm';

@ObservedV2
export class PocketLiveCapsuleListWithoutHoleAnimVm extends LiveCapsuleListWithoutHoleAnimVm {
  protected getCollapseCapsuleWidth(): number {
    return this.getTransferState(LiveStyle.CAPSULE_SMALL_CIRCLE_WIDTH);
  }

  protected getOpacityAnimExtraDelay(): number {
    return 0;
  }

  protected getCapsuleCollapseOffset(): number {
    return EnvVm.instance.isScreenLock ? 0 : LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE;
  }

  protected setCollapseCapsuleScale(capsuleVm: ILiveCapsuleVm): void {
    capsuleVm.scaleX = 0.8;
    capsuleVm.scaleY = 0.8;
  }

  protected setExpandCapsuleScale(capsuleVm: ILiveCapsuleVm): void {
    capsuleVm.scaleX = 1;
    capsuleVm.scaleY = 1;
  }
}