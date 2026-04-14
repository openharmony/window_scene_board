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

import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm'
import { ILiveCapsuleLightWaveVm } from '../interface/ILiveCapsuleLightWaveVm';
import { LiveStyle } from '../constants/LiveStyle';

const BORDER_WIDTH = 1.2;
@ComponentV2
export struct LiveCapsuleLightWaveView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;
  @Param isToRight?: boolean = false;

  @Computed get capsuleWave(): ILiveCapsuleLightWaveVm {
    return this.isToRight ? this.liveVmInjector.getCapsuleRightLightWaveVm(this.live) :
    this.liveVmInjector.getCapsuleLightWaveVm(this.live);
  }

  @Computed
  get capsuleVm(): ILiveCapsuleVm {
    return this.liveVmInjector.getCapsuleVm(this.live);
  }

  build() {
    // 流光边框
      Row() {
        Row() {
        }
        .width(this.capsuleVm.fixedWidth)
        .height(this.capsuleVm.height)
        .borderRadius(LiveStyle.CAPSULE_RADIUS)
        .backgroundColor('rgba(255,255,255,0)')
        .blendMode(6)
      }
      .id(this.capsuleVm.componentId + `${this.isToRight ? '-right_lightWave' : '-left_lightWave'}`)
      .width(this.capsuleVm.fixedWidth + 2 * BORDER_WIDTH)
      .height(this.capsuleVm.height + 2 * BORDER_WIDTH)
      .borderRadius(LiveStyle.CAPSULE_RADIUS + 2 * BORDER_WIDTH)
      .backgroundImage($r('app.media.flow_light_bg'))
      .backgroundImageSize({ height: this.capsuleVm.height + 2 * BORDER_WIDTH })
      .backgroundImagePosition({
        x: `${this.capsuleWave.positionX}vp`,
        y: '0vp'
      })
      .blendMode(1000)
      .justifyContent(FlexAlign.Center)
      .visibility(this.capsuleWave.lightShow ? Visibility.Visible : Visibility.None)
  }
}
