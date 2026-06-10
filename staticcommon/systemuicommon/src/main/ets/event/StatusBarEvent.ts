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
import { PluginSlot } from '@ohos/frameworkwrapper';

export enum StatusBarEventType {
  /**
   * 状态栏隐藏
   */
  STATUS_BAR_HIDE = 'status_bar_hide',
  /**
   * 小外屏应用内隐藏状态栏
   */
  STATUS_BAR_HIDE_IN_APP = 'status_bar_hide_in_app',
  /**
   * 小外屏进沉浸式显隐状态栏
   */
  STATUS_BAR_HIDE_IN_IMMER = 'status_bar_hide_in_immer'
}

/**
 * 图标宽度变化事件
 */
export class PluginWidthChangeEvent {
  public static readonly eventTypeName = 'PluginWidthChangeEvent';
  /**
   * plugin图标唯一标示
   */
  public pluginSlot: string = '';
  /**
   * plugin图标宽度
   */
  private width: number = 0;

  /**
   * plugin图标宽度变化值
   */
  private changeDelta: number = 0;

  public setWidth(value: number): void {
    this.changeDelta = value - this.width;
    this.width = value;
  }

  public getWidth(): number {
    return this.width;
  }

  public getChangeDelta(): number {
    return this.changeDelta;
  }


  static create(slot: string, width: number): PluginWidthChangeEvent {
    let event = new PluginWidthChangeEvent();
    event.pluginSlot = slot;
    event.width = width;
    event.changeDelta = 0;
    return event;
  }
}

/**
 * 状态栏类型变化事件
 */
export class StatusBarTypeChangeEvent {

  public static readonly eventTypeName = 'StatusBarTypeChangeEvent';
  public statusBarType: number = 2;
}

/**
 * 单手模式变化事件
 */
export class SingleHandModeChangeEvent {
  public static readonly eventTypeName = 'SingleHandModeChangeEvent';
  public isSingleHandMode: boolean = false;
  public mode: string = '';
  public scale: number = 0;
  public singleHandX: number = 0;
  public singleHandY: number = 0;
  public singleHandW: number = 0;
  public singleHandH: number = 0;
}

/**
 * 状态栏显示隐藏变化事件
 */
export class StatusBarShowHideChangeEvent {
  public static readonly eventTypeName = 'StatusBarShowHideChangeEvent';
  public isShow: boolean = true;

  static create(isShow: boolean): StatusBarShowHideChangeEvent {
    let event = new StatusBarShowHideChangeEvent();
    event.isShow = isShow;
    return event;
  }
}

/**
 * 状态栏Tips变化事件
 */
export class StatusBarTipsChangeEvent {
  public static readonly eventTypeName = 'StatusBarTipsChangeEvent';
  public slot: string = '';
  public tips: string = '';

  static create(slot: string, tips: string): StatusBarTipsChangeEvent {
    let event = new StatusBarTipsChangeEvent();
    event.slot = slot;
    event.tips = tips;
    return event;
  }
}

Object.defineProperty(StatusBarTipsChangeEvent, 'eventTypeName', { value: 'StatusBarTipsChangeEvent' });

/**
 * 状态栏布局完成事件
 */
export class StatusBarLayoutFinishedEvent {
  isFinished: boolean;
}

Object.defineProperty(StatusBarLayoutFinishedEvent, 'eventTypeName', { value: 'StatusBarLayoutFinishedEvent' });

/**
 * pad鼠标点击下拉双中心事件，屏蔽onTouch的进度check
 */
export class MouseClickDropDownEvent {

}

Object.defineProperty(MouseClickDropDownEvent, 'eventTypeName', { value: 'MouseClickDropDownEvent' });

/**
 * 状态栏避让高度变化事件
 */
export class StatusBarAvoidHeightChangeEvent {
  /**
   * 状态栏避让高度
   */
  public avoidHeight: number = 0;

  static create(avoidHeight: number): StatusBarAvoidHeightChangeEvent {
    let event = new StatusBarAvoidHeightChangeEvent();
    event.avoidHeight = avoidHeight;
    return event;
  }
}

Object.defineProperty(StatusBarAvoidHeightChangeEvent, 'eventTypeName', { value: 'StatusBarAvoidHeightChangeEvent' });

/**
 * 运营商、时间切换事件
 */
export class OperatorClockChangeEvent {
  /**
   * 是否展示时间
   */
  public isShowClock: boolean;

  constructor(isShowClock: boolean) {
    this.isShowClock = isShowClock;
  }
}

Object.defineProperty(OperatorClockChangeEvent, 'eventTypeName', { value: 'OperatorClockChangeEvent' });

/**
 * 状态栏图标特殊显示规则事件
 */
export class SpecialIconEvent {
  /**
   *  图标是否可在非下拉场景显示
   */
  public isCanShowInLauncherStatusBar: boolean;

  /**
   * 图标名称
   */
  public pluginName: string;

  /**
   * 创建事件
   */
  static create(pluginName: string, isCanShow: boolean): SpecialIconEvent {
    let event = new SpecialIconEvent();
    event.isCanShowInLauncherStatusBar = isCanShow;
    event.pluginName = pluginName;
    return event;
  }
}
Object.defineProperty(SpecialIconEvent, 'eventTypeName', { value: 'SpecialIconEvent'});

/**
 * 通知状态栏栏显示隐藏
 */
export class NotifyStatusBarShowHideEvent {
  /**
   * 显隐标记
   */
  flag: boolean;
  /**
   * 是否使用动效
   */
  enableAnimation: boolean;

  constructor(flag: boolean, enableAnimation: boolean) {
    this.flag = flag;
    this.enableAnimation = enableAnimation;
  }
}

Object.defineProperty(NotifyStatusBarShowHideEvent, 'eventTypeName', { value: 'NotifyStatusBarShowHideEvent' });

/*
 * 状态栏显示蒙层事件
 */
export class StatusBarBlurEvent {
  public static readonly eventTypeName = 'StatusBarBlurEvent';

  public isShowBlur = false;

  public enableBlurTransition = false;

  constructor(isShowBlur: boolean, enableBlurTransition: boolean = true) {
    this.isShowBlur = isShowBlur;
    this.enableBlurTransition = this.enableBlurTransition;
  }
}

/**
 * 2.0录屏事件
 */
export class ScreenRecordEvent {
  public static readonly eventTypeName = 'ScreenRecordEvent';

  /**
   * 录屏胶囊状态
   */
  public status: boolean;
  /**
   * 录屏胶囊背景色
   */
  public color: string;

  constructor(status: boolean, color: string) {
    this.status = status;
    this.color = color;
  }
}