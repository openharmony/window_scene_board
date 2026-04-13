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
 * 场景标示
 */
export enum SceneFlag {
  /**
   * 锁屏场景
   */
  SCENE_LOCK_SCREEN = 'scene_lock_screen',

  /**
   * 横幅释放场景
   */
  SCENE_RELEASE_HEADS_UP = 'scene_release_heads_up',

  /**
   * 实况面板释放场景
   */
  SCENE_RELEASE_LIVE_LIST = 'scene_release_live_list',

  /**
   * 胶囊列表释放场景
   */
  SCENE_RELEASE_CAPSULE_LIST = 'scene_release_capsule_list',

  /**
   * 实况面板释放，点击条目场景
   */
  SCENE_RELEASE_LIVE_LIST_BY_CLICK_ITEM = 'scene_release_live_list_by_click_item',

  /**
   * 实况面板释放，下拉通知、控制中心面板场景
   */
  SCENE_RELEASE_LIVE_LIST_BY_DROP_DOWN = 'scene_release_live_list_by_drop_down',

  /**
   * 实况面板释放，熄屏场景
   */
  SCENE_RELEASE_LIVE_LIST_BY_SCREEN_OFF = 'scene_release_live_list_by_screen_off',

  /**
   * 实况面板释放，数据清空场景
   */
  SCENE_RELEASE_LIVE_LIST_BY_EMPTY_DATA = 'scene_release_live_list_by_empty_data',

  /**
   * 折叠外屏实况列表释放
   */
  SCENE_RELEASE_LIVE_LIST_BY_IMMERSIVE = 'scene_release_live_list_by_immersive',

  /**
   * 折叠外屏实况列表展开
   */
  SCENE_REQUEST_LIVE_LIST_BY_IMMERSIVE = 'scene_request_live_list_by_immersive',
}