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
 * 组件特性开关类型
 */
export enum ConfigType {
  /**
   * 与通知、卡片联动
   */
  LINK_WITH_OTHERS = 'link_with_others',

  /**
   * 是否启用艺术签名
   */
  OPEN_ART_SIGN = 'open_art_sign'
}

/**
 * 动态绑定参数类型
 */
export type PropertyName = ConfigType;

/**
 * 外部向时钟组件内注册业务插件类型定义
 */
export enum ClockHookType {
  /**
   * viewModel组件
   */
  CLOCK_WIDGET_MODEL = 'clock_widget_model',

  /**
   * 时钟基础动效组件
   */
  CLOCK_ANIM_MANAGER = 'clock_anim_manager',

  /**
   * 时钟一镜到底动效组件
   */
  CLOCK_ONE_SHOT_ANIM_MANAGER = 'clock_one_shot_anim_manager',
  /**
   * 局部AOD时钟一镜到底
   */
  PART_CLOCK_ONE_SHOT_ANIM_MANAGER = 'part_clock_one_shot_anim_manager'
}

/**
 * 外部注入业务插件类型
 */
export type HookType = ClockHookType;

/**
 * 时钟组件使用场景
 */
export enum UseScene {
  /**
   * 默认场景
   */
  DEFAULT_SCENE = 'default_scene',

  /**
   * 主页面
   */
  MAIN_PAGE = 'main_page',

  /**
   * 壁纸编辑
   */
  WALLPAPER_EDIT = 'wallpaper_edit',

  /**
   * 桌面热安全模式
   */
  THERMAL_SAFE = 'thermalSafe',

  /**
   * verde小外屏桌面热安全模式
   */
  OUTER_THERMAL_SAFE = 'outer_thermalSafe',

  /**
   * 桌面应急模式
   */
  EMERGENCY = 'emergency',

  /**
   * verde小外屏桌面应急模式
   */
  OUTER_EMERGENCY = 'outer_emergency',

  /**
   * AOD预览
   */
  AOD_PRE_IMAGE = 'aod_pre_image',

  /**
   * 送显流程，全屏AOD
   */
  AOD_FULL_SCREEN = 'aod_full_screen',

  /**
   * 设置-桌面和个性化，小预览场景，全屏AOD
   */
  AOD_PREVIEW_FULL_SCREEN = 'aod_preview_full_screen',

  /**
   * 设置-桌面和个性化-熄屏显示，样式选择页面，全屏AOD
   */
  AOD_SELECT_FULL_SCREEN = 'aod_select_full_screen',

  /**
   * 设置-桌面和个性化-熄屏显示，样式应用页面，全屏AOD
   */
  AOD_APPLY_FULL_SCREEN = 'aod_apply_full_screen',

  /**
   * 锁屏编辑-熄屏显示，样式选择页面，全屏AOD
   */
  AOD_SELECT_FULL_SCREEN_SL_EDITOR = 'aod_select_full_screen_sl_editor',

  /**
   * 锁屏编辑-熄屏显示，样式应用页面，全屏AOD
   */
  AOD_APPLY_FULL_SCREEN_SL_EDITOR = 'aod_apply_full_screen_sl_editor',

  /**
   * 设置-桌面和个性化，小预览场景，自定义时钟样式
   */
  AOD_PREVIEW_CUSTOM_CLOCK = 'aod_preview_custom_clock',

  /**
   * 设置-桌面和个性化，样式选择页面，自定义时钟样式
   */
  AOD_SELECT_CUSTOM_CLOCK = 'aod_select_custom_clock',

  /**
   * 设置-桌面和个性化，样式应用页面，自定义时钟样式
   */
  AOD_APPLY_CUSTOM_CLOCK = 'aod_apply_custom_clock',

  /**
   * AOD自定义样式
   */
  AOD_CUSTOM_CLOCK = 'aod_custom_clock',
}
