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
import lazy { SolidColorAlgorithmUtils } from '@ohos/basicutils/src/main/ets/utils/SolidColorAlgorithmUtils';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { EvtBus, GlobalContext } from '@ohos/frameworkwrapper';
import { ControlCenterBackgroundDegreeEvent } from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';
import { SCBVisualEffectManagerAdapter } from '../../adapter/SCBVisualEffectManagerAdapter';
import { ColorInvertTool } from '../../utils/ColorInvertTool';
import { BrightnessOptionUtils } from './BrightnessOptionUtils';
import { DISABLE_BRIGHTNESS, ENABLE_SOLID_COLOR } from '../common/SCBVisualEffectOption';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { effectKit } from '@kit.ArkGraphics2D';

const TAG = 'ColorModeViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const LIVE_NTF_DEFAULT_BLUR_OPTIONS_GRAYSCALE = 38;

@Observed
export class ColorModeViewData {
  public isBrightnessActive: boolean = true;
  // dynamicBrightness param
  public commonDefaultRate: number = 0;
  public commonDefaultDegree: number = 0;

  private wifiDefault: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().customWifiBg : undefined;

  //WIFI 小底板 选中状态
  private wifiOn: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().customWifiBgOn : undefined;

  // add more button text
  public addMoreTextOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().foregroundSecondaryOption : undefined;
  // more settings
  public subpageMoreSettingsOption: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundPrimaryOnOptionDark;
  // 前景哑光1级
  public foregroundPrimaryOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().foregroundPrimaryOptionLight : undefined;
  public foregroundPrimaryOnOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().foregroundPrimaryOnOptionLight : undefined;

  public foregroundVolumePrimaryOnOption: BrightnessOptions | undefined = BrightnessOptionUtils
    .getInstance().foregroundPrimaryOnOptionLight;

  // 前景哑光2级
  public foregroundSecondaryOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().foregroundSecondaryOption : undefined;
  // 前景炫彩3级
  public foregroundTertiaryGlossOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().foregroundTertiaryGlossOption : undefined;
  // 播控二级标题
  public foregroundTertiaryGlossSubOption: BrightnessOptions | undefined = this.isBrightnessActive ?
    BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption : undefined;
  // 播控胶囊一级标题
  public foregroundCapsulePrimaryOption: BrightnessOptions | undefined = this.isBrightnessActive ?
    BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark : undefined;
  // 播控胶囊二级标题
  public foregroundCapsuleGlossSubOption: BrightnessOptions | undefined = this.isBrightnessActive ?
    BrightnessOptionUtils.getInstance().foregroundTertiaryDarkOption : undefined;
  public mediaWifiDefault: BrightnessOptions | undefined = this.isBrightnessActive ?
    BrightnessOptionUtils.getInstance().customWifiBgDark : undefined;
  //WIFI 小底板 选中状态
  public mediaWifiOn: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
    .customWifiBgOnDark : undefined;
  public mediaWifiIconDefault: BrightnessOptions | undefined = this.isBrightnessActive ?
    BrightnessOptionUtils.getInstance().foregroundPrimaryOptionOnBackgroundDark : undefined;
  public mediaWifiIconOn = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().foregroundPrimaryOnOptionDark
    : undefined;
  // 分割线
  public foregroundDividerOption: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundDividerOption;


  // add more button background
  public addMoreBgOption:BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().backgroundEightOption : undefined;

  // 纯色模式取色
  public pickColor: effectKit.Color = {red: 255, green: 255, blue: 255, alpha: 255};

  // color param
  public commonIconOnColor: ResourceColor = '';
  public commonIconOffColor: ResourceColor = '';
  public commonBgOnColor: ResourceColor = '';
  public commonBgOffColor: ResourceColor = '';
  public chosenSliderBgColor: ResourceColor = '';
  public wifiBgOnColor: ResourceColor = '';
  public wifiBgOffColor: ResourceColor = '';
  public wifiOnTextColor: ResourceColor = '';
  public wifiOffTextColor: ResourceColor = '';
  public brightnessBgColor: ResourceColor = '';
  public volumeAndBrightNessBgColor: ResourceColor = '';
  public brightnessBlockColor: ResourceColor = '';
  public brightnessNotChosenBlockColor: ResourceColor = '';
  public mediaDefaultImgBgColor: ResourceColor = '';
  public mediaDefaultImgColor: ResourceColor = '';
  public subLayoutBgColor: ResourceColor = '';
  // 音量条、亮度条二级页颜色
  public subpageBrightnessBgColor: ResourceColor = '';
  public subpageBrightnessBlockColor: ResourceColor = '';
  public subpageBrightnessTitleColor: ResourceColor = '';
  public subpageBrightnessSettingsColor: ResourceColor = '';

