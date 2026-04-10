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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'ScreenLock-ToastTip';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const DISMISS_TIMEOUT: number = 2000;

/**
 * toast弹窗
 */
@CustomDialog
export default struct ToastTip {
  private message: ResourceStr = '';
  private controller?: CustomDialogController;
  private timerId: number = -1;
  private originColorMode: number = -1;

  aboutToAppear(): void {
    // 深色模式colorMode：0， 浅色模式colorMode：1
    this.originColorMode = GlobalContext.getContext().config.colorMode as number;
    log.showInfo(`about to appear , this.originColorMode : ${this.originColorMode}`);
    this.timerId = setTimeout(() => {
      this.controller?.close();
    }, DISMISS_TIMEOUT);
  }

  aboutToDisappear() {
    clearTimeout(this.timerId);
  }

  build() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.control_center_iot_toast_text_font_size'))
          .lineHeight($r('app.float.screenLock_detail_line_height'))
          .fontColor(this.originColorMode === 0 ? $r('app.color.white') : $r('app.color.menu_text_color'))
          .margin({
            left: $r('app.float.control_center_iot_toast_text_margin_top'),
            right: $r('app.float.control_center_iot_toast_text_margin_top'),
            top: $r('app.float.control_center_iot_toast_text_margin_top'),
            bottom: $r('app.float.Control_center_long_button_spaceBetween'),
          })
      }
      .border({
        width: $r('app.float.screenLock_password_border_width'),
        color: $r('app.color.default_color_component_normal'),
      })
      .justifyContent(FlexAlign.Center)
      .backgroundBlurStyle(BlurStyle.COMPONENT_REGULAR)
      .borderRadius($r('app.float.Notification_center_icon_shadow_radius'))
  }
}