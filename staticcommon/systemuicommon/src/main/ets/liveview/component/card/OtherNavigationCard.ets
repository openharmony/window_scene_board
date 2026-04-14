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
import { ObservedItem } from '../../../model/ObservedModel';
import { immersiveKgMgr } from '../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import {
  fontScaleManager,
  FontScaleState
} from '@ohos/systemuiutils/src/main/ets/TsIndex';
import { LiveUseScene, LiveViewCommonConstants, LiveExtendType } from '../../common/LiveConstants';
import { LiveViewData } from '../../data/LiveViewData';
import { RichText } from '../../data/template/LiveBaseTemplate';
import { LiveNavigationTemplate, NavDirection } from '../../data/template/LiveNavigationTemplate';
import { CardAuthorization } from './CardAuthorization';
import { LiveOtherExtendData } from '../../data/extend/LiveOtherExtendData';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import { LiveCustomerStyle } from '../../info/card/LiveCustomerStyle';
import { NotificationType } from '../../../constants/NotificationType';
import { DarkModeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { CardUtils } from './LiveViewCardData';
import { AccessibilityAppName } from '../../../accessibility/AccessibilityAppName';
import { ColorModeViewData } from '../../../template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '../../../template/newStyle/ColorModeViewModel';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveAccessibilityUtil } from '../../common/liveAccessibilityUtil';
import { OuterHomeVm } from '../../../../ets/vm/OuterHomeVm'
import { ColorModeLiveViewData } from '../../../template/newStyle/ColorModeLiveViewData';
import { ServiceButtonComponent } from './OtherComponent/ServiceButtonComponent';
import { ExtendComponent } from './OtherComponent/ExtendComponent';
import { LiveStyle } from '../../../live/constants/LiveStyle';
import { SystemUICcmConfig } from '../../../utils/SystemUICcmConfig';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'OtherNavCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface NavCardParam {
  cardMarginUpperHalf?: Margin,
  cardMarginBottomHalf?: Margin,

  // 卡片上半区 -- 当前导航方向图标
  currNavDirectionHeight?: string,
  currNavDirectionWidth?: string,

  // 卡片上半区 -- 导航信息
  navInfoMargin?: LocalizedPadding,
  navInfoAlignRule?: AlignRuleOption,
  // 卡片上半区 -- 主要导航信息
  mainNavInfoSize?: Resource,
  mainNavInfoWeight?: FontWeight,
  mainNavInfoColor?: Resource,
  mainViceSpace?: Resource,

  // 卡片上半区 -- 次要导航信息
  viceNavInfoSize?: Resource,
  viceNavInfoWeight?: FontWeight,
  viceNavInfoColor?: Resource,

  // 卡片上半区 -- 应用图标
  appIconHeight?: string,
  appIconWidth?: string,
  appIconAlignRule?: AlignRuleOption,

  hasNavDirectionIcons?: boolean,
  cardBottomHalfHeight?: string,
}

/**
 * 导航卡片
 */
@Component
export struct OtherNavigationCard {
  @ObjectLink baseData: LiveViewData;
  @ObjectLink timerData: LiveTimerData;
  @ObjectLink @Watch('setCardParam') data: LiveNavigationTemplate;
  @State cardParam: NavCardParam = {};
  @State darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
  customerStyle: LiveCustomerStyle = new LiveCustomerStyle();
  @Prop cardScale: number = 1;
  @Prop isSmallFoldOuterScreen: boolean = false;

  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State colorModeLiveViewData: ColorModeLiveViewData = ColorModeViewModel.getInstance().getLiveViewData();

  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @State outerHomeVm: OuterHomeVm = OuterHomeVm.get();

  @Prop isNeedBannerInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;

  useScene: LiveUseScene = LiveUseScene.SCENE_LIVE_LIST;
  showAuthorizationTip: boolean = false;
  isImmersiveLive: boolean = false;

  @State navDirsWidth: number = 0;
  /**
   * 应用名称
   */
  @State appName?: ObservedItem<string> = undefined;

