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

import { CoreEventType, FsmName, StateType } from './SceneBoardStateConfig';
import { StateFsm, AbstractState } from './StateFsm';

/**
 * 开机时的初始状态
 */
class InitState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.ENTER_DESKTOP:
        return StateType.DESKTOP;
      case CoreEventType.ENTER_SCREEN_LOCK:
        return StateType.SCREEN_LOCK;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'InitState';
  }
}

/**
 * AOD状态
 */
class AODState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    if (event === CoreEventType.ENTER_SCREEN_LOCK) {
      return StateType.SCREEN_LOCK;
    } else {
      return this.stateType;
    }
  }

  public toString(): string {
    return 'AODState';
  }
}

/**
 * 锁屏状态
 */
class ScreenLockState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.ENTER_DESKTOP:
        return StateType.DESKTOP;
      case CoreEventType.OPEN_CONTROL_CENTER:
        return StateType.SCREEN_LOCK_DROPDOWN;
      case CoreEventType.ENTER_AOD:
        return StateType.AOD;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'ScreenLockState';
  }
}

/**
 * 锁屏下拉控制中心状态
 */
class ScreenLockDropDownState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.ENTER_DESKTOP:
        return StateType.DESKTOP;
      case CoreEventType.CLOSE_CONTROL_CENTER:
        return StateType.SCREEN_LOCK;
      case CoreEventType.ENTER_AOD:
        return StateType.AOD;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'ScreenLockDropDownState';
  }
}

/**
 * 桌面状态
 */
class DesktopState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.OPEN_CONTROL_CENTER:
        return StateType.DESKTOP_DROPDOWN;
      case CoreEventType.ENTER_SCREEN_LOCK:
        return StateType.SCREEN_LOCK;
      case CoreEventType.OPEN_DESKTOP_FOLDER:
        return StateType.DESKTOP_FOLDER;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'DesktopState';
  }
}

/**
 * 桌面打开文件夹状态
 */
class DesktopOpenFolderState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.OPEN_CONTROL_CENTER:
        return StateType.DESKTOP_FOLDER_DROPDOWN;
      case CoreEventType.ENTER_SCREEN_LOCK:
        return StateType.SCREEN_LOCK;
      case CoreEventType.CLOSE_DESKTOP_FOLDER:
        return StateType.DESKTOP;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'DesktopOpenFolderState';
  }
}

/**
 * 桌面下拉控制中心状态
 */
class DesktopDropDownState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.CLOSE_CONTROL_CENTER:
        return StateType.DESKTOP;
      case CoreEventType.ENTER_SCREEN_LOCK:
        return StateType.SCREEN_LOCK;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'DesktopDropDownState';
  }
}

/**
 * 桌面打开文件夹下拉控制中心状态
 */
class DesktopOpenFolderDropDownState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.CLOSE_CONTROL_CENTER:
        return StateType.DESKTOP_FOLDER;
      case CoreEventType.ENTER_SCREEN_LOCK:
        return StateType.SCREEN_LOCK;
      case CoreEventType.CLOSE_DESKTOP_FOLDER:
        return StateType.DESKTOP_DROPDOWN;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'DesktopOpenFolderDropDownState';
  }
}

/**
 * 基础状态机定义
 */
export class SceneBoardCoreStateFsm extends StateFsm {
  constructor() {
    super(FsmName.CORE_FSM, new InitState(StateType.INIT));
  }

  /**
   * 初始化
   */
  public init(): void {
    this.addState(new AODState(StateType.AOD))
      .addState(new ScreenLockState(StateType.SCREEN_LOCK))
      .addState(new ScreenLockDropDownState(StateType.SCREEN_LOCK_DROPDOWN))
      .addState(new DesktopState(StateType.DESKTOP))
      .addState(new DesktopOpenFolderState(StateType.DESKTOP_FOLDER))
      .addState(new DesktopDropDownState(StateType.DESKTOP_DROPDOWN))
      .addState(new DesktopOpenFolderDropDownState(StateType.DESKTOP_FOLDER_DROPDOWN));
  }
}