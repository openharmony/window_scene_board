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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { ConfigurationEvent, GlobalContext } from '@ohos/frameworkwrapper';
import { ResUtils, SCBScreenSessionManager } from '@ohos/windowscene';
import { ThemeActiveEvent } from '../event/ThemeActiveEvent';
import { LiveStyle } from '../live/constants/LiveStyle';
import { BrightnessOptionUtils } from '../template/newStyle/BrightnessOptionUtils';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { Singleton } from '../utils/Singleton';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { SystemEffectVm } from './SystemEffectVm';
import { effectKit } from '@kit.ArkGraphics2D';
import lazy { SolidColorAlgorithmUtils } from '@ohos/basicutils/src/main/ets/utils/SolidColorAlgorithmUtils';
import { getAvgColor } from '../utils/ColorInvertTool';
import { ScreenLockAdapter } from '../adapter/ScreenLockAdapter';

const TAG = 'SystemUIColorVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

enum ThemeColorType {
  NTF_TEXT_PRIMARY_COLOR,
  NTF_TEXT_SECONDARY_COLOR,
  NTF_TEXT_TERTIARY_COLOR,
  NTF_BG_COLOR
}

/**
 * 表示不同类型的快照或数据类型，用于区分不同的界面元素和截图区间
 */
export enum SnapshotType {
  /** 下拉菜单相关的快照类型 */
  Dropdown,
  /** 横幅广告或静态 banner 的快照类型 */
  Banner,
  /** 实时/动态 banner 的快照类型 */
  LiveBanner,
  /** 实时列表数据的快照类型 */
  LiveList
}

/**
 * SystemUI文本、背景提亮颜色VM
 */
@ThreadSync.VmDecorator
@ObservedV2
export class SystemUIColorVm {
  @Singleton.decorate()
  static get instance(): SystemUIColorVm { return new SystemUIColorVm(); }

  private static readonly HEADS_UP_BACKGROUND_RADIUS = 57;

  private static readonly HEADS_UP_BLUR_OPTIONS_GRAYSCALE = 38;

  private static readonly BG_COLOR_DEFAULT = 1728053247;

  private static readonly BG_COLOR_DARK = 1291845632;

  private static readonly NTF_ALL_CLEAR_BG_COLOR_DEFAULT = 1711276032;

  private static readonly NTF_ALL_CLEAR_BG_COLOR_DARK = 4278190080;

  public isBrightnessEffect: boolean = true;

  @Trace public isThemeActive: boolean = false;

  public colorMode: ConfigurationConstant.ColorMode | undefined = GlobalContext.getContext().config.colorMode;

  private readonly brightnessEffectResources: Resource[] = [$r('app.color.theme_ntf_color_text_primary'),
    $r('app.color.theme_ntf_color_text_secondary'), $r('app.color.theme_ntf_color_text_tertiary'),
    $r('app.color.ntf_blur_style_bg'), $r('app.color.ntf_phone_all_clear_bg_color')];

  private readonly brightnessResourceDefault: Resource[] = [$r('sys.color.ohos_id_color_text_primary'),
    $r('sys.color.ohos_id_color_text_secondary'),
    $r('sys.color.ohos_id_color_text_tertiary'),
    $r('app.color.ntf_bg_color_default'), $r('app.color.ntf_all_clear_bg_color_default')];

  private readonly brightnessResourceDark: Resource[] = [$r('sys.color.ohos_id_color_text_primary'),
    $r('sys.color.ohos_id_color_text_secondary'),
    $r('sys.color.ohos_id_color_text_tertiary'),
    $r('app.color.ntf_bg_color_dark'), $r('app.color.ntf_all_clear_bg_color_dark')];

  private ntfBrightnessResourceOverlayDefault: Array<Resource> = [$r('app.color.theme_ntf_color_text_primary')
    , $r('app.color.theme_ntf_color_text_no_brightness_secondary'),
    $r('app.color.theme_ntf_color_text_no_brightness_tertiary'),
    $r('app.color.ntf_blur_style_no_brightness_bg'), $r('app.color.ntf_phone_all_clear_no_brightness_bg_color')];

  private readonly brightnessConflictColors: Map<ThemeColorType, Resource> = new Map([
    [ThemeColorType.NTF_TEXT_PRIMARY_COLOR, $r('app.color.theme_ntf_color_text_primary')],
    [ThemeColorType.NTF_TEXT_SECONDARY_COLOR, $r('app.color.theme_ntf_color_text_secondary')],
    [ThemeColorType.NTF_TEXT_TERTIARY_COLOR, $r('app.color.theme_ntf_color_text_tertiary')],
    [ThemeColorType.NTF_BG_COLOR, $r('app.color.ntf_blur_style_bg')]
  ]);

  private readonly defaultColor: ResourceColor = $r('app.color.ntf_brightness_bg_color');

  /**
   * 一键删除按钮背景模糊参数
   */
  public ntfClearButtonBgEffect: BackgroundEffectOptions | undefined = { radius: 45 };
  /**
   * 通知卡片文字颜色
   */
  @Trace public fontColor: ResourceColor = this.defaultColor;

  /**
   * 通知中心实况卡片文字颜色
   */
  public ntfLiveFontColor: ResourceColor = this.defaultColor;

  /**
   * 通知卡片时间戳颜色
   */
  @Trace public timeFontColor: ResourceColor = this.defaultColor;

  /**
   * 通知卡片背景颜色
   */
  @Trace public ntfCardBgColor: ResourceColor = this.defaultColor;

  /**
   * 通知实况卡片背景颜色
   */
  @Trace public ntfLiveCardBgColor: ResourceColor = this.defaultColor;

