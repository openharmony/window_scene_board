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
 * 状态类型
 */
export enum StateType {
  BIND = 'state_bind',
  STATIC = 'state_static',
  STYLE = 'state_style',
  ANIM = 'state_anim',
  CACHE = 'state_cache',
  CONFIG = 'state_config',
}

/**
 * 基础类型
 */
export type BaseObj = string | number | boolean | object;

/**
 * 状态在不同模式下ID区分
 */
export enum StateModeId {
  DEFAULT = 'default', // 默认状态
  AOD = 'aod', // AOD状态
  DARK = 'dark', // 深色背景状态
  LIGHT = 'light', // 浅色背景状态
  SOLID = 'solid', // 动态模式，纯色模式状态
  DIS_BRIGHT = 'disableBright', // 动态模式，禁用提亮模式状态
  REMIND = 'remind', // 动态模式，强提醒模式状态
  LIVE_FOLD = 'liveFold', // 动态模式，实况卡片收拢/展开模式状态
}