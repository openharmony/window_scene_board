/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { uiEffect } from '@kit.ArkGraphics2D';

const TAG: string = 'SCBIMFInputMethodUtil';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const PANEL_DARK_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 0.2668, degree: 0.1674, saturation: 1.8,
  positiveCoefficient: [1.8, 2.3, 1.2], negativeCoefficient: [1, 2, 1], fraction: 0
});
const PANEL_LIGHT_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 0.0253, degree: 0.8814, saturation: 2,
  positiveCoefficient: [7, 15, 13], negativeCoefficient: [11, 15, 2], fraction: 0
});

const NONE_BLENDER: uiEffect.BrightnessBlender = uiEffect.createBrightnessBlender({
  cubicRate: 0, quadraticRate: 0, linearRate: 1, degree: 0, saturation: 1,
  positiveCoefficient: [0, 0, 0], negativeCoefficient: [0, 0, 0], fraction: 1
});

class SCBInputMethodUtil {

  constructor() {
  }

  public isEnableImmersive(keyboardViewMode: sceneSessionManager.KeyboardViewMode): boolean {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE ||
      keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      log.showInfo(`enable immersive model, keyboardViewMode is: ${keyboardViewMode}`);
      return true;
    }
    return false;
  }

  public getPanelImmersiveMode(keyboardViewMode: sceneSessionManager.KeyboardViewMode):
    uiEffect.BrightnessBlender {
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.LIGHT_IMMERSIVE_MODE) {
      return PANEL_LIGHT_BLENDER;
    }
    if (keyboardViewMode === sceneSessionManager.KeyboardViewMode.DARK_IMMERSIVE_MODE) {
      return PANEL_DARK_BLENDER;
    }
    return NONE_BLENDER;
  }
}

const inputMethodUtil = new SCBInputMethodUtil();

export default inputMethodUtil;