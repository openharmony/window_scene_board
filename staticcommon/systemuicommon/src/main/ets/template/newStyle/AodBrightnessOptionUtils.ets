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

// AOD下的提亮参数
export class AodBrightnessOptionUtils {
  // 锁屏沉浸通知背板
  public static aodImmersiveCardLightOption: BrightnessOptions = {
    rate: 1,
    lightUpDegree: 0,
    cubicCoeff: 0,
    quadCoeff: 0,
    fraction: 1,
    saturation: 1,
    posRGB: [0, 0, 0],
    negRGB: [0, 0, 0]
  }
}