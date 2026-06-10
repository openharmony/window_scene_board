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

export class FloatingBallStyle {
  public static readonly LENGTH4: number = 4;
  public static readonly LENGTH6: number = 6;
  public static readonly LENGTH8: number = 8;
  public static readonly LENGTH16: number = 16;
  /**
   * 内边距
   */
  public static readonly PADDING4: number = 4;
  /**
   * 图标宽(vp)
   */
  public static readonly ICON_WIDTH: number = 24;
  /**
   * 图标高(vp)
   */
  public static readonly ICON_HEIGHT: number = 24;
  /**
   * 悬浮球外层底板最大宽度(vp)
   */
  public static readonly OUTER_MAX_WIDTH: number = 98;
  /**
   * 悬浮球外层底板最小宽度(vp)
   */
  public static readonly OUTER_MIN_WIDTH: number = 70;
  /**
   * 悬浮球内底板最大宽度
   */
  public static readonly INNER_ROW_MAX_WIDTH: number = 90;
  /**
   * 悬浮球内底板最小宽度
   */
  public static readonly INNER_ROW_MIN_WIDTH: number = 62;
  /**
   * 悬浮球单行高度
   */
  public static readonly ROW_HEIGHT: number = 32;
  /**
   * 圆角半径大小
   */
  public static readonly RADIUS: number = 20;
  /**
   * Light模式背景色
   */
  public static readonly BACKGROUND_LIGHT: string = '#99C7C7CC';
  /**
   * Dark模式背景色
   */
  public static readonly BACKGROUND_DARK: string = '#9946484D';
  /**
   * 阴影颜色
   */
  public static readonly SHADOW_COLOR: string = '#4000001E';
  /**
   * 阴影半径
   */
  public static readonly SHADOW_RADIUS: number = 10;
  /**
   * 背景模糊半径
   */
  public static readonly BACKGROUND_EFFECT_RADIUS: number = 75;
  /**
   * 背景饱和度
   */
  public static readonly BACKGROUND_EFFECT_SATURATION: number = 1.3;
  /**
   * 背景亮度
   */
  public static readonly BACKGROUND_EFFECT_BRIGHTNESS: number = 1;
  /**
   * 背景模糊激活策略
   */
  public static readonly BACKGROUND_EFFECT_POLICY: number = 1;
  /**
   * 未被选择球透明度
   */
  public static readonly UN_SELECTED_OPACITY: number = 0.4;
  /**
   * 菜单宽度
   */
  public static readonly MENU_WIDTH: number = 190;
  /**
   * 黑色字体颜色
   */
  public static readonly FONT_BLACK: string = '#E5000000';
  /**
   * 白色字体颜色
   */
  public static readonly FONT_WHITE: string = '#E5FFFFFF';
  /**
   * 内容字体颜色(深色模式)
   */
  public static readonly CONTENT_FONT_WHITE: string = '#99FFFFFF';
  /**
   * 内容字体颜色(浅色模式)
   */
  public static readonly CONTENT_FONT_BLACK: string = '#99000000';
  /**
   * 纵向位置默认80vp
   */
  public static readonly DEFAULT_POSTION_Y: number = 80;
  /**
   * 透明度
   */
  public static readonly OPACITY: number = 0.4;
  public static readonly FONT_BODY_L: Resource = $r('sys.float.Body_L');
  public static readonly FONT_BODY_M: Resource = $r('sys.float.Body_M');
  public static readonly FONT_BODY_S: Resource = $r('sys.float.Body_S');
  public static readonly FONT_CAPTION_L: Resource = $r('sys.float.Caption_L');
  public static readonly FONT_CAPTION_M: Resource = $r('sys.float.Caption_M');
  public static readonly FONT_CAPTION_S: Resource = $r('sys.float.Caption_S');
  public static readonly FONT_COLOR_PRIMARY: Resource = $r('sys.color.font_primary');
  public static readonly FONT_COLOR_SECONDARY: Resource = $r('sys.color.font_secondary');
  public static readonly BG_COLOR: Resource = $r('sys.color.background_primary');
}