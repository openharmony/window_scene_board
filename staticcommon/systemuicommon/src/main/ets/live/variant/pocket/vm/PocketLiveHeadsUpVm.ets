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

import { ILiveHeadsUpVm } from '../../../interface/ILiveHeadsUpVm';
import { DeviceInfoVm } from '../../../../vm/DeviceInfoVm';
import { LiveHeadsUpVm } from '../../../vm/LiveHeadsUpVm';
import { LiveNotification } from '../../../model/LiveNotification';

@ObservedV2
export class PocketLiveHeadsUpVm extends LiveHeadsUpVm implements ILiveHeadsUpVm {
  protected readonly TAG: string = 'PocketLiveHeadsUpVm';
  public deviceInfoVm = DeviceInfoVm.instance;

  /**
   *
   */
  protected handleBannerZIndex(): void {
    super.handleBannerZIndex();
  }

  /**
   *
   */
  protected async tryOpenFloating(live: LiveNotification): Promise<boolean> {
    return super.tryOpenFloating(live);
  }
}