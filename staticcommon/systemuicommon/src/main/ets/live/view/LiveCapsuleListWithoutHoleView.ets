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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveCapsuleListVm } from '../interface/ILiveCapsuleListVm';
import { LiveVmInjectorFactory } from '../LiveVmInjectorFactory';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveCapsuleView } from './LiveCapsuleView';
import { LiveCapsuleMediaPlayerView } from './LiveCapsuleMediaPlayerView';
import { ILiveMetaBallVisibleVm } from '../interface/ILiveMetaBallVisibleVm';
import { ILiveCapsuleListLayoutVm } from '../interface/ILiveCapsuleLayoutVm';
import { ILiveOverlayVm } from '../interface/ILiveOverlayVm';

const TAG = 'LiveCapsuleListWithoutHoleView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveCapsuleListWithoutHoleView {
  @Provider() liveVmInjector: ILiveVmInjector = LiveVmInjectorFactory.get();

  @Computed get capsuleListVm(): ILiveCapsuleListVm {
    return this.liveVmInjector.getCapsuleListVm();
  }

  @Computed get liveMetaBallVisibleVm(): ILiveMetaBallVisibleVm {
    return this.liveVmInjector.getMetaBallVisibleVm();
  }

  @Computed get layoutVm(): ILiveCapsuleListLayoutVm {
    return this.liveVmInjector.getCapsuleListLayoutVm();
  }

  @Computed get overlayVm(): ILiveOverlayVm | undefined {
    return this.liveVmInjector.getOverlayVm?.();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear: LiveCapsuleListWithoutHoleView' + typeof this.capsuleListVm);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear: LiveCapsuleListWithoutHoleView' + typeof this.capsuleListVm);
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

      if (this.overlayVm?.visible) {
        this.overlayVm.builder?.builder(this.liveVmInjector);
      }
    }
    .id(this.liveVmInjector.getId(TAG))
    .width(this.layoutVm.capsuleListWidth)
  }
}