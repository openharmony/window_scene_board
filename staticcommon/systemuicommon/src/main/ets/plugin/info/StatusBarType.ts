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

/**
 * 状态栏类型
 *
 * @since 2022-11-16
 */
export class StatusBarType {
  /**
   * 用于过滤主类型
   */
  private static readonly TYPE_MAIN: number = 0xff;

  /**
   * 主类型，PC状态栏，默认白色
   */
  public static readonly TYPE_MAIN_PC_WHITE: number = 0x01;

  /**
   * 主类型，PC状态栏，默认黑色
   */
  public static readonly TYPE_MAIN_PC_BLACK: number = 0x0400;

  /**
   * 主类型，mac风格状态栏
   */
  public static readonly TYPE_MAIN_MAC_STATUS_BAR: number = 0x0080;

  /**
   * 主类型，window类型状态栏
   */
  public static readonly TYPE_MAIN_WINDOW_STATUS_BAR: number = 0x0800;

  /**
   * 主类型，phone，桌面状态栏
   */
  public static readonly TYPE_MAIN_PHONE_LAUNCHER: number = 0x02;

  /**
   * 主类型，phone，下拉面板状态栏
   */
  public static readonly TYPE_MAIN_PHONE_DROPDOWN: number = 0x04;

  /**
   * 主类型，phone，下拉面板状态栏
   */
  static readonly TYPE_MAIN_PHONE_DROPDOWN_SWITCH: number = 0x06;

  /**
   * 主类型，phone，锁屏状态栏
   */
  public static readonly TYPE_MAIN_PHONE_KEYGUARD: number = 0x08;

  /**
   * 属性类型，phone，状态栏下沉
   */
  public static readonly TYPE_ATTR_PHONE_PULL: number = 0x0100;

  /**
   * 属性类型，phone，单手模式
   */
  public static readonly TYPE_ATTR_PHONE_SINGLE: number = 0x0200;

  /**
   * 是否为PC状态栏，白色
   *
   * @param statusBarType 状态栏类型
   * @return true PC状态栏
   */
  static isPc(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_MAIN_PC_WHITE) !== 0;
  }

  /**
   * 是否为PC状态栏，黑色
   *
   * @param statusBarType 状态栏类型
   * @return true PC状态栏
   */
  static isPcBlack(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_MAIN_PC_BLACK) !== 0;
  }

  /**
   * 是否为mac风格状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true PC状态栏
   */

  static isMacStyle(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_MAIN_MAC_STATUS_BAR) !== 0;
  }

  /**
   * 是否为window风格状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true PC状态栏
   */
  static isWindowStyle(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR) !== 0;
  }

  /**
   * 是否为桌面状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true 桌面状态栏
   */
  static isLauncher(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_MAIN_PHONE_LAUNCHER) !== 0;
  }

  /**
   * 是否为下拉面板状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true 下拉面板状态栏
   */
  static isDropdown(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_MAIN_PHONE_DROPDOWN) !== 0;
  }

  /**
   * 是否为锁屏状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true 锁屏状态栏
   */
  static isKeyguard(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_MAIN_PHONE_KEYGUARD) !== 0;
  }

  /**
   * 是否为下沉状态栏
   *
   * @param statusBarType 状态栏类型
   * @return true 下沉状态栏
   */
  static hasPull(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_ATTR_PHONE_PULL) !== 0;
  }

  /**
   * 是否为单手模式
   *
   * @param statusBarType 状态栏类型
   * @return true 单手模式状态栏
   */
  static hasSingle(statusBarType: number): boolean {
    return (statusBarType & StatusBarType.TYPE_ATTR_PHONE_SINGLE) !== 0;
  }

  /**
   * 获取主类型
   *
   * @param sbType 复合类型
   * @return 主类型
   */
  static getMainType(sbType: number): number {
    return sbType & StatusBarType.TYPE_MAIN;
  }
}