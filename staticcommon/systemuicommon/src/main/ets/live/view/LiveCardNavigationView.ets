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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveNotification } from '../model/LiveNotification';
import { NotificationIconView } from '../../view/NotificationIconView';
import { LiveCardNavigationModel } from '../model/LiveCardNavigationModel';
import { LiveVmInjector } from '../LiveVmInjector';
import { SystemUIColorVm } from '../../vm/SystemUIColorVm';
import { ILiveCardOtherVm } from '../interface/ILiveCardOtherVm';
import { ILiveCardNavigationVm } from '../interface/ILiveCardNavigationVm';
import { LiveCardAuthorizationView } from './LiveCardAuthorizationView';
import { ILiveCardAuthorizationVm } from '../interface/ILiveCardAuthorizationVm';
import { LiveStyle } from '../constants/LiveStyle';
import { ResourceVm } from '../../vm/ResourceVm';
import { AccessibilityText } from '../../view/AccessibilityText';
import { LiveCardActionButtonView } from './LiveCardActionButtonView';
import { ILiveActionButtonVm } from '../interface/ILiveActionButtonVm';
import { LiveExtensionType } from '../model/LiveCommonModel';
import { LiveCardOtherExtendView } from './LiveCardOtherExtendView';
import { image } from '@kit.ImageKit';

const TAG = 'LiveCardNavigationView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 导航卡片组件
 */
