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
import Curves from '@ohos.curves';
import { RTLUtil } from '@ohos/componenthelper';
import PowerOffStyleConstants from './PoweroffStyleConstants';

export class AnimationManager {
  public static readonly TEXT_EFFECT_ANIMATION: TransitionEffect =
    TransitionEffect.OPACITY.animation({ curve: Curve.Friction, duration: 150 });

  public static readonly TEXT_FINAL_EFFECT_ANIMATION: TransitionEffect =
    TransitionEffect.OPACITY.animation({ curve: Curve.Friction, duration: 250, delay: 150 });

  public static readonly INITIAL_REBOOT_TRANSITION: TransitionEffect = TransitionEffect.asymmetric(
    TransitionEffect.IDENTITY,
    TransitionEffect.OPACITY
      .animation({ curve: Curves.interpolatingSpring(0, 1, 328, 36), duration: 350 })
      .combine(TransitionEffect.translate({ x: RTLUtil.isRTL() ? 64 : -64 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 328, 36), duration: 350 })
      )
  );

  public static readonly INITIAL_POWER_OFF_TRANSITION: TransitionEffect = TransitionEffect.asymmetric(
    TransitionEffect.IDENTITY,
    TransitionEffect.OPACITY.animation({ curve: Curve.Friction, duration: 350 })
      .combine(TransitionEffect.translate({ x: RTLUtil.isRTL() ? -64 : 64 })
        .animation({ curve: Curves.interpolatingSpring(0, 1, 328, 36) }))
  );

  public static readonly TEXT_TIPS_TRANSITION: TransitionEffect = TransitionEffect.OPACITY
    .animation({ curve: Curves.interpolatingSpring(0, 1, 328, 36), duration: 350 });

  public static readonly INITIAL_SCALE_ANIMATION: ScaleOptions = {
    x: 1,
    y: 1,
    centerX: '50%',
    centerY: '50%'
  };

  public static readonly SCALE_ANIMATION: ScaleOptions = {
    x: PowerOffStyleConstants.POWEROFF_ANIMATION_SCALE,
    y: PowerOffStyleConstants.POWEROFF_ANIMATION_SCALE,
    centerX: '50%',
    centerY: '50%'
  };

  public static readonly REBOOT_TRANSITION: TransitionEffect = TransitionEffect.OPACITY
    .animation({ curve: Curves.interpolatingSpring(0, 1, 328, 36), duration: 350 })
    .combine(TransitionEffect.translate({ x: RTLUtil.isRTL() ? 64 : -64 })
      .animation({ curve: Curves.interpolatingSpring(0, 1, 328, 36), duration: 350 }));

  public static readonly POWER_OFF_TRANSITION: TransitionEffect = TransitionEffect.OPACITY
    .animation({ curve: Curve.Friction, duration: 350 })
    .combine(TransitionEffect.translate({ x: RTLUtil.isRTL() ? -64 : 64 })
      .animation({ curve: Curves.interpolatingSpring(0, 1, 328, 36) }));

  public static readonly INITIAL_TEXT_MARGIN: Length = 8;

  public static readonly TEXT_MARGIN: Length = 14;

  public static readonly CLICK_ANIMATION: AnimateParam = {
    curve: Curves.interpolatingSpring(0, 1, 328, 36),
    duration: 350
  };
}