/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2023-2024. All rights reserved.
 */

/**
 * 主题AB目录常量值
 */
export class ThemePathConstant {
  /**
   * 标识沙箱路径 A 目录是当前生效主题目录
   */
  public static readonly THEME_A_FLAG: string = '/data/themes/a/app/flag';
  /**
   * 标识沙箱路径 B 目录是当前生效主题目录
   */
  public static readonly THEME_B_FLAG: string = '/data/themes/b/app/flag';
  /**
   * 沙箱路径 A 目录中资源路径
   */
  public static readonly THEME_A_PATH: string = '/data/themes/a/system';
  /**
   * 沙箱路径 B 目录中资源路径
   */
  public static readonly THEME_B_PATH: string = '/data/themes/b/system';
}

/**
 * 标记当前主题使能类型
 */
export enum ThemeActivationTarget {
  /**
   * 默认场景
   */
  NIL = 0,
  /**
   * 只有锁屏修改
   */
  UNLOCK = 1,
  /**
   * 只有Home修改
   */
  HOME = 2,
  /**
   * Home和锁屏修改
   */
  HOME_AND_UNLOCK = 3,
  /**
   * 只有AOD修改
   */
  AOD = 4,
  /**
   * AOD和锁屏修改
   */
  AOD_AND_UNLOCK = 5,
  /**
   * AOD和Home修改
   */
  AOD_AND_HOME = 6,
  /**
   * 全部修改
   */
  ALL = 7,
  /**
   * 只有锁屏时钟修改
   */
  ONLY_LOCK_CLOCK = 8,
  /**
   * 只有图标修改（预留，暂无该场景）
   */
  ONLY_ICON = 9,
  /**
   * 外屏锁屏
   */
  OUTER_LOCK = 16,
  /**
   * 内屏外屏主题同时使能
   * */
  WHOLE_THEME_ALL = 23,
}

/**
 * 定义当前主题的所有权状态
 */
export enum ThemeOwnershipType {
  /**
   * 试用
   */
  TRIAL = 0,
  /**
   * 购买
   */
  PURCHASED = 1,
}