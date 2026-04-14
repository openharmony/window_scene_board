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

import { GlassLayoutSize } from '../../common/constants/GlassLayoutConstants';
import { curves } from '@kit.ArkUI';

export class GlassStatusBarStyle extends GlassLayoutSize {
  // GlassButton相关参数
  public static readonly GLASS_BUTTON_BLUR: number = 217.6;
  public static readonly GLASS_BUTTON_BORDER: BorderOptions = {
    radius: 32,
  };
  public static readonly GLASS_BUTTON_CONSTRAINT_SIZE: ConstraintSizeOptions = {
    minWidth: '60px',
    minHeight: '60px',
  };
  // CapsuleButton
  public static readonly CALL_CAPSULE_BACKGROUND_COLOR: string = '#64BB5C'
  public static readonly CAPSULE_BUTTON_BORDER_RADIUS: number = 50;
  public static readonly CAPSULE_BUTTON_COMPONENT_INTERVAL: string = '8px';
  // 其他
  public static readonly MARGIN_LEFT_RIGHT: string = '24px';
  public static readonly STATUSBAR_COMPONENT_INTERVAL: string = '24px';
  // redhot size
  public static readonly RED_HOT_SIZE: string = '6px';
  public static readonly RED_HOT_POSITION_X: Dimension = '26px';
  public static readonly RED_HOT_POSITION_Y: Dimension = '8px';
  public static readonly ICON_SIZE: string = '36px';
}

export function getStatusBarTransition(): TransitionEffect {
  return TransitionEffect.asymmetric(
    TransitionEffect.translate({
      y: -150
    })
      .animation({
        duration: 330,
        curve: curves.cubicBezierCurve(0.42, 0.00, 0.66, 1.00)
      })
      .combine(TransitionEffect.OPACITY.animation({
        duration: 330,
        curve: curves.cubicBezierCurve(0.00, 0.00, 1.00, 1.00)
      })),
    TransitionEffect.translate({
      y: -150
    })
      .animation({
        duration: 330,
        curve: curves.cubicBezierCurve(0.42, 0.00, 0.66, 1.00)
      })
      .combine(TransitionEffect.OPACITY.animation({
        duration: 330,
        curve: curves.cubicBezierCurve(0.00, 0.00, 1.00, 1.00)
      }))
  )
}