  // 底板5级 控制中心底板使用
  public mainCardOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
    .backgroundFiveOption : undefined;
  public mainCardTogOption : BrightnessOptions | undefined = BrightnessOptionUtils.getInstance().backgroundFiveOption;
  public statusBarPanelOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().statusBarPanelOption : undefined;
  private mainCardOptionOn: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().backgroundFiveOptionOn : undefined;

  public bannerCardOption: BrightnessOptions | undefined = BrightnessOptionUtils.bannerCardOption;

  public keyguardCardOption: BrightnessOptions | undefined = BrightnessOptionUtils.keyguardCardOption;

  public keyguardImmersiveCardOption: BrightnessOptions | undefined = BrightnessOptionUtils.keyguardImmersiveCardOption;

  public customActionViewBg: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
    .customActionViewBg : undefined;

  // 亮度条背景 深色为底板5级 浅色为自定义
  public brightnessBgOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().backgroundFiveOption : undefined;

  // 音量条亮度调背景 深色为底板五级 浅色同WIFIBG
  public volumeAndBrightNessBgOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().volumeAndBrightNessBgOption : undefined;

  // 一级页音量条、亮度条图标按压态提亮效果
  public sliderIconChoosenOption: BrightnessOptions | undefined =
    this.isBrightnessActive ? BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight : undefined;

  // 二级页亮度条高亮，浅色自定义，无深色(默认一直使用提亮效果)
  public subpageBrightnessChoosenOption: BrightnessOptions = BrightnessOptionUtils.subpageBrightnessChoosenLight;
  // 亮度条二级页卡片背景 深色为底板5级 浅色为自定义(默认一直使用提亮效果)
  public brightnessSubpageBgOption: BrightnessOptions = BrightnessOptionUtils.getInstance().backgroundFiveOption;
  // 亮度条二级页亮度条背景 深浅色均为自定义(默认一直使用提亮效果)
  public subpageBrightnessBgOption: BrightnessOptions = BrightnessOptionUtils.subpageBrightnessBgLight;
  public brightnessChoosenOption: BrightnessOptions | undefined = this.isBrightnessActive ? BrightnessOptionUtils
    .getInstance().brightnessChoosenLight : undefined;
  // 亮度条二级页文字图标(默认一直使用提亮效果)
  public subpageElementOption: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight;
  public brightnessNotChosenOption: BrightnessOptions | undefined =
    this.isBrightnessActive ? BrightnessOptionUtils.getInstance().brightnessNotChosenLight : undefined;

  // 实况通知列表背板容器
  public liveListItemCardOption: BrightnessOptions = BrightnessOptionUtils.liveListItemCardOption;

  // 系统实况内容文字提亮参数
  public systemLiveFontOption: BrightnessOptions = BrightnessOptionUtils.getInstance().foregroundSecondaryOption;

  // 系统实况右侧按钮默认背景颜色
  public systemLiveButtonBgCardOption: BrightnessOptions = BrightnessOptionUtils.systemLiveButtonBgCardOption;

  // 系统实况右侧on/off类型按钮on状态背景颜色
  public systemLiveButtonOnBgCardOption: BrightnessOptions = BrightnessOptionUtils.systemLiveButtonOnBgCardOption;

  // 系统实况右侧on/off类型按钮off状态背景颜色
  public systemLiveButtonOffBgCardOption: BrightnessOptions = BrightnessOptionUtils.systemLiveButtonOffBgCardOption;

  // 二级底板上文字、图标使用
  public foregroundPrimaryOptionOnBackground: BrightnessOptions | undefined = this.isBrightnessActive ?
  BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight : undefined;

