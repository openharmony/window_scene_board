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
import { i18n } from '@kit.LocalizationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ConfigurationEvent } from '@ohos/frameworkwrapper';
import { EventListener, EvtBus } from '@ohos/frameworkwrapper';
import { AppStorageUtil } from '@ohos/basicutils';

const TAG: string = 'RTLUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * RTL语言工具类，用于判断当前是否是RTL语言
 */
export class RTLUtil {
  private static isLanguageRTL: boolean = false;
  private static languageChangeListener?: EventListener<ConfigurationEvent>;
  private static rtlChangeCallbacks: Function[] = [];

  private static init(): void {
    this.languageChangeListener = (event: ConfigurationEvent): void => this.updateRTL();
    EvtBus.on(ConfigurationEvent, this.languageChangeListener);
    this.updateRTL(true);
  }

  private static updateRTL(init?: boolean): void {
    if (init) {
      this.isLanguageRTL = this.getSystemRTL();
      AppStorageUtil.setOrCreate<boolean>('isSystemLanguageRTL', this.isLanguageRTL);
    }
    if (this.isLanguageRTL !== this.getSystemRTL()) {
      this.isLanguageRTL = this.getSystemRTL();
      AppStorageUtil.setOrCreate<boolean>('isSystemLanguageRTL', this.isLanguageRTL);
      this.rtlChangeCallbacks.forEach((callback) => {
        callback?.(this.isLanguageRTL);
      });
    }
  }

  /**
   * 注册RTL变更回调
   *
   * @param callback 回调函数
   */
  public static registerRtlChangeCallback(callback: Function): void {
    if (this.rtlChangeCallbacks.indexOf(callback) === -1) {
      this.rtlChangeCallbacks.push(callback);
    }
  }

  /**
   * 解除注册RTL变更回调
   *
   * @param callback 回调函数
   */
  public static unregisterRtlChangeCallback(callback: Function): void {
    let index: number = this.rtlChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.rtlChangeCallbacks.splice(index, 1);
    }
  }

  /**
   * 获取系统语言是否是RTL语言
   *
   * @returns 系统语言是否是RTL语言
   */
  public static getSystemRTL(): boolean {
    let systemLanguage: string = i18n.System.getSystemLanguage();
    let isRTL: boolean = i18n.isRTL(systemLanguage);
    log.showInfo(`systemLanguage: ${systemLanguage} isRTL:${isRTL}`);
    return isRTL;
  }

  /**
   * 当前是否是RTL语言
   *
   * @returns 当前是否是RTL语言
   */
  public static isRTL(): boolean {
    if (this.languageChangeListener == null) {
      this.init();
    }
    return this.isLanguageRTL;
  }

  /**
   * 根据是否是RTL语言, 来更新坐标点
   *
   * @param x 布局元素x坐标点值
   * @param screenWidth  屏幕宽度
   * @returns 返回RTL 修正后的x坐标点数据
   */
  public static getPositionByRTL(x: number, screenWidth: number): number {
    if (this.isRTL()) {
      return screenWidth - x;
    }
    return x;
  }

  /**
   *  根据RTL,修正 布局元素 列索引值
   *
   * @param column 布局元素所在的列
   * @param columnCount  当前桌面布局中， 一行共有多少列
   * @param colSpan  布局元素宽度,也就是占的列数目
   * @returns RTL 修正后, 布局元素在屏幕的列索引
   */
  public static getColumnByRTL(column: number, columnCount: number, colSpan: number): number {
    if (this.isRTL()) {
      return columnCount - colSpan - column;
    }
    return column;
  }

  public static getRTLRate(): number {
    return this.isRTL() ? -1 : 1;
  }

}
