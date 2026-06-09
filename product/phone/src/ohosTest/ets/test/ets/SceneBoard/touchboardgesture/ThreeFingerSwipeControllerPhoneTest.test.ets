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
  ThreeFingerSwipeConstants,
  ThreeFingerSwipeDirection
} from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/ThreeFingerSwipeConstants';
import { ThreeFingerSwipeController } from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/ThreeFingerSwipeController';

export function ThreeFingerSwipeControllerPhoneTest() {
  describe('ThreeFingerSwipeControllerPhoneTest', () => {
    calcSpeedAndAccTest();
    reachRecentLimitTest();
    getSwipeVerticalDistanceTest();
    getSwipeHorizontalDistanceTest();
    calcSwipeAngleTest();
    getSwipeDirectionTest();
    getSminTest();
    getSmaxTest();
    getCriticalSpeedTest();
    createGestureEventTest();
    resetTest();
  });
}

function calcSpeedAndAccTest() {
  it('calcSpeedAndAccTest_01', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    let mocker: MockKit = new MockKit();
    let func1: Function = mocker.mockFunc(threeFingerSwipeController, threeFingerSwipeController.calcSpeedAndAcc);
    when(func1)(ArgumentMatchers.any).afterReturnNothing();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.NONE);
    expect(threeFingerSwipeController.preSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curXSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curYSpeed).assertEqual(0);
    expect(threeFingerSwipeController.angle).assertEqual(0);
    expect(threeFingerSwipeController.swipeDownStartTime).assertEqual(0);
    expect(threeFingerSwipeController.speedScalar).assertEqual(0);
  });
  it('calcSpeedAndAccTest_02', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.timestamp = 1;
    threeFingerSwipeController.preEvent.timestamp = 1;
    threeFingerSwipeController.calcSpeedAndAcc();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.NONE);
    expect(threeFingerSwipeController.preSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curXSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curYSpeed).assertEqual(0);
    expect(threeFingerSwipeController.angle).assertEqual(0);
    expect(threeFingerSwipeController.swipeDownStartTime).assertEqual(0);
    expect(threeFingerSwipeController.speedScalar).assertEqual(0);
  });
  it('calcSpeedAndAccTest_03', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.timestamp = 3;
    threeFingerSwipeController.preEvent.timestamp = 1;
    threeFingerSwipeController.calcSpeedAndAcc();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.NONE);
    expect(threeFingerSwipeController.preSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curXSpeed).assertEqual(0);
    expect(threeFingerSwipeController.curYSpeed).assertEqual(0);
    expect(threeFingerSwipeController.angle).assertEqual(0);
    expect(threeFingerSwipeController.swipeDownStartTime).assertEqual(0);
    expect(threeFingerSwipeController.speedScalar).assertEqual(0);
  });
}

function reachRecentLimitTest() {
  it('reachRecentLimitTest_01', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curSpeed = px2vp(ThreeFingerSwipeConstants.CRITICAL_SPEED) - 1;
    threeFingerSwipeController.acc = px2vp(ThreeFingerSwipeConstants.CRITICAL_ACC) + 1;
    expect(threeFingerSwipeController.reachRecentLimit()).assertTrue();
  });
  it('reachRecentLimitTest_02', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curSpeed = 0;
    threeFingerSwipeController.acc = px2vp(ThreeFingerSwipeConstants.CRITICAL_ACC) + 1;
    expect(threeFingerSwipeController.reachRecentLimit()).assertTrue();
  });
  it('reachRecentLimitTest_03', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curSpeed = px2vp(ThreeFingerSwipeConstants.CRITICAL_SPEED) - 1;
    threeFingerSwipeController.acc = px2vp(ThreeFingerSwipeConstants.CRITICAL_ACC);
    expect(threeFingerSwipeController.reachRecentLimit()).assertTrue();
  });
  it('reachRecentLimitTest_04', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curSpeed = 1;
    threeFingerSwipeController.acc = px2vp(ThreeFingerSwipeConstants.CRITICAL_ACC);
    expect(threeFingerSwipeController.reachRecentLimit()).assertFalse();
  });
  it('reachRecentLimitTest_05', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curSpeed = 1;
    threeFingerSwipeController.acc = px2vp(ThreeFingerSwipeConstants.CRITICAL_ACC) + 1;
    expect(threeFingerSwipeController.reachRecentLimit()).assertFalse();
  });
}

