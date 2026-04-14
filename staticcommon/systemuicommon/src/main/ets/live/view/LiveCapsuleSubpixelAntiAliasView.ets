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

import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { LiveStyle } from '../constants/LiveStyle';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { ResourceVm } from '../../vm/ResourceVm';
import { ILiveCapsuleListVm } from '../interface/ILiveCapsuleListVm';

@ComponentV2
export struct LiveCapsuleSubpixelAntiAliasView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;
  @Param @Require borderHeight: number;

  @Computed
  get capsuleListVm(): ILiveCapsuleListVm {
    return this.liveVmInjector.getCapsuleListVm();
  }

  @Computed
  get capsuleVm(): ILiveCapsuleVm {
    return this.liveVmInjector.getCapsuleVm(this.live);
  }

  build() {
    // 次像素抗锯齿图层
    Stack() {
      // 挂孔
      Row()
      // 动画时不显示次像素抗锯齿图层
        .opacity(this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE &&
          this.capsuleListVm.capsuleAnimationCount == 0 ? 1 : 0)
        .width(this.capsuleVm.width)
        .height(LiveStyle.CAPSULE_HEIGHT)
        // DARKEN: rc = s + d - max(s * da, d * sa), ra = s + (1 - sa) * d
        // cause the outline s is FF, redirect color to whatever will be ok on dark background.
        // as for the light background, use 1/2 to √2/2, as 127 to 180
        // however, as device varies, add a gain of 0.8, making 101 to 144
        .linearGradient({
          direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
          repeating: false,
          colors: [
            ['rgba(0, 0, 0, 0)', 0],
            // left side of the hole
            ['rgba(0, 0, 0, 0)',
              (this.capsuleVm.linearGradientSingleEndWidth - LiveStyle.CAPSULE_HEIGHT -
                (px2vp(2) + this.borderHeight) / 2) / this.capsuleVm.linearGradientSingleEndWidth],
            // middle of the hole
            ['rgba(0, 144, 0, 0)',
              (this.capsuleVm.linearGradientSingleEndWidth - LiveStyle.CAPSULE_HEIGHT / 2 -
                (px2vp(2) + this.borderHeight) / 2) / this.capsuleVm.linearGradientSingleEndWidth],
            // 3/4 of the hole
            ['rgba(0, 101, 0, 1)',
              (this.capsuleVm.linearGradientSingleEndWidth -
                (LiveStyle.CAPSULE_HEIGHT / 4)) / this.capsuleVm.linearGradientSingleEndWidth],
            // right of the hole
            ['rgba(0, 144, 0, 1)', 1],
          ]
        })
        .borderRadius(LiveStyle.CAPSULE_RADIUS)
    }
    .width(this.capsuleVm.width + this.borderHeight)
    .height(LiveStyle.CAPSULE_HEIGHT + this.borderHeight)
    .pixelRound({ top: PixelRoundCalcPolicy.NO_FORCE_ROUND, bottom: PixelRoundCalcPolicy.NO_FORCE_ROUND })
  }
}