  public foregroundVolumePrimaryOptionOnBackground: BrightnessOptions | undefined =
  BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight;

  // 沉浸锁屏胶囊辅助区文本提亮
  public immersiveCapTextLightOption: BrightnessOptions | undefined = this.isBrightnessActive ?
  BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight : undefined;

  public immersiveCapTextDarkOption: BrightnessOptions | undefined = this.isBrightnessActive ?
  BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark : undefined;

  // 沉浸锁屏胶囊辅助区背景提亮
  public immersiveCapBgcLightOption: BrightnessOptions | undefined = this.isBrightnessActive ?
  BrightnessOptionUtils.immersiveCapBgcLightOption : undefined;

  public immersiveCapBgcDarkOption: BrightnessOptions | undefined = this.isBrightnessActive ?
  BrightnessOptionUtils.immersiveCapBgcDarkOption : undefined;

  public ntfLiveExtendButtonBgOption: BrightnessOptions = BrightnessOptionUtils.getInstance().customWifiBg;

  /* 通知一键删除提亮参数 */
  public themeAllClearButtonBgOptions: BrightnessOptions | undefined =
    BrightnessOptionUtils.getInstance().backgroundNineDarkOption;

  public superDeviceBgColor: ResourceColor = '';
  public deviceIconBgColor: ResourceColor = '';

  /* 位置权限提示蒙层背景色 */
  public noPermissionBgc: ResourceColor = '';

  /*沉浸卡片UIExtention正在加载组件蒙层背景色 */
  public noLocationBgc: ResourceColor = '';

  /* 通知提亮禁用 */
  public isNtfBrightnessDisable = false;

  /* 实况通知列表Item背景颜色 */
  public liveListItemBgColor: ResourceColor = $r('app.color.ntf_brightness_bg_color');

  public liveListItemBgEffect: BackgroundEffectOptions | undefined = undefined;

  private liveListNoBrightnessBgEffect: BackgroundEffectOptions = {
    radius: 0,
    brightness: 1.01,
    blurOptions: { grayscale: [LIVE_NTF_DEFAULT_BLUR_OPTIONS_GRAYSCALE, LIVE_NTF_DEFAULT_BLUR_OPTIONS_GRAYSCALE] }
  };

  constructor() {
    this.init();
  }

  private init() {
    let curMode = GlobalContext.getContext()?.config?.colorMode as number;
    this.isNtfBrightnessDisable =
      SCBVisualEffectManagerAdapter.getFeatureParam(VisualEffectConstants.NTF_BRIGHTENS_DISABLE) === 'true';
    if (curMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.changeLightMode();
      this.changeLightModeWithAnim();
    } else {
      this.changeDarkMode();
      this.changeDarkModeWithAnim();
    }
    if (this.isNtfBrightnessDisable) {
      this.liveListItemBgColor = $r('app.color.live_heads_up_disable_brightness_bg_color');
    }
  }

  public changeLightMode() {
    this.foregroundSecondaryOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundSecondaryOption : undefined;
    this.foregroundTertiaryGlossOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundTertiaryGlossOption : undefined;
    this.foregroundDividerOption = BrightnessOptionUtils.getInstance().foregroundDividerOption;
    this.systemLiveFontOption = BrightnessOptionUtils.getInstance().foregroundSecondaryOption;
    this.customActionViewBg = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().customActionViewBg : undefined;
    this.bannerCardOption = BrightnessOptionUtils.bannerCardOption;
    this.liveListItemCardOption = BrightnessOptionUtils.liveListItemCardOption;
    this.keyguardCardOption = BrightnessOptionUtils.keyguardCardOption;
    this.systemLiveButtonBgCardOption = BrightnessOptionUtils.systemLiveButtonBgCardOption;
    this.systemLiveButtonOnBgCardOption = BrightnessOptionUtils.systemLiveButtonOnBgCardOption;
    this.systemLiveButtonOffBgCardOption = BrightnessOptionUtils.systemLiveButtonOffBgCardOption;

    this.keyguardImmersiveCardOption = BrightnessOptionUtils.keyguardImmersiveCardOption;
    this.ntfLiveExtendButtonBgOption = BrightnessOptionUtils.getInstance().customWifiBg;
    this.addMoreTextOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundSecondaryOption : undefined;
    this.subpageMoreSettingsOption = BrightnessOptionUtils.getInstance().foregroundPrimaryOnOptionDark;
    this.liveListItemBgEffect = undefined;
  }

