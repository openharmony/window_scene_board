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
  Level
} from '@ohos/hypium';
import { SwipeInwardController } from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/SwipeInwardEvent';

export default function SwipeInwardControllerTest() {
  describe('SwipeInwardControllerTest', () => {
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

    //SwipeInwardController::judgeIfDoBack
    it('SwipeInwardControllerTest_judgeIfDoBack', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController['gestureFrames'] = 1;
      expect(swipeInwardController.judgeIfDoBack()).assertFalse();
      swipeInwardController['gestureFrames'] = 0;
      expect(swipeInwardController.judgeIfDoBack()).assertTrue();
    })

    //SwipeInwardController::calculateAndJudge
    it('SwipeInwardControllerTest_calculateAndJudge_direction', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController['curPointerData'].timestamp = 1;
      swipeInwardController['prePointerData'].timestamp = 1;
      expect(swipeInwardController.calculateAndJudge() === undefined).assertTrue();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 99;
      swipeInwardController['curPointerData'].x = 0;
      swipeInwardController['prePointerData'].x = 1;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['curState'] === 99).assertTrue();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 0;
      swipeInwardController['curPointerData'].x = 0;
      swipeInwardController['prePointerData'].x = 1;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['curState'] === 1).assertTrue();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 0;
      swipeInwardController['curPointerData'].x = 1;
      swipeInwardController['prePointerData'].x = 0;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['curState'] === 2).assertTrue();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 0;
      swipeInwardController['curPointerData'].x = 1;
      swipeInwardController['prePointerData'].x = 1;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['curState'] === 0).assertTrue();
    })

    //滑动方向左右校验
    it('SwipeInwardControllerTest_calculateAndJudge_leftRight', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 2;
      swipeInwardController['curPointerData'].x = 0;
      swipeInwardController['prePointerData'].x = 1;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertFalse();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 2;
      swipeInwardController['curPointerData'].x = 1;
      swipeInwardController['prePointerData'].x = 0;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertTrue();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 1;
      swipeInwardController['curPointerData'].x = 1;
      swipeInwardController['prePointerData'].x = 0;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertFalse();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curState'] = 1;
      swipeInwardController['curPointerData'].x = 0;
      swipeInwardController['prePointerData'].x = 1;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertTrue();
    })

    // 滑动相对水平角度不能过大
    it('SwipeInwardControllerTest_calculateAndJudge_angel', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curPointerData'].y = 999;
      swipeInwardController['startPointerData'].y = 0;
      swipeInwardController['curPointerData'].x = 1;
      swipeInwardController['startPointerData'].x = 0;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertFalse();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curPointerData'].y = 1;
      swipeInwardController['startPointerData'].y = 0;
      swipeInwardController['curPointerData'].x = 20;
      swipeInwardController['startPointerData'].x = 0;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertTrue();
    })

    // 内滑距离不能过长
    it('SwipeInwardControllerTest_calculateAndJudge_distance', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curPointerData'].x = 999;
      swipeInwardController['startPointerData'].x = 0;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertTrue();

      swipeInwardController['curPointerData'].timestamp = 0;
      swipeInwardController['prePointerData'].timestamp = 1;
      swipeInwardController['curPointerData'].x = 1;
      swipeInwardController['startPointerData'].x = 0;
      swipeInwardController['isHandling'] = true;
      swipeInwardController.calculateAndJudge();
      expect(swipeInwardController['isHandling']).assertTrue();
    })

    // SwipeInwardController::getHandleState
    it('SwipeInwardControllerTest_getHandleState', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController['isHandling'] = true;
      expect(swipeInwardController.getHandleState() === true).assertTrue();
    })

    it('SwipeInwardControllerTest_getHandleState2', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController['isHandling'] = false;
      expect(swipeInwardController.getHandleState() === false).assertTrue();
    })

    // SwipeInwardController::beginHandle
    it('SwipeInwardControllerTest_beginHandle', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      class SwipeInwardEvent {
        x: number = -1;
        y: number = -1;
        timestamp: number = 0;
      };
      let pointDate: SwipeInwardEvent = {
        x : 1,
        y : 2,
        timestamp : 3
      };
      expect(swipeInwardController.beginHandle(pointDate.x, pointDate.y, pointDate.timestamp) === undefined)
        .assertTrue();
      expect(swipeInwardController['isHandling']).assertTrue();
      expect(swipeInwardController['startPointerData'].x === pointDate.x).assertTrue();
      expect(swipeInwardController['prePointerData'].x === pointDate.x).assertTrue();
      expect(swipeInwardController['curPointerData'].x === pointDate.x).assertTrue();
      expect(swipeInwardController['curState'] === 0).assertTrue();
    })

    // SwipeInwardController::endHandle
    it('SwipeInwardControllerTest_endHandle', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      expect(swipeInwardController.endHandle() === undefined).assertTrue();
      expect(swipeInwardController['isHandling'] === false).assertTrue();
    })
    it('SwipeInwardControllerTest_endHandle2', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      swipeInwardController.endHandle();
      expect(swipeInwardController['isHandling'] === false).assertTrue();
    })

    // SwipeInwardController::updatePointerData
    it('SwipeInwardControllerTest_updatePointerData', 0, (): void => {
      let swipeInwardController: SwipeInwardController = new SwipeInwardController();
      class SwipeInwardEvent {
        x: number = -1;
        y: number = -1;
        timestamp: number = 0;
      };
      let pointDate: SwipeInwardEvent = {
        x : 1,
        y : 2,
        timestamp : 3
      };
      let pointDate2: SwipeInwardEvent = {
        x : 11,
        y : 22,
        timestamp : 33
      };
      swipeInwardController['curPointerData'].set(pointDate2.x, pointDate2.y, pointDate2.timestamp);
      expect(swipeInwardController.updatePointerData(pointDate.x, pointDate.y, pointDate.timestamp) === undefined)
        .assertTrue();
      expect(swipeInwardController['prePointerData'].x === pointDate2.x).assertTrue();
      expect(swipeInwardController['prePointerData'].y === pointDate2.y).assertTrue();
      expect(swipeInwardController['prePointerData'].timestamp === pointDate2.timestamp).assertTrue();
      expect(swipeInwardController['curPointerData'].x === pointDate.x).assertTrue()
      expect(swipeInwardController['curPointerData'].y === pointDate.y).assertTrue();
      expect(swipeInwardController['curPointerData'].timestamp === pointDate.timestamp).assertTrue();
    })
    resetTest();
  })
}

function resetTest() {
  it('resetTest', Level.LEVEL0, (): void => {
    let swipeInwardController: SwipeInwardController = new SwipeInwardController();
    swipeInwardController['isHandling'] = true;
    swipeInwardController['gestureFrames'] = 120;
    swipeInwardController['curState'] = 1;
    swipeInwardController.reset();
    expect(swipeInwardController['isHandling']).assertFalse();
    expect(swipeInwardController['gestureFrames']).assertEqual(5);
    expect(swipeInwardController['curState']).assertEqual(0);
  });
}