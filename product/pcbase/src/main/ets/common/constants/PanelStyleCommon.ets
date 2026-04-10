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
import { ResourceManager } from '@ohos/frameworkwrapper';

/**
 * 状态栏通用样式
 */
export default class PcPanelStyleCommon {
  /**
   * 状态栏标题浅色模式颜色
   */
  public normalTitleLightTextColor: Resource = $r('sys.color.ohos_id_color_text_secondary');

  /**
   * 状态栏标题深色模式颜色
   */
  public normalTitleDarkTextColor: Resource = $r('sys.color.ohos_id_color_text_secondary_dark');
  /**
   * 浅色模式下提亮压暗基础颜色
   */
  public brightnessBaseLightColor: string = '#ffffffff';

  /**
   * 深色模式下提亮压暗基础颜色
   */
  public brightnessBaseDarkColor: string = '#ff000000';

  /**
   * 状态栏子标题浅色模式颜色
   */
  public normalSubTitleLightTextColor: Resource = $r('sys.color.ohos_id_color_text_tertiary');

  /**
   * 状态栏子标题深色模式颜色
   */
  public normalSubTitleDarkFontColor: Resource = $r('sys.color.ohos_id_color_text_tertiary_dark');

  /**
   * 状态栏列表正文文字浅色模式颜色(选中)
   */
  public normalSelectedListTextLightFontColor: string = '#0A59F7';

  /**
   * 状态栏列表正文文字深色模式颜色(选中)
   */
  public normalSelectedListTextDarkFontColor: string = '#ffffffff';

  /**
   * 状态栏列表正文文字浅色模式颜色
   */
  public normalListTextLightFontColor: Resource = $r('sys.color.ohos_id_color_secondary');

  /**
   * 状态栏列表正文文字深色模式颜色
   */
  public normalListTextDarkFontColor: Resource = $r('sys.color.ohos_id_color_secondary_dark');

  /**
   * 状态栏列表辅助文字浅色模式颜色
   */
  public normalListAssistedTextLightFontColor: Resource = $r('sys.color.ohos_id_color_text_tertiary');

  /**
   * 状态栏列表辅助文字深色模式颜色
   */
  public normalListAssistedTextDarkFontColor: Resource = $r('sys.color.ohos_id_color_text_tertiary_dark');

  /**
   * 状态栏列表左侧图标浅色模式颜色
   */
  public normalListLeftIconLightColor: Resource = $r('sys.color.ohos_id_color_secondary');

  /**
   * 状态栏列表左侧图标深色模式颜色
   */
  public normalListLeftIconDarkColor: Resource = $r('sys.color.ohos_id_color_secondary_dark');

  /**
   * 状态栏列表右侧侧图标浅色模式颜色(选中)
   */
  public normalSelectedListRightIconLightColor: string = '#0A59F7';

  /**
   * 状态栏列表右侧侧图标深色模式颜色(选中)
   */
  public normalSelectedListRightIconDarkColor: string = '#ccffffff';

  /**
   * 状态栏注脚区文本浅色模式颜色
   */
  public normalFootnoteTextLightFontColor: Resource = $r('sys.color.ohos_id_color_secondary');

  /**
   * 状态栏注脚区文本深色模式颜色
   */
  public normalFootnoteTextDarkFontColor: Resource = $r('sys.color.ohos_id_color_secondary_dark');

  /**
   * 状态栏分割线浅色模式颜色
   */
  public normalSeparatorLightColor: Resource = $r('sys.color.ohos_id_color_list_separator');

  /**
   * 状态栏分割线深色模式颜色
   */
  public normalSeparatorDarkColor: Resource = $r('sys.color.ohos_id_color_list_separator_dark');

  /**
   * 状态栏交互归一圆角(列表圆角)
   */
  public normalHoverRadiusColor: Resource = $r('sys.float.corner_radius_level6');

  /**
   * 状态栏窗口浅色模式模糊颜色
   */
  public normalWindowLightBlurBgColor: Resource = $r('sys.color.ohos_id_blur_style_component_regular_color');

  /**
   * 状态栏窗口深色模式模糊颜色
   */
  public normalWindowDarkBlurBgColor: Resource = $r('sys.color.ohos_id_blur_style_component_regular_color_dark');

  /**
   * 状态栏窗口内描边颜色
   */
  public normalWindowInsideBorderColor: string = '#33ffffff';

  /**
   * 状态栏窗口外描边浅色模式颜色
   */
  public normalWindowLightOutsideBorderColor: string = '#1A000000';

  /**
   * 状态栏窗口外描边深色模式颜色
   */
  public normalWindowDarkOutsideBorderColor: string = '#66000000';

  /**
   * 状态栏窗口边框宽度
   */
  public normalWindowBorderWidth: Resource = $r('app.float.normal_window_border_width');

  /**
   * 状态栏窗口圆角
   */
  public normalWindowBorderRadius: Resource = $r('sys.float.ohos_id_corner_radius_default_l');

  /**
   * 字体字号
   * 20fp
   */
  public fontSize20: Resource = $r('sys.float.ohos_id_text_size_headline8');

  /**
   * 字体字号
   * 16fp
   */
  public fontSize16: Resource = $r('sys.float.ohos_id_text_size_body1');

  /**
   * 字体字号
   * 14fp
   */
  public fontSize14: Resource = $r('sys.float.ohos_id_text_size_body2');

  /**
   * 字体粗细
   */
  public semibold: number = 600;

  /**
   * 阴影样式
   * defaultShadowM
   */
  public defaultShadowMLight: ShadowOptions = {
    color: $r('sys.color.ohos_id_shadow_default_md'),
    radius: $r('sys.float.ohos_id_shadow_default_md_shadow'),
    offsetX: $r('sys.float.ohos_id_shadow_default_md_offset_x'),
    offsetY: $r('sys.float.ohos_id_shadow_default_md_offset_y')
  };

  /**
   * 阴影样式
   * defaultShadowM
   */
  public defaultShadowMDark: ShadowOptions = {
    color: $r('sys.color.ohos_id_shadow_default_md_dark'),
    radius: $r('sys.float.ohos_id_shadow_default_md_shadow_dark'),
    offsetX: $r('sys.float.ohos_id_shadow_default_md_offset_x_dark'),
    offsetY: $r('sys.float.ohos_id_shadow_default_md_offset_y_dark')
  };

  constructor() {
  }
}