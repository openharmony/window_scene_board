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
import { ActionType, inputMonitor } from '@kit.InputKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SwipeInward } from '@ohos.multimodalInput.gestureEvent';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'TouchBoardSwipeInwardGestureManager';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
const homeLog: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class TouchBoardSwipeInwardGestureManager {
  private static managerInstance: TouchBoardSwipeInwardGestureManager;
  private swipeInwardCallbackArray: SwipeInwardCallback[] = [];
  private isRegistered: boolean = false;

  private constructor() {
  }

  static getInstance(): TouchBoardSwipeInwardGestureManager {
    if (TouchBoardSwipeInwardGestureManager.managerInstance == null) {
      TouchBoardSwipeInwardGestureManager.managerInstance = new TouchBoardSwipeInwardGestureManager();
    }
    return TouchBoardSwipeInwardGestureManager.managerInstance;
  }

  public registerSystemSwipeInward(): void {
    if (this.isRegistered) {
      return;
    }
    homeLog.showInfo('register touch board swipe inward gesture monitor in system');
    try {
      inputMonitor.on('swipeInward', this.onSwipeInwardEvent);
      this.isRegistered = true;
    } catch (error) {
      homeLog.showInfo('register swipe inward monitor failed');
    }
  }

  public unRegisterSystemSwipeInward(): void {
    if (this.isRegistered) {
      inputMonitor.off('swipeInward', this.onSwipeInwardEvent);
      this.isRegistered = false;
    }
  }

  public registerSwipeInwardCallback(callback?: SwipeInwardCallback): void {
    if (!callback) {
      log.showError('registerSwipeInwardCallback fail, callback is null');
      return;
    }
    if (!this.isSupportSwipeInwardGestureFeature()) {
      return;
    }
    const index = this.swipeInwardCallbackArray.findIndex((item) => {
      return item.name === callback.name;
    });
    if (index === -1) {
      this.swipeInwardCallbackArray.push(callback);
    }
  }

  public unRegisterSwipeInwardCallback(callback?: SwipeInwardCallback): void {
    if (!callback) {
      log.showError('unRegisterSwipeInwardCallback fail, callback is null');
      return;
    }
    if (!this.isSupportSwipeInwardGestureFeature()) {
      return;
    }
    const index = this.swipeInwardCallbackArray.findIndex((item) => {
      return item.name === callback.name;
    });
    if (index !== -1) {
      this.swipeInwardCallbackArray.splice(index, 1);
    }
  }

  public isSupportSwipeInwardGestureFeature(): boolean {
    return uiType === SCBConstants.UITYPE_PAD || DeviceHelper.isUltraScreenProduct();
  }

  private onSwipeInwardEvent(gesture: SwipeInward): void {
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      return;
    }
    switch (gesture.type) {
      case ActionType.BEGIN:
        TouchBoardSwipeInwardGestureManager.getInstance().onSwipeInwardBegin(gesture.x, gesture.y, Date.now());
        break;
      case ActionType.UPDATE:
        TouchBoardSwipeInwardGestureManager.getInstance().onSwipeInwardUpdate(gesture.x, gesture.y, Date.now());
        break;
      case ActionType.END:
        TouchBoardSwipeInwardGestureManager.getInstance().onSwipeInwardEnd(gesture.x, gesture.y, Date.now());
        break;
      default:
        log.showError('onSwipeInwardEvent fail, wrong gesture type');
        break;
    }
  }

  private onSwipeInwardBegin(x: number, y: number, time: number): void {
    this.swipeInwardCallbackArray.forEach((callback) => {
      callback.onSwipeInwardBegin(x, y, time);
    })
  }

  private onSwipeInwardUpdate(x: number, y: number, time: number): void {
    this.swipeInwardCallbackArray.forEach((callback) => {
      callback.onSwipeInwardUpdate(x, y, time);
    })
  }

  private onSwipeInwardEnd(x: number, y: number, time: number): void {
    this.swipeInwardCallbackArray.forEach((callback) => {
      callback.onSwipeInwardEnd(x, y, time);
    })
  }
}

export interface SwipeInwardCallback {
  name: string;
  onSwipeInwardBegin: (x: number, y: number, time: number) => void;
  onSwipeInwardUpdate: (x: number, y: number, time: number) => void;
  onSwipeInwardEnd: (x: number, y: number, time: number) => void;
}