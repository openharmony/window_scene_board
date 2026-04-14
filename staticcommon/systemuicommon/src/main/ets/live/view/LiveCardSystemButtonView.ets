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

import { ILiveCardSystemButtonVm } from '../interface/ILiveCardSystemButtonVm';
import { LiveButtonModel } from '../model/LiveCommonModel';

@ComponentV2
export struct LiveCardSystemButtonView {
  @Param @Require buttons: LiveButtonModel[];
  @Param @Require buttonIndex: number;
  @Param @Require buttonVm: ILiveCardSystemButtonVm;

  @Computed
  get button(): LiveButtonModel {
    return this.buttons?.[this.buttonIndex];
  }

  build() {
    Stack() {
      if (this.buttonVm.isShowBorder) {
        Column()
          .width('100%')
          .height('100%')
          .borderRadius('100%')
          .border({ width: 1, color: $r('app.color.live_card_border_color') })
      }
      Image(this.buttonVm.getIcon(this.button))
        .syncLoad(true)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .autoResize(false)
        .interpolation(ImageInterpolation.Medium)
        .height(this.buttonVm.buttonSize)
        .width(this.buttonVm.buttonSize)
        .borderRadius('100%')
        .colorFilter(this.buttonVm.filterColor)
        .clip(true)
    }
    .id(this.buttonVm.getId(this.button))
    .height(this.buttonVm.buttonSize)
    .width(this.buttonVm.buttonSize)
    .borderRadius('100%')
    .opacity(this.buttonVm.buttonOpacity)
    .backgroundColor(this.buttonVm.getLiveButtonNoBrightnessBgColor(this.button))
    .backgroundBrightnessInternal(this.buttonVm.getButtonBgBrightness(this.button))
    .onClick((event: ClickEvent) => this.buttonVm.onClickButton(this.button))
    .accessibilityText(this.button.accessibilityText)
    .accessibilityRole(AccessibilityRoleType.BUTTON)
  }
}