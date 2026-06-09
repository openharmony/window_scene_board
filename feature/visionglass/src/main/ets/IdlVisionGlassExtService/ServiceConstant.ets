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
 * request response
 */
export enum ServiceResponse {
  /**
   * request success
   */
  SUCCESS = 'OK',

  /**
   * request fail
   */
  FAIL = 'FAIL',

  /**
   * action is null or undefined
   */
  INVALID_ACTION_ERROR = 'INVALID ACTION',

  /**
   * no executor to execute action
   */
  UNKNOWN_ACTION_ERROR = 'UNKNOWN ACTION',
}

/**
 * request actions
 */
export enum RequestAction {
  /**
   * 最小化应用窗口
   */
  MINIMIZE_ALL_SCENE = 'minimizeScene',
  /**
   * 处理侧滑事件
   */
  PROCESS_BACK_EVENT = 'processBackEvent',
  /**
   * 打开窗口
   */
  START_SCENE = 'startScene',
  /*
   * 更新应用白名单
   * */
  UPDATE_APP_WHITE_LIST = 'updateAppWhiteList',
  /**
   * 设置手势使能
   */
  SET_GESTURE_ENABLED = 'setGestureNavigationEnabled',
}