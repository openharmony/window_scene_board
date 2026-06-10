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
import { curves } from '@kit.ArkUI';

export class AnimationCurves {
  /**
   * 滑动松手时的动画曲线
   */
  public static readonly SWIPE_RELEASE_CURVE = curves.springCurve(0, 1, 228, 23);

  /**
   * 横幅滑动松手
   */
  public static readonly BANNER_SWIPE_CURVE = curves.springCurve(0, 1, 80, 14);
}