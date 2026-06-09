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
 * 锁屏状态管理器
 */
export enum SlStateMgr {
  MGR_COMMON = 'sl_state_common_mgr', // 通用锁屏状态管理器
  MGR_OUTER_SCREEN = 'sl_state_outer_mgr', // 小外屏锁屏状态管理器
}

/**
 * 锁屏状态唯一标示集
 */
export enum SlStateId {
  SL_COM_STATE = 'sl_com_state', // 锁屏通用静态/UI绑定/样式/动效等状态管理
  SL_IMMERSIVE_STATE = 'sl_immersive_state', // 沉浸模块静态/UI绑定/样式/动效等状态管理
  SL_LIST_STATE = 'sl_list_state', // 沉浸列表静态/UI绑定/样式/动效等状态管理
  SL_CAP_STATE = 'sl_cap_state', // 沉浸胶囊静态/UI绑定/样式/动效等状态管理
  SL_CARD_STATE = 'sl_card_state', // 沉浸大卡静态/UI绑定/样式/动效等状态管理
  SL_ART_SIGN_STATE = 'sl_art_sign_state', // 艺术签名模块静态/UI绑定/样式/动效等状态管理
}

/**
 * 锁屏组件基类，静态状态属性集
 */
export enum SlViewStaticStPt {
  PT_NONE = 'sl_view_property_none', // 组件属性待定
}

/**
 * 锁屏组件基类，UI绑定状态属性集
 */
export enum SlViewBindStPt {
  PT_VIEW_VISIBLE = 'sl_view_property_visible', // 组件可见性
}

/**
 * 锁屏组件基类，配置状态属性集
 */
export enum SlConfigStPt {
  PT_SIZE_BP_SPLICE = 'sl_view_property_size_bp_splice', // 配置所属屏幕断点拼接类型
}

/**
 * 锁屏模块通用静态状态属性集
 */
export enum SlComStaticStPt {
  PT_SCREEN_ON = 'sl_view_property_screen_on', // 屏幕亮屏状态
}

/**
 * 锁屏模块通用UI绑定状态属性集
 */
export enum SlComBinStPt {
  PT_ACCESSIBILITY_MODE = 'sl_view_property_accessibility_mode', // 当前无障碍开启状态
}

/**
 * 沉浸模块整体UI绑定状态属性集
 */
export enum SlImmBindStPt {
  PT_PRIVACY_TYPE = 'sl_view_property_privacy_type', // 沉浸模块隐私类型
  PT_SECURE_LOCKED = 'sl_secure_locked', // 锁屏上锁状态
  PT_AOD_MODE = 'sl_view_property_aod_mode', // 当前AOD开启状态
  PT_NTF_AUTO_SCREEN_ON = 'sl_view_property_ntf_auto_screen_on', // 来通知自动亮屏开关
  PT_CUR_SCREEN_ON = 'sl_view_property_cur_screen_on', // 当前屏幕是否亮屏状态
}

/**
 * 沉浸模块整体配置状态属性集
 */
export enum SlImmConfigStPt {
  PT_LIST_ENABLE = 'sl_view_property_list_enable', // 沉浸列表是否启动
  PT_CAP_ENABLE = 'sl_view_property_cap_enable', // 沉浸胶囊是否启动
  PT_CARD_ENABLE = 'sl_view_property_card_enable', // 沉浸大卡是否启动
}

/**
 * 沉浸列表组件静态状态属性集
 */
export enum SlListStaticStPt {
  PT_LIST_SCROLLER = 'sl_view_property_list_scroller', // 列表滑动控制器
  PT_ITEM_SPACE = 'sl_view_property_item_space', // 列表条目间距
  PT_LIST_MAX_HEIGHT = 'sl_view_property_list_max_height', // 列表最大高度
  PT_STOP_PROPAGATION = 'sl_view_property_stop_propagation', // 是否拦截锁屏事件
  PT_START_INDEX = 'sl_view_property_start_index', // 列表可见条目起始索引
  PT_END_INDEX = 'sl_view_property_end_index', // 列表可见条目结束索引
  PT_LIST_SCROLLING = 'sl_view_property_list_scrolling', // 列表当前滑动状态
  PT_ITEM_FOLD_ANIM = 'sl_view_property_item_fold_anim', // 列表条目翻转折叠动效
  PT_MESH_PADDING_B = 'sl_mesh_padding_bottom', // 列表网格底部边距
  PT_ITEM_SOLID_BG_COLOR = 'sl_view_property_item_solid_bg_color', // 列表条目背景纯色
}

