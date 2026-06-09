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

import ScreenLockService from './ScreenLockService';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { Observer } from '@ohos/basicutils';
import type { Subject } from '@ohos/frameworkwrapper';
import screenOnOffMediator from '@ohos/screenlockcommon/src/main/ets/interface/ScreenOnOffMediator';

export enum UnlockResult {
  SUCCESS = 0,
  FAIL = 1,
  CANCEL = 2
}

const TAG = 'ScreenLock-ScreenLockMediator'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * lock screen view
 *
 * @since 2022-04-28
 */
class ScreenLockMediator implements Subject {
  private observers: Observer[] = []

  /**
   * constructor
   */
  public constructor() {
    log.showInfo('constructor count');
  }

  /**
   * 添加observer
   */
  public addObserver(observer: Observer | null): void {
    if (observer) {
      this.observers.push(observer);
      log.showInfo(`addObserver size = ${this.observers.length}`);
    } else {
      log.showInfo(`addObserver is null`);
    }
  }

  /**
   * 删除observer
   */
  public deleteObserver(observer: Observer | null): void {
    if (observer) {
      const index = this.observers.indexOf(observer);
      ~index && this.observers.splice(index, 1);
      log.showInfo(`deleteObserver size = ${this.observers.length}`);
    } else {
      log.showInfo(`deleteObserver is null`);
    }
  }

  /**
   * observer通知
   */
  public notifyObservers(): void {
    log.showInfo(`notifyObservers length = ${this.observers.length}`);
    this.observers.forEach((observer: Observer) => {
      log.showInfo('forEach');
      observer.notify();
    })
  }

  /**
   * 保存是否亮屏标记位
   *
   * @param isScreenOn 是否亮屏
   */
  public setScreenOn(isScreenOn: boolean): void {
    ScreenLockService.isScreenOn = isScreenOn;
    screenOnOffMediator.setScreenOn(isScreenOn);
  }

  /**
   * 保存是否亮屏结束标记位
   *
   * @param isEndScreenOn 是否亮屏结束
   */
  public setScreenOnEnd(isEndScreenOn: boolean): void {
    screenOnOffMediator.setScreenOnEnd(isEndScreenOn);
  }

  /**
   * 保存是否息屏结束标记位
   *
   * @param isScreenOffEnd 是否息屏结束
   */
  public setScreenOffEnd(isScreenOffEnd: boolean): void {
    ScreenLockService.isScreenOffEnd = isScreenOffEnd;
    screenOnOffMediator.setScreenOffEnd(isScreenOffEnd);
  }

  /**
   * 监听设备变化
   *
   * @param isAddDevice 是否新增设备
   * @param deviceId 设备id
   */
  public watchInputDevice(isAddDevice: boolean, deviceId: number): void {
    ScreenLockService.checkKeyboardDevice(isAddDevice, deviceId);
  }

  /**
   * lock screen
   */
  public doScreenLock(): void {
    this.doScreenLockWithLocalCallback();
  }

  /**
   * lock screen with local callback
   */
  public doScreenLockWithLocalCallback(callback?: Function): void {
    log.showInfo('doScreenLock');
    ScreenLockService.lockScreen(() => {
      log.showInfo('doScreenLock notifyObservers');
      if (callback) {
        callback();
      }
      this.notifyObservers();
    })
  }

  /**
   * 返回到上一页
   */
  public backPage(): void {
    ScreenLockService.backPage();
  }

  /**
   * unlock Screen
   */
  public unlockScreen(): void {
    ScreenLockService.unlockScreen();
  }
}

let screenLockMediator = new ScreenLockMediator()
export default screenLockMediator as ScreenLockMediator
