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
import { NotificationIconView } from '../../view/NotificationIconView';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCardOtherVm } from '../interface/ILiveCardOtherVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveCardOtherModel } from '../model/LiveCardOtherModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCardOtherFlightView } from './LiveCardOtherFlightView';
import { LiveCardOtherScoreView } from './LiveCardOtherScoreView';
import { ILiveCardAuthorizationVm } from '../interface/ILiveCardAuthorizationVm';
import { LiveCardAuthorizationView } from './LiveCardAuthorizationView';
import { LiveCardOtherPickupView } from './LiveCardOtherPickupView';
import { LiveCardPickupModel } from '../model/LiveCardPickupModel';
import { LiveCardScoreModel } from '../model/LiveCardScoreModel';
import { LiveCardFlightModel } from '../model/LiveCardFlightModel';
import { LiveCardOtherProgressView } from './LiveCardOtherProgressView';
import { LiveCardOtherExtendView } from './LiveCardOtherExtendView';
import { LiveCardType, LiveRichTextModel } from '../model/LiveCommonModel';
import { AccessibilityText } from '../../view/AccessibilityText';
import { LiveCardActionButtonView } from './LiveCardActionButtonView';
import { ILiveActionButtonVm } from '../interface/ILiveActionButtonVm';
import { InnerEventUtil } from '../../utils/InnerEventUtil'
import { LiveCardShowAnimationEvent } from '../../event/LiveCardShowAnimationEvent';
import { EnvVm } from '../../vm/EnvVm';
import { LiveCardWeatherBackgroundView, weatherAnimationGradient } from './LiveCardWeatherBackgroundView';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { WeatherScene, PriorityWeatherScene } from '../model/LiveWeatherModel';
import { LiveCardWeatherUtil } from '../../utils/LiveCardWeatherUtil';

const TAG = 'LiveCardOtherView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 三方实况卡片
 */
