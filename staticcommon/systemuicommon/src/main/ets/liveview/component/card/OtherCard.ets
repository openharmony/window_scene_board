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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { LiveProgressTemplate } from '../../data/template/LiveProgressTemplate';
import { LiveExtendType, LiveType, LiveUseScene, LiveViewCommonConstants } from '../../common/LiveConstants';
import { OtherBaseTemplate } from '../../data/template/OtherBaseTemplate';
import { LiveViewData } from '../../data/LiveViewData';
import { ProgressVisualComponent } from './OtherComponent/ProgressVisualComponent';
import { ScoreComponent } from './OtherComponent/ScoreComponent';
import { PickUpComponent } from './OtherComponent/PickUpComponent';
import { FlightComponent } from './OtherComponent/FlightComponent';
import { LivePickUpTemplate } from '../../data/template/LivePickUpTemplate';
import { LiveScoreTemplate } from '../../data/template/LiveScoreTemplate';
import { LiveFlightTemplate } from '../../data/template/LiveFlightTemplate';
import { ExtendComponent } from './OtherComponent/ExtendComponent';
import { LiveOtherExtendData } from '../../data/extend/LiveOtherExtendData';
import { RichText as CustRichText } from '../../data/template/LiveBaseTemplate';
import { DarkModeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { CardUtils } from './LiveViewCardData';
import { CardAuthorization } from './CardAuthorization';
import { bannerMgr } from '../../../banner/phone/BannerManager';
import { BannerPanelType, BannerState } from '../../../banner/common/info/BannerState';
import { immersiveKgMgr } from '../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { ObservedItem } from '../../../model/ObservedModel';
import { fontScaleManager } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleManager';
import { FontScaleState } from '@ohos/systemuiutils/src/main/ets/fontScale/fontScaleState';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import { LiveCustomerStyle } from '../../info/card/LiveCustomerStyle';
import { ColorModeViewData } from '../../../template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '../../../template/newStyle/ColorModeViewModel';
import { NotificationType } from '../../../constants/NotificationType';
import { AccessibilityAppName } from '../../../accessibility/AccessibilityAppName';
import { BrightnessOptionUtils } from '../../../template/newStyle/BrightnessOptionUtils';
import { LiveAccessibilityUtil } from '../../common/liveAccessibilityUtil';
import { LengthMetrics } from '@kit.ArkUI';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { OuterHomeVm } from '../../../../ets/vm/OuterHomeVm'
import { ServiceButtonComponent } from './OtherComponent/ServiceButtonComponent';
import uiEffect from '@ohos.graphics.uiEffect';
import { LiveCardWeatherUtil } from '../../../utils/LiveCardWeatherUtil';
import { WeatherType, WeatherScene, PriorityWeatherScene } from '../../../live/model/LiveWeatherModel';
import { LiveStyle } from '../../../live/constants/LiveStyle';
import { SystemUICcmConfig } from '../../../utils/SystemUICcmConfig'
import { LiveCardShowAnimationEvent } from '../../../event/LiveCardShowAnimationEvent';
import { InnerEventUtil } from '../../../utils/InnerEventUtil'
import { DropdownVm } from '../../../vm/DropdownVm';
import { EnvVm } from '../../../vm/EnvVm';
import { TargetPanel } from '@ohos/frameworkwrapper';
import { LiveCardWeatherBackgroundView,
  weatherAnimationGradient } from '../../../live/view/LiveCardWeatherBackgroundView';

const TAG = LiveViewCommonConstants.LOG_PREFIX + 'OtherCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const LEFT_LARGE_ICON_RADIUS: Resource = $r('app.float.live_view_left_large_icon_radius');
const HEALTH = 'com.ohos.health';
const TIMER_REG = /\$\{placeholder.timer\}/;

/**
 * 三方卡片
 */
@Component
export struct OtherCard {
  @ObjectLink baseData: LiveViewData;
  @ObjectLink data: OtherBaseTemplate;
  @ObjectLink timerData: LiveTimerData;
  @StorageLink('Notification_DarkModeModel_DarkModeStatus') darkModeState: DarkModeState = new DarkModeState();
  useScene: LiveUseScene = LiveUseScene.SCENE_LIVE_LIST;
  isImmersiveLive: boolean = false;
  showAuthorizationTip: boolean = false;
  customerStyle: LiveCustomerStyle = new LiveCustomerStyle();
  @State bannerState: BannerState = bannerMgr.getBannerState();
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  /**
   * 长辈模式字体
   */
  @State fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  @Prop isSmallFoldOuterScreen: boolean = false;

  @Prop isNeedBannerInScreenLock: boolean = false;
  @Prop isShowBannerFromScreenLock: boolean = false;
  @State outerHomeVm: OuterHomeVm = OuterHomeVm.get();
  /**
   * 应用名称
   */
  @State appName?: ObservedItem<string> = undefined;

  @State liveVisualEffect?: uiEffect.VisualEffect = undefined;

  aboutToAppear() {
    log.showInfo('aboutToAppear, layout type=' + this.data?.layoutType);
    this.appName = this.baseData?.appName;
    if (SystemUICcmConfig.instance.isEnabledLive2 && this.baseData?.liveType === LiveType.FLIGHT) {
      InnerEventUtil.on(LiveCardShowAnimationEvent, this.onLiveCardAnimationEventChange);
      this.setAppearAnimation();
    }
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    InnerEventUtil.off(LiveCardShowAnimationEvent, this.onLiveCardAnimationEventChange);
  }

  build() {
    RelativeContainer() {
      if (this.data.layoutType === LiveType.FLIGHT) {
        if ((this.data as LiveFlightTemplate).liveCardWeatherInfo?.showType === PriorityWeatherScene.MOON_SCENE ||
          (this.data as LiveFlightTemplate).liveCardWeatherInfo?.showType === PriorityWeatherScene.SUNSET_SCENE ||
        LiveCardWeatherUtil.instance.isNeedCloudBackground((this.data as LiveFlightTemplate).liveCardWeatherInfo)) {
          LiveCardWeatherBackgroundView({
            weatherInfo: (this.data as LiveFlightTemplate).liveCardWeatherInfo,
            contentId: LiveViewCommonConstants.getItemContentId(this.baseData?.hashCode, this.useScene),
            scene: this.useScene === LiveUseScene.SCENE_SCREEN_LOCK ? WeatherScene.NOTIFICATION_CENTER :
            WeatherScene.LIVE_LIST_OR_HEADS_UP,
            cardHeight: this.getWeatherBackgroundHeight(),
          })
        }
        if ((this.data as LiveFlightTemplate).liveCardWeatherInfo?.showType === PriorityWeatherScene.WEATHER_SCENE) {
          Stack({ alignContent: Alignment.TopEnd }) {
            Column() {
            }
            .borderRadius($r('app.float.live_view_card_border_radius'))
            .clip(true)
            .visualEffect(this.liveVisualEffect)
            .opacity(EnvVm.instance.isScreenOff ? 0 : 1)
            .accessibilityLevel('no')
            .rotate({ y: 1, angle: RTLUtil.isRTL() ? 180 : 0 })
            .hitTestBehavior(HitTestMode.None)
            .width('60%')
            .height(this.getWeatherBackgroundHeight())

            weatherAnimationGradient({ cardHeight: this.getWeatherBackgroundHeight() })
          }
          .blendMode(1000, BlendApplyType.OFFSCREEN)
          .hitTestBehavior(HitTestMode.None)
        }
      }
      Column() {
        Row({ space: 12 }) {
          if (!this.isImmersiveLive) {
            Image(this.data?.getSmallIcon() ?? this.data?.getAppIcon())
              .width($r('app.float.live_view_card_large_icon_width'))
              .height($r('app.float.live_view_card_large_icon_height'))
              .borderRadius(LEFT_LARGE_ICON_RADIUS)
              .objectFit(ImageFit.Contain)
              .draggable(false)
              .interpolation(ImageInterpolation.Medium)
              .onClick(this.baseData?.getIconClickListener(this.useScene, this.isNeedBannerInScreenLock,
                this.isShowBannerFromScreenLock))
              .opacity(1)
              .autoResize(false)
          }
          Column() {
            AccessibilityAppName({
              name: LiveAccessibilityUtil.getAccessibilityAppName(this.baseData),
              isAccessibilityMode: this.isAccessibilityMode
            })
            this.constructTitle()
            this.constructRichText()
          }
          .padding(this.isSmallFoldOuterScreen ? undefined : {
            top: $r('app.float.live_view_card_padding_top_bottom'),
            bottom: $r('app.float.live_view_card_padding_top_bottom')
          })
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          if (!this.shouldHideContent()) {
            ExtendComponent({
              data: this.data?.getExtendData(LiveExtendType.TYPE_OTHER_EXTEND) as LiveOtherExtendData,
              useSysIconSize: this.isHideLayout(),
              foreBrightnessOption: this.getLiveExtendTextColor(),
              bgBrightnessOption: this.getLiveExtendButtonBgColor(),
              capsuleBackgroundColor: this.getCapsuleBackgroundColor(),
              baseData: this.baseData,
              useScene: this.useScene,
              isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
              isImmersiveLive: this.isImmersiveLive
            })
          }
        }
        .width('100%')
        .height(this.getFixedAreaHeight())
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(VerticalAlign.Center)
        .padding(this.isSmallFoldOuterScreen ? undefined : {
          left: CardUtils.LIVE_VIEW_CARD_PADDING,
          right: CardUtils.LIVE_VIEW_CARD_PADDING,
        })

        this.buildBottomZone()
      }
      .borderRadius($r('app.float.live_view_card_border_radius'))
      .clip(this.isSmallFoldOuterScreen ? false : true)
      .id(LiveViewCommonConstants.getItemContentId(this.baseData?.hashCode, this.useScene))
      .margin({
        top: this.customerStyle.cardMarginTop ?? undefined,
        bottom: this.customerStyle.cardMarginBottom ?? undefined,
        left: this.customerStyle.cardMarginHorizontal ?? undefined,
        right: this.customerStyle.cardMarginHorizontal ?? undefined
      })
    }
    .height('auto')
    .width('100%')
  }

  @Builder
  buildBottomZone() {
    if (this.baseData?.liveType === LiveType.PROGRESS) {
      Stack() {
        Row () {
          this.buildHideContent()
        }
        .visibility(this.shouldHideContent() ? Visibility.Visible : Visibility.Hidden)

        ProgressVisualComponent({
          data: this.baseData?.template as LiveProgressTemplate,
          hashcode: this.baseData.hashCode,
          useScene: this.useScene,
          isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
        })
          .visibility(this.shouldHideContent() ? Visibility.Hidden : Visibility.Visible)
      }
    } else if (this.baseData?.liveType === LiveType.PICK_UP) {
      if (this.shouldHideContent()) {
        this.buildHideContent()
      } else {
        PickUpComponent({
          data: this.baseData?.template as LivePickUpTemplate,
          timerData: this.timerData,
          isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
        })
      }
    } else if (this.baseData?.liveType === LiveType.FLIGHT) {
      if (this.shouldHideContent()) {
        this.buildHideContent()
      } else {
        FlightComponent({
          data: this.baseData?.template as LiveFlightTemplate,
          dividerBrightnessOption: this.colorModeViewData.foregroundDividerOption,
          isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
        })
      }
    } else if (this.baseData?.liveType === LiveType.SCORE) {
      if (this.shouldHideContent()) {
        this.buildHideContent()
      } else {
        ScoreComponent({
          data: this.baseData?.template as LiveScoreTemplate,
          timerData: this.timerData,
          dividerBrightnessOption: this.colorModeViewData.foregroundDividerOption,
          isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
        })
      }
    }

    if (this.showAuthorizationTip && this.baseData?.showAuthorization) {
      CardAuthorization({ dataTemplate: this.data, baseData: this.baseData, useScene: this.useScene })
    } else if (!this.shouldHideContent() && this.data.isShowServiceButton()) {
      ServiceButtonComponent({
        baseData: this.baseData,
        data: this.data,
        useScene: this.useScene,
      })
    }
  }

  @Builder
  buildHideContent() {
    Row() {
      Row() {
        Text($r('app.string.live_view_hide_tip'))
          .fontColor($r('sys.color.ohos_id_color_text_tertiary'))
          .fontSize(this.fontScaleState.getScaleSize($r('sys.float.ohos_id_text_size_body2')))
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
    .height(this.customerStyle.bottomHalfHeight ?? 72)
  }

  @Builder
  constructTitle() {
    if (this.baseData?.appIndex > 0) {
      this.buildCardTextCloneLabel()
    } else {
      this.buildCardTitle()
    }
  }

  @Builder
  buildCardTitle() {
    Text(this.getTitleText())
      .accessibilityText(this.getTitleAccessibilityText())
      .fontFamily('HarmonyHeiTi')
      .fontWeight(this.getFontWeight())
      .maxFontSize(this.getTitleFontSize())
      .minFontSize(this.customerStyle.titleMinFontSize ?? $r('app.float.live_view_other_card_title_min_font_size'))
      .maxFontScale(this.outerHomeVm.isIgnoreFontScaleState ? 1 : this.customerStyle.titleMaxFontScale ?? undefined)
      .fontFeature('\"ss08\" on')
      .fontColor(this.getTitleFontColor())
      .wordBreak(WordBreak.BREAK_ALL)
      .textAlign(TextAlign.Start)
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .margin(this.isAodOnlyShowTitleTimer() ? undefined : { bottom: this.getTextBottomMargin() })
      .lineHeight(this.getLineHeight())
      .renderGroup(true)
  }

  @Builder
  buildCardTextCloneLabel() {
    Row() {
      this.buildCardTitle()
    }
  }

  @Builder
  constructRichText() {
    if (this.data?.richContent) {
      Text() {
        if (this.shouldHideContent()) {
          Span(this.baseData?.contentHideText)
            .fontColor(this.getHideContentFontColor())
            .fontWeight(FontWeight.Regular)
        } else {
          ForEach(this.data?.richContent, (entry: CustRichText, index: number) => {
            Span(this.getRichText(entry))
              .fontColor(this.getRichTextColor(entry))
              .fontWeight(this.getRichTextFontWeight(entry))
          })
        }
      }
      .visibility(this.isAodOnlyShowTitleTimer() ? Visibility.None : Visibility.Visible)
      .accessibilityText(this.getRichAccessibilityText())
      .fontFamily('HarmonyHeiTi')
      .fontWeight(FontWeight.Regular)
      .fontSize(this.getRichTextFontSize())
      .fontFeature('\"ss08\" on')
      .textAlign(TextAlign.Start)
      .maxLines(1)
      .wordBreak(WordBreak.BREAK_ALL)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .renderGroup(true)
      .lineHeight(this.fontScaleState.getScaleSize(this.customerStyle.richTextLineHeight ??
      $r('app.float.live_view_card_text_line_height'), this.outerHomeVm.isIgnoreFontScaleState))
    }
  }

  private getTitleText(isAccessibilityText: boolean = false): string {
    if (this.shouldHideContent()) {
      return this.appName?.value ?? '';
    }
    let text: string = '';
    if (isAccessibilityText) {
      text = this.data.transformTimerAccessibilityText(this.data.title ?? '', this.timerData);
    } else {
      text = this.data.getTitleText(this.data.title ?? '', this.timerData);
    }
    let isHealth: boolean = this.baseData?.creatorBundleName === HEALTH;
    if (isHealth && typeof text === 'string') {
      return text.replace(LiveViewCommonConstants.NUM_REGX, LiveViewCommonConstants.NUM_FUZZ);
    }
    return text;
  }

  private getTitleAccessibilityText(): string {
    return this.getTitleText(true);
  }

  private getRichText(entry: CustRichText, isAccessibilityText: boolean = false): string {
    let text: string = '';
    if (isAccessibilityText) {
      text = this.data.transformTimerAccessibilityText(entry.text ?? '', this.timerData);
    } else {
      text = this.data.transformTimerText(entry.text ?? '', this.timerData);
    }
    let isHealth: boolean = this.baseData?.creatorBundleName === HEALTH;
    if (isHealth && typeof text === 'string') {
      return text.replace(LiveViewCommonConstants.NUM_REGX, LiveViewCommonConstants.NUM_FUZZ);
    }
    return text;
  }

  private getRichAccessibilityText(): string {
    if (this.shouldHideContent()) {
      return this.baseData?.contentHideText ?? '';
    }
    let text: string = '';
    this.data?.richContent?.forEach((entry: CustRichText, index: number) => {
      text += this.getRichText(entry, true);
    })
    return text;
  }

  private getTitleFontSize(): string {
    if (this.isImmersiveLive) {
      return this.fontScaleState.getScaleSize(this.customerStyle.titleFontSize, this.isSmallFoldOuterScreen);
    }
    return this.fontScaleState.getScaleSize(this.isHideLayout()
      ? $r('sys.float.ohos_id_text_size_sub_title3')
      : $r('app.float.live_view_other_card_title_font_size'), this.outerHomeVm.isIgnoreFontScaleState)
  }

  private getLineHeight(): string {
    return this.fontScaleState.getScaleSize(this.customerStyle.titleLineHeight ?? this.isHideLayout()
      ? $r('app.float.live_view_card_text_line_height')
      : $r('app.float.live_view_card_hide_layout_height'), this.outerHomeVm.isIgnoreFontScaleState)
  }

  private getFontWeight(): FontWeight {
    return this.customerStyle.titleFontWeight ?? (this.isHideLayout() ? FontWeight.Medium : FontWeight.Bold)
  }

  private getRichTextFontSize(): string {
    if (this.isImmersiveLive) {
      return this.fontScaleState.getScaleSize(this.customerStyle.richTextFontSize,
        this.outerHomeVm.isIgnoreFontScaleState);
    }
    return this.fontScaleState.getScaleSize($r('sys.float.ohos_id_text_size_body2'),
      this.outerHomeVm.isIgnoreFontScaleState)
  }

  private getRichTextFontWeight(entry: CustRichText): FontWeight {
    if (this.isImmersiveLive) {
      return entry?.getCurrentTextColor() ? FontWeight.Bold : FontWeight.Regular
    }
    return FontWeight.Regular
  }

  private getRichTextColor(entry: CustRichText): string | number | Resource | undefined {

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

  /**
   * 是否隐藏扩展区
   */
  private isHideLayout(): boolean {
    return this.baseData?.liveType === LiveType.NO_LAYOUT;
  }

  /**
   * 固定区域高度
   */
  private getFixedAreaHeight(): number {
    let originalHeight: number = 0;
    let fixedAreaHeight = this.customerStyle.fixedAreaHeight;
    if (fixedAreaHeight !== undefined) {
      originalHeight = ResUtils.getNumber(fixedAreaHeight);
    } else {
      originalHeight = this.isHideLayout() ? 66 : 72;
    }
    return LiveViewCommonConstants.getCardHeight(
      originalHeight,
      this.fontScaleState.getFontScale(this.outerHomeVm.isIgnoreFontScaleState),
      LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA
    );
  }

  private getWeatherBackgroundHeight(): number {
    return this.getFixedAreaHeight() + (this.isSmallFoldOuterScreen ? 46 : 72);
  }

  /**
   * 获取非锁屏胶囊状态下, 实况辅助区按钮背景颜色
   */
  private getCapsuleBackgroundColor(): string | Resource {
    if (!this.baseData?.isAtomicServiceFromPush &&
      this.baseData?.liveType === LiveType.PICK_UP &&
      this.baseData?.capsule?.backgroundColor) {
      return this.baseData?.capsule?.backgroundColor;
    } else {
      return $r('app.color.ntf_brightness_bg_color');
    }
  }

  /**
   * 非胶囊状态下, 实况辅助区文字提亮: foregroundSecondaryOption
   */
  private getLiveExtendTextColor(): BrightnessOptions | undefined {
    return this.colorModeViewData.foregroundSecondaryOption;
  }

  /**
   * aod模式 非胶囊状态下, 实况辅助区按钮背板提亮: aodTimeLightOptionForButtonBgColor
   * 非胶囊状态下, 实况辅助区按钮背板提亮: ntfLiveExtendButtonBgOption
   */
  private getLiveExtendButtonBgColor(): BrightnessOptions | undefined {
    return this.colorModeViewData.ntfLiveExtendButtonBgOption;
  }

  private getTextBottomMargin(): Resource {
    if (this.isSmallFoldOuterScreen) {
      return $r('app.float.live_view_card_title_margin_bottom');
    }
    return this.isHideLayout() ? $r('app.float.live_view_card_title_margin_bottom') :
    $r('app.float.live_view_other_card_title_margin_bottom');
  }

  private shouldHideContent(): boolean {
    return this.baseData?.shouldHideContent(this.useScene, this.isNeedBannerInScreenLock,
      this.isShowBannerFromScreenLock);
  }

  public onLiveCardAnimationEventChange = (event: LiveCardShowAnimationEvent): void => {
    if (!this.checkScene()) {
      return;
    }
    log.showInfo(`onLiveCardAnimationEventChange: ${this.useScene} ${event.EVENT_SHOW_DELAY}`);
    const duration = this.useScene === LiveUseScene.SCENE_SCREEN_LOCK ? LiveStyle.WEATHER_AOD_ANIMATION_DURATION :
      LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION
    this.setWeatherAnimation(duration, event.EVENT_SHOW_DELAY);
  }

  public setWeatherAnimation(duration: number, delay: number = 0): void {
    if (this.baseData?.liveType !== LiveType.FLIGHT) {
      this.liveVisualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(false, duration, WeatherType.WEATHER_TYPE_INVALID);
      return;
    }
    const template = this.data as LiveFlightTemplate;
    if (template.liveCardWeatherInfo?.showType === PriorityWeatherScene.INVALID_SCENE) {
      this.liveVisualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(false, duration, WeatherType.WEATHER_TYPE_INVALID);
      return;
    }
    if (!SystemUICcmConfig.instance.liveConfig.isShowWeatherAnimationWhenExpandCard()) {
      this.setStaticEffect();
      return;
    }
    this.setStaticEffect();
    setTimeout(() => {
      this.liveVisualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(true, duration, template?.liveCardWeatherInfo?.weatherType);
    }, delay);
  }

  private setStaticEffect(): void {
    if (!this.baseData) {
      return;
    }
    if (this.baseData?.liveType !== LiveType.FLIGHT) {
      return;
    }
    const template = this.data as LiveFlightTemplate;
    if (template.liveCardWeatherInfo?.showType === PriorityWeatherScene.INVALID_SCENE) {
      this.liveVisualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(false, LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION,
          WeatherType.WEATHER_TYPE_INVALID);
      return;
    }
    this.liveVisualEffect =
      LiveCardWeatherUtil.instance.setHdsEffect(false, 0, template?.liveCardWeatherInfo?.weatherType);
    setTimeout(() => {
      this.liveVisualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(true, 0, template?.liveCardWeatherInfo?.weatherType);
    }, 0);
  }

  private checkScene(): boolean {
    let currentScene = '';
    if (DropdownVm.instance.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL &&
      this.useScene === LiveUseScene.SCENE_NTF_CENTER) {
      currentScene = LiveUseScene.SCENE_NTF_CENTER;
    } else if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST) &&
      this.useScene === LiveUseScene.SCENE_LIVE_LIST) {
      currentScene = LiveUseScene.SCENE_LIVE_LIST;
    } else if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP) &&
      this.useScene === LiveUseScene.SCENE_HEADS_UP) {
      currentScene = LiveUseScene.SCENE_HEADS_UP;
    } else if (EnvVm.instance.isScreenLock && this.useScene === LiveUseScene.SCENE_SCREEN_LOCK) {
      currentScene = LiveUseScene.SCENE_SCREEN_LOCK;
    }
    if (currentScene !== '' && currentScene === this.useScene) {
      return true;
    }
    return false;
  }

  private setAppearAnimation(): void {
    if (DropdownVm.instance.isDropDown) {
      this.setWeatherAnimation(LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION, 5);
      return;
    }
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
      this.setWeatherAnimation(LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION, 5);
      return;
    }
    if (EnvVm.instance.isScreenLock && !EnvVm.instance.isScreenOff) {
      this.setWeatherAnimation(LiveStyle.WEATHER_AOD_ANIMATION_DURATION, 5);
      return;
    }
  }

  isTitleTimer(): boolean {
    return TIMER_REG.test(this.data.title ?? '');
  }

  isContentTimer(): boolean {
    return this.data?.richContent !== undefined && this.data.richContent.some(
      (entry: CustRichText, index: number) => TIMER_REG.test(entry?.text ?? ''));
  }

  isAodOnlyShowTitleTimer(): boolean {
    return !this.shouldHideContent() &&
      this.isTitleTimer() && this.isContentTimer();
  }

  getAodTimerText(): string {
    return ResUtils.getInnerString(this.timerData?.isCountDown ?
      $r('app.string.aod_count_down_timer_text') :
      $r('app.string.aod_timing_timer_text'));
  }

  private isOuterScreenImmersiveLive2(): boolean {
    return SystemUICcmConfig.instance.isEnabledLive2 && this.isSmallFoldOuterScreen && this.isImmersiveLive;
  }

  private getTitleFontColor(): number | Resource | string | undefined {
    if (this.isOuterScreenImmersiveLive2()) {
      return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
    }
    return 'sys.color.ohos_id_color_text_primary';
  }

  private getHideContentFontColor(): number | Resource | string | undefined {
    if (this.isOuterScreenImmersiveLive2()) {
      return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
    }
    return $r('sys.color.ohos_id_color_text_secondary');
  }
}