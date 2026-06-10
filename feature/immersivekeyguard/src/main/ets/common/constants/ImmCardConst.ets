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

// 大卡显示类型
export enum CardShowType {
  CARD_NONE = 'card_none', // 无效大卡
  CARD_CONTENT = 'card_content', // 内容大卡
  CARD_UPDATE_OLD = 'card_update_old', // 被更新的大卡
  CARD_DELETE = 'card_delete', // 被移除的大卡
  CARD_CAP = 'card_cap', // 胶囊大卡-过渡胶囊时替代内容大卡
  CARD_LIST = 'card_list', // 列表大卡-过渡列表时替代内容大卡
  CARD_UI_EXTENSION_CACHE = 'card_ui_extension_cache', // UIExtension缓存类型大卡
}

// 全大卡类型
export const CARD_ALL_TYPE: CardShowType[] = [
  CardShowType.CARD_CONTENT,
  CardShowType.CARD_UPDATE_OLD,
  CardShowType.CARD_DELETE,
  CardShowType.CARD_CAP,
  CardShowType.CARD_LIST,
  CardShowType.CARD_UI_EXTENSION_CACHE,
];

// 沉浸大卡动效状态后缀标识
export enum CardAnimSuffix {
  ITEM_COMMON_ANIM = '_item_common_anim', // 大卡条目通用动效后缀标识
  LIVE_CARD_ANIM = '_live_card_anim', // 大卡条目布局中实况卡片后缀标识
}

// 全大卡条目动效后缀
export const CARD_ALL_ANIM_SF: CardAnimSuffix[] = [CardAnimSuffix.ITEM_COMMON_ANIM, CardAnimSuffix.LIVE_CARD_ANIM];

// 沉浸大卡样式状态后缀标识
export enum CardStyleSuffix {
  ITEM_COMMON_STYLE = '_item_common_style', // 大卡条目通用样式后缀标识
  ITEM_INNER_STYLE = '_item_inner_style', // 大卡条目通用布局inner样式后缀标识
  ITEM_BG_STYLE = '_item_bg_style', // 大卡条目背景样式后缀标识
  ITEM_LIVE_STYLE = '_item_live_card_style', // 大卡条目通用布局的实况卡片样式后缀标识
  ITEM_LINEAR_BG_STYLE = '_item_live_card_linear_bg_style', // 大卡条目通用布局的实况卡片线性渐变背景样式后缀标识
  ITEM_BRIGHT_BG_STYLE = '_item_live_card_bright_bg_style', // 大卡条目通用布局的实况卡片提亮背景样式后缀标识
  ITEM_LIVE_RICH_STYLE = '_item_live_card_rich_style', // 大卡条目通用布局的实况卡片副文本样式后缀标识
  ITEM_LIVE_ARROW_STYLE = '_item_live_card_arrow_style', // 大卡条目通用布局的实况卡片顶部箭头样式后缀标识
  ITEM_AUTH_STYLE = '_item_auth_style', // 大卡条目UIExtension布局时定位授权提示样式后缀标识
  ITEM_BACK_STYLE = '_item_back_btn_style', // 大卡条目返回按钮样式后缀标识
  ITEM_PREVIEW_STYLE = '_item_preview_style', // 大卡预览图区域样式后缀标识（静态图/UIextension/播控通用）
  ITEM_MAIN_TEXT_STYLE = '_item_main_text_style', // 大卡条目主文本样式后缀标识
  ITEM_SECONDARY_TEXT_STYLE = '_item_secondary_text_style', // 大卡条目副文本样式后缀标识
  ITEM_SYS_SECONDARY_TEXT_STYLE = '_item_sys_secondary_text_style', // 系统实况大卡条目副文本样式后缀标识
  ITEM_SYS_MAIN_TEXT_STYLE = '_item_sys_main_text_style', // 系统实况大卡条目主文本样式后缀标识
  ITEM_OTHER_EXTEND_STYLE = '_item_other_extend_style', // 大卡三方拓展区样式后缀标识
  ITEM_OTHER_EXTEND_WANT_STYLE = '_item_other_extend_want_style', // 大卡三方拓展区wantAgent样式后缀标识
  ITEM_OTHER_EXTEND_TEXT_STYLE = '_item_extension_text_style', // 大卡三方扩展区中文本样式后缀标识
  ITEM_OTHER_EXTEND_BTN_STYLE = '_item_extension_button_style', // 大卡三方扩展区中按钮样式后缀标识
  ITEM_EXTENSION_LOADING_STYLE = '_item_extension_loading_style', // 大卡条目UIExtension loading组件样式后缀标识
}

