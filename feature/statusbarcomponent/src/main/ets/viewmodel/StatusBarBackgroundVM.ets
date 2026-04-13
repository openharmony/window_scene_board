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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { StatusBarTint } from '../common/StatusBarTint';
import { BackgroundLinearGradient, LinearGradientType } from './BackgroundLinearGradient';

const TAG = 'StatusBarBackgroundVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface ARGBColor {
  alpha: string;
  red: number;
  green: number;
  blue: number;
}

/**
 * 状态栏背景vm
 */
export class StatusBarBackgroundVM {
  private backgroundLinearGradient: BackgroundLinearGradient = new BackgroundLinearGradient();
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private contentColor: string = StatusBarTint.CONTENT_COLOR_WHITE;
  private enableLinearGradient: boolean = true;
  private bgColors: string[] = [];

  /**
   * 初始化状态栏背景vm
   */
  public init(): void {
    log.showInfo('init');
    this.refreshLinearGradientType();
  }

  /**
   * 去初始化状态栏背景vm
   */
  public unInit(): void {
    log.showInfo('unInit');
    this.eventMgr.offAll();
  }

  /**
   * 获取背景渐变色对象
   *
   * @returns 背景渐变色对象
   */
  public getBackgroundLinearGradient(): BackgroundLinearGradient {
    return this.backgroundLinearGradient;
  }

  private refreshLinearGradientFlag(flag: boolean): boolean {
    if (this.enableLinearGradient === flag) {
      return false;
    }
    log.showInfo(`linnear gradient flag change from ${this.enableLinearGradient} to ${flag}.`);
    this.enableLinearGradient = flag;
    return true;
  }

  /**
   * 响应渐变色标记变化处理
   *
   * @param 变化后的标记
   */
  public onLinearGradientFlagChange(flag: boolean): void {
    const isRefreshLinearGradientFlag :boolean = this.refreshLinearGradientFlag(flag);
    if (isRefreshLinearGradientFlag) {
      this.refreshLinearGradientType();
    }
  }

  /**
   * 响应渐变色标记和背景色同时变化
   *
   * @param  flag变化后的标记
   * @param  bgColor变化后的背景色
   */
  public onLinearGradientFlagAndeBgColorChange(flag: boolean, bgColor: string): void {
    const bgColors: string[] = [bgColor];
    const isRefreshLinearGradientFlag: boolean = this.refreshLinearGradientFlag(flag);
    const isRefreshBackgroundColor: boolean = this.refreshBackgroundColor(bgColors);
    if (isRefreshLinearGradientFlag || isRefreshBackgroundColor) {
      this.refreshLinearGradientType();
    }
  }

  /**
   * 响应状态栏内容颜色变化处理
   *
   * @param contentColor 变化后的状态栏内容颜色
   */
  public onContentColorChange(contentColor: string) {
    if (this.contentColor === contentColor) {
      return;
    }
    log.showInfo(`content color change from ${this.contentColor} to ${contentColor}.`);
    this.contentColor = contentColor;
    this.refreshLinearGradientType();
  }

  private refreshBackgroundColor(bgColors: string[]): boolean {
    const color: string | undefined =
      bgColors.find(bgColor => bgColor !== null && bgColor !== undefined && bgColor.length > 0);
    if (color === undefined) {
      log.showDebug('can not find valid color');
      return false;
    }

    if (this.isEqualsArr(this.bgColors, bgColors)) {
      log.showDebug('backgroud color is equal.');
      return false;
    }
    log.showInfo(`background color change from ${this.bgColors} to ${bgColors}.`);
    this.bgColors = bgColors;
    return true;
  }

  /**
   * 响应状态栏背景颜色变化处理
   *
   * @param bgColors 变化后的状态栏背景颜色
   */
  public onBackgroundColorChange(bgColors: string[]): void {
    const isRefreshBackgroundColor: boolean = this.refreshBackgroundColor(bgColors);
    if (isRefreshBackgroundColor) {
      this.refreshLinearGradientType();
    }
  }

