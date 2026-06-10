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
 * 多任务操作手势事件
 */
export enum RecentGestureEvent {
  //应用手势触发跟手
  ENTER_ZOOM_FOLLOWING,
  //桌面手势触发多任务跟手动效
  ENTER_RECENT_FOLLOWING_FROM_HOME,
  //应用手势触发多任务跟手动效
  ENTER_RECENT_FOLLOWING_FROM_APP,
  //桌面手势触发快切跟手动效
  ENTER_QUICK_SWITCH_FOLLOWING_FROM_HOME,
  //应用手势触发快切跟手动效
  ENTER_QUICK_SWITCH_FOLLOWING_FROM_APP,
  //桌面手势松手进入多任务
  ENTER_RECENT_IDLE_FROM_HOME,
  //桌面手势松手进入快切应用
  ENTER_QUICK_SWITCH_IDLE_FROM_HOME,
  //应用手势松手进入多任务
  ENTER_RECENT_IDLE_FROM_APP,
  //应用手势松手进入快切应用
  ENTER_QUICK_SWITCH_IDLE_FROM_APP,
  //多任务跟手反悔进入应用
  ENTER_APP_IDLE_FROM_RECENT_FOLLOWING,
  //快切跟手反悔进入应用
  ENTER_APP_IDLE_FROM_QUICK_SWITCH_FOLLOWING,
  //应用跟手反悔进入应用
  ENTER_APP_IDLE_FROM_ZOOM_FOLLOWING,
  //从多任务启动应用
  START_SCENE_FROM_RECENT,
  //应用手势上滑回桌面开始
  ENTER_HOME_IDLE_START,
  //应用手势上滑回桌面结束
  ENTER_HOME_IDLE_END,
  //手势开始事件
  GESTURE_ACTION_START,
  //手势结束事件
  GESTURE_ACTION_END,
  //多任务跟手反悔进入应用动效结束
  ENTER_APP_IDLE_FROM_RECENT_FOLLOWING_END,
  //快切跟手反悔进入应用动效结束
  ENTER_APP_IDLE_FROM_QUICK_SWITCH_FOLLOWING_END,
  //应用跟手反悔进入应用动效结束
  ENTER_APP_IDLE_FROM_ZOOM_FOLLOWING_END,
  //应用上滑进入多任务动效结束
  ENTER_RECENT_IDLE_FROM_APP_END,
  //快切手势松手后动效结束
  ENTER_QUICK_SWITCH_IDLE_FROM_APP_END,
  //从多任务启动应用动效结束
  START_SCENE_FROM_RECENT_END,
  //多任务一键清理开始
  CLEAR_ALL_MISSIONS_START,
  //多任务一键清理动效结束
  CLEAR_ALL_MISSIONS_END,
  //一步手势进入中景开始
  ENTER_APP_MID,
  //一步手势进入中景动效结束
  ENTER_APP_MID_END,
  //一步手势进入分屏开始
  ENTER_APP_SPLIT,
  //一步手势进入分屏动效结束
  ENTER_APP_SPLIT_END,
  //一步手势进入悬浮窗开始
  ENTER_APP_FLOAT,
  //一步手势进入悬浮窗动效结束
  ENTER_APP_FLOAT_END,
  //收到锁屏回调
  ON_LOCK_RECEIVED,
}

/**
 * 上报给RSS的手势事件
 */
export enum RSSGestureEvent {
  GESTURE_ACTION_START,
  GESTURE_ACTION_END,
  ENTER_RECENT_START,
  ENTER_RECENT_END,
  ENTER_APP_START,
  ENTER_APP_END,
  ENTER_HOME_START,
  ENTER_HOME_END,
  ENTER_APP_MID,
  ENTER_APP_MID_END,
  ENTER_APP_SPLIT,
  ENTER_APP_SPLIT_END,
  ENTER_APP_FLOAT,
  ENTER_APP_FLOAT_END,
}

/**
 * 公共事件通知事件
 */
export enum CommonGestureEvent {
  ENTER_ZOOM_FOLLOWING,
  CLEAR_ALL_MISSIONS_START,
  ENTER_RECENT_FOLLOWING_FROM_HOME
}
