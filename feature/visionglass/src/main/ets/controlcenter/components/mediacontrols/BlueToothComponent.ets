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

import { BluetoothConstants } from '../constants/BluetoothConstants';
import { calculateSize } from '../constants/WifiConstants';
import { GlassBlueToothManager } from '../manager/GlassBlueToothManager';

@Component
export default struct BlueToothComponent {
  @State glassBlueToothManager: GlassBlueToothManager = new GlassBlueToothManager();
  @Consume windowSize: SizeOptions;

  aboutToAppear(): void {
    this.glassBlueToothManager.registerStateChangeCallback();
  }

  aboutToDisappear(): void {
    this.glassBlueToothManager.unRegisterStateChangeCallback();
  }

  build() {
    Column() {
      Row() {
        Button() {
          Image($r('app.media.glass_ic_bluetooth'))
            .height(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_ICON_SIZE_SCALE))
            .width(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_ICON_SIZE_SCALE))
            .fillColor(this.glassBlueToothManager.getBluetoothFillColor())
        }
        .height(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE))
        .width(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE))
        .backgroundColor(this.glassBlueToothManager.getBluetoothColor())
        .borderRadius(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE))
        .onClick(() => {
          this.glassBlueToothManager.updateBluetoothState();
        })
      }
      .backgroundColor(BluetoothConstants.BUTTON_BACKGROUND_COLOR)
      .borderRadius(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE))
      .height(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE))
      .width(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE))

      Row()
        .size({
          width: calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE),
          height: calculateSize(this.windowSize.height as number, BluetoothConstants.CIRCLE_NAME_TOP_MARGIN)
        })

      Text($r('app.string.control_center_bluetooth'))
        .fontColor(Color.White)
        .fontWeight(BluetoothConstants.FONT_WEIGHT)
        .fontSize(BluetoothConstants.FONT_SIZE)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .opacity(0.5)
    }
    .width(calculateSize(this.windowSize.height as number, BluetoothConstants.CAPSULE_HEIGHT_SCALE))
    .alignItems(HorizontalAlign.Center)
  }
}