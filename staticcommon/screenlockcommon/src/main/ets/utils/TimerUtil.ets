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

import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'TimerUtil';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export enum TimerScene {
  EDIT_BACKGROUND_WALLPAPER
}

export class TimerUtil {
  // key为使用场景，value为timerId
  private static timerMap: Map<TimerScene, number> = new Map();

  /**
   * 设置定时器
   * @param scene 使用场景
   * @param func 要限制调用的方法
   * @param delay 防抖间隔时间，默认300ms
   */
  public static setTimer(scene: TimerScene, func: Function, delay: number = 300): void {
    log.showInfo(TAG, `set ${scene} timer`);
    if (TimerUtil.timerMap.get(scene)) {
      log.showError(TAG, 'Repeatedly set timer');
      TimerUtil.clearTimerByScene(scene);
    }
    const timerId = setTimeout((): void => {
      clearTimeout(TimerUtil.timerMap.get(scene));
      TimerUtil.timerMap.delete(scene);
      func();
    }, delay);
    TimerUtil.timerMap.set(scene, timerId);
  }

  /**
   * 清除所有定时器
   */
  public static clearAllTimer(): void {
    log.showInfo(TAG, 'clear all timer');
    for (let scene of TimerUtil.timerMap.keys()) {
      TimerUtil.clearTimerByScene(scene);
    }
  }

  /**
   * 根据使用场景清除定时器
   * @param scene 使用场景
   */
  public static clearTimerByScene(scene: TimerScene): void {
    if (TimerUtil.timerMap.get(scene)) {
      log.showInfo(TAG, `clear ${scene} timer`);
      clearTimeout(TimerUtil.timerMap.get(scene));
      TimerUtil.timerMap.delete(scene);
    }
  }
}