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

import { NotificationAction } from '@ohos/systemuicommon';
import { NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { INotificationActionButtonVm, NotificationVmInjector, ResourceVm } from '@ohos/systemuicommon/newIndex';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationStyle } from '../constants/NotificationStyle';
import { ResUtils } from '@ohos/windowscene';

const TAG = 'NotificationActionButtonView';

@ComponentV2
export struct NotificationActionButtonView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require ntf: NormalNotification;
  @Param isFloatingSupported: boolean = false;
  @Param isInGroup: boolean = false;
  colorVm = this.ntfVmInjector.getColorVm();
  @Computed get actionButtonVm(): INotificationActionButtonVm {
    return this.ntfVmInjector.getActionButtonVm(this.ntf);
  }

  build() {
    Row() {
      // 回复input显示
      if (this.actionButtonVm.replyAction) {
        this.buildActionReply();
      } else { // 按钮显示
        Repeat(this.ntf.actionButtons?.slice(0, 2)).each((data) => {
          if (data.index !== 0) {
            Divider()
              .vertical(true)
              .height($r('app.float.ntf_buttons_divier_height'))
              .color(this.actionButtonVm.touchedIndex === data.index ? Color.Transparent :
              this.colorVm.actionButtonDividerColor)
              .foregroundBrightness(this.colorVm.dividerFgBrightness)
              .flexShrink(0)
              .margin({ bottom: this.isFloatingSupported ? ResUtils.getNumber($r('app.float.ntf_has_drop_bar_add_height')) : 0 })
          }
          this.buildActionButton(data)
        }).key((action) => action?.actionTitle)
      }
    }
    .id(this.ntfVmInjector.getId(`${TAG}_${this.ntf.hashCode}`))
    .width('100%')
    .padding({ bottom: this.actionButtonVm.paddingBottom })
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(this.colorVm.actionButtonBgColor)
    .backgroundBrightnessInternal(this.colorVm.actionButtonBgBrightness)
  }

  @Builder
  buildActionReply() {
    Row() {
      TextInput({ placeholder: $r('app.string.place_holder_input_content') })
        .draggable(false)
        .type(InputType.Normal)
        .enterKeyType(EnterKeyType.Send)
        .height(ResourceVm.instance.getFontSize($r('app.float.ntf_item_header_height')))
        .layoutWeight(NotificationConfig.LAYOUT_WEIGHT_ONE)
        .margin({ right: $r('app.float.ntf_action_edit_margin_right') })
        .onChange(this.actionButtonVm.onInputChange)
      Image($r('app.media.ic_ntf_action_send'))
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .width($r('app.float.ntf_action_send_icon_size'))
        .height($r('app.float.ntf_action_send_icon_size'))
        .fillColor(this.actionButtonVm.replyContent ? $r('app.color.ntf_action_send_color') :
        $r('app.color.ntf_action_send_disable_color'))
        .onClick(this.actionButtonVm.onClickReply)
    }
    .margin({
      top: $r('app.float.ntf_action_send_margin_top'),
      bottom: $r('app.float.ntf_action_send_margin_bottom')
    })
    .padding({
      left: $r('app.float.ntf_action_send_padding_start_end'),
      right: $r('app.float.ntf_action_send_padding_start_end')
    })
    .width('100%')
  }

  @Builder
  buildActionButton(data: RepeatItem<NotificationAction>) {
    Stack({alignContent: Alignment.Center}) {
      Text(data.item?.actionTitle)
        .draggable(false)
        .fontColor(this.actionButtonVm?.fontColor)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('app.float.ntf_title_font_size'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .borderRadius($r('app.float.ntf_action_button_radius'))
        .opacity(this.actionButtonVm?.fontOpacity)
        .foregroundBrightness(this.actionButtonVm?.fontFgBrightness)
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Medium)
        .lineHeight($r('app.float.ntf_text_line_height_fp'))
        .margin({
          left: $r('app.float.ntf_item_padding_start_end'),
          right: $r('app.float.ntf_item_padding_start_end'),
          top: $r('app.float.ntf_buttons_top_bottom_margin'),
          bottom: $r('app.float.ntf_buttons_top_bottom_margin')
        })
    }
    .id(this.actionButtonVm.getActionButtonId(data.index))
    .onTouch((touchEvent) => {
      this.actionButtonVm.onTouchEvent(touchEvent, data.index);
    })
    .layoutWeight(1)
    .flexShrink(1)
    .backgroundColor(this.actionButtonVm.touchedIndex === data.index ?
    $r('sys.color.ohos_id_color_hover') : Color.Transparent)
    .responseRegion([
      {
        x: 0,
        y: 0,
        width: '100%',
        height: '100%'
      },
      {
        x: 0,
        y: '100%',
        width: '100%',
        height: $r('app.float.ntf_action_button_response_region_height')
      }
    ])
    .onClick(() => {
      this.actionButtonVm.onClickActionButton(data.item, data.index, this.isInGroup);
    })
    .height(NotificationStyle.getActionBtnHeight(this.isFloatingSupported))
  }
}