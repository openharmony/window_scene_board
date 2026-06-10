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
import { ILiveCapsuleListLayoutVm } from '../../interface/ILiveCapsuleLayoutVm';
import { ILiveVmInjector } from '../../interface/ILiveVmInjector';
import { LiveVmInjector } from '../../LiveVmInjector';
import { LiveVmFactory } from '../../vm/LiveVmFactory';
import { CutoutVm } from '../../../statusbar/vm/CutoutVm';
import { DeviceInfoVm } from '../../../vm/DeviceInfoVm';
import { PocketLiveCapsuleListOuterHomeLayoutVm } from './vm/PocketLiveCapsuleListOuterHomeLayoutVm';
import { PocketLiveCapsuleListWithoutHoleLayoutVm } from './vm/PocketLiveCapsuleListWithoutHoleLayoutVm';
import { PocketLiveCapsuleListSingleHoleLayoutVm } from './vm/PocketLiveCapsuleListSingleHoleLayoutVm';
import { LogDomain, Logger } from '@ohos/basicutils';
import { ILiveCapsuleListAnimVm } from '../../interface/ILiveCapsuleListAnimVm';
import { PocketLiveCapsuleListWithoutHoleAnimVm } from './vm/PocketLiveCapsuleListWithoutHoleAnimVm';

const TAG = 'PocketLiveVmFactory';
const log = Logger.getLogHelper(LogDomain.SYS_UI);

export class PocketLiveVmFactory extends LiveVmFactory {
  createCapsuleListLayoutVm(vmName: string, vmInjector: ILiveVmInjector): ILiveCapsuleListLayoutVm {
    switch (vmName) {
      case PocketLiveCapsuleListSingleHoleLayoutVm.name:
        log.showInfo(TAG, 'return PocketLiveCapsuleListSingleHoleLayoutVm');
        return new PocketLiveCapsuleListSingleHoleLayoutVm(vmInjector);
      case PocketLiveCapsuleListOuterHomeLayoutVm.name:
        log.showInfo(TAG, 'return PocketLiveCapsuleListOuterHomeLayoutVm');
        return new PocketLiveCapsuleListOuterHomeLayoutVm(vmInjector);
      default:
        log.showInfo(TAG, 'return PocketLiveCapsuleListWithoutHoleLayoutVm');
        return new PocketLiveCapsuleListWithoutHoleLayoutVm(vmInjector);
    }
  }

  getCapsuleListLayoutVmNameByCutoutVm(): string {
    if (CutoutVm.instance.isMiddleCutout()) {
      return PocketLiveCapsuleListSingleHoleLayoutVm.name;
    }
    return PocketLiveCapsuleListWithoutHoleLayoutVm.name;
  }

  createCapsuleListAnimVm(vmName: string, vmInjector: LiveVmInjector): ILiveCapsuleListAnimVm {
    switch (vmName) {
      case PocketLiveCapsuleListWithoutHoleAnimVm.name:
        return new PocketLiveCapsuleListWithoutHoleAnimVm(vmInjector);
      default:
        return super.createCapsuleListAnimVm(vmName, vmInjector);
    }
  }

  getCapsuleListAnimVmNameByCutoutVm(): string {
    return super.getCapsuleListAnimVmNameByCutoutVm();
  }
}