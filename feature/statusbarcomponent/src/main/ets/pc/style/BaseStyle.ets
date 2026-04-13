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
import { StyleType } from '../utils/enum';

export abstract class BaseStyle {
  /**
   * 样式唯一标识
   */
  protected key: string = '';
  /**
   * 标识样式类型
   */
  private type: StyleType = StyleType.PLUGIN;
  /**
   * 背景无状态栏时颜色
   */
  public bgColorNone: ResourceColor = '#00000000';
  /**
   * 背景选中时颜色
   */
  public bgColorSelected: ResourceColor = '#00000000';
  /**
   * 背景hover时颜色
   */
  public bgColorHovered: ResourceColor = '#00000000';
  /**
   * 图标是否需要背景
   */
  public isNeedIconBg: boolean = false;
  /**
   * 拷贝样式
   *
   * @param style 样式
   */
  public abstract copy(style: BaseStyle): void;

  /**
   * 根据状态栏类型初始化样式
   *
   * @param statusBarType 状态栏类型
   */
  public abstract init(statusBarType: number): void;

  /**
   * 状态栏切换回调
   *
   * @param statusBarType 状态栏类型
   */
  public abstract onStatusBarChange(statusBarType: number): void;

  /**
   * 获取key值
   *
   * @returns key值
   */
  public getKey(): string {
    return this.key;
  }

  /**
   * 获取样式类型
   *
   * @returns 样式类型
   */
  public getType(): number {
    return this.type;
  }

  /**
   * 当前背景颜色
   *
   * @param isSelected 是否选中
   * @param isHovered 是否hover
   */
  public getCurrentBgColor(isSelected: boolean, isHovered: boolean, isClicked: boolean): ResourceColor {
    if (!this.isNeedIconBg) {
      return this.bgColorNone;
    }
    // 优先选中状态
    if (isSelected || isClicked) {
      return this.bgColorSelected;
    }
    // 其次hover状态
    if (isHovered) {
      return this.bgColorHovered;
    }
    return this.bgColorNone;
  }

  /**
   * 根据壁纸深浅色改变图标背景色
   *
   * @param isSelected 是否选中
   * @param isHovered 是否hover
   */
  public getCurrentBgColorByContentColor(isWhite: boolean, isSelected: boolean, isHovered: boolean,
    isClicked: boolean): ResourceColor {
    if (!this.isNeedIconBg) {
      return this.bgColorNone;
    }
    // 优先选中状态
    if (isSelected || isClicked) {
      return isWhite ? '#26FFFFFF' : '#19000000';
    }
    // 其次hover状态
    if (isHovered) {
      return isWhite ? '#19FFFFFF' : '#0C000000';
    }
    return this.bgColorNone;
  }

  constructor(key: string, type: number) {
    this.key = key;
    this.type = type;
  }

  public updatePluginMargin(groupIconSpace: Length, slot: string, index: number,
    statusBarType: number, isFirst: boolean = false): void {}
}