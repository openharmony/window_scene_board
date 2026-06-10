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

import {
  AccessibilityText,
  INotificationCardVm,
  INotificationNormalVm,
  INotificationSwipeVm,
  INotificationTimeVm,
  NotificationIconView,
  NotificationVmInjector,
  ResourceVm
} from '@ohos/systemuicommon/newIndex';
import { NotificationPinTopView } from './NotificationPinTopView';
import { NotificationTimeView } from './NotificationTimeView';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationConstants } from '../common/NotificationConstants';
import { NotificationStyle } from '../constants/NotificationStyle';
import {
  INotificationPrivacyVm
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationPrivacyVm';
import { NtfMultiLineContent } from '@ohos/systemuicommon/src/main/ets/model/NotificationContent';
import notificationManager from '@ohos.notificationManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AccessibilityManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const TAG = 'NotificationPrivacyView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export enum NotificationIconType {
  NONE,
  APP_ICON_ONLY,
  OVERLAY_ICON_ONLY,
  APP_ICON_AND_OVERLAY_ICON,
}

@ComponentV2
export struct NotificationPrivacyView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require ntf: NotificationBase;
  /**
   * 通知内容动效参数
   */
  @Param textTranAnimParam: TransitionEffect = TransitionEffect.IDENTITY;

  colorVm = this.ntfVmInjector.getColorVm();

  @Computed
  get timeVm(): INotificationTimeVm {
    return this.ntfVmInjector.getTimeVm(this.ntf);
  }

  @Computed
  get normalVm(): INotificationNormalVm {
    return this.ntfVmInjector.getNormalVm(this.privacyVm.latestNotification);
  }

  @Computed
  get privacyVm(): INotificationPrivacyVm {
    return this.ntfVmInjector.getPrivacyVm(this.ntf);
  }

  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.ntfVmInjector.getSwipeVm(this.ntf);
  }

  @Computed get cardVm(): INotificationCardVm | undefined {
    return this.ntfVmInjector.getCardVm(this.ntf);
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear: ${this.ntf.hashCode}`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear: ${this.ntf.hashCode}`);
  }

  build() {
    Column() {
      this.buildNtfCommon()

      if (this.privacyVm?.isExpandedLive) {
        this.buildBottomArea()
      }
    }
    .id(this.normalVm.componentId)
    .width('100%')
    .onGestureJudgeBegin((info) => {
      return this.cardVm?.onGestureJudgeBegin(info);
    })
    .onClick(() => {
      this.privacyVm.onClick();
    })
    .clip(this.normalVm.clip)
    .accessibilityLevel('no')
  }

  @Builder
  buildBottomArea() {
    Row() {
      Text($r('app.string.live_view_hide_tip'))
        .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontWeight('sys.string.ohos_id_text_font_family_regular')
        .wordBreak(WordBreak.BREAK_ALL)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height($r('app.float.live_view_card_hide_bottom_height'))
  }

  @Builder
  buildNtfCommon() {
    Row({ space: 8 }) {
      NotificationIconView({
        scene: this.ntfVmInjector.scene,
        ntf: this.ntf,
        isOnlyUseAppIcon: this.privacyVm.isProtected,
        bigIconOpacity: this.cardVm?.iconAlpha,
        bigIconBgVisible: this.cardVm?.iconBgVisible,
        bigIconBgColor: this.cardVm?.iconBgColor,
        littleIconOpacity: this.cardVm?.topIconAlpha,
        littleIconBgVisible: this.cardVm?.topBgVisible,
        littleIconBgColor: this.cardVm?.topBgColor,
      })

      Column() {
        AccessibilityText({ text: this.ntf.appLabel })
        this.buildNtfTitle()
        this.buildNtfContent()
      }
      .padding({ top: $r('app.float.ntf_content_padding_start_end') })
      .flexShrink(1)
      .flexGrow(1)
      .alignItems(HorizontalAlign.Start)
    }
    .id(this.ntfVmInjector.getId(`${TAG}_${this.ntf.hashCode}`))
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .padding({ left: $r('app.float.ntf_item_padding_start_end'), right: $r('app.float.ntf_item_padding_start_end') })
    .accessibilityGroup(true)
    .accessibilityDescription(this.swipeVm?.getSwipeAccessibilityDescription())
  }

  @Builder
  buildNtfTitle() {
    Row() {
      if (this.privacyVm.isProtected || this.privacyVm.isHidden) {
        this.buildNtfPrivacyTitle(this.ntf.appLabel)
      } else {
        this.buildNtfPrivacyTitle(this.privacyVm.latestNotification.content?.contentTitle)
      }

      Row() {
        // 置顶标识
        if (this.normalVm.isShowPinTop) {
          NotificationPinTopView({
            fontColor: this.cardVm?.pinTopTextColor,
            foregroundBrightness: this.cardVm?.pinTopFgBrightness,
          });
        }

        // 通知时间
        if (!this.ntf.isLiveView()) {
          NotificationTimeView({
            timeVm: this.timeVm,
            colorVm: this.colorVm,
            visibility: this.cardVm?.ntfTimeVisibility,
          })
        }
      }
      .margin({ start: this.normalVm?.timeMarginStart })
      .flexShrink(0)
      .transition(this.textTranAnimParam)
    }
    .width('100%')
    .margin({ bottom: '2vp' })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  buildNtfContent() {
    Row() {
      if (this.privacyVm.isProtected || this.privacyVm.isHidden) {
        this.buildNtfPrivacyContent()
      } else {
        this.buildNtfNormalContent()
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceBetween)
    .transition(this.textTranAnimParam)
  }

  @Builder
  buildNtfPrivacyTitle(title: ResourceStr) {
    Text(title)
      .draggable(false)
      .id(TAG + '_Text_title')
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontWeight(FontWeight.Medium)
      .fontSize(this.privacyVm?.titleFontSize)
      .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
      .fontFeature('\"ss08\" on')
      .fontColor(this.cardVm?.titleFontColor)
      .wordBreak(WordBreak.BREAK_ALL)
      .flexShrink(1)
      .geometryTransition(this.ntf.hashCode + NotificationConstants.NTF_CONTENT_ID +
      this.ntfVmInjector.scene)
      .renderGroup(true)
      .lineHeight(this.privacyVm?.titleLineHeight)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
  }

  /** 加锁通知内容 */
  @Builder
  buildNtfPrivacyContent() {
    Text(this.privacyVm.content)
      .draggable(false)
      .id(TAG + '_Text_content')
      .maxLines(NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .fontWeight(FontWeight.Regular)
      .fontSize($r('app.float.ntf_title_font_size'))
      .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
      .fontFeature('\"ss08\" on')
      .fontColor(this.cardVm?.textFontColor)
      .foregroundBrightness(this.cardVm?.fontFgBrightness)
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .flexShrink(1)
      .padding({ bottom: $r('app.float.ntf_item_padding_start_end') })
      .renderGroup(true)
      .lineHeight($r('app.float.ntf_text_line_height_fp'))
  }

  @Builder
  buildNtfNormalContent() {
    if (this.privacyVm.latestNotification.contentType ===
    notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE) {
      Column() {
        ForEach((this.privacyVm.latestNotification.content as NtfMultiLineContent).linesText.slice(0,
          NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE), (item: string, index?: number) => {
          Text(item)
            .draggable(false)
            .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Regular)
            .fontSize($r('app.float.ntf_title_font_size'))
            .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
            .fontFeature('\"ss08\" on')
            .fontColor(this.colorVm.fontColor)
            .lineHeight($r('app.float.ntf_text_line_height_fp'))
            .wordBreak(WordBreak.BREAK_ALL)
            .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
        }, (item: string) => {
          return item;
        })
      }
      .foregroundBrightness(this.colorVm.fontFgBrightness)
      .alignItems(HorizontalAlign.Start)
      .id(TAG + '_MultiLines')
      .flexShrink(1)
      .padding({
        bottom: $r('app.float.ntf_item_padding_start_end')
      })
      .renderGroup(true)
    } else {
      Text(this.privacyVm.latestNotification.content?.contentText)
        .draggable(false)
        .id(TAG + '_Text_content')
        .maxLines(NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Regular)
        .fontSize($r('app.float.ntf_title_font_size'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .fontFeature('\"ss08\" on')
        .fontColor(this.colorVm.fontColor)
        .foregroundBrightness(this.colorVm.fontFgBrightness)
        .wordBreak(WordBreak.BREAK_ALL)
        .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
        .flexShrink(1)
        .padding({ bottom: $r('app.float.ntf_item_padding_start_end') })
        .renderGroup(true)
        .lineHeight($r('app.float.ntf_text_line_height_fp'))
    }
  }
}