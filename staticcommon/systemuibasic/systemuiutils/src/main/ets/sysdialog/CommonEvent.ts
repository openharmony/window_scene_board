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
 * 深色模式切换事件
 */
export class DarkModeEvent {
  public static readonly eventTypeName = 'DarkModeEvent';

  /**
   * 是否深色模式
   */
  isDarkMode: boolean = false;

  /**
   * 创建事件对象
   *
   * @returns 事件对象
   */
  static create(): DarkModeEvent {
    let event = new DarkModeEvent();
    return event;
  }
}

/**
 * 主题切换事件
 */
export class ThemeChangeEvent {
  public static readonly eventTypeName = 'ThemeChangeEvent';

  /**
   * 是否切换主题
   */
  isThemeChanged?: boolean = false;

  /**
   * 创建事件对象
   *
   * @returns 事件对象
   */
  static create(): ThemeChangeEvent {
    let event = new ThemeChangeEvent();
    return event;
  }
}

/**
 * 前台应用事件
 */
export class ForegroundAppEvent {
  public static readonly eventTypeName = 'ForegroundAppEvent';

  /**
   * 前台应用包名集
   */
  bundleNames: Array<string> = [];

  /**
   * 前台应用uid集
   */
  uidList: Array<number> = [];

  /**
   * 页面状态：使用abilityStage的参数
   */
  switchAbilityState?: number;

  /**
   * 创建事件对象
   *
   * @returns 事件对象
   */
  static create(): ForegroundAppEvent {
    let event = new ForegroundAppEvent();
    event.bundleNames = new Array();
    event.uidList = new Array();
    return event;
  }
}

/**
 * 胶囊拓展态事件
 */
export class CapsuleExtendChangeEvent {
  public static readonly eventTypeName = 'CapsuleExtendChangeEvent';

  /**
   * 当前胶囊是否为拓展态
   */
  isExtending: boolean = false;

  /**
   * 创建事件对象
   *
   * @returns 事件对象
   */
  static create(): CapsuleExtendChangeEvent {
    let event = new CapsuleExtendChangeEvent();
    return event;
  }
}

/**
 * 横幅切换事件
 */
export class HeadsUpChangeEvent {
  public static readonly eventTypeName = 'HeadsUpChangeEvent';

  /**
   * 当前弹出横幅应用包名
   */
  bundleName?: string;

  /**
   * 当前弹出横幅通知唯一标示
   * 非null表示当前弹出横幅面板
   */
  hashCode?: string;

  /**
   * 创建事件对象
   *
   * @returns 事件对象
   */
  static create(): HeadsUpChangeEvent {
    let event = new HeadsUpChangeEvent();
    return event;
  }
}

/**
 * 飞行模式状态切换事件
 */
export class AirplaneStateEvent {
  public static eventTypeName: string = 'AirplaneStateEvent';
  /**
   * 飞行模式状态
   */
  public airplaneState: boolean = false;

  getAirplaneState(): boolean {
    return this.airplaneState;
  }

  private static eventInstance: AirplaneStateEvent;

  public static getInstance(airplaneState: boolean): AirplaneStateEvent {
    if (!AirplaneStateEvent.eventInstance) {
      AirplaneStateEvent.eventInstance = new AirplaneStateEvent();
    }
    AirplaneStateEvent.eventInstance.airplaneState = airplaneState;
    return AirplaneStateEvent.eventInstance;
  }
}

export class StaticBlurEvent {
  public static readonly eventTypeName = 'StaticBlurEvent';

  command?: number;

  public setValue(command: number): void {
    this.command = command;
  }
}

/**
 * 控制中心动画进程事件
 */
export class ControlCenterAnimatingEvent {
  public static eventTypeName: string = 'ControlCenterAnimatingEvent';
  /**
   * 动画进程状态
   */
  controlCenterAnimating: boolean = false;
}

/**
 * 自动亮度切换事件
 */
export class AutoBrightnessEvent {
  public static eventTypeName: string = 'AutoBrightnessEvent';
  /**
   * 自动亮度状态
   */
  public autoBrightness: boolean = false;
}

/**
 * 控制中心背景degree刷新事件
 */
export class ControlCenterBackgroundDegreeEvent {
  public static eventTypeName: string = 'ControlCenterBackgroundDegreeEvent';
  /**
   * 背景degree
   */
  controlCenterDegree: number = -1;
}