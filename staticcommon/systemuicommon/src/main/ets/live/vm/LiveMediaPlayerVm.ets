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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';
import { ILiveMediaPlayerVm } from '../interface/ILiveMediaPlayerVm';
import { LiveNotification } from '../model/LiveNotification';
import { LiveMediaPlayerAnimation } from '../animation/LiveMediaPlayerAnimation';
import { LiveCapsuleVm } from './LiveCapsuleVm';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveCapsuleIconAnimationType } from '../model/LiveCommonModel';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

const TAG = 'LiveMediaPlayerVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveMediaPlayerVm extends LiveCapsuleVm implements ILiveMediaPlayerVm {
  @Trace public maskOpacity: number = 0;
  @Trace public oldMediaIcon?: image.PixelMap;
  @Trace public oldMediaIconOpacity: number = 0;
  @Trace public oldMediaIconOffsetX: number = 0;
  @Trace public oldMediaIconOffsetY: number = 0;
  @Trace public oldMediaIconScale: ScaleOptions = { x: 1, y: 1 };
  @Trace public mediaIconOffsetX: number = 0;
  @Trace public mediaIconOffsetY: number = 0;
  @Trace public mediaIconScale: ScaleOptions = { x: 1, y: 1 };
  public mediaCircleShape: CircleShape = new Circle({ width: LiveStyle.CAPSULE_ICON_WIDTH,
    height: LiveStyle.CAPSULE_ICON_WIDTH });

  public addMedia(live: LiveNotification): void {
    this.oldMediaIcon = live.capsule?.icon;
  }

  public async updateMedia(live: LiveNotification): Promise<void> {
    if (this.live.creatorUid !== live.creatorUid) {
      this.vmInjector.getCapsuleListVm().toggleCapsuleList();
      this.oldMediaIcon = live.capsule?.icon;
      await SystemUICommonUtil.sleep(LiveStyle.METABALL_HIGHEST_DURATION);
      return;
    }

    if (live.capsule?.iconAnimationType === LiveCapsuleIconAnimationType.Animate) {
      await new LiveMediaPlayerAnimation(this.vmInjector).updateIconAnimation(live);
    }
    this.oldMediaIcon = live.capsule?.icon;
  }
}