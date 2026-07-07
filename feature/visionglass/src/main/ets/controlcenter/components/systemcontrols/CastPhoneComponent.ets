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

import { CastPhoneConstants } from '../constants/CastPhoneConstants';
import { calculateSize } from '../constants/WifiConstants';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import xrGlassesAppService from '@hms.xrGlassesService.xrGlassesAppService';

const TAG = 'CastPhoneComponent';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct CastPhoneComponent {
  @Consume windowSize: SizeOptions;
  @Consume screenId: number;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.glass_cast_phone'))
          .height(calculateSize(this.windowSize.height as number, CastPhoneConstants.CAPSULE_ICON_SIZE_SCALE))
          .width(calculateSize(this.windowSize.height as number, CastPhoneConstants.CAPSULE_ICON_SIZE_SCALE))
          .fillColor(CastPhoneConstants.CAPSULE_ICON_CLOSE_COLOR)
      }
      .height(calculateSize(this.windowSize.height as number, CastPhoneConstants.CAPSULE_HEIGHT_SCALE))
      .width(calculateSize(this.windowSize.height as number, CastPhoneConstants.CAPSULE_HEIGHT_SCALE))
      .borderRadius(calculateSize(this.windowSize.height as number, CastPhoneConstants.CAPSULE_HEIGHT_SCALE))
      .justifyContent(FlexAlign.Center)
      .backgroundColor(CastPhoneConstants.BUTTON_BACKGROUND_COLOR)
      .onClick(() => {
        try {
          xrGlassesAppService.setSpaceMode(0)
            .then((result: number) => {
              log.showInfo(`setSpaceMode mirror success,result is ${result}`);
            })
            .catch((err: BusinessError) => {
              log.showError(`setSpaceMode mirror fail,error is ${err.code}`);
            })
        } catch (err) {
          log.showError(`setSpaceMode mirror fail2,error is ${err.code}`);
        }
      })

      Row()
        .size({
          width: calculateSize(this.windowSize.height as number, CastPhoneConstants.CAPSULE_HEIGHT_SCALE),
          height: calculateSize(this.windowSize.height as number, CastPhoneConstants.CIRCLE_NAME_TOP_MARGIN)
        })

      Text($r('app.string.control_center_phone_cast_screen'))
        .fontColor(Color.White)
        .fontSize(CastPhoneConstants.FONT_SIZE)
        .fontWeight(CastPhoneConstants.FONT_WEIGHT)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .opacity(0.5)
    }
    .width(calculateSize(this.windowSize.height as number, CastPhoneConstants.CAPSULE_HEIGHT_SCALE))
    .alignItems(HorizontalAlign.Center)
  }
}