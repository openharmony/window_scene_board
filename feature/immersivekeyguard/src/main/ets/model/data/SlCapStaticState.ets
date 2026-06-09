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
  CapStaticStateType,
  SlMainStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { ImmersiveAnimKey } from '../../common/anim/ImmersiveAnimConstants';
import { ANIM_STATE_MAP } from '../../common/anim/ImmersiveAnimParam';
import { CapsulePositionType } from '../../common/ImmersiveConstants';
import { ImmersiveTextStyle } from '@ohos/systemuicommon/Index';

/**
 * 锁屏组件，沉浸胶囊组件静态状态管理
 *
 */
export class SlCapStaticState extends WidgetStaticState<CapStaticStateType> {
  /**
   * 沉浸胶囊内容胶囊动效状态
   */
  private slContentCapAnimCtrl: WidgetAnimState | undefined = ANIM_STATE_MAP.get(CapsulePositionType.TYPE_CONTENT);
  /**
   * 沉浸胶囊阴影胶囊动效状态
   */
  private slShadowCapAnimCtrl: WidgetAnimState | undefined = ANIM_STATE_MAP.get(CapsulePositionType.TYPE_SHADOW);
  /**
   * 沉浸胶囊根布局动效状态
   */
  private slRootCapAnimCtrl: WidgetAnimState | undefined = ANIM_STATE_MAP.get(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT);
  /**
   * 背景色
   */
  private capBackgroundColor?: ResourceColor;
  /**
   * 提亮参数
   */
  private brightnessOptions?: BrightnessOptions;
  /**
   * 主文本样式
   */
  private capMainTextStyle?: ImmersiveTextStyle;
  /**
   * 副文本样式
   */
  private capSecondaryTextStyle?: ImmersiveTextStyle;


  constructor() {
    super(SlMainStateType.SL_CAP_WG_STATIC_STATE);
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initSetMethods(): void {
    this.setMethods.set(CapStaticStateType.BACKGROUND_COLOR, this.setMethodBackgroundColor);
    this.setMethods.set(CapStaticStateType.BRIGHTNESS, this.setMethodBrightness);
    this.setMethods.set(CapStaticStateType.CAPSULE_MAIN_TEXT_STYLE, this.setMethodCapMainTextStyle);
    this.setMethods.set(CapStaticStateType.CAPSULE_SECONDARY_TEXT_STYLE, this.setMethodCapSecondaryTextStyle);
  }

  private setMethodBackgroundColor(st: SlCapStaticState, value: ResourceColor): void {
    st.setBackgroundColor(value);
  }

  private setMethodBrightness(st: SlCapStaticState, value: BrightnessOptions): void {
    st.setBrightness(value);
  }

  private setMethodCapMainTextStyle(st: SlCapStaticState, value: ImmersiveTextStyle): void {
    st.setCapMainTextStyle(value);
  }

  private setMethodCapSecondaryTextStyle(st: SlCapStaticState, value: ImmersiveTextStyle): void {
    st.setCapSecondaryTextStyle(value);
  }

  private getMethodSlContentCapAnimCtrl(st: SlCapStaticState): WidgetAnimState | undefined {
    return st.getSlContentCapAnimCtrl();
  }

  private getMethodSlShadowCapAnimCtrl(st: SlCapStaticState): WidgetAnimState | undefined {
    return st.getSlShadowCapAnimCtrl();
  }

  private getMethodSlRootCapAnimCtrl(st: SlCapStaticState): WidgetAnimState | undefined {
    return st.getSlRootCapAnimCtrl();
  }

  private getMethodBackgroundColor(st: SlCapStaticState): ResourceColor | undefined {
    return st.getBackgroundColor();
  }

  private getMethodBrightness(st: SlCapStaticState): BrightnessOptions | undefined {
    return st.getBrightness();
  }

  private getMethodCapMainTextStyle(st: SlCapStaticState): ImmersiveTextStyle | undefined {
    return st.getCapMainTextStyle();
  }

  private getMethodCapSecondaryTextStyle(st: SlCapStaticState): ImmersiveTextStyle | undefined {
    return st.getCapSecondaryTextStyle();
  }

  /**
   * 复写 WidgetStaticState
   *
   */
  protected initGetMethods(): void {
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlContentCapAnimCtrl);
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlShadowCapAnimCtrl);
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlRootCapAnimCtrl);
    this.getMethods.set(CapStaticStateType.BACKGROUND_COLOR, this.getMethodBackgroundColor);
    this.getMethods.set(CapStaticStateType.BRIGHTNESS, this.getMethodBrightness);
    this.getMethods.set(CapStaticStateType.CAPSULE_MAIN_TEXT_STYLE, this.getMethodCapMainTextStyle);
    this.getMethods.set(CapStaticStateType.CAPSULE_SECONDARY_TEXT_STYLE, this.getMethodCapSecondaryTextStyle);

  }

  /**
   * 获取内容胶囊动效管理
   *
   */
  public getSlContentCapAnimCtrl(): WidgetAnimState | undefined {
    return this.slContentCapAnimCtrl;
  };

  /**
   *  获取阴影胶囊动效管理
   *
   */
  public getSlShadowCapAnimCtrl(): WidgetAnimState | undefined {
    return this.slShadowCapAnimCtrl;
  };

  /**
   * 获取沉浸胶囊根布局动效管理
   *
   */
  public getSlRootCapAnimCtrl(): WidgetAnimState | undefined {
    return this.slRootCapAnimCtrl;
  };

  /**
   * 设置沉浸胶囊背景色
   *
   */
  public setBackgroundColor(color: ResourceColor): SlCapStaticState {
    if (this.capBackgroundColor !== color) {
      this.capBackgroundColor = color;
      this.notifyStateChange(CapStaticStateType.BACKGROUND_COLOR);
    }
    return this;
  }

  /**
   * 获取沉浸胶囊背景色
   *
   */
  public getBackgroundColor(): ResourceColor | undefined {
    return this.capBackgroundColor;
  }

  /**
   * 设置沉浸胶囊提亮参数
   *
   */
  public setBrightness(options: BrightnessOptions): SlCapStaticState {
    if (this.brightnessOptions !== options) {
      this.brightnessOptions = options;
      this.notifyStateChange(CapStaticStateType.BRIGHTNESS);
    }
    return this;
  }

  /**
   * 获取沉浸胶囊提亮参数
   *
   */
  public getBrightness(): BrightnessOptions | undefined {
    return this.brightnessOptions;
  }

  /**
   * 设置主文本字体样式
   *
   */
  public setCapMainTextStyle(style: ImmersiveTextStyle): SlCapStaticState {
    if (this.capMainTextStyle !== style) {
      this.capMainTextStyle = style;
      this.notifyStateChange(CapStaticStateType.CAPSULE_MAIN_TEXT_STYLE);
    }
    return this;
  }

  /**
   * 获取主文本字体样式
   *
   */
  public getCapMainTextStyle(): ImmersiveTextStyle | undefined {
    return this.capMainTextStyle;
  }

  /**
   * 设置副文本字体样式
   *
   */
  public setCapSecondaryTextStyle(style: ImmersiveTextStyle): SlCapStaticState {
    if (this.capSecondaryTextStyle !== style) {
      this.capSecondaryTextStyle = style;
      this.notifyStateChange(CapStaticStateType.CAPSULE_SECONDARY_TEXT_STYLE);
    }
    return this;
  }

  /**
   * 获取副文本字体样式
   *
   */
  public getCapSecondaryTextStyle(): ImmersiveTextStyle | undefined {
    return this.capSecondaryTextStyle;
  }

}