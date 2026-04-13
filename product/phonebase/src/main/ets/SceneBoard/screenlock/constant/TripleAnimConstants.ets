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

export class TripleAnimConstants {
  // 常量0
  public static readonly CONSTANT_ZERO = 0;
  // 常量1
  public static readonly CONSTANT_ONE = 1;
  // 常量2
  public static readonly CONSTANT_TWO = 2;
  // 常量3
  public static readonly CONSTANT_THREE = 3;
  // 常量4
  public static readonly CONSTANT_FOUR = 4;
  // 常量6
  public static readonly CONSTANT_SIX = 6;
  // 常量8
  public static readonly CONSTANT_EIGHT = 8;
  // 锁头组件
  public static readonly LOCK_ICON = 'LockIcon';
  // 时钟组件
  public static readonly CLOCK = 'Clock';
  // 沉浸胶囊组件
  public static readonly IMMERSIVE_CAP = 'ImmersiveCap';
  // 沉浸列表组件
  public static readonly IMMERSIVE_LIST = 'ImmersiveList';
  // 沉浸卡片组件
  public static readonly IMMERSIVE_CARD = 'ImmersiveCard';
  // 快捷工具组件
  public static readonly QUICK_TOOLS = 'QuickTools';
  // 底部相机图标组件
  public static readonly BOTTOM_CAMERA = 'BottomCamera';
  // 密码面板组件
  public static readonly FOLDABLE_PSD = 'FoldablePSD';
  // 默认界面位移曲线
  public static readonly TRANSLATE_CURVES_DEFAULT = curves.springMotion(0.5, 0.95, 0);
  // 界面位移曲线
  public static readonly TRANSLATE_CURVES = curves.springMotion(0.6, 0.95, 0);
}