  /**
   * 菜单按钮背景色
   */
  @Trace public buttonBgColor: ResourceColor = $r('app.color.ntf_phone_clear_bg_color');

  /**
   * 展开/收起按钮背景色
   */
  @Trace public extraButtonBgColor: ResourceColor = $r('app.color.ntf_extra_button_color');

  /**
   * 通知header时间提亮参数
   */
  @Trace public headerContentFgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundPrimaryOptionDark;

  /**
   * 菜单按钮前景提亮参数
   */
  @Trace public buttonBgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().backgroundNineDarkOption;

  /**
   * 通知按钮前景提亮参数
   */
  @Trace public actionButtonBgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().customActionViewBg;
  @Trace public actionBgBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().customActionViewBg;
  /**
   * 通知卡片文字前景提亮参数
   */
  @Trace public fontFgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundSecondaryOption;
  @Trace public fgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundSecondaryOption;

  /**
   * 通知中心实况卡片文字前景提亮参数
   */
  @Trace public ntfLiveFontFgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundSecondaryOption;

  /**
   * 实况卡片文字前景提亮参数
   */
  public liveFontFgBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption;

  /**
   * 通知卡片时间戳前景提亮参数
   */
  @Trace public timeFgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption;
  @Trace public tgBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption;
  /**
   * 通知卡片背景提亮参数
   */
  @Trace public cardBgBrightness?: BrightnessOptions;

  @Trace public bgBrightnessOption?: BrightnessOptions;

  /**
   * 通知中心实况卡片背景提亮参数
   */
  @Trace public cardLiveBgBrightness?: BrightnessOptions;

  /**
   * 剩余通知数量背景提亮参数
   */
  @Trace public remainderBgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBg;
  @Trace public remainderBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBg;
  /**
   * 通知卡片分割线前景提亮参数
   */
  @Trace public dividerFgBrightness?: BrightnessOptions;
  @Trace public dividerBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundDividerOption;
  /**
   * 实况卡片分割线前景提亮参数
   */
  @Trace public liveCardDividerFgBrightness: BrightnessOptions =
    BrightnessOptionUtils.getInstance().foregroundDividerDarkOption;

  /**
   * 横幅卡片背景颜色
   */
  @Trace public bannerCardBgColor: ResourceColor = this.defaultColor;

  /**
   * 横幅卡片背景提亮参数
   */
  @Trace public bannerCardBgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().bannerCardOption;
  @Trace public bannerBgBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().bannerCardOption;
  /**
   * 实况横幅卡片背景颜色
   */
  @Trace public bannerLiveCardBgColor: ResourceColor = this.defaultColor;

  /**
   * 实况横幅卡片背景提亮参数
   */
  @Trace public bannerLiveCardBgBrightness: BrightnessOptions | undefined = BrightnessOptionUtils.getInstance().bannerCardOption;

  /**
   * 实况卡片辅助区文本提亮参数
   */
  @Trace public extendFontFgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundSecondaryDarkOption;

  /**
   * 实况卡片辅助区按钮背景提亮参数
   */
  @Trace public extendButtonBgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBgDark;

  /**
   * 实况卡片背景提亮参数
   */
  public liveCardBgBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().bannerCardDarkOption;
  /**
   * 充电进度环提亮参数
   */
  public progressBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().progressBrightnessOption;

  /**
   * 更多通知按钮背景提亮参数
   */
  @Trace public extraHeaderButtonBgBrightness?: BrightnessOptions =
    BrightnessOptionUtils.getInstance().backgroundSevenDarkOption;

  /**
   * 实况胶囊压暗参数
   */
  @Trace public capsuleBgBrightness: BrightnessOptions = BrightnessOptionUtils.getInstance().backgroundNineDarkOption;
  // 系统实况右侧按钮默认背景颜色
  @Trace public systemButtonBgBrightness: BrightnessOptions = BrightnessOptionUtils.systemLiveButtonBgCardOption;

  // 系统实况右侧按钮on状态背景颜色
  @Trace public systemButtonOnBgBrightness: BrightnessOptions = BrightnessOptionUtils.systemLiveButtonOnBgCardOption;

  // 系统实况右侧按钮off状态背景颜色
  @Trace public systemButtonOffBgBrightness: BrightnessOptions = BrightnessOptionUtils.systemLiveButtonOffBgCardOption;

  // 播控标题颜色
  @Trace public mediaCardTitleBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundPrimaryOptionLight;

  // 播控副标题颜色
  @Trace public mediaCardSubTitleBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundTertiaryGlossOption;

  // 播控投播按钮背景
  @Trace public mediaCardSwitchBgBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBgOn;

  // 播控投播按钮图标颜色
  @Trace public mediaCardSwitchOnBrightness?: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundPrimaryOnOptionLight;

  // 天气胶囊背景提亮
  @Trace public weatherButtonBrightness?: BrightnessOptions =
    BrightnessOptionUtils.getInstance().groupRemainderCount;

  // 录屏右侧按钮on状态背景颜色
  @Trace public screenRecordButtonOnBgBrightness: BrightnessOptions =
    BrightnessOptionUtils.systemLiveButtonOnBgCardOption;

  // 录屏右侧按钮off状态背景颜色
  @Trace public screenRecordButtonOffBgBrightness: BrightnessOptions =
    BrightnessOptionUtils.systemLiveButtonOffBgCardOption;

  /**
   * 导航资源赋色参数
   */
  @Trace public colorFilter: ColorFilter = LiveStyle.BLACK_COLOR_FILTER;

  /* 沉浸态下拉按钮背景提亮参数 */
  @Trace public circleButtonBgBrightnessOptions: BrightnessOptions| undefined = BrightnessOptionUtils.getInstance()
    .customWifiBg;

