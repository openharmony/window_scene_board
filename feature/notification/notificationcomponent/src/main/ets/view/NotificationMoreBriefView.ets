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

import { LogDomain } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { Logger } from '@ohos/basicutils/src/main/ets/utils/Logger';
import { NotificationTimeView } from './NotificationTimeView';
import {
  AccessibilityText,
  INotificationMoreVm,
  INotificationSwipeVm, INotificationTimeVm,
  NotificationIconView,
  NotificationVmInjector,
} from '@ohos/systemuicommon/newIndex';
import { NotificationBase } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { NotificationConfig } from '../common/NotificationConfig';
import { NotificationStyle } from '../constants/NotificationStyle';
import { LengthMetrics } from '@kit.ArkUI';
import { NtfAnimationConsts } from '../common/NtfAnimationConsts';

const TAG = 'NotificationMoreBriefView';
const log: Logger = Logger.getLogHelper(LogDomain.NC);

@ComponentV2
export struct NotificationMoreBriefView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  private moreNtfVm = this.ntfVmInjector.getMoreVm();
  private hearVm = this.ntfVmInjector.getNotificationMoreHeaderVm();
  private colorVm = this.ntfVmInjector.getColorVm();
  private listVm = this.ntfVmInjector.getListVm()!;

  @Computed get timeVm(): INotificationTimeVm | undefined {
    if (!this.moreNtfVm?.moreNtfAppList.length) {
      return undefined;
    }
    return this.ntfVmInjector.getTimeVm(this.moreNtfVm.moreNtfAppList[0]);
  }

  @Computed get swipeVm(): INotificationSwipeVm | undefined {
    if (!this.moreNtfVm?.moreNtfAppList.length) {
      return undefined;
    }
    return this.ntfVmInjector.getSwipeVm(this.moreNtfVm.moreNtfAppList[0]);
  }

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear`);
    this.moreNtfVm?.getTextTranEffectWhenCollapsed();
    this.moreNtfVm?.getIconTranEffectWhenCollapsed();
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear`);
  }

  build() {
    Column() {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        AccessibilityText({ text: $r('app.string.cc_accessibility_str_ntf_swipe_right_text') })
        this.buildIcons()
        this.buildContent()
      }
      .backgroundColor(this.moreNtfVm?.getMoreBriefBgColor())
      .backgroundBrightnessInternal(this.colorVm?.cardBgBrightness)
      .padding({
        left: $r('app.float.ntf_item_padding_start_end'),
        right: $r('app.float.ntf_item_padding_start_end'),
      })
    }
    .id(this.ntfVmInjector.getId(TAG))
    .borderRadius(NotificationConfig.BORDER_RADIUS)
    .clip(true)
    .useEffect(true)
    .onClick(() => {
      if (this.swipeVm?.offsetX !== 0) {
        this.swipeVm?.resetOffsetX(true);
      }
      this.hearVm?.toggleCollapsed(true);
    })
    .accessibilityDescription(this.swipeVm?.getSwipeAccessibilityDescription())
  }

  @Builder
  buildIcons() {
    Stack({ alignContent: Alignment.Start }) {
      ForEach(this.listVm.moreNtfList.slice(0, Math.min(3, this.listVm.moreNtfList.length)),
        (ntf: NotificationBase, index: number) => {
          this.buildIcon(ntf);
        }, (ntf: NotificationBase, index: number) => ntf.groupKey)
    }
    .width(this.moreNtfVm?.getIconWidth())
    .flexShrink(0)
    .flexGrow(1)
    .renderGroup(true)
  }

  @Builder
  buildIcon(ntf: NotificationBase) {
    NotificationIconView({
      scene: this.ntfVmInjector.scene,
      ntf: ntf,
      isHideLittleIcon: true,
      isOnlyUseAppIcon: true,
      modifier: new MoreBriefIconModifier(ntf, this.moreNtfVm),
      animation: { curve: NtfAnimationConsts.EXTRA_NTF_EXPAND_CURVE },
    })
  }

  @Builder
  buildContent() {
    Column() {
      Row() {
        Text() {
          // 通知标题
          Span($r('app.string.ntf_extra_message_brief_title'))
            .fontWeight(FontWeight.Medium)
            .fontSize($r('app.float.ntf_title_font_size'))
            .fontColor($r('app.color.theme_ntf_color_text_primary'))
        }
        .textAlign(TextAlign.Start)
        .fontFeature('\"ss08\" on')
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .lineHeight($r('app.float.ntf_extra_brief_title_lineHeight_fp'))
        .maxLines(NotificationConfig.ITEM_CONTENT_SINGLE_LINE)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .draggable(false)
        .flexShrink(1)
        .renderGroup(true)
        .margin({ end: LengthMetrics.resource($r('app.float.ntf_item_padding_start_end')) })
        .transition(this.moreNtfVm?.textTranEffect)

        // 通知时间
        if (this.timeVm) {
          NotificationTimeView({ timeVm: this.timeVm, colorVm: this.colorVm })
        }
      }
      .margin({ bottom: $r('app.float.ntf_extra_brief_header_margin_bottom') })
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      Text($r('app.string.ntf_extra_message_brief_content', this.moreNtfVm?.briefContent))
        .draggable(false)
        .id(`${TAG}_Brief_Content`)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .fontWeight(FontWeight.Regular)
        .fontSize($r('app.float.ntf_title_font_size'))
        .maxFontScale(NotificationStyle.DEFAULT_MAX_SCALE)
        .fontFeature('\"ss08\" on')
        .fontColor(this.colorVm?.fontColor)
        .foregroundBrightness(this.colorVm?.fontFgBrightness)
        .lineHeight($r('app.float.ntf_text_line_height_fp'))
        .textAlign(TextAlign.Start)
        .renderGroup(true)
        .transition(this.moreNtfVm?.textTranEffect)
    }
    .padding({start: LengthMetrics.resource( $r('app.float.ntf_item_padding_start_end')) })
    .margin({
      bottom: $r('app.float.ntf_extra_brief_main_margin_bottom'),
      top: $r('app.float.ntf_extra_brief_main_margin_top')
    })
    .flexBasis('auto')
    .alignItems(HorizontalAlign.Start)
  }
}

class MoreBriefIconModifier implements AttributeModifier<StackAttribute> {
  public ntf: NotificationBase;
  public moreNtfVm?: INotificationMoreVm;

  constructor(ntf: NotificationBase, moreNtfVm?: INotificationMoreVm) {
    this.ntf = ntf;
    this.moreNtfVm = moreNtfVm;
  }

  applyNormalAttribute(instance: StackAttribute): void {
    instance
      .offset({ x: this.moreNtfVm?.getStartMargin(this.ntf) })
      .zIndex(this.moreNtfVm?.getZIndex(this.ntf))
      .transition(this.moreNtfVm?.getIconAnimation(this.ntf))
  }
}