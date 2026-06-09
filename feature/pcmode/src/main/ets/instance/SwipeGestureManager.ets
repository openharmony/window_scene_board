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

import { LogHelper, LogDomain, Trace } from '@ohos/basicutils';
import { ThreeFingersSwipe, FourFingersSwipe, TouchGestureEvent, ActionType } from '@ohos.multimodalInput.gestureEvent';
import inputMonitor from '@ohos.multimodalInput.inputMonitor';
import { TouchEvent, Action } from '@ohos.multimodalInput.touchEvent';
import { SCBScreenSessionManager } from '@ohos/windowscene';

const TAG = 'SwipeGestureManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ARRAY_LENGTH_ZERO: number = 0;
const THREE_FINGERS: number = 3;
const FOUR_FINGERS: number = 4;
const FOUR_FINGER_INTERVAL: number = 5;
const FIVE_FINGERS: number = 5;
const TOUCH_EVENT_TRACE = 'inputMonitor.TouchEvent';

/*
  滑动手势事件管理
 */
export class SwipeGestureManager {
  private static instance: SwipeGestureManager;
  private fourFingersSwipeCallbacks: Array<Function> = [];
  private fourFingersScreenSwipeCallbacks: Array<Function> = [];
  private threeFingersTouchScreenSwipeCallbacks: Array<Function> = [];
  private fourFingersTouchScreenSwipeCallbacks: Array<Function> = [];
  private fiveFingersTouchScreenSwipeCallbacks: Array<Function> = [];
  private totalProcessTime: number = 0;
  private touchPadEventInterval: number = 8;
  private enableTouchMoveEventFlag: boolean = true;

  constructor() {
  }

  static getInstance() {
    if (!SwipeGestureManager.instance) {
      SwipeGestureManager.instance = new SwipeGestureManager();
    }
    return SwipeGestureManager.instance;
  }

  /**
   * register four fingers swipe event callback
   * @param callback
   */
  public registerFourFingersSwipeCallback(callback: Function): void {
    if (callback) {
      this.fourFingersSwipeCallbacks.push(callback);
    }
    log.showInfo(`registerFourFingersSwipeCallback callbacks len:${this.fourFingersSwipeCallbacks.length}`);
  }