  aboutToAppear() {
    this.setCardParam();
    this.appName = this.baseData?.appName;
    log.showInfo('aboutToAppear, layout type=' + this.data?.layoutType);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    if (this.data) {
      Column() {
        AccessibilityAppName({
          name: LiveAccessibilityUtil.getAccessibilityAppName(this.baseData),
          isAccessibilityMode: this.isAccessibilityMode
        })

        this.buildUpperHalf()
        this.buildBottomHalf()

        if (this.showAuthorizationTip && this.baseData.showAuthorization) {
          CardAuthorization({ dataTemplate: this.data, baseData: this.baseData, useScene: this.useScene })
        } else if (!this.shouldHideContent() && this.data.isShowServiceButton()) {
          ServiceButtonComponent({
            baseData: this.baseData,
            data: this.data,
            useScene: this.useScene,
          })
        }
      }
      .borderRadius($r('app.float.live_view_card_border_radius'))
      .clip(true)
      .id(LiveViewCommonConstants.getItemContentId(this.baseData.hashCode, this.useScene))
      .margin({
        top: this.customerStyle.cardMarginTop ?? undefined,
        bottom: this.customerStyle.cardMarginBottom ?? undefined,
        left: this.customerStyle.cardMarginHorizontal ?? undefined,
        right: this.customerStyle.cardMarginHorizontal ?? undefined
      })
    }
  }

