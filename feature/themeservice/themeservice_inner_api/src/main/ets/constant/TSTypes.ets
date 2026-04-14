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

export const ORIGIN_PRESET: OriginType = 'preset';

export const ORIGIN_ONLINE: OriginType = 'online';

export const ORIGIN_PRESET_FRAGMENT: OriginType = 'presetFragment';

/**
 * 主题安装来源
 * preset：预置完整的主题包。
 * presetFragment：需要跳转到主题APP，完成整包下载后才能应用。
 * online：在线
 */
export type OriginType = 'preset' | 'online' | 'presetFragment';

/**
 * 主题壁纸使用场景（锁屏、桌面）
 */
export type TWallpaperType = 'lock' | 'home';

/**
 * 壁纸内容类型
 */
export type WallPaperContentType = 'default' | 'video' | 'image' | 'json' | 'originForOther' | 'originInBase';

/**
 * 主题壁纸使用场景-锁屏场景
 */
export const TS_WALLPAPER_TYPE_LOCK: TWallpaperType = 'lock';

/**
 * 主题壁纸使用场景-桌面场景
 */
export const TS_WALLPAPER_TYPE_HOME: TWallpaperType = 'home';

/**
 * 主题资源包内文件类型
 */
export type TargetType = 'theme' | 'preview' | 'aod' | 'lock' | 'home' | 'fa' | 'long_take' | 'fonts' | 'icons' | 'skin'
  | 'sub_screen' | 'personalize';

export const TRES_THEME: TargetType = `theme`;

export const TARGET_PREVIEW: TargetType = `preview`;

export const TARGET_AOD: TargetType = `aod`;

export const TARGET_LOCK: TargetType = `lock`;

export const TARGET_HOME: TargetType = `home`;

export const TARGET_FA: TargetType = `fa`;

export const TARGET_LONG_TAKE: TargetType = `long_take`;

export const TARGET_FONT: TargetType = `fonts`;

export const TARGET_ICONS: TargetType = `icons`;

export const TARGET_SKIN: TargetType = `skin`;

export const TARGET_SUB_SCREEN: TargetType = `sub_screen`;

export const TARGET_PERSONALIZE: TargetType = `personalize`;

export type PresetResType = 'theme' | 'wallpaper' | 'icon' | 'font' | 'aod' | 'i18n';

export const PRESET_RES_THEME: PresetResType = `theme`;

export const PRESET_RES_WALLPAPER: PresetResType = `wallpaper`;

export const PRESET_RES_ICON: PresetResType = `icon`;

export const PRESET_RES_FONT: PresetResType = `font`;

export const PRESET_RES_AOD: PresetResType = `aod`;

export const PRESET_RES_I18N: PresetResType = `i18n`;

export type Qualifier = 'base' | 'land' | 'dark' | 'unfolded' | string;

export type QualifierContent<T> = Map<Qualifier, T>;

/**
 * Ts 首选项文件名称类型
 *
 * trial_theme: 试用主题缓存信息
 * optimize_theme: 预置主题文件hash记录，用于记录优化缓存文件一致性
 */
export type TsPreferenceName = 'ts_config' | 'ts_themeInfoV4' | 'ts_onlineRecommend' | 'ts_lemSubScreens'
  | 'activated_theme' | 'ts_smallSubScreens' | 'preset_themes' | 'trial_theme' | 'optimize_theme' | 'ts_update_theme'
  | 'ts_ignore_update_theme' | 'ts_update_theme_time' | 'ts_themeProperty' | 'ts_report_time';

/**
 * 试用内容类型
 * theme：主题
 * font：字体
 */
export type TrialContentType = 'theme' | 'font';

/**
 * 资源使能类型（试用|限制免费）
 */
export type ActivateType = 0 | 1;

/**
 * 试用回退类型 prev：回退前一个主题，default：回退默认主题
 */
export type TrialRollbackType = 'prev' | 'default';

/**
 * 内容可用状态，disable：资源不可用，enable：资源可用，vip：会员资源需要校验会员是否到期
 */
export type TContentPrivStatus = 'disable' | 'vip' | 'enable';

/**
 * system目录内容类型列表
 */
export const SYSTEM_THEME_TYPE_LIST = ['lock', 'home', 'aod'];

/**
 * app目录内容类型列表
 */
export const APP_THEME_TYPE_LIST = ['fonts', 'skin', 'icons'];