  public changeLightModeWithAnim(degree?: number) {
    this.commonDefaultRate = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_rate_off'));
    this.commonDefaultDegree = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightUpDegree_off'));
    this.wifiDefault = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().customWifiBg : undefined;
    this.wifiOn = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().customWifiBgOn : undefined;
    this.foregroundTertiaryGlossSubOption = this.isBrightnessActive ?
      BrightnessOptionUtils.getInstance().foregroundTertiaryGlossOption : undefined;
    this.brightnessNotChosenOption =
      this.isBrightnessActive ? BrightnessOptionUtils.getInstance().brightnessNotChosenLight : undefined;

    this.commonIconOnColor = $r('app.color.Control_center_icon_on_color');
    this.commonIconOffColor = $r('app.color.Control_center_icon_default_color');
    this.commonBgOnColor = $r('app.color.Control_center_icon_on_bg_color');
    this.commonBgOffColor = this.isUseDefaultColor() ? $r('app.color.Control_center_icon_default_bg_color') :
      $r('app.color.Control_center_icon_default_bg_color_opacity');
    this.chosenSliderBgColor = this.isUseDefaultColor() ? $r('app.color.Control_center_icon_default_bg_color') :
      $r('app.color.Control_center_brightness_bg_color_opacity');
    this.wifiOnTextColor = $r('app.color.Control_center_long_button_font_on_color');
    this.wifiOffTextColor = $r('app.color.Control_center_long_button_font_default_color');
    this.wifiBgOnColor = $r('app.color.Control_center_wifiBlue_icon_on_bg_color');
    this.wifiBgOffColor = this.isUseDefaultColor() ? $r('app.color.Control_center_wifiBlue_icon_default_bg_color') :
      $r('app.color.Control_center_wifiBlue_icon_default_bg_color_opacity');
    this.brightnessBgColor = !DISABLE_BRIGHTNESS ? $r('app.color.Control_center_brightness_bg_color') :
      $r('app.color.Control_center_brightness_bg_color_opacity');
    this.volumeAndBrightNessBgColor = $r('app.color.Control_center_wifiBlue_icon_on_bg_color');
    this.brightnessBlockColor = $r('app.color.Control_center_brightness_block_color');
    this.subpageBrightnessTitleColor = $r('app.color.Control_center_brightness_subpage_title_color');
    this.subpageBrightnessBgColor = $r('app.color.Control_center_brightness_subpage_bg_color');
    this.subpageBrightnessBlockColor = $r('app.color.Control_center_brightness_subpage_block_color');
    this.subpageBrightnessSettingsColor = $r('app.color.Control_center_brightness_subpage_settings_color');
    this.brightnessNotChosenBlockColor = $r('app.color.Control_center_wifiBlue_icon_default_bg_color');
    this.superDeviceBgColor = $r('app.color.super_device_icon_bg_color');
    this.deviceIconBgColor = $r('app.color.device_icon_bg_color');
    this.mediaDefaultImgBgColor = $r('app.color.media_control_default_img_bgc');
    this.mediaDefaultImgColor = $r('app.color.media_control_icon_disable');
    this.subLayoutBgColor = !DISABLE_BRIGHTNESS ? $r('app.color.Control_center_subLayout_default_bg_color') :
      $r('app.color.Control_center_subLayout_default_bg_color_opacity');
    this.noPermissionBgc = $r('sys.color.font_on_tertiary');
    this.noLocationBgc = $r('app.color.immersive_card_no_location_bg_color');

    this.invertLabelColor(degree);
    this.mainCardOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().backgroundFiveOption : undefined;
    this.mainCardTogOption = BrightnessOptionUtils.getInstance().backgroundFiveOption;
    this.volumeAndBrightNessBgOption = BrightnessOptionUtils.getInstance().volumeAndBrightNessBgOption;
    this.mainCardOptionOn = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().backgroundFiveOptionOn :
      undefined;
    this.statusBarPanelOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .statusBarPanelOption : undefined;
    this.brightnessBgOption = this.isBrightnessActive ? BrightnessOptionUtils.brightnessBgLight : undefined;
    this.brightnessSubpageBgOption = BrightnessOptionUtils.brightnessSubpageBgLight;
    this.subpageBrightnessBgOption = BrightnessOptionUtils.subpageBrightnessBgLight;
    this.foregroundPrimaryOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundPrimaryOptionLight
      : undefined;
    this.foregroundPrimaryOnOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundPrimaryOnOptionLight
      : undefined;
    this.addMoreBgOption = this.isBrightnessActive ?BrightnessOptionUtils.getInstance()
      .backgroundEightOption : undefined;
    this.brightnessChoosenOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .brightnessChoosenLight : undefined;
    this.foregroundPrimaryOptionOnBackground = this.isBrightnessActive ?
    BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight : undefined;
    this.sliderIconChoosenOption =
      this.isBrightnessActive ? BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight : undefined;
    this.subpageElementOption = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight;
  }

