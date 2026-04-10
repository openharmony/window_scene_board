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

import { uiEffect } from '@kit.ArkGraphics2D';

const TAG = 'CalendarPanel-BlendModeUtil';

/**
 * BlendModeUtil class
 */
export default class BlendModeUtil {
  /**
   * 列表辅助文字浅色模式参数
   */
  public static blenderTertiary: uiEffect.BrightnessBlender = uiEffect?.createBrightnessBlender({
    cubicRate: 0,
    quadraticRate: 0,
    linearRate: 0.6539,
    degree: -0.1441,
    saturation: 1.5,
    positiveCoefficient: [1.3, 3.2, 1],
    negativeCoefficient: [0.25, 0.5, 0.67],
    fraction: 0
  });

  /**
   * 列表辅助文字深色模式参数
   */
  public static blenderTertiaryDark: uiEffect.BrightnessBlender = uiEffect?.createBrightnessBlender({
    cubicRate: 0,
    quadraticRate: 0,
    linearRate: 0.9894,
    degree: 0.4005,
    saturation: 1.3,
    positiveCoefficient: [-0.1, 0.2, 0.2],
    negativeCoefficient: [1.2, 0.2, 2],
    fraction: 0
  });

  /**
   * 获取列表辅助文字参数
   */
  public static getBlenderTertiary(): uiEffect.BrightnessBlender {
    let darkMode: number = AppStorage.get('currColorMode') ?? 0;
    if (darkMode === 0) {
      return BlendModeUtil.blenderTertiaryDark;
    }
    return BlendModeUtil.blenderTertiary;
  }
}