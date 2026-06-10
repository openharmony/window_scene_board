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

import notificationManager from '@ohos.notificationManager';
import { LengthMetrics } from '@kit.ArkUI';
import { ResUtils } from '@ohos/windowscene';
import {
  AccessibilityText,
  INotificationCardVm,
  INotificationNormalVm,
  INotificationSwipeVm,
  INotificationTimeVm,
  INotificationVerticalSwipeVm,
  NotificationIconView,
  NotificationVmInjector,
  ResourceVm
} from '@ohos/systemuicommon/newIndex';
import { NotificationPinTopView } from './NotificationPinTopView';
import { NotificationTimeView } from './NotificationTimeView';
import { NormalNotification, NormalNotificationGroup } from '@ohos/systemuicommon/newTsIndex';
import { NtfMultiLineContent, OverlayIconStyle } from '@ohos/systemuicommon';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationConstants } from '../common/NotificationConstants';
import { NotificationActionButtonView } from './NotificationActionButtonView';
import { NotificationStyle } from '../constants/NotificationStyle';
import { AccessibilityManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'NotificationNormalView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export enum NotificationIconType {
  NONE,
  APP_ICON_ONLY,
  OVERLAY_ICON_ONLY,
  APP_ICON_AND_OVERLAY_ICON,
}

