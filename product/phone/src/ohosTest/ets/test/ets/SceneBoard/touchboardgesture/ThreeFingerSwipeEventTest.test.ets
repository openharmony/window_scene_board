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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { ThreeFingerSwipeEvent } from '@ohos/phonebase/src/main/ets/SceneBoard/touchboardgesture/ThreeFingerSwipeEvent';

export function ThreeFingerSwipeEventTest() {
  describe('ThreeFingerSwipeEventTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    });
    cloneTest();
    setTest();
    resetTest();
  });
}

function cloneTest() {
  it('cloneTest', Level.LEVEL0, (): void => {
    let testEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    let testEvent2: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    testEvent.set(1, 11, 2);
    testEvent2.clone(testEvent);
    expect(testEvent2.x).assertEqual(1);
    expect(testEvent2.y).assertEqual(11);
    expect(testEvent2.timestamp).assertEqual(2);
  });
}

function setTest() {
  it('setTest_01', Level.LEVEL0, (): void => {
    let testEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    testEvent.set(10, 20, 1);
    expect(testEvent.x).assertEqual(10);
    expect(testEvent.y).assertEqual(20);
    expect(testEvent.timestamp).assertEqual(1);
  });
  it('setTest_02', Level.LEVEL0, (): void => {
    let testEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    testEvent.set(0, 0, 2);
    expect(testEvent.x).assertEqual(0);
    expect(testEvent.y).assertEqual(0);
    expect(testEvent.timestamp).assertEqual(2);
  });
  it('setTest_03', Level.LEVEL0, (): void => {
    let testEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    testEvent.set(-10, -20, 3);
    expect(testEvent.x).assertEqual(-10);
    expect(testEvent.y).assertEqual(-20);
    expect(testEvent.timestamp).assertEqual(3);
  });
}

function resetTest() {
  it('resetTest_01', Level.LEVEL0, (): void => {
    let testEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    testEvent.set(10, 20, 1);
    expect(testEvent.x).assertEqual(10);
    expect(testEvent.y).assertEqual(20);
    expect(testEvent.timestamp).assertEqual(1);
    testEvent.reset()
    expect(testEvent.x).assertEqual(-1);
    expect(testEvent.y).assertEqual(-1);
    expect(testEvent.timestamp).assertEqual(0);
  });
  it('resetTest_02', Level.LEVEL0, (): void => {
    let testEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    testEvent.set(0, 0, 2);
    expect(testEvent.x).assertEqual(0);
    expect(testEvent.y).assertEqual(0);
    expect(testEvent.timestamp).assertEqual(2);
    testEvent.reset()
    expect(testEvent.x).assertEqual(-1);
    expect(testEvent.y).assertEqual(-1);
    expect(testEvent.timestamp).assertEqual(0);
  });
  it('resetTest_03', Level.LEVEL0, (): void => {
    let testEvent: ThreeFingerSwipeEvent = new ThreeFingerSwipeEvent();
    testEvent.set(-10, -20, 3);
    expect(testEvent.x).assertEqual(-10);
    expect(testEvent.y).assertEqual(-20);
    expect(testEvent.timestamp).assertEqual(3);
    testEvent.reset()
    expect(testEvent.x).assertEqual(-1);
    expect(testEvent.y).assertEqual(-1);
    expect(testEvent.timestamp).assertEqual(0);
  });
}