@ComponentV2
export struct LiveCardNavigationView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed
  get card(): LiveCardNavigationModel {
    return this.live.card as LiveCardNavigationModel;
  }

  @Computed
  get colorVm(): SystemUIColorVm {
    return this.liveVmInjector.getColorVm() as SystemUIColorVm;
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
  get navigationVm(): ILiveCardNavigationVm {
    return this.liveVmInjector.getCardNavigationVm(this.live);
  }

  aboutToAppear() {
    this.setLiveCardParam();
    log.showInfo('aboutToAppear, hashCode: ' + this.live.hashCode);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear, hashCode: ' + this.live.hashCode);
  }

  build() {
    if (this.live) {
      Column() {
        AccessibilityText({ text: this.live.getAccessibilityAppName() });
        if (this.navigationVm.isHideContent()) {
          this.buildTopHideContent()
        } else {
          this.buildTopZone();
        }
        this.buildBottomZone();

        if (this.authorizationVm && this.authorizationVm.isShowAuthorization) {
          LiveCardAuthorizationView({
            live: this.live,
          })
        } else if (this.actionButtonVm.isShowActionButtons) {
          LiveCardActionButtonView({
            live: this.live
          })
        }
      }
      .id(this.liveVmInjector.getId(`${TAG}_${this.live.hashCode}`))
      .borderRadius(LiveStyle.CARD_RADIUS)
      .clip(true)
      .margin({
        top: this.cardVm.cardMarginTop,
        bottom: this.cardVm.cardMarginBottom,
        left: this.cardVm.cardMarginHorizontal,
        right: this.cardVm.cardMarginHorizontal,
      })
    }
  }

  @Builder
  buildTopZone() {
    RelativeContainer() {
      this.buildNavDirection();
      this.buildNavInfo();
      this.buildAppIcon();
    }
    .height(this.navigationVm?.getFixedAreaHeight())
    .margin(this.navigationVm?.cardMarginUpperHalf)
  }

  @Builder
  buildBottomZone() {
    if (this.navigationVm?.hasNavDirectionIcons) {
      if (this.navigationVm.isHideContent()) {
        this.buildBottomHideContent()
      } else if (this.card.layoutIsNavigationIconsDisplayed) {
        Column() {
          Divider()
            .width('100%')// 规避arkUI在部分屏幕上不显示低于1px的元素
            .height(this.navigationVm?.getCardScale())
            .color(this.cardVm.dividerFgColor)
            .foregroundBrightness(this.cardVm.dividerBrightness)
            .visibility(this.card?.layoutIsDisplayHorizontalLine ? Visibility.Visible : Visibility.None)
            .draggable(false)

          this.buildNavDirs();
        }
        .height('44vp')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
        .margin(this.navigationVm?.cardMarginBottomHalf)
      }
    }
  }

  @Builder
  private buildNavDirection() {
    Image(this.card?.layoutCurrentNavigationIcon)
      .id(`nav-direction-icon_${this.live.hashCode}`)
      .height(this.navigationVm?.currNavDirectionHeight)
      .width(this.navigationVm?.currNavDirectionWidth)
      .interpolation(ImageInterpolation.Medium)
      .objectFit(ImageFit.Contain)
      .draggable(false)
      .opacity(this.navigationVm?.navDirectionOpacity)
      .alignRules({
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
      .colorFilter(this.navigationVm?.imgColorFilter)
      .onClick(this.navigationVm?.onIconClick)
      .visibility(this.card?.layoutCurrentNavigationIcon ? Visibility.Visible : Visibility.Hidden)
  }

  @Monitor('card')
  private setLiveCardParam() {
    if (this.card?.layoutNavigationIcons?.length && this.card?.layoutNavigationIcons.length > 0) {
      this.navigationVm?.setNavDirectIcons(true);
    } else {
      this.navigationVm?.setNavDirectIcons(false);
    }

    if (this.navigationVm?.hasNavDirectionIcons) {
      if (!this.card.layoutIsNavigationIconsDisplayed) {
        this.navigationVm.setParamWithoutNavigationIcons();
      } else {
        this.navigationVm.setParamWithBottom();
      }
    }
  }

  @Builder
  private buildNavInfo() {
    Column() {
      this.buildTitle();
      this.buildContent();
    }
    .id(`${this.liveVmInjector.scene}_${TAG}_nav-text-content_${this.live.hashCode}`)
    .alignItems(HorizontalAlign.Start)
    .margin(this.navigationVm.navInfoMargin)
    .alignRules(this.navigationVm.navInfoAlignRule)
  }

  @Builder
  private buildAppIcon() {
    // 应用图标显隐控制
    if (this.card?.extensionType === LiveExtensionType.PICTURE && this.card?.extensionPic) {
      Row() {
        LiveCardOtherExtendView({
          live: this.live
        })
      }
      .id(`nav-app-icon_${this.live.hashCode}`)
      .alignRules(this.navigationVm?.appIconAlignRule)
    } else {
      if (!this.cardVm?.isHideAppIcon) {
        Image(this.live?.getAppIcon())
          .id(`nav-app-icon_${this.live.hashCode}`)
          .height(this.navigationVm?.appIconHeight)
          .width(this.navigationVm?.appIconWidth)
          .objectFit(ImageFit.Contain)
          .interpolation(ImageInterpolation.Medium)
          .borderRadius('6vp')
          .clip(true)
          .draggable(false)
          .alignRules(this.navigationVm?.appIconAlignRule)
          .opacity(this.navigationVm?.navDirectionOpacity)
      }
    }
  }

  @Builder
  private buildTitle() {
    Text(this.navigationVm?.getTimerText(this.cardVm?.title ?? '', this.card.timer))
      .fontSize(this.navigationVm?.mainNavInfoSize)
      .maxFontScale(ResourceVm.instance.getLiveFontScale())
      .fontFeature('\"ss08\" on')
      .fontWeight(this.navigationVm?.mainNavInfoWeight)
      .fontColor(this.navigationVm?.titleFontColor)
      .fontFamily('HarmonyHeiTi')
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup(this.navigationVm?.renderGroup)
      .margin({
        bottom: this.navigationVm?.mainViceSpace,
      })
      .draggable(false)
  }

  @Builder
  private buildContent() {
    Text() {
      Repeat(this.card?.fixedContent).each((data) => {
        Span(this.navigationVm?.getTimerText(data.item.text ?? '', this.card.timer))
          .fontColor(this.navigationVm?.getContentFontColor(data.item))
      })
    }
    .fontSize(this.navigationVm?.viceNavInfoSize)
    .maxFontScale(ResourceVm.instance.getLiveFontScale())
    .fontFeature('\"ss08\" on')
    .fontWeight(this.navigationVm?.viceNavInfoWeight)
    .fontFamily('HarmonyHeiTi')
    .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .renderGroup(this.navigationVm?.renderGroup)
    .draggable(false)

  }

  @Builder
  buildNavDirs() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: ItemAlign.End,
    }) {
      ForEach(this.card?.layoutNavigationIcons, (pic: image.PixelMap)=> {
        Image(pic)
          .objectFit(ImageFit.Contain)
          .interpolation(ImageInterpolation.Medium)
          .height(this.navigationVm.navDirsSize)
          .width(this.navigationVm.navDirsSize)
          .draggable(false)
          .syncLoad(true)
          .colorFilter(this.navigationVm?.navDirsColorFilter)
          .opacity(this.navigationVm?.navDirsOpacity)
      })
    }
    .direction(Direction.Ltr)
    .layoutWeight(1)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.navigationVm.navDirsWidth = newValue.width as number;
      log.showInfo('onAreaChange navDirsWidth: ' + this.navigationVm.navDirsWidth);
    })
  }

  @Builder
  buildTopHideContent() {
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
        if (this.card.layoutIsNavigationIconsDisplayed && this.navigationVm.hasNavDirectionIcons) {
          this.buildHideLargeTitle()
        } else {
          this.buildHideSmallTitle()
        }
        this.buildHideText()
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .padding(this.cardVm.topZonePadding)
    .height(this.cardVm?.getFixedAreaHeight())
  }

  @Builder
  buildHideSmallTitle() {
    Text(this.cardVm?.title)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Medium)
      .fontColor(this.cardVm?.titleFontColor)
      .fontSize($r('sys.float.ohos_id_text_size_sub_title3'))
      .maxFontScale(ResourceVm.instance.getLiveFontScale())
      .fontFeature('\"ss08\" on')
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .lineHeight(this.cardVm?.titleLineHeight)
      .draggable(false)
      .renderGroup(this.cardVm?.contentRenderGroup)
  }

  @Builder
  buildHideLargeTitle() {
    Text(this.cardVm?.title)
      .fontFamily('HarmonyHeiTi')
      .fontWeight(this.cardVm?.titleFontWeight)
      .fontColor(this.cardVm?.titleFontColor)
      .minFontSize(this.cardVm?.titleMinFontSize)
      .maxFontSize(this.cardVm?.titleMaxFontSize)
      .maxFontScale(ResourceVm.instance.getLiveFontScale())
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
  }

  @Builder
  buildHideText() {
    Text(ResourceVm.instance.getPluralString($r('app.plural.live_hide_content'), 1))
      .fontColor(LiveStyle.LIVE_CARD_TEXT_FONT_COLOR)
      .fontWeight(FontWeight.Regular)
      .fontFamily('HarmonyHeiTi')
      .fontSize(this.cardVm?.contentTextFontSize)
      .maxFontScale(ResourceVm.instance.getLiveFontScale())
      .fontFeature('\"ss08\" on')
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(ResourceVm.instance.isRTL ? TextAlign.End : TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .draggable(false)
      .renderGroup(this.cardVm?.contentRenderGroup)
      .lineHeight(this.cardVm?.richTextLineHeight)
      .accessibilityText(this.cardVm.getContentAccessibilityText())
  }

  @Builder
  buildBottomHideContent() {
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
    .height(this.cardVm.bottomHalfHeight)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}