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
 * 定义：事件类型
 */
export enum CoreEventType {
  /**
   * 进入锁屏
   */
  ENTER_SCREEN_LOCK = 'ENTER_SCREEN_LOCK',

  /**
   * 进入桌面
   */
  ENTER_DESKTOP = 'ENTER_DESKTOP',

  /**
   * 进入AOD
   */
  ENTER_AOD = 'ENTER_AOD',

  /**
   * 下拉控制中心
   */
  OPEN_CONTROL_CENTER = 'OPEN_CONTROL_CENTER',

  /**
   * 收起控制中心
   */
  CLOSE_CONTROL_CENTER = 'CLOSE_CONTROL_CENTER',

  /**
   * 打开桌面大文件夹
   */
  OPEN_DESKTOP_FOLDER = 'OPEN_DESKTOP_FOLDER',

  /**
   * 关闭桌面大文件夹
   */
  CLOSE_DESKTOP_FOLDER = 'CLOSE_DESKTOP_FOLDER',

  /**
   * 进入应用全屏
   */
  OPEN_APP = 'OPEN_APP',

  /**
   * 退出应用全屏
   */
  CLOSE_APP = 'CLOSE_APP',

  /**
   * 进入多任务
   */
  ENTER_RECENT = 'ENTER_RECENT',

  /**
   * 退出多任务
   */
  EXIT_RECENT = 'EXIT_RECENT'
}

export enum FsmName {
  CORE_FSM = 'CoreFSM',
  SCREEN_LOCK_FSM = 'ScreenLockFSM',
  AOD_FSM = 'AodFSM',
  DESKTOP_FSM = 'DesktopFSM'
}

export enum StateType {
  // 异常状态
  ERROR = -1,
  // 初始状态
  INIT = 0,
  // AOD状态
  AOD = 1 << 0,
  // 锁屏状态
  SCREEN_LOCK = 1 << 1,
  // 桌面状态
  DESKTOP = 1 << 2,
  // 锁屏下拉控制中心状态
  SCREEN_LOCK_DROPDOWN = 1 << 3,
  // 桌面打开文件夹状态
  DESKTOP_FOLDER = 1 << 4,
  // 桌面下拉双中心状态
  DESKTOP_DROPDOWN = 1 << 5,
  // 桌面打开文件夹且下拉双中心状态
  DESKTOP_FOLDER_DROPDOWN = 1 << 6,
  // 桌面默认状态，用于桌面子状态
  DESKTOP_DEFAULT = 1 << 7,
  // 应用前台状态，用于桌面子状态
  APP_OPEN = 1 << 8,
  // 多任务状态，用于桌面子状态
  RECENT = 1 << 9
}