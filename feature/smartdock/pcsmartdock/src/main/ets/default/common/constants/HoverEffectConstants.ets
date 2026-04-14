/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

export default class HoverEffectConstants {
  public static readonly BACKGROUND_ROTATE_ANGLE_X = -5;
  public static readonly BACKGROUND_ROTATE_ANGLE_Y = 5;
  public static readonly FOREGROUND_ROTATE_ANGLE_MULTIPLE = 3;
  public static readonly CAMERA_DISTANCE = -1.5;
  public static readonly BASE_SCALE = 1.2;
  public static readonly ADAPTIVE_SCALE = 1.5;
  public static readonly SHADOW_SCALE = 1.03;
  public static readonly FOREGROUND_SCALE = 1.01;
  public static readonly SHADOW_OPACITY = 0.35; // UX检视，0.2不太明显，建议改成0.35
  public static readonly FOREGROUND_BASE_TRANSLATE = 8;
  public static readonly SHADOW_BASE_TRANSLATE = 7;
  public static readonly LAUNCHER_APPCENTER_FOREGROUND_NAME: string = 'adaptive_appcenter_foreground';
  public static readonly LAUNCHER_MULTITASK_FOREGROUND_NAME: string = 'adaptive_multitask_foreground';
  public static readonly LAUNCHER_RECYCLE_FOREGROUND_NAME: string = 'adaptive_recycle_bin_foreground';

  // 通栏hover动效参数
  public static readonly FIXED_SHADOW_SCALE: number = 1.02;
  public static readonly FIXED_FOREGROUND_BASE_TRANSLATE: number = 4;
  public static readonly FIXED_SHADOW_BASE_TRANSLATE: number = 4;
  public static readonly MAX_SCALE: number = 1.2; // 1.15放大倍数不明显，修改成鼠标为放大中心后，鼠标放大倍数修改成0.35
  public static readonly MAX_SCALE_REGION: number = 1.5; // 最大的Item作用区间，超过1.5倍间距后scale还原为1
  public static readonly FIXED_HOVER_MASTER_SCALE: number = 1.15;
  public static readonly FIXED_HOVER_BASE_SCALE: number = 1.10;
  public static readonly FIXED_HOVER_GAP_SCALE: number = 0.05;
  public static readonly FIXED_HOVER_COMPANION_SCALE: number = 1.05;
  public static readonly FIXED_HOVER_RESET: number = 1;
  public static readonly FIXED_HOVER_EFFECT_CURVES: ICurve = curves.interpolatingSpring(0, 1, 820, 49);

  // dock 阴影参数
  public static readonly MAX_SHADOW_OFFSET: number = 6;
  public static readonly SHADOW_OFFSET: number = 4.5;
  public static readonly HALF_SHADOW_OFFSET: number = 3;
  public static readonly ITEM_SHADOW_RADIUS = 5;
  public static readonly ITEM_SHADOW_COLOR = '#26000000';
}