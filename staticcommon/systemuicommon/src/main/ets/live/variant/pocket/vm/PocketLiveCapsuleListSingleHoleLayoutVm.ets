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
import { ILiveCapsuleListLayoutVm } from '../../../interface/ILiveCapsuleLayoutVm';
import { LiveCapsuleListSingleHoleLayoutVm } from '../../../vm/LiveCapsuleListSingleHoleLayoutVm';
import { LiveNotification } from '../../../model/LiveNotification';
import { PocketManager } from '../manager/PocketManager';

@ObservedV2
export class PocketLiveCapsuleListSingleHoleLayoutVm extends LiveCapsuleListSingleHoleLayoutVm
implements ILiveCapsuleListLayoutVm {
  public computeCapsuleFixedWithAndOffset(liveList: LiveNotification[], isUpdate: boolean = true): void {
    this.log.showInfo('computeCapsuleFixedWithAndOffset');
    super.computeCapsuleFixedWithAndOffset(liveList, isUpdate);
    PocketManager.updateCapsuleShowStyle(liveList, this.vmInjector);
  }
}