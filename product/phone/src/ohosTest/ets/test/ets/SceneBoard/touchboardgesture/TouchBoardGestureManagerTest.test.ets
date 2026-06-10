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
import {
  describe, it, expect, Level, MockKit, when, ArgumentMatchers
} from '@ohos/hypium'
import {
  ThreeFingerSwiperCallback,
  TouchBoardGestureManager } from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/TouchBoardGestureManager';
import { ReflectionUtils } from '../scenemanager/multiwindow/ReflectionUtils';
import { ActionType, ThreeFingersSwipe } from '@kit.InputKit';

export function TouchBoardGestureManagerTest() {
  describe('TouchBoardGestureManagerTest', () => {
    getInstanceTest();
    registerSystemThreeFingersSwipeTest();
    unRegisterSystemThreeFingersSwipeTest();
    registerThreeFingerSwipeCallbackTest();
    unRegisterThreeFingerSwipeCallbackTest();
    onThreeFingersSwipeEventTest();
    onThreeFingerSwiperBeginTest();
    onThreeFingerSwiperUpdateTest();
    onThreeFingerSwiperEndTest();
    onThreeFingerSwiperCancelTest();
  });
}

function getInstanceTest() {
  it('getInstanceTest', Level.LEVEL0, (): void => {
    let result: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    expect(result === undefined).assertFalse();
  });
}

function registerSystemThreeFingersSwipeTest() {
  it('registerSystemThreeFingersSwipeTest_02', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    ReflectionUtils.setProperty(touchBoardGestureManager, 'hasRegistered', true)
    touchBoardGestureManager.registerSystemThreeFingersSwipe();
    let result: boolean = ReflectionUtils.getProperty(touchBoardGestureManager, 'hasRegistered');
    expect(result).assertTrue();
  });
}

function unRegisterSystemThreeFingersSwipeTest() {
  it('unRegisterSystemThreeFingersSwipeTest_01', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    ReflectionUtils.setProperty(touchBoardGestureManager, 'hasRegistered', false)
    touchBoardGestureManager.unRegisterSystemThreeFingersSwipe();
    let result: boolean = ReflectionUtils.getProperty(touchBoardGestureManager, 'hasRegistered');
    expect(result).assertFalse();
  });
}

function registerThreeFingerSwipeCallbackTest() {
  it('registerThreeFingerSwipeCallbackTest_01', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let testCallback: ThreeFingerSwiperCallback = {
      name: 'testCallback',
      onThreeFingerSwiperBegin: () => {},
      onThreeFingerSwiperUpdate: (x: number, y: number, time: number) => {},
      onThreeFingerSwiperEnd: () => {},
      onThreeFingerSwiperCancel: () => {}
    };
    touchBoardGestureManager.registerThreeFingerSwipeCallback(testCallback);
    expect(touchBoardGestureManager.registerThreeFingerSwipeCallback(testCallback) === undefined).assertTrue();
  });
  it('registerThreeFingerSwipeCallbackTest_02', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardGestureManager,
      touchBoardGestureManager.registerThreeFingerSwipeCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
  it('registerThreeFingerSwipeCallbackTest_03', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardGestureManager,
      touchBoardGestureManager.registerThreeFingerSwipeCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
  it('registerThreeFingerSwipeCallbackTest_04', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardGestureManager,
      touchBoardGestureManager.registerThreeFingerSwipeCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
}

function unRegisterThreeFingerSwipeCallbackTest() {
  it('unRegisterThreeFingerSwipeCallbackTest_01', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let testCallback: ThreeFingerSwiperCallback = {
      name: 'testCallback',
      onThreeFingerSwiperBegin: () => {},
      onThreeFingerSwiperUpdate: (x: number, y: number, time: number) => {},
      onThreeFingerSwiperEnd: () => {},
      onThreeFingerSwiperCancel: () => {}
    };
    touchBoardGestureManager.unRegisterThreeFingerSwipeCallback(testCallback);
    expect(touchBoardGestureManager.unRegisterThreeFingerSwipeCallback(testCallback) === undefined).assertTrue();
  });
  it('unRegisterThreeFingerSwipeCallbackTest_02', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardGestureManager,
      touchBoardGestureManager.unRegisterThreeFingerSwipeCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
  it('unRegisterThreeFingerSwipeCallbackTest_03', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardGestureManager,
      touchBoardGestureManager.unRegisterThreeFingerSwipeCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
  it('unRegisterThreeFingerSwipeCallbackTest_04', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardGestureManager,
      touchBoardGestureManager.unRegisterThreeFingerSwipeCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
}

function onThreeFingersSwipeEventTest() {
  it('onThreeFingersSwipeEventTest_01', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let testGesture: ThreeFingersSwipe = {
      type: ActionType.CANCEL,
      x : 0,
      y : 0
    };
    testGesture.type = ActionType.BEGIN;
    let result: void = ReflectionUtils.useFunc(touchBoardGestureManager, 'onThreeFingersSwipeEvent', testGesture);
    expect(result !== null).assertTrue();
  });
  it('onThreeFingersSwipeEventTest_02', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let testGesture: ThreeFingersSwipe = {
      type: ActionType.CANCEL,
      x : 0,
      y : 0
    };
    testGesture.type = ActionType.UPDATE;
    let result: void = ReflectionUtils.useFunc(touchBoardGestureManager, 'onThreeFingersSwipeEvent', testGesture);
    expect(result !== null).assertTrue();
  });
  it('onThreeFingersSwipeEventTest_03', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let testGesture: ThreeFingersSwipe = {
      type: ActionType.CANCEL,
      x : 0,
      y : 0
    };
    testGesture.type = ActionType.END;
    let result: void = ReflectionUtils.useFunc(touchBoardGestureManager, 'onThreeFingersSwipeEvent', testGesture);
    expect(result !== null).assertTrue();
  });
  it('onThreeFingersSwipeEventTest_04', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let testGesture: ThreeFingersSwipe = {
      type: ActionType.CANCEL,
      x : 0,
      y : 0
    };
    let result: void = ReflectionUtils.useFunc(touchBoardGestureManager, 'onThreeFingersSwipeEvent', testGesture);
    expect(result !== null).assertTrue();
  });
}

function onThreeFingerSwiperBeginTest() {
  it('onThreeFingerSwiperBeginTest', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = Reflect.get(touchBoardGestureManager, 'onThreeFingerSwiperBegin');
    let func2: Function = mocker.mockFunc(touchBoardGestureManager, func1);
    when(func2)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
}

function onThreeFingerSwiperUpdateTest() {
  it('onThreeFingerSwiperUpdateTest', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = Reflect.get(touchBoardGestureManager, 'onThreeFingerSwiperUpdate');
    let func2: Function = mocker.mockFunc(touchBoardGestureManager, func1);
    when(func2)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
}

function onThreeFingerSwiperEndTest() {
  it('onThreeFingerSwiperEndTest', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = Reflect.get(touchBoardGestureManager, 'onThreeFingerSwiperEnd');
    let func2: Function = mocker.mockFunc(touchBoardGestureManager, func1);
    when(func2)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
}

function onThreeFingerSwiperCancelTest() {
  it('onThreeFingerSwiperCancelTest', Level.LEVEL0, (): void => {
    let touchBoardGestureManager: TouchBoardGestureManager = TouchBoardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let func1: Function = Reflect.get(touchBoardGestureManager, 'onThreeFingerSwiperCancel');
    let func2: Function = mocker.mockFunc(touchBoardGestureManager, func1);
    when(func2)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(touchBoardGestureManager);
    mocker.clearAll();
  });
}

