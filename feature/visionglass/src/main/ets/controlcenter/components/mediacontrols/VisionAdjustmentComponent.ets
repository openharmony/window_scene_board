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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ControlCenterWindowManager, ControlCenterWindowName } from '../../manager/ControlCenterWindowManager';
import { ControlCenterConstants } from '../constants/ControlCenterConstants';
import { VisionAdjustmentConstants } from '../constants/VisionAdjustmentConstants';
import { calculateSize } from '../constants/WifiConstants';

const TAG = 'VisionAdjustmentComponent';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct VisionAdjustmentComponent {
  @Consume windowSize: SizeOptions;

  build() {
    Row() {
      Row() {
        Button({
          type: ButtonType.Circle,
          stateEffect: true,
        }) {
          Image($r('app.media.glass_vision_adjustment_icon'))
            .width(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_SIZE_SCALE))
            .height(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_SIZE_SCALE))
            .fillColor(ControlCenterConstants.CAPSULE_ICON_CLOSE_COLOR)
        }
        .width(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_BG_SIZE_SCALE))
        .height(calculateSize(this.windowSize.height as number, ControlCenterConstants.CAPSULE_ICON_BG_SIZE_SCALE))
        .backgroundColor(VisionAdjustmentConstants.CAPSULE_CLOSE_COLOR)
      }
      .borderRadius(calculateSize(this.windowSize.height as number, VisionAdjustmentConstants.CAPSULE_HEIGHT_SCALE))
      .width(calculateSize(this.windowSize.height as number, VisionAdjustmentConstants.CAPSULE_HEIGHT_SCALE))
      .height(calculateSize(this.windowSize.height as number, VisionAdjustmentConstants.CAPSULE_HEIGHT_SCALE))
      .justifyContent(FlexAlign.Center)

      Text($r('app.string.control_center_adjustment'))
        .fontColor(VisionAdjustmentConstants.CAPSULE_ICON_CLOSE_COLOR)
        .fontSize(VisionAdjustmentConstants.FONT_SIZE)
        .fontWeight(FontWeight.Bold)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Start)
        .fontSize(VisionAdjustmentConstants.FONT_SIZE)
    }
    .backgroundColor(ControlCenterConstants.BUTTON_BACKGROUND_COLOR)
    .borderRadius(calculateSize(this.windowSize.height as number, VisionAdjustmentConstants.CAPSULE_HEIGHT_SCALE))
    .width(calculateSize(this.windowSize.height as number, VisionAdjustmentConstants.CAPSULE_WIDTH_SCALE))
    .height(calculateSize(this.windowSize.height as number, VisionAdjustmentConstants.CAPSULE_HEIGHT_SCALE))
    .onClick(() => {
      ControlCenterWindowManager.getInstance().openSubWindow(ControlCenterWindowName.VISION_ADJUST_STEPS_WINDOW);
    })
  }
}