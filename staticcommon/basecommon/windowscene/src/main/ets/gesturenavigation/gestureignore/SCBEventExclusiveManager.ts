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
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventType, EventExclusiveConfig } from './configs/EventExclusiveConfig';
import { eventExclusiveCommander } from './utils/EventExclusiveCommander';
import { GestureEventExclusiveRestorer } from '../common/GestureEventExclusiveRestorer';

const TAG = 'SCBEventExclusiveManager';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

class SCBEventExclusiveManager {
  // 互斥自愈回调
  private restoreCallBackMap: Map<EventType, (source?: SourceType, fingerId?: number) => void> = new Map();
  // 设置事件互斥Map
  private eventExclusiveMap: Map<EventType, [boolean, string]> = new Map();
  // 事件互斥二进制位图
  private totalExclusiveBitmap: number = EventType.NO_EXCLUSIVE;

  public static getInstance(): SCBEventExclusiveManager {
    return SingletonHelper.getInstance(SCBEventExclusiveManager, TAG);
  }

  public initEventExclusiveManager(): void {
    eventExclusiveCommander.registerDebugCommands(this.eventExclusiveMap);
    GestureEventExclusiveRestorer.getInstance().init();
  }
  /**
   * 注册事件互斥，使得caller事件类型在事件互斥管理模块中与其他事件生成互斥关系。
   *
   * @param caller
   * @param gestureExclusiveTypes
   */
  public registerEventExclusive(caller: EventType, restoreCallBack?: (source?: SourceType,
    fingerId?: number) => void): void {
    if (!EventExclusiveConfig.getEventTypeName(caller)) {
      log.showInfo(`registerEventExclusive, ${caller} is invaild event type.`);
      return;
    }
    log.showInfo(`registerEventExclusive, caller:${EventExclusiveConfig.getEventTypeName(caller)}`);
    if (restoreCallBack) {
      this.restoreCallBackMap.set(caller, restoreCallBack);
    }
  }

  /**
   * 注销事件互斥，在事件互斥管理模块中注销caller事件类型与其他事件类型的互斥关系。
   *
   * @param caller
   * @param gestureExclusiveTypes
   */
  public unRegisterEventExclusive(caller: EventType): void {
    if (!EventExclusiveConfig.getEventTypeName(caller)) {
      log.showInfo(`unRegisterEventExclusive, ${caller} is invaild event type.`);
      return;
    }
    log.showInfo(`unRegisterEventExclusive, caller:${EventExclusiveConfig.getEventTypeName(caller)}`);
    this.restoreCallBackMap.delete(caller);
  }

  /**
   * 使能事件互斥
   *
   * @param caller
   * @param isExclusive
   */
  public setEventExclusive(caller: EventType, isExclusive: boolean): void {
    if (!EventExclusiveConfig.getEventTypeName(caller)) {
      log.showInfo(`setEventExclusive, ${caller} is invaild event type.`);
      return;
    }
    log.showInfo(`EventType:${EventExclusiveConfig.getEventTypeName(caller)} setEventExclusive ${isExclusive}.`);
    this.eventExclusiveMap.set(caller, [isExclusive, this.getTime()]);
    if (isExclusive) {
      let callerExclusiveBitmap = EventExclusiveConfig.getEventExclusiveBitmap(caller);
      this.totalExclusiveBitmap |= callerExclusiveBitmap;
    } else {
      let eventExclusiveBitmap = EventType.NO_EXCLUSIVE;
      this.eventExclusiveMap.forEach((value: [boolean, string], key: EventType) => {
        if (value[0]) {
          eventExclusiveBitmap |= EventExclusiveConfig.getEventExclusiveBitmap(key);
        }
      });
      this.totalExclusiveBitmap = eventExclusiveBitmap;
    }
    this.setDesktopAllEventNotGridSwiper();
    this.setDesktopAllEvent();
    this.setExclusiveStatusBarEvent();
  }

  private setDesktopAllEventNotGridSwiper(): void {
    if ((this.totalExclusiveBitmap & EventType.DESKTOP_ALL_NOTGRIDSWIPER) !== 0) {
      AppStorage.setOrCreate('isExclusiveSwiperElementsEvent', true);
    } else {
      AppStorage.setOrCreate('isExclusiveSwiperElementsEvent', false);
    }
  }

  private setDesktopAllEvent(): void {
    if ((this.totalExclusiveBitmap & EventType.DESKTOP_ALLEVENT) !== 0) {
      AppStorage.setOrCreate('isExclusiveDesktopEvent', true);
    } else {
      AppStorage.setOrCreate('isExclusiveDesktopEvent', false);
    }
  }

