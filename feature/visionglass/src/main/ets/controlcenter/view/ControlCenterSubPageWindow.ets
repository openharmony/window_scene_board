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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ControlCenterConstants } from '../components/constants/ControlCenterConstants';
import VisionAdjustmentStepsComponent from '../components/mediacontrols/VisionAdjustmentStepsComponent';
import { ControlCenterWindowName } from '../manager/ControlCenterWindowManager';

const TAG = 'ControlCenterSubPageWindow';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct ControlCenterSubPageWindow {
  @State currentWindowName: string = ControlCenterWindowName.VISION_ADJUST_STEPS_WINDOW;
  public setSubWindowName = (name: string): void => {
    this.currentWindowName = name;
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Row() {
      if (this.currentWindowName === ControlCenterWindowName.VISION_ADJUST_STEPS_WINDOW) {
        VisionAdjustmentStepsComponent();
      }
    }
    .backgroundBlurStyle(BlurStyle.Thick, {
      scale: 0.7,
      blurOptions: {
        grayscale: [40, 40]
      },
      colorMode: ThemeColorMode.DARK
    })
    .size({
      width: ControlCenterConstants.FULL_SIZE,
      height: ControlCenterConstants.FULL_SIZE
    })
    .onAppear(() => {
      log.showInfo(`onAppear`);
    })
    .onDisAppear(() => {
      log.showInfo(`onDisAppear`);
    })
  }
}