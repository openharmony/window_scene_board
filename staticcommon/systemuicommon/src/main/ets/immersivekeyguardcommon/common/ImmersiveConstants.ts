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
 * 锁屏胶囊模板类型
 */
export enum ImmersiveCapsuleType {
  /**
   * 普通通知类型
   */
  NORMAL,

  /**
   * 实况通知类型
   */
  LIVE_VIEW
}

/**
 * 沉浸锁屏数据显示类型
 */
export enum ImmersiveShowType {
  /**
   * 完全不显示
   */
  NOT_SHOW = 0x01,

  /**
   * 在胶囊显示
   */
  SHOW_CAPSULE = 0x02,

  /**
   * 在卡片显示
   */
  SHOW_CARD = 0x04,
}

/**
 * 实况数据更新事件类型
 */
export enum NtfEventType {
  /**
   * 通知列表初始化
   */
  EVENT_TYPE_INIT = 0,

  /**
   * 通知新增事件
   */
  EVENT_TYPE_POST_ADD = 1,

  /**
   * 通知更新事件
   */
  EVENT_TYPE_POST_UPDATE = 2,

  /**
   * 通知取消事件
   */
  EVENT_TYPE_POST_CANCEL = 3
}

/**
 * 默认进沉浸态屏幕开关
 */
export enum DefaultImmersiveScreenSwitch {
  /**
   * 全关
   */
  ALL_OFF = 0x00,

  /**
   * 小折叠外屏
   */
  SMALL_OUTER_SCREEN = 0x01,

  /**
   * 默认屏
   */
  DEFAULT_SCREEN = 0x02,
}

/**
 * 默认进沉浸态通知开关
 */
export enum DefaultImmersiveNtfTypeSwitch {
  /**
   * 所有通知类型全关
   */
  NTF_TYPE_OFF = 0x00,

  /**
   * 播控通知
   */
  NTF_TYPE_BROAD = 0x01,

  /**
   * 三方实况通知
   */
  NTF_TYPE_LIVE = 0x02,
}

/**
 * 沉浸锁屏常量
 *
 * @since 2024-02-27
 */
export class ImmersiveConstants {
  /**
   * 日志前缀
   */
  static readonly LOG_PREFIX: string = '[IMMERSIVE_KEYGUARD]';

  /**
   * 默认进沉浸态屏幕开关 按二进制查表DefaultImmersiveScreenSwitch枚举判断开关是否打开
   */
  static readonly NTF_DEFAULT_IMMERSIVE_SCREEN_SWITCH: number = 1;

  /**
   * 默认进沉浸态通知开关 按二进制查表DefaultImmersiveNtfTypeSwitch枚举判断开关是否打开
   */
  static readonly NTF_DEFAULT_IMMERSIVE_TYPE_SWITCH: number = 3;

  /**
   * 默认进沉浸态三方应用开关
   */
  static readonly NTF_DEFAULT_IMMERSIVE_APP_SWITCH: string[] = [];
}