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

import { LogDomain, LogHelper } from '@ohos/basicutils'
import { RTLUtil } from '@ohos/componenthelper'
import { curves } from '@kit.ArkUI'

const TAG = 'AppIconAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 组通知折叠展开动效管理
 */
export class NotificationGroupExpandAnimation {
  /**
   * 动画时长
   */
  public static readonly duration: number = 333;

  /**
   * 会话类通知，通知头像动效
   * 透明度、位移（20vp）、缩放（0.8），第一条通知时延：0ms，动画时长75ms；其他通知时延依次延迟32ms，动画时长50ms
   *
   * @param index 通知索引值
   * @param lastIndex 最后一条通知的索引值
   * @returns
   */
  public static getOverlayIconAnimation(index: number, lastIndex: number): TransitionEffect {
    const appearDelayTime = index * 32;
    const appearDurationTime = index == 0 ? 75 : 50;
    const disappearDelayTime = (lastIndex - index) * 32;
    const disappearDurationTime = index == lastIndex ? 75 : 50;
    return TransitionEffect.asymmetric(
      TransitionEffect.translate({ y: -20 }).animation({ delay: appearDelayTime, duration: appearDurationTime })
        .combine(TransitionEffect.OPACITY.animation({ delay: appearDelayTime, duration: appearDurationTime }))
        .combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })
          .animation({ delay: appearDelayTime, duration: appearDurationTime })),
      TransitionEffect.translate({ y: -20 }).animation({ delay: disappearDelayTime, duration: disappearDurationTime })
        .combine(TransitionEffect.OPACITY.animation({ delay: disappearDelayTime, duration: disappearDurationTime }))
        .combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })
          .animation({ delay: disappearDelayTime, duration: disappearDurationTime }))
    )
  }
  
  static getIconTransEffect(isHeaderIcon: boolean, transY: number): TransitionEffect {
    return TransitionEffect.scale({
      x: isHeaderIcon ? 2 : 0.5,
      y: isHeaderIcon ? 2 : 0.5,
      centerX: RTLUtil.isRTL() ? '100%' : 0,
      centerY: 0
    })
      .animation({
        duration: 200,
        curve: curves.cubicBezierCurve(0.33, 0.00, 0.83, 1.0)
      })
      .combine(TransitionEffect.translate({ y: isHeaderIcon ? -transY : transY})
        .animation({
          duration: 250,
          curve: curves.cubicBezierCurve(0.27, 0.00, 0.43, 1.0)
        }))
  }
}