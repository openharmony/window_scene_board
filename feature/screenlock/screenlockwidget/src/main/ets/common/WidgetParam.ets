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

import { CardItemInfo } from '@ohos/launchercommon';
import { TimePosition } from '@ohos/screenlockcommon';

// 正常时钟样式和倒转的时钟样式差
export const CLOCK_LAYOUT_REVERSE_CONSTANT = 20;

/**
 * 时钟样式标识
 * 0~10 旧时钟样式（过时）
 * 10~100 数字时钟样式
 * 100~200 UD版本数字时钟样式
 */
export enum ClockLayout {
  DIMENSION_4_4 = 0,
  DIMENSION_4_2 = 1,
  DIMENSION_2_4 = 2,
  DIMENSION_3_6 = 4,
  DIMENSION_6_6 = 6,
  // 数字时钟样式
  DEFAULT_CLOCK_LAYOUT = 10,
  NORMAL_CLOCK_LAYOUT = 11,
  NORMAL_CLOCK_LAYOUT_LEFT = 12,
  NORMAL_CLOCK_LAYOUT_SPECIAL = 13,
  MOUNTAIN_CLOCK_LAYOUT = 14,
  MOUNTAIN_CLOCK_LAYOUT_SEPERATOR = 15,
  MOUNTAIN_CLOCK_LAYOUT_SPECIAL = 16,
  DEFAULT_CLOCK_SPECIAL = 17,

  // 时钟翻转样式
  DEFAULT_CLOCK_REVERSE_LAYOUT = DEFAULT_CLOCK_LAYOUT + CLOCK_LAYOUT_REVERSE_CONSTANT,
  NORMAL_CLOCK_REVERSE_LAYOUT = NORMAL_CLOCK_LAYOUT + CLOCK_LAYOUT_REVERSE_CONSTANT,
  MOUNTAIN_CLOCK_REVERSE_LAYOUT = MOUNTAIN_CLOCK_LAYOUT + CLOCK_LAYOUT_REVERSE_CONSTANT,
  MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR = MOUNTAIN_CLOCK_LAYOUT_SEPERATOR + CLOCK_LAYOUT_REVERSE_CONSTANT,

  // UD数字时钟标识，标识+数字时钟样式=UD数字时钟样式
  CLOCK_LAYOUT_UD_FLAG = 100,

  // 当前时钟样式结尾
  LAYOUT_END = 400
}

// 转置时钟样式
export const REVERSE_LAYOUT: Set<ClockLayout> =
  new Set([ClockLayout.DEFAULT_CLOCK_REVERSE_LAYOUT, ClockLayout.NORMAL_CLOCK_REVERSE_LAYOUT,
    ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT,
    ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR]);

/**
 * 时钟组件中各组件ID
 */
export enum ClockWidgetId {
  NONE = '',
  // 小时
  ID_HOUR0 = 'hour0',
  // 小时
  ID_HOUR1 = 'hour1',
  // 分隔符
  ID_SEPARATOR = 'separator',
  // 分钟
  ID_MINUTE0 = 'minute0',
  // 分钟
  ID_MINUTE1 = 'minute1',
  // 日期
  ID_DATE = 'date',
  // 星期
  ID_WEEK = 'week',
  // 农历
  ID_LUNA = 'lunar',
  // 普通签名
  ID_COM_SIGN = 'sign',
  // 艺术签名
  ID_ART_SIGN = 'artSign',
  // 父布局，即宫格
  ID_PARENT = 'parent',
  // 电量
  ID_BATTERY = 'battery',
}

// 全ID记录
export const ALL_CLOCK_WG_ID = [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
  ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1, ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK,
  ClockWidgetId.ID_LUNA, ClockWidgetId.ID_COM_SIGN, ClockWidgetId.ID_ART_SIGN, ClockWidgetId.ID_BATTERY];

/**
 * 数字时钟预置字体样式
 */
export enum ClockComFamily {
  HARMONY_CLOCK_01 = 'HarmonyClock_01',
  HARMONY_CLOCK_02 = 'HarmonyClock_02',
  HARMONY_CLOCK_03 = 'HarmonyClock_03',
  HARMONY_CLOCK_04 = 'HarmonyClock_04',
  HARMONY_CLOCK_05 = 'HarmonyClock_05',
  HARMONY_CLOCK_06 = 'HarmonyClock_06',
  HARMONY_CLOCK_07 = 'HarmonyClock_07',
  HARMONY_CLOCK_08 = 'HarmonyClock_08',
  // 布局1对应的UD字体
  HARMONY_CLOCK_ULT_01 = 'HarmonyClock_ult_layout_1',
  // 布局2-4对应的UD字体
  HARMONY_CLOCK_ULT_2_4 = 'HarmonyClock_ult_layout_2_4',
}

