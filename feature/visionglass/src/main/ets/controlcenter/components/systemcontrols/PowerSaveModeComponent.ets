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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PowerSaveModeConstants } from '../constants/PowerSaveModeConstants';
import { calculateSize } from '../constants/WifiConstants';
import { PowerSaveModeManager } from './../manager/PowerSaveModeManager';

const TAG = 'PowerSaveModeComponent';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct PowerSaveModeComponent {
  @Consume windowSize: SizeOptions;
  @State isPowerSaveModeOpen: boolean = PowerSaveModeManager.getInstance().isOpenPowerSaveMode();

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    PowerSaveModeManager.getInstance().initPolicy();
    PowerSaveModeManager.getInstance().registerCallback(this.onPowerSaveModeChange);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    PowerSaveModeManager.destroyInstance();
  }

  private onPowerSaveModeChange = (isOpen: boolean): void => {
    this.isPowerSaveModeOpen = isOpen;
  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.glass_power_save_mode'))
          .height(calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CAPSULE_ICON_SIZE_SCALE))
          .width(calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CAPSULE_ICON_SIZE_SCALE))
          .fillColor(this.isPowerSaveModeOpen ? PowerSaveModeConstants.CAPSULE_ICON_OPEN_COLOR :
          PowerSaveModeConstants.CAPSULE_ICON_CLOSE_COLOR)
      }
      .height(calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CAPSULE_HEIGHT_SCALE))
      .width(calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CAPSULE_HEIGHT_SCALE))
      .borderRadius(calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CAPSULE_HEIGHT_SCALE))
      .justifyContent(FlexAlign.Center)
      .backgroundColor(this.isPowerSaveModeOpen ? PowerSaveModeConstants.CAPSULE_OPEN_COLOR :
      PowerSaveModeConstants.BUTTON_BACKGROUND_COLOR)
      .onClick(() => {
        PowerSaveModeManager.getInstance().changePowerSaveMode(this.isPowerSaveModeOpen);
      })

      Row()
        .size({
          width: calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CAPSULE_HEIGHT_SCALE),
          height: calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CIRCLE_NAME_TOP_MARGIN)
        })

      Text($r('app.string.control_center_phone_power_save_mode'))
        .fontColor(Color.White)
        .fontSize(PowerSaveModeConstants.FONT_SIZE)
        .fontWeight(PowerSaveModeConstants.FONT_WEIGHT)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .opacity(0.5)
    }
    .width(calculateSize(this.windowSize.height as number, PowerSaveModeConstants.CAPSULE_HEIGHT_SCALE))
    .alignItems(HorizontalAlign.Center)
  }
}