  /*通知中心摘要*/
  @Trace public ntfThemeTextSecondaryColor: ResourceColor | undefined = '';

  /*通知中心主题*/
  @Trace public ntfThemeTextPrimaryColor: ResourceColor | undefined = '';

  /*折叠*/
  @Trace public ntfExtraContentColor: ResourceColor | undefined = ''

  /*通知中心折叠三角图片*/
  @Trace public ntfButtonImageColor: ResourceColor | undefined = ''

  /**
   * 通知卡片已置顶颜色
   */
  @Trace public pinTopTextColor: ResourceColor = $r('app.color.theme_ntf_phone_pin_text_color');

  /*
   * 通知卡片菜单按钮背景颜色
   */
  @Trace public menuButtonBgColor: ResourceColor = $r('app.color.ntf_phone_clear_button_bg_color');
  /*
   * 组通知卡片菜单按钮背景颜色
   */
  @Trace public groupMenuButtonBgColor: ResourceColor = this.menuButtonBgColor;
  /*
   * 通知中心底部一键删除按钮背景颜色
   */
  @Trace public allClearButtonBgColor: ResourceColor = $r('app.color.ntf_phone_all_clear_bg_color');
  /*
   * 通知中心组通知多余数量容器背景颜色
   */
  @Trace public remainderCountColor: ResourceColor = $r('app.color.theme_ntf_phone_remaind_bg_color');
  /*
   * 通知中心组通知多余数量文字颜色
   */
  @Trace public ntfRemainderCountTextColor: ResourceColor = $r('app.color.theme_ntf_color_text_secondary');
  /*
   * 带按钮的通知的按钮颜色
   */
  @Trace public actionButtonBgColor: ResourceColor = $r('app.color.theme_ntf_phone_action_bg_color');
  /*
   * 通知中心组通知分割线颜色
   */
  @Trace public groupDividerColor: ResourceColor = $r('app.color.theme_ntf_phone_group_divider_color');
  /*
   * 通知中心组通知分割线颜色
   */
  @Trace public actionButtonDividerColor: ResourceColor = $r('app.color.theme_ntf_phone_action_divider_color');

  /*
  * 横幅沉浸式通知展开按钮颜色
  */
  @Trace public immersiveBannerExpandIconColor: ResourceColor = $r('app.color.tint_ntf_title_font_color_dark_mode');

  /**
   * 横幅背景模糊效果
   */
  public bannerBgBlurStyle?: BlurStyle = BlurStyle.BACKGROUND_REGULAR;

  /**
   * 横幅阴影
   */
  public bannerBgShadow?: ShadowStyle = ShadowStyle.OUTER_DEFAULT_MD;

  /**
   * 通知卡片主题时间戳提亮参数
   */
  public themeTimestampForegroundColor: ResourceColor = $r('app.color.ntf_brightness_bg_color');

  @Trace public liveListCardBgColor: ResourceColor = '#9f111111';

  /**
   * 菜单按钮背景色
   */
  @Trace public buttonNoBrightBgColor: ResourceColor = $r('app.color.ntf_phone_clear_button_bg_color');

  public liveListItemNoBrightnessBgEffect: BackgroundEffectOptions = {
    radius: 0,
    brightness: 1.01,
    blurOptions: { grayscale: [38, 38] }
  };

  @Trace public liveListItemBgEffect: BackgroundEffectOptions | undefined = undefined;

  public headsUpNoBrightnessBgEffect: BackgroundEffectOptions = {
    radius: 57,
    blurOptions: {
      grayscale: [38, 38]
    }
  };

  @Trace public headsUpBgEffect: BackgroundEffectOptions | undefined = { radius: 57 };

  /**
   * 通知卡片主题时间戳提亮参数
   */
  public themeTimestampForegroundBrightnessOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption;

  /*文字图片提亮压暗*/
  public foregroundPrimaryOption: BrightnessOptions | undefined = undefined;

  /* 通知提亮禁用 */
  public isNtfBrightnessDisable = false;

  /* 纯色模式CCM配置开启 */
  public isSolidColorEnable = false;

  public headsUpDefaultBgEffect: BackgroundEffectOptions = { radius: SystemUIColorVm.HEADS_UP_BACKGROUND_RADIUS };

  /**
   * 横幅模糊参数
   */
  public bannerBgEffect: BackgroundEffectOptions = this.headsUpDefaultBgEffect;

