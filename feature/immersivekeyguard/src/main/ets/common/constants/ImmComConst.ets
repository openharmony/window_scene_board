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

import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { AnimEvent } from '@ohos/screenlockcommon/Index';

// AOD截图使用组件层级
export enum ImmAodZIndex {
  // 保持AOD截图组件顶层
  INDEX_AOD_VIEW = 9999
}

/**
 * 沉浸模块通用动效场景
 */
export enum ImmComAnimScene {
  // 无动效
  ANIM_NONE = 'capsule_anim_none',
  // 胶囊过渡列表固定动效
  ANIM_CAP_LIST_FIX = 'capsule_to_list_fix',
  // 胶囊上滑过渡列表
  ANIM_CAP_LIST_TOUCH = 'capsule_to_list_touch',
  // 胶囊上滑过渡列表阈值不足回弹
  ANIM_CAP_LIST_TOUCH_BACK = 'capsule_to_list_touch_back',
  // 列表过渡胶囊固定动效
  ANIM_LIST_CAP_FIX = 'list_to_capsule_fix',
  // 列表下滑过渡胶囊
  ANIM_LIST_CAP_TOUCH = 'list_to_capsule_touch',
  // 列表下滑过渡胶囊阈值不足回弹
  ANIM_LIST_CAP_TOUCH_BACK = 'list_to_capsule_touch_back',
  // 胶囊过渡大卡
  ANIM_CAP_CARD = 'capsule_to_card',
  // 大卡过渡胶囊
  ANIM_CARD_CAP = 'card_to_capsule',
  // 胶囊大卡互切
  ANIM_CAP_CARD_SWITCH = 'card_to_capsule_switch',
  // 列表过渡大卡
  ANIM_LIST_CARD = 'scene_list_to_card',
  // 大卡过渡列表
  ANIM_CARD_LIST = 'scene_card_to_list',
  // 外屏实况列表过渡沉浸大卡
  ANIM_LIVE_LIST_CARD = 'scene_live_list_to_card',
  // 外屏沉浸大卡过渡实况列表
  ANIM_CARD_LIVE_LIST = 'scene_card_to_live_list',
  // 外屏沉浸大卡过渡实况胶囊
  ANIM_CARD_LIVE_CAP = 'scene_card_to_live_cap',
}

// 配置名-胶囊过渡大卡
export enum CfgNameCapCard {
  CFG_INIT = 'cap_to_card_init',
  CFG_FINISH = 'cap_to_card_finish',
  CFG_END_ALPHA = 'cap_to_card_end_alpha',
  CFG_END_MAIN = 'cap_to_card_end_main',
}

// 配置名-大卡过渡胶囊
export enum CfgNameCardCap {
  CFG_INIT = 'card_to_cap_init',
  CFG_FINISH = 'card_to_cap_finish',
  CFG_END_ALPHA = 'card_to_cap_end_alpha',
  CFG_END_MAIN = 'card_to_cap_end_main',
}

// 配置名-胶囊大卡互切
export enum CfgNameCapCardSwitch {
  CFG_INIT = 'cap_card_switch_init',
  CFG_FINISH = 'cap_card_switch_finish',
  CFG_END_ALPHA = 'cap_card_switch_end_alpha',
  CFG_END_MAIN = 'cap_card_switch_end_main',
}

// 配置名-列表过渡大卡
export enum CfgNameListCard {
  CFG_INIT = 'list_to_card_init',
  CFG_FINISH = 'list_to_card_finish',
  CFG_END_ALPHA = 'list_to_card_end_alpha',
  CFG_END_CLICK_SCALE = 'list_to_card_end_click_scale',
  CFG_END_MAIN = 'list_to_card_end_main',
}

// 配置名-大卡过渡列表
export enum CfgNameCardList {
  CFG_INIT = 'card_to_list_init',
  CFG_FINISH = 'card_to_list_finish',
  CFG_END_ALPHA = 'card_to_list_end_alpha',
  CFG_END_MAIN = 'card_to_list_end_main',
}

// 配置名-胶囊过渡列表
export enum CfgNameCapList {
  CFG_INIT = 'cap_to_list_init',
  CFG_FINISH = 'cap_to_list_finish',
  CFG_END_ALPHA = 'cap_to_list_end_alpha',
  CFG_END_MAIN = 'cap_to_list_end_main',
}

// 配置名-列表过渡胶囊
export enum CfgNameListCap {
  CFG_INIT = 'list_to_cap_init',
  CFG_FINISH = 'list_to_cap_finish',
  CFG_END_ALPHA = 'list_to_cap_end_alpha',
  CFG_END_MAIN = 'list_to_cap_end_main',
}

// 配置名-实况列表过渡沉浸大卡
export enum CfgNameLiveListCard {
  CFG_INIT = 'live_list_to_card_init',
  CFG_FINISH = 'live_list_to_card_finish',
  CFG_END_ALPHA = 'live_list_to_card_end_alpha',
  CFG_END_MAIN = 'live_list_to_card_end_main',
}

// 配置名-沉浸大卡过渡实况列表
export enum CfgNameCardLiveList {
  CFG_INIT = 'card_to_live_list_init',
  CFG_FINISH = 'card_to_live_list_finish',
  CFG_END_ALPHA = 'card_to_live_list_end_alpha',
  CFG_END_MAIN = 'card_to_live_list_end_main',
}

// 配置名-沉浸大卡过渡实况胶囊
export enum CfgNameCardLiveCap {
  CFG_INIT = 'card_to_live_cap_init',
  CFG_FINISH = 'card_to_live_cap_finish',
  CFG_END_ALPHA = 'card_to_live_cap_end_alpha',
  CFG_END_MAIN = 'card_to_live_cap_end_main',
}

// 联合动效扩展参数
export interface HybridAnimParam {
  // 动效场景
  animScene: ImmComAnimScene;
  // 动效速度
  vel?: number;
  // 跳过动效数据标识
  skipGroupKey?: string;
  // 动效结束回调
  onFinish?: AnimEvent;
}

// 坐标点热区检测参数
export interface PointCheckParam {
  globalX: number,
  globalY: number,
  slStMgr?: SlStateMgr
}