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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SingletonHelper } from '@ohos/basicutils';
import { AodElemPosition } from '../model/AodElemPosition';

const TAG = 'ThemeWallpaperAnimationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 主题引擎壁纸动效代理管理，用于状态切换时通知主题引擎执行对应的壁纸动效
 */
class ThemeWallpaperAnimationManager {
  private wallpaperProxy: WallpaperProxy = undefined;

  /**
   * 注册壁纸动效代理
   *
   * @param proxy 壁纸动效代理
   */
  registerWallpaperProxy(proxy: WallpaperProxy): void {
    log.showInfo('registerWallpaperProxy');
    if (proxy === undefined || proxy === null) {
      return;
    }
    this.wallpaperProxy = proxy;
  }

  /**
   * 注销壁纸动效代理
   *
   * @param proxy 壁纸动效代理
   */
  unRegisterWallpaperProxy(): void {
    log.showInfo('unRegisterWallpaperProxy');
    this.wallpaperProxy = null;
  }

  /**
   * 请求播放一镜到底壁纸动效
   *
   * @param param 动效参数
   */
  reqPlayWallpaperAnimation(param: WallPaperAnimationParam): void {
    log.showInfo('reqPlayWallpaperAnimation');
    this.wallpaperProxy?.sendCmd(param);
  }

  /**
   * 下发锁屏上的交互事件至主题引擎
   *
   * @param info 事件信息
   */
  sendInteractiveEvent2Wallpaper(event: InteractiveEvent): void {
    log.showInfo('sendInteractiveEvent');
    this.wallpaperProxy?.sendInteractiveEvent(event);
  }

  /**
   * 下发桌面上的交互事件至主题引擎
   *
   * @param event 事件信息
   */
  sendHomeInteractiveEvent2Wallpaper(event: InteractiveEvent): void {
    log.showInfo(TAG, 'sendHomeInteractiveEvent');
    this.wallpaperProxy?.sendHomeInteractiveEvent(event);
  }

  /**
   * 下发锁屏状态改变事件至主题引擎
   *
   * @param event 锁屏状态
   */
  sendMainPageStateChangeEvent2Wallpaper(event: MainPageStateEvent): void {
    log.showInfo('MainPageStateChangeEvent');
    this.wallpaperProxy?.sendMainPageStateChangeEvent(event);
  }

  /**
   * PC场景请求动态壁纸动效
   *
   * @param param 动效参数
   */
  sendAnimationInfo2Wallpaper(info: AnimationInfo): void {
    log.showInfo('sendDynamicAnimationInfo');
    this.wallpaperProxy?.sendAnimation(info);
  }

  /**
   * AOD压暗更新
   */
  aodUpdate(): void {
    log.showInfo('aodUpdate');
    this.wallpaperProxy?.aodUpdate();
  }

  /**
   * 触发手势回调
   *
   * @param enable 使能
   * @param callback 回调函数
   */
  reqEnableGesture(enable: boolean, callback: (clockCollapse: boolean) => void): number {
    log.showInfo('reqEnableGesture');
    return this.wallpaperProxy?.enableGesture(enable, callback);
  }

  /**
   * 获取aod背景位置
   * @param aodPosition 位置参数
   */
  syncAodPosition(aodPosition: AodElemPosition):void {
    this.wallpaperProxy?.syncAodPosition(aodPosition);
  }

  /**
   * 发送主题场景更新事件
   *
   * @param {string} event - 事件名称
   * @param {() => void} callBack - 更新事件完场回调函数
   */
  sendUpdateThemeSceneEvent(event: string, callBack: () => void): void {
    this.wallpaperProxy?.sendUpdateThemeSceneEvent(event, callBack);
  }

  /**
   * 发送实况通知事件变化
   *
   * @param {number} eventType - 事件的类型1-创建，2-更新，3-取消
   * @param {string} hashCode - 事件的唯一标识符
   * @param {string} event - 事件的名称
   * @param {number} status - 事件的状态
   */
  sendLiveViewEvent(eventType: number, hashCode: string, event: string, status: number): void {
    this.wallpaperProxy?.sendLiveViewEvent(eventType, hashCode, event, status);
  }

  /**
   * AOD发送获取时钟信息的消息，接收回调
   *
   * @param { () => void } callBack - Base图截图完成后触发回调函数
   */
  updateClockBaseImage(callBack: () => void): void {
    this.wallpaperProxy?.updateClockBaseImage(callBack);
  }

  /**
   * 冻结主题引擎
   *
   * @param 冻结原因
   */
  freezeThemeEngine(freezeReason?: ThemeFreezeReason): void {
    this.wallpaperProxy?.freezeThemeEngine(freezeReason);
  }

  /**
   * 解冻主题引擎
   *
   * @param 冻结原因
   */
  unfreezeThemeEngine(freezeReason?: ThemeFreezeReason): void {
    this.wallpaperProxy?.unfreezeThemeEngine(freezeReason);
  }
}

