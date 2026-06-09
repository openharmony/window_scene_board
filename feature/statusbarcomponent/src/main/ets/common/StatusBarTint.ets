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

import Window from '@ohos.window';

/**
 * 状态栏沉浸式属性
 *
 * @since 2022-11-19
 */
export class StatusBarTint {
  /**
   * 状态栏内容颜色，白色
   */
  public static readonly CONTENT_COLOR_WHITE: string = '#FFFFFF';
  /**
   * 状态栏内容颜色，黑色
   */
  public static readonly CONTENT_COLOR_BLACK: string = '#000000';
  /**
   * 状态栏内容颜色，不透明白色
   */
  public static readonly CONTENT_COLOR_OPAQUE_WHITE: string = '#FFFFFFFF';
  /**
   * 状态栏内容颜色，不透明黑色
   */
  public static readonly CONTENT_COLOR_OPAQUE_BLACK: string = '#FF000000';
  /**
   * 状态栏背景颜色，透明
   */
  public static readonly BG_COLOR_TRANSPARENT: string = '#00000000';
  /**
   * 状态栏背景颜色，全白透明
   */
  public static readonly DEFAULT_BG_COLOR: string = '#00FFFFFF';
  /**
   * PC状态栏右侧区域背景颜色，浅色模式
   */
  public static readonly GROUP_BG_COLOR_LIGHT: string = '#66FAFAFA';
  /**
   * PC状态栏右侧区域背景颜色，深色模式
   */
  public static readonly GROUP_BG_COLOR_DARK: string = '#66666666';
  /**
   * PC状态栏左侧区域边框颜色
   */
  public static readonly GROUP_LEFT_BORDER_COLOR: string = '#FFFFFFFF';
  /**
   * PC状态栏右侧区域边框颜色
   */
  public static readonly GROUP_RIGHT_BORDER_COLOR: string = '#1A000000';
  /**
   * the pc status bar inner border color
   */
  public static readonly GROUP_INNER_BORDER_COLOR: string = '#33ffffff';
  /**
   * the pc status bar outer border color
   */
  public static readonly GROUP_OUTER_BORDER_COLOR: string = '#1a000000';
  /**
   * the pc status bar blur radius
   */
  public static readonly GROUP_BLUR_RADIUS: number = 0;
  /**
   * the pc status bar saturation
   */
  public static readonly GROUP_SATURATION: number = 1.4;
  /**
   * the pc status bar brightness
   */
  public static readonly GROUP_BRIGHTNESS: number = 1.0;
  /**
   * the pc status bar border width
   */
  public static readonly GROUP_BORDER_WIDTH: number = 0;
  /**
   * the pc status bar blur background color
   */
  public static readonly GROUP_BLUR_BG_COLOR: string = '#4dffffff';
  /**
   * 外屏状态栏背景渐变色
   */
  public static readonly OUTER_BG_GRADIENT_COLOR: Array<[string, number]> = [
    ['#33000000', 0.0], ['#1A000000', 0.6], ['#00000000', 1.0]
  ];
  /**
   * 状态栏内容颜色
   */
  public contentColor: string = '';
  /**
   * 状态栏背景颜色
   */
  public backgroundColor: string = '';
  /**
   * 区域范围
   */
  public region?: Window.Rect;
  /**
   * 状态栏背景色变化是否有动效
   */
  public enableAnimation: boolean = false;
}