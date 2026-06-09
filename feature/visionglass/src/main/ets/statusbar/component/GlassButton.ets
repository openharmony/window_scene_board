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

import { GlassLayoutColor } from '../../common/constants/GlassLayoutConstants';
import { GlassStatusBarStyle } from '../view/GlassStatusBarStyle';

/**
 * 按钮
 */
@Component
export struct GlassButton {
  private img?: Resource | string;
  @BuilderParam content?: () => void;

  build() {
    Row() {
      if (this.content) {
        this.content()
      } else if (this.img) {
        Image(this.img)
          .height(GlassStatusBarStyle.ICON_SIZE)
          .width(GlassStatusBarStyle.ICON_SIZE)
      }
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .border(GlassStatusBarStyle.GLASS_BUTTON_BORDER)
    .backdropBlur(GlassStatusBarStyle.GLASS_BUTTON_BLUR)
    .backgroundColor(GlassLayoutColor.BACKGROUND_REGULAR_COLOR)
    .constraintSize(GlassStatusBarStyle.GLASS_BUTTON_CONSTRAINT_SIZE)
  }
}