  // 纯色模式通知中心取色
  public ncPickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};

  // 纯色模式通知横幅取色
  public ntfBannerPickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};

  // 纯色模式实况横幅、列表背景取色
  public livePickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};

  // 纯色模式实况卡片背景颜色
  @Trace public liveBgPickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};

  public init(): void {
    this.isSolidColorEnable =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.CC_SOLID_COLOR_ENABLE) === 'true';
    this.isNtfBrightnessDisable =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.NTF_BRIGHTENS_DISABLE) === 'true';
    if (this.isNtfBrightnessDisable) {
      this.isBrightnessEffect = false;
    }

    InnerEventUtil.on(ConfigurationEvent, this.onConfigurationEvent.bind(this));

    this.checkThemeColor();
    this.updateColorMode();
    if (SystemEffectVm.instance.isBrightnessDisable) {
      this.liveListItemBgEffect = this.liveListItemNoBrightnessBgEffect;
      this.headsUpBgEffect = this.headsUpNoBrightnessBgEffect;
    }

    if (this.isSolidEnable()) {
      // 纯色模式，关闭模糊
      this.ntfClearButtonBgEffect = undefined;
    }
  }

  public destroy(): void {
    InnerEventUtil.off(ConfigurationEvent, this.onConfigurationEvent.bind(this));
  }

  protected onThemeActiveEvent(): void {
    log.showInfo('onThemeActiveEvent');
    // 主题切换的时候会向资源管理一起发事件，会有小概率产生获取到的颜色值还是未切换前的情况，使用setTimeout兜底
    setTimeout(() => {
      this.checkThemeColor();
      this.updateColorMode();
    }, 100);
  };

  protected onConfigurationEvent(event: ConfigurationEvent): void {
    log.showInfo(`onConfigurationEvent, colorMode: ${event.config?.colorMode}`);
    if (event.config?.colorMode !== undefined && event.config.colorMode !== this.colorMode) {
      this.colorMode = event.config.colorMode;
    }
    this.onThemeActiveEvent();
  };

  protected updateColorMode(): void {
    log.showInfo(`updateColorMode, colorMode: ${this.colorMode}, brightness effect： ${this.isBrightnessEffect}`);

    this.fontColor = this.getColor(this.getThemeColor(ThemeColorType.NTF_TEXT_SECONDARY_COLOR));
    this.timeFontColor = this.getColor(this.getThemeColor(ThemeColorType.NTF_TEXT_TERTIARY_COLOR));
    this.ntfCardBgColor = this.getColor(this.getThemeColor(ThemeColorType.NTF_BG_COLOR));
    this.themeTimestampForegroundColor = this.getColor(this.getThemeColor(ThemeColorType.NTF_TEXT_TERTIARY_COLOR));
    this.bannerCardBgColor = this.getColor(this.getThemeColor(ThemeColorType.NTF_BG_COLOR));
    this.ntfThemeTextSecondaryColor = $r('app.color.theme_ntf_color_text_secondary');
    this.ntfThemeTextPrimaryColor = $r('app.color.theme_ntf_color_text_primary');
    this.ntfExtraContentColor = $r('app.color.ntf_extra_content_color');
    this.ntfButtonImageColor = $r('app.color.ntf_extra_content_image_color');

    if (this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.actionBgBrightness = BrightnessOptionUtils.getInstance().customActionViewBg;
      this.dividerBrightness = BrightnessOptionUtils.getInstance().foregroundDividerOption;
      this.bgBrightnessOption = BrightnessOptionUtils.getInstance().backgroundFiveOption;
      this.fgBrightness = BrightnessOptionUtils.getInstance().foregroundSecondaryOption;
      this.tgBrightness = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption;
      this.bannerBgBrightness = BrightnessOptionUtils.getInstance().bannerCardOption;
      this.remainderBrightness = BrightnessOptionUtils.getInstance().customWifiBg;
      this.systemButtonBgBrightness = BrightnessOptionUtils.systemLiveButtonBgCardOption;
      this.systemButtonOnBgBrightness = BrightnessOptionUtils.systemLiveButtonOnBgCardOption;
      this.systemButtonOffBgBrightness = BrightnessOptionUtils.systemLiveButtonOffBgCardOption;
      this.screenRecordButtonOnBgBrightness = BrightnessOptionUtils.systemLiveButtonOnBgCardDarkOption;
      this.screenRecordButtonOffBgBrightness = BrightnessOptionUtils.systemLiveButtonOffBgCardDarkOption;
      this.colorFilter = LiveStyle.BLACK_COLOR_FILTER;
      this.mediaCardTitleBrightness = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight;
      this.mediaCardSwitchBgBrightness = BrightnessOptionUtils.getInstance().customWifiBgOn;
      this.mediaCardSwitchOnBrightness = BrightnessOptionUtils.getInstance().foregroundPrimaryOnOptionLight;
      this.mediaCardSubTitleBrightness = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption;
      this.foregroundPrimaryOption = undefined;
      this.cardLiveBgBrightness = BrightnessOptionUtils.getInstance().backgroundFiveOption;
      this.ntfLiveFontFgBrightness = BrightnessOptionUtils.getInstance().foregroundSecondaryOption;
      this.liveListItemBgEffect =
        SystemEffectVm.instance.isBrightnessDisable ? this.liveListItemNoBrightnessBgEffect : undefined;
      this.headsUpBgEffect =
        SystemEffectVm.instance.isBrightnessDisable ? this.headsUpNoBrightnessBgEffect : { radius: 57 };
      this.weatherButtonBrightness = this.getOption(BrightnessOptionUtils.getInstance().groupRemainderCount);
    } else {
      this.actionBgBrightness = BrightnessOptionUtils.getInstance().customActionViewBgDark;
      this.dividerBrightness = BrightnessOptionUtils.getInstance().foregroundDividerDarkOption;
      this.bgBrightnessOption = BrightnessOptionUtils.getInstance().backgroundFiveOptionDark;
      this.fgBrightness = BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption;
      this.tgBrightness = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossDarkOption;
      this.bannerBgBrightness = BrightnessOptionUtils.getInstance().bannerCardDarkOption;
      this.remainderBrightness = BrightnessOptionUtils.getInstance().customWifiBgDark;
      this.systemButtonBgBrightness = BrightnessOptionUtils.systemLiveButtonBgCardDarkOption;
      this.systemButtonOnBgBrightness = BrightnessOptionUtils.systemLiveButtonOnBgCardDarkOption;
      this.systemButtonOffBgBrightness = BrightnessOptionUtils.systemLiveButtonOffBgCardDarkOption;
      this.screenRecordButtonOnBgBrightness = BrightnessOptionUtils.systemLiveButtonOnBgCardDarkOption;
      this.screenRecordButtonOffBgBrightness = BrightnessOptionUtils.systemLiveButtonOffBgCardDarkOption;
      this.colorFilter = LiveStyle.WHITE_COLOR_FILTER;
      this.mediaCardTitleBrightness = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark;
      this.mediaCardSwitchBgBrightness = BrightnessOptionUtils.getInstance().customWifiBgOnDark;
      this.mediaCardSwitchOnBrightness = BrightnessOptionUtils.getInstance().foregroundPrimaryOnOptionDark;
      this.mediaCardSubTitleBrightness = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossDarkOption;
      this.foregroundPrimaryOption = undefined;
      this.cardLiveBgBrightness = BrightnessOptionUtils.getInstance().backgroundFiveOptionDark;
      this.ntfLiveFontFgBrightness = BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption;
      this.liveListItemBgEffect =
        SystemEffectVm.instance.isBrightnessDisable ? this.liveListItemNoBrightnessBgEffect : undefined;
      this.headsUpBgEffect =
        SystemEffectVm.instance.isBrightnessDisable ? this.headsUpNoBrightnessBgEffect : undefined;
      this.weatherButtonBrightness = this.getOption(BrightnessOptionUtils.getInstance().customWifiBgDark);
    }
    this.actionButtonBgBrightness = this.getOption(this.actionBgBrightness);
    this.dividerFgBrightness = this.getOption(this.dividerBrightness);
    this.cardBgBrightness = this.getOption(this.bgBrightnessOption);
    this.fontFgBrightness = this.getOption(this.fgBrightness);
    this.timeFgBrightness = this.getOption(this.tgBrightness);
    this.bannerCardBgBrightness = this.getOption(this.bannerBgBrightness);
    this.remainderBgBrightness = this.getOption(this.remainderBrightness);
    this.extendFontFgBrightness = this.getOption(BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption);
    this.extendButtonBgBrightness = BrightnessOptionUtils.getInstance().customWifiBgDark;
    this.buttonBgBrightness = this.getOption(BrightnessOptionUtils.getInstance().backgroundNineDarkOption);
    this.headerContentFgBrightness = this.getOption(BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark);
    this.themeTimestampForegroundBrightnessOptions =
      this.getOption(BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption);
    this.extraHeaderButtonBgBrightness = this.getOption(BrightnessOptionUtils.getInstance().backgroundSevenDarkOption);
    this.circleButtonBgBrightnessOptions = this.isSolidEnable() ? undefined : BrightnessOptionUtils.getInstance()
      .customWifiBg;
    if (this.isNtfBrightnessDisable) {
      this.updateDisableBrightnessOptions();
      this.updateDisableBrightnessOptionColor();
      this.bannerBgEffect =
        this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ? this.headsUpNoBrightnessBgEffect :
        this.headsUpDefaultBgEffect;
    }
    if (!ScreenLockAdapter.getLock()) {
      this.updateNCColor();
    }
  }

  private isNtfBrightnessEqual(index: number): boolean {
    if (this.isNtfBrightnessDisable && ResUtils.getColor(this.brightnessEffectResources[index]) ===
    ResUtils.getColor(this.ntfBrightnessResourceOverlayDefault[index])) {
      return false;
    }
    return true;
  }

  /**
   * 主题变换
   */
  protected checkThemeColor(): void {
    for (let index = 0; index < this.brightnessEffectResources.length; index++) {
      log.showInfo(`updateNtfBrightnessUseEffect, ${ResUtils.getColor(this.brightnessEffectResources[index]) ??
        0}, ${ResUtils.getColor(this.brightnessResourceDefault[index])}, ${ResUtils.getColor(this.brightnessResourceDark[index])}`);
      if ((ResUtils.getColor(this.brightnessEffectResources[index]) !==
      ResUtils.getColor(this.brightnessResourceDefault[index]) &&
        ResUtils.getColor(this.brightnessEffectResources[index]) !==
        ResUtils.getColor(this.brightnessResourceDark[index]) && this.isNtfBrightnessEqual(index))) {
        log.showInfo(`Theme color not support brightness.`);
        this.isThemeActive = true;
        this.isBrightnessEffect = false;
        return;
      }
    }
    log.showInfo(`Theme color support brightness, brightnessDisable = ${this.isNtfBrightnessDisable}.`);
    this.isThemeActive = false;
    this.isBrightnessEffect = !this.isNtfBrightnessDisable;
  }

  protected getOption(brightnessEffectOpt: BrightnessOptions): BrightnessOptions | undefined {
    return this.isBrightnessEffect ? brightnessEffectOpt : undefined;
  }

  protected getColor(conflictColor: ResourceColor): ResourceColor {
    return this.isBrightnessEffect ? this.defaultColor : conflictColor;
  }

  protected getThemeColor(type: ThemeColorType): Resource {
    return this.brightnessConflictColors.get(type)!;
  }

  private updateDisableBrightnessOptions(): void {
    this.buttonBgBrightness = undefined;

    this.bannerLiveCardBgBrightness = undefined;
    this.foregroundPrimaryOption = undefined;
    this.cardLiveBgBrightness = undefined;
  }

  private updateDisableBrightnessOptionColor(): void {
    this.bannerLiveCardBgColor = $r('app.color.live_heads_up_disable_brightness_bg_color');
    this.ntfLiveCardBgColor = $r('app.color.live_ntf_disable_brightness_bg_color');
  }

  public updateScreenLockColor(color?: effectKit.Color): void {
    if (!this.isSolidEnable()) {
      return;
    }
    if (!color) {
      log.showWarn(`Color for ScreenLock Background is undefined`);
      return;
    }
    this.ncPickColor = color;
    if (this.isThemeActive) {
      this.ntfLiveCardBgColor = this.calcPrimarySolidColor(this.ntfLiveCardBgColor, this.bgBrightnessOption, color);
      this.liveBgPickColor = this.convertResourceColorToEffectColor(this.ntfLiveCardBgColor);

      this.menuButtonBgColor =
        this.calcPrimarySolidColor(this.menuButtonBgColor, BrightnessOptionUtils.getInstance().backgroundNineDarkOption, color);
      this.groupMenuButtonBgColor =
        this.calcSecondarySolidColor(this.menuButtonBgColor, BrightnessOptionUtils.getInstance().backgroundNineDarkOption,
          this.liveBgPickColor);
      this.actionButtonBgColor = $r('app.color.theme_ntf_phone_action_bg_color');
      this.remainderCountColor = $r('app.color.theme_ntf_phone_remaind_bg_color');
      this.actionButtonDividerColor = $r('app.color.theme_ntf_phone_action_divider_color');
      this.groupDividerColor = $r('app.color.theme_ntf_phone_group_divider_color');
      this.ntfRemainderCountTextColor = $r('app.color.theme_ntf_color_text_secondary');
      return;
    }
    this.ntfCardBgColor = this.calcPrimarySolidColor(this.ntfCardBgColor, this.bgBrightnessOption, color);
    const ntfCardBgKitColor = this.convertResourceColorToEffectColor(this.ntfCardBgColor);

    this.fontColor = this.calcSecondarySolidColor(this.fontColor, this.fgBrightness, ntfCardBgKitColor);
    this.timeFontColor = this.calcSecondarySolidColor(this.timeFontColor, this.tgBrightness, ntfCardBgKitColor);
    this.pinTopTextColor = this.calcSecondarySolidColor(this.pinTopTextColor, this.tgBrightness, ntfCardBgKitColor);

    this.ntfLiveCardBgColor = this.calcPrimarySolidColor(this.ntfLiveCardBgColor, this.bgBrightnessOption, color);
    this.liveBgPickColor = this.convertResourceColorToEffectColor(this.ntfLiveCardBgColor);

    this.menuButtonBgColor =
      this.calcPrimarySolidColor(this.menuButtonBgColor, BrightnessOptionUtils.getInstance().backgroundNineDarkOption, color);
    this.groupMenuButtonBgColor =
      this.calcSecondarySolidColor(this.menuButtonBgColor, BrightnessOptionUtils.getInstance().backgroundNineDarkOption,
        ntfCardBgKitColor);

    this.actionButtonBgColor =
      this.calcSecondarySolidColor(this.actionButtonBgColor, this.actionBgBrightness, ntfCardBgKitColor);
    const buttonBgKitColor: effectKit.Color = this.convertResourceColorToEffectColor(this.actionButtonBgColor);
    this.actionButtonDividerColor = this.calcSecondarySolidColor(
      this.actionButtonDividerColor, this.dividerBrightness, buttonBgKitColor);

    this.groupDividerColor =
      this.calcSecondarySolidColor(this.groupDividerColor, this.dividerBrightness, ntfCardBgKitColor);

    this.remainderCountColor = this.calcSecondarySolidColor(
      this.remainderCountColor, this.remainderBrightness, ntfCardBgKitColor);
    const remainderBgKitColor = this.convertResourceColorToEffectColor(this.remainderCountColor);
    this.ntfRemainderCountTextColor = this.calcSecondarySolidColor(
      this.ntfRemainderCountTextColor, this.fgBrightness, remainderBgKitColor);
  }

  private updateNCColor(): void {
    if (!this.isSolidEnable()) {
      return;
    }
    if (this.isThemeActive) {
      this.ntfLiveCardBgColor =
        this.calcPrimarySolidColor(this.ntfLiveCardBgColor, this.bgBrightnessOption,
          this.ncPickColor);

      this.liveBgPickColor = this.convertResourceColorToEffectColor(this.ntfLiveCardBgColor);

      this.menuButtonBgColor =
        this.calcPrimarySolidColor(this.menuButtonBgColor, BrightnessOptionUtils.getInstance().backgroundNineDarkOption,
          this.ncPickColor);
      this.groupMenuButtonBgColor =
        this.calcSecondarySolidColor(this.menuButtonBgColor,
          BrightnessOptionUtils.getInstance().backgroundNineDarkOption, this.liveBgPickColor);
      this.actionButtonBgColor = $r('app.color.theme_ntf_phone_action_bg_color');
      this.extraButtonBgColor = $r('app.color.ntf_extra_button_color');
      this.allClearButtonBgColor = $r('app.color.ntf_phone_all_clear_bg_color');
      this.remainderCountColor = $r('app.color.theme_ntf_phone_remaind_bg_color');
      this.actionButtonDividerColor = $r('app.color.theme_ntf_phone_action_divider_color');
      this.groupDividerColor = $r('app.color.theme_ntf_phone_group_divider_color');
      this.ntfRemainderCountTextColor = $r('app.color.theme_ntf_color_text_secondary');
      return;
    }
    this.ntfCardBgColor = this.calcPrimarySolidColor(this.ntfCardBgColor, this.bgBrightnessOption, this.ncPickColor);
    log.showInfo(`Update NC's Color in Solid Color Mode with Calculated Card Background Color ${this.ntfCardBgColor}`)
    const ntfCardBgKitColor = this.convertResourceColorToEffectColor(this.ntfCardBgColor);

    this.fontColor = this.calcSecondarySolidColor(this.fontColor, this.fgBrightness, ntfCardBgKitColor);
    this.timeFontColor = this.calcSecondarySolidColor(this.timeFontColor, this.tgBrightness, ntfCardBgKitColor);
    this.pinTopTextColor = this.calcSecondarySolidColor(this.pinTopTextColor, this.tgBrightness, ntfCardBgKitColor);

    this.menuButtonBgColor =
      this.calcPrimarySolidColor(this.menuButtonBgColor, BrightnessOptionUtils.getInstance().backgroundNineDarkOption,
        this.ncPickColor);
    this.groupMenuButtonBgColor =
      this.calcSecondarySolidColor(this.menuButtonBgColor, BrightnessOptionUtils.getInstance().backgroundNineDarkOption,
        ntfCardBgKitColor);

    const allClearButtonBgBrightnessOption = this.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK ?
    BrightnessOptionUtils.getInstance().backgroundTenDarkOption :
    BrightnessOptionUtils.getInstance().backgroundNineDarkOption
    this.allClearButtonBgColor = this.calcSecondarySolidColor(
      this.allClearButtonBgColor, allClearButtonBgBrightnessOption, ntfCardBgKitColor);

    this.extraButtonBgColor = this.calcPrimarySolidColor(
      this.extraButtonBgColor, BrightnessOptionUtils.getInstance().backgroundSevenDarkOption, this.ncPickColor);

    this.remainderCountColor = this.calcSecondarySolidColor(
      this.remainderCountColor, this.remainderBrightness, ntfCardBgKitColor);
    const remainderBgKitColor = this.convertResourceColorToEffectColor(this.remainderCountColor);
    this.ntfRemainderCountTextColor = this.calcSecondarySolidColor(
      this.fontColor, this.fgBrightness, remainderBgKitColor);

    this.groupDividerColor =
      this.calcSecondarySolidColor(this.groupDividerColor, this.dividerBrightness, ntfCardBgKitColor);

    this.actionButtonBgColor = this.calcSecondarySolidColor(
      this.actionButtonBgColor, this.actionBgBrightness, ntfCardBgKitColor);
    const buttonBgKitColor: effectKit.Color =
      this.convertResourceColorToEffectColor(this.actionButtonBgColor);
    this.actionButtonDividerColor = this.calcSecondarySolidColor(
      this.actionButtonDividerColor, this.dividerBrightness, buttonBgKitColor);

    this.ntfLiveCardBgColor =
      this.calcPrimarySolidColor(this.ntfLiveCardBgColor, this.bgBrightnessOption,
        this.ncPickColor);

    this.liveBgPickColor = this.convertResourceColorToEffectColor(this.ntfLiveCardBgColor);
  }

  private updateNtfBannerColor(): void {
    if (!this.isSolidEnable()) {
      return;
    }
    if (this.isThemeActive) {
      this.actionButtonBgColor = $r('app.color.theme_ntf_phone_action_bg_color');
      this.actionButtonDividerColor = $r('app.color.theme_ntf_phone_action_divider_color');

      const bannerCardBgColor =
        this.calcPrimarySolidColor(this.bannerCardBgColor, this.bannerBgBrightness, this.ntfBannerPickColor);
      const ntfCardBgKitColor = this.convertResourceColorToEffectColor(bannerCardBgColor);

      this.immersiveBannerExpandIconColor = this.calcSecondarySolidColor(
        this.immersiveBannerExpandIconColor, BrightnessOptionUtils.getInstance().customWifiBg, ntfCardBgKitColor);
      return;
    }
    this.bannerCardBgColor =
      this.calcPrimarySolidColor(this.bannerCardBgColor, this.bannerBgBrightness, this.ntfBannerPickColor);
    const ntfCardBgKitColor = this.convertResourceColorToEffectColor(this.bannerCardBgColor);
    this.ntfCardBgColor = this.bannerCardBgColor;

    this.fontColor = this.calcSecondarySolidColor(this.fontColor, this.fgBrightness, ntfCardBgKitColor);
    this.timeFontColor = this.calcSecondarySolidColor(this.timeFontColor, this.tgBrightness, ntfCardBgKitColor);
    this.pinTopTextColor = this.calcSecondarySolidColor(this.pinTopTextColor, this.tgBrightness, ntfCardBgKitColor);

    this.actionButtonBgColor = this.calcSecondarySolidColor(
      this.actionButtonBgColor, this.actionBgBrightness, ntfCardBgKitColor);
    const buttonBgKitColor: effectKit.Color =
      this.convertResourceColorToEffectColor(this.actionButtonBgColor);
    this.actionButtonDividerColor = this.calcSecondarySolidColor(
      this.actionButtonDividerColor, this.dividerBrightness, buttonBgKitColor);

    this.immersiveBannerExpandIconColor = this.calcSecondarySolidColor(
      this.immersiveBannerExpandIconColor, BrightnessOptionUtils.getInstance().customWifiBg, ntfCardBgKitColor);
  }

  private updateLiveBannerColor(): void {
    if (!this.isSolidEnable()) {
      return;
    }
    this.liveListCardBgColor =
      this.calcPrimarySolidColor(this.liveListCardBgColor, this.liveCardBgBrightness, this.livePickColor);
    this.liveBgPickColor = this.convertResourceColorToEffectColor(this.liveListCardBgColor);
  }

  private updateLiveListColor(): void {
    if (!this.isSolidEnable()) {
      return;
    }
    this.liveListCardBgColor =
      this.calcPrimarySolidColor(this.liveListCardBgColor, this.liveCardBgBrightness, this.livePickColor);
    this.liveBgPickColor = this.convertResourceColorToEffectColor(this.liveListCardBgColor);

    this.buttonNoBrightBgColor =
      this.calcPrimarySolidColor(this.buttonNoBrightBgColor,
        BrightnessOptionUtils.getInstance().backgroundNineDarkOption, this.livePickColor);
  }

  /**
   * 计算主纯色颜色，通知中心下拉和点击实况胶囊时计算卡片背景颜色场景
   *
   * @param color 不使用纯色模式时的原始颜色
   * @param option 不使用纯色模式时的原始提亮
   * @param baseColor 基色（计算颜色的基准值，如全屏截图的颜色平均值）
   * @returns 若纯色模式不使能是或提亮参数为空，返回原来的颜色，使能时计算目标颜色
   */
  public calcPrimarySolidColor(color: ResourceColor, option: BrightnessOptions | undefined,
    baseColor: effectKit.Color): ResourceColor {
    // 提亮压暗效果开启或纯色模式不使能或提亮压暗参数无效时，返回原颜色
    if (!this.isSolidEnable() || option === undefined) {
      return color;
    }

    const curMode = GlobalContext.getContext()?.config?.colorMode as number;
    const adjustRGB = SolidColorAlgorithmUtils.adjustRGB(baseColor, curMode);

    const editedColor: effectKit.Color = {
      red: adjustRGB[0],
      green: adjustRGB[1],
      blue: adjustRGB[2],
      alpha: baseColor.alpha
    };

    const solidColor = SolidColorAlgorithmUtils.calSolidColor(option, editedColor);
    if (solidColor) {
      const red = solidColor?.red.toString(16).padStart(2, '0');
      const green = solidColor?.green.toString(16).padStart(2, '0');
      const blue = solidColor?.blue.toString(16).padStart(2, '0');
      return `#FF${red}${green}${blue}`;
    }

    return color;
  }

  /**
   * 计算副纯色颜色，文字、按钮、分界线等场景（除通知中心下拉和点击实况胶囊时计算卡片背景颜色场景外场景）
   * @param color
   * @param option
   * @param baseColor
   * @returns
   */
  public calcSecondarySolidColor(color: ResourceColor, option: BrightnessOptions | undefined,
    baseColor: effectKit.Color): ResourceColor {
    // 提亮压暗效果开启或纯色模式不使能或提亮压暗参数无效时，返回原颜色
    if (!this.isSolidEnable() || option === undefined) {
      return color;
    }

    const solidColor = SolidColorAlgorithmUtils.calSolidColor(option, baseColor);
    if (solidColor) {
      const red = solidColor?.red.toString(16).padStart(2, '0');
      const green = solidColor?.green.toString(16).padStart(2, '0');
      const blue = solidColor?.blue.toString(16).padStart(2, '0');
      return `#FF${red}${green}${blue}`;
    }

    return color;
  }

  /**
   * 当产品化定制视效使能纯色模式且系统不使用默认颜色时，启用纯色效果
   *
   * @returns boolean
   */
  public isSolidEnable(): boolean {
    return this.isSolidColorEnable && this.isNtfBrightnessDisable;
  }

  /**
   * 产品化定制视效调整接口，配置通知中心、实况、音量条是否使能提亮压暗效果
   *
   * @param option
   * @returns option or undefined
   */
  public getNCBrightnessOption(option: BrightnessOptions | undefined): BrightnessOptions | undefined {
    return this.isNtfBrightnessDisable ? undefined : option;
  }

  /**
   * 将资源颜色转换为effectKit.Color效果颜色。
   * @param ResourceColor 需要转换的颜色，通常为十六进制字符串（'#AARRGGBB'）。
   * @returns {effectKit.Color} - 转换后的颜色对象，包含红、绿、蓝、透明度。
   */
  public convertResourceColorToEffectColor(resourceColor?: ResourceColor): effectKit.Color {
    if (typeof resourceColor === 'string') {
      const hex = resourceColor.replace('#', '');
      log.showInfo(`save color: ${parseInt(hex.slice(2, 4), 16)}${parseInt(hex.slice(4, 6), 16)}${parseInt(hex.slice(6,
        8), 16)}`);
      return {
        red: parseInt(hex.slice(2, 4), 16),
        green: parseInt(hex.slice(4, 6), 16),
        blue: parseInt(hex.slice(6, 8), 16),
        alpha: 255
      }
    } else {
      log.showInfo(`convertResourceColorToEffectColor notstring ${typeof resourceColor}`);
      return {
        red: 255,
        green: 255,
        blue: 255,
        alpha: 255
      };
    }
  }

  public getAverageColor(snapshotType: SnapshotType, inputColor?: effectKit.Color): void {
    if (!this.isSolidEnable()) {
      return;
    }
    const mainSession = SCBScreenSessionManager.getInstance()?.getMainScreenSession()
    if (!mainSession) {
      log.showInfo(`MainScreenSession does not exist`)
      return;
    }
    switch (snapshotType) {
      case SnapshotType.Dropdown:
        if (inputColor && inputColor !== this.ncPickColor) {
          this.ncPickColor = inputColor;
          this.updateNCColor();
        }
        break;
      case SnapshotType.Banner:
        getAvgColor(mainSession?.session?.screenId, 0.2).then((averageColor: effectKit.Color | undefined) => {
          log.info('Get Banner Average Color');
          if (averageColor && averageColor !== this.ntfBannerPickColor) {
            this.ntfBannerPickColor = averageColor;
            this.updateNtfBannerColor();
          }
        }).catch((error: Error) => {
          log.error('Get AvgColor failed:', error.message);
        });
        break;
      case SnapshotType.LiveBanner:
        getAvgColor(mainSession?.session?.screenId, 0.2).then((averageColor: effectKit.Color | undefined) => {
          log.info('Get LiveBanner Average Color');
          if (averageColor && averageColor !== this.livePickColor) {
            this.livePickColor = averageColor;
            this.updateLiveBannerColor();
          }
        }).catch((error: Error) => {
          log.error('Get AvgColor failed:', error.message);
        });
        break;
      case SnapshotType.LiveList:
        getAvgColor(mainSession?.session?.screenId, 1).then((averageColor: effectKit.Color | undefined) => {
          log.info('Get LiveList Average Color');
          if (averageColor && averageColor !== this.livePickColor) {
            this.livePickColor = averageColor;
            this.updateLiveListColor();
          }
        }).catch((error: Error) => {
          log.error('Get AvgColor failed:', error.message);
        });
        break;
    }
  }
}