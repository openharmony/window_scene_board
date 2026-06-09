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
import { DeviceInfoVm } from '../../../../vm/DeviceInfoVm';
import { CapsuleShowType } from '../../../model/LiveCommonModel';
import { LiveNotification } from '../../../model/LiveNotification';
import { LiveCapsuleMarqueeVm } from '../../../vm/LiveCapsuleMarqueeVm';
import { ResUtils } from '@ohos/windowscene';
import { EnvVm } from '../../../../vm/EnvVm';
import { PocketManager } from '../manager/PocketManager';

@ObservedV2
export class PocketLiveCapsuleMarqueeVm extends LiveCapsuleMarqueeVm {
  private deviceInfoVm = DeviceInfoVm.instance;
  private envVm = EnvVm.instance;
  @Trace private showAodTipsContent: boolean = false;

  @Computed public get isHideContent(): boolean {
    return PocketManager.isHideContent();
  }

  public updateUIProperty(): Promise<void> {
    return super.updateUIProperty();
  }

  public getText(liveNotification?: LiveNotification, capsuleShowType?: CapsuleShowType): string {
    const live: LiveNotification = liveNotification ?? this.live;
    if (live.capsule?.isTimer() && this.envVm.isScreenOff && this.showAodTipsContent) {
      const isCountDown = live.capsule?.timer?.isCountdown;
      return ResUtils.getInnerString(isCountDown ?
        $r('app.string.aod_count_down_capsule_timer_text') :
        $r('app.string.aod_timing_capsule_timer_text'));
    }
    return super.getText(liveNotification, capsuleShowType);
  }

  public isEnabled(isExtend: boolean): boolean {
    if (this.envVm.isScreenOff) {
      return false;
    }
    return super.isEnabled(isExtend);
  }
}