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

import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const ADD_MORE_TOGGLE_BUTTON_SIZE: number = 28;
const ADD_MORE_BUTTON_WIDTH: number = 304;
const ADD_MORE_BUTTON_WIDTH_SINGLE_FOLD: number = 328;

@Component
export struct AddMoreToggleButton {
  private addMoreButtonWidth: number = ADD_MORE_BUTTON_WIDTH;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  build() {
    Stack() {
      SymbolGlyph($r('sys.symbol.plus'))
        .size({ width: 28, height: 28 })
        .fontSize(ADD_MORE_TOGGLE_BUTTON_SIZE + 'vp')
        .fontColor([$r('app.color.center_edit_add_more_toggle_button_icon_color')])
        .fontWeight(FontWeight.Medium)
        .foregroundBrightness(this.colorModeViewData.addMoreTextOption)
        .draggable(false)
    }
    .height(48)
    .width(this.addMoreButtonWidth)
    .alignContent(Alignment.Center)
    .borderRadius(24)
    .backgroundColor($r('app.color.center_edit_add_more_toggle_button_bg_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.addMoreBgOption)
  }
}