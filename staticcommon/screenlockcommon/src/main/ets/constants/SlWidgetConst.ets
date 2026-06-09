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
 * 锁屏首页各组件ID
 */
export enum SlWidgetId {
  ROOT_ID = '__container__', // 根布局，相对布局固定ID
  SL_ROOT_ALIAS = 'sl_root_home', // 根布局别名，真实ID
  CLOCK = 'sl_clock', // 时钟组件
  ART_SIGN = 'art_sign', // 时钟组件
  DOF_WALLPAPER = 'sl_dof_wallpaper', // 景深壁纸
  LOCK_HEAD = 'sl_lock_head', // 顶部锁头
  FORM = 'sl_form', // 快捷卡片
  FORM_FOR_AOD = 'sl_form_for_aod', // 快捷卡片
  BOTTOM_TOOLS_ICON = 'sl_bottom_tools_icon', // 底部小工具图标
  QUICK_TOOLS_ICON = 'sl_quick_tools_icon', // 底部快捷工具图标
  CAMERA_ICON = 'sl_camera_icon', // 底部相机图标
  IMMERSIVE_LIST = 'sl_immersive_list', // 沉浸通知列表
  IMMERSIVE_CARD = 'sl_immersive_card', // 沉浸通知卡片
  IMMERSIVE_CARD_OUTER = 'sl_immersive_card_outer', // 小外屏沉浸通知卡片
  IMMERSIVE_CAP = 'sl_immersive_capsule', // 沉浸胶囊
  IMMERSIVE_LIST_SHOW_AREA = 'sl_immersive_list_show_area', // 沉浸通知列表可见区域
  IMMERSIVE_LIST_FOR_ADO = 'sl_immersive_for_aod', // 沉浸通知列表截图区域
  IMMERSIVE_CAP_SHOW_AREA = 'sl_immersive_cap_show_area', // 沉浸胶囊列表可见区域
  IMMERSIVE_CAP_FOR_AOD = 'sl_immersive_cap_for_aod', // 沉浸胶囊列表截图区域
  IMMERSIVE_CARD_SHOW_AREA = 'sl_immersive_card_show_area', // 沉浸卡片可见区域
  IMMERSIVE_CARD_FOR_AOD = 'sl_immersive_card_for_aod', // 沉浸卡片截图区域
  IMMERSIVE_lIVE_CARD = 'sl_immersive_live_card', // 沉浸大卡中实况卡片ID
  FORM_BORDER = 'sl_form_border', // 卡片边框
  SL_GREET = 'sl_greet', // 问候
  AOD_BATTERY_ICON_SIGN = 'sl_aod_battery_icon_sign', // AOD电量图标-签名组件
  AOD_BATTERY_ICON_LUNAR = 'sl_aod_battery_icon_lunar', // AOD电量图标-农历组件
  AOD_BATTERY_ICON = 'sl_aod_battery_icon', // AOD电量图标-农历组件
}

/**
 * 锁屏首页各组件默认Z序
 */
export enum SlWidgetZIndex {
  DEFAULT_Z_INDEX_ART_SIGN = 5,
  Z_INDEX_CLOCK = 10,
  Z_INDEX_ART_SING_BELOW_DOF = 19, // 艺术签名情况下，艺术字可能在景深下面
  Z_INDEX_DOF_WALLPAPER = 20,
  Z_INDEX_CLOCK_UP_DOF = 21, // 艺术签名情况下，时钟可能在景深壁纸上面
  Z_INDEX_ART_SING_UP_DOF = 22, // 艺术签名情况下，艺术字可能在景深上面
  Z_INDEX_FORM = 31,
  Z_INDEX_BOTTOM_TOOLS = 39,
  Z_INDEX_QUICK_TOOLS_ICON = 40,
  Z_INDEX_CAMERA_ICON = 41,
  Z_INDEX_OUTER_FORM = 49,
  Z_INDEX_IMMERSIVE_LIST = 50,
  Z_INDEX_IMMERSIVE_CARD = 60,
  Z_INDEX_GREET = 59,
  Z_INDEX_LOCK_HEAD = 61,
  Z_INDEX_IMMERSIVE_CAP = 70,
  Z_INDEX_DROP_ANIMATION = 80,
}