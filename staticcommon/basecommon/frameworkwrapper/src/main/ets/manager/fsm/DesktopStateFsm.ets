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

import { CoreEventType, FsmName, StateType } from './SceneBoardStateConfig';
import { StateFsm, AbstractState } from './StateFsm';

/**
 * 应用前台状态
 */
class AppOpenState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.CLOSE_APP:
        return StateType.DESKTOP_DEFAULT;
      case CoreEventType.ENTER_RECENT:
        return StateType.RECENT;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'AppOpenState';
  }
}

/**
 * 多任务状态
 */
class RecentState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.OPEN_APP:
        return StateType.APP_OPEN;
      case CoreEventType.EXIT_RECENT:
        return StateType.DESKTOP_DEFAULT;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'RecentState';
  }
}

/**
 * 桌面默认状态
 */
class DesktopDefaultState extends AbstractState {
  /**
   * 处理事件
   *
   * @param event 事件
   * @param args 额外参数，用以辅助判断跳转到哪一个状态
   * @returns 下一状态
   */
  public handleEvent(event: CoreEventType, ...args: Object[]): StateType {
    switch (event) {
      case CoreEventType.ENTER_RECENT:
        return StateType.RECENT;
      case CoreEventType.OPEN_APP:
        return StateType.APP_OPEN;
      default:
        return this.stateType;
    }
  }

  public toString(): string {
    return 'DesktopDefaultState';
  }
}

/**
 * 桌面子状态机定义
 */
export class DesktopStateFsm extends StateFsm {
  constructor() {
    super(FsmName.DESKTOP_FSM, new DesktopDefaultState(StateType.DESKTOP_DEFAULT));
  }

  /**
   * 初始化
   */
  public init(): void {
    this.addState(new DesktopDefaultState(StateType.DESKTOP_DEFAULT))
      .addState(new AppOpenState(StateType.APP_OPEN))
      .addState(new RecentState(StateType.RECENT));
  }
}