/**
 * 沉浸列表组件UI绑定状态属性集
 */
export enum SlListBindStPt {
  PT_LIST_SCROLLER_ENABLE = 'sl_view_property_scroller_enable', // 列表滑动是否开启
  PT_ITEM_SWIPE_ENABLE = 'sl_view_property_item_swipe_enable', // 列表条目横滑开关
}

/**
 * 沉浸列表组件配置状态属性集
 */
export enum SlListConfigStPt {
  PT_TOP_CLOCK_HEIGHT = 'sl_view_property_top_clock_height', // 列表感知顶部时钟配置高度
  PT_BOTTOM_TOOLS_HEIGHT = 'sl_view_property_bottom_clock_height', // 列表感知底部小工具配置高度
  PT_GUTTER_CONFIG = 'sl_view_property_gutter_config', // 沉浸态宽度栅格计算配置
}

/**
 * 沉浸胶囊组件静态状态属性集
 */
export enum SlCapStaticStPt {
  PT_MAIN_CAP_SOLID_BG_COLOR = 'sl_view_property_main_cap_solid_bg_color', // 主胶囊纯色模式下背景颜色
  PT_SHADOW_CAP_SOLID_BG_COLOR = 'sl_view_property_shadow_cap_solid_bg_color', // 阴影胶囊纯色模式下背景颜色
  PT_MAIN_CAP_SOLID_FG_COLOR = 'sl_view_property_main_cap_solid_fg_color', // 主胶囊纯色模式下前景颜色
  PT_SHADOW_CAP_SOLID_FG_COLOR = 'sl_view_property_shadow_cap_solid_fg_color', // 阴影胶囊纯色模式下前景颜色
  PT_EXT_TEXT_SOLID_FG_COLOR = 'sl_view_property_ext_text_solid_fg_color', // 扩展区文本纯色模式下前景颜色
  PT_EXT_BTN_SOLID_BG_COLOR = 'sl_view_property_ext_btn_solid_bg_color', // 扩展区按钮纯色模式下背景颜色
  PT_BTN_SOLID_BG_COLOR = 'sl_view_property_btn_solid_bg_color', // 胶囊按钮纯色模式下背景颜色
  PT_AOD_MIRROR_INTERRUPT = 'sl_view_property_aod_mirror_interrupt', // 胶囊AOD一镜到底动效打断器
}

/**
 * 沉浸胶囊组件UI绑定状态属性集
 */
export enum SlCapBindStPt {
  PT_BTN_COUNT = 'sl_view_property_btn_count', // 实况胶囊扩展区按钮个数
  PT_CAP_REMIND = 'sl_view_property_cap_remind', // 实况胶囊当前强提醒状态
}

/**
 * 沉浸胶囊组件配置状态属性集
 */
export enum SlCapConfigStPt {
  PT_BTN_COUNT = 'sl_view_property_cap_btn_count', // 实况胶囊扩展区按钮个数
  PT_USE_HEIGHT_CAL = 'sl_view_property_use_height_cal', // 实况胶囊宽度计算是否使用屏幕高度
}

/**
 * 沉浸大卡组件静态状态属性集
 */
export enum SlCardStaticStPt {
  PT_LIVE_CACHE_POS = 'sl_view_property_live_cache_pos_enable', // 大卡通用样式中实况卡片位置记录是否开启
  PT_FOLD_OUTER_STATE = 'sl_view_property_fold_outer_state', // 大卡折叠小外屏状态
  PT_GROUP_KEY_OF_SHOWING = 'immersive_card_group_key_of_showing', // 当前显示的沉浸大卡通知groupKey
  PT_CARD_SOLID_BG_COLOR = 'sl_view_property_card_solid_bg_color', // 沉浸大卡纯色模式下背景颜色
  PT_BACK_BTN_SOLID_COLOR = 'sl_view_property_back_btn_solid_color', // 沉浸大卡返回按钮纯色模式下颜色
  PT_LIVE_CARD_FOLD = 'sl_view_property_live_card_fold_st', // 沉浸大卡实况卡片是否收拢隐藏
}

/**
 * 沉浸大卡组件UI绑定状态属性集
 */
