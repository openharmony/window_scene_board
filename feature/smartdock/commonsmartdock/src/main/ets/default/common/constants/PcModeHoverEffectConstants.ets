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
import curves from '@ohos.curves';

export default class PcModeHoverEffectConstants {
  public static readonly BACKGROUND_ROTATE_ANGLE_X = -5;
  public static readonly BACKGROUND_ROTATE_ANGLE_Y = 5;
  public static readonly FOREGROUND_ROTATE_ANGLE_MULTIPLE = 3;
  public static readonly CAMERA_DISTANCE = -1.5;
  public static readonly BASE_SCALE = 1.2;
  public static readonly ADAPTIVE_SCALE = 1.5;
  public static readonly SHADOW_SCALE = 1.03;
  public static readonly FOREGROUND_SCALE = 1.01;
  public static readonly SHADOW_OPACITY = 0.2;
  public static readonly FOREGROUND_BASE_TRANSLATE = 8;
  public static readonly SHADOW_BASE_TRANSLATE = 7;
  public static readonly LAUNCHER_APPCENTER_FOREGROUND_NAME: string = 'adaptive_appcenter_foreground';
  public static readonly LAUNCHER_MULTITASK_FOREGROUND_NAME: string = 'adaptive_multitask_foreground';
  public static readonly LAUNCHER_RECYCLE_FOREGROUND_NAME: string = 'adaptive_recycle_bin_foreground';

  // 通栏hover动效参数
  public static readonly FIXED_SHADOW_SCALE: number = 1.02;
  public static readonly FIXED_FOREGROUND_BASE_TRANSLATE: number = 4;
  public static readonly FIXED_SHADOW_BASE_TRANSLATE: number = 4;
  public static readonly FIXED_HOVER_MASTER_SCALE: number = 1.15;
  public static readonly FIXED_HOVER_COMPANION_SCALE: number = 1.05;
  public static readonly FIXED_HOVER_RESET: number = 1;
  public static readonly FIXED_HOVER_EFFECT_CURVES: ICurve = curves.springCurve(0, 1, 322, 30);
}