  public changeDarkMode() {
    this.foregroundSecondaryOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundSecondaryDarkOption : undefined;
    this.foregroundTertiaryGlossOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundTertiaryDarkOption : undefined;
    this.foregroundDividerOption = BrightnessOptionUtils.getInstance().foregroundDividerDarkOption;
    this.systemLiveFontOption = BrightnessOptionUtils.getInstance().foregroundSecondaryDarkOption;
    this.customActionViewBg = this.isBrightnessActive ?
      BrightnessOptionUtils.getInstance().customActionViewBgDark : undefined;
    this.bannerCardOption = BrightnessOptionUtils.bannerCardDarkOption;
    this.liveListItemCardOption = BrightnessOptionUtils.liveListItemCardOption;
    this.keyguardCardOption = BrightnessOptionUtils.keyguardCardDarkOption;
    this.systemLiveButtonBgCardOption = BrightnessOptionUtils.systemLiveButtonBgCardDarkOption;
    this.systemLiveButtonOnBgCardOption = BrightnessOptionUtils.systemLiveButtonOnBgCardDarkOption;
    this.systemLiveButtonOffBgCardOption = BrightnessOptionUtils.systemLiveButtonOffBgCardDarkOption;
    this.keyguardImmersiveCardOption = BrightnessOptionUtils.keyguardImmersiveDarkCardOption;
    this.ntfLiveExtendButtonBgOption = BrightnessOptionUtils.getInstance().customWifiBgDark;
    this.addMoreTextOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundSecondaryOption : undefined;
    this.subpageMoreSettingsOption = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionDark;
    this.liveListItemBgEffect = this.isNtfBrightnessDisable ? this.liveListNoBrightnessBgEffect : undefined;
  }

