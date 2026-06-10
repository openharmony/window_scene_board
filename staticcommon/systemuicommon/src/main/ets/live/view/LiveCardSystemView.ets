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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LengthMetrics } from '@ohos.arkui.node';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveNotification } from '../model/LiveNotification';
import { NotificationIconView } from '../../view/NotificationIconView';
import { LiveVmInjector } from '../LiveVmInjector';
import { ILiveCardSystemVm } from '../interface/ILiveCardSystemVm';
import { LiveCardSystemProgressView } from './LiveCardSystemProgressView';
import { LiveCardSystemModel } from '../model/LiveCardSystemModel';
import { LiveCardSystemButtonView } from './LiveCardSystemButtonView';
import { LiveStyle } from '../constants/LiveStyle';
import { AccessibilityText } from '../../view/AccessibilityText';
import { LiveCardActionButtonView } from './LiveCardActionButtonView';

const TAG = 'LiveCardSystemView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveCardSystemView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed
  get card(): LiveCardSystemModel {
    return this.live.card as LiveCardSystemModel;
  }

  @Computed
  get cardVm(): ILiveCardSystemVm {
    return this.liveVmInjector.getCardSystemVm(this.live);
  }

  @Computed
  get cardViewId(): string {
    if (!this.cardVm.hasActionButtons) {
      return this.liveVmInjector.getId(`${TAG}_${this.live.hashCode}`);
    }
    return this.liveVmInjector.getId(`${TAG}_${this.live.hashCode}_card_view`);
  }

  colorVm = this.liveVmInjector.getColorVm();

  aboutToAppear() {
    log.showInfo(`aboutToAppear, hashCode: ${this.live.hashCode}`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear, hashCode: ${this.live.hashCode}`);
  }

  build() {
    if (!this.cardVm.hasActionButtons && this.cardVm.isHideContent()) {
      this.buildCardView();
    } else {
      Column() {
        this.buildCardView();
        if (this.cardVm.isShowActionButtons) {
          LiveCardActionButtonView({ live: this.live })
        }
      }
      .borderRadius(LiveStyle.CARD_RADIUS)
      .clip(true)
      .id(this.liveVmInjector.getId(`${TAG}_${this.live.hashCode}`))
    }
  }

  @Builder
  buildCardView(){
    Row({ space: 12 }) {
      AccessibilityText({ text: this.live.getAccessibilityAppName() })
      // 应用图标显隐控制
      if (!this.cardVm?.isHideAppIcon) {
        NotificationIconView({
          scene: this.liveVmInjector.scene,
          ntf: this.live,
          onClick: this.cardVm.onIconClick,
          bigIconOpacity: this.cardVm?.iconAlpha,
          bigIconBgVisible: this.cardVm?.iconBgVisible,
          bigIconBgColor: this.cardVm?.iconBgColor,
          littleIconOpacity: this.cardVm?.topIconAlpha,
          littleIconBgVisible: this.cardVm?.topBgVisible,
          littleIconBgColor: this.cardVm?.topBgColor,
        })
      }
      this.buildContent()
      if (!this.cardVm.isHideContent()) {
        this.buildAuxiliaryArea()
      }
    }
    .id(this.cardViewId)
    .width('100%')
    .height(this.cardVm.getCardHeight())
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(LiveStyle.CARD_RADIUS)
    .alignItems(VerticalAlign.Center)
    .padding({ left: LiveStyle.CARD_PADDING, right: LiveStyle.CARD_PADDING })
    .clip(true)
  }

  @Builder
  buildContent() {
    Column({ space: 2 }) {
      this.buildTitle()
      if (this.cardVm.isContentAppear) {
        this.buildText()
      }
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Start)
    .padding({
      top: $r('app.float.live_view_card_padding_top_bottom'),
      bottom: $r('app.float.live_view_card_padding_top_bottom')
    })
  }

  @Builder
  buildTitle() {
    if (this.live.appIndex > 0) {
      Row() {
        this.buildNormalTitle();
      }
    } else {
      this.buildNormalTitle();
    }
  }

  @Builder
  buildNormalTitle() {
    Text(this.cardVm?.title)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Medium)
      .fontColor(this.cardVm?.titleFontColor)
      .fontSize(this.cardVm?.titleFontSize)
      .maxFontScale(this.cardVm?.maxFontScale)
      .fontFeature('\"ss08\" on')
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .lineHeight(this.cardVm?.titleLineHeight)
      .draggable(false)
      .renderGroup(this.cardVm?.contentRenderGroup)
      .accessibilityText(this.cardVm.getTitleAccessibilityText())
      .visibility(this.cardVm?.isHideTitleText ? Visibility.None : Visibility.Visible)
  }

  @Builder
  buildText() {
    Flex({ alignItems: ItemAlign.Center }) {
      if (this.cardVm.simIcon) {
        this.buildSimIcon()
      }

      Text(this.cardVm?.text)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .fontColor(this.cardVm?.textFontColor)
        .fontSize(this.cardVm?.textFontSize)
        .maxFontScale(this.cardVm?.maxFontScale)
        .fontFeature('\"ss08\" on')
        .foregroundColor(this.cardVm?.getSolidTextColor())
        .foregroundBrightness(this.cardVm?.textForegroundBrightness)
        .wordBreak(WordBreak.BREAK_ALL)
        .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .draggable(false)
        .renderGroup(this.cardVm?.contentRenderGroup)
        .lineHeight(this.cardVm?.textLineHeight)
        .accessibilityText(this.cardVm.getContentAccessibilityText())
    }.width('100%')
    .visibility(this.cardVm?.isHideContentText ? Visibility.None : Visibility.Visible)
  }

  @Builder
  buildSimIcon() {
    Text() {
      SymbolSpan(this.cardVm.simIcon).fontColor(this.cardVm.simIconColor)
    }
    .maxFontScale(this.cardVm?.maxFontScale)
    .padding({
      top: LengthMetrics.vp(LiveStyle.CARD_SIM_PADDING_TOP),
      bottom: LengthMetrics.vp(LiveStyle.CARD_SIM_PADDING_BOTTOM),
      end: LengthMetrics.vp(LiveStyle.CARD_SIM_PADDING_RIGHT)
    })
  }

  @Builder
  buildAuxiliaryArea() {
    if (this.card.progress) {
      LiveCardSystemProgressView({ live: this.live })
    }

    if (this.card.buttons?.length) {
      Row({ space: 12 }) {
        Repeat(this.card.buttons).each((data) => {
          LiveCardSystemButtonView({
            buttons: this.card.buttons,
            buttonIndex: data.index,
            buttonVm: this.liveVmInjector.getCardSystemButtonVm(this.live),
          })
        }).key((_, index: number) => this.live.hashCode + '#' + index)
      }.accessibilityText(' ')
    }
  }
}