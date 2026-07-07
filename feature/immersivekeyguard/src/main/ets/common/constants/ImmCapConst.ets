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

// 胶囊显示类型
export enum CapShowType {
  CAP_NONE = 'cap_none', // 无类型
  CAP_SHADOW = 'cap_shadow', // 阴影胶囊
  CAP_CONTENT = 'cap_content', // 内容胶囊
  CAP_REMIND = 'cap_remind', // 强提醒胶囊
  CAP_CARD = 'cap_to_card', // 过渡沉浸大卡的胶囊
  CAP_CARD_BACK = 'card_to_cap', // 沉浸大卡过渡返回的胶囊
  CAP_REMOVE = 'cap_remove', // 被移除的胶囊
  CAP_UPDATE = 'cap_update', // 更新的胶囊
  CAP_ADD = 'cap_add', // 新增的胶囊
}

// 全胶囊类型
export const CAP_ALL_TYPE: CapShowType[] = [CapShowType.CAP_SHADOW, CapShowType.CAP_CONTENT,
  CapShowType.CAP_REMIND, CapShowType.CAP_CARD, CapShowType.CAP_REMOVE, CapShowType.CAP_UPDATE, CapShowType.CAP_ADD];

// 沉浸胶囊动效状态后缀标识
export enum CapAnimSuffix {
  ITEM_COMMON_ANIM = '_item_common_anim', // 胶囊条目通用动效后缀标识
  ITEM_INNER_ANIM = '_item_inner_anim', // 胶囊条目inner动效后缀标识
}

// 全胶囊条目动效后缀
export const CAP_ALL_ANIM_SF: CapAnimSuffix[] = [CapAnimSuffix.ITEM_COMMON_ANIM, CapAnimSuffix.ITEM_INNER_ANIM];

// 沉浸胶囊样式状态后缀标识
export enum CapStyleSuffix {
  ITEM_COMMON_STYLE = '_item_common_style', // 胶囊条目通用样式后缀标识
  ITEM_LARGE_ICON_STYLE = '_item_large_icon_style', // 胶囊条目大图标样式后缀标识
  ITEM_SMALL_ICON_STYLE = '_item_small_icon_style', // 胶囊条目小图标样式后缀标识
  ITEM_SMALL_ICON_BG_STYLE = '_item_small_icon_bg_style', // 胶囊条目小图标背景样式后缀标识
  ITEM_SMALL_ICON_REVERSE_STYLE = '_item_small_icon_reverse_style', // 胶囊条目小图标克隆应用样式后缀标识
  ITEM_SMALL_ICON_BG_REVERSE_STYLE = '_item_small_icon_bg_reverse_style', // 胶囊条目小图标背景克隆应用样式后缀标识
  ITEM_MAIN_TEXT_STYLE = '_item_main_text_style', // 胶囊条目主文本样式后缀标识
  ITEM_SECONDARY_TEXT_STYLE = '_item_secondary_text_style', // 胶囊条目副文本样式后缀标识
  ITEM_EXTENSION_STYLE = '_item_extension_style', // 胶囊条目扩展区样式后缀标识
  ITEM_EXT_TEXT_STYLE = '_item_extension_text_style', // 胶囊条目扩展区中文本样式后缀标识
  ITEM_EXT_BTN_STYLE = '_item_extension_button_style', // 胶囊条目扩展区中按钮样式后缀标识
  ITEM_BUTTON_STYLE = '_item_button_style', // 胶囊按钮样式后缀表示
}

// 全胶囊条目样式后缀
export const CAP_ALL_STYLE_SF: CapStyleSuffix[] = [CapStyleSuffix.ITEM_COMMON_STYLE,
  CapStyleSuffix.ITEM_LARGE_ICON_STYLE, CapStyleSuffix.ITEM_SMALL_ICON_STYLE,
  CapStyleSuffix.ITEM_SMALL_ICON_BG_STYLE, CapStyleSuffix.ITEM_SMALL_ICON_REVERSE_STYLE,
  CapStyleSuffix.ITEM_SMALL_ICON_BG_REVERSE_STYLE, CapStyleSuffix.ITEM_MAIN_TEXT_STYLE,
  CapStyleSuffix.ITEM_SECONDARY_TEXT_STYLE, CapStyleSuffix.ITEM_EXTENSION_STYLE,
  CapStyleSuffix.ITEM_EXT_TEXT_STYLE, CapStyleSuffix.ITEM_EXT_BTN_STYLE, CapStyleSuffix.ITEM_BUTTON_STYLE];

// 沉浸胶囊缓存状态后缀标识
export enum CapCacheSuffix {
  ITEM_COMMON_CACHE = '_item_common_cache', // 胶囊条目通用缓存后缀标识
}

// 全胶囊条目缓存后缀
export const CAP_ALL_CACHE_SF: CapCacheSuffix[] = [CapCacheSuffix.ITEM_COMMON_CACHE];

// 胶囊动效场景
export enum CapAnimScene {
  // 无动效
  ANIM_NONE = 'capsule_anim_none',
  // 胶囊出现
  ANIM_SHOW = 'capsule_root_show',
  // 胶囊消失
  ANIM_HIDE = 'capsule_root_hide',
  // 胶囊顶部新增数据堆叠效果切换
  ANIM_TOP_ADD = 'capsule_stack_add',
  // 胶囊顶部移除数据堆叠效果切换
  ANIM_TOP_REMOVE = 'capsule_stack_remove',
  // 胶囊顶部更新数据强提醒效果
  ANIM_TOP_UPDATE = 'capsule_top_update',
  // 阴影胶囊移除效果
  ANIM_SHADOW_REMOVE = 'capsule_shadow_remove',
  // 胶囊强提醒翻转
  ANIM_REMIND = 'capsule_remind',
  // 胶囊退出强提醒翻转
  ANIM_REMIND_EXIT = 'capsule_remind_exit',
}