  public changeDarkModeWithAnim(degree?: number) {
    this.commonDefaultRate = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_rate_off_darkMode'));
    this.commonDefaultDegree = ResUtils.getConvertNumber($r('app.float.Control_center_brightness_lightUpDegree_off_darkMode'));
    this.brightnessNotChosenOption =
      this.isBrightnessActive ? BrightnessOptionUtils.getInstance().brightnessNotChosenDark : undefined;
    this.wifiDefault = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().customWifiBgDark : undefined;
    this.wifiOn = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().customWifiBgOnDark : undefined;
    this.foregroundTertiaryGlossSubOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundTertiaryDarkOption : undefined;

    this.commonIconOnColor = $r('app.color.Control_center_icon_on_color_dark');
    this.commonIconOffColor = $r('app.color.Control_center_icon_default_color_dark');
    this.commonBgOnColor = $r('app.color.Control_center_icon_on_bg_color_dark');
    this.commonBgOffColor = this.isUseDefaultColor() ? $r('app.color.Control_center_icon_default_bg_color_dark') :
      $r('app.color.Control_center_icon_default_bg_color_dark_opacity');
    this.chosenSliderBgColor = this.isUseDefaultColor() ? $r('app.color.Control_center_icon_default_bg_color_dark') :
      $r('app.color.Control_center_icon_default_bg_color_dark_opacity');
    this.wifiOnTextColor = $r('app.color.Control_center_long_button_font_on_color_dark');
    this.wifiOffTextColor = $r('app.color.Control_center_long_button_font_default_color_dark');
    this.wifiBgOnColor = $r('app.color.Control_center_wifiBlue_icon_on_bg_color_dark');
    this.wifiBgOffColor = this.isUseDefaultColor() ? $r('app.color.Control_center_wifiBlue_icon_default_bg_color_dark') :
      $r('app.color.Control_center_wifiBlue_icon_default_bg_color_dark_opacity');
    this.brightnessBgColor = !DISABLE_BRIGHTNESS ? $r('app.color.Control_center_brightness_bg_color_dark') :
      $r('app.color.Control_center_brightness_bg_color_dark_opacity');
    this.volumeAndBrightNessBgColor = $r('app.color.Control_center_brightness_bg_color_dark');
    this.brightnessBlockColor = $r('app.color.Control_center_brightness_block_color_dark');
    this.subpageBrightnessBgColor = $r('app.color.Control_center_brightness_subpage_bg_color_dark');
    this.subpageBrightnessBlockColor = $r('app.color.Control_center_brightness_subpage_block_color_dark');
    this.subpageBrightnessTitleColor = $r('app.color.Control_center_brightness_subpage_title_color_dark');
    this.subpageBrightnessSettingsColor = $r('app.color.Control_center_brightness_subpage_settings_color_dark');
    this.brightnessNotChosenBlockColor = $r('app.color.Control_center_wifiBlue_icon_default_bg_color_dark');
    this.superDeviceBgColor = $r('app.color.Control_center_icon_default_bg_color_dark');
    this.deviceIconBgColor = $r('app.color.device_icon_bg_color_dark');
    this.mediaDefaultImgBgColor = $r('app.color.media_control_default_img_bgc_dark');
    this.mediaDefaultImgColor = $r('app.color.media_control_icon_disable_dark');
    this.subLayoutBgColor = !DISABLE_BRIGHTNESS ? $r('app.color.Control_center_subLayout_default_bg_color_dark') :
      $r('app.color.Control_center_subLayout_default_bg_color_dark_opacity');
    this.noPermissionBgc = $r('app.color.immersive_auth_overlay_dark');
    this.noLocationBgc = $r('app.color.immersive_card_no_location_dark_bg_color');

    this.invertLabelColor(degree);
    this.mainCardOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .backgroundFiveOptionDark : undefined;
    this.mainCardTogOption = BrightnessOptionUtils.getInstance().backgroundFiveOptionDark;
    this.mainCardOptionOn = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .backgroundFiveOptionOnDark : undefined;
    this.statusBarPanelOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .statusBarPanelDarkOption : undefined;
    this.brightnessBgOption = this.isBrightnessActive ? this.mainCardOption : undefined;
    this.brightnessSubpageBgOption = BrightnessOptionUtils.getInstance().backgroundFiveOptionDark;
    this.volumeAndBrightNessBgOption = BrightnessOptionUtils.getInstance().volumeAndBrightNessBgOptionDark;
    this.subpageBrightnessBgOption = BrightnessOptionUtils.brightnessBgLight;
    this.foregroundPrimaryOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundPrimaryOptionDark : undefined;
    this.foregroundPrimaryOnOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .foregroundPrimaryOnOptionDark : undefined;
    this.addMoreBgOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance().backgroundSixOption : undefined;
    this.brightnessChoosenOption = this.isBrightnessActive ? BrightnessOptionUtils.getInstance()
      .brightnessChoosenOptionDark : undefined;
    this.foregroundPrimaryOptionOnBackground = this.isBrightnessActive ?
    BrightnessOptionUtils.getInstance().foregroundPrimaryOptionOnBackgroundDark : undefined;
    this.subpageElementOption = BrightnessOptionUtils.getInstance().foregroundPrimaryOptionOnBackgroundDark;
    this.sliderIconChoosenOption =
      this.isBrightnessActive ? BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight : undefined;
  }

  private invertLabelColor(degree?: number) {
    if (degree === undefined) {
      return;
    }
    // 发送degree更新事件
    EvtBus.post(ControlCenterBackgroundDegreeEvent, { controlCenterDegree: degree });
    log.showInfo('invertLabelColor: %{public}d', degree);
    ColorInvertTool.getInstance().changeLabelColor(degree);
  }
  public getTopOption(isOn? : boolean) : BrightnessOptions | undefined {
    return isOn ? this.wifiOn : this.wifiDefault;
  }

