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

import { ResUtils } from '@ohos/windowscene';
import PanelStyleCommon from '../constants/PanelStyleCommon';

export default class StatusBarPanelStyleManager {
  private styleCommon: PanelStyleCommon = new PanelStyleCommon();

  constructor() {
  }

  /**
   * 获取状态栏标题字体颜色
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalTitleColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalTitleDarkTextColor :
    this.styleCommon.normalTitleLightTextColor;
  }

  /**
   * 获取状态栏标题字号，24fp
   *
   * @returns 字体字号
   */
  getNormalTitleSize(): Length {
    return ResUtils.getNumberFromLength(this.styleCommon.fontSize20);
  }

  /**
   * 获取状态栏小标题字体颜色
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalSubTitleColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalSubTitleDarkFontColor :
    this.styleCommon.normalSubTitleLightTextColor;
  }

  /**
   * 获取状态栏小标题字号，14fp
   *
   * @returns 字体字号
   */
  getNormalSubTitleSize(): Length {
    return ResUtils.getNumberFromLength(this.styleCommon.fontSize14);
  }

  /**
   * 获取状态栏列表正文字体颜色(选中)
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalSelectedListTextColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalSelectedListTextDarkFontColor :
    this.styleCommon.normalSelectedListTextLightFontColor;
  }

  /**
   * 获取状态栏列表正文字体颜色
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalListTextColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalListTextDarkFontColor :
    this.styleCommon.normalListTextLightFontColor;
  }

  /**
   * 获取状态栏列表正文字号，16fp
   *
   * @returns 字体字号
   */
  getNormalListTextSize(): Length {
    return ResUtils.getNumberFromLength(this.styleCommon.fontSize16);
  }

  /**
   * 获取状态栏列表辅助文本字体颜色
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalListAssistedTextColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalListAssistedTextDarkFontColor :
    this.styleCommon.normalListAssistedTextLightFontColor;
  }

  /**
   * 获取状态栏列表辅助文本字号，14fp
   *
   * @returns 字体字号
   */
  getNormalListAssistedTextSize(): Length {
    return ResUtils.getNumberFromLength(this.styleCommon.fontSize14);
  }

  /**
   * 获取状态栏列表左侧图标颜色
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalLeftIconColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalListLeftIconDarkColor :
    this.styleCommon.normalListLeftIconLightColor;
  }

  /**
   * 获取状态栏列表右侧图标颜色(选中)
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalRightIconColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalSelectedListTextDarkFontColor :
    this.styleCommon.normalSelectedListRightIconLightColor;
  }

  /**
   * 获取状态栏注脚区文本字体颜色
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalFootnoteTextColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalFootnoteTextDarkFontColor :
    this.styleCommon.normalFootnoteTextLightFontColor;
  }

  /**
   * 获取状态栏注脚区文本字号，16fp
   *
   * @returns 字体字号
   */
  getNormalFootnoteTextSize(): Length {
    return ResUtils.getNumberFromLength(this.styleCommon.fontSize16);
  }

  /**
   * 获取状态栏分割线颜色
   *
   * @param isDark 是否是深色模式
   * @returns 字体颜色
   */
  getNormalSeparatorColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.normalSeparatorDarkColor :
    this.styleCommon.normalSeparatorLightColor;
  }

  /**
   * 获取状态栏交互归一圆角(列表圆角)
   *
   * @returns 状态栏列表外框圆角
   */
  getNormalHoverRadius(): Resource {
    return this.styleCommon.normalHoverRadiusColor;
  }

  /**
   * 获取状态栏提亮压暗基础颜色
   *
   * @returns
   */
  getBrightnessBaseColor(isDark: boolean): ResourceStr {
    return isDark ? this.styleCommon.brightnessBaseDarkColor : this.styleCommon.brightnessBaseLightColor;
  }

  /**
   * 获取深浅模式下defaultShadowM
   *
   * @param isDark
   * @returns 窗口阴影属性
   */
  public getDefaultShadowM(isDark: boolean): ShadowOptions {
    return isDark ? this.styleCommon.defaultShadowMDark : this.styleCommon.defaultShadowMLight;
  }

  /**
   * 获取窗口圆角
   *
   * @returns 窗口圆角
   */
  getWindowRadius(): Resource {
    return this.styleCommon.normalWindowBorderRadius;
  }

  getBorderWidth(): Resource {
    return this.styleCommon.normalWindowBorderWidth;
  }

  getInsideBorderColor(): string {
    return this.styleCommon.normalWindowInsideBorderColor;
  }

  getOutSideBorderColor(isDark: boolean): string {
    return isDark ? this.styleCommon.normalWindowDarkOutsideBorderColor :
    this.styleCommon.normalWindowLightOutsideBorderColor;
  }

  getBgBlurColor(isDark: boolean): Resource {
    return isDark ? this.styleCommon.normalWindowDarkBlurBgColor :
    this.styleCommon.normalWindowLightBlurBgColor;
  }
}

