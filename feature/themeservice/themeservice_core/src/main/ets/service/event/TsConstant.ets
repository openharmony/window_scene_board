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
  OUTER_LOCK = 16
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