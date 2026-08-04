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
  EDIT_FORM_DRAG,
  EDIT_FORM_MODE_DETAIL,
  EDIT_FORM_MODE_MAIN,
  EDIT_FULL_MODE,
  ENTER_OTHER_APP_BORDER_SHOW
} from '@ohos/screenlockcommon/src/main/ets/base/BaseViewModel';
import { ScreenLockState, ScreenLockStateManager } from '@ohos/screenlockcommon';
import { EDIT_GUIDE_MODE } from '@ohos/screenlockcommon/Index';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import BorderViewConfig, { BorderState } from '../models/BorderConfig';
import { ColorType } from '../models/MainColor';
import FormPlaceHolderInfo from '../../form/drag/FormPlaceHolderInfo';
import { SlVisualArgs, SlVisualControl, SlPositionType, SlAreaType, CcmOption } from '@ohos/screenlockcommon';

const BLENDMODE_DESTINATION_IN: number = 6;
const ADD_IMAGE_OPACITY: number = 0.8;
const ADD_IMAGE_SCALE: string = '27.27%';

@Component
export default struct FormBorderItem {
  @Prop @Watch('updateBorderState') displayMode: number;
  @Prop itemWidth: number = 0;
  @Prop @Watch('updateConfig') itemHeight: number = 0;
  @Prop mainColorType: ColorType = ColorType.LIGHT;
  @Prop isLightWallpaper: boolean = true;
  @Prop contentColor: string
  @ObjectLink @Watch('updateBorderState') formHolder: FormPlaceHolderInfo;
  @State config: BorderViewConfig = new BorderViewConfig(this.itemHeight / 2);
  @State foregroundBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_FORM_FOREGROUND);
  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CAPSULE);

  aboutToAppear(): void {
    if (ScreenLockStateManager.getInstance().isInEdite || ScreenLockStateManager.getInstance().isInBouncer ||
    !ScreenLockStateManager.getInstance().isPageShow) {
      this.updateBorderState();
    }
  }

  private updateConfig(): void {
    this.config.borderRadius = this.itemHeight / 2;
  }

  private updateBorderState(): void {
    switch (this.displayMode) {
      case EDIT_GUIDE_MODE:
      case ENTER_OTHER_APP_BORDER_SHOW:
      case EDIT_FULL_MODE:
        this.config.setBorderState(BorderState.GUIDE, this.isLightWallpaper);
        break;
      case EDIT_CLOCK_DRAG:
        this.config.setBorderState(this.formHolder.isForm ? BorderState.PLACEHOLDER : BorderState.HIDE,
          this.isLightWallpaper);
        break;
      case EDIT_FORM_DRAG:
        this.config.setBorderState(this.formHolder.isPlaceholder ? BorderState.PLACEHOLDER : this.formHolder.isForm ?
        BorderState.HIDE : BorderState.IMMERSION, this.isLightWallpaper, true);
        break;
      case EDIT_FORM_MODE_MAIN:
      case EDIT_FORM_MODE_DETAIL:
        this.config.setBorderState(this.formHolder.isForm ? BorderState.HIDE : BorderState.IMMERSION,
          this.isLightWallpaper);
        break;
      default:
        this.config.setBorderState(BorderState.HIDE, this.isLightWallpaper);
        break;
    }
  }

  private getBackgroundColor(): ResourceColor | undefined {
    return this.enableBright ? BrightnessOptionUtils.brightColor :
      this.foregroundBrightArgs?.getBrightnessColor(this.isLightWallpaper) ?? BrightnessOptionUtils.brightColor;
  }

  // private getBackgroundBrightnessOption(): BrightnessOptions | undefined {
  //   if (!this.enableBright) {
  //     return undefined;
  //   }
  //   return this.isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
  //     BrightnessOptionUtils.keyguardTimeLightOption
  // }

  private getBackgroundBrightnessOption(): BackgroundBrightnessOptions | undefined {
    if (!this.enableBright) {
      return undefined;
    }
    return this.isLightWallpaper ? BrightnessOptionUtils.keyguardTimeDarkOption :
    BrightnessOptionUtils.keyguardTimeLightOption
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Rect({
        width: this.itemWidth,
        height: this.itemHeight,
        radius: this.config.borderRadius
      })
        .borderRadius(this.config.borderRadius)
        .borderColor(this.config.borderColor)
        .borderWidth(this.config.borderWidth)
        .fill(this.config.fillColor)
        .fillOpacity(this.config.fillOpacity)

      Image($r('app.media.ic_form_add'))
        .opacity(this.config.fillOpacity === 0 ? ADD_IMAGE_OPACITY : 0)
        .height(ADD_IMAGE_SCALE)
        .width(ADD_IMAGE_SCALE)
        .fillColor(this.config.borderColor)

      Column()
        .hitTestBehavior(HitTestMode.Transparent)
        .useEffect(true)
        .width('100%')
        .height('100%')
        .blendMode(6)

      Column() {
      }
      .hitTestBehavior(HitTestMode.Transparent)
      .width('100%')
      .height('100%')
      // .blendMode(this.enableBright ? BlendMode.NORMAL : BLENDMODE_DESTINATION_IN)
      .blendMode(this.enableBright ? BlendMode.SRC_IN : BLENDMODE_DESTINATION_IN)
      .backgroundColor(this.contentColor)
      // .backgroundBrightnessInternal(this.getBackgroundBrightnessOption())
      // .backgroundBrightness(this.getBackgroundBrightnessOption())
    }
    .visibility(this.config.visibility ? Visibility.Visible : Visibility.Hidden)
    .blendMode(1000)
  }
}