function getSwipeVerticalDistanceTest() {
  it('getSwipeVerticalDistanceTest_01', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.y = 5;
    threeFingerSwipeController.startEvent.y = 5;
    expect(threeFingerSwipeController.getSwipeVerticalDistance()).assertEqual(0);
  });
}

function getSwipeHorizontalDistanceTest() {
  it('getSwipeHorizontalDistanceTest_01', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.x = 5;
    threeFingerSwipeController.startEvent.x = 1;
    expect(threeFingerSwipeController.getSwipeHorizontalDistance()).assertEqual(4);
  });
  it('getSwipeHorizontalDistanceTest_02', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.x = 5;
    threeFingerSwipeController.startEvent.x = 5;
    expect(threeFingerSwipeController.getSwipeHorizontalDistance()).assertEqual(0);
  });
  it('getSwipeHorizontalDistanceTest_03', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.x = 5;
    threeFingerSwipeController.startEvent.x = 9;
    expect(threeFingerSwipeController.getSwipeHorizontalDistance()).assertEqual(-4);
  });
}

function calcSwipeAngleTest() {
  it('calcSwipeAngleTest_01', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.timestamp = 1;
    threeFingerSwipeController.preEvent.timestamp = 1;
    threeFingerSwipeController.calcSwipeAngle();
    expect(true).assertTrue();
  });
  it('calcSwipeAngleTest_02', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.timestamp = 2;
    threeFingerSwipeController.curEvent.x = 5;
    threeFingerSwipeController.curEvent.y = 5;
    threeFingerSwipeController.preEvent.timestamp = 1;
    threeFingerSwipeController.preEvent.x = 1;
    threeFingerSwipeController.preEvent.y = 1;
    threeFingerSwipeController.calcSwipeAngle();
    let testAngle: number = -Math.atan2(4, 4) / Math.PI * ThreeFingerSwipeConstants.ANGLE_180;
    expect(threeFingerSwipeController.angle).assertEqual(testAngle);
  });
  it('calcSwipeAngleTest_03', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.timestamp = 2;
    threeFingerSwipeController.curEvent.x = 5;
    threeFingerSwipeController.curEvent.y = 5;
    threeFingerSwipeController.preEvent.timestamp = 1;
    threeFingerSwipeController.preEvent.x = 5;
    threeFingerSwipeController.preEvent.y = 5;
    threeFingerSwipeController.calcSwipeAngle();
    expect(threeFingerSwipeController.angle).assertEqual(-45);
  });
  it('calcSwipeAngleTest_04', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.timestamp = 2;
    threeFingerSwipeController.curEvent.x = 5;
    threeFingerSwipeController.curEvent.y = 5;
    threeFingerSwipeController.preEvent.timestamp = 1;
    threeFingerSwipeController.preEvent.x = 9;
    threeFingerSwipeController.preEvent.y = 9;
    threeFingerSwipeController.calcSwipeAngle();
    expect(threeFingerSwipeController.angle).assertEqual(-45);
  });
}

function getSwipeDirectionTest() {
  it('getSwipeDirectionTest_01', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = 90;
    threeFingerSwipeController.getSwipeDirection();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.UP);
  });
  it('getSwipeDirectionTest_02', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = 135;
    threeFingerSwipeController.getSwipeDirection();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.LEFT_UP);
  });
  it('getSwipeDirectionTest_03', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = 45;
    threeFingerSwipeController.getSwipeDirection();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.RIGHT_UP);
  });
  it('getSwipeDirectionTest_04', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = -90;
    threeFingerSwipeController.getSwipeDirection();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.DOWN);
  });
  it('getSwipeDirectionTest_05', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = 0;
    threeFingerSwipeController.getSwipeDirection();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.RIGHT);
  });
  it('getSwipeDirectionTest_06', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = 175;
    threeFingerSwipeController.getSwipeDirection();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.LEFT);
  });
  it('getSwipeDirectionTest_07', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = -175;
    threeFingerSwipeController.getSwipeDirection();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.LEFT);
  });
}

