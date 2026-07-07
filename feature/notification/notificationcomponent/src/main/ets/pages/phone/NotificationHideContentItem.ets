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

import { NotificationEntry, NtfDataUpdateListener } from '../../model/NotificationEntry';
import { NotificationConfig } from '../../common/NotificationConfig';
import { CommonUtils } from '@ohos/basicutils';
import { NtfAppIconModifier } from '../../vm/style/NtfAppIconModifier';
import { DateTimeView } from '@ohos/customcomponent/src/main/ets/pages/DateTimeView';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AodStyleType,
  FontScaleState,
  fontScaleManager,
  ImmersiveAodStyle,
  immersiveKgMgr,
  ObservedItem,
  OverlayIconStyle
} from '@ohos/systemuicommon';
import { notificationStyle } from '../../vm/style/NotificationStyle';
import { NotificationItemStyle } from '../../vm/style/NotificationItemStyle';
import { BrightnessOptionUtils, NotificationType } from '@ohos/systemuicommon/Index';
import { NtfColorModeVM } from '../../vm/NtfColorModeVM';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { LengthMetrics } from '@kit.ArkUI';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { DeliverBadge } from '@ohos/systemuicommon/src/main/ets/view/DeliverBadge';

const TAG = 'NotificationHideContentItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Component
export struct NotificationHideContentItem {
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  /**
   * 通知数据
   */
  @Consume ntfEntry: NotificationEntry;
  /**
   * 隐藏通知内容显示的文字
   */
  @Consume contentHideText: string;

  /**
   * 通知是否置顶显示
   */
  @State isDisplayAtTop: boolean = false;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * AOD显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(
    this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD);
  /**
   * 应用名称
   */
  @State appName?: ObservedItem<string> = undefined;

  /**
   * 通知条目样式
   */
  @State itemStyle: NotificationItemStyle = notificationStyle.item;

  @State colorModeVM: NtfColorModeVM | undefined = undefined;

  @State protectedVm: AppProtectedVm = AppProtectedVm.get();

  /**
   * 获取通知数据
   * SingleItemCallback
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry {
    return this.ntfEntry;
  }

  /**
   * 监听通知是否置顶
   */
  private ntfDataUpdateListener: NtfDataUpdateListener = {
    onNtfDataUpdate: (newEntry: NotificationEntry): void => {
      this.ntfEntry = newEntry;
      if (this.ntfEntry) {
        // 通知是否置顶显示
        this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
      }
    }
  }

