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
 * 沉浸锁屏固定动效标识
 */
export enum ImmersiveAnimKey {
  /**
   * 沉浸列表
   */
  IMMERSIVE_LIST_ROOT = 'immersive_list_root',

  /**
   * 沉浸胶囊
   */
  IMMERSIVE_CAPSULE_ROOT = 'immersive_capsule_root',

  /**
   * 沉浸卡片页面
   */
  IMMERSIVE_CARD_ROOT = 'immersive_card_root'
}

/**
 * 沉浸锁屏动效场景列举
 */
export enum ImmersiveAnimScene {
  /**
   * 固定动效，胶囊过渡到列表
   */
  SCENE_CAPSULE_TO_LIST_FIX = 'capsule_to_list_fix',

  /**
   * 跟手动效，胶囊过渡到列表
   */
  SCENE_CAPSULE_TO_LIST_TOUCH = 'capsule_to_list_touch',

  /**
   * 胶囊过渡到列表跟手动效阈值不足，恢复动效
   */
  SCENE_CAPSULE_TO_LIST_TOUCH_BACK = 'capsule_to_list_touch_back',

  /**
   * 固定动效，列表过渡到胶囊
   */
  SCENE_LIST_TO_CAPSULE_FIX = 'list_to_capsule_fix',

  /**
   * 跟手动效，列表过渡到胶囊
   */
  SCENE_LIST_TO_CAPSULE_TOUCH = 'list_to_capsule_touch',

  /**
   * 列表过渡到胶囊跟手动效阈值不足，恢复动效
   */
  SCENE_LIST_TO_CAPSULE_TOUCH_BACK = 'list_to_capsule_touch_back',

  /**
   * 通知列表到卡片动效
   */
  SCENE_LIST_TO_CARD = 'scene_list_to_card',

  /**
   * 时间卡片到列表动效
   */
  SCENE_CARD_TO_LIST = 'scene_card_to_list',

  /**
   * 胶囊根布局出现动效
   */
  SCENE_CAPSULE_ROOT_SHOW = 'capsule_root_show',

  /**
   * 胶囊根布局消失动效
   */
  SCENE_CAPSULE_ROOT_HIDE = 'capsule_root_hide',

  /**
   * 胶囊新增通知堆叠动效
   */
  SCENE_CAPSULE_STACK_SHOW = 'capsule_stack_show',

  /**
   * 胶囊堆叠移除通知动效
   */
  SCENE_CAPSULE_STACK_REMOVE = 'capsule_stack_remove',

  /**
   * 胶囊阴影移除动效
   */
  SCENE_CAPSULE_SHADOW_REMOVE = 'capsule_shadow_remove',

  /**
   * 胶囊顶部更新动效
   */
  SCENE_CAPSULE_TOP_UPDATE = 'capsule_top_update',

  /**
   * 胶囊强提醒动效
   */
  SCENE_CAPSULE_REMIND = 'capsule_remind',

  /**
   * 胶囊强提醒退出动效
   */
  SCENE_CAPSULE_REMIND_EXIT = 'capsule_remind_exit',

  /**
   * 沉浸卡片更新
   */
  SCENE_CARD_UPDATE = 'scene_card_update',

  /**
   * 点击胶囊头像或长按胶囊进入沉浸态动效
   */
  SCENE_CAPSULE_TO_CARD = 'capsule_to_card',

  /**
   * 沉浸卡片回到胶囊动效
   */
  SCENE_CARD_TO_CAPSULE = 'card_to_capsule',

  SCENE_CARD_DELETE = 'card_to_delete', // 沉浸卡片删除场景

  SCENE_LIST_ALIGN_CHANGE = 'list_align_change', // 列表顶部、底部对齐切换

  SCENE_BACK_BTN_APPEAR = 'back_btn_appear', // 沉浸卡片返回按钮渐显场景
}

/**
 * 沉浸锁屏通知性能打点
 */
export enum ImmersivePfmConstant {
  /**
   * 沉浸锁屏胶囊展开到列表动效
   */
  SCENE_CAP_TO_LIST_ANIM = 'SCENE_CAP_TO_LIST_ANIM',

  /**
   * 沉浸锁屏列表收起到胶囊动效
   */
  SCENE_LIST_TO_CAP_ANIM = 'SCENE_LIST_TO_CAP_ANIM',

  /**
   * 沉浸胶囊展开到沉浸卡片动效
   */
  SCENE_CAP_TO_CARD_ANIM = 'SCENE_CAP_TO_CARD_ANIM',

  /**
   * 沉浸卡片收起到沉浸胶囊动效
   */
  SCENE_CARD_TO_CAP_ANIM = 'SCENE_CARD_TO_CAP_ANIM',

  /**
   * 沉浸锁屏列表上下滑动动效
   */
  SCENE_LIST_SWIPE_ANIM = 'SCENE_LIST_SWIPE_ANIM'
}


/**
 * 沉浸通知场景
 */
export enum ImmersiveNtfScene {
  /**
   * 通知新增
   */
  SCENE_NTF_ADD = 0x01,

  /**
   * 通知更新
   */
  SCENE_NTF_UPDATE = 0x02,

  /**
   * 通知删除
   */
  SCENE_NTF_REMOVE = 0x04
}