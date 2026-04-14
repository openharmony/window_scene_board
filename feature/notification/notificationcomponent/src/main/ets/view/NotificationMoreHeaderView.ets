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

import I18n from '@ohos.i18n';
import { LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { INotificationCardVm, INotificationListVm, NotificationVmInjector,
  ResourceVm } from '@ohos/systemuicommon/newIndex';
import { MORE_NTF_HEADER_DELETE_TRANSITION } from '../animation/MoreNotificationCollapsedAnimation';
import { NotificationStyle } from '../constants/NotificationStyle';

const TAG = 'NotificationMoreHeaderView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@ComponentV2
export struct NotificationMoreHeaderView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;

  @Computed get moreHeaderVm() {
    return this.ntfVmInjector.getNotificationMoreHeaderVm();
  }
  private colorVm = this.ntfVmInjector.getColorVm();

  @Computed
  get listVm(): INotificationListVm {
    return this.ntfVmInjector.getListVm()!;
  }

  @Computed
  get moreListLength(): number | undefined {
    return this.listVm?.moreNtfList?.length
  }

  @Computed
  get cardVm(): INotificationCardVm | undefined {
    if (this.listVm.moreNtfList[0]) {
      return this.ntfVmInjector.getCardVm(this.listVm.moreNtfList[0]);
    }
    return undefined;
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear`);
    this.moreHeaderVm?.reset();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`);
  }

  @Builder
  buildCollapsedButton() {
    Text(this.moreHeaderVm?.isCollapsed ? $r('app.string.ntf_extra_message_expand') : $r('app.string.ntf_extra_message_collapse'))
      .draggable(false)
      .id(`${TAG}_Title_Content_Ntf`)
      .fontSize($r('app.float.ntf_extra_content_font_size'))
      .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
      .fontColor(this.colorVm.ntfExtraContentColor)
      .foregroundBrightness(this.colorVm.foregroundPrimaryOption)
      .fontWeight(FontWeight.Medium)
      .textOverflow({ overflow: TextOverflow.MARQUEE })
      .marqueeOptions({ start: false, fadeout: true })
      .maxLines(1)
      .height('100%')
      .fontFamily('HarmonyHeiTi')
      .constraintSize({ maxWidth: '26%' })

    Image(this.moreHeaderVm?.isCollapsed ? $r('app.media.ic_ntf_arrow_down') : $r('app.media.ic_ntf_arrow_up'))
      .id(`${TAG}_Title_Button_Image_Ntf`)
      .objectFit(ImageFit.Contain)
      .width(ResourceVm.instance.getFontSize($r('app.float.ntf_extra_image_width')))
      .fillColor(this.colorVm.ntfButtonImageColor)
      .foregroundBrightness(this.colorVm.foregroundPrimaryOption)
      .margin({
        start: LengthMetrics.resource($r('app.float.ntf_extra_content_image_margin_start'))
      })
  }

  // 更多通知 文字
  @Builder
  buildMoreNtfText() {
    Text($r('app.string.ntf_extra_message'))
      .draggable(false)
      .id(`${TAG}_Title_Extra_Ntf`)
      .fontSize($r('app.float.ntf_extra_title_font_size'))
      .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
      .fontColor($r('app.color.ntf_center_title_font_color'))
      .foregroundBrightness(this.colorVm.foregroundPrimaryOption)
      .fontWeight(FontWeight.Medium)
      .textOverflow({ overflow: TextOverflow.MARQUEE })
      .marqueeOptions({ start: false, fadeout: true })
      .maxLines(1)
      .flexShrink(0)
      .textShadow({
        radius: 5,
        color: 'rgba(0, 0, 0, 0.2)',
      })
      .renderGroup(true)
      .height(ResourceVm.instance.getFontSize($r('app.float.ntf_extra_button_line_height')))
      .margin({
        start: LengthMetrics.resource($r('app.float.ntf_extra_title_margin_start'))
      })
      .accessibilityLevel('yes')
      .constraintSize({
        maxWidth: this.moreListLength && this.moreListLength > 1 ? this.moreHeaderVm?.moreHeaderContentMaxWidth : '100%'
      })
  }

  build() {
    Row() {
      this.buildMoreNtfText() // 更多通知
      Blank()
        .height($r('app.float.ntf_extra_button_line_height'))
      if (this.moreListLength && this.moreListLength > 1) {
        Row() {
          this.buildCollapsedButton();
        }
        .id(this.moreHeaderVm?.moreHeaderButtonId)
        .height(ResourceVm.instance.getFontSize($r('app.float.ntf_extra_button_line_height')))
        .constraintSize({ minWidth: $r('app.float.ntf_extra_button_width') })
        .borderRadius($r('app.float.ntf_extra_button_radius'))
        .backgroundColor(this.colorVm.extraButtonBgColor)
        .backgroundBrightnessInternal(this.colorVm.extraHeaderButtonBgBrightness)
        .margin({
          end: LengthMetrics.resource($r('app.float.ntf_extra_button_margin_right')),
          start: LengthMetrics.resource($r('app.float.ntf_extra_content_margin_left'))
        })
        .padding({
          left: ResourceVm.instance.getFontSize($r('app.float.ntf_extra_content_margin_left')),
          right: ResourceVm.instance.getFontSize($r('app.float.ntf_extra_content_margin_left')),
          top: ResourceVm.instance.getFontSize($r('app.float.ntf_extra_content_margin_top')),
          bottom: ResourceVm.instance.getFontSize($r('app.float.ntf_extra_content_margin_bottom'))
        })
        .onClick(() => {
          this.moreHeaderVm?.toggleCollapsed(false);
        })
        .transition(MORE_NTF_HEADER_DELETE_TRANSITION)
        .accessibilityRole(AccessibilityRoleType.BUTTON)
        .onSizeChange(this.moreHeaderVm?.collapsedButtonSizeChange)
      }
    }
    .alignItems(VerticalAlign.Bottom)
    .translate({ y: this.moreHeaderVm?.translateY })
    .opacity(this.moreHeaderVm?.opacity)
    .scale({ x: this.moreHeaderVm?.scale, y: this.moreHeaderVm?.scale })
    .width('100%')
    .height(ResourceVm.instance.getFontSize(this.listVm.mainNtfList.length > 0 ? $r('app.float.ntf_extra_height') :
    $r('app.float.ntf_extra_button_line_height')))
  }
}