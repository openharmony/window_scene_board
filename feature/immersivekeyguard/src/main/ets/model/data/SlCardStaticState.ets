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

import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  CardStaticStateType,
  SlMainStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { ImmersiveAnimKey } from '../../common/anim/ImmersiveAnimConstants';
import { ANIM_STATE_MAP } from '../../common/anim/ImmersiveAnimParam';
import { CardAnimType } from '../../common/ImmersiveConstants';
import { ImmersiveTextStyle } from '@ohos/systemuicommon/Index';

/**
 * 锁屏组件，沉浸卡片组件静态状态管理
 *
 */
export class SlCardStaticState extends WidgetStaticState<CardStaticStateType> {
  /**
   * 沉浸卡片更新卡片场景动效状态
   */
  private slUpdateCardAnimCtrl: WidgetAnimState | undefined = ANIM_STATE_MAP.get(CardAnimType.CARD_UPDATE_TYPE);
  /**
   * 沉浸卡片切换卡片场景动效状态
   */
  private slToggleCardAnimCtrl: WidgetAnimState | undefined = ANIM_STATE_MAP.get(CardAnimType.CARD_TOGGLE_TYPE);
  /**
   * 沉浸卡片根布局动效状态
   */
  private slRootCardAnimCtrl: WidgetAnimState | undefined = ANIM_STATE_MAP.get(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT);
  /**
   * 背景色
   */
  private cardBackgroundColor?: ResourceColor;
  /**
   * 提亮参数
   */
  private brightnessOptions?: BrightnessOptions;
  /**
   * 三方卡片标题样式
   */
  private otherCardTitleTextStyle?: ImmersiveTextStyle;
  /**
   * 三方卡片副文本样式
   */
  private otherCardRichTextStyle?: ImmersiveTextStyle;
  /**
   * 导航卡片主要导航文本样式
   */
  private cardMainNavInfoStyle?: ImmersiveTextStyle;
  /**
   * 导航卡片次要导航文本样式
   */
  private cardViceNavInfoStyle?: ImmersiveTextStyle;

