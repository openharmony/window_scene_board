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

import { ILiveHeadsUpCommonCardVm } from '../../../interface/ILiveHeadsUpCommonCardVm';
import { LiveHeadsUpCommonCardVm } from '../../../vm/LiveHeadsUpCommonCardVm';
import { LiveNotification } from '../../../model/LiveNotification';
import { DeviceInfoVm } from '../../../../vm/DeviceInfoVm';
import { EnvVm } from '../../../../vm/EnvVm';

@ObservedV2
export class PocketLiveHeadsUpCommonCardVm extends LiveHeadsUpCommonCardVm implements ILiveHeadsUpCommonCardVm {
  protected readonly TAG: string = 'PocketLiveHeadsUpCommonCardVm';
  protected readonly CARD_SCALE_RATE: number = 0.9;
  public envVm = EnvVm.instance;
  public deviceInfoVm = DeviceInfoVm.instance;

  @Computed
  public get cardWidth(): Length {
    return '100%';
  }

  @Computed
  public get cardScale(): ScaleOptions | undefined {
    return undefined;
  }

  public isNeedShow(live: LiveNotification): boolean {
    // 灭屏状态不显示横幅
    if (this.envVm.isScreenOff) {
      return false;
    }
    return super.isNeedShow(live);
  }
}