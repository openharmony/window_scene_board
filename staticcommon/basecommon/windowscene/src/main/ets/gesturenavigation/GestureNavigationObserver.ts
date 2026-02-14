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
import { GestureNavigationState } from './SCBGestureManager';

const TAG = 'GestureNavigationObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 导航类型
 */
export enum NavigationType {
  GESTURE = 'GESTURE',
  FLOATING = 'FLOATING'
}

/**
 * 场景caller
 */
export enum SceneCaller {
  // 多窗
  MULTIWINDOW = 'MultiWindow',
  // 底部导航窗口管理
  NAVBAR_WINDOW_MANAGER = 'NavBarWindowManager',
}

/**
 * 手势导航事件
 */
export class GestureNavigationEvent {
  public type: NavigationType;
  public gestureEvent?: GestureEvent;
}

/**
 * 手势导航事件观察者
 */
class GestureNavigationEventObserver {
  private static mInstance: GestureNavigationEventObserver | null = null;
  /**
   * 手势导航事件监听回调
   */
  private gestureNavigationEventCallBack: Map<SceneCaller, Function> = new Map();

  public static getInstance(): GestureNavigationEventObserver {
    if (!GestureNavigationEventObserver.mInstance) {
      GestureNavigationEventObserver.mInstance = new GestureNavigationEventObserver();
    }
    return GestureNavigationEventObserver.mInstance;
  }

  private constructor() {
  }

  /**
   * 发送手势导航事件
   *
   * @param state 手势事件的状态
   * @param type 导航的类型
   * @param event 手势事件
   */
  public sendGestureNavigationEvent(state: GestureNavigationState, type: NavigationType,
    event?: GestureEvent): void {
    if (state === GestureNavigationState.UPDATE) {
      log.showDebug(`sendGestureNavigationEvent state=${state}, type=${type}.`);
    } else {
      log.showInfo(`sendGestureNavigationEvent state=${state}, type=${type}.`);
    }
    let gestureNavigationEvent = new GestureNavigationEvent();
    gestureNavigationEvent.type = type;
    gestureNavigationEvent.gestureEvent = event;
    this.gestureNavigationEventCallBack.forEach((callback: Function) => {
      callback?.(state, gestureNavigationEvent);
    });
  }

  /**
   * 注册手势导航事件监听
   *
   * @param sceneCaller 注册的场景caller
   * @param callBack 事件回调
   */
  public registerGestureNavigationEvent(sceneCaller: SceneCaller, callBack: Function): void {
    log.showInfo(`registerNavBarPanGestureEvent sceneType=${sceneCaller}.`);
    this.gestureNavigationEventCallBack.set(sceneCaller, callBack);
  }

  /**
   * 注销手势导航事件监听
   *
   * @param sceneCaller 注册的场景caller
   */
  public unRegisterGestureNavigationEvent(sceneCaller: SceneCaller): void {
    if (!this.gestureNavigationEventCallBack.has(sceneCaller)) {
      log.showInfo(`unRegister sceneType=${sceneCaller} error, no such sceneType`);
      return;
    }
    this.gestureNavigationEventCallBack.delete(sceneCaller);
    log.showInfo(`unRegister sceneType=${sceneCaller} success`);

  }
}

export const gestureNavigationObserver = GestureNavigationEventObserver.getInstance();
