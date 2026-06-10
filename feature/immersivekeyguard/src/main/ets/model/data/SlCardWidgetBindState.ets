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

import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { CardWgBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

/**
 * 锁屏组件，沉浸卡片组件UI绑定状态
 *
 */
@Observed
export class SlCardWidgetBindState extends WidgetBindState<CardWgBindStateType> {
  /**
   * 背景色
   */
  @Track private cardBackgroundColor?: ResourceColor;
  /**
   * 提亮参数
   */
  @Track private brightnessOptions?: BrightnessOptions;
  /**
   * 背板透明度
   */
  @Track private bgAlpha?: number;
  /**
   * 预览图透明度
   */
  @Track private previewAlpha?: number;

  /**
   * 缩放参数
   */
  @Track private cardScale?: number;

  /**
   * 透明度
   */
  @Track private alpha?: number;

  /**
   * 沉浸实况堆叠布局的小卡是否收拢，true表示收拢，false表示展开
   */
  @Track private isCardFold?: boolean;
  /**
   * 卡片UIExtention加载Loading状态
   */
  @Track private uiExtentionLoadingState?: boolean;

  constructor() {
    super(SlMainStateType.SL_CARD_WG_BIND_STATE);
  }

  /**
   * 复写WidgetBindState
   *
   */
  protected initSetMethods(): void {
    super.initSetMethods();
    this.setMethods.set(CardWgBindStateType.BACKGROUND_COLOR, this.setMethodBackgroundColor);
    this.setMethods.set(CardWgBindStateType.BRIGHTNESS, this.setMethodBrightness);
    this.setMethods.set(CardWgBindStateType.BACKGROUND_ALPHA, this.setMethodBgAlpha);
    this.setMethods.set(CardWgBindStateType.PREVIEW_ALPHA, this.setMethodPreviewAlpha);
    this.setMethods.set(CardWgBindStateType.CARD_SCALE, this.setMethodScale);
    this.setMethods.set(CardWgBindStateType.CARD_ALPHA, this.setMethodAlpha);
    this.setMethods.set(CardWgBindStateType.IS_CARD_FOLD, this.setMethodIsCardFold);
    this.setMethods.set(CardWgBindStateType.UI_EXTENTION_LOADING_STATE, this.setMethodUiExtentionLoadState);
  }

  private setMethodBackgroundColor(st: SlCardWidgetBindState, value: ResourceColor): void {
    st.setBackgroundColor(value);
  }

  private setMethodBrightness(st: SlCardWidgetBindState, value: BrightnessOptions): void {
    st.setBrightness(value);
  }

  private setMethodBgAlpha(st: SlCardWidgetBindState, value: number): void {
    st.setBgAlpha(value);
  }

  private setMethodPreviewAlpha(st: SlCardWidgetBindState, value: number): void {
    st.setPreviewAlpha(value);
  }

  private setMethodScale(st: SlCardWidgetBindState, value: number): void {
    st.setScale(value);
  }

  private setMethodAlpha(st: SlCardWidgetBindState, value: number): void {
    st.setAlpha(value);
  }

  private setMethodIsCardFold(st: SlCardWidgetBindState, value: boolean): void {
    st.setIsCardFold(value);
  }

  private setMethodUiExtentionLoadState(st: SlCardWidgetBindState, value: boolean): void {
    st.setUiExtentionLoadState(value);
  }

  private getMethodBackgroundColor(st: SlCardWidgetBindState): ResourceColor | undefined {
    return st.getBackgroundColor();
  }

  private getMethodBrightness(st: SlCardWidgetBindState): BrightnessOptions | undefined {
    return st.getBrightness();
  }

  private getMethodBgAlpha(st: SlCardWidgetBindState): number | undefined {
    return st.getBgAlpha();
  }

  private getMethodPreviewAlpha(st: SlCardWidgetBindState): number | undefined {
    return st.getPreviewAlpha();
  }

  private getMethodScale(st: SlCardWidgetBindState): number | undefined {
    return st.getScale();
  }

  private getMethodAlpha(st: SlCardWidgetBindState): number | undefined {
    return st.getAlpha();
  }

  private getMethodIsCardFold(st: SlCardWidgetBindState): boolean | undefined {
    return st.getIsCardFold();
  }

  private getMethodUiExtentionLoadState(st: SlCardWidgetBindState): boolean | undefined {
    return st.getUiExtentionLoadState();
  }
  /**
   * 复写WidgetBindState
   *
   */
  protected initGetMethods(): void {
    super.initGetMethods();
    this.getMethods.set(CardWgBindStateType.BACKGROUND_COLOR, this.getMethodBackgroundColor);
    this.getMethods.set(CardWgBindStateType.BRIGHTNESS, this.getMethodBrightness);
    this.getMethods.set(CardWgBindStateType.BACKGROUND_ALPHA, this.getMethodBgAlpha);
    this.getMethods.set(CardWgBindStateType.PREVIEW_ALPHA, this.getMethodPreviewAlpha);
    this.getMethods.set(CardWgBindStateType.CARD_SCALE, this.getMethodScale);
    this.getMethods.set(CardWgBindStateType.CARD_ALPHA, this.getMethodAlpha);
    this.getMethods.set(CardWgBindStateType.IS_CARD_FOLD, this.getMethodIsCardFold);
    this.getMethods.set(CardWgBindStateType.UI_EXTENTION_LOADING_STATE, this.getMethodUiExtentionLoadState);
  }

  /**
   * 设置沉浸卡片背景色
   *
   */
  public setBackgroundColor(color: ResourceColor): SlCardWidgetBindState {
    if (this.cardBackgroundColor !== color) {
      this.cardBackgroundColor = color;
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
  public setBrightness(options: BrightnessOptions): SlCardWidgetBindState {
    if (this.brightnessOptions !== options) {
      this.brightnessOptions = options;
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
   * 设置沉浸卡片背板透明度
   *
   */
  public setBgAlpha(options: number): SlCardWidgetBindState {
    if (this.bgAlpha !== options) {
      this.bgAlpha = options;
    }
    return this;
  }

  /**
   * 获取沉浸卡片背板透明度
   *
   */
  public getBgAlpha(): number | undefined {
    return this.bgAlpha;
  }

  /**
   * 设置沉浸卡片预览图透明度
   *
   */
  public setPreviewAlpha(options: number): SlCardWidgetBindState {
    if (this.previewAlpha !== options) {
      this.previewAlpha = options;
    }
    return this;
  }

  /**
   * 获取沉浸卡片预览图透明度
   *
   */
  public getPreviewAlpha(): number | undefined {
    return this.previewAlpha;
  }

  /**
   * 设置沉浸卡片缩放参数
   *
   */
  public setScale(scale: number): SlCardWidgetBindState {
    if (this.cardScale !== scale) {
      this.cardScale = scale;
    }
    return this;
  }

  /**
   * 获取沉浸卡片提亮参数
   *
   */
  public getScale(): number | undefined {
    return this.cardScale;
  }

  /**
   * 设置沉浸卡片透明度参数
   *
   */
  public setAlpha(alpha: number): SlCardWidgetBindState {
    if (this.alpha !== alpha) {
      this.alpha = alpha;
    }
    return this;
  }

  /**
   * 获取沉浸卡片提亮参数
   *
   */
  public getAlpha(): number | undefined {
    return this.alpha;
  }

  /**
   * 设置沉浸卡片堆叠布局的小卡是否收拢的参数
   *
   */
  public setIsCardFold(isCardFold: boolean): SlCardWidgetBindState {
    if (this.isCardFold !== isCardFold) {
      this.isCardFold = isCardFold;
    }
    return this;
  }

  /**
   * 获取沉浸卡片堆叠布局的小卡是否收拢的参数
   *
   */
  public getIsCardFold(): boolean | undefined {
    return this.isCardFold;
  }

  /**
   * 设置卡片UIExtention加载是否完毕
   *
   */
  public setUiExtentionLoadState(isFinishLoad: boolean): SlCardWidgetBindState {
    if (this.uiExtentionLoadingState !== isFinishLoad) {
      this.uiExtentionLoadingState = isFinishLoad;
      this.notifyStateChange(CardWgBindStateType.UI_EXTENTION_LOADING_STATE);
    }
    return this;
  }

  /**
   * 获取卡片UIExtention加载是否完毕
   *
   */
  public getUiExtentionLoadState(): boolean | undefined {
    return this.uiExtentionLoadingState;
  }
}