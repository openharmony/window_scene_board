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
 * 组件位置，常量
 */
import { PluginSlot } from '@ohos/frameworkwrapper';

export class PluginPosition {
  /**
   * 组件位置，左侧
   */
  public static readonly POSITION_LEFT: string = 'left';

  /**
   * 组件位置，系统图标右侧区域
   */
  public static readonly POSITION_RIGHT: string = 'right';

  /**
   * 组件位置，系统图标左侧区域（跨孔场景）
   */
  public static readonly POSITION_SYSTEM_LEFT: string = 'system_left';

  /**
   * 组件位置，中间区域（实况2.0场景）
   */
  public static readonly POSITION_MIDDLE: string = 'middle';

}

/**
 * 状态栏系统图标默认宽度（统一用该图标最大宽度）不一定等于该图标在状态栏显示时的实际宽度
 * 该宽度用于初始化图标默认宽度
 */
export const DEFAULT_ICON_WIDTH_MAP: Map<string, number> = new Map([
  [PluginSlot.SLOT_STATUS_BATTERY, 28.75], // 电池图标宽度，
  [PluginSlot.SLOT_STATUS_SIGNAL, 47], // 双卡时图标宽度
  [PluginSlot.SLOT_STATUS_WIFI, 18.25],
  [PluginSlot.SLOT_STATUS_HOT_SPOT, 16.5],
  [PluginSlot.SLOT_STATUS_SUPER_PRIVACY, 14],
  [PluginSlot.SLOT_STATUS_LOCATION, 16],
  [PluginSlot.SLOT_STATUS_RING, 17.5], // 震动图标宽度
  [PluginSlot.SLOT_STATUS_DO_NOT_DISTURB, 14.25],
  [PluginSlot.SLOT_STATUS_NET_SPEED, 17],
  [PluginSlot.SLOT_STATUS_BLE, 19],
  [PluginSlot.SLOT_STATUS_NFC, 14],
  [PluginSlot.SLOT_STATUS_EARPHONE, 15],
  [PluginSlot.SLOT_STATUS_STAR_FLASH, 13],
  [PluginSlot.SLOT_STATUS_VPN, 17.5],
  [PluginSlot.SLOT_STATUS_CLOCK, 42]
])

/* 状态栏竖向时间容器边缘距离时间的间隙 */
export const STATUSBAR_CLOCK_EDGE_SPACE: number = 4;

export enum ClockShowType {
  NORMAL_SHOW,
  EXTRUDE_SHOW,
  HIDE,
}

export enum ClockWidth {
  NORMAL_WIDTH = 42,
  EXTRUDE_WIDTH = 21,
}

/**
 * 状态栏显隐场景
 */
export enum ShowHideStatusBarScene {
  LANDSCAPE_EXIT_APP = 0,
}

/**
 * 状态栏热区类型
 */
export enum ResponseRegionsClipType {
  /* 状态栏整个热区 */
  NO_CLIP = 0,
  /* 隐私指示器按钮热区 */
  PRIVACY_BUTTON = 1,
  /* 平板titleBar热区 */
  PAD_TITLE_BAR = 2,
  /* 手机titleBar热区 */
  PHONE_TITLE_BAR = 3,
  /* 点击手机titleBar呼出menu热区 */
  PHONE_MENU = 4
}

/**
 * titleBar类型
 */
export enum TitleBarType {
  /* 不显示 */
  NONE = 0,
  /* 平板 */
  PAD = 1,
  /* 折叠屏 */
  FOLD = 2,
  /* 折叠屏的menu */
  FOLD_MENU = 3
}

export enum BackGroundEffectType {
  backgroundShadow,
  backgroundHover,
}

export enum IconFilterType {
  UNDEFINED = -1,
  DEFAULT, // 默认
  KEYGUARD, // 锁屏
  KEYGUARD_IN_APP, // 锁屏应用场景
  DROPDOWN, // 双中心下拉
  OOBE,
  OOBE_AND_KEYGUARD,
}