  aboutToAppear() {
    this.appName = this.ntfEntry?.appName;
    this.ntfEntry?.registerDataUpdateListener(this.ntfDataUpdateListener);
    this.isDisplayAtTop = this.ntfEntry?.isDisplayAtTop;
    log.showInfo(`aboutToAppear, this.isDisplayAtTop = ${this.isDisplayAtTop}`)
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`);
    this.ntfEntry?.unregisterDataUpdateListener(this.ntfDataUpdateListener);
  }

  @Builder
  ContentBuilder() {
    Text(this.contentHideText)
      .draggable(false)
      .id(TAG + '_Text_SingleHideText')
      .fontWeight(FontWeight.Regular)
      .fontSize($r('app.float.ntf_title_font_size'))
      .maxFontScale(FontScaleState.systemUIMaxScale)
      .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.CARD_SECONDARY_FONT_COLOR) :
        this.colorModeVM?.themeFontForegroundColor)
      .foregroundBrightness(this.aodStyle?.isAod ? this.colorModeVM?.themeFontForegroundOptions :
        this.colorModeVM?.themeFontForegroundBrightnessOptions)
      .lineHeight(this.fontScaleState.getScaleSize($r('app.float.ntf_text_line_height')))
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .margin({ top: $r('app.float.ntf_hide_content_margin_top') })
  }

  @Builder
  buildPinTop() {
    Text($r('app.string.topped_notification_flag'))
      .draggable(false)
      .id(TAG + '_ntf_flag')
      .border({
        width: $r('app.float.ntf_pin_top_flag_border_width'),
        color: this.aodStyle?.isAod
          ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR)
          : this.colorModeVM?.bgPinTextColor,
        radius: $r('app.float.ntf_pin_top_flag_border_radius'),
        style: BorderStyle.Solid
      })
      .padding({
        top: $r('app.float.ntf_pin_top_flag_padding_vertical'),
        bottom: $r('app.float.ntf_pin_top_flag_padding_vertical'),
        left: $r('app.float.ntf_pin_top_flag_padding_horizontal'),
        right: $r('app.float.ntf_pin_top_flag_padding_horizontal')
      })
      .fontSize($r('app.float.ntf_pin_top_flag_font_size'))
      .fontWeight(FontWeight.Medium)
      .margin({ end: LengthMetrics.vp(ResUtils.getNumber($r('app.float.ntf_hidden_pin_top_time_margin'))) })
      .fontColor(this.aodStyle?.isAod
        ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR)
        : this.colorModeVM?.bgPinTextColor)
      .foregroundBrightness(this.aodStyle?.isAod ? BrightnessOptionUtils.aodTimeLightOptionForFillColor :
        this.colorModeVM?.themeTimestampForegroundBrightnessOptions)
  }

  build() {
    if (!CommonUtils.isInvalid(this.ntfEntry)) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        if (this.ntfEntry?.overlayIconStyle !== OverlayIconStyle.REVERSE) {
          this.buildSingleIcon()
        } else {
          this.buildOverlayIcon()
        }

        Column() {
          Row() {
            Text(this.appName?.value)
              .draggable(false)
              .id(TAG + '_AppName')
              .fontSize($r('app.float.ntf_title_font_size'))
              .maxFontScale(FontScaleState.systemUIMaxScale)
              .fontColor(this.aodStyle?.isAod ? this.aodStyle?.getStyleValue(AodStyleType.FONT_COLOR) :
              $r('app.color.theme_ntf_color_text_primary'))
              .fontWeight(FontWeight.Medium)
              .maxLines(NotificationConfig.LAYOUT_WEIGHT_ONE)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .renderGroup(this.aodStyle?.isOneMirror ? false : true)
              .flexShrink(1)

            Row() {
              // 置顶标识
              if (this.isDisplayAtTop) {
                this.buildPinTop()
              }

              // 通知时间
              DateTimeView({
                slot: this.getNtfEntry().hashCode,
                timeMillis: this.ntfEntry?.deliveryTime,
                fontSize: $r('app.float.ntf_app_name_font_size'),
                fontColor: $r('app.color.theme_ntf_color_text_primary')
              })
                .opacity(0.4)
                .flexShrink(0)
                .visibility(this.aodStyle?.isAod ? Visibility.Hidden : Visibility.Visible)
            }
            .margin({
              start: LengthMetrics.vp(ResUtils.getNumber($r('app.float.ntf_item_padding_start_end'))),
            })
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)
          .height(this.fontScaleState.getScaleSize($r('app.float.ntf_text_title_height')))
          // 隐藏通知内容，显示 几个通知
          this.ContentBuilder()
        }
        .alignItems(HorizontalAlign.Start)
        .flexShrink(1)
        .flexGrow(1)
        .padding({
          start: LengthMetrics.vp(ResUtils.getNumber($r('app.float.ntf_item_padding_start_end')))
        })
      }
      .width('100%')
    }
  }

  @Builder
  buildSingleIcon() {
    Image(this.ntfEntry?.getAppIcon(true))
      .id(this.ntfEntry?.hashCode + '_app_icon')
      .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'), $r('app.float.ntf_item_right_icon_radius')))
      .flexShrink(0)
      .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_APP_ICON_ALPHA) : undefined)
  }

  @Builder
  buildOverlayIcon() {
    Stack() {
      Image(this.ntfEntry?.getAppIcon(true))
        .id(this.ntfEntry?.hashCode + '_app_icon')
        .attributeModifier(new NtfAppIconModifier($r('app.float.ntf_small_icon_size_phone'),
          $r('app.float.ntf_item_right_icon_radius')))
        .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_APP_ICON_ALPHA) : undefined)
      DeliverBadge({
        isKgScene: this.notificationType === NotificationType.TYPE_PHONE_KEYGUARD,
      })
    }
    .flexShrink(0)
    .width($r('app.float.ntf_small_icon_size_phone'))
    .height($r('app.float.ntf_small_icon_size_phone'))
  }
}
