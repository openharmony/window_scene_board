/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ResUtils } from '@ohos/windowscene';

@Component
export struct DefaultControlPanel {
  private onActionClose = () => {};
  private onActionRestore = () => {};

  build() {
    RelativeContainer() {
      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.ic_close_bold'))
          .size({ width: 24, height: 24 })
          .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
          .objectFit(ImageFit.Contain)
      }
      .backgroundColor('#00FFFFFF')
      .size({ width: 24, height: 24 })
      .margin(12)
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
      .id('control_exit')
      .responseRegion({ x: '-50%', y: '-50%', width: '200%', height: '200%' })
      .accessibilityText(ResUtils.getInnerString($r('app.string.pip_close')))
      .onClick(() => {
        this.onActionClose();
      })

      Button({ type: ButtonType.Circle }) {
        Image($r('app.media.ic_public_restore'))
          .fillColor($r('sys.color.ohos_id_color_primary_contrary'))
          .objectFit(ImageFit.Contain)
      }
      .backgroundColor('#00FFFFFF')
      .size({ width: 24, height: 24 })
      .margin(12)
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .id('control_restore')
      .responseRegion({ x: '-50%', y: '-50%', width: '200%', height: '200%' })
      .accessibilityText(ResUtils.getInnerString($r('app.string.pip_restore')))
      .onClick(() => {
        this.onActionRestore();
      })
    }
    .width('100%')
    .height(48)
    .linearGradient({
      angle: 180,
      colors: [['#4D000000', 0.0], ['#00000000', 1.0]]
    })
    .alignRules({
      top: { anchor: '__container__', align: VerticalAlign.Top },
      left: { anchor: '__container__', align: HorizontalAlign.Start }
    })
    .id('default_control')
  }
}