  public getMainCardOption(isOn? : boolean) : BrightnessOptions | undefined {
    return isOn ? this.mainCardOptionOn : this.mainCardOption;
  }

  public getPrimaryFgOption(isOn? : boolean) : BrightnessOptions | undefined {
    return isOn ? this.foregroundPrimaryOnOption : this.foregroundPrimaryOptionOnBackground;
  }

  public getVolumePrimaryFgOption(isOn? : boolean) : BrightnessOptions | undefined {
    return isOn ? this.foregroundVolumePrimaryOnOption : this.foregroundVolumePrimaryOptionOnBackground;
  }

  // F键音量条背景板
  public getVolumeDarkFgOption() : BrightnessOptions | undefined {
    return this.isBrightnessActive ? BrightnessOptionUtils.getInstance().statusBarPanelDarkOption : undefined;
  }
  // F键音量条前景图标
  public getVolumeForegroundOption(isOn? : boolean) : BrightnessOptions | undefined {
    return isOn ? BrightnessOptionUtils.getInstance().foregroundPrimaryOptionLight :
    BrightnessOptionUtils.getInstance().foregroundPrimaryOptionOnBackgroundDark;
  }

  public setBrightnessStatus(isSysColor: boolean) {
    if (isSysColor === this.isBrightnessActive) {
      return;
    }
    log.showInfo(`theme event activation setBrightnessStatus  ${isSysColor}`);
    this.isBrightnessActive = isSysColor;
    this.init();
  }

  /**
   * 产品化定制视效调整接口，配置是否使能提亮压暗效果
   *
   * @param option
   * @returns option or undefined
   */
  public getBrightnessOption(option: BrightnessOptions | undefined): BrightnessOptions | undefined {
    return DISABLE_BRIGHTNESS ? undefined : option;
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
   * 产品化定制视效调整接口，计算纯色模式下的控制中心组件背景色
   *
   * @param originColor 原颜色
   * @param option 提亮压暗参数
   * @returns 组件背景色
   */
  public getSolidColor(originColor: ResourceColor, option: BrightnessOptions | undefined): ResourceColor {
    // 纯色效果不启用或提亮压暗参数无效时，返回原颜色
    if (!this.isUseSolidColor() || !option) {
      return originColor;
    }
    const pickColor = this.pickColor;
    const curMode = GlobalContext.getContext()?.config?.colorMode as number;
    const adjustRGB = SolidColorAlgorithmUtils.adjustRGB(pickColor, curMode);
    const editedColor: effectKit.Color = {
      red: adjustRGB[0],
      green: adjustRGB[1],
      blue: adjustRGB[2],
      alpha: pickColor.alpha
    };
    const solidColor = SolidColorAlgorithmUtils.calSolidColor(option, editedColor);
    if (solidColor) {
      const red = solidColor?.red.toString(16).padStart(2, '0');
      const green = solidColor?.green.toString(16).padStart(2, '0');
      const blue = solidColor?.blue.toString(16).padStart(2, '0');
      return `#FF${red}${green}${blue}`;
    }
    return originColor;
  }

  /**
   * 当产品化定制视效不使能提亮压暗效果，或提亮压暗效果总开关关闭时使用默认颜色
   *
   * @returns boolean
   */
  public isUseDefaultColor(): boolean {
    return !DISABLE_BRIGHTNESS || !this.isBrightnessActive;
  }

  /**
   * 当产品化定制视效使能纯色模式且系统不使用默认颜色时，启用纯色效果
   *
   * @returns boolean
   */
  public isUseSolidColor(): boolean {
    return ENABLE_SOLID_COLOR && !this.isUseDefaultColor();
  }

  /**
   * 计算主纯色颜色，通知中心下拉和点击实况胶囊时计算卡片背景颜色场景
   *
   * @param color 不使用纯色模式时的原始颜色
   * @param option 不使用纯色模式时的原始颜色
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
    return ENABLE_SOLID_COLOR && this.isNtfBrightnessDisable;
  }

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
}