  constructor() {
    super(SlMainStateType.SL_CARD_WG_STATIC_STATE);
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initSetMethods(): void {
    this.setMethods.set(CardStaticStateType.BACKGROUND_COLOR, this.setMethodBackgroundColor);
    this.setMethods.set(CardStaticStateType.BRIGHTNESS, this.setMethodBrightness);
    this.setMethods.set(CardStaticStateType.OTHER_CARD_TITLE_TEXT_STYLE, this.setMethodOtherCardTitleTextStyle);
    this.setMethods.set(CardStaticStateType.OTHER_CARD_RICH_TEXT_STYLE, this.setMethodOtherCardRichTextStyle);
    this.setMethods.set(CardStaticStateType.CARD_MAIN_NAV_INFO_STYLE, this.setMethodCardMainNavInfoStyle);
    this.setMethods.set(CardStaticStateType.CARD_VICE_NAV_INFO_STYLE, this.setMethodCardViceNavInfoStyle);
  }

  private setMethodBackgroundColor(st: SlCardStaticState, value: ResourceColor): void {
    st.setBackgroundColor(value);
  }

  private setMethodBrightness(st: SlCardStaticState, value: BrightnessOptions): void {
    st.setBrightness(value);
  }

  private setMethodOtherCardTitleTextStyle(st: SlCardStaticState, value: ImmersiveTextStyle): void {
    st.setOtherCardTitleTextStyle(value);
  }

  private setMethodOtherCardRichTextStyle(st: SlCardStaticState, value: ImmersiveTextStyle): void {
    st.setOtherCardRichTextStyle(value);
  }

  private setMethodCardMainNavInfoStyle(st: SlCardStaticState, value: ImmersiveTextStyle): void {
    st.setCardMainNavInfoStyle(value);
  }

  private setMethodCardViceNavInfoStyle(st: SlCardStaticState, value: ImmersiveTextStyle): void {
    st.setCardViceNavInfoStyle(value);
  }

  private getMethodSlUpdateCardAnimCtrl(st: SlCardStaticState): WidgetAnimState | undefined {
    return st.getSlUpdateCardAnimCtrl();
  }

  private getMethodSlToggleCardAnimCtrl(st: SlCardStaticState): WidgetAnimState | undefined {
    return st.getSlToggleCardAnimCtrl();
  }

  private getMethodSlRootCardAnimCtrl(st: SlCardStaticState): WidgetAnimState | undefined {
    return st.getSlRootCardAnimCtrl();
  }

  private getMethodBackgroundColor(st: SlCardStaticState): ResourceColor | undefined {
    return st.getBackgroundColor();
  }

  private getMethodBrightness(st: SlCardStaticState): BrightnessOptions | undefined {
    return st.getBrightness();
  }

  private getMethodOtherCardTitleTextStyle(st: SlCardStaticState): ImmersiveTextStyle | undefined {
    return st.getOtherCardTitleTextStyle();
  }

  private getMethodOtherCardRichTextStyle(st: SlCardStaticState): ImmersiveTextStyle | undefined {
    return st.getOtherCardRichTextStyle();
  }

  private getMethodCardMainNavInfoStyle(st: SlCardStaticState): ImmersiveTextStyle | undefined {
    return st.getCardMainNavInfoStyle();
  }

  private getMethodCardViceNavInfoStyle(st: SlCardStaticState): ImmersiveTextStyle | undefined {
    return st.getCardViceNavInfoStyle();
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initGetMethods(): void {
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlUpdateCardAnimCtrl);
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlToggleCardAnimCtrl);
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlRootCardAnimCtrl);
    this.getMethods.set(CardStaticStateType.BACKGROUND_COLOR, this.getMethodBackgroundColor);
    this.getMethods.set(CardStaticStateType.BRIGHTNESS, this.getMethodBrightness);
    this.getMethods.set(CardStaticStateType.OTHER_CARD_TITLE_TEXT_STYLE, this.getMethodOtherCardTitleTextStyle);
    this.getMethods.set(CardStaticStateType.OTHER_CARD_RICH_TEXT_STYLE, this.getMethodOtherCardRichTextStyle);
    this.getMethods.set(CardStaticStateType.CARD_MAIN_NAV_INFO_STYLE, this.getMethodCardMainNavInfoStyle);
    this.getMethods.set(CardStaticStateType.CARD_VICE_NAV_INFO_STYLE, this.getMethodCardViceNavInfoStyle);
  }

  /**
   * 获取更新场景卡片动效管理
   *
   */
  public getSlUpdateCardAnimCtrl(): WidgetAnimState | undefined {
    return this.slUpdateCardAnimCtrl;
  };

  /**
   * 获取切换场景卡片动效管理
   *
   */
  public getSlToggleCardAnimCtrl(): WidgetAnimState | undefined {
    return this.slToggleCardAnimCtrl;
  };

  /**
   * 获取卡片根布局动效管理
   *
   */
  public getSlRootCardAnimCtrl(): WidgetAnimState | undefined {
    return this.slRootCardAnimCtrl;
  };

  /**
   * 设置沉浸卡片背景色
   *
   */
  public setBackgroundColor(color: ResourceColor): SlCardStaticState {
    if (this.cardBackgroundColor !== color) {
      this.cardBackgroundColor = color;
      this.notifyStateChange(CardStaticStateType.BACKGROUND_COLOR);
    }
    return this;
  }

  /**
   * 获取沉浸卡片背景色
   *
   */
  public getBackgroundColor(): ResourceColor | undefined {
    return this.cardBackgroundColor;
  }

  /**
   * 设置沉浸卡片提亮参数
   *
   */
  public setBrightness(options: BrightnessOptions): SlCardStaticState {
    if (this.brightnessOptions !== options) {
      this.brightnessOptions = options;
      this.notifyStateChange(CardStaticStateType.BRIGHTNESS);
    }
    return this;
  }

  /**
   * 获取沉浸卡片提亮参数
   *
   */
  public getBrightness(): BrightnessOptions | undefined {
    return this.brightnessOptions;
  }

  /**
   * 设置三方卡片标题文本样式
   *
   */
  public setOtherCardTitleTextStyle(style: ImmersiveTextStyle): SlCardStaticState {
    if (this.otherCardTitleTextStyle !== style) {
      this.otherCardTitleTextStyle = style;
      this.notifyStateChange(CardStaticStateType.OTHER_CARD_TITLE_TEXT_STYLE);
    }
    return this;
  }

  /**
   * 获取三方卡片标题文本样式
   *
   */
  public getOtherCardTitleTextStyle(): ImmersiveTextStyle | undefined {
    return this.otherCardTitleTextStyle;
  }

  /**
   * 设置三方卡片副文本样式
   *
   */
  public setOtherCardRichTextStyle(style: ImmersiveTextStyle): SlCardStaticState {
    if (this.otherCardRichTextStyle !== style) {
      this.otherCardRichTextStyle = style;
      this.notifyStateChange(CardStaticStateType.OTHER_CARD_RICH_TEXT_STYLE);
    }
    return this;
  }

  /**
   * 获取三方卡片副文本样式
   *
   */
  public getOtherCardRichTextStyle(): ImmersiveTextStyle | undefined {
    return this.otherCardRichTextStyle;
  }

  /**
   * 设置导航卡片主要导航文本样式
   *
   */
  public setCardMainNavInfoStyle(style: ImmersiveTextStyle): SlCardStaticState {
    if (this.cardMainNavInfoStyle !== style) {
      this.cardMainNavInfoStyle = style;
      this.notifyStateChange(CardStaticStateType.CARD_MAIN_NAV_INFO_STYLE);
    }
    return this;
  }

  /**
   * 获取导航卡片主要导航文本样式
   *
   */
  public getCardMainNavInfoStyle(): ImmersiveTextStyle | undefined {
    return this.cardMainNavInfoStyle;
  }

  /**
   * 设置导航卡片次要导航文本样式
   *
   */
  public setCardViceNavInfoStyle(style: ImmersiveTextStyle): SlCardStaticState {
    if (this.cardViceNavInfoStyle !== style) {
      this.cardViceNavInfoStyle = style;
      this.notifyStateChange(CardStaticStateType.CARD_VICE_NAV_INFO_STYLE);
    }
    return this;
  }

  /**
   * 获取导航卡片次要导航字体大小
   *
   */
  public getCardViceNavInfoStyle(): ImmersiveTextStyle | undefined {
    return this.cardViceNavInfoStyle;
  }

}
