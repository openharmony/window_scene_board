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
 * 沉浸列表常量
 */
export enum ImmListConst {
  INVALID_INDEX = -1, // 异常索引值
}

/**
 * 沉浸列表动效状态后缀标识
 */
export enum ListAnimSuffix {
  ITEM_COMMON_ANIM = '_item_common_anim', // 列表条目通用动效后缀标识
  ITEM_FOLD_ANIM = '_item_fold_anim', // 列表条目折叠翻转动效后缀标识
  ITEM_INNER_ANIM = '_item_inner_anim', // 列表条目内部内容动效后缀标识
  ITEM_BG_ANIM = '_item_bg_anim', // 列表条目背景动效后缀标识
  ITEM_SHADOW_ANIM = '_item_shadow_anim', // 列表条目阴影动效后缀标识
}

// 全列表条目动效后缀
export const LIST_ALL_ANIM_SF: ListAnimSuffix[] = [ListAnimSuffix.ITEM_COMMON_ANIM, ListAnimSuffix.ITEM_FOLD_ANIM,
  ListAnimSuffix.ITEM_INNER_ANIM, ListAnimSuffix.ITEM_BG_ANIM, ListAnimSuffix.ITEM_SHADOW_ANIM];

/**
 * 沉浸列表样式状态后缀标识
 */
export enum ListStyleSuffix {
  ITEM_COMMON_STYLE = '_item_common_style', // 列表条目通用样式后缀标识
  ITEM_ICON_STYLE = '_item_icon_style', // 列表条目图标样式后缀标识
  ITEM_TITLE_STYLE = '_item_title_style', // 列表条目主文本样式后缀标识
  ITEM_CONTENT_STYLE = '_item_content_style', // 列表条目副文本样式后缀标识
  EXT_TITLE_STYLE = '_item_ext_title_style', // 三方实况扩展区标题文本样式后缀标识
  EXT_CONTENT_STYLE = '_item_ext_content_style', // 三方实况扩展区内容文本样式后缀标识
  EXT_DIVIDER_STYLE = '_item_ext_divider_style', // 三方实况扩展区分割线样式后缀标识
  EXT_ACTION_STYLE = '_item_ext_action_style', // 三方实况扩展区服务按钮样式后缀标识
  EXT_AUTHOR_STYLE = '_item_ext_author_style', // 三方实况扩展区鉴权按钮样式后缀标识
  EXT_PICKUP_CON_STYLE = '_item_ext_pickup_con_style', // 三方实况取餐卡片扩展区副文本样式后缀标识
  EXT_SCORE_TIMER_STYLE = '_item_ext_score_timer_style', // 三方实况比分卡片扩展区计时样式后缀标识
  ITEM_TIME_STYLE = '_item_time_style', // 普通通知时间文本样式后缀标识
  SYS_LIVE_CONTENT_STYLE = '_system_live_content_style', // 系统实况副文本样式后缀标识
  SYS_LIVE_BUTTON_STYLE = '_system_live_button_style', // 系统实况按钮样式后缀标识
  SYS_LIVE_PROGRESS_STYLE = '_system_live_progress_style', // 系统实况进度环样式后缀标识
  OTHER_LIVE_EXTEND_STYLE = '_other_live_extend_style', // 三方实况扩展区样式后缀标识
  OTHER_EXT_VIEW_TEXT_STYLE = '_other_extent_view_text_style', // 三方实况辅助区文本样式后缀标识
  OTHER_EXT_VIEW_WANT_STYLE = '_other_extent_view_text_want_style', // 三方实况辅助区文本带wantAgent样式后缀标识
  OTHER_EXT_VIEW_BTN_STYLE = '_other_extent_view_button_style', // 三方实况辅助区按钮样式后缀标识
}

// 全列表条目样式后缀
export const LIST_ALL_STYLE_SF: ListStyleSuffix[] = [
  ListStyleSuffix.ITEM_COMMON_STYLE,
  ListStyleSuffix.ITEM_ICON_STYLE,
  ListStyleSuffix.ITEM_TITLE_STYLE,
  ListStyleSuffix.ITEM_CONTENT_STYLE,
  ListStyleSuffix.EXT_TITLE_STYLE,
  ListStyleSuffix.EXT_CONTENT_STYLE,
  ListStyleSuffix.EXT_DIVIDER_STYLE,
  ListStyleSuffix.EXT_ACTION_STYLE,
  ListStyleSuffix.EXT_AUTHOR_STYLE,
  ListStyleSuffix.EXT_PICKUP_CON_STYLE,
  ListStyleSuffix.EXT_SCORE_TIMER_STYLE,
  ListStyleSuffix.ITEM_TIME_STYLE,
  ListStyleSuffix.SYS_LIVE_CONTENT_STYLE,
  ListStyleSuffix.SYS_LIVE_BUTTON_STYLE,
  ListStyleSuffix.SYS_LIVE_PROGRESS_STYLE,
  ListStyleSuffix.OTHER_LIVE_EXTEND_STYLE,
  ListStyleSuffix.OTHER_EXT_VIEW_TEXT_STYLE,
  ListStyleSuffix.OTHER_EXT_VIEW_WANT_STYLE,
  ListStyleSuffix.OTHER_EXT_VIEW_BTN_STYLE,
];

/**
 * 沉浸列表缓存状态后缀标识
 */
export enum ListCacheSuffix {
  ITEM_COMMON_CACHE = '_item_common_cache', // 列表条目通用缓存后缀标识
}

// 全列表条目缓存后缀
export const LIST_ALL_CACHE_SF: ListCacheSuffix[] = [ListCacheSuffix.ITEM_COMMON_CACHE];

/**
 * 列表拦截/不拦截事件原因
 */
export enum StopTouchReason {
  REASON_UP_AT_END = 'touch_up_at_end', // 列表触底继续上滑
}

// 列表动效场景
export enum ListAnimScene {
  // 列表顶部、底部对齐方式切换动效
  ANIM_LIST_ALIGN_CHANGE = 'list_align_change',
  // 列表数据动效刷新
  ANIM_LIST_DATA_CHANGE = 'list_data_change',
  // 列表条目堆叠动效
  ANIM_LIST_ITEM_FOLD = 'list_item_fold',
  // 组通知展开动效
  ANIM_GROUP_EXPAND = 'list_group_expand',
  // 组通知收起动效
  ANIM_GROUP_COLLAPSE = 'list_group_collapse',
}