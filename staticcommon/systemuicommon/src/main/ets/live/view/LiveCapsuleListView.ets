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
import { ILiveCapsuleListVm } from '../interface/ILiveCapsuleListVm';
import { LiveVmInjectorFactory } from '../LiveVmInjectorFactory';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveCapsuleView } from './LiveCapsuleView';
import { LiveMetaBallView } from './LiveMetaBallView';
import { LiveCapsuleMediaPlayerView } from './LiveCapsuleMediaPlayerView';
import { ILiveMetaBallVisibleVm } from '../interface/ILiveMetaBallVisibleVm';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ILiveOverlayVm } from '../interface/ILiveOverlayVm';

const TAG = 'LiveCapsuleListView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveCapsuleListView {
  @Provider() liveVmInjector: ILiveVmInjector = LiveVmInjectorFactory.get();

  @Computed get capsuleListVm(): ILiveCapsuleListVm {
    return this.liveVmInjector.getCapsuleListVm();
  }

  @Computed get liveMetaBallVisibleVm(): ILiveMetaBallVisibleVm {
    return this.liveVmInjector.getMetaBallVisibleVm();
  }

  @Computed get overlayVm(): ILiveOverlayVm | undefined {
    return this.liveVmInjector.getOverlayVm?.();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear:' + typeof this.capsuleListVm);
  }

  build(): void {
    Stack({ alignContent: Alignment.Start }) {
      Repeat(this.capsuleListVm.liveList).each((data) => {
        if (data.item.isMediaPlayer()) {
          LiveCapsuleMediaPlayerView({ live: data.item })
        } else {
          LiveCapsuleView({ live: data.item })
        }
      }).key((live) => `${live.key}-${live.updateToDeleteCount}`)

      if (CutoutVm.instance.isMiddleCutout()) {
        LiveMetaBallView()
      }
      if (this.overlayVm?.visible) {
        this.overlayVm.builder?.builder(this.liveVmInjector);
      }
    }
    .id(this.liveVmInjector.getId(TAG))
    .width('100%')
    .height('100%')
    .accessibilityLevel(this.capsuleListVm.isShowCapsule ? 'yes' : 'no-hide-descendants')
  }
}