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
import { ConfigurationConstant } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { ConfigurationEvent, EventManager, EvtBus, GlobalContext, SolidColorEvent } from '@ohos/frameworkwrapper';
import { BrightnessOptionUtils, ColorModeViewModel, ColorModeViewData } from '@ohos/systemuicommon/Index';
import { ResUtils } from '@ohos/windowscene';
import { NotificationConfig } from '../common/NotificationConfig';
import { BrightnessEffectChangeCallback, ntfThemeActiveMgr } from '../common/NotificationThemeActiveManager';
import { effectKit } from '@kit.ArkGraphics2D';
import { ColorModeLiveViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeLiveViewData';
import { ColorModeNCViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeNCViewData';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';

const TAG = 'NtfColorModeVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const CIRCLE_DARK_COLOR: string = '#1affffff';

export interface NtfColorModeConfig {
  bgBrightnessOption?: BrightnessOptions;
  foregroundDividerOption?: BrightnessOptions;
  foregroundPrimary?: BrightnessOptions;
  foregroundPrimaryBackground?: BrightnessOptions;
  themeFontForegroundOptions?: BrightnessOptions;
  themeNtfTextPrimaryColor?: ResourceColor;
  extraNtfContentColor?: ResourceColor;
  centerNtfTitleColor?: ResourceColor;
  buttonImageNtfColor?: ResourceColor;
  themeNtfTextSecondary?: ResourceColor;
  bgPinTextColor?: ResourceColor;
  immersiveArrowDownColor?: ResourceColor;
  immersiveCircleColor?: ResourceColor;
}

@Observed
export class NtfColorModeVM {

  private eventMgr: EventManager = EvtBus.createEventManager();
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private colorModeNCViewData: ColorModeNCViewData = ColorModeViewModel.getInstance().getNCViewData();
  private colorModeLiveViewData: ColorModeLiveViewData = ColorModeViewModel.getInstance().getLiveViewData();
  private lightConfig: NtfColorModeConfig = {
    bgBrightnessOption: BrightnessOptionUtils.getInstance().getBackgroundFiveOption(false),
    foregroundDividerOption: BrightnessOptionUtils.getInstance().foregroundDividerOption,
    foregroundPrimary: undefined,
    foregroundPrimaryBackground: undefined,
    themeFontForegroundOptions: undefined,
    themeNtfTextPrimaryColor: $r('app.color.theme_ntf_color_text_primary'),
    extraNtfContentColor: $r('app.color.ntf_extra_content_color'),
    centerNtfTitleColor: $r('app.color.ntf_center_title_font_color'),
    buttonImageNtfColor: $r('app.color.ntf_extra_content_image_color'),
    themeNtfTextSecondary: $r('app.color.theme_ntf_color_text_secondary'),
    bgPinTextColor: $r('app.color.theme_ntf_phone_pin_text_color'),
    immersiveArrowDownColor: $r('app.color.live_card_divider_bg_color'),
    immersiveCircleColor: $r('app.color.icon_off_bg'),
  };

  private darkConfig: NtfColorModeConfig = {
    bgBrightnessOption: BrightnessOptionUtils.getInstance().getBackgroundFiveOption(true),
    foregroundDividerOption: BrightnessOptionUtils.getInstance().foregroundDividerDarkOption,
    foregroundPrimary: undefined,
    foregroundPrimaryBackground: undefined,
    themeFontForegroundOptions: undefined,
    themeNtfTextPrimaryColor: $r('app.color.theme_ntf_color_text_primary'),
    extraNtfContentColor :  $r('app.color.ntf_extra_content_color'),
    centerNtfTitleColor: $r('app.color.ntf_center_title_font_color'),
    buttonImageNtfColor: $r('app.color.ntf_extra_content_image_color'),
    themeNtfTextSecondary: $r('app.color.theme_ntf_color_text_secondary'),
    bgPinTextColor: $r('app.color.theme_ntf_phone_pin_text_color'),
    immersiveArrowDownColor: $r('app.color.live_card_divider_bg_color'),
    immersiveCircleColor:  $r('app.color.icon_off_bg'),
  };

  public isBrightnessEffect: boolean = true;

  private brightnessCallback: BrightnessEffectChangeCallback = {
    updateOnBrightnessEffectChange: (isEffect) => {
      log.showInfo(`updateOnBrightnessEffectChange, ${isEffect}`);
      this.isBrightnessEffect = isEffect && !this.isNtfBrightnessDisable;
      this.onThemeChange?.();
    }
  };

  private themeBrightnessConflictColors: Map<ThemeColorType, Resource> = new Map([
    [ThemeColorType.NTF_TEXT_PRIMARY_COLOR, $r('app.color.theme_ntf_color_text_primary')],
    [ThemeColorType.NTF_TEXT_SECONDARY_COLOR, $r('app.color.theme_ntf_color_text_secondary')],
    [ThemeColorType.NTF_TEXT_TERTIARY_COLOR, $r('app.color.theme_ntf_color_text_tertiary')],
    [ThemeColorType.NTF_BG_COLOR, $r('app.color.ntf_blur_style_bg')]
  ]);

  private onThemeChange: (() => void) | undefined = undefined;

  public bgBrightnessOption: BrightnessOptions | undefined = undefined;

  public foregroundDividerOption: BrightnessOptions | undefined = undefined;

  public foregroundDividerForGroupOption: BrightnessOptions | undefined = undefined;

  public bgColor: Resource = $r('app.color.ntf_brightness_bg_color');

  /* 横幅通知提亮参数 */
  public themeBannerBgOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.bannerCardOption;
  public liveBannerBgOptions: BrightnessOptions | undefined = BrightnessOptionUtils.bannerCardOption;

  /* 通知header时间提亮参数 */
  public themeHeaderContentButtonBgOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark;

  /* 通知一键删除提亮参数 */
  public themeAllClearButtonBgOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().backgroundNineDarkOption;

  /* 通知菜单按钮提亮参数 */
  public themeMenuButtonBgOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().backgroundNineDarkOption;

  public menuButtonBgOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().backgroundNineDarkOption;

  /* 组通知中单通知卡片和通知多个按钮中按钮之间分割线提亮参数 */
  public themeForegroundDividerOption: BrightnessOptions | undefined = undefined;

  /* 更多通知折叠展开按钮提亮参数 */
  public themeExtraHeaderButtonBgOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().backgroundSevenDarkOption;

  /* 剩余通知折叠按钮提亮参数 */
  public themeGroupRemainderCountOptions: BrightnessOptions | undefined = undefined;

  /* 通知卡片主题文字提亮参数 */
  public themeFontForegroundBrightnessOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().foregroundSecondaryOption;

  /* 通知卡片主题时间戳提亮参数 */
  public themeTimestampForegroundBrightnessOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption;

  /* 主题资源背景亮度参数 */
  public themeBgBrightnessOption: BrightnessOptions | undefined = undefined;
  public liveBgBrightnessOption: BrightnessOptions | undefined = undefined;

  /* 通知卡片主题文字提亮参数 */
  public themeFontForegroundColor: ResourceColor = this.bgColor;

  /* 通知卡片主题时间戳提亮参数 */
  public themeTimestampForegroundColor: ResourceColor = this.bgColor;

  /* 主题资源背景亮度参数 */
  public themeBgColor: ResourceColor = this.bgColor;
  public themeBannerBgColor: ResourceColor = this.themeBgColor;
  public themeClearButtonBgColor: ResourceColor = $r('app.color.ntf_phone_clear_button_bg_color');
  public themeClearButtonBgCardColor: ResourceColor = this.themeClearButtonBgColor
  public themeButtonBgColor: ResourceColor = $r('app.color.theme_ntf_phone_action_bg_color');
  public themeActionDividerColor: ResourceColor = $r('app.color.theme_ntf_phone_action_divider_color');
  public themeGroupDividerColor: ResourceColor = $r('app.color.theme_ntf_phone_group_divider_color');
  public themeRemainderCountColor: ResourceColor = $r('app.color.theme_ntf_phone_remaind_bg_color');
  public ntfRemainderCountTextColor: ResourceColor = $r('app.color.theme_ntf_color_text_secondary');
  public themeAllClearButtonBgColor: ResourceColor = $r('app.color.ntf_phone_all_clear_bg_color');
  public themeExtraHeaderButtonBgColor: ResourceColor = $r('app.color.ntf_extra_button_color');

  public headerContentBgOptions: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark;

  public allClearButtonBgOptions: BrightnessOptions = BrightnessOptionUtils.getInstance().backgroundNineDarkOption;

  public extraHeaderButtonBgOptions: BrightnessOptions = BrightnessOptionUtils.getInstance().backgroundSevenDarkOption;

  /* 通知卡片文字提亮参数 */
  public fontForegroundBrightnessOptions: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundSecondaryOption;

  /* 通知卡片时间戳提亮参数 */
  public timestampForegroundBrightnessOptions: BrightnessOptions = BrightnessOptionUtils.getInstance()
    .foregroundTertiaryGlossOption;

  /* 横幅通知卡片背景提亮参数 */
  public bannerCardOption: BrightnessOptions | undefined = BrightnessOptionUtils.bannerCardOption;

  /* 通知按钮背景提亮参数 */
  public themeButtonBgBrightnessOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().customActionViewBg;
  public buttonBgBrightnessOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().customActionViewBg;

  /* 沉浸态下拉按钮背景提亮参数 */
  public circleButtonBgBrightnessOptions: BrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBg;

  /* 组通知数字角标提亮参数 */
  public groupRemainderCountBgBrightnessOptions: BrightnessOptions =
    BrightnessOptionUtils.getInstance().groupRemainderCount;

  /* AOD模式文字提亮 */
  public aodTimeLightOptionForFillColor: BrightnessOptions = BrightnessOptionUtils.aodTimeLightOptionForFillColor;

  /* AOD模式按钮背板提亮 */
  public aodTimeLightOptionForButtonBgColor: BrightnessOptions =
    BrightnessOptionUtils.getInstance().aodTimeLightOptionForButtonBgColor;

  /*PC二级面板文字图片提亮压暗*/
  public foregroundPrimaryOptionOnBackground: BrightnessOptions | undefined = undefined;

  /*文字图片提亮压暗*/
  public foregroundPrimaryOption: BrightnessOptions | undefined = undefined;

  /* 通知中心摘要提亮参数 */
  public themeFontForegroundOptions: BrightnessOptions | undefined = undefined;

  /* 组通知通知计数提亮参数 */
  public groupRemainderCountOptions: BrightnessOptions | undefined = undefined;


  /*通知中心主题*/
  public ntfThemeTextPrimaryColor: ResourceColor | undefined = ''

  /*通知中心摘要*/
  public ntfThemeTextSecondaryColor: ResourceColor | undefined = ''

  /*折叠*/
  public ntfExtraContentColor: ResourceColor | undefined = ''

  /*通知标题和摘要*/
  public ntfCenterTitleColor: ResourceColor | undefined = ''

  /*通知中心折叠三角图片*/
  public ntfButtonImageColor: ResourceColor | undefined = ''

  /*通知应用分身图标颜色*/
  public bgPinTextColor: ResourceColor | undefined = '';

  /* 实况通知背景颜色 */
  public liveNtfItemBgColor: ResourceColor = this.bgColor;

  /* 实况通知横幅背景颜色 */
  public liveHeadsUpBgColor: ResourceColor = this.bgColor;

  /* 通知提亮禁用 */
  public isNtfBrightnessDisable = false;

  /* 纯色模式启用 */
  public isSolidColorEnable = false;

  public headsUpDefaultBgEffect: BackgroundEffectOptions = { radius: NotificationConfig.HEADS_UP_BACKGROUND_RADIUS };

  public headsUpBgEffect: BackgroundEffectOptions = this.headsUpDefaultBgEffect;

  /* 沉浸式横幅通知收起箭头颜色 */
  public immersiveArrowDownColor: ResourceColor | undefined = ''

  /* 沉浸式横幅通知Circle背景颜色 */
  public immersiveCircleColor: ResourceColor | undefined = ''

  private headsUpNoBrightnessBgEffect: BackgroundEffectOptions = {
    radius: NotificationConfig.HEADS_UP_BACKGROUND_RADIUS,
    blurOptions: {
      grayscale: [NotificationConfig.HEADS_UP_BLUR_OPTIONS_GRAYSCALE,
        NotificationConfig.HEADS_UP_BLUR_OPTIONS_GRAYSCALE]
    }
  };

  /*深色模式*/
  private isDarkMode: boolean = false;

  // 在纯色模式下，AOD场景，锁屏通知列表背板需要显示成黑色
  public isNeedShowBackColorForAod: boolean = false;

  private onModeChange(curMode: ConfigurationConstant.ColorMode) {
    log.showInfo(`current color mode is ${curMode}`);
    if (curMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.isDarkMode = false;
      this.bgBrightnessOption = this.lightConfig?.bgBrightnessOption;
      this.foregroundDividerOption = this.lightConfig?.foregroundDividerOption;
      this.fontForegroundBrightnessOptions = BrightnessOptionUtils.getInstance().foregroundSecondaryOption;
      this.timestampForegroundBrightnessOptions = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption
      this.bannerCardOption = BrightnessOptionUtils.bannerCardOption;
      this.buttonBgBrightnessOptions = BrightnessOptionUtils.getInstance().customActionViewBg;
      this.circleButtonBgBrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBg;
      this.foregroundDividerForGroupOption = BrightnessOptionUtils.foregroundDividerForGroupOption;
      this.groupRemainderCountOptions = BrightnessOptionUtils.getInstance().groupRemainderCount;
      this.updateBrightnessOptionLightColor();
    } else {
      this.isDarkMode = true;
      this.bgBrightnessOption = this.darkConfig?.bgBrightnessOption;
      this.foregroundDividerOption = this.darkConfig?.foregroundDividerOption;
      this.fontForegroundBrightnessOptions = BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption;
      this.timestampForegroundBrightnessOptions = BrightnessOptionUtils.getInstance().foregroundTertiaryGlossDarkOption;
      this.bannerCardOption = BrightnessOptionUtils.bannerCardDarkOption;
      this.buttonBgBrightnessOptions = BrightnessOptionUtils.getInstance().customActionViewBgDark;
      this.circleButtonBgBrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBgDark;
      this.foregroundDividerForGroupOption = BrightnessOptionUtils.foregroundDividerForGroupDarkOption;
      this.groupRemainderCountOptions = BrightnessOptionUtils.getInstance().customWifiBgDark;
      this.updateBrightnessOptionDarkColor();
    }
    this.updateThemeColor();
  }

  private getThemeColor(type: ThemeColorType): Resource {
    return this.themeBrightnessConflictColors.get(type)!;
  }

  public init(light?: NtfColorModeConfig, dark?: NtfColorModeConfig, onThemeChange?: () => void) {
    if (light !== undefined) {
      if (!light.extraNtfContentColor) {
        this.addDefaultConfig(light);
      }
      this.lightConfig = light;
    }

    if (dark !== undefined) {
      if (!dark.extraNtfContentColor) {
        this.addDefaultConfig(dark);
      }
      this.darkConfig = dark;
    }
    this.isSolidColorEnable =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.CC_SOLID_COLOR_ENABLE) === 'true';
    this.isNtfBrightnessDisable =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.NTF_BRIGHTENS_DISABLE) === 'true';
    if (this.isNtfBrightnessDisable) {
      this.isBrightnessEffect = false;
    }
    let curMode = GlobalContext.getContext().config.colorMode as number;
    this.onModeChange(curMode);

    this.eventMgr.on(ConfigurationEvent, (event: ConfigurationEvent) => {
      log.showInfo(`ConfigurationEvent： ${event.config?.colorMode}`);
      if (event.config?.colorMode !== undefined) {
        this.onModeChange(event.config.colorMode);
      }
    }).on(SolidColorEvent, (event: SolidColorEvent) => {
      if (event.scene === SolidColorEvent.FULL) {
        this.updateColor();
      } else if (event.scene === SolidColorEvent.TOP20) {
        this.updateBannerColor();
      } else {
        log.showError('OnSolidColorEvent invalid scene %{public}s', event.scene);
      }
    });
    if (onThemeChange) {
      log.showInfo(`onThemeChange is not undefined`);
      this.onThemeChange = onThemeChange;
    }
    // 监听提亮功能是否生效
    this.registerBrightnessEffect();
  }

  public deinit() {
    this.onThemeChange = undefined;
    this.eventMgr.offAll();
    ntfThemeActiveMgr.unregisterBrightnessEffectChange(this.brightnessCallback);
  }

  private isSolidEnable() {
    return this.isSolidColorEnable && this.isNtfBrightnessDisable;
  }

  public updateScreenLockColor(color?: effectKit.Color): void {
    if (!this.isSolidEnable()) {
      return;
    }
    if (!color) {
      log.showWarn(`Color for ScreenLock Background is undefined`);
      return;
    }
    this.colorModeNCViewData.pickColor = color;
    if (!ntfThemeActiveMgr.isNtfBrightnessEffectUse()) {
      this.liveNtfItemBgColor =
        this.colorModeViewData?.calcPrimarySolidColor(this.bgColor, this.bgBrightnessOption,
          color);
      this.colorModeLiveViewData.liveBgPickColor =
        this.colorModeViewData.convertResourceColorToEffectColor(this.liveNtfItemBgColor);

      this.themeClearButtonBgColor = this.colorModeViewData?.calcPrimarySolidColor(
        $r('app.color.ntf_phone_clear_button_bg_color'), this.menuButtonBgOptions, color);
      this.themeClearButtonBgCardColor = this.colorModeViewData?.calcSecondarySolidColor(
        this.themeClearButtonBgColor, this.menuButtonBgOptions, this.colorModeLiveViewData.liveBgPickColor);
      this.themeButtonBgColor = $r('app.color.theme_ntf_phone_action_bg_color');
      this.themeRemainderCountColor = $r('app.color.theme_ntf_phone_remaind_bg_color');
      this.themeActionDividerColor = $r('app.color.theme_ntf_phone_action_divider_color');
      this.themeGroupDividerColor = $r('app.color.theme_ntf_phone_group_divider_color');
      this.ntfRemainderCountTextColor = $r('app.color.theme_ntf_color_text_secondary');
      return;
    }
    this.themeBgColor = this.colorModeViewData?.calcPrimarySolidColor(this.bgColor, this.bgBrightnessOption,
      color);
    const themeBgKitColor = this.colorModeViewData.convertResourceColorToEffectColor(this.themeBgColor);

    this.themeFontForegroundColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.fontForegroundBrightnessOptions, themeBgKitColor);

    this.themeTimestampForegroundColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.timestampForegroundBrightnessOptions, themeBgKitColor);

    this.bgPinTextColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.timestampForegroundBrightnessOptions, themeBgKitColor);

    this.liveNtfItemBgColor =
      this.colorModeViewData?.calcPrimarySolidColor(this.liveNtfItemBgColor, this.bgBrightnessOption,
        color);

    this.colorModeLiveViewData.liveBgPickColor =
      this.colorModeViewData.convertResourceColorToEffectColor(this.liveNtfItemBgColor);

    this.themeClearButtonBgColor = this.colorModeViewData?.calcPrimarySolidColor(
      $r('app.color.ntf_phone_clear_button_bg_color'), this.menuButtonBgOptions, color);
    this.themeClearButtonBgCardColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.themeClearButtonBgColor, this.menuButtonBgOptions, themeBgKitColor);

    this.themeButtonBgColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_action_bg_color'), this.buttonBgBrightnessOptions, themeBgKitColor);

    const themeButtonBgKitColor: effectKit.Color =
      this.colorModeViewData.convertResourceColorToEffectColor(this.themeButtonBgColor);

    this.themeActionDividerColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_action_divider_color'), this.foregroundDividerOption, themeButtonBgKitColor);

    this.themeGroupDividerColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_group_divider_color'), this.foregroundDividerOption, themeBgKitColor);

    this.themeRemainderCountColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_remaind_bg_color'), this.groupRemainderCountOptions, themeBgKitColor);
    const remainderBgKitColor = this.colorModeViewData.convertResourceColorToEffectColor(this.themeRemainderCountColor);

    this.ntfRemainderCountTextColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_color_text_secondary'), this.fontForegroundBrightnessOptions, remainderBgKitColor);

  }

  private updateBannerColor(): void {
    if (!this.isSolidEnable()) {
      return;
    }
    if (!ntfThemeActiveMgr.isNtfBrightnessEffectUse()) {
      this.liveHeadsUpBgColor =
        this.colorModeViewData.calcSecondarySolidColor(this.liveHeadsUpBgColor,
          this.bannerCardOption, this.colorModeLiveViewData.livePickColor)

      this.colorModeLiveViewData.liveBgPickColor =
        this.colorModeViewData.convertResourceColorToEffectColor(this.liveHeadsUpBgColor);

      const themeBannerBgColor =
        this.colorModeViewData.calcSecondarySolidColor(this.themeBannerBgColor,
          this.bannerCardOption, this.colorModeNCViewData.pickColor)

      this.colorModeNCViewData.bannerBgPickColor =
        this.colorModeViewData.convertResourceColorToEffectColor(themeBannerBgColor);

      this.themeButtonBgColor = $r('app.color.theme_ntf_phone_action_bg_color');
      this.themeActionDividerColor = $r('app.color.theme_ntf_phone_action_divider_color');
      return;
    }

    this.themeBannerBgColor =
      this.colorModeViewData.calcSecondarySolidColor(this.themeBannerBgColor,
        this.bannerCardOption, this.colorModeNCViewData.pickColor)

    this.colorModeNCViewData.bannerBgPickColor =
      this.colorModeViewData.convertResourceColorToEffectColor(this.themeBannerBgColor);

    this.liveHeadsUpBgColor =
      this.colorModeViewData.calcSecondarySolidColor(this.liveHeadsUpBgColor,
        this.bannerCardOption, this.colorModeLiveViewData.livePickColor)

    this.colorModeLiveViewData.liveBgPickColor =
      this.colorModeViewData.convertResourceColorToEffectColor(this.liveHeadsUpBgColor);

    this.themeFontForegroundColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.fontForegroundBrightnessOptions, this.colorModeNCViewData.bannerBgPickColor);

    this.themeTimestampForegroundColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.timestampForegroundBrightnessOptions, this.colorModeNCViewData.bannerBgPickColor);

    this.themeButtonBgColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_action_bg_color'), this.buttonBgBrightnessOptions,
      this.colorModeNCViewData.bannerBgPickColor);

    const themeButtonBgKitColor: effectKit.Color =
      this.colorModeViewData.convertResourceColorToEffectColor(this.themeButtonBgColor);

    this.themeActionDividerColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_action_divider_color'), this.foregroundDividerOption, themeButtonBgKitColor);
  }

  private updateColor(): void {
    if (!this.isSolidEnable()) {
      return;
    }
    if (!ntfThemeActiveMgr.isNtfBrightnessEffectUse()) {
      this.liveNtfItemBgColor =
        this.colorModeViewData?.calcPrimarySolidColor(this.bgColor, this.bgBrightnessOption,
          this.colorModeLiveViewData.livePickColor);
      this.colorModeLiveViewData.liveBgPickColor =
        this.colorModeViewData.convertResourceColorToEffectColor(this.liveNtfItemBgColor);

      this.themeClearButtonBgColor = this.colorModeViewData?.calcPrimarySolidColor(
        $r('app.color.ntf_phone_clear_button_bg_color'), this.menuButtonBgOptions, this.colorModeNCViewData.pickColor);
      this.themeClearButtonBgCardColor = this.colorModeViewData?.calcSecondarySolidColor(
        this.themeClearButtonBgColor, this.menuButtonBgOptions, this.colorModeLiveViewData.liveBgPickColor);
      this.themeButtonBgColor = $r('app.color.theme_ntf_phone_action_bg_color');
      this.themeExtraHeaderButtonBgColor = $r('app.color.ntf_extra_button_color');
      this.themeAllClearButtonBgColor = $r('app.color.ntf_phone_all_clear_bg_color');
      this.themeRemainderCountColor = $r('app.color.theme_ntf_phone_remaind_bg_color');
      this.themeActionDividerColor = $r('app.color.theme_ntf_phone_action_divider_color');
      this.themeGroupDividerColor = $r('app.color.theme_ntf_phone_group_divider_color');
      this.ntfRemainderCountTextColor = $r('app.color.theme_ntf_color_text_secondary');
      return;
    }
    this.themeBgColor = this.colorModeViewData?.calcPrimarySolidColor(this.bgColor, this.bgBrightnessOption,
      this.colorModeNCViewData.pickColor);
    const themeBgKitColor = this.colorModeViewData.convertResourceColorToEffectColor(this.themeBgColor);

    this.themeFontForegroundColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.fontForegroundBrightnessOptions, themeBgKitColor);

    this.themeTimestampForegroundColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.timestampForegroundBrightnessOptions, themeBgKitColor);

    this.bgPinTextColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.bgColor, this.timestampForegroundBrightnessOptions, themeBgKitColor);

    this.liveNtfItemBgColor =
      this.colorModeViewData?.calcPrimarySolidColor(this.liveNtfItemBgColor, this.bgBrightnessOption,
        this.colorModeLiveViewData.livePickColor);

    this.colorModeLiveViewData.liveBgPickColor =
      this.colorModeViewData.convertResourceColorToEffectColor(this.liveNtfItemBgColor);

    this.themeExtraHeaderButtonBgColor = this.colorModeViewData?.calcPrimarySolidColor(
      $r('app.color.ntf_extra_button_color'), this.extraHeaderButtonBgOptions, this.colorModeNCViewData.pickColor);

    this.themeClearButtonBgColor = this.colorModeViewData?.calcPrimarySolidColor(
      $r('app.color.ntf_phone_clear_button_bg_color'), this.menuButtonBgOptions, this.colorModeNCViewData.pickColor);
    this.themeClearButtonBgCardColor = this.colorModeViewData?.calcSecondarySolidColor(
      this.themeClearButtonBgColor, this.menuButtonBgOptions, themeBgKitColor);

    this.themeButtonBgColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_action_bg_color'), this.buttonBgBrightnessOptions, themeBgKitColor);

    const themeButtonBgKitColor: effectKit.Color =
      this.colorModeViewData.convertResourceColorToEffectColor(this.themeButtonBgColor);

    this.themeActionDividerColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_action_divider_color'), this.foregroundDividerOption, themeButtonBgKitColor);

    this.themeGroupDividerColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_group_divider_color'), this.foregroundDividerOption, themeBgKitColor);

    this.themeRemainderCountColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_phone_remaind_bg_color'), this.groupRemainderCountOptions, themeBgKitColor);
    const remainderBgKitColor = this.colorModeViewData.convertResourceColorToEffectColor(this.themeRemainderCountColor);

    this.ntfRemainderCountTextColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.theme_ntf_color_text_secondary'), this.fontForegroundBrightnessOptions, remainderBgKitColor);

    const allClearButtonBgBrightnessOption =
      this.isDarkMode ? BrightnessOptionUtils.getInstance().backgroundTenDarkOption :
      BrightnessOptionUtils.getInstance().backgroundNineDarkOption
    this.themeAllClearButtonBgColor = this.colorModeViewData?.calcSecondarySolidColor(
      $r('app.color.ntf_phone_all_clear_bg_color'), allClearButtonBgBrightnessOption, themeBgKitColor);
  }

  private registerBrightnessEffect(): void {
    ntfThemeActiveMgr.registerBrightnessEffectChange(this.brightnessCallback);
    this.isBrightnessEffect = ntfThemeActiveMgr.isNtfBrightnessEffectUse() && !this.isNtfBrightnessDisable;
    this.onThemeChange?.();
    log.showInfo(`registerBrightnessEffect, init effect : ${this.isBrightnessEffect}`);
  }

  public updateThemeColor(): void {
    if (this.isBrightnessEffect) {
      this.foregroundDividerOption =
        this.isDarkMode ? this.darkConfig?.foregroundDividerOption : this.lightConfig?.foregroundDividerOption;
      this.buttonBgBrightnessOptions =
        this.isDarkMode ? BrightnessOptionUtils.getInstance().customActionViewBgDark :
        BrightnessOptionUtils.getInstance().customActionViewBg;
      this.groupRemainderCountOptions =
        this.isDarkMode ? BrightnessOptionUtils.getInstance().customWifiBgDark :
        BrightnessOptionUtils.getInstance().groupRemainderCount;
    }
    this.themeFontForegroundBrightnessOptions = this.isBrightnessEffect ? this.fontForegroundBrightnessOptions :
      undefined;
    this.themeTimestampForegroundBrightnessOptions = this.isBrightnessEffect ?
    this.timestampForegroundBrightnessOptions : undefined;
    this.themeBgBrightnessOption = this.isBrightnessEffect ? this.bgBrightnessOption : undefined;
    this.themeAllClearButtonBgOptions = this.isBrightnessEffect ? this.allClearButtonBgOptions : undefined;
    this.themeExtraHeaderButtonBgOptions = this.isBrightnessEffect ? this.extraHeaderButtonBgOptions : undefined;
    this.themeHeaderContentButtonBgOptions = this.isBrightnessEffect ? this.headerContentBgOptions : undefined;
    this.themeBannerBgOptions = this.isBrightnessEffect ? this.bannerCardOption : undefined;
    this.themeForegroundDividerOption = this.isBrightnessEffect ? this.foregroundDividerOption : undefined;
    this.themeGroupRemainderCountOptions = this.isBrightnessEffect ? this.groupRemainderCountOptions : undefined;
    this.themeButtonBgBrightnessOptions = this.isBrightnessEffect ? this.buttonBgBrightnessOptions : undefined;
    this.themeFontForegroundColor = this.isBrightnessEffect ? this.bgColor :
    this.getThemeColor(ThemeColorType.NTF_TEXT_SECONDARY_COLOR);
    this.themeTimestampForegroundColor = this.isBrightnessEffect ? this.bgColor :
    this.getThemeColor(ThemeColorType.NTF_TEXT_TERTIARY_COLOR);
    this.themeBgColor = this.isBrightnessEffect ? this.bgColor : this.getThemeColor(ThemeColorType.NTF_BG_COLOR);
    this.themeBannerBgColor = this.themeBgColor;
    this.liveBgBrightnessOption = this.bgBrightnessOption;
    this.liveBannerBgOptions = this.bannerCardOption;
    if (this.isNtfBrightnessDisable) {
      if (!this.isSolidColorEnable) {
        this.bgBrightnessOption = undefined;
      }
      this.updateDisableBrightnessOptions();
      this.updateDisableBrightnessOptionColor();
      this.headsUpBgEffect = this.isDarkMode ? this.headsUpNoBrightnessBgEffect : this.headsUpDefaultBgEffect;
    }
    if (!ScreenLockApi.getLock()) {
      this.updateColor();
    } else {
      this.updateScreenLockColor(this.colorModeNCViewData.pickColor);
    }
  }

  public updateBrightnessOptionLightColor(): void {
    this.foregroundPrimaryOptionOnBackground = this.lightConfig?.foregroundPrimaryBackground;
    this.foregroundPrimaryOption = this.lightConfig?.foregroundPrimary;
    this.themeFontForegroundOptions = this.lightConfig?.themeFontForegroundOptions;
    this.ntfThemeTextPrimaryColor = this.lightConfig?.themeNtfTextPrimaryColor;
    this.ntfExtraContentColor = this.lightConfig?.extraNtfContentColor;
    this.ntfCenterTitleColor = this.lightConfig?.centerNtfTitleColor;
    this.ntfButtonImageColor = this.lightConfig?.buttonImageNtfColor;
    this.ntfThemeTextSecondaryColor = this.lightConfig?.themeNtfTextSecondary;
    this.bgPinTextColor = this.lightConfig?.bgPinTextColor;
    this.immersiveArrowDownColor = this.lightConfig?.immersiveArrowDownColor;
    this.immersiveCircleColor = this.lightConfig?.immersiveCircleColor;
  }

  public updateBrightnessOptionDarkColor(): void {
    this.foregroundPrimaryOptionOnBackground = this.darkConfig?.foregroundPrimaryBackground;
    this.foregroundPrimaryOption = this.darkConfig?.foregroundPrimary;
    this.themeFontForegroundOptions = this.darkConfig?.themeFontForegroundOptions;
    this.ntfThemeTextPrimaryColor = this.darkConfig?.themeNtfTextPrimaryColor;
    this.ntfExtraContentColor = this.darkConfig?.extraNtfContentColor;
    this.ntfCenterTitleColor = this.darkConfig?.centerNtfTitleColor;
    this.ntfButtonImageColor = this.darkConfig?.buttonImageNtfColor;
    this.ntfThemeTextSecondaryColor = this.darkConfig?.themeNtfTextSecondary;
    this.bgPinTextColor = this.darkConfig?.bgPinTextColor;
    this.immersiveArrowDownColor = this.darkConfig?.immersiveArrowDownColor;
    this.immersiveCircleColor = this.darkConfig?.immersiveCircleColor;
  }

  private updateDisableBrightnessOptions(): void {
    this.themeMenuButtonBgOptions = undefined;
    this.liveBannerBgOptions = undefined;
    this.liveBgBrightnessOption = undefined;
    this.foregroundPrimaryOption = undefined;
  }

  private updateDisableBrightnessOptionColor(): void {
    this.liveNtfItemBgColor = $r('app.color.live_ntf_disable_brightness_bg_color');
    this.liveHeadsUpBgColor = $r('app.color.live_heads_up_disable_brightness_bg_color');
  }

  private addDefaultConfig(ntfModeConfig: NtfColorModeConfig): void {
    ntfModeConfig.foregroundPrimary = undefined;
    ntfModeConfig.foregroundPrimaryBackground = undefined;
    ntfModeConfig.themeFontForegroundOptions = undefined;
    ntfModeConfig.themeNtfTextPrimaryColor = $r('app.color.theme_ntf_color_text_primary');
    ntfModeConfig.extraNtfContentColor = $r('app.color.ntf_extra_content_color');
    ntfModeConfig.centerNtfTitleColor = $r('app.color.ntf_center_title_font_color');
    ntfModeConfig.buttonImageNtfColor = $r('app.color.ntf_extra_content_image_color');
    ntfModeConfig.themeNtfTextSecondary = $r('app.color.theme_ntf_color_text_secondary');
    ntfModeConfig.bgPinTextColor = $r('app.color.theme_ntf_phone_pin_text_color');
    ntfModeConfig.immersiveArrowDownColor = $r('app.color.tint_ntf_title_font_color_dark_mode');
    ntfModeConfig.immersiveCircleColor = $r('sys.color.comp_background_tertiary');
  }
}

export enum ThemeColorType {
  NTF_TEXT_PRIMARY_COLOR,
  NTF_TEXT_SECONDARY_COLOR,
  NTF_TEXT_TERTIARY_COLOR,
  NTF_BG_COLOR
}