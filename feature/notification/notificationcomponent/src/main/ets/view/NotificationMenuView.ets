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

import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import {
  INotificationMenuVm,
  INotificationSwipeVm,
  NotificationVmInjector,
  ResourceVm,
  INotificationCardVm,
} from '@ohos/systemuicommon/newIndex';
import { LengthMetrics } from '@ohos.arkui.node';
import { NotificationStyle } from '../constants/NotificationStyle';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'NotificationMenuView';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

@ComponentV2
export struct NotificationMenuView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require ntf: NotificationBase;
  /**
   * 是否在组通知里
   */
  @Param isInGroup: boolean = false;

  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    const swipeVm = this.ntfVmInjector.getSwipeVm(this.ntf);
    if (swipeVm) {
      swipeVm.setLeftThreshold(this.menuVm?.menuWidth ?? 0);
    }
    return swipeVm;
  }
  @Computed get menuVm(): INotificationMenuVm | undefined {
    const menuVm = this.ntfVmInjector.getMenuVm?.(this.ntf);
    if (menuVm) {
      menuVm.isInGroup = this.isInGroup;
    }
    return menuVm;
  }
  @Computed get settingButtonId(): string {
    return this.ntfVmInjector.getId(`${TAG}_setting_${this.ntf.hashCode}`);
  }
  @Computed get removeButtonId(): string {
    return this.ntfVmInjector.getId(`${TAG}_remove_${this.ntf.hashCode}`);
  }
  @Computed get cardVm(): INotificationCardVm {
    return this.ntfVmInjector.getCardVm(this.ntf);
  }

  private colorVm = this.ntfVmInjector.getColorVm();

  build() {
    RelativeContainer() {
      if (this.menuVm?.isShowSettingButton()) {
        this.buildSettingButton()
      }
      if (this.menuVm?.isShowRemoveButton()) {
        this.buildRemoveButton()
      }
    }
    .id(this.ntfVmInjector.getId(`${TAG}_${this.ntf.hashCode}`))
    .height($r('app.float.ntf_action_button_height'))
    .clip(true)
    .width(-(this.swipeVm?.offsetX ?? 0))
    .margin({
      top: this.ntfVmInjector.getNormalGroupVm(this.ntf)?.isExpanded ? $r('app.float.ntf_item_padding_start_end') : undefined
    })
    .zIndex(-1)
  }

  @Styles
  buttonStyles() {
    .borderRadius($r('app.float.ntf_menu_row_clear_button_radius'))
    .width(NotificationStyle.ITEM_ICON_SIZE)
    .height(NotificationStyle.ITEM_ICON_SIZE)
    .backgroundColor(this.isInGroup ? this.colorVm.groupMenuButtonBgColor : this.colorVm.menuButtonBgColor)
    .backgroundBrightnessInternal(this.colorVm.buttonBgBrightness)
  }

  @Builder
  buildSettingButton() {
    Column() {
      Image($r('app.media.ic_public_more'))
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .fillColor($r('app.color.ntf_phone_menu_bg_color'))
        .width($r('app.float.ntf_action_send_icon_size'))
        .height($r('app.float.ntf_action_send_icon_size'))
        .id(this.ntfVmInjector.getId(`${TAG}_settingIcon_${this.ntf.hashCode}`))
    }
    .justifyContent(FlexAlign.Center)
    .id(this.settingButtonId)
    .buttonStyles()
    .offset({ start: LengthMetrics.vp(this.menuVm?.settingButtonData.offsetX) })
    .opacity(this.menuVm?.settingButtonData.opacity)
    .onClick(() => this.menuVm?.onSettingButtonClick())
    .margin({ end: LengthMetrics.vp(NotificationStyle.ITEM_PADDING * (this.menuVm?.isShowRemoveButton() ? 2 : 1)) })
    .accessibilityText($r('app.string.accessibility_notification_setting_bar'))
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      end: { anchor: this.menuVm?.isShowRemoveButton() ? this.removeButtonId : '__container__',
        align: this.menuVm?.isShowRemoveButton() ? HorizontalAlign.Start : HorizontalAlign.End, },
    })
  }

  @Builder
  buildRemoveButton() {
    Column() {
      Stack({ alignContent: Alignment.TopStart }) {
        Image($r('app.media.trash_cover'))
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.ntf_phone_menu_bg_color'))
          .width($r('app.float.ntf_action_send_icon_size'))
          .height($r('app.float.ntf_action_send_icon_size'))
          .rotate({
            centerX: '90%',
            centerY: '15%',
            z: 1,
            angle: this.menuVm?.removeButtonData.coverRotate
          })
        Image($r('app.media.trash_bin'))
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.ntf_phone_menu_bg_color'))
          .width($r('app.float.ntf_action_send_icon_size'))
          .height($r('app.float.ntf_action_send_icon_size'))
          .rotate({
            centerX: '80%',
            centerY: '25%',
            z: 1,
            angle: this.menuVm?.removeButtonData.binRotate
          })
      }
      .id(this.ntfVmInjector.getId(`${TAG}_removeIcon_${this.ntf.hashCode}`))
    }
    .justifyContent(FlexAlign.Center)
    .id(this.removeButtonId)
    .buttonStyles()
    .offset({ start: LengthMetrics.vp(this.menuVm?.removeButtonData.removeButtonOffsetX) })
    .opacity(this.menuVm?.removeButtonData.opacity)
    .onClick(() => {
      this.menuVm?.removeNtf(this.ntfVmInjector.getCardVm(this.ntf).isMoreBrief() ? 0 : undefined);
      this.swipeVm?.removeNtf();
    })
    .scale({
      x: ResourceVm.instance.getXDirectionValue(this.menuVm?.removeButtonData.removeButtonScale),
      y: this.menuVm?.removeButtonData.removeButtonScale
    })
    .margin({ end: LengthMetrics.vp(NotificationStyle.ITEM_PADDING ?? 0) })
    .accessibilityText($r('app.string.accessibility_notification_delete_bar'))
    .accessibilityRole(AccessibilityRoleType.BUTTON)
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      end: { anchor: '__container__', align: HorizontalAlign.End, },
    })
  }
}