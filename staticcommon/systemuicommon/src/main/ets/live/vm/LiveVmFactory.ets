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
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ILiveCapsuleListLayoutVm } from '../interface/ILiveCapsuleLayoutVm';
import { ILiveCapsuleListAnimVm } from '../interface/ILiveCapsuleListAnimVm';
import { ILiveMetaBallVm } from '../interface/ILiveMetaBallVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveCapsuleListMultipleHoleAnimVm } from './LiveCapsuleListMultipleHoleAnimVm';
import { LiveCapsuleListMultipleHoleLayoutVm } from './LiveCapsuleListMultipleHoleLayoutVm';
import { LiveCapsuleListSingleHoleAnimVm } from './LiveCapsuleListSingleHoleAnimVm';
import { LiveCapsuleListSingleHoleLayoutVm } from './LiveCapsuleListSingleHoleLayoutVm';
import { LiveCapsuleListWithoutHoleAnimVm } from './LiveCapsuleListWithoutHoleAnimVm';
import { LiveCapsuleListWithoutHoleLayoutVm } from './LiveCapsuleListWithoutHoleLayoutVm';
import { LiveSingleMetaBallVm } from './LiveSingleMetaBallVm';
import { LiveTwoMetaBallVm } from './LiveTwoMetaBallVm';
import { LiveThreeMetaBallVm } from './LiveThreeMetaBallVm';
import { LiveZeroMetaBallVm } from './LiveZeroMetaBallVm';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { PadLiveCapsuleListWithoutHoleLayoutVm } from './PadLiveCapsuleListWithoutHoleLayoutVm';

// VM 工厂
export class LiveVmFactory {
  createMetaBallVm(vmName: string, vmInjector: LiveVmInjector): ILiveMetaBallVm {
    switch (vmName) {
      case LiveSingleMetaBallVm.name:
        return new LiveSingleMetaBallVm(vmInjector);
      case LiveTwoMetaBallVm.name:
        return new LiveTwoMetaBallVm(vmInjector);
      case LiveThreeMetaBallVm.name:
        return new LiveThreeMetaBallVm(vmInjector);
      default:
        return new LiveZeroMetaBallVm(vmInjector);
    }
  }

  getMetaBallVmNameByCutoutVm(): string {
    if (CutoutVm.instance.isMiddleCutout()) {
      if (CutoutVm.instance.holeNum === 1) {
        return LiveSingleMetaBallVm.name;
      }
      if (CutoutVm.instance.holeNum === 2) {
        return LiveTwoMetaBallVm.name;
      }
      if (CutoutVm.instance.holeNum === 3) {
        return LiveThreeMetaBallVm.name;
      }
    }
    return LiveZeroMetaBallVm.name;
  }

  createCapsuleListLayoutVm(vmName: string, vmInjector: LiveVmInjector): ILiveCapsuleListLayoutVm {
    switch (vmName) {
      case LiveCapsuleListSingleHoleLayoutVm.name:
        return new LiveCapsuleListSingleHoleLayoutVm(vmInjector);
      case LiveCapsuleListMultipleHoleLayoutVm.name:
        return new LiveCapsuleListMultipleHoleLayoutVm(vmInjector);
      case LiveCapsuleListWithoutHoleLayoutVm.name:
        return new LiveCapsuleListWithoutHoleLayoutVm(vmInjector);
      case PadLiveCapsuleListWithoutHoleLayoutVm.name:
        return new PadLiveCapsuleListWithoutHoleLayoutVm(vmInjector);
      default:
        return new LiveCapsuleListWithoutHoleLayoutVm(vmInjector);
    }
  }

  getCapsuleListLayoutVmNameByCutoutVm(): string {
    if (CutoutVm.instance.isMiddleCutout()) {
      if (CutoutVm.instance.holeNum === 1) {
        return LiveCapsuleListSingleHoleLayoutVm.name;
      }
      if (CutoutVm.instance.holeNum > 1) {
        return LiveCapsuleListMultipleHoleLayoutVm.name;
      }
    }
    return DeviceHelper.isPad() ? PadLiveCapsuleListWithoutHoleLayoutVm.name : LiveCapsuleListWithoutHoleLayoutVm.name;
  }

  createCapsuleListAnimVm(vmName: string, vmInjector: LiveVmInjector): ILiveCapsuleListAnimVm {
    switch (vmName) {
      case LiveCapsuleListSingleHoleAnimVm.name:
        return new LiveCapsuleListSingleHoleAnimVm(vmInjector);
      case LiveCapsuleListMultipleHoleAnimVm.name:
        return new LiveCapsuleListMultipleHoleAnimVm(vmInjector);
      case LiveCapsuleListWithoutHoleAnimVm.name:
        return new LiveCapsuleListWithoutHoleAnimVm(vmInjector);
      default:
        return new LiveCapsuleListWithoutHoleAnimVm(vmInjector);
    }
  }

  getCapsuleListAnimVmNameByCutoutVm(): string {
    if (CutoutVm.instance.isMiddleCutout()) {
      if (CutoutVm.instance.holeNum === 1) {
        return LiveCapsuleListSingleHoleAnimVm.name;
      }
      if (CutoutVm.instance.holeNum > 1) {
        return LiveCapsuleListMultipleHoleAnimVm.name;
      }
    }
    return LiveCapsuleListWithoutHoleAnimVm.name;
  }
}