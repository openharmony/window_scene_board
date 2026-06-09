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

import { ILiveCardOtherVm } from '../interface/ILiveCardOtherVm';
import { LiveItemBaseVm } from './LiveBaseVm';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCardType, LiveRichTextModel } from '../model/LiveCommonModel';
import { LiveCardOtherModel } from '../model/LiveCardOtherModel';
import { LiveStyle } from '../constants/LiveStyle';
import { AccessibilityVm } from '../../vm/AccessibilityVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { TextInfo, TextUtil } from '../../utils/TextUtil';
import { text } from '@kit.ArkGraphics2D';
import uiEffect from '@ohos.graphics.uiEffect';
import { LiveCardWeatherUtil } from '../../utils/LiveCardWeatherUtil';
import { WeatherType, PriorityWeatherScene } from '../model/LiveWeatherModel';
import { SystemUICcmConfig } from '../../utils/SystemUICcmConfig';
import { LiveCardFlightModel } from '../model/LiveCardFlightModel'
import { LiveCardShowAnimationEvent } from '../../event/LiveCardShowAnimationEvent';
import { SystemUIUseScene } from '../../constants/SystemuiConstants';
import { DropdownVm } from '../../vm/DropdownVm';
import { BannerVm } from '../../vm/BannerVm';
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { ILiveCardOtherProgressVm } from '../interface/ILiveCardOtherProgressVm';
import { ILiveCardOtherExtendVm } from '../interface/ILiveCardOtherExtendVm';
import { TargetPanel } from '@ohos/frameworkwrapper';
import { EnvVm } from '../../vm/EnvVm';
import { LiveNotification } from '../model/LiveNotification';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';