// 全大卡条目样式后缀
export const CARD_ALL_STYLE_SF: CardStyleSuffix[] = [
  CardStyleSuffix.ITEM_COMMON_STYLE,
  CardStyleSuffix.ITEM_BACK_STYLE,
  CardStyleSuffix.ITEM_INNER_STYLE,
  CardStyleSuffix.ITEM_BG_STYLE,
  CardStyleSuffix.ITEM_LIVE_STYLE,
  CardStyleSuffix.ITEM_LINEAR_BG_STYLE,
  CardStyleSuffix.ITEM_BRIGHT_BG_STYLE,
  CardStyleSuffix.ITEM_LIVE_RICH_STYLE,
  CardStyleSuffix.ITEM_LIVE_ARROW_STYLE,
  CardStyleSuffix.ITEM_AUTH_STYLE,
  CardStyleSuffix.ITEM_PREVIEW_STYLE,
  CardStyleSuffix.ITEM_MAIN_TEXT_STYLE,
  CardStyleSuffix.ITEM_SECONDARY_TEXT_STYLE,
  CardStyleSuffix.ITEM_SYS_SECONDARY_TEXT_STYLE,
  CardStyleSuffix.ITEM_SYS_MAIN_TEXT_STYLE,
  CardStyleSuffix.ITEM_OTHER_EXTEND_STYLE,
  CardStyleSuffix.ITEM_OTHER_EXTEND_TEXT_STYLE,
  CardStyleSuffix.ITEM_OTHER_EXTEND_BTN_STYLE,
  CardStyleSuffix.ITEM_OTHER_EXTEND_WANT_STYLE,
  CardStyleSuffix.ITEM_EXTENSION_LOADING_STYLE
];

// 沉浸大卡缓存状态后缀标识
export enum CardCacheSuffix {
  ITEM_COMMON_CACHE = '_item_common_cache', // 大卡条目通用缓存后缀标识
  ITEM_LIVE_CACHE = '_item_live_cache', // 大卡条目通用UI样式中实况卡片缓存后缀标识
}

// 全大卡条目缓存后缀
export const CARD_ALL_CACHE_SF: CardCacheSuffix[] = [CardCacheSuffix.ITEM_COMMON_CACHE,
  CardCacheSuffix.ITEM_LIVE_CACHE];

// UIExtension定位权限错误码
export enum LocationErrorCode {
  DEFAULT_CODE = Infinity, // 默认错误码
  NO_PERMISSION = 201, // 应用无定位权限
  LOCATION_SWITCH_OFF = 3301100, // 系统定位权限未开启
}

// UIExtension定位权限错误码全集
export const ALL_LOCATION_ERR: LocationErrorCode[] = [LocationErrorCode.DEFAULT_CODE,
  LocationErrorCode.NO_PERMISSION, LocationErrorCode.LOCATION_SWITCH_OFF];

// UIExtension定位权限错误码有效集
export const VALID_LOCATION_ERR: LocationErrorCode[] = [LocationErrorCode.NO_PERMISSION,
  LocationErrorCode.LOCATION_SWITCH_OFF];

// 定位权限
export enum LocationPermission {
  APPROXIMATELY_LOCATION = 'ohos.permission.APPROXIMATELY_LOCATION', // 应用定位权限
  LOCATION_MANAGER_URI = 'location_manager_settings', // 定位权限管理页面URI
  APPLICATION_ENTRY_URI = 'application_info_entry', // 定位权限目标应用页面URI
}

// 设置应用信息
export enum SettingsInfo {
  SETTINGS_BUNDLE_NAME = 'com.ohos.settings', // 设置应用包名
  SETTINGS_ABILITY_NAME = 'com.ohos.settings.MainAbility', // 设置应用主页面
}

// 沉浸大卡动效场景
export enum CardAnimScene {
  // 无动效
  ANIM_NONE = 'card_anim_none',
  // 沉浸卡片删除场景
  ANIM_DELETE = 'card_anim_delete',
  // 沉浸卡片更新场景
  ANIM_UPDATE = 'card_anim_update',
  // 实况卡片收拢/展开场景
  ANIM_LIVE_FOLD = 'card_anim_live_fold',
}

// 外屏大卡大小
export enum OuterCardSize {
  WIDTH = '980px',
  HEIGHT = '980px',
}

// 实况卡片默认高度
export enum LiveCardHeight {
  DEFAULT_HEIGHT = 84,
  MEDIA_HEIGHT = 108
}