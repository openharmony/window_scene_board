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
import { ILiveCardMenuVm } from '../interface/ILiveCardMenuVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { LiveStyle } from '../constants/LiveStyle';
import { LengthMetrics } from '@ohos.arkui.node';
import { SystemEffectVm } from '../../vm/SystemEffectVm';

const TAG = 'LiveCardMenuView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveCardMenuView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  colorVm = this.liveVmInjector.getColorVm();
  @Computed get menuVm(): ILiveCardMenuVm {
    return this.liveVmInjector.getCardMenuVm(this.live);
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear: ${this.live.hashCode}`);
    this.menuVm.init();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear: ${this.live.hashCode}`);
    this.menuVm.destroy();
  }

  build() {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Row() {}
        .width('100%')
        .height('100%')
        .backgroundColor(SystemEffectVm.instance.isCloseBrightness() ? this.colorVm.buttonNoBrightBgColor :
        this.colorVm.buttonBgColor)
        .backgroundBrightnessInternal(SystemEffectVm.instance.isCloseBrightness() ? undefined :
        this.colorVm.buttonBgBrightness)

        Image($r('app.media.ic_item_del_clear'))
          .draggable(false)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .fillColor(Color.White)
          .width($r('app.float.menu_icon_size'))
          .height($r('app.float.menu_icon_size'))
      }
      .id(this.liveVmInjector.getId(`${TAG}_RemoveButton_${this.live.hashCode}`))
      .width(LiveStyle.CARD_MENU_BUTTON_WIDTH)
      .height(LiveStyle.CARD_MENU_BUTTON_HEIGHT)
      .borderRadius('100%')
      .margin({ left: LiveStyle.CARD_MENU_MARGIN, right: LiveStyle.CARD_MENU_MARGIN })
      .clip(true)
      .useEffect(true)
      .onClick(this.menuVm.removeLive)
      .accessibilityLevel(this.menuVm.menuOpacity ? 'yes' : 'no')
      .accessibilityText($r('app.string.accessibility_notification_delete_bar'))
      .accessibilityRole(AccessibilityRoleType.BUTTON)
    }
    .id(this.liveVmInjector.getId(`${TAG}_${this.live.hashCode}`))
    .padding({ start: LengthMetrics.resource($r('app.float.item_padding_start_end')) })
    .offset({ start: LengthMetrics.vp(this.menuVm.menuOffsetX) })
    .opacity(this.menuVm.resetMenuWithAnim ? this.menuVm.menuOpacityWithAnim : this.menuVm.menuOpacity)
    .onSizeChange(this.menuVm.onMenuSizeChange)
  }
}