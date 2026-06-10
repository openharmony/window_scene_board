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

import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  ListStaticStateType,
  SlMainStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { ImmersiveAnimKey } from '../../common/anim/ImmersiveAnimConstants';
import { ANIM_STATE_MAP } from '../../common/anim/ImmersiveAnimParam';
import { ImmersiveTextStyle } from '@ohos/systemuicommon/Index';

/**
 * 锁屏组件，通知列表组件静态状态管理
 *
 */
export class SlListStaticState extends WidgetStaticState<ListStaticStateType> {
  /**
   * 锁屏通知列表根布局动效状态
   */
  private slRootListAnimCtrl: WidgetAnimState | undefined = ANIM_STATE_MAP.get(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
  /**
   * 背景色
   */
  private listBackgroundColor?: ResourceColor;
  /**
   * 提亮参数
   */
  private brightnessOptions?: BrightnessOptions;
  /**
   * 锁屏通知主文本样式
   */
  private listMainTextStyle?: ImmersiveTextStyle;
  /**
   * 锁屏通知副文本字体大小
   */
  private listSecondaryTextStyle?: ImmersiveTextStyle;

  /**
   * 默认沉浸态场景是否需要隐藏实况通知数据
   */
  private isHideWhenDesktopToSL?: boolean;

  /**
   * 条目总高度
   */
  private itemHeightSum: number = 0;

  constructor() {
    super(SlMainStateType.SL_LIST_WG_STATIC_STATE);
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initSetMethods(): void {
    this.setMethods.set(ListStaticStateType.BACKGROUND_COLOR, this.setMethodBackgroundColor);
    this.setMethods.set(ListStaticStateType.BRIGHTNESS, this.setMethodBrightness);
    this.setMethods.set(ListStaticStateType.LIST_MAIN_TEXT_STYLE, this.setMethodListMainTextStyle);
    this.setMethods.set(ListStaticStateType.LIST_SECONDARY_TEXT_STYLE, this.setMethodListSecondaryTextStyle);
    this.setMethods.set(ListStaticStateType.NTF_LIST_HIDE_FLAG, this.setMethodListHideFlag);
    this.setMethods.set(ListStaticStateType.NTF_LIST_ITEM_HEIGHT_SUM, this.setMethodListHeightSum);
  }

  private setMethodBackgroundColor(st: SlListStaticState, value: ResourceColor): void {
    st.setBackgroundColor(value);
  }

  private setMethodBrightness(st: SlListStaticState, value: BrightnessOptions): void {
    st.setBrightness(value);
  }

  private setMethodListMainTextStyle(st: SlListStaticState, value: ImmersiveTextStyle): void {
    st.setListMainTextStyle(value);
  }

  private setMethodListSecondaryTextStyle(st: SlListStaticState, value: ImmersiveTextStyle): void {
    st.setListSecondaryTextStyle(value);
  }

  private setMethodListHideFlag(st: SlListStaticState, value: boolean): void {
    st.setListHideFlag(value);
  }

  private getMethodSlRootListAnimCtrl(st: SlListStaticState): WidgetAnimState | undefined {
    return st.getSlRootListAnimCtrl();
  }

  private getMethodBackgroundColor(st: SlListStaticState): ResourceColor | undefined {
    return st.getBackgroundColor();
  }

  private getMethodBrightness(st: SlListStaticState): BrightnessOptions | undefined {
    return st.getBrightness();
  }

  private getMethodListMainTextStyle(st: SlListStaticState): ImmersiveTextStyle | undefined {
    return st.getListMainTextStyle();
  }

  private getMethodListSecondaryTextStyle(st: SlListStaticState): ImmersiveTextStyle | undefined {
    return st.getListSecondaryTextStyle();
  }

  private getMethodListHideFlag(st: SlListStaticState): boolean | undefined {
    return st.getListHideFlag();
  }

  private getMethodListHeightSum(st: SlListStaticState): number {
    return st.getListHeightSum();
  }

  private setMethodListHeightSum(st: SlListStaticState, value: number): void {
    st.setListHeightSum(value);
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initGetMethods(): void {
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlRootListAnimCtrl);
    this.getMethods.set(ListStaticStateType.BACKGROUND_COLOR, this.getMethodBackgroundColor);
    this.getMethods.set(ListStaticStateType.BRIGHTNESS, this.getMethodBrightness);
    this.getMethods.set(ListStaticStateType.LIST_MAIN_TEXT_STYLE, this.getMethodListMainTextStyle);
    this.getMethods.set(ListStaticStateType.LIST_SECONDARY_TEXT_STYLE, this.getMethodListSecondaryTextStyle);
    this.getMethods.set(ListStaticStateType.NTF_LIST_HIDE_FLAG, this.getMethodListHideFlag);
    this.getMethods.set(ListStaticStateType.NTF_LIST_ITEM_HEIGHT_SUM, this.getMethodListHeightSum);
  }

  /**
   * 获取通知列表根布局动效管理
   *
   */
  public getSlRootListAnimCtrl(): WidgetAnimState | undefined {
    return this.slRootListAnimCtrl;
  };

  /**
   * 设置通知列表背景色
   *
   */
  public setBackgroundColor(color: ResourceColor): SlListStaticState {
    if (this.listBackgroundColor !== color) {
      this.listBackgroundColor = color;
      this.notifyStateChange(ListStaticStateType.BACKGROUND_COLOR);
    }
    return this;
  }

  /**
   * 获取通知列表背景色
   *
   */
  public getBackgroundColor(): ResourceColor | undefined {
    return this.listBackgroundColor;
  }

  /**
   * 设置通知列表提亮参数
   *
   */
  public setBrightness(options: BrightnessOptions): SlListStaticState {
    if (this.brightnessOptions !== options) {
      this.brightnessOptions = options;
      this.notifyStateChange(ListStaticStateType.BRIGHTNESS);
    }
    return this;
  }

  /**
   * 获取通知列表提亮参数
   *
   */
  public getBrightness(): BrightnessOptions | undefined {
    return this.brightnessOptions;
  }


  /**
   * 设置通知主文本样式
   *
   */
  public setListMainTextStyle(style: ImmersiveTextStyle): SlListStaticState {
    if (this.listMainTextStyle !== style) {
      this.listMainTextStyle = style;
      this.notifyStateChange(ListStaticStateType.LIST_MAIN_TEXT_STYLE);
    }
    return this;
  }

  /**
   * 获取通知主文本样式
   *
   */
  public getListMainTextStyle(): ImmersiveTextStyle | undefined {
    return this.listMainTextStyle;
  }

  /**
   * 设置通知副文本样式
   *
   */
  public setListSecondaryTextStyle(style: ImmersiveTextStyle): SlListStaticState {
    if (this.listSecondaryTextStyle !== style) {
      this.listSecondaryTextStyle = style;
      this.notifyStateChange(ListStaticStateType.LIST_SECONDARY_TEXT_STYLE);
    }
    return this;
  }

  /**
   * 获取通知副文本样式
   *
   */
  public getListSecondaryTextStyle(): ImmersiveTextStyle | undefined {
    return this.listSecondaryTextStyle;
  }

  public setListHideFlag(isHide?: boolean): SlListStaticState {
    if (this.isHideWhenDesktopToSL !== isHide) {
      this.isHideWhenDesktopToSL = isHide;
      this.notifyStateChange(ListStaticStateType.NTF_LIST_HIDE_FLAG);
    }
    return this;
  }

  public getListHideFlag(): boolean | undefined {
    return this.isHideWhenDesktopToSL;
  }

  public getListHeightSum(): number {
    return this.itemHeightSum;
  }

  public setListHeightSum(itemHeightSum: number): SlListStaticState {
    if (this.itemHeightSum !== itemHeightSum) {
      this.itemHeightSum = itemHeightSum;
      this.notifyStateChange(ListStaticStateType.NTF_LIST_ITEM_HEIGHT_SUM);
    }
    return this;
  }
}

