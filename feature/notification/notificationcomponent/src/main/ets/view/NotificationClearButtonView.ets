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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ResourceVm, NotificationVmInjector, AccessibilityVm } from '@ohos/systemuicommon/newIndex';

const TAG = 'NotificationClearButtonView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DEL_EFFECT = TransitionEffect.OPACITY.animation({ duration: 350, curve: Curve.Friction });

@ComponentV2
export struct NotificationClearButtonView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;

  @Computed
  get clearButtonVm() {
    return this.ntfVmInjector.getClearButtonVm?.();
  }

  private colorVm = this.ntfVmInjector?.getColorVm();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.clearButtonVm?.registerEventListener();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisAppear');
    this.clearButtonVm?.unRegisterEventListener();
  }

  build() {
    if (this.clearButtonVm?.isShow) {
      Column() {
        Button({ type: ButtonType.Circle, stateEffect: true }) {
          Stack({ alignContent: Alignment.Center }) {
            Image($r('app.media.trash_cover'))
              .objectFit(ImageFit.Contain)
              .fillColor($r('app.color.ntf_phone_common_font_color'))
              .width($r('app.float.ntf_action_send_icon_size'))
              .height($r('app.float.ntf_action_send_icon_size'))
              .draggable(false)
              .rotate({
                z: 1,
                centerX: '90%',
                centerY: '30%',
                angle: this.clearButtonVm?.angle
              })
            Image($r('app.media.trash_bin'))
              .draggable(false)
              .objectFit(ImageFit.Contain)
              .fillColor($r('app.color.ntf_phone_common_font_color'))
              .width($r('app.float.ntf_action_send_icon_size'))
              .height($r('app.float.ntf_action_send_icon_size'))
          }
          .width($r('app.float.ntf_clear_button_icon_size'))
          .height($r('app.float.ntf_clear_button_icon_size'))
          .borderRadius($r('app.float.ntf_clear_button_icon_size'))
          .backgroundColor(this.colorVm.allClearButtonBgColor)
          .backgroundBrightnessInternal(this.colorVm?.buttonBgBrightness)
        }
        .id(`${TAG}_button`)
        .backgroundColor(Color.Transparent)
        .backgroundEffect(this.clearButtonVm?.backgroundEffectOptions)
        .accessibilityText($r('app.string.accessibility_notification_clear'))
        .onClick(() => {
          this.clearButtonVm?.clear();
          AccessibilityVm.instance.sendEventByResource($r('app.string.already_clear'));
        })
      }
      .id(TAG)
      .margin(this.clearButtonVm.margin)
      .transition(TransitionEffect.asymmetric(DEL_EFFECT, DEL_EFFECT))
      .width(this.clearButtonVm.width)
      .alignItems(HorizontalAlign.Center)
      .scale({ x: this.clearButtonVm?.scale, y: this.clearButtonVm?.scale })
      .layoutWeight(1)
      .alignRules(this.clearButtonVm?.alignRules)
    }
  }
}