const TAG = 'LiveCardOtherVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCardOtherVm extends LiveItemBaseVm implements ILiveCardOtherVm {
  @Trace public contentRenderGroup: boolean = true;
  @Trace public contentLayoutLength: number = 0;
  @Trace public isShowUnderline: boolean = true;
  @Trace public visualEffect: uiEffect.VisualEffect | undefined = undefined;
  @Computed get card(): LiveCardOtherModel {
    return this.live.card as LiveCardOtherModel
  }

  /**
   * 将文本中的{placeholder.timer}占位符替换为倒计时
   * @param text 需要替换的文本
   * @param isAccessibilityText 是否用于无障碍
   * @returns 返回替换后的文本
   */
  protected replaceTimeHolder(text: string, isAccessibilityText: boolean = false): string {
    if (CommonUtils.isInvalid(text)) {
      log.showInfo(' text is invalid ');
      return '';
    }
    const timeTemplateReg : RegExp = /\$\{placeholder.timer\}/g;
    if (!this.card.timer) {
      const result = text.replace(timeTemplateReg, '');
      return result;
    }
    let timeText = '';
    if (isAccessibilityText) {
      timeText = this.vmInjector.getTimerVm().getTimerAccessibilityText(this.card.timer);
    } else {
      timeText = this.vmInjector.getTimerVm().getTimerText(this.card.timer);
    }
    const result = text.replace(timeTemplateReg, timeText);
    this.isShowUnderline = result.trim().length > 0;
    if (result.trim().length === 0) {
      return '';
    }
    return result;
  }

  @Computed get title(): string {
    if (this.isHideContent()) {
      return this.live.appLabel;
    }
    return this.replaceTimeHolder(this.card.fixedTitle);
  }

  public flightCircleColor: ResourceColor = $r('sys.color.ohos_id_color_foreground_dark');
  public dividerColor: ResourceColor = $r('app.color.live_card_divider_bg_color');
  public underlineOpacity: number = 1;
  public titleMargin: Resource = $r('app.float.live_view_other_card_title_margin_bottom');
  public topZonePadding: Padding | undefined = {
    left: LiveStyle.CARD_PADDING,
    right: LiveStyle.CARD_PADDING,
  };
  //沉浸态参数
  public cardMarginTop: Length | undefined = undefined;
  public cardMarginBottom: Length | undefined = undefined;
  public cardMarginHorizontal: Length | undefined = undefined;
  public titleMinFontSize: Length = $r('app.float.live_view_other_card_title_min_font_size');
  public richTextFontSize: Resource = $r('sys.float.ohos_id_text_size_body2');
  public bottomHalfHeight?: Length = 72;
  public fontFixedAreaHeight: number = 34;
  public isHideContent(): boolean {
    return false;
  }

  get providerNameColor(): ResourceColor {
    return $r('sys.color.ohos_id_color_text_tertiary_dark');
  }

  get contentTextFontSize(): Length | undefined {
    return $r('sys.float.ohos_id_text_size_body2');
  }

  @Computed
  get maxFontScale(): number {
    return ResourceVm.instance.getLiveFontScale(ResourceVm.DEFAULT_MAX_SCALE);
  }

  @Computed
  get extendOpacity(): number | undefined {
    return undefined;
  }

  @Computed get titleMaxFontSize(): Length {
    return ResourceVm.instance.getLiveFontSize(this.isHideLayout()
      ? $r('sys.float.ohos_id_text_size_sub_title3')
      : $r('sys.float.ohos_id_text_size_headline8'));
  }

  @Computed
  get titleFontWeight(): number | FontWeight | string | undefined {
    return this.isHideLayout() ? FontWeight.Medium : FontWeight.Bold;
  }

  @Computed get titleLineHeight(): Length {
    return ResourceVm.instance.getLiveFontSize(this.isHideLayout()
      ? $r('app.float.live_view_card_text_line_height')
      : $r('app.float.live_view_card_hide_layout_height'));
  }

  @Computed get richTextLineHeight(): Length {
    return ResourceVm.instance.getLiveFontSize($r('app.float.live_view_card_text_line_height'));
  }

  @Computed
  get dividerFgColor(): ResourceColor {
    return this.vmInjector.getColorVm()
      .calcSecondarySolidColor(this.dividerColor, this.vmInjector.getColorVm().liveCardDividerFgBrightness,
        this.vmInjector.getColorVm().liveBgPickColor);
  }

  @Computed
  get dividerBrightness(): BrightnessOptions | undefined {
    return this.vmInjector.getColorVm().liveCardDividerFgBrightness;
  }

  public onUpdate(live: LiveNotification): void {
    this.live = live;
    log.showInfo(`on live update ${live.hashCode}`);
    if (!this.checkScene()) {
      return;
    }
    if (live.card.isFlightCard() && !(live.card as LiveCardFlightModel).liveCardWeatherInfo?.isUpdateAnimation) {
      return;
    }
    const duration = this.vmInjector.scene === SystemUIUseScene.KG ? LiveStyle.WEATHER_AOD_ANIMATION_DURATION :
      LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION;
    this.setWeatherAnimation(duration);
  }

  @Computed
  get cardOtherProgressVm(): ILiveCardOtherProgressVm {
    return this.vmInjector.getCardOtherProgressVm(this.live);
  }

  @Computed
  get cardOtherExtendVm(): ILiveCardOtherExtendVm {
    return this.vmInjector.getCardOtherExtendVm(this.live);
  }

  public getContentWidth(txt: string): number {
    if (!txt || !txt.length) {
      return 0;
    }
    // 测量的文本信息，必须与展示文本的控件信息完全一致
    const textInfo: TextInfo = {
      textContent: txt,
      fontSize: LiveStyle.PICKUP_EXTEND_TIMER_FONT_SIZE,
      fontWeight: text.FontWeight.W700,
      fontFamilies: ['HarmonyHeiTi'],
      maxLines: 1,
      textBoxWidth: this.contentLayoutLength
    }
    return TextUtil.getLongestLineActualWidth(textInfo);
  }

  get titleFontColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TITLE_FONT_COLOR;
  }

  get contentFontColor(): ResourceColor | undefined {
    return LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  public getContentText(richText: LiveRichTextModel): string {
    return this.replaceTimeHolder(richText.text) ?? '';
  }

  public getContentFontColor(richText: LiveRichTextModel): ResourceColor | undefined {
    return richText.textColor ?? LiveStyle.LIVE_CARD_TEXT_FONT_COLOR;
  }

  public getContentFontWeight(richText: LiveRichTextModel): FontWeight {
    return FontWeight.Regular;
  }

  public getTimerContent(content: string): string {
    return this.replaceTimeHolder(content);
  }

  public getFixedAreaHeight(): number {
    return LiveStyle.LIVE_OTHER_CARD_FIXED_HEIGHT +
    ResourceVm.instance.getLiveFontScaleHeightDiff(this.fontFixedAreaHeight);
  }

  public getCardHeight(): number {
    return (this.isHideLayout() ? LiveStyle.LIVE_SYSTEM_CARD_HEIGHT : LiveStyle.LIVE_OTHER_CARD_HEIGHT) +
    ResourceVm.instance.getLiveFontScaleHeightDiff(this.fontFixedAreaHeight);
  }

  public getWeatherBackgroundHeight(): number {
    return LiveStyle.LIVE_OTHER_CARD_FIXED_HEIGHT +
    ResourceVm.instance.getLiveFontScaleHeightDiff(this.fontFixedAreaHeight) + 72;
  }

  /**
   * 是否隐藏扩展区
   */
  isHideLayout(): boolean {
    return this.card.cardType === LiveCardType.NO_LAYOUT;
  }

  public getAccessibilityText(text: string): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    return this.replaceTimeHolder(text, true);
  }

  public getContentAccessibilityText(): string {
    let text = '';
    if (!AccessibilityVm.instance.isEnabled) {
      return text;
    }
    this.card.fixedContent.forEach((richText) => {
      text += this.replaceTimeHolder(richText.text, true) ?? '';
    })
    return text;
  }

  public onLiveCardAnimationEventChange = (event: LiveCardShowAnimationEvent): void => {
    if (!this.checkScene()) {
      return;
    }
    const duration = this.vmInjector.scene === SystemUIUseScene.KG ? LiveStyle.WEATHER_AOD_ANIMATION_DURATION :
    LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION;
    log.showInfo(`onLiveCardAnimationEventChange ${duration} ${event.EVENT_SHOW_DELAY} ${DropdownVm.instance.isFromCCToNC}`);
    this.setWeatherAnimation(duration, event.EVENT_SHOW_DELAY);
    this.startOtherCardAnim(this.getProgressDelay());
  }

  private startOtherCardAnim(delay: number = LiveStyle.PROGRESS_ANIMATION_DELAY, resetType: 0 | 1 | 2 = 1): void {
    if (!this.live) {
      return;
    }
    if (DropdownVm.instance.isFromCCToNC) {
      return;
    }
    if (this.live.card.isOtherCard()) {
      this.cardOtherExtendVm.startImageAnim(delay);
    }
    if (this.live.card.isProgressCard()) {
      this.cardOtherProgressVm.startProgressAnim(delay, resetType);
    }
  }

  private setWeatherAnimation(duration: number, delay: number = 5): void {
    if (!this.live.card.isFlightCard()) {
      this.visualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(false, duration, WeatherType.WEATHER_TYPE_INVALID);
      return;
    }
    if (this.live.card.liveCardWeatherInfo?.showType === PriorityWeatherScene.INVALID_SCENE) {
      this.visualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(false, duration, WeatherType.WEATHER_TYPE_INVALID);
      return;
    }
    if (!SystemUICcmConfig.instance.liveConfig.isShowWeatherAnimationWhenExpandCard()) {
      this.setStaticEffect();
      return;
    }
    const weatherType = this.live.card.liveCardWeatherInfo?.weatherType;
    this.setStaticEffect();
    setTimeout(() => {
      this.visualEffect = LiveCardWeatherUtil.instance.setHdsEffect(true, duration, weatherType);
    }, delay);
  }

  private setStaticEffect(): void {
    if (!this.live) {
      return;
    }
    if (!this.live.card.isFlightCard()) {
      return;
    }
    if (this.live.card.liveCardWeatherInfo?.showType === PriorityWeatherScene.INVALID_SCENE) {
      this.visualEffect =
        LiveCardWeatherUtil.instance.setHdsEffect(false, LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION,
          WeatherType.WEATHER_TYPE_INVALID);
      return;
    }
    const weatherType = (this.live.card as LiveCardFlightModel).liveCardWeatherInfo?.weatherType;
    this.visualEffect = LiveCardWeatherUtil.instance.setHdsEffect(false, 0, weatherType);
    setTimeout(() => {
      this.visualEffect = LiveCardWeatherUtil.instance.setHdsEffect(true, 0, weatherType);
    }, 0);
  }

  public setAppearAnimation(): void {
    this.setWeatherAnimation(LiveStyle.WEATHER_NORMAL_ANIMATION_DURATION, 5);
    setTimeout(() => {
      this.startOtherCardAnim(this.getProgressDelay(), 2);
    });
    return;
  }

  private checkScene(): boolean {
    let currentScene = '';
    if (DropdownVm.instance.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL &&
      this.vmInjector.scene === SystemUIUseScene.DROPDOWN) {
      currentScene = SystemUIUseScene.DROPDOWN;
    } else if (BannerVm.instance.bannerType === BannerPanelType.TYPE_LIVE_LIST &&
      this.vmInjector.scene === SystemUIUseScene.LIVE) {
      currentScene = SystemUIUseScene.LIVE;
    } else if (BannerVm.instance.bannerType === BannerPanelType.TYPE_LIVE_HEADS_UP &&
      this.vmInjector.scene === SystemUIUseScene.LIVE) { //实况2.0横幅是live场景
      currentScene = SystemUIUseScene.LIVE;
    } else if (EnvVm.instance.isScreenLock && this.vmInjector.scene === SystemUIUseScene.KG) {
      currentScene = SystemUIUseScene.KG;
    }
    log.showInfo(`currentScene ${currentScene}, vmInjector scene ${this.vmInjector.scene}`);
    if (currentScene !== '' && currentScene === this.vmInjector.scene) {
      return true;
    }
    return false;
  }

  private getProgressDelay(): number {
    if (!this.vmInjector.getLiveHeadsUpVm().isBannerWeatherScene) {
      return LiveStyle.PROGRESS_ANIMATION_DELAY;
    }

    if (!CutoutVm.instance.isMiddleCutout()) {
      return LiveStyle.PROGRESS_ANIMATION_DELAY;
    }

    return LiveStyle.PROGRESS_ANIMATION_DELAY + 350;
  }
}