export enum SlCardBindStPt {
  PT_BACK_BTN = 'sl_view_property_back_bnt_enable', // 沉浸态是否显示返回按钮
  PT_LIVE_BG_BLUR = 'sl_view_property_live_bg_blur_enable', // 大卡通用样式中底部实况卡片是否开启模糊背景
  PT_LIVE_ARROW = 'sl_view_property_live_arrow_enable', // 大卡通用样式中底部实况卡片是否开启顶部箭头
  PT_CONTENT_FULL = 'sl_view_property_content_full_screen_enable', // 大卡通用样式中内容是否开启占满全屏开关
  PT_HIDE_AUTH_IMG = 'sl_view_property_hide_auth_img', // 大卡定位权限授权提醒布局中是否隐藏图标
  PT_ITEM_CLICK_INNER = 'sl_view_property_item_click_inner', // 大卡条目点击事件是否设置在内部实况卡片上
  PT_DISABLE_ITEM_GESTURE = 'sl_view_property_disable_item_gesture', // 大卡条目手势上滑下滑事件屏蔽开关
  PT_ENABLE_LIVE_GESTURE = 'sl_view_property_enable_live_gesture', // 大卡实况卡片手势下滑事件开启开关
  PT_HIDE_ITEM_BG = 'sl_view_property_hide_item_bg', // 大卡条目是否隐藏背景
  PT_LIVE_CARD_FOLD = 'sl_view_property_live_card_fold_st', // 大卡条目实况卡片是否收拢隐藏
}

/**
 * 沉浸大卡动效、样式子状态ID
 */
export enum SlCardChildId {
  ID_CARD_BG = 'sl_view_id_card_bg', // 沉浸大卡背景组件
  ID_CARD_PREVIEW = 'sl_view_id_card_preview', // 沉浸大卡预览图组件
}

/**
 * 沉浸大卡组件配置状态属性集
 */
export enum SlCardConfigStPt {
  PT_TOP_CLOCK_HEIGHT = 'sl_view_property_top_clock_height', // 列表感知顶部时钟配置高度
  PT_BOTTOM_TOOLS_HEIGHT = 'sl_view_property_bottom_clock_height', // 列表感知底部小工具配置高度
  PT_GUTTER_CONFIG = 'sl_view_property_gutter_config', // 沉浸态宽度栅格计算配置
  PT_GUTTER_HEIGHT = 'sl_view_property_gutter_by_height', // 沉浸态宽度栅格计算是否以屏幕高度为基准
  PT_GUTTER_CALC_HEIGHT = 'sl_view_property_gutter_calc_height', // 沉浸态以栅格宽度计算栅格高度
  PT_BACK_BTN = 'sl_view_property_back_bnt_enable', // 沉浸态是否显示返回按钮
  PT_LIVE_BG_BLUR = 'sl_view_property_live_bg_blur_enable', // 大卡通用样式中底部实况卡片是否开启模糊背景
  PT_LIVE_ARROW = 'sl_view_property_live_arrow_enable', // 大卡通用样式中底部实况卡片是否开启顶部箭头
  PT_CONTENT_FULL = 'sl_view_property_content_full_screen_enable', // 大卡通用样式中内容是否开启占满全屏开关
  PT_HIDE_AUTH_IMG = 'sl_view_property_hide_auth_img', // 大卡定位权限授权提醒布局中是否隐藏图标
  PT_ITEM_CLICK_INNER = 'sl_view_property_item_click_inner', // 大卡条目点击事件是否设置在内部实况卡片上
  PT_LIVE_CACHE_POS = 'sl_view_property_live_cache_pos_enable', // 大卡通用样式中实况卡片位置记录是否开启
  PT_CLOCK_HEIGHT_DISABLE = 'sl_view_property_clock_height_disable', // 顶部时钟高度监听是否关闭
  PT_DISABLE_ITEM_GESTURE = 'sl_view_property_disable_item_gesture', // 沉浸大卡条目手势是否禁用
  PT_ENABLE_LIVE_GESTURE = 'sl_view_property_enable_live_gesture', // 沉浸大卡实况卡片手势是否启用
  PT_FOLD_OUTER_STATE = 'sl_view_property_fold_outer_state', // 大卡折叠小外屏状态
  PT_HIDE_ITEM_BG = 'sl_view_property_hide_item_bg', // 大卡条目隐藏背景
}

// 锁屏组件状态属性归一
export type SlStateProperty = SlViewStaticStPt | SlViewBindStPt | SlConfigStPt | SlComStaticStPt | SlComBinStPt |
  SlImmBindStPt | SlImmConfigStPt | SlListBindStPt | SlListStaticStPt | SlListConfigStPt | SlCapStaticStPt |
  SlCapBindStPt | SlCapConfigStPt | SlCardStaticStPt | SlCardBindStPt | SlCardConfigStPt;