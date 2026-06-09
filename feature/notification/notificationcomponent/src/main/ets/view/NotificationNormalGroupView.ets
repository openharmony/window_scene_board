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

import { curves, LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  NotificationVmInjector,
  INotificationNormalGroupVm,
  INotificationSwipeVm,
  INotificationMenuVm,
  INotificationTimeVm,
  ResourceVm,
  AccessibilityText,
  NotificationIconView,
  NOTIFICATION_ICON_SMALL_SCALE,
  INotificationCardVm,
} from '@ohos/systemuicommon/newIndex';
import { NotificationTimeView } from './NotificationTimeView';
import { NotificationPinTopView } from './NotificationPinTopView';
import { NotificationAppNameView } from './NotificationAppNameView';
import { NotificationNormalGroupItemView } from './NotificationNormalGroupItemView';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationConstants } from '../common/NotificationConstants';
import { NormalNotification, NormalNotificationGroup } from '@ohos/systemuicommon/newTsIndex';
import { NotificationStyle } from '../constants/NotificationStyle';
import { image } from '@kit.ImageKit';

const TAG = 'NotificationNormalGroupView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 展开组最多展示数量
 */
const GROUP_EXPAND_MAX_SHOW_SIZE = 8;

/**
 * 折叠组展示数量
 */
const GROUP_COLLAPSE_MAX_SHOW_SIZE = 3;