@ComponentV2
export struct LiveCardOtherView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed
  get card(): LiveCardOtherModel {
    return this.live.card as LiveCardOtherModel;
  }

  @Computed
  get cardVm(): ILiveCardOtherVm {
    return this.liveVmInjector.getCardOtherVm(this.live);
  }

  @Computed
  get authorizationVm(): ILiveCardAuthorizationVm {
    return this.liveVmInjector.getCardAuthorizationVm(this.live);
  }

  @Computed
  get actionButtonVm(): ILiveActionButtonVm {
    return this.liveVmInjector.getLiveActionButtonVm(this.live);
  }

  @Computed
  get componentId(): string {
    return this.liveVmInjector.getId(`${TAG}_${this.live.hashCode}`)
  }

  colorVm = this.liveVmInjector.getColorVm();

  aboutToAppear() {
    log.showInfo('aboutToAppear, hashCode: ' + this.live.hashCode);
    if (!this.liveVmInjector.getLiveHeadsUpVm().isBannerWeatherScene) {
      InnerEventUtil.on(LiveCardShowAnimationEvent, this.cardVm.onLiveCardAnimationEventChange);
    }
    this.cardVm.setAppearAnimation();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear, hashCode: ' + this.live.hashCode);
    if (this.liveVmInjector.getLiveHeadsUpVm().isBannerWeatherScene) {
      this.liveVmInjector.getLiveHeadsUpVm().isBannerWeatherScene = false;
      return;
    }
    InnerEventUtil.off(LiveCardShowAnimationEvent, this.cardVm.onLiveCardAnimationEventChange);
  }

  build() {
    RelativeContainer() {
      if (this.live.card.isFlightCard()) {
        if (this.live.card.liveCardWeatherInfo?.showType === PriorityWeatherScene.SUNSET_SCENE ||
          this.live.card.liveCardWeatherInfo?.showType === PriorityWeatherScene.MOON_SCENE ||
        LiveCardWeatherUtil.instance.isNeedCloudBackground(this.live.card.liveCardWeatherInfo)) {
          LiveCardWeatherBackgroundView({
            contentId: this.componentId,
            scene: this.liveVmInjector.scene === SystemUIUseScene.LIVE ? WeatherScene.LIVE_LIST_OR_HEADS_UP :
            WeatherScene.NOTIFICATION_CENTER,
            weatherInfo: this.live.card?.liveCardWeatherInfo,
            cardHeight: this.cardVm?.getWeatherBackgroundHeight(),
          })
        }
        if (this.live.card.liveCardWeatherInfo?.showType === PriorityWeatherScene.WEATHER_SCENE) {
          Stack({ alignContent: Alignment.TopEnd }) {
            Column() {
            }
            .borderRadius(LiveStyle.CARD_RADIUS)
            .visualEffect(this.cardVm.visualEffect)
            .opacity(EnvVm.instance.isScreenOff ? 0 : 1)
            .width('60%')
            .height(this.cardVm?.getWeatherBackgroundHeight())
            .rotate({ y: 1, angle: ResourceVm.instance.isRTL ? 180 : 0 })

            weatherAnimationGradient({ cardHeight: this.cardVm?.getWeatherBackgroundHeight() })
          }
          .blendMode(1000, BlendApplyType.OFFSCREEN)
          .hitTestBehavior(HitTestMode.None)
        }
      }
      Column() {
        this.buildTopZone()
        this.buildBottomZone()
      }
      .id(this.componentId)
      .borderRadius(LiveStyle.CARD_RADIUS)
      .clip(true)
      .margin({
        top: this.cardVm.cardMarginTop,
        bottom: this.cardVm.cardMarginBottom,
        left: this.cardVm.cardMarginHorizontal,
        right: this.cardVm.cardMarginHorizontal,
      })
    }
    .height('auto')
    .width('100%')
  }

  /**
   * 上半区，图标、标题、内容、辅助区
   */
  @Builder
  buildTopZone() {
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

      Column({ space: 2 }) {
        this.buildTitle()
        this.buildText()
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .padding({
        top: $r('app.float.live_view_card_padding_top_bottom'),
        bottom: $r('app.float.live_view_card_padding_top_bottom')
      })

      if (!this.cardVm.isHideContent()) {
        this.buildExtend()
      }
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding(this.cardVm.topZonePadding)
    .height(this.cardVm?.getFixedAreaHeight())
  }

  @Builder
  buildTitle() {
    if (this.live?.appIndex > 0) {
      this.buildCloneLabelTitle()
    } else {
      this.buildNormalCardTitle()
    }
  }

  @Builder
  buildCloneLabelTitle() {
    Row() {
      this.buildNormalCardTitle()
      Image(this.live?.cloneLabelRes)
        .draggable(false)
        .width($r('app.float.ntf_small_icon_size'))
        .height($r('app.float.ntf_small_icon_size'))
        .margin({
          start: LengthMetrics.resource($r('app.float.ntf_extra_content_image_margin')),
          bottom: LengthMetrics.resource($r('app.float.ntf_live_view_image_margin_bottom'))
        })
    }
  }

  @Builder
  buildNormalCardTitle() {
    Text(this.cardVm?.title)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(this.cardVm?.titleFontWeight)
      .fontColor(this.cardVm?.titleFontColor)
      .minFontSize(this.cardVm?.titleMinFontSize)
      .maxFontSize(this.cardVm?.titleMaxFontSize)
      .maxFontScale(this.cardVm?.maxFontScale)
      .fontFeature('\"ss08\" on')
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .margin({
        bottom: this.cardVm?.titleMargin
      })
      .lineHeight(this.cardVm?.titleLineHeight)
      .draggable(false)
      .renderGroup(this.cardVm?.contentRenderGroup)
      .accessibilityText(this.cardVm.getAccessibilityText(this.card.fixedTitle))
      .visibility(this.cardVm?.isHideTitleText ? Visibility.None : Visibility.Visible)
  }

  @Builder
  buildText() {
    Text() {
      if (this.cardVm.isHideContent()) {
        Span(ResourceVm.instance.getPluralString($r('app.plural.live_hide_content'), 1))
          .fontColor(this.cardVm.contentFontColor)
      } else {
        ForEach(this.card?.fixedContent, (item: LiveRichTextModel, index: number) => {
          Span(this.cardVm?.getContentText(item))
            .fontColor(this.cardVm?.getContentFontColor(item))
            .fontWeight(this.cardVm?.getContentFontWeight(item))
        }, (item: LiveRichTextModel, index: number) => {
          return this.liveVmInjector.scene + '_' + item.text + '_' + item.textColor + '_' + index;
        })
      }
    }
    .fontFamily('HarmonyHeiTi')
    .fontSize(this.cardVm?.contentTextFontSize)
    .maxFontScale(this.cardVm?.maxFontScale)
    .fontFeature('\"ss08\" on')
    .wordBreak(WordBreak.BREAK_ALL)
    .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .draggable(false)
    .renderGroup(this.cardVm?.contentRenderGroup)
    .lineHeight(this.cardVm?.richTextLineHeight)
    .visibility(this.cardVm?.isHideContentText ? Visibility.None : Visibility.Visible)
    .accessibilityText(this.cardVm.getContentAccessibilityText())
  }

  @Builder
  buildExtend() {
    LiveCardOtherExtendView({
      live: this.live
    })
  }

  @Builder
  buildLayoutHideContent() {
    Column() {
      Text($r('app.string.live_view_hide_tip'))
        .fontColor(this.cardVm.contentFontColor)
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontWeight('sys.string.ohos_id_text_font_family_regular')
        .maxFontScale(ResourceVm.instance.limitFontScale)
        .wordBreak(WordBreak.BREAK_ALL)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(72)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 扩展区
   */
  @Builder
  buildBottomZone() {
    if (this.cardVm.isHideContent() && !this.card.isNoLayoutCard()) {
      this.buildLayoutHideContent()
    } else if (this.card.cardType === LiveCardType.FLIGHT) {
      LiveCardOtherFlightView({
        live: this.live,
        cardInfo: this.card as LiveCardFlightModel,
        cardVm: this.cardVm,
        cardFlightVm: this.liveVmInjector.getCardOtherFlightVm(this.live),
        colorVm: this.colorVm,
      })
    } else if (this.card.cardType === LiveCardType.PICK_UP) {
      LiveCardOtherPickupView({
        live: this.live,
        cardInfo: this.card as LiveCardPickupModel,
        cardVm: this.cardVm,
        cardPickupVm: this.liveVmInjector.getCardOtherPickupVm(this.live),
      })
    } else if (this.card.cardType === LiveCardType.SCORE) {
      LiveCardOtherScoreView({
        live: this.live,
        cardInfo: this.card as LiveCardScoreModel,
        cardVm: this.cardVm,
        cardScoreVm: this.liveVmInjector.getCardOtherScoreVm(this.live),
        colorVm: this.colorVm,
      })
    } else if (this.card.cardType === LiveCardType.PROGRESS) {
      LiveCardOtherProgressView({
        live: this.live
      })
    }
    if (this.authorizationVm.isShowAuthorization) {
      LiveCardAuthorizationView({
        live: this.live,
      })
    } else if (this.actionButtonVm.isShowActionButtons) {
      LiveCardActionButtonView({
        live: this.live
      })
    }
  }
}