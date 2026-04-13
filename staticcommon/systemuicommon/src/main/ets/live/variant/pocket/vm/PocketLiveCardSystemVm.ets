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
import { ILiveCardSystemVm } from '../../../interface/ILiveCardSystemVm';
import { LiveCardSystemVm } from '../../../vm/LiveCardSystemVm';
import { PocketManager } from '../manager/PocketManager';

@ObservedV2
export class PocketLiveCardSystemVm extends LiveCardSystemVm implements ILiveCardSystemVm {
  protected readonly TAG: string = 'PocketLiveCardSystemVm';

  public isHideContent(): boolean {
    return PocketManager.isHideContent();
  }

  @Computed get onIconClick(): (() => void) | undefined {
    if (PocketManager.canEnterImmersive(this.live)) {
      return () => {
        PocketManager.onIconClick(this.live, this.vmInjector);
      }
    } else {
      return undefined;
    }
  }
}