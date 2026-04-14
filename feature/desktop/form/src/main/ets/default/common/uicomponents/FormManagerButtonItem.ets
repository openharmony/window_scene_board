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

import FormStyleConstants from '../constants/FormStyleConstants';
import FormConstants from '../constants/FormConstants';

@Component
export default struct FormManagerButtonItem {
  @Prop formManagerShowFrom: number = FormConstants.FORM_MANAGER_SHOW_FROM_DESKTOP_APP_RIGHT_MENU;
  private addToDesktopButtonClick?: Function;
  private buttonTouchDown?: Function;

  build() {
    Column() {
      Button($r('app.string.add_to_desktop'), { type: ButtonType.Capsule })
      .id('FormManagerButtonItem_AddToDesktopButton')
      .width(FormStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
      .height(FormStyleConstants.FORM_MGR_ADD_TO_DESKTOP_BUTTON_HEIGHT)
      .onClick(() => {
        this.addToDesktopButtonClick?.();
      })
      .onTouch((event: TouchEvent) => {
        if (event.type === TouchType.Down) {
          this.buttonTouchDown?.();
        }
      })
    }
    .padding({
      left: FormStyleConstants.FORM_MANAGER_BUTTON_MARGIN,
      right: FormStyleConstants.FORM_MANAGER_BUTTON_MARGIN
    })
    .margin({
      bottom: $r('sys.float.ohos_id_default_padding_bottom_fixed'),
      top: FormStyleConstants.FORM_MGR_BUTTON_SPACE
    })
    .width(FormStyleConstants.DEFAULT_LAYOUT_PERCENTAGE)
  }
}