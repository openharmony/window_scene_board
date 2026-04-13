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

import { curves } from '@kit.ArkUI';
import { ClockComFamily } from '../../common/WidgetParam';

export class Constants {
  /**
   * 浅色的背景色值
   */
  public static readonly BACKGROUND_LIGHT_COLOR: string = 'rgba(255, 255, 255, 0.1)';

  /**
   * 深色的背景色值
   */
  public static readonly BACKGROUND_DARK_COLOR: string = 'rgba(0, 0, 0, 0.1)';

  /**
   * 二级菜单浅色背景值
   */
  public static readonly SECONDARY_SELECTED_BACKGROUND_LIGHT: string = 'rgba(255, 255, 255, 0.1)';

  public static readonly LAYOUTBTN_SELECTED_BACKGROUND_LIGHT: string = 'rgba(255, 255, 255, 0.05)';

  /**
   * 二级菜单深色背景值
   */
 public static readonly SECONDARY_SELECTED_BACKGROUND_DARK: string = 'rgba(0, 0, 0, 0.05)';

  /**
   * 二级菜单描边浅色值
   */
 public static readonly SECONDARY_BORDER_LIGHT: string = 'rgba(255, 255, 255, 0.6)';

  /**
   * 二级菜单描边深色值
   */
 public static readonly SECONDARY_BORDER_DARK: string = 'rgba(0, 0, 0, 0.4)';

  /**
   * 色板第一个填充浅色值
   */
 public static readonly FIRST_COLOR_BUTTON_LIGHT: string = 'rgba(255, 255, 255, 0.6)';

  /**
   * 色板第一个填充深色值
   */
 public static readonly FIRST_COLOR_BUTTON_DARK: string = 'rgba(0, 0, 0, 0.2)';

  /**
   * 编辑面板阴影颜色
   */
 public static readonly PANE_SHADOW_COLOR: string = 'rgba(0, 0, 0, 0.1)';

  /**
   * 面板拖动条颜色
   */
 public static readonly SCROLL_BAR_COLOR: string = 'rgba(255, 255, 255, 0.4)';

  /**
   * 亮度变化速率
   */
 public static readonly BRIGHTNESS_RATE: number = 0.4;

  /**
   * 提亮程度
   */
 public static readonly BRIGHTNESS_DEGREE: number = 0.2;

  /**
   * BLENDMODE_NONE
   */
 public static readonly BLENDMODE_NONE: number = 0;

  /**
   * BLENDMODE_SRC_IN
   */
 public static readonly BLENDMODE_SRC_IN: number = 6;

  /**
   * BLENDMODE_SRC_OVER
   */
 public static readonly BLENDMODE_SRC_OVER: number = 4;

 public static readonly BLUR_RADIUS: number = 60;

 public static readonly SHADOW_RADIUS: number = 100;

 public static readonly SHADOW_OFFSETY: number = 10;

 public static readonly FLOAT_BTN_SHADOW_OFFSETY: number = 5;

 public static readonly COLOR_BTN_BRIGHTNESS = 1.05;

 public static readonly COLOR_BTN_ALPHA: string = '0.85';

 public static readonly MULTI_CLOCK_ALPHA: string = '0.65';

 public static readonly EDIT_CUBIC_CURVE: string | ICurve = curves.cubicBezierCurve(0.4, 0.0, 0.4, 1.0);
 public static readonly EDIT_INTERPOLATE_CURVE: string | ICurve = curves.interpolatingSpring(0, 1, 228, 26);
  public static readonly FONT_IMAGE_RESOURCES: Resource[] = [
    $r('app.media.ic_number_01'),
    $r('app.media.ic_number_02'),
    $r('app.media.ic_number_03'),
    $r('app.media.ic_number_04'),
    $r('app.media.ic_number_05'),
    $r('app.media.ic_number_06'),
    $r('app.media.ic_number_07'),
    $r('app.media.ic_number_08'),
  ];

  public static readonly FONT_IMAGE_RESOURCES_UD: Resource[] = [
    $r('app.media.ic_number_01_ud'),
    $r('app.media.ic_number_01'),
    $r('app.media.ic_number_02'),
    $r('app.media.ic_number_03'),
    $r('app.media.ic_number_04'),
    $r('app.media.ic_number_05'),
    $r('app.media.ic_number_06'),
    $r('app.media.ic_number_07'),
  ];

  public static readonly FONT_FAMILY: ClockComFamily[] = [
    ClockComFamily.HARMONY_CLOCK_01,
    ClockComFamily.HARMONY_CLOCK_02,
    ClockComFamily.HARMONY_CLOCK_05,
    ClockComFamily.HARMONY_CLOCK_06,
    ClockComFamily.HARMONY_CLOCK_07,
    ClockComFamily.HARMONY_CLOCK_03,
    ClockComFamily.HARMONY_CLOCK_04,
    ClockComFamily.HARMONY_CLOCK_08,
  ];

  public static readonly FONT_FAMILY_UD: ClockComFamily[] = [
    ClockComFamily.HARMONY_CLOCK_ULT_2_4,
    ClockComFamily.HARMONY_CLOCK_01,
    ClockComFamily.HARMONY_CLOCK_02,
    ClockComFamily.HARMONY_CLOCK_05,
    ClockComFamily.HARMONY_CLOCK_06,
    ClockComFamily.HARMONY_CLOCK_07,
    ClockComFamily.HARMONY_CLOCK_03,
    ClockComFamily.HARMONY_CLOCK_04,
  ];
}

// 锁屏编辑时钟样式选择面板类型
export enum ClockLayoutTab {
  LAYOUT_TAB_CLOCK = 0, // 数字时钟
}

// 锁屏编辑选择面板类型
export enum EditToolType {
  None = 0,
  Color = 1,
  Font = 2,
  Layout = 3,
  More = 4,
}

// 签名样式选择面板类型，艺术签名与合体字
export enum SignatureStyleTab {
  TAB_COMPOUND,
  TAB_ART_SIGN,
}

// 锁屏编辑面板位置，分为下、左、右、上
export enum EditPanelPos {
  Bottom = 0,
  Left = 1,
  Right = 2,
  Top = 3,
}