/**
 * 锁屏日期字体
 */
// 仓库内同名字体资源实际为 Thin 占位文件；Phone 参考样式使用系统可变字体落实 900/500 字重。
export const CLOCK_REFERENCE_FONT_FAMILY: string = 'HarmonyOS Sans';

// 预置字体样式集
export const ALL_COM_FAMILY: ClockComFamily[] = [ClockComFamily.HARMONY_CLOCK_01, ClockComFamily.HARMONY_CLOCK_02,
  ClockComFamily.HARMONY_CLOCK_03, ClockComFamily.HARMONY_CLOCK_04, ClockComFamily.HARMONY_CLOCK_05,
  ClockComFamily.HARMONY_CLOCK_06, ClockComFamily.HARMONY_CLOCK_07, ClockComFamily.HARMONY_CLOCK_08,
  ClockComFamily.HARMONY_CLOCK_ULT_01, ClockComFamily.HARMONY_CLOCK_ULT_2_4];

export enum ClockTextAlign {
  LEFT = 0,
  CENTER = 1,
  RIGHT = 2
}

/**
 * 智慧美学模糊透明与赋色
 */
export class AestheticColorArgs {
  public radius: number = 50;
  public saturation: number = 1.5;
  public brightness: number = 1.3;
  public needColor: string = '#59FFFFFF';
  public isShadow: boolean = true;
  public isChangeColor: boolean = false;
  public isPosterShadow?: boolean = false;
}

export class LockscreenFormConfig {
  public positionX: number = 0;
  public positionY: number = 0;
  // 宽度占用行数
  public dimensionX: number = 1;
  public formInfo: CardItemInfo = new CardItemInfo();
}

export interface LockscreenThemeConfig {
  clock: IThemeParam;
  form: LockscreenForm;
}

export interface IThemeParam {
  positionX: number;
  positionY: number;
  layout: ClockLayout;
  layoutDetail?: number; // 艺术签名子样式
  textShadow: boolean;
  textBlurEffect: boolean;
  signatureText: string;
  isShowAsCompound: boolean; // 是否作为合字体进行显示
  editStatus: boolean;
  dateVisible: boolean;
  lunarVisible: boolean;
  signatureVisible: boolean;
  textAlign: ClockTextAlign;
  color: string;
  fontFamily: string;
  aestheticColorArgs: AestheticColorArgs;
  isLightWallpaper?: boolean;
  isDof: boolean;
  clockDegree: number;
  version: number;
  isPosterShadow?: boolean;
}

/**
 * 锁屏时钟、卡片配置信息
 */
export class LockscreenConfig {
  public clock: ClockInnerConfig = new ClockInnerConfig();
  public form: LockscreenForm = new LockscreenForm();
}

/**
 * 锁屏时钟配置信息
 */
export class ClockInnerConfig implements TimePosition {
  public positionX: number = 0;
  public positionY: number = 0;
  public layout?: number;
  public layoutDetail?: number; // 艺术签名子样式
  public textAlign?: number;
  public textShadow?: boolean;
  public textBlurEffect?: boolean;
  public signatureText?: string;
  public isShowAsCompound?: boolean;
  public editStatus?: boolean;
  public dateVisible?: boolean;
  public lunarVisible?: boolean;
  public signatureVisible?: boolean;
  public color?: string;
  public fontFamily?: string;
  public isDof?: boolean; // 景深时钟样式
  public aestheticColorArgs?: AestheticColorArgs;
  public isLightWallpaper?: boolean;
  public clockDegree: PictureLightColorDegree = PictureLightColorDegree.UNKOWN_LIGHT_COLOR_DEGREE_PICTURE;
  public version?: number;

  constructor() {
  }
}

/**
 * 锁屏卡片配置信息
 */
export class LockscreenForm {
  public list: LockscreenFormConfig[] = [];
  public positionY: number = 0;

  constructor() {
  }
}

/**
 * 美学壁纸类型
 */
export enum PictureLightColorDegree {
  UNKOWN_LIGHT_COLOR_DEGREE_PICTURE = 0,
  EXTREMELY_LIGHT_COLOR_PICTURE = 1,
  LIGHT_COLOR_PICTURE = 2,
  DARK_COLOR_PICTURE = 3,
  EXTREMELY_DARK_COLOR_PICTURE = 4,
  FLOWERY_PICTURE = 5,
  EXTREMELY_FLOWERY_PICTURE = 6
}


/**
 * 电池布局信息
 */
export enum BatteryLayout {
  // 全屏AOD数字时钟电池布局
  FULL_AOD_LAYOUT,
  // 全屏AOD艺术签名电池布局
  FULL_ART_SIGN_LAYOUT,
  // 局部AOD数字时钟电池布局
  PART_AOD_LAYOUT,
}