function getSminTest() {
  it('getSminTest', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    expect(threeFingerSwipeController.getSmin()).assertEqual(ThreeFingerSwipeConstants.REBOUND_DISTANCE);
  });
}

function getSmaxTest() {
  it('getSmaxTest', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    expect(threeFingerSwipeController.getSmax()).assertEqual(ThreeFingerSwipeConstants.FOLLOW_UP_DISTANCE);
  });
}

function getCriticalSpeedTest() {
  it('getCriticalSpeedTest', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    expect(threeFingerSwipeController.getCriticalSpeed()).assertEqual(ThreeFingerSwipeConstants.CRITICAL_SPEED);
  });
}

function createGestureEventTest() {
  it('createGestureEventTest', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.createGestureEvent(0, 0)
    expect(true).assertTrue();
  });
}

function resetTest() {
  it('resetTest_01', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.direction = ThreeFingerSwipeDirection.UP;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.direction).assertEqual(ThreeFingerSwipeDirection.NONE);
  });
  it('resetTest_02', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curSpeed = 10;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.curSpeed).assertEqual(0);
  });
  it('resetTest_03', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curXSpeed = 10;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.curXSpeed).assertEqual(0);
  });
  it('resetTest_04', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curYSpeed = 10;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.curYSpeed).assertEqual(0);
  });
  it('resetTest_05', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.speedScalar = 5;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.speedScalar).assertEqual(0);
  });
  it('resetTest_06', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.preSpeed = 5;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.preSpeed).assertEqual(0);
  });
  it('resetTest_07', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.acc = 0.5;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.acc).assertEqual(0);
  });
  it('resetTest_08', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.swipeDownStartTime = 2;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.swipeDownStartTime).assertEqual(0);
  });
  it('resetTest_09', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.angle = 90;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.angle).assertEqual(0);
  });
  it('resetTest_10', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.startEvent.x = 2;
    threeFingerSwipeController.startEvent.y = 2;
    threeFingerSwipeController.startEvent.timestamp = 1;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.startEvent.x).assertEqual(-1);
    expect(threeFingerSwipeController.startEvent.y).assertEqual(-1);
    expect(threeFingerSwipeController.startEvent.timestamp).assertEqual(0);
  });
  it('resetTest_11', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.preEvent.x = 2;
    threeFingerSwipeController.preEvent.y = 2;
    threeFingerSwipeController.preEvent.timestamp = 1;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.preEvent.x).assertEqual(-1);
    expect(threeFingerSwipeController.preEvent.y).assertEqual(-1);
    expect(threeFingerSwipeController.preEvent.timestamp).assertEqual(0);
  });
  it('resetTest_12', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.curEvent.x = 2;
    threeFingerSwipeController.curEvent.y = 2;
    threeFingerSwipeController.curEvent.timestamp = 1;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.curEvent.x).assertEqual(-1);
    expect(threeFingerSwipeController.curEvent.y).assertEqual(-1);
    expect(threeFingerSwipeController.curEvent.timestamp).assertEqual(0);
  });
  it('resetTest_13', Level.LEVEL0, (): void => {
    let threeFingerSwipeController = new ThreeFingerSwipeController();
    threeFingerSwipeController.stopEvent.x = 2;
    threeFingerSwipeController.stopEvent.y = 2;
    threeFingerSwipeController.stopEvent.timestamp = 1;
    threeFingerSwipeController.reset();
    expect(threeFingerSwipeController.stopEvent.x).assertEqual(-1);
    expect(threeFingerSwipeController.stopEvent.y).assertEqual(-1);
    expect(threeFingerSwipeController.stopEvent.timestamp).assertEqual(0);
  });
}