@ComponentV2
export struct NotificationNormalView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require ntf: NormalNotification;
  /**
   * 通知内容动效参数
   */
  @Param textTranAnimParam: TransitionEffect = TransitionEffect.IDENTITY;
  /**
   * 单通知对应的组通知
   */
  @Param groupNtf: NormalNotificationGroup | undefined = undefined;

  colorVm = this.ntfVmInjector.getColorVm();

  @Computed
  get timeVm(): INotificationTimeVm {
    return this.ntfVmInjector.getTimeVm(this.ntf);
  }

  @Computed
  get normalVm(): INotificationNormalVm {
    return this.ntfVmInjector.getNormalVm(this.ntf);
  }

  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.ntfVmInjector.getSwipeVm(this.ntf);
  }

  @Computed get cardVm(): INotificationCardVm | undefined {
    return this.ntfVmInjector.getCardVm(this.ntf);
  }

  @Computed get verticalSwipeVm(): INotificationVerticalSwipeVm | undefined {
    return this.ntfVmInjector.getVerticalSwipeVm();
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear: ${this.ntf.hashCode} ${this.timeVm.timeText}`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear: ${this.ntf.hashCode}`);
  }

  build() {
    Column() {
      this.buildNtfCommon()
      if (this.ntf.actionButtons?.length && this.normalVm.isShowActionButton) {
        NotificationActionButtonView({ ntf: this.ntf, isInGroup: this.groupNtf !== undefined })
      }
    }
    .id(this.normalVm.componentId)
    .opacity(this.verticalSwipeVm?.bannerDeformState.bannerTextOpacity)
    .width('100%')
    .onGestureJudgeBegin((info) => {
      return this.cardVm?.onGestureJudgeBegin(info);
    })
    .onClick(() => {
      this.normalVm.onClick();
    })
    .transition(this.normalVm.transition)
    .clip(this.normalVm.clip)
    .accessibilityDescription(this.cardVm?.accessibilityDescription)
    .accessibilityLevel('yes')
  }

  @Builder
  buildNtfCommon() {
    Row({ space: 12 }) {
      if (this.groupNtf && this.ntf.overlayIcon && this.ntf.overlayIconStyle !== OverlayIconStyle.REVERSE) {
        NotificationIconView({
          needGeometryTransition: this.groupNtf?.children.length === 1,
          scene: this.ntfVmInjector.scene,
          ntf: this.ntf,
          isHideLittleIcon: true,
          opacity: this.normalVm.isExpandImmersive ? 0 : 1,
        })
      } else if (!this.groupNtf) {
        NotificationIconView({
          needGeometryTransition: true,
          scene: this.ntfVmInjector.scene,
          ntf: this.ntf,
          opacity: this.normalVm.isExpandImmersive ? 0 : 1,
          renderGroup: this.ntf.overlayIcon ? true : false,
          bigIconOpacity: this.cardVm?.iconAlpha,
          bigIconBgVisible: this.cardVm?.iconBgVisible,
          bigIconBgColor: this.cardVm?.iconBgColor,
          littleIconOpacity: this.cardVm?.topIconAlpha,
          littleIconBgVisible: this.cardVm?.topBgVisible,
          littleIconBgColor: this.cardVm?.topBgColor,
          geometryTransitionId: this.cardVm?.getComponentGeometryId(NotificationConstants.NTF_BIG_ICON_ID)
        })
      }

      Column() {
        AccessibilityText({ text: this.ntf.appLabel })
        this.buildNtfTitle()
        this.buildNtfContent()
      }
      .layoutWeight(1)
      .padding({ top: $r('app.float.ntf_content_padding_start_end') })
      .alignItems(HorizontalAlign.Start)
    }
    .id(this.normalVm.bodyComponentId)
    .opacity(this.normalVm.bodyOpacity)
    .height(this.normalVm.height)
    .width('100%')
    .padding({ left: $r('app.float.ntf_item_padding_start_end'), right: $r('app.float.ntf_item_padding_start_end') })
    .alignItems(VerticalAlign.Center)
    .accessibilityGroup(AccessibilityManager.getInstance().getIsAccessibilityMode())
    .accessibilityDescription(this.swipeVm?.getSwipeAccessibilityDescription())
  }

  @Builder
  buildNtfTitle() {
    Row() {
      Text(this.normalVm.ntfTitle)
        .draggable(false)
        .id(this.normalVm.titleComponentId)
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Medium)
        .fontSize($r('app.float.ntf_title_font_size'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .fontFeature('\"ss08\" on')
        .fontColor(this.cardVm?.titleFontColor)
        .wordBreak(WordBreak.BREAK_ALL)
        .flexShrink(1)
        .geometryTransition(this.cardVm?.getComponentGeometryId(NotificationConstants.NTF_TITLE_ID),
          { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
        .renderGroup(true)
        .lineHeight($r('app.float.ntf_text_line_height_fp'))
        .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
        .opacity(this.normalVm.isExpandImmersive ? 0 : 1)

      Row() {
        // 置顶标识, 组通知内的子通知不展示
        if (!this.groupNtf && this.normalVm.isShowPinTop && !this.normalVm.isEmergencyNtf) {
          NotificationPinTopView({
            fontColor: this.cardVm?.pinTopTextColor,
            foregroundBrightness: this.cardVm?.pinTopFgBrightness,
            geometryTransitionId: this.cardVm?.getComponentGeometryId(NotificationConstants.NTF_PIN_TOP_ID),
          })
        }

        // 通知时间
        NotificationTimeView({
          timeVm: this.timeVm,
          colorVm: this.colorVm,
          geometryTransitionId: this.cardVm?.getComponentGeometryId(NotificationConstants.NTF_TIME_ID),
          visibility: this.cardVm?.ntfTimeVisibility,
        })
      }
      .margin({ start: this.normalVm?.timeMarginStart })
      .flexShrink(0)
      .translate(this.normalVm.timeTranslate)
    }
    .width('100%')
    .margin({ bottom: '2vp' })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  buildNtfContent() {
    Row() {
      this.buildNtfTextContent()
      if (this.ntf.largeIcon) {
        Image(this.ntf.largeIcon)
          .id(this.ntfVmInjector.getId(`${TAG}_largeIcon_${this.ntf.hashCode}`))
          .draggable(false)
          .objectFit(ImageFit.Cover)
          .width($r('app.float.ntf_item_right_icon_size'))
          .height($r('app.float.ntf_item_right_icon_size'))
          .borderRadius($r('app.float.ntf_item_right_icon_radius'))
          .flexShrink(0)
          .margin({
            start: LengthMetrics.vp(ResUtils.getNumber($r('app.float.ntf_item_padding_start_end'))),
            bottom: LengthMetrics.vp(6)
          })
          .interpolation(ImageInterpolation.Medium)
          .autoResize(false)
          .opacity(this.cardVm?.iconAlpha)
      }
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceBetween)
    .translate(this.normalVm.contentTranslate)
    .geometryTransition(this.cardVm?.getComponentGeometryId(NotificationConstants.NTF_CONTENT_ID),
      { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
  }

  @Builder
  buildNtfTextContent() {
    if (this.ntf.contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE &&
    (this.ntf.content as NtfMultiLineContent).linesText.some(text => text)) {
      Column() {
        ForEach((this.ntf.content as NtfMultiLineContent).linesText.slice(0,
          NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE), (item: string, index?: number) => {
          Text(item)
            .draggable(false)
            .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .fontWeight(FontWeight.Regular)
            .fontSize($r('app.float.ntf_title_font_size'))
            .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
            .fontFeature('\"ss08\" on')
            .fontColor(this.cardVm?.textFontColor)
            .lineHeight($r('app.float.ntf_text_line_height_fp'))
            .wordBreak(WordBreak.BREAK_ALL)
            .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
            .onClick(()=>{
              this.normalVm.onClickMultiContent(item, index);
            })
        }, (item: string) => {
          return item;
        })
      }
      .foregroundBrightness(this.cardVm?.fontFgBrightness)
      .alignItems(HorizontalAlign.Start)
      .flexShrink(1)
      .padding({
        bottom: $r('app.float.ntf_item_padding_start_end')
      })
      .renderGroup(!this.normalVm.hasEmojiInMultiLines())
      .transition(TransitionEffect.IDENTITY)
    } else {
      Text(this.normalVm.ntfContent)
        .draggable(false)
        .maxLines(NotificationConfig.ITEM_CONTENT_MAX_LINE_PHONE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Regular)
        .fontSize($r('app.float.ntf_title_font_size'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .fontFeature('\"ss08\" on')
        .fontColor(this.cardVm?.textFontColor)
        .foregroundBrightness(this.cardVm?.fontFgBrightness)
        .wordBreak(WordBreak.BREAK_ALL)
        .flexShrink(1)
        .padding({ bottom: $r('app.float.ntf_item_padding_start_end') })
        .renderGroup(this.normalVm.isRenderGroup)
        .lineHeight($r('app.float.ntf_text_line_height_fp'))
        .transition(TransitionEffect.IDENTITY)
    }
  }
}