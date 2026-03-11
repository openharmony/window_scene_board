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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  Size,
  TestType
} from '@ohos/hypium';
import {
  GestureNavigationEvent,
  gestureNavigationObserver,
  NavigationType,
  SceneCaller} from '../../../../../../main/ets/gesturenavigation/GestureNavigationObserver';
import { GestureNavigationState } from '../../../../../../main/ets/gesturenavigation/SCBGestureManager';

let eventArea: Area = {
  width: 0,
  height: 0,
  position: { x: 0, y: 0 },
  globalPosition: { x: 0, y: 0 }
};

let eventTarget: EventTarget = {
  area: eventArea
};

let event: GestureEvent = {
  target: eventTarget,
  timestamp: 0,
  source: 0,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: 0,
  repeat: false,
  fingerList: [],
  offsetX: 0,
  offsetY: 0,
  angle: 0,
  speed: 0,
  scale: 0,
  pinchCenterX: 0,
  pinchCenterY: 0,
  velocityX: 0,
  velocityY: 0,
  velocity: 0
};


export default function GestureNavigationEventObserverTest() {
  describe('GestureNavigationEventObserverTest', () => {
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

    it('GestureNavigationEventObserverTest_sendGestureNavigationEvent_1', TestType.USER | Size.SMALLTEST |
      Level.LEVEL0, (): void => {
      let state = GestureNavigationState.UPDATE;
      let type = NavigationType.GESTURE;
      expect(gestureNavigationObserver.sendGestureNavigationEvent(state, type) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_sendGestureNavigationEvent_2', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      let state = GestureNavigationState.START;
      let type = NavigationType.GESTURE;
      expect(gestureNavigationObserver.sendGestureNavigationEvent(state, type) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_sendGestureNavigationEvent_3', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      let state = GestureNavigationState.START;
      let type = NavigationType.GESTURE;
      expect(gestureNavigationObserver.sendGestureNavigationEvent(state, type, event) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_sendGestureNavigationEvent_4', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      let state = GestureNavigationState.START;
      let type = NavigationType.GESTURE;
      expect(gestureNavigationObserver.sendGestureNavigationEvent(state, type, event) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_sendGestureNavigationEvent_5', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      let state = GestureNavigationState.START;
      let type = NavigationType.GESTURE;
      ((gestureNavigationObserver as object)['gestureNavigationEventCallBack'] as Map<SceneCaller, Function>).set(
        SceneCaller.MULTIWINDOW, (state: GestureNavigationState, event: GestureNavigationEvent) => {})
      expect(gestureNavigationObserver.sendGestureNavigationEvent(state, type, event) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_registerGestureNavigationEvent_1', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      let scene = SceneCaller.MULTIWINDOW;
      let callBack = (state: GestureNavigationState, event: GestureNavigationEvent) => {};
      expect(gestureNavigationObserver.registerGestureNavigationEvent(scene, callBack) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_unRegisterGestureNavigationEvent_1', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      ((gestureNavigationObserver as object)['gestureNavigationEventCallBack'] as Map<SceneCaller, Function>).clear();
      let scene = SceneCaller.MULTIWINDOW;
      expect(gestureNavigationObserver.unRegisterGestureNavigationEvent(scene) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_unRegisterGestureNavigationEvent_2', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      ((gestureNavigationObserver as object)['gestureNavigationEventCallBack'] as Map<SceneCaller, Function>).clear();
      ((gestureNavigationObserver as object)['gestureNavigationEventCallBack'] as Map<SceneCaller, Function>).set(
        SceneCaller.MULTIWINDOW, (state: GestureNavigationState, event: GestureNavigationEvent) => {});
      let scene = SceneCaller.MULTIWINDOW;
      expect(gestureNavigationObserver.unRegisterGestureNavigationEvent(scene) === undefined).assertTrue();
    })

    it('GestureNavigationEventObserverTest_unRegisterGestureNavigationEvent_3', TestType.USER | Size.SMALLTEST |
    Level.LEVEL0, (): void => {
      ((gestureNavigationObserver as object)['gestureNavigationEventCallBack'] as Map<SceneCaller, Function>).clear();
      ((gestureNavigationObserver as object)['gestureNavigationEventCallBack'] as Map<SceneCaller, Function>).set(
        SceneCaller.MULTIWINDOW, (state: GestureNavigationState, event: GestureNavigationEvent) => {});
      let scene = SceneCaller.MULTIWINDOW;
      gestureNavigationObserver.unRegisterGestureNavigationEvent(scene);
      expect(((gestureNavigationObserver as object)['gestureNavigationEventCallBack'] as Map<SceneCaller,
        Function>).size).assertEqual(0);
    })
  })
}