  /**
   * unregister four fingers swipe event callback
   * @param callback
   */
  public unregisterFourFingersSwipeCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`unRegisterFourFingersSwipeCallback failed. callback is null`);
      return;
    }

    let index: number = this.fourFingersSwipeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.fourFingersSwipeCallbacks.splice(index, 1);
    }
    log.showInfo(`unregisterFourFingersSwipeCallback callbacks len:${this.fourFingersSwipeCallbacks.length}`);
  }

  /**
   * register screen four fingers swipe event callback
   * @param callback
   */
  public registerScreenFourFingersCallback(callback: Function): void {
    if (callback) {
      this.fourFingersScreenSwipeCallbacks.push(callback);
    }
    log.showInfo(`registerScreenFourFingersCallback callbacks len:${this.fourFingersScreenSwipeCallbacks.length}`);
  }

  /**
   * unregister screen four fingers swipe event callback
   * @param callback
   */
  public unregisterScreenFourFingersCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`unRegisterScreenFourFingersSwipeCallback failed. callback is null`);
      return;
    }

    let index: number = this.fourFingersScreenSwipeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.fourFingersScreenSwipeCallbacks.splice(index, 1);
    }
    log.showInfo(`unregisterFourFingersSwipeCallback callbacks len:${this.fourFingersScreenSwipeCallbacks.length}`);
  }

  /**
   * monitor fourFingersSwipe
   */
  public onFourFingersSwipe(): void {
    try {
      inputMonitor.on('fourFingersSwipe', this.onFourFingersSwipeEvent);
    } catch (error) {
      log.showError(`onFourFingersSwipe error, code: ${error?.code}, message: ${error?.message}`);
    }
    AppStorage.setOrCreate('isHandleFourFingerSwiper', false);
  }

  /**
   * cancel monitor fourFingersSwipe
   */
  public offFourFingersSwipe() {
    log.showDebug(`offFourFingersSwipe`);
    try {
      inputMonitor.off('fourFingersSwipe', this.onFourFingersSwipeEvent);
    } catch (error) {
      log.showError(`offFourFingersSwipe error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  /**
   * monitor screenFourFingersSwipe
   */
  public onScreenFourFingersSwipe(): void {
    log.showInfo('onScreenFourFingersSwipe');
    try {
      inputMonitor.on('touch', this.fourFingersTouch);
    } catch (error) {
      log.showError(`onScreenFourFingersSwipe error, code: ${error?.code}, message: ${error?.message}`);
    }
    AppStorage.setOrCreate('isHandleScreenFourFingerSwiper', false);
  }

  /**
   * cancel monitor screenFourFingersSwipe
   */
  public offScreenFourFingersSwipe() {
    log.showInfo('offScreenFourFingersSwipe');
    try {
      inputMonitor.off('touch', this.fourFingersTouch);
    } catch (error) {
      log.showError(`offScreenFourFingersSwipe error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  private onFourFingersSwipeEvent = (gesture: FourFingersSwipe): void => {
    this.fourFingersSwipeCallbacks.forEach((callback) => {
      if (callback) {
        callback(gesture);
      }
    })
  }

  private fourFingersTouch: inputMonitor.TouchEventReceiver = (touchEvent: TouchEvent): boolean => {
    Trace.start(TOUCH_EVENT_TRACE);
    if (touchEvent.action === Action.MOVE) {
      if (this.enableTouchMoveEventFlag) {
        log.showDebug('enableTouchMoveEventFlag is true, reset Timeout, go on');
        this.enableTouchMoveEventFlag = false;
        setTimeout(() => {
          this.enableTouchMoveEventFlag = true;
        }, FOUR_FINGER_INTERVAL);
      } else {
        Trace.end(TOUCH_EVENT_TRACE);
        return false;
      }
    } else {
      log.showInfo(`touchEvent.action === ${touchEvent.action}, go on`);
    }
    let result: boolean = false;
    if (this.fourFingersScreenSwipeCallbacks.length === ARRAY_LENGTH_ZERO) {
      log.showWarn('failed callback is null');
    }
    for (let i = 0; i < this.fourFingersScreenSwipeCallbacks.length; i++) {
      let callback = this.fourFingersScreenSwipeCallbacks[i];
      if (callback(touchEvent)) {
        result = true;
        break;
      }
    }
    Trace.end(TOUCH_EVENT_TRACE);
    return result;
  }

  /**
   * About three fingers touch screen swipe callbacks
   */
  public onThreeFingersTouchScreenSwipe(): void {
    try {
      inputMonitor.on('touchscreenSwipe', THREE_FINGERS, this.threeFingersTouchScreenSwipe);
    } catch (err) {
      log.showError('onThreeFingersTouchScreenSwipe err: ' + JSON.stringify(err));
    }
  }

  public offThreeFingersTouchScreenSwipe() {
    try {
      inputMonitor.off('touchscreenSwipe', THREE_FINGERS, this.threeFingersTouchScreenSwipe);
    } catch (err) {
      log.showError('offThreeFingersTouchScreenSwipe err: ' + JSON.stringify(err));
    }
  }

  private threeFingersTouchScreenSwipe: Callback<TouchGestureEvent> = (touchEvent: TouchGestureEvent): boolean => {
    let result: boolean = false;
    if (this.threeFingersTouchScreenSwipeCallbacks.length === ARRAY_LENGTH_ZERO) {
      log.showWarn('failed threeFingersTouchScreenSwipe callback is null');
    }
    log.showDebug('[SCBEvent]threeFingersTouchScreenSwipe triggered, callbacks len: ' +
      this.threeFingersTouchScreenSwipeCallbacks.length);
    for (const callback of this.threeFingersTouchScreenSwipeCallbacks) {
      if (!callback) {
        continue;
      }
      if (callback(touchEvent)) {
        result = true;
        break;
      }
    }
    return result;
  }

  /**
   * register screen three fingers swipe event callback
   * @param callback
   */
  public registerThreeFingersTouchScreenSwipeCallback(callback: Function): void {
    if (callback) {
      this.threeFingersTouchScreenSwipeCallbacks.push(callback);
    }
    log.showInfo('registerThreeFingersTouchScreenSwipeCallback callbacks len:' +
      this.threeFingersTouchScreenSwipeCallbacks.length);
  }

  /**
   * unregister screen three fingers swipe event callback
   * @param callback
   */
  public unregisterThreeFingersTouchScreenSwipeCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`registerThreeFingersTouchScreenSwipeCallback failed. callback is null`);
      return;
    }

    let index: number = this.threeFingersTouchScreenSwipeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.threeFingersTouchScreenSwipeCallbacks.splice(index, 1);
    }
    log.showInfo('unregisterTouchScreenSwipeCallback callbacks len:' +
      this.threeFingersTouchScreenSwipeCallbacks.length);
  }

  /**
   * About four fingers touch screen swipe callbacks
   */
  public onFourFingersTouchScreenSwipe(): void {
    try {
      inputMonitor.on('touchscreenSwipe', FOUR_FINGERS, this.fourFingersTouchScreenSwipe);
    } catch (err) {
      log.showError('onFourFingersTouchScreenSwipe err: ' + JSON.stringify(err));
    }
  }

  public offFourFingersTouchScreenSwipe() {
    try {
      inputMonitor.off('touchscreenSwipe', FOUR_FINGERS, this.fourFingersTouchScreenSwipe);
    } catch (err) {
      log.showError('offFourFingersTouchScreenSwipe err: ' + JSON.stringify(err));
    }
  }

  private fourFingersTouchScreenSwipe: Callback<TouchGestureEvent> = (touchEvent: TouchGestureEvent): boolean => {
    let result: boolean = false;
    if (this.fourFingersTouchScreenSwipeCallbacks.length === ARRAY_LENGTH_ZERO) {
      log.showWarn('failed fourFingersTouchScreenSwipe callback is null');
    }
    log.showDebug('[SCBEvent]fourFingersTouchScreenSwipe triggered, callbacks len: ' +
      this.fourFingersTouchScreenSwipeCallbacks.length);
    for (const callback of this.fourFingersTouchScreenSwipeCallbacks) {
      if (!callback) {
        continue;
      }
      if (callback(touchEvent)) {
        result = true;
        break;
      }
    }
    return result;
  }

  /**
   * register screen four fingers swipe event callback
   * @param callback
   */
  public registerFourFingersTouchScreenSwipeCallback(callback: Function): void {
    if (callback) {
      this.fourFingersTouchScreenSwipeCallbacks.push(callback);
    }
    log.showInfo('registerFourFingersTouchScreenSwipeCallback callbacks len:' +
      this.fourFingersTouchScreenSwipeCallbacks.length);
  }

  /**
   * unregister screen four fingers swipe event callback
   * @param callback
   */
  public unregisterFourFingersTouchScreenSwipeCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`registerFourFingersTouchScreenSwipeCallback failed. callback is null`);
      return;
    }

    let index: number = this.fourFingersTouchScreenSwipeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.fourFingersTouchScreenSwipeCallbacks.splice(index, 1);
    }
    log.showInfo('unregisterTouchScreenSwipeCallback callbacks len:' +
      this.fourFingersTouchScreenSwipeCallbacks.length);
  }

  /**
   * About five fingers touch screen swipe callbacks
   */
  public onFiveFingersTouchScreenSwipe(): void {
    try {
      inputMonitor.on('touchscreenSwipe', FIVE_FINGERS, this.fiveFingersTouchScreenSwipe);
    } catch (err) {
      log.showError('onFiveFingersTouchScreenSwipe err: ' + JSON.stringify(err));
    }
  }

  public offFiveFingersTouchScreenSwipe() {
    try {
      inputMonitor.off('touchscreenSwipe', FIVE_FINGERS, this.fiveFingersTouchScreenSwipe);
    } catch (err) {
      log.showError('offFiveFingersTouchScreenSwipe err: ' + JSON.stringify(err));
    }
  }

  private fiveFingersTouchScreenSwipe: Callback<TouchGestureEvent> = (touchEvent: TouchGestureEvent): boolean => {
    let result: boolean = false;
    if (this.fiveFingersTouchScreenSwipeCallbacks.length === ARRAY_LENGTH_ZERO) {
      log.showWarn('failed fiveFingersTouchScreenSwipe callback is null');
    }
    log.showDebug('[SCBEvent]fiveFingersTouchScreenSwipe triggered, callbacks len: ' +
      this.fiveFingersTouchScreenSwipeCallbacks.length);
    for (const callback of this.fiveFingersTouchScreenSwipeCallbacks) {
      if (!callback) {
        continue;
      }
      if (callback(touchEvent)) {
        result = true;
        break;
      }
    }
    return result;
  }

  /**
   * register screen five fingers swipe event callback
   * @param callback
   */
  public registerFiveFingersTouchScreenSwipeCallback(callback: Function): void {
    if (callback) {
      this.fiveFingersTouchScreenSwipeCallbacks.push(callback);
    }
    log.showInfo('registerFiveFingersTouchScreenSwipeCallback callbacks len:' +
      this.fiveFingersTouchScreenSwipeCallbacks.length);
  }

  /**
   * unregister screen five fingers swipe event callback
   * @param callback
   */
  public unregisterFiveFingersTouchScreenSwipeCallback(callback: Function): void {
    if (!callback) {
      log.showWarn(`registerFiveFingersTouchScreenSwipeCallback failed. callback is null`);
      return;
    }

    let index: number = this.fiveFingersTouchScreenSwipeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.fiveFingersTouchScreenSwipeCallbacks.splice(index, 1);
    }
    log.showInfo('unregisterTouchScreenSwipeCallback callbacks len:' +
      this.fiveFingersTouchScreenSwipeCallbacks.length);
  }
}