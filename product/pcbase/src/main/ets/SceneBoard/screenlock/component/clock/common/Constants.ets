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

import { ClockAniParam } from './ClockAniParam';

/**
 * 时钟组件ID
 */
export enum ClockWidgetId {
  ROOT = '__container__', // 根布局，相对布局固定ID
  CLOCK = 'clock_widget', // 根布局别名，真实ID
  TIME = 'time_view',
  DATE = 'date_view',
  SIGN = 'sign_view',
}

export class ClockAniParamConst {
  public static readonly HORIZONTAL: ClockAniParam = {
    timeFontSize: 168,
    dateFontSize: 28,
    timeAndDateSpace: 27,
  };
  public static readonly VERTICAL: ClockAniParam = {
    timeFontSize: 136,
    dateFontSize: 24,
    timeAndDateSpace: 27,
  };
  public static readonly NO_ROTATION: ClockAniParam = {
    timeFontSize: 150,
    dateFontSize: 24,
    timeAndDateSpace: 12,
  };
}

export interface ClockStyleParam {
  timeShadow?: ShadowOptions,
  dateShadow?: ShadowOptions,
  fontColor: Resource;
  opacityLevel: number,
}

export interface ClockTimeTextParam {
  fontSize: number;
  fontColor: ResourceColor;
  fontFamily: string;
  fontWeight: FontWeight;
}

export interface ClockDateTextParam {
  textContent?: string | ResourceStr,
  fontColor: ResourceColor,
  shadowOptions?: ShadowOptions,
}

export class ClockStyleConst {
  /**
   * Clock Widge - blur, Brightness, opacity
   */
  public static readonly CLOCK_WIDGE_OPAQUE: ClockStyleParam = {
    fontColor: $r('app.color.screen_lock_clock_widge_fontcolor'),
    opacityLevel: 1
  };

  public static readonly CLOCK_WIDGE_WITH_SHADOW_OPACITY: ClockStyleParam = {
    fontColor: $r('app.color.screen_lock_clock_widge_fontcolor'),
    timeShadow: {
      radius: 30,
      color: $r('app.color.screen_lock_clock_widge_time_shadowcolor'),
      offsetX: 0,
      offsetY: 2
    },
    dateShadow: {
      color: $r('app.color.screen_lock_clock_widge_date_shadowcolor'),
      radius: 0,
      offsetX: 0,
      offsetY: 2
    },
    opacityLevel: 0.3
  }

  public static clockWidgeBrightness: BackgroundEffectOptions = {
    radius: 60,
    brightness: 1.6,
    saturation: 1.2
  }

  public static clockWidgeBrightnessBright: BackgroundEffectOptions = {
    radius: 40,
    brightness: 1.4,
    saturation: 1.7
  }
}