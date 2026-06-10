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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  MockKit,
  when,
  expect,
  Level,
  ArgumentMatchers
} from '@ohos/hypium';
import { SwipeInward } from '@ohos.multimodalInput.gestureEvent';
import { ActionType } from '@kit.InputKit';
import {
  SwipeInwardCallback,
  TouchBoardSwipeInwardGestureManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/SwipeInwardGestureManager';
import { ReflectionUtils } from '../scenemanager/multiwindow/ReflectionUtils';


export default function TouchBoardSwipeInwardGestureManagerTest() {
  describe('TouchBoardSwipeInwardGestureManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('TouchBoardSwipeInwardGestureManagerTest_registerSYS', 0, (): void => {
      let touchBoardSwipeInwardGestureManager : TouchBoardSwipeInwardGestureManager =
        TouchBoardSwipeInwardGestureManager.getInstance();

      expect(touchBoardSwipeInwardGestureManager.registerSystemSwipeInward() === undefined).assertTrue();
      expect(touchBoardSwipeInwardGestureManager.registerSystemSwipeInward() === undefined).assertTrue();

      expect(touchBoardSwipeInwardGestureManager.unRegisterSystemSwipeInward() === undefined).assertTrue();
    })

    it('TouchBoardSwipeInwardGestureManagerTest_registerCallback', 0, (): void => {
      let touchBoardSwipeInwardGestureManager : TouchBoardSwipeInwardGestureManager =
        TouchBoardSwipeInwardGestureManager.getInstance();
      let swipeInwardCallback: SwipeInwardCallback = {
        name: 'swipeInward',
        onSwipeInwardBegin: (x: number, y: number, time: number) => {
        },
        onSwipeInwardUpdate: (x: number, y: number, time: number) => {
        },
        onSwipeInwardEnd: (x: number, y: number, time: number) => {
        },
      };
      let swipeInwardUndefined : undefined;

      expect(touchBoardSwipeInwardGestureManager.registerSwipeInwardCallback(swipeInwardUndefined) === undefined)
        .assertTrue();
      expect(touchBoardSwipeInwardGestureManager.registerSwipeInwardCallback(swipeInwardCallback) === undefined)
        .assertTrue();

      expect(touchBoardSwipeInwardGestureManager.unRegisterSwipeInwardCallback(swipeInwardUndefined) === undefined)
        .assertTrue();
      expect(touchBoardSwipeInwardGestureManager.unRegisterSwipeInwardCallback(swipeInwardCallback) === undefined)
        .assertTrue();
    })
    getInstanceTest();
    registerSystemSwipeInwardTest();
    unRegisterSystemSwipeInwardTest();
    registerSwipeInwardCallbackTest();
    unRegisterSwipeInwardCallbackTest();
  })
}

function getInstanceTest() {
  it('getInstanceTest', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    expect(touchBoardSwipeInwardGestureManager === undefined).assertFalse();
  });
}

function registerSystemSwipeInwardTest() {
  it('registerSystemSwipeInwardTest_01', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    ReflectionUtils.setProperty(touchBoardSwipeInwardGestureManager, 'isRegistered', true);
    expect(touchBoardSwipeInwardGestureManager.registerSystemSwipeInward() === undefined).assertTrue();
  });
  it('registerSystemSwipeInwardTest_02', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    ReflectionUtils.setProperty(touchBoardSwipeInwardGestureManager, 'isRegistered', false);
    touchBoardSwipeInwardGestureManager.registerSystemSwipeInward();
    let result: boolean = ReflectionUtils.getProperty(touchBoardSwipeInwardGestureManager, 'isRegistered');
    expect(result).assertTrue();
  });
}

function unRegisterSystemSwipeInwardTest() {
  it('unRegisterSystemSwipeInwardTest_01', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    ReflectionUtils.setProperty(touchBoardSwipeInwardGestureManager, 'isRegistered', true);
    touchBoardSwipeInwardGestureManager.unRegisterSystemSwipeInward();
    let result: boolean = ReflectionUtils.getProperty(touchBoardSwipeInwardGestureManager, 'isRegistered');
    expect(result).assertFalse();
  });
  it('unRegisterSystemSwipeInwardTest_02', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    ReflectionUtils.setProperty(touchBoardSwipeInwardGestureManager, 'isRegistered', false);
    touchBoardSwipeInwardGestureManager.unRegisterSystemSwipeInward();
    let result: boolean = ReflectionUtils.getProperty(touchBoardSwipeInwardGestureManager, 'isRegistered');
    expect(result).assertFalse();
  });
}

function registerSwipeInwardCallbackTest() {
  it('registerSwipeInwardCallbackTest_01', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    expect(touchBoardSwipeInwardGestureManager.registerSwipeInwardCallback() === undefined).assertTrue();
  });
  it('registerSwipeInwardCallbackTest_02', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardSwipeInwardGestureManager,
      touchBoardSwipeInwardGestureManager.registerSwipeInwardCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    expect(touchBoardSwipeInwardGestureManager === undefined).assertFalse();
    mocker.clear(touchBoardSwipeInwardGestureManager);
    mocker.clearAll();
  });
  it('registerSwipeInwardCallbackTest_03', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardSwipeInwardGestureManager,
      touchBoardSwipeInwardGestureManager.registerSwipeInwardCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
    expect(touchBoardSwipeInwardGestureManager === undefined).assertFalse();
    mocker.clear(touchBoardSwipeInwardGestureManager);
    mocker.clearAll();
  });
  it('registerSwipeInwardCallbackTest_04', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardSwipeInwardGestureManager,
      touchBoardSwipeInwardGestureManager.registerSwipeInwardCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
    expect(touchBoardSwipeInwardGestureManager === undefined).assertFalse();
    mocker.clear(touchBoardSwipeInwardGestureManager);
    mocker.clearAll();
  });
}

function unRegisterSwipeInwardCallbackTest() {
  it('unRegisterSwipeInwardCallbackTest_01', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    expect(touchBoardSwipeInwardGestureManager.unRegisterSwipeInwardCallback() === undefined).assertTrue();
  });
  it('unRegisterSwipeInwardCallbackTest_02', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardSwipeInwardGestureManager,
      touchBoardSwipeInwardGestureManager.unRegisterSwipeInwardCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    expect(touchBoardSwipeInwardGestureManager === undefined).assertFalse();
    mocker.clear(touchBoardSwipeInwardGestureManager);
    mocker.clearAll();
  });
  it('unRegisterSwipeInwardCallbackTest_03', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardSwipeInwardGestureManager,
      touchBoardSwipeInwardGestureManager.unRegisterSwipeInwardCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
    expect(touchBoardSwipeInwardGestureManager === undefined).assertFalse();
    mocker.clear(touchBoardSwipeInwardGestureManager);
    mocker.clearAll();
  });
  it('unRegisterSwipeInwardCallbackTest_04', Level.LEVEL0, (): void => {
    let touchBoardSwipeInwardGestureManager: TouchBoardSwipeInwardGestureManager =
      TouchBoardSwipeInwardGestureManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(touchBoardSwipeInwardGestureManager,
      touchBoardSwipeInwardGestureManager.unRegisterSwipeInwardCallback);
    when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
    expect(touchBoardSwipeInwardGestureManager === undefined).assertFalse();
    mocker.clear(touchBoardSwipeInwardGestureManager);
    mocker.clearAll();
  });
}