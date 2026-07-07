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
import { ActionType, inputMonitor, ThreeFingersSwipe } from '@kit.InputKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { EventType, scbEventExclusiveManager, SCBOobeManager, SCBSceneSessionManager } from '@ohos/windowscene';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';


const TAG = 'TouchBoardGestureManager';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);
const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;

export class TouchBoardGestureManager {
  private static mInstance: TouchBoardGestureManager;
  private threeFingerSwiperCallbackArray: ThreeFingerSwiperCallback[] = [];
  private hasRegistered: boolean = false;
  private isInThreeFingerGesture: boolean = false;
  private isThreeFingerForceCanceled: boolean = false;

  private constructor() {
  }

  static isSupportTouchBoardGestureFeature(): boolean {
    return uiType === SCBConstants.UITYPE_PAD || DeviceHelper.isThreeFoldProduct();
  }

  static getInstance(): TouchBoardGestureManager {
    if (TouchBoardGestureManager.mInstance == null) {
      TouchBoardGestureManager.mInstance = new TouchBoardGestureManager();
      TouchBoardGestureManager.mInstance.init();
    }
    return TouchBoardGestureManager.mInstance;
  }

  public init(): void {
    scbEventExclusiveManager.registerEventExclusive(EventType.THREE_FINGER_GESTURE, () => {
      if (this.isInThreeFingerGesture) {
        TouchBoardGestureManager.getInstance().onThreeFingerSwiperCancel();
      }
      this.isThreeFingerForceCanceled = true;
      scbEventExclusiveManager.setEventExclusive(EventType.THREE_FINGER_GESTURE, false);
    });
  }

  public registerSystemThreeFingersSwipe(): void {
    if (!this.hasRegistered && TouchBoardGestureManager.isSupportTouchBoardGestureFeature()) {
      inputMonitor.on('threeFingersSwipe', this.onThreeFingersSwipeEvent);
      AppStorage.setOrCreate('isHandleThreeFingerSwiper', false);
      this.hasRegistered = true;
    }
  }

  public unRegisterSystemThreeFingersSwipe(): void {
    if (this.hasRegistered && TouchBoardGestureManager.isSupportTouchBoardGestureFeature()) {
      inputMonitor.off('threeFingersSwipe', this.onThreeFingersSwipeEvent);
      this.hasRegistered = false;
    }
  }

  public registerThreeFingerSwipeCallback(callback: ThreeFingerSwiperCallback): void {
    if (!TouchBoardGestureManager.isSupportTouchBoardGestureFeature()) {
      return;
    }
    if (!callback) {
      log.showError('registerThreeFingerSwipeCallback fail, callback is null');
      return;
    }
    const index = this.threeFingerSwiperCallbackArray.findIndex((item) => {
      return item.name === callback.name;
    });
    if (index === -1) {
      this.threeFingerSwiperCallbackArray.push(callback);
    }
  }

  public unRegisterThreeFingerSwipeCallback(callback: ThreeFingerSwiperCallback): void {
    if (!TouchBoardGestureManager.isSupportTouchBoardGestureFeature()) {
      return;
    }
    if (!callback) {
      log.showError('unRegisterThreeFingerSwipeCallback fail, callback is null');
      return;
    }
    const index = this.threeFingerSwiperCallbackArray.findIndex((item) => {
      return item.name === callback.name;
    });
    if (index !== -1) {
      this.threeFingerSwiperCallbackArray.splice(index, 1);
    }
  }

  private onThreeFingersSwipeEvent(gesture: ThreeFingersSwipe): void {
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      return;
    }
    if (SCBOobeManager.isEnable()) {
      log.showInfo('oobe is enable, no need to handle swiper');
      return;
    }
    if (gesture.type === ActionType.BEGIN) {
      TouchBoardGestureManager.getInstance().onThreeFingerSwiperBegin();
    } else if (gesture.type === ActionType.UPDATE) {
      TouchBoardGestureManager.getInstance().onThreeFingerSwiperUpdate(gesture.x, gesture.y, Date.now());
    } else if (gesture.type === ActionType.END) {
      TouchBoardGestureManager.getInstance().onThreeFingerSwiperEnd();
    } else if (gesture.type === ActionType.CANCEL) {
      TouchBoardGestureManager.getInstance().onThreeFingerSwiperCancel();
    }
  }

  private onThreeFingerSwiperBegin(): void {
    if (scbEventExclusiveManager.isExclusive(EventType.THREE_FINGER_GESTURE)) {
      log.showInfo('onThreeFingerSwiperBegin exclusive, return');
      return;
    }
    log.showInfo(`onThreeFingerSwiperBegin`);
    this.isInThreeFingerGesture = true;
    this.isThreeFingerForceCanceled = false;
    scbEventExclusiveManager.setEventExclusive(EventType.THREE_FINGER_GESTURE, true);
    this.threeFingerSwiperCallbackArray.forEach((callback) => {
      callback.onThreeFingerSwiperBegin();
    })
  }

  private onThreeFingerSwiperUpdate(x: number, y: number, time: number): void {
    if (scbEventExclusiveManager.isExclusive(EventType.THREE_FINGER_GESTURE)) {
      log.showDebug('onThreeFingerSwiperUpdate exclusive, return');
      return;
    }
    if (this.isThreeFingerForceCanceled) {
      log.showDebug('onThreeFingerSwiperUpdate ThreeFingerForceCanceled, return');
      return;
    }
    log.showDebug('onThreeFingerSwiperUpdate');
    this.threeFingerSwiperCallbackArray.forEach((callback) => {
      callback.onThreeFingerSwiperUpdate(x, y, time);
    })
  }

  private onThreeFingerSwiperEnd(): void {
    if (scbEventExclusiveManager.isExclusive(EventType.THREE_FINGER_GESTURE)) {
      log.showInfo('onThreeFingerSwiperEnd exclusive, return');
      return;
    }
    if (this.isThreeFingerForceCanceled) {
      log.showInfo('onThreeFingerSwiperEnd ThreeFingerForceCanceled, return');
      return;
    }
    log.showInfo('onThreeFingerSwiperEnd');
    this.isInThreeFingerGesture = false;
    scbEventExclusiveManager.setEventExclusive(EventType.THREE_FINGER_GESTURE, false);
    this.threeFingerSwiperCallbackArray.forEach((callback) => {
      callback.onThreeFingerSwiperEnd();
    })
  }

  private onThreeFingerSwiperCancel(): void {
    if (scbEventExclusiveManager.isExclusive(EventType.THREE_FINGER_GESTURE)) {
      log.showInfo('onThreeFingerSwiperCancel exclusive, return');
      return;
    }
    if (this.isThreeFingerForceCanceled) {
      log.showInfo('onThreeFingerSwiperCancel ThreeFingerForceCanceled, return');
      return;
    }
    log.showInfo('onThreeFingerSwiperCancel');
    scbEventExclusiveManager.setEventExclusive(EventType.THREE_FINGER_GESTURE, false);
    this.isInThreeFingerGesture = false;
    this.threeFingerSwiperCallbackArray.forEach((callback) => {
      callback.onThreeFingerSwiperCancel();
    })
  }
}

export interface ThreeFingerSwiperCallback {
  name: string;
  onThreeFingerSwiperBegin: () => void;
  onThreeFingerSwiperUpdate: (x: number, y: number, time: number) => void;
  onThreeFingerSwiperEnd: () => void;
  onThreeFingerSwiperCancel: () => void;
}