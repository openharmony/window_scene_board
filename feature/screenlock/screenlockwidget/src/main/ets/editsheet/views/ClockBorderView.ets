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
import {
  EDIT_CLOCK_DRAG,
  EDIT_CLOCK_MODE,
  EDIT_FULL_MODE
} from '@ohos/screenlockcommon/src/main/ets/base/BaseViewModel';
import { EDIT_GUIDE_MODE, ENTER_OTHER_APP_BORDER_SHOW } from '@ohos/screenlockcommon/Index';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { ClockLayoutParam, clockLayoutParam } from '../../clock/common/ClockLayoutParam';
import BorderViewConfig, { BorderState } from '../models/BorderConfig';
import { ColorType } from '../models/MainColor';
import { SlVisualArgs, SlVisualControl, SlPositionType, SlAreaType, CcmOption } from '@ohos/screenlockcommon';

const BLENDMODE_SRC_OVER: number = 1000;
const BLENDMODE_DESTINATION_IN: number = 6;

const TAG = 'ClockBorderView';

@Component
export default struct ClockBorderView {
  @Prop mainColorType: ColorType = ColorType.LIGHT;
  @Prop @Watch('onDisplayModeChanged') displayMode: number = 0;
  @Prop isLightWallpaper: boolean = true;
  @State layoutParam : ClockLayoutParam = clockLayoutParam;
  @State config: BorderViewConfig = new BorderViewConfig(24);
  @State backgroundBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CLOCK_WIDGET);
  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CAPSULE);

  private onDisplayModeChanged(): void {
    switch (this.displayMode) {
      case EDIT_GUIDE_MODE:
      case ENTER_OTHER_APP_BORDER_SHOW:
        this.config.setBorderState(BorderState.GUIDE, this.isLightWallpaper, false, this.displayMode);
        break;
      case EDIT_CLOCK_DRAG:
        this.config.setBorderState(BorderState.PLACEHOLDER, this.isLightWallpaper);
        break;
      case EDIT_FULL_MODE:
      case EDIT_CLOCK_MODE:
        this.config.setBorderState(BorderState.IMMERSION, this.isLightWallpaper);
        break;
      default:
        this.config.setBorderState(BorderState.HIDE, this.isLightWallpaper);
        break;
    }
  }

  // private getBgBrightnessOption(): BrightnessOptions | undefined {
  //   if (!this.enableBright) {
  //     return undefined;
  //   }
  //   return this.isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
  //     BrightnessOptionUtils.keyguardTimeLightOption;
  // }

  private getBgBrightnessOption(): BackgroundBrightnessOptions | undefined {
    if (!this.enableBright) {
      return undefined;
    }
    return this.isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
    BrightnessOptionUtils.keyguardTimeLightOption;
  }

  private getBgColor(): ResourceColor {
    return this.enableBright ? BrightnessOptionUtils.brightColor :
      this.backgroundBrightArgs?.getBrightnessColor(this.isLightWallpaper) ?? BrightnessOptionUtils.brightColor;
  }

  build() {
    Stack() {
      Rect({
        width: this.layoutParam.gridParam.gridWidthSize,
        height: this.layoutParam.gridParam.gridHeightSize,
        radius: this.config.borderRadius
      })
        .fill(this.config.fillColor)
        .fillOpacity(this.config.fillOpacity)
        .borderColor(this.config.borderColor)
        .borderRadius(this.config.borderRadius)
        .borderWidth(this.config.borderWidth)
        .radius(this.config.borderRadius)

      Stack() {
      }
      .useEffect(true)
      .blendMode(BLENDMODE_DESTINATION_IN)
      .width('100%')
      .height('100%')

      Column() {
      }
      .width('100%')
      .height('100%')
      // .blendMode(this.enableBright ? BlendMode.NORMAL : BLENDMODE_DESTINATION_IN)
      .blendMode(this.enableBright ? BlendMode.SRC_OVER : BLENDMODE_DESTINATION_IN)
      .backgroundColor(this.getBgColor())
      // .backgroundBrightnessInternal(this.getBgBrightnessOption())
      .backgroundBrightness(this.getBgBrightnessOption())
    }
    .visibility(this.config.visibility ? Visibility.Visible : Visibility.Hidden)
    .width(this.layoutParam.gridParam.gridWidthSize)
    .height(this.layoutParam.gridParam.gridHeightSize)
    .blendMode(BLENDMODE_SRC_OVER)
    .id(TAG)
  }
}