@ComponentV2
export struct NotificationNormalGroupView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require ntf: NormalNotificationGroup;

  colorVm = this.ntfVmInjector.getColorVm();
  @Computed get menuVm(): INotificationMenuVm | undefined {
    return this.ntfVmInjector.getMenuVm(this.ntf);
  }
  @Computed get normalGroupVm(): INotificationNormalGroupVm | undefined {
    return this.ntfVmInjector.getNormalGroupVm(this.ntf);
  }
  @Computed get timeVm(): INotificationTimeVm {
    return this.ntfVmInjector.getTimeVm(this.ntf);
  }
  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    return this.ntfVmInjector.getSwipeVm(this.ntf);
  }
  @Computed get cardVm(): INotificationCardVm {
    return this.ntfVmInjector.getCardVm(this.ntf);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear, ${this.ntf.hashCode}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear, ${this.ntf.hashCode}`);
  }

  build() {
    if (this.normalGroupVm?.isExpanded) {
      Column() {
        this.buildGroupHeader()
        this.buildDivider()
        // 不使用repeat原因：删除子通知时，repeat会复用组件，导致新的子通知从被删除位置出现，动效异常
        ForEach(this.normalGroupVm?.children?.slice(0, GROUP_EXPAND_MAX_SHOW_SIZE),
          (data: NormalNotification, index) => {
            if (this.normalGroupVm?.isFrameValid(index)) {
              NotificationNormalGroupItemView({ groupNtf: this.ntf, ntf: data })
              if (index < (this.normalGroupVm?.children?.length ?? 0) - 1) {
                this.buildDivider(data.overlayIcon)
              }
            } //index不要删，会影响key生成，不使用Hashcode做key，会导致按钮信息更新UI渲染不同步问题
          }, (data: NormalNotification, index) => data.uid)
      }
      .id(this.normalGroupVm?.componentId)
      .transition(this.normalGroupVm?.iconTransition)
      .width('100%')
    } else {
      Row({ space: 12 }) {
        AccessibilityText({ text: $r('app.string.cc_accessibility_str_ntf_swipe_right_text') })
        AccessibilityText({ text: this.ntf.appLabel })
        this.buildBriefIcon()
        this.buildBriefContent()
      }
      .id(this.normalGroupVm?.componentId)
      .transition(this.normalGroupVm?.iconTransition)
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .padding({
        left: $r('app.float.ntf_item_padding_start_end'),
        right: $r('app.float.ntf_item_padding_start_end'),
        top: $r('app.float.ntf_item_padding_start_end'),
        bottom: $r('app.float.ntf_item_padding_start_end')
      })
      .onGestureJudgeBegin((info) => {
        return this.cardVm?.onGestureJudgeBegin(info);
      })
      .onClick(() => {
        this.normalGroupVm?.onClick(this.menuVm?.isMenuExpanded() ?? false);
      })
      .accessibilityGroup(true)
      .accessibilityDescription(this.swipeVm?.getSwipeAccessibilityDescription())
    }
  }

  @Builder
  buildGroupHeader() {
    Row() {
      AccessibilityText({ text: $r('app.string.cc_accessibility_str_ntf_swipe_left_text') })
      this.buildGroupExpandIcon()

      NotificationAppNameView({
        ntf: this.ntf,
        textFontColor: this.cardVm?.titleFontColor
      })

      Blank()

      if (this.ntf.isDisplayAtTop) {
        NotificationPinTopView({
          fontColor: this.cardVm?.pinTopTextColor,
          foregroundBrightness: this.cardVm?.pinTopFgBrightness,
          geometryTransitionId: this.cardVm.getComponentGeometryId(NotificationConstants.NTF_PIN_TOP_ID),
        });
      }

      // 展开/收起按钮
      Image($r('app.media.ic_ntf_arrow_up'))
        .id(this.ntfVmInjector.getId(`${TAG}_ntfArrowUp_${this.ntf.hashCode}`))
        .objectFit(ImageFit.Fill)
        .hitTestBehavior(HitTestMode.None)
        .width($r('app.float.ntf_arrow_width'))
        .height($r('app.float.ntf_arrow_height'))
        .fillColor(this.colorVm.ntfThemeTextSecondaryColor)
        .opacity(NotificationConfig.NTF_ARROW_ICON_ALPHA)
        .transition(TransitionEffect.translate({ y: 5 })
          .animation({
            delay: 50,
            duration: 100,
            curve: curves.cubicBezierCurve(0.20, 0.00, 0.20, 1.0)
          }))
    }
    .id(this.normalGroupVm?.headerComponentId)
    .width('100%')
    .padding({
      left: $r('app.float.ntf_item_padding_start_end'),
      right: $r('app.float.ntf_item_padding_start_end'),
      top: $r('app.float.ntf_small_icon_offset_phone'),
      bottom: $r('app.float.ntf_header_common_margin'),
    })
    .onClick(() => {
      this.normalGroupVm?.onClick(this.menuVm?.isMenuExpanded() ?? false);
    })
  }

  @Builder
  buildGroupExpandIcon() {
    NotificationIconView({
      scene: this.ntfVmInjector.scene,
      ntf: this.ntf,
      scale: NOTIFICATION_ICON_SMALL_SCALE,
      needGeometryTransition: true,
      // 组通知标题，通过修改geometryTransitionId，分别和组通知折叠态应用图标、单通知图标进行转场动效
      geometryTransitionId: this.normalGroupVm?.getGeometryTransitionId(),
      bigIconOpacity: this.cardVm?.iconAlpha,
      bigIconBgVisible: this.cardVm?.iconBgVisible,
      bigIconBgColor: this.cardVm?.iconBgColor,
      isOnlyUseAppIcon: true
    })
  }

  @Builder
  buildRemainderCount() {
    Stack({ alignContent: Alignment.Center }) {
      // 标示通知个数
      Text(this.normalGroupVm?.remainderCount)
        .draggable(false)
        .id(TAG + '_Text_groupRemainderCount')
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .fontSize($r('app.float.ntf_remainder_count_font_size'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .lineHeight($r('app.float.ntf_remain_count_lineHeight'))
        .fontWeight(FontWeight.Medium)
        .fontColor(this.normalGroupVm?.remainderCountFontColor)
        .foregroundBrightness(this.normalGroupVm?.remainderCountFgBrightness)
        .flexShrink(0)
        .opacity(0.6)
    }
    .width(ResourceVm.instance.getFontSize($r('app.float.nft_brief_remain_count_width')))
    .flexShrink(0)
    .margin({
      start: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')),
      top: $r('app.float.ntf_header_common_margin_top')
    })
    .borderRadius('14vp')
    .backgroundColor(this.normalGroupVm?.remainderCountBgColor)
    .backgroundBrightnessInternal(this.normalGroupVm?.remainderCountBgBrightness)
    .transition(TransitionEffect.translate({ y: this.normalGroupVm?.isExpanded ? '30' : '0' })
      .animation({
        duration: 100,
        curve: curves.cubicBezierCurve(0.20, 0.00, 0.20, 1.0)
      }))
  }

  @Builder
  buildContent(entry: NormalNotification, index?: number) {
    Flex() {
      // 第一条通知标题 摘要
      Text() {
        // 通知标题
        Span(this.normalGroupVm?.getBriefTitleText(entry))
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.ntf_title_font_size'))
          .fontColor(this.normalGroupVm?.titleFontColor)
        // 这里利用中文空格，并设置宽度为8vp，使其达到8vp的宽度占用
        if (!ResourceVm.instance.isRTL) {
          Span('\u3000')
          .fontColor(Color.Transparent)
          .fontSize($r('app.float.ntf_group_brief_title_and_content_margin_fp'))
        }
      }
      .fontFeature('\"ss08\" on')
      .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
      .lineHeight($r('app.float.ntf_text_title_line_height_fp'))
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .wordBreak(WordBreak.BREAK_ALL)
      .geometryTransition(this.cardVm?.isSaveGroupNtf ? '' :
        entry.key + NotificationConstants.NTF_TITLE_ID + this.ntfVmInjector.scene +
          (this.ntf.isMoreNtf() ? NotificationConstants.NTF_MORE_SUFFIX : NotificationConstants.NTF_MAIN_SUFFIX),
        { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
      .flexShrink(0)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .renderGroup(this.normalGroupVm?.isRenderGroup(this.normalGroupVm?.getBriefTitleText(entry)))

      // 第一条通知标题 摘要
      Text() {
        if (ResourceVm.instance.isRTL) {
          Span('\u3000')
            .fontColor(Color.Transparent)
            .fontSize($r('app.float.ntf_group_brief_title_and_content_margin_fp'))
        }
        // 通知摘要
        Span(this.normalGroupVm?.getBriefContentText(entry))
          .fontWeight(FontWeight.Regular)
          .fontSize($r('app.float.ntf_title_font_size'))
          .fontColor(this.normalGroupVm?.textFontColor)
      }
      .fontFeature('\"ss08\" on')
      .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
      .lineHeight($r('app.float.ntf_text_title_line_height_fp'))
      .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .wordBreak(WordBreak.BREAK_ALL)
      .flexShrink(1)
      .transition(this.normalGroupVm?.getBriefTextAnimation(index ?? 0))
      .padding({ end: LengthMetrics.resource($r('app.float.ntf_pin_top_flag_padding_horizontal'))})
      .textAlign(TextAlign.Start)
      .renderGroup(this.normalGroupVm?.isRenderGroup(this.normalGroupVm?.getBriefContentText(entry)))
      .layoutWeight(1)
      .foregroundBrightness(this.normalGroupVm?.fontFgBrightness)
    }
    .draggable(false)
    .flexShrink(1)
    .margin({ top: (index !== 0) ? '4vp' : undefined })
  }

  @Builder
  buildBriefIcon() {
    NotificationIconView({
      scene: this.ntfVmInjector.scene,
      ntf: this.ntf,
      needGeometryTransition: true,
      bigIconOpacity: this.cardVm?.iconAlpha,
      bigIconBgVisible: this.cardVm?.iconBgVisible,
      bigIconBgColor: this.cardVm?.iconBgColor,
      isOnlyUseAppIcon: true
    })
  }

  @Builder
  buildBriefContent() {
    Column() {
      // 隐藏通知内容，显示几个通知
      if (this.normalGroupVm?.isHideNtfContent) {
        Row() {
          NotificationAppNameView({
            ntf: this.ntf,
            textFontColor: this.cardVm?.titleFontColor
          })

          Row() {
            // 置顶标识
            if (this.ntf.isDisplayAtTop) {
              NotificationPinTopView({
                fontColor: this.cardVm?.pinTopTextColor,
                foregroundBrightness: this.cardVm?.pinTopFgBrightness,
                geometryTransitionId: this.cardVm.getComponentGeometryId(NotificationConstants.NTF_PIN_TOP_ID),
              });
            }
            // 通知时间
            if (this.timeVm) {
              NotificationTimeView({
                timeVm: this.timeVm,
                colorVm: this.colorVm,
                visibility: this.cardVm?.ntfTimeVisibility,
              })
            }
          }
          .margin({ left: $r('app.float.ntf_item_padding_start_end') })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceBetween)

        Text(this.normalGroupVm.hideText)
          .draggable(false)
          .id(TAG + '_Text_groupCountHideText')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.ntf_title_font_size'))
          .fontColor(this.normalGroupVm?.hideFontColor)
          .lineHeight($r('app.float.ntf_text_line_height'))
          .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: '2vp' })
      } else { // 正常摘要
        ForEach(this.normalGroupVm?.children?.slice(0, GROUP_COLLAPSE_MAX_SHOW_SIZE),
          (entry: NormalNotification, index?: number) => {
            this.buildBriefContentItem(entry, index);
          }, (entry: NormalNotification) => entry.uid)
      }
    }
    .flexShrink(1)
    .alignItems(HorizontalAlign.Start)
    .transition(TransitionEffect.OPACITY)
  }

  @Builder
  buildBriefContentItem(entry: NormalNotification, index?: number) {
    Row() {
      this.buildContent(entry, index);

      if (index === 0 && (this.ntf.isDisplayAtTop || this.normalGroupVm?.isShowDateTime)) {
        Row() {
          if (this.ntf.isDisplayAtTop) {
            NotificationPinTopView({
              fontColor: this.cardVm?.pinTopTextColor,
              foregroundBrightness: this.cardVm?.pinTopFgBrightness,
              geometryTransitionId: this.cardVm.getComponentGeometryId(NotificationConstants.NTF_PIN_TOP_ID),
            })
          }

          // 通知时间
          if (this.timeVm) {
            NotificationTimeView({
              timeVm: this.timeVm,
              colorVm: this.colorVm,
              geometryTransitionId: this.cardVm.getComponentGeometryId(NotificationConstants.NTF_TIME_ID),
              visibility: this.cardVm?.ntfTimeVisibility,
            })
          }
        }
        .margin({ start: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')) })
        .flexShrink(0)
      }

      if (index === 2 && this.normalGroupVm?.remainderCount) {
        this.buildRemainderCount();
      }
    }
    .height((index === 0) ? 'auto' : undefined)
    .width('100%')
    .alignItems((index === 0) ? VerticalAlign.Center : VerticalAlign.Bottom)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  buildDivider(overlayIcon?: image.PixelMap) {
    Divider()
      .strokeWidth('1px')
      .color(this.colorVm.groupDividerColor)
      .foregroundBrightness(this.colorVm.dividerFgBrightness)
      .padding({
        start: LengthMetrics.resource((overlayIcon ? $r('app.float.ntf_center_header_phone_land_height') :
        $r('app.float.ntf_item_padding_start_end'))),
        end: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end'))
      })
      .transition(TransitionEffect.OPACITY.animation({
        duration: 333,
        curve: curves.cubicBezierCurve(0.20, 0.00, 0.20, 1.0)
      }))
  }
}