/**
 * 主题引擎壁纸动效参数
 */
export class WallPaperAnimationParam {
  curState: DynamicWallPaperState;
  tarState: DynamicWallPaperState;
  isOffScreenSupportAod: boolean;
  onFinish: () => void;
  isPlayingAnimation: boolean;
  isSafeMode?: boolean; // 坚盾模式
}

/**
 * 主题引擎壁纸状态
 */
export enum DynamicWallPaperState {
  DEFAULT = 0,
  SCREENLOCK = 1,
  DESKTOP = 2,
  AOD = 3,
  SCREEN_ON = 4,
  PROXIMITY_SCREEN_ON = 5,
  PROXIMITY_SCREEN_OFF = 6,
  LID_OPEN = 7,
  DOUBLE_CLICK = 8,
  DROPDOWN_PANEL_DOWN = 9,
  DROPDOWN_PANEL_UP = 10,
  GlobalSearch_DOWN = 11,
  GlobalSearch_UP = 12,
  SOURCE_MODE_MAIN = 13,
  SOURCE_MODE_EXTEND = 14,
}

/**
 * 主题引擎通信代理接口
 */
export interface WallpaperProxy {
  sendCmd: (param: WallPaperAnimationParam) => void;
  sendInteractiveEvent: (event: InteractiveEvent) => void;
  sendHomeInteractiveEvent: (event: InteractiveEvent) => void;
  sendMainPageStateChangeEvent: (event: MainPageStateEvent) => void;
  sendAnimation:(info: AnimationInfo) => void;
  aodUpdate: () => void;
  enableGesture: (enable: boolean, gestureMotionCallback: (clockCollapse: boolean) => void) => number;
  syncAodPosition: (aodPosition: AodElemPosition) => void;
  sendUpdateThemeSceneEvent: (event: string, completeCallBackFunc: () => void) => void;
  sendLiveViewEvent: (eventType: number, hashCode: string, event: string, status: number) => void;
  updateClockBaseImage: (callBack: () => void) => void;
  freezeThemeEngine: (freezeReason?: ThemeFreezeReason) => void;
  unfreezeThemeEngine: (freezeReason?: ThemeFreezeReason) => void;
}

/**
 * Theme freeze reason
 */
export enum ThemeFreezeReason {
  ON_BACKGROUND = 0,
  PROXIMITY_SCREEN_OFF = 1,
  ENTER_EDIT_TOOL = 2,
  OS_ACCOUNT_SWITCHED = 3,
  MASHUP_STATIC_WALLPAPER = 4,
  DROPDOWN_PANEL = 5,
  GLOBAL_SEARCH_PANEL = 6,
  IMMERSIVE_PANEL = 7,
  POWER_SAVING_MODE = 8,
  SCREEN_LOCK_ON_BACKGROUND = 9,
}

/**
 * 交互类型
 */
export enum InteractiveType {
  TOUCH_DOWN = 0,
  TOUCH_UP = 1,
  CLICK = 2,
  DOUBLE_CLICK = 3,
  LONG_PRESS = 4,
  MOVE = 5,
  MOVE_LEFT_START = 6,
  MOVE_LEFT_END = 7,
  MOVE_RIGHT_START = 8,
  MOVE_RIGHT_END = 9,
  CANCEL = 10,
}

/**
 * 传递给引擎的交互事件信息
 */
export class InteractiveEvent {
  interactiveType: InteractiveType;
  x: number;
  y: number;
}

/**
 * PC/PAD上主题引擎动态壁纸动效类型
 */
export enum AnimationType {
  AOD_TO_LOCKSCREEN_LID_OPEN = 12,
  LAUNCHER_STATUS_DOUBLE_CLICK = 13,
  WALLPAPER_DESKTOP_TO_LOCKSCREEN = 1000,
  WALLPAPER_LOCKSCREEN_TO_DESKTOP = 1001,
  WALLPAPER_DOUBLE_CLICK_DESKTOP = 1002,
  WALLPAPER_SCREEN_ON = 1003,
  WALLPAPER_SCREEN_OFF = 1004,
  WALLPAPER_LID_OPEN = 1005,
  WALLPAPER_LOCKSCREEN_TO_DESKTOP_PAD = 2000,
  WALLPAPER_DOUBLE_CLICK_PAD = 2001,
  WALLPAPER_SCREEN_ON_PAD = 2002,
  WALLPAPER_SCREEN_OFF_PAD = 2003,
  WALLPAPER_STOP_PAD = 2004,
}

/**
 * PC上主题引擎动态壁纸动效信息
 */
export class AnimationInfo {
  animationType: AnimationType;
}

/**
 * PC上主题引擎动态壁纸动效信息
 */
export class MainPageStateEvent {
  mainPageStateType: number;
}

// 单例
export let themeWallpaperAniMgr: ThemeWallpaperAnimationManager = SingletonHelper.getInstance(ThemeWallpaperAnimationManager, TAG);