  private setExclusiveStatusBarEvent(): void {
    if ((this.totalExclusiveBitmap & EventType.GESTURE_STATUS_BAR) !== 0) {
      AppStorage.setOrCreate('isExclusiveStatusBarEvent', true);
    } else {
      AppStorage.setOrCreate('isExclusiveStatusBarEvent', false);
    }
  }

  /**
   * 获取Caller的手势互斥状态
   *
   * @param caller
   * @returns
   */
  public getEventExclusiveByCaller(caller: EventType): boolean {
    if (!EventExclusiveConfig.getEventTypeName(caller)) {
      log.showInfo(`getEventExclusiveByCaller, ${caller} is invaild event type.`);
      return false;
    }
    let isSetEventExclusive: boolean = false;
    this.eventExclusiveMap.forEach((value: [boolean, string], key: EventType) => {
      if (key === caller && value[0]) {
        isSetEventExclusive = true;
      }
    });
    return isSetEventExclusive;
  }

  /**
   * 获取整个模块的手势互斥使能状态
   *
   * @param caller
   * @returns
   */
  public getAllEventExclusive(): boolean {
    let isSetEventExclusive: boolean = false;
    this.eventExclusiveMap.forEach((value: [boolean, string]) => {
      if (value[0]) {
        isSetEventExclusive = true;
      }
    });
    return isSetEventExclusive;
  }

  public isExclusive(caller: EventType): boolean {
    if (!EventExclusiveConfig.getEventTypeName(caller)) {
      log.showInfo(`isExclusive, ${caller} is invaild event type.`);
      return false;
    }
    let isExclusive = (this.totalExclusiveBitmap & caller) !== 0;
    if (!isExclusive) {
      return isExclusive;
    }
    this.eventExclusiveMap.forEach((value: [boolean, string], key: EventType) => {
      if (value[0]) {
        let callerBitmap = EventExclusiveConfig.getEventExclusiveBitmap(key);
        if ((callerBitmap & caller) !== 0) {
          log.showInfo(`EventType:${EventExclusiveConfig.getEventTypeName(caller)} is exclusived, \
          For: EventType:${EventExclusiveConfig.getEventTypeName(key)} is true.`);
        }
      }
    });

    return isExclusive;
  }

  /**
   * 强制清理互斥标记位, 仅锁屏场景使用
   */
  public restoreAllEventExclusiveByHard(): void {
    log.showInfo(`restore all EventExclusive by Hard.`);
    this.totalExclusiveBitmap = EventType.NO_EXCLUSIVE;
    this.eventExclusiveMap.clear();
    AppStorage.setOrCreate('isExclusiveDesktopEvent', false);
    AppStorage.setOrCreate('isExclusiveSwiperElementsEvent', false);
    AppStorage.setOrCreate('isExclusiveStatusBarEvent', false);
  }

  /**
   * Top场景单指滑动时，通知未闭环的事件自愈。
   *
   * @param caller
   * @param sourceType 输入设备类型
   * @param 手指id
   */
  public restoreAllEventExclusive(caller: EventType, source?: SourceType, fingerId?: number): void {
    if (!EventExclusiveConfig.getEventTypeName(caller)) {
      log.showInfo(`restoreAllEventExclusive, ${caller} is invaild event type.`);
      return;
    }
    log.showInfo(`EventType:${EventExclusiveConfig.getEventTypeName(caller)} notify all EventExclusive to restore.`);
    this.eventExclusiveMap.forEach((value: [boolean, string], key: EventType) => {
      if (value[0]) {
        log.showInfo(`notify EventType:${key} to restore.`);
        let restoreCallBack = this.restoreCallBackMap?.get(key);
        if (restoreCallBack) {
          restoreCallBack(source, fingerId);
        } else {
          log.showInfo(`notify EventType:${key} to restore fail, it is not register.`);
        }
      }
    });
  }

  private getTime(): string {
    let date = new Date();
    let time = String(date.getFullYear()).padStart(2, '0') + '/' +
    String(date.getMonth() + 1).padStart(2, '0') + '/' +
    String(date.getDate()).padStart(2, '0') + ' ' +
    String(date.getHours()).padStart(2, '0') + ':' +
    String(date.getMinutes()).padStart(2, '0') + ':' +
    String(date.getSeconds()).padStart(2, '0') + '.' +
    String(date.getMilliseconds()).padStart(2, '0');
    return time;
  }
}

export const scbEventExclusiveManager = SCBEventExclusiveManager.getInstance();