/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2024. All rights reserved.
 */
import { PictureLightColorDegree, ClockWidgetId } from '../../common/WidgetParam';

/**
 * 日期、星期、农历布局样式
 */
export enum DateWeekLunarStyle {
  STYLE_SINGLE_LINE = 1, // 单行显示样式
  STYLE_MULTILINE, // 多行显示样式
  STYLE_SEPARATOR // 离散显示样式
}

/**
 * 时钟元素布局参数对应索引
 */
export enum ElementConfIndex {
  HOUR_0 = 0,
  HOUR_1,
  SEPARATOR,
  MINUTE_0,
  MINUTE_1,
  DATE,
  WEEK,
  LUNAR,
  SIGN
}

/**
 * AOD电量组件位置
 */
export enum BatteryPosition {
  SEPARATE = 0, // 默认离散布局
  LUNAR_RIGHT,  // 农历右侧
  LUNAR_LEFT,   // 农历左侧
  WEEK_RIGHT,   // 星期右侧
  DATE_LEFT,    // 阳历左侧
}

export class ClockConstants {
  /**
   * 锁屏时钟阴影默认半径
   */
  public static readonly DEFAULT_CLOCK_SHADOW_RADIUS = 100;

  /**
   * 锁屏时钟阴影默认颜色
   */
  public static readonly DEFAULT_CLOCK_SHADOW_COLOR = '#FFFFFF';

  /**
   * 锁屏时钟投影半径
   */
  public static readonly SHADOW_RADIUS: Map<PictureLightColorDegree, number | Resource> = new Map([
    [PictureLightColorDegree.LIGHT_COLOR_PICTURE, ClockConstants.DEFAULT_CLOCK_SHADOW_RADIUS],
    [PictureLightColorDegree.FLOWERY_PICTURE, ClockConstants.DEFAULT_CLOCK_SHADOW_RADIUS],
    [PictureLightColorDegree.EXTREMELY_FLOWERY_PICTURE, ClockConstants.DEFAULT_CLOCK_SHADOW_RADIUS],
  ]);


  /**
   * 锁屏时钟投影颜色
   */
  public static readonly SHADOW_COLOR: 
    Map<PictureLightColorDegree, Color | string | Resource | ColoringStrategy> = new Map([
    [PictureLightColorDegree.LIGHT_COLOR_PICTURE, '#0d000000'],
    [PictureLightColorDegree.FLOWERY_PICTURE, '#0d000000'],
    [PictureLightColorDegree.EXTREMELY_FLOWERY_PICTURE, '#17000000'],
  ]);

  /**
   * 数字0
   */
  public static readonly ZERO = 0;

  /**
   * 锁屏时钟投影填充属性
   */
  public static readonly FILL_CLOCK_SHADOW = true;

  /**
   * 透明度为0的白色
   */
  public static readonly BRIGHT_COLOR = '#00ffffff';

  /**
   * 默认白色
   */
  public static readonly DEFAULT_CLOCK_BRIGHT_COLOR = '#FFFFFF';

  /**
   * 锁屏时钟默认投影参数
   */
  public static readonly DEFAULT_CLOCK_SHADOW_OPTION: ShadowOptions = {
    radius: ClockConstants.DEFAULT_CLOCK_SHADOW_RADIUS,
    color: ClockConstants.BRIGHT_COLOR,
    fill: ClockConstants.FILL_CLOCK_SHADOW
  };

  /**
   * 提亮数值brightness < 1表示需要提亮，反之需要压暗
   */
  public static readonly BRIGHT_NESS_DEFAULT = 1;

  /**
   * 时钟颜色默认值
   */
  public static readonly CLOCK_DEFAULT_FOREGROUND_COLOR: string = '#FFFFFF';

  /**
   * 时钟元素ID集合
   */
  public static readonly ID_ARR = [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
    ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1, ClockWidgetId.ID_DATE, ClockWidgetId.ID_WEEK,
    ClockWidgetId.ID_LUNA, ClockWidgetId.ID_BATTERY];

  /**
   *  ClockWidget ID常量
   */
  public static readonly COMPONENT_ID_DIGITAL_VIEW = 'Text_Digital';
  public static readonly COMPONENT_ID_DIGITAL_TEXT_VIEW = 'Text_Digital_Text';
}

export class AodBatteryConstants {
  /**
   * 默认的aod电量尺寸
   */
  public static readonly AOD_BATTERY_DEFAULT_SCALE = 1.0;

  /**
   * 小外屏的aod电量图标缩放尺寸
   */
  public static readonly AOD_BATTERY_SMALL_FOLD_SCALE = 0.816;

  /**
   * 小折叠内屏的aod电量图标缩放尺寸
   */
  public static readonly AOD_BATTERY_POCKET_FOLD_SCALE = 0.855;

  /**
   * 第七款时钟样式下，小外屏农历日期的偏移量
   */
  public static readonly LUNAR_OFFSET_BY_MOUNTAIN_CLOCK_SPECIAL_FOR_SMALL_FOLD = 38;

  /**
   * 第七款时钟样式下，小外屏电量图标的偏移量
   */
  public static readonly AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_SPECIAL_FOR_SMALL_FOLD = -54;
  /**
   * 第七款时钟样式下，在闰月时，小外屏电量图标的偏移量
   */
  public static readonly AOD_BATTERY_OFFSET_BY_MOUNTAIN_CLOCK_SPECIAL_FOR_LEAP = -59;
}

// 艺术签名单字阴影样式
export const ART_SIGN_SHADOW_STYLE: ShadowOptions = {
  radius: 30,
  color: '#1A000000',
  fill: true,
}

// 农历、日期、星期阴影样式
export const DATE_SHADOW_STYLE: ShadowOptions = {
  radius: 80,
  color: '#15000000',
  fill: true,
}

// AOD阴影过度样式
export const ART_SIGN_SHADOW_STYLE_AOD: ShadowOptions = {
  radius: 30,
  color: '#00000000',
  fill: true,
}