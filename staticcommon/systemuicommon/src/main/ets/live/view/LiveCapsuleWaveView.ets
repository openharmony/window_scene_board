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

import { LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCapsuleWaveVm } from '../interface/ILiveCapsuleWaveVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveCapsuleWaveView');

@ComponentV2
export struct LiveCapsuleWaveView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed
  get capsuleWave(): ILiveCapsuleWaveVm {
    const capsuleWave = this.liveVmInjector.getCapsuleWaveVm(this.live);
    capsuleWave.refreshProgressWaveMarginLeft();
    return capsuleWave;
  }

  aboutToDisappear(): void {
    log.showInfo(`about to disappear: ${this.live.hashCode}`);
    this.capsuleWave.destroy();
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Image(this.capsuleWave.waveImageResource)
        .height('100%')
        .width(LiveStyle.WAVE_WIDTH)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .matchTextDirection(true)
        .margin({
          start: LengthMetrics.vp(this.capsuleWave.processWaveMarginLeft)
        })

      Image(this.capsuleWave.waveImageResource)
        .height('100%')
        .width(LiveStyle.WAVE_WIDTH)
        .objectFit(ImageFit.Contain)
        .opacity(this.capsuleWave.moveWaveOpacity)
        .draggable(false)
        .matchTextDirection(true)
        .margin({
          start: LengthMetrics.vp(this.capsuleWave.moveWaveMarginLeft)
        })
    }
    .draggable(false)
    .width('100%')
    .height(LiveStyle.CAPSULE_HEIGHT)
    .position({
      top: LengthMetrics.vp(-LiveStyle.CAPSULE_ICON_PADDING),
      start: LengthMetrics.vp(-LiveStyle.CAPSULE_ICON_PADDING),
    })
    .zIndex(1)
    .visibility(this.capsuleWave.isVisible ? Visibility.Visible : Visibility.None)
  }
}