  /**
   * 导航栏隐藏内容时的上半区组成：
   */
  @Builder
  private buildHiddenUpperHalf() {
    Row({ space: 12 }) {
      Image(this.data?.getSmallIcon() ?? this.data?.getAppIcon())
        .width($r('app.float.live_view_card_large_icon_width'))
        .height($r('app.float.live_view_card_large_icon_height'))
        .borderRadius($r('app.float.live_view_left_large_icon_radius'))
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .border({
          width: '1px',
          color: '#3F808080',
          radius: $r('app.float.live_view_left_large_icon_radius')
        })
        .opacity(1)

      Column() {
        Text(this.appName?.value ?? '')
          .fontFamily('HarmonyHeiTi')
          .fontWeight(this.cardParam?.hasNavDirectionIcons ? FontWeight.Bold : FontWeight.Medium)
          .fontSize(this.fontScaleState.getScaleSize(this.cardParam?.hasNavDirectionIcons ?
          $r('app.float.live_view_other_card_title_font_size') : this.cardParam?.mainNavInfoSize as Resource,
            this.outerHomeVm.isIgnoreFontScaleState))
          .fontFeature('\"ss08\" on')
          .fontColor(('sys.color.ohos_id_color_text_primary'))
          .wordBreak(WordBreak.BREAK_ALL)
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .lineHeight(this.fontScaleState.getScaleSize(this.cardParam?.hasNavDirectionIcons ?
            $r('app.float.live_view_card_hide_layout_height') : this.cardParam?.mainNavInfoSize as Resource, this.outerHomeVm.isIgnoreFontScaleState))
          .margin({
            bottom: this.cardParam?.hasNavDirectionIcons ? $r('app.float.live_view_other_card_title_margin_bottom') : 0,
          })
          .renderGroup(true)

        Text(this.baseData?.contentHideText)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize(this.fontScaleState.getScaleSize($r('sys.float.ohos_id_text_size_body2'),
            this.outerHomeVm.isIgnoreFontScaleState))
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .wordBreak(WordBreak.BREAK_ALL)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .renderGroup(true)
          .lineHeight(this.fontScaleState.getScaleSize($r('app.float.live_view_card_text_line_height'),
            this.outerHomeVm.isIgnoreFontScaleState))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .fontWeight(FontWeight.Regular)
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .padding({
        top: this.cardParam?.hasNavDirectionIcons ? $r('app.float.live_view_card_padding_top_bottom') : 0,
        bottom: this.cardParam?.hasNavDirectionIcons ? $r('app.float.live_view_card_padding_top_bottom') : 0,
      })
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .padding({
      start: LengthMetrics.resource(CardUtils.LIVE_VIEW_CARD_PADDING),
      end: LengthMetrics.resource(CardUtils.LIVE_VIEW_CARD_PADDING),
    })
    .width('100%')
    .height(this.getFixedAreaHeight())
    .margin({
      top: this.cardParam?.hasNavDirectionIcons ? 0 : this.cardParam?.cardMarginUpperHalf?.top,
      bottom: this.cardParam?.hasNavDirectionIcons ? 0 : this.cardParam?.cardMarginUpperHalf?.bottom,
    })
  }

  /**
   * 导航栏隐藏内容时的下半区组成：
   */
  @Builder
  private buildHiddenBottomHalf() {
    Row() {
      Row() {
        Text($r('app.string.live_view_hide_tip'))
          .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
          .fontSize(this.fontScaleState.getScaleSize($r('sys.float.ohos_id_text_size_body2'),
            this.outerHomeVm.isIgnoreFontScaleState))
          .fontWeight('sys.string.ohos_id_text_font_family_regular')
          .wordBreak(WordBreak.BREAK_ALL)
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('100%')
    }
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .padding({
      start: LengthMetrics.resource(CardUtils.LIVE_VIEW_CARD_PADDING),
      end: LengthMetrics.resource(CardUtils.LIVE_VIEW_CARD_PADDING),
      bottom: LengthMetrics.resource(CardUtils.LIVE_VIEW_CARD_PADDING)
    })
    .width('100%')
    .height(72)
  }

  /**
   * 导航栏卡片的上半区组成：
   * 拓展区的当前导航方向图标 - 固定区导航双文本信息 - 辅助区应用图标
   */
  @Builder
  private buildUpperHalf() {
    if (this.shouldHideContent()) {
      this.buildHiddenUpperHalf()
    } else {
      RelativeContainer() {
        this.buildCurrNavDirection();
        this.buildNavInfo();
        if (!this.isImmersiveLive) {
          this.buildAppIcon();
        }
      }
      .height(this.getFixedAreaHeight())
      .margin(this.isSmallFoldOuterScreen ? undefined : this.cardParam?.cardMarginUpperHalf)
    }
  }

  @Builder
  private buildCurrNavDirection() {
    Image(this.data?.currNavDirectionIcon)
      .id(`nav-direction-icon-${this.baseData.hashCode}`)
      .height(this.isSmallFoldOuterScreen ? 40 : this.cardParam?.currNavDirectionHeight)
      .width(this.isSmallFoldOuterScreen ? 40 : this.cardParam?.currNavDirectionWidth)
      .interpolation(ImageInterpolation.Medium)
      .objectFit(ImageFit.Contain)
      .colorFilter(this.getImgColorFilter())
      .draggable(false)
      .opacity(undefined)
      .alignRules(this.isSmallFoldOuterScreen ? {
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        top: { anchor: '__container__', align: VerticalAlign.Top }
      } : {
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
      .onClick(this.baseData?.getIconClickListener(this.useScene, this.isNeedBannerInScreenLock,
        this.isShowBannerFromScreenLock))
      .visibility(this.data?.currNavDirectionIcon ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  private constructorTitle() {
    Text(this.data.transformTimerText(this.data.title ?? '', this.timerData))
      .accessibilityText(this.data.transformTimerAccessibilityText(this.data.title ?? '', this.timerData))
      .fontSize(this.isSmallFoldOuterScreen ? '14vp' :
      this.fontScaleState.getScaleSize(this.cardParam?.mainNavInfoSize, this.outerHomeVm.isIgnoreFontScaleState))
      .fontFeature('\"ss08\" on')
      .fontWeight(this.cardParam?.mainNavInfoWeight)
      .fontColor(this.getTitleFontColor())
      .fontFamily('HarmonyHeiTi')
      .textAlign(TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup(true)
      .margin({
        bottom: this.isSmallFoldOuterScreen ? 2 : this.cardParam?.mainViceSpace,
      })
      .draggable(false)
      .lineHeight(this.isSmallFoldOuterScreen ? '20vp' : undefined)
  }

  @Builder
  constructContent() {
    Text() {
      ForEach(this.data?.richContent, (entry: RichText, index: number) => {
        Span(this.data.transformTimerText(entry?.text ?? '', this.timerData)).fontColor(this.getRichTextColor(entry))
      })
    }
    .accessibilityText(this.getRichAccessibilityText())
    .fontSize(this.isSmallFoldOuterScreen ? '12vp' :
    this.fontScaleState.getScaleSize(this.cardParam?.viceNavInfoSize, this.outerHomeVm.isIgnoreFontScaleState))
    .fontFeature('\"ss08\" on')
    .fontWeight(this.cardParam?.viceNavInfoWeight)
    .fontFamily('HarmonyHeiTi')
    .textAlign(TextAlign.Start)
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .renderGroup(true)
    .draggable(false)
    .lineHeight(this.isSmallFoldOuterScreen ? 16 : undefined)
  }

  /**
   * 如果没传导航信息，仍然占位，不显示文本信息。
   */
  @Builder
  private buildNavInfo() {
    Column() {
      this.constructorTitle()
      this.constructContent()
    }
    .id(`nav-text-content-${this.baseData.hashCode}`)
    .alignItems(HorizontalAlign.Start)
    .margin({
      start: this.isSmallFoldOuterScreen ? LengthMetrics.vp(8) : this.cardParam.navInfoMargin?.start,
      end: this.cardParam.navInfoMargin?.end
    })
    .alignRules({
      center: this.isSmallFoldOuterScreen ?
        { anchor: `nav-direction-icon-${this.baseData.hashCode}`, align: VerticalAlign.Center } :
        this.cardParam.navInfoAlignRule?.center,
      left: this.cardParam.navInfoAlignRule?.left,
      right: this.cardParam.navInfoAlignRule?.right,
    })
  }

  @Builder
  private buildAppIcon() {
    if (this.data.hasExtendPic()) {
      Row() {
        ExtendComponent({
          data: this.data?.getExtendData(LiveExtendType.TYPE_OTHER_EXTEND) as LiveOtherExtendData,
          baseData: this.baseData,
          useScene: this.useScene,
          isNavigation: true,
          isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
          isImmersiveLive: this.isImmersiveLive
        })
      }
      .alignRules(this.cardParam?.appIconAlignRule)
    } else {
      Image(this.data?.getAppIcon())
        .id(`nav-app-icon-${this.baseData.hashCode}`)
        .height(this.cardParam?.appIconHeight)
        .width(this.cardParam?.appIconWidth)
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .borderRadius('6vp')
        .opacity(undefined)
        .clip(true)
        .draggable(false)
        .alignRules(this.cardParam?.appIconAlignRule)
    }
  }

  /**
   * 导航栏卡片的下半区组成：
   * 分割线
   *   |
   * 导航方向图标
   */
  @Builder
  private buildBottomHalf() {
    if (this.shouldHideContent()) {
      if (this.cardParam?.hasNavDirectionIcons) {
        this.buildHiddenBottomHalf();
      }
    } else {
      if (this.cardParam?.hasNavDirectionIcons && this.data.isNavigationIconsDisplayed) {
        Column() {
          Divider()
            .width('100%')
              // 规避arkUI在部分屏幕上不显示低于1px的元素
            .height(this.cardScale < 1 ? '1.5px' : '1px')
            .color(this.colorModeViewData.calcSecondarySolidColor($r('app.color.live_card_divider_bg_color'),
              this.colorModeViewData.foregroundDividerOption, this.colorModeLiveViewData.liveBgPickColor))
            .foregroundBrightness(this.colorModeViewData.isSolidEnable() ? undefined :
              this.colorModeViewData.foregroundDividerOption)
            .foregroundBrightness(this.colorModeViewData.foregroundDividerOption)
            .visibility(this.getDividerVisibility())
            .draggable(false)

          if (this.isSmallFoldOuterScreen) {
            this.buildSmallFoldNavDirs()
          } else {
            this.buildNavDirs();
          }
        }
        .height(this.cardParam.cardBottomHalfHeight)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
        .margin(this.isSmallFoldOuterScreen ? undefined : this.cardParam?.cardMarginBottomHalf)
      }
    }
  }

  @Builder
  private buildSmallFoldNavDirs() {
    Column() {
      this.buildNavDirs()
    }
    .width('240vp')
  }

  @Builder
  private buildNavDirs() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceEvenly,
      alignItems: ItemAlign.End,
    }) {
      ForEach(this.data?.navDirectionIcons,
        (navDirectionIcon: NavDirection, index: number) => {
          Image(navDirectionIcon.icon)
            .objectFit(ImageFit.Contain)
            .interpolation(ImageInterpolation.Medium)
            .height(this.getNavDirsSize())
            .width(this.getNavDirsSize())
            .colorFilter(this.getImgColorFilter())
            .opacity(undefined)
            .draggable(false)
            .syncLoad(true)
        },
        (navDirectionIcon: NavDirection) => navDirectionIcon.iconKey)
    }
    .direction(Direction.Ltr)
    .layoutWeight(1)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.navDirsWidth = newValue.width as number;
      log.showInfo('onAreaChange navDirsWidth: ' + this.navDirsWidth);
    })
  }

  private getRichTextColor(entry: RichText): string | number | Resource | undefined {

    // 当前富文本颜色，如外卖距离商家 300 米，数字300标记为蓝色，AOD时不变色
    let currentTextColor = entry?.getCurrentTextColor();
    if (currentTextColor) {
      return currentTextColor;
    }

    // 深色模式兜底颜色
    if (this.darkModeState?.isDarkMode) {
      return CardUtils.DARK_RICH_CONTEXT_COLOR;
    }

    if (this.isOuterScreenImmersiveLive2()) {
      return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
    }

    return $r('sys.color.ohos_id_color_text_secondary');
  }

  private setCardParam(): void {
    if (this.data?.navDirectionIcons?.length && this.data?.navDirectionIcons?.length > 0) {
      this.cardParam.hasNavDirectionIcons = true;
    } else {
      this.cardParam.hasNavDirectionIcons = false;
    }
    log.showInfo('setCardParam hasNavDirectionIcons: ' + this.cardParam.hasNavDirectionIcons);

    if (this.cardParam?.hasNavDirectionIcons) {
      if (!this.data.isNavigationIconsDisplayed && !this.shouldHideContent()) {
        this.setParamWithoutNavigationIcons();
      } else {
        this.setParamWithBottom();
      }
    } else {
      this.setParamWithoutBottom();
    }
  }

  private setParamWithoutNavigationIcons() {
    log.showInfo('setCardParam without navigationIcons');
    this.cardParam.cardMarginUpperHalf = {
      top: '12vp',
      left: '12vp',
      right: '12vp',
      bottom: '12vp'
    };
    this.cardParam.currNavDirectionHeight = '80vp';
    this.cardParam.currNavDirectionWidth = '80vp';
    this.cardParam.mainNavInfoSize = this.customerStyle.titleFontSize ?? $r('sys.float.ohos_id_text_size_headline7');
    this.cardParam.mainNavInfoWeight = FontWeight.Bold;
    this.cardParam.mainNavInfoColor = $r('sys.color.ohos_id_color_text_primary');
    this.cardParam.mainViceSpace = $r('sys.float.ohos_id_text_paragraph_margin_xs');
    this.cardParam.viceNavInfoSize = this.customerStyle.richTextFontSize ?? $r('sys.float.ohos_id_text_size_sub_title1');
    this.cardParam.viceNavInfoWeight = FontWeight.Regular;
    this.cardParam.viceNavInfoColor = $r('sys.color.ohos_id_color_text_secondary');
    this.cardParam.navInfoMargin = {
      start: LengthMetrics.vp(12),
      end: LengthMetrics.vp(0)
    };
    this.cardParam.navInfoAlignRule = {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: `nav-direction-icon-${this.baseData.hashCode}`, align: HorizontalAlign.End },
      right: { anchor: `nav-app-icon-${this.baseData.hashCode}`, align: HorizontalAlign.End },
    };
    this.cardParam.appIconHeight = '24vp';
    this.cardParam.appIconWidth = '24vp';
    this.cardParam.appIconAlignRule = {
      top: { anchor: `__container__`, align: VerticalAlign.Top },
      right: { anchor: '__container__', align: HorizontalAlign.End },
    };
  }

  private setParamWithBottom() {
    log.showInfo('setCardParam with bottom');
    this.cardParam.cardMarginUpperHalf = {
      top: '12vp',
      left: '12vp',
      right: '12vp',
      bottom: '4vp'
    };
    this.cardParam.cardMarginBottomHalf = {
      top: '0vp',
      left: '12vp',
      right: '12vp',
      bottom: '12vp'
    };
    this.cardParam.cardBottomHalfHeight = '44vp';
    this.cardParam.currNavDirectionHeight = '64vp';
    this.cardParam.currNavDirectionWidth = '64vp';
    this.cardParam.mainNavInfoSize = this.customerStyle.titleFontSize ?? $r('sys.float.ohos_id_text_size_headline8');
    this.cardParam.mainNavInfoWeight = FontWeight.Bold;
    this.cardParam.mainNavInfoColor = $r('sys.color.ohos_id_color_text_primary');
    this.cardParam.mainViceSpace = $r('sys.float.ohos_id_text_paragraph_margin_xs');
    this.cardParam.viceNavInfoSize = this.customerStyle.richTextFontSize ?? $r('sys.float.ohos_id_text_size_body2');
    this.cardParam.viceNavInfoWeight = FontWeight.Regular;
    this.cardParam.viceNavInfoColor = $r('sys.color.ohos_id_color_text_secondary');
    this.cardParam.navInfoMargin = {
      start: LengthMetrics.vp(12),
      end: LengthMetrics.vp(24),
    };
    this.cardParam.navInfoAlignRule = {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: `nav-direction-icon-${this.baseData.hashCode}`, align: HorizontalAlign.End },
      right: { anchor: `nav-app-icon-${this.baseData.hashCode}`, align: HorizontalAlign.Start },
    };
    this.cardParam.appIconHeight = '24vp';
    this.cardParam.appIconWidth = '24vp';
    this.cardParam.appIconAlignRule = {
      top: { anchor: `__container__`, align: VerticalAlign.Top },
      right: { anchor: '__container__', align: HorizontalAlign.End },
    };
  }

  private setParamWithoutBottom() {
    log.showInfo('setCardParam without bottom');
    this.cardParam.cardMarginUpperHalf = {
      top: '9vp',
      bottom: '9vp',
      left: '12vp',
      right: '12vp',
    };
    this.cardParam.currNavDirectionHeight = '48vp';
    this.cardParam.currNavDirectionWidth = '48vp';
    this.cardParam.mainNavInfoSize = this.customerStyle.titleFontSize ?? $r('sys.float.ohos_id_text_size_sub_title3');
    this.cardParam.mainNavInfoWeight = this.customerStyle.titleFontWeight ?? FontWeight.Medium;
    this.cardParam.mainNavInfoColor = $r('sys.color.ohos_id_color_text_primary');
    this.cardParam.mainViceSpace = $r('sys.float.ohos_id_text_margin_vertical');
    this.cardParam.viceNavInfoSize = this.customerStyle.richTextFontSize ?? $r('sys.float.ohos_id_text_size_body2');
    this.cardParam.viceNavInfoWeight = FontWeight.Regular;
    this.cardParam.viceNavInfoColor = $r('sys.color.ohos_id_color_text_secondary');
    this.cardParam.navInfoMargin = {
      start: LengthMetrics.vp(12),
      end: LengthMetrics.vp(24),
    };
    this.cardParam.navInfoAlignRule = {
      center: { anchor: '__container__', align: VerticalAlign.Center },
      left: { anchor: `nav-direction-icon-${this.baseData.hashCode}`, align: HorizontalAlign.End },
      right: { anchor: `nav-app-icon-${this.baseData.hashCode}`, align: HorizontalAlign.Start },
    };
    this.cardParam.appIconHeight = '24vp';
    this.cardParam.appIconWidth = '24vp';
    this.cardParam.appIconAlignRule = {
      center: { anchor: `nav-direction-icon-${this.baseData.hashCode}`, align: VerticalAlign.Center },
      right: { anchor: '__container__', align: HorizontalAlign.End },
    };
  }

  /**
   * 固定区域高度
   */
  private getFixedAreaHeight(): number {
    if (this.isSmallFoldOuterScreen) {
      return LiveViewCommonConstants.SMALL_FOLD_OUTER_CARD_FIXED_AREA_HEIGHT;
    }
    let height = 0;
    if (this.cardParam?.hasNavDirectionIcons) {
      if (!this.data.isNavigationIconsDisplayed && !this.shouldHideContent()) {
        height = 120;
      } else {
        height = 72;
      }
    } else {
      height = 48;
    }
    return LiveViewCommonConstants.getCardHeight(
      height,
      this.fontScaleState.getFontScale(this.outerHomeVm.isIgnoreFontScaleState),
      LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA
    );
  }

  private getRichAccessibilityText(): string {
    let text: string = '';
    this.data?.richContent?.forEach((entry: RichText, index: number) => {
      text += this.data.transformTimerAccessibilityText(entry?.text ?? '', this.timerData);
    })
    return text;
  }

  private getDividerVisibility(): Visibility {
    if (this.isSmallFoldOuterScreen) {
      return Visibility.Hidden;
    }
    return this.data?.isDisplayHorizontalLine ? Visibility.Visible : Visibility.None;
  }


  /*
   * 优先使用图标32，并并套用公式一；当w值<6时，图标向下缩小档位
   * 公式一：w=（卡宽-图标大小*n）/n+1
   */
  private getNavDirsSize(): string {
    if (this.isSmallFoldOuterScreen) {
      return '20vp';
    }

    if (this.checkNavDirsSize(32)) {
      return '32vp';
    } else if (this.checkNavDirsSize(28)) {
      return '28vp';
    } else {
      return '24vp';
    }
  }

  private checkNavDirsSize(iconSize: number): boolean {
    const iconNum = this.data?.navDirectionIcons?.length ?? 0;

    if (iconNum && this.navDirsWidth) {
      return (this.navDirsWidth - iconSize * iconNum) / (iconNum + 1) >= 6;
    }

    return true;
  }

  private shouldHideContent(): boolean {
    return this.baseData?.shouldHideContent(this.useScene, this.isNeedBannerInScreenLock,
      this.isShowBannerFromScreenLock);
  }

  private getTitleFontColor(): number | Resource | string | undefined {
    if (this.isOuterScreenImmersiveLive2()) {
      return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
    }
    return this.cardParam?.mainNavInfoColor;
  }

  getImgColorFilter(): ColorFilter | undefined {
    if (this.isOuterScreenImmersiveLive2()) {
      return this.data?.layoutNavigationIconMimeType === 'svg' || this.data?.layoutNavigationIconMimeType === 'png' ?
      LiveStyle.WHITE_COLOR_FILTER : undefined;
    }
    return undefined;
  }

  private isOuterScreenImmersiveLive2(): boolean {
    return SystemUICcmConfig.instance.isEnabledLive2 && this.isSmallFoldOuterScreen && this.isImmersiveLive;
  }
}