  /**
   * 数组是否相同，即两个数组中包含相同的元素，不保障顺序。
   *
   * @param oldArr 旧数组
   * @param newArr 新数组
   * @returns 相同返回真，否则返回假
   */
  private isEqualsArr(oldArr: string[], newArr: string[]): boolean {
    if (oldArr.length !== newArr.length) {
      return false;
    }
    return oldArr.every((item) => newArr.includes(item));
  }

  /**
   * 通过argb颜色字符串获取a、r、g、b数值
   *
   * @param color argb颜色字符串
   * @returns 透明度、红色、绿色和蓝色数值
   */
  private getColorValue(color: string): ARGBColor {
    let colorValue: ARGBColor;
    const colorStr = color.substring(1);
    if (colorStr.length === 6) {
      colorValue = {
        alpha: 'FF',
        red: parseInt(colorStr.substring(0, 2), 16),
        green: parseInt(colorStr.substring(2, 4), 16),
        blue: parseInt(colorStr.substring(4, 6), 16),
      };
    } else {
      colorValue = {
        alpha: colorStr.substring(0, 2),
        red: parseInt(colorStr.substring(2, 4), 16),
        green: parseInt(colorStr.substring(4, 6), 16),
        blue: parseInt(colorStr.substring(6, 8), 16),
      };
    }
    return colorValue;
  }

  /**
   * 是否颜色为透明色
   *
   * @param color argb颜色字符串
   * @returns 是否为透明色，透明度为零
   */
  private isTransparentColor(color: string): boolean {
    const argbColor: ARGBColor = this.getColorValue(color);
    if (argbColor.alpha === '00' || argbColor.alpha === '0') {
      return true;
    }

    return false;
  }

  /**
   * 是否所有的背景色都为透明色
   *
   * @param bgColors 背景色数组
   * @returns 是否为都为透明色
   */
  private isBgAllTransparentColors(bgColors: string[]): boolean {
    const color: string | undefined = bgColors.find(bgColor =>!this.isTransparentColor(bgColor));
    if (color !== undefined) {
      return false;
    }
    return true;
  }

  /**
   * 通过argb颜色字符串获取a、r、g、b数值
   *
   * @param color argb颜色字符串
   * @returns 透明度、红色、绿色和蓝色数值
   */
  private getLinearGradientType(): LinearGradientType {
    let linearGradientType: LinearGradientType = LinearGradientType.NONE;
    if (!this.isBgAllTransparentColors(this.bgColors)) {
      log.showDebug(`not all background colors transparent color(${this.bgColors}).`);
      return linearGradientType;
    }

    if (!this.enableLinearGradient) {
      log.showDebug(`linear gradient flag is ${this.enableLinearGradient}.`);
      return linearGradientType;
    }

    if (this.contentColor === '') {
      log.showInfo('content color is empty.');
      return linearGradientType;
    }

    const argbColor: ARGBColor = this.getColorValue(this.contentColor);
    if (argbColor.red === 255 && argbColor.green === 255 && argbColor.blue === 255) {
      linearGradientType = LinearGradientType.BLACK;
    }
    if (argbColor.red === 0 && argbColor.green === 0 && argbColor.blue === 0) {
      linearGradientType = LinearGradientType.WHITE;
    }

    log.showDebug(`linear gradient type is ${linearGradientType}`);
    return linearGradientType;
  }


  /**
   * 刷新当前渐变色类型
   */
  private refreshLinearGradientType() {
    const linearGradientType: LinearGradientType = this.getLinearGradientType();
    const lastLinearGradientType: LinearGradientType = this.backgroundLinearGradient.getLinearGradientType();
    if (lastLinearGradientType === linearGradientType) {
      return;
    }
    this.backgroundLinearGradient.setLinearGradientType(linearGradientType);
    log.showInfo(`refresh linear gradient type from ${lastLinearGradientType} to ${linearGradientType}`);
    return;
  }
}

let statusBarBackgroundVM = SingletonHelper.getInstance(StatusBarBackgroundVM, TAG);

export default statusBarBackgroundVM;
