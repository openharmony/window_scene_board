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
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { LiveMetaBallBaseVm } from './LiveMetaBallBaseVm';
// import { BallParams } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { Hole } from '../../statusbar/vm/CutoutVm';

const TAG = 'LiveZeroMetaBallVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveZeroMetaBallVm extends LiveMetaBallBaseVm {
  public animStatusBarHeight: number = this.STATUS_BAR_HEIGHT;
  public maxOffsetY: number = 0;

  public getWidth(capsulePosition: StatusBarCapsulePosition): number {
    log.showWarn(`use LiveZeroMetaBallVm to get width, it may cause unexpected errors`);
    return 0;
  }

  public getHeight(capsulePosition: StatusBarCapsulePosition): number {
    log.showWarn(`use LiveZeroMetaBallVm to get width, it may cause unexpected errors`);
    return 0;
  }

  public getPosition(capsulePosition: StatusBarCapsulePosition): LocalizedEdges | Edges {
    log.showWarn(`use LiveZeroMetaBallVm to get position, it may cause unexpected errors`);
    return {
      left: 0,
      top: 0
    };
  }

  // public getBallParam(capsulePosition: StatusBarCapsulePosition): BallParams[] {
  //   log.showWarn(`use LiveZeroMetaBallVm to get ball option, it may cause unexpected errors`);
  //   return [{ centerX: 0, centerY:0, radius: 0, isIsolated: true }]
  // }

  public getMiddleHole(): Hole {
    return { centerX: 0, centerY:0, radius: 0 };
  }

  toggleToDeskTop(isUpwards?: boolean | undefined): Promise<void> {
    throw new Error('Method not implemented.');
  }

  toggleToHeadUp(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  toggleToLiveList(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  toggleToPanel(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  toggleToRemind(): Promise<void> {
    throw new Error('Method not implemented.');
  }

  toggleToImmersive(): Promise<void> {
    throw new Error('Method not implemented.');
  }
}